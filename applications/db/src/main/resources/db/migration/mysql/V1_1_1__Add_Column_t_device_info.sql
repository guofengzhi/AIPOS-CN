ALTER TABLE `t_device_info`
ADD COLUMN `device_pn`  varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT 'P/N' AFTER `device_sn`,
ADD COLUMN `device_version`  varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '版本号' AFTER `device_type`,
ADD COLUMN `tusn`  varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '银联唯一终端标识' AFTER `device_os_version`,
ADD COLUMN `product_type_code`  varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '产品类型代码' AFTER `tusn`;

