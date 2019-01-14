# 环境变量
. .projrc

# 工作目录
cd ${PROJ_GIT_DIR}

# 项目配置
. scripts/base/environ.py.sh

# 收集静态资源存至指定目录(部署时处理)
${PROJ_PYTHON} manage.py collectstatic --noinput
