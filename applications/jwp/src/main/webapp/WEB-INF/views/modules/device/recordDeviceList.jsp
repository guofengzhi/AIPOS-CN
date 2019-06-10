<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div class="dataTables_filter" id="deviceSearchDiv">
					
						<div class="btn-group">
							<select name="manufacturerNo" id="manufacturerNo" onchange="manuFacturerChange()" data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>' class="form-control select2" style="width: 170px">
							   <option value=""></option>
							  <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
						      			<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
						      </c:forEach>
							</select>
						</div>&nbsp;&nbsp;
						
						<div class="btn-group">
							<select name="deviceType" id="deviceTypeId" onchange="deviceTypeChange()"
							data-placeholder='<spring:message code="app.apprecord.please.select.the.device.type"/>'' class="form-control select2" style="width: 170px;">
							   <option value=""><spring:message code="common.form.select"/></option>
							
							</select>
						</div>&nbsp;&nbsp;
					
					<div class="btn-group">
					<input
							placeholder='<spring:message code="app.apprecord.please.enter.the.device.sn.number"/>' id="deviceSn" name="deviceSn" class="form-control"
							type="search" title='<spring:message code="app.apprecord.please.enter.the.device.sn.number"/>' /> 
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
		deviceTable = new CommonTable("device_table", "record_device_list", "deviceSearchDiv",
				"/device/list",config);
		
		$('button[data-btn-type]').click(
				function() {
					var action = $(this).attr('data-btn-type');
					switch (action) {
					case 'addDevice':
						deviceProcessDef.addDeviceInfo()
						break;
					case 'addBatchDevice':{
						deviceProcessDef.addBatchDeviceInfo();
						break;
					}
					default:
						break;
					}
				});
	})
	
	var deviceProcessDef={
		recordDevice:function(id){
			modals.openWin({
				winId : winId,
				title : '<spring:message code="app.devicerecord.look.at.the.history.of.the.device.update"/>',
				width : '900px',
				url : basePath + "/osRom/deviceRomIndex?id=" + id
			});
		}
	}
	
	
	function operation(id, type, rowObj){
		var oper = "&nbsp;&nbsp;&nbsp;";
		oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.recordDevice(\"" + id +"\")'>"+'<spring:message code="sys.role.view"/>'+"</a>";
        return oper;
	}
	
</script>

