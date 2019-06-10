<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="app.release.client" var="releaseClient"/>
<spring:message code="modules.device.hint.merchant" var="selectMerchant"/>
<spring:message code="modules.device.hint.shop" var="selectStore"/>
<!-- Content Header (Page header) -->
<div id="listForm">
	<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="#"><i class="fa fa-dashboard"></i><spring:message code="common.homepage"/></a></li>
		<li><a href="#"><spring:message code="app.devicerecord.device.management.info"/></a></li>
		<li class="active"><spring:message code="app.devicerecord.device.management"/></li>
	</ol>
	<div class="col-sm-12"></div>
</section>
<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div class="dataTables_filter" id="deviceSearchDiv" style="text-align: left;" role="form">
						<div class="has-feedback form-group">
							<select name="manufacturerNo" style="margin-left:0px;width: 180px;" id="manufacturerNo" onchange="manuFacturerChange()" 
							data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>' class="form-control select2" >
							  <option value=""></option>
							  <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
						      			<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
						      </c:forEach>
							</select>
						</div>
						
						<div class="has-feedback form-group">
							<select name="osDeviceType" style="margin-left:0px;width: 180px;" id="deviceTypeId" onchange="deviceTypeChange()" 
							data-placeholder='<spring:message code="app.apprecord.please.select.the.device.type"/>' class="form-control select2">
							   <option value=""></option>
							</select>
						</div>
					
				
						<div class="has-feedback form-group">
							<select id="merId" name="merId" style="margin-left:0px;width: 180px;"  data-placeholder="${selectMerchant}" onchange="clickMerId()" class="form-control select2">  
								  <option value=""></option>
								  <c:forEach items='${merchants}' var="merchant" varStatus="idxStatus">
							      		<option value="${merchant.merId}">${merchant.merName}</option>
							      </c:forEach>
							</select>
						</div>
					
						<div class="has-feedback form-group">
							<select  id="shopId" name="shopId" style="margin-left:0px;width: 180px;" data-placeholder="${selectStore}" onchange="shopChange()" class="form-control select2">
								  <c:forEach items="${stores}" var="store" varStatus="idxStatus">
							      		<option value="${store.storeId}">${store.storeName}</option>
							      </c:forEach>
							</select>
						</div>
					
		
						<div class="has-feedback form-group">
							<input style="margin-left:0px;width: 180px;" placeholder='<spring:message code="app.apprecord.please.enter.the.device.sn.number"/>' id="deviceSn" name="deviceSn" class="form-control"
									type="search" /> 
						</div>
						<div class="btn-group">
							<button type="button" class="btn btn-primary"
								data-btn-type="search"><spring:message code="common.query"/></button>
							<button type="button" class="btn btn-default"
								data-btn-type="reset"><spring:message code="common.reset"/></button>
						</div>

				
					<shiro:hasPermission name="device:edit">
						<div style="width:100%;margin-top:5px;">
							<button type="button"  style="float: left;" class="btn btn-primary" data-btn-type="toBoundDevice"><i class="fa fa-plus"></i><spring:message code="device.bund"/></button>
							 <button type="button"  class="btn btn-default"  data-btn-type="deleteDevice" title="<spring:message code='common.delete'/>" style="float: right;">
							 <i class="fa fa-remove"></i>
						   </button>
						   <button data-btn-type="editDevice" class="btn btn-default"  title="<spring:message code='common.edit'/>" type="button" style="float: right;">
							 <i class="fa fa-edit"></i>
						   </button>
							<button type="button"  style="float: right;" class="btn btn-default" data-btn-type="addDevice" title="<spring:message code='common.add'/>"><i class="fa fa-plus"></i></button>
							<button type="button"  style="float: left;" class="btn btn-default" data-btn-type="batImportFile"><spring:message code="modules.device.file.importing.device"/></button>
						 </div>
	                  </shiro:hasPermission>
                </div>
				<div class="box-body">
					<table id="device_table"
						class="table table-condensed table-bordered table-striped table-hover" style="margin-top:0px !important;">
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
			//singleSelect:null
	};
	$(function() {
		//init table and fill data
		deviceTable = new CommonTable("device_table", "device_list", "deviceSearchDiv",
				"/device/list?mId="+"${mId}",config );
		
		$('button[data-btn-type]').click(
				function() {
					var action = $(this).attr('data-btn-type');
					var deviceRowId=deviceTable.getSelectedRowId();
					switch (action) {
					case 'toBoundDevice':
						$.ajax({
							url:basePath+'/device/toBoundDevice',
							success:function(res){
								$("#listForm").html(res);
							}
						});
						break;
					case 'addDevice':
						deviceProcessDef.addDeviceInfo()
						break;
					case 'merExport':
						modals.confirm('<spring:message code="modules.device.do.you.want.to.export.the.user"/>', function() {
							$.download(basePath + "/sys/user/export",
									"post", "userSearchDiv");
						})
						break;
					
					case 'batImportFile':{
						deviceProcessDef.batImportFile();
						break;
					}
					case 'editDevice':
						if (!deviceRowId) {
							modals.info('<spring:message code="please.select.edit.row"/>');
							return false;
						}
						deviceProcessDef.editDevice(deviceRowId);
						break;
					case 'deleteDevice':
						if (!deviceRowId) {
							modals.info('<spring:message code="please.select.delete.row"/>');
							return false;
						}
						deviceProcessDef.deleteDevice(deviceRowId);
						break;
					default:
						break;
					}

				});
		
	})
	
	var deviceProcessDef={
		addDeviceInfo:function(){
			modals.openWin({
				winId : winId,
				title : '<spring:message code="modules.device.add.device"/>',
				width : '1300px',
				url : basePath + "/device/form"
			});
		},
		
		batImportFile:function(){
			modals.openWin({
				winId : winId,
				title : '<spring:message code="modules.device.device.file.upload"/>',
				width : '900px',
				url : basePath + "/device/batImportFile"
			});
		},
		deleteDevice:function(id){
			
			modals.confirm('<spring:message code="modules.device.determine.to.delete.this.device"/>', function() {
				
				//Save Data，对应'submit-提交'
				 var params = {};
				 params["id"] = id;
					 ajaxPost(basePath+'/device/delete', params, function(data, status) {
					 if(data.code == 200){
						//新增 
						modals.correct(data.message);
						modals.hideWin(winId);	
						deviceTable.reloadRowData();
					 }else{
					 	modals.warn(data.message);
					 }				 
				}); 
			})
		},
		editDevice:function(id){
			modals.openWin({
				winId : winId,
				title : '<spring:message code="common.edit"/>',
				width : '1300px',
				url : basePath + "/device/form?id=" + id
			});
		},
		checkDevice:function(id){
			modals.openWin({
				winId : winId,
				title : '<spring:message code="modules.device.information"/>',
				width : '1200px',
				url : basePath + "/device/deviceInfo?id=" + id
			});
		},
		checkLog:function(id){
			modals.openWin({
				winId : winId,
				title : '<spring:message code="modules.device.get.a.log"/>',
				width : '1200px',
				url : basePath + "/device/getAppDirectory?id=" + id
			});
		},
		getDeviceInfo:function(id){
			var params = {};
			params["deviceId"] = id;
			ajaxPost(basePath+'/device/getDeviceInfo', params,  function(data, status) {
				if(data.code == 200){
					modals.correct(data.message);
				}else{
					modals.warn(data.message);
				}				 
		  }); 
		}
	}
	
	
	function operation(id, type, rowObj){
		var oper = "";
		//oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.deleteDevice(\"" + id +"\")'>"+'<spring:message code="common.delete"/>'+"</a>";
        //oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.editDevice(\"" + id +"\")'>"+'<spring:message code="common.edit"/>'+"</a>";
        oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.checkLog(\"" + id +"\")'>"+'<spring:message code="modules.device.get.a.log"/>'+"</a>";
        oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.getDeviceInfo(\"" + id +"\")'>"+'<spring:message code="modules.device.get.device.infomation"/>'+"</a>";
        oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.checkDevice(\"" + id +"\")'><spring:message code='device.detail'/></a>";
        return oper;
	}
	
	/* function check(id, type,rowObj){
		var oper = "";
			oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.checkDevice(\"" + id +"\")'>"+'<spring:message code="modules.device.information"/>'+"</a>";
         return oper;
	} */
	
	function clickIndustry(){
		var value = $("#industry").val();
		$("#industryId").val(value);
	}
	
	function clickMerId(){
		 var params = {};
		 var merId = $("#merId").val();
		 if (merId != '' && merId != null) {
			 $("#shopId").empty();
		 }
		 params['merId'] = merId;
		 ajaxPost(basePath+'/device/storeList', params, function(data, status) {
				if(data.code == 200){
					var stores=data.data;
					 $("#shopId").empty();
					for(var i=0;i<stores.length;i++){
						$("#shopId").append("<option value=\""+stores[i].storeId+"\">"+stores[i].storeName+"</option>");
					} 
				}else{
					modals.warn(data.message);
				}			
		 });
	}
	
	function shopChange(){
		 var merId = $("#merId").val();
		 if(merId == ''){
			 modals.info('<spring:message code="modules.device.hint.merchant"/>');
		 	$("#shopId").empty('');
		 }
	}
</script>
</div>
