<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>

<spring:message code="ota.table.name" var="name"/>
<spring:message code="ota.table.phone" var="phone"/>
<spring:message code="ota.table.company" var="company"/>
<spring:message code="ota.table.company.address" var="companyaddress"/>

<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="app.developer.new.developer.information"/></h5>
</div>

<div class="modal-body">
	<form:form id="appDeveloper-form" name="appDeveloper-form" modelAttribute="appDeveloper"
		class="form-horizontal" >
		 <form:hidden path="id" value="${appDeveloper.id }" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'>
		 
		<div class="box-body">
			<div class="col-md-12">
			
				<div class="form-group">
					<label for="name" class="col-sm-2 control-label"><spring:message code="ota.table.name"/><span style="color:red">*</span></label>
					<div class="col-sm-9">
					    <form:input path="name" value="${appDeveloper.name }" htmlEscape="false" maxlength="50" class="form-control" placeholder='${name }'/>
					</div>
				</div>
				
				<div class="form-group">
					<label for="phone" class="col-sm-2 control-label"><spring:message code="ota.table.phone"/><span style="color:red">*</span></label>
					<div class="col-sm-9">
					    <form:input path="phone" value="${appDeveloper.phone }" htmlEscape="false" maxlength="50" class="form-control" placeholder="${phone }"/>
					</div>
				</div>
				
				<div class="form-group">
					<label for="company" class="col-sm-2 control-label"><spring:message code="ota.table.company"/><span style="color:red">*</span></label>
					<div class="col-sm-9">
					    <form:input path="company" value="${appDeveloper.company }" htmlEscape="false" maxlength="50" class="form-control" placeholder="${company }"/>
					</div>
				</div>
				
				<div class="form-group">
					<label for="address" class="col-sm-2 control-label"><spring:message code="ota.table.company.address"/><span style="color:red">*</span></label>
					<div class="col-sm-9">
					    <form:input path="address" value="${appDeveloper.address }" htmlEscape="false" maxlength="50" class="form-control" placeholder="${companyaddress }"/>
					</div>
				</div>
					
			</div>
		</div>
		<!-- /.box-body -->
		<div class="box-footer text-right">
			<!--以下两种方式提交验证,根据所需选择-->
			<button type="button" class="btn btn-default" data-btn-type="cancel"
				data-dismiss="modal"><spring:message code="common.cancel"/></button>
			 <button type="submit" class="btn btn-primary" data-btn-type="save"><spring:message code="common.submit"/></button>
		</div>
		
		<!-- /.box-footer -->
	</form:form>
	

</div>
<script>
//tableId,queryId,conditionContainer
var appDeveloperform = null;
var id="${empty device.id?0:device.id}";
$(".select2").select2();
$(function() {
	
	appDeveloperform=$("#appDeveloper-form").form();
	//数据校验
	$("#appDeveloper-form").bootstrapValidator({
		message : '<spring:message code="app.appinfo.please.enter.a.valid.value"/>',
		feedbackIcons : {
			valid : 'glyphicon glyphicon-ok',
			invalid : 'glyphicon glyphicon-remove',
			validating : 'glyphicon glyphicon-refresh'
		},
		fields : {
			name : {
				validators : {
					notEmpty : {
						message : '<spring:message code="app.developer.please.enter.the.developer.name"/>！'
					}
				}
			},
			phone : {
				validators : {
					notEmpty : {
						message : '<spring:message code="app.developer.please.enter.the.phone"/>！'
					}
				}
			},
			company : {
				validators : {
					notEmpty : {
						message : '<spring:message code="app.developer.please.enter.the.company"/>！'
					}
				}
			},
			address : {
				validators : {
					notEmpty : {
						message : '<spring:message code="app.developer.please.enter.the.company.address"/>！'
					}
				}
			}
		}
	}).on("success.form.bv",function(e){
		    e.preventDefault();
			modals.confirm('<spring:message code="common.confirm.save"/>', function() {
				//Save Data，对应'submit-提交'
				 var params = appDeveloperform.getFormSimpleData();
					 ajaxPost(basePath+'/appDeveloper/save', params, function(data, status) {
					if(data.code == 200){
						//新增 
						modals.correct(data.message);
						modals.hideWin(winId);	
						appDeveloperTable.reloadRowData();
					}else{
						modals.warn(data.message);
					}				 
				}); 
			});		    
	});
	//初始化控件
	
});


function resetappDeveloperForm(){
	appDeveloperform.clearForm();
	$("#appDeveloper-form").data('bootstrapValidator').resetForm();
}
</script>
