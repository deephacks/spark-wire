#!/usr/bin/env bash

if [ "$#" -lt 2 ]; then
    echo "Usage: delta_spark_submit.sh <class> <jar> [<args>]"
    echo "  class:  name of main class"
    echo "  jar:    path to jar-file"
    echo "  args:   arguments"
    exit 1
fi

export HADOOP_CONF_DIR=/etc/hadoop/conf
export SPARK_HOME=/usr/local/spark
export SPARK_VERSION="1.6.0"
export HADOOP_VERSION="2.7.1"
export HDP_VERSION=${HDP_VERSION:-"2.4.0.0-169"}
export SPARK_YARN_JAR="hdfs://hdpcluster/jars/spark-assembly-${SPARK_VERSION}.${HDP_VERSION}-hadoop${HADOOP_VERSION}.${HDP_VERSION}.jar"

if [ -z ${SPARK_EXECUTOR_CORES+x} ]; then
  SPARK_EXECUTOR_CORES=10;
fi

if [ -z ${SPARK_EXECUTOR_MEMORY+x} ]; then
  SPARK_EXECUTOR_MEMORY=10G;
fi

class="$1"
jar="$2"

shift
shift

app_name="$class $*"

exec $SPARK_HOME/bin/spark-submit \
  --conf "spark.driver.extraJavaOptions=-Dhdp.version=$HDP_VERSION" \
  --conf "spark.yarn.am.extraJavaOptions=-Dhdp.version=$HDP_VERSION" \
  --conf "spark.yarn.maxAppAttempts=1" \
  --conf "spark.yarn.jar=$SPARK_YARN_JAR" \
  --conf "spark.executor.memory=$SPARK_EXECUTOR_MEMORY" \
  --conf "spark.executor.cores=$SPARK_EXECUTOR_CORES" \
  --master local[8] \
  --verbose \
  --name "$app_name" \
  --class "$class" \
  "$jar" $*

