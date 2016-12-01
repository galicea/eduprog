# -*- coding: utf-8 -*-

from flask_wtf import Form
from wtforms import TextField, PasswordField, TextAreaField
from wtforms_alchemy import ModelForm
from wtforms.widgets import HiddenInput
from wtforms import validators
from flask import current_app
from admin.models import User, Zagadnienie

class LoginForm(Form):
  username = TextField(u'Identyfikator', validators=[validators.required()])
  password = PasswordField(u'Hasło', validators=[validators.optional()])

  def validate(self):
    check_validate = super(LoginForm, self).validate()

    # if our validators do not pass
    if not check_validate:
      return False

    # user exists ?
    user = User.query.filter_by(username=self.username.data).first()
    if not user:
      self.username.errors.append('Błędny identyfikator')
      return False

    # Do the passwords match
    if not user.check_password(self.password.data):
      self.username.errors.append('Błędny identyfikator lub hasło')
      return False
    return True

class CreateForm(Form):
  username = TextField(u'Identyfikator', validators=[validators.required()])
  password = PasswordField(u'Hasło', validators=[validators.optional()])
  temat = TextField(u'Zagadnienie jakim chcesz się zająć', validators=[])
  username_error = None
  password_error = None

  def validate(self):
    # Username not null
    if not self.username.data:
      self.username_error='Podaj identyfikator!'
      return False

    # Passwords not null
    if not self.password.data:
      self.password_error='Puste hsło!!!'
      return False

    self.password_error=None
    self.username_error=None
    return True



class ZmianaForm(ModelForm):
  tytul = TextField(u'Tytuł', validators=[validators.required()])
  opis = TextAreaField(u'Opis', validators=[])
  id = HiddenInput('id')

  class Meta:
    model = Zagadnienie
    only=['id','tytul','opis']
