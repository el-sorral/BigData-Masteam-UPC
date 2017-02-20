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
    for airport in air_lst:
        if airport.name == ap_name:
            airport.add_takeoff()
            return
    air_lst.append(AirportCounter.new_takeoff(ap_name))
    return


def add_landing(ap_name):
    for airport in air_lst:
        if airport.name == ap_name:
            airport.add_landing()
            return
    air_lst.append(AirportCounter.new_landing(ap_name))
    return


with open(filename, 'r') as f:
    for line in f:
        line_split = line.split(';')
        add_takeoff(line_split[0])
        add_landing(line_split[1])
    time_reading = time.time()

total = len(air_lst)

print '%-15s %-15s %-15s %-15s' % ("AIRPORT NAME", "# TOTAL MOVEMENTS", "# TAKE OFFs", "# LANDINGS")
for i in range(10):
    idx = max(range(len(air_lst)), key=lambda j: air_lst[j].totals)
    print air_lst[idx]
    air_lst.remove(air_lst[idx])

print "Total of flights", total
print "Time of file processing", time.time() - time_reading
print "Elapsed total time ", time.time() - t0
print "Memory footprint", psutil.Process(os.getpid()).memory_info().vms / 1000, "Kb"
