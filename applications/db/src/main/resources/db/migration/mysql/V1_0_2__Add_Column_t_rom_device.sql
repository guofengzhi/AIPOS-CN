ALTER TABLE `t_rom_device`
ADD COLUMN `record_rom_id`  bigint NOT NULL COMMENT '发布流水记录' AFTER `upgrade_type`;


ALTER TABLE `t_os_rom_info`
ADD COLUMN `rom_file_size`  BIGINT NOT NULL COMMENT 'rom文件大小' AFTER `os_packet_type`;