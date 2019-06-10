<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="modules.osrom.release.system.version"/></h5>
</div>

<div class="modal-header">	
	<ul class="nav nav-tabs">
		<li class="active"><a href="#tab-content-appFile"
			data-toggle="tab" id="merInfo"><i class="fa fa-list-ul"></i>&nbsp;<spring:message code="modules.osrom.system.package"/><br />
				<small><spring:message code="modules.osrom.file.information"/></small></a></li>
		<li class=""><a href="#tab-content-osRomInfo" data-toggle="tab"
			id="merCert"><i class="fa fa-image"><spring:message code="modules.osrom.basic.information.of.program.equipment"/></i>&nbsp;<br /> <small><spring:message code="modules.osrom.system.progrem"/></small></a></li>
	</ul>
</div>

<div class="modal-body nav-tabs-custom">
    <input type="hidden" id="filePathId" name="filePathId" value="">
     <input type="hidden" id="fileMd5ValueId" name="fileMd5Value" value="">
    <input type="hidden" id="option" name="option" value="${option}">
	<div class="tab-content">
		<div class="tab-pane active" id="tab-content-appFile">
		    <!-- 程序包信息 --> 
		    <jsp:include page="appFile.jsp" flush="true"/>			
		</div>
		<div class="tab-pane" id="tab-content-osRomInfo">
			<!-- 程序基本信息 -->
			<jsp:include page="osRomInfoForm.jsp" flush="true"/>	
		</div>
	</div>

</div>

