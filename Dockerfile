FROM java:7-jre

MAINTAINER Daniel Zohar <daniel@memrise.com>

ENV SNOWPLOW_SOURCE_ZIP snowplow_kinesis_r65_scarlet_rosefinch.zip
ENV JAR_FILE snowplow-lzo-s3-sink-0.2.0

RUN apt-get update \
    && apt-get install -y lzop liblzo2-dev \
    && wget https://bintray.com/artifact/download/snowplow/snowplow-generic/${SNOWPLOW_SOURCE_ZIP} \
    && unzip ${SNOWPLOW_SOURCE_ZIP} \
    && rm ${SNOWPLOW_SOURCE_ZIP} \
    && mv ${JAR_FILE} keep_${JAR_FILE} \
    && rm -f snowplow* \
    && mv keep_${JAR_FILE} snowplow-lzo-s3-sink.jar

ENTRYPOINT ["/usr/bin/java", "-jar", "snowplow-lzo-s3-sink.jar", "--config", "/etc/snowplow/s3-sink.conf"]


