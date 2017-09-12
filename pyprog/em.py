#!/usr/bin/env python
# -*- coding: utf-8 -*-
# przykłady z książki https://leanpub.com/pyprog

import sys
import csv

def doit_file(filename):
  csvfile=open(filename)
  fileout = open('maile.txt','w')
  for row in csv.reader(csvfile, delimiter=';'):
    fileout.write('%s %s<%s>\n' % (row[0],row[1],row[2]))
  fileout.close()


def doit_std():
  for row in csv.reader(sys.stdin, delimiter=';'):
    print('%s %s<%s>' % (row[0],row[1],row[2]))


if __name__ == "__main__":
  if len(sys.argv)>1:
    doit_file(sys.argv[1])
  else:
    doit_std()
