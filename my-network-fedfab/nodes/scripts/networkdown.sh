sudo docker stop $(sudo docker ps -a -q)
sudo docker rm -fv $(sudo docker ps -a -q)
docker image rm -f $(docker images -aq --filter reference='dev-peer*')

sudo rm -rf channel-artifacts/* crypto-config/ordererOrganizations crypto-config/peerOrganizations
sudo rm -rf crypto-config/fabric-ca/ordererOrg crypto-config/fabric-ca/org1 crypto-config/fabric-ca/org2 crypto-config/fabric-ca/tls-ca
sudo rm -rf system-genesis-block
sudo rm -rf mtemp/*

: ${CONTAINER_CLI:="docker"}

docker-compose -f compose/compose-ca.yaml -f compose/compose.yaml down --volumes --remove-orphans
docker volume prune
${CONTAINER_CLI} kill $(${CONTAINER_CLI} ps -q --filter name=ccaas) || true

# ${CONTAINER_CLI} volume rm docker_orderer.fedfab.com docker_peer0.org1.fedfab.com docker_peer0.org2.fedfab.com

# remove orderer block and other channel configuration transactions and certs
${CONTAINER_CLI} run --rm -v "$(pwd):/data" busybox sh -c 'cd /data && rm -rf system-genesis-block/*.block organizations/peerOrganizations organizations/ordererOrganizations'
## remove fabric ca artifacts
${CONTAINER_CLI} run --rm -v "$(pwd):/data" busybox sh -c 'cd /data && rm -rf organizations/fabric-ca/org1/msp organizations/fabric-ca/org1/tls-cert.pem organizations/fabric-ca/org1/ca-cert.pem organizations/fabric-ca/org1/IssuerPublicKey organizations/fabric-ca/org1/IssuerRevocationPublicKey organizations/fabric-ca/org1/fabric-ca-server.db'
${CONTAINER_CLI} run --rm -v "$(pwd):/data" busybox sh -c 'cd /data && rm -rf organizations/fabric-ca/org2/msp organizations/fabric-ca/org2/tls-cert.pem organizations/fabric-ca/org2/ca-cert.pem organizations/fabric-ca/org2/IssuerPublicKey organizations/fabric-ca/org2/IssuerRevocationPublicKey organizations/fabric-ca/org2/fabric-ca-server.db'
${CONTAINER_CLI} run --rm -v "$(pwd):/data" busybox sh -c 'cd /data && rm -rf organizations/fabric-ca/ordererOrg/msp organizations/fabric-ca/ordererOrg/tls-cert.pem organizations/fabric-ca/ordererOrg/ca-cert.pem organizations/fabric-ca/ordererOrg/IssuerPublicKey organizations/fabric-ca/ordererOrg/IssuerRevocationPublicKey organizations/fabric-ca/ordererOrg/fabric-ca-server.db'
# remove channel and script artifacts
${CONTAINER_CLI} run --rm -v "$(pwd):/data" busybox sh -c 'cd /data && rm -rf channel-artifacts log.txt *.tar.gz'