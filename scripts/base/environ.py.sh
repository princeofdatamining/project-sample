. ./.projrc && echo "# -*- coding: utf-8 -*-" > environ/default.py && cat <<EOF >> environ/default.py
#import pymysql; pymysql.install_as_MySQLdb()
from applus.environ import get_envfunc, update_django_dbs, update_django_caches
#


read_env = get_envfunc("")

default_db_values = {
    "username": "root",
    "password": "",
    "hostname": "127.0.0.1",
    "port": 3306,
    "sql_mode": ("STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,"
                 "NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO"),
}


# Classes used to implement DB routing behavior.
DATABASE_ROUTERS = ["applus.django.db_router.ConfigurableDatabaseRouter"]

# { db: apps } 对应关系，如："dbx=app3,app4 dby=app8,app9"
DATABASE_APPS = read_env("DATABASE_APPS", "${DATABASE_APPS}")

# 不需要 migrate 的 dbs，如："dbx dby"
DATABASE_NEVER_MIGRATES = read_env("DATABASE_NEVER_MIGRATES", "${DATABASE_NEVER_MIGRATES}").split()

# See https://docs.djangoproject.com/en/2.2/howto/deployment/checklist/
SECRET_KEY = read_env("SECRET_KEY", "${SECRET_KEY}")

# Celery 消息队列 的配置
CELERY_BROKER_URL = read_env("CELERY_BROKER_URL", "${CELERY_BROKER_URL}")

# Celery任务结果数据库 的配置
CELERY_RESULT_BACKEND = read_env("CELERY_RESULT_BACKEND", "${CELERY_RESULT_BACKEND}")

# celery 任务配置文件
CELERY_BEAT_CONFIG = read_env("CELERY_BEAT_CONFIG", "${CELERY_BEAT_CONFIG}")

# celery 启用异步调用
CELERY_ENABLE_DELAY = read_env("CELERY_ENABLE_DELAY", ${CELERY_ENABLE_DELAY:-True}, bool)

# caches
CACHES = update_django_caches({}, read_env("CACHES", "${CACHES}"))

# session
SESSION_ENGINE = read_env("SESSION_ENGINE", "${SESSION_ENGINE}")
SESSION_CACHE_ALIAS = read_env("SESSION_CACHE_ALIAS", "${SESSION_CACHE_ALIAS}")

# 后端服务的静态资源
STATIC_URL = read_env("STATIC_URL", "${STATIC_URL}")
STATIC_ROOT = read_env("STATIC_ROOT", "${STATIC_ROOT}")

# 动态资源 URL 及目录
MEDIA_URL = read_env("MEDIA_URL", "${MEDIA_URL}")
MEDIA_ROOT = read_env("MEDIA_ROOT", "${MEDIA_ROOT}")

###########################
# 以下内容请不要随意修改  #
###########################

def merge(g):
    # 数据库设置
    update_django_dbs(g['DATABASES'], read_env("DB_URI", "${DB_URI}"), **default_db_values)
    # 日志
    g['LOGGING']['handlers']['file']['filename'] = read_env("PROG_LOG_FILE", "${PROG_LOG_FILE}")
    g['LOGGING']['handlers']['celery']['filename'] = read_env("CELERY_LOG_FILE", "${CELERY_LOG_FILE}")
    # raven（sentry）设置
    g['RAVEN_CONFIG']['dsn'] = read_env("RAVEN_DSN", "${RAVEN_DSN}")
    ###########################
    #     自定义扩展设置      #
    ###########################
    # 更改日志级别
    import sys
    if g['DEBUG']: g['LOGGING']['loggers']['django.db.backends']['level'] = "DEBUG"
    # g['INSTALLED_APPS'].append('debug_toolbar')
    # g['MIDDLEWARE_CLASSES'].insert(0, 'debug_toolbar.middleware.DebugToolbarMiddleware')

DEBUG = read_env("DEBUG_MODE", ${DEBUG_MODE:-False}, bool)

INTERNAL_IPS = read_env("DEBUG_INTERNAL_IPS", "${DEBUG_INTERNAL_IPS}").split()
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