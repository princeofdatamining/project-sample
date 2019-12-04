""" URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('', include('django.contrib.staticfiles.urls')),
    *static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT),
    #
    path('views/auth/', include('rest_framework.urls')),
    path('api/admin/', include('drf_auth.admin.urls')),
    path('api/', include('drf_auth.api.urls')),
    #
    path('views/feat/', include('libtest.urls')),
    path('api/feat/', include('libtest.exceptions.urls')),
    path('api/feat/', include('libtest.biz.urls')),
    path('api/admin/feat/', include('libtest.admin.urls')),
]


# 验证 sentry 服务
# https://docs.sentry.io/platforms/python/django/

def trigger_error(request):
    division_by_zero = 1 / 0


if settings.DEBUG:
    urlpatterns.insert(0, path('views/sentry/debug/', trigger_error))
