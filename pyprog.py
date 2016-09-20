# -*- coding: utf-8 -*-
#
# przykłady z książki https://leanpub.com/pyprog
#
# Copyright (c) 2016, Galicea <fundacja@galicea.org>
# All rights reserved.
# License FreeBSD: see license.txt for details.


def objects():
  print('123'.replace('2',"a"))
  n=1
  print(n.__class__)
  print(n.__str__)
  r=1.0
  print(r.__class__)

def sort():
  a=[1,5,4,2,0]
  a.sort()
  print(a)
  print(a.sort())
  
def multiplication_table():
  # tabliczka mnożenia
  cyfry=(0,1,2,3,4,5,6,7,8,9)
  for a in cyfry:
    for b in cyfry:
      print('%s x %s = %s' % (a,b,a*b))

def expression():
  length = 5
  breadth = 2
  area = length * breadth
  print(u'Powierzchnia prostokąta = %s' % area)
  print(u'Obwód = %s' % (2 * (length + breadth)) )
  perimeter = 2 * (length + breadth)
  print(u'Obwód = %s' % perimeter )
  
import csv
import numpy

def mediana():
  ages=[]
  with open('data.csv') as csvfile:
    readCSV = csv.reader(csvfile, delimiter=';')
    for row in readCSV:
      ages.append(int(row[2]))
  m=numpy.median(ages)
  print(m)

def i_for():
  for i in range(1, 5):
    print(i)
  else:
    print('Zrobione!')

def using_list():
  # Lista zakupów
  shoplist = ['jabłka', 'mango', 'marchewka', 'banany']
  print(u'Mam %s rzeczy do kupienia. \nSą to:' % len(shoplist))
  for item in shoplist:
    print(item),
# w Pythinie 3.x:    print(item, end=' ')
  print(u'\nDla sąsiadki kupuję jeszcze ryż.')
  shoplist.append('rice')
  print(u'pełna lista zakupów to obecnie %s' % shoplist)

  print('Posortowana lista:')
  shoplist.sort()
  print(shoplist)

  print(u'Skreślam pierwszy element, bo mam mało pieniędzy: %s' % shoplist[0])
  olditem = shoplist[0]
  del shoplist[0]
  print(u'Zapamiętam, że nie kupiłem: %s' % olditem)
  print(u'Ostateczna lista zakupów: %s' % shoplist)
  

def using_tuple():
  zoo = ('python', 'elephant', 'penguin')
  print('Ilość zwierząt w ZOO =%s' % len(zoo))
  new_zoo = 'monkey', 'camel', zoo
  print(u'W nowym ZOO są zwierzęta:')
  print(new_zoo)
  print(u'razem %s miejsca' %  len(new_zoo))
  print(u'Zwierzęta nabyte ze starego zoo:')
  print(new_zoo[2])
  print(u'Ostatnie zwierzę ze starego zoo to %s' % new_zoo[2][2])
  print u'Ilość zwierząt w nowym zoo: ', len(new_zoo)-1+len(new_zoo[2])
  
def using_dict():
  # 'ab' to krótka lista adresowa
  ab = {
    'Swaroop': 'swaroop@swaroopch.com',
    'Larry': 'larry@wall.org',
    'Matsumoto': 'matz@ruby-lang.org',
    'Spammer': 'spammer@hotmail.com'
  }
  print("Adres Swaroop'a to", ab['Swaroop'])
  # Usuwanie pary z listy
  del ab['Spammer']
  
  print('Ilość kontaktów w liście: {}\n'.format(len(ab)))
  for name, address in ab.items():
    print('Adres {} to {}'.format(name, address))
  # dodanie pary
  ab['Guido'] = 'guido@python.org'
  if 'Guido' in ab:
    print("\nAdres Guido'to", ab['Guido'])
  
def using_set():
  bri = set(['brazil', 'russia', 'india'])
  print('india' in bri)
  bric = bri.copy()
  bric.add('china')
  print('BRI='); print(bri)
  print('BRIc=');print(bric)
  print('BRI podzbiorem BRIc?')
  print(bric.issuperset(bri))
  bri.remove('russia')
  print(bric)
  print(bri & bric)
  bric.intersection(bri)
  print(bric)
 


if __name__ == "__main__":
  ex=36
  if ex==11:
    objects()
  elif ex==12:
    sort()
  elif ex==13:
    multiplication_table()
  elif ex==21:
    expression()
  elif ex==31:
    mediana()
  elif ex==32:
    i_for()
  elif ex==33:
    using_list()
  elif ex==34:
    using_tuple()
  elif ex==35:
    using_dict()
  elif ex==36:
    using_set()