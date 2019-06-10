

ALTER TABLE `t_os_rom_info`
ADD COLUMN `os_version_compare_val`  varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '系统版本比较值' AFTER `description`,
ADD COLUMN `hardware_version_compare_val`  varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '硬件版本号对比值' AFTER `os_version_compare_val`;



ALTER TABLE `t_app_version`
ADD COLUMN `app_version_compare_val`  varchar(120) NULL AFTER `hardware_version`,
ADD COLUMN `hardware_version_compare_val`  varchar(120) NULL AFTER `app_version_compare_val`;