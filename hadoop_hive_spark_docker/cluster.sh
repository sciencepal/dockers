#!/bin/bash

# Bring the services up
function startServices {
  docker start nodemaster node2 node3
  sleep 5
  echo ">> Starting hdfs ..."
  docker exec -u hadoop -it nodemaster start-dfs.sh
  sleep 5
  echo ">> Starting yarn ..."
  docker exec -u hadoop -d nodemaster start-yarn.sh
  sleep 5
  echo ">> Starting MR-JobHistory Server ..."
  docker exec -u hadoop -d nodemaster mr-jobhistory-daemon.sh start historyserver
  sleep 5
  echo ">> Starting Spark ..."
  docker exec -u hadoop -d nodemaster start-master.sh
  docker exec -u hadoop -d node2 start-slave.sh nodemaster:7077
  docker exec -u hadoop -d node3 start-slave.sh nodemaster:7077
  sleep 5
  echo ">> Starting Spark History Server ..."
  docker exec -u hadoop nodemaster start-history-server.sh
  sleep 5
  echo ">> Preparing hdfs for hive ..."
  docker exec -u hadoop -it nodemaster hdfs dfs -mkdir -p /tmp
  docker exec -u hadoop -it nodemaster hdfs dfs -mkdir -p /user/hive/warehouse
  docker exec -u hadoop -it nodemaster hdfs dfs -chmod g+w /tmp
  docker exec -u hadoop -it nodemaster hdfs dfs -chmod g+w /user/hive/warehouse
  sleep 5
  echo ">> Starting Hive Metastore ..."
  docker exec -u hadoop -d nodemaster hive --service metastore
  echo "Hadoop info @ nodemaster: http://172.18.1.1:8088/cluster"
  echo "DFS Health @ nodemaster : http://172.18.1.1:50070/dfshealth"
  echo "MR-JobHistory Server @ nodemaster : http://172.18.1.1:19888"
  echo "Spark info @ nodemaster  : http://172.18.1.1:8080"
  echo "Spark History Server @ nodemaster : http://172.18.1.1:18080"
}

function stopServices {
  echo ">> Stopping Spark Master and slaves ..."
  docker exec -u hadoop -d nodemaster stop-master.sh
  docker exec -u hadoop -d node2 stop-slave.sh
  docker exec -u hadoop -d node3 stop-slave.sh
  echo ">> Stopping containers ..."
  docker stop nodemaster node2 node3 psqlhms
}

if [[ $1 = "start" ]]; then
  docker network create --subnet=172.18.0.0/16 hadoopnet # create custom network

  # Starting Postresql Hive metastore
  echo ">> Starting postgresql hive metastore ..."
  docker run -d --net hadoopnet --ip 172.18.1.4 --hostname psqlhms --name psqlhms -it postgresql-hms
  sleep 5
  
  # 3 nodes
  echo ">> Starting nodes master and worker nodes ..."
  docker run -d --net hadoopnet --ip 172.18.1.1 --hostname nodemaster --add-host node2:172.18.1.2 --add-host node3:172.18.1.3 --name nodemaster -it hive
  docker run -d --net hadoopnet --ip 172.18.1.2 --hostname node2 --add-host nodemaster:172.18.1.1 --add-host node3:172.18.1.3 --name node2 -it spark
  docker run -d --net hadoopnet --ip 172.18.1.3 --hostname node3 --add-host nodemaster:172.18.1.1 --add-host node2:172.18.1.2 --name node3 -it spark

  # Format nodemaster
  echo ">> Formatting hdfs ..."
  docker exec -u hadoop -it nodemaster hdfs namenode -format
  startServices
  exit
fi


if [[ $1 = "stop" ]]; then
  stopServices
  docker rm nodemaster node2 node3 psqlhms
  docker network rm hadoopnet
  exit
fi


if [[ $1 = "uninstall" ]]; then
  stopServices
  docker rmi hadoop spark hive postgresql-hms -f
  docker network rm hadoopnet
  docker system prune -f
  exit
fi

echo "Usage: cluster.sh start|stop|uninstall"
echo "                 start  - start existing containers"
echo "                 stop   - stop running processes"
echo "                 uninstall - remove all docker images"
