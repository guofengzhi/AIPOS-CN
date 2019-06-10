<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<style>
    .content-header h1 {
        font-size: 16px;
    }
</style>


<!-- Main content -->
<section class="content" id="section_task">
    <!--业务表单信息-->
    <div class="box box-info" id="form_container" style="display: none">
        <div class="box-header with-border">
            <span><i class="fa fa-edit">&nbsp;<spring message code="workflow.todo.table" /></i></span>
            <div class="box-tools pull-right">
                <button type="button" class="btn btn-box-tool" data-widget="collapse" data-toggle="tooltip"
                        title="Collapse">
                    <i class="fa fa-minus"></i></button>
            </div>
        </div>
        <div class="box-body" id="business_container">

        </div>
    </div>

    <!-- 流程审批信息-->
    <div class="box box-primary">
        <!--<div class="box-header">-->
        <div class="box-header">
            <ul class="nav nav-tabs">
                <li class="active"><a href="#tab-content-task" data-toggle="tab" id="nav-tab-task"><i
                        class="fa fa-edit"></i>&nbsp;<spring:message code="workflow.todo.instance.approved" /></a></li>
                <li><a href="#tab-content-list" data-toggle="tab" id="nav-tab-list"><i
                        class="fa fa-list-ul"></i>&nbsp;<spring:message code="workflow.proinst.detail.table" /></a></li>
                <li><a href="#tab-content-image" data-toggle="tab" id="nav-tab-image"><i class="fa fa-image"></i>&nbsp;<spring:message code="workflow.proinst.image.deplay" /></a>
                </li>
            </ul>
            <div class="box-tools pull-right">
                <button type="button" class="btn btn-box-tool" data-widget="collapse" data-toggle="tooltip"
                        title="Collapse">
                    <i class="fa fa-minus"></i></button>
            </div>
        </div>

        <!--</div>-->
        <div class="box-body">
            <div class="tab-content" style="padding: 0px;">
                <div class="tab-pane active" id="tab-content-task">
                    <form name="task_form" id="task_form" class="form-horizontal">
                        <div class="col-xs-12">
                     <#if formData??>
                         <!--通过formKey中的.form获取表单-->
                          ${formData}
                     <#else>
                         <#list formProperties as field>
                             <div class="form-group">
                                 <label class="col-xs-3 control-label">${field.name}</label>
                             <#if field.type.name=='date'>
                                 <div class="input-group col-xs-7">
                             <#else>
                                 <div class="col-xs-7">
                             </#if>
                                 <#if field.type.name=='date'>
                                     <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                     <input type="text" placeholder="<spring:message code='workfolw.todo.please.print' />${field.name}"  name="${field.id}" id="${field.id}" data-flag="datepicker" class="form-control" data-format="${field.type.getInformation('datePattern')?replace('mm','ii')?replace('MM','mm')}" value="${field.value}" >
                                 <#elseif field.type.name='enum'>
                                     <select name="${field.id}" name="${field.id}" class="form-control select2" data-blank="false">
                                         <#assign itemMap=field.type.getInformation('values')/>
                                         <#list itemMap?keys as itemKey>
                                         <option value="${itemKey}">${itemMap[itemKey]}</option>
                                         </#list>
                                     </select>
                                 <#else>
                                 <input type="text" class="form-control"  <#if !field.isWritable()>readonly</#if> id="${field.id}" value="${field.value?default('')}" name="${field.id}" placeholder="请填写${field.name}">
                                 </#if>
                                 </div>
                             </div>
                         </#list>
                     </#if>
                        </div>
                        <div class="col-xs-12 text-center"style="border-top: 1px solid #ddd;padding-top: 10px;">
                            <button type="submit" class="btn btn-primary" data-btn-type="submitTask"><i class="fa fa-save"></i>&nbsp;提交</button>
                            &nbsp;&nbsp;
                            <button type="button" class="btn btn-default" data-btn-type="retTolist"><i class="fa fa-reply"></i>&nbsp;返回待办</button>
                        </div>
                    </form>
                </div>

                <div class="tab-pane" id="tab-content-list">

                </div>

                <div class="tab-pane" id="tab-content-image">

                </div>
            </div>
        </div>
    </div>
</section>

<script>
    var processInstanceId = "${processInstanceId?default(0)}";
    var formUrl = "${formUrl?default(0)}";
    var taskCtrl = {
        loadBusinessForm: function () {
            if (formUrl != 0) {
                $("#form_container").show();
                loadPage(basePath + formUrl, "#business_container");
            }else{
                $("#form_container").hide();
            }
        },
        taskForm:null,
        loadTaskFormByProperties:function () {
            this.taskForm=$("#task_form").form({baseEntity:false});
            var self=this;
            $("#task_form").bootstrapValidator({
                message: '<spring:message code="common.promt.value" />',
                feedbackIcons: {
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                },
                submitHandler: function (validator, taskform, submitButton) {
                    modals.confirm('<spring:message code="workflow.todo.commit.instance" />', function () {
                        // TODO 传参类型待定
                        var params = self.taskForm.getFormSimpleData();
                        $.extend(params,self.collectExtFormData());
                        ajaxPost(basePath + '/activiti/task/complete/${taskId}', params, function (data, status) {
                            if (data.success) {
                                self.gotolist();
                            }
                        });
                    });
                },
            <#assign hasValidator=0>
                <#list formProperties as field>
                  <#if field.isRequired()>
               <#assign hasValidator=1>
                  </#if>
                </#list>
               <#if hasValidator==1>
                fields: {
                    <#list formProperties as field>
                    <#if field.isRequired()>
                    ${field.id}:{validators:{notEmpty:{message:'<spring:message code="workfolw.todo.please.print" />${field.name}'}}},
                    </#if>
                    </#list>
                }
               </#if>
            });
            this.taskForm.initComponent();
        },
        //通过data-form-property收集业务数据，用来控制流程的变量
        collectExtFormData:function(){
            var extObj={};
            $("#section_task").find("[data-form-property]").each(function () {
                var name=$(this).data("form-property");
                var value=$(this).val();
                extObj[name]=value;
            })
            return extObj;
        },
        //通过formKey初始化表单，通用审批
        <#if formData??>
        loadTaskFormByFormKey:function(){
            this.taskForm=workflowCtrl.init("task_form");
            console.log(workflowCtrl.validators());
            var self=this;
            $("#task_form").bootstrapValidator({
                message: '<spring:message code="common.promt.value" />',
                feedbackIcons: {
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                },
                submitHandler: function (validator, taskform, submitButton) {
                    modals.confirm('<spring:message code="workflow.todo.commit.instance" />', function () {
                        // TODO 传参类型待定
                        var params = self.taskForm.getFormSimpleData();
                        $.extend(params,self.collectExtFormData());
                        ajaxPost(basePath + '/activiti/task/complete/${taskId}', params, function (data, status) {
                            if (data.success) {
                                self.gotolist();
                            }
                        });
                    });
                },
                fields:workflowCtrl.validators()
            });
            this.taskForm.initComponent();

        },
        </#if>
        initButtonEvent:function () {
            var self=this;
            $("button[data-btn-type='retTolist']").click(function(){
                self.gotolist();
            });
        },
        gotolist:function(){
            loadPage(basePath+"/activiti/task/todo/list");
        }

    };

    $(function () {
        //加载业务表单
        taskCtrl.loadBusinessForm();
        //加载审批表单
        <#if formData??>
        taskCtrl.loadTaskFormByFormKey();
        <#else>
        taskCtrl.loadTaskFormByProperties();
        </#if>
        taskCtrl.initButtonEvent();
        loadPage(basePath + "/activiti/monitor/list/" + processInstanceId, "#tab-content-list");
        loadPage(basePath + "/activiti/monitor/image/" + processInstanceId, "#tab-content-image");
    })


</script>
