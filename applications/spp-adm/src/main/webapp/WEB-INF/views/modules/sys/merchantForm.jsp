<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=nYICsgumUhMHbsnYVBFHG2eh3vewG0p3"></script> -->
<!-- <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDeq5ahjwh5ZQA66IKy5msWG2RQQlN5ZZI&sensor=false"></script> -->
<script type="text/javascript"
	src="${basePath}/adminlte/plugins/jQuery-form/jquery.form.js"></script>
<script type="text/javascript"
	src="${ctxStatic}/adminlte/plugins/bootstrapvalidator/dist/js/bootstrapValidator.js"></script>
<%-- <script type="text/javascript"
	src="${ctxStatic}/adminlte/plugins/select2/select2tree.js"></script> --%>
<link rel="stylesheet"
	href="${ctxStatic}/adminlte/plugins/bootstrapvalidator/dist/css/bootstrapValidator.css">
<link rel="stylesheet"
	href="${ctxStatic}/adminlte/plugins/select2/select2.min.css">
<link rel="stylesheet"
	href="${ctxStatic}/adminlte/plugins/select2/select2-bootstrap.min.css">
<script type="text/javascript">
	$(function() {
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

			geolocationControl.addEventListener("locationSuccess", function(e) {
				// 定位成功事件
				var address = '';
				address += e.addressComponent.province;
				address += e.addressComponent.city;
				address += e.addressComponent.district;
				address += e.addressComponent.street;
				address += e.addressComponent.streetNumber;
				modals.info("<spring:message code='current.location.address'/>："
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
					$("#address").attr('value', address);
				});
				geolocation.getCurrentPosition(function(r) {
					if (this.getStatus() == BMAP_STATUS_SUCCESS) {
						var mk = new BMap.Marker(pt);
						map.addOverlay(mk);
						map.panTo(pt);
						$("#longitude").attr("value", pt.lng);
						$("#latitude").attr("value", pt.lat);
					} else {
						modals.info('failed' + this.getStatus());
					}
				}, {
					enableHighAccuracy : true
				});
			});
			map.enableScrollWheelZoom(true); //开启鼠标滚轮缩放
			//==============================================================================================================
	});

	var merchantForm = null;
	var merUrl = "/sys/merchant/add";
	$(function() {
		//初始化控件
		merchantForm = $("#merchant-form").form();
		var updateflag = "${updateflag}";
		if (updateflag === "true") {
			var id = "${id}";
			merUrl = "/sys/merchant/update?id=" + id;
			//数据校验
			$("#merchant-form")
					.bootstrapValidator(
							{
								message : '<spring:message code="common.promt.value"/>',
								feedbackIcons : {
									valid : 'glyphicon glyphicon-ok',
									invalid : 'glyphicon glyphicon-remove',
									validating : 'glyphicon glyphicon-refresh'
								},
								fields : {
									orgId : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.store.orgId.not.empty"/>'
											}
										}
									},
									merName : {
										validators : {
											notEmpty : {
												message : '<spring:message code="merchant.name.not.empty"/>'
											}
										}
									},
									merId : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.merchant.merId.not.empty"/>'
											},
											stringLength : {
												min : 6,
												max : 20,
												message : '<spring:message code="sys.merchant.merId.length.not.invalid"/>'
											}
										/* ,
																					remote : {
																						url : basePath
																								+ "/sys/merchant/checkMerId",
																						delay : 2000,
																						message : '<spring:message code="sys.merchant.exist"/>'
																					} */
										}
									},
									linkMan : {
										validators : {
											notEmpty : {
												message : '<spring:message code="linkman.not.empty"/>'
											}
										}
									},
									linkPhone : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.user.promt.mobile"/>'
											},
											stringLength : {
												min : 11,
												max : 11,
												message : '<spring:message code="sys.user.promt.mobile.length"/>'
											},
											regexp : {
												regexp : /^1[3|5|8|7]{1}[0-9]{9}$/,
												message : '<spring:message code="sys.user.promt.mobile.error"/>'
											}
										}
									},
									address : {
										validators : {
											notEmpty : {
												message : '<spring:message code="address.not.empty"/>'
											}
										}
									},
									longitude : {
										validators : {
											notEmpty : {
												message : '<spring:message code="longitude.not.empty"/>'
											},
											stringLength : {
												max : 10,
												message : '<spring:message code="longitude.max.length"/>'
											},
											regexp : {
												regexp : /^[+]?\d*\.\d*$/,
												message : '<spring:message code="longitude.only.number"/>'
											}
										}
									},
									latitude : {
										validators : {
											notEmpty : {
												message : '<spring:message code="latitude.not.empty"/>'
											},
											stringLength : {
												max : 10,
												message : '<spring:message code="latitude.max.length"/>'
											},
											regexp : {
												regexp : /^[+]?\d*\.\d*$/,
												message : '<spring:message code="latitude.only.number"/>'
											}
										}
									},
									radius : {
										validators : {
											notEmpty : {
												message : '<spring:message code="device.range.not.empty"/>'
											},
											stringLength : {
												max : 5,
												message : '<spring:message code="device.max.radius"/>'
											},
											regexp : {
												regexp : /^[1-9]\d{0,4}$/,
												message : '<spring:message code="radius.only.number"/>'
											}
										}
									}
								}
							})
					.on(
							'success.form.bv',
							function(e) {
								// 阻止默认事件提交
								e.preventDefault();
								modals
										.confirm(
												'<spring:message code="common.confirm.save"/>',
												function() {
													//$("#merchant-form").bootstrapValidator('validate');//提交验证 
													//if ($("#merchant-form").data('bootstrapValidator').isValid()) {//获取验证结果，如果成功，执行下面代码  
													var params = merchantForm
															.getFormSimpleData();
													$
															.ajax({
																type : 'post',
																url : basePath
																		+ merUrl,
																data : params,
																dataType : 'json',
																success : function(
																		res) {
																	modals
																			.hideWin(winId);
																	merchantTable
																			.reloadRowData();
																},
																error : function(
																		res) {
																	modals
																			.hideWin(winId);
																	merchantTable
																			.reloadRowData();
																}
															});
													//} 
												});
							});
		} else {
			$("#merchant-form")
					.bootstrapValidator(
							{
								message : '<spring:message code="common.promt.value"/>',
								feedbackIcons : {
									valid : 'glyphicon glyphicon-ok',
									invalid : 'glyphicon glyphicon-remove',
									validating : 'glyphicon glyphicon-refresh'
								},
								fields : {
									orgId : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.store.orgId.not.empty"/>'
											}
										}
									},
									merName : {
										validators : {
											notEmpty : {
												message : '<spring:message code="merchant.name.not.empty"/>'
											}
										}
									},
									merId : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.merchant.merId.not.empty"/>'
											},
											stringLength : {
												min : 6,
												max : 20,
												message : '<spring:message code="sys.merchant.merId.length.not.invalid"/>'
											},
											remote : {
												url : basePath
														+ "/sys/merchant/checkMerId",
												delay : 2000,
												message : '<spring:message code="sys.merchant.exist"/>'
											}
										}
									},
									linkMan : {
										validators : {
											notEmpty : {
												message : '<spring:message code="linkman.not.empty"/>'
											}
										}
									},
									linkPhone : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.user.promt.mobile"/>'
											},
											stringLength : {
												min : 11,
												max : 11,
												message : '<spring:message code="sys.user.promt.mobile.length"/>'
											},
											regexp : {
												regexp : /^1[3|5|8|7]{1}[0-9]{9}$/,
												message : '<spring:message code="sys.user.promt.mobile.error"/>'
											}
										}
									},
									address : {
										validators : {
											notEmpty : {
												message : '<spring:message code="address.not.empty"/>'
											}
										}
									},
									longitude : {
										validators : {
											notEmpty : {
												message : '<spring:message code="longitude.not.empty"/>'
											},
											stringLength : {
												max : 10,
												message : '<spring:message code="longitude.max.length"/>'
											},
											regexp : {
												regexp : /^[+]?\d*\.\d*$/,
												message : '<spring:message code="longitude.only.number"/>'
											}
										}
									},
									latitude : {
										validators : {
											notEmpty : {
												message : '<spring:message code="latitude.not.empty"/>'
											},
											stringLength : {
												max : 10,
												message : '<spring:message code="latitude.max.length"/>'
											},
											regexp : {
												regexp : /^[+]?\d*\.\d*$/,
												message : '<spring:message code="latitude.only.number"/>'
											}
										}
									},
									radius : {
										validators : {
											notEmpty : {
												message : '<spring:message code="device.range.not.empty"/>'
											},
											stringLength : {
												max : 5,
												message : '<spring:message code="device.max.radius"/>'
											},
											regexp : {
												regexp : /^[1-9]\d{0,4}$/,
												message : '<spring:message code="radius.only.number"/>'
											}
										}
									}
								}
							})
					.on(
							'success.form.bv',
							function(e) {
								// 阻止默认事件提交
								e.preventDefault();
								modals
										.confirm(
												'<spring:message code="common.confirm.save"/>',
												function() {
													//$("#merchant-form").bootstrapValidator('validate');//提交验证 
													//if ($("#merchant-form").data('bootstrapValidator').isValid()) {//获取验证结果，如果成功，执行下面代码  
													var params = merchantForm
															.getFormSimpleData();
													$
															.ajax({
																type : 'post',
																url : basePath
																		+ merUrl,
																data : params,
																dataType : 'json',
																success : function(
																		res) {
																	modals
																			.hideWin(winId);
																	merchantTable
																			.reloadRowData();
																},
																error : function(
																		res) {
																	modals
																			.hideWin(winId);
																	merchantTable
																			.reloadRowData();
																}
															});
													//} 
												});
							});
		}
	});
</script>
</head>
<body>
	<div class="modal-header modalsbg">
		<button type="button" class="close" data-dismiss="modal"
			aria-hidden="true">
			<li class="fa fa-remove"></li>
		</button>
		<h5 class="modal-title">
			<spring:message code="add.merchant" />
		</h5>
	</div>
	<div class="modal-body">
		<form:form id="merchant-form" name="merchant-form"
			modelAttribute="merchant" class="form-horizontal">
			<div class="box-body">
				<div class="col-md-5">
					<div class="form-group">
						<label for="office.id" class="col-sm-3 control-label"><spring:message
								code="sys.user.office" /></label>
						<div class="col-sm-8">
							<input id="merFormOrgSelect" style="width: 253.33px;"
							name="orgId" class="form-control" type="hidden"
							placeholder="${orgId}" />
							<form:input  id="merFormOrgSelectValue" path="orgName" class="form-control" htmlEscape="false"
							maxlength="100" placeholder="${orgName}" onclick="showOrgTree();"/>
							
							<%-- <input type="hidden" id="orgId1" name="orgId" value="${orgId}">
							<input type="text" id="orgName1" name="orgName"
								class="form-control" value="${orgName}"> --%>
								
							<!-- <div id="officetree"></div> -->
						</div>
					</div>
					<div class="form-group">
						<label for="merName" class="col-sm-3 control-label"><spring:message
								code="sys.merchant.name" /><span style="color: red">*</span></label>
						<div class="col-sm-8">
							<form:input type="text" htmlEscape="false" class="form-control"
								id="merName" path="merName" placeholder="${merName}" />
						</div>
					</div>
					<div class="form-group">
						<label for="merId" class="col-sm-3 control-label"><spring:message
								code="sys.merchant.id" /><span style="color: red">*</span></label>
						<div class="col-sm-8">
							<form:input type="text" htmlEscape="false" class="form-control"
								id="merId" path="merId" placeholder="${merId}" />
						</div>
					</div>
					<div class="form-group">
						<label for="linkMan" class="col-sm-3 control-label"><spring:message
								code="sys.merchant.linkMan" /><span style="color: red">*</span></label>
						<div class="col-sm-8">
							<form:input type="text" htmlEscape="false" class="form-control"
								id="linkMan" path="linkMan" placeholder="${linkMan}" />
						</div>
					</div>
					<div class="form-group">
						<label for="linkPhone" class="col-sm-3 control-label"><spring:message
								code="sys.merchant.mobile" /><span style="color: red">*</span></label>
						<div class="col-sm-8">
							<form:input type="text" htmlEscape="false" class="form-control"
								id="linkPhone" path="linkPhone" placeholder="${linkPhone}" />
						</div>
					</div>
					<div class="form-group">
						<label for="address" class="col-sm-3 control-label"><spring:message
								code="sys.merchant.address" /><span style="color: red">*</span></label>
						<div class="col-sm-8">
							<form:input type="text" htmlEscape="false" class="form-control"
								id="address" path="address" placeholder="${address}" />
						</div>
					</div>
					<p style="margin-left: 100px; margin-top: -10px;">
						<font color="green"><spring:message code="tips" /></font>
					</p>
					<div class="form-group">
						<label for="longitude" class="col-sm-3 control-label"><spring:message
								code="longitude" /><span style="color: red">*</span></label>
						<div class="col-sm-8">
							<form:input type="text" htmlEscape="false" class="form-control"
								id="longitude" path="longitude" placeholder="${longitude}" />
						</div>
					</div>
					<div class="form-group">
						<label for="latitude" class="col-sm-3 control-label"><spring:message
								code="latitude" /> <span style="color: red">*</span></label>
						<div class="col-sm-8">
							<form:input type="text" htmlEscape="false" class="form-control"
								id="latitude" path="latitude" placeholder="${latitude}" />
						</div>
					</div>
					<div class="form-group">
						<label for="radius" class="col-sm-3 control-label"><spring:message
								code="device.range.radius" /><span style="color: red">*</span></label>
						<div class="col-sm-8">
							<form:input type="text" htmlEscape="false" class="form-control"
								value="500" id="radius" path="radius" placeholder="${radius}" />
						</div>
					</div>
				</div>
				<div class="col-md-7" id="map">
					<div id="allmap" style="height: 440px;"></div>
				</div>
			</div>
			<div class="box-footer text-right">
				<button type="button" class="btn btn-default" data-btn-type="cancel"
					data-dismiss="modal" id="cancel">
					<spring:message code="common.cancel" />
				</button>
				<button class="btn btn-primary" data-btn-type="save" id="save">
					<spring:message code="common.submit" />
				</button>
			</div>
		</form:form>
	</div>
</body>
<script type="text/javascript">
	function showOrgTree() {
		modals
				.openWin({
					winId : "merFormOrgTree",
					title : '<spring:message code="modules.device.importing.equipment.by.product.batch"/>',
					width : '300px',
					url : basePath
							+ "/sys/office/toOfficeTree?windowId=merFormOrgTree&orgSelect=merFormOrgSelect&orgSelectValue=merFormOrgSelectValue"
				});
	}
</script>
</html>



