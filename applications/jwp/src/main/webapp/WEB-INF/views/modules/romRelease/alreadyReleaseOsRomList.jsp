<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>


<!-- Main content -->
<div class="modal-body">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<div class="dataTables_filter" id="osRomSearchDiv">
					<div class="btn-group">
						<select name="manufacturerNo" id="manufacturerNo" onchange="manuFacturerChange()" data-flag="dictSelector"
						 data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>' class="form-control select2" style="width: 170px">
						  <option value=""></option>
						  <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
					      	 <option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
					      </c:forEach>
						</select>
					</div>					
					<div class="btn-group">
						<select name="osDeviceType" id="deviceTypeId" onchange="deviceTypeChange()"
						data-placeholder='<spring:message code="app.apprecord.please.select.the.device.type"/>' class="form-control select2" style="width: 170px;">
						   <option value=""><spring:message code="common.form.select"/></option>
						</select>
					</div>&nbsp;&nbsp;
				
				<div class="btn-group">
					<input
							placeholder='<spring:message code="modules.osrom.please.enter.the.system.version.number"/>' name="osVersion" class="form-control"
							type="search"/> 
					
					</div>
				
					<div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search"><spring:message code="common.query"/></button>
						&nbsp;&nbsp;
						<button type="button" class="btn btn-default"
							data-btn-type="reset"><spring:message code="common.reset"/></button>
					</div>
					
						<!-- <div class="btn-group">
							<button type="button" class="btn btn-success" data-btn-type="addBatchOsRom"><i class="fa fa-plus"></i>批量新增设备</button>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</div> -->
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

<script>
var osRomTable;
var osRomform = $("#osRomSearchDiv").form({baseEntity: false});
osRomform.initComponent();
	var osRomform,winId = "merWin";
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
			
		releaseAlreayVersion:function(rowId, osVersion, osDeviceType,cid){
			var title = cid+ ' ' + '<spring:message code="app.release.published"/>' + ' -【'+osVersion+'】';	
			modals.openWin({
				winId : winId,
				title : title,
				width : '1150px',
				url : basePath + "/osRom/releaseAlreadyEdition?id="+rowId+"&osDeviceType="+osDeviceType
			});
			
		}
	}
	
		function releaseOperation(id, type, rowObj){
		    var oper = "";
	        oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='merchantProcessDef.releaseAlreayVersion(\"" + id +"\",\"" + rowObj.osVersion +"\",\"" + rowObj.osDeviceType +"\",\"" + rowObj.clientIdentification +"\")'>"+'<spring:message code="app.release.published"/>'+"</a>";
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
