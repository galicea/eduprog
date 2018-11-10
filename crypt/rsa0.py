#!/usr/bin/python
#-*- coding: utf-8 -*-
"""
RSA Demo in Python
author: Jerzy Wawro, Galicea
License:  GNU General Public License <http://www.gnu.org/licenses/>.

pip install primesieve
pip install numpy
"""

import numpy as np
import primesieve
from random import randint

def gen_prime(min, max):
  """
  Eratosthenes sieve http://code.activestate.com/recipes/117119/
  https://github.com/hickford/primesieve-python 
  """
  prime_list = primesieve.primes(min, max)
  while (not prime_list):
    min=max
    max+=100
    prime_list = generate_primes(min, max)
  n=randint(0, len(prime_list)-1)
  return prime_list[n]


# The greatest common divisor (GCD) - Euler
def gcd(x, y):
    while y != 0:
        (x, y) = (y, x % y)
    return x

# result == x:  a*x mod n == 1,  0 < a < n 
# extended  Euclides
# https://anh.cs.luc.edu/331/notes/xgcd.pdf
def inv(a,n):
  v0 = 0
  v1 = 1
  r0=n
  r1=a
  while r1 != 0: 
    d = r0 // r1
    (r0, r1) = r1, r0 - d * r1
    (v0, v1) = v1, v0 - d * v1
  if v0>0:
    return v0
  else:
    return v0+n


def rsa_keys(p, q): # p<q
# return: d, e, p * q
  n=p*q
  fi=(q-1)*(p-1)
  # wybieramy d wzglednie pierwsze wzgledem fi  z przedzialu [q + 1 .. n-1] 
  d=q+1
  wd=-1
  while (wd != 1 ) and (d<n):
    wd=gcd(d, fi)
    if wd != 1:
      d+=1
  if wd != 1:
    print('nie znaleziono kluczy')
    exit(-1)
  e = inv(d, fi)
  return (d, e, n)


def rsa(M, d, n):
  return (M ** d) % n


if __name__=="__main__":
  # przykładowe dane startowe
  min=779
  d=88
  # liczby pierwsze
  p=gen_prime(min,min+d)
  q=gen_prime(p,p+d)
  # klucze
  d, e, n = rsa_keys(p, q)
  print ('d=%s, e=%s, n=%s' % (d, e, n))
  # test
  M=input('Liczba=')
  Mcrypt=rsa(M,d,n)
  print("zaszyfrowana=%s" % Mcrypt)
  print("odszyfrowana=%s" %   rsa(Mcrypt,e,n))