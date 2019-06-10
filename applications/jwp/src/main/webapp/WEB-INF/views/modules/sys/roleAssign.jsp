<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title">新增角色功能</h5>
</div>

<!-- Main content -->
<div class="modal-body">
	<div class="row">
		<div class="col-md-3">

			<!-- Profile Image -->
			<div class="box box-primary">
				<div class="box-body box-profile">
					<div id="tree"></div>
				</div>
				<!-- /.box-body -->
			</div>
			<!-- /.box -->
		</div>
		<!-- /.col -->
		<div class="col-md-9">
			<div class="box box-primary">
				<div class="box-header with-border">
					<!-- /.box-tools -->
				</div>
				<!-- /.box-header -->
				<div class="box-body" style="min-height: 420px">
				<input type="hidden" id="language" name="language" value="${language }"/>
					<input type="hidden" id="roleId" name="roleId" value="${roleId}" />

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
								<i class="fa fa-reply">&nbsp;<spring:message code="common.close" /></i>
							</button>
							<button data-btn-type="save" class="btn btn-primary">
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

	<script>
		//初始化form表单
		var pre_ids = "${menuIds}".split(",");
		$(function() {
			//初始化菜单树
			initTree(0);
			initChecked();
			//按钮操作
			$("button[data-btn-type]").click(function() {
				var action = $(this).attr('data-btn-type');
				var roleId = $("#roleId").val();
				switch (action) {
				case "save":
					var nodes = $("#tree").data("treeview").getChecked();
					var rflist = [];
					for (var i = 0; i < nodes.length; i++) {
						var curNode = nodes[i];
						rflist.push(curNode.id);
					}

					//批量保存选中节点
					ajaxPost(basePath + "/sys/role/assignrole", {
						roleId : roleId,
						menuIds : JSON.stringify(rflist)
					}, function(data, status) {
						modals.hideWin("roleMeunWin");
					});
					break;
				default:
					break;
				}
			});
		});

		function initChecked() {
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