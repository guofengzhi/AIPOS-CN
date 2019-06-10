<%@ page contentType="text/html;charset=UTF-8"%>
<!-- sidebar: style can be found in sidebar.less -->
<section class="sidebar">
	<!-- Sidebar user panel -->
	<div class="user-panel">
		<div class="pull-left image">
			<img src="${ctxStatic}/adminlte/dist/img/user2-160x160.jpg"
				class="img-circle" alt="User Image">
		</div>
		<div class="pull-left info">
			<p>
				<shiro:principal property="name" />
			</p>
			<a href="#"><i class="fa fa-circle text-success"></i><spring:message code="online"/></a>
		</div>
	</div>

	<!-- /.search form -->
	<!-- sidebar menu: : style can be found in sidebar.less -->
	<ul class="sidebar-menu" data-widget="tree">
	</ul>
</section>
<!-- /.sidebar -->
