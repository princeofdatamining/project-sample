# -*- coding: utf-8 -*-
# pylint: disable=missing-docstring,too-many-ancestors,unused-argument,no-self-use,pointless-string-statement,invalid-name
from rest_framework import viewsets
from rest_framework import response
from applus.rest_framework import routers
from applus.django import dao
from .. import serializers


router = routers.VerbRouter()


@router.register_decorator('filter/users', base_name="api-filter-user", include='LRP')
class IncludeUserViewSet(viewsets.ModelViewSet):

    serializer_class = serializers.BaseUserSerializer
    queryset = dao.get_lazy_queryset(None)


@router.register_decorator('verb/users', base_name="api-verb-user", include='CR')
class VerbUserViewSet(IncludeUserViewSet):

    @router.action(detail=False)
    def act(self, request, *args, **kwargs):
        return response.Response(dict(message="`action` decorator affected."))

    @router.verb()
    def fetch(self, request, *args, **kwargs):
        return response.Response(dict(message="`verb`(GET) decorator affected."))

    @router.verb("POST")
    def amend(self, request, *args, **kwargs):
        return response.Response(dict(message="`verb`(POST) decorator affected."))

    @router.verb("delete")
    def erase(self, request, *args, **kwargs):
        return response.Response(dict(message="`verb`(DELETE) decorator affected."))
