<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>

<section class="content">
	<div class="row">
		<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
			<div class="box">
				<div id="logSearchDiv" class="form-horizontal" role="form">
				       <input type="hidden" id= "language" name ="language" value="${localLang }" />
					 <div class="form-group dataTables_filter" style="margin: 1em;">
							<div class="col-sm-12">
							      <input class="form-control " id="title" type="text" name="title" placeholder='<spring:message code="sys.log.option.menu"/>' />
								<input class="form-control " id="createByName" type="text" name="createByName" placeholder='<spring:message code="sys.log.userName"/>' />
								<input class="form-control " id="beginDate" type="text" name="beginDate" placeholder='<spring:message code="sys.log.beginTime"/>'  data-flag="datepicker" />
								<input class="form-control " id="endDate"   type="text" name="endDate"   placeholder='<spring:message code="sys.log.endTime"/>'    data-flag="datepicker" />
								<button type="submit" class="btn btn-primary " data-btn-type="search"><spring:message code="common.query"/></button>
		   					      <button type="button" class="btn btn-default " data-btn-type="reset"><spring:message code="common.reset"/></button>
							</div>
					</div>
				</div>
				<div class="box-body">
					<table id="log_table"
						class="table table-bordered table-striped table-hover">
					</table>
				</div>
			</div>
		</div>
	</div>
</section>


<script>  

	var language = $("#language").val();
	var langType = language.substring(3, 5).toUpperCase();
	language = language.replace(language.substring(2, 5), "-" + langType);
	$("#endDate").datepicker({
		language : language,
		autoclose : true,
		todayHighlight : true,
		endDate : new Date(),
		format : "yyyy-mm-dd"
	});
	$("#beginDate").datepicker({
		language : language,
		autoclose : true,
		todayHighlight : true,
		beginDate : new Date(),
		format : "yyyy-mm-dd"
	});

	var logform = $("#logSearchDiv").form({
		baseEntity : false
	});
	logform.initComponent();
	//tableId,queryId,conditionContainer
	var logTable;
	var winId = "logWin";
	$(function() {
		var date = new Date().Format('yyyy-MM-dd');
		$("#endDate").val(date);
		$("#beginDate").val(date);
		$("#logSearchDiv")
				.bootstrapValidator(
						{
							message : '<spring:message code="common.promt.value"/>',
							feedbackIcons : {
								invalid : 'glyphicon glyphicon-remove',
								validating : 'glyphicon glyphicon-refresh'
							},
							fields : {
								beginDate : {
									validators : {
										date : {
											format : 'YYYY-MM-DD',
											message : '<spring:message code="sys.log.tip.tiemFromatIncorrect"/>'
										},
										callback : {
											message : '<spring:message code="sys.log.tip.beginTimeTooBig"/>',
											callback : function(value,
													validator, $field, options) {
												var end = $(
														"input[name='endDate']")
														.val();
												if (value == "" && end == "") {
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
										date : {
											format : 'YYYY-MM-DD',
											message : '<spring:message code="sys.log.tip.tiemFromatIncorrect"/>'
										},
										callback : {
											message : '<spring:message code="sys.log.tip.endTimeTooSmall"/>',
											callback : function(value,
													validator, $field) {
												var begin = $(
														"input[name='beginDate']")
														.val();
												$("input[name='beginDate']")
														.keypress();
												if (value == "" && begin == "") {
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
		var config = {
			resizeSearchDiv : false,
			singleSelect : null,
			language : {
				url : basePath + '<spring:message code="common.language"/>'
			}
		};
		//init table and fill data
		logTable = new CommonTable("log_table", "log_list", "logSearchDiv",
				"/sys/log/list", config);

	})
</script>
