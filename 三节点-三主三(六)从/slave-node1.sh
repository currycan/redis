#!/bin/bash

REDIS_IP=$(ip -4 addr ls $(ip route|awk '/default/ { print $5 }') | awk '/inet / {print $2}' | cut -d"/" -f1)
echo "NODE2_IP: $NODE2_IP"
# slave to node2
set -ex
redis-trib add-node --slave $REDIS_IP:6381 $NODE2_IP:6282
