#!/bin/bash


# export FABRIC_CFG_PATH=${PWD}
VERBOSE=false

# system channel name defaults to "byfn-sys-channel"
# SYS_CHANNEL="byfn-sys-channel"
SYS_CHANNEL="mychannel"

. scripts/utils.sh

pwd
# Fetch the config for the channel, writing it to config.json
# fetchChannelConfig ${SYS_CHANNEL} sysconfig.json
fetchChannelConfig ${SYS_CHANNEL} mychannel.json
# fetchChannelConfig ${SYS_CHANNEL} configaddedorg3.json
