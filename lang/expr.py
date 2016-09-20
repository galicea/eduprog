#!/usr/bin/env python
#
# Copyright (c) 2016, Galicea <fundacja@galicea.org>
# All rights reserved.
# License FreeBSD: see license.txt for details.
#
# Example LL(1): simple calculator - only * and + and single digit integers
#

class calculator():
  source=[]
  digits = ('0','1','2','3','4','5','6','7','8','9')
  result=0
  token='!'

  def next_token(self):
    if len(self.source)==0:
      self.token='$'
    else:
      self.token=self.source[0]
      del self.source[0]

  def factor(self): # czynnik
    self.result=0
    if self.token=='(':
      self.next_token()
      self.expr()
      if self.token != ')':
        self.token='!'
      else:
        self.next_token()
    elif self.token in self.digits:
      self.result=int(self.token)
      self.next_token()

  def term(self): # skladnik
    self.factor()
    mem=self.result
    while self.token=='*':
      self.next_token()
      self.factor()
      mem=mem*self.result
    self.result=mem

  def expr(self):
    self.result=0
    self.term()
    mem=self.result
    while (self.token=='+'):
      self.next_token()
      self.term()
      mem=mem+self.result
    self.result=mem
    
  def calc(self,expression):
    self.source=list(expression)
    self.next_token()
    self.expr()
    if self.token=='$':
      return self.result
    else:
      return None

if __name__ == "__main__":
  e='4*(2+3)' #input('expression:')
  c=calculator()
  res=c.calc(e)
  if res != None:
    print(res)
  else:
    print('error')
