import urllib


class Sitemap:

    class Meta:
        __html = "/views/"
        __api = "/api/"
        __admin = "/api/admin/"
        ### drf_auth.api
        _auth = "auth/"
        API_AUTH_LOGIN = __api + _auth + "login/"
        API_AUTH_LOGOUT = __api + _auth + "logout/"
        API_AUTH_PROFILE = __api + _auth + "profile/"
        API_AUTH_TOKEN = __api + _auth + "token/"
        #
        ADMIN_USERS = __admin + "users/"
        ADMIN_USER_PASSWORD = ADMIN_USERS + "{}/password/"
        ###
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
                path = urllib.parse.urljoin(host, getattr(self.Meta, k))
                setattr(self, k.lower(), path)

    def join(self, *args):
        return urllib.parse.urljoin(self.host, *args)
