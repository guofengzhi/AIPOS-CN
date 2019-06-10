<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="ota.table.manufacturer.number" var="manufacturerNumber"/>
<spring:message code="ota.table.manufacturer.name" var="manufacturerName"/>
<spring:message code="ota.table.manufacturer.address" var="manufacturerAddress"/>

<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="modules.manufacturer.add.manufacturer.information"/></h5>
</div>

<div class="modal-body">
	<form:form id="manuFacturer-form" name="manuFacturer-form" modelAttribute="manuFacturer"
		class="form-horizontal" >
		 <form:hidden path="id" value="${manuFacturer.id }" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'>
		 
		<div class="box-body">
			<div class="col-md-12">
			
				<div class="form-group">
					<label for="manufacturerNo" class="col-sm-2 control-label"><spring:message code="ota.table.manufacturer.number"/><span style="color:red">*</span></label>
					<div class="col-sm-9">
					    <form:input path="manufacturerNo" value="${manuFacturer.manufacturerNo }" htmlEscape="false" maxlength="20" class="form-control" placeholder="${manufacturerNumber }"/>
					</div>
				</div>
				
				<div class="form-group">
					<label for="manufacturerName" class="col-sm-2 control-label"><spring:message code="ota.table.manufacturer.name"/><span style="color:red">*</span></label>
					<div class="col-sm-9">
					    <form:input path="manufacturerName" value="${manuFacturer.manufacturerName }" htmlEscape="false" maxlength="50"  class="form-control" placeholder="${manufacturerName }"/>
					</div>
				</div>
				
			
				<div class="form-group">
					<label for="manufacturerAddr" class="col-sm-2 control-label"><spring:message code="ota.table.manufacturer.address"/><span style="color:red">*</span></label>
					<div class="col-sm-9">
					    <form:input path="manufacturerAddr" value="${manuFacturer.manufacturerAddr }" htmlEscape="false" maxlength="50"  class="form-control" placeholder="${manufacturerAddress }"/>
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
var manuFacturerform = null;
var id="${empty device.id?0:device.id}";
$(".select2").select2();
$(function() {
	
	manuFacturerform=$("#manuFacturer-form").form();
	//数据校验
	$("#manuFacturer-form").bootstrapValidator({
		message : '<spring:message code="app.appinfo.please.enter.a.valid.value"/>',
		feedbackIcons : {
			valid : 'glyphicon glyphicon-ok',
			invalid : 'glyphicon glyphicon-remove',
			validating : 'glyphicon glyphicon-refresh'
		},
		fields : {
			manufacturerNo : {
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.manufacturer.please.enter.the.manufacturer.number"/>'
					},
					remote : {
						url : basePath
								+ "/manuFacturer/checkManufacturerNo",
						delay : 2000,
						message : '<spring:message code="manuFacturerNo.exist"/>'
					}
				}
			},
			manufacturerName : {
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.manufacturer.please.enter.the.manufacturer.name"/>'
					}
				}
			},
			manufacturerAddr : {
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.manufacturer.please.enter.the.manufacturer.address"/>'
					}
				}
			}
		}
	}).on("success.form.bv",function(e){
		    e.preventDefault();
			modals.confirm('<spring:message code="common.confirm.save"/>', function() {
				//Save Data，对应'submit-提交'
				 var params = manuFacturerform.getFormSimpleData();
					 ajaxPost(basePath+'/manuFacturer/save', params, function(data, status) {
					if(data.code == 200){
						//新增 
						modals.correct(data.message);
						modals.hideWin(winId);	
						manuFacturerTable.reloadRowData();
					}else{
						modals.warn(data.message);
					}				 
				}); 
			});		    
	});
	//初始化控件
	
});


function resetmanuFacturerForm(){
	manuFacturerform.clearForm();
	$("#manuFacturer-form").data('bootstrapValidator').resetForm();
}
</script>
