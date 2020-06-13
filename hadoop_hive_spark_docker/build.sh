#!/bin/bash

# generate ssh key
echo "Y" | ssh-keygen -t rsa -P "" -f configs/id_rsa

# Hadoop build
docker build -f ./hadoop/Dockerfile . -t peterstraussen/hadoop_cluster:hadoop
docker push peterstraussen/hadoop_cluster:hadoop

# Spark
docker build -f ./spark/Dockerfile . -t peterstraussen/hadoop_cluster:spark
docker push peterstraussen/hadoop_cluster:spark

# PostgreSQL Hive Metastore Server
docker build -f ./postgresql-hms/Dockerfile . -t peterstraussen/hadoop_cluster:postgresql-hms
docker push peterstraussen/hadoop_cluster:postgresql-hms

# Hive
docker build -f ./hive/Dockerfile . -t peterstraussen/hadoop_cluster:hive
docker push peterstraussen/hadoop_cluster:hive

# Nifi
docker build -f ./nifi/Dockerfile . -t peterstraussen/hadoop_cluster:nifi
docker push peterstraussen/hadoop_cluster:nifi

# Edge
docker build -f ./edge/Dockerfile . -t peterstraussen/hadoop_cluster:edge
docker push peterstraussen/hadoop_cluster:edge

# hue
docker build -f ./hue/Dockerfile . -t peterstraussen/hadoop_cluster:hue
docker push peterstraussen/hadoop_cluster:hue

# zeppelin
docker build -f ./zeppelin/Dockerfile . -t peterstraussen/hadoop_cluster:zeppelin
docker push peterstraussen/hadoop_cluster:zeppelin