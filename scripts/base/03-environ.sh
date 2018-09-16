# 环境变量
. .projrc

# 工作目录
cd $PROJ_GIT_DIR

# 日志目录
mkdir -p $PROJ_LOG_DIR

# 项目配置
bash scripts/base/environ.sh.py

# 静态资源
$PROJ_PYTHON manage.py collectstatic --noinput
