<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>

<spring:message code='app.apprecord.upgraded' var="upgraed"/>
<spring:message code='app.apprecord.not.upgraded' var="notupgraed"/>
<spring:message code="app.release.client" var="releaseclient"/>

<style type="text/css">
.col-sm-3 {
    width: 26%;
}
</style>
<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"></h5>
</div>

<!-- Main content -->
<div class="modal-body">
	<div class="row">
		<div class="col-xs-12">
				<div class="form-horizontal" id="deviceSearchDiv">
					
					<div class="form-group" style="margin: 1em;">
						<label class="col-sm-2 control-label"><spring:message code="app.release.industry"/></label>
						<div class="col-sm-3">
								<select name="industry" id="industry"  data-placeholder='<spring:message code="app.release.please.choose.the.industry"/>' onchange="clickIndustry()" class="form-control select2" style="width: 191px">
									   <option value=""></option>
									  <c:forEach items="${industryList}" var="industry" varStatus="idxStatus">
								      			<option value="${industry.value}">${industry.label }</option>
								      </c:forEach>
								</select>
						</div>
						
						<label class="col-sm-2 control-label"><spring:message code="app.release.client"/></label>
						<div class="col-sm-3">
							<sys:treeselect id="clientNo" name="clientNo" value="${client.parentId}" labelName="parentName" labelValue="${client.customerName}"
						title='${releaseclient }' url="/client/treeData" extId="${client.customerId}" cssClass="form-control" allowClear="true"/>
						</div>
					</div>
					
					<div class="form-group" style="margin: 1em;">
						<label class="col-sm-2 control-label"><spring:message code="app.release.manufacturer"/></label>
						<div class="col-sm-3">
							<select name="manufacturerNo" id="manufacturerNo" onchange="manuFacturerChange()" 
							data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>' class="form-control select2" style="width: 190px">
							   <option value=""></option>
							  <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
						      			<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
						      </c:forEach>
							</select>
						</div>
						
						<label class="col-sm-2 control-label"><spring:message code="ota.table.device.type"/></label>
						<div class="col-sm-3">
							<select name="deviceType" id="deviceTypeId"  onchange="deviceTypeChange()"
							data-placeholder='<spring:message code="ota.table.device.type"/>' class="form-control select2" style="width: 190px;">
							   <option value=""><spring:message code="ota.table.device.type"/></option>
							</select>
						</div>
					</div>
					
					<div class="form-group" style="margin: 1em;">
						<label class="col-sm-2 control-label"><spring:message code="ota.table.device.sn"/></label>
						<div class="col-sm-3">
							<input placeholder='<spring:message code="ota.table.device.sn"/>' id="deviceSn" name="deviceSn" class="form-control"
								type="search" title='<spring:message code="ota.table.device.sn"/>' /> 
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
						class="table table-bordered table-striped table-hover">
					</table>
				</div>
				
				<div class="box-footer text-right">
					<!--以下两种方式提交验证,根据所需选择-->
					<button type="button" class="btn btn-default" data-btn-type="cancel"
						data-dismiss="modal"><spring:message code="common.cancel"/></button>
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
		var appId = '${id}';
		var clientIdentification = '${clientIdentification}';
		//init table and fill data
		deviceTable = new CommonTable("device_table", "already_app_device_list", "deviceSearchDiv",
				"/device/alreayPublishAppDeviceList?appId=" + appId + "&clientIdentification=" + clientIdentification, config);
	});
	function clickIndustry(){
		var value = $("#industry").val();
		$("#industryId").val(value);
	}
	function formatFileUrl(url){
		if (url == null || url == '') return '';
		var fileds = url.split("/");
	    if (fileds.length == 1 && url.indexOf("/") == -1){
	    	fileds = url.split("\\");
	    }
        return fileds[fileds.length - 1];
	}
	function operation(value, type, rowObj){
		var upgraed='${upgraed}';
		var notupgraed='${notupgraed}';
		
		var oper = "";
		if(value == '1' || value == '0'){
			oper += "<span style='color: green;'>"+upgraed+"</span>";
		}else{
			oper += "<span style='color: red;'>"+notupgraed+"</span>";
		}
        return oper;
	}
	
</script>

