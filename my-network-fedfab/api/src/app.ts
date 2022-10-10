/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

import * as grpc from '@grpc/grpc-js';
import { connect, Contract, Identity, Signer, signers } from '@hyperledger/fabric-gateway';
import * as crypto from 'crypto';
import { promises as fs } from 'fs';
import * as path from 'path';
import { TextDecoder } from 'util';
import {Peer, envOrDefault} from './peer'


const channelName = envOrDefault('CHANNEL_NAME', 'channel2');
const chaincodeName = envOrDefault('CHAINCODE_NAME', 'fedfab');

const peer0Org1 = new Peer(0,1,8051);
const peer1Org1 = new Peer(1,1,8053);
const peer2Org1 = new Peer(2,1,8055);
const peer0Org2 = new Peer(0,2,9051);

var currentPeer:Peer;

const utf8Decoder = new TextDecoder();



export async function Run(currentPeer:Peer, f:(contract:Contract)=>Promise<string>): Promise<string> {
    await displayInputParameters(currentPeer);
    const client = await newGrpcConnection(currentPeer);
    const gateway = connect({
        client,
        identity: await newIdentity(currentPeer),
        signer: await newSigner(currentPeer),
        evaluateOptions: () => {
            return { deadline: Date.now() + 5000 }; // 5 seconds
        },
        endorseOptions: () => {
            return { deadline: Date.now() + 15000 }; // 15 seconds
        },
        submitOptions: () => {
            return { deadline: Date.now() + 5000 }; // 5 seconds
        },
        commitStatusOptions: () => {
            return { deadline: Date.now() + 60000 }; // 1 minute
        },
    });
    try {
        const network = gateway.getNetwork(channelName);
        const contract = network.getContract(chaincodeName);
        return await f(contract)
    } finally {
        gateway.close();
        client.close();
    }
}


async function newGrpcConnection(currentPeer:Peer): Promise<grpc.Client> {
    const tlsRootCert = await fs.readFile(currentPeer.tlsCertPath);
    const tlsCredentials = grpc.credentials.createSsl(tlsRootCert);
    return new grpc.Client(currentPeer.peerEndpoint, tlsCredentials, {
        'grpc.ssl_target_name_override': currentPeer.peerHostAlias,
    });
}

async function newIdentity(currentPeer:Peer): Promise<Identity> {
    const credentials = await fs.readFile(currentPeer.certPath);
    const mspId = currentPeer.mspId
    return { mspId, credentials };
}

async function newSigner(currentPeer:Peer): Promise<Signer> {
    const files = await fs.readdir(currentPeer.keyDirectoryPath);
    const keyPath = path.resolve(currentPeer.keyDirectoryPath, files[0]);
    const privateKeyPem = await fs.readFile(keyPath);
    const privateKey = crypto.createPrivateKey(privateKeyPem);
    return signers.newPrivateKeySigner(privateKey);
}

async function get(funktion:string, contract: Contract, ...args: string[]): Promise<string> {
    console.log(`\n--> Evaluate Transaction: ${funktion}, function returns all the current assets on the ledger`);
    const resultBytes = await contract.evaluate(funktion, { arguments: args });    
    const resultJson = utf8Decoder.decode(resultBytes);
    console.log('*** Result:', resultJson);
    return resultJson;
}

async function set(funktion:string, contract: Contract, ...args: string[]): Promise<string> {
    console.log(`\n--> Evaluate Transaction: ${funktion}, function returns all the current assets on the ledger`);
    const resultBytes = await contract.submit(funktion, { arguments: args });
    const resultJson = utf8Decoder.decode(resultBytes);
    console.log('*** Result:', resultJson);
    return resultJson;
}



async function displayInputParameters(currentPeer:Peer): Promise<void> {
    console.log(`channelName:       ${channelName}`);
    console.log(`chaincodeName:     ${chaincodeName}`);
    console.log(`mspId:             ${currentPeer.mspId}`);
    console.log(`cryptoPath:        ${currentPeer.cryptoPath}`);
    console.log(`keyDirectoryPath:  ${currentPeer.keyDirectoryPath}`);
    console.log(`certPath:          ${currentPeer.certPath}`);
    console.log(`tlsCertPath:       ${currentPeer.tlsCertPath}`);
    console.log(`peerEndpoint:      ${currentPeer.peerEndpoint}`);
    console.log(`peerHostAlias:     ${currentPeer.peerHostAlias}`);
}

// 是否线程安全？？？
const peerTable = [[peer0Org1,peer1Org1,peer2Org1],[peer0Org2]]

function getPeer(peer:string, org:string):Peer {
    const currentPeer = peerTable[Number.parseInt(org)-1][Number.parseInt(peer)]
    console.log("*** current Peer: " + currentPeer.toString());
    return currentPeer
}

export async function AddModel(peer:string, org:string, rid:string, cid:string, model:string):Promise<string> {
    currentPeer = getPeer(peer, org)
    return await Run(currentPeer, contract => {return set('AddModel', contract, rid, cid, model)})
}

export async function QueryWetherAllReceived(peer:string, org:string, rid:string):Promise<string> {
    currentPeer = getPeer(peer, org)
    return await Run(currentPeer, contract => {return get('QueryWetherAllReceived', contract, rid)})
}

export async function QueryAllReceived(peer:string, org:string, rid:string):Promise<string> {
    currentPeer = getPeer(peer, org)
    return await Run(currentPeer, contract => {return get('QueryAllReceived', contract, rid)})
}

export async function UpdateGlobal(peer:string, org:string, sid:string, model_weight:string):Promise<string> {
    currentPeer = getPeer(peer, org)
    return await Run(currentPeer, contract => {return set('UpdateGlobal', contract, sid, model_weight)})
}

export async function NewRound(peer:string, org:string, rid:string, client_num:string):Promise<string> {
    currentPeer = getPeer(peer, org)
    return await Run(currentPeer, contract => {return set('NewRound', contract, rid, client_num)})
}
