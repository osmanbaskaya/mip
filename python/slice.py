#! /usr/bin/python
# -*- coding: utf-8 -*-

__author__ = "Osman Baskaya"

"""
This module provides slice test and correlation score analysis.

"""
from itertools import repeat
import numpy as np
from scipy.stats import pearsonr


IHA = 2
HCA = 3
WHOLE = 4

#expert = [1,7,4,2,6,8,3,5] # for register-MNI-1mm
expert = [1,5,6,7,4,1,4,2,6,6,1,6,8,4,3,5,4,6,7,6,7,8,2,6,5,5,5,7,5]  # whole-MNI-1mm

expert = np.matrix(expert)


#DATASET = 'register-MNI-1mm.dat'
DATASET = 'whole.dat'

def read_datafile(filename, delimiter='\t'):
    with open(filename, 'r') as f:
        a = []
        for line in f.readlines():
            if line[0] != '#':
                a.append(line.strip().split(delimiter))
    return a

def preprocess_data(data):
    data_dict = dict()
    for e in data:
        key1, key2, val = e

        # type changing
        key1 = int(key1)
        key2 = int(key2)
        val = float(val)
        
        if key1 not in data_dict:
            vals = [val,]
            data_dict[key1] = {key2: vals}
        else:
            d = data_dict[key1]
            if key2 not in d:
                vals = [val,]
                d[key2] = vals
            else:
                vals = d[key2]
                vals.append(val)

    # value list becomes numpy.array
    for d in data_dict.itervalues():
        for k2, e in d.iteritems():
            e = np.array(e)
            d[k2] = e

    return data_dict

D = read_datafile(DATASET)
DATA = preprocess_data(D)

def create_window(n_slice, center=None, weight_type = 'linear'):
    

    if n_slice % 2 == 1:
        m = (n_slice - 1) / 2
    else:
        raise ValueError('Number of slice should be odd: {0}'.format(n_slice))


    if weight_type == 'linear':
        incr = 1.0 / (m+1)
        right = [1 - (m+1-i)*incr for i in xrange(1,m+1)]
        left = [1 - (i-m)*incr for i in xrange(m, n_slice)]
        right.extend(left)
        window = np.asarray(right) / sum(right)
        return window
    elif weight_type == 'uniform':
         return np.asarray(tuple(repeat(1.0 / n_slice, n_slice)))

    else:
        raise ValueError('Number of slice should be odd: {0}'.format(n_slice))

def evaluate_atrophy(window, interval, data=DATA, ind=HCA, eval_type='mean', f=None):
    # eval types = median. mean
    # ind = 2 or 3 | 2: IHA, 3:HCA
    b, e = interval # beginning and end
    s = len(window)

    for i in xrange(b, e-s+1):
        k = []
        # patient matrix creation
        for j in xrange(s):
            k.append(data[i+j][ind])
        
        m = np.matrix(k)
        #print m, '\n--------------------------'
        if eval_type == 'mean':
            atrophy = window * m
        elif eval_type == 'median':
            m.sort(axis=0) # rowlara gore
            med_ind = s / 2
            atrophy = m[med_ind, :]
        else:
            print "mean or median"
            exit()
        #print atrophy, '\n################'
        nan = np.isnan(atrophy)
        pred = atrophy[~nan].tolist()[0]
        actual = expert[~nan].tolist()[0]
        res = pearsonr(pred, actual)
        #print "({0}-{1}), size: {2}, {3}".format(i, i+j, len(pred), res[0])
        #print "{0},{1},{2},{3},{4}".format(i, i+j, len(pred), res[0], res[1])
        #print "{0},{1},{2},{3}".format(i, i+j, len(pred), res[0])
        if f is not None:
            f.write("{0},{1},{2},{3}\n".format(i, i+j, len(pred), res[0]))
        else:
            print "{0},{1},{2},{3}".format(i, i+j, len(pred), res[0])


def corr_test_IHA(filename, size, interval, data=DATA, w=None, e=None):

    with open('/home/tyr/Desktop/%s'% filename, 'w') as f:
        #f.write("#%s, %d, %d, %d, %s\n" % (filename, size, interval[0], interval[1], e))
        if w is None:
            w = create_window(size, weight_type= 'uniform')
        evaluate_atrophy(w, interval, ind=IHA, eval_type=e, f=f) 

def corr_test_HCA(filename, size, interval, data=DATA, w=None, e=None):
    with open('/home/tyr/Desktop/%s'% filename, 'w') as f:
        #f.write("#%s, %d, %d, %d, %s\n" % (filename, size, interval[0], interval[1], e))
        if w is None:
            w = create_window(size, weight_type='uniform')
        evaluate_atrophy(w, interval, ind=HCA, eval_type=e, f=f) 


def interval_test():

    #dataset = 'register-MNI-1mm.dat'
    #d = read_datafile(dataset)
    #data = preprocess_data(d)
    
    interval = (100, 150)
    size = 3
    e = 'median'

    corr_test_IHA('%s-IHA-%d-%s.txt' % (DATASET[:-4], size, e), size, interval, e=e)
    corr_test_HCA('%s-HCA-%d-%s.txt' % (DATASET[:-4], size, e), size, interval, e=e)

    e = 'mean'
    corr_test_IHA('%s-IHA-%d-%s.txt' % (DATASET[:-4], size, e), size, interval, e=e)
    corr_test_HCA('%s-HCA-%d-%s.txt' % (DATASET[:-4], size, e), size, interval, e=e)

    w = create_window(size, weight_type='linear')
    print w

    corr_test_IHA('%s-IHA-%d-%s-Weighted.txt' % (DATASET[:-4], size, e), size, interval, w=w, e=e)
    corr_test_HCA('%s-HCA-%d-%s-Weighted.txt' % (DATASET[:-4], size, e), size, interval, w=w, e=e)


def perf_corr_IHA(slices, eval_type, size=1, w=None, data=DATA, win_type='uniform'):
    
    if w is None:
        w = create_window(size, weight_type=win_type)

    eval_perf_atrophy(slices, w, data, eval_type, ind=IHA)

    
def perf_corr_HCA(slices, eval_type, size=1, w=None, data=DATA, win_type='uniform'):
    
    if w is None:
        w = create_window(size, weight_type=win_type)

    eval_perf_atrophy(slices, w, data, eval_type, ind=HCA)

def eval_perf_atrophy(slices, window, data, eval_type, ind=HCA, f=None):
    #TODO No need to this function. Update eval_atrophy function to be more general form.

    size = len(window)
    n_slices = (size-1) / 2


    patients = []
    for i, slice in enumerate(slices):
        k = []
        for j in xrange(-n_slices, n_slices+1):
            k.append(data[slice+j][ind][i])
        patients.append(k)

    m = np.matrix(patients)
    m = m.T
    #print 'Window is', window
    if eval_type == 'mean':
        atrophy = window * m
    elif eval_type == 'median':
        m.sort(axis=0) # rowlara gore
        med_ind = size / 2
        atrophy = m[med_ind, :]
    else:
        print "mean or median"
        exit()
    #print atrophy, '\n################'
    nan = np.isnan(atrophy)
    pred = atrophy[~nan].tolist()[0]
    actual = expert[~nan].tolist()[0]
    res = pearsonr(pred, actual)
    #print "({0}-{1}), size: {2}, {3}".format(i, i+j, len(pred), res[0])
    #print "{0},{1},{2},{3},{4}".format(i, i+j, len(pred), res[0], res[1])
    if f is not None:
        f.write("{0},{1},{2},{3}\n".format(i, i+j, len(pred), res[0]))
    else:
        print "\t{0},{1},{2}".format(size, len(pred), res[0])

def perfect_reg_test(region, data=DATA, eval_type='mean', size=1, win_type='uniform'):

    cent_slices = [134, 133, 130, 129, 130, 125, 132, 128] #central sulci
    if region == IHA:
        perf_corr_IHA(cent_slices, eval_type, size=size, win_type=win_type)
    elif region == HCA:
        perf_corr_HCA(cent_slices, eval_type, size=size, win_type=win_type)


def main():
    interval_test()


    # Perfect registration Tests
    #print 'median IHA'
    #for i in xrange(1, 10, 2):
        #perfect_reg_test(IHA, eval_type='median', size=i)
    #print 'median HCA'
    #for i in xrange(1, 10, 2):
        #perfect_reg_test(HCA, eval_type='median', size=i)
    #print 'mean IHA'
    #for i in xrange(1, 10, 2):
        #perfect_reg_test(IHA, eval_type='mean', size=i, win_type='uniform')
    #print 'mean HCA'
    #for i in xrange(1, 10, 2):
        #perfect_reg_test(HCA, eval_type='mean', size=i, win_type='uniform')

    #print 'linear IHA'
    #for i in xrange(1, 10, 2):
        #perfect_reg_test(IHA, eval_type='mean', size=i, win_type='linear')
    #print 'linear HCA'
    #for i in xrange(1, 10, 2):
        #perfect_reg_test(HCA, eval_type='mean', size=i, win_type='linear')

    
if __name__ == '__main__':
    main()


