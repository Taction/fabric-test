#在已有单组织加密物料的前提下。本脚本生成genesis.block、channel.tx、Org1MSPanchors.tx
export PATH="$PATH:/Users/zc/go/src/github.com/hyperledger/fabric/.build/bin"

#export FABRIC_CFG_PATH=/Users/zc/Desktop/companyWorkspace/blockchain/hyperledger/test-project-dir/hyperledger-node-service-zhongtai/artifacts/channel

export FABRIC_CFG_PATH=${PWD}
echo $FABRIC_CFG_PATH

(

configtxgen -profile SampleMultiNodeEtcdRaft -channelID syschannel -outputBlock ./channel-artifacts/genesis.block

rm -r ./json
mkdir json

touch ./json/genesis.json && configtxgen -inspectBlock ./channel-artifacts/genesis.block > ./json/genesis.json
 
export CHANNEL_NAME=mychannel  && configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

touch ./json/mychannel.json && configtxgen -inspectChannelCreateTx ./channel-artifacts/channel.tx > ./json/mychannel.json

configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
)

export CHANNEL_NAME=mychannel2  && configtxgen -profile TwoOrgsChannel2 -outputCreateChannelTx ./channel-artifacts/channel2.tx -channelID $CHANNEL_NAME

touch ./json/mychannel2.json && configtxgen -inspectChannelCreateTx ./channel-artifacts/channel2.tx > ./json/mychannel2.json

configtxgen -profile TwoOrgsChannel2 -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors2.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
configtxgen -profile TwoOrgsChannel2 -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors2.tx -channelID $CHANNEL_NAME -asOrg Org2MSP