# -*- coding: utf-8 -*-
""" 数据库表初始化工具 """
from django.conf import settings
from django.core.management import base


# MySQL 不推荐直接输入密码(-p ...)
PWD_CONF = """
[client]
password="{PASSWORD}"
"""


# cat <<'EOF' | mysql ...
CAT_MYSQL = "cat <<'EOF' | mysql --defaults-extra-file={extra} -h {HOST} -P {PORT} -u{USER}\n"

CREATE = """CREATE DATABASE IF NOT EXISTS `{NAME}` DEFAULT CHARSET {charset};\n"""
USE = "USE `{NAME}`;\n"
SOURCE = "SOURCE scripts/sql/{};\n"

CAT_EOF = "\nEOF\n"


SCRIPTS = {
    # default 不需要 SOURCE 通过 --migrate 即可
    "handle": [
        "0000_handles.sql",
    ],
}


class Command(base.BaseCommand):
    """ python manage.py proj_db """

    def handle(self, *args, **options):
        with open("scripts/host/10-prepare.sh", "w", encoding='utf-8') as fout:
            for alias, conf in settings.DATABASES.items():
                # BEGIN mysql config file(store password)
                extra = "scripts/host/db_{NAME}.cnf".format(**conf)
                with open(extra, "w", encoding="utf-8") as fpwd:
                    fpwd.write(PWD_CONF.format(**conf))
                # END mysql config file(store password)
                #
                # BEGIN cat | mysql
                fout.write(CAT_MYSQL.format(extra=extra, **conf))
                # BEGIN SQL
                fout.write(CREATE.format(
                    charset=conf["OPTIONS"]["charset"],
                    **conf
                ))
                fout.write(USE.format(**conf))
                for source in SCRIPTS.get(alias, []):
                    fout.write(SOURCE.format(source))
                # END SQL
                fout.write(CAT_EOF)
                # END cat | mysql
