<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<html>
<head>
<%-- 	<%@ include file="/WEB-INF/views/common/head.jsp"%> --%>
<link rel="stylesheet"
	href="${ctxStatic}/adminlte/plugins/bootstrapvalidator/dist/css/bootstrapValidator.css">
<script type="text/javascript"
	src="${basePath}/adminlte/plugins/jQuery-form/jquery.form.js"></script>	
<script type="text/javascript"
	src="${basePath}/adminlte/plugins/jQuery-form/jquery.form.js"></script>	
<script type="text/javascript">
	var storeForm = null;
	//var id = "${empty merchant.id?0:merchant.id}";
	var storeUrl="/sys/store/add";
	$(function() {
		$("#merSelect").select2({
		 }); 
		var mapType = "${mapType}";
		if (mapType == "google") {
			// 谷歌地图API功能===================================================================================================
			var maker;
			var geocoder;
			function initialize() {
				debugger;
				var mapProp = {
					center :new google.maps.LatLng(39.8071864614,116.4489128550),
					zoom : 5,
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
																			results[0].geometry.location.Ea);
															$("#latitude")
																	.attr(
																			"value",
																			results[0].geometry.location.Da);
														}
													});
								});
				function placeMarker(location) {
					$("#longitude").attr("value", location.lng());
					$("#latitude").attr("value", location.lat());
				}
			}
			google.maps.event.addDomListener(window, 'load', initialize);

			//==============================================================================================================
		}else{
			// 百度地图API功能===================================================================================================
			var map = new BMap.Map("allmap");
			var point = new BMap.Point(116.331398,39.897445);
			map.centerAndZoom(point,12);
			// 创建地址解析器实例
			var myGeo = new BMap.Geocoder();
			var geolocation = new BMap.Geolocation();
			  // 添加定位控件
			  var geolocationControl = new BMap.GeolocationControl();
			  geolocationControl.addEventListener("locationSuccess", function(e){
			    // 定位成功事件
			    var address = '';
			    address += e.addressComponent.province;
			    address += e.addressComponent.city;
			    address += e.addressComponent.district;
			    address += e.addressComponent.street;
			    address += e.addressComponent.streetNumber;
			    modals.info("<spring:message code='current.location.address'/>：" + address);
			  });
			  geolocationControl.addEventListener("locationError",function(e){
				    // 定位失败事件
				    modals.info(e.message);
				});
			  map.addControl(geolocationControl);
			$("#address").blur(function(){
				var addr = this.value;
				// 将地址解析结果显示在地图上,并调整地图视野
				myGeo.getPoint(addr, function(point){
					if (point) {
						map.centerAndZoom(point, 16);
						map.addOverlay(new BMap.Marker(point));
						geolocation.getCurrentPosition(function(r){
							if(this.getStatus() == BMAP_STATUS_SUCCESS){
								var mk = new BMap.Marker(point);
								map.addOverlay(mk);
								map.panTo(point);
								$("#longitude").attr("value",point.lng);
								$("#latitude").attr("value",point.lat);
							}
							else {
								modals.info('failed'+this.getStatus());
							}        
						},{enableHighAccuracy: true}); 
					}else{
						modals.info("<spring:message code='address.not.resolved.to.result'/>");
					}
				}, "北京市");
			});
			map.addEventListener("click", function(e){  
				map.clearOverlays();
				var pt = e.point;
				myGeo.getLocation(pt, function(rs){
					var addComp = rs.addressComponents;
					var address = addComp.province + addComp.city  + addComp.district + addComp.street  + addComp.streetNumber;
					$("#address").attr('value',address);
				});   
				geolocation.getCurrentPosition(function(r){
					if(this.getStatus() == BMAP_STATUS_SUCCESS){
						var mk = new BMap.Marker(pt);
						map.addOverlay(mk);
						map.panTo(pt);
						$("#longitude").attr("value",pt.lng);
						$("#latitude").attr("value",pt.lat);
					}
					else {
						modals.info('failed'+this.getStatus());
					}        
				},{enableHighAccuracy: true});     
			});
			map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
		//==============================================================================================================
		}
		


		
		//初始化控件
		storeForm = $("#store-form").form();
		var updateflag = "${updateflag}";
			var id = "${id}";
			
			//数据校验
			if(updateflag==="true"){
				storeUrl = "/sys/store/update?id="+id;
			}
			$("#store-form").bootstrapValidator({
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
									},storeName : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.store.orgId.not.empty"/>'
											}
										}
									},
									storeId : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.store.storeId.not.empty"/>'
											},
											stringLength : {
												min : 6,
												max : 20,
												message : '<spring:message code="sys.store.storeId.length.not.invalid"/>'
											}
										}
									}, 
									linkMan:{
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
									address:{
										validators : {
											notEmpty : {
												message : '<spring:message code="address.not.empty"/>'
											}
										}
									},
									longitude:{
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
									latitude:{
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
									radius:{
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
							}).on('success.form.bv', function(e) {
									 modals.confirm('<spring:message code="common.confirm.save"/>',function() {
										// $("#store-form").bootstrapValidator('validate');//提交验证 
											//if ($("#store-form").data('bootstrapValidator').isValid()) {//获取验证结果，如果成功，执行下面代码  
												var params = storeForm.getFormSimpleData();
												$.ajax({
													type : 'post',
													url : basePath+storeUrl,
													data : params,
													dataType:'json',
													success : function(res) {
														modals.hideWin(winId);
														storeTable.reloadRowData();
													},
													error:function(res){
														modals.hideWin(winId);
														storeTable.reloadRowData();
													}
												}); 
								     });
							});
			
							
	});


	/* function resetstoreForm() {
		storeForm.clearForm();
		$("#store-form").data('bootstrapValidator').resetForm();
	} */
</script>
</head>
<body>
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title">
		<spring:message code="store.add"/>
	</h5>
</div>
<div class="modal-body">
	<form:form id="store-form" name="store-form"
		modelAttribute="store" class="form-horizontal">
		<div class="box-body">
			<div class="col-md-4">
				<div class="form-group">
					<label for="office.id" class="col-sm-3 control-label"><spring:message
							code="sys.user.office" /></label>
					<div class="col-sm-8">
						<%-- <input  type="hidden" id="orgId" name="orgId" value="${orgId}">
						<input  type="text" id="orgName" name="orgName" class="form-control" value="${orgName}">
						<div id="officetree"></div> --%>
						<input id="storeFormOrgSelect" style="width: 253.33px;"
							name="orgId" class="form-control" type="hidden"
							placeholder="${orgId}" />
						<form:input  id="storeFormOrgSelectValue" path="orgName" class="form-control" htmlEscape="false"
							maxlength="100" placeholder="${orgName}" onclick="showOrgTree();"/>
					</div>
				</div>
				<div class="form-group">
					<label for="office.id" class="col-sm-3 control-label"><spring:message
							code="sys.store.merName" /></label>
					<div class="col-sm-8">
						<form:select path="merId" id="merSelect"
							class="form-control select2" style="width: 100%;">
							<form:options items="${merchants}" itemLabel="merName"
								itemValue="merId" htmlEscape="false"/>
						</form:select>
					</div>
				</div>
				<div class="form-group">
					<label for="storeName" class="col-sm-3 control-label"><spring:message
							code="sys.store.name" /><span
						style="color: red">*</span></label>
					<div class="col-sm-8">
						<form:input type="text" htmlEscape="false" class="form-control"
							id="storeName" path="storeName" placeholder="${storeName}"/>
					</div>
				</div>
				<div class="form-group">
					<label for="storeId" class="col-sm-3 control-label"><spring:message
							code="sys.store.id" /><span
						style="color: red">*</span></label>
					<div class="col-sm-8">
						<form:input type="text" htmlEscape="false" class="form-control"
							id="storeId" path="storeId" placeholder="${storeId}"/>
					</div>
				</div>
				<div class="form-group">
					<label for="linkMan" class="col-sm-3 control-label"><spring:message
							code="sys.store.linkMan" /><span
						style="color: red">*</span></label>
					<div class="col-sm-8">
						<form:input type="text" htmlEscape="false" class="form-control"
							id="linkMan" path="linkMan" placeholder="${linkMan}"/>
					</div>
				</div>
				<div class="form-group">
					<label for="linkPhone" class="col-sm-3 control-label"><spring:message
							code="sys.store.mobile" /><span
						style="color: red">*</span></label>
					<div class="col-sm-8">
						<form:input type="text" htmlEscape="false" class="form-control"
							id="linkPhone" path="linkPhone" placeholder="${linkPhone}"/>
					</div>
				</div>
				<div class="form-group">
					<label for="address" class="col-sm-3 control-label"><spring:message
							code="sys.store.address" /><span
						style="color: red">*</span></label>
					<div class="col-sm-8">
						<form:input type="text" htmlEscape="false" class="form-control"
							id="address" path="address" placeholder="${address}"/>
					</div>
				</div>
				<p style="margin-left:90px;margin-top:-10px;"><font color="green"><spring:message
							code="tips" /></font></p>
					<div class="form-group">
					<label for="longitude" class="col-sm-3 control-label"><spring:message
							code="longitude" /><span
						style="color: red">*</span></label>
					<div class="col-sm-8">
						<form:input type="text" htmlEscape="false" class="form-control"
							id="longitude" path="longitude" placeholder="${longitude}"/>
					</div>
				</div>
				<div class="form-group">
					<label for="latitude" class="col-sm-3 control-label"><spring:message
							code="latitude" /><span
						style="color: red">*</span></label>
					<div class="col-sm-8">
						<form:input type="text" htmlEscape="false" class="form-control"
							id="latitude" path="latitude" placeholder="${latitude}"/>
					</div>
				</div>
				<div class="form-group">
					<label for="radius" class="col-sm-3 control-label"><spring:message
							code="device.range.radius" /><span
						style="color: red">*</span></label>
					<div class="col-sm-8">
						<form:input type="text" htmlEscape="false" class="form-control" value="500"
							id="radius" path="radius" placeholder="${radius}"/>
					</div>
				</div>
			</div>
			<div class="col-md-8" id="map"  style="height: 500px;">
				<div id="allmap"  style="height: 500px;"></div>
			</div>
		</div>
		<div class="box-footer text-right">
		<button type="button" class="btn btn-default"
			data-dismiss="modal" id="cancel">
			<spring:message code="common.cancel" />
		</button>
		<button class="btn btn-primary" data-btn-type="save"
			id="save">
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
				winId : "storeFormOrgTree",
				title : '<spring:message code="modules.device.importing.equipment.by.product.batch"/>',
				width : '300px',
				url : basePath
						+ "/sys/office/toOfficeTree?windowId=storeFormOrgTree&orgSelect=storeFormOrgSelect&orgSelectValue=storeFormOrgSelectValue"
			});
}
</script>
</html>

