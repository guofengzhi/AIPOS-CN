<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="#"><i class="fa fa-dashboard"></i> <spring:message code="common.homepage"/></a></li>
		<li><a href="#"><spring:message code="modules.client.basic.data"/></a></li>
		<li class="active"><spring:message code="modules.client.client.infomation"/></li>
	</ol>
	<div class="col-md-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<form:form id="clientEntity-form" name="clientEntity-form"
		modelAttribute="clientEntity" class="form-horizontal">
		<form:hidden path="id" value="${clientEntity.id }" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'>
		<div class="row">
			<div class="col-md-3">

				<!-- Profile Image -->
				<div class="box box-primary">
					<div class="box-body box-profile">
						<div id="clentInfoTree"></div>
					</div>
					<!-- /.box-body -->
				</div>
				<!-- /.box -->
			</div>
			<!-- /.col -->
			<div class="col-md-9">
				<div class="box box-primary">
					<div class="box-header with-border">
						<div class="dataTables_filter" id="clientSearchDiv">
							<div class="btn-group">
								<label class="col-sm-2 control-label"><spring:message code="modules.client.customer.name"/></label>
								<input data-placeholder='<spring:message code="modules.client.please.enter.the.customer.name"/>' name="customerName"
									class="form-control" type="search" title='<spring:message code="modules.client.please.enter.the.customer.name"/>' />
								&nbsp;&nbsp; 
								<input name="customerId" id="customerId" type="hidden" />
							</div>
							<div class="btn-group">
								<button type="button" class="btn btn-primary"
									data-btn-type="search"><spring:message code="common.query"/></button>
								&nbsp;&nbsp;
								<button type="button" class="btn btn-default"
									data-btn-type="reset"><spring:message code="common.reset"/></button>
							</div>
						</div>
						<!-- /.box-tools -->
					</div>


					<!-- /.box-header -->
					<div class="box-body" style="min-height: 420px">

						<table id="client_table"
							class="table table-bordered table-striped table-hover">
						</table>
						<!-- /.box-body -->
					</div>
					<!-- /. box -->

				</div>
			</div>
			<!-- /.row -->

		</div>
	</form:form>
</section>

<script>
	var form = $("#clientSearchDiv").form({
		baseEntity : false
	});
	form.initComponent();
	//tableId,queryId,conditionContainer
	var clientTable;
	var winId = "clientWin";
	//初始化form表单
	var pre_ids = "${menuIds}".split(",");
	$(function() {

		//init table and fill data
		clientTable = new CommonTable("client_table", "client_list",
				"clientSearchDiv", "/client/list");

		//初始化菜单树
		initTree(0);
	});

	
	function initTree(selectNodeId) {
		var treeData = null;
		ajaxPost(basePath + "/client/clientTreeData", null, function(data) {
			treeData = data;
		});
		$("#clentInfoTree").treeview({
			data : treeData,
			showBorder : true,
			showCheckbox : false,
			levels : 1,
			showIcon : false,
			onNodeSelected : function(event, data) {
				var customId = data.id;
				$("#customerId").val(customId);
				clientTable.reloadData();
			}
		});
		if (treeData.length == 0)
			return;
		//默认选中第一个节点 
		selectNodeId=selectNodeId||0;
		$("#clentInfoTree").data('treeview').selectNode(selectNodeId);
		$("#clentInfoTree").data('treeview').expandNode(selectNodeId);
		$("#clentInfoTree").data('treeview').revealNode(selectNodeId);
	}
</script>