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
                <div>&nbsp;</div>
                <div class="dataTables_filter" id="procdefSearchDiv">
                    <div class="btn-group">
                    <input type="search" placeholder="<spring:message code='workflow.procdef.print.name'/>" title="<spring:message code='workflow.procdef.print.name'/>" name="name"
                           class="form-control" id="name" operator="like" likeOption="true" />&nbsp;&nbsp;
                    </div>
                    <div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search"><spring:message code="common.query"/></button>
						&nbsp;&nbsp;
						<button type="button" class="btn btn-default"
							data-btn-type="reset"><spring:message code="common.reset"/></button>
					</div>
                    <shiro:hasPermission name="workflow:processdef:edit">
						<div class="btn-group">
							<button type="button" class="btn btn-danger"
								data-btn-type="delete"><spring:message code="common.delete"/></button>
						    &nbsp;&nbsp;
						    <button type="button" class="btn btn-danger"
						        data-btn-type="deleteForever"><spring:message code="workflow.procdef.delete.forver" /></button>
						</div>
					</shiro:hasPermission>
                </div>
                <div class="box-body">
                    <table id="processdef_table" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    var processdefTable, winId = "modelWin";

    var processDefObj = {
        deleteProcessDef: function (rowId) {
        	if (!rowId) {
                modals.info('<spring:message code="common.promt.delete" />');
                return false;
            }
            modals.confirm("<spring:message code='workflow.procdef.del.confirm' />", function () {
                ajaxPost(basePath + "/workflow/processdef/delete/0/" + rowId, null, function (data) {
                    if (data.code == 200) {
                    	modals.correct(data.message);
                    	processdefTable.reloadRowData();
                    } else {
                        modals.warn(data.message);
                    }
                });
            })
        },
        deleteProcessDefForever: function (rowId) {
            if (!rowId) {
                modals.info('<spring:message code="common.promt.delete" />');
                return false;
            }
            modals.confirm("<spring:message code='workflow.procdef.del.forver.confirm' />", function () {
                ajaxPost(basePath + "/workflow/processdef/delete/1/" + rowId, null, function (data) {
                	 if (data.code == 200) {
                     	modals.correct(data.message);
                     	processdefTable.reloadRowData();
                     } else {
                         modals.warn(data.message);
                     }
                });
            })
        },
        showFlow: function (rowId) {
            var rowData = processdefTable.getRowDataByRowId(rowId);
            var title = "【" + rowData.name + "】xml&image";
            modals.openWin({
                winId: "flowWin",
                width: "900px",
                url: basePath + "/workflow/processdef/show/" + rowId,
                title: title
            });
        },
        exportXml: function (rowId) {
            window.open(basePath + "/workflow/processdef/export/xml/" + rowId);
        },
        exportImage: function (rowId) {
            window.open(basePath + "/workflow/processdef/export/image/" + rowId);
        }
    }

    var config={
    		language : {
				url: basePath+'<spring:message code="common.language"/>'
			}
    };
    
    //方法入口
    $(function () {
        processdefTable = new CommonTable("processdef_table", "processdef_list", "procdefSearchDiv", "/workflow/processdef/findList",config);
        //绑定按钮事件
        $("button[data-btn-type]").click(function () {
            var action = $(this).data("btn-type");
            var rowId = processdefTable.getSelectedRowId();
            switch (action) {
                case 'delete':
                    processDefObj.deleteProcessDef(rowId);
                    break;
                case 'deleteForever':
                    processDefObj.deleteProcessDefForever(rowId);
                    break;
                default:
                    break;
            }
        })
    })


    function fnRenderOperator(value, type, rowObj) {
        var oper = "";
        oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='processDefObj.showFlow(\"" + value + "\")'><spring:message code='sys.role.view' /></a>";
        oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='processDefObj.exportXml(\"" + value + "\")'>xml</a>";
        oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='processDefObj.exportImage(\"" + value + "\")'>png</a>";
        return oper;
    }
    
    function processdefOperator(value, type, rowObj){
    	var oper = "";
    	 if(value == '1'){
 			oper += "<spring:message code='workflow.procdef.activate' />";
 		}else{
 			oper += "<spring:message code='workflow.procdef.handup' />";
 		}
         return oper;
    }
</script>