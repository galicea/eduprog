import os
import sqlite3
import click

def connect_db():
  """Connects to the specific database."""
  rv = sqlite3.connect('bryk.db')
  rv.row_factory = sqlite3.Row
  return rv

def ini_db():
  db = connect_db()
  with app.open_resource('schema.sql', mode='r') as f:
    db.cursor().executescript(f.read())
  db.commit()
  db.close()


def ini_db1():
  schema_str = open("schema.sql","r").read()
  db = connect_db()
  cur = db.cursor()
  cur.executescript(schema_str)
  db.commit()


#* flask 0.11 ****************
#from flask import Flask
#
#app = Flask(__name__)
#
#@app.cli.command()
#def initdb():
#    """Initializes the database."""
#    ini_db()
#    print 'Initialized the database.'

ini_db1()