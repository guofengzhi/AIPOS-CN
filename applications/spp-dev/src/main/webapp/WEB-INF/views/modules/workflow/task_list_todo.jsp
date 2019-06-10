<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<style>
    table.dataTable thead > tr > th {
        padding-right: 0px;
    }
</style>


<section class="content">
    <div class="row">
        <div class="col-xs-12">
            <div class="box">
                <!-- /.box-header -->
                <div class="dataTables_filter" id="searchDiv">
		            <input type="hidden" value="${fns:getUser().id}" data-noreset="true" name="userId">
		            <div class="box-body">
		                 <div class="row">
		                 	  <div class="form-group">
		                 		 	<div class="col-sm-12">
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
							 <button type="button" class="btn btn-primary"
								data-btn-type="search"><spring:message code="common.query"/></button>
							<button type="button" class="btn btn-default"
								data-btn-type="reset"><spring:message code="common.reset"/></button>
				                 </div>
		                 	    </div>
		                 </div>
	                </div>
	          </div>
                <div class="box-body">
                    <table id="tasktodo_table" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div id="msgcontainer">

    </div>
</section>

<script>
    var tasktodoTable;
    var form = $("#searchDiv").form({baseEntity: false});
    form.initComponent();
    var userId = $("input[name='userId']").val();

    var taskTodoObj = {
        showMonitor: function (rowId) {
            modals.openWin({
                winId: "flowWin",
                width: "900px",
                url: basePath + "/workflow/monitor/" + rowId,
                title: "<spring:message code='workflow.monitor.detail' />"
            });
        },
        claimTask: function (rowId) {
        	alert(rowId);
            modals.confirm("<spring:message code='workflow.usertask.not.sign.msg' />", function () {
                ajaxPost(basePath + "/activiti/task/claim/" + rowId + "/" + userId, null, function (data) {
                    if (!data.code == 200)
                        modals.info(data.message);
                        tasktodoTable.reloadRowData(rowId);
                })
            })
        },
        unclaimTask: function (rowId) {
            modals.confirm("<spring:message code='workflow.usertask.cancel.sign.msg' />", function () {
                ajaxPost(basePath + "/activiti/task/unclaim/" + rowId + "/" + userId, null, function (data) {
                    if (!data.code == 200)
                        modals.info(data.message);
                        tasktodoTable.reloadRowData(rowId);
                })
            })
        },
        dealTask: function (rowId) {
            ajaxPost(basePath + "/activiti/task/checkClaim/" + rowId + "/" + userId, null, function (data) {
                if (data.code == 200) {
                    loadPage(basePath + "/activiti/task/deal/" + rowId, true);
                    /* modals.openWin({
                        winId: "flowWin",
                        width: "900px",
                        url: basePath + "/activiti/task/deal/" + rowId,
                        title: "<spring:message code='workflow.monitor.detail' />"
                    }); */
                } else {
                	if(data.code==400){
                		 modals.info(data.message);
                         tasktodoTable.reloadRowData(rowId);
                	}else{
                		modals.confirm(data.message, function () {
                            ajaxPost(basePath + "/activiti/task/claim/" + rowId + "/" + userId, null, function (ret) {
                                if (ret.code == 200)
                                	loadPage(basePath + "/activiti/task/deal/" + rowId, true);
                                else {
                                    modals.error(ret.message);
                                    tasktodoTable.reloadRowData(rowId);
                                }
                            });
                        });
                	}
                }
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
        tasktodoTable = new CommonTable("tasktodo_table", "task_todo_list", "searchDiv", "/activiti/task/todo/getTaskToDoList/" + userId, config);
    })

    function fnRenderSuspensionState(value) {
        if (value == "1")
            return '<span class="label label-success"><spring:message code="workflow.proinst.normal" /></span>';
        else
            return '<span class="label label-danger"><spring:message code="workflow.proinst.handup" /></span>';
    }


    function fnRenderOperator(value, type, rowObj) {
        var instanceId = rowObj.processInstanceId;
        var oper = "";
        oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='taskTodoObj.showMonitor(\"" + instanceId + "\")'><spring:message code='workflow.monitor.detail' /></a>";
     
        if (rowObj.suspensionState == "1") {
            //已有签收人
            console.log(rowObj.initialAssignee+"----"+rowObj.assignee);
            if (rowObj.assignee) {
                if (rowObj.canUnclaim=="1") {
                    //签收人和初始签收人不一致
                    oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='taskTodoObj.unclaimTask(\"" + value + "\")'><spring:message code='workflow.cancel.sign' /></a>";
                }
            }
            else
                oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='taskTodoObj.claimTask(\"" + value + "\")'><spring:message code='workflow.sign' /></a>";
            oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='taskTodoObj.dealTask(\"" + value + "\")'><spring:message code='workflow.handle' /></a>";
        }
        return oper;
    }
</script>