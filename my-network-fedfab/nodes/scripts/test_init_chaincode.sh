peer chaincode invoke -o orderer.fedfab.com:7050 --isInit --ordererTLSHostnameOverride orderer.fedfab.com --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fedfab.com/orderers/orderer.fedfab.com/msp/tlscacerts/tlsca.fedfab.com-cert.pem --channelID channel2 --name fedfab --tls true \
    --peerAddresses peer0.org1.fedfab.com:8051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer0.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer1.org1.fedfab.com:8053 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer1.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer2.org1.fedfab.com:8055 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer2.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer0.org2.fedfab.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.fedfab.com/peers/peer0.org2.fedfab.com/tls/ca.crt \
    -c '{"Args":["initialize", "Initializing ChainCode"]}'

peer chaincode invoke -o orderer.fedfab.com:7050 --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fedfab.com/orderers/orderer.fedfab.com/msp/tlscacerts/tlsca.fedfab.com-cert.pem --channelID channel2 --name fedfab --tls true \
    --peerAddresses peer0.org1.fedfab.com:8051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer0.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer1.org1.fedfab.com:8053 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer1.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer2.org1.fedfab.com:8055 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer2.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer0.org2.fedfab.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.fedfab.com/peers/peer0.org2.fedfab.com/tls/ca.crt \
    -c '{"Args":["NewRound", "r1", "2"]}'

peer chaincode invoke -o orderer.fedfab.com:7050 --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fedfab.com/orderers/orderer.fedfab.com/msp/tlscacerts/tlsca.fedfab.com-cert.pem --channelID channel2 --name fedfab --tls true \
    --peerAddresses peer0.org1.fedfab.com:8051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer0.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer1.org1.fedfab.com:8053 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer1.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer2.org1.fedfab.com:8055 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer2.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer0.org2.fedfab.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.fedfab.com/peers/peer0.org2.fedfab.com/tls/ca.crt \
    -c '{"Args":["AddModel", "r1", "c1", "{\"a\":[1,2,3], \"b\":[2,3,4], \"c\":[3,4,5]}"]}'

peer chaincode invoke -o orderer.fedfab.com:7050 --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fedfab.com/orderers/orderer.fedfab.com/msp/tlscacerts/tlsca.fedfab.com-cert.pem --channelID channel2 --name fedfab --tls true \
    --peerAddresses peer0.org1.fedfab.com:8051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer0.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer1.org1.fedfab.com:8053 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer1.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer2.org1.fedfab.com:8055 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer2.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer0.org2.fedfab.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.fedfab.com/peers/peer0.org2.fedfab.com/tls/ca.crt \
    -c '{"Args":["QueryWetherAllReceived", "r1"]}'

peer chaincode invoke -o orderer.fedfab.com:7050 --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fedfab.com/orderers/orderer.fedfab.com/msp/tlscacerts/tlsca.fedfab.com-cert.pem --channelID channel2 --name fedfab --tls true \
    --peerAddresses peer0.org1.fedfab.com:8051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer0.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer1.org1.fedfab.com:8053 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer1.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer2.org1.fedfab.com:8055 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer2.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer0.org2.fedfab.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.fedfab.com/peers/peer0.org2.fedfab.com/tls/ca.crt \
    -c '{"Args":["AddModel", "r1", "c2", "{\"a\":[1,2,3], \"b\":[2,3,4], \"c\":[3,4,5]}"]}'

peer chaincode invoke -o orderer.fedfab.com:7050 --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fedfab.com/orderers/orderer.fedfab.com/msp/tlscacerts/tlsca.fedfab.com-cert.pem --channelID channel2 --name fedfab --tls true \
    --peerAddresses peer0.org1.fedfab.com:8051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer0.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer1.org1.fedfab.com:8053 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer1.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer2.org1.fedfab.com:8055 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer2.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer0.org2.fedfab.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.fedfab.com/peers/peer0.org2.fedfab.com/tls/ca.crt \
    -c '{"Args":["QueryWetherAllReceived", "r1"]}'

peer chaincode invoke -o orderer.fedfab.com:7050 --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fedfab.com/orderers/orderer.fedfab.com/msp/tlscacerts/tlsca.fedfab.com-cert.pem --channelID channel2 --name fedfab --tls true \
    --peerAddresses peer0.org1.fedfab.com:8051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer0.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer1.org1.fedfab.com:8053 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer1.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer2.org1.fedfab.com:8055 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer2.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer0.org2.fedfab.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.fedfab.com/peers/peer0.org2.fedfab.com/tls/ca.crt \
    -c '{"Args":["QueryAllReceived", "r1"]}'

peer chaincode invoke -o orderer.fedfab.com:7050 --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fedfab.com/orderers/orderer.fedfab.com/msp/tlscacerts/tlsca.fedfab.com-cert.pem --channelID channel2 --name fedfab --tls true \
    --peerAddresses peer0.org1.fedfab.com:8051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer0.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer1.org1.fedfab.com:8053 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer1.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer2.org1.fedfab.com:8055 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fedfab.com/peers/peer2.org1.fedfab.com/tls/ca.crt \
    --peerAddresses peer0.org2.fedfab.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.fedfab.com/peers/peer0.org2.fedfab.com/tls/ca.crt \
    -c '{"Args":["UpdateGlobal", "s1", "{\"a\":[1,2,3], \"b\":[2,3,4], \"c\":[3,4,5]}"]}'
