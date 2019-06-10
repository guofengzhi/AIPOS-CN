<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i> <spring:message
					code="common.homepage" /></a></li>
		<li><a href="#"><spring:message code="app.information.approval.tab" /></a></li>
		<li class="active"><spring:message code="app.information.approval.detail.tab" /></li>
	</ol>
	<div class="col-xs-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div class="dataTables_filter" id="approveDetailSearchDiv">
				</div>
				<div class="box-body">
					<table id="approveDetail_table"
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
	var approveDetailTable;
	var config = {
		singleSelect : null
	};
	$(function() {
		var id = '${id}';
		//init table and fill data
		approveDetailTable = new CommonTable("approveDetail_table",
				"approveDetail_list", "approveDetailSearchDiv",
				"/approvalRecord/approveDetailList?id=" + id, config);
	})

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
</script>
