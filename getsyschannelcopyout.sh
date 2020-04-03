#!/bin/bash

export PATH="$PATH:/Users/zc/go/src/github.com/hyperledger/fabric/.build/bin"

docker exec cli scripts/getsyschannel.sh

if [ ! -d syschannel ]; then
mkdir syschannel
fi

docker cp cli:/opt/gopath/src/github.com/hyperledger/fabric/peer/sysconfig.json ./syschannel/
docker cp cli:/opt/gopath/src/github.com/hyperledger/fabric/peer/modified_sysconfig.json ./syschannel/
docker cp cli:/opt/gopath/src/github.com/hyperledger/fabric/peer/sysconfig_update.json ./syschannel/
docker cp cli:/opt/gopath/src/github.com/hyperledger/fabric/peer/config_update_sys_in_envelope.json ./syschannel/
