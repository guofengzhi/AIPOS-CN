<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="sys.area.area" var="sysArea"/>
<spring:message code="sys.area.name" var="areaName"/>
<spring:message code="sys.area.code" var="areaCode"/>
<spring:message code="sys.area.type" var="areaType"/>
<spring:message code="sys.area.remarks" var="areaRemarks"/>
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="sys.area.view.area.information"/></h5>
</div>

<div class="modal-body">
	<form:form id="area-form" name="area-form" modelAttribute="area"
		class="form-horizontal">
		<form:hidden path="id" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'>
		
		<div class="box-body">
			<div class="col-md-12">
				<div class="form-group">
					<label for="value" class="col-sm-2 control-label"><spring:message code="sys.area.superior.area"/></label>
					<div class="col-sm-9">
						<sys:treeselect id="area" name="parent.id" value="${area.parent.id}" labelName="parent.name" labelValue="${area.parent.name}"
					title="${sysArea }" url="/sys/area/treeData" extId="${area.id}" cssClass="form-control" allowClear="true"/>
					</div>
				</div>
				<div class="form-group">
					<label for="name" class="col-sm-2 control-label">${areaName }</label>
					<div class="col-sm-9">
					    <form:input path="name" htmlEscape="false" maxlength="50" class="form-control" placeholder="${areaName }"/>
					</div>
				</div>
				<div class="form-group">
					<label for="type" class="col-sm-2 control-label">${areaCode }</label>
					<div class="col-sm-9">
					    <form:input path="code" htmlEscape="false" class="form-control" placeholder="${areaCode }"  maxlength="50"/>
					</div>
				</div>

				<div class="form-group">
					<label for="type" class="col-sm-2 control-label">${areaType }</label>
					<div class="col-sm-9">
						<form:select path="type" class="form-control select2">
				      	<form:options items="${fns:getDictList('sys_area_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				       </form:select>
					</div>
				</div>
				<div class="form-group">
					<label for="remarks" class="col-sm-2 control-label">${areaRemarks }</label>
					<div class="col-sm-9">
						<form:textarea path="remarks" class="form-control"
							htmlEscape="false" rows="3" maxlength="200" placeholder="${areaRemarks }" />
					</div>
				</div>
			</div>
		</div>
		<!-- /.box-body -->
		<div class="box-footer text-right">
			<!--以下两种方式提交验证,根据所需选择-->
			<button type="button" class="btn btn-default" data-btn-type="cancel"
				data-dismiss="modal"><spring:message code="common.cancel"/></button>
			<shiro:hasPermission name="sys:area:edit">			
			 <button type="submit" class="btn btn-primary" data-btn-type="save"><spring:message code="common.submit"/></button>
			</shiro:hasPermission>
		</div>
		<!-- /.box-footer -->
	</form:form>

</div>
<script>
	//tableId,queryId,conditionContainer
	var areaform = null;
	
	var id = "${empty user.id?0:user.id}";
	$(".select2").css("width","100%").select2();
	$(function() {
		//初始化控件
		areaform = $("#area-form").form();
		//数据校验
		var action = '${area.action}';
		if(action == 'view'){
			areaform.formReadonly();
		}
				
		$("#area-form").bootstrapValidator(
						{
							message : '<spring:message code="sys.essay.effectiveValue"/>',
							feedbackIcons : {
								valid : 'glyphicon glyphicon-ok',
								invalid : 'glyphicon glyphicon-remove',
								validating : 'glyphicon glyphicon-refresh'
							},							
							fields : {
								name : {
									validators : {
										notEmpty : {
											message : '<spring:message code="sys.area.input.area.name"/>'
										}
									}
								},
								code : {
									validators : {
										notEmpty : {
											message : '<spring:message code="sys.area.input.area.code"/>'
										}
									}
								},
								type : {
									validators : {
										notEmpty : {
											message : '<spring:message code="sys.area.input.area.type"/>',
										}

									}
								}
							}
						}).on('success.form.bv', function(e) {
							 // 阻止默认事件提交
							 e.preventDefault();
							 modals.confirm(
										'<spring:message code="common.confirm.save"/>',
										function() {
											//Save Data，对应'submit-提交'
											var params = areaform
													.getFormSimpleData();
											ajaxPost(
													basePath
															+ '/sys/area/save',
													params,
													function(data,
															status) {
														if (data.success) {
															if (id != "0") {//更新
																modals.hideWin(winId);
															} else {//新增
																modals.hideWin(winId);
															}
															areaTable.reloadData();
														} else{
															modals.error(data.message);
														}
													});
										});
						});
	});

	function resetAreaForm() {
		areaform.clearForm();
		$("#area-form").data('bootstrapValidator').resetForm();
	}
</script>
