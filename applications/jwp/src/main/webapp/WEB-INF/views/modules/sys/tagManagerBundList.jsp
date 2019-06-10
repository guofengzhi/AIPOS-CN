<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<div id="userSearchDiv" class="dataTables_filter" style="text-align: left;" role="form">
					 <div class="form-group dataTables_filter " style="margin: 1em;">
					 	<select name="merId" id="selectMerchants1"
								data-placeholder='<spring:message code="modules.device.hint.merchant"/>'     
								class="form-control select2" style="width: 231px">
								<option value=""></option>
								<c:forEach items="${merchants}" var="merchant"
									varStatus="idxStatus">
									<option value="${merchant.merId}">${merchant.merName}</option>
								</c:forEach>
							</select>
							<select name="shopId" id="selectStores1"
								data-placeholder='<spring:message code="modules.device.hint.shop"/>'
								class="form-control select2" style="width: 231px">
								<option value=""></option>
							</select>
							<select name="deviceSn" id="selectBunds"
								data-placeholder='<spring:message code="app.release.select.device"/>'
								class="form-control select2" style="width: 231px">
								<option value=""></option>
								<c:forEach items="${devices}" var="device"
									varStatus="idxStatus">
									<option value="${device.id}">${device.deviceSort}&nbsp;&nbsp;${device.deviceType}&nbsp;&nbsp;${device.deviceSn}</option>
								</c:forEach>
							</select>
							<select  id="listMode" name="deviceBundState" class="form-control select2" style="width: 231px">
								<option value=""><spring:message code="sys.labelManagement.unbund"/></option>
								<option value="1"><spring:message code="sys.labelManagement.bund"/></option>
							</select>
							<button type="button" class="btn btn-primary"
								data-btn-type="search"><spring:message code="common.query"/></button>
							<button type="button" class="btn btn-default"
								data-btn-type="reset"><spring:message code="common.reset"/></button>
								<div class="btn-group"  id='div_boundTerm'>
										<button type="button" class="btn btn-primary" data-btn-type="boundTerm" style="float:left;"><spring:message code="sys.labelManagement.doBund"/></button>
									</div>
									<div class="btn-group"  id='div_unBund'>
										<button type="button" class="btn btn-danger" data-btn-type="unBund" style="float:left;"><spring:message code="sys.labelManagement.doUnbund"/></button>
									</div>
						</div>
					 </div>
				
						<div class="has-feedback form-group">
						<div class="has-feedback form-group">
							
						</div>
						<div class="has-feedback form-group">
						</div>
						<div class="has-feedback form-group">
							
						</div>
						<div class="btn-group">
						</div>
						<shiro:hasPermission name="device:edit">
							<div style="width:100%;margin-top:5px;">
			                  </div>
                  		</shiro:hasPermission>
				</div>
				<div class="box-body">
					<table id="bundTagManagerDevice_table"
						class="table table-bordered table-bg table-striped table-hover" style="margin-top:0px !important;">
					</table>
				</div>
			</div>
		</div>
	</div>
</section>

<script>
	//tableId,queryId,conditionContainer
	var bundTagManagerDeviceTable;
	var winId = "boundTermWin";
	$(function() {
		$("#selectMerchants").select2();
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
			bundTagManagerDeviceTable = new CommonTable("bundTagManagerDevice_table", "bundTagManagerDeviceTable",
					"userSearchDiv", "/sys/tagManager/deviceBundList?mId="+"${mId}"+"&sId="+"${sId}" + "&tagId=" + "${id}" + "&deviceBundState=" + "${deviceBundState}" ,  config);
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var bundRowId = bundTagManagerDeviceTable
									.getSelectedRowId();
							var mer = $('#selectMerchants');
							var device = $('#selectUnBunds');
							var store = $('#selectStores');
							
							var merId = mer.val();
							var deviceId= device.val();
							var storeId = store.val();
							switch (action) {
							case 'boundTerm':
								if(merId===""){
									modals.info("<spring:message code="modules.device.hint.merchant"/>");
									return false;
								} 
								var ids=[];
								var checkds = $("#bundTagManagerDevice_table > tbody").find("input[type='checkbox']:checked");
								var len = checkds.length;
								if(len<=0){
									modals.info("<spring:message code="sys.labelManagement.chooseDevice"/>！");
									return false;
								}
								$(checkds).each(function(index,ele){
									/* var val = ele.value;
									ids.push(val); */
									var snVal = $.trim($(ele).parent().parent().find("td:eq(2)").html());
									ids.push(snVal);
								});
								modals.confirm({
									cancel_label:"<spring:message code="common.cancel" />",
									title:"<spring:message code="common.sys.confirmTip" />",
									ok_label:"<spring:message code="common.confirm" />",
									text:"<spring:message code="sys.labelManagement.bundconfirm" />？",
									callback: function() {
										$.ajax({
											type : 'POST',
											traditional:true,
											 data: {
											    "ids": ids,
											    "tagId":"${id}"
											  },
											url:basePath + "/sys/tagManager/boundBatchTerm",
											success:function(data){
												if (data.code == 200) {
													modals.correct({
														title:'<spring:message code="common.sys.success" />',
														cancel_label:'<spring:message code="common.confirm" />',
														text:data.message});
													bundTagManagerDeviceTable.reloadRowData();
												}
											}
										});
									}});
								break;
							case 'unBund':
								var ids=[];
								var checkds =$("#bundTagManagerDevice_table > tbody").find("input[type='checkbox']:checked");
								var len = checkds.length;
								if(len<=0){
									modals.info("<spring:message code="sys.labelManagement.chooseDevice"/>！");
									return false;
								}
								$(checkds).each(function(index,ele){
									/* var val = ele.value;
									ids.push(val); */
									var snVal = $.trim($(ele).parent().parent().find("td:eq(2)").html());
									ids.push(snVal);
								});
								modals.confirm({
									cancel_label:"<spring:message code="common.cancel" />",
									title:"<spring:message code="common.sys.confirmTip" />",
									ok_label:"<spring:message code="common.confirm" />",
									text:"<spring:message code="sys.labelManagement.unbundconfirm" />？",
									callback: function() {
										$.ajax({
											type : 'POST',
											traditional:true,
											 data: {
											    "ids": ids,
											    "tagId":"${id}"
											  },
											url:basePath + "/sys/tagManager/unBoundBatchTerm",
											success:function(data){
												if (data.code == 200) {
													modals.correct({
														title:'<spring:message code="common.sys.success" />',
														cancel_label:'<spring:message code="common.confirm" />',
														text:data.message});
													bundTagManagerDeviceTable.reloadRowData();
												}
											}
										});
									}});
								break;
							}
						});
	});
	
	function check(id){	
		var oper = "&nbsp;&nbsp;&nbsp;";
		oper += "<input value='"+id+"' type='checkBox' >"+"</input>";
        return oper;
	}
	function state(deviceBundState){
		var state = "";
		if(deviceBundState==="0"){
			state='<spring:message code="sys.labelManagement.unbund"/>';
		}else if(deviceBundState==="1"){
			state='<spring:message code="sys.labelManagement.bund"/>';
		}
        return state;
	}
	
	function change(){
		var check = $("#allSelect").is(':checked');
		$("input[type='checkbox']").prop("checked",check);
	}
 
	$(function(){
		merStores("selectMerchants1","selectStores1");
		merStores("selectMerchants","selectStores");
		$('#div_unBund').hide();
		$("button[data-btn-type='search']").click(function(){
			if('1' == $("#listMode").val()){
				$('#div_boundTerm').hide();
				$('#div_unBund').show();
			}else{
				$('#div_unBund').hide();
				$('#div_boundTerm').show();
			}
		});
		
	});
function merStores(merSelectId,storeSelectId){
	$("#"+merSelectId).change(function(){
		var secSelect = document.getElementById(storeSelectId);
		var merId = this.value;
		secSelect.options.length = 0;
		$.ajax({
			url:basePath+'/sys/store/stores?merId='+merId,
			success:function(res){
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
