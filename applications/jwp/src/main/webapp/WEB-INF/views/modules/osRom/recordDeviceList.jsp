<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="app.apprecord.a.list.of.published.devices"/></h5>
</div>

<!-- Main content -->
<div class="modal-body">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<div class="dataTables_filter" id="recordDeviceSearchDiv">
					<div class="btn-group">
					<input
							placeholder='<spring:message code="app.apprecord.please.enter.the.device.sn.number"/>' id="recordDeviceSn" name="recordDeviceSn" class="form-control"
							type="search"/> 
					
						 <input
							placeholder='<spring:message code="modules.device.please.enter.the.name.of.the.device.type"/>' id="recordDeviceType" name="recordDeviceType" class="form-control"
							type="search"/> &nbsp;&nbsp;
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
					<table id="recordDevice_table"
						class="table table-bordered table-striped table-hover">
						
						
					</table>
				</div>
				
				<!-- /.box-body -->
			</div>
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</div>

<script>
var recordDeviceform = $("#recordDeviceSearchDiv").form({baseEntity: false});
recordDeviceform.initComponent();
	var recordDeviceTable,winId = "merWin";
	var config={
			singleSelect:null
	};
	$(function() {
		var osrecordDeviceType = '${osrecordDeviceType}';
		var osRomId = '${osRomId}';
		//init table and fill data
		recordDeviceTable = new CommonTable("recordDevice_table", "already_recordDevice_list", "recordDeviceSearchDiv",
				"/recordRom/getrecordDeviceList?id=" + osRomId, config);
		
	})
	
	function operation(id){
		
	}
	
	
</script>

