'''
Download the quijote.txt file from Internet to this folder
https://raw.githubusercontent.com/SparkBarcelona/libro/master/Capitulo3/quijote.txt
'''
import os, sys
# os.environ['SPARK_HOME'] = "opt/gerard/spark-2.0.0-bin-hadoop2.7"
# os.environ['JAVA_HOME'] = "/usr/lib/jvm/java-8-oracle"
#
# sys.path.append("/opt/gerard/spark-2.0.0-bin-hadoop2.7/python")
# sys.path.append("/opt/gerard/spark-2.0.0-bin-hadoop2.7/python/lib/py4j-0.10.1-src.zip")

from pyspark import SparkContext

sc = SparkContext(appName='FirstExample')
file = sc.textFile('/home/gerard/Repos/BigData-Masteam-UPC/week_2/quijote/quijote.txt', minPartitions = 4)  # optional parameter minPartitions
# and now show first lines and save as HDFS (Hadoo File System)
for line in file.take(20):
    print (line)
file.saveAsTextFile('QUIJOTE')
