<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<link rel="stylesheet"
	href="${ctxStatic}/common/libs/webuploader/webuploader.css">
<style>
.span_line {
	font-size: 16px;
	color: gray;
	line-height: 40px;
}

.span_value {
	font-size: 16px;
	color: black;
	font-weight: bold;
	line-height: 40px;
}
.nav-tabs-custom>.nav-tabs>.active>a, .nav-tabs-custom>.nav-tabs>.active>a:hover, ..nav-tabs-custom>nav-tabs>.active>a:focus {
    border-color: #337ab7;
    border-color: transparent;
}
.nav-tabs-custom>.nav-tabs {
   border: 1px solid #337ab7;
}
.nav-tabs-custom>.tab-content {
   border: 1px solid #337ab7;
}
#bmapInfo {
height:400px;
width:100%;
}
</style>
<script src="${ctxStatic}/common/libs/webuploader/webuploader.js"></script>
<!-- <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=59HUmDo9lXpSzmFYX0agwoda6lKN6UHx"></script> -->
<script type="text/javascript">
	// 谷歌地图API功能
	var geocoder;
	function initialize() {
		var myCenter = new google.maps.LatLng("${location.latitude}","${location.longitude}");
		var mapProp = {
			center : myCenter,
			zoom : 12,
			mapTypeId : google.maps.MapTypeId.ROADMAP
		};
	
		map = new google.maps.Map(
				document.getElementById("bmapInfo"), mapProp);
		//经纬度解析器
		geocoder = new google.maps.Geocoder();
		var marker = new google.maps.Marker(
				{
					position : myCenter,
					map : map
				});// 创建标注
				google.maps.event
				.addListener(
						marker,
						'click',
						function(event) {
							var infowindow = new google.maps.InfoWindow(
									{
										content : "<font color='red'>设备SN："
												+ "${device.deviceSn}"
												+ "</font>"
									});
							infowindow
									.open(
											map,
											marker);
						});
	}
	window.onload = initialize();
	
</script>


<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title" align="left"><spring:message code="modules.device.information"/></h5>
</div>
<div class="modal-body">
	<div class="box-body">
		<div class="row">
			<!-- /.box-header -->
			<div class="col-md-4 panel panel-primary">
				<div class="panel-body">
					<span class="span_line">&nbsp;&nbsp;<spring:message code="ota.table.device.sn"/>：</span> <span
						class="span_value">&nbsp;&nbsp;${device.deviceSn}</span> <br /> 
					<span class="span_line">&nbsp;&nbsp;<spring:message code="modules.device.deviceinfo.type"/>：</span> <span
						class="span_value">&nbsp;&nbsp;${device.deviceType}</span> <br />
					<span class="span_line">&nbsp;&nbsp;<spring:message code="modules.device.parame.devicesort"/>：</span> <span
						class="span_value">&nbsp;&nbsp;${device.deviceSort}</span> <br />
					<span class="span_line">&nbsp;&nbsp;<spring:message code="modules.device.manufacturer"/>：</span> <span
						class="span_value">&nbsp;&nbsp;${device.manufacturerName}</span> <br />
					<span class="span_line">&nbsp;&nbsp;<spring:message code="modules.device.hint.affiliatedmerchant"/>：</span> <span
						class="span_value">&nbsp;&nbsp;${device.merName}</span> <br />
					<span class="span_line">&nbsp;&nbsp;<spring:message code="modules.device.hint.affiliatedstore"/>：</span> <span
						class="span_value">&nbsp;&nbsp;${device.shopName}</span> <br />
					<span class="span_line">&nbsp;&nbsp;<spring:message code="modules.device.parame.installlocation"/>：</span> <span
						class="span_value">&nbsp;&nbsp;${device.installLocation}</span> <br />
					<%-- <span class="span_line">&nbsp;&nbsp;<spring:message code="modules。device.hint.affiliatedlabel"/>：</span> <span
						class="span_value">&nbsp;&nbsp;</span> <br /> --%>
					<br /> 

				</div>
			</div>
			<!-- /.box-body -->

			<!-- Left col -->
			<div class="col-md-8 ">
				<!-- tabs-->
				<div class="nav-tabs-custom">
					<!-- Tabs within a box -->
					<ul class="nav nav-tabs">
					    <li class="active"><a href="#" data-target="#serviceInfo"
							data-toggle="tab"><spring:message code="modules.device.hard.information"/></a></li>
						<li><a href="#" data-target="#logInfo" data-toggle="tab"><spring:message code="modules.device.application.information"/></a></li>
						<li><a href="#" data-target="#bmapInfo" data-toggle="tab"><spring:message code="modules.device.parame.location"/></a></li>
					</ul>
					<div class="tab-content no-padding">
						<!-- Morris chart -->
						<div class="tab-pane active" id="serviceInfo">
						
						<div style="width: 50%;float: left;">
							<span class="span_line">&nbsp;&nbsp;&nbsp;<spring:message code="modules.device.system.version"/>：</span>
							<span class="span_line">${deviceInfo.androidosversion}</span>
							<br /> <span class="span_line">&nbsp;&nbsp;&nbsp;<spring:message code="ota.table.manufacturer.name"/>：</span>
							<span class="span_line">${deviceInfo.manufacture}</span>
							<br /><span class="span_line">&nbsp;&nbsp;&nbsp;<spring:message code="modules.device.deviceinfo.type"/>：</span>
							<span class="span_line">${deviceInfo.model}</span>
						
							<br />
						
							 <span class="span_line">&nbsp;&nbsp;&nbsp;<spring:message code="modules.device.deviceinfo.internet"/>：</span>
							<c:forEach items="${dictList2}" var="dict" varStatus="idxStatus">
								<c:if test="${dict.value == deviceInfo.internet }">
									<span class="span_line">${dict.label }</span>
								</c:if>
							</c:forEach>	
							<br /> <span class="span_line">&nbsp;&nbsp;&nbsp;<spring:message code="modules.device.deviceinfo.totalmemory"/>：</span>
							<span class="span_line">${deviceInfo.totalmemory}</span>
							<br /> <span class="span_line">&nbsp;&nbsp;&nbsp;<spring:message code="modules.device.deviceinfo.availmemory"/>：</span>
							<span class="span_line">${deviceInfo.availmemory}</span>		
							<br /> <span class="span_line">&nbsp;&nbsp;&nbsp;<spring:message code="modules.device.deviceinfo.battery"/>：</span>
							<span class="span_line"><c:if test="${deviceInfo.battery != null}">${deviceInfo.battery}%</c:if></span>	
							<br /> <span class="span_line">&nbsp;&nbsp;&nbsp;WIFI：</span>
							<span class="span_line">
							<c:forEach items="${statusList}" var="status1" varStatus="idxStatus">
								<c:if test="${status1.value == deviceInfo.wifi}">
									<span class="span_line">${status1.label }</span>
								</c:if>
							</c:forEach>
							</span>	
							</div>
							<div style="float:left;width: 50%">
							<br /> <span class="span_line">&nbsp;&nbsp;&nbsp;WCDMA：</span>
							<span class="span_line"><c:forEach items="${statusList}" var="status1" varStatus="idxStatus">
								<c:if test="${status1.value == deviceInfo.wcdma}">
									<span class="span_line">${status1.label }</span>
								</c:if>
							</c:forEach></span>	
							<br /> <span class="span_line">&nbsp;&nbsp;&nbsp;BLUETOOTH：</span>
							<span class="span_line"><c:forEach items="${statusList}" var="status1" varStatus="idxStatus">
								<c:if test="${status1.value == deviceInfo.bluetooth}">
									<span class="span_line">${status1.label }</span>
								</c:if>
							</c:forEach></span>	
							<br /> 
							</div>
						</div>
						<div class="tab-pane" id="logInfo">
								<table id="code-table"
									class="table table-bordered table-striped table-hover">
								</table>
						</div>
						<div class="tab tab-pane " id="bmapInfo" >
						</div>
					</div>
				</div>
				<!-- /.nav-tabs-custom -->

			</div>
		</div>
	</div>
</div>
<script>
function download(obj){ 	
	$.download(basePath + "/device/downloadLogFile?logId="+obj.value, "post", "");
}
$(document).ready(function() {
	
	var deviceId = ${device.id};
	ajaxPost(
			basePath+'/device/checkDeviceAppList', 
			{deviceId:deviceId},  
			function(data, status) 
			{
				if(data.code == 200){
					$('#code-table').dataTable( {
				         autoWidth:false,
				         data: data.data,
				         columns: [
				             { data: 'appLogo', title:'<spring:message code="ota.table.application.logo"/>',className:"text-center"},    
				             { data: 'appName',title:'<spring:message code="ota.table.application.name"/>', className:"text-center"},
				             { data: 'appVersion', title:'<spring:message code="ota.table.application.appversion"/>', className:"text-center"},
				             { data: 'appPackage', title:'<spring:message code="ota.table.application.appPackage"/>', className:"text-center"},
				             { data: 'installDate', title:'<spring:message code="ota.table.application.installdate"/>', className:"text-center"},
				             { data: 'appDeveloper', title:'<spring:message code="ota.table.application.developer"/>', className:"text-center"}
							  
				        ],
				        bFilter: false,    //去掉搜索框方法
				        bLengthChange: false,   //去掉每页显示多少条数据方法
				        bSort: false,  //禁止排序
				        "aoColumnDefs" : [{
				            targets : 0,
				            data : "appLogo",
				            render : function(data, type, row) {
				            	var oper = "";
					     		if(data==null || data == ''){
					     			oper += "<div class='textavatar' style='width: 40px;' data-name='"+row.appName+"'></div>";
					     		}else{
					     			oper += "<div class='appimg'> <img src='" + row.appLogo + "' class='appimg-circle' /></div>";
					     		}
					     		return oper;
				            }
				        }],
				        "language" : { // 中文支持
				        	"sUrl" : basePath + $.i18n.prop("common.language")
						}
				    } );   
				}
				if(data.code == 400){
					modals.warn(data.message);
				}
		});
	
	$('.textavatar').textAvatar();
});
</script>
