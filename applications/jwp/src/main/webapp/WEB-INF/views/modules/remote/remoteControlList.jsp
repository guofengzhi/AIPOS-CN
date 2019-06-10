<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<spring:message code="common.query" var="query" />
<spring:message code="common.reset" var="reset" />
<spring:message code="common.cancel" var="cancel" />
<spring:message code="common.submit" var="submit" />

<!-- Content Header (Page header) -->
<%-- <div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="remote.controller.device.list" /></h5>
</div> --%>

<section class="content-header">
		<ol class="breadcrumb">
			<li><a href="${basePath}"><i class="fa fa-dashboard"></i>
				<spring:message code="common.homepage" /></a></li>
			<li><a href="#"><spring:message code="device.remote.control" /></a></li>
			<li class="active"><spring:message code="remote.controller.device.list"/></li>
		</ol>
		<div class="col-sm-12"></div>
	</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div>&nbsp;</div>
				<div class="" id="contrl">
					&nbsp;
					&nbsp;
					&nbsp;
					<div class="btn-group">
						<button onclick="sendCommand('UpgradeRom')" class="btn btn-primary"><spring:message code="remote.controller.sys.upgrade" /></button>
					</div>
					
					<div class="btn-group">
						<button class="btn btn-primary"><spring:message code="remote.controller.factory.data.reset" /></button>
					</div>
					
					<div class="btn-group">
						<button class="btn btn-primary"><spring:message code="remote.controller.remote.device.activation" /></button>
					</div>
					
					<div class="btn-group">
						<button class="btn btn-primary"><spring:message code="remote.controller.lock.screen" /></button>
					</div>
					
					<div class="btn-group">
						<button class="btn btn-primary"><spring:message code="remote.controller.disable.camera" /></button>
					</div>
					
					<div class="btn-group">
						<button class="btn btn-primary"><spring:message code="remote.controller.root.detection" /></button>
					</div>
					
					<div class="btn-group">
						<button class="btn btn-primary"><spring:message code="remote.controller.key.download.update" /></button>
					</div>
					
					<div class="btn-group">
						<button class="btn btn-primary"><spring:message code="remote.controller.device.remote.locking" /></button>
					</div>
					
					<div class="btn-group">
						<button class="btn btn-primary"><spring:message code="remote.controller.data.erasure" /></button>
					</div>
					
					<div class="btn-group">
						<button class="btn btn-primary"><spring:message code="remote.controller.remote.access.log" /></button>
					</div>
					
				</div>
				<br/><br/>
				<div class="dataTables_filter" id="deviceSearchDiv" style="float:left;">
					
					<div class="btn-group">
						<input type="checkbox" name="singleCheckBox" id="singleCheckBox" onclick="singlePageClick()"/>
						<spring:message code="remote.controller.all.single.page" />
					</div>
					<div class="btn-group">
						<input type="checkbox" name="allCheckBox" id="allCheckBox" onclick="allPageClick()"/>
						<spring:message code="remote.controller.full.page" />
					</div>
					
					<div class="btn-group">
							<select name="manufacturerNo" id="manufacturerNo" onchange="manuFacturerChange()"  data-placeholder='<spring:message code="remote.controller.please.select.a.device.manufacturer" />'  class="form-control select2" style="width: 170px">
							   <option value=""></option>
							  <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
						      			<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
						      </c:forEach>
							</select>
					</div>&nbsp;&nbsp;
						
					<%-- <div class="btn-group">
						<select name="deviceType" id="deviceTypeId" data-placeholder='<spring:message code='modules.device.please.select.the.customer' />' onchange="deviceTypeChange()" class="form-control select2" style="width: 170px;">
						   <option value=""><spring:message code="common.form.select" /></option>
						 
						</select>
					</div>&nbsp;&nbsp; --%>
					
					<div class="btn-group">
					<input
							placeholder='<spring:message code="app.apprecord.please.enter.the.device.sn.number" />' id="deviceSn" name="deviceSn" class="form-control"
							type="search" title='<spring:message code="app.apprecord.please.enter.the.device.sn.number"/>' /> 
					
					</div>
					
					<div class="btn-group">
						<select name="clientNo" id="clientNo" data-flag="dictSelector"
						data-blank="true" data-code="agent_user_type" data-value="value" data-text="label"
						data-placeholder='<spring:message code="modules.device.please.select.the.customer" />' class="form-control select2" style="width: 170px">
						   <option value=""></option>
						  <c:forEach items="${clientList}" var="client" varStatus="idxStatus">
					      			<option value="${client.clientNo}">${client.clientName }</option>
					      </c:forEach>
						</select>
					</div>&nbsp;&nbsp;
					
					<div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search">${query}</button>
						&nbsp;&nbsp;
						<button type="button" class="btn btn-default"
							data-btn-type="reset">${reset}</button>
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
						data-dismiss="modal">${cancel}</button>
					 <button type="button" onclick="submitDevice()" class="btn btn-primary">${submit}</button>
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
	var deviceTable,winId = "controlDeviceWin";
	var config={
			singleSelect:null
	};
	$(function() {
		
		deviceTable = new CommonTable("device_table", "remote_control_device_list", "deviceSearchDiv",
				"/control/list", config);
		
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
	
	function addCheckBox(id){
		var oper = "";
		if($("#allCheckBox").prop("checked")){
			oper += "<input type='checkbox' value='" + id +"' name='box' checked disabled/>";
		}else{
			oper += "<input type='checkbox' value='" + id +"' name='box' />";
		}
        
        return oper;
	}
	
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
	
	function sendCommand(commandType){
		var ids = '';
		$("input[name='box']:checkbox").each(function(){ 
			if (true == this.checked) { 
				ids += $(this).attr('value')+','; 
			} 
		}); 
		if(ids == ''){
			modals.warn('<spring:message code="remote.controller.please.select.at.least.one.device" />');
			return;
		}
		
		layer.msg('正在发送指令，请稍后...', {icon: 16,tips: [1, '#3595CC'],area: ['250px', '70px'],shade: [0.5, '#f5f5f5'],scrollbar: false,time: 500000}) ; 
		
		$('#icon').addClass('fa fa-circle-o-notch fa-spin');
		var params = {};
		params['commandType'] = commandType;
		//选择所有页
		if($("#allCheckBox").prop("checked")){
			params['isAll'] = '0';
			ajaxProgressDef("/control/sendCommand",params);
		}else { //选择单页 或 点选
			//id数组
			params['ids'] = ids;
			params['isAll'] = '1';
			ajaxProgressDef('/control/sendCommand',params);
		}
		
	}
	
	function singlePageClick(){
		if($("#allCheckBox").prop("checked")){
			$("#allCheckBox").prop("checked",false);
			$("input[name='box']:checkbox").each(function(){ 
				$(this).attr("disabled",$("#allCheckBox").prop("checked"));
			});
			return;
		}
		
		$("input[name='box']:checkbox").each(function(){ 
			this.checked = $("#singleCheckBox").prop("checked") ; 
		});
	}
	
	function allPageClick(){
		if($("#singleCheckBox").prop("checked")){
			$("#singleCheckBox").prop("checked",false);
			$("input[name='box']:checkbox").each(function(){ 
				$(this).attr("disabled",$("#allCheckBox").prop("checked"));
			});
			return;
		}
		$("input[name='box']:checkbox").each(function(){ 
			this.checked = $("#allCheckBox").prop("checked"); 
			$(this).attr("disabled",$("#allCheckBox").prop("checked"));
		});
	}
	
</script>

