import * as path from 'path';
export function envOrDefault(key: string, defaultValue: string): string {
    return process.env[key] || defaultValue;
}
export class Peer {
    map:Map<string, string> = new Map();
    mspId = ''
    cryptoPath = ''
    keyDirectoryPath = ''
    certPath = ''
    tlsCertPath = ''
    peerEndpoint = ''
    peerHostAlias = ''
    Org = ''
    peer = ''
    constructor(peerN:number, orgN:number, port:number) {
        const org = "org" + orgN.toPrecision(1)
        const Org = "Org" + orgN.toPrecision(1)
        const peer = "peer" + peerN.toPrecision(1)
        const User = "User" + (peerN+1).toPrecision(1)
        const crypto_path = path.resolve(__dirname, '..', '..','nodes', 'crypto-config', 'peerOrganizations', org + '.fedfab.com')
        // this.map.set('CRYPTO_PATH', crypto_path)
        // this.map.set('KEY_DIRECTORY_PATH', path.resolve(crypto_path, 'users', User + '@' + org + '.fedfab.com', 'msp', 'keystore'))
        // this.map.set('CERT_PATH', path.resolve(crypto_path, 'users',  User + '@' + org + '.fedfab.com', 'msp', 'signcerts',  User + '@' + org + '.fedfab.com-cert.pem'))
        // this.map.set('TLS_CERT_PATH', path.resolve(crypto_path, 'peers', peer + '.' + org + '.fedfab.com', 'tls', 'ca.crt'))
        // this.map.set('PEER_ENDPOINT', 'localhost:' + port.toPrecision(4))
        // this.map.set('PEER_HOST_ALIAS', peer + '.' + org + '.fedfab.com')
        // this.map.set('MSP_ID', Org + "MSP")

        
        this.cryptoPath = envOrDefault('CRYPTO_PATH', crypto_path);
        this.keyDirectoryPath = envOrDefault('KEY_DIRECTORY_PATH', path.resolve(crypto_path, 'users', User + '@' + org + '.fedfab.com', 'msp', 'keystore'));
        this.certPath = envOrDefault('CERT_PATH', path.resolve(crypto_path, 'users',  User + '@' + org + '.fedfab.com', 'msp', 'signcerts',  User + '@' + org + '.fedfab.com-cert.pem'));
        this.tlsCertPath = envOrDefault('TLS_CERT_PATH', path.resolve(crypto_path, 'peers', peer + '.' + org + '.fedfab.com', 'tls', 'ca.crt'));
        this.peerEndpoint = envOrDefault('PEER_ENDPOINT', 'localhost:' + port.toPrecision(4));
        this.peerHostAlias = envOrDefault('PEER_HOST_ALIAS', peer + '.' + org + '.fedfab.com');
        this.mspId = envOrDefault('MSP_ID', Org + "MSP");

        this.peer = peer
        this.Org = Org
    };

    /**
     * get
     */
    public get(key:string):string {
        if (this.map.has(key)) {
            return this.map.get(key)!!
        } else {
            throw Error("*** No such key: " + key)
        }
    }

    /**
     * toString
     */
    public toString():string {
        return this.peer + "." + this.Org
    }

}
