<%@ page contentType="text/html;charset=UTF-8"%>

<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<!-- Main content -->
<section class="content">
    <div class="row">
        <div class="col-xs-12">
            <div class="box">
             <div id="selectSearchDiv" class="form-horizontal" role="form">
                    <div class="form-group dataTables_filter " style="margin: 1em;">
                    <%--    <button type="button" class="btn btn-default" data-btn-type="edit"><spring:message code="sys.selectTable.BatchCreate"/></button>  --%>
                       <button type="button" class="btn btn-default" data-btn-type="edit"><spring:message code="sys.selectTable.EditFile"/></button> 
                    </div>
                </div>
                <div class="dataTables_filter">
                    <div style="text-align: right;">
                    </div>
                </div>       
                <div class="box-body" style="padding-top: 0px;">
                    <table id="selectTable_table"
                        class="table table-bordered table-striped table-hover">
                    </table>
                </div>
                <!-- /.box-body -->
            </div>
        </div>
        <!-- /.col -->
    </div>
    <!-- /.row -->
</section>

<script>
var form = $("#selectSearchDiv").form({baseEntity: false});
form.initComponent();
    //tableId,queryId,conditionContainer
    var selectTable;
    var winId = "dictWin";
    $(function() {
        //init table and fill data
          var config = {
            resizeSearchDiv:false,
            language : {
                url: basePath+'<spring:message code="common.language"/>'
            }
        };
          selectTable = new CommonTable("selectTable_table", "selectTable", "selectSearchDiv", "/generator/list", config);
      
    });
  //初始化加载列表名称
	 $('button[data-btn-type]').click(function() {
       var action = $(this).attr('data-btn-type');
       switch (action) {
           case 'edit':
        	   modals.openWin({
					winId : winId,
					title : '<spring:message code="sys.user.add"/>',
					width : '900px',
					url : basePath + "/generator/edit"
				});
                   break;
       }

   });
    function fnRenderOperator(value, type, rowObj) {
    	
        //流程定义
        var oper = "<a href='javascript:void(0)' onclick='defineFlow(\"" + rowObj.tableName + "\")'><spring:message code="sys.selectTable.GeneratorCode"/></a>";
        return oper;
    }
    function defineFlow(value){
    	
    	location.href = basePath + "/generator/code/" + value;
    	
    }
    </script>
