<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i> <spring:message
					code="common.homepage" /></a></li>
		<li><a href="#"><spring:message code="common.tms.management" /></a></li>
		<li class="active"><spring:message
				code="tms.updateItems.management" /></li>
	</ol>
	<div class="col-sm-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div id="updateItemsSearchDiv" class="dataTables_filter"
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
							style="margin-left: 0px; width: 226.5px;" autocomplete="off"
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
					<!-- <div class="col-sm-12 form-group" style="float: right;margin-top:10px;margin-right:-14px;"> -->
					<div style="width: 100%; margin-top: 5px;">
						<shiro:hasPermission name="tms:updateItems:edit">
							<button type="button" class="btn btn-default"
								style="float: right;" data-btn-type=updateItemsDelete
								title="<spring:message code='delete'/>">
								<i class="fa fa-remove"></i>
							</button>
							<button data-btn-type="updateItemsEdit" class="btn btn-default"
								style="float: right;" title="<spring:message code='edit'/>"
								type="button">
								<i class="fa fa-edit"></i>
							</button>
							<button data-btn-type="updateItemsAdd" class="btn btn-default"
								style="float: right;" title="<spring:message code='add'/>"
								type="button">
								<i class="fa fa-plus"></i>
							</button>
						</shiro:hasPermission>
					</div>
				</div>
				<div class="box-body">
					<table id="updateFiles_table"
						class="table table-bordered table-bg table-striped table-hover"
						style="margin-top: 0px !important;">
					</table>
				</div>
			</div>
			<!-- /.box-body -->
		</div>
	</div>
	<!-- /.col -->
	</div>
	<!-- /.row -->
</section>


<script>
	var form = $("#updateItemsSearchDiv").form({
		baseEntity : false
	});
	form.initComponent();

	//tableId,queryId,conditionContainer
	var updateItemsTable;
	var winId = "userWin";
	$(function() {
		//查询框是否在一行设置
		var config = {
			resizeSearchDiv : false,
			language : {
				url : basePath + '<spring:message code="common.language"/>'
			}
		};
		//init table and fill data
		updateItemsTable = new CommonTable("updateFiles_table",
				"updateFiles_list", "updateItemsSearchDiv",
				"/tms/updateFiles/list", config);
		
		
		
		//button event
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var updateItemsRowId = updateItemsTable
									.getSelectedRowId();
							switch (action) {
							case 'updateItemsAdd':
								modals
										.openWin({
											winId : winId,
											title : '<spring:message code="tms.updateItems.add"/>',
											width : '900px',
											url : basePath
													+ "/tms/updateFiles/form"
										});
								break;
							case 'updateItemsEdit':
								if (!updateItemsRowId) {
									modals
											.info('<spring:message code="common.promt.edit"/>');
									return false;
								}
								modals
										.openWin({
											winId : winId,
											title : '<spring:message code="tms.updateItems.edit"/>【'
													 + updateItemsTable
															.getSelectedRowData().fileName 
													+ '】',
											width : '900px',
											url : basePath
													+ "/tms/updateFiles/form?id="
													+ updateItemsRowId
										});
								break;
							case 'updateItemsDelete':
								if (!updateItemsRowId) {
									modals
											.info('<spring:message code="common.promt.delete"/>');
									return false;
								}
								modals
										.confirm({
											cancel_label : "<spring:message code="common.cancel" />",
											title : "<spring:message code="common.sys.confirmTip" />",
											ok_label : "<spring:message code="common.confirm" />",
											text : "<spring:message code="tms.confirm.delete" />",
											callback : function() {
												ajaxPost(
														basePath
																+ "/tms/updateFiles/delete?id="
																+ updateItemsRowId,
														null,
														function(data) {
															if (data.code == 200) {
																modals
																		.correct({
																			title : '<spring:message code="common.sys.success" />',
																			cancel_label : '<spring:message code="common.confirm" />',
																			text : data.message
																		});
																updateItemsTable
																		.reloadRowData();
															} else {
																modals
																		.warn(data.message);
															}
														});
											}
										});
								break;
							}
						});
	})
	
	/* 格式化文件大小 */
	function renderSize(filesize){
	    if(null==filesize||filesize==''){
	        return "0 Bytes";
	    }
	    var unitArr = new Array("Bytes","KB","MB","GB","TB","PB","EB","ZB","YB");
	    var index=0;
	    var srcsize = parseFloat(filesize);
	    index=Math.floor(Math.log(srcsize)/Math.log(1024));
	    var size =srcsize/Math.pow(1024,index);
	    size=size.toFixed(2);//保留的小数位数
	    return size+unitArr[index];
	}
	function formatSize(id, type, rowObj) {
        return renderSize(rowObj.fileSize);
	}
</script>