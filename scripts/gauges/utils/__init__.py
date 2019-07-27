import urllib
import tablib
from getgauge.python import data_store
from applus import gauge


class Sitemap:

    class Meta:
        __html = "/views/"
        __api = "/api/"
        __admin = "/api/admin/"
        __detail = "{}/"
        #
        __mod_auth = "auth"
        __mod_user = "users"
        #
        __act_password = "password"
        __act_token = "token"
        __act_retoken = "retoken"
        __act_active = "active"
        __act_restore = "restore"
        __act_agree = "agree"
        __act_refuse = "refuse"
        ############
        # drf_auth #
        ############
        API_AUTH = __api + __detail.format(__mod_auth)
        API_AUTH_LOGIN = API_AUTH + "login/"
        API_AUTH_LOGOUT = API_AUTH + "logout/"
        API_AUTH_PROFILE = API_AUTH + "profile/"
        API_AUTH_TOKEN = API_AUTH + __detail.format(__act_token)
        API_AUTH_RETOKEN = API_AUTH + __detail.format(__act_retoken)
        API_AUTH_PWD = API_AUTH + __detail.format(__act_password)
        #
        ADMIN_USERS = __admin + __detail.format(__mod_user)
        ADMIN_USER_ = ADMIN_USERS + __detail
        ADMIN_USER_PASSWORD = ADMIN_USER_ + __detail.format(__act_password)
        ADMIN_USER_ACTIVE = ADMIN_USER_ + __detail.format(__act_active)
        ADMIN_USER_TOKEN = ADMIN_USER_ + __detail.format(__act_token)
        ########
        # test #
        ########
        _feat = "feat/"
        H5_FEAT_HELLO = __html + _feat + 'html/hello/'
        H5_FEAT_SAY = __html + _feat + 'html/say/{}/'
        H5_FEAT_MONTH = __html + _feat + 'html/articles/{}/{}/'
        API_ERR = __api + _feat
        API_BIZ_FILTER = __api + _feat + 'filter/users/'
        API_BIZ_VERB = __api + _feat + 'verb/users/'
        API_BIZ_AUTH = __api + _feat + 'auth/'

    def __init__(self, host):
        self.host = host
        for k in dir(self.Meta):
            if k.isupper():
                setattr(self, k.lower(), self.join(getattr(self.Meta, k)))

    def join(self, url_or_path):
        return urllib.parse.urljoin(self.host, url_or_path)


def get_cached_user(username):
    return gauge.User(data_store.suite, username)


def tail_or_not(value, tail):
    if value.endswith(tail):
        return value[:-len(tail)]
    else:
        return value + tail


def save_csv(filename, headers, rows):
    sheet = tablib.Dataset()
    sheet.headers = headers
    for row in rows:
        sheet.append(row)
    with open(filename, "w", encoding="utf-8") as fout:
        fout.write(sheet.export("csv"))
