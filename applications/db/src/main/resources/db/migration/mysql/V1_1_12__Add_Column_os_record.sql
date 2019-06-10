ALTER TABLE `t_record_rom_info`
ADD COLUMN `os_version_shifter`  varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '版本号变形' AFTER `os_version`;

