import os
from sys import argv


def make_lower():
    all_files = os.listdir('.')
    for item in all_files:
        os.rename(item, item.lower())

def rename_with_sulcal(delimiter = '_'):
    all_files = os.listdir('.')
    for item in all_files:
        new_name = item.split(delimiter)[0] + '_sulcal.png'
        if item != new_name:
            print "%s ---> %s" % (item, new_name)
        os.rename(item, new_name)


def main():
    try:
        delimiter, directory = argv[1], argv[2]
    except IndexError:
        print "\nusage: %s [delimiter [directory]]" % argv[0]
        print "example: %s _ /home/tyr/matlab/Data/checkbetsurf\n" % argv[0]
        exit()
    os.chdir(directory)
    make_lower()
    rename_with_sulcal(delimiter)

if __name__ == '__main__':
    main()



