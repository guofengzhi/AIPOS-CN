<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i> <spring:message code="common.homepage"/></a></li>
		<li><a href="#"><spring:message code="modules.client.basic.data"/></a></li>
		<li class="active"><spring:message code="modules.manufacturer.manager"/></li>
	</ol>
	<div class="col-xs-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<div class="dataTables_filter" id="manuFacturerSearchDiv"  style="text-align: left;" role="form">
					<div class="has-feedback form-group">
						<input placeholder='<spring:message code="ota.table.manufacturer.number"/>' name="manufacturerNo"
							class="form-control" type="search" style="margin-left:0px;width: 226.5px;"/> 
					</div>
					<div class="has-feedback form-group">
						<input placeholder='<spring:message code="ota.table.manufacturer.name"/>' name="manufacturerName" 
						   class="form-control" type="search" style="margin-left:0px;width: 226.5px;"/>
					</div>
					<div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search"><spring:message code="common.query"/></button>
						<button type="button" class="btn btn-default"
							data-btn-type="reset"><spring:message code="common.reset"/></button>
					</div>
					<shiro:hasPermission name="maun:edit">
						<div style="width:100%;margin-top:5px;">
							<button type="button" class="btn btn-default" style="float: right;"
								data-btn-type=delete title="<spring:message code = 'common.delete' />">
								<i class="fa fa-remove"></i>
							</button>
							<button data-btn-type="edit" class="btn btn-default" style="float: right;"
								title="<spring:message code = 'common.edit' />" type="button">
								<i class="fa fa-edit"></i>
							</button>
							<button data-btn-type="add" class="btn btn-default" style="float: right;"
								title="<spring:message code = 'common.add' />" type="button">
								<i class="fa fa-plus"></i>
							</button>
						</div>
					</shiro:hasPermission>
				</div>
				<div class="box-body">
					<table id="manuFacturer_table"
						class="table table-bordered table-striped table-hover" style="margin-top:0px !important;">
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
var form = $("#manuFacturerSearchDiv").form({baseEntity: false});
    form.initComponent();
	//tableId,queryId,conditionContainer
	var manuFacturerTable;
	var winId = "manuFacturerWin";
	$(function() {
		//init table and fill data
		manuFacturerTable = new CommonTable("manuFacturer_table", "manuFacturer_list", "manuFacturerSearchDiv",
				"/manuFacturer/list");

		//button event
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var rowId = manuFacturerTable.getSelectedRowId();
							switch (action) {
							case 'add':
								modals.openWin({
									winId : winId,
									title : '<spring:message code="modules.manufacturer.add.manufacturer.information"/>',
									width : '900px',
									url : basePath + "/manuFacturer/form/add"
								});
								break;
							case 'edit':
								if (!rowId) {
									modals.info('<spring:message code="common.promt.edit"/>');
									return false;
								}
								modals
										.openWin({
											winId : winId,
											title : '<spring:message code="common.edit"/>'+'【'
													+ manuFacturerTable
															.getSelectedRowData().manufacturerName
													+ '】',
											width : '900px',
											url : basePath + "/manuFacturer/form/edit?id="
													+ rowId
										});
								break;
							case 'delete':
								if (!rowId) {
									modals.info('<spring:message code="common.promt.delete"/>');
									return false;
								}
								modals
										.confirm(
												'<spring:message code="common.confirm.delete"/>',
												function() {
													ajaxPost(
															basePath
																	+ "/manuFacturer/delete?id="
																	+ rowId,
															null,
															function(data) {
																
																if (data.code == 200) {
																	modals.correct('<spring:message code="app.appinfo.the.data.has.been.deleted"/>');
																	manuFacturerTable
																			.reloadRowData();
																} else {
																	modals
																			.error(data.message);
																}
															});
												})
								break;
							}

						});
		//form_init();
	})
		function operation(id, type, rowObj){
			var oper = "&nbsp;&nbsp;&nbsp;";
			oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.deleteDevice(\"" + id +"\")'>"+'<spring:message code="common.delete"/>'+"</a>";
	        oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.editDevice(\"" + id +"\")'>"+'<spring:message code="common.edit"/>'+"</a>";
	        return oper;
	}
	
</script>
