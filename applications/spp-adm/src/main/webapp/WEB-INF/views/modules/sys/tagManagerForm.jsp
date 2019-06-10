<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
	<%-- <%@ include file="/WEB-INF/views/common/commonsjs.jsp"%> --%>
<script type="text/javascript"
	src="${basePath}/adminlte/plugins/jQuery-form/jquery.form.js"></script>	
<script type="text/javascript">
	var tagManagerForm = null;
	var tagManagerUrl="/sys/tagManager/add";
	$(function() {
		//初始化控件
		tagManagerForm = $("#tagManager-form").form();
		var updateflag = "${updateflag}";
		if(updateflag==="true"){
			var tagId = "${id}";
			tagManagerUrl = "/sys/tagManager/update?id="+tagId;
		}
			//数据校验
			$("#tagManager-form").bootstrapValidator({
								message : '<spring:message code="common.promt.value"/>',
								feedbackIcons : {
									valid : 'glyphicon glyphicon-ok',
									invalid : 'glyphicon glyphicon-remove',
									validating : 'glyphicon glyphicon-refresh'
								},
								fields : {
									orgId : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.store.orgId.not.empty"/>'
											}
										}
									},
									tagName : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.labelManagement.label.not.null"/>'
											},
											remote : {
												 url:basePath+"/sys/tagManager/checkTagManagerName", 
					                              delay :  2000,
					                              data: function(validator) {
					                                  return {
					                                	  tagId:tagId,
					                                	  tagName:$('tagName').val(),
					                                	  orgId:$('#storeFormOrgSelect').val()
					                                  };
					                              },
												message : '<spring:message code="sys.labelManagement.LabelName.existed"/>'
											}
										}
									}
								}
							});
		
				$("#save").click(function(){
					$("#tagManager-form").bootstrapValidator('validate');//提交验证 
					if ($("#tagManager-form").data('bootstrapValidator').isValid()) {//获取验证结果，如果成功，执行下面代码  
						var params = tagManagerForm.getFormSimpleData();
						$.ajax({
							type : 'POST',
							traditional:true,
							url : basePath+tagManagerUrl,
							data : params,
							success : function(res) {
								modals.closeWin(winId);
								modals.correct({
									title:'<spring:message code="common.sys.success" />',
									cancel_label:'<spring:message code="common.confirm" />', 
									text:'<spring:message code="sys.labelManagement.doSucess" />'});
								window.parent.tagManagerTable.reloadRowData();
							},
							error:function(res){
								modals.closeWin(winId);
								modals.correct({
									title:'<spring:message code="common.sys.success" />',
									cancel_label:'<spring:message code="common.confirm" />',
									text:'<spring:message code="sys.labelManagement.doSucess" />'});
								window.parent.tagManagerTable.reloadRowData();
							}
						}); 
					} 
				});	 
			});
	function showOrgTree() {
		modals
				.openWin({
					winId : "tagFormOrgTree",
					title : '<spring:message code="modules.device.importing.equipment.by.product.batch"/>',
					width : '300px',
					url : basePath
							+ "/sys/office/toOfficeTree?windowId=tagFormOrgTree&orgSelect=tagFormOrgSelect&orgSelectValue=tagFormOrgSelectValue"
				});
	}

</script>
</head>
<body>
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
	<form:form id="tagManager-form" name="tagManager-form"
		modelAttribute="tagManager" class="form-horizontal">
		<div class="box-body">
			<div class="col-md-6">
				<div class="form-group">
					<label for="office.id" class="col-sm-3 control-label"><spring:message
							code="sys.user.office" /></label>
					<div class="col-sm-8">
						<%-- <form:select path="orgId" id="orgId"
							class="form-control select2" style="width: 100%;">
							<form:options items="${fns:getOfficeList()}" itemLabel="name"
								itemValue="id" htmlEscape="false"/>
						</form:select> --%>
						<input id="tagFormOrgSelect" style="width: 253.33px;"
							name="orgId" class="form-control" type="hidden"
							placeholder="${orgId}" />
						<form:input  id="tagFormOrgSelectValue" path="orgName" class="form-control" htmlEscape="false"
							maxlength="100" placeholder="${orgName}" onclick="showOrgTree();"/>
					</div>
				</div>
				<div class="form-group">
					<label for="tagName" class="col-sm-3 control-label"><spring:message
							code="sys.labelManagement.labelName" /><span
						style="color: red">*</span></label>
					<div class="col-sm-8">
						<form:input type="text" htmlEscape="false" class="form-control"
							id="tagName" path="tagName" placeholder="${tagName}"/>
					</div>
				</div>
			</div>
		</div>
		<div class="box-footer text-right">
		<button type="button" class="btn btn-default" data-btn-type="cancel"
			data-dismiss="modal" id="cancel">
			<spring:message code="common.cancel" />
		</button>
		<button class="btn btn-primary" data-btn-type="save"
			id="save">
			<spring:message code="common.submit" />
		</button>
	</div>
	</form:form>
</div>
</body>
</html>

