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

# set hive-config.sh
RUN echo "export HADOOP_HOME=/home/hadoop/hadoop" >> /home/hadoop/hive/bin/hive-config.sh
RUN cp /usr/share/java/mysql-connector-java.jar $HIVE_HOME/lib/
ADD hive-site.xml $HIVE_HOME/conf

RUN service mysql start
RUN mysqladmin -uroot -prootpass proc; exit 0
RUN echo "CREATE USER 'hive'@'localhost' IDENTIFIED BY 'hive';"
RUN echo "GRANT ALL PRIVILEGES ON *.* TO 'hive'@'localhost';"
RUN echo "CREATE USER 'hive'@'%' IDENTIFIED BY 'hive';"
RUN echo "GRANT ALL PRIVILEGES ON *.* TO 'hive'@'%';"
RUN echo "CREATE USER 'hive'@'[HIVE_METASTORE_FQDN]' IDENTIFIED BY 'hive';"
RUN echo "GRANT ALL PRIVILEGES ON *.* TO 'hive'@'[HIVE_METASTORE_FQDN]';"
RUN echo "FLUSH PRIVILEGES;"
ENTRYPOINT service mysql start && /bin/bash
