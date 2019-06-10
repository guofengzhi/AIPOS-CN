package com.jiewen.ota;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class BatchImportRelationTest {

	public static void main(String[] args) {
		List<String> fileSqlList = buildExecuSql("t_tms_file");
		List<String> strategySqlList = buildExecuSql("t_tms_strategy");
		List<String> fileIds = new ArrayList<String>();
		List<String> strategyIds = new ArrayList<String>();
		for (int i = 0; i < fileSqlList.size(); i++) {
			String fileSql = fileSqlList.get(i);
			fileIds.addAll(connectDbExecuSql(fileSql));
		}
		for (int j = 0; j < strategySqlList.size(); j++) {
			String strategySql = strategySqlList.get(j);
			strategyIds.addAll(connectDbExecuSql(strategySql));
		}
		int count = 0;
		for (int i = 0; i < fileIds.size(); i++) {
			String sql = "insert into t_tms_file_strategy(file_id, strategy_id) "
					+ "values('" + fileIds.get(i) + "', '" + strategyIds.get(i) + "')";
			System.out.println(sql);
			execuSql(sql);
			count++;
		}
		System.out.println("共成功录入" + count + "条数据！");
	}

	/**
	 * 获取指定数据库表中某一种厂商的id列表,有几种厂商就有几条数据
	 * @param tableName
	 * @return	
	 */
	public static List<String> buildExecuSql(String tableName) {
		String manufactures[] = {"A70", "航天信息", "联迪", "艾体威尔"};
		List<String> sqlList = new ArrayList<>();
		for (String manufacture : manufactures) {
			String sql = "SELECT id FROM " + tableName + " WHERE `manufacture_no`='" + manufacture + "';";
			sqlList.add(sql);
		}
		return sqlList;
	}
	
	public static List<String> connectDbExecuSql(String sql) {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String url = "jdbc:mysql://10.123.199.114:3306/spp?useUnicode=true&characterEncoding=utf8";
		String user = "spp";
		String password = "BPnV273CNEQ44mFK";
		List<String> ids = new ArrayList<String>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(url, user, password);
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			while(rs.next()) {
				ids.add(rs.getString(1));
			}
		} catch (ClassNotFoundException e) {
			System.out.println("加载驱动异常");
			e.printStackTrace();
			return null;
		} catch (SQLException e) {
			System.out.println("数据库异常");
			e.printStackTrace();
			return null;
		} finally {
			try {
				if (stmt != null)
					stmt.close();
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return ids;
	}

	public static int execuSql(String sql) {
		Connection conn = null;
		Statement stmt = null;
		int rs = 0;
		String url = "jdbc:mysql://10.123.199.114:3306/spp?useUnicode=true&characterEncoding=utf8";
		String user = "spp";
		String password = "BPnV273CNEQ44mFK";
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(url, user, password);
			stmt = conn.createStatement();
			rs = stmt.executeUpdate(sql);
		} catch (ClassNotFoundException e) {
			System.out.println("加载驱动异常");
			e.printStackTrace();
			return 0;
		} catch (SQLException e) {
			System.out.println("数据库异常");
			e.printStackTrace();
			return 0;
		} finally {
			try {
				if (stmt != null)
					stmt.close();
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return rs;
	}
}
