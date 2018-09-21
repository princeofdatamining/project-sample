# 环境变量
. .projrc

APPS=""

listall() {
    for folder in `ls "$1"`; do
        appname=$folder
        if [ -f "$1/$folder/tests.py" ]; then
            echo "+ test $folder.tests(file)"
            APPS="$APPS$folder.tests "
        elif [ -d "$1/$folder/tests" ]; then
            echo "+ test $folder.tests(dir)"
            APPS="$APPS$folder.tests "
        fi
    done
}

# 处理所有子模块
for package in `ls libs`; do
    dir="libs/$package"
    if [ -d "$dir" ]; then
        listall "$dir"
    fi
done

python manage.py test $APPS
