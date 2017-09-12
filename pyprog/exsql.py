#!/usr/bin/env python
# -*- coding: utf-8 -*-
# przykłady z książki https://leanpub.com/pyprog

import os
import sqlite3

def connect_db():
  # przylaczenie bazy danych
  db = sqlite3.connect('test.db')
  return db

def ini_db():
 try:
  db = connect_db()
  cur = db.cursor()
  cur.executescript('''
  CREATE TABLE "user" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "username" TEXT,
    "password" TEXT
  );
 ''')
  db.commit()
 except sqlite3.Error as e:
   print("DB error:", e.args[0])
 except Error as e:
   print("rror:", e.args[0])

def new_user(db, name, password):
 try:
   cursor = db.cursor()
   cursor.executescript("insert into user(username, password) values ('%s','%s')" % (name, password))
# nie powoduje błędu z O''Connor:
#   cursor.execute("insert into user(username, password) values (?,?)" , (name, password))
   db.commit()
 except sqlite3.Error as e:
   print("DB error:", e.args[0])
   print('nieudane  wstawienie %s ', name)


ini_db()
db=connect_db()
new_user(db, 'Tomek','haslotomka')
new_user(db, "O'Connor",'haslo2')
new_user(db, 'Romek','hasloromka')

cursor = db.cursor()
for (id, username, password) in cursor.execute('select id, username, password from user'):
  print('%s %s:%s' % (id, username, password))
