#!/bin/bash

# generate ssh key
echo "Y" | ssh-keygen -t rsa -P "" -f configs/id_rsa

# Hadoop build
docker build -f ./hadoop/Dockerfile . -t hadoop

# Spark
docker build -f ./spark/Dockerfile . -t spark

# PostgreSQL Hive Metastore Server
docker build -f ./postgresql-hms/Dockerfile . -t postgresql-hms

# Hive
docker build -f ./hive/Dockerfile . -t hive
