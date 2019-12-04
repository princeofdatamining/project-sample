# 环境变量
# . ./.projrc

# 工作目录
# cd ${PROJ_GIT_DIR}

# 输出 parent 信息
git rev-list --parents -n 1 HEAD > "$1"; echo "----" >> "$1"

# 输出 submodule 信息
git submodule >> "$1"
