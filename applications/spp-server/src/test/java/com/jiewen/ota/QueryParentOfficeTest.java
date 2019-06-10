package com.jiewen.ota;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class QueryParentOfficeTest {

	public static void main(String[] args) {

		QueryParentOfficeTest tdt = new QueryParentOfficeTest();
		Office office = tdt.getRootOffice("4");
		System.out.println(office.getId() + "    " + office.getParentId() + "    " + office.getName());
	}

	public Office getRootOffice(String parentId) {
		QueryParentOfficeTest tdt = new QueryParentOfficeTest();
		List<Office> list = tdt.connectDbExecuSql(parentId);
		Office office = list.get(0);
		if (office.getParentId().equals("0")) {
			return office;
		}
		return getRootOffice(office.getParentId());
	}

	public class Office {

		private String id;

		private String parentId;

		private String parentIds;

		private String name;

		private String sort;

		private String areaId;

		private String code;

		private String type;

		private String grade;

		private String address;

		private String zipCode;

		private String master;

		public String getId() {
			return id;
		}

		public void setId(String id) {
			this.id = id;
		}

		public String getParentId() {
			return parentId;
		}

		public void setParentId(String parentId) {
			this.parentId = parentId;
		}

		public String getParentIds() {
			return parentIds;
		}

		public void setParentIds(String parentIds) {
			this.parentIds = parentIds;
		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public String getSort() {
			return sort;
		}

		public void setSort(String sort) {
			this.sort = sort;
		}

		public String getAreaId() {
			return areaId;
		}

		public void setAreaId(String areaId) {
			this.areaId = areaId;
		}

		public String getCode() {
			return code;
		}

		public void setCode(String code) {
			this.code = code;
		}

		public String getType() {
			return type;
		}

		public void setType(String type) {
			this.type = type;
		}

		public String getGrade() {
			return grade;
		}

		public void setGrade(String grade) {
			this.grade = grade;
		}

		public String getAddress() {
			return address;
		}

		public void setAddress(String address) {
			this.address = address;
		}

		public String getZipCode() {
			return zipCode;
		}

		public void setZipCode(String zipCode) {
			this.zipCode = zipCode;
		}

		public String getMaster() {
			return master;
		}

		public void setMaster(String master) {
			this.master = master;
		}

	}

	public List<Office> connectDbExecuSql(String params) {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		List<Office> officeList = new ArrayList<Office>();

		// MySQL的JDBC连接语句
		// URL编写格式：jdbc:mysql://主机名称：连接端口/数据库的名称?参数=值
		String url = "jdbc:mysql://10.123.199.114:3306/spp?user=spp&password=BPnV273CNEQ44mFK";

		// 查询语句
		String cmd = "SELECT * FROM sys_office o WHERE o.id = '" + params + "'";
		try {
			Class.forName("com.mysql.jdbc.Driver"); // 加载驱动
			conn = DriverManager.getConnection(url); // 获取数据库连接
			stmt = conn.createStatement(); // 创建执行环境
			// 读取数据
			System.out.println(cmd);
			rs = stmt.executeQuery(cmd); // 执行查询语句，返回结果数据集
			rs.last(); // 将光标移到结果数据集的最后一行，用来下面查询共有多少行记录
			System.out.println("共有" + rs.getRow() + "行记录");
			rs.beforeFirst(); // 将光标移到结果数据集的开头

			while (rs.next()) { // 循环读取结果数据集中的所有记录
				System.out.println(rs.getRow() + "、 id:" + rs.getString("id") + "\t" + "parentId:"
						+ rs.getString("parent_id") + "\t" + "name:" + rs.getString("name"));
				Office office = new Office();
				office.setId(rs.getString("id"));
				office.setParentId(rs.getString("parent_id"));
				office.setName(rs.getString("name"));
				officeList.add(office);
			}

		} catch (ClassNotFoundException e) {
			System.out.println("加载驱动异常");
			e.printStackTrace();
		} catch (SQLException e) {
			System.out.println("数据库异常");
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close(); // 关闭结果数据集
				if (stmt != null)
					stmt.close(); // 关闭执行环境
				if (conn != null)
					conn.close(); // 关闭数据库连接
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return officeList;
	}
}
