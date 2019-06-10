ALTER TABLE `sys_file`
ADD COLUMN `file_md5`  varchar(60) NULL COMMENT '文件md5值' AFTER `file_path`;
ALTER TABLE `sys_file`
ADD COLUMN `file_progress`  varchar(10) NULL COMMENT '文件进度条' AFTER `file_md5`;
ALTER TABLE `sys_file`
ADD COLUMN `upload_time`  timestamp NULL COMMENT '上传时间' AFTER `file_progress`;