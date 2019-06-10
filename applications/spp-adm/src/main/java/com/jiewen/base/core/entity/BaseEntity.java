
package com.jiewen.base.core.entity;

import java.io.Serializable;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.xml.bind.annotation.XmlTransient;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.google.common.collect.Maps;
import com.jiewen.base.config.Global;
import com.jiewen.base.query.domain.Query;
import com.jiewen.base.sys.entity.User;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.jwp.common.utils.StringUtils;

/**
 * Created by Administrator on 2017/1/20.
 */
public abstract class BaseEntity<Clazz> implements Serializable {

	private static final long serialVersionUID = -7123135389857815796L;

	@Id
	@Column(name = "id")
	protected String id;

	@JsonIgnore
	protected Integer page;

	private Map<String, String> sqlMap;

	protected String sortInfo;

	@JsonIgnore
	protected Integer rows;

	@JsonIgnore
	protected boolean countSql = true;

	@JsonIgnore
	protected Long totals;

	/**
	 * 是否是新记录（默认：false），调用setIsNewRecord()设置新记录，使用自定义ID。
	 * 设置为true后强制执行插入语句，ID不会自动生成，需从手动传入。
	 */
	@JsonIgnore
	protected boolean isNewRecord = false;

	/**
	 * 当前用户
	 */
	protected User currentUser;

	protected Query query;

	public BaseEntity() {

	}

	public BaseEntity(String id) {
		this();
		this.id = id;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Integer getPage() {
		return page;
	}

	public void setPage(Integer page) {
		this.page = page;
	}

	public Integer getRows() {
		return rows;
	}

	public void setRows(Integer rows) {
		this.rows = rows;
	}

	public boolean isCountSql() {
		return countSql;
	}

	public void setCountSql(boolean countSql) {
		this.countSql = countSql;
	}

	public Long getTotals() {
		return totals;
	}

	public void setTotals(Long totals) {
		this.totals = totals;
	}

	/**
	 * 是否是新记录（默认：false），调用setIsNewRecord()设置新记录，使用自定义ID。
	 * 设置为true后强制执行插入语句，ID不会自动生成，需从手动传入。
	 * 
	 * @return
	 */
	public boolean getIsNewRecord() {
		return isNewRecord || StringUtils.isBlank(getId());
	}

	/**
	 * 是否是新记录（默认：false），调用setIsNewRecord()设置新记录，使用自定义ID。
	 * 设置为true后强制执行插入语句，ID不会自动生成，需从手动传入。
	 */
	public void setIsNewRecord(boolean isNewRecord) {
		this.isNewRecord = isNewRecord;
	}

	@JsonIgnore
	@XmlTransient
	public Map<String, String> getSqlMap() {
		if (sqlMap == null) {
			sqlMap = Maps.newHashMap();
		}
		return sqlMap;
	}

	public void setSqlMap(Map<String, String> sqlMap) {
		this.sqlMap = sqlMap;
	}

	public String getSortInfo() {
		return sortInfo;
	}

	public void setSortInfo(String sortInfo) {
		this.sortInfo = sortInfo;
	}

	@JsonIgnore
	@XmlTransient
	public User getCurrentUser() {
		if (currentUser == null) {
			currentUser = UserUtils.getUser();
		}
		return currentUser;
	}

	public void setCurrentUser(User currentUser) {
		this.currentUser = currentUser;
	}

	public Query getQuery() {
		return query;
	}

	public void setQuery(Query query) {
		this.query = query;
	}

	/**
	 * 全局变量对象
	 */
	@JsonIgnore
	public Global getGlobal() {
		return Global.getInstance();
	}

	/**
	 * 获取数据库名称
	 */
	@JsonIgnore
	public String getDbName() {
		return Global.getConfig("jdbc.type");
	}

	/**
	 * 插入之前执行方法，子类实现
	 */
	public abstract void preInsert();

	/**
	 * 插入之前执行方法，子类实现
	 */
	public abstract void preInsert(boolean isIdGen);

	/**
	 * 更新之前执行方法，子类实现
	 */
	public abstract void preUpdate();

	/**
	 * 删除标记（0：正常；1：删除；2：审核；）
	 */
	public static final String DEL_FLAG_NORMAL = "0";

	public static final String DEL_FLAG_DELETE = "1";

	public static final String DEL_FLAG_AUDIT = "2";

	/**
	 * 菜单禁用标记 0 显示 1 禁用
	 */
	public static final String IS_SHOW_ENABLE = "0";

	public static final String IS_SHOW_DISENABLE = "1";

	public static final String IS_VALID_NORMAL = "1";

	public static final String IS_VALID_DEL = "0";

}
