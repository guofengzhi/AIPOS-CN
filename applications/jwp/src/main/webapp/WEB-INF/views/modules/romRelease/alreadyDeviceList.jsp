<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<spring:message code="app.release.client" var="releaseClient"/>
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
				<div class="form-horizontal" id="deviceSearchDiv">
					
					<div class="form-group" style="margin: 1em;">
						<label class="col-sm-2 control-label"><spring:message code="app.release.industry"/></label>
						<div class="col-sm-3">
								<select name="industry" id="industry"  data-placeholder='<spring:message code="app.release.please.choose.the.industry"/>' onchange="clickIndustry()" class="form-control select2" style="width: 100%;">
									   <option value=""></option>
									  <c:forEach items="${industryList}" var="industry" varStatus="idxStatus">
								      			<option value="${industry.value}">${industry.label }</option>
								      </c:forEach>
								</select>
						</div>
						
						<label class="col-sm-2 control-label">${releaseClient }</label>
						<div class="col-sm-3">
							<sys:treeselect id="clientNo" name="clientNo" value="${client.parentId}" labelName="parentName" labelValue="${client.customerName}"
						title="${releaseClient }" url="/client/treeData" industryName="1111" extId="${client.customerId}" cssClass="form-control" allowClear="true"/>
						</div>
					</div>
					
					<div class="form-group" style="margin: 1em;">
						<label class="col-sm-2 control-label"><spring:message code="ota.table.device.sn"/></label>
						<div class="col-sm-3">
							<input placeholder='<spring:message code="app.apprecord.please.enter.the.device.sn.number"/>' id="deviceSn" name="deviceSn" class="form-control" type="search" /> 
						</div>
						<label class="col-sm-2 control-label"><spring:message code="modules.rom.release.device.upgrade"/></label>
						<div class="col-sm-3">
							<select name="versionCompareValue" id="versionCompareValue" data-placeholder='<spring:message code="modules.rom.release.device.upgrade"/>' data-allow-clear="true" class="form-control select2" style="width: 100%;">
							   <option value=""></option>
							   <option value="-1"><spring:message code="app.apprecord.not.upgraded"/></option>
							   <option value="1"><spring:message code="app.apprecord.upgraded"/></option>
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
						class="table table-bordered table-striped table-hover">
					</table>
				</div>
				
				<div class="box-footer text-right">
					<!--以下两种方式提交验证,根据所需选择-->
					<button type="button" class="btn btn-default" data-btn-type="cancel"
						data-dismiss="modal"><spring:message code="common.cancel"/></button>
					 <button type="button" onclick="submitDevice()" class="btn btn-primary"><spring:message code="common.submit"/></button>
				</div>
				<!-- /.box-body -->
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
		var osRomId = '${osRomId}';
		//init table and fill data
		deviceTable = new CommonTable("device_table", "already_device_list", "deviceSearchDiv",
				"/device/alreayPublishlist?id=" + osRomId, config);
		
		$('button[data-btn-type]').click(
				function() {
					var action = $(this).attr('data-btn-type');
					switch (action) {
					case 'addDevice':
						deviceProcessDef.addDeviceInfo()
						break;
					case 'addBatchDevice':{
						deviceProcessDef.addBatchDeviceInfo();
					}
					default:
						break;
					}

				});
	})
	
	function operation(value, type, rowObj){
		var oper = "";
		if(value == '1' || value == '0'){
			oper += "<span class='label label-success'>"+'<spring:message code="app.apprecord.upgraded"/>'+"</span>";
		}else{
			oper += "<span class='label label-danger'>"+'<spring:message code="app.apprecord.not.upgraded"/>'+"</span>";
		}
        return oper;
	}
	
</script>

