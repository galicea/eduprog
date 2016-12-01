# -*- coding: utf-8 -*-
# przykłady z książki https://leanpub.com/pyprog

######################
class Sumator():
  wynik = 0
  krok=1

  def dodaj(self, ile):
    self.wynik+=(ile*self.krok)
    return self.wynik

def o_sumator():
  Sumator.wynik=1
  sumator1=Sumator()
  Sumator.wynik=2
  Sumator.krok=2
  sumator2=Sumator()
  for ilosc_krokow in (1,1,2):
    print('sumator1: %s' % sumator1.dodaj(ilosc_krokow))
    print('sumator2: %s' % sumator2.dodaj(ilosc_krokow))
  print('wlasnosc klasy: %s' % Sumator.wynik)
  print('metoda klasy dla obiektu sumator1: %s' % Sumator.dodaj(sumator1,1))

#####################3

class Sumator2():
  wynik = 0
  krok = 0

  def __init__(self,start,krok):
    self.wynik=start
    self.krok=krok

  def dodaj(self, ile):
    self.wynik+=(ile*self.krok)
    return self.wynik

def o_sumator2():
  sumator1=Sumator2(1,2)
  sumator2=Sumator2(2,2)

  for ilosc_krokow in (1,1,2):
    print('sumator1: %s' % sumator1.dodaj(ilosc_krokow))
    print('sumator2: %s' % sumator2.dodaj(ilosc_krokow))

#################################
class Osoba:
  def przywitajSie(self):
    print 'Witaj, jak się masz?'

def o_metoda():
  o = Osoba()
  o.przywitajSie()
    
###############
class Osoba2:
  def __init__(self, imie):
    self.imie = imie
  
  def przywitajSie(self):
    print 'Witaj, mam na imię', self.imie

def o_init():
  o = Osoba2  ('Swaroop')
  o.przywitajSie()

#########################
class Robot:
  u'''Reprezentuje robota, z nazwą.'''

  def __init__(self, nazwa):
    u'''Inicjalizuje dane.'''
    self.nazwa = nazwa
    print '(Inicjalizacja %s)' % self.nazwa


  def przywitajSie(self):
    u'''Powitanie robota.
      Tak, one naprawdę to potrafią.'''
    print 'Melduję się, moi panowie nazywają mnie %s.' % self.nazwa
    
def o_robot():
  droid1 = Robot('R2-D2')
  droid1.przywitajSie()

  droid2 = Robot('C-3PO')
  droid2.przywitajSie()

#####################
class SchoolMember:
  u'''Reprezentuje człowieka związanego z uczelnią.'''
  def __init__(self, imie, wiek):
    self.imie = imie
    self.wiek = wiek
    print '(Inicjalizacja SchoolMember: %s)' % self.imie

  def powiedz(self):
    u'''Opowiedz o sobie.'''
    print 'Imię:"%s" Wiek:"%s"' % (self.imie, self.wiek),

class Wykladowca(SchoolMember):
    u'''Reprezentuje wykładowcę.'''

    def __init__(self, imie, wiek, pensja):
      SchoolMember.__init__(self, imie, wiek)
      self.pensja = pensja
      print '(Inicjalizacja Wykladowcy: %s)' % self.imie

    def powiedz(self):
      SchoolMember.powiedz(self)
      print 'Pensja: "%d"' % self.pensja

class Student(SchoolMember):
    '''Reprezentuje studenta.'''
    
    def __init__(self, imie, wiek, oceny):
      SchoolMember.__init__(self, imie, wiek)
      self.oceny = oceny
      print '(Inicjalizacja Studenta: %s)' % self.imie

    def powiedz(self):
      SchoolMember.powiedz(self)
      print 'Oceny: "%d"' % self.oceny

def o_dziedziczenie():
  w = Wykladowca('Mrs. Shrividya', 40, 30000)
  s = Student('Swaroop', 25, 75)

  print # wypisuje pustą linię

  osoby = [w, s]
  for osoba in osoby:
    osoba.powiedz() # działa zarówno dla Wykładowców, jak i Studentów

##############

class RobotNG(Robot):
  populacja = 0
        
  def __init__(self, nazwa):
    Robot.__init__(self,nazwa)
    RobotNG.populacja += 1

  def jakDuzo():
    u'''Wypisuje aktualną populację.'''
    print 'Mamy %d roboty.' % RobotNG.populacja

  jakDuzo=staticmethod(jakDuzo)

def o_robot2():
  droid1 = RobotNG('R2-D2')
  droid1.przywitajSie()

  droid2 = RobotNG('C-3PO')
  droid2.przywitajSie()

  RobotNG.jakDuzo()

#############
def helloworld(ob):
  print "Hello world"
  return ob

@helloworld
def myfunc():
  print "my function"

def o_decorator():
  myfunc()

###############
def dekorator2(f):
  def nowa_funkcjonalnosc(*args, **kwds):
    print('Nazwa funkcji:', f.__name__)
    return f(*args, **kwds)

  return nowa_funkcjonalnosc


@dekorator2
def funkcja1(par):
  print(par) 
      

def funkcja2(par):
  print(par) 

def o_decorator2():
  funkcja1('OK1')
# równoważny kod bez użycia notacji dekoratorów
  f=dekorator2(funkcja2)
  f('OK2')


if __name__ == "__main__":
  ex=89
  if ex==81:
    o_sumator()
  if ex==82:
    o_sumator2()
  elif ex==83:
    o_metoda()
  elif ex==84:
    o_init()
  elif ex==85:
    o_robot()
  elif ex==86:
    o_dziedziczenie()
  elif ex==87:
    o_robot2()
  elif ex==88:
    o_decorator()
  elif ex==89:
    o_decorator2()  