# WEEK 1

## How To?:

If you are running linux shebang is added, so you can just invoke it as a script:

$ ./main.py ../datasets/traffic1day.exp2

## Conclusions:

### List
    - Slowest one. Requires searching in an unsorted list for a keyname (airport name). If it is not present, requires
        running through whole list

### Binary-Search for list insertion
    - Much quicker than List. Here in this case the insertion is done in a sorted way by either finding the position
        where the existing element is, or the position where the new element should be added. By using a binary algorithm
        (list is divided into to, get only the subset where element should be, divide again ... repeat this strategy)
    - This list is always sorted by name, so lookups for insertion will be much quicker

### Dictionary
    - Insertions are indexed by name, and the value is obtained just by doing a lookup using the name. This is the
        most performing option for this searches.


