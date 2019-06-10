<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="#"><i class="fa fa-dashboard"></i> <spring:message
					code="common.homepage" /></a></li>
		<li><a href="#"><spring:message code="app.information.manager.tab" /></a></li>
		<li class="active"><spring:message code="app.record.device.updata.app.record" /></li>
	</ol>
	<div class="col-md-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div class="dataTables_filter" id="deviceSearchDiv" style="text-align: left;" role="form">
					<div class="has-feedback form-group">
						<select name="manufacturerNo" id="manufacturerNo"
							onchange="manuFacturerChange()"
							data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>'
							class="form-control select2" style="margin-left:0px;width: 226.5px">
							<option value=""></option>
							<c:forEach items="${manuFacturerList}" var="manuFacturer"
								varStatus="idxStatus">
								<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
							</c:forEach>
						</select>
					</div>
					<div class="has-feedback form-group">
						<select name="deviceType" id="deviceTypeId"
							onchange="deviceTypeChange()"
							data-placeholder='<spring:message code="app.apprecord.please.select.the.device.type"/>'
							class="form-control select2" style="margin-left:0px;width: 226.5px">
						</select>
					</div>
					<div class="has-feedback form-group">
						<input
							placeholder='<spring:message code="app.apprecord.please.enter.the.device.sn.number"/>'
							id="deviceSn" name="deviceSn" class="form-control" type="search"
							title='<spring:message code="app.apprecord.please.enter.the.device.sn.number"/>'style="margin-left:0px;width: 226.5px"/>
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
							data-btn-type="view"><spring:message code="sys.role.view"/></button>
					</div>
				</div>
				<div class="box-body">
					<table id="device_table"
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
	var deviceform = $("#deviceSearchDiv").form({
		baseEntity : false
	});
	deviceform.initComponent();
	var deviceTable, winId = "deviceWin";
	$(function() {
		//init table and fill data
		deviceTable = new CommonTable("device_table", "app_device_list",
				"deviceSearchDiv", "/device/list");
		
		$('button[data-btn-type]').click(function() {
			var action = $(this).attr('data-btn-type');
			var rowId = deviceTable.getSelectedRowId();
			switch (action) {
			case 'view':
				if (!rowId) {
					modals.info('<spring:message code="sys.role.tip.selectLine"/>');
					return false;
				}
				deviceProcessDef.recordDevice(rowId);
				break;
			}
		});
	})
	var deviceProcessDef = {
		recordDevice : function(rowId) {
			modals
					.openWin({
						winId : winId,
						title : '<spring:message code="app.devicerecord.look.at.the.history.of.the.device.update"/>',
						width : '1300px',
						url : basePath
								+ "/appVersion/toRecordAppVersionIndex?id="
								+ rowId
					});
		}
	}
</script>

