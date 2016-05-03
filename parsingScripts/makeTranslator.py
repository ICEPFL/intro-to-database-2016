import csv
import numpy as np

def makeTranslator(filename, numRows):
    lst = [None]
    count = 0

    for i, line in enumerate(open(filename, 'r')):
    	if i%1000 == 0:
    		print i
    	tup = ()
    	if len(line)<2:
    		continue

        overall = line.strip().split('	')
        if (overall[2] != '\\N') and (len(overall[2]) > 7):
            count += 1
            tup = tup + (int(overall[0]),) + (overall[2],)
            lst = lst + [tup]
        else:
            continue

    print '---------------- finish loading data to Set! -----------------------'
    return count, lst

count, out = makeTranslator('titlesrem.csv', 1136515)
print count

with open('makeTranslator.csv','w') as f:
     writer = csv.writer(f, delimiter = ',')
     for row in out:
         writer.writerow([row])
