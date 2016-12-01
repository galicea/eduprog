#!/home/galicea/www/bryk/env/bin/python2.7
import os
import sys


PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))
path_to_the_application = "%s.py" % PROJECT_ROOT
sys.path.insert(0, PROJECT_ROOT)
activate_this = '/home/galicea/www/bryk/env/bin/activate_this.py'
execfile(activate_this, dict(__file__=activate_this))

from bryk import app as application