#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

# This script is designed to be run in the cli container as the third
# step of the EYFN tutorial. It installs the chaincode as version 2.0
# on peer0.org1 and peer0.org2, and uprage the chaincode on the
# channel to version 2.0, thus completing the addition of org3 to the
# network previously setup in the BYFN tutorial.
# 直接替换版本和channel名字就可以测试执行 docker exec cli scripts/testchaincode.sh

echo
echo "========= Finish adding Org3 to your first network ========= "
echo
CHANNEL_NAME="$1"
DELAY="$2"
LANGUAGE="$3"
TIMEOUT="$4"
VERBOSE="$5"
: ${CHANNEL_NAME:="mychannel2"}
: ${DELAY:="3"}
: ${LANGUAGE:="golang"}
: ${TIMEOUT:="10"}
: ${VERBOSE:="false"}
LANGUAGE=`echo "$LANGUAGE" | tr [:upper:] [:lower:]`
COUNTER=1
MAX_RETRY=5

CC_SRC_PATH="github.com/chaincode/chaincode_example02/go/"
if [ "$LANGUAGE" = "node" ]; then
	CC_SRC_PATH="/opt/gopath/src/github.com/chaincode/chaincode_example02/node/"
fi

# import utils
. scripts/utils.sh

upgradeChaincode() {
  PEER=$1
  ORG=$2
  setGlobals $PEER $ORG

  set -x
  peer chaincode upgrade -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n mycc -v 7.0 -c '{"Args":["init","a","90","b","210"]}' -P "OutOf(2,'Org1MSP.member,'Org1MSP.member')"
#   peer chaincode upgrade -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n mycc -v 7.0 -c '{"Args":["init","a","90","b","210"]}' -P "OutOf(2,'Org1MSP.member','Org2MSP.member')"
  res=$?
  set +x
  cat log.txt
  verifyResult $res "Chaincode upgrade on peer${PEER}.org${ORG} has failed"
  echo "===================== Chaincode is upgraded on peer${PEER}.org${ORG} on channel '$CHANNEL_NAME' ===================== "
  echo
}

chaincodeQuery() {
  PEER=$1
  ORG=$2
  setGlobals $PEER $ORG
  EXPECTED_RESULT=$3
  echo "===================== Querying on peer${PEER}.org${ORG} on channel '$CHANNEL_NAME'... ===================== "
  local rc=1
  local starttime=$(date +%s)

  # continue to poll
  # we either get a successful response, or reach TIMEOUT
  while
    test "$(($(date +%s) - starttime))" -lt "$TIMEOUT" -a $rc -ne 0
  do
    sleep $DELAY
    echo "Attempting to Query peer${PEER}.org${ORG} ...$(($(date +%s) - starttime)) secs"
    set -x
    peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}' >&log.txt
    res=$?
    cat log.txt
    set +x
    cat log.txt
    test $res -eq 0 && VALUE=$(cat log.txt | awk '/Query Result/ {print $NF}')
    test "$VALUE" = "$EXPECTED_RESULT" && let rc=0
    # removed the string "Query Result" from peer chaincode query command
    # result. as a result, have to support both options until the change
    # is merged.
    test $rc -ne 0 && VALUE=$(cat log.txt | egrep '^[0-9]+$')
    test "$VALUE" = "$EXPECTED_RESULT" && let rc=0
  done
  echo
  cat log.txt
  if test $rc -eq 0; then
    echo "===================== Query successful on peer${PEER}.org${ORG} on channel '$CHANNEL_NAME' ===================== "
  else
    echo "!!!!!!!!!!!!!!! Query result on peer${PEER}.org${ORG} is INVALID !!!!!!!!!!!!!!!!"
    echo "================== ERROR !!! FAILED to execute End-2-End Scenario =================="
    echo
    exit 1
  fi
}


echo "===================== Installing chaincode 2.0 on peer0.org1 ===================== "
installChaincode 0 1 7.0
echo "===================== Installing chaincode 2.0 on peer0.org2 ===================== "
installChaincode 0 2 7.0

echo "===================== Installing chaincode 2.0 on peer1.org1 ===================== "
installChaincode 1 1 7.0
echo "===================== Installing chaincode 2.0 on peer1.org2 ===================== "
installChaincode 1 2 7.0

echo "===================== Upgrading chaincode on peer0.org1 ===================== "
upgradeChaincode 0 1

# Invoke chaincode on peer0.org1 and peer0.org2
	echo "Sending invoke transaction on peer0.org1 peer1.org1..."
	chaincodeInvoke 0 1 1 1
	# chaincodeInvoke 0 1 0 2
	# chaincodeInvoke 0 1 


	# Query on chaincode on peer1.org2, check if the result is 90
	echo "Querying chaincode on peer0.org1..."
	chaincodeQuery 0 1 80

echo
echo "========= Finished adding Org3 to your first network! ========= "
echo

exit 0
