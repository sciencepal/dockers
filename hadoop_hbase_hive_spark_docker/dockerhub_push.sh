#!/bin/bash

# push to dockerhub

# Hadoop
docker push sciencepal/hadoop_cluster:hadoop

# Spark
docker push sciencepal/hadoop_cluster:spark

# PostgreSQL Hive Metastore Server
docker push sciencepal/hadoop_cluster:postgresql-hms

# Hive
docker push sciencepal/hadoop_cluster:hive

# Nifi
# docker push sciencepal/hadoop_cluster:nifi

# Edge
docker push sciencepal/hadoop_cluster:edge

# hue
docker push sciencepal/hadoop_cluster:hue

