<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i><spring:message code="common.homepage"/></a></li>
		<li><a href="#"><spring:message code="common.sys.management"/></a></li>
		<li class="active"><spring:message code="sys.menu.management"/></li>
	</ol>
	<div class="col-md-12"></div>
</section>

<!-- Main content -->
<section class="content">

	<div class="row">
		<div class="col-md-3">

			<!-- Profile Image -->
			<div class="box box-primary">
				<div class="box-body box-profile">
					<div id="menutree"></div>
				</div>
				<!-- /.box-body -->
			</div>
			<!-- /.box -->
		</div>
		<!-- /.col -->
		<div class="col-md-9">
			<div class="box box-primary">
				<div class="box-header with-border">
					<div class="btn-group">
						<button type="button" class="btn btn-default"
							data-btn-type="addMenuRoot">
							<li class="fa fa-plus">&nbsp;<spring:message code="sys.menu.add.root"/></li>
						</button>
						<button type="button" class="btn btn-default" data-btn-type="menuAdd">
							<li class="fa fa-plus">&nbsp;<spring:message code="sys.menu.add.subordinate"/></li>
						</button>
						<button type="button" class="btn btn-default" data-btn-type="menuEdit">
							<li class="fa fa-edit">&nbsp;<spring:message code="sys.menu.edit"/></li>
						</button>
						<button type="button" class="btn btn-default"
							data-btn-type="menuDelete">
							<li class="fa fa-remove">&nbsp;<spring:message code="sys.menu.delete"/></li>
						</button>
					</div>
					<!-- /.box-tools -->
				</div>
				<!-- /.box-header -->
				<div class="box-body">
					<form class="form-horizontal" id="function-form">
						<input type="hidden" name="parentId" />
						<input type='hidden' value='${CSRFToken}' id='csrftoken'>
						<div class="form-group">
							<label for="parentName" class="col-sm-2 control-label"><spring:message code="sys.menu.superiors"/></label>

							<div class="col-sm-9">
								<input type="text" class="form-control" disabled="disabled"
									id="parentName" name="parentName" placeholder='<spring:message code="sys.menu.superior"/>'>
							</div>
						</div>

						<div class="form-group">
							<label for="name" class="col-sm-2 control-label"><spring:message code="sys.menu.name"/><span style="color:red">*</span></label>
							<div class="col-sm-9" id="showName">
								<input type="text" class="form-control" disabled="disabled"
									id="showName" name="showName" placeholder="<spring:message code="sys.menu.name"/>">
							</div>
							<div class="col-sm-9" id="addName">
							   <div class="col-xs-4" style="padding-left: 0px;padding-right: 0px;">
								   <div class="input-group">
								  <span class="input-group-addon"><spring:message code="sys.menu.name.zhcn"/></span>
									<input type="text" class="form-control" id="name" name="name"
										placeholder="<spring:message code="sys.menu.name"/>">
								 </div>
							   </div>
							 <div class="col-xs-4" style="padding-left: 0px;padding-right: 0px;">
							  <div class="input-group">
							  <span class="input-group-addon"><spring:message code="sys.menu.name.en"/></span>
								<input type="text" class="form-control" id="enName" name="enName"
									placeholder="<spring:message code="sys.menu.name"/>">
							 </div>
							 </div>
							  <div class="col-xs-4" style="padding-left: 0px;padding-right: 0px;">
							  <div class="input-group">
							  <span class="input-group-addon"><spring:message code="sys.menu.name.zhtw"/></span>
								<input type="text" class="form-control" id="tcName" name="tcName"
									placeholder='<spring:message code="sys.menu.name"/>'>
							 </div>
							 </div>  
							</div>
						</div>
						<div class="form-group">
							<label for="code" class="col-sm-2 control-label"><spring:message code="sys.menu.code"/><span style="color:red">*</span></label>

							<div class="col-sm-9">
								<input type="text" class="form-control" id="code" name="code"
									placeholder='<spring:message code="sys.menu.code"/>'>
							</div>
						</div>
						<div class="form-group">
							<label for="url" class="col-sm-2 control-label">URL</label>

							<div class="col-sm-9">
								<input type="text" class="form-control" id="url" name="url"
									placeholder="URL">
							</div>
						</div>
						<div class="form-group">
							<label for="levelCode" class="col-sm-2 control-label"><spring:message code="sys.menu.levelCode"/><span style="color:red">*</span></label>

							<div class="col-sm-9">
								<input type="text" class="form-control" id="levelCode"
									name="levelCode" placeholder='<spring:message code="sys.menu.levelCode"/>'>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label"><spring:message code="sys.menu.type"/><span style="color:red">*</span></label>
							<div class="col-sm-9">
								<label class="control-label"> <input type="radio"
									name="functype" class="flat-red" checked="checked" value="0">
									<spring:message code="sys.menu.catalog"/>
								</label> &nbsp;&nbsp;&nbsp; <label class="control-label"> <input
									type="radio" name="functype" class="flat-red" value="1">
									<spring:message code="sys.menu.menu"/>
								</label> &nbsp;&nbsp;&nbsp; <label class="control-label"> <input
									type="radio" name="functype" class="flat-red" value="2">
									<spring:message code="sys.menu.button"/>
								</label>
							</div>
						</div>
						<div class="form-group">
							<label for="icon" class="col-sm-2 control-label"><spring:message code="sys.menu.icon"/></label>
							<div class="col-sm-7">
								<i data-bv-icon-for="icon" id="icon_i"
									class="form-control-feedback fa fa-circle-o"
									style="right: 15px"></i> <input type="text"
									class="form-control" id="icon" name="icon" placeholder='<spring:message code="sys.menu.icon"/>'>
							</div>
							<div class="col-sm-2">
								<button type="button" id="selectIcon"
									class="btn btn-primary disabled" data-btn-type="selectIcon">
									<i class="fa fa-hand-pointer-o">&nbsp;<spring:message code="sys.menu.icon.select"/></i>
								</button>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label"><spring:message code="sys.menu.useState"/><span style="color:red">*</span></label>
							<div class="col-sm-9">
								<label class="control-label"> <input type="radio"
									name="isShow" class="flat-red" checked="checked" value="0">
									<spring:message code="enable"/>
								</label> &nbsp;&nbsp;&nbsp; <label class="control-label"> <input
									type="radio" name="isShow" class="flat-red" value="1">
									<spring:message code="disable"/>
								</label>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label"><spring:message code="sys.menu.permission"/></label>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="permission"
										name="permission" placeholder='<spring:message code="sys.menu.permission"/>'> <span
									class="help-inline"><spring:message code="sys.menu.permission.desc"/></span>
							</div>
						</div>
						<div class="form-group">
							<label for="remarks" class="col-sm-2 control-label"><spring:message code="sys.menu.demonstration"/></label>
							<div class="col-sm-9">
								<textarea class="form-control" id="remarks" name="remarks"
									placeholder='<spring:message code="sys.menu.demonstration"/>'></textarea>
							</div>
						</div>
						<div class="box-footer" style="display: none">
							<div class="text-center">
								<button type="button" class="btn btn-default"
									data-btn-type="cancel">
									<i class="fa fa-reply">&nbsp;<spring:message code="common.cancel"/></i>
								</button>
								<button type="submit" class="btn btn-primary">
									<i class="fa fa-save">&nbsp;<spring:message code="common.save"/></i>
								</button>
							</div>
						</div>
					</form>
				</div>
				<!-- /.box-body -->
			</div>
			<!-- /. box -->
		</div>
	</div>
	<!-- /.row -->

</section>

<script>
	       //初始化form表单
			var menuform = null;
			var winId='iconWin';
			$(function() {

				menuform=$('#function-form').form();
				initMenuTree(0); 
				//初始化校验
				$('#function-form').bootstrapValidator({
					message : '<spring:message code="common.promt.value"/>',
					feedbackIcons : {
						valid : 'glyphicon glyphicon-ok',
						invalid : 'glyphicon glyphicon-remove',
						validating : 'glyphicon glyphicon-refresh'
					},	
					fields : {
						name : {
							validators : {
								notEmpty : {
									message : '<spring:message code="sys.menu.promt.name"/>'
								}
							}
						},
						code : {
							validators : {
								notEmpty : {
									message : '<spring:message code="sys.menu.promt.code"/>'
								}/* ,
						        remote:{
						        	url:basePath+"/base/checkUnique", 
						        	data: function(validator) {
			                            return {
			                                className:'com.cnpc.framework.base.entity.Function',
			                                fieldName:'code',
			                                fieldValue:$('#code').val(),
			                                id:$('#id').val()
			                            };
			                        },
						        	message:'该编码已被使用'
						        } */
							}
						},
						levelCode : {
							validators : {
								notEmpty : {
									message : '<spring:message code="sys.menu.promt.levelCode"/>'
								}
							}
						},
						functype:{
							validators : {
								notEmpty : {
									message : '<spring:message code="sys.menu.promt.type"/>'
								}
							}
						},
						isShow:{
							validators : {
								notEmpty : {
									message : '<spring:message code="sys.menu.promt.is.show"/>'
								}
							}
						},
						deleted : {
							validators : {
								notEmpty : {
									message : '<spring:message code="sys.menu.promt.useState"/>'
								}
							}
						}
					}
				}).on("success.form.bv",function(e){
					 // 阻止默认事件提交
				     e.preventDefault();
						modals.confirm('<spring:message code="common.confirm.save"/>', function() {
							//Save Data，对应'submit-提交' 
							var params = menuform.getFormSimpleData();
							ajaxPost(basePath + '/sys/menu/save', params, function(data, status) {
								if (data.code == 200) {
									modals.correct(data.message);
									var selectedArr=$("#menutree").data("treeview").getSelected();
									var selectedNodeId=selectedArr.length>0?selectedArr[0].nodeId:0;
									initMenuTree(selectedNodeId);
								}else{
									modals.warn(data.message);
								}
							});
						});
				});
				
				//按钮事件
				var btntype=null;
				$('button[data-btn-type]').click(function() {
					var action = $(this).attr('data-btn-type');
					var selectedArr=$("#menutree").data("treeview").getSelected();
					var selectedNode=selectedArr.length>0?selectedArr[0]:null;
					switch (action) {
					case 'addMenuRoot':
						menuform.formWritable(action);
						$("#addName").show();
						$("#showName").hide();
						menuform.clearForm();
						$("#icon_i").removeClass();
						//填充上级菜单和层级编码
						fillParentAndLevelCode(null);
						btntype='menuAdd';
						break; 
					case 'menuAdd':
						if(!selectedNode){
							modals.info('<spring:message code="sys.menu.promt.superior"/>');
							return false;
						}
						menuform.formWritable(action);
						$("#addName").show();
						$("#showName").hide();
						menuform.clearForm();
						$("#icon_i").removeClass();
						//填充上级菜单和层级编码
						fillParentAndLevelCode(selectedNode);
						btntype='menuAdd';
						break;
					case 'menuEdit':
						if(!selectedNode){
							modals.info('<spring:message code="sys.menu.promt.edit"/>');
							return false;
						}
						if(btntype=='menuAdd'){
							fillMenuForm(selectedNode);
						}
						menuform.formWritable(action);
						$("#addName").show();
						$("#showName").hide();
						btntype='menuEdit';
						break;
					case 'menuDelete':
						if(!selectedNode){
							modals.info('<spring:message code="sys.menu.promt.delete"/>');
							return false;
						}
						if(btntype=='menuAdd')
							fillMenuForm(selectedNode);
						menuform.formReadonly();
						$("#addName").hide();
						$("#showName").show();
						$(".box-header button[data-btn-type='menuDelete']").removeClass("btn-default").addClass("btn-primary");
					    if(selectedNode.nodes){
					    	modals.info('<spring:message code="sys.menu.promt.delete.child"/>');
					    	return false;
					    }
					    modals.confirm('<spring:message code="common.confirm.delete" />',function(){
					    	ajaxPost(basePath+"/sys/menu/delete?id="+selectedNode.id,null,function(data){
					    		if(data.code == 200){
					    		   modals.correct('<spring:message code="sys.menu.promt.deleted" />');	
					    		}else{
					    			modals.info(data.message);
					    		}
					    		//定位
					    		var brothers=$("#menutree").data("treeview").getSiblings(selectedNode);
					    		if(brothers.length>0) 
					    			initMenuTree(brothers[brothers.length-1].nodeId);
					    		else{
					    		   var parent=$("#menutree").data("treeview").getParent(selectedNode);
					    		   initMenuTree(parent?parent.nodeId:0); 
					    		}
					    	});
					    });
						break;
					case 'cancel':  
						if(btntype=='add')
						fillMenuForm(selectedNode);
						menuform.formReadonly();
						$("#addName").hide();
						$("#showName").show();
						break;
					case 'selectIcon':
						var disabled=$(this).hasClass("disabled"); 
				        if(disabled)
				        	break;
						var iconName;
						if($("#icon").val())
						   iconName=encodeURIComponent($("#icon").val());
						modals.openWin({
                        	winId:winId,
                        	title:'<spring:message code="sys.menu.promt.icon.select"/>',
                        	width:'1000px',
                        	url:basePath+"/icon/nodecorator/select?iconName="+iconName
                        });
						break;
					}
				});
			})
			
			function initMenuTree(selectNodeId){
				var menuTreeData = null;
				ajaxPost(basePath + "/sys/menu/treeData", null, function(data) {
					menuTreeData = data;
				});
				$("#menutree").treeview({
					data : menuTreeData,
					showBorder : true,
					expandIcon : "glyphicon glyphicon-stop",
					collapseIcon : "glyphicon glyphicon-unchecked",
					levels : 1,
					onNodeSelected : function(event, data) {
						fillMenuForm(data);
						menuform.formReadonly();
						$("#addName").hide();
						$("#showName").show();
					}
				});
				if(menuTreeData.length==0)
					return;
				//默认选中第一个节点 
				selectNodeId=selectNodeId||0;
				$('#menutree').treeview('selectNode',selectNodeId);
				$("#menutree").data('treeview').expandNode(selectNodeId);
				$("#menutree").data('treeview').revealNode(selectNodeId);
			}
			
			//新增时，带入父级菜单名称id,自动生成levelcode
			function fillParentAndLevelCode(selectedNode){
				$("input[name='parentName']").val(selectedNode?selectedNode.text:'<spring:message code="sys.menu.sytem"/>');
			    $("input[name='deleted'][value='0']").prop("checked","checked");  
			    if(selectedNode){
			    	$("input[name='parentId']").val(selectedNode.id);
					var nodes=selectedNode.nodes;
					var levelCode=nodes?nodes[nodes.length-1].levelCode:null;
					$("input[name='levelCode']").val(getNextCode(selectedNode.levelCode,levelCode,6));
			    }else{
			    	var brothers=null;
			    	brothers=$("#menutree").data("treeview").getSiblings(0);
			    	var levelCode="000000";
			    	if(brothers&&brothers.length>0)
			    	   levelCode=brothers[brothers.length-1].levelCode;
			    	$("input[name='levelCode']").val(getNextCode("",levelCode,6));    	
			    }
			}
			
			//填充form
			function fillMenuForm(node){
				menuform.clearForm();
				ajaxPost(basePath+"/sys/menu/get?id="+node.id,null,function(data){
					menuform.initFormData(data);
					fillBackIconName(data.icon);
				})
			}
			//回填图标
			function fillBackIconName(icon_name){
				$("#icon").val(icon_name); 
				$("#icon_i").removeClass().addClass("form-control-feedback").addClass(icon_name);
			}
			
		</script>
