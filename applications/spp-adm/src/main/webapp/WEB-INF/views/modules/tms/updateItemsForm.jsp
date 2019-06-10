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

<div class="modal-body">
	<form:form id="updateItems-form" name="updateItems-form"
		modelAttribute="updateItems" class="form-horizontal">
		<form:hidden path="id" value="${updateItems.id}" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'> 

		<div class="box-body">
			<div class="col-md-12">
			
				<div class="form-group" style="margin-left: -80px;">
					<label for="manufactureNo" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateItems.manufactureNo" /><span style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:select path="manufactureNo" class="form-control select2"
							style="width: 100%;">
							<form:option value="" label="${formSelect}" /> 
							<form:options items="${manufacturerList}"
								itemLabel="manufacturerName" itemValue="manufacturerName" htmlEscape="false" />
						</form:select>
					</div>
					
					<label for="fileType" class="col-sm-2 control-label"><spring:message
							code="tms.file.type" /><span style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:select path="fileType" class="form-control select2"
							style="width: 100%;">
							<form:option value="" label="${formSelect}" /> 
							<form:options items="${fns:getDictList('tms_file_type')}"
								itemLabel="label" itemValue="value" htmlEscape="false" />
						</form:select>
					</div>
				</div>
				
				<!-- 文件版本、备注 -->
				<div class="form-group" style="margin-left: -80px;">
					<label for="fileVerion" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateItems.fileVersion" /><span
						style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:input type="text" htmlEscape="false" class="form-control" autocomplete="off"
							id="fileVersion" path="fileVersion" placeholder="${fileVersion}" />
					</div>
					<label for="remarks" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateItems.remarks" /></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<textarea id="remarks" name="remarks" rows="4" maxlength="500"
							htmlEscape="false" class="form-control" id="remarks"
							path="remarks"
							placeholder="<spring:message code='tms.table.updateItems.remarks' />">${updateItems.remarks}</textarea>
					</div>
				</div>
				
				<!-- </div> -->
				 <div class="form-group" style="margin-left: -80px;">
					<label class="col-sm-2 control-label"><spring:message
							code="tms.table.updateItems" /><span style="color: red">*</span></label> 
					<div class="col-sm-4" id="file_container">
						<input type="hidden" name="updateItemsId" id="updateItemsId" value="${updateItems.id }">
					    <input type="file" name="file" id="file" placeholder="<spring:message code='tms.table.updateItems' />"/>
					</div> 
					
					
				</div>
			</div>
		</div>
		<!-- /.box-body -->
		<div class="box-footer text-right">
			<!--以下两种方式提交验证,根据所需选择-->
			<button type="button" class="btn btn-default" data-btn-type="cancel"
				data-dismiss="modal">
				<spring:message code="common.cancel" />
			</button>
			<button type="submit" id="submit" class="btn btn-primary"
				data-btn-type="save">
				<spring:message code="common.submit" />
			</button>
		</div>

		<!-- /.box-footer -->
	</form:form>
</div>
<script>
	//tableId,queryId,conditionContainer
	/* var appInfoform = null; */
	var updateItemsInfoForm = null;
	$(".select2").select2();
	$(function() {
	    $('#file').file({
	    	            fileinput: {
	    	            	uploadUrl:"",
	    	            	overwriteInitial: true,
	    	            	showClose: true,
	    	                showCaption: false,
	    	                browseLabel: this.placeholder,
	    	                removeLabel: '<spring:message code="app.information.delete.file" />',
	    	                removeClass: 'btn btn-danger',
	    	                otherActionButtons:"",
	    	                browseIcon: '<i class="glyphicon glyphicon-folder-open"></i>',
	    	                maxFileSize: 51200,
	    	                maxFileCount:1,
	    	                autoReplace: true,
	    	                layoutTemplates: {main2: '{preview}  {browse} {remove}'}
	    	            },
	    	            fileIdContainer:"[name='updateItemsId']",
	    	            window:false,
	    	            showUrl:basePath+"/tms/updateItems/getFiles/${updateItems.id}"
	    	        });
	     
		var updateItems = $("#updateItems-form").form();
		$("#updateItems-form")
				.bootstrapValidator(
						{
							message : '<spring:message code="app.appinfo.please.enter.a.valid.value" />',
							feedbackIcons : {
								valid : 'glyphicon glyphicon-ok',
								invalid : 'glyphicon glyphicon-remove',
								validating : 'glyphicon glyphicon-refresh'
							},
							fields : {
								manufactureNo : {
									validators : {
										notEmpty : {
											message : '<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>！'
										}
									}
								},
								fileType : {
									validators : {
										notEmpty : {
											message : '<spring:message code="please.select.updateItems.type"/>!'
										}
									}
								},
								fileVersion : {
									validators : {
										notEmpty : {
											message : '<spring:message code="please.input.updateItems.version"/>!'
										}
									}
								},
								file : {
									validators : {
										notEmpty : {
											message : '<font color="red">'+'<spring:message code="please.select.updateItems" />'+'</font>'
										}
									}
								}
							}
						})
				.on(
						'success.form.bv',
						function(e) {
							// 阻止默认事件提交
							e.preventDefault();

							modals
									.confirm(
											'<spring:message code="app.appinfo.are.you.sure.you.want.to.save.this.information"/>?',
											function() {
												var params = new FormData(
														$("#updateItems-form")[0])
												ajaxPostFileForm(
														basePath
																+ '/tms/updateItems/save',
														params,
														function(data, status) {
															if (data.code == 200) {
																//新增 
																modals
																		.correct(data.message);
																modals
																		.hideWin(winId);
																$('input').val("");
																updateItemsTable
																		.reloadRowData();
															} else {
																modals
																		.info(data.message);
																$("#submit")
																		.removeAttr(
																				'disabled');
															}
														});
											});

						})

	});
	function resetUpdateItemsForm() {
		updateItemsInfoForm.clearForm();
		$("#updateItems-form").data('bootstrapValidator').resetForm();
	}
</script>