. .projrc && touch proj/environ/__init__.py && cat <<EOF > proj/environ/default.py
# 后端的静态资源
STATIC_URL = '$PROJ_STATIC_URL'
STATIC_ROOT = '$PROJ_STATIC_DIR'

import urllib
def parse_url(url, defport=0):
  parsed = urllib.parse.urlparse(url)
  userpwd, netloc = urllib.parse.splituser(parsed.netloc)
  user, word = urllib.parse.splitpasswd(userpwd)
  host, port = urllib.parse.splitnport(netloc, defport)
  return dict(scheme=parsed.scheme,
              netloc=parsed.netloc,
              host=host, port=port, username=user, password=word,
              path=parsed.path,
              params=parsed.params,
              query=parsed.query,
              query_dict=urllib.parse.parse_qs(parsed.query),
              fragment=parsed.fragment)

# 数据库
mysql_url = "$PROJ_MYSQL_DEFAULT"
if $PROJ_MYSQL_ENABLE and mysql_url:
  parsed = parse_url(mysql_url, 3306)
  charset = parsed['query_dict'].get('charset', [''])[0] or 'utf8mb4'
  mysql_mode = "$PROJ_MYSQL_MODE"
  DATABASES = {
    'default': {
      'ENGINE': 'django.db.backends.mysql',
      'HOST': parsed['host'],
      'PORT': parsed['port'],
      'USER': parsed['username'],
      'PASSWORD': parsed['password'] or '',
      'NAME': parsed['path'].strip('/'),
      'OPTIONS': {
        'charset': charset,
        'sql_mode': sql_mode,
      },
      'TEST': {
        'charset': charset,
        'sql_mode': sql_mode,
      },
    }
  }

####################################
# 高级处理，仅修改复杂配置中的某项 #
####################################

def merge(g):
  g['LOGGING']['handlers']['file']['filename'] = '$PROJ_LOG_DIR/logging.log'
  g['RAVEN_CONFIG']['dsn'] = '$PROJ_RAVEN_DSN'

$PROJ_MYSQL_DRIVER
EOF