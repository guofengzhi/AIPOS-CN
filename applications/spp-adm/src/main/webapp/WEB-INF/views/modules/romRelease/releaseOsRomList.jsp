<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="#"><i class="fa fa-dashboard"></i>  <spring:message code="common.homepage"/></a></li>
		<li><a href="#"> <spring:message code="modules.rom.release.version.release.management"/></a></li>
		<li class="active"> <spring:message code="modules.record.rom.rom.release.list"/></li>
	</ol>
	<div class="col-md-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<div class="dataTables_filter" id="osRomSearchDiv">
				<div class="btn-group">
						<select name="manufacturerNo" id="manufacturerNo" onchange="manuFacturerChange()" data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>' class="form-control select2" style="width: 170px">
						   <option value=""></option>
						  <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
					      			<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
					      </c:forEach>
						</select>
					</div>
					
					<div class="btn-group">
						<select name="osDeviceType" id="deviceTypeId" onchange="deviceTypeChange()"
						 data-placeholder='<spring:message code="app.apprecord.please.select.the.device.type"/>' class="form-control select2" style="width: 170px;">
						   <option value=""></option>
						  
						</select>
					</div>&nbsp;&nbsp;
				
				<div class="btn-group">
					<input placeholder='<spring:message code="app.devicerecord.please.enter.the.syste.version"/>' name="osVersion" class="form-control"
							type="search" /> 
					</div>
				
					<div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search"><spring:message code="common.query"/></button>
						<button type="button" class="btn btn-default"
							data-btn-type="reset"><spring:message code="common.reset"/></button>
					</div>
				</div>
				<div class="box-body">
					<table id="osRom_table"
						class="table table-bordered table-striped ">
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
var osRomTable;
var osRomform = $("#osRomSearchDiv").form({baseEntity: false});
//releaseType 0:被动发布 1:主动发布
var releaseType = '${releaseType}';
osRomform.initComponent();
	var osRomform,merId = "merWin", releaseWinId = "releaseWinId", winId = "win";
	var config={
			singleSelect:null
	};
	$(function() {
		//init table and fill data
		
		osRomTable = new CommonTable("osRom_table", "osRom_list", "osRomSearchDiv",
				"/osRom/list",config);
		
		$('button[data-btn-type]').click(
				function() {
					var action = $(this).attr('data-btn-type');
					switch (action) {
					case 'addOsRom':
						merchantProcessDef.addOsRomInfo();
						break;
					case 'addBatchOsRom':{
						merchantProcessDef.addBatchOsRomInfo();
					}
					default:
						break;
					}

				});
		
	});
	
	var merchantProcessDef={
			//点选发布
			clickReleaseVersion:function(romId,osDeviceType,osVersion,clientIdentif){
				var title =clientIdentif;
				if (releaseType == '0') {
					title += '  ' + '<spring:message code="modules.rom.release.passive.release"/>' + '-【'+osVersion+'】';						
				} else {
					title += '  ' + '<spring:message code="modules.rom.release.active.release"/>' + '-【'+osVersion+'】';		
				}
				modals.openWin({
					winId : winId,
					title : title,
					width : '1150px' ,
					url : basePath + "/osRom/releaseNoEdition?id="+romId+"&releaseType=" + releaseType  
				});
			}
		}
	
		function releaseOperation(id, type, rowObj){
		    var oper = "";
			oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='merchantProcessDef.clickReleaseVersion(\"" + id +"\",\"" + rowObj.osDeviceType +"\",\"" + rowObj.osVersion +"\",\"" + rowObj.clientIdentification +"\")'>"+'<spring:message code="modules.rom.release.release"/>'+"</a>";
	        return oper;
		}
	
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
	
</script>

