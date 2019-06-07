This repo aims at creating a 3 node hadoop cluster having 1 master and 2 worker nodes using docker.io containers. You can read more about the project here: https://medium.com/@aditya.pal/setup-a-3-node-hadoop-spark-hive-cluster-from-scratch-using-docker-332dae6b98d0

<br />

**NOTE: Please verify that the download links in the Dockerfiles are still active.**

For Hadoop: Choose any Hadoop version > 2.0 from here https://archive.apache.org/dist/hadoop/core/

For Hive: Choose Hive version > 2.0.0 (preferably < 3.0) from here https://archive.apache.org/dist/hive/

For Spark: Choose Spark version > 2.0 from here https://archive.apache.org/dist/spark/

<br />

**Update: Added pyspark support by installing python 2.7** ... Change to your default python version in spark Dockerfile

<br />

**Instructions for use**

1. Build cluster using **./build.sh**

2. Once all images are built, start cluster by **./cluster.sh start**

3. Verify the containers running by **docker ps -as**. nodemaster, node2, node3 and psqlhms containers should be running.

4. Enter any container this way: **docker exec -u hadoop -it nodemaster /bin/bash**

5. Once all work is done, bring down cluster by **./cluster.sh stop**

<br />

**Tests Done with Hive**

1. Copy file from local to nodemaster container : **docker cp test_data.csv nodemaster:/tmp/**

2. Enter nodemaster : **docker exec -u hadoop -it nodemaster /bin/bash**

3. Create directory in HDFS : hadoop@nodemaster:/$ **hdfs dfs -mkdir -p /user/hadoop/test**

4. Get file from container local to HDFS : hadoop@nodemaster:/$ **hdfs dfs -put /tmp/test_data.csv /user/hadoop/test/**

5. execute Hive by : hadoop@nodemaster:/$ **hive**

6. In hive terminal : hive>**create schema if not exists test;**

7. In hive terminal : hive>**create external table if not exists test.test_data (row1 int, row2 int, row3 decimal(10,3), row4 int) row format delimited fields terminated by ',' stored as textfile location 'hdfs://172.18.1.1:9000/user/hadoop/test/';**

8. **Results**

hive> **select * from test.test_data where row3 > 2.499;**<br />
OK<br />
1	122	5.000	838985046<br />
1	185	4.500	838983525<br />
1	231	4.000	838983392<br />
1	292	3.500	838983421<br />
1	316	3.000	838983392<br />
1	329	2.500	838983392<br />
1	377	3.500	838983834<br />
1	420	5.000	838983834<br />
1	466	4.000	838984679<br />
1	480	5.000	838983653<br />
1	520	2.500	838984679<br />
1	539	5.000	838984068<br />
1	586	3.500	838984068<br />
1	588	5.000	838983339<br />
Time taken: 0.175 seconds, Fetched: 14 row(s)

