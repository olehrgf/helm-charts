# See: https://github.com/aws-samples/hive-emr-on-eks

FROM public.ecr.aws/amazoncorretto/amazoncorretto:17

ARG HADOOP_VERSION=3.3.2
ARG HMS_VERSION=3.0.0
ARG POSTGRES_CONNECTOR_VERSION=42.6.0

ENV METASTORE_HOME="/opt/hive-metastore"

ENV HADOOP_HOME="/opt/hadoop"
ENV HADOOP_CLASSPATH="${HADOOP_HOME}/share/hadoop/tools/lib/*:${HADOOP_HOME}/share/hadoop/common/lib/*"

ENV PATH="/opt/spark/bin:/opt/hadoop/bin:${METASTORE_HOME}/lib/:${PATH}"

ENV DATABASE_DRIVER=org.postgresql.Driver
ENV DATABASE_TYPE=postgres
ENV DATABASE_TYPE_JDBC=postgresql
ENV DATABASE_PORT=5432

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -ex && \
    rm /bin/sh && ln -s /bin/bash /bin/sh && ln -s /lib /lib64 && \
    yum -y update && \
    yum -y groupinstall development && \
    yum -y install yum-utils unzip procps curl && \
    yum clean all && \
    rm -rf /var/cache/yum

COPY --from=hairyhenderson/gomplate:stable /gomplate /usr/local/bin/gomplate
RUN chmod 755 /usr/local/bin/gomplate

# Download Hadoop
RUN curl -s https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz \
        | tar xz -C /opt/  \
        && ln -s ${HADOOP_HOME}-$HADOOP_VERSION ${HADOOP_HOME} \
        && rm -r ${HADOOP_HOME}/share/doc

WORKDIR ${HADOOP_HOME}/share/hadoop

# Add additional jars to the Hadoop classpath
RUN curl -s -o tools/lib/log4j-1.2-api-2.17.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-1.2-api/2.17.2/log4j-1.2-api-2.17.2.jar && \
    curl -s -o tools/lib/log4j-api-2.17.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-api/2.17.2/log4j-api-2.17.2.jar && \
    curl -s -o tools/lib/log4j-core-2.17.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-core/2.17.2/log4j-core-2.17.2.jar && \
    curl -s -o tools/lib/log4j-slf4j18-impl-2.17.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-slf4j18-impl/2.17.2/log4j-slf4j18-impl-2.17.2.jar  && \
    curl -s -o tools/lib/postgresql.jar https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRES_CONNECTOR_VERSION}/postgresql-${POSTGRES_CONNECTOR_VERSION}.jar && \
    ln -s tools/lib/postgresql* common/lib/ && \
    ln -s tools/lib/hadoop-aws* common/lib/ && \
    ln -s tools/lib/aws-java-sdk* common/lib/ && \
    ln -s tools/lib/azure* common/lib/ && \
    ln -s tools/lib/hadoop-azure* common/lib/ && \
    chmod 0644 tools/lib/*


# Download the standalone hive metastore
RUN curl -s https://repo1.maven.org/maven2/org/apache/hive/hive-standalone-metastore/${HMS_VERSION}/hive-standalone-metastore-${HMS_VERSION}-bin.tar.gz \
        | tar xz -C /opt/ \
        && ln -s /opt/apache-hive-metastore-${HMS_VERSION}-bin ${METASTORE_HOME}

WORKDIR ${METASTORE_HOME}
RUN rm lib/log4j-* && \
    rm lib/guava-* && \
    ln -s ${HADOOP_HOME}/share/hadoop/tools/lib/log4j-* lib/ && \
    ln -s ${HADOOP_HOME}/share/hadoop/tools/lib/postgresql.jar lib/ && \
    ln -s ${HADOOP_HOME}/share/hadoop/common/lib/guava-27.0-jre.jar lib/ && \
    chmod 0644 lib/*

COPY conf/metastore-log4j2.properties conf
COPY conf/generate-conf.sh bin/generate-conf.sh
COPY entrypoint.sh bin/
COPY schema-tool.sh bin/
RUN chmod +x bin/entrypoint.sh bin/schema-tool.sh bin/generate-conf.sh

EXPOSE 9083
ENTRYPOINT ["bin/entrypoint.sh"]
