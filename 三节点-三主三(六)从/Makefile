node1: 
	@export REDIS_PORT=6281; ./redis_config.sh
	@echo "configrate node1 done"
node2: 
	@export REDIS_PORT=6282; ./redis_config.sh
	@echo "configrate node2 done"
node3: 
	@export REDIS_PORT=6283; ./redis_config.sh
	@echo "configrate node3 done"


slave_node1:
	@echo "input node2 and node3 IP"
	@export NODE2_IP=$$NODE2_IP; export NODE3_IP=$$NODE3_IP; ./slave-node1.sh
slave_node2:
	@echo "input node3 and node1 IP"
	@export NODE3_IP=$$NODE3_IP; export NODE1_IP=$$NODE1_IP; ./slave-node2.sh
slave_node3:
	@echo "input node1 and node2 IP"
	@export NODE1_IP=$$NODE1_IP; export NODE2_IP=$$NODE2_IP; ./slave-node3.sh
master:
	@echo "input node1、 node2 IP and node3 IP"
	@export NODE1_IP=$$NODE1_IP; export NODE2_IP=$$NODE2_IP; export NODE3_IP=$$NODE3_IP; ./master.sh

clean:
	@rm -rf /redis
	@echo "delete the config file"
