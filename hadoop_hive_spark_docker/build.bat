@echo off
REM Construccion de los Contendores Docker

REM Hadoop build
docker build -f ./hadoop/Dockerfile . -t hadoop

REM Spark
docker build -f ./spark/Dockerfile . -t spark

REM PostgreSQL Hive Metastore Server
docker build -f ./postgresql-hms/Dockerfile . -t postgresql-hms

REM Hive
docker build -f ./hive/Dockerfile . -t hive

REM Edge
docker build -f ./edge/Dockerfile . -t edge

REM hue
docker build -f ./hue/Dockerfile . -t hue