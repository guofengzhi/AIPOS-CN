<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<spring:message code="modules.client.customer.number" var="customerNumber" />
<spring:message code="modules.client.customer.name" var="customerName" />

<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="modules.client.add.client"/></h5>
</div>

<div class="modal-body">
	<form:form id="client-form" name="client-form" modelAttribute="client"
		class="form-horizontal">
		 <form:hidden path="id" value="${client.id }" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'>
		 
		<div class="box-body">
			<div class="col-md-12">
				<div class="form-group">
					<label for="clientNo" class="col-sm-2 control-label">${customerNumber }<span style="color:red">*</span></label>
					<div class="col-sm-9">
					    <form:input path="clientNo" value="${client.clientNo }" htmlEscape="false" maxlength="50" class="form-control" placeholder="${customerNumber }"/>
					</div>
				</div>
				
				<div class="form-group">
					<label for="clientName" class="col-sm-2 control-label">${customerName }<span style="color:red">*</span></label>
					<div class="col-sm-9">
					    <form:input path="clientName" value="${client.clientName }" htmlEscape="false" maxlength="50"  class="form-control" placeholder="${customerName }"/>
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
var clientform = null;
var id="${empty device.id?0:device.id}";
$(".select2").select2();
$(function() {
	
	clientform=$("#client-form").form();
	//数据校验
	$("#client-form").bootstrapValidator({
		message : '<spring:message code="common.promt.value"/>',
		feedbackIcons : {
			valid : 'glyphicon glyphicon-ok',
			invalid : 'glyphicon glyphicon-remove',
			validating : 'glyphicon glyphicon-refresh'
		},
		fields : {
			clientNo : {
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.client.please.enter.the.customer.number"/>'
					}
				}
			},
			clientName : {
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.client.please.enter.the.customer.name"/>'
					}
				}
			}
		}
	}).on("success.form.bv",function(e){
		    e.preventDefault();
		    
			modals.confirm('<spring:message code="common.confirm.save"/>', function() {
				//Save Data，对应'submit-提交'
				 var params = clientform.getFormSimpleData();
					 ajaxPost(basePath+'/client/save', params, function(data, status) {
					
					if(data.code == 200){
						//新增 
						modals.correct(data.message);
						modals.hideWin(winId);	
						clientTable.reloadRowData();
					}else{
						modals.warn(data);
					}				 
				}); 
			});		    
	});
	//初始化控件
	
});


function resetclientForm(){
	clientform.clearForm();
	$("#client-form").data('bootstrapValidator').resetForm();
}
</script>
