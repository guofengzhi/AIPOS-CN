package com.jiewen.ota;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Random;

import com.jiewen.commons.util.DateTimeUtil;

public class BatchImportStrategyTest {

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

		String manufactures[] = {"A70", "航天信息", "联迪", "艾体威尔"};
		String deviceTypes[] = {"A70", "A90"};
		
		List<String> sqlList = new ArrayList<>();
		String currentDateTime = DateTimeUtil.getSystemDateTime("yyyy-MM-dd HH:mm:ss");
		
		for (String deviceType : deviceTypes) {
			for (String manufacture : manufactures) {
				for(int i = 1; i <= 15; i++) {
					String sql = "insert into `t_tms_strategy` (`strategy_name`, "
							+ "`begin_date`, "
							+ "`end_date`, "
							+ "`update_time`, "
							+ "`device_type`, "
							+ "`device_sn`, "
							+ "`manufacture_no`, "
							+ "`mer_no`, `term_no`, "
							+ "`create_by`, `create_date`, `update_by`, `update_date`, "
							+ "`remarks`, `organ_id`, `del_flag`) "
							+ "values('" + manufacture + "-" + deviceType + "-" + i + "',"
							+ "'" + getRandomBeginValue() +"',"
							+ "'" + getRandomEndValue() +"',"
							+ "'O',"
							+ "'" + deviceType + "',"
							+ "'1234567890',"
							+ "'" + manufacture + "',"
							+ "'1234567890','001',"
							+ "'1','" + currentDateTime + "','1','" + currentDateTime + "',"
							+ "NULL,'1','0');";
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

	private static String getRandomBeginValue() {
		Calendar beginDate = Calendar.getInstance();
		Random randomDate = new Random();
		int beginDay = randomDate.nextInt(29) + 1;
		beginDate.set(2019, 2, beginDay, 0, 0, 0);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return sdf.format(beginDate.getTime());
	}
	
	private static String getRandomEndValue() {
		Calendar endDate = Calendar.getInstance();
		Random randomDate = new Random();
		int endDay = randomDate.nextInt(29) + 1;
		endDate.set(2019, 3, endDay, 0, 0, 0);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return sdf.format(endDate.getTime());
	}

}
