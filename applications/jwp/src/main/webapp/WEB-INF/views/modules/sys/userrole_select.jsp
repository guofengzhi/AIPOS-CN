<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="commom.RoleUserBindingDeregulation" /></h5>
</div>

<!-- Main content -->
<div class="modal-body" style="height:580px;">
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
					    <input type="hidden" value="${roleId}" name="roleId" isCondition="false"/>
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
					    <input type="hidden" value="${roleId}" name="roleId"/>
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

  </div>
	<script>
	//tableId,queryId,conditionContainer
	var roleId="${roleId}";//role Id
	var unselectedTable,selectedTable;
	$(function() { 
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
		//init table and fill data
		unselectedTable = new CommonTable("userRole_unselected_table", "userRoleTable", "searchDiv_unselected","/sys/user/findRoleUserList?selectedType=1&roleId="+roleId+"",table_config);
		setTimeout(function(){unselectedTable.table.columns.adjust();},100);
		//init userrole table  
		
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
		selectedTable=new CommonTable("userRole_selected_table","userRoleTable","searchDiv_selected","/sys/user/findRoleUserList?selectedType=2&roleId="+roleId+"",selected_config);
		//button event  
		
		//绑定角色到用户
		$("#btn_add_ur").click(function(){
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
		})
	})
	
</script>
<style type="text/css">
 div.dataTables_paginate ul.pagination {
	margin: 2px 0;
	white-space: nowrap;
	width:294px;
}
</style>