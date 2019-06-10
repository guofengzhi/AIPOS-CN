package com.jiewen.jwp.base.web;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.alibaba.fastjson.JSON;
import com.jiewen.commons.toolkit.utils.BeanUtils;
import com.jiewen.jwp.base.entity.DataEntity;
import com.jiewen.jwp.base.query.domain.Call;
import com.jiewen.jwp.base.query.domain.Column;
import com.jiewen.jwp.base.query.domain.Query;
import com.jiewen.jwp.base.query.domain.QueryCondition;
import com.jiewen.jwp.base.query.handler.QueryDefinition;
import com.jiewen.jwp.base.utils.LocaleMessageSourceUtil;
import com.jiewen.jwp.common.JsonMapper;
import com.jiewen.jwp.common.SpringUtil;
import com.jiewen.modules.sys.utils.DictUtils;
import com.jiewen.modules.sys.utils.UserUtils;

public class ParamResult<T extends DataEntity> {

	private LocaleMessageSourceUtil messageSourceUtil = SpringUtil
			.getBean(LocaleMessageSourceUtil.class);

	private String json;

	private Query query;

	private T entity;

	private QueryCondition<T> queryCondition;

	private String objectJson;

	public String getObjectJson() {
		objectJson = JSON.toJSONString(queryCondition.getConditions().get(0));
		return objectJson;
	}

	public void setObjectJson(String objectJson) {
		this.objectJson = objectJson;
	}

	protected Logger logger = LoggerFactory.getLogger(ParamResult.class);

	/**
	 * 
	 * @param json
	 * @throws Exception
	 */
	public ParamResult(String json) {
		this.json = StringEscapeUtils.unescapeHtml4(json);
		this.queryCondition = getQueryCondition();
		this.query = initQuery();
	}

	public String getJson() {
		return json;
	}

	public void setJson(String json) {
		this.json = json;
	}

	/**
	 * 
	 * @return
	 */
	public Query getQuery() {
		return query;
	}

	public void setQuery(Query query) {
		this.query = query;
	}

	@SuppressWarnings("unchecked")
	public QueryCondition<T> getQueryCondition() {
		return JSON.parseObject(json, QueryCondition.class);
	}

	public void setQueryCondition(QueryCondition<T> queryCondition) {
		this.queryCondition = queryCondition;
	}

	/**
	 * 
	 * @param clazz
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public T getEntity(Class<T> clazz) {
		entity = (T) JsonMapper.fromJsonString(getObjectJson(), clazz);
		entity.setPage(queryCondition.getPageInfo() == null ? 1
				: queryCondition.getPageInfo().getPageNum());
		//entity.setRows(query.getPagesize());
		entity.setRows(queryCondition.getPageInfo() == null ?
				query.getPagesize(): queryCondition.getPageInfo().getPageSize());
		entity.setQuery(query);
		entity.setSortInfo(queryCondition.getSortInfo());
		entity.setCurrentUser(UserUtils.getUser());
		return entity;
	}

	public void setEntity(T entity) {
		this.entity = entity;
	}

	/**
	 * 查询表格国际化显示
	 * 
	 * @param query
	 * @throws NoSuchMethodException
	 * @throws InvocationTargetException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	protected Query initQuery() {
		Query oriQuery = QueryDefinition.getQueryById(queryCondition
				.getQueryId());
		Query query = new Query();
		query.setTableName(messageSourceUtil.getDefaultMessage(
				oriQuery.getTableName(), query.getTableName()));
		for (Column column : oriQuery.getColumnList()) {
			Column newColum = (Column) BeanUtils.cloneBean(column);
			newColum.setHeader(messageSourceUtil.getDefaultMessage(
					column.getHeader(), column.getHeader()));
			query.addColumn(newColum);
		}
		Map<String, Column> columnMap = query.getColumnMap();
		for (Map.Entry<String, Column> entry : columnMap.entrySet()) {
			Column newColum = (Column) BeanUtils.cloneBean(entry.getValue());

			newColum.setHeader(messageSourceUtil.getDefaultMessage(
					newColum.getHeader(), newColum.getHeader()));
			query.getColumnMap().put(entry.getKey(), newColum);
		}
		query.setCallList(getCallList(query));
		return query;
	}

	/**
	 * 获取初始化表格方法Call
	 * 
	 * @param query
	 *            表格xml定义
	 * @return
	 * @throws Exception
	 */
	protected List<Call> getCallList(Query query) {

		List<Call> callList = new ArrayList<>();
		List<Column> colList = query.getColumnList();
		int colLen = colList.size();
		// 列头名称
		String header = "";
		// 副表头
		String subHeader = "";
		// 列头Id
		String ids = "";
		// 列头 filter 字典Code
		String dicts = "";
		// 类类型
		String colTypes = "";
		// 初始列宽
		String initWidths = "";
		// 列的对齐方式
		String colAlign = "";
		// 列颜色
		String columnColor = "";
		// 列的显示隐藏
		String columnVisibility = "";
		String enableTooltips = "";
		String enableMultiline = query.getEnableMultiline().toString();
		// 冻结列
		String splitAt = (query.getSplitAt() == null) ? null : query
				.getSplitAt().toString();
		// 列头操作
		for (int i = 0; i < colLen; i++) {
			Column column = colList.get(i);
			if (column.getIsServerCondition()) {
				continue;
			}
			header = (i == 0) ? column.getHeader() : header + ","
					+ column.getHeader();
			subHeader = (i == 0) ? messageSourceUtil.getDefaultMessage(
					column.getSubHeader(), column.getSubHeader()) : subHeader
					+ ","
					+ messageSourceUtil.getDefaultMessage(
							column.getSubHeader(), column.getSubHeader());
			String id = column.getId() == null ? column.getKey() : column
					.getId();
			ids = (i == 0) ? id : ids + "," + id;
			dicts = (i == 0) ? column.getDict() : dicts + ","
					+ column.getDict();
			if (StringUtils.isNotBlank(column.getDict())
					&& !StringUtils.contains(column.getRender(), "$data=")) {
				column.setRender(column.getRender() + ",$data="
						+ DictUtils.getDictListJson(column.getDict()));
			}
			colTypes = (i == 0) ? column.getType() : colTypes + ","
					+ column.getType();
			// colSorting = (i == 0) ? column.getSortType() : colSorting + "," +
			// column.getSortType();
			initWidths = (i == 0) ? column.getWidth() : initWidths + ","
					+ column.getWidth();
			colAlign = (i == 0) ? column.getAlign() : colAlign + ","
					+ column.getAlign();
			columnColor = (i == 0) ? column.getColor() : columnColor + ","
					+ column.getColor();
			columnVisibility = (i == 0) ? column.getHidden().toString()
					: columnVisibility + "," + column.getHidden().toString();
			enableTooltips = (i == 0) ? column.getEnableTooltip().toString()
					: enableTooltips + ","
							+ column.getEnableTooltip().toString();
		}
		String[] commands = { "setHeader", "setInitWidths", "setColumnIds",
				"setColumnDicts", "setColTypes", "setColAlign",
				"setColumnColor", "setColumnsVisibility", "enableTooltips",
				"enableMultiline", "splitAt" };
		String[] params = { header, initWidths, ids, dicts, colTypes, colAlign,
				columnColor, columnVisibility, enableTooltips, enableMultiline,
				splitAt };
		for (int i = 0; i < commands.length; i++) {
			if (StringUtils.isBlank(params[i])) {
				continue;
			}
			Call call = new Call();
			if (commands[i].equals("setInitWidths")
					&& query.getWidthType().equals("%")) {
				call.setCommand("setInitWidthsP");
			} else {
				call.setCommand(commands[i]);
			}
			call.setParam(params[i]);
			callList.add(call);
		}
		if (query.getEnableMultiHeader()) {
			Call call = new Call();
			call.setCommand("attachHeader");
			call.setParam(subHeader);
			callList.add(call);
		}
		return callList;
	}

}
