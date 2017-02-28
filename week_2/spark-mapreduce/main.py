#!/usr/bin/python

import os
import psutil
import time

import sys

from pyspark import SparkContext


def split_lines(l):
    line_split = l.split(";")
    return [(line_split[0], {'takeoff': 1, 'landing': 0}), (line_split[1], {'takeoff': 0, 'landing': 1})]


def join_tupples(v1, v2):
    v1["takeoff"] += v2["takeoff"]
    v1["landing"] += v2["landing"]
    return v1


def main():
    rdd_file = load_file()
    t0 = time.time()
    result = mapreduce(rdd_file)
    first_ten_airports = result.takeOrdered(10, key=lambda x: -(x[1]['takeoff'] + x[1]['landing']))
    print_table(first_ten_airports)
    print "Total of flights", result.count()
    print "Elapsed total time ", time.time() - t0
    print "Memory footprint", psutil.Process(os.getpid()).memory_info().vms / 1000, "Kb"


def load_file():
    filename = sys.argv[1]
    sc = SparkContext(appName="Top10Airports")
    return sc.textFile(filename, minPartitions=4)


def mapreduce(rdd_file):
    airport_list = rdd_file.flatMap(split_lines)
    return airport_list.reduceByKey(join_tupples)


def print_table(ordered_result):
    print '%-15s %-15s %-15s %-15s' % ("AIRPORT NAME", "# TOTAL MOVEMENTS", "# TAKE OFFs", "# LANDINGS")
    for e in ordered_result:
        print '%-17s %-17i %-17i %-17i' % (e[0], e[1]['takeoff'] + e[1]['landing'], e[1]['takeoff'], e[1]['landing'])


if __name__ == "__main__":
    main()
