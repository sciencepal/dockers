#!/bin/bash

# generate ssh key
echo "Y" | ssh-keygen -t rsa -P "" -f configs/id_rsa

# Hadoop build
docker build -f ./hadoop/Dockerfile . -t sciencepal/hadoop_cluster:hadoop
docker push sciencepal/hadoop_cluster:hadoop

# Spark
docker build -f ./spark/Dockerfile . -t sciencepal/hadoop_cluster:spark
docker push sciencepal/hadoop_cluster:spark

# PostgreSQL Hive Metastore Server
docker build -f ./postgresql-hms/Dockerfile . -t sciencepal/hadoop_cluster:postgresql-hms
docker push sciencepal/hadoop_cluster:postgresql-hms

# Hive
docker build -f ./hive/Dockerfile . -t sciencepal/hadoop_cluster:hive
docker push sciencepal/hadoop_cluster:hive

# Nifi
docker build -f ./nifi/Dockerfile . -t sciencepal/hadoop_cluster:nifi
docker push sciencepal/hadoop_cluster:nifi

# Edge
docker build -f ./edge/Dockerfile . -t sciencepal/hadoop_cluster:edge
docker push sciencepal/hadoop_cluster:edge

# hue
docker build -f ./hue/Dockerfile . -t sciencepal/hadoop_cluster:hue
docker push sciencepal/hadoop_cluster:hue

# zeppelin
docker build -f ./zeppelin/Dockerfile . -t sciencepal/hadoop_cluster:zeppelin
docker push sciencepal/hadoop_cluster:zeppelin
