. .projrc && cat <<EOF > $PROJ_UWSGI_INI
[uwsgi]
${PROJ_UWSGI_WITH_VENV}virtualenv = $PROJ_PYTHON_DIR
chdir = $PROJ_GIT_DIR
wsgi-file = proj/wsgi.py
socket = :$PROJ_WEB_PORT
logto = $PROJ_LOG_DIR/django.log
EOF