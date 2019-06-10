/*
Navicat MySQL Data Transfer

Source Server         : localtest
Source Server Version : 50715
Source Host           : localhost:3306
Source Database       : otasys

Target Server Type    : MYSQL
Target Server Version : 50715
File Encoding         : 65001

Date: 2017-09-05 10:26:43
*/


-- ----------------------------
-- Records of sys_area
-- ----------------------------
INSERT INTO `sys_area` VALUES ('1', '0', '0,', '中国', '10', '100000', '1', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_area` VALUES ('2', '1', '0,1,', '山东省', '20', '110000', '2', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_area` VALUES ('3', '2', '0,1,2,', '济南市', '30', '110101', '3', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_area` VALUES ('4', '3', '0,1,2,3,', '历城区', '40', '110102', '4', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_area` VALUES ('5', '3', '0,1,2,3,', '历下区', '50', '110104', '4', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_area` VALUES ('6', '3', '0,1,2,3,', '高新区', '60', '110105', '4', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES ('1', '0', '正常', 'del_flag', '删除标记', '10', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('17', '1', '国家', 'sys_area_type', '区域类型', '10', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('18', '2', '省份、直辖市', 'sys_area_type', '区域类型', '20', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('19', '3', '地市', 'sys_area_type', '区域类型', '30', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('2', '1', '删除', 'del_flag', '删除标记', '20', '0', '1', '2013-05-27 08:00:00', '1', '2017-02-27 14:53:38', '测试说明', '0');
INSERT INTO `sys_dict` VALUES ('20', '4', '区县', 'sys_area_type', '区域类型', '40', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('21', '1', '公司', 'sys_office_type', '机构类型', '60', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('22', '2', '部门', 'sys_office_type', '机构类型', '70', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('23', '3', '小组', 'sys_office_type', '机构类型', '80', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('24', '4', '其它', 'sys_office_type', '机构类型', '90', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('28', '1', '一级', 'sys_office_grade', '机构等级', '10', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('29', '2', '二级', 'sys_office_grade', '机构等级', '20', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('3', '1', '显示', 'show_hide', '显示/隐藏', '10', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('30', '3', '三级', 'sys_office_grade', '机构等级', '30', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('31', '4', '四级', 'sys_office_grade', '机构等级', '40', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('32', '1', '所有数据', 'sys_data_scope', '数据范围', '10', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('33', '2', '所在公司及以下数据', 'sys_data_scope', '数据范围', '20', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('34', '3', '所在公司数据', 'sys_data_scope', '数据范围', '30', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('35', '4', '所在部门及以下数据', 'sys_data_scope', '数据范围', '40', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('36', '5', '所在部门数据', 'sys_data_scope', '数据范围', '50', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('37', '8', '仅本人数据', 'sys_data_scope', '数据范围', '90', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('38', '9', '按明细设置', 'sys_data_scope', '数据范围', '100', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('39', '1', '系统管理', 'sys_user_type', '用户类型', '10', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('4', '0', '隐藏', 'show_hide', '显示/隐藏', '20', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('40', '2', '部门经理', 'sys_user_type', '用户类型', '20', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('41', '3', '普通用户', 'sys_user_type', '用户类型', '30', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('513d009fcef3463e831b651d4fe7d9c1', '1', 'A90', 'device_type', '设备类型', '20', '0', '1', '2017-08-29 13:35:30', '1', '2017-08-29 13:35:30', null, '0');
INSERT INTO `sys_dict` VALUES ('54', '1', '删除', 'cms_del_flag', '内容状态', '20', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('55', '2', '审核', 'cms_del_flag', '内容状态', '15', '0', '1', '2013-05-27 08:00:00', '1', '2017-08-28 14:10:54', null, '0');
INSERT INTO `sys_dict` VALUES ('6', '0', '否', 'yes_no', '是/否', '20', '0', '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('67', '1', '接入日志', 'sys_log_type', '日志类型', '30', '0', '1', '2013-06-03 08:00:00', '1', '2013-06-03 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('68', '2', '异常日志', 'sys_log_type', '日志类型', '40', '0', '1', '2013-06-03 08:00:00', '1', '2013-06-03 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('84', 'input', '文本框', 'gen_show_type', '字段生成方案', '10', '0', '1', '2013-10-28 08:00:00', '1', '2013-10-28 08:00:00', null, '1');
INSERT INTO `sys_dict` VALUES ('85', 'textarea', '文本域', 'gen_show_type', '字段生成方案', '20', '0', '1', '2013-10-28 08:00:00', '1', '2013-10-28 08:00:00', null, '1');
INSERT INTO `sys_dict` VALUES ('86', 'select', '下拉框', 'gen_show_type', '字段生成方案', '30', '0', '1', '2013-10-28 08:00:00', '1', '2013-10-28 08:00:00', null, '1');
INSERT INTO `sys_dict` VALUES ('87', 'checkbox', '复选框', 'gen_show_type', '字段生成方案', '40', '0', '1', '2013-10-28 08:00:00', '1', '2013-10-28 08:00:00', null, '1');
INSERT INTO `sys_dict` VALUES ('88', 'radiobox', '单选框', 'gen_show_type', '字段生成方案', '50', '0', '1', '2013-10-28 08:00:00', '1', '2013-10-28 08:00:00', null, '1');
INSERT INTO `sys_dict` VALUES ('89', 'dateselect', '日期选择', 'gen_show_type', '字段生成方案', '60', '0', '1', '2013-10-28 08:00:00', '1', '2013-10-28 08:00:00', null, '1');
INSERT INTO `sys_dict` VALUES ('90', 'userselect', '人员选择\0', 'gen_show_type', '字段生成方案', '70', '0', '1', '2013-10-28 08:00:00', '1', '2013-10-28 08:00:00', null, '1');
INSERT INTO `sys_dict` VALUES ('91', 'officeselect', '部门选择', 'gen_show_type', '字段生成方案', '80', '0', '1', '2013-10-28 08:00:00', '1', '2013-10-28 08:00:00', null, '1');
INSERT INTO `sys_dict` VALUES ('92', 'areaselect', '区域选择', 'gen_show_type', '字段生成方案', '90', '0', '1', '2013-10-28 08:00:00', '1', '2013-10-28 08:00:00', null, '1');
INSERT INTO `sys_dict` VALUES ('95', 'dao', '仅持久层', 'gen_category', '代码生成分类\0\0\0\0\0\0', '40', '0', '1', '2013-10-28 08:00:00', '1', '2013-10-28 08:00:00', null, '1');
INSERT INTO `sys_dict` VALUES ('96', '1', '男', 'sex', '性别', '10', '0', '1', '2013-10-28 08:00:00', '1', '2013-10-28 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('97', '2', '女', 'sex', '性别', '20', '0', '1', '2013-10-28 08:00:00', '1', '2013-10-28 08:00:00', null, '0');
INSERT INTO `sys_dict` VALUES ('c740a3c1a9e94616a8f44b280128a257', '1', '是', 'yes_no', '是/否', '30', '0', '1', '2017-09-01 08:58:21', '1', '2017-09-01 08:58:21', '是否', '0');
INSERT INTO `sys_dict` VALUES ('edceb0c51ff84fb4b23c3650dc0af738', '2', 'A100', 'device_type', '设备类型', '20', '0', '1', '2017-08-29 13:36:13', '1', '2017-08-29 13:36:13', null, '0');


-- ----------------------------
-- Records of sys_file
-- ----------------------------
INSERT INTO `sys_file` VALUES ('09615477f47e4a2db2c2e0e3725476fc', 'pom.xml', '20170316155001361_pom.xml', '5399', '\\20170316155001361_pom.xml', '1', '2017-03-16 15:50:01', '1', '2017-03-16 15:50:01', '0');
INSERT INTO `sys_file` VALUES ('1bce8989d9c441b1bd342aaaf3e58e3a', 'TRC29.xls', '20170316151143284_TRC29.xls', '23552', '\\20170316151143284_TRC29.xls', '1', '2017-03-16 15:11:43', '1', '2017-03-16 15:11:43', '0');
INSERT INTO `sys_file` VALUES ('32b95eeebb024dceab4fafbfddf629ed', 'archetype_catalog.xml', '20170316151534182_archetype_catalog.xml', '5456930', '\\20170316151534182_archetype_catalog.xml', '1', '2017-03-16 15:15:34', '1', '2017-03-16 15:15:34', '0');
INSERT INTO `sys_file` VALUES ('6d6d9a16f22e4422bda1d84f122b17e3', 'pom.xml', '20170316160051601_pom.xml', '5399', '\\20170316160051601_pom.xml', '1', '2017-03-16 16:00:52', '1', '2017-03-16 16:00:52', '0');
INSERT INTO `sys_file` VALUES ('b304f8fd5b964efda8e59545227e4d1e', 'pom.xml', '20170316154454316_pom.xml', '5399', '\\20170316154454316_pom.xml', '1', '2017-03-16 15:44:54', '1', '2017-03-16 15:44:54', '0');
INSERT INTO `sys_file` VALUES ('be607bc1b5af4a338446486b2045788a', 'pom.xml', '2017031615191185_pom.xml', '5399', '\\2017031615191185_pom.xml', '1', '2017-03-16 15:19:11', '1', '2017-03-16 15:19:11', '0');


-- ----------------------------
-- Records of sys_log
-- ----------------------------
INSERT INTO `sys_log` VALUES ('087567f1007842d3974293723fc06e30', '1', '系统发布管理', '1', '2017-09-05 10:02:02', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36', '/a/osRom/list', 'POST', 'reqObj={\"queryId\":\"osRom_list\",\"pageName\":\"/a\",\"pageInfo\":null,\"query\":null,\"conditions\":[{\"osVersion\":\"...', '');
INSERT INTO `sys_log` VALUES ('1007c5e1a9d94c198b9a1244af1463a5', '1', '系统版本管理-系统版本信息', '1', '2017-09-05 10:02:02', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36', '/a/osRom/index', 'GET', '', '');
INSERT INTO `sys_log` VALUES ('17c724e462c4426bbb5732770fec953f', '1', '系统管理-角色管理-查看', '1', '2017-09-05 10:01:35', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36', '/a/sys/role/list', 'POST', 'reqObj={\"queryId\":\"role_list\",\"pageName\":\"/a\",\"pageInfo\":null,\"query\":null,\"conditions\":[{\"name\":\"\"}]}', '');
INSERT INTO `sys_log` VALUES ('4de589e0ec7649369b4adea4d7d8031a', '1', '系统管理-角色管理-查看', '1', '2017-09-05 10:01:39', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36', '/a/sys/role/form', 'GET', 'id=1', '');
INSERT INTO `sys_log` VALUES ('673710d54aa64d58a2858956642f0100', '1', '系统发布管理', '1', '2017-09-05 10:17:13', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36', '/a/osRom/list', 'POST', 'reqObj={\"queryId\":\"osRom_list\",\"pageName\":\"/a\",\"pageInfo\":null,\"query\":null,\"conditions\":[{\"osVersion\":\"...', '');
INSERT INTO `sys_log` VALUES ('6aeb424d3bc04510b6dfea68451c5062', '1', '系统管理-角色管理-修改', '1', '2017-09-05 10:01:45', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36', '/a/sys/role/save', 'POST', 'id=1&officeId=1&oldName=系统管理员&name=系统管理员&oldEnname=sysadmin&enname=sysadmin&roleType=security-role&sysData=0&useable=1&dataScope=1', '');
INSERT INTO `sys_log` VALUES ('802fc58ff45c4fb586846fc64231e980', '1', '系统管理-角色管理-修改', '1', '2017-09-05 10:01:52', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36', '/a/sys/role/save', 'POST', 'id=7&officeId=1&oldName=设备管理员&name=设备管理员&oldEnname=d&enname=d&roleType=security-role&sysData=1&useable=1&dataScope=2&remarks=测试说明', '');
INSERT INTO `sys_log` VALUES ('ab75e4a2e8434bcab69fe5e26380e429', '1', '系统登录', '1', '2017-09-05 10:01:29', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36', '/a', 'GET', 'login=', '');
INSERT INTO `sys_log` VALUES ('c79f3ead14494df291ca969ca21af3a3', '1', '系统版本管理-系统版本信息', '1', '2017-09-05 10:17:13', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36', '/a/osRom/index', 'GET', '', '');
INSERT INTO `sys_log` VALUES ('c925fa41159e48dc8d5bd6d2ae3af8e1', '1', '系统管理-角色管理-查看', '1', '2017-09-05 10:01:45', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36', '/a/sys/role/list', 'POST', 'reqObj={\"queryId\":\"role_list\",\"pageName\":\"/a\",\"pageInfo\":{\"pageSize\":10,\"pageNum\":1},\"query\":null,\"sortI...', '');
INSERT INTO `sys_log` VALUES ('d97b2da1b1bf44ad9eeab86e12300921', '1', '系统管理-角色管理', '1', '2017-09-05 10:01:35', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36', '/a/sys/role/index', 'GET', '', '');
INSERT INTO `sys_log` VALUES ('db4745c89dc24e82905899ed8f853a3f', '1', '系统管理-角色管理-查看', '1', '2017-09-05 10:01:48', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36', '/a/sys/role/form', 'GET', 'id=7', '');
INSERT INTO `sys_log` VALUES ('ffa4c517aada45d2bfbf4bf0c95bff59', '1', '系统管理-角色管理-查看', '1', '2017-09-05 10:01:52', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36', '/a/sys/role/list', 'POST', 'reqObj={\"queryId\":\"role_list\",\"pageName\":\"/a\",\"pageInfo\":{\"pageSize\":10,\"pageNum\":1},\"query\":null,\"sortI...', '');



-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES ('03a36ea58d6542fd8665cea51edbf54c', '4028818a56d407950156d4160e390002', '0,4028818a56d407950156d41352630000,4028818a56d407950156d4160e390002,', '修改', 'dictedit', '2', '', '000030000002000002', '', '0', 'sys:dict:edit', '字典查看', '0', '1', '2017-02-22 17:03:16', '1', '2017-02-22 17:03:16');
INSERT INTO `sys_menu` VALUES ('16a315bd32a046aeb9285196dfe26c3b', '3f9f735e67184feab91dde2a0b1a8ab1', '0,3f9f735e67184feab91dde2a0b1a8ab1,', '系统版本信息', 'OS_VerSION_INFO', '1', 'fa fa-square', '000033000002', '/osRom/index', '0', null, '系统版本信息', '0', '1', '2017-08-28 16:14:36', '1', '2017-08-28 16:14:36');
INSERT INTO `sys_menu` VALUES ('1b8c178e55874b4b947c602f3159ae5c', '4028818a56d407950156d4ecfafa0004', '0,4028818a56d407950156d41352630000,4028818a56d407950156d4ecfafa0004,', '授权', 'SYSASSIGN', '2', '', '000030000004000003', '', '0', 'sys:role:assign', '授权标识', '0', '1', '2017-03-16 09:43:40', '1', '2017-03-16 09:43:40');
INSERT INTO `sys_menu` VALUES ('2566121c199b4b3a9ea4726446775262', '4028818a56d407950156d41d32ab0003', '0,4028818a56d407950156d41352630000,4028818a56d407950156d41d32ab0003,', '查看', 'menuview', '2', '', '000030000003000001', '', '0', 'sys:menu:view', '菜单查看', '0', '1', '2017-02-22 16:55:13', '1', '2017-02-22 16:55:40');
INSERT INTO `sys_menu` VALUES ('2c4d4751d49b48d18d1fa9a6e52f5c64', '4028818a56d407950156d41d32ab0003', '0,4028818a56d407950156d41352630000,4028818a56d407950156d41d32ab0003,', '修改', 'menuedit', '2', '', '000030000003000002', '', '0', 'sys:menu:edit', '菜单修改权限', '0', '1', '2017-02-22 16:57:22', '1', '2017-02-22 16:57:22');
INSERT INTO `sys_menu` VALUES ('2cf114a84ef743afad23e6f7c40f4ed5', '4028818a56d407950156d41435830001', '0,4028818a56d407950156d41352630000,4028818a56d407950156d41435830001,', '修改', 'useredit', '2', '', '000030000001000002', '', '0', 'sys:user:edit', '用户修改', '0', '1', '2017-02-22 16:54:26', '1', '2017-02-22 16:54:26');
INSERT INTO `sys_menu` VALUES ('31d4091f571745c5a671c2a665c97214', '44208b60d2c14b58b09cfe254ec33695', '0,4028818a56d407950156d41352630000,44208b60d2c14b58b09cfe254ec33695,', '编辑', 'AREAEDIT', '2', '', '000030000006000002', '', '0', 'sys:area:edit', '区域管理查看', '0', '1', '2017-03-27 17:29:23', '1', '2017-03-27 17:29:23');
INSERT INTO `sys_menu` VALUES ('3f9f735e67184feab91dde2a0b1a8ab1', '0', '0,', '系统版本管理', 'OS_VerSION_INFO', '1', 'fa fa-chevron-left', '000033', '/osRom/list', '0', 'sys:osRom:view', null, '0', '1', '2017-08-18 16:34:43', '1', '2017-08-18 16:37:35');
INSERT INTO `sys_menu` VALUES ('402880e958eb83230158eb85a30f0000', '402880eb58d9a6d40158d9a7b21f0000', '0,402880eb58d9a6d40158d9a7b21f0000,', '系统日志', 'SYSLOG', '1', 'fa fa-edit', '000028000001', '/sys/log/index', '0', '', '', '0', '1', '2016-12-11 09:35:53', '1', '2017-02-22 17:11:03');
INSERT INTO `sys_menu` VALUES ('402880eb58d9a6d40158d9a7b21f0000', '0', '0,', '系统工具', 'SYSTOOL', '0', 'fa fa-wrench', '000028', '', '0', '', '', '0', '1', '2016-12-07 22:19:55', '1', '2017-03-24 15:45:27');
INSERT INTO `sys_menu` VALUES ('402880eb58d9a6d40158d9a995130001', '402880eb58d9a6d40158d9a7b21f0000', '0,402880eb58d9a6d40158d9a7b21f0000,', '系统监控', 'SYSLISTENER', '1', 'fa fa-pencil', '000028000002', '/../druid', '0', '', '', '0', '1', '2016-12-07 22:21:59', '1', '2017-02-22 17:11:38');
INSERT INTO `sys_menu` VALUES ('4028818a56d407950156d41352630000', '0', '0,', '系统管理', 'SYSTEM', '0', 'fa fa-tv', '000030', '', '0', null, '', '0', '1', '2016-08-29 10:14:11', '1', '2016-08-29 10:14:11');
INSERT INTO `sys_menu` VALUES ('4028818a56d407950156d41435830001', '4028818a56d407950156d41352630000', '0,4028818a56d407950156d41352630000,', '用户管理', 'USER', '1', 'fa fa-user', '000030000001', '/sys/user/index', '0', 'sys:user:view', '', '0', '1', '2016-08-29 10:15:09', '1', '2016-08-29 10:15:09');
INSERT INTO `sys_menu` VALUES ('4028818a56d407950156d4160e390002', '4028818a56d407950156d41352630000', '0,4028818a56d407950156d41352630000,', '字典管理', 'DICTIONARY', '1', 'fa fa-book', '000030000002', '/sys/dict/index', '0', '', '', '0', '1', '2016-08-29 10:17:10', '1', '2017-02-24 15:50:16');
INSERT INTO `sys_menu` VALUES ('4028818a56d407950156d41d32ab0003', '4028818a56d407950156d41352630000', '0,4028818a56d407950156d41352630000,', '菜单管理', 'FUNCTION', '1', 'fa fa-cog', '000030000003', '/sys/menu/index', '0', 'sys:menu:edit', '', '0', '1', '2016-08-29 10:24:58', '1', '2016-08-30 13:43:36');
INSERT INTO `sys_menu` VALUES ('4028818a56d407950156d4ecfafa0004', '4028818a56d407950156d41352630000', '0,4028818a56d407950156d41352630000,', '角色管理', 'Role', '1', 'fa fa-street-view', '000030000004', '/sys/role/index', '0', '', '', '0', '1', '2016-08-29 14:11:55', '1', '2016-08-30 13:44:07');
INSERT INTO `sys_menu` VALUES ('44208b60d2c14b58b09cfe254ec33695', '4028818a56d407950156d41352630000', '0,4028818a56d407950156d41352630000,', '区域管理', 'SYSAREA', '1', 'fa fa-square', '000030000006', '/sys/area/list', '0', '', '区域管理', '0', '1', '2017-03-27 17:27:02', '1', '2017-03-27 17:27:02');
INSERT INTO `sys_menu` VALUES ('48ebb2a7de204d04a41186adf57e5c89', '0', 'null0,', '设备信息', 'DEVICEINFO', '1', 'fa fa-square', '000032', null, '0', null, null, '0', '1', '2017-08-18 08:51:59', '1', '2017-09-05 08:26:29');
INSERT INTO `sys_menu` VALUES ('4992b8425f834b02990f8476582515d8', '0', '0,', '系统发布管理', 'OS_RELEASE_MANAGER', '1', 'fa fa-play', '000036', '/osRom/list', '0', null, null, '0', '1', '2017-08-29 09:03:11', '1', '2017-08-29 09:03:11');
INSERT INTO `sys_menu` VALUES ('5a2b89a4e72643698ea10da25695274e', '4028818a56d407950156d41352630000', '0,4028818a56d407950156d41352630000,', '机构管理', 'OFFICE', '1', 'fa fa-bars', '000030000005', '/sys/office/', '0', 'sys:office:view', '机构树形管理', '0', '1', '2017-02-17 14:42:05', '1', '2017-02-17 14:43:01');
INSERT INTO `sys_menu` VALUES ('5b32d03f43664de5bc49ca76156163f8', '5a2b89a4e72643698ea10da25695274e', '0,4028818a56d407950156d41352630000,5a2b89a4e72643698ea10da25695274e,', '查看', 'officeview', '2', '', '000030000005000001', '', '0', 'sys:office:view', '机构查看', '0', '1', '2017-02-22 16:59:52', '1', '2017-02-22 16:59:52');
INSERT INTO `sys_menu` VALUES ('5ef6770000614b95a05538f31ff1da23', '4028818a56d407950156d4ecfafa0004', '0,4028818a56d407950156d41352630000,4028818a56d407950156d4ecfafa0004,', '查看', 'roleview', '2', '', '000030000004000001', '', '0', 'sys:role:view', '角色查看权限', '0', '1', '2017-02-22 16:58:12', '1', '2017-02-22 16:58:12');
INSERT INTO `sys_menu` VALUES ('64d6c62cbdd348d3a536708e7a55ef44', '4992b8425f834b02990f8476582515d8', '0,4992b8425f834b02990f8476582515d8,', '被动发布', 'PASSIVE_RELEASE', '1', 'fa fa-play', '000036000001', '/osRom/passiveReleaseIndex', '0', null, null, '0', '1', '2017-08-29 09:05:39', '1', '2017-08-29 09:05:39');
INSERT INTO `sys_menu` VALUES ('697c86ebd7ec4a1c925c1f78b4ddd058', '7d97ddd1e9b64b67b5851450f904c6d2', '0,7d97ddd1e9b64b67b5851450f904c6d2,', '厂商信息', 'MAUNFACTURERINFO', '1', 'fa fa-file-text', '000031000001', '/manuFacturer/index', '0', null, '厂商管理', '0', '1', '2017-09-04 16:24:12', '1', '2017-09-04 16:24:31');
INSERT INTO `sys_menu` VALUES ('6a576f1c76f84ad8a629ca8fce367083', '44208b60d2c14b58b09cfe254ec33695', '0,4028818a56d407950156d41352630000,44208b60d2c14b58b09cfe254ec33695,', '查看', 'AREAVIEW', '2', '', '000030000006000001', '', '0', 'sys:area:view', '区域管理查看', '0', '1', '2017-03-27 17:28:22', '1', '2017-03-27 17:28:22');
INSERT INTO `sys_menu` VALUES ('6b4d3a4dd44b40f9b3fb8cf2a34602be', '7d97ddd1e9b64b67b5851450f904c6d2', '0,7d97ddd1e9b64b67b5851450f904c6d2,', '客户信息', 'CLENTINFO', '1', 'fa fa-file-picture-o', '000031000002', '/client/index', '0', null, '客户信息', '0', '1', '2017-09-04 16:25:46', '1', '2017-09-04 16:25:46');
INSERT INTO `sys_menu` VALUES ('7d97ddd1e9b64b67b5851450f904c6d2', '0', '0,', '基础数据', 'BASEDATA', '0', 'fa fa-list-ul', '000031', null, '0', null, '系统参数', '0', '1', '2017-03-16 09:39:41', '1', '2017-09-04 16:19:08');
INSERT INTO `sys_menu` VALUES ('9a79ab48ae0241049192f837eefe9dbc', '4028818a56d407950156d4160e390002', '0,4028818a56d407950156d41352630000,4028818a56d407950156d4160e390002,', '查看', 'DICTVIEW', '2', null, '000030000002000003', null, '0', 'sys:dict:view', null, '0', '1', '2017-09-05 09:00:37', '1', '2017-09-05 09:00:37');
INSERT INTO `sys_menu` VALUES ('a763dc88848547db9e4a3528bf91a688', '402880e958eb83230158eb85a30f0000', '0,402880eb58d9a6d40158d9a7b21f0000,402880e958eb83230158eb85a30f0000,', '查看', 'SYSLOGVIEW', '2', '', '000028000001000001', '', '0', 'sys:log:view', '', '0', '1', '2017-02-22 17:15:14', '1', '2017-02-22 17:15:14');
INSERT INTO `sys_menu` VALUES ('aeb4bb332c2247a1a29350247d88f8e3', '7d97ddd1e9b64b67b5851450f904c6d2', '0,7d97ddd1e9b64b67b5851450f904c6d2,', '设备型号', 'DEVICE_TYPE_MANAGER', '1', 'fa fa-github-alt', '000031000003', '/deviceType/index', '0', null, '设备型号管理', '0', '1', '2017-09-04 16:27:24', '1', '2017-09-04 16:27:38');
INSERT INTO `sys_menu` VALUES ('b37ea1c4899a400b9df85a6f8e684f60', '4028818a56d407950156d4ecfafa0004', '0,4028818a56d407950156d41352630000,4028818a56d407950156d4ecfafa0004,', '修改', 'roleedit', '2', '', '000030000004000002', '', '0', 'sys:role:edit', '权限修改', '0', '1', '2017-02-22 16:59:06', '1', '2017-02-23 09:32:52');
INSERT INTO `sys_menu` VALUES ('c554479dbffe4955bac334478337cdd5', '4028818a56d407950156d41435830001', '0,4028818a56d407950156d41352630000,4028818a56d407950156d41435830001,', '查看', 'userview', '2', '', '000030000001000001', '', '0', 'sys:user:view', '权限标识', '0', '1', '2017-02-22 16:53:34', '1', '2017-02-22 16:53:34');
INSERT INTO `sys_menu` VALUES ('ca0bbe7225ed4b2a91fca171b8c85f0c', '4992b8425f834b02990f8476582515d8', '0,4992b8425f834b02990f8476582515d8,', '已发布', 'ALREADYRELEASE', '1', 'fa fa-play', '000036000003', '/osRom/alreadyReleaseIndex', '0', null, null, '0', '1', '2017-08-29 09:08:10', '1', '2017-08-29 09:08:10');
INSERT INTO `sys_menu` VALUES ('e143b2ce5a7542359ff55a81d3e269d0', '5a2b89a4e72643698ea10da25695274e', '0,4028818a56d407950156d41352630000,5a2b89a4e72643698ea10da25695274e,', '修改', 'officeedit', '2', '', '000030000005000002', '', '0', 'sys:office:edit', '机构修改', '0', '1', '2017-02-22 17:00:45', '1', '2017-02-22 17:00:45');
INSERT INTO `sys_menu` VALUES ('e412ee34d72f4e5090687e0aeaa59915', '4992b8425f834b02990f8476582515d8', '0,4992b8425f834b02990f8476582515d8,', '主动发布', 'ACTIVE_RELEASE', '1', 'fa fa-play', '000036000002', '/osRom/activeReleaseIndex', '0', null, null, '0', '1', '2017-08-29 09:06:55', '1', '2017-08-29 09:06:55');
INSERT INTO `sys_menu` VALUES ('ef60de0b167a47e3814fb28a3313cb27', '48ebb2a7de204d04a41186adf57e5c89', '0,48ebb2a7de204d04a41186adf57e5c89,', '设备管理', 'device', '2', 'fa fa-square', '000032000001', '/device/index', null, null, null, '0', '1', '2017-08-18 08:55:38', '1', '2017-08-18 08:55:38');


-- ----------------------------
-- Records of sys_office
-- ----------------------------
INSERT INTO `sys_office` VALUES ('1', '0', '0,', '北京捷文科技有限公司', '10', '2', '100000', '2', '1', null, null, null, null, null, null, '1', null, null, '1', '2013-05-27 08:00:00', '1', '2017-09-05 08:41:08', null, '0');
INSERT INTO `sys_office` VALUES ('4', '1', '0,1,', '市场部', '30', '2', '100003', '2', '1', null, null, null, null, null, null, '1', null, null, '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_office` VALUES ('5', '1', '0,1,', '技术部', '40', '2', '100004', '2', '1', null, null, null, null, null, null, '1', null, null, '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');
INSERT INTO `sys_office` VALUES ('6', '1', '0,1,', '研发部', '50', '2', '100005', '2', '1', null, null, null, null, null, null, '1', null, null, '1', '2013-05-27 08:00:00', '1', '2013-05-27 08:00:00', null, '0');


-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES ('1', '1', '系统管理员', 'sysadmin', 'security-role', '1', '0', '1', '1', '2013-05-27 08:00:00', '1', '2017-09-05 10:01:45', null, '0');
INSERT INTO `sys_role` VALUES ('4', '6', '版本管理', 'b', 'security-role', '4', '0', '1', '1', '2013-05-27 08:00:00', '1', '2017-09-05 08:50:52', null, '0');
INSERT INTO `sys_role` VALUES ('7', '1', '设备管理员', 'd', 'security-role', '2', '1', '1', '1', '2013-05-27 08:00:00', '1', '2017-09-05 10:01:52', '测试说明', '0');


-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES ('1', '03a36ea58d6542fd8665cea51edbf54c');
INSERT INTO `sys_role_menu` VALUES ('1', '16a315bd32a046aeb9285196dfe26c3b');
INSERT INTO `sys_role_menu` VALUES ('1', '1b8c178e55874b4b947c602f3159ae5c');
INSERT INTO `sys_role_menu` VALUES ('1', '2566121c199b4b3a9ea4726446775262');
INSERT INTO `sys_role_menu` VALUES ('1', '2c4d4751d49b48d18d1fa9a6e52f5c64');
INSERT INTO `sys_role_menu` VALUES ('1', '2cf114a84ef743afad23e6f7c40f4ed5');
INSERT INTO `sys_role_menu` VALUES ('1', '31d4091f571745c5a671c2a665c97214');
INSERT INTO `sys_role_menu` VALUES ('1', '3f9f735e67184feab91dde2a0b1a8ab1');
INSERT INTO `sys_role_menu` VALUES ('1', '402880e958eb83230158eb85a30f0000');
INSERT INTO `sys_role_menu` VALUES ('1', '402880eb58d9a6d40158d9a7b21f0000');
INSERT INTO `sys_role_menu` VALUES ('1', '402880eb58d9a6d40158d9a995130001');
INSERT INTO `sys_role_menu` VALUES ('1', '4028818a56d407950156d41352630000');
INSERT INTO `sys_role_menu` VALUES ('1', '4028818a56d407950156d41435830001');
INSERT INTO `sys_role_menu` VALUES ('1', '4028818a56d407950156d4160e390002');
INSERT INTO `sys_role_menu` VALUES ('1', '4028818a56d407950156d41d32ab0003');
INSERT INTO `sys_role_menu` VALUES ('1', '4028818a56d407950156d4ecfafa0004');
INSERT INTO `sys_role_menu` VALUES ('1', '44208b60d2c14b58b09cfe254ec33695');
INSERT INTO `sys_role_menu` VALUES ('1', '48ebb2a7de204d04a41186adf57e5c89');
INSERT INTO `sys_role_menu` VALUES ('1', '4992b8425f834b02990f8476582515d8');
INSERT INTO `sys_role_menu` VALUES ('1', '5a2b89a4e72643698ea10da25695274e');
INSERT INTO `sys_role_menu` VALUES ('1', '5b32d03f43664de5bc49ca76156163f8');
INSERT INTO `sys_role_menu` VALUES ('1', '5ef6770000614b95a05538f31ff1da23');
INSERT INTO `sys_role_menu` VALUES ('1', '64d6c62cbdd348d3a536708e7a55ef44');
INSERT INTO `sys_role_menu` VALUES ('1', '697c86ebd7ec4a1c925c1f78b4ddd058');
INSERT INTO `sys_role_menu` VALUES ('1', '6a576f1c76f84ad8a629ca8fce367083');
INSERT INTO `sys_role_menu` VALUES ('1', '6b4d3a4dd44b40f9b3fb8cf2a34602be');
INSERT INTO `sys_role_menu` VALUES ('1', '7d97ddd1e9b64b67b5851450f904c6d2');
INSERT INTO `sys_role_menu` VALUES ('1', '9a79ab48ae0241049192f837eefe9dbc');
INSERT INTO `sys_role_menu` VALUES ('1', 'a763dc88848547db9e4a3528bf91a688');
INSERT INTO `sys_role_menu` VALUES ('1', 'aeb4bb332c2247a1a29350247d88f8e3');
INSERT INTO `sys_role_menu` VALUES ('1', 'b37ea1c4899a400b9df85a6f8e684f60');
INSERT INTO `sys_role_menu` VALUES ('1', 'c554479dbffe4955bac334478337cdd5');
INSERT INTO `sys_role_menu` VALUES ('1', 'ca0bbe7225ed4b2a91fca171b8c85f0c');
INSERT INTO `sys_role_menu` VALUES ('1', 'e143b2ce5a7542359ff55a81d3e269d0');
INSERT INTO `sys_role_menu` VALUES ('1', 'e412ee34d72f4e5090687e0aeaa59915');
INSERT INTO `sys_role_menu` VALUES ('1', 'ef60de0b167a47e3814fb28a3313cb27');




-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES ('1', '1', '1', 'jw_admin', 'c7efd9554b843c9b0def0a2a508f602ffb8c05239876028f0b5d9436d074ef2e28ac1d1fa2d3672f', '0001', '系统管理员', 'thinkgem@163.com', '8675', '13212311232', '1', '', '0:0:0:0:0:0:0:1', '2017-09-05 10:01:29', '1', '1', '2013-05-27 08:00:00', '1', '2017-09-05 08:51:51', '最高管理员', '0');
INSERT INTO `sys_user` VALUES ('2', '1', '1', 'sd_admin', '02a3f0772fcca9f415adc990734b45c6f059c7d33ee28362c4852032', '0002', '管理员', 'aaa@g.com', 'adfadfad', '15110012321', '1', null, null, null, '1', '1', '2013-05-27 08:00:00', '1', '2017-09-05 08:51:18', '', '0');
INSERT INTO `sys_user` VALUES ('4', '1', '4', 'sd_scb', '02a3f0772fcca9f415adc990734b45c6f059c7d33ee28362c4852032', '0004', '市场部', 'test@123.com', null, '13018921021', '3', null, null, null, '1', '1', '2013-05-27 08:00:00', '1', '2017-09-05 08:55:27', null, '0');
INSERT INTO `sys_user` VALUES ('5', '1', '5', 'sd_jsb', '02a3f0772fcca9f415adc990734b45c6f059c7d33ee28362c4852032', '0005', '技术部', 'test@test.com', null, '13018921021', '1', null, null, null, '1', '1', '2013-05-27 08:00:00', '1', '2017-09-05 08:55:54', null, '0');
INSERT INTO `sys_user` VALUES ('6', '1', '6', 'sd_yfb', '02a3f0772fcca9f415adc990734b45c6f059c7d33ee28362c4852032', '0006', '研发部', 'test@123.com', null, '13018921021', '3', null, null, null, '1', '1', '2013-05-27 08:00:00', '1', '2017-09-05 08:56:12', null, '0');


-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES ('1', '1');
INSERT INTO `sys_user_role` VALUES ('2', '1');
INSERT INTO `sys_user_role` VALUES ('4', '7');
INSERT INTO `sys_user_role` VALUES ('5', '1');
INSERT INTO `sys_user_role` VALUES ('6', '4');
INSERT INTO `sys_user_role` VALUES ('9b94f683a3174ff7a04bd009016e2005', '1');


-- ----------------------------
-- Records of t_client_info
-- ----------------------------
INSERT INTO `t_client_info` VALUES ('1', '银联商务', '0001', '0', '2017-09-23 00:09:55', '', '2017-08-21 08:39:09', '', '0');
INSERT INTO `t_client_info` VALUES ('7', '工商银行', '01', '系统管理员', '2017-09-01 17:46:27', '系统管理员', '2017-09-01 17:46:27', null, '0');



-- ----------------------------
-- Records of t_device_type_info
-- ----------------------------
INSERT INTO `t_device_type_info` VALUES ('3', '000014', 'A90', '系统管理员', '2017-09-01 17:40:54', '系统管理员', '2017-09-01 17:45:26', null, '0');
INSERT INTO `t_device_type_info` VALUES ('4', '000012', 'A90', '系统管理员', '2017-09-01 17:42:44', '系统管理员', '2017-09-01 17:42:44', null, '0');

-- ----------------------------
-- Records of t_manufacturer_info
-- ----------------------------
INSERT INTO `t_manufacturer_info` VALUES ('1', '艾体威尔', '000014', '北京市', '0', '2017-08-13 00:55:38', '0', '2017-08-20 21:19:56', '', '0');
INSERT INTO `t_manufacturer_info` VALUES ('5', '联迪', '000012', '福建', '系统管理员', '2017-09-01 17:33:52', '系统管理员', '2017-09-01 17:33:52', null, '0');

