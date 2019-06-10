<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>

<spring:message code="ota.table.strategy.name" var="strategyName"/>
<spring:message code="app.version.equipment.upgrading" var="upgradingType"/>
<spring:message code="ota.table.strategy.desc" var="strategyDesc"/>
<spring:message code="modules.strategy.start.date" var="strategyStartTime"/>
<spring:message code="modules.strategy.end.date" var="strategyEndTime"/>

<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="modules.strategy.add.strategy"/></h5>
</div>

<div class="modal-body">
	<form:form id="strategy-form" name="strategy-form" modelAttribute="strategy"
		class="form-horizontal" >
		 <form:hidden path="id" value="${strategy.id }" />
		<input type='hidden' value='${CSRFToken}' id='csrftoken'>
		 
		<div class="box-body">
			<div class="col-md-12">
			
				
				<div class="form-group">
					<label for="strategyName" class="col-sm-2 control-label">${strategyName }<span style="color:red">*</span></label>
					<div class="col-sm-9">
					    <form:input path="strategyName" value="${strategy.strategyName }" htmlEscape="false" maxlength="50"  class="form-control" placeholder="${strategyName }"/>
					</div>
				</div>
				
				<div class="form-group">
					<label for="strategyDesc" class="col-sm-2 control-label">${strategyDesc }<span style="color:red">*</span></label>
					<div class="col-sm-9">
						<form:textarea path="strategyDesc" value="${strategy.strategyDesc }" class="form-control"
							htmlEscape="false" rows="3" maxlength="450" placeholder="${strategyDesc }" />
					</div>
				</div>
				
				<!-- <div class="form-group">
					<label for="upgradeType" class="col-sm-2 control-label">升级方式<span style="color:red">*</span></label>
					<div class="col-sm-9">
						<select id="upgradeType" name="upgradeType"  
							maxlength="50"  class="form-control select2 col-sm-9" data-placeholder="请选择升级方式">
							<option value=""></option>
							<option value="0">提示</option>
							<option value="1">强制</option>
						</select>
					</div>
				</div> -->
				
			 <div class="form-group">
					<label class="col-sm-2 control-label" for="beginDate">${strategyStartTime }<span style="color:red">*</span></label>
					<div class="col-sm-9">
						<div class="input-group date">
							<div class="input-group-addon">
								<i class="fa fa-calendar"></i>
							</div>
						    <span style="position: relative; z-index: 9999;"><form:input class="form-control pull-right" id="beginDate"
								type="text" path="beginDate"  placeholder="${strategyStartTime }"
								data-flag="datepicker" data-format="yyyy/MM/dd hh:mm:ss"  ></form:input></span>
						</div>
					</div>
			</div>	
			
			
			 <div class="form-group">
					
				<label class="col-sm-2 control-label" for="endDate">${strategyEndTime }<span style="color:red">*</span></label>
				<div class="col-sm-9">
					<div class="input-group date">
						<div class="input-group-addon">
							<i class="fa fa-calendar"></i>
						</div>
						<span style="position: relative; z-index: 9999;"><form:input class="form-control pull-right" id="endDate" type="text"
							path="endDate" placeholder="${strategyEndTime }"  data-flag="datepicker"></form:input></span>
					</div>
				</div>
			</div>	
					
						
			</div>
		</div>
		<!-- /.box-body -->
		<div class="box-footer text-right">
			<!--以下两种方式提交验证,根据所需选择-->
			<button type="button" class="btn btn-default" data-btn-type="cancel"
				data-dismiss="modal"><spring:message code="common.cancel"/></button>
			 <button type="submit" class="btn btn-primary" data-btn-type="save"><spring:message code="common.submit"/></button>
		</div>
		<!-- /.box-footer -->
	</form:form>
	

</div>
<script>
//tableId,queryId,conditionContainer
var strategyform = null;
var id="${empty device.id?0:device.id}";
$(".select2").select2();
$(function() {
	
	
	 $("#beginDate").datepicker({
         language: "zh-CN",
         autoclose: true,//选中之后自动隐藏日期选择框
         clearBtn: true,//清除按钮
         todayBtn: true,//今日按钮
         format: "yyyy-mm-dd"//日期格式，详见 http://bootstrap-datepicker.readthedocs.org/en/release/options.html#format
     });
	
	 
	 $("#endDate").datepicker({
         language: "zh-CN",
         autoclose: true,//选中之后自动隐藏日期选择框
         clearBtn: true,//清除按钮
         todayBtn: true,//今日按钮
         format: "yyyy-mm-dd"//日期格式，详见 http://bootstrap-datepicker.readthedocs.org/en/release/options.html#format
     });
	
	var beginDateStr = '${strategy.beginDate }';
	var endDateStr = '${strategy.endDate}';
	
	var beginDate = new Date(beginDateStr);
	var endDate = new Date(endDateStr);
	if(beginDateStr == null || beginDateStr == ''){
		$("#beginDate").val(formatDate(new Date(), "yyyy-MM-dd"));
		$("#endDate").val(formatDate(new Date(), "yyyy-MM-dd"));
	}else {
		$("#beginDate").val(formatDate(beginDate, "yyyy-MM-dd"));
		$("#endDate").val(formatDate(endDate, "yyyy-MM-dd"));
	}
	
	
	strategyform=$("#strategy-form").form();
	//数据校验
	$("#strategy-form").bootstrapValidator({
		message : '<spring:message code="common.promt.value"/>',
		feedbackIcons : {
			valid : 'glyphicon glyphicon-ok',
			invalid : 'glyphicon glyphicon-remove',
			validating : 'glyphicon glyphicon-refresh'
		},
		fields : {
			strategyName : {
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.strategy.please.fill.in.the.policy.name"/>'
					}
				}
			},
			strategyDesc : {
				validators : {
					notEmpty : {
						message : '<spring:message code="modules.strategy.please.fill.in.the.policy.description"/>'
					}
				}
			}/* ,
			upgradeType : {
				validators : {
					notEmpty : {
						message : '升级方式不能为空'
					}
				}
			} */,
			beginDate : {
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
								return parseInt(value)<parseInt(end);
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
	                } ,
	                callback: {
						message: '<spring:message code="sys.log.tip.endTimeTooSmall"/>',
						callback:function(value, validator,$field){
							var begin = $("input[name='beginDate']").val();
							$("input[name='beginDate']").keypress();
							if(value == "" && begin==""){
								return true;
							}else{
								value = new Date(value).getTime();
								begin = new Date(begin).getTime();
								validator.updateStatus('beginDate', 'VALID');
								return parseInt(value)>parseInt(begin);	
							}
								
						}
					}
				}
			}
		}
	}).on("success.form.bv",function(e){
		    e.preventDefault();
			modals.confirm('<spring:message code="common.confirm.save"/>', function() {
				//Save Data，对应'submit-提交'
				 var params = strategyform.getFormSimpleData();
					 ajaxPost(basePath+'/strategy/save', params, function(data, status) {
					if(data.code == 200){
						//新增 
						modals.correct(data.message);
						modals.hideWin(winId);	
						strategyTable.reloadRowData();
					}else{
						modals.warn(data.message);
					}				 
				}); 
			});		    
	});
	//初始化控件
	
});

function resetstrategyForm(){
	strategyform.clearForm();
	$("#strategy-form").data('bootstrapValidator').resetForm();
}
</script>
