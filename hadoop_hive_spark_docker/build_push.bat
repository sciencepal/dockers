@echo off
REM Construccion de los Contendores Docker

REM Hadoop build
docker build -f ./hadoop/Dockerfile . -t sciencepal/hadoop_cluster:hadoop
docker push sciencepal/hadoop_cluster:hadoop

REM Spark
docker build -f ./spark/Dockerfile . -t sciencepal/hadoop_cluster:spark
docker push sciencepal/hadoop_cluster:spark

REM PostgreSQL Hive Metastore Server
docker build -f ./postgresql-hms/Dockerfile . -t sciencepal/hadoop_cluster:postgresql-hms
docker push sciencepal/hadoop_cluster:postgresql-hms

REM Hive
docker build -f ./hive/Dockerfile . -t sciencepal/hadoop_cluster:hive
docker push sciencepal/hadoop_cluster:hive

REM Nifi
docker build -f ./nifi/Dockerfile . -t sciencepal/hadoop_cluster:nifi
docker push sciencepal/hadoop_cluster:nifi

REM Edge
docker build -f ./edge/Dockerfile . -t sciencepal/hadoop_cluster:edge
docker push sciencepal/hadoop_cluster:edge

REM hue
docker build -f ./hue/Dockerfile . -t sciencepal/hadoop_cluster:hue
docker push sciencepal/hadoop_cluster:hue

REM zeppelin
docker build -f ./zeppelin/Dockerfile . -t sciencepal/hadoop_cluster:zeppelin
docker push sciencepal/hadoop_cluster:zeppelin
