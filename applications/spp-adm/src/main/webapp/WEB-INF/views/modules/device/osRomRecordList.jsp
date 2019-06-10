<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>

<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="ota.table.system.version.list"/></h5>
</div>

<!-- Main content -->
<div class="modal-body">
	<div class="row">
		<div class="col-xs-12">
				<div class="dataTables_filter" id="osRomRecordSearchDiv">
		      	<div class="btn-group">
						<select name="manufacturerNo" id="manufacturerNo" onchange="manuFacturerChange()" data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>' class="form-control select2" style="width: 170px">
						   <option value=""></option>
						  <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
					      			<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
					      </c:forEach>
						</select>
					</div>&nbsp;&nbsp;
					
					<div class="btn-group">
						<select name="osDeviceType" id="deviceType" data-placeholder='<spring:message code="app.apprecord.please.select.the.device.type"/>' class="form-control select2" style="width: 170px;">
						   <option value=""></option>
						  <c:forEach items="${deviceTypeList}" var="deviceType" varStatus="idxStatus">
					      			<option value="${deviceType.deviceType}">${deviceType.deviceType }</option>
					      </c:forEach>
						</select>
					</div>&nbsp;&nbsp;
				
			    	<div class="btn-group">
					<input placeholder='<spring:message code="app.devicerecord.please.enter.the.syste.version"/>' name="osVersion" class="form-control"
							type="search"/> 
					
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
					<table id="osRomRecord_table"
						class="table table-bordered table-striped ">
					</table>
				</div>
				
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</div>

<script>
var osRomRecordTable;
var osRomRecordform = $("#osRomRecordSearchDiv").form({baseEntity: false});
osRomRecordform.initComponent();
	var osRomRecordform,winId = "merWin";
	var config={
			singleSelect:null
	};
	$(function() {
		//init table and fill data
		
		var id = '${id}';
		
		osRomRecordTable = new CommonTable("osRomRecord_table", "osRom_record_list", "osRomRecordSearchDiv",
				"/osRom/getOsRomByDeviceId?id=" + id,config);
		
	});
	
	function convertMb(size){
		
		var mSize = size / (1024 * 1024 * 1.0);
		if (mSize >= 1) {
			 return mSize.toFixed(2) + ' M';
		} else {
			mSize = size / (1024 * 1.0);
			if (mSize >= 1) {
				return mSize.toFixed(2) + 'K';
			} else {
				return size.toFixed(2) + 'B';
			}
		} 
	}
	
	function deviceTypeChange(){
		
		 var manufacturerNo = $("#manufacturerNo").val();
		 if(manufacturerNo == ''){
			 modals.info('<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>');
		 	$("#deviceType").empty('');
		 }
		
	}

	function manuFacturerChange(){
		
		 var params = {};
		 var manufacturerNo = $("#manufacturerNo").val();
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

