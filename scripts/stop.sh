#!/bin/bash
CONTAINER_NAME=healet
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true