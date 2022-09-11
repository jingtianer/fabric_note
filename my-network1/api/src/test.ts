import * as grpc from '@grpc/grpc-js';
import * as crypto from 'crypto';
import { connect, Identity, signers } from '@hyperledger/fabric-gateway';
import { promises as fs } from 'fs';
import { TextDecoder } from 'util';
const path = require('path')
const utf8Decoder = new TextDecoder();

async function main(): Promise<void> {
    const credentials = await fs.readFile('../../nodes/crypto-config/peerOrganizations/org1.fedfab.com/peers/peer0.org1.fedfab.com/msp/tlscacerts/tlsca.org1.fedfab.com-cert.pem');
    const identity: Identity = { mspId: 'org1', credentials };

    const privateKeyPem = await fs.readFile('../../nodes/crypto-config/peerOrganizations/org1.fedfab.com/peers/peer0.org1.fedfab.com/msp/keystore/priv_sk');
    const privateKey = crypto.createPrivateKey(privateKeyPem);
    const signer = signers.newPrivateKeySigner(privateKey);

    const client = new grpc.Client('peer0.org1.fedfab.com:9444', grpc.credentials.createInsecure());

    const gateway = connect({ identity, signer, client });
    try {
        const network = gateway.getNetwork('channel2');
        const contract = network.getContract('ttsacc');

        const putResult = await contract.submitTransaction('put', 'a', 'dd');
        console.log('Put result:', utf8Decoder.decode(putResult));

        const getResult = await contract.evaluateTransaction('get', 'a');
        console.log('Get result:', utf8Decoder.decode(getResult));
    } finally {
        gateway.close();
        client.close()
    }
}

main().catch(console.error);