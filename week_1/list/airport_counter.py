class AirportCounter:
    name = ''
    totals = 0
    take_offs = 0
    landings = 0

    def __init__(self, name):
        self.name = name

    def recompute_totals(self):
        self.totals = self.take_offs + self.landings

    def add_takeoff(self):
        self.take_offs += 1
        self.totals += 1

    def add_landing(self):
        self.landings += 1
        self.totals += 1

    def __eq__(self, item):
        return self.name == item

    def __str__(self):
        return self.name + "\t" + str(self.totals) + "\t" + str(self.landings) + "\t" + str(self.take_offs)

    def __repr__(self):
        return str(self) + "\n"
