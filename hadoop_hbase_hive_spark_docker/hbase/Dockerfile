FROM sciencepal/hadoop_cluster:spark

MAINTAINER Aditya Pal <aditya.pal.science@gmail.com>

USER root

ENV HBASE_VERSION 2.4.15

# HBASE
# get sources
RUN wget https://archive.apache.org/dist/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz -P /home/hadoop/
RUN tar -xzf /home/hadoop/hbase-$HBASE_VERSION-bin.tar.gz -C /home/hadoop/
RUN mv /home/hadoop/hbase-$HBASE_VERSION /home/hadoop/hbase
RUN rm -rf /home/hadoop/hbase-$HBASE_VERSION-bin.tar.gz*

# set environment variables
ENV  JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV  HBASE_HOME /home/hadoop/hbase
ENV  PATH $PATH:$HBASE_HOME/bin

# set hbase-env.sh
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> $HBASE_HOME/conf/hbase-env.sh
RUN echo "export HBASE_HOME=/home/hadoop/hbase" >> $HBASE_HOME/conf/hbase-env.sh
RUN echo "export HBASE_REGIONSERVERS=/home/hadoop/hbase/conf/regionservers" >> $HBASE_HOME/conf/hbase-env.sh
RUN echo "export HBASE_MANAGES_ZK=true" >> $HBASE_HOME/conf/hbase-env.sh
ADD configs/hbase-site.xml $HBASE_HOME/conf/hbase-site.xml


# ZooKeeper config
RUN mkdir -p /home/hadoop/zookeeper /home/hadoop/zookeeper/tmp
RUN chown hadoop -R /home/hadoop/zookeeper*

RUN chown hadoop -R /home/hadoop/hbase

CMD service ssh start && bash