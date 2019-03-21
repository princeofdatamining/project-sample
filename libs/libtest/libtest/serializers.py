# -*- coding: utf-8 -*-
# pylint: disable=missing-docstring,too-few-public-methods,unused-argument
from django.contrib import auth
from rest_framework import serializers
from rest_framework import validators
from applus.django import dao


class BaseUserSerializer(serializers.ModelSerializer):

    class Meta:
        model = dao.get_lazy_model(None)
        fields = ['username', 'password']


class LoginUserSerializer(BaseUserSerializer):

    default_error_messages = {
        'invalid_username': "帐号/密码不正确。",
        'invalid_password': "帐号/密码不正确。",
    }

    user_dao = dao.cached_property_dao()

    def __init__(self, *args, **kwargs):
        super(LoginUserSerializer, self).__init__(*args, **kwargs)
        self._user = None
        # 默认会验证 Unique
        for _, field in self.fields.items():
            field.validators = [
                validator
                for validator in field.validators
                if not isinstance(validator, validators.UniqueValidator)
            ]

    def get_validators(self):
        """ 默认会验证 unique_together """
        return []

    def validate_username(self, value):
        """ Validate given username. """
        try:
            self._user = self.user_dao.get(username=value)
        except self.user_dao.model.DoesNotExist:
            self.fail('invalid_username')
        return value

    def validate_password(self, value):
        """ Validate given password. """
        if hasattr(self, '_user') and not self._user.check_password(value):
            self.fail('invalid_password')
        return value

    def validate(self, attrs):
        """ Validate given credentials. """
        self.instance = auth.authenticate(**attrs)
        return attrs


class ProfileUserSerializer(BaseUserSerializer):

    class Meta(BaseUserSerializer.Meta):
        fields = ['username']


class TokenSerializer(serializers.ModelSerializer):

    class Meta:
        model = dao.get_lazy_model("authtoken.token")
        fields = ["key"]
