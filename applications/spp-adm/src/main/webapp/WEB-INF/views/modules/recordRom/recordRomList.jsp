<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>

<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i> <spring:message code="common.homepage"/></a></li>
		<li><a href="#"><spring:message code="modules.record.rom.rom.release"/></a></li>
		<li class="active"><spring:message code="modules.record.rom.rom.release.list"/></li>
	</ol>
	<div class="col-xs-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div>&nbsp;</div>
				<div class="form-horizontal" id="recordRomSearchDiv">
				
					<div class="form-group" style="margin: 1em;">
		
						<label class="col-sm-2 control-label"><spring:message code="modules.device.manufacturer"/></label>
						<div class="col-sm-3">
							<select name="manufacturerNo" id="manufacturerNo" onchange="manuFacturerChange()" data-flag="dictSelector"
							data-blank="true" data-code="agent_user_type" data-value="value" data-text="label"
							data-placeholder='<spring:message code="common.form.select"/>' class="form-control select2" style="width: 100%;">
							   <option value=""></option>
							  <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
						      			<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
						      </c:forEach>
							</select>
						</div>
						
						<label class="col-sm-2 control-label"><spring:message code="ota.table.device.type"/></label>
						<div class="col-sm-3">
							<select name="osDeviceType" id="deviceTypeId" onchange="deviceTypeChange()" data-flag="dictSelector"
							data-blank="true" data-code="agent_user_type" data-value="value" data-text="label"
							data-placeholder='<spring:message code="common.form.select"/>' class="form-control select2" style="width: 100%;">
							   <option value=""></option>
							
							</select>
						</div>
						
					</div>
				
					<div class="form-group" style="margin: 1em;">
						<label class="col-sm-2 control-label"><spring:message code="app.apprecord.start.the.release.time"/></label>
						<div class="col-sm-3">
							<div class="input-group date">
								<div class="input-group-addon">
									<i class="fa fa-calendar"></i>
								</div>
								<input class="form-control pull-right" id="beginDate"
									type="text" name="beginDate" placeholder='<spring:message code="sys.log.beginTime"/>'
									data-flag="datepicker" />
							</div>
						</div>
						
						<label class="col-sm-2 control-label" for="endDate"><spring:message code="app.apprecord.end.the.release.time"/></label>
						<div class="col-sm-3">
						<div class="input-group date">
							<div class="input-group-addon">
								<i class="fa fa-calendar"></i>
							</div>
							<input class="form-control pull-right" id="endDate" type="text"
								name="endDate" placeholder='<spring:message code="sys.log.endTime"/>' data-flag="datepicker" />
						</div>
					</div>
						
					</div>
					
					<div class="form-group" style="margin: 1em;">
							<label class="col-sm-2 control-label" for="osVersion"><spring:message code="modules.osrom.system.version.number"/></label>
						<div class="col-sm-3">
							
						<input
							placeholder='<spring:message code="app.apprecord.please.enter.the.version.number"/>' id="osVersion" name="osVersion" class="form-control"
							type="search" /> 
						</div>
							<label class="col-sm-2 control-label" for="deviceCount"><spring:message code="ota.table.device.count"/></label>
						<div class="col-sm-3">
							
						<input
							placeholder='<spring:message code="ota.table.device.count"/>' id="deviceCount" name="deviceCount" class="form-control"
							type="search" /> 
						</div>
					</div>
				
					<div class="box-footer">
						<div class="text-center">
							<button type="button" class="btn btn-primary"
								data-btn-type="search"><spring:message code="common.query"/></button>
							&nbsp; &nbsp;
							<button type="button" class="btn btn-default"
								data-btn-type="reset"><spring:message code="common.reset"/></button>
						</div>
					</div>
				</div>
				<div class="box-body">
					<table id="recordRom_table"
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
var form = $("#recordRomSearchDiv").form({baseEntity: false});
    form.initComponent();
    var config={
			singleSelect:null
	};
		//tableId,queryId,conditionContainer
		var recordRomTable;
		var winId = "recordRomWin";
		$(function() {
			$("#recordRomSearchDiv").bootstrapValidator({
				message : '<spring:message code="common.promt.value"/>',
				feedbackIcons : {
					valid : 'glyphicon glyphicon-ok',
					invalid : 'glyphicon glyphicon-remove',
					validating : 'glyphicon glyphicon-refresh'
				},
				fields : {
					beginDate : {
						validators : {
							date : {  
			                    format : 'YYYY-MM-DD',  
			                    message : '<spring:message code="sys.log.tip.tiemFromatIncorrect"/>'  
			                },
			                callback: {
								message: '<spring:message code="sys.log.tip.beginTimeTooBig"/>',
								callback:function(value, validator,$field,options){
									var end = $("input[name='endDate']").val();
									if(value == "" && end == ""){
										return true;
									}else {
										value = new Date(value).getTime();
										end = new Date(end).getTime();
										return parseInt(value)<=parseInt(end);
									}
									
								}
							}
						}
					},
					endDate : {
						validators : {
							date : {  
			                    format : 'YYYY-MM-DD',  
			                    message : '<spring:message code="sys.log.tip.tiemFromatIncorrect"/>'  
			                } ,
			                callback: {
								message: '<spring:message code="sys.log.tip.endTimeTooSmall"/>',
								callback:function(value, validator,$field){
									var begin = $("input[name='beginDate']").val();
									$("input[name='beginDate']").keypress();
									if(value == "" && begin==""){
										return true;
									}else{
										value = new Date(value).getTime();
										begin = new Date(begin).getTime();
										validator.updateStatus('beginDate', 'VALID');
										return parseInt(value)>=parseInt(begin);	
									}
										
								}
							}
						}
					}
				}
			}).on('success.form.fv', function(e) {
			    e.preventDefault();
			});
			
			//init table and fill data
			recordRomTable = new CommonTable("recordRom_table", "recordRom_list", "recordRomSearchDiv",
					"/recordRom/list",config);
	});
		
	var deviceProcessDef={
			RealeaseVersion:function(id, osDeviceType){
				modals.openWin({
					winId : winId,
					title : '<spring:message code="app.apprecord.a.list.of.published.devices"/>',
					width : '1150px',
					url : basePath + "/recordRom/alreadyRomList?id="+id
				});
			}
	}
	
	function operation(id, type, rowObj){
			var oper = "";
			oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.RealeaseVersion(\"" + id +"\",\"" + rowObj.osDeviceType +"\" )'>"+'<spring:message code="sys.role.view"/>'+"</a>";
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
	
</script>
