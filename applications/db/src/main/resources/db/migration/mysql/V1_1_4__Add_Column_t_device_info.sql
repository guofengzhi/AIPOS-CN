ALTER TABLE t_device_info
ADD COLUMN `app_info`  json NULL COMMENT 'app信息' AFTER del_flag;