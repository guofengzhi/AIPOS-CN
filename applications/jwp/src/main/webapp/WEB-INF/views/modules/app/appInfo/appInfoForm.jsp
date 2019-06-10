<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="app.appinfo.please.enter.the.application.name"
	var="appName" />
<spring:message
	code="app.appinfo.please.enter.the.application.package.name"
	var="appPackage" />
<spring:message code="app.appinfo.client.identification"
	var="clientIdentification" />
<spring:message code="app.appinfo.developer" var="appDeveloper" />
<style>
	.file-preview{
		
    padding-top: 0px;
    padding-bottom: 0px;
    padding-left: 0px;
    padding-right: 0px;
    border-right-width: 0px;
    border-top-width: 0px;
    border-left-width: 0px;
    border-bottom-width: 0px;
		
	}
	.file-drop-zone{
	    border-top-width: 0px;
	    border-right-width: 0px;
	    border-bottom-width: 0px;
	    border-left-width: 0px;
	}
.file-caption-main {
    width: 89%;
    margin-left: 6px;
}
</style>

<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title">
		<spring:message code="app.appinfo.new.application.information" />
	</h5>
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
								code="app.appinfo.application.name" /><span style="color: red">*</span></label>
						<div class="col-sm-4">
							<form:input path="appName" value="${appInfo.appName }"
								htmlEscape="false" maxlength="20" class="form-control"
								placeholder='${appName}' />
						</div>

						<label for="appPackage" class="col-sm-2 control-label"><spring:message
								code="app.appinfo.application.package.name" /><span
							style="color: red">*</span></label>
						<div class="col-sm-4">
							<form:input path="appPackage" value="${appInfo.appPackage }"
								htmlEscape="false" maxlength="50" class="form-control"
								placeholder='${appPackage }' />
						</div>
					</div>

					<div class="form-group" style="margin-left:-80px;">
						<label for="platform" class="col-sm-2 control-label"><spring:message code="app.information.platform" /><span
							style="color: red">*</span></label>
						<div class="col-sm-4">
							<form:select path="platform" id="platform"
								data-placeholder='${platform }' class="form-control select2"
								style="width: 100%;">
								<form:option value=""></form:option>
								<c:forEach items="${platformList}" var="platform"
									varStatus="idxStatus">
									<form:option value="${platform.value}">${platform.label }</form:option>
								</c:forEach>
							</form:select>
						</div>

						<label for="category" class="col-sm-2 control-label"><spring:message code="app.information.type" /><span
							style="color: red">*</span></label>
						<div class="col-sm-4">
							<form:select path="category" id="category"
								data-placeholder='${category }' class="form-control select2"
								style="width: 100%;">
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
								style="width: 100%;">
								<form:option value=""></form:option>
								<c:forEach items="${appDeveloperList}" var="appDeveloper"
									varStatus="idxStatus">
									<form:option value="${appDeveloper.id }">${appDeveloper.name }</form:option>
								</c:forEach>
							</form:select>
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-12">
							<label for="logo" class="control-label" style="margin-left:8px;"><spring:message code="app.information.logo" /><span
							style="color: red">*</span></label>
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
							<label for="logo" class="control-label" style="margin-left:10px;"><spring:message code="app.information.screenshot" /><span
							style="color: red">*</span></label>
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
			<button type="submit" id="submit" class="btn btn-primary"
				data-btn-type="save">
				<spring:message code="common.submit" />
			</button>
		</div>

		<!-- /.box-footer -->
	</form:form>


</div>
<script>
	//tableId,queryId,conditionContainer
	var appInfoform = null;
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
	    	       removeLabel: '<spring:message code="app.information.delete.img" />',
	               removeClass: 'btn btn-danger',
	    	       dropZoneTitle:'<img src="'+src+'" style="width:100px;height:100px;"/>',
	    	       autoReplace: true,
	    	       layoutTemplates: {main2: '{preview}  {browse} {remove}'}
	    	    });
	    }); 
		var appInfo = $("#appInfo-form").form();
		$("#appInfo-form")
				.bootstrapValidator(
						{
							message : '<spring:message code="app.appinfo.please.enter.a.valid.value" />',
							feedbackIcons : {
								valid : 'glyphicon glyphicon-ok',
								invalid : 'glyphicon glyphicon-remove',
								validating : 'glyphicon glyphicon-refresh'
							},
							fields : {
								appName : {
									validators : {
										notEmpty : {
											message : '<spring:message code="app.appinfo.please.enter.the.application.name"/>！'
										}
									}
								},
								logoFile : {
									validators : {
										notEmpty : {
											message : '<font color="red">'+'<spring:message code="app.information.please.upload.application.logo" />'+'</font>'
										},
										file: {
					                        extension: 'png,jpg,jpeg',
					                        type: 'image/png,image/jpg,image/jpeg',
					                        message: '<spring:message code="app.information.please.again.select.img" />'
					                    }
									}
								},
								appPackage : {
									validators : {
										notEmpty : {
											message : '<spring:message code="app.appinfo.please.enter.the.application.package.name"/>!'
										},
										regexp: {
				                            regexp: /^[^\u4e00-\u9fa5]+$/,
				                            message: '<spring:message code="app.information.package.cannot.contains.china.char" />'
				                        }
									}
								},
								category : {
									validators : {
										notEmpty : {
											message : ''
										}
									}
								},
								platform : {
									validators : {
										notEmpty : {
											message : '<spring:message code="app.information.please.select.platform" />'
										}
									}
								},
								appImage:{
									validators:{
										notEmpty : {
											message : '<font color="red">'+'<spring:message code="app.information.please.upload.screenshot" />'+'</font>'
										},
										file: {
					                        extension: 'png,jpg,jpeg',
					                        type: 'image/png,image/jpg,image/jpeg',
					                        message: '<spring:message code="app.information.img.type.error.please.select.again" />'
					                    }
									}
								}
							}
						})
				.on(
						'success.form.bv',
						function(e) {
							// 阻止默认事件提交
							e.preventDefault();

							modals
									.confirm(
											'<spring:message code="app.appinfo.are.you.sure.you.want.to.save.this.information"/>?',
											function() {
												var params = new FormData(
														$("#appInfo-form")[0])
												ajaxPostFileForm(
														basePath
																+ '/appInfo/save',
														params,
														function(data, status) {
															if (data.code == 200) {
																//新增 
																modals
																		.correct(data.message);
																modals
																		.hideWin(winId);
																appInfoTable
																		.reloadRowData();
															} else {
																modals
																		.info(data.message);
																$("#submit")
																		.removeAttr(
																				'disabled');
															}
														});
											});

						})

	});
	function resetappInfoForm() {
		appInfoform.clearForm();
		$("#appInfo-form").data('bootstrapValidator').resetForm();
	}
</script>
