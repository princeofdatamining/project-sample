"""
[Users]
username        role
--------------------------
@super          超级管理员
admin           普通管理员
arch            普通管理员
"""
from getgauge.python import data_store, before_suite, after_suite
from utils import collections


# @before_step
def before_step_hook():
    print("before step hook")


# @after_step
def after_step_hook():
    print("after step hook")


# @before_scenario
def before_scenario_hook():
    print("before scenario hook")


# @after_scenario
def after_scenario_hook():
    print("after scenario hook")


# @before_spec
def before_spec_hook():
    print("before spec hook")


# @after_spec
def after_spec_hook():
    print("after spec hook")


@before_suite
def before_suite_hook():
    data_store.suite.users = collections.UserCollection()


# @after_suite
def after_suite_hook():
    print("after suite hook")

#########
# utils #
#########

def Users():
    return data_store.suite.users
