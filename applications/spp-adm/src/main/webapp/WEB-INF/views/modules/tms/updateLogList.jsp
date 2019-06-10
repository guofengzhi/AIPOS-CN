<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i> <spring:message
					code="common.homepage" /></a></li>
		<li><a href="#"><spring:message code="common.tms.management" /></a></li>
		<li class="active"><spring:message
				code="tms.updateLog.management" /></li>
	</ol>
	<div class="col-sm-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div id="updateLogSearchDiv" class="dataTables_filter"
					style="text-align: left;" role="form">
					<div class="has-feedback form-group">
						<select style="margin-left: 0px; width: 226.5px;" name="manufactureNo"
							id="manufactureNo"
							data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>'
							class="form-control select2" style="width: 170px">
							<option value=""></option>
							<c:forEach items="${manufacturerList}" var="manufacturer"
								varStatus="idxStatus">
								<option value="${manufacturer.manufacturerName}">${manufacturer.manufacturerName }</option>
							</c:forEach>
						</select>
					</div>
					<div class="has-feedback form-group">
						<select style="margin-left: 0px; width: 226.5px;" name="fileType"
							id="fileType"
							data-placeholder='<spring:message code="please.select.updateItems.type"/>'
							class="form-control select2" style="width: 170px">
							<option value=""></option>
							<c:forEach items="${fns:getDictList('tms_file_type')}" var="fileType"
								varStatus="idxStatus">
								<option value="${fileType.value}">${fileType.label}</option>
							</c:forEach>
						</select>
					</div>
					<div class="has-feedback form-group">
						<input class="form-control" id="fileName" type="search"
							name="fileName" operator="like" likeoption="true"
							style="margin-left: 0px; width: 226.5px;"
							placeholder="<spring:message code='please.input.updateItems.name'/>" />
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
						<button type="button" class="btn btn-default"
							data-btn-type="reset">
							<spring:message code="common.reset" />
						</button>
					</div>
					<div style="width: 100%; margin-top: 15px;"></div>
				</div>
				<div class="box-body">
					<table id="updateLog_table"
						class="table table-bordered table-bg table-striped table-hover"
						style="margin-top: 0px !important;">
					</table>
				</div>
			</div>
		</div>
	</div>
</section>

<script>
	var form = $("#updateLogSearchDiv").form({
		baseEntity : false
	});
	form.initComponent();
	
	function logDetail(id, type, rowObj) {
		var oper = "";
	    oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='showLogDetail(\"" + id +"\")'>"+'<spring:message code="tms.table.log.detail"/>'+"</a>";
        return oper;
	}
	
	function showLogDetail(id) {
		modals.openWin({
			winId : "logDetail",
			title : '<spring:message code="tms.table.log.detail"/>',
			width : '900px',
			url : basePath + "/tms/updateLog/detail?id=" + id
		});
	}
	//tableId,queryId,conditionContainer
	var updateLogTable;
	$(function() {
		//查询框是否在一行设置
		var config = {
			resizeSearchDiv : false,
			language : {
				url : basePath + '<spring:message code="common.language"/>'
			}
		};
		//init table and fill data
		updateLogTable = new CommonTable("updateLog_table", "updateLog_list",
				"updateLogSearchDiv", "/tms/updateLog/list", config);

		//button event
		$('button[data-btn-type]').click(function() {
			var action = $(this).attr('data-btn-type');
			var updateLogRowId = updateLogTable.getSelectedRowId();
		});
	})
</script>