
function CommonTreeTable(tableId,queryId,url,config){
	this.tableId = tableId;
	this.queryId = queryId;
	this.url =url;
	this.config = config;
	
	this.initTreeTable(tableId,queryId,url);
}


CommonTreeTable.prototype.initTreeTable=function(tableId,queryId,url){
	this.data = this.getServerData(queryId,url);
	var that = this;
	var columns = [];
	for (var i = 0; i < this.data.query.columnList.length; i++) {
		var column = this.data.query.columnList[i];
		var obj = {};
		obj["data"] = column.key;
		obj["title"] = column.header;
		obj["name"] = column.key;
		obj["visible"] = !column.hidden;
		obj["sortable"] = column.allowSort;
		obj["class"] = "text-" + column.align;
		//obj["width"]=column.width+"px";   
		//obj["sWidthOrig"]=null;  
		if (column.fnRender) { 
			var fnRender=null;
			try {
				fnRender=eval(column.fnRender)
			} catch (e) {
				if (e instanceof ReferenceError) {
					modals.error(column.fnRender+"<spring:message code='common.undefinition' />");
				} 
			}
			obj["mRender"] =fnRender;
		}
		columns.push(obj);
	}
	//this.table.destroy();
	this.table = $('#'+tableId).DataTable($.extend({
	    data:eval(this.data.data),
		"aoColumns" : columns,
		pageLength: 5,
		ordering: false,
		stateSave: false,
		"lengthChange" : false,
		"searching" : false, // 过滤
		"processing" : true,// 是否显示取数据时的那个等待提示
		"pagingType" : "full_numbers",// 分页样式 
		"language" : { // 中文支持
			"sUrl" : "/common/json/zh_CN.json"
		},
		treetable: {
			expandable: true,
			nodeIdAttr: "id",
			parentIdAttr: "parentId"
		}
	},this.config));
	
}


CommonTreeTable.prototype.getServerData=function(queryId,url){
	var retData = null;
	var reqParam={
			queryId:queryId
	}
	$.ajax({
		url:basePath+url,
		data:reqParam,
		type : 'post',
		dataType : 'json',
		async : false,
		success : function(result) {
			retData = result;
		},
		error : function(msg) {
			modals.error("状态码:" + msg.status + "   错误信息:" + msg.statusText);
		}
	})
	return retData;
}

CommonTreeTable.prototype.reloadData=function(){
	try {
		this.table.page('first').draw(false);
	}catch(e){
		console.log(e);
	}
}

