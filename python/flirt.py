#! /usr/bin/python
# -*- coding: utf-8 -*-

__author__ = "Osman Baskaya"

from itertools import product, repeat
from os import listdir


#cmd = """/usr/share/fsl/4.1/bin/flirt -in
#/home/tyr/Documents/AllOrganized/Registration/ref_images/turgut.hdr -ref
#/usr/share/data/fsl-mni152-templates/MNI152_T1_0.5mm.nii.gz -out
#/home/tyr/Desktop/turgut.nii.gz -omat /home/tyr/Desktop/turgut.mat -bins 256
#-cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12
#-interp trilinear"""

#ref dataset
#dataset = ['alidemir', 'baharpelin', 'erdalayhan', 'MahirErburhan', 'NesrinIrgi',
#'OzlemAliYilmaz_1', 'turgut', 'TurkanGencoglu', 'xturgut']

INPUT_PATH = '/home/tyr/Documents/AllOrganized/Registration/ref_images'
#DEPLOY_PATH = '/home/tyr/Documents/AllOrganized/FlirtRes/'

REF = ['0.5', '1'] # 0.5mm and 1.00mm reference images
CMD = """fsl4.1-flirt -in /home/tyr/Documents/AllOrganized/Registration/ref_images/%s -ref /usr/share/data/fsl-mni152-templates/MNI152_T1_%smm.nii.gz -out /home/tyr/Documents/AllOrganized/FlirtRes/%smm/%s.nii.gz -omat /home/tyr/Documents/AllOrganized/FlirtRes/%smm/%s.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 -interp trilinear"""


def get_files(path = INPUT_PATH, extension='hdr'):
    filenames = listdir(path)
    return [filename for filename in filenames if extension in filename]

def run_command(cmd=CMD):
    from os import system
    print '\tProcessing...'
    system(cmd)
    print '\tDone.'

def main():
    filenames = get_files()
    for e in product(filenames, REF):
        print e
        arguments = [i for i in repeat(e[0], 3)]
        arguments.insert(1, e[1])
        arguments.insert(1, e[1])
        arguments.insert(4, e[1])
        #print arguments
        cmd = CMD % tuple(arguments)
        #print cmd
        run_command(cmd)

if __name__ == '__main__':
    main()

