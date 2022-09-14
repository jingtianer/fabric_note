
# 创建ca节点
- 为了使用sdk的应用对链码进行调用，需要通过ca节点获得证书（创建ca节点其实应该在创建peer节点之前就进行）
- [参考教程](https://juejin.cn/post/7079334814196695054)

第一次启动CA时，它查找fabric-ca-server-config.yaml文件，其中包含CA配置参数。
## 编写创建ca的docker-compose文件
```yaml
version: '3.7'

networks:
  fed_fab:
    name: fabric_fedml

services:
  ca_org1:
    image: hyperledger/fabric-ca:latest
    labels:
      service: hyperledger-fabric
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME=ca-org1
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_PORT=8050
      - FABRIC_CA_SERVER_OPERATIONS_LISTENADDRESS=0.0.0.0:18050
    ports:
      - "8050:8050"
      - "18050:18050"
    command: sh -c 'fabric-ca-server start -b admin:adminpw -d'
    volumes:
      - ../crypto-config/fabric-ca/org1:/etc/hyperledger/fabric-ca-server
    container_name: ca_org1
    networks:
      - fed_fab

  ca_org2:
    image: hyperledger/fabric-ca:latest
    labels:
      service: hyperledger-fabric
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME=ca-org2
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_PORT=9050
      - FABRIC_CA_SERVER_OPERATIONS_LISTENADDRESS=0.0.0.0:19050
    ports:
      - "9050:9050"
      - "19050:19050"
    command: sh -c 'fabric-ca-server start -b admin:adminpw -d'
    volumes:
      - ../crypto-config/fabric-ca/org2:/etc/hyperledger/fabric-ca-server
    container_name: ca_org2
    networks:
      - fed_fab

  ca_orderer:
    image: hyperledger/fabric-ca:latest
    labels:
      service: hyperledger-fabric
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME=ca-orderer
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_PORT=7051
      - FABRIC_CA_SERVER_OPERATIONS_LISTENADDRESS=0.0.0.0:17051
    ports:
      - "7051:7051"
      - "17051:17051"
    command: sh -c 'fabric-ca-server start -b admin:adminpw -d'
    volumes:
      - ../crypto-config/fabric-ca/ordererOrg:/etc/hyperledger/fabric-ca-server
    container_name: ca_orderer
    networks:
      - fed_fab
  
  ca_tls:
    image: hyperledger/fabric-ca:latest
    labels:
      service: hyperledger-fabric
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME=ca-orderer
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_PORT=7054
      - FABRIC_CA_SERVER_OPERATIONS_LISTENADDRESS=0.0.0.0:17054
    ports:
      - "7054:7054"
      - "17054:17054"
    command: sh -c 'fabric-ca-server start -b admin:adminpw -d'
    volumes:
      - ../crypto-config/fabric-ca/tls-ca:/etc/hyperledger/fabric-ca-server
    container_name: ca_tls
    networks:
      - fed_fab
```
- 启动ca节点
```sh
docker-compose -f compose/compose-ca.yaml up -d
```
> 可以看到它生成了容器，并在`../crypto-config`文件夹下生成了各个节点的证书等文件

## 修改test-network中的registerEnroll.sh并执行
```sh
. ./crypto-config/fabric-ca/registerEnroll.sh
createOrg1
createOrg2
createOrderer
```

# 其他步骤
创建好ca后，就可以部署网络节点，chaincode，并使用api调用链码，参考test-network中的操作，将network删除干净，将生成网络和销毁网络整理成脚本`/scripts/networkup.sh`和`/scripts/networkdown.sh`