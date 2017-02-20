#!/usr/bin/python
import sys
import time
import psutil
import os

from airport_counter import AirportCounter

t0 = time.time()

filename = sys.argv[1]

air_lst = list()


def add_takeoff(ap_name):
    idx = bisect_right(air_lst, ap_name)
    if idx is not 0 and air_lst[idx - 1].name == ap_name:
        air_lst[idx - 1].add_takeoff()
    else:
        air_lst.insert(idx, AirportCounter.new_takeoff(ap_name))
    return


def add_landing(ap_name):
    idx = bisect_right(air_lst, ap_name)
    if idx is not 0 and air_lst[idx - 1].name == ap_name:
        air_lst[idx - 1].add_landing()
    else:
        air_lst.insert(idx, AirportCounter.new_landing(ap_name))
    return


def bisect_right(a, x, lo=0, hi=None):
    """Return the index where to insert item x in list a, assuming a is sorted.

    The return value i is such that all e in a[:i] have e <= x, and all e in
    a[i:] have e > x.  So if x already appears in the list, a.insert(x) will
    insert just after the rightmost x already there.

    Optional args lo (default 0) and hi (default len(a)) bound the
    slice of a to be searched.
    """

    if lo < 0:
        raise ValueError('lo must be non-negative')
    if hi is None:
        hi = len(a)
    while lo < hi:
        mid = (lo + hi) // 2
        if x < a[mid].name:
            hi = mid
        else:
            lo = mid + 1
    return lo


with open(filename, 'r') as f:
    for line in f:
        line_split = line.split(';')
        add_takeoff(line_split[0])
        add_landing(line_split[1])
    time_reading = time.time()

print("AIRPORT NAME \t # TOTAL MOVEMENTS \t # TAKE OFFs \t # LANDINGS")
for i in range(10):
    idx = max(range(len(air_lst)), key=lambda j: air_lst[j].totals)
    print air_lst[idx]
    air_lst.remove(air_lst[idx])

print "Time processing", time.time() - time_reading
print "Elapsed total time ", time.time() - t0
print "Memory footprint", psutil.Process(os.getpid()).memory_info().vms / 1000, "Kb"
