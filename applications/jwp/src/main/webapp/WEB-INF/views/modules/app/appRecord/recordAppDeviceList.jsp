<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="app.record.already.release.device.tab" /></h5>
</div>

<!-- Main content -->
<div class="modal-body">
	<div class="row">
		<div class="col-xs-12">
			<div class="dataTables_filter" id="deviceSearchDiv" style="text-align: left;" role="form">
				<div class="has-feedback form-group">
					<select name="manufacturerNo" id="manufacturerNo"
						onchange="manuFacturerChange()" data-placeholder="<spring:message code='app.apprecord.please.select.the.equipment.manufacturer' />"
						class="form-control select2" style="margin-left:0px;width: 226.5px">
						<option value=""></option>
						<c:forEach items="${manuFacturerList}" var="manuFacturer"
							varStatus="idxStatus">
							<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
						</c:forEach>
					</select>
				</div>
				<div class="has-feedback form-group">    
				    <select name="deviceType" id="deviceTypeId" style="margin-left:0px;width: 226.5px"
						onchange="deviceTypeChange()" data-placeholder="<spring:message code='app.apprecord.please.select.the.device.type' />"
						class="form-control select2">
						<option value=""></option>
					</select>
				</div>
				<div class="has-feedback form-group">
					<input placeholder="<spring:message code='app.apprecord.please.enter.the.device.sn.number' />" id="deviceSn" name="deviceSn"
					 style="margin-left:0px;width: 226.5px"	class="form-control" type="search" title="<spring:message code='app.apprecord.please.enter.the.device.sn.number' />"/>
				</div>
				<div class="btn-group">
					<button type="button" class="btn btn-primary"
						data-btn-type="search">
						<spring:message code="common.query" />
					</button>
					<button type="button" class="btn btn-default" data-btn-type="reset">
						<spring:message code="common.reset" />
					</button>
				</div>
			</div>

			<div class="box-body">
				<table id="device_table"
					class="table table-bordered table-striped table-hover">

				</table>
			</div>

		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</div>

<script>
var deviceform = $("#deviceSearchDiv").form({baseEntity: false});
deviceform.initComponent();
	var deviceTable,winId = "merWin";
	var config={
			singleSelect:null
	};
	$(function() {
		var recordId = '${recordId}';
		//init table and fill data
		deviceTable = new CommonTable("device_table", "already_app_device_list", "deviceSearchDiv",
				"/device/getAppRecordDeviceList?id=" + recordId, config);
	})
	
	function operation(value, type, rowObj){
		var oper = "";
		if(value == '1' || value == '0'){
			oper += "<span class='label label-success'>"+"<spring:message code='app.apprecord.upgraded' />"+"</span>";
		}else{
			oper += "<span class='label label-danger'>"+"<spring:message code='app.apprecord.not.upgraded' />"+"</span>";
		}
        return oper;
	}
	
	function operationUpgradeType(upgradeType, type, rowObj){
		var oper = "";
		if(upgradeType == '0'){
			oper += "<span>"+"<spring:message code='app.management.app.update' />"+"</span>";
		}else if(upgradeType == '1'){
			oper += "<span>"+"<spring:message code='app.management.app.uninstall' />"+"</span>";
		}else{
			oper += "<span>-</span>";
		}
        return oper;
	}

</script>

