@echo off
REM push to dockerhub

REM Hadoop
docker push sciencepal/hadoop_cluster:hadoop

REM Spark
docker push sciencepal/hadoop_cluster:spark

REM PostgreSQL Hive Metastore Server
docker push sciencepal/hadoop_cluster:postgresql-hms

REM Hive
docker push sciencepal/hadoop_cluster:hive

REM Nifi
docker push sciencepal/hadoop_cluster:nifi

REM Edge
docker push sciencepal/hadoop_cluster:edge

REM hue
docker push sciencepal/hadoop_cluster:hue

REM zeppelin
docker push sciencepal/hadoop_cluster:zeppelin
