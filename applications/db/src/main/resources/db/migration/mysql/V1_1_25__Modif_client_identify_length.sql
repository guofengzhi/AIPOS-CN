ALTER TABLE `t_app_version`
MODIFY COLUMN `client_identification`  varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '客户标识' AFTER `app_description`;
