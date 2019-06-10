<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<!-- Content Header (Page header) -->
<div id="listForm">
<section class="content" >
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
									<div id="tagManagerSearchDiv" class="dataTables_filter" role="form" style="text-align: left;">
										 <div class="form-group dataTables_filter " style="margin: 1em;">
										 		<input id="orgSelect" style="height:36px;width: 226.5px;" name="orgId" class="form-control"  type="hidden"/>
												<input id="orgSelectValue" style="width: 226.5px;height:36px;" onclick="showOrgTree();"  name="orgIdValue" class="form-control" type="text" placeholder='<spring:message code="please.select.organ" />'/>
											    <input class="form-control"  style="height:36px;width: 226.5px;" id="tagName" type="text" name="tagName"
													placeholder='<spring:message code="sys.labelManagement.labelName"/>' />
										        <button type="button" class="btn btn-primary" style="height:37px;"
													data-btn-type="search"><spring:message code="common.query"/></button>
												<button type="button" class="btn btn-default" style="height:37px;"
													data-btn-type="reset"><spring:message code="common.reset"/></button>
												<shiro:hasPermission name="sys:tagManager:edit">
														<button data-btn-type="manageTerm" class="btn btn-primary"  title="<spring:message code='sys.labelManagement.binding.device' />" type="button" style="height:37px;">
														<i class="fa fa-plus"><spring:message code="sys.labelManagement.binding.device" /></i>
														</button>
												</shiro:hasPermission>
									 			<shiro:hasPermission name="sys:tagManager:edit">
													    <button type="button" class="btn btn-default"  data-btn-type="tagManagerDelete"  title="<spring:message code="common.delete" />" style="height:37px;">
															<i class="fa fa-remove"></i>
														</button>
														<button data-btn-type="tagManagerEdit" class="btn btn-default"  title="<spring:message code="common.edit" />" type="button" style="height:37px;">
															<i class="fa fa-edit"></i>
														</button>
														 <button data-btn-type="tagManagerAdd" class="btn btn-default"  title="<spring:message code="common.add" />" type="button" style="height:37px;">
															<i class="fa fa-plus"></i>
														</button>
												</shiro:hasPermission>	
										 </div>
									</div>
										<div class="box-body" style="padding:0px 10px 10px 10px">
											<table id="tagManager_table"
												class="table table-bordered table-bg table-striped table-hover" style="margin-top:0px !important;">
											</table>
										</div>
									</div>
							</div>
							 <div class="tab-pane" id="tab-content-edit">	
							 <form:form id="tagManager-form" name="tagManager-form"
									modelAttribute="tagManager" class="form-horizontal">
									   <input type="hidden" id="id" value="" />
										<input type="hidden" id="addOrUpdate" value="" />
									<div class="box-body">
										<div class="col-md-6">
											<div class="form-group">
												<label for="office.id" class="col-sm-6 control-label"><spring:message
														code="sys.user.office" /></label>
												<div class="col-sm-6">
													<input id="tagFormOrgSelect" style="width: 253.33px;"
														 class="form-control" type="hidden"
														 />
													<input  id="tagFormOrgSelectValue"  class="form-control" 
														maxlength="100"  onclick="showOrgTree1();"/>
												</div>
											</div>
											<div class="form-group">
												<label for="tagName" class="col-sm-6 control-label"><spring:message
														code="sys.labelManagement.labelName" /><span
													style="color: red">*</span></label>
												<div class="col-sm-6">
													<input type="text"  class="form-control"
														id="tagNameAdd"/>
												</div>
											</div>
										</div>
									</div>
									<div class="box-footer text-right">
									<button type="button" class="btn btn-default" data-btn-type="cancel"
										data-dismiss="modal" id="cancel">
										<spring:message code="common.cancel" />
									</button>
									<button class="btn btn-primary" data-btn-type="save"
										id="save">
										<spring:message code="common.submit" />
									</button>
								</div>
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
	//tableId,queryId,conditionContainer
	var tagManagerTable;
	var winId = "tagManagerWin";
	var dataForm=null;
	$(function() {

		 dataForm= $("#tagManager-form").form();
		 //编辑区域点击事件
		 $("#nav-tab-edit").click(function(){
			    $("#tab-content-edit #id").val("");
				$("#tagNameAdd").val("");
				$("#tagFormOrgSelect").val("");
				$("#tagFormOrgSelectValue").val("");
		 });
		 $("#nav-tab-list").click(function(){
			  setTitle("<spring:message code="sys.labelManagement.labellist"/>");
		 });
		//设置心新增修改参数为新增
		$("#addOrUpdate").val("add");
		//$("#orgSelect").select2();
		//查询框是否在一行设置
		var config={
			resizeSearchDiv:false,
			language : {
				url: basePath+'<spring:message code="common.language"/>'
			}
		};
		//init table and fill data
		tagManagerTable = new CommonTable("tagManager_table", "tagManagerTable", "tagManagerSearchDiv",
				"/sys/tagManager/list",config);
		$('button[data-btn-type]').click(
				function() {
					var action = $(this).attr('data-btn-type');
					var tagManagerRowId = tagManagerTable.getSelectedRowId();
					switch (action) {
					case 'tagManagerAdd':
							setTitle('<spring:message code="add.lable"/>');//设置界面显示信息
							$("#nav-tab-edit").click();
							dataForm.clearForm();//清空文本框数据
							$("#addOrUpdate").val("add");
						break;
					case 'tagManagerEdit':
						if (!tagManagerRowId) {
							modals.info('<spring:message code="common.promt.edit"/>');
							return false;
						}
						setTitle("<spring:message code="edit.lable"/>");
						$("#nav-tab-edit").click();
						$("#addOrUpdate").val("update");
						ajaxPost(basePath+"/sys/tagManager/TagManagerEditOrAdd?id="+tagManagerRowId, null, function(data) {
							$("#tab-content-edit #id").val("");
							$("#tagNameAdd").val("");
							$("#tagFormOrgSelect").val("");
							$("#tagFormOrgSelectValue").val("");
							 ajaxPost(basePath+"/sys/office/get?id="+data.orgId, null, function(dataOrg) {
								 $("#tagFormOrgSelectValue").val(dataOrg.name);
							 });
							$("#tab-content-edit #id").val(data.id);
							$("#tagNameAdd").val(data.tagName);
							$("#tagFormOrgSelect").val(data.orgId);
						});
						break;
					case 'tagManagerDelete':
						if (!tagManagerRowId) {
							modals.info('<spring:message code="common.promt.delete"/>');
							return false;
						}
						if(!checkTagManagerBundTerm(tagManagerRowId)){
							modals.info('<spring:message code="sys.labelManagement.hasDevice.notice"/>');
							return false;
						}
						modals.confirm({
							cancel_label:"<spring:message code="common.cancel" />",
							title:"<spring:message code="common.sys.confirmTip" />",
							ok_label:"<spring:message code="common.confirm" />",
							text:"<spring:message code="common.confirm.delete" />",
							callback: function() {
							ajaxPost(basePath + "/sys/tagManager/delete?id="
									+ tagManagerRowId, null, function(data) {
								if (data.code == 200) {
									modals.correct({
										title:'<spring:message code="common.sys.success" />',
										cancel_label:'<spring:message code="common.confirm" />',
										text:data.message});
									tagManagerTable.reloadRowData();
								} else {
									modals.warn(date.message);
								}
							});
						}});
						break;
					case 'manageTerm':
						if (!tagManagerRowId) {
							modals.info('<spring:message code="please.select.bund.row" />');
							return false;
						}
						toManageTerm(tagManagerRowId);
						break;
					 case 'cancel':
	                        $("#nav-tab-list").click();
	                        $("#addOrUpdate").val("add");
	                     break;
					}
				});
				//数据校验
				$("#tagManager-form").bootstrapValidator({
									message : '<spring:message code="common.promt.value"/>',
									feedbackIcons : {
										valid : 'glyphicon glyphicon-ok',
										invalid : 'glyphicon glyphicon-remove',
										validating : 'glyphicon glyphicon-refresh'
									},
									fields : {
										orgId : {
											validators : {
												notEmpty : {
													message : '<spring:message code="sys.store.orgId.not.empty"/>'
												}
											}
										},
										tagNameAdd : {
											validators : {
												notEmpty : {
													message : '<spring:message code="sys.labelManagement.label.not.null"/>'
												},
												remote : {
													 url:basePath+"/sys/tagManager/checkTagManagerName", 
						                              delay :  2000,
						                              data: function(validator) {
						                                  return {
						                                	  tagId:tagId,
						                                	  tagName:$('tagNameAdd').val(),
						                                	  orgId:$('#storeFormOrgSelect').val()
						                                  };
						                              },
													message : '<spring:message code="sys.labelManagement.LabelName.existed"/>'
												}
											}
										}
									}
								});
			
					$("#save").click(function(){
						$("#tagManager-form").bootstrapValidator('validate');//提交验证 
						if ($("#tagManager-form").data('bootstrapValidator').isValid()) {//获取验证结果，如果成功，执行下面代码  
							var params = $("#tagManager-form").form().getFormSimpleData();
							var addOrUpdate = $("#addOrUpdate").val();
					     	var urlAddOrUpdate;
					     	var orgId=$("#tagFormOrgSelect").val();
					     	var tagName=$("#tagNameAdd").val();
					     	var tagId=$("#tab-content-edit #id").val();
							if (addOrUpdate == "update") {//更新
								urlAddOrUpdate=basePath+'/sys/tagManager/update?orgId='+orgId+'&tagName='+encodeURIComponent(tagName)+'&tagId='+tagId;
							}else{
								urlAddOrUpdate=basePath+'/sys/tagManager/add?orgId='+orgId+'&tagName='+encodeURIComponent(tagName);
							}
							 ajaxPost(urlAddOrUpdate, params, function(data, status) {
									if (data.code == '200' || data.code == 200) {
									
										if (addOrUpdate == "update") {//更新
											modals.info({
						                        title:'<spring:message code="common.sys.info" />', 
						                        cancel_label:'<spring:message code="common.close" />',
						                        text:'<spring:message code="common.editSuccess" />'}); 
												tagManagerTable.reloadRowData($('#id').val());
										} else if(addOrUpdate == "add") {//新增
											modals.info({
						                        title:'<spring:message code="common.sys.info" />', 
						                        cancel_label:'<spring:message code="common.close" />',
						                        text:'<spring:message code="common.AddSuccess" />'});
												tagManagerTable.reloadData();
												$("#tab-content-edit #id").val("");
												$("#tagNameAdd").val("");
												$("#tagFormOrgSelect").val("");
												$("#tagFormOrgSelectValue").val("");
										}
										  $("#nav-tab-list").click();
										  setTitle("<spring:message code="sys.labelManagement.labellist"/>");
									} else{
										modals.error(data.message);
									}
						  }); 
						} 
					});	 
		
		});
	function manageTerm(id){	
		var oper = "&nbsp;&nbsp;&nbsp;";
		oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='toManageTerm(\"" + id +"\")'>"+'<spring:message code="sys.labelManagement.binding.device" />'+"</a>";
        return oper;
	}
	function toManageTerm(id){
		$.ajax({
			url:basePath+ "/sys/tagManager/toBoundTermTagManager",
			type:'POST',
			traditional:true,
			data:{'id':id},
			success:function(res){
				$("#listForm").html(res);
			}
		});
	}
	
	function checkTagManagerBundTerm(tagId){
		var flag = '';
		$.ajax({
			url:basePath+ "/sys/tagManager/checkTagManagerBundTerm",
			type:'POST',
			traditional:true,
			async:false,
			data:{'tagId':tagId},
			success:function(res){
				flag = res.hasDataFlag;
			}
		});
		return flag;
	}
	
	function showOrgTree1() {
		modals.openWin({
					winId : "formOrgTree",
					title : '<spring:message code="modules.device.importing.equipment.by.product.batch"/>',
					width : '300px',
					url : basePath
							+ "/sys/office/toOfficeTree?windowId=formOrgTree&orgSelect=tagFormOrgSelect&orgSelectValue=tagFormOrgSelectValue"
				});
	}
	function showOrgTree() {
		modals.openWin({
					winId : "formOrgTree",
					title : '<spring:message code="modules.device.importing.equipment.by.product.batch"/>',
					width : '300px',
					url : basePath
							+ "/sys/office/toOfficeTree?windowId=formOrgTree&orgSelect=orgSelect&orgSelectValue=orgSelectValue"
				});
	}
</script>
<style type="text/css">
 .treeview {
		 overflow-y:auto;
		 height:300px;
		 }
</style>