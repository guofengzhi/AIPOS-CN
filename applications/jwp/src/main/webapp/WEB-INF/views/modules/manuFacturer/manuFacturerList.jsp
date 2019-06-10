<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
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
								code="ota.table.vendor.list"></spring:message></small></li>
				</ul>
				<div class="tab-content">
					<div class="tab-pane active" id="tab-content-list">
						<div class="box">
							<div class="dataTables_filter" id="manuFacturerSearchDiv"
								style="text-align: left;" role="form">
								<div class="form-group dataTables_filter " style="margin: 1em;">
									<input
										placeholder='<spring:message code="ota.table.manufacturer.number"/>'
										name="manufacturerNo" class="form-control" type="search"
										style="height:36px;" /> <input
										placeholder='<spring:message code="ota.table.manufacturer.name"/>'
										name="manufacturerName" class="form-control" type="search"
										style="height:36px;" />
									<button type="button" class="btn btn-primary"
										style="height:36px;" data-btn-type="search">
										<spring:message code="common.query" />
									</button>
									<button type="button" class="btn btn-default"
										style="height:37px;" data-btn-type="reset">
										<spring:message code="common.reset" />
									</button>
									<shiro:hasPermission name="maun:edit">
										<button type="button" class="btn btn-default"
											style="height:37px" data-btn-type=delete
											title="<spring:message code = 'common.delete' />">
											<i class="fa fa-remove"></i>
										</button>
										<button data-btn-type="edit" class="btn btn-default"
											style="height:37px"
											title="<spring:message code = 'common.edit' />" type="button">
											<i class="fa fa-edit"></i>
										</button>
										<button data-btn-type="add" class="btn btn-default"
											style="height:37px"
											title="<spring:message code = 'common.add' />" type="button">
											<i class="fa fa-plus"></i>
										</button>
									</shiro:hasPermission>
								</div>
							</div>
							<div class="box-body">
								<table id="manuFacturer_table"
									class="table table-bordered table-striped table-hover"
									style="margin-top:0px !important;">
								</table>
							</div>
						</div>
					</div>
					<div class="tab-pane" id="tab-content-edit">
						<form:form id="manuFacturer-form" name="manuFacturer-form"
							modelAttribute="manuFacturer" class="form-horizontal">
							<form:hidden path="id" value="${manuFacturer.id }" />
							<input type='hidden' value='${CSRFToken}' id='csrftoken'>
							<input type="hidden" id="addOrUpdate" value="" />
							<div class="box-body">
								<div class="col-md-12">
									<div class="form-group">
										<label for="manufacturerNo" class="col-sm-2 control-label"><spring:message
												code="ota.table.manufacturer.number" /><span
											style="color:red">*</span></label>
										<div class="col-sm-8">
										<input  type="hidden" id="oldManufacturerNo" name="manufacturerNo" value="${manuFacturer.manufacturerNo}"/>
											<form:input path="manufacturerNo" value="${manuFacturer.manufacturerNo }" htmlEscape="false"
												maxlength="20" class="form-control" placeholder="${manufacturerNumber }" />
										</div>
									</div>
									<div class="form-group">
										<label for="manufacturerName" class="col-sm-2 control-label"><spring:message
												code="ota.table.manufacturer.name" /><span style="color:red">*</span></label>
										<div class="col-sm-8">
										<input  type="hidden" id="oldManufacturerName" name="manufacturerName" value="${manuFacturer.manufacturerName}"/>
											<form:input path="manufacturerName" id="manufacturerName"
											 htmlEscape="false"
												maxlength="50" class="form-control"
												placeholder="${manufacturerName}" />
										</div>
									</div>
									<div class="form-group">
										<label for="manufacturerAddr" class="col-sm-2 control-label"><spring:message
												code="ota.table.manufacturer.address" /><span
											style="color:red">*</span></label>
										<div class="col-sm-8">
											<form:input path="manufacturerAddr"
												value="${manuFacturer.manufacturerAddr }" htmlEscape="false"
												maxlength="50" class="form-control"
												placeholder="${manufacturerAddress }" />
										</div>
									</div>

								</div>
							</div>
							<div class="box-footer text-right">
								<!--以下两种方式提交验证,根据所需选择-->
								<button type="button" class="btn btn-default"
									data-btn-type="cancel" data-dismiss="modal">
									<spring:message code="common.cancel" />
								</button>
								<button type="submit" class="btn btn-primary"
									data-btn-type="save">
									<spring:message code="common.submit" />
								</button>
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
	var form = $("#manuFacturerSearchDiv").form({
		baseEntity : false
	});
	form.initComponent();
	//tableId,queryId,conditionContainer
	var manuFacturerTable;
	var winId = "manuFacturerWin";
	var dataForm=null;
	$(function() {
		
		 //编辑区域点击事件
		 $("#nav-tab-edit").click(function(){
				dataForm.clearForm();
		 });
		 $("#nav-tab-list").click(function(){
			  setTitle("<spring:message code="ota.table.vendor.list"/>");
		 });
		
		 dataForm=$("#manuFacturer-form").form();
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
		manuFacturerTable = new CommonTable("manuFacturer_table",
				"manuFacturer_list", "manuFacturerSearchDiv",
				"/manuFacturer/list", config);

		//button event
		$('button[data-btn-type]').click(
						function() {
							var action = $(this).attr('data-btn-type');
							var rowId = manuFacturerTable.getSelectedRowId();
							switch (action) {
							case 'add':
								setTitle('<spring:message code="modules.manufacturer.add.manufacturer.information"/>');//设置界面显示信息
								$("#nav-tab-edit").click();
								dataForm.clearForm();//清空文本框数据
								$("#addOrUpdate").val("add");
								break;
							case 'edit':
								if (!rowId) {
									modals.info('<spring:message code="common.promt.edit"/>');
									return false;
								}
								setTitle("<spring:message code="modules.manufacturer.edit"/>【"+ manuFacturerTable.getSelectedRowData().manufacturerName+ "】");
								$("#nav-tab-edit").click();
								$("#addOrUpdate").val("update");
								ajaxPost(basePath+"/manuFacturer/editOrAdd?id="+rowId, null, function(data) {
											//重置
											dataForm.clearForm();
											//赋值
											dataForm.initFormData(data);
								});
								break;
							case 'delete':
								if (!rowId) {
									modals.info('<spring:message code="common.promt.delete"/>');
									return false;
								}
								modals.confirm('<spring:message code="common.confirm.delete"/>',
												function() {
													ajaxPost(basePath+ "/manuFacturer/delete?id="+ rowId,null,function(data) {
																if (data.code == 200) {
																	modals.correct('<spring:message code="app.appinfo.the.data.has.been.deleted"/>');
																	manuFacturerTable.reloadRowData();
																} else {
																	modals.error(data.message);
																}
															});
												});
								break;
							  case 'cancel':
			                        $("#nav-tab-list").click();
			                        $("#addOrUpdate").val("add");
			                        break;
							}

						});
	});
	//数据校验
	$("#manuFacturer-form").bootstrapValidator({
						message : '<spring:message code="common.promt.value"/>',
						feedbackIcons : {
							valid :      'glyphicon glyphicon-ok',
							invalid :    'glyphicon glyphicon-remove',
							validating : 'glyphicon glyphicon-refresh'
						},							
						fields : {
							manufacturerAddr : {
								validators : {
									notEmpty : {
										message : '<spring:message code="ota.table.manufacturer.address"/>'
									}
								},
								stringLength: {
			                         min: 1,
			                         max: 50,
			                         message: '<spring:message code="modules.baseinfo.vendor.address.length"/>'
			                     }
							},
							manufacturerName : {
								validators : {
									notEmpty : {
										message : '<spring:message code="ota.table.manufacturer.name"/>'
									},
									stringLength: {
				                         min: 1,
				                         max: 30,
				                         message: '<spring:message code="modules.baseinfo.vendor.name.length"/>'
				                     },
				                     remote:{
								        	url:basePath+"/manuFacturer/checkNameOrNo", 
								        	delay :  2000,
								        	data: function(validator) {
					                            return {
					                            	newValue:$('#manufacturerName').val(),
					                            	oldValue:$('#oldManufacturerName').val(),
					                            	flag:'2',
					                            	id:$("#id").val()
					                            };
					                        },
								        	message:'<spring:message code="modules.baseinfo.vendor.name.exist"/>'
								        }
								}
							},
							manufacturerNo : {
								validators : {
									notEmpty : {
										message : '<spring:message code="ota.table.manufacturer.number"/>'
									},
									stringLength: {
				                         min: 1,
				                         max: 20,
				                         message: '<spring:message code="modules.baseinfo.vendor.sn.length"/>'
				                     },
				                     remote:{
								        	url:basePath+"/manuFacturer/checkNameOrNo", 
								        	delay :  2000,
								        	data: function(validator) {
					                            return {
					                            	newValue:$('#manufacturerNo').val(),
					                            	oldValue:$('#oldManufacturerNo').val(),
					                            	flag:'1',
					                            	id:$("#id").val()
					                            };
					                        },
								        	message:'<spring:message code="modules.baseinfo.vendor.sn.exist"/>'
								        },
					                     regexp: {
					                    	    regexp: /^[a-zA-Z0-9_]+$/,
					                    	    message: '<spring:message code="modules.baseinfo.vendor.sn.Validator"/>'
					                     } 
								}
							}
						}
					}).on('success.form.bv', function(e) {
						 // 阻止默认事件提交
						 e.preventDefault();
						 modals.confirm({
								cancel_label:'<spring:message code="common.cancel" />',
								title:'<spring:message code="common.sys.confirmTip" />',
								ok_label:'<spring:message code="common.confirm" />',
								text:'<spring:message code="common.confirm.save"/>',
								callback: function() {
									//Save Data，对应'submit-提交'
									var params = dataForm.getFormSimpleData();
									ajaxPost(basePath + '/manuFacturer/save?v='+parseInt(Math.random()*1000000000) ,
											params, function(data, status) {
												if (data.code == '200' || data.code == 200) {
													var addOrUpdate = $("#addOrUpdate").val();
													if (addOrUpdate == "update") {//更新
														modals.info({
									                        title:'<spring:message code="common.sys.info" />', 
									                        cancel_label:'<spring:message code="common.close" />',
									                        text:'<spring:message code="common.editSuccess" />'}); 
														    manuFacturerTable.reloadRowData($('#id').val());
													} else if(addOrUpdate == "add") {//新增
														modals.info({
									                        title:'<spring:message code="common.sys.info" />', 
									                        cancel_label:'<spring:message code="common.close" />',
									                        text:'<spring:message code="common.AddSuccess" />'});

														manuFacturerTable.reloadData();
														dataForm.clearForm();
													}
													  $("#nav-tab-list").click();
													  setTitle("<spring:message code="ota.table.vendor.list"/>");
													  $("#csrftoken").val("");
												} else{
													modals.error(data.message);
												}
											});
								}});
					});
	function operation(id, type, rowObj) {
		var oper = "&nbsp;&nbsp;&nbsp;";
		oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.deleteDevice(\""
				+ id
				+ "\")'>"
				+ '<spring:message code="common.delete"/>'
				+ "</a>";
		oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.editDevice(\""
				+ id
				+ "\")'>"
				+ '<spring:message code="common.edit"/>'
				+ "</a>";
		return oper;
	}
</script>
