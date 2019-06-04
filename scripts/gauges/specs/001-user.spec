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
* 验证用户 "admin" 并修改密码 "B1@Hblah"


## 普通管理员

* 登录 "arch" 并获取令牌
* 登录 "admin B1@Hblah" 并获取令牌
* "admin" 查看用户列表
* 普通管理员 "admin" 不能创建管理员
* 普通管理员 "admin" 不能修改 "arch" 的密码
* 普通管理员 "admin" 修改自己密码
* 使用密码登录 "admin"
