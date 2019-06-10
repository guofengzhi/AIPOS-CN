CREATE TABLE `t_app_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `app_name` varchar(90) NOT NULL COMMENT 'App名称',
  `app_logo` varchar(120) DEFAULT NULL COMMENT 'App图标logo',
  `app_package` varchar(500) NOT NULL COMMENT 'App包名  确定唯一',
  `app_developer` bigint(20) DEFAULT NULL COMMENT '所属开发者',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `ind_app_package` (`app_package`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT = 0 DEFAULT CHARSET=utf8 COMMENT='app基本信息';


CREATE TABLE `t_app_version` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `app_name` varchar(90) NOT NULL COMMENT 'App名称',
  `app_package` varchar(500) NOT NULL COMMENT 'App包名',
  `app_version` varchar(120) DEFAULT NULL COMMENT 'App版本号',
  `app_file` varchar(150) NOT NULL COMMENT 'App APK文件',
  `app_md5` varchar(90) DEFAULT NULL COMMENT 'APK校验值',
  `app_description` varchar(400) DEFAULT NULL COMMENT 'APP升级信息描述',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `upgrade_mode` int(10) DEFAULT NULL COMMENT '设备更新类型',
  PRIMARY KEY (`id`),
  KEY `ind_apk_package` (`app_package`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT = 0 DEFAULT CHARSET=utf8 COMMENT='app版本信息';


CREATE TABLE `t_app_device_type` (
	`id` BIGINT (20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
	`apk_id` BIGINT (20) NOT NULL COMMENT 'App版本表id',
  `manu_no` VARCHAR (20) NOT NULL COMMENT '厂商编号',
	`device_type` VARCHAR (20) DEFAULT NULL COMMENT '设备型号',
	`create_by` VARCHAR (64) NOT NULL COMMENT '创建者',
	`create_date` datetime NOT NULL COMMENT '创建时间',
	`update_by` VARCHAR (64) NOT NULL COMMENT '更新者',
	`update_date` datetime NOT NULL COMMENT '更新时间',
	`remarks` VARCHAR (255) DEFAULT NULL COMMENT '备注信息',
	`del_flag` CHAR (1) NOT NULL DEFAULT '0' COMMENT '删除标记',
	PRIMARY KEY (`id`),
  KEY `ind_manu_no` (`manu_no`) USING BTREE,
  KEY `ind_app_device_type` (`device_type`) USING BTREE,
	KEY `ind_apk_id` (`apk_id`) USING BTREE
) ENGINE = INNODB AUTO_INCREMENT = 0 DEFAULT CHARSET = utf8 COMMENT = 'app版本信息';


CREATE TABLE `t_app_device` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `apk_id` bigint(20) NOT NULL COMMENT 'app版本信息ID',
  `manu_no` varchar(20) NOT NULL COMMENT '厂商编号',
  `device_type` varchar(60) NOT NULL COMMENT '设备型号',
  `device_sn` varchar(20) DEFAULT NULL COMMENT '设备sn号',
  `app_record_id` bigint(20) DEFAULT NULL COMMENT '发布记录表',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `ind_union` (`apk_id`,`manu_no`,`device_type`,`device_sn`) USING BTREE,
  KEY `ind_app_record_id` (`app_record_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT = 0 DEFAULT CHARSET=utf8 COMMENT='app发布关联关系表';



CREATE TABLE `t_app_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `app_name` varchar(60) NOT NULL COMMENT 'app名称',
  `app_version` varchar(20) NOT NULL COMMENT 'app版本',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `ind_app_name` (`app_name`) USING BTREE,
  KEY `ind_app_version` (`app_version`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT = 0 DEFAULT CHARSET=utf8 COMMENT='app发布流水表';



-- ----------------------------
-- Table structure for t_app_developer
-- ----------------------------
DROP TABLE IF EXISTS `t_app_developer`;
CREATE TABLE `t_app_developer` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(20) NOT NULL COMMENT '开发者名称',
  `company` varchar(60) NOT NULL COMMENT '所属公司单位',
  `address` varchar(60) NOT NULL COMMENT '地址',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开发者信息';








