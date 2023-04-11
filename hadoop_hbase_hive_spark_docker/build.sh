#!/bin/bash

# generate ssh key
echo "Enter your filename"
KEYFILE=configs/id_rsa
if [ -f "$KEYFILE" ]
then
    echo "Key is already available"
else
   echo "Y" | ssh-keygen -t rsa -P "" -f configs/id_rsa
fi

# Hadoop build
docker build -f ./hadoop/Dockerfile . -t sciencepal/hadoop_cluster:hadoop

# Spark
docker build -f ./spark/Dockerfile . -t sciencepal/hadoop_cluster:spark

# PostgreSQL Hive Metastore Server
docker build -f ./postgresql-hms/Dockerfile . -t sciencepal/hadoop_cluster:postgresql-hms

# Hive
docker build -f ./hive/Dockerfile . -t sciencepal/hadoop_cluster:hive

# HBASE
docker build -f ./hbase/Dockerfile . -t sciencepal/hadoop_cluster:hbase

# Edge
docker build -f ./edge/Dockerfile . -t sciencepal/hadoop_cluster:edge

# hue
#docker build -f ./hue/Dockerfile . -t sciencepal/hadoop_cluster:hue

# BELOW TOOLS are disabled
# Nifi
#docker build -f ./nifi/Dockerfile . -t sciencepal/hadoop_cluster:nifi





