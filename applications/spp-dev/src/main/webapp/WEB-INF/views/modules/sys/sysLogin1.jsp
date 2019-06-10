<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page
	import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<html>
<head>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
</head>

<body class="hold-transition login-page">
	<div class="login-box">
		<div class="login-logo">
			<a href="#"><h1>支付平台</h1></a>
		</div>
		<!-- /.login-logo -->
		<div class="login-box-body">

			<form action="${basePath}/login" method="post" id="login-form">
				<div class="form-group has-feedback">
					<input type="text" class="form-control" name="username"
						placeholder="请输入用户名\手机号"> <span
						class="glyphicon glyphicon-envelope form-control-feedback"></span>
				</div>
				<div class="form-group has-feedback">
					<input type="password" class="form-control" name="password"
						placeholder="请输入密码"> <span
						class="glyphicon glyphicon-lock form-control-feedback"></span>
				</div>
				<c:if test="${isValidateCodeLogin}">
					<div class="form-group has-feedback">
						<div class="row">
							<div class="col-sm-8">
								<input type="text" id="validateCode" name="validateCode"
									placeholder="请输入四位验证码" class="form-control" />
							</div>
							<div class="col-sm-4">
								<img src="${pageContext.request.contextPath}/validateCode"
									id="img_captcha" sytle="cursor:pointer;float:left;"
									title="点击更换" />
							</div>
						</div>
					</div>
				</c:if>
				<div
					class="alert alert-danger text-center ${(message=='' or message==null) ? 'hide' : ''}">
					${message}</div>
				<div>&nbsp;</div>
				<div class="row">
					<div class="col-xs-6">
						<div class="checkbox icheck">
							<label> <input type="checkbox" name="rememberMe">
								下次自动登录
							</label>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-12">
						<button type="submit" class="btn btn-danger btn-block btn-flat">登
							录</button>
					</div>
				</div>
			</form>

			<!-- /.login-box-body -->
		</div>
		<!-- /.login-box -->
	</div>

	<script>
		
	    $("#img_captcha").click(function(){
	    	 $(this).attr("src",'${pageContext.request.contextPath}/validateCode?'+ Math.random());
	    })
	    
		$(function() {
			$('input').iCheck({
				checkboxClass : 'icheckbox_square-red',
				radioClass : 'iradio_square-red',
				increaseArea : '20%' // optional
			});
			fillbackLoginForm();
			$("#login-form").bootstrapValidator({
				message : '请输入用户名/密码',
				fields : {
					username : {
						validators : {
							notEmpty : {
								message : '手机号或用户名不能为空'
							}
						}
					},
					password : {
						validators : {
							notEmpty : {
								message : '密码不能为空'
							}
						}
					},
					validateCode : {
						validators : {
							notEmpty : {
								message : '验证码不能为空'
							}
						}
					}
				}
			}).on("success.form.bv",function(e){
					rememberMe($("input[name='rememberMe']").is(":checked"));
			});

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