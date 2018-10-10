### 安装步骤
运行1、2
配置3-5，配置完成后启动服务，也就是3做完后做6，若是单节点集群，根据提示配置。
启动6
创建master角色7
创建slave角色8-10
优化参数11
### 常见维护
查看集群状态：
redis-trib check <IP>:<PORT>
重新配置：
pkill -9 redis
make clean
rm -rf /data (根据需要)