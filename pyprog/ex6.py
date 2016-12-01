# -*- coding: utf-8 -*-
# przykłady z książki https://leanpub.com/pyprog


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
  ex=64
  if ex==61:
    list4()                
  elif ex==62:
    sequences()            
  elif ex==63:
    reference()
  elif ex==64:
    str_methods()
  