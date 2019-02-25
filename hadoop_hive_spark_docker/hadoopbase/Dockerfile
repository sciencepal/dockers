FROM ubuntu

MAINTAINER Aditya Pal <aditya.pal.science@gmail.com>

USER root

RUN apt-get update

# Uncomment these lines to install Oracle JDK instead of OpenJDK
# RUN apt-get install -y software-properties-common
# RUN add-apt-repository -y ppa:webupd8team/java
# RUN apt-get update
# RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
# RUN apt-get install -y oracle-java8-installer


# OpenJDK installation
RUN apt-get install -y openjdk-8-jre

# ssh for communication between nodes
RUN apt-get install -y openssh-server

# install editor of your choice
RUN apt-get install -y vim

# set pubkey authentication and change port for ssh
RUN echo "PubkeyAuthentication yes" >> /etc/ssh/ssh_config
RUN service ssh start
CMD service ssh start && bash
