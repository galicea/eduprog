#import tempfile
#db_file = tempfile.NamedTemporaryFile()

db_file = 'test.db'

class Config(object):
    SECRET_KEY = 'secret key'


class ProdConfig(Config):
    SQLALCHEMY_DATABASE_URI = 'sqlite:///bryk.db'
    CACHE_TYPE = 'simple'


class DevConfig(Config):
    DEBUG = True
    DEBUG_TB_INTERCEPT_REDIRECTS = False
    SQLALCHEMY_DATABASE_URI = 'sqlite:///bryk.db'
    CACHE_TYPE = 'null'
    ASSETS_DEBUG = True


class TestConfig(Config):
    DEBUG = True
    DEBUG_TB_INTERCEPT_REDIRECTS = False

    SQLALCHEMY_DATABASE_URI = 'sqlite:///' + db_file
    SQLALCHEMY_ECHO = True
    CACHE_TYPE = 'null'
    WTF_CSRF_ENABLED = False
