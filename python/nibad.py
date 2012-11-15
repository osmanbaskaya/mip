#! /usr/bin/python
# -*- coding: utf-8 -*-

__author__ = "Osman Baskaya"



def read_data(filename, delimiter='\t\t'):
    with open(filename, 'r') as f:
        a = []
        for line in f.readlines():
            a.append(line.strip().split(delimiter))
    print a[1]
    return a

def preprocess_data(data):
    new_data = []
    for e in data:
        e.insert(1, e[0][-1])
        e[0] = e[0][:3]
        e[2:] = map(float, e[2:])
        new_data.append(e)
    return new_data

def create_volume_file(data_dict):
    f = open('volume_results.txt', 'w')
    for d in sorted(data_dict):
        res = data_dict[d]
        whole, lateral, hipL, hipR = res['A']
        for timepoint in sorted(res):
            result = []
            result.append(d)
            result.append(timepoint)
            
            w1, lat1, hipL1, hipR1 = res[timepoint]
            new = []

            
            if whole < w1:
                new.append(whole)
            else:
                new.append(w1)

            if lateral > lat1:
                new.append(lateral)
            else:
                new.append(lat1)

            if hipL < hipL1:
                new.append(hipL)
            else:
                new.append(hipL1)

            if hipR < hipR1:
                new.append(hipR)
            else:
                new.append(hipR1)

            res[timepoint] = new

            result.extend(res[timepoint])
            result=map(str, result)
            f.write(','.join(result))
            f.write('\n')
    f.close()
    return data_dict

def create_atrophy_file(data_dict):
    f = open('atrophy_result.txt', 'w')
    from itertools import permutations
    for d in sorted(data_dict.keys()):
        m = sorted(data_dict[d].keys())
        
        #c = list(permutations(m, 2))
        #print d, c, len(c), len(m)
        
        for p1, p2 in permutations(m, 2):
            res = []
            res.append(d)
            res.append(p1)
            res.append(p2)
            wh1, lt1, hipoL1, hipoR1 = data_dict[d][p1]
            wh2, lt2, hipoL2, hipoR2 = data_dict[d][p2]
            res.extend([wh1-wh2, lt1-lt2, hipoL1 - hipoL2, hipoR1 - hipoR2])
            res = map(str, res)
            f.write(','.join(res))
            f.write('\n')
    f.close()
    return data_dict

def main():
    data = read_data('volumes_orig.txt')
    data = preprocess_data(data)
    data_dict = dict()
    for e in data:
        key1 = e[0]
        key2 = e[1]
        if key1 not in data_dict:
            data_dict[key1] = {key2: e[2:]}
        else:
            d = data_dict[key1]
            if key2 not in d:
                d[key2] = e[2:]

    #create_volume_file(data_dict)
    create_atrophy_file(data_dict)
    





if __name__ == '__main__':
    main()

