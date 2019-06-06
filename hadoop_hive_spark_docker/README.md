This repo aims at creating a 3 node hadoop cluster having 1 master and 2 worker nodes using docker.io containers. You can read more about the project here: https://medium.com/@aditya.pal/setup-a-3-node-hadoop-spark-hive-cluster-from-scratch-using-docker-332dae6b98d0

**NOTE: Please verify that the download links in the Dockerfiles are still active.**

For Hadoop: Choose any Hadoop version > 2.0 from here https://archive.apache.org/dist/hadoop/core/

For Hive: Choose Hive version > 2.0.0 (preferably < 3.0) from here https://archive.apache.org/dist/hive/

For Spark: Choose Spark version > 2.0 from here https://archive.apache.org/dist/spark/

**Update: Added pyspark support by installing python 2.7** ... Change to your default python version in spark Dockerfile
