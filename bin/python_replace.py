#!/usr/bin/env python
import sys
import shutil

'''
input:
sys.argv[1] : Enter file name
sys.argv[2] : Enter a string to be replaced
sys.argv[3] : Enter a string to be added
sys.argv[4] : Enter the name of a new file
'''

shutil.copy(sys.argv[1], sys.argv[4], follow_symlinks=True)
with open(sys.argv[4], 'r') as infile:
    file = infile.read()
file = file.replace(sys.argv[2], sys.argv[3])
with open(sys.argv[4], 'w') as ofile:
    ofile.write(file)
