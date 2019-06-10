ALTER TABLE `t_upgrade_translog`
CHANGE COLUMN `rom_start_version` `method_name`  varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '方法名称' AFTER `device_sn`,
CHANGE COLUMN `rom_end_version` `packet_info`  json NOT NULL COMMENT 'json包信息' AFTER `method_name`,
ADD COLUMN `manu_no`  varchar(20) NULL COMMENT '厂商编号' AFTER `device_sn`;

