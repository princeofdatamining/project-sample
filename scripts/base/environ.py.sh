echo "" > environ/default.py && cat <<EOF >> environ/default.py
sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,'\
    'NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO'
default_db_values = {
    "username": "root",
    "password": "",
    "hostname": "127.0.0.1",
    "port": 3306,
}

import urllib
def parse_uri(uri, **defaults):
    result = urllib.parse.urlparse(uri)
    return {
        "scheme": result.scheme,
        "username": result.username or defaults.get('username'),
        "password": result.password or defaults.get('password'),
        "netloc": result.netloc,
        "hostname": result.hostname or defaults.get('hostname'),
        "port": result.port or defaults.get('port'),
        "path": result.path,
        "query": result.query,
        "queries": urllib.parse.parse_qs(result.query, keep_blank_values=True),
        "params": result.params,
        "fragment": result.fragment,
    }

def joint_uri(parsed, **kwargs):
    return urllib.parse.urlunparse(urllib.parse.ParseResult(
        scheme=kwargs.get("scheme", parsed["scheme"]),
        netloc=kwargs.get("netloc", parsed["netloc"]),
        path=kwargs.get("path", parsed["path"]),
        query=kwargs.get("query", parsed["query"]),
        params=kwargs.get("params", parsed["params"]),
        fragment=kwargs.get("fragment", parsed["fragment"]),
    ))

def parse_db_uri(uri):
    parsed = parse_uri(uri, **default_db_values)
    return {
        'ENGINE': 'django.db.backends.mysql',
        'HOST': parsed['hostname'],
        'PORT': parsed['port'],
        'USER': parsed['username'],
        'PASSWORD': parsed['password'],
        'NAME': parsed['path'].split('/')[1],
        'OPTIONS': {
            'charset': parsed['queries'].get('charset') or 'utf8mb4',
            'sql_mode': sql_mode,
        },
        'TEST': {
            'charset': parsed['queries'].get('charset') or 'utf8mb4',
            'sql_mode': sql_mode,
        },
    }


# 数据库设置
db_uri = "${DB_URI}"
if db_uri:
    DATABASES = {
        'default': parse_db_uri(db_uri),
    }

# 后端服务的静态资源
STATIC_URL = "${STATIC_URL}"
STATIC_ROOT = "${STATIC_ROOT}"

###########################
# 以下内容请不要随意修改  #
###########################

def merge(g):
    # 日志
    g['LOGGING']['handlers']['file']['filename'] = "${PROG_LOG_FILE}"
    # raven（sentry）设置
    g['RAVEN_CONFIG']['dsn'] = "${RAVEN_DSN}"
    ###########################
    #     自定义扩展设置      #
    ###########################
    # 更改日志级别
    import sys
    # g['INSTALLED_APPS'].append('debug_toolbar')
    # g['MIDDLEWARE_CLASSES'].insert(0, 'debug_toolbar.middleware.DebugToolbarMiddleware')

INTERNAL_IPS = [
  '10.10.1.71',
]
DEBUG_TOOLBAR_PANELS = [
    'debug_toolbar.panels.versions.VersionsPanel',
    'debug_toolbar.panels.timer.TimerPanel',
    'debug_toolbar.panels.settings.SettingsPanel',
    'debug_toolbar.panels.headers.HeadersPanel',
    'debug_toolbar.panels.request.RequestPanel',
    'debug_toolbar.panels.sql.SQLPanel',
    'debug_toolbar.panels.staticfiles.StaticFilesPanel',
    'debug_toolbar.panels.templates.TemplatesPanel',
    'debug_toolbar.panels.cache.CachePanel',
    'debug_toolbar.panels.signals.SignalsPanel',
    'debug_toolbar.panels.logging.LoggingPanel',
    'debug_toolbar.panels.redirects.RedirectsPanel',
]

EOF
