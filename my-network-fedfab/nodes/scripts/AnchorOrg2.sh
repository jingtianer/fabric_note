peer channel fetch config channel-artifacts/config_block.pb -o orderer.fedfab.com:7050 -c channel2 --tls --cafile ${PWD}/crypto/ordererOrganizations/fedfab.com/orderers/orderer.fedfab.com/msp/tlscacerts/tlsca.fedfab.com-cert.pem
cd channel-artifacts
configtxlator proto_decode --input config_block.pb --type common.Block --output config_block.json
jq .data.data[0].payload.data.config config_block.json > config.json
cp config.json config_copy.json
jq '.channel_group.groups.Application.groups.Org2MSP.values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "peer0.org2.fedfab.com","port": 9051}]},"version": "0"}}' config_copy.json > modified_config.json
configtxlator proto_encode --input config.json --type common.Config --output config.pb
configtxlator proto_encode --input modified_config.json --type common.Config --output modified_config.pb
configtxlator compute_update --channel_id channel2 --original config.pb --updated modified_config.pb --output config_update.pb
configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate --output config_update.json
echo '{"payload":{"header":{"channel_header":{"channel_id":"channel2", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . > config_update_in_envelope.json
configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope --output config_update_in_envelope.pb
cd ..
peer channel update -f channel-artifacts/config_update_in_envelope.pb -c channel2 -o orderer.fedfab.com:7050 --tls --cafile ${PWD}/crypto/ordererOrganizations/fedfab.com/orderers/orderer.fedfab.com/msp/tlscacerts/tlsca.fedfab.com-cert.pem
peer channel getinfo -c channel2