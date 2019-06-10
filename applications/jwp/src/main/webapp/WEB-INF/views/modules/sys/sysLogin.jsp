<!--login_page_identity-->
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<html>
<head>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%--  <link rel="stylesheet"
	href="${ctxStatic}/common/css/loginCenter.css">  --%>
<link rel="stylesheet"
	href="${ctxStatic}/common/libs/iconfonts/iconfont.min.css">
<link rel="stylesheet"
	href="${ctxStatic}/adminlte/plugins/toastr/toastr.min.css">	
	<style type="text/css">
		.img {
		margin-right:-100px;
		}
</style>
</head>

<body>
     <!-- 顶部LOG信息  1 -->
	 <div class="header">
	 </div>
	  <!-- 中间2 -->
    <div class="loginWraper">
    <input id="loginIMG" name="loginIMG" type="hidden" value="${loginIMG}" >
       <div id="loginform" class="loginBox">
			<form class="form form-horizontal" action="${basePath}/login" method="post" id="login-form">
				<div class="form-group row cl ">
                 <!--    <label class="form-label col-xs-3"><i class="iconfont">&#xe60d;</i></label> -->
                      <div class="formControls col-xs-8 col-xs-offset-3">
                        <input id="username" name="username" type="text" placeholder='<spring:message code="sys.login.tip.iputADM" />' class="form-control input-text size-L ">
                        <span class="glyphicon glyphicon-user form-control-feedback"></span>
                    </div>
                </div>
                <br>
                <div class="form-group row cl ">
                <!--     <label class="form-label col-xs-3"><i class="iconfont">&#xe60e;</i></label> -->
                     <div class="formControls col-xs-8 col-xs-offset-3">
                        <input id="password" name="password" type="password" placeholder='<spring:message code="sys.login.tip.iputPW" />' class="form-control input-text size-L">
                        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                    </div>
                </div>
                  <br>
                <c:if test="${fns:getConfig('error.password.times')==0 || isValidateCodeLogin}">
                 
                <div  id="yanId" class="row cl has-feedback">
                 <!--    <label class="form-label col-xs-3"><i class="iconfont">&#xe6e1;</i></label> -->
                      <div class="formControls col-xs-8 col-xs-offset-3">
                        <div class="col-xs-4">
                        <input  class="form-control size-L" id="validateCode"  style="width:209px;height:41px;margin-left:-15px;" name="validateCode" type="text" 
                        placeholder='验证码'/>
                       </div>
                       <div class="col-xs-2 col-xs-offset-1" style="margin-left:97px;">
                        <img src="${pageContext.request.contextPath}/validateCode"
									id="img_captcha"   class="size-L;" sytle="cursor:pointer; "
									title='<spring:message code="sys.login.tip.PINClick" />'> 
                        </div>
                     </div>
                 </div>
                 </c:if> 
                 <div class="row cl">
                    <div class="formControls col-xs-8 col-xs-offset-3">
                        <input type="submit" class="btn btn-danger radius size-L" value='<spring:message code="sys.login" />'>
                    </div>
                </div>
                  <br>
                <div class="row cl">
                     <label class="form-label col-xs-3"></label>
                    <div class="formControls col-xs-8">
                        <label for="rememberMe">
                        <input type="checkbox" name="rememberMe" id="rememberMe"> <font style="color:white"><spring:message code="sys.login.select.logined" /></font></label>
                        <label for="rememberLogin">
                        <input type="checkbox" name="rememberLogin" id="rememberLogin"> <font style="color:white"><spring:message code="sys.login.select.logine" /></font></label> 
                    </div>
                </div>
                 <div class="row cl">
                    <div class="formControls col-xs-8 col-xs-offset-3">
                             <a   class="btn"    href="${basePath}/login?loginLang=zh_cn" >中文</a>
                        &nbsp; 
                             <a   class="btn "   href="${basePath}/login?loginLang=en_us">English</a>
                        &nbsp; 
                             <a   class="btn"    href="${basePath}/login?loginLang=zh_tw">繁體</a>
                    </div>
                </div>
                </form>
			<!-- /.login-box-body -->
		</div>
		<!-- /.login-box -->
	</div>
	<!--3 底部信息 -->
	<div class="footer">
        <%@ include file="/WEB-INF/views/common/footer.jsp"%>
    </div>

	<script>
	
		
		var aa=0;
	    $("#img_captcha").click(function(){
	    	 $(this).attr("src",'${pageContext.request.contextPath}/validateCode?'+ Math.random());
	    });
	    var message="${message}";
	    var yanCount="${yanCount}";
	    $("#yanId").hide();
	    if(yanCount >2){
	    	 $("#yanId").show();
	    }
		$(function() {
			    //加载登录界面样式
		     	
		     	      var loginIMG=$("#loginIMG").val();
				var head = document.getElementsByTagName('HEAD').item(0);
				var style = document.createElement('link');
				style.href = '${ctxStatic}/common/css/'+loginIMG+'.css';
				style.rel = 'stylesheet';
				style.type = 'text/css';
				head.appendChild(style);
			
			
			$('input').iCheck({
				checkboxClass : 'icheckbox_minimal-blue',
				increaseArea : '20%' // optional
			});
			fillbackLoginForm();
			$("#login-form").bootstrapValidator({
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
					}
				}
			}).on("success.form.bv",function(e){
			  var validateCode=$("#validateCode").val();
			   rememberMe($("input[name='rememberMe']").is(":checked"));
			   rememberLogin($("input[name='rememberLogin']").is(":checked"));
			   if(yanCount >3){
				   if(validateCode=="" || validateCode==''){
					   toastr.options = {
								  "closeButton": true,
								  "positionClass": "toast-top-center",
								  "preventDuplicates": false,
								  "showDuration": "400",
								  "hideDuration": "1000",
								  "timeOut": "5000",
								  "extendedTimeOut": "1000",
								  "showEasing": "swing",
								  "hideEasing": "linear",
								  "showMethod": "fadeIn",
								  "hideMethod": "fadeOut"
								}
						toastr["error"](message, '<spring:message code="sys.login.tip.PINNull" />');
						return false;
				 }   
			   }
			});
			
			if(message != ''){
				toastr.options = {
						  "closeButton": true,
						  "positionClass": "toast-top-center",
						  "preventDuplicates": false,
						  "showDuration": "400",
						  "hideDuration": "1000",
						  "timeOut": "5000",
						  "extendedTimeOut": "1000",
						  "showEasing": "swing",
						  "hideEasing": "linear",
						  "showMethod": "fadeIn",
						  "hideMethod": "fadeOut"
						}
				localStorage.rememberLogin = 0;
				toastr["error"](message, '<spring:message code="sys.login.tip.error" />');
			}

		});
		
		
		function rememberLogin(rm_flag) {
			//remember me
			if (rm_flag) {
				localStorage.userName = $("input[name='username']").val();
				localStorage.password = $("input[name='password']").val();
				localStorage.rememberLogin = 1;
			}else {
				localStorage.rememberLogin = 0;
			}
		}
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
			if (localStorage.rememberLogin && localStorage.rememberLogin == "1") {
				$("input[name='username']").val(localStorage.userName);
				$("input[name='password']").val(localStorage.password);
				$("input[name='rememberLogin']").iCheck('check');
				$("input[name='rememberLogin']").iCheck('update');
				$("#login-form").submit();
			}
		}
	</script>
</body>

</html>