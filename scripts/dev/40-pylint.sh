# 环境变量
. .projrc

lint() {
    for folder in `ls "$1"`; do
        if [ -f "$1/$folder/__init__.py" ]; then
            echo "pylint $1/$folder ..."
            pylint "$1/$folder"
        fi
    done
}

# 处理所有子模块
for package in `ls libs`; do
    dir="libs/$package"
    if [ -d "$dir" ]; then
        lint "$dir"
    fi
done
