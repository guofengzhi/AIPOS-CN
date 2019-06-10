<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<spring:message code="app.release.manufacturer" var="manufacturer"/>
<spring:message code="modules.osrom.upgrade.the.start.version" var="startVersion"/>
<spring:message code="modules.osrom.rom.file.md5.value" var="md5Value"/>
<spring:message code="modules.osrom.rom.package.file.size" var="romFileSize"/>
<spring:message code="app.version.start.the.hardware.version" var="startHardVersion"/>
<spring:message code="app.version.end.the.hardware.version" var="endHardVersion"/>
<spring:message code="modules.osrom.system.version.number" var="systemVersionNumber"/>
<spring:message code="modules.osrom.system.device.type" var="systemDeviceType"/>
<spring:message code="modules.osrom.upgrade.the.end.version" var="upgradeEndVersion"/>
<spring:message code="modules.osrom.rom.file.md5.acknowledgement.value" var="md5AcknowledgementValue"/>
<spring:message code="ota.table.client.identification" var="clientIdentification"/>
<spring:message code="modules.osrom.system.package.type" var="systemPackageType"/>
<spring:message code="modules.osrom.full.package" var="fullPackage"/>
<spring:message code="modules.osrom.differential.package" var="differentialPackage"/>
<spring:message code="modules.osrom.system.update.information.description" var="updateInformationDescription"/>


<!-- Content Header (Page header) -->
<div class="modal-header modalsbg" id="titleDiv">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="modules.osrom.view.the.system.version"/></h5>
</div>

<div class="modal-body">
	<form:form id="rom-form" name="rom-form" modelAttribute="osRomInfo"
		class="form-horizontal">
		 <form:hidden path="id" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'>
		<form:input path="manufacturerNo" type="hidden" id="manufacturerNoId"  />
		<div class="box-body">
			<div class="col-md-6">
				<div class="form-group">
					<label for="manufacturerNo" class="col-sm-4 control-label">${manufacturer }</label>
					<div class="col-sm-8">
					    <input  id="manufacturerName" value="${manufacturerName }" readonly="true"  htmlEscape="false" maxlength="50" class="form-control" placeholder="${manufacturer }"/>
					</div>
					
				</div>
				<div class="form-group">
					<label for="osStart" class="col-sm-4 control-label">${startVersion }</label>
					<div class="col-sm-8">
					    <form:input path="osStart" id="osStartId" readonly="true" value="${romInfo.osStart }" htmlEscape="false" maxlength="50" class="form-control" placeholder="${startVersion }"/>
					</div>
				</div>
				<div class="form-group">
					<label for="romHash" class="col-sm-4 control-label">${md5Value }<span style="color:red">*</span></label>
					<div class="col-sm-8">
					    <form:input path="romHash" id="romHash" readonly="true"  htmlEscape="false" maxlength="50" class="form-control"  placeholder="${md5Value }"/>
					</div>	
				</div>
				<div class="form-group">
					<form:input path="romFileSize" type="hidden" readonly="true" id="romFileSize" htmlEscape="false" maxlength="50" class="form-control" />
					<label for="romFileSize" class="col-sm-4 control-label">${romFileSize }</label>
					<div class="col-sm-8">
					    <input readonly="true" id="romFileSizeMB" htmlEscape="false" maxlength="50" class="form-control"/>
					</div>
				</div>
				<div class="form-group">
					<label for="startHard" class="col-sm-4 control-label">${startHardVersion }</label>
					<div class="col-sm-8">
					    <form:input path="startHard" id="startHard" value="${romInfo.startHard }" htmlEscape="false" maxlength="50" class="form-control" placeholder="${startHardVersion }"/>
					</div>
				</div>
				<div class="form-group">
					<label for="osVersion" class="col-sm-4 control-label">${systemVersionNumber }<span style="color:red">*</span></label>
					<div class="col-sm-8">
					    <form:input path="osVersion" id="osVersion" htmlEscape="false" maxlength="50" class="form-control" placeholder="${systemVersionNumber }"/>
					</div>
				</div>	
			</div>
			
			<div class="col-md-6">
				<div class="form-group">
				  <label for="osDeviceType" class="col-sm-4 control-label">${systemDeviceType }</label>
					<div class="col-sm-8">
					    <form:input path="osDeviceType" readonly="true" id="osDeviceType" value="${romInfo.osDeviceType }" htmlEscape="false" maxlength="50" class="form-control" placeholder="${systemDeviceType }"/>
					</div>
				</div>				
				<div class="form-group">
				<label for="osEnd" class="col-sm-4 control-label">${upgradeEndVersion }</label>
					<div class="col-sm-8">
					    <form:input path="osEnd" id="osEndId" readonly="true" value="${romInfo.osEnd }" htmlEscape="false" maxlength="50" class="form-control" placeholder="${upgradeEndVersion }"/>
					</div>
				</div>
				<div class="form-group">
				  <label for="reRomHash" id="reRomHashLabel" class="col-sm-4 control-label">${md5AcknowledgementValue }<span style="color:red">*</span></label>
					<div class="col-sm-8">
					    <input name="reRomHash" id="reRomHash" htmlEscape="false" maxlength="50" class="form-control"  placeholder="${md5AcknowledgementValue }"/>
					</div>
				</div>
				<div class="form-group">
				  <label for="clientIdentification" class="col-sm-4 control-label">${clientIdentification }</label>
					<div class="col-sm-8">
						<form:select path="clientIdentification" style="width:233px" id="clientIdentification"  data-placeholder="${clientIdentification }" class="form-control select2">
						   <form:option value=""></form:option>
						  <c:forEach items="${clientIdentifyList}" var="clientIdentify" varStatus="idxStatus">
					      			<form:option value="${clientIdentify.value}">${clientIdentify.label }</form:option>
					      </c:forEach>
						</form:select>
					</div>
				</div>
				<div class="form-group">
					<label for="endHard" class="col-sm-4 control-label">${endHardVersion }<span style="color:red">*</span></label>
					<div class="col-sm-8">
					    <form:input path="endHard" id="endHard" value="${romInfo.endHard }" htmlEscape="false" maxlength="50" class="form-control" placeholder="${endHardVersion }"/>
					</div>
				</div>
				<div class="form-group">
					<label for="osPacketType" class="col-sm-4 control-label">${systemPackageType }<span style="color:red">*</span></label>
					<div class="col-sm-8">
						<form:select path="osPacketType"  data-placeholder="${systemPackageType }" class="form-control select2" style="width: 100%;">
							<form:option value=""></form:option>
							<form:option value="0">${fullPackage }</form:option>
							<form:option value="1">${differentialPackage }</form:option>
						</form:select>
					</div>
				</div>
				</div>
			<div class="col-md-12">
			<div class="form-group">
					<label for="description" class="col-sm-2 control-label">${updateInformationDescription }<span style="color:red">*</span></label>
					<div class="col-sm-10">
						<form:textarea path="description" class="form-control"
							htmlEscape="false" rows="3" maxlength="250" placeholder="${updateInformationDescription }" />
					</div>
				</div>
			</div>
			
		</div>
		<!-- /.box-body -->
		<div class="box-footer text-right" id="submitDiv">
			<!--以下两种方式提交验证,根据所需选择-->
			<button type="button" class="btn btn-default" data-btn-type="cancel"
				data-dismiss="modal"><spring:message code="common.cancel"/></button>
			 <button type="submit" class="btn btn-primary" id="submitBtn" data-btn-type="save"><spring:message code="common.submit"/></button>
		</div>
		
		<!-- /.box-footer -->
	</form:form>
	

</div>
<script>
//tableId,queryId,conditionContainer
var romform = null;
var id="${empty osRomInfo.id?0:osRomInfo.id}";
$(".select2").select2();

$(function() {
	romform=$("#rom-form").form();
	//数据校验
	$("#rom-form").bootstrapValidator({
		message : '<spring:message code="common.promt.value"/>',
		feedbackIcons : {
			valid : 'glyphicon glyphicon-ok',
			invalid : 'glyphicon glyphicon-remove',
			validating : 'glyphicon glyphicon-refresh'
		},
		fields : {
			osVersion : {
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.osrom.please.enter.the.system.version.number"/>'
					},
					regexp :{
						regexp : /(v|V)(?:(\d+)\.)?(?:(\d+)\.)?(\*|\d+)/,
						message : '<spring:message code="modules.osrom.the.format.of.the.version.number.is.not.correct.please.fill.it.out.again"/>'
					}
					
				}
			},
			osDeviceType : {
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.device.please.enter.the.name.of.the.device.type"/>'
					}
				}
			},
			clientIdentification : {
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.osrom.please.enter.the.customer.identity"/>'
					}
				}
			},
			romHash : {
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.osrom.please.enter.the.md5.check.value"/>'
					}
				}
			},
			reRomHash : {
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.osrom.please.enter.the.system.version.hash.confirmation.value"/>'
					},
					identical: {
						field: 'romHash',
						message: '<spring:message code="modules.osrom.the.system.version.hash.value.must.be.the.same.as.the.hash.acknowledgement.value"/>'
					 }
				}
			},
			description : {
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.osrom.please.enter.the.system.information.description"/>'
					}
				}
			},
			osPacketType : {
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.osrom.please.select.the.system.package.type"/>'
					}
				}
			},
			startHard:{
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.osrom.start.the.hardware.version.number.is.not.empty"/>'
					},
					regexp :{
						regexp : /(v|V)(?:(\d+)\.)?(?:(\d+)\.)?(\*|\d+)/,
						message : '<spring:message code="modules.osrom.the.format.of.the.version.number.is.not.correct.please.fill.it.out.again"/>'
					}
				}
			},
			endHard : {
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.osrom.please.fill.in.the.end.of.the.hardware.version.number"/>'
					},
					regexp :{
						regexp : /(v|V)(?:(\d+)\.)?(?:(\d+)\.)?(\*|\d+)/,
						message : '<spring:message code="modules.osrom.the.format.of.the.version.number.is.not.correct.please.fill.it.out.again"/>'
					}
				}
			}
		}
	}).on("success.form.bv",function(e){
		    e.preventDefault();
		    var filePath = $('#filePathId').val();
			if(filePath==""){
				modals.info('<spring:message code="modules.osrom.please.save.the.package.first"/>');
				return false;
			}else{
				modals.confirm('<spring:message code="common.confirm.save"/>', function() {
					//Save Data，对应'submit-提交'
					 var params = romform.getFormSimpleData();
					 params['romPath'] = filePath;
					ajaxPost(basePath+'/osRom/save', params, function(data, status) {
						if(data.code == 200){
							//新增 
							modals.correct(data.message);
							modals.hideWin(winId);	
							osRomTable.reloadRowData();
						}else{
							modals.info(data.message);
						}				 
					}); 
				});
			}
	});
	//初始化控件
});

function deviceTypeChange(){
	
	 var manufacturerNo = $("#manufacturerNoId456").val();
	 if(manufacturerNo == ''){
		 alert('<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>');
	 	 $("#deviceTypeId").empty();
	 }
	
}

function manuFacturerChange(){
	 var params = {};
	 var manufacturerNo = $("#manufacturerNoId456").val();
	 params['manufacturerNo'] = manufacturerNo;
	 ajaxPost(basePath+'/deviceType/getDeviceTypeByManuNo', params, function(data, status) {
			
			if(data.code == 200){
				var deviceTypes = data.data;
				$("#deviceTypeId").empty();
				
			 	 for(var i=0;i<deviceTypes.length;i++){
					
				    $("#deviceTypeId").append("<option value=\""+deviceTypes[i].deviceType+"\">"+deviceTypes[i].deviceType+"</ooption>");
				} 
				
			}else{
				modals.warn(data.message);
			}			
	 });
}

function getRomFileSize(size){

	var romFileSize = size / (1.0 * 1024 * 1024);
	var romSize = '';
	if (romFileSize >= 1) {
		  romSize = romFileSize.toFixed(2) + ' M';
	} else {
		  romSize = romFileSize = size / (1024 * 1.0);
		if (romFileSize >= 1) {
			romSize = romFileSize.toFixed(2) + 'K';
		} else {
			romSize = size.toFixed(2) + 'B';
		}
	} 
	return romSize;
}

function resetromForm(){
	romform.clearForm();
	$("#rom-form").data('bootstrapValidator').resetForm();
}
var romFileSize = '${osRomInfo.romFileSize}';
var romId = '${osRomInfo.id}';

if (romId != null && romId != '') {
	$("#submitBtn").remove();
	$("#reRomHash").remove();
	$("#reRomHashLabel").remove();
	$("#romFileSizeMB").val(getRomFileSize(romFileSize));
}else {
	$("#titleDiv").remove();
}


</script>
