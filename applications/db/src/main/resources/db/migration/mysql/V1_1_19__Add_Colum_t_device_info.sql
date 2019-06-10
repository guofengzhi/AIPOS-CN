ALTER TABLE `t_app_info`
ADD COLUMN `client_identification`  varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '客户标识' AFTER `app_developer`;


