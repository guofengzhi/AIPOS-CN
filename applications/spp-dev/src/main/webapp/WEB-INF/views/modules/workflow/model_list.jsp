<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>

<section class="content">
    <div class="row">
        <div class="col-xs-12">
            <div class="box">
                <div>&nbsp;</div>
                <div class="dataTables_filter" id="modelSearchDiv">
                    <!--查询条件-->
                    <div class="btn-group">
                    <input type="search" placeholder="<spring:message code='workflow.model.print.name'/>" title="<spring:message code='workflow.model.serch.name'/>" name="name"
                           class="form-control" id="name" operator="like" likeOption="true" />&nbsp;&nbsp;
                    </div>
                   <div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search"><spring:message code="common.query"/></button>
						&nbsp;&nbsp;
						<button type="button" class="btn btn-default"
							data-btn-type="reset"><spring:message code="common.reset"/></button>
					</div>
                    <shiro:hasPermission name="workflow:define:edit">
						<div class="btn-group">
							<button type="button" class="btn btn-default" data-btn-type="add"><spring:message code="common.add"/></button>
							&nbsp;&nbsp;
							<button type="button" class="btn btn-default"
								data-btn-type="edit"><spring:message code="common.edit"/></button>
							&nbsp;&nbsp;
							<button type="button" class="btn btn-default"
								data-btn-type="delete"><spring:message code="common.delete"/></button>
						</div>
					</shiro:hasPermission>
                </div>
                <div class="box-body">
                    <table id="model_table" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div id="msgcontainer">

    </div>
</section>

<script>
    var modelTable, winId = "modelWin";

    var modelObj = {
        addModel: function () {
            modals.openWin({
                winId: winId,
                title: '<spring:message code="workflow.add.model"/>',
                width: '800px',
                url: basePath + "/workflow/model/edit"
            });
        },
        editModel: function (rowId) {
            if (!rowId) {
                modals.info('<spring:message code="common.promt.edit" />');
                return false;
            }
            modals.openWin({
                winId: winId,
                title: '<spring:message code="workflow.edit.model" />' + modelTable.getSelectedRowData().name + '<spring:message code="workflow.edito.model" />',
                width: '800px',
                url: basePath + "/workflow/model/edit/?id=" + rowId
            });
        },
        deleteModel: function (rowId) {
        	if (!rowId) {
                modals.info('<spring:message code="common.promt.delete" />');
                return false;
            }
            modals.confirm("<spring:message code='common.confirm.delete' />", function () {
                ajaxPost(basePath + "/workflow/model/delete/" + rowId, null, function (data) {
                    if (data.code == 200) {
                    	modals.correct(data.message);
                    	modelTable.reloadRowData();
                    } else {
                        modals.warn(data.message);
                    }
                });
            })
        },
        defineFlow: function (rowId) {
            window.open(basePath + "/workflow/modeler/" + rowId);
        },
        copyFlow:function (rowId) {
            ajaxPost(basePath+"/workflow/model/copy/"+rowId,null,function (data) {
                if(data.code == 200){
                	modelTable.reloadRowData();
                    modals.correct("<spring:message code='workflow.model.copyflow' />");
                }
            })
        },
        deployFlow: function (rowId) {
            var rowData = modelTable.getRowDataByRowId(rowId);
            if (!rowData.editorSourceExtraValueId) {
                modals.info("<spring:message code='workflow.model.deploy' />");
                return;
            }
            var msg = rowData.deploymentId ? "<spring:message code='workflow.model.deploy.again' />" : "<spring:message code='workflow.model.deploy.sure' />";
            modals.confirm(msg, function () {
                ajaxPost(basePath + "/workflow/model/deploy/" + rowId, null, function (data) {
                    if (data.code == 200) {
                        modals.correct("<spring:message code='workflow.model.deploy.success' />");
                        modelTable.reloadRowData(rowId);
                    } else {
                        modals.error(data.message);
                    }
                })
            })
        },
        showFlow: function (rowId) {
            ajaxPost(basePath + "/workflow/model/exist/xml/" + rowId, null, function (data) {
                if (data.code == 200) {
                    var rowData = modelTable.getRowDataByRowId(rowId);
                    var title = "【" + rowData.name + "】xml&image";
                    modals.openWin({
                        winId: "flowWin",
                        width: "900px",
                        url: basePath + "/workflow/model/show/" + rowId,
                        title: title
                    });
                } else {
                    modals.error("<spring:message code='workflow.model.showflow.msg' />");
                }
            })
        },
        exportXml: function (rowId) {
            ajaxPost(basePath + "/workflow/model/exist/xml/" + rowId, null, function (data) {
                if (data.code == 200) {
                	window.open(basePath + "/workflow/model/export/xml/" + rowId);
                } else {
                    modals.error("<spring:message code='workflow.model.exportxml.msg' />");
                }
            })
        },
        exportImage: function (rowId) {
            ajaxPost(basePath + "/workflow/model/exist/xml/" + rowId, null, function (data) {
                if (data.code == 200) {
                    window.open(basePath + "/workflow/model/export/image/" + rowId);
                } else {
                    modals.error("<spring:message code='workflow.model.exportimage.msg' />");
                }
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
        modelTable = new CommonTable("model_table", "model_list", "modelSearchDiv", "/workflow/model/findList",config);
        //绑定按钮事件
        $("button[data-btn-type]").click(function () {
            var action = $(this).data("btn-type");
            var rowId = modelTable.getSelectedRowId();
            switch (action) {
                case "add":
                    modelObj.addModel();
                    break;
                case "edit":
                    modelObj.editModel(rowId);
                    break;
                case 'delete':
                    modelObj.deleteModel(rowId);
                    break;
            }
        })
    })


    function fnRenderOperator(value, type, rowObj) {
        //流程定义
        var oper = "<a href='javascript:void(0)' onclick='modelObj.defineFlow(\"" + value + "\")'>建模</a>";
        oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='modelObj.copyFlow(\"" + value + "\")'>复制</a>";
        //部署
        if (rowObj.editorSourceExtraValueId) {
            oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='modelObj.deployFlow(\"" + value + "\")'>部署</a>";
            oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='modelObj.showFlow(\"" + value + "\")'>查看</a>";
            oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='modelObj.exportXml(\"" + value + "\")'>xml</a>";
            oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='modelObj.exportImage(\"" + value + "\")'>png</a>";
        } else {
            oper += "&nbsp;&nbsp;&nbsp;<span title='请先配置流程定义'>部署</span>";
            oper += "&nbsp;&nbsp;&nbsp;<span title='请先配置流程定义'>查看</span>";
            oper += "&nbsp;&nbsp;&nbsp;<span title='请先配置流程定义'>xml</span>";
            oper += "&nbsp;&nbsp;&nbsp;<span title='请先配置流程定义'>png</span>";
        }
        return oper;
    }
</script>