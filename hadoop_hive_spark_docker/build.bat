@echo off
REM Construccion de los Contendores Docker

REM Hadoop build
docker build -f ./hadoop/Dockerfile . -t peterstraussen/hadoop_cluster:hadoop
docker push peterstraussen/hadoop_cluster:hadoop

REM Spark
docker build -f ./spark/Dockerfile . -t peterstraussen/hadoop_cluster:spark
docker push peterstraussen/hadoop_cluster:spark

REM PostgreSQL Hive Metastore Server
docker build -f ./postgresql-hms/Dockerfile . -t peterstraussen/hadoop_cluster:postgresql-hms
docker push peterstraussen/hadoop_cluster:postgresql-hms

REM Hive
docker build -f ./hive/Dockerfile . -t peterstraussen/hadoop_cluster:hive
docker push peterstraussen/hadoop_cluster:hive

REM Nifi
docker build -f ./nifi/Dockerfile . -t peterstraussen/hadoop_cluster:nifi
docker push peterstraussen/hadoop_cluster:nifi

REM Edge
docker build -f ./edge/Dockerfile . -t peterstraussen/hadoop_cluster:edge
docker push peterstraussen/hadoop_cluster:edge

REM hue
docker build -f ./hue/Dockerfile . -t peterstraussen/hadoop_cluster:hue
docker push peterstraussen/hadoop_cluster:hue

REM zeppelin
docker build -f ./zeppelin/Dockerfile . -t peterstraussen/hadoop_cluster:zeppelin
docker push peterstraussen/hadoop_cluster:zeppelin