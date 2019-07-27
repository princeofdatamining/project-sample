. ./.projrc

NOPYENV=; NOPIP=; DOUNINSTALL=; NOENVIRON=; NOCOLLECT=; NOPREPARE=; DOMIGRATE=; NOHOST=; NONUXT=;
NOPIP_HOST=; DOPIP_DEV=;
while true; do
  case "$1" in
    --no-pyenv ) NOPYENV=$1; echo NOPYENV=${NOPYENV}; shift ;;
    --no-pip ) NOPIP=$1; echo NOPIP=${NOPIP}; shift ;;
    --no-pip-host ) NOPIP_HOST=$1; echo NOPIP_HOST=${NOPIP_HOST}; shift ;;
    --pip-dev ) DOPIP_DEV=$1; echo DOPIP_DEV=${DOPIP_DEV}; shift ;;
    --uninstall ) DOUNINSTALL=$1; echo DOUNINSTALL=${DOUNINSTALL}; shift ;;
    --no-environ ) NOENVIRON=$1; echo NOENVIRON=${NOENVIRON}; shift ;;
    --no-collect ) NOCOLLECT=$1; echo NOCOLLECT=${NOCOLLECT}; shift ;;
    --no-prepare ) NOPREPARE=$1; echo NOPREPARE=${NOPREPARE}; shift ;;
    --migrate ) DOMIGRATE=$1; echo DOMIGRATE=${DOMIGRATE}; shift ;;
    --no-host ) NOHOST=$1; echo NOHOST=${NOHOST}; shift ;;
    --no-nuxt ) NONUXT=$1; echo NONUXT=${NONUXT}; shift ;;
    -- ) shift; echo "-- $@"; break ;;
    * ) break ;;
  esac
done

# 创建 pyenv 虚拟环境；如无需 pyenv，则注释
[ -z "${NOPYENV}" ] && echo "host: pyenv" && (
$SHELL ./scripts/host/02-pyenv.sh;
)
# 安装依赖
[ -z "${NOPIP}" ] && echo "exec: pip" && (
$SHELL ./scripts/base/01-submodules.sh ${DOUNINSTALL};
$SHELL ./scripts/base/02-pip.sh; [ -z "${NOPIP_HOST}" ] && \
$SHELL ./scripts/host/02-pip.sh; [ -n "${DOPIP_DEV}" ] && \
$SHELL ./scripts/dev/02-pip.sh;
)
# 更新项目配置
[ -z "${NOENVIRON}" ] && echo "base: environ" && (
$SHELL ./scripts/base/03-environ.sh ${NOCOLLECT};
)
# 更新数据
[ -z "${NOPREPARE}" ] && echo "base: prepare" && (
$SHELL ./scripts/base/10-prepare.sh ${DOMIGRATE};
)
# 系统服务配置
[ -z "${NOHOST}" ] && echo "host: configuration" && (
$SHELL ./scripts/host/19-uwsgi.sh;
$SHELL ./scripts/host/19-supervisor.sh;
$SHELL ./scripts/host/19-nginx.sh;#[ -z "${NONUXT}" ] && \
#SHELL ./scripts/host/19-nuxt.sh;
#
#
)
echo "flush done."
