<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<form id="listForm">
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i><spring:message code="common.homepage"/></a></li>
		<li><a href="#"><spring:message code="app.devicerecord.device.management.info"/></a></li>
		<li class="active"><spring:message code="common.sys.labelManagement"/></li>
	</ol>
	<div class="col-sm-12"></div>
</section>

<!-- Main content -->
<section class="content" >
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div id="tagManagerSearchDiv" class="dataTables_filter" role="form" style="text-align: left;">
						<div class="has-feedback form-group">
							<%-- <select id="orgSelect" name="orgId" style="margin-left:0px;width: 226.5px;" class="form-control select2"  data-placeholder='<spring:message code="please.select.organ" />'	 style="width:100%;">
									<option value=""></option>
									<option value=""><spring:message code="common.all" /></option>
							</select> --%>
							<input id="orgSelect" style="width: 226.5px;" name="orgId" class="form-control"  type="hidden"/>
							<input id="orgSelectValue" style="width: 226.5px;margin-left:0px;" name="orgIdValue" class="form-control" type="text" placeholder='<spring:message code="please.select.organ" />'/>
						</div>
						<div class="has-feedback form-group">
							<input class="form-control"  style="margin-left:0px;width: 226.5px;" id="tagName" type="text" name="tagName"
								placeholder='<spring:message code="sys.labelManagement.labelName"/>' />
						</div>
						<div class="btn-group">
							<button type="button" class="btn btn-primary"
								data-btn-type="search"><spring:message code="common.query"/></button>
							<button type="button" class="btn btn-default"
								data-btn-type="reset"><spring:message code="common.reset"/></button>
						</div>
				<div style="width:100%;margin-top:5px;">
					<shiro:hasPermission name="sys:tagManager:edit">
									<button data-btn-type="manageTerm" class="btn btn-primary"  title="<spring:message code='sys.labelManagement.binding.device' />" type="button" style="float:left;">
									<i class="fa fa-plus"><spring:message code="sys.labelManagement.binding.device" /></i>
									</button>
					</shiro:hasPermission>
				 	<shiro:hasPermission name="sys:tagManager:edit">
						    <button type="button" class="btn btn-default"  data-btn-type="tagManagerDelete"  title="<spring:message code="common.delete" />" style="float:right;">
								<i class="fa fa-remove"></i>
							</button>
							<button data-btn-type="tagManagerEdit" class="btn btn-default"  title="<spring:message code="common.edit" />" type="button" style="float:right;">
								<i class="fa fa-edit"></i>
							</button>
							 <button data-btn-type="tagManagerAdd" class="btn btn-default"  title="<spring:message code="common.add" />" type="button" style="float:right;">
								<i class="fa fa-plus"></i>
							</button>
					</shiro:hasPermission>
				</div>
				</div>
                 
					<div class="box-body" style="padding:0px 10px 10px 10px">
						<table id="tagManager_table"
							class="table table-bordered table-bg table-striped table-hover" style="margin-top:0px !important;">
						</table>
					</div>
					<!-- /.box-body -->
				</div>
			</div>
			<!-- /.col -->
		</div>
		<!-- /.row -->
</section>
</form>
<script>
	//tableId,queryId,conditionContainer
	var tagManagerTable;
	var winId = "tagManagerWin";
	$(function() {
		//$("#orgSelect").select2();
		//查询框是否在一行设置
		var config={
			resizeSearchDiv:false,
			language : {
				url: basePath+'<spring:message code="common.language"/>'
			}
		};
		//init table and fill data
		tagManagerTable = new CommonTable("tagManager_table", "tagManagerTable", "tagManagerSearchDiv",
				"/sys/tagManager/list",config);
		
/* 		var secSelect = document.getElementById("orgSelect");
		$.ajax({
			url : basePath + '/sys/office/treeData',
			success : function(dataJson) {
				for (var i = 0; i < dataJson.length; i++) {
					var oOption = document.createElement("OPTION");
					oOption.value = dataJson[i].id;
					var parent = dataJson[i].parentId;
					oOption.text = dataJson[i].text;
					var nodes = dataJson[i].nodes;
					$(oOption).attr('parent', parent);
					secSelect.options.add(oOption);
				}
			}
		}); */
		
		$('button[data-btn-type]').click(
				function() {
					var action = $(this).attr('data-btn-type');
					var tagManagerRowId = tagManagerTable.getSelectedRowId();
					switch (action) {
					case 'tagManagerAdd':
						modals.openWin({
							winId : winId,
							title : '<spring:message code="add.lable" />',
							width : '900px',
							url : basePath + "/sys/tagManager/form"
						});
						break;
					case 'tagManagerEdit':
						if (!tagManagerRowId) {
							modals.info('<spring:message code="common.promt.edit"/>');
							return false;
						}
						modals
								.openWin({
									winId : winId,
									title : '<spring:message code="sys.merchant.edit"/>【'
											+ tagManagerTable
													.getSelectedRowData().tagName
											+ '】',
									width : '900px',
									url : basePath
											+ "/sys/tagManager/form?id="
											+ tagManagerRowId
								});
						break;
					case 'tagManagerDelete':
						if (!tagManagerRowId) {
							modals.info('<spring:message code="common.promt.delete"/>');
							return false;
						}
						if(!checkTagManagerBundTerm(tagManagerRowId)){
							modals.info('<spring:message code="sys.labelManagement.hasDevice.notice"/>');
							return false;
						}
						modals.confirm({
							cancel_label:"<spring:message code="common.cancel" />",
							title:"<spring:message code="common.sys.confirmTip" />",
							ok_label:"<spring:message code="common.confirm" />",
							text:"<spring:message code="common.confirm.delete" />",
							callback: function() {
							ajaxPost(basePath + "/sys/tagManager/delete?id="
									+ tagManagerRowId, null, function(data) {
								if (data.code == 200) {
									modals.correct({
										title:'<spring:message code="common.sys.success" />',
										cancel_label:'<spring:message code="common.confirm" />',
										text:data.message});
									tagManagerTable.reloadRowData();
								} else {
									modals.warn(date.message);
								}
							});
						}});
						break;
					case 'manageTerm':
						if (!tagManagerRowId) {
							modals.info('<spring:message code="please.select.bund.row" />');
							return false;
						}
						toManageTerm(tagManagerRowId);
						break;
					}
				});
		});
	function manageTerm(id){	
		var oper = "&nbsp;&nbsp;&nbsp;";
		oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='toManageTerm(\"" + id +"\")'>"+'<spring:message code="sys.labelManagement.binding.device" />'+"</a>";
        return oper;
	}
	function toManageTerm(id){
		$.ajax({
			url:basePath+ "/sys/tagManager/toBoundTermTagManager",
			type:'POST',
			traditional:true,
			data:{'id':id},
			success:function(res){
				$("#listForm").html(res);
			}
		});
	}
	
	function checkTagManagerBundTerm(tagId){
		var flag = '';
		$.ajax({
			url:basePath+ "/sys/tagManager/checkTagManagerBundTerm",
			type:'POST',
			traditional:true,
			async:false,
			data:{'tagId':tagId},
			success:function(res){
				flag = res.hasDataFlag;
			}
		});
		return flag;
	}
	$(function(){
		$("#orgSelectValue").click(function(){
					modals
					.openWin({
						winId : winId,
						title : '<spring:message code="modules.device.importing.equipment.by.product.batch"/>',
						width : '300px',
						url : basePath
								+ "/sys/office/toOfficeTree"
					});
		});
	});
</script>
