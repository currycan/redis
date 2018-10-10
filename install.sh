#!/bin/bash

#=================================================
#   System Required: CentOS 7
#   Description: redis cluster 一键安装
#   Version: 1.0.0
#   Author: currycan
#   Github: https://github.com/currycan/redis
#=================================================

sh_ver=1.0.0

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

set -e

ruby_install() {
    echo ">>> install ruby"
    # ruby install
    yum install -y gcc-c++ make
    yum install -y ruby
    echo ">>>> ruby installation done <<<<"
}

redis_install() {
    echo ">>> install redis"
    # redis install
    version=4.0.11
    curl -o ./redis-$version.tar.gz http://download.redis.io/releases/redis-$version.tar.gz
    tar -zxvf redis-$version.tar.gz
    cd redis-$version
    make -j 4 && make
    cd src
    make install PREFIX=/usr/local/
    cp -a redis-trib.rb /usr/local/bin/
    chmod 770 /usr/local/bin/redis-trib.rb
    ln -s redis-trib.rb /usr/local/bin/redis-trib
    cd ../..
    rm -rf redis-$version
    rm -rf redis-$version.tar.gz
    gem install redis -v 3.3.5
    echo ">>>> redis installation done <<<<"
}

start() {
    echo ">>> start redis"
    read -p "所有服务是否运行在一台主机[Y/n]:" yn
    [ -z "${yn}" ] && yn="y"
    if [[ $yn == [Yy] ]]; then
        read -p "请输入当前节点名[node1/node2/node3]: " node_name
        mkdir -p /redis/conf/$node_name
        mv /redis/conf/master.conf /redis/conf/$node_name/
        mv /redis/conf/slave*.conf /redis/conf/$node_name/
        redis-server /redis/conf/$node_name/master.conf
        for file in /redis/conf/$node_name/slave*.conf; do
            redis-server $file
        done
    else
        redis-server /redis/conf/master.conf
        for file in /redis/conf/slave*.conf; do
            redis-server $file
        done
    fi
    sleep 1
    ps aux | grep redis
}

master() {
    echo -e " ${Green_font_prefix}配置集群master，需要node1、node2节点和node3节点 IP${Font_color_suffix}"
    read -p "请输入node1 IP:" node1_ip
    read -p "请输入node2 IP:" node2_ip
    read -p "请输入node3 IP:" node3_ip
    make master NODE1_IP=$node1_ip NODE2_IP=$node2_ip NODE3_IP=$node3_ip
}

slave1() {
    echo -e " ${Green_font_prefix}配置node1节点slave, 需要node2和node3节点 IP${Font_color_suffix}"
    read -p "请输入node2 IP:" node2_ip
    read -p "请输入node3 IP:" node3_ip
    make slave_node1 NODE2_IP=$node2_ip NODE3_IP=$node3_ip
}

slave2() {
    echo -e " ${Green_font_prefix}配置node2节点slave, 需要node1和node3节点 IP${Font_color_suffix}"
    read -p "请输入node1 IP:" node1_ip
    read -p "请输入node3 IP:" node3_ip
    make slave_node2 NODE1_IP=$node1_ip NODE3_IP=$node3_ip
}

slave3() {
    echo -e " ${Green_font_prefix}配置node3节点slave, 需要node1和node2节点 IP${Font_color_suffix}"
    read -p "请输入node1 IP:" node1_ip
    read -p "请输入node2 IP:" node2_ip
    make slave_node3 NODE1_IP=$node1_ip NODE2_IP=$node2_ip
}

optimizing_system(){
    sed -i '/fs.file-max/d' /etc/sysctl.conf
    sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
    sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
    sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
    sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
    sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
    sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
    echo "fs.file-max = 1000000
fs.inotify.max_user_instances = 8192
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 32768
# forward ipv4
net.ipv4.ip_forward = 1">>/etc/sysctl.conf
    sysctl -p
    echo "*               soft    nofile           1000000
*               hard    nofile          1000000">/etc/security/limits.conf
    echo "ulimit -SHn 1000000">>/etc/profile
    read -p "需要重启主机后，才能生效系统优化配置，是否现在重启 ? [Y/n] :" yn
    [ -z "${yn}" ] && yn="y"
    if [[ $yn == [Yy] ]]; then
        echo -e "${Info} 主机重启中..."
        reboot
    fi
}

start_menu(){
clear
echo && echo -e " redis cluster 一键安装管理脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}

 ————————————基础环境准备————————————————
 ${Green_font_prefix}1.${Font_color_suffix} 安装 ruby, 当前版本2.0.0

 ————————————安装redis———————————————————
 ${Green_font_prefix}2.${Font_color_suffix} 安装 redis, 当前版本4.0.11

 ————————————节点配置文件生成————————————
 ${Green_font_prefix}3.${Font_color_suffix} node1生成配置文件，请在相应节点运行！
 ${Green_font_prefix}4.${Font_color_suffix} node2生成配置文件，请在相应节点运行！
 ${Green_font_prefix}5.${Font_color_suffix} node3生成配置文件，请在相应节点运行！

 —————————————启动redis服务———————————————
 ${Green_font_prefix}6.${Font_color_suffix} 启动redis服务

 ————————————启动集群—————————————————————
 ${Green_font_prefix}7.${Font_color_suffix} 生成master角色，任一节点运行！
 ${Green_font_prefix}8.${Font_color_suffix} node1生成slave角色，请在相应节点运行！
 ${Green_font_prefix}9.${Font_color_suffix} node2生成slave角色，请在相应节点运行！
 ${Green_font_prefix}10.${Font_color_suffix} node3生成slave角色，请在相应节点运行！


 ————————————杂项管理————————————————————
 ${Green_font_prefix}11.${Font_color_suffix} 系统配置优化
 ${Green_font_prefix}0.${Font_color_suffix} 退出脚本
 ————————————————————————————————————————" && echo

echo
read -p " 请输入数字 [0-11]:" num
case "$num" in
    0)
    exit 1
    ;;
    1)
    ruby_install
    ;;
    2)
    redis_install
    ;;
    3)
    echo "Please execute on node1"
    make node1
    echo "Done"
    ;;
    4)
    echo "Please execute on node2"
    make node2
    echo "Done"
    ;;
    5)
    echo "Please execute on node3"
    make node3
    echo "Done"
    ;;
    6)
    start
    ;;
    7)
    echo "Create master"
    master
    echo "Done"
    ;;
    8)
    echo "Please execute on node1"
    slave1
    echo "Done"
    ;;
    9)
    echo "Please execute on node2"
    slave2
    echo "Done"
    ;;
    10)
    echo "Please execute on node3"
    slave3
    echo "Done"
    ;;
    11)
    optimizing_system
    ;;
    *)
    clear
    echo -e "${Error}:请输入正确数字 [0-11]"
    sleep 5s
    start_menu
    ;;
esac
}
start_menu
