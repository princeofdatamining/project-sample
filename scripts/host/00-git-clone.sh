. .gitrc # 引入环境变量

# 【创建】项目目录
mkdir -p $PROJ_GIT_DIR

# 【克隆】指定版本
git clone --recursive -b $PROJ_GIT_BRANCH $PROJ_GIT_URL $PROJ_GIT_DIR

# .gitrc 移到项目目录下
mv .gitrc $PROJ_GIT_DIR/
