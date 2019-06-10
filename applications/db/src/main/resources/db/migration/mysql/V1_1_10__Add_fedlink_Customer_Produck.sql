--CREATE SERVER fedlink FOREIGN DATA WRAPPER mysql OPTIONS (
	--USER 'otatest',
	--HOST '10.123.199.171',
	--DATABASE 'sass_new',	
	--PASSWORD 'Eo96g6&ota@td&eV',
  --PORT 3306
--);

CREATE TABLE `sass_customer` (
  `customer_id` varchar(12) NOT NULL COMMENT '客户编号',
  `customer_name` varchar(50) DEFAULT NULL COMMENT '客户名称',
  `customer_class` varchar(2) DEFAULT NULL COMMENT '客户层级',
  `parent_id` varchar(12) DEFAULT NULL COMMENT '上级客户',
  `level` varchar(2) DEFAULT NULL COMMENT '级别',
  `customer_credits` varchar(20) DEFAULT NULL,
  `account_period` varchar(8) DEFAULT NULL COMMENT '账期',
  `remark` varchar(100) DEFAULT '' COMMENT '备注',
  `customer_id_path` varchar(500) DEFAULT NULL COMMENT '客户id路径',
  `province` varchar(10) DEFAULT NULL COMMENT '省份',
  `city` varchar(10) DEFAULT NULL COMMENT '城市',
  `industry` varchar(10) DEFAULT NULL COMMENT '行业',
  `AUTH_USER_ID` varchar(16) DEFAULT '' COMMENT '操作用户id',
  `AUTH_ORG_ID` varchar(20) DEFAULT '' COMMENT '操作用户机构号',
  `CREATE_DATE` varchar(10) DEFAULT '' COMMENT '创建日期',
  `CREATE_TIME` varchar(10) DEFAULT '' COMMENT '创建时间',
  `MODIFY_DATE` varchar(10) DEFAULT '' COMMENT '修改日期',
  `MODIFY_TIME` varchar(10) DEFAULT '' COMMENT '修改时间',
  `MODIFY_USER_ID` varchar(16) DEFAULT '' COMMENT '修改人',
  PRIMARY KEY (`customer_id`),
  KEY `customer_name` (`customer_name`)
) ENGINE=FEDERATED DEFAULT CHARSET=utf8 
CONNECTION="fedlink/sass_customer";



CREATE TABLE `sass_product_sn` (
  `id` varchar(20) NOT NULL,
  `sn` varchar(50) CHARACTER SET utf8mb4 NOT NULL COMMENT '序列号SN码',
  `pn` varchar(50) NOT NULL COMMENT 'PN码',
  `delivery_id` varchar(20) DEFAULT NULL COMMENT '发货单编号',
  `customer_id` varchar(20) NOT NULL COMMENT '客户编号',
  `contract_id` varchar(20) DEFAULT NULL COMMENT '合同编号',
  `delivery_date` varchar(10) NOT NULL COMMENT '发货日期',
  `product_id` varchar(20) NOT NULL COMMENT '产品型号',
  `detail_code` varchar(100) DEFAULT NULL COMMENT '组合型号明细',
  `version` varchar(100) NOT NULL COMMENT '版本号',
  `vendor_code` varchar(20) NOT NULL COMMENT '厂商代码',
  `product_type_code` varchar(10) NOT NULL COMMENT '产品类型代码',
  `union_pay_term_id` varchar(50) NOT NULL COMMENT '银联唯一终端标识',
  `status` varchar(2) NOT NULL COMMENT '状态（已发货、已退货）',
  `warranty_period` varchar(10) DEFAULT NULL COMMENT '保修期',
  `AUTH_USER_ID` varchar(16) DEFAULT '' COMMENT '操作用户id',
  `AUTH_ORG_ID` varchar(20) DEFAULT '' COMMENT '操作用户机构号',
  `CREATE_DATE` varchar(10) DEFAULT '' COMMENT '创建日期',
  `CREATE_TIME` varchar(10) DEFAULT '' COMMENT '创建时间',
  `MODIFY_DATE` varchar(10) DEFAULT '' COMMENT '修改日期',
  `MODIFY_TIME` varchar(10) DEFAULT '' COMMENT '修改时间',
  `MODIFY_USER_ID` varchar(16) DEFAULT '' COMMENT '修改人',
  PRIMARY KEY (`id`),
  KEY `sn` (`sn`),
  KEY `pn` (`pn`),
  KEY `contract_id` (`contract_id`),
  KEY `delivery_date` (`delivery_date`),
  KEY `product_id` (`product_id`),
  KEY `union_pay_term_id` (`union_pay_term_id`)
) ENGINE=FEDERATED DEFAULT CHARSET=utf8 CONNECTION="fedlink/sass_product_sn";

