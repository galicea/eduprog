# -*- coding: utf-8 -*-
# przykłady z książki https://leanpub.com/pyprog



def powiedzAhoj():
  print 'Ahoj, przygodo!' # Blok należący do funkcji.
  # Koniec funkcji.  

def fun0():
  powiedzAhoj() # Wywołanie funkcji.
  powiedzAhoj() # Ponowne wywołanie funkcji.
  
  
############
def suma1(a,b):
  print(a+b)
  a=a+b

def suma2(a):
  print(a[0]+a[1])
  a[0]=a[0]+a[1]

def par_fun():
  suma1(3,2*3)
  a=3
  suma1(a,6)
  print('parametr prosty po wyjsciu=',a)
  suma2([3,6])
  lista=[3,6]
  suma2(lista)
  print('parametr / lista po wyjsciu=',lista)

####################
def wypiszMax(a, b):
  if a > b:
    print('%s to maksimum' % a)
  elif a == b:
    print('liczby jednakowe')
  else:
    print('maksimum to %s' % b)

def par2fun():
  wypiszMax(3, 4)
  wypiszMax(7, 5)

################
def maximum(x, y):
  if x > y:
    return x
  else:
    return y

def f_return():
  print maximum(2, 3)

############
def powiedz(wiadomosc, ile = 1):
  print wiadomosc * ile

def f_par():
  powiedz('Ahoj')
  powiedz('Przygodo!', 5)

##########
def powiedz2(wiadomosc, ile = 1):
  print wiadomosc * ile

def f_key():
  powiedz2('Ahoj')
  powiedz2('Przygodo!', 5)

#######
def f(*par,**kpar):
  print par
  print kpar

def f_vpar():
  f(1,2,4)
  f('1',a=2,b=3)

#############
x = 50

def f(x):
  print 'x wynosi', x
  x = 2
  print 'Zmieniono lokalne x na', x
  
def f_local():
  f(x)
  print 'x wynosi nadal', x 
 
####################
x = 50

def f():
  global x
  print 'x wynosi', x
  x = 2
  print 'Zmieniono globalne x na', x


def f_global():
  f()
  print 'Wartość x wynosi', x

#####################3
 
if __name__ == "__main__":
  ex=79
  if ex==71:
    fun0()
  if ex==72:
    par_fun()
  elif ex==73:
    par2fun()
  elif ex==74:
    f_return()
  elif ex==75:
    f_par()
  elif ex==76:
    f_key()
  elif ex==77:
    f_vpar()
  elif ex==78:
    f_local()
  elif ex==79:
    f_global()  