#! /usr/bin/python
# -*- coding: utf-8 -*-

__author__ = "Osman Baskaya"
import os
from sys import argv

def make_lower():
    all_files = os.listdir('.')
    for item in all_files:
        os.rename(item, item.lower())

def rename(delimiter = '_brain', ):
    all_files = os.listdir('.')
    for item in all_files:
        new_name = item.split(delimiter)[0]
        extension = item.split('.')[1:]
        new_name = new_name + '.' + '.'.join(extension)
        if item != new_name:
            print "%s ---> %s" % (item, new_name)
        os.rename(item, new_name)

def main():

    try:
        directory = argv[1]
    except IndexError:
        print "\nusage: %s directory" % argv[0]
        print "example: %s /home/tyr/matlab/Data/checkbetsurf\n" % argv[0]
        exit()
        
    os.chdir(directory)
    make_lower()
    #rename() #betsurf
    rename('__seg') #fast

if __name__ == '__main__':
    main()

