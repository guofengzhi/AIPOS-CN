<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i> <spring:message
					code="common.homepage" /></a></li>
		<li><a href="#"><spring:message code="app.information.manager.tab" /></a></li>
		<li class="active"><spring:message code="app.information.remote.management" /></li>
	</ol>
	<div class="col-xs-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div class="dataTables_filter" id="appInfoSearchDiv" style="text-align: left;" role="form">
					<div class="has-feedback form-group">
						<input placeholder="<spring:message code='ota.table.application.name' />" name="appName" class="form-control"
							type="search" title="<spring:message code='app.appinfo.please.enter.the.application.name' />" style="width: 226.5px;margin-left:0px;" />
					</div>
					<div class="has-feedback form-group">
					    <input placeholder="<spring:message code='app.information.please.input.app.developer' />"
							name="appDeveloper" class="form-control" title="<spring:message code='app.information.please.input.app.developer' />" style="margin-left:0px;width: 226.5px" />
					</div>
					<div class="has-feedback form-group">
						<select name="platform" id="platform" data-placeholder="<spring:message code='app.information.platform' />"
							class="form-control select2" style="margin-left:0px;width: 226.5px">
							<option value=""></option>
							<c:forEach items="${platformList}" var="platform"
								varStatus="idxStatus">
								<option value="${platform.value}">${platform.label }</option>
							</c:forEach>
						</select>
					</div>
					<div class="has-feedback form-group">
					    <select name="category" id="category"
							data-placeholder="<spring:message code='app.information.type' />" class="form-control select2"
							style="margin-left:0px;width: 226.5px">
							<option value=""></option>
							<c:forEach items="${categoryList}" var="category"
								varStatus="idxStatus">
								<option value="${category.value}">${category.label }</option>
							</c:forEach>
						</select>
					</div>
					<div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search">
							<spring:message code="common.query" />
						</button>
						<button type="button" class="btn btn-default"
							data-btn-type="reset">
							<spring:message code="common.reset" />
						</button>
					</div>
					<div style="width:100%;margin-top:5px;">
						 <button type="button" class="btn btn-primary" style="float:left;"
								data-btn-type="upgrade"><spring:message code="app.management.app.update" /></button>
						 <button type="button" class="btn btn-primary" style="float:left;"
								data-btn-type="uninstall"><spring:message code="app.management.app.uninstall" /></button>
					</div>
				</div>
				<div class="box-body">
					<table id="appTelemanagement_table"
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
	var form = $("#appInfoSearchDiv").form({
		baseEntity : false
	});
	form.initComponent();
	//tableId,queryId,conditionContainer
	var appTelemanagementTable;
	var winId = "appInfoWin";
	$(function() {
		//init table and fill data
		appTelemanagementTable = new CommonTable("appTelemanagement_table",
				"appTelemanagement_List", "appInfoSearchDiv",
				"/appInfo/appTelemanagementList");
		
		$('button[data-btn-type]').click(function() {
			var action = $(this).attr('data-btn-type');
			var rowId = appTelemanagementTable.getSelectedRowId();
			switch (action) {
			case 'upgrade':
				if (!rowId) {
					modals.info('<spring:message code="sys.role.tip.selectLine"/>');
					return false;
				}
				deviceProcessDef.telemanagementUpgrade(rowId);
				break;
			case 'uninstall':
				if (!rowId) {
					modals.info('<spring:message code="sys.role.tip.selectLine"/>');
					return false;
				}
				deviceProcessDef.telemanagementUninstall(rowId);
				break;
			}
		});
	})

	var deviceProcessDef = {
		//type: 0-安装,1-卸载
		telemanagementUpgrade : function(rowId) {
			modals.openWin({
				winId : winId,
				title : '<spring:message code="app.management.app.update" />',
				width : '1150px',
				url : basePath + "/appInfo/telemanagementDevices?id=" + rowId
						+ "&type='0'"
			});
		},
		telemanagementUninstall : function(rowId) {
			modals.openWin({
				winId : winId,
				title : '<spring:message code="app.management.app.uninstall" />',
				width : '1150px',
				url : basePath + "/appInfo/telemanagementDevices?id=" + rowId
						+ "&type='1'"
			});
		}
	}

	function operationAppLogo(appLogo, type, rowObj) {
		var oper = "";
		if (appLogo == null || appLogo == '') {
			oper += "<div class='textavatar' style='width: 40px;' data-name='"+rowObj.appName+"'></div>"
		} else {
			oper += "<div class='appimg'> <img src='" + rowObj.appLogo + "' class='appimg-circle' /></div>";
		}
		return oper;
	}
</script>
