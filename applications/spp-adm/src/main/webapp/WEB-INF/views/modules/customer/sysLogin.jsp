<!--login_page_identity-->
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page
	import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<html>
<head>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<link rel="stylesheet" href="${ctxStatic}/common/css/login.css">
<link rel="stylesheet" href="${ctxStatic}/common/css/languages.min.css">
<link rel="stylesheet"
	href="${ctxStatic}/common/libs/language-switcher/language-switcher.css">
<%-- <link rel="stylesheet"
	href="${ctxStatic}/common/libs/iconfonts/iconfont.min.css"> --%>
<link rel="stylesheet"
	href="https://at.alicdn.com/t/font_8d5l8fzk5b87iudi.css">
<script type="text/javascript"
	src="${ctxStatic}/common/js/base-language.js"></script>
<script type="text/javascript"
	src="${ctxStatic}/common/libs/language-switcher/language.switcher.js"></script>

</head>

<body>
	<div class="header">
		<div id="polyglotLanguageSwitcher" style="margin-top: 15px;">
			<form action="#">
				<select id="polyglot-language-options">
					<option id="cn" value="zh_CN">简体中文</option>
					<option id="en" value="en_US">Enlisgh</option>
					<option id="tw" value="zh_TW">繁體中文</option>
				</select>
			</form>
		</div>
	</div>
	<div class="loginWraper">
		<div id="loginform" class="loginBox">

			<form class="form form-horizontal"
				action="${basePath}/customer/login" method="post" id="login-form">
				<input name="loginType" id="loginType" type="hidden"
					value="customer">
				<div class="form-group row cl ">
					<label class="form-label col-xs-3"><i class="iconfont">&#xe60d;</i></label>
					<div class="formControls col-xs-8">
						<input id="username" name="username" type="text"
							placeholder='<spring:message code="sys.login.tip.iputADM" />'
							class="form-control input-text size-L">
					</div>
				</div>
				<div class="form-group row cl has-feedback">
					<label class="form-label col-xs-3"><i class="iconfont">&#xe60e;</i></label>
					<div class="formControls col-xs-8">
						<input id="password" name="password" type="password"
							placeholder='<spring:message code="sys.login.tip.iputPW" />'
							class="form-control input-text size-L">
					</div>
				</div>

				<c:if test="${isValidateCodeLogin}">

					<div class="row cl has-feedback">
						<label class="form-label col-xs-3"></label>
						<div class="formControls">
							<div class="col-xs-4">
								<input class="form-control input-text size-L" id="validateCode"
									name="validateCode" type="text"
									placeholder='<spring:message code="sys.login.tip.inputPIN" />'
									onblur="if(this.value==''){this.value='验证码:'}"
									onclick="if(this.value=='验证码:'){this.value='';}" value="验证码:" />
							</div>
							<div class="col-xs-2 col-xs-offset-1">
								<img src="${pageContext.request.contextPath}/validateCode"
									id="img_captcha" class="size-L" sytle="cursor:pointer;"
									title='<spring:message code="sys.login.tip.PINClick" />'>
							</div>
						</div>
					</div>
				</c:if>

				<div class="row cl">
					<label class="form-label col-xs-3"></label>
					<div class="formControls col-xs-8">
						<label for="online"> <input type="checkbox"
							name="rememberMe" id="rememberMe"> <spring:message
								code="sys.login.select.logined" /></label>
					</div>
				</div>
				<div class="row cl">
					<div class="formControls col-xs-8 col-xs-offset-3">
						<input type="submit" class="btn btn-success radius size-L"
							value='<spring:message code="sys.login" />'>
					</div>
				</div>
			</form>

			<!-- /.login-box-body -->
		</div>
		<!-- /.login-box -->
	</div>

	<div class="footer">
		<%@ include file="/WEB-INF/views/common/footer.jsp"%>
	</div>

	<script>
		$("#img_captcha").click(
				function() {
					$(this).attr(
							"src",
							'${pageContext.request.contextPath}/validateCode?'
									+ Math.random());
				})
		var message = "${message}";
		$(function() {
			var selectValue = ''
				var lan = getCookie("language");
				if (lan == "en-US") {
					selectValue = "en";
				} else if (lan == "zh-TW") {
					selectValue = "tw";
				} else {
					selectValue = "cn";
				}
				$('#polyglotLanguageSwitcher').polyglotLanguageSwitcher({
					effect : 'fade',
					openMode : 'click',
					//testMode:true,
					initValue : selectValue,
					onChange : function(evt) {
						setCookie(evt.selectedItem);
					}
				});
			$('input').iCheck({
				checkboxClass : 'icheckbox_minimal-blue',
				increaseArea : '20%' // optional
			});
			fillbackLoginForm();
			$("#login-form")
					.bootstrapValidator(
							{
								message : '<spring:message code="sys.login.tip.inputADMOrPW" />',
								fields : {
									username : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.login.tip.ADMNull" />'
											}
										}
									},
									password : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.login.tip.PWNull" />'
											}
										}
									},
									validateCode : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.login.tip.PINNull" />'
											}
										}
									}
								}
							}).on(
							"success.form.bv",
							function(e) {
								rememberMe($("input[name='rememberMe']").is(
										":checked"));
							});

			toastr.options = {
				"closeButton" : true,
				"positionClass" : "toast-top-center",
				"preventDuplicates" : false,
				"showDuration" : "300",
				"hideDuration" : "1000",
				"timeOut" : "5000",
				"extendedTimeOut" : "1000",
				"showEasing" : "swing",
				"hideEasing" : "linear",
				"showMethod" : "fadeIn",
				"hideMethod" : "fadeOut"
			}
			if (message != '') {
				toastr["error"](message,
						'<spring:message code="sys.login.tip.error" />');
			}
			try {
				var _href = window.location.href + "";
				if (_href && _href.indexOf('?kickout') != -1) {
					toastr["error"]
							(
									'<spring:message code="sys.login.been.kicked.out" />',
									'<spring:message code="sys.login.tip.error" />');
				}
			} catch (e) {
			}

		});

		//使用本地缓存记住用户名密码
		function rememberMe(rm_flag) {
			//remember me
			if (rm_flag) {
				localStorage.userName = $("input[name='username']").val();
				localStorage.password = $("input[name='password']").val();
				localStorage.rememberMe = 1;
			}
			//delete remember msg
			else {
				localStorage.userName = null;
				localStorage.password = null;
				localStorage.rememberMe = 0;
			}
		}

		//记住回填
		function fillbackLoginForm() {
			if (localStorage.rememberMe && localStorage.rememberMe == "1") {
				$("input[name='username']").val(localStorage.userName);
				$("input[name='password']").val(localStorage.password);
				$("input[name='rememberMe']").iCheck('check');
				$("input[name='rememberMe']").iCheck('update');
			}
		}
	</script>
</body>

</html>