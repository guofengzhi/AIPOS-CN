<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="sys.modifyPW" /></h5>
</div>

<div class="modal-body">
	<form:form id="sys-form" name="sys-form" class="form-horizontal"
		modelAttribute="dict">
		<input type='hidden' value='${CSRFToken}' id='csrftoken'>
		<div class="box-body">
			<div class="col-md-12">
				<div class="form-group">
					<label for="password" class="col-sm-2 control-label"><spring:message code="sys.modifyPW.oldPW" /></label>

					<div class="col-sm-9">
					    <div class="input-group">
						  <input class="form-control" id="password" name="password"
							type="password" placeholder='<spring:message code="sys.modifyPW.oldPW" />' />
							<div class="input-group-addon">
                            <i><font color="red">*</font></i>
                             </div>
                          </div>
					</div>
				</div>
				<div class="form-group">
					<label for="newPassword" class="col-sm-2 control-label"><spring:message code="sys.modifyPW.newPW" /></label>

					<div class="col-sm-9">
					    <div class="input-group">
						<input class="form-control" id="newPassword" name="newPassword"
							type="password" placeholder='<spring:message code="sys.modifyPW.newPW" />' />
							<div class="input-group-addon">
                            <i><font color="red">*</font></i>
                             </div>
                             </div>
					</div>
				</div>
				<div class="form-group">
					<label for="confirmNewPassword" class="col-sm-2 control-label"><spring:message code="sys.modifyPW.confirmPW" /></label>
					<div class="col-sm-9">
					   <div class="input-group">
						<input id="confirmNewPassword" class="form-control"
							name="confirmNewPassword" type="password" placeholder='<spring:message code="sys.modifyPW.confirmPW" />' />
						   <div class="input-group-addon">
                            <i><font color="red">*</font></i>
                            </div>
                         </div>
					</div>
				</div>

			</div>
		</div>
		<!-- /.box-body -->
		<div class="box-footer text-right">
			<button type="button" class="btn btn-default" data-btn-type="cancel"
				data-dismiss="modal"><spring:message code="common.cancel" /></button>
			<button type="submit" class="btn btn-primary" data-btn-type="save"><spring:message code="common.submit" /></button>&nbsp;

		</div>
		<!-- /.box-footer -->
	</form:form>

</div>
<script>
	//tableId,queryId,conditionContainer
	var form = null;
	$(function() {
		//数据校验
		$("#sys-form").bootstrapValidator({
			message : '<spring:message code="common.promt.value" />',
			feedbackIcons : {
				valid : 'glyphicon glyphicon-ok',
				invalid : 'glyphicon glyphicon-remove',
				validating : 'glyphicon glyphicon-refresh'
			},
			fields : {
				password : {
					validators: {
	                    notEmpty: {
	                        message: '<spring:message code="sys.modifyPW.tip.PWNull" />'
	                    },
	                    stringLength: {
	                        min: 6,
	                        max: 30,
	                        message: '<spring:message code="sys.modifyPW.tip.PWLength" />'
	                    }
	                }
				},
				newPassword : {
					validators: {
	                    notEmpty: {
	                        message: '<spring:message code="sys.modifyPW.tip.newPWNull" />'
	                    },
	                    stringLength: {
	                        min: 6,
	                        max: 30,
	                        message: '<spring:message code="sys.modifyPW.tip.newPWLength" />'
	                    },
	                    identical: {
	                        field: 'confirmPassword',
	                        message: '<spring:message code="sys.modifyPW.tip.confirmPWDiffer" />'
	                    }
	                }
				},
				confirmNewPassword : {
				validators: {
                    notEmpty: {
                        message: '<spring:message code="sys.modifyPW.tip.confirPWNull" />'
                    },
                    stringLength: {
                        min: 6,
                        max: 30,
                        message: '<spring:message code="sys.modifyPW.tip.confirmPWLength" />'
                    },
                    identical: {
                        field: 'confirmPassword',
                        message: '<spring:message code="sys.modifyPW.tip.newPWDiffer" />'
                }
			}
			}
			}
		}).on("success.form.bv",function(e){
			    e.preventDefault();
				modals.confirm('<spring:message code="common.confirm.save" />', function() {
					//Save Data，对应'submit-提交'
					var params = form.getFormSimpleData();
					ajaxPost(basePath+'/customer/user/modifyPwd', params, function(data, status) {
						if(data.code == 200){
							modals.correct(data.message);
						    modals.hideWin(winId);
						}else{
							modals.error(data.message);
						}				 
					});
				});
		});
		//初始化控件
		form=$("#sys-form").form();
	});
	
	
	function resetForm(){
		form.clearForm();
        $("#sys-form").data('bootstrapValidator').resetForm();
	}
</script>
