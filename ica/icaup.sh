#!/bin/bash

export IMAGE_TAG=latest

cp ../crypto-config/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem ica/ca.org1.pem
cp ../crypto-config/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem ica/tlsca.org1.pem

docker-compose -f docker-compose-ica.yaml -f docker-compose-tlsica.yaml up -d