<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div>&nbsp;</div>
				<div id="userSearchDiv" class="form-horizontal" role="form">
					<div class="form-group" style="margin: 1em;">
						<label class="col-sm-2 control-label" for="name"><spring:message code="sys.user.name"/></label>
						<div class="col-sm-3">
							<input class="form-control" id="name" type="text" name="name"
								placeholder="<spring:message code="sys.user.promt.name"/>" />
						</div>
						<label class="col-sm-2 control-label" for="loginname"><spring:message code="sys.user.login.name"/></label>
						<div class="col-sm-3">
							<input class="form-control" id="loginname" type="text"
								name="loginName" placeholder="<spring:message code="sys.user.promt.name"/>" />
						</div>
					</div>
					<div class="box-footer">
						<div class="text-center">
							<button type="button" class="btn btn-primary"
								data-btn-type="search"><spring:message code="common.query"/></button>
							&nbsp; &nbsp;
							<button type="button" class="btn btn-default"
								data-btn-type="reset"><spring:message code="common.reset"/></button>
						</div>
					</div>
				</div>
				<div class="dataTables_filter">
					<div class="btn-group col-sm-12">
						<shiro:hasPermission name="sys:user:edit">
							<button type="button" class="btn btn-success"
								data-btn-type="userAdd"><spring:message code="common.add"/></button>
							<button type="button" class="btn btn-success"
								data-btn-type="userEdit"><spring:message code="common.edit"/></button>
							<button type="button" class="btn btn-danger"
								data-btn-type="userDelete"><spring:message code="common.delete"/></button>
							<!-- 
							<button type="button" class="btn btn-default"
								data-btn-type="userExport">导出用户</button>
							<div class="btn btn-default btn-file" id="uploadFile">
								<i class="fa fa-paperclip"></i> 导入用户(Max. 10MB)
							</div>
							 -->
						</shiro:hasPermission>
					</div>
				</div>
				<div class="box-body">
					<table id="user_table"
						class="table table-bordered table-bg table-striped table-hover"">
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

	var userTable;
	var winId = "userWin";
	$(function() {
		
		//查询框是否在一行设置
		var config={
				resizeSearchDiv:false
		};
		//init table and fill data
		userTable = new CommonTable("user_table", "userTable", "userSearchDiv",
				"/customer/user/list",config);

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
									url : basePath + "/customer/user/form"
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
													+ "/customer/user/form?id="
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
									ajaxPost(basePath + "/customer/user/delete?id="
											+ userRowId, null, function(data) {
										if (data.code == 200) {
											modals.correct({
												title:'<spring:message code="common.sys.success" />',
												cancel_label:'<spring:message code="common.confirm" />',
												text:data.message});
											userTable.reloadRowData();
										} else {
											modals.warn(date.message);
										}
									});
								}});
								break;
							}

						});
		//form_init();
	})
</script>
