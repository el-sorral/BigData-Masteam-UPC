#!/usr/bin/python

import sys
import getopt
import os
from PIL import Image  # pip install pillow
import numpy as np
import numpy

import csv


usage = 'generate.py -i <input_path> -o <output_path>'


def close_program():
    sys.exit(1)


def convert_image():
    pass


def convert_path(in_path, out_path):
    with open(out_path + "/data.csv", 'wb') as csv_file:
        wr = csv.writer(csv_file)
        for file_name in os.listdir(in_path):

            # print path to all subdirectories first.
            print("Convert image: " + in_path + "/" + file_name)
            number = int(file_name.split('.')[0][-1:])
            print("\tThe number is " + str(number))

            im = Image.open(in_path + "/" + file_name)

            grey_im = im.crop((155, 376, 561, 782)).convert("L").resize((8, 8))
            grey_im.save(out_path + "/" + file_name)

            # convert image to numpy array
            m = np.array(grey_im.getdata())  # linear data. Use reshape to N-dim
            m = numpy.round(16 * (m.max() - m) / (m.max() - m.min()))

            print("\tShape {}: data from {} to {}".format(m.shape, m.min(), m.max()))
            line = m.tolist()
            line.append(number)
            print("\t{}".format(line))

            wr.writerow(line)


def main(argv):
    # Get args
    in_path = None
    out_path = None
    try:
        opts, args = getopt.getopt(argv, "hi:o:", ["input=", "output="])
    except getopt.GetoptError:
        print(usage)
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print(usage)
            close_program()
        elif opt in ("-i", "--input"):
            in_path = arg
        elif opt in ("-o", "--output"):
            out_path = arg

    # Run the program
    if in_path is None or out_path is None:
        print("You must specify the folder.")
        print(usage)
        close_program()

    convert_path(in_path, out_path)


if __name__ == "__main__":
    main(sys.argv[1:])
