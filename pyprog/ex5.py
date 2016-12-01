# -*- coding: utf-8 -*-
# przykłady z książki https://leanpub.com/pyprog


def szyfruj(liczba, klucz):
  return (liczba + klucz) % 256

def odszyfruj(liczba, klucz):
  return (256 + liczba - klucz) % 256

def cipher0():
  wiadomosc = int(input('Podaj dodatnią liczbę do zaszyfrowania: '))
  szyfr=szyfruj(wiadomosc, 89)
  print('Wynik=%s' % szyfr)
  print('Odszyfrowany: %s' % odszyfruj(szyfr, 89))

#################################

class klasa():
  def metoda(self):
    print(self.wlasnosc)

def klasy():
  obiekt1=klasa()
  obiekt1.wlasnosc=1
  obiekt2=klasa()
  obiekt2.wlasnosc=2
  obiekt1.metoda()
  obiekt2.metoda()

#################################

class TSzyfrant:

  def __init__(self,klucz):
    self.klucz=klucz

  def szyfruj(self, liczba):
    return (liczba + self.klucz) % 256

  def odszyfruj(self, liczba):
    return (256 + liczba - self.klucz) % 256

def cipher2o():
  szyfrant=TSzyfrant(89)
  wiadomosc = int(input('Podaj dodatnią liczbę do zaszyfrowania: '))
  szyfr=szyfrant.szyfruj(wiadomosc)
  print('Wynik=%s' % szyfr)
  print('Odszyfrowany: %s' % szyfrant.odszyfruj(szyfr))

#################################

class TSzyfrant:

  def __init__(self,klucz):
    self.klucz=klucz

  def szyfruj(self, liczba):
    return (liczba + self.klucz) % 256

  def odszyfruj(self, liczba):
    return (256 + liczba - self.klucz) % 256

class TSolitaire(TSzyfrant):

  def s_szyfruj(self, napis):
    wynik=[]
    for znak in napis:
      wynik.append(self.szyfruj(ord(znak)))
    return wynik

  def s_odszyfruj(self, zakodowany):
    wynik=''
    for kod in zakodowany:
      wynik= wynik+chr(self.odszyfruj(kod))
    return wynik

def szyfrant():
  szyfrant=TSolitaire(88)
  wiadomosc = raw_input('Podaj napis: ')
  szyfr=szyfrant.s_szyfruj(wiadomosc)
  print('Wynik=%s' % szyfr)
  print('Deszyfr=%s' % szyfrant.s_odszyfruj(szyfr))

if __name__ == "__main__":
  ex=55
  if ex==51:
    cipher0()                
  elif ex==52:
    cipher1o()            
  elif ex==53:
    cipher2o()
  elif ex==55:
    szyfrant()
  