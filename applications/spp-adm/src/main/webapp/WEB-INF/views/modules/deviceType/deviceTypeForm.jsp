<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>

<spring:message code="app.apprecord.please.select.the.equipment.manufacturer" var="selectManufacturer"/>
<spring:message code="ota.table.device.type" var="selectDeviceType"/>

<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="modules.device.type.add.type.of.device"/></h5>
</div>


<div class="modal-body">
	<form:form id="deviceType-form" name="deviceType-form" modelAttribute="deviceType"
		class="form-horizontal" >
		 <form:hidden path="id" value="${deviceType.id }" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'>
		 
		<div class="box-body">
			<div class="col-md-12">
			
				<div class="form-group">
					<label for="manufacturerNo" class="col-sm-2 control-label"><spring:message code="app.release.manufacturer"/><span style="color:red">*</label>
					<div class="col-sm-9">
						<form:select path="manufacturerNo" id="manufacturerNo" data-placeholder="${selectManufacturer }" class="form-control select2" style="width: 100%;">
							  <form:option value=""></form:option>
							  <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
						      		<form:option value="${manuFacturer.manufacturerNo }">${manuFacturer.manufacturerName }</form:option>
						      </c:forEach> 
						</form:select>
					</div>
				</div>
			
				
				<div class="form-group">
					<label for="deviceType" class="col-sm-2 control-label">${selectDeviceType }<span style="color:red">*</span></label>
					<div class="col-sm-9">
					    <form:input path="deviceType" value="${deviceType.deviceType }" htmlEscape="false" maxlength="50"  class="form-control" placeholder="${selectDeviceType }"/>
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
var deviceTypeform = null;
var id="${empty device.id?0:device.id}";
$(".select2").select2();
$(function() {
	
	var manufacturerNo = '${deviceType.manufacturerNo}';
	if(manufacturerNo != null){
		$("#manufacturerNo").val(manufacturerNo);
	}
	
	deviceTypeform=$("#deviceType-form").form();
	//数据校验
	$("#deviceType-form").bootstrapValidator({
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
						message : '<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>'
					}
				}
			},
			deviceType : {
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.device.please.enter.the.name.of.the.device.type"/>'
					}
				}
			}
		}
	}).on("success.form.bv",function(e){
		    e.preventDefault();
		    
			modals.confirm('<spring:message code="common.confirm.save"/>', function() {
				//Save Data，对应'submit-提交'
				 var params = deviceTypeform.getFormSimpleData();
					 ajaxPost(basePath+'/deviceType/save', params, function(data, status) {
					
					if(data.code == 200){
						//新增 
						modals.correct(data.message);
						modals.hideWin(winId);	
						deviceTypeTable.reloadRowData();
					}else{
						modals.warn(data.message);
					}				 
				}); 
			});		    
	});
	//初始化控件
	
});


function resetdeviceTypeForm(){
	deviceTypeform.clearForm();
	$("#deviceType-form").data('bootstrapValidator').resetForm();
}
</script>
