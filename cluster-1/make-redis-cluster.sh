#!/usr/bin/env bash

# Run this script within redis-cli shell to configure redis cluster:
#
#   docker-compose run --rm redis-cli

redis-cli -c -h redis-2 -p 6379 cluster meet ${REDIS_1_PORT_6379_TCP_ADDR} ${REDIS_1_PORT_6379_TCP_PORT}

MASTER_NODE_ID=$(redis-cli -h redis-1 -p 6379 cluster nodes | grep myself)
MASTER_NODE_ID=${MASTER_NODE_ID:0:40}
redis-cli -c -h redis-2 -p 6379 cluster replicate ${MASTER_NODE_ID}

redis-cli -c -h redis-1 -p 6379 cluster addslots $(seq -s ' ' 0 16383)
redis-cli -c -h redis-1 -p 6379 cluster info