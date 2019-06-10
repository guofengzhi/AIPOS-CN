<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i>
			<spring:message code="common.homepage" /></a></li>
		<li><a href="#"><spring:message code="common.sys.management" /></a></li>
		<li class="active"><spring:message code="sys.user.management" /></li>
	</ol>
	<div class="col-sm-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div id="userSearchDiv" class="dataTables_filter" style="text-align: left;" role="form">
					<div class="has-feedback form-group">
						<input id="userOrgSelect" style="width: 226.5px;" name="orgId" class="form-control"  type="hidden"/>
								<input id="userOrgSelectValue" style="width: 226.5px;margin-left:0px;" name="orgIdValue" class="form-control" type="text" placeholder='<spring:message code="please.select.organ" />'/>
					</div>
					<div class="has-feedback form-group">
							<input class="form-control" id="name" type="search" name="name" operator="like" likeoption="true" style="margin-left:0px;width: 226.5px;"
								placeholder="<spring:message code='please.input.name'/>"/>
					</div>
					<div class="has-feedback form-group">
							<input class="form-control" id="loginname" type="search" operator="like" likeoption="true" style="margin-left:0px;width: 226.5px;"
								name="loginName" placeholder="<spring:message code='please.input.loginName'/>" />
					</div>
					<div class="btn-group" style="margin-right:1px;">
							<button type="button" class="btn btn-primary"
								data-btn-type="search"><spring:message code="common.query"/></button>
							<button type="button" class="btn btn-default"
								data-btn-type="reset"><spring:message code="common.reset"/></button>
					</div>
					<!-- <div class="col-sm-12 form-group" style="float: right;margin-top:10px;margin-right:-14px;"> -->
					<div style="width:100%;margin-top:5px;">
						<shiro:hasPermission name="sys:user:edit">
							<button type="button" class="btn btn-default" style="float: right;"
								data-btn-type=userDelete title="<spring:message code='delete'/>">
								<i class="fa fa-remove"></i>
							</button>
							<button data-btn-type="userEdit" class="btn btn-default" style="float: right;"
								title="<spring:message code='edit'/>" type="button">
								<i class="fa fa-edit"></i>
							</button>
							<button data-btn-type="userAdd" class="btn btn-default" style="float: right;"
								title="<spring:message code='add'/>" type="button">
								<i class="fa fa-plus"></i>
							</button>
						</shiro:hasPermission>
					</div>
				</div>
					<div class="box-body">
						<table id="user_table"
								class="table table-bordered table-bg table-striped table-hover" style="margin-top:0px !important;">
							</table>
					</div>
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
	var userTable;
	var winId = "userWin";
	$(function() {
		//查询框是否在一行设置
		var config={
			resizeSearchDiv:false,
			language : {
				url: basePath+'<spring:message code="common.language"/>'
			}
		};
		//init table and fill data
		userTable = new CommonTable("user_table", "userTable", "userSearchDiv",
				"/sys/user/list",config);

		//button event
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var userRowId = userTable.getSelectedRowId();
							switch (action) {
							case 'userAdd':
								modals.openWin({
									winId : winId,
									title : '<spring:message code="sys.user.add"/>',
									width : '900px',
									url : basePath + "/sys/user/form"
								});
								break;
							case 'userEdit':
								if (!userRowId) {
									modals.info('<spring:message code="common.promt.edit"/>');
									return false;
								}
								modals
										.openWin({
											winId : winId,
											title : '<spring:message code="sys.user.edit"/>【'
													+ userTable
															.getSelectedRowData().name
													+ '】',
											width : '900px',
											url : basePath
													+ "/sys/user/form?id="
													+ userRowId
										});
								break;
							case 'userDelete':
								if (!userRowId) {
									modals.info('<spring:message code="common.promt.delete"/>');
									return false;
								}
								modals.confirm({
									cancel_label:"<spring:message code="common.cancel" />",
									title:"<spring:message code="common.sys.confirmTip" />",
									ok_label:"<spring:message code="common.confirm" />",
									text:"<spring:message code="common.confirm.delete" />",
									callback: function() {
									ajaxPost(basePath + "/sys/user/delete?id="
											+ userRowId, null, function(data) {
										if (data.code == 200) {
											modals.correct({
												title:'<spring:message code="common.sys.success" />',
												cancel_label:'<spring:message code="common.confirm" />',
												text:data.message});
											userTable.reloadRowData();
										} else {
											modals.warn(data.message);
										}
									});
								}});
								break;
							case 'userExport':
								modals.confirm('<spring:message code="sys.user.confirm.export"/>', function() {
									$.download(basePath + "/sys/user/export",
											"post", "userSearchDiv");
								})
							}

						});
		//form_init();
	})
	$(function(){
		$("#userOrgSelectValue").click(function(){
					modals
					.openWin({
						winId : "userOrgTree",
						title : '<spring:message code="modules.device.importing.equipment.by.product.batch"/>',
						width : '300px',
						url : basePath
								+ "/sys/office/toOfficeTree?windowId=userOrgTree&orgSelect=userOrgSelect&orgSelectValue=userOrgSelectValue"
					});
	});
});
</script>
