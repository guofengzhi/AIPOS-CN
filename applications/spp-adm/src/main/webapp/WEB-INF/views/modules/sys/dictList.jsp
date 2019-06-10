<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i> <spring:message code="common.homepage"/></a></li>
		<li><a href="#"><spring:message code="common.sys.management"/></a></li>
		<li class="active"><spring:message code="sys.dict.management"/></li>
	</ol>
	<div class="col-xs-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div class="dataTables_filter" id="dictSearchDiv" style="text-align: left;">
					<div class="has-feedback form-group">
						<select name="type" id="type" title='<spring:message code="sys.dict.promt.type.value"/>'
							data-flag="arraySelector" style="margin-left:0px;width: 226.5px;"
							data-datasrc='${typeList}' data-blank="true" tabindex="-1"
							aria-hidden="true" data-placeholder='<spring:message code="sys.dict.promt.type.value"/>'
							class="form-control select2">
						</select>
					 </div>
					<div class="has-feedback form-group">
						<input placeholder='<spring:message code="sys.dict.label.describe"/>' name="description"
							style="margin-left:0px;width: 226.5px;" class="form-control" type="search" title='<spring:message code="sys.dict.promt.type.description"/>' /> 
					</div>
					<div class="has-feedback form-group">
						<input placeholder='<spring:message code="sys.dict.promt.label"/>' name="label" class="form-control"
							style="margin-left:0px;width: 226.5px;" type="search" title='<spring:message code="sys.dict.promt.label"/>' />
					</div>
					<div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search"><spring:message code="common.query"/></button>
						<button type="button" class="btn btn-default"
							data-btn-type="reset"><spring:message code="common.reset"/></button>
					</div>
					<!-- <div class="col-sm-12 form-group" style="float: right;margin-top:10px;margin-right:-14px;"> -->
					<div style="width:100%;margin-top:5px;">
						<shiro:hasPermission name="sys:dict:edit">
						<button type="button" class="btn btn-default"  data-btn-type=delete title="<spring:message code='delete'/>" style="float: right;">
										<i class="fa fa-remove"></i>
									</button>
									<button data-btn-type="edit" class="btn btn-default"  title="<spring:message code='edit'/>" type="button" style="float:right;">
										<i class="fa fa-edit"></i>
									</button>
								<button data-btn-type="add" class="btn btn-default" title="<spring:message code='add'/>" type="button" style="float:right;">
										<i class="fa fa-plus"></i>
									</button>
									
									
						</shiro:hasPermission>
					</div>
				</div>
				<div class="box-body">
					<table id="dict_table"
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
var form = $("#dictSearchDiv").form({baseEntity: false});
    form.initComponent();
	//tableId,queryId,conditionContainer
	var dictTable;
	var winId = "dictWin";
	$(function() {
		//init table and fill data
		dictTable = new CommonTable("dict_table", "dict_list", "dictSearchDiv",
				"/sys/dict/list");

		//button event
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var rowId = dictTable.getSelectedRowId();
							switch (action) {
							case 'add':
								modals.openWin({
									winId : winId,
									title : '<spring:message code="sys.dict.add"/>',
									width : '900px',
									url : basePath + "/sys/dict/edit"
								});
								break;
							case 'edit':
								if (!rowId) {
									modals.info('<spring:message code="sys.role.tip.selectLine"/>');
									return false;
								}
								modals
										.openWin({
											winId : winId,
											title : '<spring:message code="sys.dict.edit"/>'+'【'
													+ dictTable
															.getSelectedRowData().label
													+ '】',
											width : '900px',
											url : basePath + "/sys/dict/edit?id="
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
																	+ "/sys/dict/delete/"
																	+ rowId,
															null,
															function(data) {
																if (data.code == 200) {
																	modals.correct('<spring:message code="common.promt.deleted"/>');
																	dictTable
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
