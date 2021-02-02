FROM gethue/hue:latest

MAINTAINER Aditya Pal <aditya.pal.science@gmail.com>

USER root

ADD configs/hue.ini /usr/share/hue/desktop/conf/hue.ini
ADD configs/hue.ini /usr/share/hue/desktop/conf/hue-overrides.ini 
ADD configs/hue.ini /usr/share/hue/tools/docker/hue/conf/hue-overrides.ini
RUN mkdir -p /etc/hive/conf

# set environment variables
ENV HIVE_CONF_DIR /etc/hive/conf

ADD configs/hive-site.xml $HIVE_CONF_DIR/hive-site.xml
