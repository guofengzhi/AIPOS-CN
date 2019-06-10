<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<section class="content">
    <div class="row">
        <div class="col-xs-12">
            <div class="box box-info">
                <div class="box-body">
                <form name="vacation_form" id="vacation_form" class="form-horizontal" >
                    <div class="col-xs-12">
                        <div class="form-group has-feedback">
                            <label class="col-xs-3 control-label"><spring:message code="activity.demo.leave.days" /></label>
                            <div class="col-xs-7">
                                <input class="form-control" id="days"  name="days" placeholder="<spring:message code='please.fill.in.the.leave.days' />"
                                       type="text">
                            </div>
                        </div>
                        <div class="form-group has-feedback">
                            <label class="col-xs-3 control-label"><spring:message code="sys.log.beginTime" /></label>
                            <div class="input-group col-xs-7" style="padding-left: 15px; padding-right: 15px;">
                                <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                <input placeholder="<spring:message code='please.fill.in.the.start.time' />" name="startDate" id="startDate" data-flag="datepicker"
                                       class="form-control" data-format="yyyy-mm-dd hh:ii" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-xs-3 control-label"><spring:message code="activity.demo.motivation" /></label>
                            <div class="col-xs-7">
                                <input class="form-control" id="motivation"  name="motivation"
                                       placeholder="<spring:message code='please.fill.in.the.motivation' />" type="text">
                            </div>
                        </div>
                        <input type="hidden" value="${fns:getUser().name}" name="applyUserName">
                    </div>
                    <div class="col-xs-12 text-center" style="border-top: 1px solid #ddd;padding-top: 10px;">
                        <button type="submit" class="btn btn-primary" data-btn-type="submitTask"><i
                                class="fa fa-save"></i>&nbsp;<spring:message code="common.submit" />
                        </button>
                    </div>
                    <input value="" type="hidden">
                </form>
                </div>
            </div>
        </div>
    </div>
</section>
<script>
    var vacationForm = null;
    $(function () {
        //初始化表单
        vacationForm = $("#vacation_form").form({baseEntity: false});
        //数据校验
        $("#vacation_form").bootstrapValidator({
        	 message : '<spring:message code="common.promt.value"/>',
             feedbackIcons : {
                 valid : 'glyphicon glyphicon-ok',
                 invalid : 'glyphicon glyphicon-remove',
                 validating : 'glyphicon glyphicon-refresh'
             },
             fields: {
                 days: {
                    validators: {
                        notEmpty: {
                               message: '<spring:message code="please.fill.in.the.leave.days" />'
                        },
                        integer: {
                               message: '<spring:message code="workflow.please.promt.integer" />'
                        }
                    }
                 },
                 startDate: {
                     validators: {
                         notEmpty: {
                             message: '<spring:message code="please.fill.in.the.start.time" />'
                         }
                     }
                }
            }
        }).on("success.form.bv",function(e){
   		        e.preventDefault();
				modals.confirm({
					cancel_label:'<spring:message code="common.cancel" />',
					title:'<spring:message code="common.sys.confirmTip" />',
					ok_label:'<spring:message code="common.confirm" />',
					text:'<spring:message code="common.confirm.save"/>',
					callback: function() {
					//Save Data，对应'submit-提交'
					var params = vacationForm.getFormSimpleData();
                    ajaxPost(basePath + '/activiti/demo/vacation/startFlow', params, function(data, status) {
                    	if(data.code == 200){
                    		modals.correct("<spring:message code='activity.demo.instance.start.already.msg' />");
						}else{
							modals.info(data.message);
						}				 
					});
				}});
    	});
        //初始化表单
        vacationForm=$("#vacation_form").form();
    });


</script>
