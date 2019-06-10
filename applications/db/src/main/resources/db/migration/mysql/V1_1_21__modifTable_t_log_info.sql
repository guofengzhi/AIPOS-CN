DROP TABLE IF EXISTS `t_log_info`;

CREATE TABLE `t_log_file` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `version` varchar(4) DEFAULT NULL COMMENT '版本号',
  `manufacturer_no` varchar(15) DEFAULT NULL COMMENT '厂商编号',
  `device_type` varchar(4) DEFAULT NULL COMMENT '设备型号',
  `sn` varchar(64) DEFAULT NULL COMMENT '设备序列号',
  `log_name` varchar(128) DEFAULT NULL COMMENT '日志文件名称',
  `log_md5` varchar(64) DEFAULT NULL COMMENT '日志文件MD5',
  `file_size` int(11) DEFAULT NULL COMMENT '文件大小',
  `file_path` varchar(256) DEFAULT NULL COMMENT '文件路径',
  `rec_date` datetime DEFAULT NULL COMMENT '上传时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='日志文件信息表';