
DROP TABLE IF EXISTS `t_tms_file`;
CREATE TABLE `t_tms_file` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '更新物文件ID',
  `file_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '文件名称',
  `manufacture_no` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '厂商编号',
  `file_type` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '文件类型',
  `file_size` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '文件大小',
  `file_version` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '文件版本',
  `file_path` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '文件路径',
  `upload_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '上传时间',
  `remarks` varchar(500) CHARACTER SET utf8 DEFAULT '' COMMENT '描述',
  `organ_id` varchar(40) COLLATE utf8_bin DEFAULT NULL COMMENT '机构号',
  `del_flag` varchar(1) CHARACTER SET utf8 DEFAULT NULL COMMENT '有效标识',
  `md5` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '文件md5值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='更新物文件信息表';


DROP TABLE IF EXISTS `t_tms_strategy`;
CREATE TABLE `t_tms_strategy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `strategy_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '策略名称',
  `begin_date` datetime NOT NULL COMMENT '策略开始时间',
  `end_date` datetime NOT NULL COMMENT '策略结束时间',
  `update_time` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '更新次数 O:一次，M:多次',
  `device_type` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '设备类型',
  `device_sn_str` varchar(2048) COLLATE utf8_bin DEFAULT NULL COMMENT '设备SN字符串',
  `manufacture_no` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '厂商编号',
  `mer_no` varchar(40) CHARACTER SET utf8 DEFAULT NULL COMMENT '商户号',
  `term_no` varchar(40) COLLATE utf8_bin DEFAULT NULL COMMENT '终端号',
  `create_by` varchar(64) CHARACTER SET utf8 NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(500) CHARACTER SET utf8 DEFAULT NULL COMMENT '备注信息',
  `organ_id` varchar(40) COLLATE utf8_bin DEFAULT NULL COMMENT '机构号',
  `del_flag` char(1) CHARACTER SET utf8 NOT NULL DEFAULT '0' COMMENT '删除标记',
  `device_count` int(11) DEFAULT NULL COMMENT '设备数量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='策略文件信息表';


DROP TABLE IF EXISTS `t_tms_log`;
CREATE TABLE `t_tms_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `file_id` int(11) DEFAULT NULL COMMENT '更新物ID',
  `file_name` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '文件名称',
  `file_type` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '文件类型',
  `file_size` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '文件大小',
  `file_version` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '文件版本',
  `file_path` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '文件路径',
  `strategy_id` int(11) DEFAULT NULL COMMENT '策略ID',
  `strategy_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '策略名称',
  `begin_date` datetime DEFAULT NULL COMMENT '策略开始时间',
  `end_date` datetime DEFAULT NULL COMMENT '策略结束时间',
  `update_time` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '更新次数',
  `device_type` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '设备类型',
  `device_sn` varchar(40) COLLATE utf8_bin DEFAULT NULL COMMENT '设备SN',
  `mer_no` varchar(64) CHARACTER SET utf8 DEFAULT NULL COMMENT '商户号',
  `term_no` varchar(40) COLLATE utf8_bin DEFAULT NULL COMMENT '终端号',
  `operate_date` datetime DEFAULT NULL COMMENT '执行时间',
  `manufacture_no` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '厂商编号',
  `remarks` varchar(500) CHARACTER SET utf8 DEFAULT NULL COMMENT '备注',
  `organ_id` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '机构号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


DROP TABLE IF EXISTS `t_tms_device_info`;
CREATE TABLE `t_tms_device_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `device_sn` varchar(20) DEFAULT NULL COMMENT '设备sn',
  `manu_no` varchar(40) DEFAULT NULL COMMENT '厂商',
  `device_type` varchar(10) DEFAULT NULL COMMENT '设备型号',
  `mer_id` varchar(20) DEFAULT NULL COMMENT '商户号',
  `term_id` varchar(20) DEFAULT NULL COMMENT '终端号',
  `create_date` datetime DEFAULT NULL COMMENT '记录时间',
  `strategy_id` varchar(20) DEFAULT NULL COMMENT '策略ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8 COMMENT='更新设备信息表';


DROP TABLE IF EXISTS `t_tms_file_strategy`;
CREATE TABLE `t_tms_file_strategy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_id` varchar(256) COLLATE utf8_bin DEFAULT NULL COMMENT '更新物文件ID',
  `strategy_id` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '策略ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;



-- TMS菜单
insert into `sys_menu` (`id`, `parent_id`, `parent_ids`, `name`, `code`, `functype`, `icon`, `level_code`, `url`, `is_show`, `permission`, `remarks`, `del_flag`, `create_by`, `create_date`, `update_by`, `update_date`, `tc_name`, `en_name`) values('3ffe5a7802fa4b719a4bd837ea5d94be','0',' 0,','TMS管理|tms manage|TMS管理','TMS_MANAGE','0','glyphicon glyphicon-paste','000048',NULL,'0','tms:view',NULL,'0','1','2019-03-13 15:21:54','1','2019-03-13 16:55:18','TMS管理','tms manage');
insert into `sys_menu` (`id`, `parent_id`, `parent_ids`, `name`, `code`, `functype`, `icon`, `level_code`, `url`, `is_show`, `permission`, `remarks`, `del_flag`, `create_by`, `create_date`, `update_by`, `update_date`, `tc_name`, `en_name`) values('427b3426fc5b4439a7d8698ca313c909','3ffe5a7802fa4b719a4bd837ea5d94be',' 0,3ffe5a7802fa4b719a4bd837ea5d94be,','策略管理|strategy manage|策略管理','STRATEGY MANAGE','0','fa fa-random','000048000002','tms/updateStrategy/index','0','tms:updateStrategy:view',NULL,'0','1','2019-03-13 15:49:15','1','2019-03-19 14:36:24','策略管理','Strategy manage');
insert into `sys_menu` (`id`, `parent_id`, `parent_ids`, `name`, `code`, `functype`, `icon`, `level_code`, `url`, `is_show`, `permission`, `remarks`, `del_flag`, `create_by`, `create_date`, `update_by`, `update_date`, `tc_name`, `en_name`) values('4ae51e96b57d49a58d0d2788c212f08c','3ffe5a7802fa4b719a4bd837ea5d94be',' 0,0,3ffe5a7802fa4b719a4bd837ea5d94be,','更新物管理|update items manage|更新物管理','UPDATE_ITEMS','1','fa fa-folder-open-o','000048000001','tms/updateItems/index','0','tms:updateItems:view','更新物管理','0','1','2019-03-13 15:43:20','1','2019-03-13 16:46:59','更新物管理','Update items manage');
insert into `sys_menu` (`id`, `parent_id`, `parent_ids`, `name`, `code`, `functype`, `icon`, `level_code`, `url`, `is_show`, `permission`, `remarks`, `del_flag`, `create_by`, `create_date`, `update_by`, `update_date`, `tc_name`, `en_name`) values('4f310b8e94744aa8a94df75758f7e57c','4ae51e96b57d49a58d0d2788c212f08c',' 0,0,3ffe5a7802fa4b719a4bd837ea5d94be,4ae51e96b57d49a58d0d2788c212f08c,','查看|view|查看','view','1',NULL,'000048000001000001',NULL,'0','tms:updateItems:view',NULL,'0','1','2019-03-13 16:47:41','1','2019-03-13 16:47:41','查看','view');
insert into `sys_menu` (`id`, `parent_id`, `parent_ids`, `name`, `code`, `functype`, `icon`, `level_code`, `url`, `is_show`, `permission`, `remarks`, `del_flag`, `create_by`, `create_date`, `update_by`, `update_date`, `tc_name`, `en_name`) values('5efcd30a607b452189a1d37f5b9266ad','84b2e4494bb2404da6bc312ee6efa11b',' 0,3ffe5a7802fa4b719a4bd837ea5d94be,0,3ffe5a7802fa4b719a4bd837ea5d94be,0,3ffe5a7802fa4b719a4bd837ea5d94be,0,0,3ffe5a7802fa4b719a4bd837ea5d94be,0,3ffe5a7802fa4b719a4bd837ea5d94be,84b2e4494bb2404da6bc312ee6efa11b,','查看|view|查看','UPDATE_LOG_VIEW','1',NULL,'000048000003000001',NULL,'0','tms:log:view',NULL,'0','1','2019-03-13 16:52:35','1','2019-03-13 16:52:35','查看','view');
insert into `sys_menu` (`id`, `parent_id`, `parent_ids`, `name`, `code`, `functype`, `icon`, `level_code`, `url`, `is_show`, `permission`, `remarks`, `del_flag`, `create_by`, `create_date`, `update_by`, `update_date`, `tc_name`, `en_name`) values('84b2e4494bb2404da6bc312ee6efa11b','3ffe5a7802fa4b719a4bd837ea5d94be',' 0,3ffe5a7802fa4b719a4bd837ea5d94be,','日志查询|log search|日誌查詢','LOG_SEARCH','1','fa fa-recycle','000048000003','tms/updateLog/index','0','tms:updateLog:view',NULL,'0','1','2019-03-13 16:02:04','1','2019-03-21 15:06:32','日誌查詢','Log search');
insert into `sys_menu` (`id`, `parent_id`, `parent_ids`, `name`, `code`, `functype`, `icon`, `level_code`, `url`, `is_show`, `permission`, `remarks`, `del_flag`, `create_by`, `create_date`, `update_by`, `update_date`, `tc_name`, `en_name`) values('8678e7476499489f927d6e6ef6712123','4ae51e96b57d49a58d0d2788c212f08c',' 0,0,3ffe5a7802fa4b719a4bd837ea5d94be,4ae51e96b57d49a58d0d2788c212f08c,','修改|update|修改','UPDATE_ITEMS_UPDATE','1',NULL,'000048000001000002',NULL,'0','tms:updateItems:edit',NULL,'0','1','2019-03-13 16:49:47','1','2019-03-14 16:56:50','修改','update');
insert into `sys_menu` (`id`, `parent_id`, `parent_ids`, `name`, `code`, `functype`, `icon`, `level_code`, `url`, `is_show`, `permission`, `remarks`, `del_flag`, `create_by`, `create_date`, `update_by`, `update_date`, `tc_name`, `en_name`) values('b7031652c4844503b39de71e4001a8b7','427b3426fc5b4439a7d8698ca313c909',' 0,3ffe5a7802fa4b719a4bd837ea5d94be,427b3426fc5b4439a7d8698ca313c909,','修改|update|修改','STRATEGY_UPDATE','1',NULL,'000048000002000002',NULL,'0','tms:updateStrategy:edit',NULL,'0','1','2019-03-13 16:51:42','1','2019-03-19 14:36:52','修改','update');
insert into `sys_menu` (`id`, `parent_id`, `parent_ids`, `name`, `code`, `functype`, `icon`, `level_code`, `url`, `is_show`, `permission`, `remarks`, `del_flag`, `create_by`, `create_date`, `update_by`, `update_date`, `tc_name`, `en_name`) values('cfe24c81127445469a9bd853b74c553a','427b3426fc5b4439a7d8698ca313c909',' 0,3ffe5a7802fa4b719a4bd837ea5d94be,427b3426fc5b4439a7d8698ca313c909,','查看|view|查看','STRATEGY_VIEW','1',NULL,'000048000002000001',NULL,'0','tms:updateStrategy:view',NULL,'0','1','2019-03-13 16:51:07','1','2019-03-19 14:36:37','查看','view');
-- 新建更新文件管理菜单
-- insert into `sys_menu` (`id`, `parent_id`, `parent_ids`, `name`, `code`, `functype`, `icon`, `level_code`, `url`, `is_show`, `permission`, `remarks`, `del_flag`, `create_by`, `create_date`, `update_by`, `update_date`, `tc_name`, `en_name`) values('4ae51e96b57d49a58d0d2788c212f08d','3ffe5a7802fa4b719a4bd837ea5d94be',' 0,0,3ffe5a7802fa4b719a4bd837ea5d94be,','更新文件管理|update files manage|更新文件管理','UPDATE_FILES','1','fa fa-folder-open-o','000048000004','tms/updateFiles/index','0','tms:updateFiles:view','更新文件管理','0','1','2019-03-13 15:43:20','1','2019-03-13 16:46:59','更新文件管理','update files manage');
-- insert into `sys_menu` (`id`, `parent_id`, `parent_ids`, `name`, `code`, `functype`, `icon`, `level_code`, `url`, `is_show`, `permission`, `remarks`, `del_flag`, `create_by`, `create_date`, `update_by`, `update_date`, `tc_name`, `en_name`) values('4f310b8e94744aa8a94df75758f7e57d','4ae51e96b57d49a58d0d2788c212f08d',' 0,0,3ffe5a7802fa4b719a4bd837ea5d94be,4ae51e96b57d49a58d0d2788c212f08d,','查看|view|查看','view','1',NULL,'000048000004000001',NULL,'0','tms:updateFiles:view',NULL,'0','1','2019-03-13 16:47:41','1','2019-03-13 16:47:41','查看','view');
-- insert into `sys_menu` (`id`, `parent_id`, `parent_ids`, `name`, `code`, `functype`, `icon`, `level_code`, `url`, `is_show`, `permission`, `remarks`, `del_flag`, `create_by`, `create_date`, `update_by`, `update_date`, `tc_name`, `en_name`) values('8678e7476499489f927d6e6ef6712124','4ae51e96b57d49a58d0d2788c212f08d',' 0,0,3ffe5a7802fa4b719a4bd837ea5d94be,4ae51e96b57d49a58d0d2788c212f08d,','修改|update|修改','UPDATE_FILES_UPDATE','1',NULL,'000048000004000002',NULL,'0','tms:updateFiles:edit',NULL,'0','1','2019-03-13 16:49:47','1','2019-03-14 16:56:50','修改','update');
-- 最终(删除更新文件菜单、调整更新物管理菜单指向更新文件管理内容)
delete from sys_menu where id in ('4ae51e96b57d49a58d0d2788c212f08c', '4f310b8e94744aa8a94df75758f7e57c', '8678e7476499489f927d6e6ef6712123', '4ae51e96b57d49a58d0d2788c212f08d', '4f310b8e94744aa8a94df75758f7e57d', '8678e7476499489f927d6e6ef6712124');
insert into `sys_menu` (`id`, `parent_id`, `parent_ids`, `name`, `code`, `functype`, `icon`, `level_code`, `url`, `is_show`, `permission`, `remarks`, `del_flag`, `create_by`, `create_date`, `update_by`, `update_date`, `tc_name`, `en_name`) values('4ae51e96b57d49a58d0d2788c212f08c','3ffe5a7802fa4b719a4bd837ea5d94be',' 0,0,3ffe5a7802fa4b719a4bd837ea5d94be,','更新物管理|update items manage|更新物管理','UPDATE_ITEMS','1','fa fa-folder-open-o','000048000001','tms/updateFiles/index','0','tms:updateItems:view','更新物管理','0','1','2019-03-13 15:43:20','1','2019-03-13 16:46:59','更新物管理','Update items manage');
insert into `sys_menu` (`id`, `parent_id`, `parent_ids`, `name`, `code`, `functype`, `icon`, `level_code`, `url`, `is_show`, `permission`, `remarks`, `del_flag`, `create_by`, `create_date`, `update_by`, `update_date`, `tc_name`, `en_name`) values('4f310b8e94744aa8a94df75758f7e57c','4ae51e96b57d49a58d0d2788c212f08c',' 0,0,3ffe5a7802fa4b719a4bd837ea5d94be,4ae51e96b57d49a58d0d2788c212f08c,','查看|view|查看','view','1',NULL,'000048000001000001',NULL,'0','tms:updateItems:view',NULL,'0','1','2019-03-13 16:47:41','1','2019-03-13 16:47:41','查看','view');
insert into `sys_menu` (`id`, `parent_id`, `parent_ids`, `name`, `code`, `functype`, `icon`, `level_code`, `url`, `is_show`, `permission`, `remarks`, `del_flag`, `create_by`, `create_date`, `update_by`, `update_date`, `tc_name`, `en_name`) values('8678e7476499489f927d6e6ef6712123','4ae51e96b57d49a58d0d2788c212f08c',' 0,0,3ffe5a7802fa4b719a4bd837ea5d94be,4ae51e96b57d49a58d0d2788c212f08c,','修改|update|修改','UPDATE_ITEMS_UPDATE','1',NULL,'000048000001000002',NULL,'0','tms:updateItems:edit',NULL,'0','1','2019-03-13 16:49:47','1','2019-03-14 16:56:50','修改','update');

--TMS管理员限
INSERT INTO `sys_role_menu` VALUES ('1', '3ffe5a7802fa4b719a4bd837ea5d94be');
INSERT INTO `sys_role_menu` VALUES ('1', '427b3426fc5b4439a7d8698ca313c909');
INSERT INTO `sys_role_menu` VALUES ('1', '4ae51e96b57d49a58d0d2788c212f08c');
INSERT INTO `sys_role_menu` VALUES ('1', '4f310b8e94744aa8a94df75758f7e57c');
INSERT INTO `sys_role_menu` VALUES ('1', '5efcd30a607b452189a1d37f5b9266ad');
INSERT INTO `sys_role_menu` VALUES ('1', '84b2e4494bb2404da6bc312ee6efa11b');
INSERT INTO `sys_role_menu` VALUES ('1', '8678e7476499489f927d6e6ef6712123');
INSERT INTO `sys_role_menu` VALUES ('1', 'b7031652c4844503b39de71e4001a8b7');
INSERT INTO `sys_role_menu` VALUES ('1', 'cfe24c81127445469a9bd853b74c553a');
-- 新建更新文件管理菜单
-- INSERT INTO `sys_role_menu` VALUES ('1', '4ae51e96b57d49a58d0d2788c212f08d');
-- INSERT INTO `sys_role_menu` VALUES ('1', '4f310b8e94744aa8a94df75758f7e57d');
-- INSERT INTO `sys_role_menu` VALUES ('1', '8678e7476499489f927d6e6ef6712124');
-- 最终（删除新增的更新文件管理菜单）
delete from sys_role_menu where menu_id in ('4ae51e96b57d49a58d0d2788c212f08d', '4f310b8e94744aa8a94df75758f7e57d', '8678e7476499489f927d6e6ef6712124');

--插入TMS升级所需数据字典
insert into `sys_dict` (`id`, `value`, `label`, `type`, `description`, `sort`, `parent_id`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) values('176a4452be8f4b36b2da9fe80d9e4ab1','UF','底层固件','tms_file_type','TMS更新物类型','4','0','1','2019-03-13 18:05:35','1','2019-03-13 18:05:35','底层固件','0');
insert into `sys_dict` (`id`, `value`, `label`, `type`, `description`, `sort`, `parent_id`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) values('4dd090eeb5354667825cd52c36568f6e','DD','动态库','tms_file_type','TMS更新物类型','2','0','1','2019-03-13 18:04:17','1','2019-03-13 18:04:17','动态库','0');
insert into `sys_dict` (`id`, `value`, `label`, `type`, `description`, `sort`, `parent_id`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) values('519f5f11b7c84ce6a1f7cf6503cf41f8','APP','应用','tms_file_type','TMS更新物类型','1','0','1','2019-03-13 18:01:20','1','2019-03-13 18:01:20','TMS更新物类型','0');
insert into `sys_dict` (`id`, `value`, `label`, `type`, `description`, `sort`, `parent_id`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) values('c10114baab16430194eee5271d2f77b0','CK','密码键盘','tms_file_type','TMS更新物类型','3','0','1','2019-03-13 18:04:39','1','2019-03-13 18:04:39','密码键盘','0');
insert into `sys_dict` (`id`, `value`, `label`, `type`, `description`, `sort`, `parent_id`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) values('def8beedb778462684d554216c47d745','WS','字库','tms_file_type','TMS更新物类型','5','0','1','2019-03-13 18:05:53','1','2019-03-13 18:05:53','字库','0');
insert into `sys_dict` (`id`, `value`, `label`, `type`, `description`, `sort`, `parent_id`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) values('def8beedb778462684d554216c47d746','PF','参数文件','tms_file_type','TMS更新物类型','6','0','1','2019-03-29 15:11:31','1','2019-03-29 15:11:40','参数文件','0');
insert into `sys_dict` (`id`, `value`, `label`, `type`, `description`, `sort`, `parent_id`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) values('def8beedb778462684d554216c47d747','A70','A70','tms_device_type','TMS设备类型','10','0','1','2017-08-29 13:35:30','1','2017-08-29 13:35:30',NULL,'0');
insert into `sys_dict` (`id`, `value`, `label`, `type`, `description`, `sort`, `parent_id`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) values('def8beedb778462684d554216c47d748','A90','A90','tms_device_type','TMS设备类型','20','0','1','2017-08-29 13:35:30','1','2017-08-29 13:35:30',NULL,'0');
insert into `sys_dict` (`id`, `value`, `label`, `type`, `description`, `sort`, `parent_id`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) values('def8beedb778462684d554216c47d757','V71','V71','tms_device_type','TMS设备类型','10','0','1','2017-08-29 13:35:30','1','2017-08-29 13:35:30',NULL,'0');
insert into `sys_dict` (`id`, `value`, `label`, `type`, `description`, `sort`, `parent_id`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) values('def8beedb778462684d554216c47d758','V80SE','V80SE','tms_device_type','TMS设备类型','20','0','1','2017-08-29 13:35:30','1','2017-08-29 13:35:30',NULL,'0');
insert into `sys_dict` (`id`, `value`, `label`, `type`, `description`, `sort`, `parent_id`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) values('def8beedb778462684d554216c47d749','O','一次','tms_update_time','TMS设备更新次数','10','0','1','2017-08-29 13:35:30','1','2017-08-29 13:35:30',NULL,'0');
insert into `sys_dict` (`id`, `value`, `label`, `type`, `description`, `sort`, `parent_id`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) values('def8beedb778462684d554216c47d740','M','多次','tms_update_time','TMS设备更新次数','20','0','1','2017-08-29 13:35:30','1','2017-08-29 13:35:30',NULL,'0');
