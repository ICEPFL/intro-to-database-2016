import csv
import numpy as np
import io


def parser(file_name):
    with io.open(file_name, "r", encoding='latin1') as o:
        rows = o.readlines()

    count = 0
    output = []
    container = ()

    for ind, line in enumerate(rows):
            try:
                if ind%1000 == 0:
                    print ind

                if len(line) < 2:
                    continue

                overall = line.strip().split("\t")
                buf = overall[4].strip().split("+")
                buf2 = overall[9]
                # print buf2
                # print buf2[0]
                # print buf2[1:]
                
                if buf2 == '\N':
                    out2 = '\N' + '\t' + '\N'
                else:
                    out2 = buf2[0] + '\t' + str(float(buf2[1:]))
                
                if len(buf) == 1:
                    out = '\\N' + '\t' + buf[0] + '\t' + '\\N' + '\t' + '\\N'
                elif len(buf) == 2:
                    out = buf[0] + '\t' + buf[1] + '\t' + '\\N' + '\t' + '\\N'
                elif len(buf) == 3:
                    out = buf[0] + '\t' + buf[1] + '\t' + buf[2] + '\t' + '\\N'
                elif len(buf) == 4:
                    out = buf[0] + '\t' + buf[1] + '\t' + buf[2] + '\t' + buf[3]
                elif len(buf) == 0:
                    out = '\\N' + '\t' + '\\N' + '\t' + '\\N' + '\t' + '\\N'

                for j in range(0, len(overall)):
                    if j != 4 and j != 9:
                        container += (overall[j],)
                    elif j == 9:
                        container += (out2,)
                    else:
                        container += (out,)
                
                output.append(container)
                container = ()
            except BaseException:
                continue

    return count, output

def write_to_file(file_name, output):
    with io.open('publicationParsed.csv', 'w', encoding='utf-8') as f:
        out_str = "\n".join(map(lambda x: "\t".join(x), output))
        f.write(out_str)

if __name__ == '__main__':
    count, outcome = parser("publications.csv")
    write_to_file("publicationParsed.csv", outcome)
    




