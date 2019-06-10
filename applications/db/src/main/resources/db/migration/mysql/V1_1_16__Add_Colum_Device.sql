ALTER TABLE `t_device_info`
MODIFY COLUMN `app_info`  json NULL DEFAULT NULL COMMENT 'app信息' AFTER `os_msg`,
ADD COLUMN `os_version_shifter`  varchar(64) NULL COMMENT '设备系统版本号的变形' AFTER `device_os_version`;

