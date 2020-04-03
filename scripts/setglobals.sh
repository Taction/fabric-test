#!/bin/bash

. scripts/utils.sh

echo "========= Submitting transaction from a different peer (peer$1.org$2) which also signs it ========= "
setGlobals $1 $1