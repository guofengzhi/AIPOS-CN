-- ----------------------------
-- Table structure for t_record_rom_info
-- ----------------------------
DROP TABLE IF EXISTS `t_record_rom_info`;
CREATE TABLE `t_record_rom_info` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `os_id` int(10) NOT NULL COMMENT '版本id',
  `os_version` varchar(12) NOT NULL COMMENT '系统版本',
  `os_device_type` varchar(50) DEFAULT NULL COMMENT '设备类型',
  `manufacturer_no` varchar(50) DEFAULT NULL COMMENT '商户编号',
  `create_by` varchar(64) NOT NULL COMMENT '发布人',
  `create_date` datetime NOT NULL COMMENT '发布时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统版本发布流水表';
