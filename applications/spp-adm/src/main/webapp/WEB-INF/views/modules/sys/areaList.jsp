<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treetable.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i>  <spring:message code="common.homepage"/></a></li>
		<li><a href="#"> <spring:message code="sys.area.system.manage"/></a></li>
		<li class="active"><spring:message code="sys.area.area.manager"/></li>
	</ol>
	<div class="col-xs-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div class="box-body">
					<table id="area_table"
						class="table table-bordered table-striped table-hover">
					</table>
				</div>
				<!-- /.box-body -->
			</div>
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</section>

<script>
	//tableId,queryId,conditionContainer
	var areaTable;
	var winId = "areaWin";
	$(function() {
		areaTable=new CommonTreeTable('area_table','area_list','/sys/area/list');
	});
	
	function viewArea(id){
		modals.openWin({
			winId : winId,
			title : '<spring:message code="sys.area.view.area.manager"/>',
			width : '900px',
			url : basePath + "/sys/area/form?action=view&id="+id
		});
	};
	function editArea(id,title){
		modals.openWin({
			winId : winId,
			title : '<spring:message code="sys.area.edit.area"/>【'
					+ title
					+ '】',
			width : '900px',
			url : basePath + "/sys/area/form?id="
					+ id
		});
	};
	function deleteArea(id){
		modals
		.confirm(
				'<spring:message code="sys.area.delete.area.all.child"/>',
				function() {
					ajaxPost(
							basePath
									+ "/sys/area/delete?id="
									+ id,
							null,
							function(data) {
								if (data.code == 200) {
									modals.correct(data.message);
									areaTable.reloadData();
								} else {
									modals.error(data.message);
								}
							});
				})
	};
	function addChildArea(id,title){
		modals.openWin({
			winId : winId,
			title : '<spring:message code="common.add"/>【'
					+ title
					+ '】<spring:message code="sys.area.blow.area"/>',
			width : '900px',
			url : basePath + "/sys/area/form?parent.id="
					+ id
		});
	}
	function dictType(value, type, rowObj,oSetting){
		return getDictLabel(eval('${fns:toJson(fns:getDictList("sys_area_type"))}'), value)
	}
	function areaShow(value, type, rowObj,oSetting){
		return '<a href="#" onClick="viewArea(\''+rowObj.id+'\')">'+value+'</a>';
	}
	
	function areaOperation(value, type, rowObj,oSetting){
		var content = '<a href="#" class="btn btn-default" onClick="editArea(\''+rowObj.id+'\',\''+rowObj.name+'\')">'+'<spring:message code="common.edit"/>'+'</a>'+
		'<a href="#" class="btn btn-default"  onclick="deleteArea(\''+rowObj.id+'\')">'+'<spring:message code="common.delete"/>'+'</a>'+
		'<a href="#" class="btn btn-default" onClick="addChildArea(\''+rowObj.id+'\',\''+rowObj.name+'\')" >'+'<spring:message code="sys.area.add.blow.area"/>'+'</a>';
		return  content;
	}
	
</script>
