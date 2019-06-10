<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"></h5>
</div>

<!-- Main content -->
<div class="modal-body">
	<div class="row">
		<div class="col-xs-12">
			<div class="dataTables_filter" id="appVersionRecordSearchDiv" style="text-align: left;" role="form">
				<div class="has-feedback form-group">
					<input placeholder='<spring:message code="app.devicerecord.please.select.the.application.name"/>' name="appName"
						class="form-control" type="search"
						title='<spring:message code="app.devicerecord.please.select.the.application.name"/>' style="width: 226.5px" />
				</div>
				<div class="has-feedback form-group">	
					<input placeholder='<spring:message code="app.devicerecord.please.enter.the.syste.version"/>' name="appVersion"
						class="form-control" type="search"
						title='<spring:message code="app.devicerecord.please.enter.the.syste.version"/>' style="width: 226.5px" />
				</div>
				<div class="btn-group">
					<button type="button" class="btn btn-primary"
						data-btn-type="search">
						<spring:message code="common.query" />
					</button>
					<button type="button" class="btn btn-default" data-btn-type="reset">
						<spring:message code="common.reset" />
					</button>
				</div>
			</div>
			<div class="box-body">
				<table id="appVersionRecord_table"
					class="table table-bordered table-striped ">
				</table>
			</div>

		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</div>

<script>
var appVersionRecordTable;
var appVersionRecordform = $("#appVersionRecordSearchDiv").form({baseEntity: false});
appVersionRecordform.initComponent();
	var appVersionRecordform,winId = "merWin";
	var config={
			singleSelect:null
	};
	$(function() {
		//init table and fill data
		
		var deviceSn = '${deviceSn}';
		
		appVersionRecordTable = new CommonTable("appVersionRecord_table", "appVersion_list", "appVersionRecordSearchDiv",
				"/appVersion/findAppVersionByDeviceSn?deviceSn=" + deviceSn,config);
		
	});
	
	function convertMb(size){
		
		var mSize = size / (1024 * 1024 * 1.0);
		if (mSize >= 1) {
			 return mSize.toFixed(2) + ' M';
		} else {
			mSize = size / (1024 * 1.0);
			if (mSize >= 1) {
				return mSize.toFixed(2) + 'K';
			} else {
				return size.toFixed(2) + 'B';
			}
		} 
	}
	
	function formatFileUrl(url){
		if (url == null || url == '') return '';
		var fileds = url.split("/");
	    if (fileds.length == 1 && url.indexOf("/") == -1){
	    	fileds = url.split("\\");
	    }
        return fileds[fileds.length - 1];
	}
	
	function operationUpgradeType(upgradeType, type, rowObj){
		var oper = "";
		if(upgradeType == '0'){
			oper += "<span>"+"<spring:message code='app.management.app.update' />"+"</span>";
		}else if(upgradeType == '1'){
			oper += "<span>"+"<spring:message code='app.management.app.uninstall' />"+"</span>";
		}else{
			oper += "<span>-</span>";
		}
        return oper;
	}
	
</script>

