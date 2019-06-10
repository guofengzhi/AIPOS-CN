<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<style>
    table.dataTable thead > tr > th {
        padding-right: 0px;
    }
    #searchDiv .form-control{
        width: 130px;
    }
</style>


<section class="content">
    <div class="row">
        <div class="col-xs-12">
            <div class="box">
                <!-- /.box-header -->
                <div class="dataTables_filter" id="searchDiv">
                    <div class="btn-group">
	                    <!--查询条件-->
	                    <input type="hidden" value="${fns:getUser().id}" data-noreset="true" name="userId">
	                    <%-- <input type="hidden" value="8a8a80f05cc32020015cc32895240001" data-noreset="true" name="userId"> --%>
	                    <input type="search" placeholder="<spring:message code='workflow.proinst.print.name' />" title="<spring:message code='workflow.proinst.name' />" name="name"
	                           class="form-control" id="name" operator="like" likeOption="true">
	                    <input type="search" placeholder="<spring:message code='workflow.proinst.print.key' />" title="<spring:message code='workflow.business.key' />" name="businessKey"
	                           class="form-control" id="businessKey" operator="eq" likeOption="false">
	                    <select name="category" id="category" title='<spring:message code="workflow.proinst.select.category" />'
								data-flag="arraySelector" style="width: 159px"
								data-datasrc='${moduleList}' data-blank="true" tabindex="-1"
								aria-hidden="true" data-placeholder='<spring:message code="workflow.proinst.select.category" />'
								class="form-control select2">
						</select>
					 </div>
					 <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                        <input type="search" placeholder="<spring:message code='workflow.start.time' />" title="<spring:message code='workflow.start.time' />" name="startTime" data-flag="datepicker" class="form-control" data-format="yyyy-mm-dd">
                   	 </div>
                   		~
                   	 <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                        <input type="search" placeholder="<spring:message code='workflow.end.time' />" title="<spring:message code='workflow.end.time' />" name="endTime" data-flag="datepicker" class="form-control" data-format="yyyy-mm-dd">
                     </div>
                     <div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search"><spring:message code="common.query"/></button>
						&nbsp;&nbsp;
						<button type="button" class="btn btn-default"
							data-btn-type="reset"><spring:message code="common.reset"/></button>
					 </div>
                </div>
                <div class="box-body">
                    <table id="taskDone_table" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div id="msgcontainer">

    </div>
</section>

<script>
    var taskDoneTable;
    var form = $("#searchDiv").form({baseEntity: false});
    var userId = $("input[name='userId']").val();
    form.initComponent();

    var taskDoneObj = {
        showMonitor: function (rowId) {
            modals.openWin({
                winId: "flowWin",
                width: "900px",
                url: basePath + "/workflow/monitor/" + rowId,
                title: "<spring:message code='workflow.monitor.detail' />"
            });
        },
        withdrawTask:function (rowId) {
           modals.confirm("<spring:message code='workflow.is.recall.task' />",function () {
               ajaxPost(basePath+"/activiti/task/withdraw/"+rowId+"/" + userId,null,function (data) {
                   if(data.code == 200){
                       taskDoneTable.reloadRowData();
                   }else{
                       modals.error(data.message);
                   }
               })
           });
        }
    }

    var config={
    		language : {
				url: basePath+'<spring:message code="common.language"/>'
			}
    };
    
    //方法入口
    $(function () {
        taskDoneTable = new CommonTable("taskDone_table", "task_done_list", "searchDiv", "/activiti/task/todo/getTaskDoneList", config);
    })

    function fnRenderFlowState(value) {
        if(value=="1")
            return '<span class="label label-success"><spring:message code="workflow.forend.already"/></span>';
        else
            return '<span class="label label-danger"><spring:message code="workflow.under.review"/></span>';
    }

    function fnRenderOperator(value, type, rowObj) {
        var oper = "";
        oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='taskDoneObj.showMonitor(\"" + value + "\")'><spring:message code='workflow.monitor.detail' /></a>";
        if(rowObj.flowState=="0"&&rowObj.canWithdraw=="1") {
            oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='taskDoneObj.withdrawTask(\"" + value + "\")'><spring:message code='workflow.recall'/></a>";
        }
        return oper;
    }
</script>