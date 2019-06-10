<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
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
							class="form-control" type="search" title='<spring:message code="ota.table.application.name"/>' /> 
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
               	<!-- /.box-header -->
				<div class="dataTables_filter" id="appVersionSearchDiv">
					<div class="btn-group">
						<input type="hidden" name="appName" id="appNameL" /> 
						<input type="hidden" name="appPackage" id="appPackage" />
						<input type="hidden" name="clientIdentification" id="clientIdentification" />
						 <div class="btn-group" >
				    	<label ><span style="color:red;font-weight: bold;">*</span></label>
						<select name="releaseType" id="releaseType" data-placeholder='<spring:message code="app.release.please.select.the.release.type"/>' class="form-control select2" style="width: 170px">
						   <option value=""></option>
						   <option value="1"><spring:message code="app.release.release.by.device.type"/></option>
						   <option value="2"><spring:message code="app.release.release.by.device.sn"/></option>
						</select>
						</div>
						
						<input placeholder='<spring:message code="app.version.application.version.number"/>' name="appVersion" id="appVersion" class="form-control"
							type="search" title='<spring:message code="app.version.application.version.number"/>' /> &nbsp;&nbsp;
					</div>
					<div class="btn-group">
						<button type="button" class="btn btn-primary"
							data-btn-type="search"><spring:message code="common.query"/></button>
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
        var config={
			singleSelect:null,
			pagingType:'simple'
		};  
		  var appInfo_config = {
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
            pagingType:"simple"
        }
		 
		
		appInfoTable = new CommonTable("appInfo_table", "appInfo_version_list", "appInfoSearchDiv",
				"/appInfo/list",appInfo_config);
		  
         //init table and fill data
		appVersionTable = new CommonTable("appVersion_table", "release_appVersion_list", "appVersionSearchDiv",
				"/appVersion/list",config);
         
		   //默认选中第一行
        setTimeout(function() {
        	appInfoTable.selectFirstRow(true);
        }, 30);
	})
	
	function operationAppLogo(appLogo,type, rowObj){
		var oper = "";
		if(appLogo==null || appLogo == ''){
			oper += "<div class='textavatar' style='width: 40px;' data-name='"+rowObj.appName+"'></div>"
		}else{
			oper += "<div class='appimg'> <img src='"+ rowObj.appLogo + "' class='appimg-circle' /></div>";
		}
		return oper;
	}
	
	//获取发布标题
	function getReleaseTypeTitle(appVersion, appName, type) {
		var releaseType = $("#releaseType").val();
		var	title = '<spring:message code="app.release.application"/>  ' + (releaseType == 1) 
					? '<spring:message code="app.release.release.by.device.type"/>' 
					: '<spring:message code="app.release.release.by.device.sn"/>' 
					+ (type == 0?'<spring:message code="app.release.active"/>':'<spring:message code="app.release.passtive"/>') 
					+ '<spring:message code="app.release.release"/>' + '-【'+appName+'】-【'+appVersion+'】';	
		return title;
	}
	
	var merchantProcessDef={
			activeReleaseVersion:function(rowId, appVersion, appName) {
				//type: 0 被动 1 主动 
				var type = '${type}';
				//发布方式类型 1：按'按设备类型'发布 2：按按设备SN发布
				var releaseType = $("#releaseType").val();
				if (releaseType == 0 || releaseType == '' || releaseType == null) {
					modals.warn('<spring:message code="app.release.please.select.the.release.type"/>!');
					return;
				} 
				var title = getReleaseTypeTitle(appVersion, appName, type);
				modals.openWin({
					winId : winId,
					title : title,
					width : '1150px',
					url : basePath + "/appVersion/noReleaseDevices?id="+rowId+"&releaseType=" + releaseType+"&type=" + type
				});
			}
		}
		
		function releaseOperation(id, type, rowObj){
		    var oper = "";
			oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='merchantProcessDef.activeReleaseVersion(\"" + id +"\", \"" + rowObj.appVersion +"\", \"" + rowObj.appName +"\")'><spring:message code='app.release.release'/></a>";
	        return oper;
		}
	
	   function formatFileUrl(url) {
		    if (url == null || url == '') return '';
		    var fileds = url.split("/");
		    if (fileds.length == 1){
		    	fileds = url.split("\\");
	   		}
        	return fileds[fileds.length - 1];
		}

	   function operationClientId(clientIdentification){
			if (clientIdentification == null || clientIdentification == ''){
				return '<spring:message code="app.appinfo.currency"/>';
			}
			return clientIdentification;
		}
</script>


