<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Logo -->
<a href="${basePath}/" class="logo"> <!-- mini logo for sidebar mini 50x50 pixels -->
	<span class="logo-mini">${miniLogo}</span> <!-- logo for regular state and mobile devices -->
	<span class="logo-lg"><spring:message code="product.name"/></span>
</a>
<!-- Header Navbar: style can be found in header.less -->
<nav class="navbar navbar-static-top">
	<!-- Sidebar toggle button-->
	<a href="#" class="sidebar-toggle" data-toggle="push-menu"
		role="button"> <span class="sr-only">Toggle navigation</span>
	</a>

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
							<a href="javascript:modifyPwd();" data-btn-type="modifyPwd" class="btn btn-default btn-flat"><spring:message code="sys.login.updatePW"/></a>
						</div>
						<div class="pull-right">
							<a href="${basePath}/logout" class="btn btn-default btn-flat"><spring:message code="sys.login.exit"/></a>
						</div>
					</li>
				</ul>
			</li>
		</ul>
	</div>

</nav>
