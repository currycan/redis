#!/bin/bash
#
set -e

IP_NET=`ip route|awk '/default/ { print $5 }'`
IP=$(ip -4 addr ls $IP_NET | awk '/inet / {print $2}' | cut -d"/" -f1)
mkdir -p /redis/conf /data /redis/log
configEnvKeys=(
    ip
    port
    priority
)
role=(master slave1 slave2)

sed_conf() {
    local parameter="$1"
    local file_name="$2"
    sed -i -e "s!\${$parameter}!`eval echo '$'"$parameter"`!g" ${file_name}
    sed -i -e "s!\$$parameter!`eval echo '$'"$parameter"`!g" ${file_name}
}

config() {
    PORT=$REDIS_PORT
    PRIORITY=100
    for roleKey in ${role[@]};
    do
        \curl -so /redis/conf/$roleKey.conf https://raw.githubusercontent.com/currycan/redis/master/sample.conf
        for configEnvKey in "${configEnvKeys[@]}"; do sed_conf "${configEnvKey^^}" /redis/conf/$roleKey.conf; done
        nl /redis/conf/$roleKey.conf
        PORT=$((PORT+100))
        PRIORITY=$((PRIORITY-50))
    done
}
config
