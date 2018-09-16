# 环境变量
. .projrc

# 工作目录
cd $PROJ_GIT_DIR

# 数据库迁移
$PROJ_PYTHON manage.py migrate
