# -*- coding: utf-8 -*-
'''This module helps to create images by using bet, fast, betsurf.


Calıstırmak istediğiniz path'i vermeniz gerekiyor. Input klasörünün içine
yeni bir klasör yaratıp (BET ise BET adında, FAST ise FAST adında)
daha sonra scripti çalıştırın.

Useful Functions:

fetchFiles(path, suffix)
runFSLBET(command, args, files, suffix = '.hdr')
runFSLFAST(command, args, files, suffix)
bet(path)
betsurf(path)
fast(path)
betfast(path)

Author   : Osman Başkaya
e-mail   : osman.baskaya@computer.org
Date     : 2011, May 22
Licence  : GNU GENERAL PUBLIC LICENSE

Eksikler :
-> bet`in yerini kendi bulsun filan, onlar yok; machine-independent değil. import command 
-> time olayını ekle. Ne kadar sürmüş, bu process'''

import os
import sys
from time import time

#PATH = '/usr/share/fsl/4.1/bin/'
PATH = '/usr/bin/fsl4.1-'

fast_bin = PATH + 'fast'
bet_bin = PATH + 'bet'

def fetchFiles(path, suffix):
    os.chdir(path)
    workingDir = path
    rFiles = []
    files = os.listdir(workingDir)
    for f in files:
        if f.endswith(suffix):
            rFiles.append(f)
    return rFiles      

def runFSLBET(command, args, files, suffix = '.hdr'):
    for f in files:
        args[1] = f
        args[2] = f.replace(suffix, '_brain')
        #args[2] = "BETSURF/" + args[2] # for betsurf
        args[2] = "BET/" + args[2]
        p_id = os.fork()
        start = time()
        if p_id == 0: # child process.
            print "Processing BET: %s" % f
            os.execv(command, args)
        else:
            os.wait() # wait for completion of a child process.
        stop = time()
        minute = (stop - start) / 60
        second = (stop - start) % 60
        print "\tCompleted in %s min. %s sec." % (int(minute), int(second))
        print "\tOutput created on %s" % args[2]

def runFSLFAST(command, args, files, suffix = '_brain.nii.gz'):
    for f in files:
        args[-1] = f
        args[-2] = f.replace(suffix, '')
        args[-2] = "../FAST/" + args[-2]
        p_id = os.fork()
        start = time()
        if p_id == 0:
            print "Processing FAST: %s" % f
            os.execv(command, args)
        else:
            os.wait() # wait for completion of a child process.
        stop = time()
        minute = (stop - start) / 60
        second = (stop - start) % 60
        print "\tCompleted in %s min. %s sec." % (int(minute), int(second))
        print "\tOutput created on %s" % args[-2]

def bet(path, fractIntensity = '0.5'):
    
    args = ['', '','','-f', fractIntensity, '-g', '0'] #default args for bet.
    suffix = '.nii.gz'
    #suffix = '.hdr'
    files = fetchFiles(path, suffix)
    runFSLBET(bet_bin, args, files, suffix)
       

def betsurf(path):
    args = ['', '', '', '-A', '-f', '0.5', '-g', '0'] #default args for betsurf.
    suffix = '.nii.gz'
    #suffix = '.hdr'
    files = fetchFiles(path, suffix)
    runFSLBET(bet_bin, args, files, suffix)

def fast(path):
    args = ['', '-t', '1', '-n', '3', '-H', '0.1', '-I', '4', '-l',
            '20.0', '-o', '', ''] # default args for fast
    suffix = 'brain.nii.gz'
    files = fetchFiles(path, suffix)
    runFSLFAST(fast_bin, args, files, suffix)

def betfast(path):
    bet(path)
    fast(path)
    
def main():

    try:
        path = sys.argv[1]
        job = sys.argv[2]
    except IndexError:
        print "usage:", sys.argv[0], "[path]", "[bet | fast | betfast | betsurf] [,fractional_intensity]"
        exit(1)
    if job == "bet" :
        if (len(sys.argv) == 4):
            bet(path, sys.argv[3])
        else:
            bet(path)
    elif job == "betsurf":
        betsurf(path)
    elif job == "betfast":
        betfast(path)
    elif job == "fast":
        fast(path)
    else:
        print "usage:", sys.argv[0], "[path]", "[bet | fast | betfast | betsurf]"

    
if __name__ == '__main__':
    main()
