<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="workflow.module.name" var="moduleName"/>
<spring:message code="workflow.module.code" var="moduleCode"/>
<spring:message code="workflow.module.remarks" var="moduleRemarks"/>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"><li class="fa fa-remove"></li></button>
    <h5 class="modal-title"><spring:message code="workflow.add.module"/></h5>
</div>

<div class="modal-body">
   <form:form id="module-form" name="module-form" class="form-horizontal"
		modelAttribute="module">
		<form:hidden path="id" />
        <input type='hidden' value="${CSRFToken}" id='csrftoken'>
        <div class="box-body">
            <div class="col-md-12">
                <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="workflow.module.name" /><span style="color:red">*</span></label>
                    <div class="col-sm-8">
                        <form:input type="text" class="form-control" path="name" name="name" placeholder="${moduleName }" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="workflow.module.code" /><span style="color:red">*</span></label>
                    <div class="col-sm-8">
                        <form:input type="text" class="form-control" path="code" name="code" placeholder="${moduleCode} " />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="workflow.module.type" /></label>
                    <div class="col-sm-8">
                        <form:select path="delFlag" class="form-control select2"
							style="width: 100%;">
							<form:options items="${fns:getDictList('yes_no')}"
								itemLabel="label" itemValue="value" htmlEscape="false" />
						</form:select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="workflow.module.remarks" /></label>
                    <div class="col-sm-9">
						<form:textarea path="remark" class="form-control"
							htmlEscape="false" rows="3" maxlength="200" placeholder="${moduleRemarks }" />
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
    var id="${empty module.id?0:module.id}";
    $(function(){
        //数据校验
        $("#module-form").bootstrapValidator({
            message : '<spring:message code="common.promt.value"/>',
            feedbackIcons : {
                valid : 'glyphicon glyphicon-ok',
                invalid : 'glyphicon glyphicon-remove',
                validating : 'glyphicon glyphicon-refresh'
            },
            fields : {
            	"name":{
                    validators:{
                        notEmpty:{message:'<spring:message code="workflow.module.name.notnull" />'}
                    }
                },
                "code":{
                    validators:{
                        notEmpty:{message:'<spring:message code="workflow.module.code.notnull" />'}
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
					ajaxPost(basePath+'/workflow/module/save', params, function(data, status) {
						if(data.code == 200){
							if(id!="0"){//更新
								modals.correct(data.message);
								modals.hideWin(winId);
								moduleTable.reloadRowData(id);
							}else{//新增 
								 modals.correct(data.message);
								 modals.hideWin(winId);
								 moduleTable.reloadData();
							}
						}else{
							modals.warn(data.message);
						}				 
					});
				}});
    	});
        //初始化表单
        form=$("#module-form").form();
    });
    
	function resetForm(){
		form.clearForm();
        $("#module-form").data('bootstrapValidator').resetForm();
	}
</script>
