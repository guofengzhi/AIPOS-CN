CREATE TABLE `t_record_info` (
  `id` varchar(20) NOT NULL COMMENT '记录ID  YYYYMMDDHHmmssSSS + 3位random',
  `parent_id` varchar(20) DEFAULT NULL COMMENT '上一级记录ID',
  `status` char(1) DEFAULT NULL COMMENT '状态 0-正常，1-获取中，9-失败',
  `package_info` json DEFAULT NULL COMMENT '本级包内信息',
  `record_datetime` varchar(14) DEFAULT NULL COMMENT '记录时间',
  `package_path` varchar(512) DEFAULT NULL COMMENT '本级包路径',
  `package_name` varchar(64) DEFAULT NULL COMMENT '本级包名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='获取日志流水表';