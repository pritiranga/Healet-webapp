#!/bin/bash
IMAGE_NAME=pritidevops/healet:latest
docker pull $IMAGE_NAME
docker run -d -p 80:80 --name healet $IMAGE_NAME
