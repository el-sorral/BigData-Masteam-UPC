import os
import psutil

import time

from pyspark import SparkContext, SparkConf


# def split_lines(l):
#     line_split = l.split(";")
#     return [(line_split[0], 'takeoff'), (line_split[1], 'landing')]


def join_tupples(v1, v2):
    v1["takeoff"] += v2["takeoff"]
    v1["landing"] += v2["landing"]
    return v1


def main():
    rdd_file = load_file()
    t0 = time.time()
    result = mapreduce(rdd_file)
    first_ten_airports = result.takeOrdered(10, key=lambda x: -(x[1]['takeoff'] + x[1]['landing']))
    print_table(result.count(), first_ten_airports, t0)


def load_file():
    sc = SparkContext(appName="Top10Airports")
    return sc.textFile("/home/gerard/Repos/BigData-Masteam-UPC/Top10Airports/datasets/traffic1week.exp2",
                       minPartitions=7)


def mapreduce(rdd_file):
    airport_list = rdd_file.map(lambda l: l.split(";"))
    airport_list = airport_list.flatMap(lambda l: [(l[0], {'takeoff':1,'landing':0}), (l[1], {'takeoff':1,'landing':0})])
    return airport_list.reduceByKey(join_tupples)


def print_table(total_count, ordered_result, t0):
    print '%-15s %-15s %-15s %-15s' % ("AIRPORT NAME", "# TOTAL MOVEMENTS", "# TAKE OFFs", "# LANDINGS")
    for e in ordered_result:
        print '%-17s %-17i %-17i %-17i' % (e[0], e[1]['takeoff'] + e[1]['landing'], e[1]['takeoff'], e[1]['landing'])
    print "Total of flights", total_count
    print "Elapsed total time ", time.time() - t0
    print "Memory footprint", psutil.Process(os.getpid()).memory_info().vms / 1000, "Kb"


if __name__ == "__main__":
    main()
