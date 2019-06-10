<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title">
		<spring:message code="tms.new.updateStrategy.information" />
	</h5>
</div>

<!-- Main content -->
<div class="modal-body">
	<div class="row">
		<div class="col-xs-12">
			<!-- /.box-header -->
			<div id="updateItemsSearchDiv" class="dataTables_filter"
				style="text-align: left;" role="form">
				<div class="has-feedback form-group">
					<input type="hidden" name="manufactureNo"
						value="${updateStrategy.manufactureNo}"> <input
						class="form-control" id="fileName" type="search" name="fileName"
						operator="like" likeoption="true"
						style="margin-left: 0px; width: 226.5px;"
						placeholder="<spring:message code='please.input.updateItems.name'/>" />
				</div>
				<div class="has-feedback form-group">
					<select style="margin-left: 0px; width: 226.5px;" name="fileType"
						id="fileType"
						data-placeholder='<spring:message code="please.select.updateItems.type"/>'
						class="form-control select2" style="width: 170px">
						<option value=""></option>
						<c:forEach items="${fns:getDictList('tms_file_type')}"
							var="fileType" varStatus="idxStatus">
							<option value="${fileType.value}">${fileType.label}</option>
						</c:forEach>
					</select>
				</div>
				<div class="has-feedback form-group">
					<input class="form-control" id="fileVersion" type="search"
						name="fileVersion" operator="like" likeoption="true"
						style="margin-left: 0px; width: 226.5px;"
						placeholder="<spring:message code='please.input.updateItems.version'/>" />
				</div>
				<div class="btn-group" style="margin-right: 1px;">
					<button type="button" class="btn btn-primary"
						data-btn-type="search">
						<spring:message code="common.query" />
					</button>
					<button type="button" class="btn btn-default" data-btn-type="reset">
						<spring:message code="common.reset" />
					</button>
				</div>
			</div>
			<div class="box-body">
				<table id="updateItems_table"
					class="table table-bordered table-striped table-hover">
				</table>
			</div>
			<div class="box-footer text-right">
				<!--以下两种方式提交验证,根据所需选择-->
				<button type="button" class="btn btn-default" data-btn-type="cancel"
					data-dismiss="modal"><spring:message code="common.cancel" /></button>
				<button type="button" onclick="submitChecks()"
					class="btn btn-primary"><spring:message code="common.submit" /></button>
			</div>
		</div>
	</div>
</div>


<script>
	var form = $("#updateItemsSearchDiv").form({
		baseEntity : false
	});
	form.initComponent();

	var checkIds = [];
	//tableId,queryId,conditionContainer
	var updateItemsTable;
	var winId = "configFile";
	$(function() {
		//查询框是否在一行设置
		var config = {
			resizeSearchDiv : false,
			language : {
				url : basePath + '<spring:message code="common.language"/>'
			}
		};
		var maunNo = '${maunNo}';
		var strategyId = '${id}';
		//init table and fill data
		updateItemsTable = new CommonTable("updateItems_table",
				"updateItemsConfig_list", "updateItemsSearchDiv",
				"/tms/updateItems/notConfigList?maunNo=" + maunNo
						+ "&strategyId=" + strategyId, config);
	})

	function ajaxProgressDef(url, params) {
		layer.msg('<spring:message code="tms.release.its.being.released.please.wait.a.little.later"/>', {
			icon : 16,
			tips : [ 1, '#3595CC' ],
			area : [ '250px', '70px' ],
			shade : [ 0.5, '#f5f5f5' ],
			scrollbar : false,
			time : 1800000
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
			} else {
				modals.info(data.message);
			}
		})
	}

	function submitChecks() {
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
			modals.info("<spring:message code='tms.release.choose.at.laste.one'/>");
			return;
		}

		var strategyId = '${id}';
		var params = {};
		//id数组
		params['ids'] = ids;
		ajaxProgressDef("/tms/updateStrategy/config/" + strategyId, params);
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
		toastr["success"]($.i18n.prop("tms.release.items.have.been.selected.count",heckIds.length), '<spring:message code="tms.release.select.item"/>');
	}
</script>