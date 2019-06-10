<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>

<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i> <spring:message code="common.homepage" /></a></li>
		<li><a href="#"><spring:message code="common.sys.management" /></a></li>
		<li class="active"><spring:message code="sys.role.roleManage" /></li>
	</ol>
	<div class="col-xs-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
	  <div class="col-xs-12">
		<div class="box">
			  <div class="dataTables_filter" id="roleSearchDiv" style="text-align: left;">
					<div class="has-feedback form-group">
						<input style="width: 226.5px;margin-left:0px;" placeholder='<spring:message code="sys.role.tip.iputRoleName" />' name="name" class="form-control"
							type="search" likeOption="true" />
					</div>
					<div class="btn-group">
							<button type="button" class="btn btn-primary"
								data-btn-type="search"><spring:message code="common.query" /></button>
					</div>
					 
					<!-- <div class="col-sm-12" style="margin-top:10px;"> -->
					<div style="width:100%;margin-top:5px;">
						<shiro:hasPermission name="sys:role:assign">
							<button type="button" class="btn btn-primary" style="float: left;" data-btn-type="roleAssign"><spring:message code="sys.role.authorization" /></button>
						</shiro:hasPermission>
						<shiro:hasPermission name="sys:role:edit">
						   <button type="button"  class="btn btn-default"  data-btn-type="roleDelete" title="<spring:message code='delete' />" style="float: right;">
							 <i class="fa fa-remove"></i>
						   </button>
						   <button data-btn-type="roleEdit" class="btn btn-default"  title="<spring:message code='edit' />" type="button" style="float: right;">
							 <i class="fa fa-edit"></i>
						   </button>
						   <button data-btn-type="roleAdd" class="btn btn-default"  title="<spring:message code='add' />" type="button" style="float: right;">
							 <i class="fa fa-plus"></i>
						   </button>
		                 </shiro:hasPermission>
					</div>
				</div>
				<div class="box-body">
						<table id="roletable" class="table table-bordered table-striped table-hover" style="margin-top:0px !important;">
						</table>
				</div>
			</div>
		</div>
	</div>
</section>


<script>
	//tableId,queryId,conditionContainer
	var roleTable;
	var winId = "roleWin";
	
	$(function() {
		
		//init table and fill data
		roleTable = new CommonTable("roletable", "role_list", "roleSearchDiv","/sys/role/list");
		//button event   
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var roleRowId=roleTable.getSelectedRowId();
							switch (action) {
							case 'roleAdd':
								modals.openWin({
									winId : winId,
									title : '<spring:message code="sys.role.addRole" />',
									width : '600px',
									url : basePath + "/sys/role/form"
								});
								break;
							case 'roleEdit':
								if (!roleRowId) {
									modals.info('<spring:message code="sys.role.tip.selectLine" />');
									return false;
								}
								modals.openWin({
											winId : winId,
											title : '<spring:message code="sys.role.modifyRole" />【'
													+ roleTable.getSelectedRowData().name
													+ '】',
											width : '600px',
											url : basePath + "/sys/role/form?id="
													+ roleRowId
										});
								break;
							case 'roleDelete':
								if (!roleRowId) {
									modals.info('<spring:message code="sys.role.tip.selectLine" />');
									return false;
								}
								modals.confirm('<spring:message code="common.confirm.delete" />', function() {
									ajaxPost(
											basePath + "/sys/role/delete?id=" + roleRowId,
											null, function(data) {
												if (data.code == 200) {
													modals.correct(data.message);
													roleTable.reloadRowData();
												} else {
													modals.warn(data.message);
												}
											});
								})
								break;
							case 'roleAssign':
								if (!roleRowId) {
									modals.info('<spring:message code="sys.role.tip.selectLine" />');
									return false;
								}
								modals.openWin({
											winId : 'roleMeunWin',
											width : 1000,
											title : '<spring:message code="sys.role" />【'+roleTable.getSelectedRowData().name
													+ '】<spring:message code="sys.role.bindFunctioin" />',
											url : basePath
													+ '/sys/role/assign?id='
													+ roleRowId,
											hideFunc : function() {
												
											}
										})
								break;
							}
						});
	})
</script>


