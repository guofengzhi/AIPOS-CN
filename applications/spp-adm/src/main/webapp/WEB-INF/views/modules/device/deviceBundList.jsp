<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<style type="text/css">
</style>
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i>
			<spring:message code="common.homepage" /></a></li>
		<li><a href="#"><spring:message code="common.sys.management" /></a></li>
		<li class="active"><spring:message code="sys.merchant.management" /></li>
	</ol>
	<div class="col-sm-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<div id="userSearchDiv" class="dataTables_filter" role="form" style="text-align: left;">
					<div class="has-feedback form-group">
							<select name="merId" id="selectMerchants1" style="margin-left:0px;width: 226.5px;"
								data-placeholder='<spring:message
							code="please.select.merchant" />' class="form-control select2">
								<option value=""></option>
								<c:forEach items="${merchants}" var="merchant"
									varStatus="idxStatus">
									<option value="${merchant.merId}">${merchant.merName}</option>
								</c:forEach>
						</select>
					</div>
					<div class="has-feedback form-group">
							<select name="shopId" id="selectStores1"
								data-placeholder='<spring:message
							code="please.select.store" />'
								class="form-control select2" style="margin-left:0px;width: 226.5px;">
								<option value=""></option>
							</select>
					</div>
					<div class="has-feedback form-group">
							<select name="deviceSn" id="selectBunds"
								data-placeholder='<spring:message
							code="please.select.device" />'
								class="form-control select2" style="margin-left:0px;width: 226.5px;">
								<option value=""></option>
								<c:forEach items="${devices}" var="device"
									varStatus="idxStatus">
									<option value="${device.deviceSn}">${device.deviceSort}&nbsp;&nbsp;${device.deviceType}&nbsp;&nbsp;${device.deviceSn}</option>
								</c:forEach>
							</select>
						</div>
					<div class="has-feedback form-group">
							<select  id="listMode" name="deviceBundState" class="form-control select2" style="margin-left:0px;width: 226.5px;">
								<option value="1"><spring:message code="already.bund" /></option>
								<option value="0"><spring:message code="unbund" /></option>
							</select>
					</div>
					<div class="btn-group">
						<button type="button" class="btn btn-primary"  id="chaxun"
								data-btn-type="search"><spring:message code="common.query"/></button>
							<button type="button" class="btn btn-default"
								data-btn-type="reset"><spring:message code="common.reset"/></button>
					</div>
					<div style="width:100%;margin-top:5px;">
						<shiro:hasPermission name="device:edit">
					  		<div class="btn-group" id="unBun" style="margin-left:0px;">
								<button type="button" class="btn btn-danger" data-btn-type="batchUnBund"><i class="fa fa-plus"></i><spring:message code="unbind"/></button>
							</div>
					  	</shiro:hasPermission>
					</div>
				</div>
				<div class="box-body col-sm-12" style="margin:0px 0px;" id="bundTable">
					<table id="boundTerm_table"
						class="table table-bordered table-bg table-striped table-hover">
					</table>
				</div>
					<div class="box-body col-sm-2" id="bundSelects">
					<div class="col-sm-12">
						<div  class="form-group col-sm-12">
							<label class="control-label"><spring:message code="binding.merchant"/>：</label>
						</div>
						<div  class="form-group col-sm-12">
							<select name="merId2" id="selectMerchants" data-placeholder='<spring:message
							code="please.select.merchant" />' >
							<option value="">- - - -<spring:message code="please.select"/>- - - -</option>
							<c:forEach items="${merchants}" var="merchant"
								varStatus="idxStatus">
								<option value="${merchant.merId}">${merchant.merName}</option>
							</c:forEach>
						</select>
						</div>
					</div>
					<div class="col-sm-12">
						<div class="form-group col-sm-12">
							<label class="control-label"><spring:message code="binding.store"/>：</label>
						</div>
						<div  class="form-group col-sm-12">
							<select name="shopId" id="selectStores" data-placeholder='<spring:message code="please.select.store"/>'>
								<option value="">- - - -<spring:message code="please.select"/>- - - -</option>
							</select>
						</div>
					</div>
					<div class="col-sm-12" align="center">
						<shiro:hasPermission name="device:edit">
							<div class="form-group col-sm-12">
								<button type="button" class="btn btn-success" data-btn-type="batchBund"><i class="fa fa-plus"></i><spring:message code="bund"/></button>
							</div>
						</shiro:hasPermission>
					</div>
					</div>
			</div>
		</div>
	</div>
</section>

<script>
	//tableId,queryId,conditionContainer
	var boundTermTable;
	var winId = "boundTermWin";
	
	
	var bundDisp="none";
	var unDisp="";
	var clazz="box-body col-sm-12";
	document.getElementById("bundSelects").style.display=bundDisp;//隐藏
	document.getElementById("unBun").style.display=unDisp;//显
	
	/*$("#listMode").change(function(){
		var queryScope = $("#listMode").val();
		if(queryScope==="1"){
			bundDisp="";
			unDisp="none";
			clazz="box-body col-sm-12";
		}
		if(queryScope==="0"){
			bundDisp="none";
			unDisp="";
			clazz="box-body col-sm-10";
		}
	 });*/
	$("#chaxun").click(function(){
		var queryScope = $("#listMode").val();
		if(queryScope==="1"){
			bundDisp="";
			unDisp="none";
			clazz="box-body col-sm-12";
		}
		if(queryScope==="0"){
			bundDisp="none";
			unDisp="";
			clazz="box-body col-sm-10";
		}
		document.getElementById("unBun").style.display=bundDisp;//隐藏
		document.getElementById("bundSelects").style.display=unDisp;//显
		document.getElementById("bundTable").className =clazz;
	});
	
	$(function() {
		$("#selectMerchants").select2({
		});
		$("#selectMerchants1").select2();
		$("#selectUnBunds").select2();
		$("#selectBunds").select2();
		$("#selectStores1").select2();
		$("#selectStores").select2();
		//查询框是否在一行设置
		var config = {
			resizeSearchDiv : false,
			language : {
				url : basePath + '<spring:message code="common.language"/>'
			}
		};
		//init table and fill data
			boundTermTable = new CommonTable("boundTerm_table", "boundTermTable",
					"userSearchDiv", "/device/deviceBundList?mId="+"${mId}"+"&sId="+"${sId}", config);
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var bundRowId = boundTermTable
									.getSelectedRowId();
							var mer = $('#selectMerchants');
							var device = $('#selectUnBunds');
							var store = $('#selectStores');

							
							var merId = mer.val();
							var deviceId= device.val();
							var storeId = store.val();
							switch (action) {
							case 'boundTerm':
								if(deviceId===""){
									modals.info("<spring:message code='please.select.device'/>！");
									return false;
								} 
								if(merId===""){
									modals.info("<spring:message code='please.select.merchant'/>！");
									return false;
								} 
								ajaxPost(basePath + "/device/boundOneTerm?merId="+ merId+"&deviceId="+deviceId+"&storeId="+storeId, null, function(data) {
									if (data.code == 200) {
										modals.correct({
											title:'<spring:message code="common.sys.success" />',
											cancel_label:'<spring:message code="common.confirm" />',
											text:'<spring:message code="already.bund" />！'});
										$("#selectUnBunds option:selected").remove();
										boundTermTable.reloadRowData();
									} else {
										modals.warn(date.message);
									}
								});
								break;
							case 'batchBund':
								if(merId===""){
									modals.info("<spring:message code='please.select.merchant' />！");
									return false;
								} 
								var ids=[];
								var checkds = $(":checkBox:checked");
								var len = checkds.length;
								if(len<=0){
									modals.info("<spring:message code='please.select.device' />！");
									return false;
								}
								$(checkds).each(function(index,ele){
									/* if(index>0){ */
										var val = ele.value;
										ids.push(val);
									/* } */
								});
								modals.confirm({
									cancel_label:"<spring:message code="common.cancel" />",
									title:"<spring:message code="common.sys.confirmTip" />",
									ok_label:"<spring:message code="common.confirm" />",
									text:"确认绑定？",
									callback: function() {
										$.ajax({
											type : 'POST',
											traditional:true,
											 data: {
											    "ids": ids,
											    "merId":merId,
											    "storeId":storeId
											  },
											url:basePath + "/device/boundBatchTerm",
											success:function(data){
												if (data.code == 200) {
													modals.correct({
														title:'<spring:message code="common.sys.success" />',
														cancel_label:'<spring:message code="common.confirm" />',
														text:data.message});
													boundTermTable.reloadRowData();
												}
											}
										});
									}});
								break;
							case 'batchUnBund':
								var ids=[];
								var checkds = $(":checkBox:checked");
								var len = checkds.length;
								if(len<=0){
									modals.info("<spring:message code='please.select.device' />");
									return false;
								}
								$(checkds).each(function(index,ele){
										var val = ele.value;
										ids.push(val);
								});
								modals.confirm({
									cancel_label:"<spring:message code="common.cancel" />",
									title:"<spring:message code="common.sys.confirmTip" />",
									ok_label:"<spring:message code="common.confirm" />",
									text:"<spring:message code="common.confirm.delete" />",
									callback: function() {
										$.ajax({
											type : 'POST',
											traditional:true,
											 data: {
											    "ids": ids
											  },
											url:basePath + "/device/unBoundBatchTerm",
											success:function(data){
												if (data.code == 200) {
													modals.correct({
														title:'<spring:message code="common.sys.success" />',
														cancel_label:'<spring:message code="common.confirm" />',
														text:data.message});
													boundTermTable.reloadRowData();
												}
											}
										});
									}});
								break;
							case 'unBund':
								if (!bundRowId) {
									modals.info('<spring:message code='please.select.device' />');
									return false;
								}
								modals.confirm({
									cancel_label:"<spring:message code="common.cancel" />",
									title:"<spring:message code="common.sys.confirmTip" />",
									ok_label:"<spring:message code="common.confirm" />",
									text:"<spring:message code="common.confirm.delete" />",
									callback: function() {
									ajaxPost(basePath + "/device/unBoundOneTerm?id="
											+ bundRowId, null, function(data) {
										if (data.code == 200) {
											modals.correct({
												title:'<spring:message code="common.sys.success" />',
												cancel_label:'<spring:message code="common.confirm" />',
												text:data.message});
											boundTermTable.reloadRowData();
										} else {
											modals.warn(date.message);
										}
									});
								}});
								break;
							}
						});
	});
	function unBound(id){	
		var oper = "&nbsp;&nbsp;&nbsp;";
		oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='unBoundTerm(\"" + id +"\")'>"+'<spring:message code="unBound.term"/>'+"</a>";
        return oper;
	}
	function check(id){	
		var oper = "&nbsp;&nbsp;&nbsp;";
		oper += "<input value='"+id+"' type='checkBox' onclick='sss(\"" + id +"\")'>"+"</input>";
        return oper;
	}
	function unBoundTerm(id){
		$
		.ajax({
			url : basePath
					+ "/sys/merchant/unBoundTerm?id="
					+ id,
			success : function() {
				modals
						.correct({
							title : '<spring:message code="common.sys.success" />',
							cancel_label : '<spring:message code="common.confirm" />',
							text : '<spring:message code="already.unbund" />'
						});
				boundTermTable.reloadRowData();
			}
		});
	}
	function sss(id){
		/* alert(id); */
	}

	function state(deviceBundState){
		var state = "";
		if(deviceBundState==="0"){
			state='<spring:message code="unbund" />';
		}else if(deviceBundState==="1"){
			state='<spring:message code="already.bund" />';
		}
        return state;
	}

	function change(){
		var check = $("#allSelect").is(':checked');
		$("input[type='checkbox']").prop("checked",check);
	}

	$(function(){
});
	$(function(){
		merStores("selectMerchants1","selectStores1");
		merStores("selectMerchants","selectStores");

});
function merStores(merSelectId,storeSelectId){
	$("#"+merSelectId).change(function(){
		var secSelect = document.getElementById(storeSelectId);
		var merId = this.value;
		secSelect.options.length = 0;
		$.ajax({
			url:basePath+'/sys/store/stores?merId='+merId,
			success:function(res){
				 var oOption = document.createElement("OPTION");
			        oOption.value = "";
			        oOption.text = "- - - -"+"<spring:message code='please.select'/>"+"- - - -";
			        secSelect.options.add(oOption);
				 var dataJson = res.data;
				 for ( var i = 0; i < dataJson.length; i++) {
					 var oOption = document.createElement("OPTION");
				        oOption.value = dataJson[i].storeId;
				        oOption.text = dataJson[i].storeName;
				        secSelect.options.add(oOption);
				 }
			}
	});
	});
}
</script>
