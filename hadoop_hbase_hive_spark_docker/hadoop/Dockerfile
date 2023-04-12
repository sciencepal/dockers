FROM ubuntu:20.04

USER root

# open port 22
EXPOSE 22

RUN apt-get update

# Uncomment these lines to install Oracle JDK instead of OpenJDK
# RUN apt-get install -y software-properties-common
# RUN add-apt-repository -y ppa:webupd8team/java
# RUN apt-get update
# RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
# RUN apt-get install -y oracle-java8-installer

# OpenJDK installation
RUN apt-get install -y openjdk-8-jre openjdk-8-jdk openssh-server vim
# Python3 to be used by Pyspark
# RUN apt-get install -y python3 python3-pip python-is-python3
ENV HADDOP_VERSION 3.3.1
# add hadoop user
RUN useradd -m -s /bin/bash hadoop

# set pubkey authentication
RUN echo "PubkeyAuthentication yes" >> /etc/ssh/ssh_config
RUN mkdir -p /home/hadoop/.ssh
RUN echo "PubkeyAcceptedKeyTypes +ssh-dss" >> /home/hadoop/.ssh/config
RUN echo "PasswordAuthentication no" >> /home/hadoop/.ssh/config

# copy keys
ADD configs/id_rsa.pub /home/hadoop/.ssh/id_rsa.pub
ADD configs/id_rsa /home/hadoop/.ssh/id_rsa
RUN chmod 400 /home/hadoop/.ssh/id_rsa
RUN chmod 400 /home/hadoop/.ssh/id_rsa.pub
RUN cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys
RUN chown hadoop -R /home/hadoop/.ssh

# get sources
ENV HADOOP_VERSION 3.3.1
RUN wget https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz -P /home/hadoop/
RUN tar -xzf /home/hadoop/hadoop-$HADOOP_VERSION.tar.gz -C /home/hadoop/
RUN mv /home/hadoop/hadoop-$HADOOP_VERSION /home/hadoop/hadoop
RUN rm -rf /home/hadoop/hadoop-$HADOOP_VERSION*

# set environment variables
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME /home/hadoop/hadoop
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV HADOOP_MAPRED_HOME $HADOOP_HOME 
ENV HADOOP_COMMON_HOME $HADOOP_HOME 
ENV HADOOP_HDFS_HOME $HADOOP_HOME 
ENV HADOOP_COMMON_LIB_NATIVE_DIR $HADOOP_HOME/share/hadoop/common/lib
ENV YARN_HOME $HADOOP_HOME
ENV PATH $JAVA_HOME/bin:$PATH
ENV PATH $HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

# set hadoop-env.sh
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HADOOP_HOME=/home/hadoop/hadoop" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HADOOP_CONF_DIR=/home/hadoop/hadoop/etc/hadoop" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HDFS_NAMENODE_USER=hadoop" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HDFS_DATANODE_USER=hadoop" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HDFS_SECONDARYNAMENODE_USER=hadoop" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh

# create folders for nodes
RUN mkdir -p /home/hadoop/data/nameNode /home/hadoop/data/dataNode /home/hadoop/data/nameNodeSecondary /home/hadoop/data/tmp
RUN mkdir -p /home/hadoop/hadoop/logs
ADD configs/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
ADD configs/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD configs/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
ADD configs/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD configs/hive-site.xml $HADOOP_HOME/etc/hadoop/hive-site.xml
ADD configs/workers $HADOOP_HOME/etc/hadoop/workers

# permissions
RUN chown hadoop -R /home/hadoop/data
RUN chown hadoop -R /home/hadoop/hadoop

CMD service ssh start && bash
