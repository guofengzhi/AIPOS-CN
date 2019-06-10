<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>

<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="#"><i class="fa fa-dashboard"></i> <spring:message code="common.homepage"/></a></li>
		<li><a href="#"><spring:message code="modules.osrom.system.version.management"/></a></li>
		<li class="active"><spring:message code="modules.osrom.system.version.list"/></li>
	</ol>
	<div class="col-md-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<div class="dataTables_filter" id="osRomSearchDiv" style="text-align: left;" role="form">
					<div class="has-feedback form-group">
						<select name="manufacturerNo" id="manufacturerNo" onchange="manuFacturerChange()" data-flag="dictSelector"
						 data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>' class="form-control select2" style="width: 226.5px;margin-left: 0px;">
						   <option value=""></option>
						  <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
					      			<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
					      </c:forEach>
						</select>
					</div>
					
					<div class="has-feedback form-group">
						<select name="osDeviceType" id="deviceTypeId" onchange="deviceTypeChange()"
						 data-placeholder='<spring:message code="app.apprecord.please.select.the.device.type"/>' class="form-control select2" style="width: 226.5px;margin-left: 0px;">
						   <option value=""><spring:message code="common.form.select"/></option>
						</select>
					</div>
				
					<div class="has-feedback form-group">
					<input placeholder='<spring:message code="modules.device.please.enter.the.name.of.the.device.type"/>' name="osVersion" class="form-control" style="width: 226.5px;margin-left: 0px;"
							type="search"/> 
					
					</div>
						<div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search"><spring:message code="common.query"/></button>
						<button type="button" class="btn btn-default"
							data-btn-type="reset"><spring:message code="common.reset"/></button>
					</div>
					<div style="width:100%;margin-top:5px;">
						<shiro:hasPermission name="osrom:edit">
							<%-- <button type="button" class="btn btn-success" data-btn-type="addOsRom"><i class="fa fa-plus"></i><spring:message code="modules.osrom.add.version.information"/></button> --%>
							<button data-btn-type="addOsRom" class="btn btn-default" style="float: right;"
								title="新增" type="button">
								<i class="fa fa-plus"></i>
							</button>
						</shiro:hasPermission>
					</div>
				</div>
				<div class="box-body">
					<table id="osRom_table"
						class="table table-bordered table-bg table-striped table-hover" style="margin-top:0px !important;">
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
osRomform.initComponent();
	var osRomform,winId = "osRomWin";
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
		
			getRomInfo:function(id){
				modals.openWin({
					winId : winId,
					title : '<spring:message code="modules.osrom.version.information.view"/>',
					width : '900px',
					url : basePath + "/osRom/form/add?id=" + id
				});
			},
			deleteVersion:function(id){
				
				modals.confirm('<spring:message code="modules.osrom.you.are.sure.to.delete.this.device"/>', function() {
					
					//Save Data，对应'submit-提交'
					 var params = {};
					 params["id"] = id;
						 ajaxPost(basePath+'/osRom/delete', params, function(data, status) {
						 if(data.code == 200){
							//新增 
							modals.correct(data.message);
							modals.hideWin(winId);	
							osRomTable.reloadRowData();
						 }else{
						 	modals.warn(data.message);
						 }				 
					}); 
				
			});
		},
		addOsRomInfo:function(rowId){
			
			modals.openWin({
				winId : winId,
				title : '<spring:message code="modules.osrom.add.system.version"/>',
				width : '900px',
				backdrop:'static',
				url : basePath + "/osRom/form/add"
			});
		}
	}
	
		function releaseOperation(id, type, rowObj){
			var oper = "";
			oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='merchantProcessDef.getRomInfo(\"" + id +"\")'>"+'<spring:message code="sys.role.view"/>'+"</a>";
			oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='merchantProcessDef.deleteVersion(\"" + id +"\")'>"+'<spring:message code="common.delete"/>'+"</a>";
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

