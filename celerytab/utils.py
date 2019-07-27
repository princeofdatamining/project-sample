# -*- coding: utf-8 -*-
""" Celery utils """
from django.conf import settings


def execute(func, *args, **kwargs):
    """ 方便调试和没有异步环境，可根据配置决定任务是否异步调度 """
    if settings.CELERY_ENABLE_DELAY:
        func.delay(*args, **kwargs)
    else:
        func(*args, **kwargs)
