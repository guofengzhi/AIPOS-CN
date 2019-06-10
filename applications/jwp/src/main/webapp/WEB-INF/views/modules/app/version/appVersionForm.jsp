<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="ota.table.application.appPackage" var="versionAppPackage"/>
<spring:message code="app.version.application.version.number" var="versionAppVersion"/>
<spring:message code="app.version.equipment.upgrading" var="equipmentUpgrading"/>
<spring:message code="app.version.start.the.hardware.version" var="startHardVersion"/>
<spring:message code="app.version.end.the.hardware.version" var="endHardVersion"/>
<spring:message code="ota.table.client.identification" var="clientIdentification"/>
<spring:message code="ota.table.application.file" var="applicationFile"/>
<spring:message code="app.version.application.version.description" var="applicationVersionDesc"/>

<style>

.krajee-default.file-preview-frame .kv-file-content {
    height: 167px;
    width: 200px;
}
</style>


<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="app.version.new.application.version"/></h5>
</div>

<div class="modal-body">
	<form:form id="appVersion-form" name="appVersion-form" modelAttribute="appVersion"
		class="form-horizontal" >
		 <form:hidden path="id" value="${appVersion.id }" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'>
		<div class="box-body">
			<div class="col-md-12">
			  <div class="row">
				  <div class="form-group">
					<label for="appName" class="col-sm-2 control-label"><spring:message code="ota.table.application.name"/><span style="color:red">*</span></label>
					<div class="col-sm-4">
					    <form:input path="appName" id="appName" disabled="true" value="${appInfo.appName }" htmlEscape="false" maxlength="50" class="form-control" />
					</div>
					<%-- <label for="appPackage" class="col-sm-2 control-label"><spring:message code="ota.table.application.appPackage"/><span style="color:red">*</span></label>
					<div class="col-sm-4">
					    <form:input path="appPackage" id="appPackageId" disabled="true" value="${appVersion.appPackage }"  htmlEscape="false" maxlength="50" class="form-control" placeholder='${versionAppPackage }'/>
					</div>  --%>
				</div>
				<div class="form-group">
					<label for="appPackage" class="col-sm-2 control-label"><spring:message code="ota.table.application.appPackage"/><span style="color:red">*</span></label>
					<div class="col-sm-4">
					    <form:input path="appPackage" id="appPackage" disabled="true" value="${appInfo.appPackage }" htmlEscape="false" maxlength="50" class="form-control" />
					</div>
					<%-- <label for="appPackage" class="col-sm-2 control-label"><spring:message code="ota.table.application.appPackage"/><span style="color:red">*</span></label>
					<div class="col-sm-4">
					    <form:input path="appPackage" id="appPackageId" disabled="true" value="${appVersion.appPackage }"  htmlEscape="false" maxlength="50" class="form-control" placeholder='${versionAppPackage }'/>
					</div>  --%>
				</div>
				<div class="form-group">
					<label for="appVersion" class="col-sm-2 control-label">${versionAppVersion }<span style="color:red">*</span></label>
					<div class="col-sm-4">
					    <form:input path="appVersion" id="appVersion" value="${appVersion.appVersion }" htmlEscape="false" maxlength="50" class="form-control" placeholder="${versionAppVersion }"/>
					</div>
				</div>
				<div class="form-group">
					<label for="file" class="col-sm-2 control-label">${applicationFile }<span style="color:red">*</span></label>
					<div class="col-sm-4" id="file_container">
						<input type="hidden" name="appVersionId" id="appVersionId" value="${appVersion.id }">
					    <input type="file" name="file" id="file" placeholder="${applicationFile }"/>
					</div>
				</div>
				<div class="form-group">
					<label for="appDescription" class="col-sm-2 control-label">${applicationVersionDesc }<span style="color:red">*</span></label>
					<div class="col-sm-10">
						<form:textarea path="appDescription" class="form-control"
							htmlEscape="false" rows="3" maxlength="250" placeholder="${applicationVersionDesc }" />
					</div>
				</div>
			</div>
		</div>
		<!-- /.box-body -->
		<div class="box-footer text-right">
			<!--以下两种方式提交验证,根据所需选择-->
			<button type="button" class="btn btn-default" data-btn-type="cancel"
				data-dismiss="modal"><spring:message code="common.cancel"/></button>
			 <button type="submit" id="submitBtn" class="btn btn-primary" data-btn-type="save"><spring:message code="common.submit"/></button>
		</div>
		
		<!-- /.box-footer -->
	</form:form>
	

</div>
<script>
//tableId,queryId,conditionContainer
var appVersionform = null;
$(".select2").select2();

$(function() {
	var appVersion = $("#appVersion-form").form();
	$("input[type=file]").each(function(k,v){
		$('#'+this.id).file({
            fileinput: {
            	uploadUrl:"",
            	overwriteInitial: true,
            	showClose: true,
                showCaption: false,
                browseLabel: this.placeholder,
                removeLabel: '<spring:message code="app.information.delete.file" />',
                removeClass: 'btn btn-danger',
                otherActionButtons:"",
                browseIcon: '<i class="glyphicon glyphicon-folder-open"></i>',
                maxFileSize: 51200,
                maxFileCount:1,
                autoReplace: true,
                layoutTemplates: {main2: '{preview}  {browse} {remove}'}
            },
            fileIdContainer:"[name='appVersionId']",
            window:false,
            showUrl:basePath+"/appVersion/getFiles/"+'appFile'+"/"+ '${appVersion.id }'
        });
	})
	
	$("#appVersion-form").bootstrapValidator({
				message : '<spring:message code="common.promt.value"/>',
				feedbackIcons : {
					valid : 'glyphicon glyphicon-ok',
					invalid : 'glyphicon glyphicon-remove',
					validating : 'glyphicon glyphicon-refresh'
				},
				fields : {
					appName : {
						validators : {
							notEmpty : {
								message : '<spring:message code="app.appinfo.please.enter.the.application.name"/>'
							}
						}
					},
					appVersion : {
						validators : {
							notEmpty : {
								message : '<spring:message code="app.release.please.enter.the.application.version"/>'
							},
							regexp :{
								regexp : /(v|V)(?:(\d+)\.)?(?:(\d+)\.)?(\*|\d+)/,
								message : '<spring:message code="app.version.the.format.of.the.version.number.is.not.correct.please.fill.it.out.again"/>'
							}
							
						}
					},
					appPackage : {
						validators : {
							notEmpty : {
								message : '<spring:message code="app.appinfo.please.enter.the.application.package.name"/>'
							}
						}
					},
					appDescription : {
						validators : {
							notEmpty : {
								message : '<spring:message code="app.version.please.enter.the.application.version.description.information"/>'
							}
						}
					}
				}
			}).on('success.form.bv',function(e){
		// 阻止默认事件提交
		 e.preventDefault();
		
		 var reg = new RegExp("[\\u4E00-\\u9FFF]+","g");
			if(reg.test($("#appVersion").val())){ 
				modals.warn('<spring:message code="app.version.the.application.version.number.can.not.contain.chinese"/>');  
			    return;  					
			}

		modals.confirm('<spring:message code="app.version.are.you.sure.you.want.to.save.the.version.of.the.application.file"/>', function() {
			$("#appName").removeAttr('disabled');
			$("#appPackageId").removeAttr('disabled');
			var params = new FormData($("#appVersion-form")[0]);
			ajaxPostFileForm(basePath+'/appVersion/save',params,function(data,status){
				if(data.code == 200){
					modals.correct(data.message);
					modals.hideWin(winId);	
					appVersionTable.reloadRowData();
				}else{
					/* modals.info(data.message); */
					modals.confirm(data.message);
					$('#submitBtn').removeAttr("disabled");
				}				 
		 });
		});
	})
});


function appNameChange(){
	 var params = {};
	 var appName = $("#appName").val();
	 params['appName'] = appName;
	 ajaxPost(basePath+'/appInfo/getAppInfoByName', params, function(data, status) {
			if(data.code == 200){
				var appInfo = data.data;
				$("#appPackageId").val(appInfo.appPackage);
				 var appPackage = $("#appPackageId").val();
			}else{
				modals.warn(data.message);
			}			
	 });
}

function resetappVersionForm(){
	appVersionform.clearForm();
	$("#appVersion-form").data('bootstrapValidator').resetForm();
}

</script>
