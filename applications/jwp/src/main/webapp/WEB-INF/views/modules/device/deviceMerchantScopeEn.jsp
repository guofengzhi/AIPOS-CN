<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<div id="merchantScopeSearchDiv" class="dataTables_filter"
					role="form" style="text-align: left; margin-top: 10px;">
					<%-- <label for="office.id" class="col-sm-2 control-label"><spring:message
							code="sys.user.office" /></label> --%>
					<div class="col-sm-3">
						<label class="col-sm-6 control-label"> <!-- <strong><font color="blue" >商户数：</font><label id="merP"></label><font color="blue" >&nbsp;家</font></strong> -->
							<span class="label label-info pull-right"
							style="float: left; padding-top: 3.6px !important;"><spring:message
									code="number.of.merchants" />：<label id="merP"></label></span>
						</label> <label class="col-sm-6 control-label"> <!-- <strong><font color="red" >设备数：</font><label id="termP"></label><font color="red" >&nbsp;台</font></strong> -->
							<span class="label label-danger pull-right"
							style="float: left; padding-top: 3.6px !important;"><spring:message
									code="number.of.devices" />：<label id="termP"></label></span>
						</label>
					</div>
					<div class="col-sm-3">
						<select id="orgSelect" name="orgId" class="form-control select2"
							data-placeholder="<spring:message code='sys.user.office' />"
							style="float: left;" style="width: 226.5px;">
							<option value=""><spring:message code='all' /></option>
							<c:if test="${not empty fns:getOfficeList()}">
								<c:forEach items="${fns:getOfficeList()}" var="office">
									<option value="${office.id}" parent="${office.parentId}">${office.name}</option>
								</c:forEach>
							</c:if>
						</select>
					</div>
					<%-- <label class="col-sm-2 control-label" for="name"><spring:message
									code="sys.merchant.merId" /></label> --%>
					<div class="col-sm-3">
						<%-- <input class="form-control" id="merId" type="text" name="merId"
									placeholder='<spring:message code="sys.merchant.merId"/>' /> --%>
						<select id="selectMerchants" name="merId"
							class="form-control select2"
							data-placeholder="<spring:message code='modules.device.hint.affiliatedmerchant' />"
							style="float: left;" style="width: 226.5px;">
							<option value=""><spring:message code="all" /></option>
						</select>
					</div>
					<div class="btn-group col-sm-3">
						<button type="button" class="btn btn-primary" id="search"
							style="float: left;" data-btn-type="search">
							<spring:message code="common.query" />
						</button>
						<button type="button" class="btn btn-default" id="reset"
							style="float: left;" data-btn-type="reset">
							<spring:message code="common.reset" />
						</button>
					</div>
				</div>
				<div id="map" class="col-sm-12" style="margin-top: 10px;">
					<div id="allmap" style="height: 500px;"></div>
				</div>
			</div>
		</div>
	</div>
</section>
<script type="text/javascript">
	var map;
	var markersArray = []; 
	$("#selectMerchants").select2();
	$("#orgSelect").select2();
	$("#reset").click(function(){
		 $("select").select2().val("");
	});
	var merId = $("#selectMerchants").val();
	var orgId = $("#orgSelect").val();
	termLoca(orgId,merId);
	merLoca(orgId,merId);
// 谷歌地图API功能===================================================================================================
		var geocoder;
		function initialize() {
			var mapProp = {
				center :new google.maps.LatLng(39.8871864614,116.3489128550),
				zoom : 10,
				mapTypeId : google.maps.MapTypeId.ROADMAP
			};
		
			map = new google.maps.Map(
					document.getElementById("allmap"), mapProp);
			//经纬度解析器
			geocoder = new google.maps.Geocoder();
			
			
			
		}
		window.onload = initialize();
	
//=========================================================================
		$("#search").click(function(){
			deleteOverlays()
			var merId = $("#selectMerchants").val();
			var orgId = $("#orgSelect").val();
			if(merId==null){
				merId = "";
			}
			if(orgId==null){
				orgId = "";
			}
			termLoca(orgId,merId);
			merLoca(orgId,merId);
		});
		
			// 随机向地图添加25个标注
			
//=========================================================================

	
	$("#orgSelect").change(function(){
		var secSelect = document.getElementById("selectMerchants");
		var orgId = this.value;
		secSelect.options.length = 0;
		$.ajax({
			url:basePath+'/sys/merchant/merchants?orgId='+orgId,
			success:function(res){
				 var dataJson = res.data;
				 for ( var i = 0; i < dataJson.length; i++) {
					 var oOption = document.createElement("OPTION");
				        oOption.value = dataJson[i].merId;
				        oOption.text = dataJson[i].merName;
				        secSelect.options.add(oOption);
				 }
			}
		});
	});
	function merLoca(orgId,merId){
		$.ajax({
			url:basePath+"/scope/merchants?orgId="+orgId+"&merId="+merId,
			success:function(data){
				
				var da = eval('('+data+')'); 
				var leg = da.length;
				$("#merP").text(leg);
				if(leg>0){
					$(da).each(function(index,element){
						var longitude = element.longitude;
						var latitude = element.latitude;
						if(longitude!=null&&latitude!=null&&longitude!=""&&longitude!=""){
							var myCenter=new google.maps.LatLng(latitude,longitude);
							var marker = new google.maps.Marker({
									position : myCenter,
									icon: "${ctxStatic}/common/images/merchant_location.png",
																map : map
															});// 创建标注
													var merchantScope = new google.maps.Circle(
															{
																center : myCenter,
																radius : element.radius,
																strokeColor : "#40E0D0",
																strokeOpacity : 0.8,
																strokeWeight : 0.5,
																fillColor : "#40E0D0",
																fillOpacity : 0.4,
																map : map
															});
													markersArray.push(marker);
													markersArray
															.push(merchantScope);
													google.maps.event
															.addListener(
																	marker,
																	'click',
																	function(
																			event) {
																		var infowindow = new google.maps.InfoWindow(
																				{
																					content : "<font color='blue'>"
																							+ element.merName
																							+ "："
																							+ element.address
																							+ "</font>"
																				});
																		infowindow
																				.open(
																						map,
																						marker);
																	});
												}
											});
						} else {
							map.centerAndZoom(initPoint, 12);
						}
					}
				});
	}
	function termLoca(orgId, merId) {
		$
				.ajax({
					url : basePath + "/scope/terms?orgId=" + orgId + "&merId="
							+ merId,
					success : function(data) {
						var da = eval('(' + data + ')');
						var leg = da.length;
						$("#termP").text(leg);
						$(da)
								.each(
										function(index, element) {
											var Location = element.Location;
											var loca = eval('(' + Location
													+ ')');
											var myCenter = new google.maps.LatLng(
													loca.latitude,
													loca.longitude);
											var marker = new google.maps.Marker(
													{
														position : myCenter,
														map : map
													});// 创建标注
											markersArray.push(marker);
											google.maps.event
													.addListener(
															marker,
															'click',
															function(event) {
																var infowindow = new google.maps.InfoWindow(
																		{
																			content : "<font color='red'>Device SN："
																					+ element.deviceSn
																					+ "</font>"
																		});
																infowindow
																		.open(
																				map,
																				marker);
															});
										});
					}
				});
	}
	function deleteOverlays() {
		if (markersArray) {
			for (i in markersArray) {
				debugger;
				markersArray[i].setMap(null);
			}
			markersArray.length = 0;
		}
	}
	//==============================================================================================================
</script>
<style type="text/css">
 .treeview {
		 overflow-y:auto;
		 height:300px;
		 }
</style>