<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>

<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i><spring:message code="common.homepage"/></a></li>
		<li><a href="#"><spring:message code="sys.log.sysTool"/></a></li>
		<li class="active"><spring:message code="sys.log.sysLog"/></li>
	</ol>
	<div class="col-xs-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<div id="logSearchDiv" class="dataTables_filter" style="text-align: left;" role="form">
						<div class="has-feedback form-group">
							<input class="form-control" id="title" style="width: 226.5px;margin-left:0px;" type="text" name="title"
								placeholder='<spring:message code="sys.log.option.menu"/>' />
						</div>
						<div class="has-feedback form-group">
							<input class="form-control" id="createByName" type="text" style="margin-left:0px;width: 226.5px"
								name="createByName" placeholder='<spring:message code="sys.log.userName"/>' />
						</div>
						<div class="has-feedback form-group">
								<input class="form-control" id="beginDate" style="margin-left:0px;width: 226.5px"
									type="text" name="beginDate" placeholder='<spring:message code="sys.log.beginTime"/>'
									data-flag="datepicker" onkeypress="notPut(event);"/>
						</div>

						<div class="has-feedback form-group">
								<input class="form-control" id="endDate" type="text" style="margin-left:0px;width: 226.5px" onkeypress="notPut(event);"
									name="endDate" placeholder='<spring:message code="sys.log.endTime"/>' data-flag="datepicker" />

						</div>
					<div class="btn-group">
							<button type="submit" class="btn btn-primary"
								data-btn-type="search"><spring:message code="common.query"/></button>
							<button type="button" class="btn btn-default"
								data-btn-type="reset"><spring:message code="common.reset"/></button>
					</div>
					<div style="width:100%;margin-top:5px;" id="pTitle">
						<div class="has-feedback form-group"><p style="margin-left:0px;width: 226.5px;"></p></div>
                    	<div class="has-feedback form-group"><p style="margin-left:0px;width: 226.5px;"></p></div>
                    	<div class="has-feedback form-group"><p id="startP" style="margin-left:0px;width:226.5px;"></p></div>
                    	<div class="has-feedback form-group"><p id="endP" style="margin-left:0px;width: 226.5px;"></p></div>
					</div>
				</div>
				<div class="box-body">
					<table id="log_table"
						class="table table-condensed table-bordered table-striped table-hover">
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
var logform = $("#logSearchDiv").form({baseEntity: false});
    logform.initComponent();
		//tableId,queryId,conditionContainer
		var logTable;
		var winId="logWin";
		$(function() { 
			$("#logSearchDiv").bootstrapValidator({
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
			                callback: {
								message: '<spring:message code="sys.log.tip.beginTimeTooBig"/>',
								callback:function(value, validator,$field,options){
									var end = $("input[name='endDate']").val();
									if(value == "" && end == ""){
										return true;
									}else {
										value = new Date(value).getTime();
										end = new Date(end).getTime();
										return parseInt(value)<=parseInt(end);
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
			                } ,
			                callback: {
								message: '<spring:message code="sys.log.tip.endTimeTooSmall"/>',
								callback:function(value, validator,$field){
									$("input[name='beginDate']").keypress();
									if(value == "" && begin==""){
										document.getElementById("pTitle").style.display="none";
										return true;
									}else{
										value = new Date(value).getTime();
										begin = new Date(begin).getTime();
										validator.updateStatus('beginDate', 'VALID');
										return parseInt(value)>=parseInt(begin);	
									}
										
								}
							}
						}
					}
				}
			}).on('success.form.fv', function(e) {
			    e.preventDefault();
			});
			var config={
					resizeSearchDiv:false,
					singleSelect:null
			};
			//init table and fill data
			logTable = new CommonTable("log_table", "log_list", "logSearchDiv","/sys/log/list",config);
			
		})
</script>
