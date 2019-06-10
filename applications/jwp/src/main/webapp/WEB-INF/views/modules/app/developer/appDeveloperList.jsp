<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box box-primary">
				<!-- /.box-header -->
				<div class="dataTables_filter" id="appDeveloperSearchDiv">
					<div class="btn-group">

						<input placeholder='<spring:message code="app.developer.application.developer.name"/>' name="name"
							class="form-control" type="search" title='<spring:message code="app.developer.application.developer.name"/>' /> &nbsp;&nbsp;
					</div>
					<div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search"><spring:message code="common.query"/></button>
						<button type="button" class="btn btn-default"
							data-btn-type="reset"><spring:message code="common.reset"/></button>
					</div>
					<shiro:hasPermission name="app:developer:edit">
						<div class="btn-group">
							<button type="button" class="btn btn-success" data-btn-type="add"><spring:message code="common.add"/></button>
							<button type="button" class="btn btn-success"
								data-btn-type="edit"><spring:message code="common.edit"/></button>
							<button type="button" class="btn btn-danger"
								data-btn-type="delete"><spring:message code="common.delete"/></button>
						</div>
					</shiro:hasPermission>
				</div>
				<div class="box-body">
					<table id="appDeveloper_table"
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
var form = $("#appDeveloperSearchDiv").form({baseEntity: false});
    form.initComponent();
	//tableId,queryId,conditionContainer
	var appDeveloperTable;
	var winId = "appDeveloperWin";
	$(function() {
		//init table and fill data
		appDeveloperTable = new CommonTable("appDeveloper_table", "appDeveloper_list", "appDeveloperSearchDiv",
				"/appDeveloper/list");

		//button event
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var rowId = appDeveloperTable.getSelectedRowId();
							switch (action) {
							case 'add':
								modals.openWin({
									winId : winId,
									title : '<spring:message code="app.developer.new.developer.information"/>',
									width : '900px',
									url : basePath + "/appDeveloper/form/add"
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
											title : '<spring:message code="common.edit"/>【'
													+ appDeveloperTable
															.getSelectedRowData().name
													+ '】',
											width : '900px',
											url : basePath + "/appDeveloper/form/edit?id="
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
																	+ "/appDeveloper/delete?id="
																	+ rowId,
															null,
															function(data) {
																
																if (data.code == 200) {
																	modals.correct('<spring:message code="app.appinfo.the.data.has.been.deleted"/>');
																	appDeveloperTable
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
	
</script>
