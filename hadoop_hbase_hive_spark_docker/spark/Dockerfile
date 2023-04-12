FROM sciencepal/hadoop_cluster:hadoop


USER root

# installing python for pyspark
# change python version as per your requirement
#RUN apt-get update && apt-get install -y python3 python3-pip python-is-python3

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install -y python3.7

ENV SCALA_VERSION 2.12.12
ENV SPARK_VERSION 3.1.2

# get sources

#SCALA Source
RUN mkdir /usr/share/scala
RUN wget https://downloads.lightbend.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz -P /tmp/
RUN tar -xzf /tmp/scala-$SCALA_VERSION.tgz -C /tmp/
RUN mv /tmp/scala-$SCALA_VERSION/* /usr/share/scala/
RUN rm -rf /tmp/scala-$SCALA_VERSION /tmp/scala-$SCALA_VERSION.tgz
RUN cp /usr/share/scala/bin/* /usr/bin/
# SCALA DEB Package adn SBT
# install scala and sbt
# RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list \
#                 && echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list \
#                 && curl -sL https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823 | apt-key add \
#                 && apt-get update \
#                 && apt-get install -y sbt scala

# SPARK Sources
# RUN wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-without-hadoop.tgz -P /home/hadoop/
# RUN tar -xzf /home/hadoop/spark-$SPARK_VERSION-bin-without-hadoop.tgz -C /home/hadoop/
# RUN mv /home/hadoop/spark-$SPARK_VERSION-bin-without-hadoop /home/hadoop/spark
# RUN rm /home/hadoop/spark-$SPARK_VERSION-bin-without-hadoop.tgz
# hadoop pre built package
RUN wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.2.tgz -P /home/hadoop/
RUN tar -xzf /home/hadoop/spark-$SPARK_VERSION-bin-hadoop3.2.tgz -C /home/hadoop/
RUN mv /home/hadoop/spark-$SPARK_VERSION-bin-hadoop3.2 /home/hadoop/spark
RUN rm /home/hadoop/spark-$SPARK_VERSION-bin-hadoop3.2.tgz


RUN mkdir -p /home/hadoop/spark/logs
RUN chown hadoop -R /home/hadoop/spark/logs

# set environment variables
ENV SCALA_HOME /usr/share/scala
ENV SPARK_HOME /home/hadoop/spark
ENV SPARK_LOG_DIR /home/hadoop/spark/logs
ENV HADOOP_HOME /home/hadoop/hadoop
# ENV SPARK_DIST_CLASSPATH $(hadoop classpath) does not work
RUN export SPARK_DIST_CLASSPATH=$(hadoop classpath)
ENV PATH $SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH
ENV PATH $SCALA_HOME/bin:$PATH
ENV LD_LIBRARY_PATH /home/hadoop/hadoop/share/hadoop/common/lib:$LD_LIBRARY_PATH
RUN mv /home/hadoop/spark/conf/spark-env.sh.template /home/hadoop/spark/conf/spark-env.sh
RUN echo "export SPARK_DIST_CLASSPATH=$(hadoop classpath)" >> /home/hadoop/spark/conf/spark-env.sh
RUN echo "export SPARK_LOG_DIR=/home/hadoop/spark/logs" >> /home/hadoop/spark/conf/spark-env.sh
RUN echo "export PYSPARK_PYTHON=python3.7" >> /home/hadoop/spark/conf/spark-env.sh
RUN mv /home/hadoop/spark/conf/spark-defaults.conf.template /home/hadoop/spark/conf/spark-defaults.conf
RUN echo "spark.eventLog.dir file:/home/hadoop/spark/logs" >> /home/hadoop/spark/conf/spark-defaults.conf
RUN echo "spark.history.fs.logDirectory file:/home/hadoop/spark/logs" >> /home/hadoop/spark/conf/spark-defaults.conf
RUN echo "spark.master spark://nodemaster:7077" >> /home/hadoop/spark/conf/spark-defaults.conf
RUN echo "spark.sql.catalogImplementation hive" >> /home/hadoop/spark/conf/spark-defaults.conf
RUN echo "spark.yarn.jars hdfs://nodemaster:9000/spark-jars/*" >> /home/hadoop/spark/conf/spark-defaults.conf
RUN echo "spark.sql.hive.metastore.version 2.3.0" >> /home/hadoop/spark/conf/spark-defaults.conf
RUN echo "spark.sql.hive.metastore.jars $(hadoop classpath)" >> /home/hadoop/spark/conf/spark-defaults.conf
ADD configs/hbase-site.xml /home/hadoop/spark/conf/
ADD configs/hive-site.xml /home/hadoop/spark/conf/
ADD configs/core-site.xml /home/hadoop/spark/conf/
ADD configs/hdfs-site.xml /home/hadoop/spark/conf/
ADD configs/yarn-site.xml /home/hadoop/spark/conf/
ADD configs/workers /home/hadoop/spark/conf/slaves
RUN chown hadoop -R /home/hadoop/spark
