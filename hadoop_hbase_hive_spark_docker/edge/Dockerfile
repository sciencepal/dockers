FROM sciencepal/hadoop_cluster:hbase

USER root

# get Kafka sources
RUN wget http://archive.apache.org/dist/kafka/2.4.0/kafka_2.12-2.4.0.tgz -P /home/hadoop/
RUN tar -xzf /home/hadoop/kafka_2.12-2.4.0.tgz -C /home/hadoop/
RUN mv /home/hadoop/kafka_2.12-2.4.0 /home/hadoop/kafka
RUN rm -rf /home/hadoop/kafka_2.12-2.4.0*
RUN chown hadoop -R /home/hadoop/kafka
ENV KAFKA_HOME=/home/hadoop/kafka
ENV PATH $KAFKA_HOME/bin:$PATH

CMD service ssh start && bash

