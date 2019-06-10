<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<!-- Main content -->
<section class="content">
	<div class="row">
		<!-- /.col -->
		<div class="col-md-5">
			<div class="box box-primary">
				<!-- /.box-header -->
				<div class="dataTables_filter" id="appInfoSearchDiv">
					<div class="form-group dataTables_filter " style="margin: 1em;">
						<input placeholder='<spring:message code="ota.table.application.name"/>'
							name="appName" class="form-control" type="search" />
						<button type="button" class="btn btn-primary" style="height:37px;" data-btn-type="search">
							<spring:message code="common.query" />
						</button>
						<button type="button" class="btn btn-default"  style="height:37px;"  data-btn-type="reset">
							<spring:message code="common.reset" />
						</button>
					</div>
				</div>
				<div class="box-body">
					<table id="appInfo_table"
						class="table table-bordered table-striped table-hover">
					</table>
				</div>
				<!-- /.box-body -->
			</div>
		</div>
		<div class="col-md-7">
			<!-- Profile Image -->
			<div class="box box-primary">
				<!-- /.box-header -->
				<div class="dataTables_filter" id="appVersionSearchDiv">
					<div class="btn-group">
						<input type="hidden" name="appName" id="appNameL" /> <input
							type="hidden" name="appPackage" id="appPackage" /> <input
							type="hidden" name="clientIdentification"
							id="clientIdentification" /> <input
							placeholder='<spring:message code="app.release.please.enter.the.application.version"/>'
							name="appVersion" id="appVersion" class="form-control"
							type="search" />
					</div>

					<div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search">
							<spring:message code="common.query" />
						</button>
					</div>
					<shiro:hasPermission name="app:version:edit">
						<div class="btn-group">
							<button type="button" class="btn btn-default" data-btn-type="add"
								title="<spring:message code='common.add'/>">
								<i class="fa fa-plus"></i>
							</button>
							<button type="button" class="btn btn-default"
								data-btn-type="edit"
								title="<spring:message code='common.edit'/>">
								<i class="fa fa-edit"></i>
							</button>
							<button type="button" class="btn btn-default"
								data-btn-type="delete"
								title="<spring:message code='common.delete'/>">
								<i class="fa fa-remove"></i>
							</button>
						</div>
					</shiro:hasPermission>
				</div>
				<div class="box-body">
					<table id="appVersion_table"
						class="table table-bordered table-striped table-hover">
					</table>
				</div>
				<!-- /.box-body -->
			</div>
			<!-- /.box -->
		</div>
	</div>
	<!-- /.row -->

</section>


<script>
	var form = $("#appInfoSearchDiv").form({
		baseEntity : false
	});
	form.initComponent();
	//tableId,queryId,conditionContainer
	var appInfoTable, appVersionTable;
	var winId = "appInfoWin";
	$(function() {

		//init table and fill data

		var role_config = {
			rowClick : function(row, isSelected) {
				$("#roleId").val(isSelected ? row.id : "-1");
				$("#appNameId").remove();
				$("#appPackage").val(row.appPackage);
				$("#appNameL").val(row.appName);
				$("#clientIdentification").val(row.clientIdentification);
				if (isSelected)
					$("#appVersionSearchDiv").prepend(
							"<h5 id='appNameId' class='pull-left'>【"
									+ row.appName + "】</h5>");
				appVersionTable.reloadData();
			},
			pagingType : 'simple'
		}

		appInfoTable = new CommonTable("appInfo_table", "appInfo_version_list",
				"appInfoSearchDiv", "/appInfo/list", role_config);

		var config = {
			lengthChange : false,
			pagingType : 'simple'
		};
		//init table and fill data
		appVersionTable = new CommonTable("appVersion_table",
				"appVersion_manager_list", "appVersionSearchDiv",
				"/appVersion/list", config);

		//默认选中第一行
		setTimeout(function() {
			appInfoTable.selectFirstRow(true);
		}, 30);

		//button event
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var rowId = appVersionTable.getSelectedRowId();
							var appInfo = appInfoTable.getSelectedRowData();
							var clientIdentification = '';
							if (appInfo.clientIdentification != null
									&& appInfo.clientIdentification != '') {
								clientIdentification = appInfo.clientIdentification;
							}
							switch (action) {
							case 'add':
								modals
										.openWin({
											winId : winId,
											title : '<spring:message code="app.appinfo.new.application.information"/>',
											width : '900px',
											url : basePath
													+ "/appVersion/form/add?appInfoId="
													+ appInfo.id
										});
								break;
							case 'edit':
								if (!rowId) {
									modals
											.info('<spring:message code="app.appinfo.please.select.the.lines.to.be.edited"/>');
									return false;
								}
								modals
										.openWin({
											winId : winId,
											title : '<spring:message code="common.edit"/>'
													+ '【'
													+ appVersionTable
															.getSelectedRowData().appName
													+ '】',
											width : '900px',
											url : basePath
													+ "/appVersion/form/edit?id="
													+ rowId + "&appInfoCId"
													+ clientIdentification
										});
								break;
							case 'delete':
								if (!rowId) {
									modals
											.info('<spring:message code="app.appinfo.please.select.the.line.to.delete"/>');
									return false;
								}
								modals
										.confirm(
												'<spring:message code="app.appinfo.do.you.want.to.delete.the.row.data"/>',
												function() {
													ajaxPost(
															basePath
																	+ "/appVersion/delete?id="
																	+ rowId,
															null,
															function(data) {

																if (data.code == 200) {
																	modals
																			.correct('<spring:message code="app.appinfo.the.data.has.been.deleted"/>');
																	appVersionTable
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

	function operationAppLogo(appLogo, type, rowObj) {
		var oper = "";
		if (appLogo == null || appLogo == '') {
			oper += "<div class='textavatar' style='width: 40px;' data-name='"+rowObj.appName+"'></div>"
		} else {
			oper += "<div class='appimg'> <img src='"+ rowObj.appLogo + "' class='appimg-circle' /></div>";
		}
		return oper;
	}

	function formatFileUrl(url) {
		if (url == null || url == '')
			return '';
		var fileds = url.split("/");
		if (fileds.length == 1 && url.indexOf("/") == -1) {
			fileds = url.split("\\");
		}
		return fileds[fileds.length - 1];
	}

	function operationClientId(clientIdentification) {
		if (clientIdentification == null || clientIdentification == '') {
			return '<spring:message code="app.appinfo.currency"/>';
		}
		return clientIdentification;
	}
</script>
