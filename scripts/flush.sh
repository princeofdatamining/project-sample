. .projrc

# 创建 pyenv 虚拟环境；如无需 pyenv，则注释
echo "##### check python / pyenv ..."
. scripts/host/02-pyenv.sh
[[ $@ =~ "--to-pyenv" ]] && exit 0

# 安装依赖
if [[ ! $@ =~ "--no-pip" ]]; then
echo "##### check libraries ..."
. scripts/host/02-pip.sh
. scripts/base/02-pip.sh
. scripts/dev/40-submodules.sh
fi

# 更新项目配置
if [[ ! $@ =~ "--no-environ" ]]; then
echo "##### update environ ..."
mkdir -p $PROJ_LOG_DIR
. scripts/base/03-environ.sh
fi

# 更新数据
if [[ ! $@ =~ "--no-prepare" ]]; then
echo "##### prepare data ..."
. scripts/base/10-prepare.sh
fi

# 系统服务配置
if [[ ! $@ =~ "--no-servconf" ]]; then
echo "##### update uwsgi & supervisor & nginx configuration"
. scripts/host/19-uwsgi.sh
. scripts/host/19-supervisor.sh
. scripts/host/19-nginx.sh
# scripts/host/19-nuxt.sh
fi
