# 环境变量
. .projrc

# 设定工作目录
cd $PROJ_GIT_DIR

# 生成 uwsgi 配置文件
bash scripts/host/uwsgi.ini.sh

# 生成 supervisor 配置文件
bash scripts/host/supervisor.conf.sh

# 生成 nginx 配置文件
bash scripts/host/nginx.conf.sh
