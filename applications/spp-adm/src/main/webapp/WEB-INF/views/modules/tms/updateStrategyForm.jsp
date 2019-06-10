<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="common.form.select" var="formSelect" />
<spring:message code="tms.table.updateStrategy.manufactureNo"
	var="manufactureNo" />
<spring:message code="tms.table.updateStrategy.deviceSn" var="deviceSn" />
<spring:message code="tms.table.updateStrategy.beginDate"
	var="beginDate" />
<spring:message code="tms.table.updateStrategy.endDate" var="endDate" />
<spring:message code="tms.table.updateStrategy.merNo" var="merNo" />
<spring:message code="tms.table.updateStrategy.termNo" var="termNo" />
<spring:message code="tms.table.updateStrategy.strategyName"
	var="strategyName" />
<style>
.file-preview {
	padding-top: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
	padding-right: 0px;
	border-right-width: 0px;
	border-top-width: 0px;
	border-left-width: 0px;
	border-bottom-width: 0px;
}

.file-drop-zone {
	border-top-width: 0px;
	border-right-width: 0px;
	border-bottom-width: 0px;
	border-left-width: 0px;
}

.file-caption-main {
	width: 89%;
	margin-left: 6px;
}
</style>

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

<div class="modal-body">
	<form:form id="updateStrategy-form" name="updateStrategy-form"
		modelAttribute="updateStrategy" class="form-horizontal">
		<form:hidden path="id" value="${updateStrategy.id}" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'>

		<div class="box-body">
			<div class="col-md-12">
				<!-- 策略名称、厂商 -->
				<div class="form-group" style="margin-left: -80px;">
					<label for="manufactureNo" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateStrategy.manufactureNo" /><span
						style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:select path="manufactureNo" class="form-control select2"
							style="width: 100%;">
							<form:option value="" label="${formSelect}" />
							<form:options items="${manufacturerList}"
								itemLabel="manufacturerName" itemValue="manufacturerName"
								htmlEscape="false" />
						</form:select>
					</div>

					<label for="deviceType" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateStrategy.deviceType" /><span
						style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:select path="deviceType" class="form-control select2"
							style="width: 100%;">
							<form:option value="" label="${formSelect}" />
							<form:options items="${fns:getDictList('tms_device_type')}"
								itemLabel="label" itemValue="label" htmlEscape="false" />
						</form:select>
					</div>
				</div>
				<!-- 设备类型、终端号 -->
				<div class="form-group" style="margin-left: -80px;">
					<label class="col-sm-2 control-label"><spring:message
							code="tms.table.updateStrategy.strategyName" /><span
						style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:input type="text" htmlEscape="false" class="form-control"
							autocomplete="off" id="strategyName" path="strategyName"
							placeholder="${strategyName}" />
					</div>

					<label for="updateTime" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateStrategy.updateTime" /><span
						style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<form:select path="updateTime" class="form-control select2"
							style="width: 100%;">
							<form:option value="" label="${formSelect}" />
							<form:options items="${fns:getDictList('tms_update_time')}"
								itemLabel="label" itemValue="value" htmlEscape="false" />
						</form:select>
					</div>
				</div>

				<!-- 开始时间、结束时间测试 -->
				<div class="form-group" style="margin-left: -80px;">
					<label class="col-sm-2 control-label" for="beginDate"><spring:message
							code="tms.table.updateStrategy.beginDate" /><span
						style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<div class="input-group date">
							<div class="input-group-addon">
								<i class="fa fa-calendar"></i>
							</div>
							<span style="position: relative; z-index: 9999;"><form:input
									class="form-control pull-right" id="beginDate1" type="text"
									autocomplete="off" path="beginDate" placeholder="${beginDate }"
									data-flag="datepicker" data-format="yyyy/MM/dd hh:mm:ss"></form:input></span>
						</div>
					</div>
					<label class="col-sm-2 control-label" for="endDate"><spring:message
							code="tms.table.updateStrategy.endDate" /><span
						style="color: red">*</span></label>
					<div class="col-sm-4" style="padding-left: 0px;">
						<div class="input-group date">
							<div class="input-group-addon">
								<i class="fa fa-calendar"></i>
							</div>
							<span style="position: relative; z-index: 9999;"><form:input
									class="form-control pull-right" id="endDate1" type="text"
									autocomplete="off" path="endDate" placeholder="${endDate }"
									data-flag="datepicker" data-format="yyyy/MM/dd hh:mm:ss"></form:input></span>
						</div>
					</div>
				</div>
				<!-- sn -->
				<div class="form-group" style="margin-left: -80px;">
					<label for="deviceSn" class="col-sm-2 control-label"><spring:message
							code="tms.table.updateStrategy.deviceSn" /><span
						style="color: red">*</span></label>
					<div class="col-sm-9" style="padding-left: 0px; width: ">
						<textarea id="deviceSnStr" name="deviceSnStr" rows="6"
							htmlEscape="false" class="form-control" maxlength="2048"
							placeholder="<spring:message code='tms.table.updateStrategy.deviceSnStr' />">${updateStrategy.deviceSnStr}</textarea>
					</div>
				</div>
			</div>
		</div>
		<!-- /.box-body -->
		<div class="box-footer text-right">
			<!--以下两种方式提交验证,根据所需选择-->
			<button type="button" class="btn btn-default" data-btn-type="cancel"
				data-dismiss="modal">
				<spring:message code="common.cancel" />
			</button>
			<button type="submit" id="submit" class="btn btn-primary"
				data-btn-type="save">
				<spring:message code="common.submit" />
			</button>
		</div>

		<!-- /.box-footer -->
	</form:form>
</div>
<script>
	//tableId,queryId,conditionContainer
	/* var appInfoform = null; */
	var updateStrategyInfoForm = null;
	$(".select2").select2();
	$(function() {
		var updateItems = $("#updateStrategy-form").form();

		var beginDateStr = '${updateStrategy.beginDate}';
		var endDateStr = '${updateStrategy.endDate}';
		var adBeginTime = new Date(beginDateStr);
		var adEndTime = new Date(endDateStr);
		if (beginDateStr != '') {
			$("[name=beginDate]").val(formatDate(adBeginTime, "yyyy-MM-dd"));
		}
		if (endDateStr != '') {
			$("[name=endDate]").val(formatDate(adEndTime, "yyyy-MM-dd"));
		}

		$("#updateStrategy-form")
				.bootstrapValidator(
						{
							message : '<spring:message code="app.appinfo.please.enter.a.valid.value" />',
							feedbackIcons : {
								valid : 'glyphicon glyphicon-ok',
								invalid : 'glyphicon glyphicon-remove',
								validating : 'glyphicon glyphicon-refresh'
							},
							fields : {
								beginDate : {
									validators : {
										notEmpty : {
											message : '<spring:message code="please.input.updateStrategy.minBeginDate"/>',
										},
										date : {
											format : 'YYYY-MM-DD',
											message : '<spring:message code="sys.log.tip.tiemFromatIncorrect"/>'
										},
										callback : {
											message : '<spring:message code="sys.log.tip.beginTimeTooBig"/>',
											callback : function(value,
													validator, $field, options) {
												var end = $("#endDate1").val();
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
									validators : {
										notEmpty : {
											message : '<spring:message code="please.input.updateStrategy.maxEndDate"/>',
										},
										date : {
											format : 'YYYY-MM-DD',
											message : '<spring:message code="sys.log.tip.tiemFromatIncorrect"/>'
										},
										callback : {
											message : '<spring:message code="sys.log.tip.endTimeTooSmall"/>',
											callback : function(value,
													validator, $field) {
												var begin = $("#beginDate1")
														.val();
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
								},
								manufactureNo : {
									validators : {
										notEmpty : {
											message : '<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>！'
										}
									}
								},
								strategyName : {
									validators : {
										notEmpty : {
											message : '<spring:message code="please.input.updateStrategy.name"/>!'
										}
									}
								},
								deviceType : {
									validators : {
										notEmpty : {
											message : '<spring:message code="tms.device.type.not.null"/>!'
										}
									}
								},
								updateTime : {
									validators : {
										notEmpty : {
											message : '<spring:message code="tms.update.time.not.null"/>!'
										}
									}
								},
								deviceSnStr : {
									validators : {
										notEmpty : {
											message : '<spring:message code="tms.device.sn.not.null"/>!'
										}
									}
								}
							}
						})
				.on(
						'success.form.bv',
						function(e) {
							// 阻止默认事件提交
							e.preventDefault();

							modals
									.confirm(
											'<spring:message code="app.appinfo.are.you.sure.you.want.to.save.this.information"/>?',
											function() {
												var params = new FormData(
														$("#updateStrategy-form")[0])
												ajaxPostFileForm(
														basePath
																+ '/tms/updateStrategy/save',
														params,
														function(data, status) {
															resetUpdateStrategyForm();
															if (data.code == 200) {
																//新增 
																modals
																		.correct(data.message);
																modals
																		.hideWin(winId);
																updateStrategyTable
																		.reloadRowData();
															} else {
																modals
																		.info(data.message);
																$("#submit")
																		.removeAttr(
																				'disabled');
															}
														});
											});

						})

		$("#userWin").on('hidden.bs.modal', function() {
			resetUpdateStrategyForm();
		})

	});
	function resetUpdateStrategyForm() {
		$('input').val("");
	}
</script>