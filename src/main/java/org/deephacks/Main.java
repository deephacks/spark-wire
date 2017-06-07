package org.deephacks;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.serializer.JavaSerializer;

import java.util.Arrays;

public class Main {
  public static void main(String[] args) {
    JavaSparkContext ctx = new JavaSparkContext("local", "",
      new SparkConf().set("spark.serializer", JavaSerializer.class.getName()));
    ctx.parallelize(Arrays.asList(1, 2, 3))
      .map(i -> new Request.Builder().requestId(i).build())
      .repartition(3)
      .collect().forEach(System.out::println);
  }
}
