import sys
import csv

from airport_counter import AirportCounter

file = sys.argv[1]

print 'Opening file:', file

airport_list = []


def add_takeoff(airport_name):
    if airport_name in airport_list:
        i = airport_list.index(airport_name)
        airport_list[i].add_takeoff()
    else:
        airport = AirportCounter(airport_name)
        airport.add_takeoff()
        airport_list.append(airport)
    return


def add_landing(airport_name):
    if airport_name in airport_list:
        i = airport_list.index(airport_name)
        airport_list[i].add_landing()
    else:
        airport = AirportCounter(airport_name)
        airport.add_landing()
        airport_list.append(airport)
    return


def get_airport_key(airport_counter):
    return airport_counter.totals


with open(file, 'rb') as csvfile:
    reader = csv.reader(csvfile, delimiter=';')
    for row in reader:
        add_takeoff(str(row[0]))
        add_landing(str(row[1]))

    airport_list.sort(key=get_airport_key, reverse=True)

    print "AIRPORT NAME \t # TOTAL MOVEMENTS \t # TAKE OFFs \t # LANDINGS"
    for x in airport_list[:10]:
        print "%s \t %d \t %d \t %d" % (x.airport_name, x.totals, x.take_offs, x.landings)
