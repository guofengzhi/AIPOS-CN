<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<spring:message code="ota.table.strategy.name" var="strategyName"/>
<spring:message code="app.version.equipment.upgrading" var="upgradingType"/>
<spring:message code="ota.table.strategy.desc" var="strategyDesc"/>
<spring:message code="modules.strategy.start.date" var="strategyStartTime"/>
<spring:message code="modules.strategy.end.date" var="strategyEndTime"/>
<div id="listForm">
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
									code="ota.table.strategy.list"></spring:message></small></li>
					</ul>
					<div class="tab-content">
							<div class="tab-pane active" id="tab-content-list">
								<div class="box">
									<div class="dataTables_filter" id="strategySearchDiv"  role="form">
									   <div class="form-group dataTables_filter " style="margin: 1em;">
											<input style="height:36px" placeholder="<spring:message code="ota.table.strategy.name"/>" name="strategyName"
												class="form-control"  type="search" /> &nbsp;&nbsp;
							              	<button type="button" style="height:36px;" class="btn btn-primary"
												data-btn-type="search"><spring:message code="common.query"/></button>&nbsp;
											<button type="button" style="height:36px;" class="btn btn-default"
												data-btn-type="reset"><spring:message code="common.reset"/></button>&nbsp;
											<shiro:hasPermission name="maun:edit">
													<button type="button" class="btn btn-default" style="height:36px;"
														data-btn-type=delete title="<spring:message code = 'common.delete' />">
														<i class="fa fa-remove"></i>
													</button>&nbsp;
													<button data-btn-type="edit" class="btn btn-default" style="height:36px;"
														title="<spring:message code = 'common.edit' />" type="button">
														<i class="fa fa-edit"></i>
													</button>&nbsp;
													<button data-btn-type="add" class="btn btn-default" style="height:36px;"
														title="<spring:message code = 'common.add' />" type="button">
														<i class="fa fa-plus"></i>
													</button>
										    </shiro:hasPermission>
									    </div>
									</div>
									<div class="box-body">
										<table id="strategy_table"
											class="table table-bordered table-striped table-hover" style="margin-top:0px !important;">
										</table>
									</div>
								</div>
						 </div>
						 <div class="tab-pane" id="tab-content-edit">
						 		<form:form id="strategy-form" name="strategy-form" modelAttribute="strategy"
										class="form-horizontal" >
										 <form:hidden path="id" value="${strategy.id }" />
										<input type='hidden' value='${CSRFToken}' id='csrftoken'>
										<input type="hidden" id="addOrUpdate" value="" />
										<div class="box-body">
											<div class="col-md-12">
												<div class="form-group">
													<label for="strategyName" class="col-sm-2 control-label">${strategyName }<span style="color:red">*</span></label>
													<div class="col-sm-9">
														<input  type="hidden" id="oldStrategyName" name="strategyName" value="${strategy.strategyName}"/>
													    <form:input path="strategyName" id="strategyName"  value="${strategy.strategyName }" htmlEscape="false" maxlength="50"  class="form-control" placeholder="${strategyName }"/>
													</div>
												</div>
												
												<div class="form-group">
													<label for="strategyDesc" class="col-sm-2 control-label">${strategyDesc }<span style="color:red">*</span></label>
													<div class="col-sm-9">
														<form:textarea path="strategyDesc" value="${strategy.strategyDesc }" class="form-control"
															htmlEscape="false" rows="3" maxlength="450" placeholder="${strategyDesc }" />
													</div>
												</div>
											 <div class="form-group">
													<label class="col-sm-2 control-label" for="beginDate">${strategyStartTime }<span style="color:red">*</span></label>
													<div class="col-sm-9">
														<div class="input-group date">
															<div class="input-group-addon">
																<i class="fa fa-calendar"></i>
															</div>
														    <span style="position: relative; z-index: 9999;"><form:input class="form-control pull-right" id="beginDate"
																type="text" path="beginDate"  placeholder="${strategyStartTime }"
																data-flag="datepicker"   ></form:input></span>
														</div>
													</div>
											</div>	
											 <div class="form-group">
													
												<label class="col-sm-2 control-label" for="endDate">${strategyEndTime }<span style="color:red">*</span></label>
												<div class="col-sm-9">
													<div class="input-group date">
														<div class="input-group-addon">
															<i class="fa fa-calendar"></i>
														</div>
														<span style="position: relative; z-index: 9999;"><form:input class="form-control pull-right" id="endDate" type="text"
															path="endDate" placeholder="${strategyEndTime }"  data-flag="datepicker"></form:input></span>
													</div>
												</div>
											</div>	
											</div>
										</div>
										<!-- /.box-body -->
										<div class="box-footer text-right">
											<!--以下两种方式提交验证,根据所需选择-->
											<button type="button" class="btn btn-default" data-btn-type="cancel"
												data-dismiss="modal"><spring:message code="common.cancel"/></button>
											 <button type="submit" class="btn btn-primary" data-btn-type="save"><spring:message code="common.submit"/></button>
										</div>
										<!-- /.box-footer -->
									</form:form>
						 </div>
					</div>
			</div>		
		</div>
	</div>
</section>
	</div>
<script>
function setTitle(title) {
	$("ul.nav-tabs li.header small").text(title);
}
var form = $("#strategySearchDiv").form({baseEntity: false});
    form.initComponent();
	//tableId,queryId,conditionContainer
	var strategyTable;
	var winId = "strategyWin";
	var dataForm=null;
	$(".select2").select2();
	$(function() {
		$("#beginDate").datepicker({
	         language: "zh-CN",
	         autoclose: true,//选中之后自动隐藏日期选择框
	         clearBtn: true,//清除按钮
	         todayBtn: true,//今日按钮
	         format: "yyyy-mm-dd"//日期格式，详见 http://bootstrap-datepicker.readthedocs.org/en/release/options.html#format
	     });
		
		 
		 $("#endDate").datepicker({
	         language: "zh-CN",
	         autoclose: true,//选中之后自动隐藏日期选择框
	         clearBtn: true,//清除按钮
	         todayBtn: true,//今日按钮
	         format: "yyyy-mm-dd"//日期格式，详见 http://bootstrap-datepicker.readthedocs.org/en/release/options.html#format
	     });
		
		var beginDateStr = '${strategy.beginDate }';
		var endDateStr = '${strategy.endDate}';
		
		var beginDate = new Date(beginDateStr);
		var endDate = new Date(endDateStr);
		if(beginDateStr == null || beginDateStr == ''){
			$("#beginDate").val(formatDate(new Date(), "yyyy-MM-dd"));
			$("#endDate").val(formatDate(new Date(), "yyyy-MM-dd"));
		}else {
			$("#beginDate").val(formatDate(beginDate, "yyyy-MM-dd"));
			$("#endDate").val(formatDate(endDate, "yyyy-MM-dd"));
		}
		
		 dataForm=$("#strategy-form").form();
		 //编辑区域点击事件
		 $("#nav-tab-edit").click(function(){
				dataForm.clearForm();
		 });
		 $("#nav-tab-list").click(function(){
			  setTitle("<spring:message code="ota.table.strategy.list"/>");
		 });
		//设置心新增修改参数为新增
		$("#addOrUpdate").val("add");
		
		var config = {
				resizeSearchDiv : false,
				language : {
					url : basePath + '<spring:message code="common.language"/>'
				}
			};
		//init table and fill data
		strategyTable = new CommonTable("strategy_table", "strategy_list", "strategySearchDiv",
				"/strategy/list",config);

		//button event
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var rowId = strategyTable.getSelectedRowId();
							switch (action) {
							case 'add':
								setTitle('<spring:message code="modules.strategy.add.strategy"/>');//设置界面显示信息
								$("#nav-tab-edit").click();
								dataForm.clearForm();//清空文本框数据
								$("#addOrUpdate").val("add");
								break;
							case 'edit':
								if (!rowId) {
									modals.info('<spring:message code="common.promt.edit"/>');
									return false;
								}
								setTitle("<spring:message code="ota.table.strategy.edit"/>");
								$("#nav-tab-edit").click();
								$("#addOrUpdate").val("update");
								ajaxPost(basePath+"/strategy/StrategyEditOrAdd?id="+rowId, null, function(data) {
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
								modals
										.confirm(
												'<spring:message code="common.confirm.delete"/>',
												function() {
													ajaxPost(
															basePath
																	+ "/strategy/delete?id="
																	+ rowId,
															null,
															function(data) {
																
																if (data.code == 200) {
																	modals.correct('<spring:message code="common.promt.deleted"/>');
																	strategyTable
																			.reloadRowData();
																} else {
																	modals
																			.error(data.message);
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
		//数据校验
		$("#strategy-form").bootstrapValidator({
			message : '<spring:message code="common.promt.value"/>',
			feedbackIcons : {
				valid : 'glyphicon glyphicon-ok',
				invalid : 'glyphicon glyphicon-remove',
				validating : 'glyphicon glyphicon-refresh'
			},
			fields : {
				strategyName : {
					validators : {
						notEmpty : {
							message : '<spring:message code="modules.strategy.please.fill.in.the.policy.name"/>'
						},
						stringLength: {
	                        min: 1,
	                        max: 31,
	                        message: '<spring:message code="ota.table.strategy.name.length"/>'
	                    },
                       remote:{
				        	url:basePath+"/strategy/checkStrategyName", 
				        	delay :  2000,
				        	data: function(validator) {
	                            return {
	                            	oldValueNo:$('#oldStrategyName').val(),
	                            	newValueNo:$('#strategyName').val(),
	                            	id:$("#id").val()
	                            };
	                        },
				        	message:'<spring:message code="modules.device.type.device.type.check"/>'
				        }
					}
				},
				strategyDesc : {
					validators : {
						notEmpty : {
							message : '<spring:message code="modules.strategy.please.fill.in.the.policy.description"/>'
						},
						stringLength: {
	                        min: 1,
	                        max: 250,
	                        message: '<spring:message code="ota.table.strategy.desc.length"/>'
	                    }
					}
				},
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
									return parseInt(value)<parseInt(end);
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
									return parseInt(value)>parseInt(begin);	
								}
									
							}
						}
					}
				}
			}
		}).on("success.form.bv",function(e){
			    e.preventDefault();
				modals.confirm('<spring:message code="common.confirm.save"/>', function() {
					 var params = dataForm.getFormSimpleData();
					 ajaxPost(basePath+'/strategy/save', params, function(data, status) {
							if (data.code == '200' || data.code == 200) {
								var addOrUpdate = $("#addOrUpdate").val();
								if (addOrUpdate == "update") {//更新
									modals.info({
				                        title:'<spring:message code="common.sys.info" />', 
				                        cancel_label:'<spring:message code="common.close" />',
				                        text:'<spring:message code="common.editSuccess" />'}); 
										strategyTable.reloadRowData($('#id').val());
								} else if(addOrUpdate == "add") {//新增
									modals.info({
				                        title:'<spring:message code="common.sys.info" />', 
				                        cancel_label:'<spring:message code="common.close" />',
				                        text:'<spring:message code="common.AddSuccess" />'});
										strategyTable.reloadData();
										dataForm.clearForm();
								}
								  $("#nav-tab-list").click();
								  setTitle("<spring:message code="ota.table.strategy.list"/>");
								  $("#csrftoken").val("");
							} else{
								modals.error(data.message);
							}
				  }); 
				});		    
		});
		//初始化控件
	});
	/* function upgradeType(upgradeType){
		if(upgradeType==="0"){
			return "提示";
		}
		return "强制";
	} */
	
		function operation(id, type, rowObj){
			var oper = "&nbsp;&nbsp;&nbsp;";
			oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.deleteDevice(\"" + id +"\")'>"+'<spring:message code="common.delete"/>'+"</a>";
	        oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='deviceProcessDef.editDevice(\"" + id +"\")'>"+'<spring:message code="common.edit"/>'+"</a>";
	        return oper;
	}
	
</script>
