### 安装步骤
运行：install.sh   
安装1、2，安装ruby和redis   
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
### 说明
  若是两节点集群，修改redis_conf.sh中role=(master slave1 slave2)为role=(master slave1)   
  注释slave_node*.sh中，第二个slave关系   
