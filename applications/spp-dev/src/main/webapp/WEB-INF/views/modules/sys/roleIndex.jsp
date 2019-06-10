<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>

<!-- Main content -->
<section class="content">
   <div class="nav-tabs-custom">
   		        <ul class="nav nav-tabs pull-right">
   		              <li><a href="#tab-content-user"   data-toggle="tab" id="nav-tab-user"><i class="glyphicon glyphicon-th"></i><spring:message code="commom.RoleUserBindingDeregulation"/></a></li>
	                    <li><a href="#tab-content-edit"   data-toggle="tab" id="nav-tab-edit"><i class="glyphicon glyphicon-plus"></i><spring:message code="sys.role.addRole"/></a></li>
	                    <li><a href="#tab-content-author" data-toggle="tab" id="nav-tab-author"><i class="glyphicon glyphicon-barcode"></i><spring:message code="common.RoleAuthorMenu"/></a></li>
	                    <li class="active"><a href="#tab-content-list" data-toggle="tab" id="nav-tab-list"><i class="fa fa-list-ul"></i><spring:message code="sys.role.table.name"/></a></li>
	                    <li class=" header"><i class="fa fa-adjust"></i><small><spring:message code="sys.role"></spring:message></small></li>
	           </ul>
	           <div class="tab-content">
	           		 <div class="tab-pane" id="tab-content-user">
	           		 	  <div class="row">
						<!-- /.col -->
						<div class="col-md-6">
							<div class="box box-primary">
								<!-- /.box-header -->
								<div class="box-header with-border">
								   <h5 class="box-title" style="font-size:14px;"><spring:message code="common.TheRoleOfUnboundUserList" /></h5>
								   <button type="button" id="btn_add_ur" class="btn btn-sm close" title="<spring:message code="common.UserBindingRoles" />" ><li class="fa fa-arrow-right"></li></button>
								</div>
								<div class="dataTables_filter" id="searchDiv_unselected">
								    <input type="hidden" value="1" name="selectedType"  id="selectedType" isCondition="false"/>
									<input placeholder="<spring:message code="sys.login.tip.iputADM" />" name="name" class="form-control form-control-sm" type="search" likeOption="true" />
									<div class="btn-group">
										<button type="button" class="btn btn-primary" data-btn-type="search" ><spring:message code="common.query" /></button>
									</div>	 				
								</div>
								<div class="box-body">
									<table id="userRole_unselected_table" class="table table-bordered table-striped table-hover">
									</table>
								</div>
								<!-- /.box-body -->
							</div>
						</div>
					
						<div class="col-md-6">
							<!-- Profile Image -->
							<div class="box box-primary">
							<div class="box-header with-border">
								   <h5 class="box-title" style="font-size:14px;float:right"><spring:message code="common.TheUserHasTheRoleList" /></h5>
								   <button type="button" id="btn_remove_ur" class="btn btn-sm close" style="float:left" title="<spring:message code="common.userUntyingRole" />" ><li class="fa fa-arrow-left"></li></button>
								</div>
								<div class="dataTables_filter" id="searchDiv_selected">
								    <input type="hidden" value="" id="userRoleId"/>
								     <input type="hidden" value="2" name="selectedType"  id="selectedType" isCondition="false"/>
									<input placeholder="<spring:message code="sys.login.tip.iputADM" />" name="name" class="form-control" type="search" likeOption="true" />
									<div class="btn-group">
										<button type="button" class="btn btn-primary" data-btn-type="search"><spring:message code="common.query" /></button>
									</div>						
								</div>
								<div class="box-body">
									<table id="userRole_selected_table" class="table table-bordered table-striped table-hover">
									</table>
								</div>
								<!-- /.box-body -->
							</div>
							<!-- /.box -->
						</div>
					</div>
					<div class="box-footer">
						<div class="text-center">
							<button type="button" class="btn btn-default"
								data-btn-type="cancel" data-dismiss="modal">
								<i class="fa fa-reply">&nbsp;<spring:message code="sys.essay.back" /></i>
							</button>
						</div>
					</div>
	           		 </div>
	         	      <div class="tab-pane" id="tab-content-author">
              				<div class="row">
							<div class="col-md-3">
								<div class="box box-primary">
									<div class="box-body box-profile">
										<div id="tree"></div>
									</div>
								</div>
							</div>
							<!-- /.col -->
							<div class="col-md-9">
								<div class="box box-primary">
									<div class="box-header with-border">
										<!-- /.box-tools -->
									</div>
									<!-- /.box-header -->
									<div class="box-body" style="min-height: 420px">
									<input type="hidden" id="language" name="language" value=""/>
										<input type="hidden" id="roleIdAuthor" name="roleIdAuthor" value="" />
					
										<div class="panel panel-primary">
											<div class="panel-heading">
												<h3 class="panel-title"><spring:message code="sys.role.viewFunctionSelect" /></h3>
											</div>
											<div class="panel-body">
												<textarea class="form-control" rows="20" disabled id="menutext">
												</textarea>
											</div>
										</div>
										<div class="box-footer">
											<div class="text-center">
												<button type="button" class="btn btn-default"
													data-btn-type="cancel" data-dismiss="modal">
													<i class="fa fa-reply">&nbsp;<spring:message code="sys.essay.back" /></i>
												</button>
												<button data-btn-type="saveAuth" class="btn btn-primary">
													<i class="fa fa-save">&nbsp;<spring:message code="common.save"/></i>
												</button>
											</div>
										</div>
										<!-- /.box-body -->
									</div>
									<!-- /. box -->
								</div>
							</div>
							<!-- /.row -->
					
						</div>

              		</div>
			      <div class="tab-pane" id="tab-content-edit">
			           	<form:form id="role-form" name="role-form" class="form-horizontal"
						modelAttribute="role">
						<form:hidden path="id" />
						<input type='hidden' value="" id='addOrUpdate'>
						<input type='hidden' value='${CSRFToken}' id='csrftoken'>
						<div class="box-body">
				            <div class="col-md-6">
				               <div class="form-group">
				                   <%--  <label for="officeId" class="col-sm-3 control-label"><spring:message code="sys.role.organBelong" /></label>
				                    <div class="col-sm-8">
				                        <form:select path="officeId" class="form-control select2" style="width: 100%;">
				                            <form:options items="${fns:getOfficeList()}" itemLabel="name"
				                                itemValue="id" htmlEscape="false" />
				                        </form:select>
				                    </div> --%>
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
				                    <label for="name" class="col-sm-3 control-label"><spring:message code="sys.role.name" /><span style="color:red">*</span></label>
				                    <div class="col-sm-8">
				                        <input id="oldName" name="oldName" type="hidden"
				                            value="" />
				                      <form:input path="roleName"  class="form-control" htmlEscape="false" 
									 placeholder="${roleName}" />
				                    </div>
				                </div>
				                <div class="form-group">
				                    <label for="enname" class="col-sm-3 control-label"><spring:message code="sys.role.enname" /><span style="color:red">*</span></label>
				                    <div class="col-sm-8">
				                        <input id="oldEnname" name="oldEnname" type="hidden"
				                            value="" />
				                        <form:input path="enname" class="form-control" htmlEscape="false"
				                            placeholder="${enname}" />
				                    </div>
				                </div>
				
				                <div class="form-group">
				                    <label for="roleType" class="col-sm-3 control-label"><spring:message code="sys.role.type" /><span style="color:red">*</span></label>
				                    <div class="col-sm-8">
				                        <form:select path="roleType" class="form-control select2">
				                            <form:option value="security-role"><spring:message code="sys.role.manageRole" /></form:option>
				                            <form:option value="user"><spring:message code="sys.role.normalRole" /></form:option>
				                        </form:select>
				                    </div>
				                </div>
				                 
				                <div class="form-group">
				                    <label for="remarks" class="col-sm-3 control-label"><spring:message code="common.instructions" /></label>
				                    <div class="col-sm-8">
				                        <form:textarea path="remarks" class="form-control"
				                            htmlEscape="false" rows="3" maxlength="200" />
				                    </div>
				                </div> 
				                 
				            </div>
				            <div class="col-md-6">
				                <div class="form-group">
				                    <label for="sysData" class="col-sm-3 control-label"><spring:message code="sys.role.dataOfSys" /></label>
				                    <div class="col-sm-8">
				                        <form:select path="sysData" class="form-control select2" style="width: 100%;">
				                            <form:options items="${fns:getDictList('yes_no')}"
				                                itemLabel="label" itemValue="value" htmlEscape="false" />
				                        </form:select>
				                        <span class="help-inline"><spring:message code="sys.role.tip.dataOfSys" /></span>
				                    </div>
				                </div>
				                <div class="form-group">
				                    <label for="useable" class="col-sm-3 control-label"><spring:message code="sys.role.useState" /><span style="color:red">*</span></label>
				                    <div class="col-sm-8">
				                        <form:select path="useable" class="form-control select2" style="width: 100%;">
				                            <form:options items="${fns:getDictList('yes_no')}"
				                                itemLabel="label" itemValue="value" htmlEscape="false" />
				                        </form:select>
				                        <span class="help-inline"><spring:message code="sys.role.tip.useState" /></span>
				                    </div>
				                </div>
				                <div class="form-group">
				                    <label for="dataScope" class="col-sm-3 control-label"><spring:message code="sys.role.dataScope" /><span style="color:red">*</span></label>
				                    <div class="col-sm-8">
				                        <form:select path="dataScope" class="form-control select2" style="width: 100%;">
				                            <form:options items="${fns:getDictList('sys_data_scope')}"
				                                itemLabel="label" itemValue="value" htmlEscape="false" />
				                        </form:select>
				                        <span class="help-inline"><spring:message code="sys.role.tip.dataScope" /></span>
				                    </div>
				                </div>
				                
				            </div>
				        </div>
						<!-- /.box-body -->
						<div class="box-footer text-right">
							<button type="button" class="btn btn-default" data-btn-type="cancel"
								data-dismiss="modal"><spring:message code="common.cancel" /></button>
							<c:if
								test="${(role.sysData eq fns:getDictValue('是', 'yes_no', '1') && fns:getUser().admin)||!(role.sysData eq fns:getDictValue('是', 'yes_no', '1'))}">
								<shiro:hasPermission name="sys:role:edit">
									<button type="submit" class="btn btn-primary" data-btn-type="save"><spring:message code="common.submit" /></button>&nbsp;</shiro:hasPermission>
							</c:if>
				
						</div>
					</form:form>
							           			
			      </div>
                 		<div class="tab-pane active" id="tab-content-list">
                 			<div class="row">
						<div class="col-xs-7">
							<div class="box-body">
				                  	  <div  id="roleSearchDiv" class="dataTables_filter "  role="form" >
				                            <input placeholder="<spring:message code="sys.role.tip.iputRoleName" />" name="name" class="form-control"
				                            type="search" likeOption="true" />
				                            <button type="button" class="btn btn-primary"
				                                data-btn-type="search"><spring:message code="common.query"/></button>
				                            <button type="button" class="btn btn-default"
				                                data-btn-type="reset"><spring:message code="common.reset"/></button>
				                            <button type="button" class="btn btn-default" data-btn-type="roleAdd"><spring:message code="sys.role.addRole" /></button>
						                    <shiro:hasPermission name="sys:role:assign">
						                    <button type="button" class="btn btn-default" data-btn-type="roleAssign"><spring:message code="common.RoleAuthorMenu" /></button>
						                    </shiro:hasPermission>
						                    <shiro:hasPermission name="sys:role:edit">
						                    <button type="button" class="btn btn-default" data-btn-type="roleEdit"><spring:message code="sys.role.modifyRole" /></button>
						                    <button type="button" class="btn btn-default"  data-btn-type="roleDelete" ><spring:message code="common.delete" /></button>
						                   </shiro:hasPermission>
						                  
				                   	 </div>
								<div class="box-body">
									<table id="roletable" class="table table-bordered table-striped table-hover">
									</table>
								</div>
								</div>
						</div>
						<div class="col-xs-5">
							<div class="box-body">
								<div id="userSearchDiv" class=" dataTables_filter "  role="form" >
				                            <input type="hidden"  name="roleId" value="" id="roleId"/>
				                            <input placeholder="<spring:message code="sys.login.tip.iputADM"/>"  name="name" style="margin-left:-10em;" class="form-control" type="search" likeOption="true" />
				                            <button type="button" class="btn btn-primary"  data-btn-type="search"><spring:message code="common.query"/></button>
				                            <button type="button" class="btn btn-default"   data-btn-type="selectUserRole"><spring:message code="commom.RoleUserBindingDeregulation"/></button>
				               	             <button type="button" class="btn btn-default" data-btn-type="deleteRoleUser"><spring:message code="common.delete"/></button>
				               	 	</div>
								<div class="box-body">
									<table id="user_table" class="table table-bordered table-striped table-hover">
									</table>
								</div>
							<!-- /.box-body -->
							</div>
						</div>
					</div>
                 		</div>
                 </div>		
   </div>
</section>


<script>
	//设置标题
	function setTitle(title){
	    $("ul.nav-tabs li.header small").text(title);
	 }
	// 角色列表
	var roleTable; 
	//角色弹出框
	var winId = "roleWin"; 
	// 角色用户列表
	var unselectedTable,selectedTable; 
	// 新增角色表单
	var roleform=null; 
	$(function() {
		
		// 新增角色初始化为空
	 	$("#addOrUpdate").val(""); 
	 	//初始化新增角色表单
		roleform=$("#role-form").form(); 
		
		//部门选择树
		$("button[data-flag='org']").org({
	            idField: $("#orgSelect"),
	            nameField: $("#deptName"),
	            title:'<spring:message code="common.SelectAgencyDepartmentDoubleClickToGeT"/>'
	        });
		
		$("#nav-tab-edit").on("click",function(){
			  roleform.clearForm();
			  $("#officeId").val("");
            	  $("#deptName").val("");
			  $("#addOrUpdate").val("add");
	        });
		//init table and fill data
		var config = {
		            resizeSearchDiv:false,
		        	pagingType:'simple',
		        	"iDisplayLength": 15,
		            language : {
		                url: basePath+'<spring:message code="common.language"/>'
		            },
		            rowClick:function(row,isSelected){  
						$("#roleId").val(isSelected?row.id:"-1");
						$("#name").remove();
						var roleIdNew=$("#roleId").val();
						if(isSelected){
							 $("#userSearchDiv").prepend("<h5 id='name' class='pull-left'>【"+row.name+"】</h5>");
							  userTable.reloadData({roleId:roleIdNew});
						}
					
				}
	        };
		 var userTable;
		 var config1={
					lengthChange:false,
					pagingType:'simple',
					language : {
			                url: basePath+'<spring:message code="common.language"/>'
			            }
				};
		var roleIdNew=$("#roleId").val();
	      userTable = new CommonTable("user_table", "userRoleTable", "userSearchDiv",
	    		  "/sys/user/findRoleUserList?selectedType=3&roleId="+roleIdNew+"",config1);  
	     
		//角色列表
		roleTable = new CommonTable("roletable", "role_list", "roleSearchDiv","/sys/role/list",config); 
		//默认选中第一行 
		setTimeout(function(){roleTable.selectFirstRow(true)},1);  
		//button event   
		$('button[data-btn-type]').click(
		function() {
			var action = $(this).attr('data-btn-type');
			var roleRowId=roleTable.getSelectedRowId();
			switch (action) {
			case "saveAuth":
				var roleIdAuthor = $("#roleIdAuthor").val();
				var nodes = $("#tree").data("treeview").getChecked();
				var rflist = [];
				for (var i = 0; i < nodes.length; i++) {
					var curNode = nodes[i];
					rflist.push(curNode.id);
				}
				//批量保存选中节点
				ajaxPost(basePath + "/sys/role/assignrole", {
					roleId : roleIdAuthor,
					menuIds : JSON.stringify(rflist)
				}, function(data, status) {
					   modals.info(data.message);
					   $("#nav-tab-list").click();
					  setTitle("<spring:message code="sys.role"></spring:message>");
					  $("#csrftoken").val("");
				});
				break;
			case 'roleAdd':
		                  setTitle('<spring:message code="sys.role.addRole"/>');
		                  roleform.clearForm();
		                  $("#nav-tab-edit").click();
		                  $("#officeId").val("");
		                  $("#deptName").val("");
		                  $("#addOrUpdate").val("add");
					break;
			case 'roleEdit':
				if (!roleRowId) {
					modals.info({
			                        title:'<spring:message code="common.sys.info" />', 
			                        cancel_label:'<spring:message code="common.close" />',
			                        text:'<spring:message code="sys.role.tip.selectLine" />'});
					return false;
				}
				setTitle("<spring:message code="sys.role.modifyRole"/>【"+roleTable.getSelectedRowData().name+"】");
	                  $("#nav-tab-edit").click();
	             	$("#addOrUpdate").val("update");
	             	 $("#deptName").val("");
	             	ajaxPost(basePath+"/sys/role/selectRole?id="+ roleRowId,null,function(data){
	             	
 					 $("#deptName").val(data.officeName);
	                    	 //重置
	                    	 roleform.clearForm();
	                    	 //赋值
	                    	 $("#oldEnname").val(data.enname);
		 	             $("#oldName").val(data.roleName);
	                    	 roleform.initFormData(data);
	                    	
	 			  });
				break;
			case 'roleDelete':
				if (!roleRowId) {
					modals.info({
                        title:'<spring:message code="common.sys.info" />', 
                        cancel_label:'<spring:message code="common.close" />',
                        text:'<spring:message code="sys.role.tip.selectLine" />'}); 
					return false;
				}
				var sizeList=userTable.data.pageInfo.size;
				if(sizeList>0){
					modals.info({
                        title:'<spring:message code="common.sys.info" />', 
                        cancel_label:'<spring:message code="common.close" />',
                        text:'<spring:message code="common.deleteUserInfo" />'}); 
					return false;
				}
				modals.confirm({
                                cancel_label:'<spring:message code="common.cancel" />',
                                title:'<spring:message code="common.sys.confirmTip" />',
                                ok_label:'<spring:message code="common.confirm" />',
                                text:'<spring:message code="common.confirm.delete" />', 
                                callback: function() {
					ajaxPost(
							basePath + "/sys/role/delete?id=" + roleRowId,
							null, function(data) {
								if (data.code == 200) {
									modals.correct({
										title:'<spring:message code="common.sys.success" />', 
										cancel_label:'<spring:message code="common.close" />',
										text:data.message});
									roleTable.reloadRowData();
								} else {
									modals.warn({
		                                title:'<spring:message code="common.sys.warn" />', 
		                                cancel_label:'<spring:message code="common.close" />',
		                                text:data.message});
								}
							});
				}});
				break;
			case 'selectUserRole':
				if(!roleRowId){
					modals.info('<spring:message code="common.PleaseSelectRoles" />');
					return;
				}
				setTitle("<spring:message code="commom.RoleUserBindingDeregulation"/>【"+roleTable.getSelectedRowData().name+"】");
                        $("#nav-tab-user").click();
                        $("#userRoleId").val("");
                        $("#userRoleId").val(roleTable.getSelectedRowData().id);
                        unselectedTable = new CommonTable("userRole_unselected_table", "userRoleTable", "searchDiv_unselected","/sys/user/findRoleUserList?selectedType=1&roleId="+roleTable.getSelectedRowData().id+"&num="+Math.random(),table_config);
                		selectedTable=new CommonTable("userRole_selected_table","userRoleTable","searchDiv_selected","/sys/user/findRoleUserList?selectedType=2&roleId="+roleTable.getSelectedRowData().id+"&num="+Math.random(),selected_config);
                		setTimeout(function(){unselectedTable.table.columns.adjust();},1);
				/* modals.openWin({
					winId:'roleMeunWin',
					width:1000,
					title:'<spring:message code="sys.role" />【'+roleTable.getSelectedRowData().name+'】<spring:message code="common.bindingUser" />',
					url : basePath
					+ '/sys/user/selectUserRole?roleId='
					+ roleRowId,
				    hideFunc:function(){userTable.reloadData();}
				}); */
				break;
			case 'deleteRoleUser':
				var userId=userTable.getSelectedRowId();
				if(!userId){
					modals.info('<spring:message code="common.PleaseSelectUser" />');
					return false;
				}
				modals.confirm({
                                cancel_label:'<spring:message code="common.cancel" />',
                                title:'<spring:message code="common.sys.confirmTip" />',
                                ok_label:'<spring:message code="common.confirm" />',
                                text:'<spring:message code="common.confirm.delete" />', 
                                callback: function() {
					ajaxPost(
							basePath + "/sys/user/deleteUR?roleId=" +roleRowId+"&userId="+userId,
							null, function(data) {
								if (data.code == 200) {
									userTable.reloadRowData();
								} else {
									modals.warn({
		                                title:'<spring:message code="common.sys.warn" />', 
		                                cancel_label:'<spring:message code="common.close" />',
		                                text:data.message});
								}
							});
				}});
				break;
			case 'roleAssign':
				if (!roleRowId) {
					modals.info({
						    title:'<spring:message code="common.sys.info" />', 
                            cancel_label:'<spring:message code="common.close" />',
                            text:'<spring:message code="sys.role.tip.selectLine" />'});
					return false;
				}
				 setTitle('<spring:message code="sys.role" />【'+roleTable.getSelectedRowData().name+ '】<spring:message code="sys.role.bindFunctioin" />');
		             $("#nav-tab-author").click();
		             ajaxPost(basePath+"/sys/role/selectRoleIdAssign?id="+ roleRowId,null,function(data){
			             	$("#roleIdAuthor").val(data.id);
			             	$("#language").val(data.language);
			             	//初始化form表单
			            	var pre_ids = data.menuIds.split(",");
			            	console.log(data.menuIds);
			             	//初始化菜单树
			        		initTree(0);
			        		initChecked(pre_ids);
		 			  });
				break;
			case 'cancel':
	                    $("#nav-tab-list").click();
	                 	setTitle("<spring:message code="sys.role"></spring:message>");
	                  break;
			}
		});
		
		 
		//the table config of opened window
		/* var table_config=null; */
	 	var table_config={ 
	 			     "scrollY":"270px",
		                 "scrollCollapse": true,
		                 "singleSelect":false,
		                 "scrollXInner":"450px", 
		                 "autoWidth":false,
		             	lengthChange:false,
				      pagingType:'simple',
				      language : {
			                url: basePath+'<spring:message code="common.language"/>'
			            }
                 //"lengthChange":false
		                 };     
		var selected_config={
				      "scrollY":"270px",
		                  "scrollCollapse": true,
		                  "singleSelect":false,
		                  "autoWidth":false,
		                  lengthChange:false,
				      pagingType:'simple',
				      language : {
			                url: basePath+'<spring:message code="common.language"/>'
			            }
		                   };
		//button event  
		
		//绑定角色到用户
		$("#btn_add_ur").click(function(){
	      var roleId=$("#userRoleId").val();
            var rows=unselectedTable.getSelectedRowsData();
            var urlist=[]; 
            //console.log(JSON.stringify(rows));                 
            if(!rows){ 
            	modals.info('<spring:message code="common.PleaseSelectUserWhoWantToBindThisRole" />');
            	return;
            }
            $.each(rows,function(index,row){                	
            	var urObj={};
            	urObj.userId=row.id;
            	urObj.roleId=roleId;
            	urlist.push(urObj);
            });
            ajaxPost(basePath+"/sys/user/insertUserRoleAddDelete?flag=add",{"urlist":JSON.stringify(urlist)},function(data){
            	if(data.code==200){
				modals.info(data.message);            		
            		selectedTable.reloadData();
            		unselectedTable.reloadRowData();                		
            	}
            });
       
		});
		
		//解绑用户
		$("#btn_remove_ur").click(function(){
			var roleId=$("#userRoleId").val();
			var rows=selectedTable.getSelectedRowsData();
			if(!rows){
				modals.info('<spring:message code="common.PleaseSelectUserWhoWantToUnbing" />');
				return;
			}
			 var urlist=[]; 
			 $.each(rows,function(index,row){                	
	            	var urObj={};
	            	urObj.userId=row.id;
	            	urObj.roleId=roleId;
	            	urlist.push(urObj);
	            });
			ajaxPost(basePath+"/sys/user/insertUserRoleAddDelete?flag=delete",{"urlist":JSON.stringify(urlist)},function(data){
				if(data.code==200){
					modals.info(data.message);
					unselectedTable.reloadRowData();
	            		selectedTable.reloadData();                		
				}
			})
		});
		//数据校验
		$("#role-form").bootstrapValidator({
			message : '<spring:message code="common.promt.value" />',
			feedbackIcons : {
				valid : 'glyphicon glyphicon-ok',
				invalid : 'glyphicon glyphicon-remove',
				validating : 'glyphicon glyphicon-refresh'
			},
			fields : {
				name : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.role.tip.inputName" />'
						}
					}
				},
				enname : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.role.enname"/>'
						},
						stringLength: {
	                         min: 1,
	                         max: 50,
	                         message: '<spring:message code="sys.role.promt.enname.length"/>'
	                     },
	                     remote:{
					        	url:basePath+"/sys/role/checkEnname", 
					        	delay :  2000,
					        	data: function(validator) {
					        		console.log(validator);
		                            return {
		                            	   oldEnname:$('#oldEnname').val(),
		                            	   enname:$('#enname').val(),
		                            	   id:$('#id').val()
		                            };
		                        },
					        	message:'<spring:message code="sys.role.promt.enname.used"/>'
					        } 
					}
				},
				roleName : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.user.promt.login.name"/>'
						},
						stringLength: {
	                         min: 1,
	                         max: 50,
	                         message: '<spring:message code="sys.role.promt.name.length"/>'
	                     },
	                     remote:{
					        	url:basePath+"/sys/role/checkName", 
					        	delay :  2000,
					        	data: function(validator) {
			                            return {
			                            	oldName:$('#oldName').val(),
			                            	roleName:$('#roleName').val(),
			                            	   id:$('#id').val()
			                            };
		                        },
		                     	  
					        	message:'<spring:message code="sys.role.promt.name.used"/>'
					        } 
					}
				}
			}
		}).on("success.form.bv",function(e){
			    e.preventDefault();
				modals.confirm('<spring:message code="common.confirm.save" />', function() {
					//Save Data，对应'submit-提交'
					var params = roleform.getFormSimpleData();
					var orgSelect = $("#orgSelect").val();
					if(orgSelect == null || orgSelect == undefined || orgSelect ==""){
						modals.info('<spring:message code="common.OrganizationOrDepartmentIsNUll"/>');
						return ;
					};
					ajaxPost(basePath+'/sys/role/save', params, function(data, status) {
						if(data.code == 200){
							if(id!="0"){//更新
								modals.correct({
										title:'<spring:message code="common.sys.success" />', 
										  cancel_label:'<spring:message code="common.close" />',
				                                text:data.message});
								roleTable.reloadRowData(id);
								
							}else{//新增 
								 modals.correct({
		                                title:'<spring:message code="common.sys.success" />', 
		                                cancel_label:'<spring:message code="common.close" />',
		                                text:data.message});
								 roleTable.reloadRowData();
								
							}
							  $("#nav-tab-list").click();
							  setTitle("<spring:message code="sys.role"></spring:message>");
							  $("#csrftoken").val("");
						}else{
							modals.error(data.message);
						}				 
					});
				});
		});
		//初始化控件
	});
	function resetRoleForm(){
		roleform.clearForm();
		$("#role-form").data('bootstrapValidator').resetForm();
	}
	function initChecked(pre_ids) {
		var nodes = [];
		var textValue = "";
		nodes = $("#tree").treeview('getUnchecked');
		$.each(nodes, function(index, node) {
			$.each(pre_ids, function(index, value) {
				if (value === node.id) {
					$("#tree").data('treeview').checkNode(node, {
						silent : true
					});
					textValue += node.text + "\r";
				}
			});
		});
		setValueForText();
	}

	function checkNode(data) {
		if (data.parentId == undefined) {
			return;
		}
		$('#tree').treeview('checkNode', [ data, {
			silent : true
		} ]);
		var pnode = $('#tree').data('treeview').getParent(data);
		$('#tree').treeview('checkNode', [ pnode, {
			silent : true
		} ]);
		checkNode(pnode);
	}

	function unCheckNode(data) {
		$('#tree').treeview('uncheckNode', [ data.nodeId, { silent: true}]);
		if (data == undefined||data.nodes == undefined) {
			return;
		}else{
			$.each(data.nodes,function(index,node){
        			unCheckNode(node);
        	});
		}
	}

	function setValueForText() {
		var nodes = [];
		var textValue = "";
		nodes = $('#tree').treeview('getChecked', nodes);
		$.each(nodes, function(index, node) {
			textValue += node.text + "\r";
		});
		$('#menutext').val(textValue);
	}
	function initTree(selectNodeId) {
		var treeData = null;
		var language = $("#language").val();
		ajaxPost(basePath + "/sys/menu/treeData?language="+language, null, function(data) {
			treeData = data;
		});
		$("#tree").treeview({
			data : treeData,
			showBorder : true,
			showCheckbox : true,
			levels : 1,
			showIcon : false,
			onNodeChecked : function(event, data) {
				checkNode(data);
				setValueForText();
			},
			onNodeUnchecked : function(event, data) {
				unCheckNode(data);
				setValueForText();
			}
		});
		if (treeData.length == 0)
			return;
	}
</script>
<style type="text/css">
 .treeview {
		 overflow-y:auto;
		 height:300px;
		 }
</style>