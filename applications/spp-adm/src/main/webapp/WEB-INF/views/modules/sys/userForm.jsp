<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="sys.user.name.form" var="nameForm" />
<spring:message code="common.form.select" var="formSelect" />
<spring:message code="sys.user.login.name" var="loginName" />
<spring:message code="sys.user.mobile" var="userMobile" />
<spring:message code="sys.user.mail" var="userMail" />
<spring:message code="sys.user.tel" var="userTel" />

<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title">
		<spring:message code="sys.user.add" />
	</h5>
</div>

<div class="modal-body">
	<form:form id="user-form" name="user-form" modelAttribute="user"
		class="form-horizontal">
		<form:hidden path="id" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'>
		<div class="box-body">
			<div class="col-md-6">
				<div class="form-group">
					<label for="office.id" class="col-sm-3 control-label"><spring:message
							code="sys.user.office" /></label>
					<div class="col-sm-8">
						<input id="userFormOrgSelect" style="width: 253.33px;"
							name="officeId" class="form-control" type="hidden"
							placeholder="${officeId}" />
						<form:input  id="userFormOrgSelectValue" path="officeName" class="form-control" htmlEscape="false"
							maxlength="100" placeholder="${officeName}" onclick="showOrgTree();"/>
					</div>
				</div>
				<div class="form-group">
					<label for="name" class="col-sm-3 control-label"><spring:message
							code="sys.user.name.form" /><span style="color: red">*</span></label>
					<div class="col-sm-8">
						<form:input type="text" htmlEscape="false" class="form-control"
							id="name" path="name" placeholder="${nameForm}" />
					</div>
				</div>

				<div class="form-group">
					<label for="loginFlag" class="col-sm-3 control-label"><spring:message
							code="sys.user.login.allow" /><span style="color: red">*</span></label>
					<div class="col-sm-8">
						<form:select path="loginFlag" class="form-control select2"
							style="width: 100%;">
							<form:options items="${fns:getDictList('yes_no')}"
								itemLabel="label" itemValue="value" htmlEscape="false" />
						</form:select>
					</div>
				</div>
				<div class="form-group">
					<label for="userType" class="col-sm-3 control-label"><spring:message
							code="sys.user.type" /><span style="color: red">*</span></label>
					<div class="col-sm-8">
						<form:select path="userType" class="form-control select2"
							style="width: 100%;">
							<form:option value="" label="${formSelect}" />
							<form:options items="${fns:getDictList('sys_user_type')}"
								itemLabel="label" itemValue="value" htmlEscape="false" />
						</form:select>
					</div>
				</div>
			</div>
			<div class="col-md-6">
				<div class="form-group">
					<label class="col-sm-3 control-label"><spring:message
							code="sys.user.mail" /><span style="color: red">*</span></label>

					<div class="col-sm-8">
						<form:input path="email" class="form-control" htmlEscape="false"
							maxlength="100" placeholder="${userMail }" />
					</div>
				</div>
				<div class="form-group">
					<label for="loginName" class="col-sm-3 control-label"><spring:message
							code="sys.user.login.name" /><span style="color: red">*</span></label>
					<div class="col-sm-8">
						<input id="oldLoginName" name="oldLoginName" type="hidden"
							value="${user.loginName}">
						<form:input type="text" htmlEscape="false" class="form-control"
							id="loginName" path="loginName" placeholder="${loginName}" />
					</div>
				</div>
				<div class="form-group">
					<label for="mobile" class="col-sm-3 control-label"><spring:message
							code="sys.user.mobile" /><span style="color: red">*</span></label>

					<div class="col-sm-8">
						<form:input type="text" htmlEscape="false" class="form-control"
							id="mobile" path="mobile" placeholder="${userMobile}" />
					</div>
				</div>
				<div class="form-group">
					<label for="phone" class="col-sm-3 control-label"><spring:message
							code="sys.user.tel" /></label>
					<div class="col-sm-8">
						<form:input path="phone" class="form-control" htmlEscape="false"
							maxlength="100" placeholder="${userTel}" />
					</div>
				</div>


				<!-- 
				<div class="form-group">
					<label for="remarks" class="col-sm-3 control-label">备注</label>
					<div class="col-sm-8">
						<form:textarea path="remarks" class="form-control"
							htmlEscape="false" rows="3" maxlength="200" />
					</div>
				</div>
				 -->
			</div>
			<div class="col-md-12">
				<div class="form-group">
					<label for="loginFlag" class="col-sm-2 control-label"
						style="width: 12.5%"><spring:message code="sys.user.role" /><span
						style="color: red">*</span></label>
					<div class="col-sm-10">
						<label class="control-label"> <form:checkboxes
								path="roleIdList" items="${allRoles}" cssClass="styled"
								element="div class='checkbox-inline checkbox checkbox-success'"
								itemLabel="name" itemValue="id" htmlEscape="false" />
						</label>
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
			<button type="submit" class="btn btn-primary" data-btn-type="save">
				<spring:message code="common.submit" />
			</button>
		</div>
		<!-- /.box-footer -->
	</form:form>

</div>
<script>
	//tableId,queryId,conditionContainer
	var winId = "userWin";
	var userform = null;
	var id = "${empty user.id?0:user.id}";
	$(".select2").select2();
	function showOrgTree() {
		modals
				.openWin({
					winId : "userFormOrgTree",
					title : '<spring:message code="modules.device.importing.equipment.by.product.batch"/>',
					width : '300px',
					url : basePath
							+ "/sys/office/toOfficeTree?windowId=userFormOrgTree&orgSelect=userFormOrgSelect&orgSelectValue=userFormOrgSelectValue"
				});
	}
	$(function() {
		//初始化控件
		userform = $("#user-form").form();
		//iCheck for checkbox and radio inputs
		//$('input[type="checkbox"].minimal').iCheck({
		// checkboxClass: 'icheckbox_minimal-blue'
		//});
		//数据校验
		$("#user-form")
				.bootstrapValidator(
						{
							message : '<spring:message code="common.promt.value"/>',
							feedbackIcons : {
								valid : 'glyphicon glyphicon-ok',
								invalid : 'glyphicon glyphicon-remove',
								validating : 'glyphicon glyphicon-refresh'
							},
							fields : {
								name : {
									validators : {
										notEmpty : {
											message : '<spring:message code="sys.user.promt.name"/>'
										}
									}
								},
								loginName : {
									validators : {
										notEmpty : {
											message : '<spring:message code="sys.user.promt.login.name"/>'
										},
										stringLength : {
											min : 6,
											max : 30,
											message : '<spring:message code="sys.user.promt.name.length"/>'
										},
										remote : {
											url : basePath
													+ "/sys/user/checkLoginName",
											delay : 2000,
											data : function(validator) {
												return {
													loginName : $('#loginName')
															.val(),
													oldLoginName : $(
															'#oldLoginName')
															.val(),
													id : $('#id').val()
												};
											},
											message : '<spring:message code="sys.user.promt.name.used"/>'
										}
									}
								},
								userType : {
									validators : {
										notEmpty : {
											message : '<spring:message code="user.type.required"/>'
										}
									}
								},
								mobile : {
									validators : {
										notEmpty : {
											message : '<spring:message code="sys.user.promt.mobile"/>'
										},
										stringLength : {
											min : 11,
											max : 11,
											message : '<spring:message code="sys.user.promt.mobile.length"/>'
										},
										regexp : {
											regexp : /^1[3|5|8|7]{1}[0-9]{9}$/,
											message : '<spring:message code="sys.user.promt.mobile.error"/>'
										}
									}
								},
								email : {
									validators : {
										notEmpty : {
											message : '<spring:message code="sys.user.promt.mail"/>',
										},
										emailAddress : {
											message : '<spring:message code="sys.user.promt.mail.error"/>',
										}

									}
								},
								'officeId' : {
									validators : {
										notEmpty : {
											message : '<spring:message code="sys.user.promt.office"/>'
										}
									}
								},
								'loginFlag' : {
									validators : {
										notEmpty : {
											message : '<spring:message code="sys.user.promt.login.allow"/>'
										}
									}
								},
								'roleIdList' : {
									validators : {
										notEmpty : {
											message : '<spring:message code="sys.user.promt.role"/>'
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
											'<spring:message code="common.confirm.save"/>',
											function() {
												//Save Data，对应'submit-提交'
												var params = userform
														.getFormSimpleData();
												ajaxPost(
														basePath
																+ '/sys/user/save',
														params,
														function(data, status) {
															if (data.code == 200) {
																debugger;
																if (id != "0") {//更新
																	modals
																			.hideWin(winId);
																	userTable
																			.reloadRowData(id);
																} else {//新增
																	modals
																			.hideWin(winId);
																	userTable
																			.reloadData();
																}
															} else {
																modals
																		.error(data.message);
															}
														});
											});
						});
	});

	function resetUserForm() {
		userform.clearForm();
		$("#user-form").data('bootstrapValidator').resetForm();
	}
</script>
