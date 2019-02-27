FROM spark

MAINTAINER Aditya Pal <aditya.pal.science@gmail.com>

USER root

# get sources
RUN apt-get install -y mysql-server libmysql-java
WORKDIR /home/hadoop
ADD sources/apache-hive-3.1.1-bin.tar.gz /home/hadoop/
RUN mv /home/hadoop/apache-hive-3.1.1-bin /home/hadoop/hive
RUN rm -rf /home/hadoop/apache-hive-3.1.1*

# set environment variables
ENV HIVE_HOME /home/hadoop/hive
ENV PATH $HIVE_HOME/bin:$PATH

# set hive-config.sh and hive-site.xml
RUN echo "export HADOOP_HOME=/home/hadoop/hadoop" >> /home/hadoop/hive/bin/hive-config.sh
RUN cp /usr/share/java/mysql-connector-java.jar $HIVE_HOME/lib/
ADD configs/hive-site.xml $HIVE_HOME/conf
RUN chown hadoop -R /home/hadoop/hive

RUN service mysql start
RUN sleep 5
RUN mysqladmin -uroot -prootpass proc; exit 0

ENTRYPOINT service mysql start && /bin/bash
