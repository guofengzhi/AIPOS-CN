ALTER TABLE `t_rom_device`
ADD COLUMN `device_version`  varchar(64) NOT NULL COMMENT '升级前版本' AFTER `device_id`,
ADD COLUMN `os_version_shifter`  varchar(128) NULL COMMENT '系统版本号变形' AFTER `device_version`;