#!/bin/bash

./byfn.sh generate -o etcdraft

./testconfigtxgen.sh


./byfn.sh up -o etcdraft