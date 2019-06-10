<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<spring:message code="app.release.client" var="releaseClient"/>
<spring:message code="modules.device.hint.merchant" var="selectMerchant"/>
<spring:message code="modules.device.hint.shop" var="selectStore"/>
<!-- Content Header (Page header) -->
<div id="listForm">
<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="nav-tabs-custom">
					<ul class="nav nav-tabs pull-right">
						<li><a href="#tab-content-edit" data-toggle="tab"
							id="nav-tab-edit"><i class="fa fa-edit"></i></a></li>
						<li class="active"><a href="#tab-content-list"
							data-toggle="tab" id="nav-tab-list"><i class="fa fa-list-ul"></i></a></li>
						<li class=" header"><i class="fa-hourglass-half "></i><small><spring:message
									code="ota.table.device.type.list"></spring:message></small></li>
					</ul>
					<div class="tab-content">
						<div class="tab-pane active" id="tab-content-list">
								<div class="box">
									<!-- /.box-header -->
									<div class="dataTables_filter" id="deviceSearchDiv" style="text-align: left;" role="form">
										 <div class="form-group dataTables_filter " style="margin: 1em;">
										 		<select name="manufacturerNo" style="height:36px;width: 180px;" id="manufacturerNo" onchange="manuFacturerChange()" 
													data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>' class="form-control select2" >
												  		 <option value=""></option>
												 		 <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
											      				<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
											     		 </c:forEach>
												</select>
												<select name="osDeviceType" style="height:36px;width: 180px;" id="deviceTypeId" onchange="deviceTypeChange()" 
														data-placeholder='<spring:message code="app.apprecord.please.select.the.device.type"/>' class="form-control select2">
														   <option value=""></option>
												</select>
												<select id="merId" name="merId" style="height:36px;width: 180px;"  data-placeholder="${selectMerchant}" onchange="clickMerId()" class="form-control select2">  
													  <option value=""></option>
													  <c:forEach items='${merchants}' var="merchant" varStatus="idxStatus">
												      		<option value="${merchant.merId}">${merchant.merName}</option>
												      </c:forEach>
												</select>
												<select  id="shopId" name="shopId" style="height:36px;width: 180px;" data-placeholder="${selectStore}" onchange="shopChange()" class="form-control select2">
													  <c:forEach items="${stores}" var="store" varStatus="idxStatus">
												      		<option value="${store.storeId}">${store.storeName}</option>
												      </c:forEach>
												</select>
												<input style="height:36px;width: 180px;" placeholder='<spring:message code="app.apprecord.please.enter.the.device.sn.number"/>' id="deviceSn" name="deviceSn" class="form-control"
														type="search" /> 
												<button type="button" class="btn btn-primary"  style="height:37px;"
													data-btn-type="search"><spring:message code="common.query"/></button>
												<button type="button" class="btn btn-default"  style="height:37px;"
													data-btn-type="reset"><spring:message code="common.reset"/></button>
												<shiro:hasPermission name="device:edit">
													<button type="button"  style="height:37px;" class="btn btn-primary" data-btn-type="toBoundDevice"><i class="fa fa-plus"></i><spring:message code="device.bund"/></button>
													 <button type="button"  class="btn btn-default"  data-btn-type="deleteDevice" title="<spring:message code='common.delete'/>"  style="height:37px;" >
													 <i class="fa fa-remove"></i>
												   </button>
												   <button data-btn-type="editDevice" class="btn btn-default"  title="<spring:message code='common.edit'/>" type="button"  style="height:37px;" >
													 <i class="fa fa-edit"></i>
												   </button>
													<button type="button"   style="height:37px;" class="btn btn-default" data-btn-type="addDevice" title="<spring:message code='common.add'/>"><i class="fa fa-plus"></i></button>
													<button type="button"  style="height:37px;"  class="btn btn-default" data-btn-type="batImportFile"><spring:message code="modules.device.file.importing.device"/></button>
						                 	 </shiro:hasPermission>
										 </div>
									
					                </div>
									<div class="box-body">
										<table id="device_table"
											class="table table-condensed table-bordered table-striped table-hover" style="margin-top:0px !important;">
										</table>
									</div>
									<!-- /.box-body -->
								</div>
						</div>
					    <div class="tab-pane" id="tab-content-edit">
					    		<form:form id="device-form" name="device-form" modelAttribute="device"
									class="form-horizontal">
									<form:hidden path="id" id="id" value="${device.id }" />
									 <input type='hidden' value='${CSRFToken}' id='csrftoken'>
									 <input type="hidden" id="addOrUpdate" value="" />
									   <input type="hidden" id="deviceLo" value="" />
									   <input type="hidden" id="deviceLa" value="" />
									<div class="box-body">
										<div class="col-md-5">
							
											<div class="form-group" style="margin: 1em;">
												<label for="manufacturerNo" class="col-sm-3 control-label"><spring:message
														code="app.release.manufacturer" /><span style="color: red">*</span></label>
												<div class="col-sm-8">
													<form:select path="manufacturerNo" id="manuNo"
														onchange="manuChange()" class="form-control select2"
														style="width: 100%;">
														 <option value=""></option>
														<form:options items="${manuFacturerList}"
															itemLabel="manufacturerName" itemValue="manufacturerNo"
															htmlEscape="false" />
													</form:select>
												</div>
											</div>
											<div class="form-group" style="margin: 1em;">
												<label for="deviceType" class="col-sm-3 control-label"><spring:message
														code="ota.table.device.type" /><span style="color: red">*</span></label>
												<div class="col-sm-8">
													<form:select path="deviceType" id="deviceTypeId1"
														onchange="deviceChange()" class="form-control select2"
														style="width: 100%;">
														 <option value=""></option>
														<form:options items="${deviceTypeList}" itemLabel="deviceType"
															itemValue="deviceType" htmlEscape="false" />
													</form:select>
												</div>
											</div>
							
											<div class="form-group" style="margin: 1em;">
												<label for="device.merId" class="col-sm-3 control-label"><spring:message
														code="app.release.merchant" /></label>
												<div class="col-sm-8">
													<form:select path="merId" id="merId1" onchange="clickMerId1()"
														class="form-control select2" style="width: 100%;">
														 <option value=""></option>
														<form:options items="${merchants}" itemLabel="merName"
															itemValue="merId" htmlEscape="false" />
													</form:select>
												</div>
											</div>
											<div class="form-group" style="margin: 1em;">
												<label for="device.shopId" class="col-sm-3 control-label"><spring:message
														code="app.release.store" /></label>
												<div class="col-sm-8">
													<form:select path="shopId" id="shopId1" onchange="shopChange()"
														class="form-control select2" style="width: 100%;">
														 <option value=""></option>
														<%-- <form:options items="${stores}" itemLabel="storeName"
															itemValue="storeId" htmlEscape="false" /> --%>
													</form:select>
												</div>
											</div>
							
							
							
											<div class="form-group" style="margin: 1em;">
												<label for="parame.applyDate" class="col-sm-3 control-label"><spring:message
														code="modules.device.parame.applydate" /></label>
												<div class="col-sm-8">
												<form:input type="text" htmlEscape="false" class="form-control"
														id="applyDate" path="applyDate" value=""   data-flag="datepicker"/>		
												</div>
											</div>
											<div class="form-group" style="margin: 1em;">
												<label class="col-sm-3 control-label"><spring:message
														code="modules.device.parame.installdate" /><span
													style="color: red">*</span></label>
												<div class="col-sm-8">
													<form:input type="text" htmlEscape="false" class="form-control"
														id="installDate" path="installDate" value=""  data-flag="datepicker" />
							
												</div>
											</div>
											<div class="form-group" style="margin: 1em;">
												<label class="col-sm-3 control-label"><spring:message
														code="modules.device.parame.deviceSn" /><span style="color: red">*</span></label>
												<div class="col-sm-8">
													<form:input type="text" htmlEscape="false" class="form-control"
														id="deviceSn" path="deviceSn" value="" />		
												</div>
											</div>
											<div class="form-group" style="margin: 1em;">
												<label for="parame.installLocation" class="col-sm-3 control-label"><spring:message
														code="modules.device.parame.installlocation" /></label>
												<div class="col-sm-8">
													<input id="address" name="installLocation" type="text"
														value="${device.installLocation}" class="form-control">
												</div>
											</div>
											<div class="form-group" style="margin: 1em;" hidden="true">
												<label for="parame.installLocation" class="col-sm-3 control-label">传递json</label>
												<div class="col-sm-8">
													<input id="locationString" name="locationString" type="text"
														class="form-control">
												</div>
											</div>
										</div>
										<div class="col-md-7" id="map">
											<div id="allmap" style="height: 474px;"></div>
										</div>
									</div>
									<!-- /.box-body -->
									<div class="box-footer text-right">
										<!--以下两种方式提交验证,根据所需选择-->
										<button type="button" class="btn btn-default" data-btn-type="cancel"
											data-dismiss="modal">
											<spring:message code="common.cancel" />
										</button>
										<button type="submit" class="btn btn-primary" data-btn-type="save">
											<spring:message code="common.submit" />
										</button>
									</div>
							
									<!-- /.box-footer -->
								</form:form>
					    </div>
					</div>
					
			</div>		
		</div>
	</div>
</section>

<script>
function setTitle(title) {
	$("ul.nav-tabs li.header small").text(title);
}
function shopChange() {
	var merId = $("#merId1").val();
	if (merId == '') {
		modals.info('<spring:message code="modules.device.hint.merchant"/>');
		$("#shopId1").empty('');
	}
}

function deviceChange() {

	var manufacturerNo = $("#manuNo").val();
	if (manufacturerNo == '') {
		modals
				.info('<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>');
		$("#deviceTypeId1").empty('');
	}
}
function manuChange() {
	var params = {};
	var manufacturerNo = $("#manuNo").val();
	if (manufacturerNo == '' || manufacturerNo == null) {
		$("#deviceTypeId1").empty('');
	}
	params['manufacturerNo'] = manufacturerNo;
	ajaxPost(basePath + '/deviceType/getDeviceTypeByManuNo', params,
			function(data, status) {

				if (data.code == 200) {
					var deviceTypes = data.data;
					$("#deviceTypeId1").empty();
					for (var i = 0; i < deviceTypes.length; i++) {
						$("#deviceTypeId1").append(
								"<option value=\""+deviceTypes[i].deviceType+"\">"
										+ deviceTypes[i].deviceType
										+ "</option>");
					}
				} else {
					modals.warn(data.message);
				}
			});
}
var deviceform = $("#deviceSearchDiv").form({baseEntity: false});
deviceform.initComponent();
	var deviceTable,winId = "deviceWin";
	 var config={
			//singleSelect:null
	};
	 var dataForm=$("#device-form").form();
	$(function() {
		
		//编辑区域点击事件
		 $("#nav-tab-edit").click(function(){
			 dataForm.clearForm();
			 $("#addOrUpdate").val("add");

		 });
		 $("#nav-tab-list").click(function(){
			  setTitle("<spring:message code="sys.ota.deviceList.manager"/>");
		 });
		
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
					/* 	deviceProcessDef.addDeviceInfo(); */
								 setTitle('<spring:message code="modules.device.add.device"/>');//设置界面显示信息
								 $("#nav-tab-edit").click();
								 dataForm.clearForm();
								 $("#addOrUpdate").val("add");

								 $(".form-horizontal").data("bootstrapValidator").resetForm();
						break;
					case 'merExport':
						modals.confirm('<spring:message code="modules.device.do.you.want.to.export.the.user"/>', function() {
							$.download(basePath + "/sys/user/export",
									"post", "userSearchDiv");
						});
						break;
					
					case 'batImportFile':{
						deviceProcessDef.batImportFile();
						break;
					}
					case 'editDevice':
						if (!deviceRowId) {
							modals.info('请选择要修改的行！');
							return false;
						}
						/* deviceProcessDef.editDevice(deviceRowId); */
						setTitle("<spring:message code="sys.merchant.edit"/>");
								$("#nav-tab-edit").click();
								$("#addOrUpdate").val("update");
								ajaxPost(basePath+"/device/DeviceEditOrAdd?id="+deviceRowId, null, function(data) {
											 dataForm.clearForm();
										     dataForm.initFormData(data);
											 $("#deviceLo").val(JSON.parse(data.location).longitude);
											 $("#deviceLa").val(JSON.parse(data.location).latitude);
											 $("#tab-content-edit #address").val(JSON.parse(data.location).addr);
											 mapALl(JSON.parse(data.location).longitude,JSON.parse(data.location).latitude);
											 $(".form-horizontal").data("bootstrapValidator").resetForm();
								});
						break;
					case 'deleteDevice':
						if (!deviceRowId) {
							modals.info('请选择要删除的行！');
							return false;
						}
						deviceProcessDef.deleteDevice(deviceRowId);
						break;
					default:
						break;
					case 'cancel':
                        $("#nav-tab-list").click();
                        $("#addOrUpdate").val("add");
                     break;
					}

				});
		$("#device-form").bootstrapValidator({
			message : '<spring:message code="app.appinfo.please.enter.a.valid.value"/>',
			feedbackIcons : {
				valid : 'glyphicon glyphicon-ok',
				invalid : 'glyphicon glyphicon-remove',
				validating : 'glyphicon glyphicon-refresh'
			},
			fields : {
				manufacturerNo : {
					validators : {
						notEmpty : {
							message : '<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>'
						}
					}
				},
				deviceType : {
					validators : {
						notEmpty : {
							message : '<spring:message code="app.apprecord.please.select.the.device.type"/>'
						}
					}
				},
				deviceSn : {
					validators : {
						notEmpty : {
							message : '<spring:message code="app.apprecord.please.enter.the.device.sn.number"/>'
						}
					}
				}
			}
		})
.on(
		"success.form.bv",
		function(e) {
			e.preventDefault();

			modals
					.confirm(
							'<spring:message code="common.confirm.save"/>',
							function() {
								//Save Data，对应'submit-提交'
								var params = dataForm.getFormSimpleData();
								 ajaxPost(basePath+'/device/save', params, function(data, status) {
										if (data.code == '200' || data.code == 200) {
											var addOrUpdate = $("#addOrUpdate").val();
											if (addOrUpdate == "update") {//更新
												modals.info({
							                        title:'<spring:message code="common.sys.info" />', 
							                        cancel_label:'<spring:message code="common.close" />',
							                        text:'<spring:message code="common.editSuccess" />'}); 
													deviceTable.reloadRowData($('#id').val());
											} else if(addOrUpdate == "add") {//新增
												modals.info({
							                        title:'<spring:message code="common.sys.info" />', 
							                        cancel_label:'<spring:message code="common.close" />',
							                        text:'<spring:message code="common.AddSuccess" />'});
													deviceTable.reloadData();
													 $("#addOrUpdate").val("add");

											}
											  dataForm.clearForm();
											  $("#nav-tab-list").click();
											  setTitle("<spring:message code="sys.ota.deviceList.manager"/>");
											  $("#csrftoken").val("");
										} else{
											modals.error(data.message);
										}
							}); 
								/* ajaxPost(
										basePath
												+ '/device/save',
										params,
										function(data, status) {
											if (data.code == 200) {
												//新增 
												modals
														.correct(data.message);
												modals
														.hideWin(winId);
												deviceTable
														.reloadRowData();
											} else {
												modals
														.info(data.message);
											}
										}); */
							});
		});
	});
	
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
        oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.checkDevice(\"" + id +"\")'>设备详情</a>";
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
	function clickMerId1() {
		var params = {};
		var merId = $("#merId1").val();
		 $("#shopId1").select2("val", " ");
		 $("#shopId1").val("");
		 $("#shopId1").empty();
		if (merId == '' || merId == null) {
			 $("#shopId1").select2("val", " ");
			 $("#shopId1").val("");
			 $("#shopId1").empty();
		}
		params['merId'] = merId;
		ajaxPost(basePath + '/device/storeList', params,
				function(data, status) {
					if (data.code == 200) {
						var stores = data.data;
						 $("#shopId1").select2("val", " ");
						 $("#shopId1").empty();
						for (var i = 0; i < stores.length; i++) {
							$("#shopId1").append("<option value=\""+stores[i].storeId+"\">"+ stores[i].storeName+ "</option>");
						}
					} else {
						modals.warn(data.message);
					}
				});
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
	function mapALl(deviceLo,deviceLa){

		var deviceLo = deviceLo;
		var deviceLa = deviceLa;
		var location;
		// 百度地图API功能===================================================================================================
		var geolocationControl = new BMap.GeolocationControl();
		var geolocation = new BMap.Geolocation();
		var lo = 116.331398;
		var la = 39.897445;
		var point = new BMap.Point(lo, la);
		var map = new BMap.Map("allmap");
		map.centerAndZoom(point, 12);
		// 创建地址解析器实例
		var myGeo = new BMap.Geocoder();
		// 添加定位控件
		if (deviceLo != null && deviceLo != '' && deviceLa != null
				&& deviceLa != '') {
			var po = new BMap.Point(deviceLo, deviceLa);
			var marker = new BMap.Marker(po);
			map.addOverlay(marker);
		}
		geolocationControl.addEventListener("locationSuccess", function(e) {
			// 定位成功事件
			var address = '';
			address += e.addressComponent.province;
			address += e.addressComponent.city;
			address += e.addressComponent.district;
			address += e.addressComponent.street;
			address += e.addressComponent.streetNumber;
			modals.info('<spring:message code="current.location.address"/>'
					+ address);
		});
		geolocationControl.addEventListener("locationError", function(e) {
			// 定位失败事件
			modals.info(e.message);
		});
		map.addControl(geolocationControl);
		$("#address")
				.blur(
						function() {
							map.clearOverlays();
							var addr = this.value;
							// 将地址解析结果显示在地图上,并调整地图视野
							myGeo
									.getPoint(
											addr,
											function(point) {
												if (point) {
													map.centerAndZoom(
															point, 16);
													map
															.addOverlay(new BMap.Marker(
																	point));
													geolocation
															.getCurrentPosition(
																	function(
																			r) {
																		if (this
																				.getStatus() == BMAP_STATUS_SUCCESS) {
																			var mk = new BMap.Marker(
																					point);
																			map
																					.addOverlay(mk);
																			map
																					.panTo(point);
																			$(
																					"#longitude")
																					.attr(
																							"value",
																							point.lng);
																			$(
																					"#latitude")
																					.attr(
																							"value",
																							point.lat);

																			myGeo
																					.getLocation(
																							point,
																							function(
																									rs) {
																								var addComp = rs.addressComponents;
																								var address = addComp.province
																										+ addComp.city
																										+ addComp.district
																										+ addComp.street
																										+ addComp.streetNumber;
																								location = "{'addr':'"
																										+ address
																										+ "','city':'"
																										+ addComp.city
																										+ "','street':'"
																										+ addComp.street
																										+ addComp.streetNumber
																										+ "','country':'中国','province':'"
																										+ addComp.province
																										+ "','district':'"
																										+ addComp.district
																										+ "','latitude':'"
																										+ point.lat
																										+ "','longitude':'"
																										+ point.lng
																										+ "'}";
																								$(
																										"#locationString")
																										.val(
																												location);
																								$(
																										"#address")
																										.val(
																												address);
																							});
																		} else {
																			modals.info('failed'
																					+ this
																							.getStatus());
																		}
																	},
																	{
																		enableHighAccuracy : true
																	});
												} else {
													modals.info("<spring:message code='address.not.resolved.to.result'/>");
												}
											}, "北京市");
						});
		map.addEventListener("click", function(e) {
			map.clearOverlays();
			var pt = e.point;
			myGeo.getLocation(pt, function(rs) {
				var addComp = rs.addressComponents;
				var address = addComp.province + addComp.city
						+ addComp.district + addComp.street
						+ addComp.streetNumber;
				location = "{'addr':'" + address + "','city':'"
						+ addComp.city + "','street':'" + addComp.street
						+ addComp.streetNumber
						+ "','country':'中国','province':'"
						+ addComp.province + "','district':'"
						+ addComp.district;
				$("#address").val(address);

			});
			geolocation.getCurrentPosition(function(r) {
				//if (this.getStatus() == BMAP_STATUS_SUCCESS) {
				var mk = new BMap.Marker(pt);
				map.addOverlay(mk);
				map.panTo(pt);
				//$("#longitude").attr("value", pt.lng);
				//$("#latitude").attr("value", pt.lat);
				location = location + "','latitude':'" + pt.lat
						+ "','longitude':'" + pt.lng + "'}";
				$("#locationString").val(location);
				//} else {
				//alert('failed' + this.getStatus());
				//}
			}, {
				enableHighAccuracy : true
			});
		});
		map.enableScrollWheelZoom(true); //开启鼠标滚轮缩放
		//==============================================================================================================
	}
	$(function (){
		mapALl("","");
	});
</script>
</div>
