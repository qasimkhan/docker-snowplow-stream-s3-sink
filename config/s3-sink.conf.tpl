# Default configuration for kinesis-lzo-s3-sink

sink {

  # The following are used to authenticate for the Amazon Kinesis sink.
  #
  # If both are set to 'default', the default provider chain is used
  # (see http://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/com/amazonaws/auth/DefaultAWSCredentialsProviderChain.html)
  #
  # If both are set to 'iam', use AWS IAM Roles to provision credentials.
  #
  # If both are set to 'env', use environment variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
  aws {
    access-key: "{{ AWS_ACCESS_KEY }}"
    secret-key: "{{ AWS_SECRET_KEY }}"
  }

  kinesis {
    in {
      # Kinesis input stream name
      stream-name: "{{ SNOWPLOW_STREAM_NAME }}"

      # LATEST: most recent data.
      # TRIM_HORIZON: oldest available data.
      # Note: This only affects the first run of this application
      # on a stream.
      initial-position: "TRIM_HORIZON"
    }

    out {
      # Stream for events for which the storage process fails
      stream-name: "{{ SNOWPLOW_STREAM_NAME_BAD }}"
    }

    region: "{{ AWS_REGION }}"

    # "app-name" is used for a DynamoDB table to maintain stream state.
    # You can set it automatically using: "SnowplowLzoS3Sink-$\\{sink.kinesis.in.stream-name\\}"
    app-name: "SnowplowLzoS3Sink-{{ SNOWPLOW_STREAM_NAME }}"
  }

  s3 {
    # If using us-east-1, then endpoint should be "http://s3.amazonaws.com".
    # Otherwise "http://s3-<<region>>.s3.amazonaws.com", e.g.
    # http://s3-eu-west-1.amazonaws.com
    endpoint: "http://s3.amazonaws.com"
    region: "{{ AWS_REGION }}"
    bucket: "{{ SNOWPLOW_S3_SINK }}"
  }

  # Events are accumulated in a buffer before being sent to S3.
  # The buffer is emptied whenever:
  # - the combined size of the stored records exceeds byte-limit or
  # - the number of stored records exceeds record-limit or
  # - the time in milliseconds since it was last emptied exceeds time-limit
  buffer {
    byte-limit: {{ BUFFER_BYTE_LIMIT | default(4000000) }} # 4 mb
    record-limit: {{ BUFFER_RECORD_LIMIT | default(500) }} # 500 records
    time-limit: {{ BUFFER_TIME_LIMIT | default(60000) }}   # 1 minute
  }

}
