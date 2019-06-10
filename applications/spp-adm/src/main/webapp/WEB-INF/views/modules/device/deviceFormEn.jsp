<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<link rel="stylesheet"
	href="${ctxStatic}/common/libs/webuploader/webuploader.css">
<script src="${ctxStatic}/common/libs/webuploader/webuploader.js"></script>

<spring:message
	code="app.apprecord.please.select.the.equipment.manufacturer"
	var="selectManufacturer" />
<spring:message code="app.apprecord.please.select.the.device.type"
	var="selectDeviceType" />
<spring:message code="app.release.please.choose.the.industry"
	var="selectIndustry" />
<spring:message code="modules.device.hint.merchant" var="selectMerchant" />
<spring:message code="modules.device.hint.shop" var="selectStore" />
<spring:message code="ota.table.client" var="client" />
<spring:message code="ota.table.client.identification"
	var="identification" />
<spring:message code="ota.table.device.sn" var="deviceSn" />


<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title">
		<spring:message code="modules.device.add.device" />
	</h5>
</div>
<div class="modal-body">
	<form:form id="device-form" name="device-form" modelAttribute="device"
		class="form-horizontal">
		<form:hidden path="id" id="id" value="${device.id }" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'>
		<div class="box-body">
			<div class="col-md-5">

				<div class="form-group" style="margin: 1em;">
					<label for="manufacturerNo" class="col-sm-3 control-label"><spring:message
							code="app.release.manufacturer" /><span style="color: red">*</span></label>
					<div class="col-sm-8">
						<form:select path="manufacturerNo" id="manuNo"
							onchange="manuChange()" class="form-control select2"
							style="width: 100%;">
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
							<form:options items="${deviceTypeList}" itemLabel="deviceType"
								itemValue="deviceType" htmlEscape="false" />
						</form:select>
					</div>
				</div>

				<div class="form-group" style="margin: 1em;">
					<label for="device.merId" class="col-sm-3 control-label"><spring:message
							code="app.release.merchant" /></label>
					<div class="col-sm-8">
						<form:select path="merId" id="merId1" onchange="clickMerId()"
							class="form-control select2" style="width: 100%;">
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
							<form:options items="${stores}" itemLabel="storeName"
								itemValue="storeId" htmlEscape="false" />
						</form:select>
					</div>
				</div>



				<div class="form-group" style="margin: 1em;">
					<label for="parame.applyDate" class="col-sm-3 control-label"><spring:message
							code="modules.device.parame.applydate" /></label>
					<div class="col-sm-8">
						<input id="applyDate" name="applyDate" type="date"
							class="form-control"
							value="<fmt:formatDate value='${device.applyDate}' pattern='yyyy-MM-dd' />">
					</div>
				</div>
				<div class="form-group" style="margin: 1em;">
					<label class="col-sm-3 control-label"><spring:message
							code="modules.device.parame.installdate" /><span
						style="color: red">*</span></label>
					<div class="col-sm-8">
						<input id="applyDate" name="applyDate" type="date"
							class="form-control"
							value="<fmt:formatDate value='${device.installDate}' pattern='yyyy-MM-dd' />">

					</div>
				</div>
				<div class="form-group" style="margin: 1em;">
					<label class="col-sm-3 control-label"><spring:message
							code="modules.device.parame.deviceSn" /><span style="color: red">*</span></label>
					<div class="col-sm-8">
						<input id="deviceSn" name="deviceSn" type="text"
							value="${device.deviceSn}" class="form-control">

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

<script>
	//tableId,queryId,conditionContainer
	var romform = null;
	var id = "${empty device.id?0:device.id}";
	$(".select2").select2();
	$(function() {

		//编辑时，将客户编号赋值
		var clientNo = '${device.clientNo}';
		if (clientNo != null && clientNo != '') {
			$("#customerIdId").val(clientNo);
		}
		//清空设备列表选择的行业赋值
		$("#industryId").val('');
		/* var manufacturerNo = '${device.manufacturerNo}';
		if (manufacturerNo != null) {
			$("#manuNo").val(manufacturerNo);
		}

		var deviceType = '${device.deviceType}';
		if (deviceType != null) {
			$("#deviceTypeId1").val(deviceType);
		}

		var shopId1 = '${device.shopId}';
		if (shopId1 != null) {
			$("#shopId").val(shopId1);
		} */

		romform = $("#device-form").form();
		//数据校验
		$("#device-form")
				.bootstrapValidator(
						{
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
												var params = romform
														.getFormSimpleData();
												ajaxPost(
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
														});
											});
						});
		//初始化控件
		//筛选行业
		clickIndustry();
	});

	function resetromForm() {
		romform.clearForm();
		$("#device-form").data('bootstrapValidator').resetForm();
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

	function clickIndustry() {
		var value = $("#industryForm").val();
		$("#industryId").val(value);
	}

	function clickMerId() {
		var params = {};
		var merId = $("#merId1").val();
		if (merId == '' || merId == null) {
			$("#shopId1").empty();
		}
		params['merId'] = merId;
		ajaxPost(basePath + '/device/storeList', params,
				function(data, status) {
					if (data.code == 200) {
						var stores = data.data;
						$("#shopId1").empty();
						for (var i = 0; i < stores.length; i++) {
							$("#shopId1")
									.append(
											"<option value=\""+stores[i].storeId+"\">"
													+ stores[i].storeName
													+ "</option>");
						}
					} else {
						modals.warn(data.message);
					}
				});
	}

	function shopChange() {
		var merId = $("#merId1").val();
		if (merId == '') {
			modals
					.info('<spring:message code="modules.device.hint.merchant"/>');
			$("#shopId1").empty('');
		}
	}

		var deviceLo = "${deviceLo}";
		var deviceLa = "${deviceLa}";
		var addrLocation;
			// 谷歌地图API功能===================================================================================================
			var maker;
			var geocoder;
			function initialize() {
				var mapProp = {
					center : new google.maps.LatLng(39.8071864614,
							116.4489128550),
					zoom : 12,
					mapTypeId : google.maps.MapTypeId.ROADMAP
				};

				var map = new google.maps.Map(
						document.getElementById("allmap"), mapProp);
				//经纬度解析器
				geocoder = new google.maps.Geocoder();
				google.maps.event
						.addListener(
								map,
								'click',
								function(event) {
									if (window.marker)
										marker.setMap(null);//删除上一个标记
									window.marker = new google.maps.Marker({
										position : event.latLng,
										map : map,
									});
									$("#longitude").attr("value",
											event.latLng.lng());
									$("#latitude").attr("value",
											event.latLng.lat());
									//根据经纬度解析地址
									if (geocoder) {
										geocoder
												.geocode(
														{
															'location' : event.latLng
														},
														function(results,
																status) {
															if (status == google.maps.GeocoderStatus.OK) {
																if (results[0]) {
																	$(
																			"#address")
																			.attr(
																					'value',
																					results[0].formatted_address);
																	debugger;
																	var add = results[0].formatted_address;
																	var adds = add
																			.split(",");
																	var length = adds.length;
																	var city = "";
																	var street = "";
																	var streetNumber = "";
																	if (adds[length - 3] != undefined) {
																		city = adds[length - 3];
																		if (adds[length - 4] != undefined) {
																			street = adds[length - 4];
																			if (adds[length - 5] != undefined) {
																				streetNumber = adds[length - 5];
																			}
																		}
																	}

																	addrLocation = "{'addr':'"
																			+ add
																			+ "','city':'"
																			+ city
																			+ "','street':'"
																			+ street
																			+ streetNumber
																			+ "','country':'"
																			+ adds[length - 1]
																			+ "','province':'"
																			+ adds[length - 2]
																			+ "','district':'','latitude':'"
																			+ event.latLng
																					.lat()
																			+ "','longitude':'"
																			+ event.latLng
																					.lng()
																			+ "'}";
																			modals.info(addrLocation);
																	$("#locationString").val(addrLocation);
																}
															}
														});
									}
								});

				$("#address")
						.blur(
								function() {
									debugger;
									var address = this.value;
									//根据地址解析经纬度
									geocoder
											.geocode(
													{
														'address' : address
													},
													function(results, status) {
														if (status == google.maps.GeocoderStatus.OK) {
															console
																	.log(results[0].geometry.location)
															map
																	.setCenter(results[0].geometry.location);
															if (window.marker)
																marker
																		.setMap(null);//删除上一个标记
															this.marker = new google.maps.Marker(
																	{
																		title : address,
																		map : map,
																		position : results[0].geometry.location
																	});
															$("#longitude")
																	.attr(
																			"value",
																			results[0].geometry.location.Ea);
															$("#latitude")
																	.attr(
																			"value",
																			results[0].geometry.location.Da);
															var add = results[0].formatted_address;
															var adds = add
																	.split(",");
															var length = adds.length;
															var city = "";
															var street = "";
															var streetNumber = "";
															if (adds[length - 3] != "undefined") {
																city = adds[length - 3];
																if (adds[length - 4] != "undefined") {
																	street = adds[length - 4];
																	if (adds[length - 5] != "undefined") {
																		streetNumber = adds[length - 5];
																	}
																}
															}
															addrLocation = "{'addr':'"
																	+ add
																	+ "','city':'"
																	+ city
																	+ "','street':'"
																	+ street
																	+ streetNumber
																	+ "','country':'"
																	+ adds[length - 1]
																	+ "','province':'"
																	+ adds[length - 2]
																	+ "','district':'','latitude':'"
																	+ event.latLng
																			.lat()
																	+ "','longitude':'"
																	+ event.latLng
																			.lng()
																	+ "'}";
															$("#locationString").val(addrLocation);
														}
													});
								});
				function placeMarker(location) {
					$("#longitude").attr("value", location.lng());
					$("#latitude").attr("value", location.lat());
				}
			}
			//==============================================================================================================
	window.onload = initialize();
</script>
