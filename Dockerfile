FROM java:7-jre

MAINTAINER Daniel Zohar <daniel@memrise.com>

ENV SNOWPLOW_SOURCE_ZIP kinesis_s3_0.4.0.zip
ENV JAR_FILE snowplow-kinesis-s3-0.4.0

RUN apt-get update \
    && apt-get install -y lzop liblzo2-dev \
    && wget https://bintray.com/artifact/download/snowplow/snowplow-generic/${SNOWPLOW_SOURCE_ZIP} \
    && unzip ${SNOWPLOW_SOURCE_ZIP} \
    && rm ${SNOWPLOW_SOURCE_ZIP} \
    && mv ${JAR_FILE} keep_${JAR_FILE} \
    && rm -f snowplow* \
    && mv keep_${JAR_FILE} snowplow-lzo-s3-sink.jar

RUN apt-get install -y make \
    build-essential \
    python-setuptools \
    python2.7-dev

RUN easy_install envtpl

COPY config/s3-sink.conf.tpl /etc/snowplow/s3-sink.conf.tpl

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

