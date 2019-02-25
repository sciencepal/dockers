#!/bin/bash

# Bring the services up
function startServices {
  docker start nodemaster node2 node3
  sleep 5
  echo ">> Starting hdfs ..."
  docker exec -u hadoop -it nodemaster /home/hadoop/hadoop/sbin/start-dfs.sh
  sleep 5
  echo ">> Starting yarn ..."
  docker exec -u hadoop -d nodemaster /home/hadoop/hadoop/sbin/start-yarn.sh
  sleep 5
  echo ">>Starting MR-JobHistory Server ..."
  docker exec -u hadoop -d nodemaster /home/hadoop/hadoop/sbin/mr-jobhistory-daemon.sh start historyserver
  sleep 5
  echo ">>Starting Spark ..."
  docker exec -u hadoop -d nodemaster /home/hadoop/sparkcmd.sh start
  docker exec -u hadoop -d node2 /home/hadoop/sparkcmd.sh start
  docker exec -u hadoop -d node3 /home/hadoop/sparkcmd.sh start
  echo "Hadoop info @ nodemaster: http://172.18.1.1:8088/cluster"
  echo "DFS Health @ nodemaster : http://172.18.1.1:50070/dfshealth"
  echo "MR-JobHistory Server @ nodemaster : http://172.18.1.1:19888"
  echo "Secondary Namenode @ nodemaster : http://172.18.1.1:50090"
  echo "Spark info @ nodemaster  : http://172.18.1.1:8080"
}

if [[ $1 = "start" ]]; then
  startServices
  exit
fi

if [[ $1 = "stop" ]]; then
  docker exec -u hadoop -d nodemaster /home/hadoop/sparkcmd.sh stop
  docker exec -u hadoop -d node2 /home/hadoop/sparkcmd.sh stop
  docker exec -u hadoop -d node3 /home/hadoop/sparkcmd.sh stop
  docker stop nodemaster node2 node3
  docker rm nodemaster node2 node3
  docker system prune -f
  exit
fi

if [[ $1 = "deploy" ]]; then
  docker rm -f `docker ps -aq` # delete old containers
  docker network rm hadoopnet
  docker network create --subnet=172.18.0.0/16 hadoopnet # create custom network

  # 3 nodes
  echo ">> Starting nodes master and worker nodes ..."
  docker run -d --net hadoopnet --ip 172.18.1.1 --hostname nodemaster --add-host node2:172.18.1.2 --add-host node3:172.18.1.3 --name nodemaster -it spark
  docker run -d --net hadoopnet --ip 172.18.1.2 --hostname node2 --add-host nodemaster:172.18.1.1 --add-host node3:172.18.1.3 --name node2 -it spark
  docker run -d --net hadoopnet --ip 172.18.1.3 --hostname node3 --add-host nodemaster:172.18.1.1 --add-host node2:172.18.1.2 --name node3 -it spark

  # Format nodemaster
  echo ">> Formatting hdfs ..."
  docker exec -u hadoop -it nodemaster /home/hadoop/hadoop/bin/hdfs namenode -format
  startServices
  exit
fi

echo "Usage: cluster.sh deploy|start|stop"
echo "                 deploy - create a new Docker network"
echo "                 start  - start the existing containers"
echo "                 stop   - stop the running containers"  
