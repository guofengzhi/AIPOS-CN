<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<!-- Content Header (Page header) -->
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
	    height:200px;
	}
.file-caption-main {
    width: 89%;
    margin-left: 6px;
}
.file-loading {
    font-size: 12px;
}
.input-group{
	width:293.33px;
	margin-left: 137px;
	margin-top: -25;
}
/* .help-block{
    margin-left: 160px;
} */
</style>
<div id="listForm">

	<!-- Main content -->
	<section class="content">
		<div class="nav-tabs-custom">
			<div class="tab-pane " id="tab-content-edit">
				<form:form id="app-form" name="app-form" modelAttribute="app"
					enctype="multipart/form-data" class="form-horizontal">
					<div class="box-body">
					<div class="col-md-1"></div>
						<div class="col-md-5">
							<div class="form-group has-feedback">
								<label for="office.id" class="col-sm-3 control-label"><spring:message code="app.name"/><span
									style="color: red">*</span>
								</label>
								<div class="col-sm-8">
									<form:input type="text" path="appName" value="${app.appName}"
										id="appName" class="form-control" htmlEscape="false"
										maxlength="100" />
								</div>
							</div>
							
							<div class="form-group has-feedback">
									<label for="appDeveloper" class="col-sm-3 control-label"><spring:message code="developer"/><span style="color: red">*</span></label>
									<div class="col-sm-8">
										<form:select path="appDeveloper" id="appDeveloper"
											data-placeholder='${appDeveloper}' class="form-control select2"
											style="width: 100%;">
											<form:option value=""></form:option>
											<c:forEach items="${appDeveloperList}" var="appDeveloper"
												varStatus="idxStatus">
												<form:option value="${appDeveloper.id }">${appDeveloper.name }</form:option>
											</c:forEach>
										</form:select>
									</div>
							</div>
							<div class="form-group has-feedback">
								<label for="category" class="col-sm-3 control-label"><spring:message code="application.category"/><span style="color: red">*</span></label>
								<div class="col-sm-8">
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
							
							<div class="form-group has-feedback">
								<div>
									<label for="logo" class="col-sm-3 control-label"><spring:message code="app.logo"/><span
										style="color: red">*</span></label>
								</div>
								<div class="file-loading">
									<input type="file" id="logoFile" name="logoFile" multiple="multiple" accept="image/gif, image/jpeg,image/jpg,image/png"/>
								</div>
							</div>
						</div>
						<div class="col-md-5">
							<div class="form-group has-feedback">
								<label for="name" class="col-sm-3 control-label"><spring:message code="app.package"/><span
									style="color: red">*</span></label>
								<div class="col-sm-8">
									<form:input type="text" htmlEscape="false" class="form-control"
										id="appPackage" path="appPackage"
										placeholder="${app.appPackage}" />
								</div>
							</div>
							
							<div class="form-group has-feedback">
								<label for="platform" class="col-sm-3 control-label"><spring:message code="subordinate.to.the.platform"/><span
										style="color: red">*</span></label>
								<div class="col-sm-8">
									<form:select path="platform" id="platform"
										data-placeholder='${platform }' class="form-control select2"
										style="width: 100%;">
										<form:option value=""></form:option>
										<c:forEach items="${platformList}" var="platform"
											varStatus="idxStatus">
											<form:option value="${platform.value}">${platform.label}</form:option>
										</c:forEach>
									</form:select>
								</div>
							</div>
							<div class="form-group has-feedback">
								<label class="col-sm-3 control-label"><span
										style="color: red">&nbsp;</span></label>
							</div>
							<div class="form-group has-feedback">
								<div>
									<label for="apk" class="col-sm-3 control-label"><spring:message code="app.file"/><span
										style="color: red">*</span></label>
								</div>
								<div class="file-loading col-sm-3">
									<input type="file" id="apkFile" name="apkFile" multiple="multiple" accept=".apk"/>
								</div>
							</div>
						</div>
						<div class="col-md-1"></div>
						</div>
						<div class="box-footer text-right">
							<!--以下两种方式提交验证,根据所需选择-->
							<button type="button" class="btn btn-primary"
								data-btn-type="cancel" onclick="javascript:history.back(-1);">
								<spring:message code="common.cancel" />
							</button>
							<button type="submit" class="btn btn-primary" 
								data-btn-type="save">
								<spring:message code="common.submit" />
							</button>
						</div>
						<!-- /.box-footer -->
				</form:form>
			</div>
		</div>
</div>
<!-- /.row -->
</section>
</div>
<script>
	$(function(){
		initialPreview1=["${app.appLogo}"];
		initialPreview2=[""];
		file("logoFile",initialPreview1);
		file("apkFile",initialPreview2);
	});
	function file(id,initialPreview){
		  $('#'+id).fileinput({
			initialPreview : initialPreview,
			initialPreviewAsData : true,
			overwriteInitial : true,
			maxFileSize : 40000,
			showPreview : true, //是否显示预览
			showUpload : false,
			showRemove:false,
			showCaption : true,
			initialCaption : "<spring:message code='please.select.file'/>",
			dropZoneEnabled : false
		});
	}
	//tableId,queryId,conditionContainer
	var appTable;
	var winId = "appWin";
	var form = $("#app-form").form();
	$("#appDeveloper").select2();
	function setTitle(title) {
		$("ul.nav-tabs li.header small").text(title);
	}
	$(function() {
		form.initComponent();

	});
	function manageTerm(countTerm) {
		var oper = "&nbsp;&nbsp;&nbsp;";
		oper += "<a href='javascript:void(0)'   onclick='toManageTerm()'>"
				+ countTerm + "</a>";
		return oper;
	}

/* 	$(function() {
		$(".help-block").each(function(index,element){
			debugger;
			if(index==1||index==3){
				$(element).attr("style","margin-left:160px;");
			}
		});
	}); */

	function operationAppLogo(appLogo, type, rowObj) {
		var oper = "";
		if (appLogo == null || appLogo == '') {
			oper += "<div class='textavatar' style='width: 40px;' data-name='"+rowObj.appName+"'></div>"
		} else {
			oper += "<div class='appimg'> <img src='"+ rowObj.appLogo + "' class='appimg-circle' /></div>";
		}
		return oper;
	}
	$("#app-form").bootstrapValidator(
				{
					message : '校验属性',
					feedbackIcons : {
						valid : 'glyphicon glyphicon-ok',
						invalid : 'glyphicon glyphicon-remove',
						validating : 'glyphicon glyphicon-refresh'
					},
					fields : {
						appName : {
							validators : {
								notEmpty : {
									message : '<spring:message code="the.application.name.cannot.be.empty"/>！'
								}
							}
						},
						appDeveloper : {
							validators : {
								notEmpty : {
									message : '<spring:message code="the.application.name.cannot.be.empty"/>！'
								}
							}
						},
						category : {
							validators : {
								notEmpty : {
									message : '<spring:message code="the.application.name.cannot.be.empty"/>！'
								}
							}
						},
						platform : {
							validators : {
								notEmpty : {
									message : '<spring:message code="the.application.name.cannot.be.empty"/>！'
								}
							}
						},
						logoFile : {
							validators : {
								notEmpty : {
									message : '<spring:message code="select.the.apply.icon"/>'
								},
								file: {
			                        extension: 'png,jpg,jpeg',
			                        type: 'image/png,image/jpg,image/jpeg',
			                        message: '<spring:message code="wrong.file.format"/>'
			                    }
							}
						},
						appPackage : {
							validators : {
								notEmpty : {
									message : '<spring:message code="the.application.package.name.cannot.be.empty"/>!'
								},
								regexp: {
		                            regexp: /^[^\u4e00-\u9fa5]+$/,
		                            message: '<spring:message code="package.name.format.error"/>！'
		                        }
							}
						},
						apkFile:{
							validators:{
								notEmpty : {
									message : '<spring:message code="select.the.apk.file"/>'
								}/* ,
								file: {
			                        extension: 'apk',
			                        type: 'apk',
			                        message: '只能上传.apk文件'
			                    } */
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
									'<spring:message code="are.you.sure.you.want.to.save.the.application"/>',
									function() {
										var params = new FormData(
												$("#app-form")[0])
										ajaxPostFileForm(
												basePath +"/app/save",
												params,
												function(data, status) {
													if (data.code == 200) {
														//新增 
														modals.confirm(data.message,function(){
															window.location.href="javascript:history.back(-1);";
														});
													} else {
														modals.info(data.message);
														$("#submit")
																.removeAttr(
																		'disabled');
													}
												});
									});

				});
	
</script>
