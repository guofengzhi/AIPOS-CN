<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!-- Logo -->
<a href="${basePath}/" class="logo"> <!-- mini logo for sidebar mini 50x50 pixels -->
    <span class="logo-mini">${miniLogo}</span> <!-- logo for regular state and mobile devices -->
    <span class="logo-lg">${productName}</span>
</a>
<!-- Header Navbar: style can be found in header.less -->
<nav class="navbar navbar-static-top">
    <!-- Sidebar toggle button-->
    <a href="#" class="sidebar-toggle" data-toggle="offcanvas"
        role="button"> <span class="sr-only">Toggle navigation</span>
    </a>
	<!-- NAVBAR LEFT -->
	<ul class="nav navbar-nav pull-left hidden-xs" id="navbar-left" >
		<li class="dropdown">
			<a href="#" class="dropdown-toggle" data-toggle="dropdown" style="width:160px">
				<i class="fa fa-cog" style="margin-left:32px"></i>
				<span class="name" ><spring:message code="common.Language"></spring:message> </span>
				<i class="fa fa-angle-down"></i>
			</a>
			<ul class="dropdown-menu skins">
				<li><a  class="btn"    href="${basePath}/login?loginLang=zh_cn" ><spring:message code="common.Chinese"></spring:message></a></li>
				<li><a  class="btn "   href="${basePath}/login?loginLang=en_us"><spring:message code="common.English"></spring:message></a></li>
				<li><a  class="btn"    href="${basePath}/login?loginLang=zh_tw"><spring:message code="common.TraditionalChineseCharacter"></spring:message></a></li>
			 </ul>
		</li>
	</ul>
    <!-- Navbar Right Menu -->
    <div class="navbar-custom-menu">
        <ul class="nav navbar-nav">
            <!-- User Account: style can be found in dropdown.less -->
            <li class="dropdown user user-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown"> 
                <img src="${ctxStatic}/adminlte/dist/img/user2-160x160.jpg" class="user-image" alt="User Image"/> 
                    <span class="hidden-xs"> <shiro:principal property="name"/> </span>
            </a>
                <ul class="dropdown-menu">
                   <!-- User image -->
                    <li class="user-header">
                    <img src="${ctxStatic}/adminlte/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
                        <p>
                            <shiro:principal property="name" />
                        </p>
                     </li>
                    <!-- Menu Body -->
                    <!-- Menu Footer-->
                    <li class="user-footer">
                        <div class="pull-left">
                            <a href="javascript:modifyPwd();" data-btn-type="modifyPwd" class="btn btn-default btn-flat"><spring:message code="sys.login.updatePW" /></a>
                        </div>
                        <div class="pull-right">
                            <%--   <a href="${basePath}/logout"  class="btn btn-default btn-flat"><spring:message code="sys.login.exit" /></a>  --%>
                          <a href="javascript:logout();" class="btn btn-default btn-flat"><spring:message code="sys.login.exit" /></a>
                        </div>
                    </li>
                </ul>
            </li>
            <li>
	            <a href="#" data-toggle="control-sidebar"><i class="fa fa-gears"></i></a>
	       </li>
        </ul>
    </div>
</nav>
