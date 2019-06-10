<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i> <spring:message
					code="common.homepage" /></a></li>
		<li><a href="#"><spring:message code="common.tms.management" /></a></li>
		<li class="active"><spring:message
				code="tms.updateStrategy.management" /></li>
	</ol>
	<div class="col-sm-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div id="updateStrategySearchDiv" class="dataTables_filter"
					style="text-align: left;" role="form">
					<div class="has-feedback form-group">
						<select style="margin-left: 0px; width: 226.5px;"
							name="manufactureNo" id="manufactureNo"
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
						<input class="form-control" id="strategyName" type="search"
							name="strategyName" operator="like" likeoption="true"
							style="margin-left: 0px; width: 226.5px;" autocomplete="off"
							placeholder="<spring:message code='please.input.updateStrategy.name'/>" />
					</div>
					<div class="has-feedback form-group">
						<input class="form-control" id="beginDate" type="search"
							name="beginDate" autocomplete="off"
							style="margin-left: 0px; width: 226.5px;"
							placeholder="<spring:message code='please.input.updateStrategy.minBeginDate'/>"
							data-flag="datepicker">
					</div>
					<div class="has-feedback form-group">
						<input class="form-control" id="endDate" type="search"
							name="endDate" autocomplete="off"
							style="margin-left: 0px; width: 226.5px;"
							placeholder="<spring:message code='please.input.updateStrategy.maxEndDate'/>"
							data-flag="datepicker" />
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

					<div style="width: 100%; margin-top: 5px;">
						<shiro:hasPermission name="tms:updateStrategy:edit">
							<button data-btn-type="deploy" class="btn btn-primary"
								title="<spring:message code="tms.table.configUpdateItems" />"
								type="button" style="float: left;">
								<i class="fa fa-plus"><spring:message
										code="tms.table.configUpdateItems" /></i>
							</button>
						</shiro:hasPermission>
						<shiro:hasPermission name="tms:updateStrategy:edit">
							<button type="button" class="btn btn-default"
								data-btn-type="updateStrategyDelete"
								title="<spring:message code="common.delete" />"
								style="float: right;">
								<i class="fa fa-remove"></i>
							</button>
							<button data-btn-type="updateStrategyEdit"
								class="btn btn-default"
								title="<spring:message code="common.edit" />" type="button"
								style="float: right;">
								<i class="fa fa-edit"></i>
							</button>
							<button data-btn-type="updateStrategyAdd" class="btn btn-default"
								title="<spring:message code="common.add" />" type="button"
								style="float: right;">
								<i class="fa fa-plus"></i>
							</button>
						</shiro:hasPermission>
					</div>
				</div>
				<div class="box-body">
					<table id="updateStrategy_table"
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
	var form = $("#updateStrategySearchDiv").form({
		baseEntity : false
	});
	form.initComponent();

	//tableId,queryId,conditionContainer
	var updateStrategyTable;
	var winId = "userWin";

	$(function() {
		$("#updateStrategySearchDiv")
				.bootstrapValidator(
						{
							message : '<spring:message code="common.promt.value"/>',
							feedbackIcons : {
								validating : 'glyphicon glyphicon-refresh'
							},
							fields : {
								beginDate : {
									container : '#startP',
									validators : {
										date : {
											format : 'YYYY-MM-DD',
											message : '<spring:message code="sys.log.tip.tiemFromatIncorrect"/>'
										},
										callback : {
											message : '<spring:message code="sys.log.tip.beginTimeTooBig"/>',
											callback : function(value,
													validator, $field, options) {
												$("small").prop("hidden",
														"hidden");
												var end = $("#endDate").val();
												if (value == "" || end == "") {
													return true;
												} else {
													value = new Date(value)
															.getTime();
													end = new Date(end)
															.getTime();
													return parseInt(value) <= parseInt(end);
												}

											}
										}
									}
								},
								endDate : {
									container : '#endP',
									validators : {
										date : {
											format : 'YYYY-MM-DD',
											message : '<spring:message code="sys.log.tip.tiemFromatIncorrect"/>'
										},
										callback : {
											message : '<spring:message code="sys.log.tip.endTimeTooSmall"/>',
											callback : function(value,
													validator, $field) {
												var begin = $("#beginDate")
														.val();
												$("#beginDate").keypress();
												if (value == "" || begin == "") {
													return true;
												} else {
													value = new Date(value)
															.getTime();
													begin = new Date(begin)
															.getTime();
													validator.updateStatus(
															'beginDate',
															'VALID');
													return parseInt(value) >= parseInt(begin);
												}
											}
										}
									}
								}
							}
						}).on('success.form.fv', function(e) {
					e.preventDefault();
				});
		//查询框是否在一行设置
		var config = {
			resizeSearchDiv : false,
			language : {
				url : basePath + '<spring:message code="common.language"/>'
			}
		};
		//init table and fill data
		updateStrategyTable = new CommonTable("updateStrategy_table",
				"updateStrategy_list", "updateStrategySearchDiv",
				"/tms/updateStrategy/list", config);

		//button event
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var updateStrategyRowId = updateStrategyTable
									.getSelectedRowId();
							switch (action) {
							case 'updateStrategyAdd':
								modals
										.openWin({
											winId : winId,
											title : '<spring:message code="tms.updateStrategy.add"/>',
											width : '900px',
											url : basePath
													+ "/tms/updateStrategy/form"
										});
								break;
							case 'updateStrategyEdit':
								if (!updateStrategyRowId) {
									modals
											.info('<spring:message code="common.promt.edit"/>');
									return false;
								}
								modals
										.openWin({
											winId : winId,
											title : '<spring:message code="tms.updateStrategy.edit"/>【'
													+ updateStrategyTable
															.getSelectedRowData().strategyName
													+ '】',
											width : '900px',
											url : basePath
													+ "/tms/updateStrategy/form?id="
													+ updateStrategyRowId
										});
								break;
							case 'updateStrategyDelete':
								if (!updateStrategyRowId) {
									modals
											.info('<spring:message code="common.promt.delete"/>');
									return false;
								}
								modals
										.confirm({
											cancel_label : "<spring:message code="common.cancel" />",
											title : "<spring:message code="common.sys.confirmTip" />",
											ok_label : "<spring:message code="common.confirm" />",
											text : "<spring:message code="common.confirm.delete" />",
											callback : function() {
												ajaxPost(
														basePath
																+ "/tms/updateStrategy/delete?id="
																+ updateStrategyRowId,
														null,
														function(data) {
															if (data.code == 200) {
																modals
																		.correct({
																			title : '<spring:message code="common.sys.success" />',
																			cancel_label : '<spring:message code="common.confirm" />',
																			text : data.message
																		});
																updateStrategyTable
																		.reloadRowData();
															} else {
																modals
																		.warn(data.message);
															}
														});
											}
										});
								break;
							case 'deploy':
								if (!updateStrategyRowId) {
									modals
											.info('<spring:message code="sys.role.tip.selectLine"/>');
									return false;
								}
								modals
										.openWin({
											winId : "configFile",
											title : '<spring:message code="tms.table.configUpdateItems"/>',
											width : '1000px',
											url : basePath
													+ "/tms/updateStrategy/configView?id="
													+ updateStrategyRowId
										});
								break;
							}
						});
	})
</script>