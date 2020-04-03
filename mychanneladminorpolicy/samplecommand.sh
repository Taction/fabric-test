#!/bin/bash

configtxlator proto_encode --input mychanneladminorpolicy/channel.json --type common.Envelope > mychanneladminorpolicy/channel.tx

configtxgen -inspectChannelCreateTx ./mychanneladminorpolicy/channel.tx > mychanneladminorpolicy/mychannelmodifyed.json