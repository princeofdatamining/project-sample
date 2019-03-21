# -*- coding: utf-8 -*-
# pylint: disable=missing-docstring,too-few-public-methods,unused-argument
from rest_framework import serializers
from applus.django import dao


class BaseUserSerializer(serializers.ModelSerializer):

    class Meta:
        model = dao.get_lazy_model(None)
        fields = ['username', 'password']
