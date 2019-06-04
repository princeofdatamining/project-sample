import requests
from getgauge.python import step
from getgauge.python import data_store
from applus import gauge as gutils
from utils.variables import sitemap
from utils import settings


def _post_login(username, password, code=201):
    data = dict(username=username, password=password)
    resp = requests.post(sitemap.api_auth_login, json=data)
    assert code == resp.status_code, str(resp.status_code)
    return resp


def _split_user(passport):
    parts = passport.split()
    if len(parts) > 1:
        return parts[:2]
    if not parts or parts[0] == settings.SUPER_ALIAS:
        return settings.SUPER_ALIAS, ""
    return parts[0], settings.DEFAULT_PASSWORD


@step("使用密码登录 <username>")
def post_login(passport):
    username, password = _split_user(passport)
    user = gutils.User(data_store.suite, username)
    if username == settings.SUPER_ALIAS:
        resp = _post_login(settings.SUPER_USERNAME, settings.SUPER_PASSWORD)
    else:
        resp = _post_login(username, password)
    user.save_cookie(resp, 'sessionid', 'csrftoken')


@step("获取 <username> 的令牌")
def get_token(username):
    username, _ = _split_user(username)
    user = gutils.User(data_store.suite, username)
    cookies = user.fill_cookie()
    resp = requests.get(sitemap.api_auth_token, cookies=cookies)
    assert 200 == resp.status_code
    content = resp.json()
    assert 'key' in content
    user.save_token(content, 'token', 'key')


@step("登出 <username>")
def delete_login(username):
    user = gutils.User(data_store.suite, username)
    cookies = user.fill_cookie()
    headers = user.fill_csrf()
    resp = requests.delete(sitemap.api_auth_logout, cookies=cookies, headers=headers)
    assert 204 == resp.status_code


def _test_profile(resp, username):
    assert 200 == resp.status_code
    content = resp.json()
    if not username:
        assert not bool(content)
    elif username == settings.SUPER_ALIAS:
        assert settings.SUPER_USERNAME == content['username']
    else:
        assert username == content['username']


@step("通过会话验证用户信息 <username>")
def get_profile_by_cookie(username):
    user = gutils.User(data_store.suite, username)
    cookies = user.fill_cookie()
    resp = requests.get(sitemap.api_auth_profile, cookies=cookies)
    _test_profile(resp, username)


@step("通过令牌验证用户信息 <username>")
def get_profile_by_token(username):
    user = gutils.User(data_store.suite, username)
    headers = user.fill_token()
    resp = requests.get(sitemap.api_auth_profile, headers=headers)
    _test_profile(resp, username)

##############
# Admin API  #
##############

@step("<username> 查看用户列表")
def get_admin_users(username):
    user = gutils.User(data_store.suite, username)
    headers = user.fill_token()
    resp = requests.get(sitemap.admin_users, headers=headers)
    assert 200 == resp.status_code
    content = resp.json()
    gutils.assert_results(content, username=settings.SUPER_USERNAME)
    try:
        gutils.assert_results(content, username="admin")
    except AssertionError:
        data_store.suite.has_user_admin = False
    else:
        data_store.suite.has_user_admin = True


@step("<username> 创建管理员 <passport>")
def create_admin(username, passport):
    if data_store.suite.has_user_admin:
        return
    user = gutils.User(data_store.suite, username)
    headers = user.fill_token()
    req = dict(username=passport, new_password=settings.DEFAULT_PASSWORD)
    resp = requests.post(sitemap.admin_users, json=req, headers=headers)
    assert 201 == resp.status_code


def _put_password(username, other, password, code):
    user = gutils.User(data_store.suite, username)
    headers = user.fill_token()
    url = sitemap.admin_user_password.format(other)
    req = dict(new_password=password)
    resp = requests.put(url, json=req, headers=headers)
    assert code == resp.status_code
    return resp


@step("验证用户 <username> 并修改密码 <password>")
def post_created_admin_password(username, password):
    try:
        _post_login(username, settings.DEFAULT_PASSWORD)
    except AssertionError as exc:
        if str(exc) == '400':
            return
        raise
    _put_password(settings.SUPER_ALIAS, username, password, 200)



@step("普通管理员 <username> 不能创建管理员")
def create_admin_fail(username):
    user = gutils.User(data_store.suite, username)
    headers = user.fill_token()
    req = dict(username="root", new_password=settings.DEFAULT_PASSWORD)
    resp = requests.post(sitemap.admin_users, json=req, headers=headers)
    assert 403 == resp.status_code


@step("普通管理员 <username> 不能修改 <other> 的密码")
def put_password_fail(username, other):
    _put_password(username, other, settings.DEFAULT_PASSWORD, 403)


@step("普通管理员 <username> 修改自己密码")
def put_password(username):
    _put_password(username, username, settings.DEFAULT_PASSWORD, 200)
