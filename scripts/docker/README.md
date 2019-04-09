# Docker

## 运行

```shell
# 运行服务
docker-compose up -d

# 创建数据库
docker-compose exec mysql bash -c 'echo "create database db_test_sample default charset utf8;" | mysql -pexample'
docker-compose exec web python3 manage.py migrate
docker-compose exec web bash ./scripts/base/10-prepare.sh

# 创建超级用户 super:super
docker-compose exec web python3 manage.py createsuperuser --noinput --username=super --email=super@localhost 
docker-compose exec mysql bash -c 'echo "update db_test_sample.auth_user set password = \"pbkdf2_sha256\$150000\$salt\$WWxoCDzUc76vDtQ/VzyCpYfxhrAuwhTbYFsEIXDj5tU=\" where id = 1;" | mysql -pexample'

```
