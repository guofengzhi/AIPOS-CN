<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="modules.device.get.a.log"/></h5>
</div>

<!-- Main content -->
<div class="modal-header">
	<ul class="nav nav-tabs">
		<li class="active"><a href="#tab-content-appFile"
			data-toggle="tab" id="merInfo"><i class="fa fa-list-ul"></i>&nbsp;<spring:message code="modules.device.get.a.log"/><br /></a></li>
		<li class=""><a href="#tab-content-osRomInfo" data-toggle="tab"
			id="merCert"><i class="fa fa-image"><spring:message code="modules.device.file.search"/></i>&nbsp;<br /></a></li>
	</ul>
</div>

<div class="modal-body nav-tabs-custom">
	<input type="hidden" id="sn" name="sn" value="${device.deviceSn }">
	<input type="hidden" id="deviceId" name="deviceId"
		value="${device.id }">
	<div class="tab-content">
		<div class="tab-pane active" id="tab-content-appFile">
			<!-- 日志列表 -->
			<jsp:include page="deviceMenuTree.jsp" flush="true" />
		</div>
		<div class="tab-pane" id="tab-content-osRomInfo">
			<!-- 文件搜索 -->
			<jsp:include page="devicePackageList.jsp" flush="true" />
		</div>
	</div>
</div>
