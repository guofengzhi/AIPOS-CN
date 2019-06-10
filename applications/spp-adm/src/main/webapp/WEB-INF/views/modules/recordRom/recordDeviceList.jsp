<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="app.apprecord.a.list.of.published.devices"/></h5>
</div>

<!-- Main content -->
<div class="modal-body">
	<div class="row">
		<div class="col-xs-12">
				<div class="dataTables_filter" id="deviceSearchDiv">
						<div class="btn-group">
							<select name="manufacturerNo" id="manuNoId" onchange="manuFacturerChange()" data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>' class="form-control select2" style="width: 170px">
							   <option value=""></option>
							  <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
						      			<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
						      </c:forEach>
							</select>
						</div>
						
						<div class="btn-group">
							<select name="deviceType" id="deviceType" onchange="deviceTypeChange()"
							data-placeholder='<spring:message code="app.apprecord.please.select.the.device.type"/>' class="form-control select2" style="width: 170px">
							   <option value=""><spring:message code="common.form.select"/></option>
							
							</select>
						</div>
						
						<div class="btn-group">
							<input placeholder='<spring:message code="app.apprecord.please.enter.the.device.sn.number"/>' id="deviceSn" name="deviceSn" class="form-control"
									type="search"/> 
						</div>
					
						<div class="btn-group">
							<select name="versionCompareValue" id="versionCompareValue" data-placeholder='<spring:message code="modules.record.rom.whether.or.not.to.upgrade"/>' class="form-control select2" style="width: 170px">
							   <option value=""></option>
							   <option value="-1"><spring:message code="app.apprecord.not.upgraded"/></option>
							   <option value="0"><spring:message code="app.apprecord.upgraded"/></option>
							</select>
						</div>
					
					<div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search"><spring:message code="common.query"/></button>
						&nbsp;&nbsp;
						<button type="button" class="btn btn-default"
							data-btn-type="reset"><spring:message code="common.reset"/></button>
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
		var recordRomId = '${recordRomId}';
		//init table and fill data
		deviceTable = new CommonTable("device_table", "already_device_list", "deviceSearchDiv",
				"/device/getDeviceList?id=" + recordRomId, config);
	});

	function operation(value, type, rowObj){
		var oper = "";
		if(value == '1' || value == '0'){
			oper += "<span class='label label-success'>"+'<spring:message code="app.apprecord.upgraded"/>'+"</span>";
		}else{
			oper += "<span class='label label-danger'>"+'<spring:message code="app.apprecord.not.upgraded"/>'+"</span>";
		}
        return oper;
	}
	
	function deviceTypeChange(){
		debugger;
		 var manufacturerNo = $("#manuNoId").val();
		 if (manufacturerNo == '' || manufacturerNo == null) {
			 modals.info('<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>');
		 	$("#deviceType").empty('');
		 }
	}

	function manuFacturerChange(){
		
		 var params = {};
		 var manufacturerNo = $("#manuNoId").val();
		 if (manufacturerNo == '' || manufacturerNo == null) {
			 $("#deviceType").empty('');
		 }
		 if (manufacturerNo == '' || manufacturerNo == null) {
			 $("#deviceType").empty('');
		 }
		 params['manufacturerNo'] = manufacturerNo;
		 ajaxPost(basePath+'/deviceType/getDeviceTypeByManuNo', params, function(data, status) {
				
				if(data.code == 200){
				
					var deviceTypes = data.data;
					$("#deviceType").empty();
					
				 	 for(var i=0;i<deviceTypes.length;i++){
						
					    $("#deviceType").append("<option value=\""+deviceTypes[i].deviceType+"\">"+deviceTypes[i].deviceType+"</ooption>");
					} 
					
				}else{
					modals.warn(data.message);
				}			
		 });
	}
</script>

