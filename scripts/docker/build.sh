# 环境变量
. .projrc

# 设定工作目录
cd $PROJ_GIT_DIR

# docker 不允许操作上层目录，所以需要放到 src 的上层
cp -r scripts/docker/* ../

# 转到新的目录
cd ..

# 生成 nginx 配置文件
docker build -t $PROJ_CODE_NAME .
