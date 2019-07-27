. ./.projrc && echo "# -*- coding: utf-8 -*-" > scripts/gauges/utils/settings.py && cat <<EOF >> scripts/gauges/utils/settings.py
from applus.environ import get_envfunc


read_env = get_envfunc("")

ENDPOINT = read_env("ENDPOINT", "${G_ENDPOINT}")

SUPER_ALIAS = read_env("SUPER_ALIAS", "@super")
SUPER_USERNAME, SUPER_PASSWORD = read_env("SUPER", "${G_SUPER}").split()
DEFAULT_PASSWORD = read_env("DEFAULT_PASSWORD", "${G_DEFAULT_PASSWORD}")

from .default import *
EOF