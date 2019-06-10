ALTER TABLE `t_device_info`
ADD COLUMN `hardware_shifter`  varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '硬件版本号变形 1.0.0 ——》001000000' AFTER `hardware_version`;