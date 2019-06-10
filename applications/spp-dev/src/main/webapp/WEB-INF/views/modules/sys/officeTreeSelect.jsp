<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li class="active">机构选择</li>
	</ol>
	<div class="col-sm-12"></div>
</section>
<!-- Main content -->
<section class="content">

	<div class="row">
		<div class="col-md-12">

			<!-- Profile Image -->
			<div class="box box-primary">
				<div class="box-body box-profile" >
					<div id="officetree"  style="overflow:auto;width:460px;height:180px;"></div>
				</div>
				<!-- /.box-body -->
			</div>
			<!-- /.box -->
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->

</section>

<script>
			$(function() {

				initTree(); 
			});
			function initTree(){
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
						var id=data.id;
						var text = data.text;
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
			
			
		</script>
