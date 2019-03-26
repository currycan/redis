node: 
	@export REDIS_PORT=6281; ./redis_config.sh
	@echo "configrate node done"

slave_node1:
	@echo "input node1 and node4 IP"
	@export NODE1_IP=$$NODE1_IP; export NODE4_IP=$$NODE4_IP; export REDIS_PORT=6281; redis-trib add-node --slave $NODE4_IP:$REDIS_PORT $NODE1_IP:$REDIS_PORT
slave_node2:
	@echo "input node2 and node5 IP"
	@export NODE2_IP=$$NODE2_IP; export NODE5_IP=$$NODE5_IP; export REDIS_PORT=6281; redis-trib add-node --slave $NODE5_IP:$REDIS_PORT $NODE2_IP:$REDIS_PORT
slave_node3:
	@echo "input node3 and node6 IP"
	@export NODE3_IP=$$NODE3_IP; export NODE6_IP=$$NODE6_IP; export REDIS_PORT=6281; redis-trib add-node --slave $NODE6_IP:$REDIS_PORT $NODE3_IP:$REDIS_PORT
slave_node4:
	@echo "input node1 and node4 IP"
	@export NODE1_IP=$$NODE1_IP; export NODE7_IP=$$NODE7_IP; export REDIS_PORT=6281; redis-trib add-node --slave $NODE7_IP:$REDIS_PORT $NODE1_IP:$REDIS_PORT
slave_node5:
	@echo "input node2 and node5 IP"
	@export NODE2_IP=$$NODE2_IP; export NODE8_IP=$$NODE8_IP; export REDIS_PORT=6281; redis-trib add-node --slave $NODE8_IP:$REDIS_PORT $NODE2_IP:$REDIS_PORT
slave_node6:
	@echo "input node3 and node6 IP"
	@export NODE3_IP=$$NODE3_IP; export NODE9_IP=$$NODE9_IP; export REDIS_PORT=6281; redis-trib add-node --slave $NODE9_IP:$REDIS_PORT $NODE3_IP:$REDIS_PORT


master:
	@echo "input master node IP (node1、 node2、 node3) "
	@export NODE1_IP=$$NODE1_IP; export NODE2_IP=$$NODE2_IP; export NODE3_IP=$$NODE3_IP; export REDIS_PORT=6281; redis-trib create $NODE1_IP:$REDIS_PORT $NODE2_IP:$REDIS_PORT $NODE3_IP:$REDIS_PORT

clean:
	@rm -rf /redis
	@echo "delete the config file"
