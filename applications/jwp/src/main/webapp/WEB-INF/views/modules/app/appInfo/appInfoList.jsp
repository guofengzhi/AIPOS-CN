<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<div class="dataTables_filter" id="appInfoSearchDiv" style="text-align: left;" role="form">
					 <div class="form-group dataTables_filter " style="margin: 1em;">
						<input placeholder="<spring:message code='ota.table.application.name' />" name="appName" class="form-control"
							type="search" title="<spring:message code='app.appinfo.please.enter.the.application.name' />" style="height:37px;margin-left:0px;width: 188.8px;" />
					    <input placeholder="<spring:message code='app.information.please.input.app.developer' />" name="appDeveloper"
							class="form-control" type="search" title="<spring:message code='app.information.please.input.app.developer' />" style="height:37px;margin-left:0px;width: 188.8px;" />
						<select name="platform" id="platform" data-placeholder="<spring:message code='app.information.platform' />"
							class="form-control select2" style="height:37px;margin-left:0px;width: 188.8px;">
							<option value=""></option>
							<c:forEach items="${platformList}" var="platform"
								varStatus="idxStatus">
								<option value="${platform.value}">${platform.label }</option>
							</c:forEach>
						</select>
						<select name="category" id="category" data-placeholder="<spring:message code='app.information.type' />"
							class="form-control select2" style="height:37px;margin-left:0px;width: 188.8px;">
							<option value=""></option>
							<c:forEach items="${categoryList}" var="category"
								varStatus="idxStatus">
								<option value="${category.value}">${category.label }</option>
							</c:forEach>
						</select>
						<select name="currentApproveFlag" id="currentApproveFlag"
							data-placeholder="<spring:message code='app.information.approval.flag' />" class="form-control select2" style="height:37px;margin-left:0px;width: 188.8px;">
							<option value=""></option>
							<option value="0"><spring:message code="app.information.flag.already.online" /></option>
							<option value="1"><spring:message code="app.information.flag.under.review" /></option>
							<option value="2"><spring:message code="app.information.flag.unapprove" /></option>
							<option value="3"><spring:message code="app.information.flag.already.offline" /></option>
						</select>
						<button type="button" class="btn btn-primary" style="height:37px;"
							data-btn-type="search">
							<spring:message code="common.query" />
						</button>
						<button type="button" class="btn btn-default" style="height:37px;"
							data-btn-type="reset">
							<spring:message code="common.reset" />
						</button>
						<shiro:hasPermission name="app:info:edit">
							<button type="button" class="btn btn-default" style="height:37px;"
								data-btn-type="delete" title="<spring:message code="common.delete" />">
								<i class="fa fa-remove"></i>
							</button>
							<button type="button" class="btn btn-default" style="height:37px;"
								data-btn-type="edit" title="<spring:message code="common.edit" />">
								<i class="fa fa-edit"></i>
							</button>
							<button type="button" class="btn btn-default" style="height:37px;"
								data-btn-type="add" title="<spring:message code="common.add" />">
								<i class="fa fa-plus"></i>
							</button>
					</shiro:hasPermission>
					</div>
				</div>
				<div class="box-body">
					<table id="appInfo_table"
						class="table table-bordered table-striped table-hover" style="margin-top:0px !important;">
					</table>
				</div>
				<!-- /.box-body -->
			</div>
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</section>

<script>
	var form = $("#appInfoSearchDiv").form({
		baseEntity : false
	});
	form.initComponent();
	//tableId,queryId,conditionContainer
	var appInfoTable;
	var winId = "appInfoWin";
	$(function() {
		 var config={
		            resizeSearchDiv:false,
		            language : {
		                url: basePath+'<spring:message code="common.language"/>'
		            },
		            scrollX:true,
		        };
		//init table and fill data
		appInfoTable = new CommonTable("appInfo_table", "appInfo_list",
				"appInfoSearchDiv", "/appInfo/list",config);

		$('button[data-btn-type]').click(function() {
			var action = $(this).attr('data-btn-type');
			var rowId = appInfoTable.getSelectedRowId();
			switch (action) {
			case 'add':
				deviceProcessDef.addAppInfo();
				break;
			case 'edit':
				if (!rowId) {
					modals.info('<spring:message code="sys.role.tip.selectLine"/>');
					return false;
				}
				deviceProcessDef.editAppInfo(rowId);
				break;
			case 'delete':
				if (!rowId) {
					modals.info('<spring:message code="common.promt.delete"/>');
					return false;
				}
				deviceProcessDef.deleteAppInfo(rowId);
				break;
			}
		});

	})

	var deviceProcessDef = {
		addAppInfo : function() {
			modals
					.openWin({
						winId : winId,
						title : '<spring:message code="app.appinfo.new.application.information" />',
						width : '900px',
						url : basePath + "/appInfo/form/add"
					});
		},
		editAppInfo : function(id) {
			modals.openWin({
				winId : winId,
				title : '<spring:message code="common.edit"/>',
				width : '900px',
				url : basePath + "/appInfo/form/edit?id=" + id
			});
		},
		deleteAppInfo : function(id) {
			modals
					.confirm(
							'<spring:message code="common.confirm.delete" />',
							function() {
								var params = {};
								params["id"] = id;
								ajaxPost(
										basePath + "/appInfo/delete",
										params,
										function(data) {

											if (data.code == 200) {
												modals
														.correct('<spring:message code="app.appinfo.the.data.has.been.deleted" />');
												appInfoTable.reloadRowData();
											} else {
												modals.error(data.message);
											}
										});
							})
		}
	}

	function operationAppLogo(appLogo, type, rowObj) {
		var oper = "";
		if (appLogo == null || appLogo == '') {
			oper += "<div class='textavatar' style='width: 40px;' data-name='"+rowObj.appName+"'></div>"
		} else {
			oper += "<div class='appimg'> <img src='"+ rowObj.appLogo + "' class='appimg-circle' /></div>";
		}
		return oper;
	}

	function operationApproveFlag(approveFlag) {
		var oper = "";
		if (approveFlag == '0') {
			oper += "<span class='label label-success'>" + '<spring:message code="app.information.flag.already.online" />' + "</span>";
		} else if (approveFlag == '1') {
			oper += "<span class='label label-danger'>" + '<spring:message code="app.information.flag.under.review" />' + "</span>";
		} else if (approveFlag == '2') {
			oper += "<span class='label label-danger'>" + '<spring:message code="app.information.flag.unapprove" />' + "</span>";
		} else if (approveFlag == '3') {
			oper += "<span class='label label-danger'>" + '<spring:message code="app.information.flag.already.offline" />' + "</span>";
		}
		return oper;
	}
</script>
