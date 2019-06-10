insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`code`,`functype`,`icon`,`level_code`,`url`,`is_show`,`permission`,`remarks`,`del_flag`,`create_by`,`create_date`,`update_by`,`update_date`) values 

('73752a6ee5f946f2a5e74993ae04c2be','0','0,','更新历史','UPDATE_HISTORY','0','fa fa-minus-square','000042',NULL,'0',NULL,NULL,0,'1','2017-09-04 20:24:28','1','2017-09-04 20:24:28'),
('8141101879514ae6b581e94ef8fa07fb','73752a6ee5f946f2a5e74993ae04c2be','0,73752a6ee5f946f2a5e74993ae04c2be,','系统版本发布查看','SYSTEM_VERSION_RECORD','1','fa fa-play','000042000002','/recordRom/index','0',NULL,NULL,0,'1','2017-09-04 20:27:45','1','2017-09-04 20:27:45'),
('fbdbb9727fe84e3b8ba7e5036b056f27','73752a6ee5f946f2a5e74993ae04c2be','0,73752a6ee5f946f2a5e74993ae04c2be,','设备更新版本查看','DEVICE_UPDATE_RECORD','1','fa fa-play','000042000001','/device/recordIndex','0',NULL,NULL,0,'1','2017-09-04 20:25:51','1','2017-09-04 20:25:51');




insert into `sys_dict` (`id`, `value`, `label`, `type`, `description`, `sort`, `parent_id`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) values('98','0','全量包','os_packet_type','升级包类型','30','0','1','2017-09-04 15:50:04','1','2017-09-04 15:50:08',NULL,'0');
insert into `sys_dict` (`id`, `value`, `label`, `type`, `description`, `sort`, `parent_id`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) values('99','1','差分包','os_packet_type','升级包类型','30','0','1','2017-09-04 15:50:43','1','2017-09-04 15:50:48',NULL,'0');

