FROM apache/zeppelin:0.8.1

ARG version='2.4.2'
ENV SPARK_HOME=/opt/spark

RUN mkdir -p ${SPARK_HOME}/work  ${SPARK_HOME}/conf && \
	file=spark-${version}-bin-hadoop2.7.tgz && \
	wget --quiet https://archive.apache.org/dist/spark/spark-${version}/${file} && \
	tar -xzf spark-${version}-bin-hadoop2.7.tgz && \
	mv spark-${version}-bin-hadoop2.7/* ${SPARK_HOME} && \
    wget --quiet \
        https://repo1.maven.org/maven2/io/delta/delta-core_2.12/0.5.0/delta-core_2.12-0.5.0.jar && \
    wget --quiet \
        https://repo1.maven.org/maven2/org/datasyslab/geospark/1.3.1/geospark-1.3.1.jar && \
    wget --quiet \
        https://repo1.maven.org/maven2/org/datasyslab/geospark-sql_2.3/1.3.1/geospark-sql_2.3-1.3.1.jar && \
    wget --quiet \
        https://repo1.maven.org/maven2/org/datasyslab/geospark-viz_2.3/1.3.1/geospark-viz_2.3-1.3.1.jar && \
    mv geospark*.jar ${SPARK_HOME}/jars/ && \
    mv delta*.jar ${SPARK_HOME}/jars/

EXPOSE 8080
