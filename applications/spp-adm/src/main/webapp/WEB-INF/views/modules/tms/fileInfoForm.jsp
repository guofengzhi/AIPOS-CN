<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="common.form.select" var="formSelect" />
<spring:message code="tms.table.updateItems.manufactureNo" var="manufactureNo" />
<spring:message code="tms.table.updateItems.fileType" var="fileType" />
<spring:message code="tms.table.updateItems.fileVersion" var="fileVersion" />
<spring:message code="tms.table.updateItems.fileName" var="fileName" />
<spring:message code="tms.table.updateItems.fileSize" var="fileSize" />
<spring:message code="tms.table.updateItems.uploadTime" var="uploadTime" />
<spring:message code="tms.table.updateItems.md5" var="md5" />
<spring:message code="please.input.updateItems.version" var="pleaseInputFileVersion" />

<!-- Content Header (Page header) -->
<div class="modal-header modalsbg" id="titleDiv">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title">更新物信息编辑</h5>
</div>

<div class="modal-body">
	<form:form id="updateItems-form" name="updateItems-form"
		modelAttribute="updateItems" class="form-horizontal">
		<form:hidden path="id" value="${updateItems.id}" />
		<form:hidden path="filePath" value="${updateItems.filePath}" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'> 
		<div class="box-body">
			<div class="col-md-12">
				<div class="form-group" style="margin-left: -80px;">
					<!-- 厂商 -->
					<label for="manufactureNo" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateItems.manufactureNo" /><span style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:input type="text" htmlEscape="false" class="form-control" autocomplete="off" 
							id="manufactureNo2" path="manufactureNo" placeholder="${manufactureNo}" readonly="true"/>
					</div>
					<!-- 文件类型 -->
					<label for="fileType" class="col-sm-2 control-label"><spring:message
							code="tms.file.type" /><span style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:select id="fileType2" path="fileType" class="form-control select2"
							style="width: 100%;" disabled="true">
							<form:option value="" label="${formSelect}" /> 
							<form:options items="${fns:getDictList('tms_file_type')}"
								itemLabel="label" itemValue="value" htmlEscape="false" />
						</form:select>
					</div>
				</div>
				<div class="form-group" style="margin-left: -80px;">
					<!-- 文件版本 -->
					<label for="fileVerion" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateItems.fileVersion" /><span
						style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:input type="text" htmlEscape="false" class="form-control" autocomplete="off" 
							id="fileVersion2" path="fileVersion" placeholder="${fileVersion}" readonly="true"/>
					</div>
					<!-- 文件名称 -->
					<label for="fileName" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateItems.fileName" /><span
						style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:input type="text" htmlEscape="false" class="form-control" autocomplete="off"
							id="fileName2" path="fileName" placeholder="${fileName}"  readonly="true"/>
					</div>
				</div>
				<div class="form-group" style="margin-left: -80px;">
					<!-- 文件大小 -->
					<label for="fileSize" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateItems.fileSize" /><span
						style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:input type="text" htmlEscape="false" class="form-control" autocomplete="off"
							id="fileSize2" path="fileSize" placeholder="${fileSize}"  readonly="true"/>
					</div>
					<!-- MD5-->
					<label for="md5" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateItems.md5" /><span
						style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:input type="text" htmlEscape="false" class="form-control" autocomplete="off"
							id="md5" path="md5" placeholder="${md5}"  readonly="true"/>
					</div>
				</div>
				<div class="form-group" style="margin-left: -80px;">
					<!-- 备注 -->
					<label for="remarks" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateItems.remarks" /></label>
					<div class="col-sm-10" style="padding-left: 0px;">
						<textarea id="remarks" name="remarks" rows="4" maxlength="500"
							htmlEscape="false" class="form-control" id="remarks"
							path="remarks"
							placeholder="<spring:message code='tms.table.updateItems.remarks' />">${updateItems.remarks}</textarea>
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
	</form:form>
</div>

<script>
	var updateItemsInfoForm = null;
	$(".select2").select2();
	$(function() {
		var updateItems = $("#updateItems-form").form();
		$("#updateItems-form").bootstrapValidator(
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
						fileSize : {
							validators : {
								notEmpty : {
									message : '<spring:message code="please.input.updateItems.fileSize"/>!'
								}
							}
						},
						md5 : {
							validators : {
								notEmpty : {
									message : '<spring:message code="please.input.updateItems.md5"/>!'
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
				}).on('success.form.bv',function(e) {
					e.preventDefault();
					modals.confirm('<spring:message code="app.appinfo.are.you.sure.you.want.to.save.this.information"/>?', function() {
						$('#fileType2').attr("disabled", false);
						var params = new FormData($("#updateItems-form")[0])
						ajaxPostFileForm(basePath + '/tms/updateFiles/save', params, function(data, status) {
							if (data.code == 200) {
								modals.correct(data.message);
								modals.hideWin(winId);
								$('input').val("");
								updateItemsTable.reloadRowData();
							} else {
								modals.info(data.message);
								$("#submit").removeAttr('disabled');
							}
							$('#fileType2').attr("disabled", true);
						});
					});
				})
	});
	function resetUpdateItemsForm() {
		updateItemsInfoForm.clearForm();
		$("#updateItems-form").data('bootstrapValidator').resetForm();
	}
	
	var itemsId = '${updateItems.id}';

	if (itemsId == null || itemsId == '') {
		$("#titleDiv").remove();
	}
</script> 
