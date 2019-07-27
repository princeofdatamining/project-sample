# 管理员

tags: admin

* 登录 "@super" 并获取令牌


## 登录验证

* 通过会话验证用户信息 "@super"
* 通过令牌验证用户信息 "@super"


## 超级管理员

* "@super" 查看用户列表
* "@super" 创建管理员 "admin"
* "@super" 创建管理员 "arch"
* 重置 "admin" 密码 "B1@Hblah"


## 普通管理员

* 登录 "arch" 并获取令牌
* 登录 "admin B1@Hblah" 并获取令牌
* "admin" 查看用户列表
* "admin" 不能创建管理员
* "admin" 不能重置 "arch" 的密码
* "admin" 不能重置自己密码
* "admin" 修改密码 "B1@Hblah" 为 ""
* 使用密码登录 "admin"
* "admin" 重置令牌
* 通过令牌验证用户信息 "admin"
