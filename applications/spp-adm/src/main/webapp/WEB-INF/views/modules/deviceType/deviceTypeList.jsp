<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i> <spring:message code="common.homepage"/></a></li>
		<li><a href="#"><spring:message code="modules.client.basic.data"/></a></li>
		<li class="active"><spring:message code="modules.device.type.device.type.manager"/></li>
	</ol>
	<div class="col-xs-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div class="dataTables_filter" id="deviceTypeSearchDiv" style="text-align: left;" role="form">
					
					<div class="has-feedback form-group">
						<select style="margin-left:0px;width: 226.5px;" name="manufacturerNo" id="manufacturerNo" onchange="manuFacturerChange()" data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>' class="form-control select2" style="width: 170px">
						   <option value=""></option>
						  <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
					      			<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
					      </c:forEach>
						</select>
					</div>
					
					<div class="has-feedback form-group">
						<select style="margin-left:0px;width: 226.5px;" name="deviceType" id="deviceTypeId"  onchange="deviceTypeChange()"
						data-placeholder='<spring:message code="app.apprecord.please.select.the.device.type"/>' class="form-control select2" style="width: 170px;">
						   <option value=""><spring:message code="common.form.select"/></option>
						 
						</select>
					</div>
					
					<div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search"><spring:message code="common.query"/></button>
						<button type="button" class="btn btn-default"
							data-btn-type="reset"><spring:message code="common.reset"/></button>
					</div>
					<shiro:hasPermission name="device:type:edit">
						<div style="width:100%;margin-top:5px;">
							<button type="button" class="btn btn-default" style="float: right;"
								data-btn-type=delete title="<spring:message code = 'common.delete' />">
								<i class="fa fa-remove"></i>
							</button>
							<button data-btn-type="edit" class="btn btn-default" style="float: right;"
								title="<spring:message code = 'common.edit' />" type="button">
								<i class="fa fa-edit"></i>
							</button>
							<button data-btn-type="add" class="btn btn-default" style="float: right;"
								title="<spring:message code = 'common.add' />" type="button">
								<i class="fa fa-plus"></i>
							</button>
						</div>
					</shiro:hasPermission>
				</div>
				<div class="box-body">
					<table id="deviceType_table"
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
var form = $("#deviceTypeSearchDiv").form({baseEntity: false});
    form.initComponent();
	//tableId,queryId,conditionContainer
	var deviceTypeTable;
	var winId = "deviceTypeWin";
	$(function() {
		//init table and fill data
		deviceTypeTable = new CommonTable("deviceType_table", "deviceType_list", "deviceTypeSearchDiv",
				"/deviceType/list");

		//button event
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var rowId = deviceTypeTable.getSelectedRowId();
							switch (action) {
							case 'add':
								modals.openWin({
									winId : winId,
									title : '<spring:message code="modules.device.type.add.type.of.device"/>',
									width : '900px',
									url : basePath + "/deviceType/form/add"
								});
								break;
							case 'edit':
								if (!rowId) {
									modals.info('<spring:message code="common.promt.edit"/>');
									return false;
								}
								modals
										.openWin({
											winId : winId,
											title : '<spring:message code="common.edit"/>'+'【'
													+ deviceTypeTable
															.getSelectedRowData().deviceType
													+ '】',
											width : '900px',
											url : basePath + "/deviceType/form/edit?id=" + rowId
										});
								break;
							case 'delete':
								if (!rowId) {
									modals.info('<spring:message code="app.appinfo.please.select.the.lines.to.be.edited"/>');
									return false;
								}
								modals
										.confirm(
												'<spring:message code="app.appinfo.do.you.want.to.delete.the.row.data"/>',
												function() {
													ajaxPost(
															basePath
																	+ "/deviceType/delete?id="
																	+ rowId,
															null,
															function(data) {
																
																if (data.code == 200) {
																	modals.correct('<spring:message code="app.appinfo.the.data.has.been.deleted"/>');
																	deviceTypeTable
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
	
	
		function operation(id, type, rowObj){
			var oper = "&nbsp;&nbsp;&nbsp;";
			oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.deleteDevice(\"" + id +"\")'>"+'<spring:message code="common.delete"/>'+"</a>";
	        oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.editDevice(\"" + id +"\")'>"+'<spring:message code="common.edit"/>'+"</a>";
	        return oper;
	}
	
</script>
