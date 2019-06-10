<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<spring:message code="app.apprecord.please.select.the.equipment.manufacturer" var="selectManufacturer"/>
<spring:message code="ota.table.device.type" var="selectDeviceType"/>
<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
				<div class="nav-tabs-custom">
					<ul class="nav nav-tabs pull-right">
						<li><a href="#tab-content-edit" data-toggle="tab"
							id="nav-tab-edit"><i class="fa fa-edit"></i></a></li>
						<li class="active"><a href="#tab-content-list"
							data-toggle="tab" id="nav-tab-list"><i class="fa fa-list-ul"></i></a></li>
						<li class=" header"><i class="fa-hourglass-half "></i><small><spring:message
									code="ota.table.device.type.list"></spring:message></small></li>
					</ul>
					<div class="tab-content">
						<div class="tab-pane active" id="tab-content-list">
							<div class="box">
								<!-- /.box-header -->
								<div class="dataTables_filter" id="deviceTypeSearchDiv" style="text-align: left;" role="form">
									 <div class="form-group dataTables_filter " style="margin: 1em;">
										  	<select style="height:36px;width: 226.5px;"  name="manufacturerNo" id="manufacturerNo" onchange="manuFacturerChange()" data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>' class="form-control select2" style="width: 170px">
												   <option value=""></option>
												   <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
											      			<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
											       </c:forEach>
											</select>
											<select style="height:36px;width: 226.5px;" name="deviceType" id="deviceTypeId"  onchange="deviceTypeChange()"
												  data-placeholder='<spring:message code="app.apprecord.please.select.the.device.type"/>' class="form-control select2" style="width: 170px;">
												   <option value=""><spring:message code="common.form.select"/></option>
												 
											</select>
											<button type="button" class="btn btn-primary" style="height:37px;"
											 		data-btn-type="search"><spring:message code="common.query"/></button>
									  	 	<button type="button" class="btn btn-default" style="height:37px;"
													data-btn-type="reset"><spring:message code="common.reset"/></button>
											<shiro:hasPermission name="device:type:edit">
												<button type="button" class="btn btn-default" style="height:37px;"
														data-btn-type=delete title="<spring:message code = 'common.delete' />">
														<i class="fa fa-remove"></i>
												</button>
												<button data-btn-type="edit" class="btn btn-default" style="height:37px;"
														title="<spring:message code = 'common.edit' />" type="button">
														<i class="fa fa-edit"></i>
												</button>
												<button data-btn-type="add" class="btn btn-default" style="height:37px;"
														title="<spring:message code = 'common.add' />" type="button">
													<i class="fa fa-plus"></i>
												</button>
											</shiro:hasPermission>
										  </div>
								</div>
								<div class="box-body">
									<table id="deviceType_table"
										class="table table-bordered table-striped table-hover" style="margin-top:0px !important;">
									</table>
								</div>
								<!-- /.box-body -->
							</div>
						</div>
						<div class="tab-pane" id="tab-content-edit">
							<form:form id="deviceType-form" name="deviceType-form" modelAttribute="deviceType" class="form-horizontal" >
									 <form:hidden path="id" value="${deviceType.id }" />
									 <input type='hidden' value='${CSRFToken}' id='csrftoken'>
									 <input type="hidden" id="addOrUpdate" value="" />
									<div class="box-body">
										<div class="col-md-12">
											<div class="form-group">
												<label for="manufacturerNo" class="col-sm-2 control-label"><spring:message code="app.release.manufacturer"/><span style="color:red">*</label>
												<div class="col-sm-9">
												<input  type="hidden" id="oldmanufacturerNo" name="manufacturerNo" value="${manuFacturer.manufacturerNo}"/>
													<form:select path="manufacturerNo" id="manufacturerNoAdd" data-placeholder="${selectManufacturer }" class="form-control select2" style="width: 100%;">
														  <form:option value=""></form:option>
														  <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
													      		<form:option value="${manuFacturer.manufacturerNo }">${manuFacturer.manufacturerName }</form:option>
													      </c:forEach> 
													</form:select>
												</div>
											</div>
											<div class="form-group">
												<label for="deviceType" class="col-sm-2 control-label">${selectDeviceType }<span style="color:red">*</span></label>
												<div class="col-sm-9">
													<input  type="hidden" id="oldDeviceType"  name="deviceType" value="${deviceType.deviceType}"/>
												    <form:input path="deviceType"  name="deviceType" value="${deviceType.deviceType }" htmlEscape="false" maxlength="50"  class="form-control" placeholder="${selectDeviceType }"/>
												</div>
											</div>
										</div>
									</div>
									<!-- /.box-body -->
									<div class="box-footer text-right">
										<button type="button" class="btn btn-default" data-btn-type="cancel"
											data-dismiss="modal"><spring:message code="common.cancel"/></button>
										 <button type="submit" class="btn btn-primary" data-btn-type="save"><spring:message code="common.submit"/></button>
									</div>
								</form:form>
						</div>
					</div>
				</div>
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</section>

<script>
function setTitle(title) {
	$("ul.nav-tabs li.header small").text(title);
}
var form = $("#deviceTypeSearchDiv").form({baseEntity: false});
    form.initComponent();
	//tableId,queryId,conditionContainer
	var deviceTypeTable;
	var winId = "deviceTypeWin";
	var dataForm=null;
	$(function() {
		 dataForm=$("#deviceType-form").form();
		 //编辑区域点击事件
		 $("#nav-tab-edit").click(function(){
				dataForm.clearForm();

		 });
		 $("#nav-tab-list").click(function(){
			  setTitle("<spring:message code="ota.table.device.type.list"/>");
		 });
		
		//设置心新增修改参数为新增
		$("#addOrUpdate").val("add");
		//查询框是否在一行设置
		var config = {
			resizeSearchDiv : false,
			language : {
				url : basePath + '<spring:message code="common.language"/>'
			}
		};
		//init table and fill data
		deviceTypeTable = new CommonTable("deviceType_table", "deviceType_list", "deviceTypeSearchDiv",
				"/deviceType/list",config);

		//button event
		$('button[data-btn-type]')
				.click(function() {
							var action = $(this).attr('data-btn-type');
							var rowId = deviceTypeTable.getSelectedRowId();
							switch (action) {
							case 'add':
								setTitle('<spring:message code="modules.device.type.add.type.of.device"/>');//设置界面显示信息
								$("#nav-tab-edit").click();
								dataForm.clearForm();//清空文本框数据
								$("#addOrUpdate").val("add");
								break;
							case 'reset':
								 $("#deviceTypeId").select2("val", " "); 
								break;
							case 'edit':
								if (!rowId) {
									modals.info('<spring:message code="common.promt.edit"/>');
									return false;
								}
								setTitle("<spring:message code="modules.device.type.edit.type.of.device"/>");
								$("#nav-tab-edit").click();
								$("#addOrUpdate").val("update");
								ajaxPost(basePath+"/deviceType/DeviceEditOrAdd?id="+rowId, null, function(data) {
											//重置
											dataForm.clearForm();
											//赋值
											dataForm.initFormData(data);
								});
								break;
							case 'delete':
								if (!rowId) {
									modals.info('<spring:message code="app.appinfo.please.select.the.lines.to.be.edited"/>');
									return false;
								}
								modals
										.confirm(
												'<spring:message code="app.appinfo.do.you.want.to.delete.the.row.data"/>',
												function() {
													ajaxPost(
															basePath
																	+ "/deviceType/delete?id="
																	+ rowId,
															null,
															function(data) {
																
																if (data.code == 200) {
																	modals.correct('<spring:message code="app.appinfo.the.data.has.been.deleted"/>');
																	deviceTypeTable
																			.reloadRowData();
																} else {
																	modals
																			.error(data.message);
																}
															});
												})
								break;
							 case 'cancel':
			                        $("#nav-tab-list").click();
			                        $("#addOrUpdate").val("add");
			                     break;
							}

						});
		//form_init();
	});
	$("#deviceType-form").bootstrapValidator({
		message : '<spring:message code="app.appinfo.please.enter.a.valid.value"/>',
		feedbackIcons : {
			valid : 'glyphicon glyphicon-ok',
			invalid : 'glyphicon glyphicon-remove',
			validating : 'glyphicon glyphicon-refresh'
		},
		fields : {
			manufacturerNo : {
				validators : {
					notEmpty : {
						message : '<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>'
					}
				}
			},
			deviceType : {
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.device.please.enter.the.name.of.the.device.type"/>'
					},
					stringLength: {
                        min: 1,
                        max: 31,
                        message: '<spring:message code="modules.device.type.device.type.length"/>'
                    },
                    remote:{
				        	url:basePath+"/deviceType/checkName", 
				        	delay :  2000,
				        	data: function(validator) {
	                            return {
	                            	oldValueNo:$('#oldManufacturerNo').val(),
	                            	newValueNo:$('#manufacturerNoAdd').val(),
	                            	oldValueType:$('#oldDeviceType').val(),
	                            	newValueType:$('#deviceType').val(),
	                            	id:$("#id").val()
	                            };
	                        },
				        	message:'<spring:message code="modules.device.type.device.type.check"/>'
				        }
				}
			}
		}
	}).on("success.form.bv",function(e){
		    e.preventDefault();
			modals.confirm('<spring:message code="common.confirm.save"/>', function() {
				//Save Data，对应'submit-提交'
				 var params = dataForm.getFormSimpleData();
					 ajaxPost(basePath+'/deviceType/save', params, function(data, status) {
							if (data.code == '200' || data.code == 200) {
								var addOrUpdate = $("#addOrUpdate").val();
								if (addOrUpdate == "update") {//更新
									modals.info({
				                        title:'<spring:message code="common.sys.info" />', 
				                        cancel_label:'<spring:message code="common.close" />',
				                        text:'<spring:message code="common.editSuccess" />'}); 
										deviceTypeTable.reloadRowData($('#id').val());
								} else if(addOrUpdate == "add") {//新增
									modals.info({
				                        title:'<spring:message code="common.sys.info" />', 
				                        cancel_label:'<spring:message code="common.close" />',
				                        text:'<spring:message code="common.AddSuccess" />'});

									deviceTypeTable.reloadData();
									dataForm.clearForm();
								}
								  $("#nav-tab-list").click();
								  setTitle("<spring:message code="ota.table.device.type.list"/>");
								  $("#csrftoken").val("");
							} else{
								modals.error(data.message);
							}
				}); 
			});		    
	});
		function operation(id, type, rowObj){
			var oper = "&nbsp;&nbsp;&nbsp;";
			oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.deleteDevice(\"" + id +"\")'>"+'<spring:message code="common.delete"/>'+"</a>";
	        oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.editDevice(\"" + id +"\")'>"+'<spring:message code="common.edit"/>'+"</a>";
	        return oper;
	}
</script>