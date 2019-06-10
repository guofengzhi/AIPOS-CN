<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
        <li class="fa fa-remove"></li>
    </button>
    <div>&nbsp;</div>
    <!--<h5 class="modal-title"></h5>-->
    <ul class="nav nav-tabs">
        <li class="active"><a href="#tab-content-list" data-toggle="tab" id="nav-tab-list"><i class="fa fa-list-ul"></i>&nbsp;<spring:message code="workflow.proinst.detail.table" /></a></li>
        <li><a href="#tab-content-edit" data-toggle="tab" id="nav-tab-edit"><i class="fa fa-image"></i>&nbsp;<spring:message code="workflow.proinst.image.deplay" /></a></li>
    </ul>
</div>
<div class="modal-body nav-tabs-custom" style="height: 600px;padding: 0px;">
    <div class="tab-content" style="padding: 0px;">
        <div class="tab-pane active" id="tab-content-list">
            <!-- 流程列表 -->
			<jsp:include page="monitor_show_list.jsp" flush="true" />
        </div>
        <div class="tab-pane" id="tab-content-edit">
            <!-- 流程图示 -->
			<jsp:include page="monitor_show_image.jsp" flush="true" />
        </div>
    </div>
</div>

