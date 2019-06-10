<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>

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
						<label class="col-sm-2 control-label"><spring:message code="ota.table.manufacturer.name"/></label>
						<div class="col-sm-3">
							<select name="manuNo" id="manufacturerNo" onchange="manuFacturerChange()" 
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
							data-placeholder='<spring:message code="app.apprecord.please.select.the.device.type"/>' class="form-control select2" style="width: 190px;">
							   <option value=""><spring:message code="app.apprecord.please.select.the.device.type"/></option>
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
					<div class="btn-group">
					    <label>
						<input type="checkbox" class="square-green" id="singleCheckBox" name="singleCheckBox"/>
						<spring:message code="app.release.single.page.submission"/>
						</label>
						&nbsp;&nbsp;
						<label>
						<input type="checkbox" class="square-green" id="allCheckBox" name="allCheckBox"/>
						<spring:message code="app.release.all.page.submissions"/>
						</label>
					</div>
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
			
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</div>

<script>
var appId = '${id}'; 
var deviceform = $("#deviceSearchDiv").form({baseEntity: false});
deviceform.initComponent();
	var deviceTable,winId = "appInfoWin";
	var config={
			singleSelect:null
	};
	$(function() {
		checkBox();
		//init table and fill data
		deviceTable = new CommonTable("device_table", "device_type_list", "deviceSearchDiv",
				"/appVersion/deviceTypelist/"+appId, config);
	})
	
	function ajaxProgressDef(url,params){
		var index = layer.index;
		$.when(ajaxPostWithDeferred(basePath+url, params, function(data, status) {})).done(function(data){
			layer.close(index);
			if(data.code == 200){
				modals.correct(data.message);
				modals.hideWin(winId);
			}else{
				modals.info(data.message);
			}	
		})
	}
	
		
	function addCheckBox(id, type, rowObj){
		var oper = "";
		var json = {};
		json[rowObj.manuNo] = rowObj.deviceType;
		var jsonStr = JSON.stringify(json);
		if ($("#allCheckBox").prop("checked")) {
			oper += "<div class='checkbox checkbox-success checkbox-inline'><input type='checkbox' id='checked" + rowObj.id +"'  value='" + jsonStr +"' name='box' checked disabled/><label for='checked"+rowObj.id+"'></label></div>";
		} else {
			if($("#singleCheckBox").prop("checked")){
				$("#allCheckBox").iCheck("enable");
				$("#singleCheckBox").iCheck("uncheck");
			}
			oper += "<div class='checkbox checkbox-success checkbox-inline'><input type='checkbox' id='checked" + rowObj.id +"' value='" + jsonStr +"' name='box' /><label for='checked"+rowObj.id+"'></label></div>";
		}
        return oper;
	}
	
	function submitDevice(){
		var allCheckBox = $("input[name='allCheckBox']:checkbox")[0];
		var manuNosAndTypes = '';
		if(allCheckBox.checked != true){
			
			$("input[name='box']:checkbox").each(function(){ 
				
				if (true == this.checked) { 
					if (manuNosAndTypes == ''){
						manuNosAndTypes += $(this).attr('value'); 
					} else {
						manuNosAndTypes += "," + $(this).attr('value'); 						
					}
				} 
			}); 
			if(manuNosAndTypes == ''){
				modals.info('<spring:message code="app.release.please.select.the.least.one.vendors.type.of.device.for.publication"/>');
				return;
			}
		}
		
		layer.msg('<spring:message code="app.release.its.being.released.please.wait.a.little.later"/>', {icon: 16,tips: [1, '#3595CC'],area: ['250px', '70px'],shade: [0.5, '#f5f5f5'],scrollbar: false,time: 500000}) ; 
		var index = layer.index;
		//系统版本id
		
		var manufacturerNo = $("#manufacturerNo").val();
		var deviceType = $("#deviceTypeId").val();
		
		$('#icon').addClass('fa fa-circle-o-notch fa-spin');
		var params = {};
		params['id'] = appId;
		params['manufacturerNo'] = manufacturerNo;	
		params['deviceType'] = deviceType;	
		params['isJPushMessage'] = '${type}';
		
		//选择所有页
		if($("#allCheckBox").prop("checked")){
			ajaxProgressDef("/appDevice/saveAllAppDeviceByType/",params);
		}else { //选择单页 或 点选
			//id数组
			params['manuNosAndTypes'] = manuNosAndTypes;
			ajaxProgressDef("/appDevice/saveAppDeviceByType/" + appId,params);
		}
	}
	
	$("#singleCheckBox").on("ifClicked",function(event){
		if(event.target.checked){
			$("input[name='box']:checkbox").iCheck("uncheck");
			$("input[name='box']:checkbox").iCheck("enable");
			$("#allCheckBox").iCheck("enable");
		}else{
			$("input[name='box']:checkbox").iCheck("check");
			$("input[name='box']:checkbox").iCheck("disable");
			$("#allCheckBox").iCheck("disable");
		}
	})
	
	$("#allCheckBox").on("ifClicked",function(event){
		if(event.target.checked){
			$("input[name='box']:checkbox").iCheck("uncheck");
			$("input[name='box']:checkbox").iCheck("enable");
			$("#singleCheckBox").iCheck("enable");
		}else{
			$("input[name='box']:checkbox").iCheck("check");
			$("input[name='box']:checkbox").iCheck("disable");
			$("#singleCheckBox").iCheck("disable");
		}
	})
	

</script>

