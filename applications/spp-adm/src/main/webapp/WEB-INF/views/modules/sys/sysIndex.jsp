<!--login_page_identity-->
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page
	import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
</head>
<body class="hold-transition skin-blue sidebar-mini sidebar-collapse">
	<a name="main"></a>
	<div class="wrapper">

		<header class="main-header">
			<%@ include file="/WEB-INF/views/common/header.jsp"%>
		</header>
		<!-- Left side column. contains the logo and sidebar -->
		<aside class="main-sidebar">
			<%@ include file="/WEB-INF/views/common/left-side-column.jsp"%>
		</aside>

		<!-- Content Wrapper. Contains page content -->
		<div class="content-wrapper" id="mainDiv">
			<div id="tabs">
				<ul class="nav nav-tabs" role="tablist">
					
				</ul>
				<!-- Tab panes -->
				<div class="tab-content">
				</div>
			</div>

		</div>
		<!-- /.content-wrapper -->
        <!-- /.main-footer 
		<footer class="main-footer text-center">
			
		</footer>
        -->
	</div>
	<!-- ./wrapper -->
	<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
</body>

</html>