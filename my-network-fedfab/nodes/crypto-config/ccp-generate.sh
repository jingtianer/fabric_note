#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        crypto-config/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        crypto-config/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=1
P0PORT=8051
CAPORT=8050
PEERPEM=crypto-config/peerOrganizations/org1.fedfab.com/tlsca/tlsca.org1.fedfab.com-cert.pem
CAPEM=crypto-config/peerOrganizations/org1.fedfab.com/ca/ca.org1.fedfab.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > crypto-config/peerOrganizations/org1.fedfab.com/connection-org1.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > crypto-config/peerOrganizations/org1.fedfab.com/connection-org1.yaml

ORG=2
P0PORT=9051
CAPORT=9050
PEERPEM=crypto-config/peerOrganizations/org2.fedfab.com/tlsca/tlsca.org2.fedfab.com-cert.pem
CAPEM=crypto-config/peerOrganizations/org2.fedfab.com/ca/ca.org2.fedfab.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > crypto-config/peerOrganizations/org2.fedfab.com/connection-org2.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > crypto-config/peerOrganizations/org2.fedfab.com/connection-org2.yaml
