package com.jiewen.modules.sys.domain;

import java.io.Serializable;
import java.util.Date;

import com.jiewen.jwp.base.entity.DataEntity;

/**
 * 商户表
 * 
 * @author 李裕泽
 * @email 461539197@qq.com
 * @date 2018-11-28 15:12:53
 */
public class MerchantDO extends DataEntity implements Serializable  {

	private static final long serialVersionUID = 1L;
	

	private String id; // 序号
	

	private String merId; // 商户号
	

	private String merName; // 商户名称
	

	private String merAbbre; // 商户简称
	


      public MerchantDO() {
	        super();
	  }

	  public MerchantDO(String id) {
	        super(id);
	 }

	/**
	 * 设置：序号
	 */
	public void setId(String id) {
		this.id = id;
	}
	
	/**
	 * 获取：序号
	 */
	public String getId() {
		return id;
	}
	/**
	 * 设置：商户号
	 */
	public void setMerId(String merId) {
		this.merId = merId;
	}
	
	/**
	 * 获取：商户号
	 */
	public String getMerId() {
		return merId;
	}
	/**
	 * 设置：商户名称
	 */
	public void setMerName(String merName) {
		this.merName = merName;
	}
	
	/**
	 * 获取：商户名称
	 */
	public String getMerName() {
		return merName;
	}
	/**
	 * 设置：商户简称
	 */
	public void setMerAbbre(String merAbbre) {
		this.merAbbre = merAbbre;
	}
	
	/**
	 * 获取：商户简称
	 */
	public String getMerAbbre() {
		return merAbbre;
	}
}
