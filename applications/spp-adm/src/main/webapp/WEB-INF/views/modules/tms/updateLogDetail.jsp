<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="common.form.select" var="formSelect" />
<spring:message code="tms.table.updateItems.manufactureNo" var="manufactureNo" />
<spring:message code="tms.table.updateStrategy.deviceSn" var="deviceSn" />
<spring:message
	code="app.apprecord.please.select.the.equipment.manufacturer"
	var="pleaseSelectMerNo" />
<spring:message code="tms.table.updateItems.fileName" var="fileName" />
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
		<spring:message code="tms.table.log.detail" />
	</h5>
</div>

<div class="modal-body">
	<form:form id="logDetail-form" name="logDetail-form"
		modelAttribute="updateLog" class="form-horizontal">
		<form:hidden path="id" value="${updateLog.id}" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'> 

		<div class="box-body">
			<div class="col-md-12">
				<!-- 文件名称、文件类型 -->
				<div class="form-group" style="margin-left: -80px;">
					<label for="fileName" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateItems.fileName" /></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:input type="text" htmlEscape="false" class="form-control" readonly="true"
							id="fileName" path="fileName" placeholder="${fileName}" />
					</div>
					<label for="fileType" class="col-sm-2 control-label"><spring:message
							code="tms.file.type" /><span style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:select path="fileType" class="form-control select2" disabled="true"
							style="width: 100%;">
							<form:option value="" label="${formSelect}" /> 
							<form:options items="${fns:getDictList('tms_file_type')}"
								itemLabel="label" itemValue="value" htmlEscape="false" />
						</form:select>
					</div>
				</div>
				<!-- 厂商、文件版本 -->				
				<div class="form-group" style="margin-left: -80px;">
					<label for="manufactureNo" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateItems.manufactureNo" /><span style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:select path="manufactureNo" class="form-control select2" disabled="true"
							style="width: 100%;">
							<form:option value="" label="${formSelect}" /> 
							<form:options items="${manufacturerList}"
								itemLabel="manufacturerName" itemValue="manufacturerNo" htmlEscape="false" />
						</form:select>
					</div>
					<label for="fileVerion" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateItems.fileVersion" /><span
						style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:input type="text" htmlEscape="false" class="form-control" readonly="true"
							id="fileVersion" path="fileVersion" placeholder="${fileVersion}" />
					</div>
				</div>
				<!-- 文件大小、文件路径 -->
				<div class="form-group" style="margin-left: -80px;">
					<label for="fileSize" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateItems.fileSize" /></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:input type="text" htmlEscape="false" class="form-control" readonly="true"
							id="fileSize" path="fileSize" placeholder="${fileSize}" />
					</div>
					<label for="filePath" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateItems.filePath" /></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:input type="text" htmlEscape="false" class="form-control" readonly="true"
							id="filePath" path="filePath" placeholder="${filePath}" />
					</div>
				</div>
				<!-- 策略名称、商户号 -->
				<div class="form-group" style="margin-left: -80px;">
					<label class="col-sm-2 control-label"><spring:message
								code="tms.table.updateStrategy.strategyName" /><span style="color: red">*</span></label> 
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:input type="text" htmlEscape="false" class="form-control" readonly="true"
							id="strategyName" path="strategyName" placeholder="${strategyName}" />
					</div>
					
					<label class="col-sm-2 control-label"><spring:message
								code="tms.table.updateStrategy.merNo" /><span style="color: red">*</span></label> 
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:input type="text" htmlEscape="false" class="form-control" readonly="true"
							id="merNo" path="merNo" placeholder="${merNo}" />
					</div>
				</div>
				<!-- 开始时间、结束时间	 -->
				<div class="form-group" style="margin-left: -80px;">
					<label for="beginDate" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateStrategy.beginDate" /><span style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:input type="text" htmlEscape="false" class="form-control" readonly="true"
							id="beginDate" path="beginDate" placeholder="${beginDate}" />
					</div>		
					<label for="endDate" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateStrategy.endDate" /><span style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:input type="text" htmlEscape="false" class="form-control" readonly="true"
							id="endDate" path="endDate" placeholder="${endDate}" />
					</div>
				</div>
				<!-- 更新次数、设备类型	-->
				<div class="form-group" style="margin-left: -80px;">
					<label for="updateTime" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateStrategy.updateTime" /><span style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:select path="updateTime" class="form-control select2" disabled="true"
							style="width: 100%;">
							<form:option value="" label="${formSelect}" /> 
							<form:options items="${fns:getDictList('tms_update_time')}"
								itemLabel="label" itemValue="value" htmlEscape="false" />
						</form:select>
					</div>
					<label for="deviceType" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateStrategy.deviceType" /><span style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:select path="deviceType" class="form-control select2" disabled="true"
							style="width: 100%;">
							<form:option value="" label="${formSelect}" /> 
							<form:options items="${fns:getDictList('tms_device_type')}"
								itemLabel="label" itemValue="value" htmlEscape="false" />
						</form:select>
					</div>
				</div>
				<!-- 设备编号、执行时间  -->
				<div class="form-group" style="margin-left: -80px;">
					<label for="deviceSn" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateStrategy.deviceSn" /><span style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:input type="text" htmlEscape="false" class="form-control" readonly="true"
							id="deviceSn" path="deviceSn" placeholder="${deviceSn}" />
					</div>
					<label for="operateDate" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateLog.updateDate" /></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:input type="text" htmlEscape="false" class="form-control" readonly="true"
							id="operateDate" path="operateDate" placeholder="${updateDate}" />
					</div>
				</div>
				
				<!-- 备注 -->
				<div class="form-group" style="margin-left: -80px;">
					<label class="col-sm-2 control-label"><spring:message
							code="tms.table.updateItems.remarks" /></label>
					<div class="col-sm-10" style="padding-left: 0px;">
						<textarea id="remarks" name="remarks" rows="3" maxlength="500" readonly="true"
							htmlEscape="false" class="form-control" id="remarks"
							path="remarks"
							placeholder="<spring:message code='tms.table.updateItems.remarks' />">${remarks}</textarea>
					</div>
				</div>
			</div>
		</div>
	</form:form>
</div>
<script>
	$(".select2").select2();
	$(function() {
		var logDetail = $("#logDetail-form").form();
		
		var beginDateStr = '${updateLog.beginDate}';
		var endDateStr = '${updateLog.endDate}';
		var operateDateStr = '${updateLog.operateDate}';
		var adBeginTime = new Date(beginDateStr); 
        var adEndTime = new Date(endDateStr); 
        var adOperateTime = new Date(operateDateStr); 
        if(beginDateStr == ''){
            $("#beginDate").val(formatDate(new Date().setMonth(new Date().getMonth()+1), "yyyy-MM-dd"));             
        }else {
            $("#beginDate").val(formatDate(adBeginTime, "yyyy-MM-dd"));              
        }
        if(endDateStr == ''){
            $("#endDate").val(formatDate(new Date().setMonth(new Date().getMonth()+1), "yyyy-MM-dd"));             
        }else {
            $("#endDate").val(formatDate(adEndTime, "yyyy-MM-dd"));              
        }
        if(operateDateStr == ''){
            $("#operateDate").val(formatDate(new Date().setMonth(new Date().getMonth()+1), "yyyy-MM-dd HH:mm:ss"));             
        }else {
            $("#operateDate").val(formatDate(adOperateTime, "yyyy-MM-dd HH:mm:ss"));              
        }
	});
</script>