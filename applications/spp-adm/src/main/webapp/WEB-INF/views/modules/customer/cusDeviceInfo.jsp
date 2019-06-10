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

</style>
<script src="${ctxStatic}/common/libs/webuploader/webuploader.js"></script>
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
					<span class="span_line">&nbsp;&nbsp;<spring:message code="modules.device.information"/>：</span> <span
						class="span_value">&nbsp;&nbsp;${device.deviceSn}</span> <br /> <span
						class="span_line">&nbsp;&nbsp;<spring:message code="ota.table.device.sn"/>：</span> <span
						class="span_value">&nbsp;&nbsp;${device.deviceType}</span> <br />
					<span class="span_line">&nbsp;&nbsp;<spring:message code="modules.device.manufacturer"/>：</span> <span
						class="span_value">&nbsp;&nbsp;${device.manufacturerNo}</span> <br />
					<span class="span_line">&nbsp;&nbsp;<spring:message code="modules.device.status"/>：</span> <span
						class="span_value">&nbsp;&nbsp;${device.deviceStatus}</span> <br />
					<span class="span_line">&nbsp;&nbsp;<spring:message code="modules.device.system.version"/>：</span> <span
						class="span_value">&nbsp;&nbsp;${device.deviceOsVersion}</span> <br />
					<span class="span_line">&nbsp;&nbsp;<spring:message code="modules.device.hard.version"/>：</span> <span
						class="span_value">&nbsp;&nbsp;${device.hardwareVersion}</span> <br />
					<span class="span_line">&nbsp;&nbsp;<spring:message code="modules.device.system.identification"/>：</span> <span
						class="span_value">&nbsp;&nbsp;${device.clientIdentification}</span>
					<br /> <span class="span_line">&nbsp;&nbsp;<spring:message code="ota.table.client.name"/>：</span> <span
						class="span_value">&nbsp;&nbsp;${device.clientNo}</span> <br />

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
					</ul>
					<div class="tab-content no-padding">
						<!-- Morris chart -->
						<div class="tab-pane active" id="serviceInfo">
							<span class="span_line">&nbsp;&nbsp;&nbsp;GPRS：</span>
							<c:forEach items="${dictList}" var="dict" varStatus="idxStatus">
								<c:if test="${dict.value == deviceInfo.gprs }">
									<span class="span_line">${dict.label }</span>
								</c:if>
							</c:forEach>
							<br /> <span class="span_line">&nbsp;&nbsp;&nbsp;LAN：</span>
							<c:forEach items="${dictList}" var="dict" varStatus="idxStatus">
								<c:if test="${dict.value == deviceInfo.lan }">
									<span class="span_line">${dict.label }</span>
								</c:if>
							</c:forEach>
							<br /> <span class="span_line">&nbsp;&nbsp;&nbsp;WIFI：</span>
							<c:forEach items="${dictList}" var="dict" varStatus="idxStatus">
								<c:if test="${dict.value == deviceInfo.wifi }">
									<span class="span_line">${dict.label }</span>
								</c:if>
							</c:forEach>
							<br /> <span class="span_line">&nbsp;&nbsp;&nbsp;WCDMA：</span>
							<c:forEach items="${dictList}" var="dict" varStatus="idxStatus">
								<c:if test="${dict.value == deviceInfo.wcdma }">
									<span class="span_line">${dict.label }</span>
								</c:if>
							</c:forEach>
							<br /> <span class="span_line">&nbsp;&nbsp;&nbsp;CDMA：</span>
							<c:forEach items="${dictList}" var="dict" varStatus="idxStatus">
								<c:if test="${dict.value == deviceInfo.cdma }">
									<span class="span_line">${dict.label }</span>
								</c:if>
							</c:forEach>
							<br /> <span class="span_line">&nbsp;&nbsp;&nbsp;BLUETOOTH：</span>
							<c:forEach items="${dictList}" var="dict" varStatus="idxStatus">
								<c:if test="${dict.value == deviceInfo.blueTooth }">
									<span class="span_line">${dict.label }</span>
								</c:if>
							</c:forEach>
							<br /> <span class="span_line">&nbsp;&nbsp;&nbsp;PRINTER：</span>
							<c:forEach items="${dictList}" var="dict" varStatus="idxStatus">
								<c:if test="${dict.value == deviceInfo.printer }">
									<span class="span_line">${dict.label }</span>
								</c:if>
							</c:forEach>
							<br />
						</div>
						<div class="tab-pane" id="logInfo">
								<table id="code-table"
									class="table table-bordered table-striped table-hover">
								</table>
						</div>
					</div>
				</div>
				<!-- /.nav-tabs-custom -->

			</div>
		</div>
	</div>
</div>
<script>
$(document).ready(function() {
	var deviceId = ${device.id};
	ajaxPost(
			basePath+'/customer/device/checkDeviceAppList', 
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
				             { data: 'appPackage', title:'<spring:message code="ota.table.application.appPackage"/>', className:"text-center"},
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

