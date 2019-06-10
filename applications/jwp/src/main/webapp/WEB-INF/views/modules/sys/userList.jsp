<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<spring:message code="sys.user.name.form" var="nameForm" />
<spring:message code="common.form.select" var="formSelect"/>
<spring:message code="sys.user.login.name" var="loginName"/>
<spring:message code="sys.user.mobile" var="userMobile"/>
<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="nav-tabs-custom">
	                <ul class="nav nav-tabs pull-right">
	                    <li><a href="#tab-content-edit" data-toggle="tab" id="nav-tab-edit"><i class="fa fa-edit"></i></a></li>
	                    <li class="active"><a href="#tab-content-list" data-toggle="tab" id="nav-tab-list"><i class="fa fa-list-ul"></i></a></li>
	                    <li class=" header"><i class="fa fa-user"></i><small><spring:message code="common.UserList"></spring:message></small></li>
	                </ul>
	                 <div class="tab-content">
	                 		<div class="tab-pane active" id="tab-content-list">
	                 			<div class="box">
									<div id="userSearchDiv" class="form-horizontal" role="form">
									   <div class="form-group dataTables_filter " style="margin: 1em;">
												
												<input class="form-control " id="name" type="text" name="name"
													placeholder='<spring:message code="sys.user.promt.name"/>' />
													
												<input class="form-control " id="loginname" type="text"
													name="loginName" placeholder='<spring:message code="sys.user.name.form"/>' />
												 <input class="form-control "     id="company"   type="text"
												 name="company.name" placeholder='<spring:message code="common.OrganizationOrDepartment"/>' />
										             <input type="hidden" class="form-control " style="width:11%;"   
										              name="companyId"      id="companyId"  >
												 <button type="button" class="btn btn-info"  data-btn-type="selectOrg"  data-flag="orgS">
												 	<i class="fa fa-sitemap"></i>&nbsp;<spring:message code="common.form.select"/>
					                            			 </button>
												<button type="button" class="btn btn-primary"
													data-btn-type="search"><spring:message code="common.query"/></button>
												<button type="button" class="btn btn-default"
													data-btn-type="reset"><spring:message code="common.reset"/></button>
											<shiro:hasPermission name="sys:user:edit">
												<button type="button" class="btn btn-default" data-btn-type="userAdd"><spring:message code="common.add"/></button>
												<button type="button" class="btn btn-default"
													data-btn-type="userEdit"><spring:message code="common.edit"/></button>
												<button type="button" class="btn btn-default"
													data-btn-type="userDelete"><spring:message code="common.delete"/></button>
											</shiro:hasPermission>
											
										</div>	
									</div>
									<div class="box-body">
										<table id="user_table"
											class="table table-bordered table-bg table-striped table-hover">
										</table>
									</div>
									</div>
	                 		</div>
	                 		<div class="tab-pane " id="tab-content-edit">
	                 		 <form:form id="user-form" name="user-form" modelAttribute="user" enctype="multipart/form-data" class="form-horizontal">
										<form:hidden path="id"  />
										<input type='hidden' value='' id='csrftoken'>
										<input type="hidden" id="addOrUpdate" value="" />
									  <div class="box-header">
					                    </div>
										<div class="box-body">
											<div class="col-md-6">
												<div class="form-group">
													<label for="office.id" class="col-sm-3 control-label"><spring:message code="sys.user.office"/> <span style="color:red">*</span> </label>
													<div class="col-sm-6">
															<form:input type="hidden" path="officeId" value="${user.office.id}" id="orgSelect" class="form-control" htmlEscape="false"
																	maxlength="100" />
                                  						 				  
                                  						 				   <input type="text" class="form-control"  value="" readonly id="deptName" placeholder="<spring:message code="sys.user.promt.department"/>">
													</div>
													<div class="col-sm-2">
						                                    <button type="button" class="btn btn-info"  data-btn-type="selectOrg"  data-flag="org">
						                                    <i class="fa fa-sitemap"></i>&nbsp;<spring:message code="common.form.select"/>
						                                    </button>
													</div>
												</div>
												<div class="form-group">
													<label for="name" class="col-sm-3 control-label"><spring:message code="sys.user.name.form"/><span style="color:red">*</span></label>
													<div class="col-sm-8">
														<form:input type="text" htmlEscape="false" class="form-control"
															id="name" path="name" placeholder="${nameForm}" />
													</div>
												</div>
												
												<div class="form-group">
													<label for="loginFlag" class="col-sm-3 control-label"><spring:message code="sys.user.login.allow"/><span style="color:red">*</span></label>
													<div class="col-sm-8">
														<form:select path="loginFlag" class="form-control select2"
															style="width: 100%;">
															<form:options items="${fns:getDictList('yes_no')}"
																itemLabel="label" itemValue="value" htmlEscape="false" />
														</form:select>
													</div>
												</div>
												<div class="form-group">
													<label for="userType" class="col-sm-3 control-label"><spring:message code="sys.user.type"/></label>
													<div class="col-sm-8">
														<form:select path="userType" class="form-control select2"
															style="width: 100%;">
															<form:option value="" label="${formSelect}" />
															<form:options items="${fns:getDictList('sys_user_type')}"
																itemLabel="label" itemValue="value" htmlEscape="false" />
														</form:select>
													</div>
												</div>
											</div>
											<div class="col-md-6">
												<div class="form-group">
													<label class="col-sm-3 control-label"><spring:message code="sys.user.mail"/><span style="color:red">*</span></label>
								
													<div class="col-sm-8">
														<form:input path="email" class="form-control" htmlEscape="false"
															maxlength="100" />
													</div>
												</div>
												<div class="form-group">
													<label for="loginName" class="col-sm-3 control-label"><spring:message code="sys.user.login.name"/><span style="color:red">*</span></label>
													<div class="col-sm-8">
														<input id="oldLoginName" name="oldLoginName" type="hidden"
																value="">
													     <form:input type="text" htmlEscape="false" class="form-control"
																id="loginName" path="loginName" placeholder="${loginName}" />
													</div>
												</div>
												<div class="form-group">
													<label for="mobile" class="col-sm-3 control-label"><spring:message code="sys.user.mobile"/><span style="color:red">*</span></label>
								
													<div class="col-sm-8">
														<form:input type="text" htmlEscape="false" class="form-control"
																id="mobile" path="mobile" placeholder="${userMobile}" />
													</div>
												</div>
												<div class="form-group">
													<label for="phone" class="col-sm-3 control-label"><spring:message code="sys.user.tel"/></label>
													<div class="col-sm-8">
														<form:input path="phone" class="form-control" htmlEscape="false"
															maxlength="100" />
													</div>
												</div>
											</div>
											<div class="col-md-12">
												<div class="form-group">
													<label for="loginFlag" class="col-sm-2 control-label" style="width:12.5%"><spring:message code="sys.user.role"/><span style="color:red">*</span></label>
													<div class="col-sm-3">
													          <input type="hidden"  name="roleId" id="roleId" class="form-control"  >
														    <textarea readonly name="roleName" id="roleName" placeholder=" <spring:message code="sys.user.promt.role"/>"  class="form-control"></textarea>
													</div>
													<div class="col-sm-2">
					                                   			   <button type="button" class="btn btn-info"  data-btn-type="selectRole"  >&nbsp;
					                                   			 	 <spring:message code="common.form.select"/>
					                                   			   </button>
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
			<!-- /.col -->
		</div>
		<!-- /.row -->
		<!-- 模态框（Modal） -->
		<div class="modal fade" id="myModal"   tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog" style="height:580px;width:1000px;">
		        <div class="modal-content">
		            <div class="modal-header">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		                <h4 class="modal-title" id="myModalLabel"><spring:message code="sys.role"/></h4>
		            </div>
				<div class="modal-body" >
				    <div class="row">
							<!-- /.col -->
							<div class="col-md-12">
								<div class="box box-primary">
									<!-- /.box-header -->
									<div class="box-header with-border">
									   <h5 class="box-title" style="font-size:14px;float:right"><spring:message code="sys.role.table.name"/></h5>
									</div>
									<div class="dataTables_filter" id="searchDiv_unselected">
									<br>
										<input placeholder="<spring:message code="sys.role.table.roleName"/>" name="name" class="form-control form-control-sm" type="search" likeOption="true" />
										<div class="btn-group">
											<button type="button"   class="btn btn-primary" data-btn-type="search" ><spring:message code="common.query"/></button>
											<button type="button"   class="btn btn-primary"  data-btn-type="btn_add_ur" ><spring:message code="common.sys.confirmbutton"/></button>
											<button type="button"   class="btn btn-primary"  data-btn-type="btn_remove" ><spring:message code="common.remove"/></button>
										</div>	 				
									</div>
									<div class="box-body">
										<table id="userRole_unselected_table" class="table table-bordered table-bg table-striped table-hover">
										</table>
									</div>
									<!-- /.box-body -->
								</div>
							</div>
							
					</div>
		                  </div>
		        </div><!-- /.modal-content -->
		</div><!-- /.modal -->
		</div>
</section>

<script>

function setTitle(title){
    $("ul.nav-tabs li.header small").text(title);
 }
function resetUserForm() {
	userform.clearForm();
	$("#user-form").data('bootstrapValidator').resetForm();
}
var form = null;
	//tableId,queryId,conditionContainer
	var userTable;
	var unselectedTable;
	var winId = "userWin";
	$(function() {
        form=$("#user-form").form();
		//查询框是否在一行设置
		var config={
			resizeSearchDiv:false,
			language : {
				url: basePath+'<spring:message code="common.language"/>'
			}
		};
		//init table and fill data
		 userTable = new CommonTable("user_table", "userTable", "userSearchDiv",
				"/sys/user/list",config);  
		
		$("#nav-tab-list").on("click",function(){
            setTitle('<spring:message code="common.UserList"/>');
        });
		$("#addOrUpdate").val("");
		form.initComponent();
		$("button[data-flag='org']").org({
            idField: $("#orgSelect"),
            nameField: $("#deptName"),
            title:'<spring:message code="common.SelectAgencyDepartmentDoubleClickToGeT"/>'
        });
		$("button[data-flag='orgS']").org({
            idField: $("#companyId"),
            nameField: $("#company"),
            title:'<spring:message code="common.SelectAgencyDepartmentDoubleClickToGeT"/>'
        });
		
		//初始化加载列表名称
		 $('button[data-btn-type]').click(function() {
            var action = $(this).attr('data-btn-type');
            var rowId=userTable.getSelectedRowId();
            switch (action) {
                case 'userAdd':
	                         form.clearForm();
	                         setTitle('<spring:message code="sys.user.add"/>');
	                        $("#nav-tab-edit").click();
	                    	$("#addOrUpdate").val("add");
                    break;
                case 'btn_add_ur':
		    	            var rows=unselectedTable.getSelectedRowsData();
		    	            var selectId;
		    	            var selectName;
		    	            var addAndUpdate=$("#addOrUpdate").val();
		                	  if(addAndUpdate=="add"){
		                		selectId="";
		          	            selectName="";
		                	  }else{
		                		selectId=$("#roleId").val();
		          	            selectName=$("#roleName").val();
		                	  }
		                	  var strs= new Array(); //定义一数组
		                	  strs=selectId.split(","); //字符分割
		    	            $.each(rows,function(index,row){   
		    	            	var flag=true;
		    	            	for (i=0;i<strs.length ;i++ ){
			                		 var newId=strs[i]; 
			                		 if(newId ==row.id){
			                			flag=false;
			                			break;
			                		 }
			                	}
		    	            	if(flag){
		    	            		selectId+=row.id+",";
				    	            selectName+=row.name+","; 
		    	            	}
		    	            });
		    	            $("#roleId").val(selectId);
		    	            $("#roleName").val(selectName);
		    	            modals.info('<spring:message code="common.AddSuccess"/>');
                    break;
		    case 'btn_remove':
		    	              var rows=unselectedTable.getSelectedRowsData();
                		        var selectId=$("#roleId").val();
                		        var selectName=$("#roleName").val();
                		        var selectIdNew="";
                		        var selectNameNew="";
		                	  var strs= new Array(); //定义一数组
		                	      strs=selectId.split(","); //字符分割
		                	  var strsName= new Array(); //定义一数组
		                	      strsName=selectName.split(","); //字符分割
		    	            	//Id移除
		    	            	for (i=0;i<strs.length ;i++ ){
		    	            		var flag=true;//定义Id
			    	            	 var newId=strs[i]; 
		    	            		if(newId !=""){
		    	            			 $.each(rows,function(index,row){ 
				    	            		 if(newId ==row.id){
				    	            			flag=false;
						                     }
				    	            	 });
								if(flag){
									selectIdNew+=strs[i]+",";	
								}
		    	            		}
			    	            						
		    	            	}
		    	            	//名称移除
		    	            	for (i=0;i<strsName.length ;i++ ){
		    	            		 var flagName = true ; //定义名称
			                		 var newName=strsName[i]; 
		    	            		 if(newName !=""){
		    	            			  $.each(rows,function(index,row){  
				                			  if(newName ==row.name){
				                				flagName=false;	
						                	    }
						    	            });
				                		    if(flagName){
				                		    	selectNameNew+=strsName[i]+","; 
				                		    }
		    	            		 }
		                		  
			                	} 
		    	            $("#roleId").val(selectIdNew);
		    	            $("#roleName").val(selectNameNew);
		    	            modals.info('<spring:message code="common.RemoveSuccess"/>');
		          break;
                case 'selectRole':
		              	  $('#myModal').modal('toggle');
		              	  var addAndUpdate=$("#addOrUpdate").val();
		              	  var userId="";
		              	  if(addAndUpdate=="add"){
		              		  
		              	  }else{
		              		userId=rowId;
		              		
		              	  }
		              	  var table_config={ 
		              	       "singleSelect":false,
		                    	 lengthChange:false,
		       		       pagingType:'simple',
			       		 language : {
			    					url: basePath+'<spring:message code="common.language"/>'
			    					}
		       		          };   
		       		unselectedTable = new CommonTable("userRole_unselected_table", "role_list", "searchDiv_unselected","/sys/user/findRoleList?selectedType=1&userId="+userId+"&addAndUpdate=add",table_config);
		       		break;   
                case 'userEdit':
	                        if(!rowId){
	                            modals.info('<spring:message code="common.promt.edit"/>'); 
	                            return false;
	                        }
	                        setTitle("<spring:message code="sys.user.edit"/>【"+userTable.getSelectedRowData().name+"】");
	                        $("#nav-tab-edit").click();
	                    	$("#addOrUpdate").val("update");
	                         ajaxPost(basePath+"/sys/user/selectUser?id="+rowId,null,function(data){
	                        	 $("#roleName").val("");
	                        	 $("#roleId").val("");
	                        	$("#deptName").val(data.office.name);
	                        	 var roleId="";
	                        	 $.each(data.roleIdList,function(index,row){   
	                        		 roleId+=row+",";
	 		    	            });
	                        	 //重置
	                        	 form.clearForm();
	                        	 
	                        	 //赋值
	                        	 form.initFormData(data);
	                        	
	                        	 $("#oldLoginName").val(data.loginName);
	                        	 $("#roleName").val(data.roleNames);
	                        	 $("#roleId").val(roleId);
	         				});
                        break;
                case 'userDelete':
	                	if (!rowId) {
							modals.info('<spring:message code="common.promt.delete"/>');
							return false;
						}
						modals.confirm({
							cancel_label:"<spring:message code="common.cancel" />",
							title:"<spring:message code="common.sys.confirmTip" />",
							ok_label:"<spring:message code="common.confirm" />",
							text:"<spring:message code="common.confirm.delete" />",
							callback: function() {
							ajaxPost(basePath + "/sys/user/delete?id="
									+ rowId, null, function(data) {
								if (data.code == 200) {
									modals.correct({
										title:'<spring:message code="common.sys.success" />',
										cancel_label:'<spring:message code="common.confirm" />',
										text:data.message});
									userTable.reloadRowData();
								} else {
									modals.warn(date.message);
								}
							});
					}});
                        break;
                case 'cancel':
                        $("#nav-tab-list").click();
                        break;
            }

        });
		//数据校验
			$("#user-form").bootstrapValidator(
							{
								message : '<spring:message code="common.promt.value"/>',
								feedbackIcons : {
									valid : 'glyphicon glyphicon-ok',
									invalid : 'glyphicon glyphicon-remove',
									validating : 'glyphicon glyphicon-refresh'
								},							
								fields : {
									deptName : {
										validators : {
											notEmpty : {
												message : '<spring:message code="common.OrganizationOrDepartment"/>'
											}
										}
									},
									name : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.user.promt.name"/>'
											}
										}
									},
									loginName : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.user.promt.login.name"/>'
											},
											stringLength: {
						                         min: 6,
						                         max: 30,
						                         message: '<spring:message code="sys.user.promt.name.length"/>'
						                     },
						                     remote:{
										        	url:basePath+"/sys/user/checkLoginName", 
										        	delay :  2000,
										        	data: function(validator) {
							                            return {
							                            	loginName:$('#loginName').val(),
							                            	oldLoginName:$('#oldLoginName').val(),
							                                id:$('#id').val()
							                            };
							                        },
										        	message:'<spring:message code="sys.user.promt.name.used"/>'
										        } 
										}
									},
									mobile : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.user.promt.mobile"/>'
											},
											stringLength: {
						                         min: 11,
						                         max: 11,
						                         message: '<spring:message code="sys.user.promt.mobile.length"/>'
						                     },
						                     regexp: {
						                         regexp: /^1[3|5|8|7]{1}[0-9]{9}$/,
						                         message: '<spring:message code="sys.user.promt.mobile.error"/>'
						                     }
										}
									},
									email : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.user.promt.mail"/>',
											},
											emailAddress : {
												message : '<spring:message code="sys.user.promt.mail.error"/>',
											}

										}
									},
									'officeId' : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.user.promt.office"/>'
											}
										}
									},
									'loginFlag' : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.user.promt.login.allow"/>'
											}
										}
									},
									'roleIdList' : {
										validators : {
											notEmpty : {
												message : '<spring:message code="sys.user.promt.role"/>'
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
											var params = form.getFormSimpleData();
											var orgSelect = $("#orgSelect").val();
											if(orgSelect == null || orgSelect == undefined || orgSelect ==""){
												modals.info('<spring:message code="common.OrganizationOrDepartmentIsNUll"/>');
												return ;
											}
											var roleId = $("#roleId").val();
											if(roleId == null || roleId == undefined || roleId ==""){
												modals.info('<spring:message code="sys.user.promt.role"/>');
												return ;
											}
											ajaxPost(basePath + '/sys/user/save?v='+parseInt(Math.random()*1000000000) ,
													params, function(data, status) {
														if (data.code == '200' || data.code == 200) {
															var addOrUpdate = $("#addOrUpdate").val();
															if (addOrUpdate != "add") {//更新
																modals.info({
											                        title:'<spring:message code="common.sys.info" />', 
											                        cancel_label:'<spring:message code="common.close" />',
											                        text:'<spring:message code="common.editSuccess" />'}); 
																userTable.reloadRowData(id);
															} else {//新增
																modals.info({
											                        title:'<spring:message code="common.sys.info" />', 
											                        cancel_label:'<spring:message code="common.close" />',
											                        text:'<spring:message code="common.AddSuccess" />'});

																userTable.reloadData();
																form.clearForm();
															}
															  $("#nav-tab-list").click();
															  $("#csrftoken").val("");
														} else{
															modals.error(data.message);
														}
													});
										}});
							});
		//上传头像
		$("[data-btn-type='upload']").click(function () {
            uploadAvatar();
        });
	
	});
	var avatarWin = "avatarWin";
    function uploadAvatar() {
        modals.openWin({
            winId: avatarWin,
            title: '上传头像',
            width: '700px',
            url: basePath + "/sys/user/editPhoto"
        });
    }
</script>
<style type="text/css">
 .treeview {
		 overflow-y:auto;
		 height:300px;
		 }
</style>
