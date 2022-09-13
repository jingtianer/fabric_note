cryptogen generate --config=crypto-config.yaml
SOCK="${DOCKER_HOST:-/var/run/docker.sock}"
export DOCKER_SOCK="${SOCK##unix://}"
# docker-compose -f compose/compose-ca.yaml up -d --remove-orphans 
# sudo chown -R tt crypto-config/*

export FABRIC_CFG_PATH=${PWD}/configtx
mkdir channel-artifacts
configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel2.tx -channelID channel2
# while :
# do
#     if [ ! -f "crypto-config/fabric-ca/org1/tls-cert.pem" ]; then
#     sleep 1
#     else
#     break
#     fi
# done
# . ./crypto-config/fabric-ca/registerEnroll.sh
# createOrg1
# createOrg2
# createOrderer
# ./crypto-config/ccp-generate.sh
docker-compose -f compose/compose.yaml up -d


# export FABRIC_CFG_PATH=${PWD}/configtx
# configtxgen -profile TwoOrgsApplicationGenesis -outputBlock ./channel-artifacts/channel2.block -channelID channel2

# osnadmin channel join --channelID channel2 --config-block ./channel-artifacts/channel2.block -o localhost:7050 --ca-file crypto-config/ordererOrganizations/fedfab.com/msp/tlscacerts/tlsca.fedfab.com-cert.pem --client-cert crypto-config/ordererOrganizations/fedfab.com/orderers/orderer.fedfab.com/tls/server.crt --client-key crypto-config/ordererOrganizations/fedfab.com/orderers/orderer.fedfab.com/tls/server.key

# FABRIC_CFG_PATH=./configtx/
# ORG=1
# setGlobals $ORG
# peer channel join -b ./channel-artifacts/channel2.block
# ORG=2
# setGlobals $ORG
# peer channel join -b ./channel-artifacts/channel2.block

docker ps -a