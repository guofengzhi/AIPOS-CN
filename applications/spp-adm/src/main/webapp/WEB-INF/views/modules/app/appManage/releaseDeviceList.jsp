<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<link rel="stylesheet"
	href="${ctxStatic}/common/libs/webuploader/webuploader.css">
<script src="${ctxStatic}/common/libs/webuploader/webuploader.js"></script>
<spring:message code="app.release.client" var="releaseclient" />
<spring:message code="common.delete" var="commdelete" />
<spring:message code="app.release.wait.to.upload" var="waituploading" />

<style type="text/css">
.importBtnStyleInit {
	float: right;
	display: inline-block;
}
</style>
<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"></h5>
</div>
<!-- Main content -->
<div class="modal-body">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div class="dataTables_filter" id="deviceSearchDiv" style="text-align: left;" role="form">
					<div class="has-feedback form-group">
						<select name="industry" id="industry"
							data-placeholder='<spring:message code="app.release.please.choose.the.industry"/>'
							onchange="clickIndustry()" class="form-control select2"
							style="width: 188.8px;">
							<option value=""></option>
							<c:forEach items="${industryList}" var="industry"
								varStatus="idxStatus">
								<option value="${industry.value}">${industry.label }</option>
							</c:forEach>
						</select>
					</div>
					<div class="has-feedback form-group">
						<sys:treeselect id="client" name="clientNo"
							value="${client.parentId}" labelName="parentName"
							labelValue="${client.customerName}" title="${releaseclient }"
							url="/client/treeData" extId="${client.customerId}"
							cssClass="form-control" allowClear="true"/>
					</div>
					<div class="has-feedback form-group">    
					    <select name="manufacturerNo" id="manufacturerNo"
							onchange="manuFacturerChange()"
							data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>'
							class="form-control select2" style="width: 188.8px;">
							<option value=""></option>
							<c:forEach items="${manuFacturerList}" var="manuFacturer"
								varStatus="idxStatus">
								<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
							</c:forEach>
						</select>
					</div>
					<div class="has-feedback form-group">
					    <select name="deviceType" id="deviceTypeId"
							onchange="deviceTypeChange()"
							data-placeholder='<spring:message code="app.apprecord.please.select.the.device.type"/>'
							class="form-control select2" style="width: 188.8px;">
							<option value=""><spring:message
									code="app.apprecord.please.select.the.device.type" /></option>
						</select>
					</div>
					<div class="has-feedback form-group">
						<input
							placeholder='<spring:message code="app.apprecord.please.enter.the.device.sn.number"/>'
							id="deviceSn" name="deviceSn" class="form-control" type="search"
							title='<spring:message code="app.apprecord.please.enter.the.device.sn.number"/>'
							style="width: 188.8px;" />
					</div>
					<div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search">
							<spring:message code="common.query" />
						</button>
						<button type="button" class="btn btn-default"
							data-btn-type="reset">
							<spring:message code="common.reset" />
						</button>
					</div>
					<div style="width:100%;margin-top:5px;">
						<input type="checkbox" class="square-green" style="float:left;"
							id="singleCheckBox" name="singleCheckBox" /> <spring:message
								code="app.release.single.page.submission" />
						&nbsp;&nbsp;<input type="checkbox" style="float:left;"
							class="square-green" id="allCheckBox" name="allCheckBox" /> <spring:message
								code="app.release.all.page.submissions" />
					</div>
				</div>

				<div class="box-body">
					<table id="device_table"
						class="table table-bordered table-striped table-hover">
					</table>
				</div>
				<div class="box-footer text-right">
					<!--以下两种方式提交验证,根据所需选择-->
					<button type="button" class="btn btn-default"
						data-btn-type="cancel" data-dismiss="modal">
						<spring:message code="common.cancel" />
					</button>
					<button type="button" onclick="submitDevice()"
						class="btn btn-primary">
						<spring:message code="common.submit" />
					</button>
				</div>
				<!-- /.box-body -->
			</div>
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</div>

<script>
	var deviceform = $("#deviceSearchDiv").form({
		baseEntity : false
	});
	deviceform.initComponent();
	var deviceTable, winId = "appInfoWin", straWin = "strategyWin";
	var config = {
		singleSelect : null
	};
	var checkIds = [];
	var isInitFlag = true;
	$(function() {
		checkBox();
		clearSnCache();
	})

	function loadTableSource(deviceSnCount) {
		deviceTable.reloadRowData();
		$("#availabDeviceCountId").html(
				$.i18n.prop("app.release.upload.sn.count", deviceSnCount));
	}

	//清除文件SN缓存
	function clearSnCache() {
		layer.msg('<spring:message code="app.release.the.device.information.is.being.loaded.please.later" />', {
			icon : 16,
			tips : [ 1, '#3595CC' ],
			area : [ '330px', '70px' ],
			shade : [ 0.5, '#f5f5f5' ],
			scrollbar : false,
			time : 500000
		});
		var index = layer.index;
		var url = "/osRom/clearDeviceSnCache?romOrApp=APP";
		$.when(ajaxPostWithDeferred(basePath + url, function(data, status) {
		})).done(
				function(data) {
					layer.close(index);
					if (data.code == 200) {
						if (isInitFlag == true) {
							//init table and fill data
							deviceTable = new CommonTable("device_table",
									"os_device_list", "deviceSearchDiv",
									"/device/noPublishAppDeviceList", config);
							isInitFlag = false;
						} else {
							$("#fileImportDiv").hide();
							$("#clearSnCacheBtn").hide();
							$("#availabDeviceCountId").html('');
							deviceTable.reloadRowData();
						}
					} else {
						modals.info(data.message);
					}
				})
	}

	function ajaxProgressDef(url, params) {
		layer
				.msg(
						'<spring:message code="app.release.its.being.released.please.wait.a.little.later"/>',
						{
							icon : 16,
							tips : [ 1, '#3595CC' ],
							area : [ '250px', '70px' ],
							shade : [ 0.5, '#f5f5f5' ],
							scrollbar : false,
							time : 500000
						});
		var index = layer.index;
		$.when(
				ajaxPostWithDeferred(basePath + url, params, function(data,
						status) {
				})).done(function(data) {
			layer.close(index);
			if (data.code == 200) {
				modals.correct(data.message);
				modals.hideWin(winId);
				appTelemanagementTable.reloadData();
			} else {
				modals.info(data.message);
			}
		})
	}

	function addCheckBox(id) {
		var oper = "";
		if ($("#allCheckBox").prop("checked")) {
			oper += "<div class='checkbox checkbox-success checkbox-inline'><input type='checkbox' id='checked" + id +"'  value='" + id +"' name='box' checked disabled/><label for='checked"+id+"'></label></div>";
		} else if ($.inArray(id, checkIds) != -1) {
			oper += "<div class='checkbox checkbox-success checkbox-inline'><input type='checkbox' id='checked"
					+ id
					+ "' value='"
					+ id
					+ "' name='box' checked onClick='dtCheck(this)' /><label for='checked"+id+"'></label></div>";
		} else {
			if ($("#singleCheckBox").prop("checked")) {
				$("#allCheckBox").iCheck("enable");
				$("#singleCheckBox").iCheck("uncheck");
			}
			oper += "<div class='checkbox checkbox-success checkbox-inline'><input type='checkbox' id='checked"
					+ id
					+ "' value='"
					+ id
					+ "' name='box' onClick='dtCheck(this)'/><label for='checked"+id+"'></label></div>";
		}
		return oper;
	}

	function dtCheck(row) {
		checkIds = row.checked ? union(checkIds, row.value) : difference(
				checkIds, row.value);
		toastr.options = {
			"closeButton" : true,
			"positionClass" : "toast-top-center",
			"preventDuplicates" : false,
			"showDuration" : "300",
			"hideDuration" : "1000",
			"timeOut" : "5000",
			"extendedTimeOut" : "1000",
			"showEasing" : "swing",
			"hideEasing" : "linear",
			"showMethod" : "fadeIn",
			"hideMethod" : "fadeOut"
		}
		toastr["success"]($.i18n
				.prop("app.release.devices.have.been.selected.count",
						checkIds.length),
				'<spring:message code="app.release.select.device"/>');
	}

	function submitDevice() {
		var ids = '';
		if ($("#singleCheckBox").prop("checked")
				|| $("#allCheckBox").prop("checked")) {
			ids = $("input[name='box']:checkbox").map(function() {
				if (this.checked)
					return this.value;
			}).get().join(",");
		} else {
			ids = $.map(checkIds, function(id) {
				return id;
			}).join(",");
		}
		if (ids == '') {
			modals
					.info('<spring:message code="app.release.please.select.the.least.one.device"/>');
			return;
		}

		// 0-安装，1-卸载
		var type = ${type};
		if (type == '0') {
			modals.openWin({
				winId : straWin,
				title : '<spring:message code="modules.rom.release.select.strategy" />',
				width : '600px',
				url : basePath + "/appDevice/strategySelect"
			});
		} else {
			modals.confirm("<spring:message code='app.management.uninstall.confirm.msg' />", function() {
				//发布
				deplay('a', null, ids);
			})
		}

	}

	function deplay(strategyId, upType, ids) {
		//发布流程
		layer.msg('<spring:message code="app.release.its.being.released.please.wait.a.little.later" />', {
			icon : 16,
			tips : [ 1, '#3595CC' ],
			area : [ '250px', '70px' ],
			shade : [ 0.5, '#f5f5f5' ],
			scrollbar : false,
			time : 500000
		});
		//系统版本id
		var appId = '${id}';
		var deviceSn = $("#deviceSn").val();
		var manufacturerNo = $("#manufacturerNo").val();
		var deviceType = $("#deviceTypeId").val();

		var params = {};
		params['id'] = appId;
		params['deviceSn'] = deviceSn;
		params['manufacturerNo'] = manufacturerNo;
		params['deviceType'] = deviceType;
		params['strategyId'] = strategyId;
		params['upType'] = upType;
		//type: 0 安装 1 卸载
		params['isJPushMessage'] = ${type};

		//选择所有页
		if ($("#allCheckBox").prop("checked")) {
			ajaxProgressDef("/appDevice/saveAllAppDevice/", params);
		} else { //选择单页 或 点选
			//id数组
			params['ids'] = ids;
			ajaxProgressDef("/appDevice/saveAppDevice/" + appId, params);
		}
	}

	/**
	 * 选择策略后回调该方法进行提交
	 * @param strategyId
	 * @returns
	 */
	function selectedStragy(strategyId, upType) {

		modals.hideWin(straWin);
		var ids = '';
		if ($("#singleCheckBox").prop("checked")) {
			ids = $("input[name='box']:checkbox").map(function() {
				console.log(this.value)
				if (this.checked)
					return this.value;
			}).get().join(",");
		} else {
			ids = $.map(checkIds, function(id) {
				return id;
			}).join(",");
		}
		deplay(strategyId, upType, ids);
	}

	$("#singleCheckBox").on("ifClicked", function(event) {
		if (event.target.checked) {
			$("input[name='box']:checkbox").iCheck("uncheck");
			$("input[name='box']:checkbox").iCheck("enable");
			$("#allCheckBox").iCheck("enable");
		} else {
			$("input[name='box']:checkbox").iCheck("check");
			$("input[name='box']:checkbox").iCheck("disable");
			$("#allCheckBox").iCheck("disable");
		}
	})

	$("#allCheckBox").on("ifClicked", function(event) {
		if (event.target.checked) {
			$("input[name='box']:checkbox").iCheck("uncheck");
			$("input[name='box']:checkbox").iCheck("enable");
			$("#singleCheckBox").iCheck("enable");
		} else {
			$("input[name='box']:checkbox").iCheck("check");
			$("input[name='box']:checkbox").iCheck("disable");
			$("#singleCheckBox").iCheck("disable");
		}
	})
</script>

