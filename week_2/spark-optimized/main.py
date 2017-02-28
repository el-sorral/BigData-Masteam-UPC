#!/usr/bin/python

import os
import psutil

import time

import sys

from pyspark import SparkContext, SparkConf


def main():
    file = load_file()
    t0 = time.time()
    flight_data = file.map(lambda l: l.split(";"))

    origin = flight_data.map(lambda x: (x[0], [1, 0, 1])).reduceByKey(
        lambda x, y: [x[0] + y[0], x[1] + y[1], x[2] + y[2]])

    destination = flight_data.map(lambda x: (x[1], [0, 1, 1])).reduceByKey(
        lambda x, y: [x[0] + y[0], x[1] + y[1], x[2] + y[2]])

    result = origin.union(destination).reduceByKey(
        lambda o, d: [o[0] + d[0], o[1] + d[1], o[2] + d[2]])

    # print result.take(5)

    # result = mapreduce(rdd_file)
    first_ten_airports = result.takeOrdered(10, key=lambda x: -(x[1][2]))
    print_table(first_ten_airports)
    print "Total of flights", result.count()
    print "Elapsed total time ", time.time() - t0
    print "Memory footprint", psutil.Process(os.getpid()).memory_info().vms / 1000, "Kb"


def load_file():
    filename = sys.argv[1]
    sc = SparkContext(appName="Top10Airports")
    return sc.textFile(filename, minPartitions=4)


def print_table(ordered_result):
    print '%-15s %-15s %-15s %-15s' % ("AIRPORT NAME", "# TOTAL MOVEMENTS", "# TAKE OFFs", "# LANDINGS")
    for e in ordered_result:
        print '%-17s %-17i %-17i %-17i' % (e[0], e[1][2], e[1][0], e[1][1])


if __name__ == "__main__":
    main()
