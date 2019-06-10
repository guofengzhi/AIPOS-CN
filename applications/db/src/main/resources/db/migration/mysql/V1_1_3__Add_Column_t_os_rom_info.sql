ALTER TABLE `t_os_rom_info`
ADD COLUMN `hardware_version`  varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '硬件版本' AFTER `manufacturer_no`,
ADD COLUMN `client_identification`  varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '客户标识' AFTER `manufacturer_no`;

ALTER TABLE `t_device_info`
ADD COLUMN `client_identification`  varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '客户标识' AFTER `manufacturer_no`;



ALTER TABLE `t_app_version`
ADD COLUMN `client_identification`  varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '客户标识' AFTER `app_description`,
ADD COLUMN `hardware_version`  varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '设备硬件信息' AFTER `client_identification`;






ALTER TABLE `t_device_info`
ADD COLUMN `hardware_version`  varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '设备硬件版本' AFTER `client_identification`;






