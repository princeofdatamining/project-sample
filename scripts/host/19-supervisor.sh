. ./.projrc && cat <<EOF > scripts/host/supervisor.conf
;[group:${PROJ_CODENAME}]
;programs = ${PROJ_CODENAME}, ${PROJ_CODENAME}_work, ${PROJ_CODENAME}_beat, ${PROJ_CODENAME}_nuxt

[program:${PROJ_CODENAME}]
command = ${PROJ_PYTHON_BIN}/uwsgi --ini ${PROJ_GIT_DIR}/scripts/host/uwsgi.ini
directory = ${PROJ_GIT_DIR}
user = $(whoami)
autostart = true
autorestart = true
redirect_stderr = true
stdout_logfile = ${PROJ_LOG_DIR}/supervisor.log

;[program:${PROJ_CODENAME}_work]
;command = ${PROJ_PYTHON_BIN}/celery worker -A celerytab -l info
;directory = ${PROJ_GIT_DIR}
;user = $(whoami)
;autostart = true
;autorestart = true
;redirect_stderr = true
;stdout_logfile = ${PROJ_LOG_DIR}/celery-work.log

;[program:${PROJ_CODENAME}_beat]
;command = ${PROJ_PYTHON_BIN}/celery beat   -A celerytab -l info -S django
;directory = ${PROJ_GIT_DIR}
;user = $(whoami)
;autostart = true
;autorestart = true
;redirect_stderr = true
;stdout_logfile = ${PROJ_LOG_DIR}/celery-beat.log

;[program:${PROJ_CODENAME}_nuxt]
;command = ${NUXT_NODE_BIN} ${NUXT_WEB_PATH}/node_modules/.bin/nuxt start
;directory = ${NUXT_WEB_PATH}
;user = $(whoami)
;autostart = true
;autorestart = true
;redirect_stderr = true
;stdout_logfile = ${PROJ_LOG_DIR}/nuxt.log
;environment = HOST=0.0.0.0,PORT=${NUXT_WEB_PORT}

;[program:${PROJ_CODENAME}_grpc]
;command = ${PROJ_PYTHON} manage.py grpcserver --port ${PROJ_GRPC_PORT} --max_workers 4
;directory = ${PROJ_GIT_DIR}
;user = $(whoami)
;autostart = true
;autorestart = true
;redirect_stderr = true
;stdout_logfile = ${PROJ_LOG_DIR}/grpc.log
EOF