FROM ubuntu

MAINTAINER Aditya Pal <aditya.pal.science@gmail.com>

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

# get nifi sources
RUN wget http://archive.apache.org/dist/nifi/1.10.0/nifi-1.10.0-bin.tar.gz -P /home/hadoop/
RUN tar -xzf /home/hadoop/nifi-1.10.0-bin.tar.gz -C /home/hadoop/
RUN mv /home/hadoop/nifi-1.10.0 /home/hadoop/nifi
RUN rm -rf /home/hadoop/nifi-1.10.0*

# set nifi-env.sh
RUN echo -e "\n" >> /home/hadoop/nifi/bin/nifi-env.sh
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /home/hadoop/nifi/bin/nifi-env.sh
RUN echo "export TOOLS_JAR=${JAVA_HOME}/lib/tools.jar" >> /home/hadoop/nifi/bin/nifi-env.sh

ADD configs/nifi.properties /home/hadoop/nifi/conf/nifi.properties
RUN chown hadoop -R /home/hadoop/nifi

CMD service ssh start && bash

