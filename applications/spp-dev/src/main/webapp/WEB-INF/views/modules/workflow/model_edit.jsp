<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="workflow.model.name" var="modelName"/>
<spring:message code="workflow.model.key" var="modelKey"/>
<spring:message code="workflow.model.version" var="modelVersion"/>
<spring:message code="workflow.model.tenant.id" var="modelTenat"/>
<spring:message code="workflow.model.description" var="modelDescription"/>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
        <li class="fa fa-remove"></li>
    </button>
    <h5 class="modal-title"></h5>
</div>

<div class="modal-body">
    <form:form id="model-form" name="model-form" class="form-horizontal"
		modelAttribute="model">
        <form:hidden path="id" />
        <input type='hidden' value="${CSRFToken}" id='csrftoken'>
        <div class="box-body">
            <div class="col-md-12">
                <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="workflow.model.name" /><span style="color:red">&nbsp;*</span></label>
                    <div class="col-sm-8">
                        <form:input type="text" class="form-control" path="name" name="name" placeholder="${modelName}" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="workflow.model.key" /><span style="color:red">&nbsp;*</span></label>
                    <div class="col-sm-8">
                        <form:input type="text" class="form-control" path="key" name="key" placeholder="${modelKey }" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="workflow.model.module.name" /><span style="color:red">&nbsp;*</span></label>
                    <div class="col-sm-8">
                        <form:select path="category" class="form-control select2"
							style="width: 100%;">
							<form:options items="${fns:getModuleList()}" itemLabel="name"
								itemValue="code" htmlEscape="false" />
						</form:select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="workflow.model.version" /><span style="color:red">&nbsp;*</span></label>
                    <div class="col-sm-8">
                        <form:input type="text" class="form-control" path="version" name="version" placeholder="${modelVersion }" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="workflow.model.tenant.id" /></label>
                    <div class="col-sm-8">
                        <form:input type="text" class="form-control" path="tenantId" name="tenantId" placeholder="${modelTenat }" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="workflow.model.description" /></label>
                    <div class="col-sm-8">
                        <form:textarea path="description" class="form-control"
							htmlEscape="false" rows="3" maxlength="200"
                                  placeholder="${modelDescription }" />
                    </div>
                </div>
            </div>
        </div>
        <div class="box-footer text-right">
            <button type="button" class="btn btn-default" data-btn-type="cancel" data-dismiss="modal"><spring:message code='common.cancel' /></button>
            <shiro:hasPermission name="workflow:define:edit">
            <button type="submit" class="btn btn-primary" data-btn-type="save"><spring:message code='common.submit' /></button>
            </shiro:hasPermission>
        </div>
    </form:form>
</div>
<script>
    var form = null;
    var id="${empty model.id?0:model.id}";
    $(function () {
        //初始化表单
        form = $("#model-form").form({baseEntity: false});
        //数据校验
        $("#model-form").bootstrapValidator({
        	 message : '<spring:message code="common.promt.value"/>',
             feedbackIcons : {
                 valid : 'glyphicon glyphicon-ok',
                 invalid : 'glyphicon glyphicon-remove',
                 validating : 'glyphicon glyphicon-refresh'
             },
             fields : {
                 "name": {
                     validators: {
                         notEmpty: {message: '<spring:message code="workflow.model.name.notnull" />'}
                     }
                 },
                 "key": {
                     validators: {
                         notEmpty: {message: '<spring:message code="workflow.model.code.notnull" />'},
                     }
                 },
                 "version": {
                     validators: {
                         notEmpty: {message: '<spring:message code="workflow.model.version.notnull" />'},
                         integer: {message: '<spring:message code="workflow.please.promt.integer" />'}
                     }
                 },
                 "category": {
                     validators: {
                         notEmpty: {message: '<spring:message code="workflow.model.category.notnull" />'}
                     }
                 }
 			}
        }).on("success.form.bv",function(e){
   		        e.preventDefault();
				modals.confirm({
					cancel_label:'<spring:message code="common.cancel" />',
					title:'<spring:message code="common.sys.confirmTip" />',
					ok_label:'<spring:message code="common.confirm" />',
					text:'<spring:message code="common.confirm.save"/>',
					callback: function() {
					//Save Data，对应'submit-提交'
					var params = form.getFormSimpleData();
					console.log(params);
                    ajaxPost(basePath + '/workflow/model/save', params, function(data, status) {
                    	if(data.code == 200){
							if(id!="0"){//更新
								modals.correct(data.message);
								modals.hideWin(winId);
								modelTable.reloadRowData(id);
							}else{//新增 
								modals.correct(data.message);
								modals.hideWin(winId);
								modelTable.reloadData();
							}
						}else{
							modals.warn(data.message);
						}				 
					});
				}});
    	});
        //初始化表单
        form=$("#model-form").form();
    });
    
	function resetForm(){
		form.clearForm();
        $("#model-form").data('bootstrapValidator').resetForm();
	}

</script>