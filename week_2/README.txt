# WEEK 1

## How To?:

If you are running linux shebang is added, so you can just invoke it as a script:

$ ./main.py ../datasets/traffic1day.exp2

## Conclusions:

### python-mapreduce
    - Python gives less functions to do on a map and reduce algorithm. So much more work must be added as
        writen functions
    - Does not require third party tools

### spark-mapreduce
    - Uses spark engine to perform the clustering and task management for Hadoop.
    - More suitable for large environments of data and clusters of processing hardware
    - For low datasize is slower due to the requirements of "starting" spark's engine and perform task distribution
    - Spark's map and reduce gives high level functions that simplify the way that data must be prepared/extracted

### spark-optimized
    - In theory should be the quickest one with really large datasets, because it is prepared to work in multithreaded
        environments where many tasks of map and reduce can be done separately


