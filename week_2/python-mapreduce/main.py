#!/usr/bin/python

import os
import psutil
import time
import sys


def main():
    t0 = time.time()
    splitted_file_lines = load_file()
    time_reading = time.time()
    result = mapreduce(splitted_file_lines)
    count = len(result)
    print_table(result)
    print "Total of flights", count
    print "Time of file processing", time_reading - t0
    print "Elapsed total time ", time.time() - t0
    print "Memory footprint", psutil.Process(os.getpid()).memory_info().vms / 1000, "Kb"


def load_file():
    filename = sys.argv[1]
    with open(filename, 'r') as f:
        return map(lambda l: l.split(";"), f.readlines())


def reduce_by_key(d, airport):
    if airport[0] in d:
        a = d[airport[0]]
        a[1] += airport[1]
        a[2] += airport[2]
        a[3] += airport[3]
    else:
        d[airport[0]] = airport
    return d


# [name, takeoff, arrival, totals]
def mapreduce(splitted):
    joined = reduce(lambda x, y: x + [[y[0], 1, 0, 1], [y[1], 0, 1, 1]], splitted, [])
    single_array = reduce(lambda x, y: reduce_by_key(x, y), joined, dict())
    return single_array


def get_totals(air_dict):
    def f(idx):
        return air_dict[idx][3]
    return f


def print_table(air_dict):
    print '%-15s %-15s %-15s %-15s' % ("AIRPORT NAME", "# TOTAL MOVEMENTS", "# TAKE OFFs", "# LANDINGS")
    for i in range(10):
        idx = max(air_dict, key=get_totals(air_dict))
        e = air_dict[idx]
        print '%-17s %-17i %-17i %-17i' % (e[0], e[3], e[1], e[2])
        del air_dict[idx]
        # print '%-15s %-15s %-15s %-15s' % ("AIRPORT NAME", "# TOTAL MOVEMENTS", "# TAKE OFFs", "# LANDINGS")
        # for e in ordered_result:
        #     print '%-17s %-17i %-17i %-17i' % (e[0], e[1]['takeoff'] + e[1]['landing'], e[1]['takeoff'], e[1]['landing'])


if __name__ == "__main__":
    main()
