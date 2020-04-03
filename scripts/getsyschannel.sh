#!/bin/bash


# export FABRIC_CFG_PATH=${PWD}
VERBOSE=false

# system channel name defaults to "byfn-sys-channel"
# SYS_CHANNEL="byfn-sys-channel"
SYS_CHANNEL="syschannel"
# SYS_CHANNEL="mychannel"

. scripts/utils.sh

pwd
# Fetch the config for the channel, writing it to config.json
fetchChannelConfig ${SYS_CHANNEL} sysconfig.json





# Modify the configuration to append the new org
set -x
# jq -s '.[0] * {"channel_group":{"groups":{"Consortiums":{"groups":{"SampleConsortium":{"groups": {"Org3MSP":.[1]}}}}}}}' sysconfig.json ./channel-artifacts/org3.json > modified_sysconfig.json
  jq -s '.[0] * {"channel_group":{"groups":{"Consortiums":{"groups":{"SampleConsortium":{"groups": {"Org3MSP":.[1]}, "mod_policy": "/Channel/Orderer/Admins", "policies": {}, "values": {"ChannelCreationPolicy": {"mod_policy": "/Channel/Orderer/Admins","value": {"type": 3,"value": {"rule": "ANY","sub_policy": "Admins"}},"version": "0"}},"version": "0"}}}}}}' sysconfig.json ./channel-artifacts/org3.json > modified_sysconfig.json
set +x


echo "========= createConfigUpdate ===== "
# Compute a config update, based on the differences between config.json and modified_config.json, write it as a transaction to org3_update_sys_in_envelope.pb
createSysConfigUpdate ${SYS_CHANNEL} sysconfig.json modified_sysconfig.json org3_update_sys_in_envelope.pb

echo
echo "========= Config transaction to add org3 to network created ===== "
echo

# echo "Signing config transaction"
# echo
# signConfigtxAsPeerOrg 1 org3_update_sys_in_envelope.pb

echo
echo "========= Submitting transaction with envoriment setOrdererGlobals which also signs it ========= "
echo
setOrdererGlobals
echo $CORE_PEER_MSPCONFIGPATH
# setGlobals 0 2
set -x
peer channel update -f org3_update_sys_in_envelope.pb -c ${SYS_CHANNEL} -o orderer.example.com:7050 --tls --cafile ${ORDERER_CA}
set +x