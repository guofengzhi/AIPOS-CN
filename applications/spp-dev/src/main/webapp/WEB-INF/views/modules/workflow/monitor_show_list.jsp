<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- /.box-header -->
<div class="dataTables_filter" id="searchDiv_monitor" style="display: none">
    <!--查询条件-->
    <input type="hidden" name="processInstanceId" value="${instanceId}">
</div>
<div class="box-body">
    <table id="monitor_table" class="table table-bordered table-striped table-hover">
    </table>
</div>


<script>
    var monitorTable;
	var instanceId = "${empty instanceId?0:instanceId}";
    var config={
    		language : {
				url: basePath+'<spring:message code="common.language"/>'
			}
    };
    
    //方法入口
    $(function () {
    	monitorTable = new CommonTable("monitor_table", "monitor_detail_list", "searchDiv_monitor", "/workflow/activity/getActivityList/" + instanceId, config);
    })

   
 	//任务状态
    function fnRenderActivityState(value, type, rowObj) {
        if (value == 0) {
            return '<span class="label label-success"><spring:message code="workflow.proinst.execute.end"/></span>'
        } else if (value == 1) {
            return '<span class="label label-danger"><spring:message code="workflow.proinst.execute.wait"/></span>';
        }else{
            return '<span class="label label-warning"><spring:message code="workflow.proinst.execute.not"/></span>';
        }
        return value;
    }

    //审批结果
    function fnRenderApproved(value,type,rowObj){
        if(value=='true'){
            return '<span class="label label-success"><spring:message code="workflow.proinst.approved.true"/></span>';
        }else if(value=='false'){
            return '<span class="label label-danger"><spring:message code="workflow.proinst.approved.false"/></span>';
        }else if(value){
            return '<span class="label label-primary">'+value+'</span>';
        }else if(rowObj.activityState==0){
            return '<span class="label label-primary"><spring:message code="workflow.proinst.approved.submit"/></span>';
        }else{
            return value;
        }
    } 
</script>
