#!/usr/bin/python
import sys
import time
import psutil, os

from airport_counter import AirportCounter

t0 = time.time()

filename = sys.argv[1]

air_dict = dict()


def add_takeoff(airport_name):
    if airport_name in air_dict:
        air_dict[airport_name].add_takeoff()
    else:
        airport = AirportCounter(airport_name)
        airport.add_takeoff()
        air_dict[airport_name] = airport
    return


def add_landing(airport_name):
    if airport_name in air_dict:
        air_dict[airport_name].add_landing()
    else:
        airport = AirportCounter(airport_name)
        airport.add_landing()
        air_dict[airport_name] = airport
    return


with open(filename, 'r') as f:
    for line in f:
        line_split = line.split(';')
        add_takeoff(line_split[0])
        add_landing(line_split[1])
    time_reading = time.time()


def get_totals(a):
    return air_dict[a].totals

total = len(air_dict)

print '%-15s %-15s %-15s %-15s' % ("AIRPORT NAME", "# TOTAL MOVEMENTS", "# TAKE OFFs", "# LANDINGS")
for i in range(10):
    idx = max(air_dict, key=get_totals)
    print air_dict[idx]
    del air_dict[idx]

print "Total of flights", total
print "Time of file processing", time.time() - time_reading
print "Elapsed total time ", time.time() - t0
print "Memory footprint", psutil.Process(os.getpid()).memory_info().vms / 1000, "Kb"
