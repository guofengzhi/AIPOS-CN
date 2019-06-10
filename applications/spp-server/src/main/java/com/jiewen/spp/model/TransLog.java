package com.jiewen.spp.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Table(name = "t_upgrade_translog")
public class TransLog {
	/**
	 * ID记录
	 */
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	/**
	 * 设备型号
	 */
	@Column(name = "device_type")
	private String deviceType;

	/**
	 * 设备SN
	 */
	@Column(name = "device_sn")
	private String deviceSn;

	/**
	 * 厂商编号
	 */
	@Column(name = "manu_no")
	private String manuNo;

	/**
	 * 方法名称
	 */
	@Column(name = "method_name")
	private String methodName;

	/**
	 * json包信息
	 */
	@Column(name = "packet_info")
	private String packetInfo;

	/**
	 * 备注信息
	 */
	private String remarks;

	/**
	 * 更新时间
	 */
	@Column(name = "update_date")
	private Date updateDate;

	/**
	 * 创建时间
	 */
	@Column(name = "create_date")
	private Date createDate;

	/**
	 * 删除标记
	 */
	@Column(name = "del_flag")
	private String delFlag;

	/**
	 * 获取ID记录
	 *
	 * @return id - ID记录
	 */
	public Integer getId() {
		return id;
	}

	/**
	 * 设置ID记录
	 *
	 * @param id
	 *            ID记录
	 */
	public void setId(Integer id) {
		this.id = id;
	}

	/**
	 * 获取设备型号
	 *
	 * @return device_type - 设备型号
	 */
	public String getDeviceType() {
		return deviceType;
	}

	/**
	 * 设置设备型号
	 *
	 * @param deviceType
	 *            设备型号
	 */
	public void setDeviceType(String deviceType) {
		this.deviceType = deviceType;
	}

	/**
	 * 获取设备SN
	 *
	 * @return device_sn - 设备SN
	 */
	public String getDeviceSn() {
		return deviceSn;
	}

	/**
	 * 设置设备SN
	 *
	 * @param deviceSn
	 *            设备SN
	 */
	public void setDeviceSn(String deviceSn) {
		this.deviceSn = deviceSn;
	}

	/**
	 * 获取厂商编号
	 *
	 * @return manu_no - 厂商编号
	 */
	public String getManuNo() {
		return manuNo;
	}

	/**
	 * 设置厂商编号
	 *
	 * @param manuNo
	 *            厂商编号
	 */
	public void setManuNo(String manuNo) {
		this.manuNo = manuNo;
	}

	/**
	 * 获取方法名称
	 *
	 * @return method_name - 方法名称
	 */
	public String getMethodName() {
		return methodName;
	}

	/**
	 * 设置方法名称
	 *
	 * @param methodName
	 *            方法名称
	 */
	public void setMethodName(String methodName) {
		this.methodName = methodName;
	}

	/**
	 * 获取json包信息
	 *
	 * @return packet_info - json包信息
	 */
	public String getPacketInfo() {
		return packetInfo;
	}

	/**
	 * 设置json包信息
	 *
	 * @param packetInfo
	 *            json包信息
	 */
	public void setPacketInfo(String packetInfo) {
		this.packetInfo = packetInfo;
	}

	/**
	 * 获取备注信息
	 *
	 * @return remarks - 备注信息
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * 设置备注信息
	 *
	 * @param remarks
	 *            备注信息
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	/**
	 * 获取更新时间
	 *
	 * @return update_date - 更新时间
	 */
	public Date getUpdateDate() {
		return updateDate;
	}

	/**
	 * 设置更新时间
	 *
	 * @param updateDate
	 *            更新时间
	 */
	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}

	/**
	 * 获取创建时间
	 *
	 * @return create_date - 创建时间
	 */
	public Date getCreateDate() {
		return createDate;
	}

	/**
	 * 设置创建时间
	 *
	 * @param createDate
	 *            创建时间
	 */
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	/**
	 * 获取删除标记
	 *
	 * @return del_flag - 删除标记
	 */
	public String getDelFlag() {
		return delFlag;
	}

	/**
	 * 设置删除标记
	 *
	 * @param delFlag
	 *            删除标记
	 */
	public void setDelFlag(String delFlag) {
		this.delFlag = delFlag;
	}
}
