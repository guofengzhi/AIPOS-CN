ALTER TABLE `t_device_info`
MODIFY COLUMN `device_os_version`  varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '设备系统版本' AFTER `device_type`;
ALTER TABLE `t_device_info`
MODIFY COLUMN `hardware_version`  varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '设备硬件版本' AFTER `client_identification`,
MODIFY COLUMN `hardware_shifter`  varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '硬件版本号变形 1.0.0 ——》001000000' AFTER `hardware_version`;



ALTER TABLE `t_os_rom_info`
MODIFY COLUMN `os_version`  varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '系统版本' AFTER `id`,
MODIFY COLUMN `os_start`  varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '升级开始版本' AFTER `rom_path`,
MODIFY COLUMN `os_end`  varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '升级结束版本' AFTER `os_start`;

ALTER TABLE `t_os_rom_info`
MODIFY COLUMN `start_hard`  varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '开始硬件版本号' AFTER `client_identification`,
MODIFY COLUMN `end_hard`  varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '结束硬件版本号' AFTER `start_hard`,
MODIFY COLUMN `start_hard_shift`  varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '开始硬件版本号转换值' AFTER `end_hard`,
MODIFY COLUMN `end_hard_shift`  varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL AFTER `start_hard_shift`;



ALTER TABLE `t_record_rom_info`
MODIFY COLUMN `os_version`  varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '系统版本' AFTER `os_id`;

ALTER TABLE `t_app_record`
MODIFY COLUMN `app_version`  varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'app版本' AFTER `app_name`;


ALTER TABLE `t_app_version`
MODIFY COLUMN `start_hard`  varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '开始硬件版本号' AFTER `client_identification`,
MODIFY COLUMN `end_hard`  varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '结束硬件版本号' AFTER `start_hard`,
MODIFY COLUMN `start_hard_shift`  varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '开始硬件版本号转换值' AFTER `end_hard`,
MODIFY COLUMN `end_hard_shift`  varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL AFTER `start_hard_shift`;

