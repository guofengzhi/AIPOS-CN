<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb"> 
		<li><a href="#"><i class="fa fa-dashboard"></i> <spring:message code="common.homepage"/></a></li>
		<li><a href="#"> <spring:message code="modules.device.system.version.device.number.list"/></a></li>
		<li class="active"><spring:message code="modules.device.system.version.number.list"/></li>
	</ol>
	<div class="col-md-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div class="dataTables_filter" id="deviceSearchDiv">
					
					<div class="btn-group">
					<input
							placeholder='<spring:message code="app.devicerecord.please.enter.the.syste.version"/>' id="deviceOsVersion" name="deviceOsVersion" class="form-control"
							type="search"/> 
					</div>
					
					<div class="btn-group">
						<select name="clientIdentification" id="clientIdentification"  data-placeholder='<spring:message code="app.version.please.select.the.customer.identity"/>' class="form-control select2" style="width: 170px">
						   <option value=""></option>
						  <c:forEach items="${clientIdentifyList}" var="clientIdentify" varStatus="idxStatus">
					      			<option value="${clientIdentify.value}">${clientIdentify.label }</option>
					      </c:forEach>
						</select>
					</div>
					
					<div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search"><spring:message code="common.query"/></button>
						&nbsp;&nbsp;
						<button type="button" class="btn btn-default"
							data-btn-type="reset"><spring:message code="common.reset"/></button>
					</div>
						
				</div>
				<div class="box-body">
					<table id="device_table"
						class="table table-bordered table-striped table-hover">
					</table>
				</div>
				<!-- /.box-body -->
			</div>
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</section>

<script>
var deviceform = $("#deviceSearchDiv").form({baseEntity: false});
deviceform.initComponent();
	var deviceTable,winId = "deviceWin";
	var config={
			singleSelect:null
	};
	$(function() {
		//init table and fill data
		deviceTable = new CommonTable("device_table", "rom_device_count_list", "deviceSearchDiv",
				"/device/romDeviceCount",config);
	})
	
</script>

