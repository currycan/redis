#!/bin/bash

REDIS_IP=$(ip -4 addr ls $(ip route|awk '/default/ { print $5 }') | awk '/inet / {print $2}' | cut -d"/" -f1)
echo "NODE3_IP: $NODE3_IP"
# slave to node3
set -ex
redis-trib add-node --slave $REDIS_IP:6382 $NODE3_IP:6283
