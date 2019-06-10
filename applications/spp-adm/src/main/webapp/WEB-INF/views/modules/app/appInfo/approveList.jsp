<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i> <spring:message
					code="common.homepage" /></a></li>
		<li><a href="#"><spring:message code="app.information.approval.tab" /></a></li>
		<li class="active"><spring:message code="app.information.tab" /></li>
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
							type="search" title="<spring:message code='app.appinfo.please.enter.the.application.name' />" style=margin-left:0px;"width: 226.5px;" />
					</div>
					<div class="has-feedback form-group">
					<input placeholder="<spring:message code='app.information.please.input.app.developer' />" name="appDeveloper" class="form-control"
							title="<spring:message code='app.information.please.input.app.developer' />" style="margin-left:0px;width: 226.5px;" />
					</div>
					<div class="has-feedback form-group">
						<select name="platform" id="platform" data-placeholder="<spring:message code='app.information.platform' />"
							class="form-control select2" style="margin-left:0px;width: 226.5px;">
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
							style="margin-left:0px;width: 226.5px;">
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
				</div>
				<div class="box-body">
					<table id="approve_table"
						class="table table-condensed table-bordered table-striped table-hover">
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
	var approveTable;
	var winId = "appInfoWin";
	var config = {
		singleSelect : null
	};
	$(function() {
		//init table and fill data
		approveTable = new CommonTable("approve_table", "approveInfo_list",
				"appInfoSearchDiv", "/approvalRecord/approveList", config);
	})

	var deviceProcessDef = {
		appInfoDetail : function(id) {
			modals.openWin({
				winId : winId,
				title : '<spring:message code="app.information.detail" />',
				width : '900px',
				url : basePath + "/approvalRecord/approveForm?id=" + id
			});
		},
		approveDetail : function(id) {
			modals.openWin({
				winId : winId,
				title : '<spring:message code="app.information.approval.detail" />',
				width : '900px',
				url : basePath + "/approvalRecord/approveDetailIndex?id=" + id
			});
		}
	}

	function operationAppLogo(appLogo, type, rowObj) {
		var oper = "";
		if (appLogo == null || appLogo == '') {
			oper += "<div class='textavatar' style='width: 40px;' data-name='"+rowObj.appName+"'></div>"
		} else {
			oper += "<div class='appimg'> <img src='"+ rowObj.appLogo + "' class='appimg-circle' /></div>";
		}
		return oper;
	}

	function operationApproveFlag(approveFlag) {
		var oper = "";
		if (approveFlag == '0') {
			oper += "<span class='label label-success'>" + '<spring:message code="app.information.flag.already.online" />' + "</span>";
		} else if (approveFlag == '1') {
			oper += "<span class='label label-danger'>" + '<spring:message code="app.information.flag.under.review" />' + "</span>";
		} else if (approveFlag == '2') {
			oper += "<span class='label label-danger'>" + '<spring:message code="app.information.flag.unapprove" />' + "</span>";
		} else if (approveFlag == '3') {
			oper += "<span class='label label-danger'>" + '<spring:message code="app.information.flag.already.offline" />' + "</span>";
		}
		return oper;
	}

	function operation(id, type, rowObj) {
		var oper = "&nbsp;&nbsp;&nbsp;";
		if (id == '1') {
			oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.appInfoDetail(\""
					+ rowObj.id + "\")'>" + '<spring:message code="app.information.approval.button" />' + "</a>";
		} else if (id == '0') {
			oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.approveDetail(\""
					+ rowObj.id + "\")'>" + '<spring:message code="app.information.detail.button" />' + "</a>";
		}
		return oper;
	}
</script>
