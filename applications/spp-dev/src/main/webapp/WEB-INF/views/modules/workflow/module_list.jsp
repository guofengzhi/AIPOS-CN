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
                <div>&nbsp;</div>
                <div class="dataTables_filter" id="moduleSearchDiv">
                   <!--查询条件-->
                   <div class="btn-group">
                       <input placeholder='<spring:message code="workflow.module.name"/>' name="name"
							class="form-control" type="search" title='<spring:message code="workflow.module.name"/>' /> <input
							placeholder='<spring:message code="workflow.module.code"/>' name="code" class="form-control"
							type="search" title='<spring:message code="workflow.module.code"/>' /> &nbsp;&nbsp;
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
                    <table id="module_table" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    var moduleTable, winId = "moduleWin";
    var config={
    		language : {
				url: basePath+'<spring:message code="common.language"/>'
			}
    };
    $(function (){
        moduleTable = new CommonTable("module_table", "module_list", "moduleSearchDiv", "/workflow/module/findList",config);
        //绑定按钮事件
        $("button[data-btn-type]").click(function () {
            var action = $(this).data("btn-type");
            var rowId = moduleTable.getSelectedRowId();
            switch (action) {
                case "add":
                    modals.openWin({
                        winId: winId,
                        title: '<spring:message code="workflow.add.module" />',
                        width: "800px",
                        url: basePath + "/workflow/module/edit"
                    })
                    break;
                case "edit":
                    if (!rowId) {
                        modals.info('<spring:message code="common.promt.edit" />');
                        return false;
                    }
                    modals.openWin({
                        winId: winId,
                        title: '<spring:message code="workflow.edit.module" />【' + moduleTable.getSelectedRowData().name + '】',
                        width: '800px',
                        url: basePath + "/workflow/module/edit?id=" + rowId
                    });
                    break;
                case 'delete':
                    if (!rowId) {
                        modals.info('<spring:message code="common.promt.delete" />');
                        return false;
                    }
                    modals.confirm("<spring:message code='common.confirm.delete' />", function () {
                        ajaxPost(basePath + "/workflow/module/delete/" + rowId, null, function (data) {
                            if (data.code == 200) {
                            	modals.correct(data.message);
                                moduleTable.reloadRowData();
                            } else {
                                modals.warn(data.message);
                            }
                        });
                    })
                    break;
            }
        })
    })
    
    function moduleOperator(value, type, rowObj) {
        var oper = "";
        if(value == '1'){
			oper += "<span>"+'<spring:message code="common.forbidden"/>'+"</span>";
		}else{
			oper += "<span>"+'<spring:message code="common.start.using"/>'+"</span>";
		}
        return oper;
    }
</script>