<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="ota.table.client" var="tableClient"/>
<style>

.col-sm-3 {
    width: 23%;
}
</style>

<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="modules.device.business.system.importing.equipment"/></h5>
</div>


<!-- Main content -->
<div class="modal-body">
	<div class="row">
		<div class="col-xs-12">
		
				<div class="form-horizontal" id="productSearchDiv">
					
					<div class="form-group" style="margin: 1em;">
						<label class="col-sm-2 control-label"><spring:message code="app.release.industry"/></label>
						<div class="col-sm-3">
								<select name="industry" id="selectIndustryId"  data-placeholder='<spring:message code="app.release.please.choose.the.industry"/>' onchange="clickIndustry()" class="form-control select2" style="width: 231px">
									   <option value=""></option>
									  <c:forEach items="${industryList}" var="industry" varStatus="idxStatus">
								      			<option value="${industry.value}">${industry.label }</option>
								      </c:forEach>
								</select>
						</div>
						
						<label class="col-sm-2 control-label">${tableClient }</label>
						<div class="col-sm-3">
							<sys:treeselect id="customerId" name="customerId" value="${client.parentId}" labelName="parentName" labelValue="${client.customerName}"
						title="${tableClient }" url="/client/treeData" extId="${client.customerId}" cssClass="form-control" allowClear="true"/>
						</div>
					</div>
					
					<div class="form-group" style="margin: 1em;">
						<label class="col-sm-2 control-label"><spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/></label>
						<div class="col-sm-3">
							<select name="vendorCode" id="vendorCode" onchange="manuFacturerChange()" 
							data-placeholder='<spring:message code="app.release.manufacturer"/>' class="form-control select2" style="width: 231px">
							   <option value=""></option>
							  <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
						      			<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
						      </c:forEach>
							</select>
						</div>
						
						<label class="col-sm-2 control-label" ><spring:message code="ota.table.device.sn"/></label>
						<div class="col-sm-3">
							<input placeholder='<spring:message code="app.apprecord.please.enter.the.device.sn.number"/>' id="sn" name="sn" class="form-control"
									type="search" /> 
						</div>
						
					</div>
					
					
					<div class="form-group" style="margin: 1em;">
						
						<label class="col-sm-2 control-label" ><spring:message code="ota.table.device.pn"/></label>
						<div class="col-sm-3">
							<input placeholder='<spring:message code="modules.device.please.enter.the.device.pn.number"/>' id="pn" name="pn" class="form-control"
									type="search" /> 
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
					
				<div class="btn-group" style="margin: 12px;">
					<input type="checkbox" name="singleCheckBox" id="singleCheckBox"/>
					<spring:message code="modules.device.select.single.of.the.pages"/>
					&nbsp;&nbsp;
					<input type="checkbox" name="allCheckBox" id="allCheckBox"/>
					<spring:message code="modules.device.select.all.of.the.pages"/>
				</div>
					
				</div>
				
				<div class="box-body">
					<table id="product_table"
						class="table table-bordered table-striped table-hover">
					</table>
				</div>
				
				<div class="box-footer text-right">
					<!--以下两种方式提交验证,根据所需选择-->
					<button type="button" class="btn btn-default" data-btn-type="cancel"
						data-dismiss="modal"><spring:message code="common.cancel"/></button>
					 <button type="button" onclick="submitDevice()" class="btn btn-primary"><spring:message code="modules.device.import"/></button>
				</div>
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</div>

<script>
var productform = $("#productSearchDiv").form({baseEntity: false});
productform.initComponent();
	var productTable,winId = "activeproductWin";
	var config={
			singleSelect:null
	};
	$(function() {
		//清空设备列表选择的行业赋值
		$("#industryId").val('');
		checkBox();
		//init table and fill data
		productTable = new CommonTable("product_table", "product_list", "productSearchDiv",
				"/product/devBatchList", config);
		
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
	
	function ajaxProgressDef(url,params){
		var index = layer.index;
		$.when(ajaxPostWithDeferred(basePath+url, params, function(data, status) {})).done(function(data){
			layer.close(index);
			if(data.code == 200){
				modals.correct(data.message);
				deviceTable.reloadRowData();
				modals.hideWin(winId);
			}else{
				modals.warn(data.message);
			}	
		})
	}
	
	function addCheckBox(id){
		var oper = "";
		if ($("#allCheckBox").prop("checked")) {
			oper += "<div class='checkbox checkbox-success checkbox-inline'><input type='checkbox' id='checked" + id +"'  value='" + id +"' name='box' checked disabled/><label for='checked"+id+"'></label></div>";
		} else {
			if($("#singleCheckBox").prop("checked")){
				$("#allCheckBox").iCheck("enable");
				$("#singleCheckBox").iCheck("uncheck");
			}
			oper += "<div class='checkbox checkbox-success checkbox-inline'><input type='checkbox' id='checked" + id +"' value='" + id +"' name='box' /><label for='checked"+id+"'></label></div>";
		}
        return oper;
	}
	
	function submitDevice(){
		var allCheckBox = $("input[name='allCheckBox']:checkbox")[0];
		var ids = '';
		if(allCheckBox.checked != true){
			
			$("input[name='box']:checkbox").each(function(){ 
				
				if (true == this.checked) { 
					
					ids += $(this).attr('value')+','; 
					
				} 
			}); 
			if(ids == ''){
				modals.info('<spring:message code="app.release.please.select.the.least.one.device"/>');
				return;
			}
		}
		
		layer.msg('<spring:message code="modules.device.importing.please.later"/>', {icon: 16,tips: [1, '#3595CC'],area: ['250px', '70px'],shade: [0.5, '#f5f5f5'],scrollbar: false,time: 500000}) ; 
	
		//系统版本id
		var sn = $("#sn").val();
		var manufacturerNo = $("#vendorCode").val();
		var deviceType = $("#deviceType").val();
		var customerId = $("#customerId").val();
		
		$('#icon').addClass('fa fa-circle-o-notch fa-spin');
		var params = {};
		
		params['sn'] = sn;		
		params['vendorCode'] = manufacturerNo;	
		params['productId'] = deviceType;	
		params['customerId'] = customerId;
		
		//选择所有页
		if($("#allCheckBox").prop("checked")){
			ajaxProgressDef("/device/importAllDevice/",params);
		}else { //选择单页 或 点选
			//id数组
			params['ids'] = ids;
			ajaxProgressDef("/device/importDevice/",params);
		}
	}
	
	$("#singleCheckBox").on("ifClicked", function(event) {
		if (event.target.checked) {
			$("input[name='box']:checkbox").iCheck("uncheck");
			$("input[name='box']:checkbox").iCheck("enable");
			$("#allCheckBox").iCheck("enable");
		} else {
			$("input[name='box']:checkbox").iCheck("check");
			$("input[name='box']:checkbox").iCheck("disable");
			$("#allCheckBox").iCheck("disable");
		}
	})

	$("#allCheckBox").on("ifClicked", function(event) {
		if (event.target.checked) {
			$("input[name='box']:checkbox").iCheck("uncheck");
			$("input[name='box']:checkbox").iCheck("enable");
			$("#singleCheckBox").iCheck("enable");
		} else {
			$("input[name='box']:checkbox").iCheck("check");
			$("input[name='box']:checkbox").iCheck("disable");
			$("#singleCheckBox").iCheck("disable");
		}
	})
	
	function clickIndustry(){
		var value = $("#selectIndustryId").val();
		$("#industryId").val(value);
	}
	
	
	function deviceTypeChange(){
		
		 var manufacturerNo = $("#vendorCode").val();
		 if(manufacturerNo == ''){
			 modals.info('<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>');
		 	$("#deviceType").empty('');
		 }
		
	}

	function manuFacturerChange(){
		
		 var params = {};
		 var manufacturerNo = $("#vendorCode").val();
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

