import requests
from getgauge.python import step
from getgauge.python import data_store
from applus import gauge as gutils
from utils.variables import sitemap
from utils import settings


@step("验证欢迎页")
def hello():
    resp = requests.get(sitemap.h5_feat_hello, headers={"Accept": "text/html"})
    assert 200 == resp.status_code
    assert "hello, world" == resp.content.decode()


@step("验证类型参数")
def say(word="test"):
    url = sitemap.h5_feat_say.format(word)
    resp = requests.get(url, headers={"Accept": "text/html"})
    assert 200 == resp.status_code
    assert "say: `{}`".format(word) == resp.content.decode()


def _archive(year, month, code=200, expect="Archive(year={}, month={})"):
    url = sitemap.h5_feat_month.format(year, month)
    resp = requests.get(url, headers={"Accept": "text/html"})
    assert code == resp.status_code
    if code == 200:
        assert expect.format(year, month) == resp.content.decode()


@step("验证正则参数")
def month_archive():
    _archive("201z", "12", 404)
    _archive("2018", "9", 404)
    _archive("2018", "99")
    _archive("2018", "12")



@step("验证错误响应")
def test_perform():
    user = gutils.User(data_store.suite, settings.SUPER_ALIAS)
    headers = user.fill_token()
    #
    resp = requests.get(sitemap.api_err + "error/ok/")
    assert resp.json()["reason"] == "Welcome"
    #
    resp = requests.get(sitemap.api_err + "error/400/")
    assert 400 == resp.status_code
    gutils.assert_error(resp.json(), code="parse_error")
    #
    resp = requests.get(sitemap.api_err + "error/401/not/")
    assert 401 == resp.status_code
    resp = requests.get(sitemap.api_err + "error/401/not/", headers=headers)
    assert 200 == resp.status_code
    #
    resp = requests.get(sitemap.api_err + "error/401/fail/")
    assert 401 == resp.status_code
    resp = requests.get(sitemap.api_err + "error/401/fail/", headers=headers)
    assert 403 == resp.status_code
    gutils.assert_error(resp.json(), code="permission_denied")
    #
    resp = requests.get(sitemap.api_err + "error/403/django/")
    assert 403 == resp.status_code
    gutils.assert_error(resp.json(), code="permission_denied")
    #
    resp = requests.get(sitemap.api_err + "error/403/")
    assert 403 == resp.status_code
    gutils.assert_error(resp.json(), code="permission_denied")
    #
    resp = requests.get(sitemap.api_err + "error/404/django/")
    assert 404 == resp.status_code
    gutils.assert_error(resp.json(), code="not_found")
    #
    resp = requests.get(sitemap.api_err + "error/404/")
    assert 404 == resp.status_code
    gutils.assert_error(resp.json(), code="not_found")
    #
    resp = requests.get(sitemap.api_err + "error/405/")
    assert 405 == resp.status_code
    gutils.assert_error(resp.json(), code="method_not_allowed")
    #
    resp = requests.get(sitemap.api_err + "error/406/")
    assert 406 == resp.status_code
    gutils.assert_error(resp.json(), code="not_acceptable")
    #
    resp = requests.get(sitemap.api_err + "error/415/")
    assert 415 == resp.status_code
    gutils.assert_error(resp.json(), code="unsupported_media_type")
    #
    resp = requests.get(sitemap.api_err + "error/429/")
    assert 429 == resp.status_code
    gutils.assert_error(resp.json(), code="throttled")
    ########
    resp = requests.post(sitemap.api_err + "error/null/", json={})
    assert 400 == resp.status_code
    gutils.assert_error(resp.json(), code="null")
    #
    resp = requests.post(sitemap.api_err + "error/mapping/", json={})
    assert 400 == resp.status_code
    gutils.assert_error(resp.json(), code="invalid")
    #
    resp = requests.post(sitemap.api_err + "error/validators/",
                         json=dict(username="x"))
    assert 400 == resp.status_code
    gutils.assert_error(resp.json(), code="run_bar")
    gutils.assert_error(resp.json(), code="run_foo")
    #
    resp = requests.post(sitemap.api_err + "error/validate/",
                         json=dict(username="x"))
    assert 400 == resp.status_code
    gutils.assert_error(resp.json(), code="validate")
    #
    resp = requests.post(sitemap.api_err + "error/fields/",
                         json=dict(username="x", password="y"))
    assert 400 == resp.status_code
    gutils.assert_error(resp.json(), field="username", code="fail_username_1")
    gutils.assert_error(resp.json(), field="username", code="fail_username_2")
    gutils.assert_error(resp.json(), field="password", code="fail_password_a")
    gutils.assert_error(resp.json(), field="password", code="fail_password_b")
    #


@step("验证 FilterRouter")
def test_filter():
    resp = requests.post(sitemap.api_biz_filter, json={})
    assert 405 == resp.status_code
    #
    resp = requests.get(sitemap.api_biz_filter)
    assert 200 == resp.status_code
    gutils.assert_results(resp.json(), username=settings.SUPER_USERNAME)
    ###
    resp = requests.delete(sitemap.api_biz_filter + "1/")
    assert 405 == resp.status_code
    #
    resp = requests.get(sitemap.api_biz_filter + "1/")
    assert 200 == resp.status_code
    assert settings.SUPER_USERNAME == resp.json()["username"]
    #


@step("验证 VerbRouter")
def test_verb():
    resp = requests.get(sitemap.api_biz_verb, json={})
    assert 405 == resp.status_code
    #
    resp = requests.get(sitemap.api_biz_verb + "act/")
    assert 200 == resp.status_code
    assert resp.json()["message"] == "`action`(detail=False) decorator affected."
    #
    resp = requests.get(sitemap.api_biz_verb + "1/exec/")
    assert 200 == resp.status_code
    assert resp.json()["message"] == "`action`(detail=True) decorator affected."
    ###
    resp = requests.get(sitemap.api_biz_verb + "fetch/")
    assert 200 == resp.status_code
    assert resp.json()["message"] == "`verb`(GET) decorator affected."
    #
    resp = requests.post(sitemap.api_biz_verb + "amend/")
    assert 200 == resp.status_code
    assert resp.json()["message"] == "`verb`(POST) decorator affected."
    #
    resp = requests.delete(sitemap.api_biz_verb + "erase/")
    assert 200 == resp.status_code
    assert resp.json()["message"] == "`verb`(DELETE) decorator affected."
    #


@step("登录示例")
def test_auth():
    resp = requests.post(sitemap.api_biz_auth, json={})
    assert 400 == resp.status_code
    #
    resp = requests.delete(sitemap.api_biz_auth)
    assert 200 == resp.status_code
    #
    resp = requests.get(sitemap.api_biz_auth + "profile/")
    assert 200 == resp.status_code
    #
    resp = requests.get(sitemap.api_biz_auth + "token/")
    assert 200 == resp.status_code
    #
