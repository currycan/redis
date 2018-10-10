#!/bin/bash

echo "NODE1_IP: $NODE1_IP; NODE2_IP: $NODE2_IP; NODE3_IP: $NODE3_IP"
# master A
set -ex
redis-trib create $NODE1_IP:6281 $NODE2_IP:6282 $NODE3_IP:6283
