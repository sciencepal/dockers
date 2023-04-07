#!/bin/bash

# HBASE THRIFT port 9090
nohup hbase thrift start > /home/hadoop/hbase/logs/hbase-thrift.log 2>&1 &