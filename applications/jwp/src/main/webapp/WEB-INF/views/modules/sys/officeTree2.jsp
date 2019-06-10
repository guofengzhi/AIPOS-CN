<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<script src="${ctxStatic}/adminlte/plugins/bootstrap-treeview/bootstrap-treeview.js"></script>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li class="active"><spring:message code="please.select.organ" /></li>
	</ol>
	<div class="col-md-12"></div>
</section>

<!-- Main content -->

	<div class="row">
		<div class="col-md-12">

			<!-- Profile Image -->
			<div class="box box-primary">
				<div class="box-body box-profile">
					<div id="officetree"></div>
				</div>
				<!-- /.box-body -->
			</div>
			<!-- /.box -->
		</div>
	</div>
	<!-- /.row -->


<script>
			var officeform =null;
			$(function() {
				initTree(0); 
				
				//按钮事件
				var btntype=null;
				/* $('button[data-btn-type]').click(function() {
					var selectedArr=$("#officetree").data("treeview").getSelected();
					var selectedNode=selectedArr.length>0?selectedArr[0]:null;
				}); */
			})
			var orgSelect = "${orgSelect}";
			var orgSelectValue = "${orgSelectValue}";
			var windowId = "${windowId}";
			function initTree(selectNodeId){
				var treeData = null;
				ajaxPost(basePath + "/sys/office/treeDataFilter", null, function(data) {
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
						//$("#"+orgSelect , parent.document).val(data.id);
						//$("#"+orgSelectValue , parent.document).val(data.text);
						$("#"+orgSelect).val(data.id);
						$("#"+orgSelectValue).val(data.text);
						//var secSelect = window.parent.document.getElementById("selectMerchants");
					/* 	var secSelect = document.getElementById("selectMerchants");
						if(secSelect!=undefined){
							secSelect.options.length = 0;
							$.ajax({
								url:basePath+'/sys/merchant/merchants?orgId='+data.id,
								success:function(res){
									 var dataJson = res.data;
									 var oOp = document.createElement("OPTION");
								        oOp.value = "";
								        oOp.text = "";
								        secSelect.options.add(oOp);
									 for ( var i = 0; i < dataJson.length; i++) {
										 var oOption = document.createElement("OPTION");
									        oOption.value = dataJson[i].merId;
									        oOption.text = dataJson[i].merName;
									        secSelect.options.add(oOption);
									        modals.hideWin(windowId);
									 }
								}
							});
						} */
						modals.hideWin(windowId);
					}
				});
				if(treeData.length==0)
					return;
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
			
		</script>
