<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>

<!-- Main content -->
<div class="row">
	<div class="col-xs-12"
		style="height: 500px; overflow-y: auto; overflow-x: hidden;">
		<div class="dataTables_filter">
			<div class="btn-group">
				<input placeholder='<spring:message code="modules.device.please.enter.the.absolute.path.of.the.file"/>' id="filePath" name="filePath"
					class="form-control" type="search" />
			</div>
			&nbsp;&nbsp;
			<div class="btn-group">
				<button type="button" class="btn btn-primary" data-btn-type="search"><spring:message code="modules.device.search"/></button>
				<button type="button" class="btn btn-default" data-btn-type="reset"><spring:message code="common.reset"/></button>
			</div>
		</div>
		<div class="box-body">
			<table id="file-table"
				class="table table-bordered table-striped table-hover">
			</table>
		</div>
		<!-- /.box-body -->
		<div class=" text-right" id="functionDiv" style="display: none">
			<!--以下两种方式提交验证,根据所需选择-->
			<button type="button" class="btn btn-default" id="cencal1_button"><spring:message code="common.cancel"/></button>
			<button type="button" class="btn btn-primary" id="submit1_button"><spring:message code="common.submit"/></button>
		</div>
		<!-- /.box-body -->
	</div>
	<!-- /.col -->
</div>
<!-- /.row -->

<script>
	var $package_log_table;
	$(document).ready(function() {
		var deviceSn = $("input[name='sn']").val();

		$('#submit1_button').click(function() {

			var checkboxes = $("input[type='checkbox']:checked");
			if (checkboxes.length <= 0) {
				modals.info('<spring:message code="modules.device.select.file"/>')
				return;
			}
			var jsonObj = {};
			jsonObj["name"] = checkboxes[0].value;
			jsonObj["target"] = "";

			ajaxPost(basePath + '/device/checkLog', {
				check : JSON.stringify(jsonObj),
				deviceSn : deviceSn
			}, function(data, status) {
				if (data.code == 200) {
					//上传APP编号
					modals.correct(data.message);
				} else {
					modals.warn(data.message);
				}
			});
		});
		$('#cencal1_button').click(function() {
			$("[name='checkbox']").removeAttr("checked");//取消全选 
		});
		$('button[data-btn-type]').click(function() {
			var action = $(this).attr('data-btn-type');
			switch (action) {
			case 'search':
				deviceFileListDef.searchFileList();
				break;
			case 'reset':
				deviceFileListDef.reset();
				break;
			default:
				break;
			}
		})
	})
	$package_log_table = $('#file-table')
			.dataTable(
					{
						autoWidth : false,
						//data: data.data,
						columns : [ {
							data : 'fileName',
							title : '',
							className : "text-center"
						}, {
							data : 'fileName',
							title : '<spring:message code="sys.menu.name"/>',
							className : "text-center"
						}, {
							data : 'fileTimes',
							title : '<spring:message code="modules.device.update.date"/>',
							className : "text-center"
						}, {
							data : 'fileFlag',
							title : '<spring:message code="sys.dict.type"/>',
							className : "text-center"
						}, {
							data : 'length',
							title : '<spring:message code="modules.device.size"/>',
							className : "text-center"
						} ],
						destory : true,
						bFilter : false, //去掉搜索框方法
						bLengthChange : false, //去掉每页显示多少条数据方法
						retrieve : true,
						bSort : false, //禁止排序
						"aoColumnDefs" : [ {
							targets : 0,
							data : "fileName",
							render : function(data, type, row) {
								var oper = "";
								oper += "<div class='checkbox checkbox-success checkbox-inline'><input type='checkbox' id='checked" + data +"'  value='" + data +"' name='checkbox' /><label for='checked"+data+"'></label></div>";
								return oper;
							}
						} ],
						"language" : { // 中文支持
							"sUrl" : basePath + $.i18n.prop("common.language")
						}
					});
	var deviceFileListDef = {
		searchFileList : function() {
			var deviceSn = $("input[name='sn']").val();
			var filePath = $("input[name='filePath']").val();
			if (filePath == "") {
				modals.info('<spring:message code="modules.device.please.enter.the.absolute.path.of.the.file"/>');
				return;
			}
			//设置等待友好提示窗口
			layer.msg('<spring:message code="modules.device.in.the.load.please.later"/>', {
				icon : 16,
				tips : [ 1, '#3595CC' ],
				area : [ '250px', '70px' ],
				shade : [ 0.5, '#f5f5f5' ],
				scrollbar : false,
				time : 60000
			});

			$.when(ajaxPostWithDeferred(basePath + '/device/getFileList', {
				filePath : filePath,
				deviceSn : deviceSn
			}, function(data, status) {
			})).done(function(data) {
				//关闭等待友好提示窗口
				layer.close(layer.index);

				if (data.code == 200) {
					//$.fnDestroy();//如有重复查询，现还原初始化datatable
					$package_log_table.fnClearTable();
					var jsonObj = data.data;
					if (jsonObj.length > 0) {
						$("#file-table tr:eq(1)").remove();
						$("#functionDiv").show();
					}
					$package_log_table.fnAddData(jsonObj);

				} else {
					modals.warn(data.message);
				}
			});
		},
		reset : function() {
			$("input[name='filePath']").val("");
			$package_log_table.fnClearTable(); //清空dataTable的数据
			$package_log_table.fnDestroy(); //还原初始化datatable
			$("#functionDiv").hide();
		}
	}

	function oncheck(check) {
		var $arr = $("input[type=check]");
		for (i = 0; i < $arr.length; i++) {
			if ($arr[i].checked && $arr[i].value != check.value) {
				$arr[i].checked = false;
			}
		}
	}
</script>
