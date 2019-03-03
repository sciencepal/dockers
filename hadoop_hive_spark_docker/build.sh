#!/bin/bash

if [ ! -d "sources" ]; then
  mkdir -p sources
  echo "Downloading hadoop source ..."
  wget https://archive.apache.org/dist/hadoop/core/hadoop-3.2.0/hadoop-3.2.0.tar.gz -P ./sources
  echo "Downloading hive source ..."
  wget http://mirrors.estointernet.in/apache/hive/stable-2/apache-hive-2.3.4-bin.tar.gz -P ./sources
  echo "Downloading scala source ..."
  wget https://downloads.lightbend.com/scala/2.12.8/scala-2.12.8.tgz -P ./sources
  echo "Downloading spark source ..."  
  wget https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-without-hadoop.tgz -P ./sources
else
  echo "Sources found, skipping retrieval..."
fi

# generate ssh key
echo "Y" | ssh-keygen -t rsa -P "" -f configs/id_rsa

# Hadoop base container build
docker build -f ./hadoopbase/Dockerfile . -t hadoopbase

# Hadoop build
docker build -f ./hadoop/Dockerfile . -t hadoop

# Spark
docker build -f ./spark/Dockerfile . -t spark

# PostgreSQL Hive Metastore Server
docker build -f ./postgresql-hms/Dockerfile . -t postgresql-hms

# Hive
docker build -f ./hive/Dockerfile . -t hive
