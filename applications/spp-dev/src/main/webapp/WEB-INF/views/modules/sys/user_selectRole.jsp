<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title">选择角色</h5>
</div>

<!-- Main content -->
<div class="modal-body" style="height:580px;">
    <div class="row">
			<!-- /.col -->
			<div class="col-md-6">
				<div class="box box-primary">
					<!-- /.box-header -->
					<div class="box-header with-border">
					   <h5 class="box-title" style="font-size:14px;">未绑定的角色列表</h5>
					   <button type="button" id="btn_add_ur" class="btn btn-sm close" title="绑定角色" ><li class="fa fa-arrow-right"></li></button>
					</div>
					<div class="dataTables_filter" id="searchDiv_unselected">
					    <input type="hidden" value="${userId}" name="userId" isCondition="false"/>
					    <input type="hidden" value="1" name="selectedType"  id="selectedType" isCondition="false"/>
					    
						<input placeholder="请输入角色" name="name" class="form-control form-control-sm" type="search" likeOption="true" />
						<div class="btn-group">
							<button type="button" class="btn btn-primary" data-btn-type="search" >查询</button>
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
					   <h5 class="box-title" style="font-size:14px;float:right">已绑定的角色列表</h5>
					   <button type="button" id="btn_remove_ur" class="btn btn-sm close" style="float:left" title="解绑角色" ><li class="fa fa-arrow-left"></li></button>
					</div>
					<div class="dataTables_filter" id="searchDiv_selected">
					    <input type="hidden" value="${userId}" name="userId"/>
					     <input type="hidden" value="2" name="selectedType"  id="selectedType" isCondition="false"/>
						<input placeholder="请输入角色名" name="name" class="form-control" type="search" likeOption="true" />
						<div class="btn-group">
							<button type="button" class="btn btn-primary" data-btn-type="search">查询</button>
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
	var roleId="${userId}";
	var unselectedTable,selectedTable;
	$(function() { 
		
	 	var table_config={ 
	 			 "scrollY":"270px",
                 "scrollCollapse": true,
               
                 "singleSelect":false,
                 "scrollXInner":"450px", 
                 "autoWidth":false,
             	 lengthChange:false,
				  pagingType:'simple'
		                 };     
		unselectedTable = new CommonTable("userRole_unselected_table", "userRoleTable", "searchDiv_unselected","/sys/user/findRoleUserList?selectedType=1&roleId="+roleId+"",table_config);
		setTimeout(function(){unselectedTable.table.columns.adjust();},100);
		
		
		var selected_config={
				  "scrollY":"270px",
                  "scrollCollapse": true,
                  "singleSelect":false,
                  "autoWidth":false,
                  lengthChange:false,
				  pagingType:'simple'
		                   };
		selectedTable=new CommonTable("userRole_selected_table","userRoleTable","searchDiv_selected","/sys/user/findRoleUserList?selectedType=2&roleId="+roleId+"",selected_config);
		
		//绑定角色到用户
		$("#btn_add_ur").click(function(){
            var rows=unselectedTable.getSelectedRowsData();
            var urlist=[]; 
            if(!rows){ 
            	modals.info("请选择要绑定该角色的用户");
            	return;
            }
            $.each(rows,function(index,row){                	
            	var urObj={};
            	urObj.userId=row.id;
            	urObj.roleId=roleId;
            	urlist.push(urObj);
            });
            parent.$("#roleName").val("1111111111111");
		});
		
		//解绑用户
		$("#btn_remove_ur").click(function(){
			var rows=selectedTable.getSelectedRowsData();
			if(!rows){
				modals.info("请选择要解绑的用户");
				return;
			}
			 var urlist=[]; 
			 $.each(rows,function(index,row){                	
	            	var urObj={};
	            	urObj.userId=row.id;
	            	urObj.roleId=roleId;
	            	urlist.push(urObj);
	            });
		})
	})
	
	</script>