# -*- coding: utf-8 -*-
# przykłady z książki https://leanpub.com/pyprog


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
#import numpy

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
  
def ex_if():
  number = 23
  guess = int(input('Podaj liczbę całkowitą: '))
  if guess == number:
    # Blok warunkowy zaczyna się w tym miejscu
    print('Gartulacje, zgadłeś liczbę.')
    print('(ale niestety nie ma żadnej nagrody!)')
    # Tu kończy się blok warunkowy
  elif guess < number:
    # Drugi blok 
    print('Nie, liczba powinna być większa')
    # Koniec drugiego bloku ...
  else:
    print('Nie, liczba powinna być mniejsza')
    # ten blok zostanie wykonany tylko gdy guessed > number
  print('Koniec')
  # Ostatnia instrukcja (print) jest wykonywana zawsze - 
  # po zakończeniu instrukcji warunkowej  
  
def ex_while():
  number = 23
  running = True
  while running:
    guess = int(input('Podaj liczbę całkowitą: '))
    if guess == number:
      # Blok warunkowy zaczyna się w tym miejscu
      print('Gartulacje, zgadłeś liczbę.')
      print('(ale niestety nie ma żadnej nagrody!)')
      # Tu kończy  się blok warunkowy. Konczy se także petla!
      running = False
    elif guess < number:
      # Drugi blok 
      print('Nie, liczba powinna być większa')
      # Koniec drugiego bloku ...
    else:
      print('Nie, liczba powinna być mniejsza')
      # ten blok zostanie wykonany tylko gdy guessed > number
  else:
    print('Koniec')
 
def ex_continue():
  points = 7 # pierwsza liczba jest ukryta
  counter = points # suma punktow
  print('Możesz zakończyć sumowanie wpisując 0')
  while counter < 21 and points != 0:
    points = input('Wpisz liczbę od 0 do 12: ')
    if points<0 or points>12:
        print('Od 0 do 12!')
        continue
    counter+= points # dodanie liczby
  print('Suma=%s' % counter)

def ex_break():
  points = 4 # pierwsza liczba jest ukryta
  counter = points # suma punktow
  print('Możesz zakończyć sumowanie wpisując 0')
  while counter < 21:
    points = input('Wpisz liczbę od 0 do 12: ')
    if points<0 or points>12:
        print('Od 0 do 12!')
        continue
    if points==0: # kończymy grę
      break
    counter += points # dodanie liczby
    if counter>21: # przegrana
      break
  print('Suma=%s' % counter)

class klasa():
  def metoda(self):
    print(self.wlasnosc)

def objects2():
    obiekt1=klasa()
    obiekt1.wlasnosc=1
    obiekt2=klasa()
    obiekt2.wlasnosc=2
    obiekt1.metoda()
    obiekt2.metoda()


def list4():
  print([0,1,2,3,4])
  print([0,1,2,3,4][1])
  print([0,1,2,3,4][-1])
  print([0,1,2,3,4][1:3])  
  print([0,1,2,3,4][:3])  
  print([0,1,2,3,4][1:3])  
  print([0,1,2,3,4][-1])
  print([0,1,2,3,4][1:-1])
  
def sequences():
  shoplist = ['jabłko', 'mango', 'marchew', 'banan']
  name = 'Galicea'

  # 
  print('lista zawiera chleb?', 'chleb' in shoplist)
  print('lista zawiera banan?', 'banan' in shoplist)
  
  # indeksowanie #
  print('Element 0 to % s' % shoplist[0])
  print('Element 1 to % s' % shoplist[1])
  print('Element 2 to % s' % shoplist[2])
  print('Element 3 to % s' % shoplist[3])
  print('Element -1 to % s' % shoplist[-1])
  print('Element -2 to % s' % shoplist[-2])
  print('Znak 0 to % s' % name[0])
  
  # fragmenty listy #
  print('Elementy od 1 do 3 to %s' %  shoplist[1:3])
  print('Elementy od 2 do końca to %s' % shoplist[2:])
  print('Elementy od 1 do -1 to %s' % shoplist[1:-1])
  print('Elementy od początku do końca to %s' % shoplist[:])

# fragmenty łańcucha #
  print('znaki od 1 do 3 to %s' % name[1:3])
  print('znaki od 2 do końca to %s' % name[2:])
  print('znaki od 1 do -1 to %s' % name[1:-1])
  print('znaki od początku do końca to %s' % name[:])  


def reference():
  shoplist = ['jabłko', 'mango', 'marchew', 'banan']
  # mylist to tylko inna nazwa (referencja) tych samych danych!
  mylist = shoplist
  # usunięcie pierwszego elementu z shoplist kasuje go także dla mylist
  del shoplist[0]
  print('Usuwanie z referencji:')
  print('lista wskazywana przez shoplist:', shoplist)
  print('lista wskazywana przez mylist:', mylist)

  # to samo po zrobieniu kopii
  mylist = shoplist[:]
  del mylist[0]
  print('Usuwanie z kopii:')
  print('lista wskazywana przez shoplist:', shoplist)
  print('lista wskazywana przez mylist:', mylist)

def str_methods():
  # This is a string object
  name = 'galicea'
  #zamiana małych liter na wielkie
  name = name.capitalize() #zamiana pierwszej litery na wielką
  if name.startswith('Gal'):
    print('Tak - nazwa zaczyna się od "Gal"')
    
  if 'a' in name:
    print('Tak - nazwa zawiera "a"')

  if name.find('lic') != -1:
    print('Tak - nazwa zawiera łańcuch "lic"')

  print(name.upper()) # duże litery
  print(name.lower()) #zamiana wielkich liter na małe
  print('Nazwa zawiera %s litery a' % name.count('a'))

  delimiter = '_*_'
  mylist = ['Brazil', 'Russia', 'India', 'China']
  print(delimiter.join(mylist))


if __name__ == "__main__":
  ex=11
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
  elif ex==41:
    ex_if()    
  elif ex==42:
    ex_while()
  elif ex==43:
    ex_continue()
  elif ex==44:
    ex_break()        
  elif ex==61:
    list4()                
  elif ex==62:
    sequences()            
  elif ex==63:
    reference()
  elif ex==64:
    str_methods()
  