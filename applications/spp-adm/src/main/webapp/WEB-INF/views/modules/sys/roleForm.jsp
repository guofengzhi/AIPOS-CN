<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="sys.role.name" var="name"/>
<spring:message code="sys.role.enname" var="enname"/>
<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="sys.role.addRole" /></h5>
</div>

<div class="modal-body">

	<form:form id="role-form" name="role-form" class="form-horizontal"
		modelAttribute="role">
		<form:hidden path="id" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'>
		<div class="box-body">
			<div class="col-md-12">
				<div class="form-group">
					<label for="officeId" class="col-sm-2 control-label"><spring:message code="sys.role.organBelong" /></label>
					<div class="col-sm-9">
						<form:select path="officeId" class="form-control select2"
							style="width: 100%;">
							<form:options items="${fns:getOfficeList()}" itemLabel="name"
								itemValue="id" htmlEscape="false" />
						</form:select>
					</div>
				</div>
				<div class="form-group">
					<label for="name" class="col-sm-2 control-label"><spring:message code="sys.role.name" /><span style="color:red">*</span></label>
					<div class="col-sm-9">
						<input id="oldName" name="oldName" type="hidden"
							value="${role.name}" />
						<form:input path="name" class="form-control" placeholder="${name }" />
					</div>
				</div>
				<div class="form-group">
					<label for="enname" class="col-sm-2 control-label"><spring:message code="sys.role.enname" /><span style="color:red">*</span></label>
					<div class="col-sm-9">
						<input id="oldEnname" name="oldEnname" type="hidden"
							value="${role.enname}" />
						<form:input path="enname" class="form-control" htmlEscape="false"
							placeholder="${enname }" />
					</div>
				</div>

				<div class="form-group">
					<label for="roleType" class="col-sm-2 control-label"><spring:message code="sys.role.type" /><span style="color:red">*</span></label>
					<div class="col-sm-9">
						<form:select path="roleType" class="form-control select2">
							<form:option value="security-role"><spring:message code="sys.role.manageRole" /></form:option>
							<form:option value="user"><spring:message code="sys.role.normalRole" /></form:option>
						</form:select>
					</div>
				</div>
				<div class="form-group">
					<label for="sysData" class="col-sm-2 control-label"><spring:message code="sys.role.dataOfSys" /></label>
					<div class="col-sm-9">
						<form:select path="sysData" class="form-control select2"
							style="width: 100%;">
							<form:options items="${fns:getDictList('yes_no')}"
								itemLabel="label" itemValue="value" htmlEscape="false" />
						</form:select>
						<span class="help-inline"><spring:message code="sys.role.tip.dataOfSys" /></span>
					</div>
				</div>
				<div class="form-group">
					<label for="useable" class="col-sm-2 control-label"><spring:message code="sys.role.useState" /><span style="color:red">*</span></label>
					<div class="col-sm-9">
						<form:select path="useable" class="form-control select2"
							style="width: 100%;">
							<form:options items="${fns:getDictList('yes_no')}"
								itemLabel="label" itemValue="value" htmlEscape="false" />
						</form:select>
						<span class="help-inline"><spring:message code="sys.role.tip.useState" /></span>
					</div>
				</div>
				<div class="form-group">
					<label for="dataScope" class="col-sm-2 control-label"><spring:message code="sys.role.dataScope" /><span style="color:red">*</span></label>
					<div class="col-sm-9">
						<form:select path="dataScope" class="form-control select2"
							style="width: 100%;">
							<form:options items="${fns:getDictList('sys_data_scope')}"
								itemLabel="label" itemValue="value" htmlEscape="false" />
						</form:select>
						<span class="help-inline"><spring:message code="sys.role.tip.dataScope" /></span>
					</div>
				</div>
				<div class="form-group">
					<label for="remarks" class="col-sm-2 control-label"><spring:message code="common.instructions" /></label>
					<div class="col-sm-9">
						<form:textarea path="remarks" class="form-control"
							htmlEscape="false" rows="3" maxlength="200" />
					</div>
				</div>
			</div>
		</div>
		<!-- /.box-body -->
		<div class="box-footer text-right">
			<button type="button" class="btn btn-default" data-btn-type="cancel"
				data-dismiss="modal"><spring:message code="common.cancel" /></button>
			<c:if
				test="${(role.sysData eq fns:getDictValue('是', 'yes_no', '1') && fns:getUser().admin)||!(role.sysData eq fns:getDictValue('是', 'yes_no', '1'))}">
				<shiro:hasPermission name="sys:role:edit">
					<button type="submit" class="btn btn-primary" data-btn-type="save"><spring:message code="common.submit" /></button>&nbsp;</shiro:hasPermission>
			</c:if>

		</div>
		<!-- /.box-footer -->
	</form:form>

</div>
<script>
	//tableId,queryId,conditionContainer
	var roleform = null;
	var id="${empty role.id?0:role.id}";
	$(".select2").select2();
	$(function() {
		roleform=$("#role-form").form();
		//数据校验
		$("#role-form").bootstrapValidator({
			message : '<spring:message code="common.promt.value" />',
			feedbackIcons : {
				valid : 'glyphicon glyphicon-ok',
				invalid : 'glyphicon glyphicon-remove',
				validating : 'glyphicon glyphicon-refresh'
			},
			fields : {
				name : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.role.tip.inputName" />'
						}
					}
				}
			},
			fields : {
				enname : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.role.tip.inputEnname" />'
						}
					}
				}
			}
		}).on("success.form.bv",function(e){
			    e.preventDefault();
				modals.confirm('<spring:message code="common.confirm.save" />', function() {
					//Save Data，对应'submit-提交'
					var params = roleform.getFormSimpleData();
					ajaxPost(basePath+'/sys/role/save', params, function(data, status) {
						if(data.code == 200){
							if(id!="0"){//更新
								modals.correct({
										title:'<spring:message code="common.sys.success" />', 
		                                cancel_label:'<spring:message code="common.cancel" />',
		                                text:data.message});
								roleTable.reloadRowData();
								modals.hideWin(winId);
							}else{//新增 
								 modals.correct({
		                                title:'<spring:message code="common.sys.success" />', 
		                                cancel_label:'<spring:message code="common.cancel" />',
		                                text:data.message});
								 roleTable.reloadRowData();
								 modals.hideWin(winId);
							}
						}else{
							modals.warn({
                                title:'<spring:message code="common.sys.success" />', 
                                cancel_label:'<spring:message code="common.cancel" />',
                                text:data.message});
						}				 
					});
				});
		});
		//初始化控件
		
	});
	
	function resetRoleForm(){
		roleform.clearForm();
		$("#role-form").data('bootstrapValidator').resetForm();
	}
</script>
