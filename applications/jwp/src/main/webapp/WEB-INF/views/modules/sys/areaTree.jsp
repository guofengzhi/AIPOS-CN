<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<link href="" rel="stylesheet">


<!-- Main content -->
<section class="content">

	<div class="row">
		<div class="col-md-4">

			<!-- Profile Image -->
			<div class="box box-primary">
				<div class="box-body box-profile">
					<div id="areatree"></div>
					<div >				
						<spring:message code="sys.area.allOrganOfArea" /> 
						<div id="officetree"></div>
					</div>
	
				</div>
				<!-- /.box-body -->
			</div>
			<!-- /.box -->
		</div>
		<!-- /.col -->
		<div class="col-md-8">
			<div class="box box-primary">
				<div class="box-header with-border">
					<div class="btn-group">
						<button type="button" class="btn btn-default"
							data-btn-type="addAreaRoot">
							<li class="fa fa-plus">&nbsp;<spring:message code="sys.area.addRootArea" /></li>
						</button>
						<button type="button" class="btn btn-default" data-btn-type="addArea">
							<li class="fa fa-plus">&nbsp;<spring:message code="sys.area.addChildArea" /></li>
						</button>
						<button type="button" class="btn btn-default" data-btn-type="editArea">
							<li class="fa fa-edit">&nbsp;<spring:message code="sys.area.modifyArea" /></li>
						</button>
						<button type="button" class="btn btn-default"
							data-btn-type="deleteArea">
							<li class="fa fa-remove">&nbsp;<spring:message code="sys.area.deleteArea" /></li>
						</button>
					</div>
					<!-- /.box-tools -->
				</div>
				<!-- /.box-header -->
				<div class="box-body">
					<form class="form-horizontal" id="area-form" modelAttribute="area">
						<input type='hidden' value='${CSRFToken}' id='csrftoken'>
						<input type="hidden" class="form-control" id="parentId" name="parentId">	
						
						<div class="form-group">
							<label for="parentName" class="col-sm-2 control-label"><spring:message code="sys.area.parentArea" /></label>

							<div class="col-sm-9">
								<input type="text" class="form-control" disabled="disabled"
									id="parentName" name="parentName" readonly="readonly" placeholder='<spring:message code="sys.area.parentArea" />'>
							</div>
						</div>

						<div class="form-group">
							<label for="name" class="col-sm-2 control-label"><spring:message code="sys.area.name" /><span style="color:red">*</span></label>

							<div class="col-sm-9">
								<input type="text" class="form-control" id="name" name="name"
									placeholder="<spring:message code="sys.area.name" />">
							</div>
						</div>
						<div class="form-group">
							<label for="code" class="col-sm-2 control-label"><spring:message code="sys.area.code" /><span style="color:red">*</span></label>

							<div class="col-sm-9">
								<input type="text" class="form-control" id="code" name="code"
									placeholder="<spring:message code="sys.area.code" />">
							</div>
						</div>
						<div class="form-group">
							<label for="sort" class="col-sm-2 control-label"><spring:message code="sys.area.sort" /></label>

							<div class="col-sm-9">
								<input type="text" class="form-control" id="sort"
									name="sort" placeholder="<spring:message code="sys.area.sort" />">
							</div>
						</div>
						
						<div class="form-group">
							<label for="master" class="control-label col-sm-2"><spring:message code="sys.area.createTime" /></label>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="master"
									name="createDate" placeholder="<spring:message code="sys.area.createTime" />">
							</div>
						</div>
						
						<div class="form-group">
							<label for="address" class="control-label col-sm-2"><spring:message code="sys.area.lastUpdateTime" /></label>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="address"
									name="updateDate" placeholder="<spring:message code="sys.area.lastUpdateTime" />">
							</div>
						</div>

						<div class="form-group">
							<label for="remarks" class="col-sm-2 control-label"><spring:message code="common.instructions" /></label>

							<div class="col-sm-9">
								<textarea class="form-control" id="remarks" name="remarks"
									placeholder="<spring:message code="common.instructions" />"></textarea>
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

<script type="text/javascript">
			var areaform =null;
			$(function() {
				//初始化form表单
				areaform=$("#area-form").form();
				initTree(0); 
				//初始化校验
				$("#area-form").bootstrapValidator({
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
									message : '<spring:message code="sys.area.tip.inputName" />'
								}
							}
						},
						code : {
							validators : {
								notEmpty : {
									message : '<spring:message code="sys.area.tip.inputCode" />'
								}
						
							}
						},
						sort : {
							validators : {
								notEmpty : {
									message : '<spring:message code="sys.area.tip.inputSort" />'
								}
							}
						},
						deleted : {
							validators : {
								notEmpty : {
									message : '<spring:message code="sys.area.tip.selectUseState" />'
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
                            callback: function() {
							//Save Data，对应'submit-提交'
							var params = areaform.getFormSimpleData();
							ajaxPost(basePath + '/sys/area/save', params, function(data, status) {
								if (data.code == 200) {
									modals.correct({
		                                title:'<spring:message code="common.sys.success" />', 
		                                cancel_label:'<spring:message code="common.cancel" />',
		                                text:data.message});
									var selectedArr=$("#areatree").data("treeview").getSelected();
									var selectedNodeId=selectedArr.length>0?selectedArr[0].nodeId:0;
								    initTree(selectedNodeId);
								}else{
									modals.warn({
		                                title:'<spring:message code="common.sys.warn" />', 
		                                cancel_label:'<spring:message code="common.cancel" />',
		                                text:data.message});
								}
							});
						}});
				});
				
				//按钮事件
				var btntype=null;
				$('button[data-btn-type]').click(function() {
					var action = $(this).attr('data-btn-type');
					var selectedArr=$("#areatree").data("treeview").getSelected();
					var selectedNode=selectedArr.length>0?selectedArr[0]:null;
					switch (action) {
					case 'addAreaRoot':
						areaform.formWritable(action);
						areaform.clearForm();
						fillParentAndSort(null);
						btntype='addArea';
						break; 
					case 'addArea':
						if(!selectedNode){
							modals.info({
                                title:'<spring:message code="common.sys.info" />', 
                                cancel_label:'<spring:message code="common.cancel" />',
                                text:'<spring:message code="sys.area.tip.selectParentOrgan" />'});
							return false;
						}
						areaform.formWritable(action);
						areaform.clearForm();
						//填充上级字典和层级编码
						fillParentAndSort(selectedNode);
						btntype='addArea';
						break;
					case 'editArea':
						if(!selectedNode){
							modals.info({
                                title:'<spring:message code="common.sys.info" />', 
                                cancel_label:'<spring:message code="common.cancel" />',
                                text:'<spring:message code="sys.area.tip.selectModifyNode" />'});
							return false;
						}
						if(btntype=='addArea'){
							fillDictForm(selectedNode);
						}
						areaform.formWritable(action);
						btntype='editArea';
						break;
					case 'deleteArea':
						if(!selectedNode){
							modals.info({
                                title:'<spring:message code="common.sys.info" />', 
                                cancel_label:'<spring:message code="common.cancel" />',
                                text:'<spring:message code="sys.area.tip.selectDeleteNode" />'});
							return false;
						}
						if(btntype=='addArea')
							fillDictForm(selectedNode);
						areaform.formReadonly();
						$(".box-header button[data-btn-type='deleteArea']").removeClass("btn-default").addClass("btn-primary");
					    if(selectedNode.nodes){
					    	modals.info({
                                title:'<spring:message code="common.sys.info" />', 
                                cancel_label:'<spring:message code="common.cancel" />',
                                text:'<spring:message code="sys.area.tip.haveChildNode" />'});
					    	return false;
					    }
					    modals.confirm({
                            cancel_label:'<spring:message code="common.cancel" />',
                            title:'<spring:message code="common.sys.confirmTip" />',
                            ok_label:'<spring:message code="common.confirm" />',
                            text:'<spring:message code="sys.area.confirm.delete" />', 
                            callback: function() {
					    	ajaxPost(basePath+"/sys/area/delete?id="+selectedNode.id,null,function(data){
					    		if(data.success){
					    		   modals.correct({
		                                title:'<spring:message code="common.sys.success" />', 
		                                cancel_label:'<spring:message code="common.cancel" />',
		                                text:'<spring:message code="common.deleteSuccess" />'});	
					    		}else{
					    			modals.info({
                                        title:'<spring:message code="common.sys.info" />', 
                                        cancel_label:'<spring:message code="common.cancel" />',
                                        text:data.message});
					    		}
					    		//定位
					    		var brothers=$("#areatree").data("treeview").getSiblings(selectedNode);
					    		if(brothers.length>0) 
					    		   initTree(brothers[brothers.length-1].nodeId);
					    		else{
					    		   var parent=$("#areatree").data("treeview").getParent(selectedNode);
					    		   initTree(parent?parent.nodeId:0); 
					    		}
					    	});
					    }});
						break;
					case 'cancel':  
						if(btntype=='addArea')
						fillDictForm(selectedNode);
						areaform.formReadonly();
						break;
					}
				});
			})
			
			
			function initTree(selectNodeId){
				var treeData = null;
				ajaxPost(basePath + "/sys/area/treeData", null, function(data) {
					treeData = data;
				});
			//	alert(JSON.stringify(treeData[0].officeNodes));查看后台传输过来的数据
				$("#areatree").treeview({
					data : treeData,
					showBorder : true,
					expandIcon : "glyphicon glyphicon-chevron-right",
					collapseIcon : "glyphicon glyphicon-chevron-down",
					//nodeIcon: 'glyphicon glyphicon-bookmark',
					showTags: true,
					levels : 1,
					onNodeSelected : function(event, data) {
						fillDictForm(data);
						areaform.formReadonly();
						//初始化该地区下的机构树
						initOfficeTree(data.officeNodes);
					}
				});
				if(treeData.length==0)
					return;
				//默认选中第一个节点 
				selectNodeId=selectNodeId||0;
				$("#areatree").data('treeview').selectNode(selectNodeId);
				$("#areatree").data('treeview').expandNode(selectNodeId);
				$("#areatree").data('treeview').revealNode(selectNodeId);
			}
			
			//新增时，带入父级字典名称id,自动生成sort
			function fillParentAndSort(selectedNode){
				$("input[name='parentName']").val(selectedNode?selectedNode.text:'地区名称');
			    $("input[name='deleted'][value='0']").prop("checked","checked");  
			    if(selectedNode){
			    	$("input[name='parentId']").val(selectedNode.id);
					var nodes=selectedNode.nodes;
					var levelCode=nodes?nodes[nodes.length-1].levelCode:null;
					$("input[name='sort']").val(getNextSort(levelCode));
			    }else{
			    	var brothers=$("#areatree").data("treeview").getSiblings(0);
			    	var levelCode="0";
			    	if(brothers&&brothers.length>0)
			    	   levelCode=brothers[brothers.length-1].levelCode;
			    	$("input[name='sort']").val(getNextSort(levelCode));    	
			    }
			}
			
			//填充form
			function fillDictForm(node){
				areaform.clearForm();
				ajaxPost(basePath+"/sys/area/get?id="+node.id,null,function(data){
					areaform.initFormData(data);
				});
			}
			//机构树初始化
			function initOfficeTree(officeData){
				$("#officetree").treeview({
					data : officeData,
					showBorder : true,
					expandIcon : "glyphicon glyphicon-chevron-right",
					collapseIcon : "glyphicon glyphicon-chevron-down",
					//nodeIcon: 'glyphicon glyphicon-bookmark',
					showTags: true,
					levels : 1,
					onNodeSelected : function(event,officeData) {
					}
				});
			}
		</script>
