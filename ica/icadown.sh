#!/bin/bash

export IMAGE_TAG=latest

docker-compose -f docker-compose-ica.yaml  -f docker-compose-tlsica.yaml down
