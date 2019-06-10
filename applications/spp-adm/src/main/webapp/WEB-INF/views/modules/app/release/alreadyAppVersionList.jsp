<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>

<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i> <spring:message code="common.homepage"/></a></li>
		<li><a href="#"> <spring:message code="app.release.published.application.version.management"/></a></li>
		<li class="active"><spring:message code="app.release.published.application.version.list"/></li>
	</ol>
	<div class="col-xs-12"></div>
</section>

<!-- Main content -->
<section class="content">

    <div class="row">
        <!-- /.col -->
        <div class="col-md-5">
            <div class="box box-primary">
               <!-- /.box-header -->
				<div class="dataTables_filter" id="appInfoSearchDiv">
					<div class="btn-group">
						
						<input placeholder='<spring:message code="ota.table.application.name"/>' name="appName"
							class="form-control" type="search" title='<spring:message code="app.appinfo.please.enter.the.application.name"/>' /> 
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
                    <table id="appInfo_table" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
                <!-- /.box-body -->
            </div>
        </div>
        <div class="col-md-7">
            <!-- Profile Image -->
            <div class="box box-primary">
				<div class="dataTables_filter" id="appVersionSearchDiv">
					<div class="btn-group">
						<input type="hidden" name="appName" id="appNameL" /> 
						<input type="hidden" name="appPackage" id="appPackage" />
						<input type="hidden" name="clientIdentification" id="clientIdentification" />
						<input placeholder='<spring:message code="app.version.application.version.number"/>' name="appVersion" id="appVersion" class="form-control"
							type="search" title='<spring:message code="app.version.application.version.number"/>' /> &nbsp;&nbsp;
					</div>
					<div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search"><spring:message code="common.query"/></button>
						<button type="button" class="btn btn-default"
							data-btn-type="reset"><spring:message code="common.reset"/></button>
					</div>
				</div>
                <div class="box-body">
                    <table id="appVersion_table" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
                <!-- /.box-body -->
            </div>
            <!-- /.box -->
        </div>
    </div>
    <!-- /.row -->

</section>

<script>
var form = $("#appInfoSearchDiv").form({baseEntity: false});
    form.initComponent();
	//tableId,queryId,conditionContainer
	var appInfoTable, appVersionTable;
	var winId = "appInfoWin";
	$(function() {
		
		  //init table and fill data
        var role_config = {
            rowClick: function(row, isSelected) {
                $("#roleId").val(isSelected ? row.id : "-1");
                $("#appNameId").remove();
                $("#appPackage").val(row.appPackage);
                $("#appNameL").val(row.appName);
                $("#clientIdentification").val(row.clientIdentification);
                if (isSelected)
                    $("#appVersionSearchDiv").prepend("<h5 id='appNameId' class='pull-left'>【" + row.appName + "】</h5>");
                appVersionTable.reloadData();
            },
            pagingType:'simple'
        }
        var config={
        	singleSelect:null,
        	lengthChange:false,
			pagingType:'simple'
        };  
		
		appInfoTable = new CommonTable("appInfo_table", "appInfo_version_list", "appInfoSearchDiv",
				"/appInfo/list",role_config);
		  
         //init table and fill data
		appVersionTable = new CommonTable("appVersion_table", "release_appVersion_list", "appVersionSearchDiv",
				"/appVersion/list",config);
         
		   //默认选中第一行
        setTimeout(function() {
        	appInfoTable.selectFirstRow(true);
        }, 30);
	})

	
	function formatFileUrl(url){
		if (url == null || url == '') return '';
		var fileds = url.split("/");
	    if (fileds.length == 1 && url.indexOf("/") == -1){
	    	fileds = url.split("\\");
	    }
        return fileds[fileds.length - 1];
	}
	
	function operationAppLogo(appLogo,type, rowObj){
		var oper = "";
		if(appLogo==null || appLogo == ''){
			oper += "<div class='textavatar' style='width: 40px;' data-name='"+rowObj.appName+"'></div>"
		}else{
			oper += "<div class='appimg'> <img src='"+ rowObj.appLogo + "' class='appimg-circle' /></div>";
		}
		return oper;
	}
	
	
	var merchantProcessDef={
			
			alreadyReleaseVersion:function(rowId, appVersion, appName){
					var title = '<spring:message code="app.release.application.equipment.that.has.been.released"/>' + '-【'+appName+'】-【'+appVersion+'】';					
					modals.openWin({
						winId : winId,
						title : title,
						width : '900px',
						url : basePath + "/appVersion/alreadyReleaseDeviceList?id="+rowId
					});
					
				}
		}
		
		function releaseOperation(id, type, rowObj){
		    var oper = "";
			oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='merchantProcessDef.alreadyReleaseVersion(\"" + id +"\", \"" + rowObj.appVersion +"\", \"" + rowObj.appName +"\")'><spring:message code='app.release.published'/></a>";
	        return oper;
		}
	
		function operationClientId(clientIdentification){
			if (clientIdentification == null || clientIdentification == ''){
				return '<spring:message code="app.appinfo.currency"/>';
			}
			return clientIdentification;
		}

</script>

