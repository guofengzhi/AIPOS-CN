<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="#"><i class="fa fa-dashboard"></i> <spring:message code="common.homepage" /></a></li>
		<li><a href="#"><spring:message code="common.sys.management" /></a></li>
		<li class="active"><spring:message code="sys.organ.manage" /></li>
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
					<div id="officetree"></div>
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
							data-btn-type="addOfficeRoot">
							<li class="fa fa-plus">&nbsp;<spring:message code="sys.organ.addTopOrgan" /></li>
						</button>
						<button type="button" class="btn btn-default" data-btn-type="addOffice">
							<li class="fa fa-plus">&nbsp;<spring:message code="sys.organ.addChlidOrgan" /></li>
						</button>
						<button type="button" class="btn btn-default" data-btn-type="editOffice">
							<li class="fa fa-edit">&nbsp;<spring:message code="sys.organ.modifyOrgan" /></li>
						</button>
						<button type="button" class="btn btn-default"
							data-btn-type="deleteOffice">
							<li class="fa fa-remove">&nbsp;<spring:message code="sys.organ.deleteOrgan" /></li>
						</button>
					</div>
					<!-- /.box-tools -->
				</div>
				<!-- /.box-header -->
				<div class="box-body">
					<form class="form-horizontal" id="office-form">
						<input type="hidden" name="parentId" />
						<input type='hidden' value='${CSRFToken}' id='csrftoken'>
						<div class="form-group">
							<label for="parentName" class="col-sm-2 control-label"><spring:message code="sys.organ.parentOrgan" /></label>

							<div class="col-sm-9">
								<input type="text" class="form-control" disabled="disabled"
									id="parentName" name="parentName" placeholder='<spring:message code="sys.organ.parentOrgan" />'>
							</div>
						</div>

						<div class="form-group">

							<label for="name" class="col-sm-2 control-label"><spring:message code="sys.organ.name" /><span style="color:red">*</span></label>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="name" name="name"
									placeholder='<spring:message code="sys.organ.name" />'>
							</div>
						</div>
						<div class="form-group">
							<label for="code" class="col-sm-2 control-label"><spring:message code="sys.organ.code" /><span style="color:red">*</span></label>

							<div class="col-sm-9">
								<input type="text" class="form-control" id="code" name="code"
									placeholder='<spring:message code="sys.organ.code" />'>
							</div>
						</div>
						<div class="form-group">
							<label for="sort" class="col-sm-2 control-label"><spring:message code="sys.organ.sort" /></label>

							<div class="col-sm-9">
								<input type="text" class="form-control" id="sort"
									name="sort" placeholder='<spring:message code="sys.organ.sort" />'>
							</div>
						</div>
						<div class="form-group">
							<label for="grade" class="col-sm-2 control-label"><spring:message code="sys.organ.level" /><span style="color:red">*</span></label>
							<div class="col-sm-9">
								<select id ="grade" name="grade" class="form-control select2">
									<option value="1" selected="selected"><spring:message code="sys.organ.oneLevel"  /></option>
									<option value="2"><spring:message code="sys.organ.twoLevel" /></option>
									<option value="3"><spring:message code="sys.organ.threeLevel" /></option>
									<option value="4"><spring:message code="sys.organ.fourLevel" /></option>
									
								</select>
							<!-- 	<input type="text" class="form-control" id="sort"
									name="grade" placeholder="层级排序">
							 -->
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label"><spring:message code="sys.organ.userState" /><span style="color:red">*</span></label>
							<div class="col-sm-9">
								<label class="control-label"> <input type="radio"
									name="useable" class="flat-red" checked="checked" value="1">
									<spring:message code="sys.organ.used" />
								</label> &nbsp;&nbsp;&nbsp; <label class="control-label"> <input
									type="radio" name="useable" class="flat-red" value="0">
									<spring:message code="sys.organ.unUsed" />
								</label>
							</div>
						</div>
						<div class="form-group">
							<label for="master" class="control-label col-sm-2"><spring:message code="sys.organ.head" /></label>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="master"
									name="master" placeholder='<spring:message code="sys.organ.head" />'>
							</div>
						</div>

						<div class="form-group">
							<label for="address" class="control-label col-sm-2"><spring:message code="sys.organ.address" /></label>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="address"
									name="address" placeholder='<spring:message code="sys.organ.address" />'>
							</div>
						</div>
						<div class="form-group">
							<label for="zipCode" class="control-label col-sm-2"><spring:message code="sys.organ.postCode" /></label>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="zipCode"
									name="zipCode" placeholder='<spring:message code="sys.organ.postCode" />'>
							</div>
						</div>
						<div class="form-group">
							<label for="fax" class="control-label col-sm-2"><spring:message code="sys.organ.fax" /></label>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="fax" name="fax"
									placeholder='<spring:message code="sys.organ.fax" />'>
							</div>
						</div>

						<div class="form-group">
							<label for="phone" class="control-label col-sm-2"><spring:message code="sys.organ.phone" /></label>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="phone" name="phone"
									placeholder='<spring:message code="sys.organ.phone" />'>
							</div>
						</div>

						<div class="form-group">
							<label for="email" class="control-label col-sm-2"><spring:message code="sys.organ.email" /></label>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="email" name="email"
									placeholder='<spring:message code="sys.organ.email" />'>
							</div>
						</div>

						<div class="form-group">
							<label for="remarks" class="col-sm-2 control-label"><spring:message code="common.instructions" /></label>

							<div class="col-sm-9">
								<textarea class="form-control" id="remarks" name="remarks"
									placeholder='<spring:message code="common.instructions" />'></textarea>
							</div>
						</div>
						<div class="box-footer" style="display: none">
							<div class="text-center">
								<button type="button" class="btn btn-default"
									data-btn-type="cancel">
									<i class="fa fa-reply">&nbsp;<spring:message code="common.cancel" /></i>
								</button>
								<button type="submit" class="btn btn-primary">
									<i class="fa fa-save">&nbsp;<spring:message code="common.save" /></i>
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
			var officeform =null;
			$(function() {
				//初始化form表单
				officeform=$("#office-form").form();

				initTree(0); 
				//初始化校验
				$("#office-form").bootstrapValidator({
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
									message : '<spring:message code="sys.organ.tip.inputName" />'
								}
							}
						},
						code : {
							validators : {
								notEmpty : {
									message : '<spring:message code="sys.organ.tip.inputCode" />'
								}
						/* ,
						        remote:{
						        	url:basePath+"/base/checkUnique", 
						        	data: function(validator) {
			                            return {
			                                className:'com.cnpc.framework.base.entity.Dict',
			                                fieldName:'code',
			                                fieldValue:$('#code').val(),
			                                id:$('#id').val()
			                            };
			                        },
						        	message:'该编码已被使用'
						        }  */
							}
						},
						sort : {
							validators : {
								notEmpty : {
									message : '<spring:message code="sys.organ.inputSort" />'
								}
							}
						},
						deleted : {
							validators : {
								notEmpty : {
									message : '<spring:message code="sys.organ.tip.selectUsestate" />'
								}
							}
						},
						grade : {
							validators : {
								notEmpty : {
									message : '<spring:message code="sys.organ.grade.is.not.empty" />'
								}
							}
						}
					}
				}).on("success.form.bv",function(e){
					    // 阻止默认事件提交
					    e.preventDefault();
						modals.confirm({
                            cancel_label:'<spring:message code="common.cancel" />',
                            title:'<spring:message code="common.sys.confirmTip" />',
                            ok_label:'<spring:message code="common.confirm" />',
                            text:'<spring:message code="common.confirm.save" />', 
                            callback: function(){
							//Save Data，对应'submit-提交'
							var params = officeform.getFormSimpleData();
							ajaxPost(basePath + '/sys/office/save', params, function(data, status) {
								if (data.code == 200) {
									modals.correct(data.message);
									var selectedArr=$("#officetree").data("treeview").getSelected();
									var selectedNodeId=selectedArr.length>0?selectedArr[0].nodeId:0;
								    initTree(selectedNodeId);
								}else{
									modals.warn({
                                        title:'<spring:message code="common.sys.success" />', 
                                        cancel_label:'<spring:message code="common.close" />',
                                        text:data.message});
								}
							});
						}});
				});
				
				//按钮事件
				var btntype=null;
				$('button[data-btn-type]').click(function() {
					var action = $(this).attr('data-btn-type');
					var selectedArr=$("#officetree").data("treeview").getSelected();
					var selectedNode=selectedArr.length>0?selectedArr[0]:null;
					switch (action) {
					case 'addOfficeRoot':
						officeform.formWritable(action);
						officeform.clearForm();
						fillParentAndSort(null);
						$("#grade").attr("disabled",false);
						btntype='addOffice';
						break; 
					case 'addOffice':
						if(!selectedNode){
							return false;
							modals.info('<spring:message code="sys.organ.tip.selectParentOrgan" />');
						}
						officeform.formWritable(action);
						officeform.clearForm();
						//填充上级字典和层级编码
						fillParentAndSort(selectedNode);
						$("#grade").attr("disabled",false);
						btntype='addOffice';
						break;
					case 'editOffice':
						if(!selectedNode){
							modals.info('<spring:message code="sys.organ.tip.selectModifyNode" />');
							return false;
						}
						if(btntype=='addOffice'){
							fillDictForm(selectedNode);
						}
						officeform.formWritable(action);
						
						$("#grade").attr("disabled",false);
						//alert($.parseJSON(officeform));
						
						//officeform.grade.disabled="value";
						btntype='editOffice';
						break;
					case 'deleteOffice':
						if(!selectedNode){
							modals.info('<spring:message code="sys.organ.tip.selectDeleteNode" />');
							return false;
						}
						if(btntype=='addOffice')
							fillDictForm(selectedNode);
						officeform.formReadonly();
						$(".box-header button[data-btn-type='deleteOffice']").removeClass("btn-default").addClass("btn-primary");
					    if(selectedNode.nodes){
					    	modals.info('<spring:message code="sys.organ.tip.haveChildNode" />');
					    	return false;
					    }
					    modals.confirm("<spring:message code='sys.organ.confirm.deleteNode'/>",function(){
					    	ajaxPost(basePath+"/sys/office/delete?id="+selectedNode.id,null,function(data){
					    		if(data.success){
					    		   modals.correct({
	                                       title:'<spring:message code="common.sys.success" />', 
	                                       cancel_label:'<spring:message code="common.close" />',
	                                       text:'<spring:message code="common.deleteSuccess" />'});	
					    		}else{
					    			modals.info({
                                        title:'<spring:message code="common.sys.info" />', 
                                        cancel_label:'<spring:message code="common.close" />',
                                        text:data.message});
					    		}
					    		//定位
					    		var brothers=$("#officetree").data("treeview").getSiblings(selectedNode);
					    		if(brothers.length>0) 
					    		   initTree(brothers[brothers.length-1].nodeId);
					    		else{
					    		   var parent=$("#officetree").data("treeview").getParent(selectedNode);
					    		   initTree(parent?parent.nodeId:0); 
					    		}
					    	});
					    });
						break;
					case 'cancel':  
						if(btntype=='addOffice')
						fillDictForm(selectedNode);
						officeform.formReadonly();
						break;
					}
				});
			})
			
			function initTree(selectNodeId){
				var treeData = null;
				ajaxPost(basePath + "/sys/office/treeData", null, function(data) {
					treeData = data;
				});
				$("#officetree").treeview({
					data : treeData,
					showBorder : true,
					expandIcon : "glyphicon glyphicon-chevron-right",
					collapseIcon : "glyphicon glyphicon-chevron-down",
					//nodeIcon: 'glyphicon glyphicon-bookmark',
					showTags: true,
					levels : 1,
					onNodeSelected : function(event, data) {
						fillDictForm(data);
						officeform.formReadonly();
					}
				});
				if(treeData.length==0)
					return;
				//默认选中第一个节点 
				selectNodeId=selectNodeId||0;
				$("#officetree").data('treeview').selectNode(selectNodeId);
				$("#officetree").data('treeview').expandNode(selectNodeId);
				$("#officetree").data('treeview').revealNode(selectNodeId);
			}
			
			//新增时，带入父级字典名称id,自动生成sort
			function fillParentAndSort(selectedNode){
				$("input[name='parentName']").val(selectedNode?selectedNode.text:'机构名称');
			    $("input[name='deleted'][value='0']").prop("checked","checked");  
			    if(selectedNode){
			    	$("input[name='parentId']").val(selectedNode.id);
					var nodes=selectedNode.nodes;
					var levelCode=nodes?nodes[nodes.length-1].levelCode:null;
					$("input[name='sort']").val(getNextSort(levelCode));
			    }else{
			    	var brothers=$("#officetree").data("treeview").getSiblings(0);
			    	var levelCode="0";
			    	if(brothers&&brothers.length>0)
			    	   levelCode=brothers[brothers.length-1].levelCode;
			    	$("input[name='sort']").val(getNextSort(levelCode));    	
			    }
			}
			
			//填充form
			function fillDictForm(node){
				officeform.clearForm();
				ajaxPost(basePath+"/sys/office/get?id="+node.id,null,function(data){
					officeform.initFormData(data);
				})
			}
			
		</script>
