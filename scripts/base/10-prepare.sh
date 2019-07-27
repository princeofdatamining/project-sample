# 环境变量
. ./.projrc

# 设定工作目录
cd ${PROJ_GIT_DIR}

# 动态资源
[ -n "${MEDIA_ROOT}" ] && mkdir -p ${MEDIA_ROOT}

# 数据库变更
[[ $@ =~ "--migrate" ]] && (
[ -f ./projapp/management/commands/proj_db.py ] && ${PROJ_PYTHON} manage.py proj_db;
[ -f ./scripts/host/10-prepare.sh ] && $SHELL ./scripts/host/10-prepare.sh;
${PROJ_PYTHON} manage.py migrate;
)
# 通过 command 处理业务数据
# ${PROJ_PYTHON} manage.py COMMAND ...
# ...
# ${PROJ_PYTHON} manage.py COMMAND ...

# celery 任务及配置
[ -n "${CELERY_BEAT_CONFIG}" ] && (
[ -f ./scripts/host/19-celery-beat.yml -a ! -f "${CELERY_BEAT_CONFIG}" ] && cp ./scripts/host/19-celery-beat.yml "${CELERY_BEAT_CONFIG}"
#$SHELL ./scripts/host/18-celerybeat.sh;
[ -f "${CELERY_BEAT_CONFIG}" ] && ${PROJ_PYTHON} manage.py celery_beat load;)
