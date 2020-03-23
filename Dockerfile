FROM openjdk:8-alpine3.8
## Spark standalone mode Dockerfile
#

ARG version='2.4.2'
ARG release='1.0.0'
# ARG GIT_HASH
# ARG DATE_BUILD
# ARG BRANCH


LABEL com.pacofvf.spark.vendor=pacofvf \
      com.pacofvf.spark.version=$version \
      com.pacofvf.spark.release=$release

# ENV BRANCH=${BRANCH}
# ENV GIT_HASH=${GIT_HASH}
# ENV DATE_BUILD=${DATE_BUILD}

ENV SPARK_HOME=/spark \
    SPARK_PGP_KEYS="6EC5F1052DF08FF4 DCE4BFD807461E96"

RUN adduser -Ds /bin/bash -h ${SPARK_HOME} spark && \
    apk add --no-cache bash tini libc6-compat linux-pam krb5 krb5-libs && \
# download dist
    apk add --virtual .deps --no-cache curl tar gnupg && \
    cd /tmp && export GNUPGHOME=/tmp && \
    file=spark-${version}-bin-hadoop2.7.tgz && \
    curl --remote-name-all -w "%{url_effective} fetched\n" -sSL \
        https://archive.apache.org/dist/spark/spark-${version}/${file} && \
#    gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys ${SPARK_PGP_KEYS} && \
#    gpg --batch --verify ${file}.asc ${file} && \
# create spark directories
    mkdir -p ${SPARK_HOME}/work ${SPARK_HOME}/conf && chown spark:spark ${SPARK_HOME}/work && \
    tar -xzf ${file} --no-same-owner --strip-components 1 && \
    mv bin data examples jars sbin ${SPARK_HOME} && \
    curl --remote-name-all -w "%{url_effective} fetched\n" -sSL \
        https://repo1.maven.org/maven2/io/delta/delta-core_2.12/0.5.0/delta-core_2.12-0.5.0.jar && \
    curl --remote-name-all -w "%{url_effective} fetched\n" -sSL \
        https://repo1.maven.org/maven2/org/datasyslab/geospark/1.3.1/geospark-1.3.1.jar && \
    curl --remote-name-all -w "%{url_effective} fetched\n" -sSL \
        https://repo1.maven.org/maven2/org/datasyslab/geospark-sql_2.3/1.3.1/geospark-sql_2.3-1.3.1.jar && \
    curl --remote-name-all -w "%{url_effective} fetched\n" -sSL \
        https://repo1.maven.org/maven2/org/datasyslab/geospark-viz_2.3/1.3.1/geospark-viz_2.3-1.3.1.jar && \
    mv *.jar ${SPARK_HOME}/jars/ && \
# cleanup
    apk --no-cache del .deps && ls -A | xargs rm -rf

COPY entrypoint.sh /
COPY spark-env.sh ${SPARK_HOME}/conf/

WORKDIR ${SPARK_HOME}/work
ENTRYPOINT [ "/entrypoint.sh" ]

# Specify the User that the actual main process will run as
USER spark:spark
