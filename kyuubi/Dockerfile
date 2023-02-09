FROM apache/kyuubi:master-snapshot

RUN curl -O https://repo1.maven.org/maven2/software/amazon/awssdk/s3/2.18.41/s3-2.18.41.jar \
    && curl -O https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.12.367/aws-java-sdk-1.12.367.jar \
    && curl -O https://repo1.maven.org/maven2/io/delta/delta-core_2.12/2.2.0/delta-core_2.12-2.2.0.jar \
    && curl -O https://repo1.maven.org/maven2/io/delta/delta-storage/2.2.0/delta-storage-2.2.0.jar \
    && curl -O https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.2/hadoop-aws-3.3.2.jar \
    && curl -O https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.1026/aws-java-sdk-bundle-1.11.1026.jar \
    && mv s3-2.18.41.jar /opt/kyuubi/externals/spark-3.3.1-bin-hadoop3/jars/ \
    && mv aws-java-sdk-1.12.367.jar /opt/kyuubi/externals/spark-3.3.1-bin-hadoop3/jars/ \
    && mv delta-core_2.12-2.2.0.jar /opt/kyuubi/externals/spark-3.3.1-bin-hadoop3/jars/ \
    && mv delta-storage-2.2.0.jar /opt/kyuubi/externals/spark-3.3.1-bin-hadoop3/jars/ \
    && mv hadoop-aws-3.3.2.jar /opt/kyuubi/externals/spark-3.3.1-bin-hadoop3/jars/ \
    && mv aws-java-sdk-bundle-1.11.1026.jar /opt/kyuubi/externals/spark-3.3.1-bin-hadoop3/jars/