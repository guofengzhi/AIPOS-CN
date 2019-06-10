<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="common.form.select" var="formSelect" />
<spring:message code="tms.table.updateItems.manufactureNo" var="manufactureNo" />
<spring:message
	code="app.apprecord.please.select.the.equipment.manufacturer"
	var="pleaseSelectMerNo" />
<spring:message code="tms.table.updateItems.fileType" var="fileType" />
<spring:message code="please.select.updateItems.type"
	var="pleaseSelectFileType" />
<spring:message code="tms.table.updateItems.fileVersion"
	var="fileVersion" />
<spring:message code="please.input.updateItems.version"
	var="pleaseInputFileVersion" />
<spring:message code="select.updateItems" var="selectUpdateItems" />
<style>
.file-preview {
	padding-top: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
	padding-right: 0px;
	border-right-width: 0px;
	border-top-width: 0px;
	border-left-width: 0px;
	border-bottom-width: 0px;
}

.file-drop-zone {
	border-top-width: 0px;
	border-right-width: 0px;
	border-bottom-width: 0px;
	border-left-width: 0px;
}

.file-caption-main {
	width: 89%;
	margin-left: 6px;
}
</style>

<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title">
		<spring:message code="tms.new.updateItems.information" />
	</h5>
</div>

<div class="modal-header">	
	<ul class="nav nav-tabs">
		<li class="active">
			<a href="#tab-content-appFile" data-toggle="tab" id="merInfo">
				<i class="fa fa-list-ul"></i>&nbsp;上传更新物文件<br />
			</a>
		</li>
		<li class="">
			<a href="#tab-content-osRomInfo" data-toggle="tab" id="merCert">
				<i class="fa fa-image">更新物基本信息</i>&nbsp;<br /> 
			</a>
		</li>
	</ul>
</div>


<div class="modal-body nav-tabs-custom">
    <input type="hidden" id="filePathId" name="filePathId" value="">
    <input type="hidden" id="fileMd5ValueId" name="fileMd5Value" value="">
    <input type="hidden" id="option" name="option" value="${option}">
	<div class="tab-content">
		<div class="tab-pane active" id="tab-content-appFile">
		    <!-- 文件上传 --> 
		    <jsp:include page="uploadFile.jsp" flush="true"/>			
		</div>
		<div class="tab-pane" id="tab-content-osRomInfo">
			<!-- 基本信息 -->
			<jsp:include page="fileInfoForm.jsp" flush="true"/>	
		</div>
	</div>
</div>
