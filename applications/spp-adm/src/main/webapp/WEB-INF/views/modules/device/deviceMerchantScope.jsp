<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<section class="content-header">
		<ol class="breadcrumb">
			<li><a href="${basePath}"><i class="fa fa-dashboard"></i>
				<spring:message code="common.homepage" /></a></li>
			<li><a href="#"><spring:message code="position.range.management" /></a></li>
			<li class="active"><spring:message code="common.homepage" /></li>
		</ol>
		<div class="col-sm-12"></div>
	</section>
<section class="content">
	<div class="row">
			<div class="col-xs-12">
			<div class="box">
				<div id="merchantScopeSearchDiv" class="dataTables_filter" role="form" style="text-align: left;margin-top:10px;">
					<%-- <label for="office.id" class="col-sm-2 control-label"><spring:message
							code="sys.user.office" /></label> --%>
					<div class="col-sm-3">
					<label class="col-sm-6 control-label">
							<!-- <strong><font color="blue" >商户数：</font><label id="merP"></label><font color="blue" >&nbsp;家</font></strong> -->
							<span class="label label-info pull-right" style=" float:left;padding-top:3.6px !important;"><spring:message code="number.of.merchants" />：<label id="merP"></label></span>
						</label>
					<label class="col-sm-6 control-label">
							<!-- <strong><font color="red" >设备数：</font><label id="termP"></label><font color="red" >&nbsp;台</font></strong> -->
							<span class="label label-danger pull-right"  style="float:left; padding-top:3.6px !important;"><spring:message code="number.of.devices" />：<label id="termP"></label></span>
						</label>
					</div>
					<div class="col-sm-3">
						<input id="scopeOrgSelect" 
							name="orgId" class="form-control" type="hidden"
							placeholder="${orgId}" />
						<input  id="scopeOrgSelectValue" style="width: 330px;" name="orgName" class="form-control" htmlEscape="false"
							maxlength="100" placeholder='<spring:message code="sys.user.office" />' onclick="showOrgTree();"/>
					</div>
							<div class="col-sm-3">
									<select id="selectMerchants" name="merId" class="form-control select2" data-placeholder="<spring:message code='modules.device.hint.affiliatedmerchant' />" style="float: left;"
									style="width: 226.5px;">
									<option value=""><spring:message code="all" /></option>
								</select>
							</div>
							<div class="btn-group col-sm-3">
								<button type="button" class="btn btn-primary" id="search" style="float: left;"
									data-btn-type="search">
									<spring:message code="common.query" />
								</button>
								<button type="button" class="btn btn-default" id="reset" style="float: left;"
									data-btn-type="reset">
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
/* $(function(){
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
}); */
$(function(){
	$("#selectMerchants").select2();
	$("#reset").click(function(){
		 $("select").select2().val("");
		 $("#scopeOrgSelectValue").val("");
		 $("#scopeOrgSelect").val("");
	});
	var merId = $("#selectMerchants").val();
	var orgId = $("#scopeOrgSelect").val();
	termLoca(orgId,merId);
	merLoca(orgId,merId);
	// 百度地图API功能===================================================================================================
	var geolocationControl = new BMap.GeolocationControl();
	var geolocation = new BMap.Geolocation();
	var lo = 116.331398;
	var la = 39.897445;
	var initPoint = new BMap.Point(lo,la);
	var map = new BMap.Map("allmap");
	//map.centerAndZoom(initPoint,12);
	// 创建地址解析器实例
	var myGeo = new BMap.Geocoder();
	  // 添加定位控件
	
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

	map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
	
//=========================================================================
		$("#search").click(function(){
			map.clearOverlays();
			var merId = $("#selectMerchants").val();
			var orgId = $("#scopeOrgSelect").val();
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
							var point = new BMap.Point(longitude, latitude);
							var circle = new BMap.Circle(point,element.radius,{strokeColor:"blue", strokeWeight:1, strokeOpacity:0.5}); //创建圆
							 var myIcon = new BMap.Icon("http://api.map.baidu.com/img/markers.png", new BMap.Size(23, 25), {  
			                        offset: new BMap.Size(10, 25), // 指定定位位置  
			                        imageOffset: new BMap.Size(0, 0 - 10 * 25) // 设置图片偏移  
			                    });  
							var marker = new BMap.Marker(point,{icon:myIcon});  // 创建标注
							map.addOverlay(marker);              // 将标注添加到地图中

							/* var label = new BMap.Label(  "<font color='blue'>商户："+element.merName+"</font>",{offset:new BMap.Size(30,30)});
							marker.setLabel(label); */
							map.addOverlay(circle); 
							
							var opts = {
									  width : 250,     // 信息窗口宽度
									  height: 50,     // 信息窗口高度
									  title : element.merName+"："+element.address , // 信息窗口标题
									  enableMessage:true,//设置允许信息窗发送短息
							}
							var infoWindow = new BMap.InfoWindow("<spring:message code='device.range.radius'/>： "+element.radius+" 米", opts);  // 创建信息窗口对象
							if(!merId==""){
								map.centerAndZoom(point,16);
							}else{
								map.centerAndZoom(initPoint,12);
							}
							marker.addEventListener("click", function(){          
								map.openInfoWindow(infoWindow,point); //开启信息窗口
							});
						}
					});
				}else{
					map.centerAndZoom(initPoint,12);
				}
			}
		});
	}
	function termLoca(orgId,merId){
		$.ajax({
			url:basePath+"/scope/terms?orgId="+orgId+"&merId="+merId,
			success:function(data){
				var da = eval('('+data+')');
				var leg = da.length;
				$("#termP").text(leg);
				$(da).each(function(index,element){
					var Location = element.Location;
					var loca = eval('('+Location+')'); 
					var point = new BMap.Point(loca.longitude, loca.latitude);
					addMarker(point);
					var marker = new BMap.Marker(point);  // 创建标注
					map.addOverlay(marker);              // 将标注添加到地图中
					/* var label = new BMap.Label( "<font color='red'>设备："+element.deviceSn+"</font>",{offset:new BMap.Size(20,10)});
					marker.setLabel(label); */
					var opts = {
							  width : 200,     // 信息窗口宽度
							  height: 50,     // 信息窗口高度
							  title : "设备SN："+element.deviceSn , // 信息窗口标题
							  enableMessage:true,//设置允许信息窗发送短息
					}
					var infoWindow = new BMap.InfoWindow("<spring:message code='affiliated.merchants'/>："+element.merName, opts);  // 创建信息窗口对象 
					marker.addEventListener("click", function(){          
						map.openInfoWindow(infoWindow,point); //开启信息窗口
					});
				});
			}
		});
	}

	function addMarker(point){
		  var marker = new BMap.Marker(point);
		  map.addOverlay(marker);
	}
}); 
function showOrgTree() {
	modals
			.openWin({
				winId : "scopeOrgTree",
				title : '<spring:message code="modules.device.importing.equipment.by.product.batch"/>',
				width : '300px',
				url : basePath
						+ "/sys/office/toOfficeTree?windowId=scopeOrgTree&orgSelect=scopeOrgSelect&orgSelectValue=scopeOrgSelectValue"
			});
}

//==============================================================================================================
</script>