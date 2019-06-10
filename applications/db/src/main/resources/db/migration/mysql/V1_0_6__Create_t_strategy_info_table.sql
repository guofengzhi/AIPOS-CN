-- ----------------------------
-- Table structure for `t_strategy_info` 
-- ----------------------------
DROP TABLE IF EXISTS `t_strategy_info` ;

CREATE TABLE `t_strategy_info` (
  `id` INT(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `strategy_name` VARCHAR(50) DEFAULT NULL COMMENT '策略名称',
  `begin_date` DATETIME NOT NULL COMMENT '策略开始时间',
  `end_date` DATETIME NOT NULL COMMENT '策略结束时间',
  `strategy_desc` VARCHAR(500) DEFAULT NULL COMMENT '策略描述',
  `upgrade_type` CHAR(1) DEFAULT '0' COMMENT '升级方式 0-提示 1-强制',
  `create_by` VARCHAR(64) NOT NULL COMMENT '创建者',
  `create_date` DATETIME NOT NULL COMMENT '创建时间',
  `update_by` VARCHAR(64) NOT NULL COMMENT '更新者',
  `update_date` DATETIME NOT NULL COMMENT '更新时间',
  `remarks` VARCHAR(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`)
) ENGINE=INNODB AUTO_INCREMENT=64883 DEFAULT CHARSET=utf8 COMMENT='策略基础信息'

