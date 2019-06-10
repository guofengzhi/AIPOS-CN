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
				<!-- /.box-header -->
				<div class="dataTables_filter" id="recordAppSearchDiv" style="text-align: left;" role="form">
					<div class="form-group dataTables_filter " style="margin: 1em;">
							 <input placeholder='<spring:message code="app.devicerecord.please.select.the.application.name" />' id="appName" name="appName"
									class="form-control" type="search" style="height:37px;width: 226.5px;margin-left:0px;" />
							 <input placeholder='<spring:message code="app.apprecord.please.enter.the.version.number" />' id="appVersion" name="appVersion"
									class="form-control" type="search" style="height:37px;margin-left:0px;width: 226.5px" />
							 <input class="form-control" id="beginDate" type="text" name="beginDate" onkeypress="notPut(event);"
							    	placeholder='<spring:message code="sys.log.beginTime"/>' data-flag="datepicker" style="height:37px;margin-left:0px;width: 226.5px" />
							 <input class="form-control" id="endDate" type="text" name="endDate" onkeypress="notPut(event);"
									placeholder='<spring:message code="sys.log.endTime"/>'data-flag="datepicker" style="height:37px;margin-left:0px;width: 226.5px" />
							 <button type="button" class="btn btn-primary" data-btn-type="search" style="height:37px;">
									<spring:message code="common.query" />
							 </button>
							<button type="button" class="btn btn-default" data-btn-type="reset" style="height:37px;">
									<spring:message code="common.reset" />
							</button>
							<button type="button" class="btn btn-primary" style="height:37px;" data-btn-type="view">
									<spring:message code="sys.role.view"/>
							</button>
					 </div>
					<div style="width:100%;margin-top:5px;">
						<div class="has-feedback form-group"><p style="margin-left:0px;width: 226.5px;"></p></div>
                    	<div class="has-feedback form-group"><p style="margin-left:0px;width: 226.5px;"></p></div>
                    	<div class="has-feedback form-group"><p id="startP" style="margin-left:-53px;width:226.5px;"></p></div>
                    	<div class="has-feedback form-group"><p id="endP" style="margin-left:0px;width: 226.5px;"></p></div>
					</div>
				</div>
				<div class="box-body">
					<table id="recordApp_table"
						class="table table-bordered table-striped table-hover" style="margin-top:0px !important;">
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
//禁止日期选择框树洞输入
	function notPut(even){
		var ev = window.event||even;
		if(isIE()){
			ev.returnValue=false;
		}else{
			ev.preventDefault();
		}
	}
	function isIE(){
		if(window.navigator.userAgent.toLowerCase().indexOf("mise")>=1)
			return true;
		else
			return false;
	}
	var form = $("#recordAppSearchDiv").form({
		baseEntity : false
	});
	form.initComponent();
	//tableId,queryId,conditionContainer
	var recordAppTable;
	var winId = "recordAppWin";
	$(function() {
		$("#recordAppSearchDiv")
				.bootstrapValidator(
						{
							message : '<spring:message code="common.promt.value"/>',
							feedbackIcons : {
								//valid : 'glyphicon glyphicon-ok',
								//invalid : 'glyphicon glyphicon-remove',
								validating : 'glyphicon glyphicon-refresh'
							},
							fields : {
								beginDate : {
									container: '#startP',
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
									container: '#endP',
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
				language : {
					url : basePath + '<spring:message code="common.language"/>'
				}
			};
		//init table and fill data
		recordAppTable = new CommonTable("recordApp_table", "recordApp_list",
				"recordAppSearchDiv", "/appRecord/list",config);
		
		$('button[data-btn-type]').click(function() {
			var action = $(this).attr('data-btn-type');
			var rowId = recordAppTable.getSelectedRowId();
			switch (action) {
			case 'view':
				if (!rowId) {
					modals.info('<spring:message code="sys.role.tip.selectLine"/>');
					return false;
				}
				deviceProcessDef.RealeaseVersion(rowId);
				break;
			}
		});
	});

	var deviceProcessDef = {
		RealeaseVersion : function(id) {
			modals.openWin({
				winId : winId,
				title : '<spring:message code="app.record.already.release.app.tab" />',
				width : '900px',
				url : basePath + "/appRecord/alreadyAppList?id=" + id
			});
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
	
	function operationUpgradeType(upgradeType, type, rowObj){
		var oper = "";
		if(upgradeType == '0'){
			oper += "<span>"+"<spring:message code='app.management.app.update' />"+"</span>";
		}else if(upgradeType == '1'){
			oper += "<span>"+"<spring:message code='app.management.app.uninstall' />"+"</span>";
		}else{
			oper += "<span>-</span>";
		}
        return oper;
	}
</script>
