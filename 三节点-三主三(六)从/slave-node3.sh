#!/bin/bash

REDIS_IP=$(ip -4 addr ls $(ip route|awk '/default/ { print $5 }') | awk '/inet / {print $2}' | cut -d"/" -f1)
echo "NODE1_IP: $NODE1_IP"
# slave to node1
set -ex
redis-trib add-node --slave $REDIS_IP:6383 $NODE1_IP:6281
