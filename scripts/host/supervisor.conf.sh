. .projrc && cat <<EOF > $PROJ_SUPERVISOR_CONF
[group:$PROJ_CODE_NAME]
programs = $PROJ_CODE_NAME

[program:$PROJ_CODE_NAME]
command = $PROJ_PYTHON_DIR/bin/uwsgi --ini $PROJ_UWSGI_INI
directory = $PROJ_GIT_DIR
user = $PROJ_USER
autostart = true
autorestart = true
redirect_stderr = true
stdout_logfile = $PROJ_LOG_DIR/uwsgi-django.log
EOF