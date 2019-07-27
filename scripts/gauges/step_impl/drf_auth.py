import requests
from getgauge.python import step
from applus import gauge as gutils
import utils
from utils import settings
from step_impl import Users


sitemap = utils.Sitemap(settings.ENDPOINT)


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


def _get_real_username(username, *args):
    if username == settings.SUPER_ALIAS:
        if not args:
            return settings.SUPER_USERNAME
        elif not args[0]:
            return settings.SUPER_USERNAME, settings.SUPER_PASSWORD
        else:
            return (settings.SUPER_USERNAME, *args)
    if args:
        return (username, *args)
    return username


@step("使用密码登录 <username>")
def post_login(passport):
    username, password = _split_user(passport)
    user = utils.get_cached_user(username)
    resp = _post_login(*_get_real_username(username, password))
    user.save_cookie(resp, 'sessionid', 'csrftoken')


@step("获取 <username> 的令牌")
def get_token(username):
    username, _ = _split_user(username)
    user = utils.get_cached_user(username)
    cookies = user.fill_cookie()
    resp = requests.get(sitemap.api_auth_token, cookies=cookies)
    assert 200 == resp.status_code
    content = resp.json()
    assert 'key' in content
    user.save_token(content, 'token', 'key')


@step("登出 <username>")
def delete_login(username):
    user = utils.get_cached_user(username)
    cookies = user.fill_cookie()
    headers = user.fill_csrf()
    resp = requests.delete(sitemap.api_auth_logout, cookies=cookies, headers=headers)
    assert 204 == resp.status_code


def _test_profile(resp, username):
    assert 200 == resp.status_code
    content = resp.json()
    if not username:
        assert not bool(content)
    return _get_real_username(username) == content['username']


@step("通过会话验证用户信息 <username>")
def get_profile_by_cookie(username):
    user = utils.get_cached_user(username)
    cookies = user.fill_cookie()
    resp = requests.get(sitemap.api_auth_profile, cookies=cookies)
    _test_profile(resp, username)


@step("通过令牌验证用户信息 <username>")
def get_profile_by_token(username):
    user = utils.get_cached_user(username)
    headers = user.fill_token()
    resp = requests.get(sitemap.api_auth_profile, headers=headers)
    _test_profile(resp, username)


@step("<username> 重置令牌")
def retoken(username):
    user = utils.get_cached_user(username)
    headers = user.fill_token()
    data = dict(password=settings.DEFAULT_PASSWORD)
    resp = requests.put(sitemap.api_auth_retoken, json=data, headers=headers)
    assert resp.status_code in [200]
    content = resp.json()
    user.save_token(content, 'token', 'key')


@step("<username> 修改密码 <password> 为 <new_password>")
def change_password(username, password, new_password):
    user = utils.get_cached_user(username)
    headers = user.fill_token()
    data = dict(
        password=password or settings.DEFAULT_PASSWORD,
        new_password=new_password or settings.DEFAULT_PASSWORD)
    resp = requests.put(sitemap.api_auth_pwd, json=data, headers=headers)
    assert resp.status_code in [200]


@step("<username> 已被禁用")
def been_disable(username):
    user = utils.get_cached_user(username)
    headers = user.fill_token()
    resp = requests.get(sitemap.api_auth_profile, headers=headers)
    assert resp.status_code in [401]
    gutils.assert_error(resp.json(), code='authentication_failed')

##############
# Admin API  #
##############

@step("<staff> 查看用户列表")
def get_admin_users(staff):
    # 查看列表并缓存(注意出现位置)
    user = utils.get_cached_user(staff)
    headers = user.fill_token()
    resp = requests.get(sitemap.admin_users, headers=headers)
    assert 200 == resp.status_code
    content = resp.json()
    gutils.assert_results(content, username=settings.SUPER_USERNAME)
    Users().append(resp.json()["results"])


@step("<super> 创建管理员 <staff>")
def create_admin(super, staff):
    if Users().fetch(username=staff) is not None:
        return
    user = utils.get_cached_user(super)
    headers = user.fill_token()
    req = dict(username=staff, new_password=settings.DEFAULT_PASSWORD)
    resp = requests.post(sitemap.admin_users, json=req, headers=headers)
    assert 201 == resp.status_code


def _reset_password(staff, other, password, code):
    user = utils.get_cached_user(staff)
    headers = user.fill_token()
    url = sitemap.admin_user_password.format(other)
    req = dict(new_password=password)
    resp = requests.put(url, json=req, headers=headers)
    assert code == resp.status_code
    return resp



@step("<staff> 不能创建管理员")
def create_admin_fail(staff):
    user = utils.get_cached_user(staff)
    headers = user.fill_token()
    req = dict(username="impossible", new_password=settings.DEFAULT_PASSWORD)
    resp = requests.post(sitemap.admin_users, json=req, headers=headers)
    assert 403 == resp.status_code


@step("<staff> 为 <other> 重置密码 <password>")
def reset_password(staff, other, password):
    if not password:
        password = settings.DEFAULT_PASSWORD
    _reset_password(staff, other, password, 200)


@step("<staff> 不能重置 <other> 的密码")
def reset_password_fail(staff, other):
    _reset_password(staff, other, settings.DEFAULT_PASSWORD, 403)


@step("重置 <username> 密码 <password>")
def post_created_admin_password(username, password):
    _reset_password(settings.SUPER_ALIAS, username, password, 200)


# @step("<staff> 重置自己密码")
@step("<staff> 不能重置自己密码")
def reset_password(staff):
    # _reset_password(staff, staff, settings.DEFAULT_PASSWORD, 200)
    _reset_password(staff, staff, settings.DEFAULT_PASSWORD, 403)



def _active_user(staff, target, state=False):
    user = utils.get_cached_user(staff)
    headers = user.fill_token()
    url = sitemap.admin_user_active.format(_get_real_username(target))
    req = dict(is_active=state)
    resp = requests.put(url, json=req, headers=headers)
    return resp


@step("<staff> 不能禁用 <target>")
def staff_cant_active_target(staff, target):
    resp = _active_user(staff, target)
    assert resp.status_code in [403]


@step("不能禁用超级管理员")
def cant_active_super():
    resp = _active_user(settings.SUPER_ALIAS, settings.SUPER_USERNAME)
    assert resp.status_code in [403]


@step("<staff> 禁用 <username>")
def inactive_user(staff, username):
    resp = _active_user(staff, username, False)
    assert 200 == resp.status_code


@step("<staff> 启用 <username>")
def inactive_user(staff, username):
    resp = _active_user(staff, username, True)
    assert 200 == resp.status_code


@step("管理员获取 <username> 令牌")
def admin_get_token(username):
    user = utils.get_cached_user(settings.SUPER_ALIAS)
    headers = user.fill_token()
    url = sitemap.admin_user_token.format(username)
    resp = requests.get(url, headers=headers)
    assert resp.status_code in [200]
    #
    user = utils.get_cached_user(username)
    user.save_token(resp.json(), 'token', 'key')
