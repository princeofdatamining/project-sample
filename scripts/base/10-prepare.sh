# 环境变量
. .projrc

# 设定工作目录
cd ${PROJ_GIT_DIR}

# 动态资源
[ -n "${MEDIA_ROOT}" ] && mkdir -p ${MEDIA_ROOT}

# 数据库变更
[[ $@ =~ "--migrate" ]] && ${PROJ_PYTHON} manage.py migrate

# 通过 command 处理业务数据
# ${PROJ_PYTHON} manage.py COMMAND ...
# ...
# ${PROJ_PYTHON} manage.py COMMAND ...

# celery 任务及配置
# ${PROJ_PYTHON} manage.py celery_beat load
