#!/bin/bash

export PATH="$PATH:/Users/zc/go/src/github.com/hyperledger/fabric/.build/bin"

docker cp scripts/syschannelconfigjson.sh cli-example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer/scripts/syschannelconfigjson.sh
docker cp scripts/utilso0.sh cli-example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer/scripts/utils.sh

docker exec cli scripts/syschannelconfigjson.sh
# docker exec cli-example.com scripts/syschannelconfigjson.sh

if [ ! -d mychannel ]; then
mkdir mychannel
fi

docker cp cli-example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer/sysconfig.json ./mychannel/
docker cp cli-example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer/config_block.pb ./mychannel/
# docker cp cli:/opt/gopath/src/github.com/hyperledger/fabric/peer/modified_sysconfig.json ./syschannel/
# docker cp cli:/opt/gopath/src/github.com/hyperledger/fabric/peer/sysconfig_update.json ./syschannel/
# docker cp cli:/opt/gopath/src/github.com/hyperledger/fabric/peer/config_update_sys_in_envelope.json ./syschannel/
