#!/bin/bash

set -e

ARGS=$*

echo "Run the RWD Docker container."

if [ -z "$RWD_REPO" ]; then
    echo "Environment variable RWD_REPO not defined."
    exit 1
fi

if [ -z "$RWD_DATA" ]; then
    echo "Environment variable RWD_DATA not defined."
    exit 1
fi

set -x

docker run \
-v $RWD_DATA:/opt/rwd-data \
-v $RWD_REPO:/opt/rwd \
-p 5000:5000 \
--rm \
-ti --entrypoint=/bin/bash \
$ARGS
