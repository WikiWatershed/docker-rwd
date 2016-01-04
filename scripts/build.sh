#!/bin/bash

set -e

echo "Build the RWD Docker container."

set -x

docker build -t docker-rwd .
