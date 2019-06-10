<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>

<spring:message code="sys.dict.value" var="dictValue"/>
<spring:message code="sys.dict.label" var="dictLabel"/>
<spring:message code="sys.dict.type" var="dictType"/>
<spring:message code="sys.dict.demonstration" var="dictDemostration"/>

<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="sys.dict.add"/></h5>
</div>

<div class="modal-body">
	<form:form id="dict-form" name="dict-form" class="form-horizontal"
		modelAttribute="dict">
		<form:hidden path="id" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'>
		<div class="box-body">
			<div class="col-md-12">
				<div class="form-group">
					<label for="value" class="col-sm-2 control-label"><spring:message code="sys.dict.value"/><span style="color:red">*</span></label>
					<div class="col-sm-9">
						<form:input path="value" htmlEscape="false" maxlength="50"
							class="form-control" placeholder="${dictValue }" />
					</div>
				</div>
				<div class="form-group">
					<label for="label" class="col-sm-2 control-label"><spring:message code="sys.dict.label"/><span style="color:red">*</span></label>
					<div class="col-sm-9">
						<form:input path="label" class="form-control" placeholder="${dictLabel }" />
					</div>
				</div>
				<div class="form-group">
					<label for="type" class="col-sm-2 control-label"><spring:message code="sys.dict.type"/></label>
					<div class="col-sm-9">
						<form:input path="type" class="form-control" htmlEscape="false"
							placeholder="${dictType }" />
					</div>
				</div>

				<div class="form-group">
					<label for="description" class="col-sm-2 control-label"><spring:message code="sys.dict.description"/></label>
					<div class="col-sm-9">
						<form:input path="description" htmlEscape="false" maxlength="50"
							class="form-control" />
					</div>
				</div>
				<div class="form-group">
					<label for="sort" class="col-sm-2 control-label"><spring:message code="sys.dict.sort"/></label>
					<div class="col-sm-9">
						<form:input path="sort" htmlEscape="false" class="form-control" />
					</div>
				</div>
				<div class="form-group">
					<label for="remarks" class="col-sm-2 control-label"><spring:message code="sys.dict.demonstration"/></label>
					<div class="col-sm-9">
						<form:textarea path="remarks" class="form-control"
							htmlEscape="false" rows="3" maxlength="200" placeholder="${dictDemostration}" />
					</div>
				</div>
			</div>
		</div>
		<!-- /.box-body -->
		<div class="box-footer text-right">
			<button type="button" class="btn btn-default" data-btn-type="cancel"
				data-dismiss="modal"><spring:message code="common.cancel"/></button>
			<shiro:hasPermission name="sys:dict:edit">
				<button type="submit" class="btn btn-primary" data-btn-type="save"><spring:message code="common.submit"/></button>&nbsp;</shiro:hasPermission>

		</div>
		<!-- /.box-footer -->
	</form:form>

</div>
<script>
	//tableId,queryId,conditionContainer
	var form = null;
	var id="${empty dict.id?0:dict.id}";
	$(function() {
		//数据校验
		$("#dict-form").bootstrapValidator({
			message : '<spring:message code="common.promt.value"/>',
			feedbackIcons : {
				valid : 'glyphicon glyphicon-ok',
				invalid : 'glyphicon glyphicon-remove',
				validating : 'glyphicon glyphicon-refresh'
			},
			fields : {
				value : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.dict.promt.value"/>'
						}
					}
				},
				label : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.dict.promt.label"/>'
						}
					}
				},
				type : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.dict.promt.type"/>'
						}
					}
				},
				description : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.dict.promt.type.description"/>'
						}
					}
				},
				sort : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.dict.sort"/>'
						}
					}
				}
				
			}
		}).on("success.form.bv",function(e){
			    e.preventDefault();
				modals.confirm('<spring:message code="common.confirm.save"/>', function() {
					//Save Data，对应'submit-提交'
					var params = form.getFormSimpleData();
					ajaxPost(basePath+'/sys/dict/save', params, function(data, status) {
						if(data.code == 200){
							if(id!="0"){//更新
								modals.correct(data.message);
								modals.hideWin(winId);
								dictTable.reloadRowData(id);
							}else{//新增 
								 modals.correct(data.message);
								 modals.hideWin(winId);
								 dictTable.reloadData();
							}
						}else{
							modals.error(data.message);
						}				 
					});
				});
		});
		//初始化控件
		form=$("#dict-form").form();
	});
	
	
	function resetForm(){
		form.clearForm();
        $("#dict-form").data('bootstrapValidator').resetForm();
	}
</script>
