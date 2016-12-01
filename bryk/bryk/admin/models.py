# -*- coding: utf-8 -*-

from flask.ext.sqlalchemy import SQLAlchemy
from flask.ext.login import UserMixin, AnonymousUserMixin
from werkzeug.security import generate_password_hash, check_password_hash

db = SQLAlchemy()


class User(db.Model, UserMixin):
  user_id = db.Column(db.Integer(), primary_key=True)
  username = db.Column(db.String())
  password = db.Column(db.String())

  def __init__(self, username, password):
    self.username = username
    self.set_password(password)

  def set_password(self, password):
    self.password = generate_password_hash(password)

  def check_password(self, value):
    return check_password_hash(self.password, value)

  def is_authenticated(self):
    if isinstance(self, AnonymousUserMixin):
      return False
    else:
      return True

  def is_active(self):
    return True

  def is_anonymous(self):
    if isinstance(self, AnonymousUserMixin):
      return True
    else:
      return False

  def get_id(self):
    return self.user_id

  def __repr__(self):
    return '<User %r>' % self.username


class Zagadnienie(db.Model):
  id = db.Column(db.Integer(), primary_key=True)
  user_id = db.Column(db.Integer())
  kategoria_id = db.Column(db.Integer())
  tytul = db.Column(db.String())
  opis = db.Column(db.String())
  py_rys = db.Column(db.String())
  py_skrypt = db.Column(db.String())

  def __init__(self):
    pass


class Kategoria(db.Model):
  id = db.Column(db.Integer(), primary_key=True)
  przodek = db.Column(db.Integer())
  opis = db.Column(db.String())

  def __init__(self):
    pass

class ZagadnieniePar(db.Model):
  id = db.Column(db.Integer(), primary_key=True)
  zagadnienie_id = db.Column(db.Integer())
  nazwa = db.Column(db.String())
  opis = db.Column(db.String())
  wartosc = db.Column(db.String())

  def __init__(self):
    pass

class Historia(db.Model):
  id = db.Column(db.Integer(), primary_key=True)
  zagadnienie_id = db.Column(db.Integer())
  dt = db.Column(db.Integer(), primary_key=True)
  user_id = db.Column(db.Integer(), primary_key=True)
  kategoria_id = db.Column(db.Integer())
  tytul = db.Column(db.String())
  opis = db.Column(db.String())
  py_rys = db.Column(db.String())
  py_skrypt = db.Column(db.String())

  def __init__(self):
    pass
