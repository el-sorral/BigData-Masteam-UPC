#!/usr/bin/python
import sys
import time
import psutil
import os
import resource

from airport_counter import AirportCounter

t0 = time.time()

filename = sys.argv[1]

air_lst = list()


def add_takeoff(airport_name):
    for airport in air_lst:
        if airport.name == airport_name:
            airport.add_takeoff()
            return
    airport = AirportCounter(airport_name)
    airport.add_takeoff()
    air_lst.append(airport)
    return


def add_landing(airport_name):
    for airport in air_lst:
        if airport.name == airport_name:
            airport.add_landing()
            return
    airport = AirportCounter(airport_name)
    airport.add_landing()
    air_lst.append(airport)
    return


with open(filename) as f:
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
info = psutil.Process(os.getpid()).memory_info().rss
print "Memory footprint", info / 1000, "Kb"
