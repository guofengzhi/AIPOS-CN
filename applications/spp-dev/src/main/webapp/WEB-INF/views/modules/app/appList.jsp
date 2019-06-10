<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<!-- Content Header (Page header) -->
	<!-- Main content -->
	<section class="content">
	                 			<div class="box" style="border-top-width: 0px;margin-bottom: 0px;">
									<div id="appSearchDiv" class="dataTables_filter" style="text-align: left;" role="form">
									   <div class="has-feedback form-group">
												<input id="appName" style="width: 226.5px;" name="appName" type="text" class="form-control" placeholder='<spring:message code="please.enter.the.application.name"/>'
													style="width: 100%;">
												<select id="currentApproveFlag" style="width: 226.5px;" name="currentApproveFlag" class="form-control select2" data-placeholder='<spring:message code="please.select.the.application.state"/>'>
													<option value=""></option>
													<option value="0"><spring:message code="already.online"/></option>
													<option value="1"><spring:message code="in.the.review"/></option>
													<option value="2"><spring:message code="audit.refused.to"/></option>
													<option value="3"><spring:message code="already.offline"/></option>
													<option value="4"><spring:message code="to.be.released"/></option>
												</select>
													<button type="button" class="btn btn-primary"
															data-btn-type="search">
															<spring:message code="common.query" />
														</button>
														<button type="button" class="btn btn-default" id="reset"
															data-btn-type="reset">
															<spring:message code="common.reset" />
														</button>
										</div>
										<div style="width:100%;margin-top:5px;margin-right:20px;">
											<shiro:hasPermission name="app:edit">
												<button type="button" class="btn btn-default"  style="float: right;"
													data-btn-type="appDelete"><i class="fa fa-remove"></i></button>
												<button type="button" class="btn btn-default"  style="float: right;"
													data-btn-type="appEdit"><i class="fa fa-edit"></i></button>
												<button type="button" class="btn btn-default" data-btn-type="appAdd"  style="float: right;"><i class="fa fa-plus"></i></button>
											</shiro:hasPermission>
										</div>
										</div>	
									</div>
									<div class="box-body">
										<table id="app_table"
											class="table table-bordered table-bg table-striped table-hover" style="margin-top:0px !important;">
										</table>
									</div>
	                 		<div class="tab-pane " id="tab-content-edit">
	                 		</div>
		<!-- /.row -->
	</section>
</div>
<script>
	//tableId,queryId,conditionContainer
	var appTable;
	var winId = "appWin";
	$("#currentApproveFlag").select2();
	var form=$("#app-form").form();
	$(function() {
		//查询框是否在一行设置
		var config = {
			resizeSearchDiv : false,
			language : {
				url : basePath + '<spring:message code="common.language"/>'
			}
		};
		//init table and fill data
		appTable = new CommonTable("app_table", "appTable",
				"appSearchDiv", "/app/list", config);
		form.initComponent();
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var appRowId = appTable.getSelectedRowId();
							switch (action) {
							case 'appAdd':
								window.location.href=basePath+"/app/form";
								break;
							case 'appEdit':
								if (appRowId != null) {
									window.location.href=basePath+"/app/form?id="+appRowId+"&update=update";
								}else{
									modals.info('<spring:message code="select.the.row.to.edit"/>');
									return false;
								}
								break;
							case 'appDelete':
								if (appRowId != null) {
									modals.confirm({
										cancel_label : "<spring:message code="common.cancel" />",
										title : "<spring:message code="common.sys.confirmTip" />",
										ok_label : "<spring:message code="common.confirm" />",
										text : "<spring:message code="common.confirm.delete" />",
										callback : function() {
											ajaxPost(
													basePath
															+ "/app/delete?id="
															+ appRowId,
													null,
													function(data) {
														if (data.code == 200) {
															modals
																	.correct({
																		title : '<spring:message code="common.sys.success" />',
																		cancel_label : '<spring:message code="common.confirm" />',
																		text : data.message
																	});
															appTable
																	.reloadRowData();
														} else {
															modals
																	.warn(date.message);
														}
													});
										}
									});
								}else{
									modals.info('<spring:message code="select.the.row.to.edit"/>');
								}
								break;
							}

						});

	});

	
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
			oper += "<span class='label label-success'><spring:message code='already.online'/></span>";
		} else if (approveFlag == '1') {
			oper += "<span class='label label-warning'><spring:message code='in.the.review'/></span>";
		} else if (approveFlag == '2') {
			oper += "<span class='label label-danger'><spring:message code='audit.refused.to'/></span>";
		} else if (approveFlag == '3') {
			oper += "<span class='label label-danger'><spring:message code='already.offline'/></span>";
		} else if (approveFlag == '4') {
			oper += "<span class='label label-primary'><spring:message code='to.be.released'/></span>";
		} 
		return oper;
	}
	function operation(approveFlag) {
		var oper = "";
		if (approveFlag == '0') {
			oper += '<button type="button" class="btn btn-default" disabled><spring:message code="release"/></button>';
		} else if (approveFlag == '1') {
			oper += '<button type="button" class="btn btn-default" disabled><spring:message code="release"/></button>';
		} else if (approveFlag == '2') {
			oper += '<button type="button" class="btn btn-default" disabled><spring:message code="release"/></button>';
		} else if (approveFlag == '3') {
			oper += '<button type="button" class="btn btn-default" disabled><spring:message code="release"/></button>';
		} else if (approveFlag == '4') {
			oper += '<button type="button" class="btn btn-primary" data-btn-type="release" onclick="toRelease();"><spring:message code="release"/></button>';
		}
		return oper;
	}
	
	function toRelease(){
		var appRowId = appTable.getSelectedRowId();
		if (appRowId != null) {
			modals.confirm('您确定要发布应用吗？',function(){
				ajaxPost(basePath+"/app/release?id="+appRowId,null,function(data) {
					if (data.code == 200) {
						modals.correct({
									title : '<spring:message code="common.sys.success" />',
									cancel_label : '<spring:message code="common.confirm" />',
									text : data.message
								});
						appTable.reloadRowData();
					} else {
						modals.warn(date.message);
					}
				});
			});
		}
	}
</script>
