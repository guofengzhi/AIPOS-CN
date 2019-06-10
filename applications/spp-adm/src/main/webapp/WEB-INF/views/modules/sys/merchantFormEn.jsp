<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=nYICsgumUhMHbsnYVBFHG2eh3vewG0p3"></script> -->
<!-- <script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDeq5ahjwh5ZQA66IKy5msWG2RQQlN5ZZI&sensor=false"></script> -->
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
//谷歌地图API功能===================================================================================================
		var maker;
		var geocoder;
		function initialize() {
			var mapProp = {
				center :new google.maps.LatLng(39.8071864614,116.4489128550),
				zoom : 12,
				mapTypeId : google.maps.MapTypeId.ROADMAP
			};
		
			var map = new google.maps.Map(
					document.getElementById("allmap"), mapProp);
			//经纬度解析器
			geocoder = new google.maps.Geocoder();
			google.maps.event.addListener(map, 'click', function(event) {
				if (window.marker)
					marker.setMap(null);//删除上一个标记
				window.marker = new google.maps.Marker({
					position : event.latLng,
					map : map,
				});
				$("#longitude").attr("value", event.latLng.lng());
				$("#latitude").attr("value", event.latLng.lat());
				//根据经纬度解析地址
				if (geocoder) {
					geocoder.geocode({
						'location' : event.latLng
					}, function(results, status) {
						if (status == google.maps.GeocoderStatus.OK) {
							if (results[0]) {
								$("#address").attr('value',
										results[0].formatted_address);
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
																		results[0].geometry.location.lat());
														$("#latitude")
																.attr(
																		"value",
																		results[0].geometry.location.lng());
													}
												});
							});
			function placeMarker(location) {
				$("#longitude").attr("value", location.lng());
				$("#latitude").attr("value", location.lat());
			}
		}
		window.onload = initialize();

//==============================================================================================================
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
											/* stringLength : {
												max : 10,
												message : '<spring:message code="longitude.max.length"/>'
											}, */
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
											/* stringLength : {
												max : 10,
												message : '<spring:message code="latitude.max.length"/>'
											}, */
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
											/* stringLength : {
												max : 10,
												message : '<spring:message code="longitude.max.length"/>'
											}, */
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
											/* stringLength : {
												max : 10,
												message : '<spring:message code="latitude.max.length"/>'
											}, */
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



