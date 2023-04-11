#!/bin/bash

# Bring the services up
function startServices {
  docker start nodemaster node2 node3 hbase
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
  echo ">> Preparing hdfs for hbase ..."
  docker exec -u hadoop -it nodemaster hdfs dfs -mkdir -p /tmp
  docker exec -u hadoop -it nodemaster hdfs dfs -mkdir -p /user/hbase
  docker exec -u hadoop -it nodemaster hdfs dfs -mkdir -p /hbase
  docker exec -u hadoop -it nodemaster hdfs dfs -chmod g+w /tmp
  docker exec -u hadoop -it nodemaster hdfs dfs -chmod g+w /hbase
  docker exec -u hadoop -it nodemaster hdfs dfs -chmod g+w /user/hbase
  sleep 5
  echo ">> Starting Hive Metastore ..."
  docker exec -u hadoop -d nodemaster hive --service metastore
  docker exec -u hadoop -d nodemaster hive --service hiveserver2
  sleep 5
  echo ">> Starting HBASE ..."
  docker exec -u hadoop -d hbase /home/hadoop/hbase-keyscan.sh
  docker exec -u hadoop -d hbase /home/hadoop/hbase/bin/start-hbase.sh
  sleep 5
  docker exec -u hadoop -d hbase /home/hadoop/hbase/hbase-thrift-start.sh
  sleep 5
  # echo ">> Starting Nifi Server ..."
  # docker exec -u hadoop -d nifi /home/hadoop/nifi/bin/nifi.sh start
  # echo ">> Starting kafka & Zookeeper ..."
  # docker exec -u hadoop -d edge /home/hadoop/kafka/bin/zookeeper-server-start.sh -daemon  /home/hadoop/kafka/config/zookeeper.properties
  # docker exec -u hadoop -d edge /home/hadoop/kafka/bin/kafka-server-start.sh -daemon  /home/hadoop/kafka/config/server.properties
  
  echo "Hadoop info @ nodemaster: http://172.20.1.1:8088/cluster"
  echo "DFS Health @ nodemaster : http://172.20.1.1:50070/dfshealth"
  echo "MR-JobHistory Server @ nodemaster : http://172.20.1.1:19888"
  echo "Spark info @ nodemaster  : http://172.20.1.1:8080"
  echo "Spark History Server @ nodemaster : http://172.20.1.1:18080"
  echo "Zookeeper @ hbase : http://172.20.1.9:2181"
  # echo "Kafka @ edge : http://172.20.1.5:9092"
  # echo "Nifi @ edge : http://172.20.1.5:8080/nifi & from host @ http://localhost:8080/nifi"
  echo "HBASE @ hbase : http://172.20.1.9:16010 & from host @ http://localhost:16010"
}

function stopServices {
  echo ">> Stopping Spark Master and slaves ..."
  docker exec -u hadoop -d nodemaster stop-master.sh
  docker exec -u hadoop -d node2 stop-slave.sh
  docker exec -u hadoop -d node3 stop-slave.sh
  docker exec -u hadoop -d hbase /home/hadoop/hbase/bin/stop-hbase.sh 
  # docker exec -u hadoop -d nifi /home/hadoop/nifi/bin/nifi.sh stop
  # docker exec -u hadoop -d zeppelin /home/hadoop/zeppelin/bin/zeppelin-daemon.sh stop
  echo ">> Stopping containers ..."
  # docker stop nodemaster node2 node3 edge hue nifi zeppelin psqlhms
  docker stop nodemaster node2 node3 psqlhms hbase edge
}

if [[ $1 = "install" ]]; then
  docker network create --subnet=172.20.0.0/16 hadoopnet # create custom network

  # Starting Postresql Hive metastore
  echo ">> Starting postgresql hive metastore ..."
  docker run -d --net hadoopnet --ip 172.20.1.4 --hostname psqlhms --add-host nodemaster:172.20.1.1 --add-host node2:172.20.1.2 --add-host node3:172.20.1.3 --add-host hbase:172.20.1.9 --name psqlhms -e POSTGRES_PASSWORD=hive -it sciencepal/hadoop_cluster:postgresql-hms
  sleep 5
  
  # 3 nodes
  echo ">> Starting master and worker nodes ..."
  docker run -d --net hadoopnet --ip 172.20.1.1 -p 4040:4040 -p 8088:8088 -p 50070:50070 -p 8080:8080 -p 18080:18080 --hostname nodemaster --add-host node2:172.20.1.2 --add-host node3:172.20.1.3 --add-host hbase:172.20.1.9 --name nodemaster -it sciencepal/hadoop_cluster:hive
  docker run -d --net hadoopnet --ip 172.20.1.2 --hostname node2 --add-host nodemaster:172.20.1.1 --add-host node3:172.20.1.3 --add-host hbase:172.20.1.9 --name node2 -it sciencepal/hadoop_cluster:spark
  docker run -d --net hadoopnet --ip 172.20.1.3 --hostname node3 --add-host nodemaster:172.20.1.1 --add-host node2:172.20.1.2 --add-host hbase:172.20.1.9 --name node3 -it sciencepal/hadoop_cluster:spark
  docker run -d --net hadoopnet --ip 172.20.1.5 -p 4040:4040 --hostname edge --add-host nodemaster:172.20.1.1 --add-host node2:172.20.1.2 --add-host node3:172.20.1.3 --add-host psqlhms:172.20.1.4 --add-host hbase:172.20.1.9 --name edge -it sciencepal/hadoop_cluster:edge 
  docker run -d --net hadoopnet --ip 172.20.1.9 -p 16010:16010 --hostname hbase --add-host nodemaster:172.20.1.1 --add-host node2:172.20.1.2 --add-host node3:172.20.1.3 --add-host psqlhms:172.20.1.4 --add-host hbase:172.20.1.9 --name hbase -it sciencepal/hadoop_cluster:hbase 
  #docker run -d --net hadoopnet --ip 172.20.1.6 -p 8080:8080 --hostname nifi --add-host nodemaster:172.20.1.1 --add-host node2:172.20.1.2 --add-host node3:172.20.1.3 --add-host psqlhms:172.20.1.4 --name nifi -it sciencepal/hadoop_cluster:nifi 
  #docker run -d --net hadoopnet --ip 172.20.1.7  -p 8888:8888 --hostname huenode --add-host edge:172.20.1.5 --add-host nodemaster:172.20.1.1 --add-host node2:172.20.1.2 --add-host node3:172.20.1.3 --add-host psqlhms:172.20.1.4 --name hue -it sciencepal/hadoop_cluster:hue
  # docker run -d --net hadoopnet --ip 172.20.1.8  -p 8081:8081 --hostname zeppelin --add-host edge:172.20.1.5 --add-host nodemaster:172.20.1.1 --add-host node2:172.20.1.2 --add-host node3:172.20.1.3 --add-host psqlhms:172.20.1.4 --add-host hbase:172.20.1.9 --name zeppelin -it sciencepal/hadoop_cluster:zeppelin

  # Format nodemaster
  echo ">> Formatting hdfs ..."
  docker exec -u hadoop -it nodemaster hdfs namenode -format
  startServices
  exit
fi


if [[ $1 = "stop" ]]; then
  stopServices
  exit
fi


if [[ $1 = "uninstall" ]]; then
  stopServices
  docker network rm hadoopnet
  docker ps -a | grep "sciencepal" | awk '{print $1}' | xargs docker rm
  docker rmi sciencepal/hadoop_cluster:hadoop sciencepal/hadoop_cluster:spark sciencepal/hadoop_cluster:hive sciencepal/hadoop_cluster:postgresql-hms sciencepal/hadoop_cluster:hue sciencepal/hadoop_cluster:edge sciencepal/hadoop_cluster:nifi sciencepal/hadoop_cluster:zeppelin sciencepal/hadoop_cluster:hbase -f
  exit
fi

if [[ $1 = "start" ]]; then  
  docker start psqlhms nodemaster node2 node3 hbase edge zeppelin
# docker start psqlhms nodemaster node2 node3 edge hue nifi zeppelin
  startServices
  exit
fi

if [[ $1 = "pull_images" ]]; then  
  docker pull -a sciencepal/hadoop_cluster
  exit
fi

echo "Usage: cluster.sh pull_images|install|start|stop|uninstall"
echo "                 pull_images - download all docker images"
echo "                 install - Prepare to run and start for first time all containers"
echo "                 start  - start existing containers"
echo "                 stop   - stop running processes"
echo "                 uninstall - remove all docker images"


