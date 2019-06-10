


ALTER TABLE `t_os_rom_info`
ADD COLUMN `start_hardware_version`  varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '开始硬件版本号' AFTER `hardware_version`,
ADD COLUMN `end_hardware_version`  varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '结束硬件版本号' AFTER `start_hardware_version`;



ALTER TABLE t_app_version
ADD COLUMN `start_hardware_version`  varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '开始硬件版本号' AFTER `hardware_version`,
ADD COLUMN `end_hardware_version`  varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '结束硬件版本号' AFTER `start_hardware_version`;






ALTER TABLE `t_os_rom_info`
CHANGE COLUMN `start_hardware_version` `start_hard`  varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '开始硬件版本号' AFTER `hardware_version`,
CHANGE COLUMN `end_hardware_version` `end_hard`  varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '结束硬件版本号' AFTER `start_hard`;





ALTER TABLE `t_app_version`
CHANGE COLUMN `start_hardware_version` `start_hard`  varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '开始硬件版本号' AFTER `hardware_version`,
CHANGE COLUMN `end_hardware_version` `end_hard`  varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '结束硬件版本号' AFTER `start_hard`;





ALTER TABLE `t_os_rom_info`
DROP COLUMN `hardware_version`,
DROP COLUMN `os_version_compare_val`,
DROP COLUMN `hardware_version_compare_val`,
ADD COLUMN `start_hard_shift`  varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '开始硬件版本号转换值' AFTER `end_hard`,
ADD COLUMN `end_hard_shift`  varchar(12) NULL AFTER `start_hard_shift`;




ALTER TABLE t_app_version
DROP COLUMN `hardware_version`,
DROP COLUMN `hardware_version_compare_val`,
ADD COLUMN `start_hard_shift`  varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '开始硬件版本号转换值' AFTER `end_hard`,
ADD COLUMN `end_hard_shift`  varchar(12) NULL AFTER `start_hard_shift`;





