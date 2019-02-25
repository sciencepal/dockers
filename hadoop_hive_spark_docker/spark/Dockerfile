FROM hadoop

MAINTAINER Aditya Pal <aditya.pal.science@gmail.com>

USER root

# get sources
ADD sources/scala-2.12.8.tgz /tmp/
RUN mkdir /usr/share/scala
RUN mv /tmp/scala-2.12.8/* /usr/share/scala/
RUN rm -rf /tmp/scala-2.12.8
RUN cp /usr/share/scala/bin/* /usr/bin/
ADD sources/spark-2.4.0-bin-without-hadoop.tgz /home/hadoop/
RUN mv /home/hadoop/spark-2.4.0-bin-without-hadoop /home/hadoop/spark

# set environment variables
ENV SCALA_HOME /usr/share/scala
ENV SPARK_DIST_CLASSPATH $(hadoop classpath)
ENV SPARK_HOME /home/hadoop/spark
ADD configs/workers /home/hadoop/spark/conf/slaves
ADD configs/sparkcmd.sh /home/hadoop/sparkcmd.sh
RUN chown hadoop -R /home/hadoop/spark
RUN chown hadoop /home/hadoop/sparkcmd.sh
