#!/usr/bin/env bash
envtpl < /etc/snowplow/s3-sink.conf.tpl > /etc/snowplow/s3-sink.conf
/usr/bin/java -jar snowplow-lzo-s3-sink.jar --config /etc/snowplow/s3-sink.conf > /var/log/snowplow-sink.log 2>&1
