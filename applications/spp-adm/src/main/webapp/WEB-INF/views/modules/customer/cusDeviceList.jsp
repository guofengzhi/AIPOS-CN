<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="app.release.client" var="releaseClient"/>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="#"><i class="fa fa-dashboard"></i><spring:message code="common.homepage"/></a></li>
		<li><a href="#"><spring:message code="app.devicerecord.device.management"/></a></li>
		<li class="active"><spring:message code="ota.table.device.info"/></li>
	</ol>
	<div class="col-md-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div class="form-horizontal" id="deviceSearchDiv">
					
					  <div class="form-group" style="margin: 1em;">
		
						<label class="col-sm-2 control-label" ><spring:message code="modules.device.manufacturer"/></label>
						<div class="col-sm-3">
							<select name="manufacturerNo" id="manufacturerNo" onchange="manuFacturerChange()" 
							data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>' class="form-control select2" style="width: 100%;">
							   <option value=""></option>
							  <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
						      			<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
						      </c:forEach>
							</select>
						</div>
						
						<label class="col-sm-2 control-label" ><spring:message code="ota.table.device.type"/></label>
						<div class="col-sm-3">
							<select name="osDeviceType" id="deviceTypeId" onchange="deviceTypeChange()" 
							data-placeholder='<spring:message code="app.apprecord.please.select.the.device.type"/>' class="form-control select2" style="width: 100%;">
							   <option value=""></option>
							</select>
						</div>
					
					</div>
					
					<div class="form-group" style="margin: 1em;">
		
						<label class="col-sm-2 control-label"><spring:message code="ota.table.device.sn"/></label>
						<div class="col-sm-3">
							<input placeholder='<spring:message code="app.apprecord.please.enter.the.device.sn.number"/>' id="deviceSn" name="deviceSn" class="form-control"
									type="search" /> 
						</div>
						
						<label class="col-sm-2 control-label"><spring:message code="ota.table.client.identification"/></label>
						<div class="col-sm-3">
							<select name="clientIdentification" id="clientIdentification"  data-placeholder='<spring:message code="ota.table.client.identification"/>' data-allow-clear="true" class="form-control select2" style="width: 100%;">
									   <option value=""></option>
								<c:forEach items="${clientIdentifyList}" var="clinetid" varStatus="idxStatus">
								      <option value="${clinetid.value}">${clinetid.label }</option>
								</c:forEach>
							</select>
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
				
				<div class="box-body">
					<table id="device_table"
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
var deviceform = $("#deviceSearchDiv").form({baseEntity: false});
deviceform.initComponent();
	var deviceTable,winId = "deviceWin";
	var config={
			singleSelect:null
	};
	$(function() {
		//init table and fill data
		deviceTable = new CommonTable("device_table", "customer_device_list", "deviceSearchDiv",
				"/customer/device/list",config);
		
	})
	
	var deviceProcessDef={
		view:function(id){
			modals.openWin({
				winId : winId,
				title : '<spring:message code="ota.table.device.info"/>',
				width : '900px',
				url : basePath + "/customer/device/deviceInfo?id=" + id
			});
		},
	}
	
	
	function operation(id, type, rowObj){
		var oper = "&nbsp;&nbsp;&nbsp;";
		oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.view(\"" + id +"\")'>"+'<spring:message code="ota.table.device.info"/>'+"</a>";
        return oper;
	}

</script>

