<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="app.appinfo.please.enter.the.application.name"
	var="appName" />
<spring:message
	code="app.appinfo.please.enter.the.application.package.name"
	var="appPackage" />
<spring:message code="app.appinfo.developer" var="appDeveloper" />
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
	<h5 class="modal-title"><spring:message code="app.information.detail" /></h5>
</div>

<div class="modal-body">
	<form:form id="appInfo-form" name="appInfo-form"
		modelAttribute="appInfo" class="form-horizontal">
		<form:hidden path="id" value="${appInfo.id }" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'>

		<div class="box-body">
			<div class="col-md-12">
				<div class="row">
					<div class="form-group" style="margin-left:-80px;">
						<label for="appName" class="col-sm-2 control-label"><spring:message
								code="app.appinfo.application.name" /></label>
						<div class="col-sm-4">
							<form:input path="appName" value="${appInfo.appName }"
								disabled="true" htmlEscape="false" maxlength="50"
								class="form-control" placeholder='${appName}' />
						</div>
						<label for="appPackage" class="col-sm-2 control-label"><spring:message
								code="app.appinfo.application.package.name" /></label>
						<div class="col-sm-4">
							<form:input path="appPackage" value="${appInfo.appPackage }"
								disabled="true" htmlEscape="false" maxlength="50"
								class="form-control" placeholder='${appPackage }' />
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-12">
							<label for="logo" class="control-label" style="margin-left:8px;"><spring:message code="app.information.logo" /></label>
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-4">
								<div class="file-loading">
								    <input id="logoFile" name="logoFile" type="file" multiple placeholder="<spring:message code='app.information.logo' />">
								</div>
		       				 </div>
					</div>
					<div class="form-group">
						<div class="col-sm-12">
							<label for="logo" class="control-label" style="margin-left:8px;"><spring:message code="app.information.screenshot" /></label>
						</div>
					</div>
					<div class="form-group">
	       				 <div class="col-sm-4">
		       				 <div class="file-loading">
								   <input id="appImage1" name="appImage" type="file" multiple class="file-loading" class="form-control" placeholder="<spring:message code='app.information.screenshot' />">
							</div>
       				 	</div>
	       				 <div class="col-sm-4">
		       				 <div class="file-loading">
								   <input id="appImage2" name="appImage" type="file" multiple class="file-loading" class="form-control" placeholder="<spring:message code='app.information.screenshot' />">
							</div>
       				 	</div>
	       				 <div class="col-sm-4">
		       				 <div class="file-loading">
								   <input id="appImage3" name="appImage" type="file" multiple class="file-loading" class="form-control" placeholder="<spring:message code='app.information.screenshot' />">
							</div>
       				 	</div>
       				 </div>

					<div class="form-group" style="margin-left:-80px;">
						<label for="platform" class="col-sm-2 control-label"><spring:message code="app.information.platform" /></label>
						<div class="col-sm-4">
							<form:select path="platform" id="platform"
								data-placeholder='${platform }' class="form-control select2"
								style="width: 100%;" disabled="true">
								<form:option value=""></form:option>
								<c:forEach items="${platformList}" var="platform"
									varStatus="idxStatus">
									<form:option value="${platform.value}">${platform.label }</form:option>
								</c:forEach>
							</form:select>
						</div>
						<label for="category" class="col-sm-2 control-label"><spring:message code="app.information.type" /></label>
						<div class="col-sm-4">
							<form:select path="category" id="category"
								data-placeholder='${category }' class="form-control select2"
								style="width: 100%;" disabled="true">
								<form:option value=""></form:option>
								<c:forEach items="${categoryList}" var="category"
									varStatus="idxStatus">
									<form:option value="${category.value}">${category.label }</form:option>
								</c:forEach>
							</form:select>
						</div>
					</div>

					<div class="form-group" style="margin-left:-80px;">
						<label for="appDeveloper" class="col-sm-2 control-label"><spring:message
								code="app.appinfo.developer" /></label>
						<div class="col-sm-4">
							<form:select path="appDeveloper" id="appDeveloper"
								data-placeholder='${appDeveloper }' class="form-control select2"
								style="width: 100%;" disabled="true">
								<form:option value=""></form:option>
								<c:forEach items="${appDeveloperList}" var="appDeveloper"
									varStatus="idxStatus">
									<form:option value="${appDeveloper.id }">${appDeveloper.name }</form:option>
								</c:forEach>
							</form:select>
						</div>
						<label for="appVersion" class="col-sm-2 control-label"><spring:message code="app.information.new.version" /></label>
						<div class="col-sm-4">
							<form:input path="appVersion" id="appVersion"
								value="${appInfo.appVersion }" htmlEscape="false" maxlength="50"
								class="form-control" disabled="true" />
						</div>
					</div>
					<div class="form-group">
					    <div class="col-sm-12">
						<label for="file" class="control-label" style="margin-left:8px;"><spring:message code="app.information.file" /></label>
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-4">
							<input type="hidden" name="appVersionId" id="appVersionId"
								value="${appInfo.versionId }"> <input type="file"
								name="apkFile" id="apkFile" placeholder="<spring:message code='app.information.file' />" />
						</div>
					</div>
					<div class="form-group" style="margin-left:-80px;">
						<label for="appDescription" class="col-sm-2 control-label"><spring:message code="app.information.description" /></label>
						<div class="col-sm-10">
							<form:textarea path="appDescription" class="form-control"
								htmlEscape="false" rows="3" maxlength="250" disabled="true" />
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- /.box-body -->
		<div class="box-footer text-right">
			<!--以下两种方式提交验证,根据所需选择-->
			<button type="button" class="btn btn-default" data-btn-type="cancel"
				data-dismiss="modal">
				<spring:message code="common.cancel" />
			</button>
			<button type="button" onclick="submitApprove()"
				class="btn btn-primary"><spring:message code="app.information.approval.button" /></button>
		</div>
	</form:form>


</div>
<script>
	//tableId,queryId,conditionContainer
	var appInfoform = null;
	var approveWin = "approveWin";
	var winId = "appInfoWin"
	$(".select2").select2();
	$(function() {
		/* var btnCust = '<button type="button" class="btn btn-secondary" title="Add picture tags" ' + 
	    'onclick="alert(\'Call your custom code here.\')">' +
	    '<i class="glyphicon glyphicon-tag"></i>' +
	    '</button>';  */
	    var inputs = $(":input[type=file]");
	    var message = '<strong>'+'<spring:message code="app.information.select.application.logo" />'+'<span style="color: red">*</span></strong>';
	    var src = 'http://aipos-n.jiewen.com.cn/common/add.png';
	    var option = "${option}";
	    var url1 = 'http://aipos-n.jiewen.com.cn/common/add.png',
        url2 = 'http://aipos-n.jiewen.com.cn/common/add.png';
	    var initialPreview = ["${appInfo.appLogo}"];
	    $(inputs).each(function(index,element){
	    	if(index===1){
	    		initialPreview=["${appInfo.appImg1}"];
	    	} 
	    	if(index===2){
	    		initialPreview=["${appInfo.appImg2}"];
	    	} 
	    	if(index===3){
	    		initialPreview=["${appInfo.appImg3}"];
	    	} 
	    	 $(element).fileinput({
	    		 initialPreview: initialPreview,
	    	       initialPreviewAsData: true,
	    	       overwriteInitial: true,
	    	       maxFileSize: 40000,
	    	       initialCaption: "<spring:message code='app.information.please.select.img' />",
	    	       maxFileCount:1,
	    	       browseLabel: this.placeholder,
	    	       showUpload:false,
	    	       showCaption:false,
	    	       showRemove:false,
	    	       removeLabel: '<spring:message code="app.information.delete.img" />',
	               removeClass: 'btn btn-danger',
	    	       dropZoneTitle:'<img src="'+src+'" style="width:100px;height:100px;"/>',
	    	       autoReplace: true,
	    	       layoutTemplates:{
	    	        	actionDelete:'',
	    	        	actionUpload:''
	    	       }
	    	    });
	    }); 
	    
		var appInfo = $("#appInfo-form").form();
		var appId = $("#id").val();
		
		$("input[name=apkFile]")
		.each(
				function(k, v) {
					$('#' + this.id)
							.file(
									{
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
								                layoutTemplates: {
								                	actionDelete:'',
								    	        	actionUpload:''
								    	        }
								            },
								            fileIdContainer:"[name='appVersionId']",
								            window:false,
										showUrl : basePath
												+ "/appVersion/getFiles/"
												+ 'appFile'
												+ "/"
												+ '${appInfo.versionId }'
									});
				});

	});

	function submitApprove() {
		modals.openWin({
			winId : approveWin,
			title : '<spring:message code="app.information.approval" />',
			width : '600px',
			url : basePath + "/approvalRecord/approveDetail"
		});
	}

	function deplay(flag, remarks, scope) {
		//app_id
		var appId = $("#id").val();

		var params = {};
		params['id'] = appId;
		params['flag'] = flag;
		params['appDataScope'] = scope;
		params['approveRemarks'] = remarks;

		if (flag == '0') {
			var isApproveValidator = true;
			ajaxPost(basePath + "/approvalRecord/approveValidator", params, function(
					data) {
				if (data.code == 400) {
					isApproveValidator = false;
					modals.info(data.message);
				}
			});
			
			if(!isApproveValidator){
				return;
			}
		}
		
		$.when(
				ajaxPostWithDeferred(basePath
						+ "/approvalRecord/saveApprovalRecord/",
						params, function(data, status) {
						})).done(function(data) {
			if (data.code == 200) {
				modals.correct(data.message);
				modals.hideWin(winId);
				approveTable.reloadData();
			} else {
				modals.info(data.message);
			}
		})

	}

	/**
	 * 选择后回调该方法进行提交
	 * @param strategyId
	 * @returns
	 */
	function selectedStragy(flag, remarks, scope) {
		modals.hideWin(approveWin);
		deplay(flag, remarks, scope);
	}
</script>
