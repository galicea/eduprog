# -*- coding: utf-8 -*-

from flask import Flask
from flask import render_template, request, send_from_directory, jsonify
from flask import Blueprint, flash, redirect, url_for, current_app
from flask.ext.login import login_user, logout_user, login_required, current_user
from wtforms.ext.appengine.db import model_form

from pprint import pprint

from admin.forms import LoginForm, CreateForm, ZmianaForm
from admin.models import User, Zagadnienie, db
from admin.extensions import (
#    cache,
    assets_env,
    debug_toolbar,
    login_manager
)
from admin import assets
from webassets.loaders import PythonLoader as AssetsLoader

import logging

log = logging.getLogger('werkzeug')

# UnicodeDecodeError
import sys
reload(sys)
sys.setdefaultencoding("utf-8")

def create_app():
  app = Flask(__name__)
  prod=False

  if prod:
    app.config.from_object('settings.ProdConfig')
    app.config['ENV'] = 'prod'
    app.config['DEBUG'] = False
    # initialize the cache
    cache.init_app(app)
  else:
    app.config.from_object('settings.DevConfig')
    app.config['ENV'] = 'dev'
    app.config['DEBUG'] = True
    # initialize the debug tool bar
    debug_toolbar.init_app(app)

  # initialize SQLAlchemy
  db.init_app(app)
  login_manager.init_app(app)

  # Import and register the different asset bundles (see templates)
  assets_env.init_app(app)
  assets_loader = AssetsLoader(assets)
  for name, bundle in assets_loader.load_bundles().items():
    assets_env.register(name, bundle)
#    if not prod:
#      print 'bundle=%s' % name
  return app

# template
blue = Blueprint('blue', __name__, template_folder='./templates/')
app = create_app()


# register our blueprints
app.register_blueprint(blue)

# bez template: @app.route('/')

@blue.route('/')
#@cache.cached(timeout=1000)
def home():
  zz=Zagadnienie.query.limit(100).all()
  if zz:
    return render_template('index.html', zagadnienia=zz,  current_user_id=current_user.get_id())
  else:
    return render_template('index.html')


@blue.route("/login", methods=["GET", "POST"])
def login():
  form = LoginForm()
  if form.validate_on_submit():
    user = User.query.filter_by(username=form.username.data).one()
    login_user(user)
    flash("Logged in successfully.", "success")
    return redirect(request.args.get("next") or url_for(".home"))

  return render_template("login.html", form=form)

@blue.route("/create", methods=["GET", "POST"])
def create():
  form = CreateForm()
  if form.validate_on_submit():
    user = User.query.filter_by(username=form.username.data).first()
    if (user):
      return render_template("create.html", form=form)
    else:
      user = User(request.form['username'] , request.form['password'])
# https://blog.openshift.com/use-flask-login-to-add-user-authentication-to-your-python-application/
      db.session.add(user)
      db.session.commit()
#      return redirect(url_for(".login"))
      user = User.query.filter_by(username=form.username.data).one()
      z=Zagadnienie()
      z.user_id=user.user_id
      z.tytul=form.temat.data
      db.session.add(z)
      db.session.commit()
      login_user(user)
      flash("Logged in successfully.", "success")
      return redirect(request.args.get("next") or url_for(".home"))
  return render_template("create.html", form=form)


@blue.route("/logout")
def logout():
    logout_user()
    flash("You have been logged out.", "success")

    return redirect(url_for(".home"))

@blue.route('/zmiana/<id>', methods=['GET', 'POST'])
@login_required
def zmiana(id):
  z = Zagadnienie.query.filter_by(id=id).first()
  zform = ZmianaForm(request.form)
  if request.method == 'POST' and zform.validate():
    zform.populate_obj(z)
    db.session.commit()
    return redirect(url_for(".home"))
  else:
    if z and (z.user_id==current_user.get_id()):
#    zform = MZmianaForm(request.form, z)
      zform = ZmianaForm(obj=z)
      return render_template('zmiana.html', zagadnienie=z, form=zform)
    else:
      flash("Tylko właściciel może zmieniać opis")
      return redirect(url_for(".home"))

@blue.route('/python')
@login_required
def pyscript():
#  z = Zagadnienie.query.filter_by(id=id).first()
  z = Zagadnienie.query.filter_by(user_id=current_user.get_id()).first()
  if z:
    if z.py_skrypt:
      z.py_skrypt=z.py_skrypt.replace("\n", "\\n")
    return render_template('pyscript.html',zagadnienie=z)
  else:
    flash("Tylko właściciel może zmieniać skrypt")
    return redirect(url_for(".home"))


@blue.route('/save_code', methods=["GET", "POST"])
@blue.route('/save_code/', methods=["GET", "POST"])
def save_code():
  z = Zagadnienie.query.filter_by(user_id=current_user.get_id()).first()
  if z:
    try:
#      pprint('? %s' % request.values.get('code'))
      code=request.values.get('code')
      pprint(code)
      if code:
        z.py_skrypt=code
        db.session.commit()
      return jsonify({"success": True, "message": "OK"})
    except:
      return jsonify({"success": False, "message": "DB error!"})
  else:
    return jsonify({"success": False, "message": "Nie zalogowany?"})



@blue.route('/zagadnienie', methods=["POST"])
def zagadnienie():
  id=request.values.get('id')
  z = Zagadnienie.query.filter_by(id=id).first()
  if z.py_skrypt:
    z.py_skrypt=z.py_skrypt.replace("\n", "\\n")
#  z.opis=z.opis.replace("\n", "<br />")
  return render_template('pyscriptz.html',zagadnienie=z)



@blue.route('/<path:path>')
def send_static(path):
    return send_from_directory('./', path)


@blue.route('/test_corgis', methods=["GET", "POST"])
@blue.route('/test_corgis/', methods=["GET", "POST"])
def test_corgis():
    pprint(request.values)
    return jsonify({"success": False, "message": "Nie zaimplementowane!"})




@blue.route('/submit_grade', methods=["GET", "POST"])
@blue.route('/submit_grade/', methods=["GET", "POST"])
def submit_grade():
    pprint(request.values)
    return jsonify({"success": False, "message": "Submit grade?!"})


    
@blue.route('/save_events', methods=["GET", "POST"])
@blue.route('/save_events/', methods=["GET", "POST"])
def save_events():
    pprint(request.values)
    return jsonify({"success": True, "message": "Zapisalem slad!"})

# register our blueprints
app.register_blueprint(blue)


if __name__ == "__main__":
    app.run(port=8001)
