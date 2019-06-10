package com.jiewen.ota;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.jiewen.commons.util.DateTimeUtil;

public class BatchImportFileTest {

	public static void main(String[] args) {
		List<String> sqlList = buildExecuSql();
		int count = 0;
		for (int i = 0; i < sqlList.size(); i++) {
			String sql = sqlList.get(i);
			int k;
			try {
				k = connectDbExecuSql(sql);
			} catch (Exception e) {
				break;
			}
			if (k > 0) {
				count++;
			}
		}
		System.out.println("共成功录入" + count + "条数据！");
	}

	public static List<String> buildExecuSql() {

		String fileTypes[] = {"APP", "PF", "DD", "WS", "CK", "UF"};
		String manufactures[] = {"A70", "航天信息", "联迪", "艾体威尔"};
		List<String> sqlList = new ArrayList<>();
		String currentDateTime = DateTimeUtil.getSystemDateTime("yyyy-MM-dd HH:mm:ss");
		for (String fileType : fileTypes) {
			for (String manufacture : manufactures) {
				for(int i = 1; i <= 5; i++) {
					String sql = "insert into `t_tms_file` (`file_name`, "
							+ "`manufacture_no`, "
							+ "`file_type`, "
							+ "`file_version`, "
							+ "`file_path`, "
							+ "`upload_time`, "
							+ "`remarks`, "
							+ "`file_size`, `organ_id`, `del_flag`) "
							+ "values('" + i + ".png',"
									+ "'" + manufacture + "',"
									+ "'" + fileType + "',"
									+ "'v" + i + ".0',"
									+ "'http://www.guofengzhi.top/tms/" + manufacture + "/" + fileType + "/v" + i + ".0/" + i + ".png',"
									+ "'" + currentDateTime + "', "
									+ "'" + manufacture + "-" + fileType + "-v" + i + ".0',"
									+ "'174499', '1', '0')";
					System.out.println(sql);
					sqlList.add(sql);
				}
			}
		}
		return sqlList;
	}
	
	public static int connectDbExecuSql(String sql) {
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
