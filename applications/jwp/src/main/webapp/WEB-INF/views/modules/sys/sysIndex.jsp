<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page
	import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
</head>

<body class="hold-transition skin-green sidebar-mini">
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
		<!-- <div class="content-wrapper" id="mainDiv"> -->
		 <div class="content-wrapper" > 
			 <div class="row content-tabs">
		            <button class="roll-nav roll-left J_tabLeft">
		                <i class="fa fa-backward"></i>
		            </button>
		            <nav class="page-tabs J_menuTabs">
		                <div class="page-tabs-content">
		                  
		                </div>
		            </nav> 
		            <button class="roll-nav roll-right J_tabRight">
		                <i class="fa fa-forward"></i>
		            </button>
		            <div class="btn-group roll-nav roll-right">
		                <button class="dropdown J_tabClose" data-toggle="dropdown"><spring:message code="common.ClosingOperation" /><span class="caret"></span>
		                </button>
		                <ul role="menu" class="dropdown-menu dropdown-menu-right" style="margin-right:-58px">
		                    <li class="J_tabShowActive"><a><spring:message code="common.LocateTheCurrentTab" /></a></li>
		                    <li class="divider"></li>
		                    <li class="J_tabCloseAll"><a><spring:message code="common.CloseAllTabs" /></a></li>
		                    <li class="J_tabCloseOther"><a><spring:message code="common.CloseOtherTabs" /></a></li> 
		                </ul>
		            </div>
	            </div>
	           <div class="row J_mainContent" id="content-main">
		            <iframe  width="100%" height="8px" 
		                class="J_iframe" name="iframe0"
		                    src=""
		                    seamless></iframe>
		        </div> 
		</div>
		<!-- /.content-wrapper -->
        <!-- /.main-footer -->
		<!--
		<footer class="main-footer text-center">

		</footer>
		-->

	</div>
	<!-- ./wrapper -->
 <aside class="control-sidebar control-sidebar-dark">
    <!-- Create the tabs -->
    <ul class="nav nav-tabs nav-justified control-sidebar-tabs">
      <li><a href="#control-sidebar-skin-layout-tab" data-toggle="tab"><i class="fa fa-anchor"></i></a></li>
      <li><a href="#control-sidebar-home-tab" data-toggle="tab"><i class="fa fa-home"></i></a></li>
      <li><a href="#control-sidebar-settings-tab" data-toggle="tab"><i class="fa fa-gears"></i></a></li>
    </ul>
    <!-- Tab panes -->
    <div class="tab-content">
      <!-- Home tab content -->
      <div class="tab-pane" id="control-sidebar-home-tab">
        <h3 class="control-sidebar-heading">Recent Activity</h3>
        <ul class="control-sidebar-menu">
          <li>
            <a href="javascript:void(0)">
              <i class="menu-icon fa fa-birthday-cake bg-red"></i>

              <div class="menu-info">
                <h4 class="control-sidebar-subheading">Langdon's Birthday</h4>

                <p>Will be 23 on April 24th</p>
              </div>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)">
              <i class="menu-icon fa fa-user bg-yellow"></i>

              <div class="menu-info">
                <h4 class="control-sidebar-subheading">Frodo Updated His Profile</h4>

                <p>New phone +1(800)555-1234</p>
              </div>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)">
              <i class="menu-icon fa fa-envelope-o bg-light-blue"></i>

              <div class="menu-info">
                <h4 class="control-sidebar-subheading">Nora Joined Mailing List</h4>

                <p>nora@example.com</p>
              </div>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)">
              <i class="menu-icon fa fa-file-code-o bg-green"></i>

              <div class="menu-info">
                <h4 class="control-sidebar-subheading">Cron Job 254 Executed</h4>

                <p>Execution time 5 seconds</p>
              </div>
            </a>
          </li>
        </ul>
        <!-- /.control-sidebar-menu -->

        <h3 class="control-sidebar-heading">Tasks Progress</h3>
        <ul class="control-sidebar-menu">
          <li>
            <a href="javascript:void(0)">
              <h4 class="control-sidebar-subheading">
                Custom Template Design
                <span class="label label-danger pull-right">70%</span>
              </h4>

              <div class="progress progress-xxs">
                <div class="progress-bar progress-bar-danger" style="width: 70%"></div>
              </div>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)">
              <h4 class="control-sidebar-subheading">
                Update Resume
                <span class="label label-success pull-right">95%</span>
              </h4>

              <div class="progress progress-xxs">
                <div class="progress-bar progress-bar-success" style="width: 95%"></div>
              </div>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)">
              <h4 class="control-sidebar-subheading">
                Laravel Integration
                <span class="label label-warning pull-right">50%</span>
              </h4>

              <div class="progress progress-xxs">
                <div class="progress-bar progress-bar-warning" style="width: 50%"></div>
              </div>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)">
              <h4 class="control-sidebar-subheading">
                Back End Framework
                <span class="label label-primary pull-right">68%</span>
              </h4>

              <div class="progress progress-xxs">
                <div class="progress-bar progress-bar-primary" style="width: 68%"></div>
              </div>
            </a>
          </li>
        </ul>
        <!-- /.control-sidebar-menu -->

      </div>
      <!-- /.tab-pane -->
      <div class="tab-pane active" id="control-sidebar-skin-layout-tab">
      	<div><h4 class="control-sidebar-heading">
      		<spring:message code="common.LayoutOptions"></spring:message>
      		</h4>
      	<div class="form-group">
	      	<label class="control-sidebar-subheading">
	      		<input class="pull-right" type="checkbox" data-layout="fixed">
	      		<spring:message code="common.FixedLayout"></spring:message>
	      	</label>
	      	<p>
	      	<spring:message code="common.ActivateTheFixedLayout"></spring:message>
	      	</p>
	      </div>
	      <div class="form-group">
	      	<label class="control-sidebar-subheading">
	      		<input class="pull-right" type="checkbox" data-layout="layout-boxed"> 
	      		<spring:message code="common.BoxedLayout"></spring:message> 
	      	</label>
	      	<p>
	      		<spring:message code="common.ActivateTheBoxedLayout"></spring:message> 
	      	</p>
      	</div>
      	<div class="form-group">
	      	<label class="control-sidebar-subheading">
	      		 <input class="pull-right" type="checkbox" data-layout="sidebar-collapse">
	      		 <spring:message code="common.ToggleSidebar"></spring:message>
	      	</label>
	      	<p>
	      		 <spring:message code="common.ToggleTheLeftSidebar'sState"></spring:message>
	      	</p>
      	</div>
      	<div class="form-group">
      		<label class="control-sidebar-subheading">
      			<input class="pull-right" type="checkbox" data-enable="expandOnHover"> 
				<spring:message code="common.SidebarExpandOnHover"></spring:message>
      		</label>
      		<p>
      			<spring:message code="common.LetTheSidebarMiniExpandOnHover"></spring:message>
      		</p>
      	</div>
      	<div class="form-group">
      		<label class="control-sidebar-subheading">
      			<input class="pull-right" type="checkbox" data-controlsidebar="control-sidebar-open">
      			<spring:message code="common.ToggleRightSidebarLide"></spring:message>
      		</label>
      		<p>
      			<spring:message code="common.ToggleBetweenSlideOverContentAndPushContentEffects"></spring:message>
      		</p>
      	</div>
      	<div class="form-group">
      		<label class="control-sidebar-subheading">
      			<input class="pull-right" type="checkbox" data-sidebarskin="toggle">
      			<spring:message code="common.ToggleRightSidebarSkin"></spring:message>
      		</label>
      		<p>
      			<spring:message code="common.ToggleBetweenDarkAndLightLkinsForTheRightSidebar"></spring:message>
      		</p>
      	</div>
      	<h4 class="control-sidebar-heading">
      			<spring:message code="common.Skins"></spring:message>
      	</h4>
      		<ul class="list-unstyled clearfix">
      			<li style="float:left; width: 33.33333%; padding: 5px;">
      				<a class="clearfix full-opacity-hover" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" href="javascript:void(0);" data-skin="skin-blue">
	      				<div>
		      				<span style="display:block; width: 20%; float: left; height: 7px; background: #367fa9;"></span>
		      				<span class="bg-light-blue" style="display:block; width: 80%; float: left; height: 7px;"></span>
	      				</div>
	      				<div>
	      					<span style="display:block; width: 20%; float: left; height: 20px; background: #222d32;"></span>
	      					<span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7;"></span>
	      				</div>
      				</a>
      				<p class="text-center no-margin">
      					<spring:message code="common.Blue"></spring:message>
      				</p>
      			</li>
      			<li style="float:left; width: 33.33333%; padding: 5px;">
      				<a class="clearfix full-opacity-hover" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" href="javascript:void(0);" data-skin="skin-black">
      					<div class="clearfix" style="box-shadow: 0 0 2px rgba(0,0,0,0.1)">
      						<span style="display:block; width: 20%; float: left; height: 7px; background: #fefefe;"></span>
      						<span style="display:block; width: 80%; float: left; height: 7px; background: #fefefe;"></span>
      					</div>
      					<div>
      						<span style="display:block; width: 20%; float: left; height: 20px; background: #222;"></span>
      						<span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7;"></span>
      					</div>
      				</a>
      				<p class="text-center no-margin">
      					<spring:message code="common.Black"></spring:message>
      				</p>
      			</li>
      			<li style="float:left; width: 33.33333%; padding: 5px;">
      				<a class="clearfix full-opacity-hover" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" href="javascript:void(0);" data-skin="skin-purple">
      					<div>
      						<span class="bg-purple-active" style="display:block; width: 20%; float: left; height: 7px;"></span>
      						<span class="bg-purple" style="display:block; width: 80%; float: left; height: 7px;"></span>
      					</div>
      					<div>
      						<span style="display:block; width: 20%; float: left; height: 20px; background: #222d32;"></span>
      						<span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7;"></span>
      					</div>
      				</a>
      				<p class="text-center no-margin">
      					<spring:message code="common.Purple"></spring:message>
      				</p>
      			</li>
      			<li style="float:left; width: 33.33333%; padding: 5px;">
      				<a class="clearfix full-opacity-hover" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" href="javascript:void(0);" data-skin="skin-green">
      					<div>
      						<span class="bg-green-active" style="display:block; width: 20%; float: left; height: 7px;"></span>
      						<span class="bg-green" style="display:block; width: 80%; float: left; height: 7px;"></span>
      					</div>
      					<div>
      						<span style="display:block; width: 20%; float: left; height: 20px; background: #222d32;"></span>
      						<span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7;"></span>
      					</div>
      				</a>
      				<p class="text-center no-margin">
      					<spring:message code="common.Green"></spring:message>
      				</p>
      			</li>
      			<li style="float:left; width: 33.33333%; padding: 5px;">
      				<a class="clearfix full-opacity-hover" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" href="javascript:void(0);" data-skin="skin-red">
      					<div>
      						<span class="bg-red-active" style="display:block; width: 20%; float: left; height: 7px;"></span>
      						<span class="bg-red" style="display:block; width: 80%; float: left; height: 7px;"></span>
      					</div>
      					<div>
      						<span style="display:block; width: 20%; float: left; height: 20px; background: #222d32;"></span>
      						<span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7;"></span>
      					</div>
      				</a>
      				<p class="text-center no-margin">
      					<spring:message code="common.Red"></spring:message>
      				</p>
      			</li>
      			<li style="float:left; width: 33.33333%; padding: 5px;">
      				<a class="clearfix full-opacity-hover" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" href="javascript:void(0);" data-skin="skin-yellow">
      					<div>
      						<span class="bg-yellow-active" style="display:block; width: 20%; float: left; height: 7px;"></span>
      						<span class="bg-yellow" style="display:block; width: 80%; float: left; height: 7px;"></span>
      					</div>
      					<div>
      						<span style="display:block; width: 20%; float: left; height: 20px; background: #222d32;"></span>
      						<span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7;"></span>
      						</div>
      				</a>
      				<p class="text-center no-margin">
      					<spring:message code="common.Yellow"></spring:message>
      				</p>
      			</li>
      			<li style="float:left; width: 33.33333%; padding: 5px;">
      				<a class="clearfix full-opacity-hover" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" href="javascript:void(0);" data-skin="skin-blue-light">
      					<div>
      						<span style="display:block; width: 20%; float: left; height: 7px; background: #367fa9;"></span>
      						<span class="bg-light-blue" style="display:block; width: 80%; float: left; height: 7px;"></span>
      					</div>
      					<div>
      						<span style="display:block; width: 20%; float: left; height: 20px; background: #f9fafc;"></span>
      						<span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7;"></span>
      					</div>
      				</a>
      				<p class="text-center no-margin" style="font-size: 12px">
      					<spring:message code="common.BlueLight"></spring:message>
      				</p>
      			</li>
      			<li style="float:left; width: 33.33333%; padding: 5px;">
      				<a class="clearfix full-opacity-hover" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" href="javascript:void(0);" data-skin="skin-black-light">
      					<div class="clearfix" style="box-shadow: 0 0 2px rgba(0,0,0,0.1)">
      						<span style="display:block; width: 20%; float: left; height: 7px; background: #fefefe;"></span>
      						<span style="display:block; width: 80%; float: left; height: 7px; background: #fefefe;"></span>
      					</div>
      					<div>
      						<span style="display:block; width: 20%; float: left; height: 20px; background: #f9fafc;"></span>
      						<span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7;"></span>
      					</div>
      				</a>
      				<p class="text-center no-margin" style="font-size: 12px">
      					<spring:message code="common.BlackLight"></spring:message>
      				</p>
      			</li>
      			<li style="float:left; width: 33.33333%; padding: 5px;">
      				<a class="clearfix full-opacity-hover" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" href="javascript:void(0);" data-skin="skin-purple-light">
      					<div>
      						<span class="bg-purple-active" style="display:block; width: 20%; float: left; height: 7px;"></span>
      						<span class="bg-purple" style="display:block; width: 80%; float: left; height: 7px;"></span>
      					</div>
      					<div>
      						<span style="display:block; width: 20%; float: left; height: 20px; background: #f9fafc;"></span>
      						<span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7;"></span>
      					</div>
      				</a>
      				<p class="text-center no-margin" style="font-size: 12px">
      					<spring:message code="common.PurpleLight"></spring:message>
      				</p>
      			</li>
      			<li style="float:left; width: 33.33333%; padding: 5px;">
      				<a class="clearfix full-opacity-hover" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" href="javascript:void(0);" data-skin="skin-green-light">
      					<div>
      						<span class="bg-green-active" style="display:block; width: 20%; float: left; height: 7px;"></span>
      						<span class="bg-green" style="display:block; width: 80%; float: left; height: 7px;"></span>
      					</div>
      					<div>
      						<span style="display:block; width: 20%; float: left; height: 20px; background: #f9fafc;"></span>
      						<span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7;"></span>
      					</div>
      				</a>
      				<p class="text-center no-margin" style="font-size: 12px">
						<spring:message code="common.GreenLight"></spring:message>
					</p>
      			</li>
      			<li style="float:left; width: 33.33333%; padding: 5px;">
      				<a class="clearfix full-opacity-hover" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" href="javascript:void(0);" data-skin="skin-red-light">
      					<div>
      						<span class="bg-red-active" style="display:block; width: 20%; float: left; height: 7px;"></span>
      						<span class="bg-red" style="display:block; width: 80%; float: left; height: 7px;"></span>
      					</div>
      					<div>
      						<span style="display:block; width: 20%; float: left; height: 20px; background: #f9fafc;"></span>
      						<span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7;"></span>
      					</div>
      				</a>
      				<p class="text-center no-margin" style="font-size: 12px">
      					<spring:message code="common.RedLight"></spring:message>
      				</p>
      			</li>
      			<li style="float:left; width: 33.33333%; padding: 5px;">
      				<a class="clearfix full-opacity-hover" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" href="javascript:void(0);" data-skin="skin-yellow-light">
      					<div>
      						<span class="bg-yellow-active" style="display:block; width: 20%; float: left; height: 7px;"></span>
      						<span class="bg-yellow" style="display:block; width: 80%; float: left; height: 7px;"></span>
      					</div>
      					<div>
      						<span style="display:block; width: 20%; float: left; height: 20px; background: #f9fafc;"></span>
      						<span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7;"></span>
      					</div>
      				</a>
      				<p class="text-center no-margin" style="font-size: 12px;">
      					<spring:message code="common.YellowLight"></spring:message>
      				</p>
      			</li>
      		</ul>
      	</div>
      </div>
      <!-- /.tab-pane -->
      <!-- Settings tab content -->
      <div class="tab-pane" id="control-sidebar-settings-tab">
        <form method="post">
          <h3 class="control-sidebar-heading">General Settings</h3>

          <div class="form-group">
            <label class="control-sidebar-subheading">
              Report panel usage
              <input type="checkbox" class="pull-right" checked>
            </label>

            <p>
              Some information about this general settings option
            </p>
          </div>
          <!-- /.form-group -->

          <div class="form-group">
            <label class="control-sidebar-subheading">
              Allow mail redirect
              <input type="checkbox" class="pull-right" checked>
            </label>

            <p>
              Other sets of options are available
            </p>
          </div>
          <!-- /.form-group -->

          <div class="form-group">
            <label class="control-sidebar-subheading">
              Expose author name in posts
              <input type="checkbox" class="pull-right" checked>
            </label>

            <p>
              Allow the user to show his name in blog posts
            </p>
          </div>
          <!-- /.form-group -->

          <h3 class="control-sidebar-heading">Chat Settings</h3>

          <div class="form-group">
            <label class="control-sidebar-subheading">
              Show me as online
              <input type="checkbox" class="pull-right" checked>
            </label>
          </div>
          <!-- /.form-group -->

          <div class="form-group">
            <label class="control-sidebar-subheading">
              Turn off notifications
              <input type="checkbox" class="pull-right">
            </label>
          </div>
          <!-- /.form-group -->

          <div class="form-group">
            <label class="control-sidebar-subheading">
              Delete chat history
              <a href="javascript:void(0)" class="text-red pull-right"><i class="fa fa-trash-o"></i></a>
            </label>
          </div>
          <!-- /.form-group -->
        </form>
      </div>
      <!-- /.tab-pane -->
    </div>
  </aside>
	<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>

</body>

</html>