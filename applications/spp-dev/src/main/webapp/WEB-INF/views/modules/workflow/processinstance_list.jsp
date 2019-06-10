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
                <div class="dataTables_filter" id="procinstSearchDiv">
                    <div class="btn-group">
                    <!--查询条件-->
                    <input type="search" placeholder="<spring:message code='workflow.proinst.print.name' />" name="name"
                           class="form-control" id="name" operator="like" likeOption="true">
                    <input type="search" placeholder="<spring:message code='workflow.proinst.print.key' />" name="businessKey"
                           class="form-control" id="businessKey" operator="eq" likeOption="false">
                    <select name="category" id="category" title='<spring:message code="workflow.proinst.select.category" />'
						data-flag="arraySelector" style="width: 159px"
						data-datasrc='${moduleList}' data-blank="true" tabindex="-1"
						aria-hidden="true" data-placeholder='<spring:message code="workflow.proinst.select.category" />'
						class="form-control select2">
					</select>
                    </div>
                    <div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search"><spring:message code="common.query"/></button>
						&nbsp;&nbsp;
						<button type="button" class="btn btn-default"
							data-btn-type="reset"><spring:message code="common.reset"/></button>
					</div>
                    <shiro:hasPermission name="workflow:processinstance:edit">
						<div class="btn-group">
							<button type="button" class="btn btn-danger"
								data-btn-type="delete"><spring:message code="common.delete"/></button>
						</div>
					</shiro:hasPermission>
                </div>
                <div class="box-body">
                    <table id="processinstance_table" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    var processinstanceTable, winId = "modelWin";
    var form = $("#procinstSearchDiv").form({baseEntity: false});
    form.initComponent();

    var processInstanceObj = {
        deleteProcessInstance: function (rowId) {
        	if (!rowId) {
                modals.info('<spring:message code="common.promt.delete" />');
                return false;
            }
        	modals.confirm("<spring:message code='common.confirm.delete' />", function () {
                ajaxPost(basePath + "/workflow/processinstance/delete/" + rowId, null, function (data) {
                    if (data.code == 200) {
                    	modals.correct(data.message);
                    	processinstanceTable.reloadRowData();
                    } else {
                        modals.warn(data.message);
                    }
                });
            })
        },
        showMonitor: function (rowId) {
            modals.openWin({
                winId: "flowWin",
                width: "900px",
                url: basePath + "/workflow/monitor/" + rowId,
                title: "<spring:message code='workflow.proinst.flow.detail' />"
            });
        },
        toggleState:function (rowId) {
            modals.confirm("<spring:message code='workflow.proinst.operator.confirm' />", function () {
                ajaxPost(basePath + "/workflow/processinstance/toggleSuspensionState/" + rowId, null, function (data) {
                    if (data.code == 200) {
                    	modals.correct(data.message);
                        processinstanceTable.reloadRowData();
                    } else {
                        modals.info("<spring:message code='workflow.proinst.operator.faile' />");
                    }
                });
            })
        }
    }
    
    var config={
    		language : {
				url: basePath+'<spring:message code="common.language"/>'
			}
    };
    
    //方法入口
    $(function () {
        processinstanceTable = new CommonTable("processinstance_table", "process_instance_list", "procinstSearchDiv", "/workflow/processinstance/findList", config);
        //绑定按钮事件
        $("button[data-btn-type]").click(function () {
            var action = $(this).data("btn-type");
            var rowId = processinstanceTable.getSelectedRowId();
            switch (action) {
                case 'delete':
                    processInstanceObj.deleteProcessInstance(rowId);
                    break;
                default:
                    break;
            }
        })
    })

    function fnRenderSuspensionState(value) {
        if(value=="1")
            return '<span class="label label-success"><spring:message code="workflow.proinst.normal" /></span>';
        else
            return '<span class="label label-danger"><spring:message code="workflow.proinst.handup" /></span>';
    }

    function fnRenderOperator(value, type, rowObj) {
        var oper = "";
        oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='processInstanceObj.showMonitor(\"" + value + "\")'><spring:message code='workflow.proinst.flow.detail' /></a>";
        if(rowObj.suspensionState=="1")
            oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='processInstanceObj.toggleState(\"" + value + "\")'><spring:message code='workflow.proinst.normal' /></a>";
        else
            oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='processInstanceObj.toggleState(\"" + value + "\")'><spring:message code='workflow.proinst.activate' /></a>";
        return oper;
    }
</script>