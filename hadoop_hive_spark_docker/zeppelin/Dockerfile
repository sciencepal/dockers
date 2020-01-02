FROM peterstraussen/hadoop_cluster:hive

USER root

# get sources
RUN wget http://archive.apache.org/dist/zeppelin/zeppelin-0.8.2/zeppelin-0.8.2-bin-all.tgz -P /home/hadoop/
RUN tar -xzf /home/hadoop/zeppelin-0.8.2-bin-all.tgz -C /home/hadoop/
RUN mv /home/hadoop/zeppelin-0.8.2-bin-all /home/hadoop/zeppelin
RUN rm -rf /home/hadoop/zeppelin-0.8.2-bin-all*

RUN chown hadoop -R /home/hadoop/zeppelin


RUN echo "export ZEPPELIN_ADDR=0.0.0.0" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh
RUN echo "export ZEPPELIN_PORT=8081" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh

RUN echo "export SPARK_HOME=/home/hadoop/spark" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh

# set hadoop conf dir
RUN echo "export HADOOP_HOME=/home/hadoop/hadoop" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh
RUN echo "export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh

RUN echo "export HIVE_HOME=/home/hadoop/hive" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh
RUN echo "export ZEPPELIN_INTP_CLASSPATH_OVERRIDES=$HIVE_HOME/conf" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh

# set options to pass spark-submit command
# export SPARK_SUBMIT_OPTIONS="--packages com.databricks:spark-csv_2.10:1.2.0"
