package com.jiewen.spp.wrapper;

/**
 * Created by CodeGenerator on 2017/11/14.
 * 
 * @author Pang.M
 *
 */
public class RecDirectoryWrapper extends BaseWrapper {

	private String transId; // 交易流水ID

	private String directoryList; // 文件目录列表

	public String getTransId() {
		return transId;
	}

	public void setTransId(String transId) {
		this.transId = transId;
	}

	public String getDirectoryList() {
		return directoryList;
	}

	public void setDirectoryList(String directoryList) {
		this.directoryList = directoryList;
	}

	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return super.toString();
	}

}
