
CREATE TABLE IF NOT EXISTS `django_migrations` (
  `id`      int(11)      NOT NULL AUTO_INCREMENT,
  `app`     varchar(191) NOT NULL COMMENT 'App应用',
  `name`    varchar(191) NOT NULL COMMENT '编号及描述',
  `applied` datetime(6)  NOT NULL COMMENT '变更时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_django_migration__together` (`app`,`name`)
) ENGINE=InnoDB COMMENT='Django 数据库变更历史';

CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id`        int(11)      NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL COMMENT 'App应用',
  `model`     varchar(100) NOT NULL COMMENT 'Model模型',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_django_ct__app_label` (`app_label`,`model`)
) ENGINE=InnoDB COMMENT='Django Model';



CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id`              int(11)      NOT NULL AUTO_INCREMENT,
  `content_type_id` int(11)      NOT NULL COMMENT '模型ID',
  `codename`        varchar(100) NOT NULL COMMENT '操作命名标识符',
  `name`            varchar(191) NOT NULL COMMENT '操作说明',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_auth_perm__ctid_codename` (`content_type_id`,`codename`)
) ENGINE=InnoDB COMMENT='Django 权限列表';

CREATE TABLE IF NOT EXISTS `auth_group` (
  `id`   int(11)      NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL COMMENT '角色名',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_auth_group__name` (`name`)
) ENGINE=InnoDB COMMENT='Django 组列表';

CREATE TABLE IF NOT EXISTS `auth_group_permissions` (
  `id`            int(11) NOT NULL AUTO_INCREMENT,
  `group_id`      int(11) NOT NULL COMMENT '角色ID',
  `permission_id` int(11) NOT NULL COMMENT '操作ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_auth_group_perms__group_permn` (`group_id`,`permission_id`),
  KEY `idx_auth_group_perms__perm` (`permission_id`)
) ENGINE=InnoDB COMMENT='Django 组权限';

CREATE TABLE IF NOT EXISTS `auth_user_groups` (
  `id`       int(11) NOT NULL AUTO_INCREMENT,
  `user_id`  int(11) NOT NULL COMMENT '用户ID',
  `group_id` int(11) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_auth_user_grp__user_group` (`user_id`,`group_id`),
  KEY `idx_auth_user_grp__group` (`group_id`)
) ENGINE=InnoDB COMMENT='Django 用户组';

CREATE TABLE IF NOT EXISTS `auth_user_user_permissions` (
  `id`            int(11) NOT NULL AUTO_INCREMENT,
  `user_id`       int(11) NOT NULL COMMENT '用户ID',
  `permission_id` int(11) NOT NULL COMMENT '操作ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_auth_user_perms__user_perm` (`user_id`,`permission_id`),
  KEY `idx_auth_user_perms__perm` (`permission_id`)
) ENGINE=InnoDB COMMENT='Django 用户权限';

CREATE TABLE IF NOT EXISTS `auth_user` (
  `id`           int(11)      NOT NULL AUTO_INCREMENT,
  `password`     varchar(128) DEFAULT '' COMMENT '密码（含加密方法）',
  `last_login`   datetime(6)  DEFAULT NULL COMMENT '最近访问时间',
  `is_superuser` tinyint(1)   NOT NULL COMMENT '是否超级用户',
  `username`     varchar(150) NOT NULL COMMENT '用户名',
  `first_name`   varchar(30)  NOT NULL COMMENT '名',
  `last_name`    varchar(150) NOT NULL COMMENT '姓',
  `email`        varchar(191) NOT NULL COMMENT '注册邮箱',
  `is_staff`     tinyint(1)   NOT NULL COMMENT '是否管理员',
  `is_active`    tinyint(1)   NOT NULL COMMENT '是否可用',
  `date_joined`  datetime(6)  NOT NULL COMMENT '注册时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_auth_user__email` (`email`),
  UNIQUE KEY `unq_auth_user__username` (`username`)
) ENGINE=InnoDB COMMENT='Django 用户列表';



CREATE TABLE IF NOT EXISTS `django_session` (
  `id`           int(11)     NOT NULL AUTO_INCREMENT,
  `session_key`  varchar(40) NOT NULL COMMENT '会话编号',
  `session_data` longtext    NOT NULL COMMENT '会话内容',
  `expire_date`  datetime(6) NOT NULL COMMENT '过期时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_django_session__key` (`session_key`),
  KEY `idx_django_session__expire_date` (`expire_date`)
) ENGINE=InnoDB COMMENT='Django 会话列表';

CREATE TABLE IF NOT EXISTS `authtoken_token` (
  `id`      int(11)      NOT NULL AUTO_INCREMENT,
  `user_id` int(11)      NOT NULL COMMENT '用户ID',
  `key`     varchar(191) NOT NULL COMMENT '永久token',
  `created` datetime(6)  NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_auth_token__key` (`key`),
  UNIQUE KEY `unq_auth_token__user_id` (`user_id`)
) ENGINE=InnoDB COMMENT='Django 登录凭证';



CREATE TABLE IF NOT EXISTS `django_celery_beat_clockedschedule` (
  `id`           int(11)     NOT NULL AUTO_INCREMENT,
  `clocked_time` datetime(6) NOT NULL COMMENT '？',
  `enabled`      tinyint(1)  NOT NULL COMMENT '是否启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB COMMENT='celery clock 策略';

CREATE TABLE IF NOT EXISTS `django_celery_beat_crontabschedule` (
  `id`            int(11)      NOT NULL AUTO_INCREMENT,
  `minute`        varchar(191) NOT NULL COMMENT '几分',
  `hour`          varchar(96)  NOT NULL COMMENT '几时',
  `day_of_week`   varchar(64)  NOT NULL COMMENT '周几',
  `day_of_month`  varchar(124) NOT NULL COMMENT '几日',
  `month_of_year` varchar(64)  NOT NULL COMMENT '几月',
  `timezone`      varchar(64)  NOT NULL COMMENT '时区',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB COMMENT='celery crontab 策略';

CREATE TABLE IF NOT EXISTS `django_celery_beat_intervalschedule` (
  `id`     int(11)     NOT NULL AUTO_INCREMENT,
  `every`  int(11)     NOT NULL COMMENT '周期数',
  `period` varchar(24) NOT NULL COMMENT '时间单位',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB COMMENT='celery interval 策略';

CREATE TABLE IF NOT EXISTS `django_celery_beat_periodictask` (
  `id`              int(11)           NOT NULL AUTO_INCREMENT,
  `name`            varchar(191)      NOT NULL COMMENT '任务',
  `task`            varchar(191)      NOT NULL COMMENT '方法路径',
  `args`            longtext          NOT NULL COMMENT '变参',
  `kwargs`          longtext          NOT NULL COMMENT '命名参数',
  `queue`           varchar(191)      DEFAULT NULL COMMENT 'MQ相关',
  `exchange`        varchar(191)      DEFAULT NULL COMMENT 'MQ相关',
  `routing_key`     varchar(191)      DEFAULT NULL COMMENT 'MQ相关',
  `expires`         datetime(6)       DEFAULT NULL COMMENT '终止时间',
  `enabled`         tinyint(1)        NOT NULL COMMENT '是否启用',
  `last_run_at`     datetime(6)       DEFAULT NULL COMMENT '上次执行时间',
  `total_run_count` int(10) unsigned  NOT NULL COMMENT '总计执行次数',
  `date_changed`    datetime(6)       NOT NULL COMMENT '更改时间',
  `description`     longtext          NOT NULL COMMENT '备注',
  `crontab_id`      int(11)           DEFAULT NULL COMMENT 'crontab 策略',
  `interval_id`     int(11)           DEFAULT NULL COMMENT 'interval 策略',
  `solar_id`        int(11)           DEFAULT NULL COMMENT 'solar 策略',
  `clocked_id`      int(11)           DEFAULT NULL COMMENT 'clock 策略',
  `one_off`         tinyint(1)        NOT NULL COMMENT '？',
  `start_time`      datetime(6)       DEFAULT NULL COMMENT '？',
  `priority`        int unsigned      NULL COMMENT '？',
  `headers`         longtext          NOT NULL COMMENT '？',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_celery_task__name` (`name`),
  KEY `idx_celery_task__crontab_id` (`crontab_id`),
  KEY `idx_celery_task__interval_id` (`interval_id`)
) ENGINE=InnoDB COMMENT='celery 计划任务';

CREATE TABLE IF NOT EXISTS `django_celery_beat_periodictasks` (
  `ident`       smallint(6) NOT NULL,
  `last_update` datetime(6) NOT NULL,
  PRIMARY KEY (`ident`)
) ENGINE=InnoDB COMMENT='celery 全局变量';

CREATE TABLE IF NOT EXISTS `django_celery_beat_solarschedule` (
  `id`        int(11)       NOT NULL AUTO_INCREMENT,
  `event`     varchar(24)   NOT NULL,
  `latitude`  decimal(9, 6) NOT NULL,
  `longitude` decimal(9, 6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_celery_solar__together` (`event`, `latitude`, `longitude`)
) ENGINE=InnoDB COMMENT='celery solar 策略';

CREATE TABLE IF NOT EXISTS `celery_taskmeta` (
  `id`        int(11)       NOT NULL AUTO_INCREMENT,
  `task_id`   varchar(155)  DEFAULT NULL,
  `status`    varchar(50)   DEFAULT NULL,
  `result`    blob          DEFAULT NULL,
  `date_done` datetime      DEFAULT NULL,
  `traceback` text          DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_celery_task__tid` (`task_id`)
) ENGINE=InnoDB COMMENT='celery result 信息';

CREATE TABLE IF NOT EXISTS `celery_tasksetmeta` (
  `id`        int(11)       NOT NULL AUTO_INCREMENT,
  `taskset_id` varchar(155) DEFAULT NULL,
  `result`     blob         DEFAULT NULL,
  `date_done`  datetime     DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_celery_taskset__tsid` (`taskset_id`)
) ENGINE=InnoDB COMMENT='celery result 信息';



INSERT IGNORE INTO `django_migrations`
(`applied`, `app`, `name`)
VALUES
(NOW(), 'contenttypes', '0001_initial'),
(NOW(), 'contenttypes', '0002_remove_content_type_name'),

(NOW(), 'auth', '0001_initial'),
(NOW(), 'auth', '0002_alter_permission_name_max_length'),
(NOW(), 'auth', '0003_alter_user_email_max_length'),
(NOW(), 'auth', '0004_alter_user_username_opts'),
(NOW(), 'auth', '0005_alter_user_last_login_null'),
(NOW(), 'auth', '0006_require_contenttypes_0002'),
(NOW(), 'auth', '0007_alter_validators_add_error_messages'),
(NOW(), 'auth', '0008_alter_user_username_max_length'),
(NOW(), 'auth', '0009_alter_user_last_name_max_length'),
(NOW(), 'auth', '0010_alter_group_name_max_length'),
(NOW(), 'auth', '0011_update_proxy_permissions'),

(NOW(), 'sessions', '0001_initial'),
(NOW(), 'authtoken', '0001_initial'),
(NOW(), 'authtoken', '0002_auto_20160226_1747'),

(NOW(), 'django_celery_beat', '0001_initial'),
(NOW(), 'django_celery_beat', '0002_auto_20161118_0346'),
(NOW(), 'django_celery_beat', '0003_auto_20161209_0049'),
(NOW(), 'django_celery_beat', '0004_auto_20170221_0000'),
(NOW(), 'django_celery_beat', '0005_add_solarschedule_events_choices'),
(NOW(), 'django_celery_beat', '0006_auto_20180322_0932'),
(NOW(), 'django_celery_beat', '0007_auto_20180521_0826'),
(NOW(), 'django_celery_beat', '0008_auto_20180914_1922'),
(NOW(), 'django_celery_beat', '0006_auto_20180210_1226'),
(NOW(), 'django_celery_beat', '0006_periodictask_priority'),
(NOW(), 'django_celery_beat', '0009_periodictask_headers'),
(NOW(), 'django_celery_beat', '0010_auto_20190429_0326'),
(NOW(), 'django_celery_beat', '0011_auto_20190508_0153');
