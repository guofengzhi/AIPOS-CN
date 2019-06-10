<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<section class="content-header">
    <ol class="breadcrumb">
        <li><a href="${basePath}"><i class="fa fa-dashboard"></i><spring:message code="common.homepage"/></a></li>
        <li><a href="#"><spring:message code="common.sys.advertisement"/></a></li>
        <li class="active"><spring:message code="sys.advertisement.management"/></li>
    </ol>
    <div class="col-sm-12"></div>
</section>

<!-- Main content -->
<section class="content">
    <div class="row">
        <div class="col-xs-12">
            <div class="box">
                <div id="advertisementSearchDiv" class="dataTables_filter" style="text-align: left;" role="form">
                        <div class="has-feedback form-group">
                            <input class="form-control" id="adName"  style="margin-left:0px;width: 226.5px;" type="text"  maxlength="50"
                                name="adName" placeholder='<spring:message code="sys.advertisement.adName"/>' />
                        </div> 
                       <div class="has-feedback form-group">
                            <input class="form-control" id="adTitle"  style="margin-left:0px;width: 226.5px;" type="text"  maxlength="50"
                                name="adTitle" placeholder='<spring:message code="sys.advertisement.adTitle"/>' />
                        </div>   
                       <div class="has-feedback form-group">
                                <input class="form-control" id="adStartTime1"  style="margin-left:0px;width: 226.5px;"
                                    type="text" name="adStartTime1" placeholder='<spring:message code="sys.advertisement.adStartTime"/>' onkeypress="notPut(event);"
                                    data-flag="datepicker" />
                        </div> 
                      <div class="has-feedback form-group">
                                <input class="form-control" id="adEndTime1" type="text"  style="margin-left:0px;width: 226.5px;" onkeypress="notPut(event);"
                                    name="adEndTime1" placeholder='<spring:message code="sys.advertisement.adEndTime"/>' data-flag="datepicker" />

                        </div> 
                        <div class="btn-group">
                        	<button type="button" class="btn btn-primary"
                                data-btn-type="search"><spring:message code="common.query"/></button>
                            <button type="button" class="btn btn-default"
                                data-btn-type="reset"><spring:message code="common.reset"/></button>
                        </div>
                    	<div style="width:100%;margin-top:5px;">
                    	<div class="has-feedback form-group"><p style="margin-left:0px;width: 226.5px;"></p></div>
                    	<div class="has-feedback form-group"><p style="margin-left:0px;width: 226.5px;"></p></div>
                    	<div class="has-feedback form-group"><p id="startP" style="margin-left:0px;width:226.5px;"></p></div>
                    	<div class="has-feedback form-group"><p id="endP" style="margin-left:0px;width: 226.5px;"></p></div>
                    		<shiro:hasPermission name="sys:advertisement:edit">
								<button type="button" class="btn btn-default"  data-btn-type="advertisementDelete" title='<spring:message code="common.delete"/>' style="float:right;">
									<i class="fa fa-remove"></i>
								</button>
								<button data-btn-type="advertisementEdit" class="btn btn-default"  title='<spring:message code="common.edit"/>' type="button" style="float:right;">
									<i class="fa fa-edit"></i>
								</button>
								<button data-btn-type="advertisementAdd" class="btn btn-default"  title='<spring:message code="common.add"/>' type="button" style="float:right;">
									<i class="fa fa-plus"></i>
								</button>
                   	 	</shiro:hasPermission>
                    	</div>
                </div>
               
                    <div class="box-body">
                        <table id="advertisement_table"
                            class="table table-bordered table-bg table-striped table-hover" style="margin-top:0px !important;">
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
//禁止日期选择框树洞输入
function notPut(even){
	var ev = window.event||even;
	if(isIE()){
		ev.returnValue=false;
	}else{
		ev.preventDefault();
	}
}
function isIE(){
	if(window.navigator.userAgent.toLowerCase().indexOf("mise")>=1)
		return true;
	else
		return false;
}
    //tableId,queryId,conditionContainer

    var advertisementform = $("#advertisementSearchDiv").form({baseEntity: false});
    advertisementform.initComponent();
    
    var advertisementTable;
    var winId = "advertisementWin";
    $(function() {
    	$("#advertisementSearchDiv").bootstrapValidator({
            message : '<spring:message code="common.promt.value"/>',
            feedbackIcons : {
                //valid : 'glyphicon glyphicon-ok',
                //invalid : 'glyphicon glyphicon-remove',
                validating : 'glyphicon glyphicon-refresh'
            },
            fields : {
            	adStartTime1 : {
            		container: '#startP',
                    validators : {
                        date : { 
                            format : 'YYYY-MM-DD',  
                            message : '<spring:message code="sys.log.tip.tiemFromatIncorrect"/>'
                        },
                        callback: {
                            message: '<spring:message code="sys.log.tip.beginTimeTooBig"/>',
                            callback:function(value, validator,$field,options){
                            	$("small").prop("hidden","hidden");
                                var end = $("input[name='adEndTime1']").val();
                                if(value == "" && end == ""){
                                    return true;
                                }else {
                                    value = new Date(value).getTime();
                                    end = new Date(end).getTime();
                                    return parseInt(value)<=parseInt(end);
                                }
                                
                            }
                        }
                    }
                },              
                adEndTime1 : {
                	container: '#endP',
                    validators : {
                        date : {  
                            format : 'YYYY-MM-DD',  
                            message : '<spring:message code="sys.log.tip.tiemFromatIncorrect"/>' 
                        } ,
                        callback: {
                            message: '<spring:message code="sys.log.tip.endTimeTooSmall"/>',
                            callback:function(value, validator,$field){
                                var begin = $("input[name='adStartTime1']").val();
                                $("input[name='adStartTime1']").keypress();
                                if(value == "" && begin==""){
                                    return true;
                                }else{
                                    value = new Date(value).getTime();
                                    begin = new Date(begin).getTime();
                                    validator.updateStatus('adStartTime1', 'VALID');
                                    errorDiv = "endP";
                                    return parseInt(value)>=parseInt(begin);    
                                }
                                    
                            }
                        }
                    }
                } 
            }
        }).on('success.form.fv', function(e) {
            e.preventDefault();
        });
        //查询框是否在一行设置
        var config={
            resizeSearchDiv:false,
            language : {
                url: basePath+'<spring:message code="common.language"/>'
            }
            //scrollX:true,
        };
        //init table and fill data
        advertisementTable = new CommonTable("advertisement_table", "advertisement_list", "advertisementSearchDiv",
                "/advertisement/list",config);

        //button event
        $('button[data-btn-type]')
                .click(
                        function() {
                            var action = $(this).attr('data-btn-type');                     
                            var advertisementRowId = advertisementTable.getSelectedRowId();                       
                            switch (action) {
                            case 'advertisementAdd':
                                modals.openWin({
                                    winId : winId,
                                    title : '<spring:message code="sys.advertisement.add"/>',
                                    width : '900px',
                                    url : basePath + "/advertisement/form"
                                });
                                break;
                            case 'advertisementEdit':
                                if (!advertisementRowId) {
                                    modals.info('<spring:message code="common.promt.edit"/>');
                                    return false;
                                }
                                modals
                                        .openWin({
                                            winId : winId,
                                            title : '<spring:message code="sys.advertisement.edit"/>【'
                                                    + advertisementTable
                                                            .getSelectedRowData().adName
                                                    + '】',
                                            width : '900px',
                                            url : basePath
                                                    + "/advertisement/form?id="
                                                    + advertisementRowId
                                        });
                                break;
                            case 'advertisementDelete':
                                if (!advertisementRowId) {
                                    modals.info('<spring:message code="common.promt.delete"/>');
                                    return false;
                                }
                                modals.confirm({
                                    cancel_label:"<spring:message code="common.cancel" />",
                                    title:"<spring:message code="common.sys.confirmTip" />",
                                    ok_label:"<spring:message code="common.confirm" />",
                                    text:"<spring:message code="common.confirm.delete" />",
                                    callback: function() {
                                    ajaxPost(basePath + "/advertisement/delete?id="
                                            + advertisementRowId, null, function(data) {
                                        if (data.code == 200) {
                                            modals.correct({
                                                title:'<spring:message code="common.sys.success" />',
                                                cancel_label:'<spring:message code="common.confirm" />',
                                                text:data.message});
                                            advertisementTable.reloadRowData();
                                        } else {
                                            modals.warn(date.message);
                                        }
                                    });
                                }})
                               
                            }

                        });
        //form_init();
       
        function resetAdvertisementForm(){
        	advertisementform.clearForm();
            $("#advertisement-form").data('bootstrapValidator').resetForm();
        }
        
        var currDate = new Date();
    	currDate.setMonth(currDate.getMonth()-1);
        var y = currDate.getFullYear();
        var m = currDate.getMonth()+1;
        var currM = currDate.getMonth()+2;
        var d = currDate.getDate();
        var formatwdate = y+'-'+(m.toString().length==2?m:'0'+m)+'-'+(d.toString().length==2?d:'0'+d);
        var formatwdate1 = y+'-'+(currM.toString().length==2?currM:'0'+currM)+'-'+(d.toString().length==2?d:'0'+d);
        //$('#adStartTime1').val(formatwdate); 
        //$('#adEndTime1').val(formatwdate1); 
    })
    
     function operationadStatus(adStatus) {
            var oper = "";
            if (adStatus == '1') {
                oper += "<span class='label label-success'>" + '<spring:message code="effective" />' + "</span>";
            }  else {
                oper += "<span class='label label-danger'>" + '<spring:message code="invalid" />' + "</span>";
            } 
            
            return oper;
        };
        
        function operationapprovalStatus(approvalStatus){
        	var oper = "";
            if (approvalStatus == '3') {
                oper += "<span class='label label-success'>" + '<spring:message code="approved" />' + "</span>";
            } else if (approvalStatus == '1') {
                oper += "<span class='label label-danger'>" + '<spring:message code="create" />' + "</span>";
            } else if (approvalStatus == '2') {
                oper += "<span class='label label-danger'>" + '<spring:message code="release" />' + "</span>";
            } else if (approvalStatus == '4') {
                oper += "<span class='label label-danger'>" + '<spring:message code="audit.refused.to" />' + "</span>";
            } else if (approvalStatus == '0') {
                oper += "<span class='label label-danger'>" + '<spring:message code="in.the.review" />' + "</span>";
            }
            return oper;
        }
    
    function operation(id, type, rowObj) {
    	
        var oper = "&nbsp;&nbsp;&nbsp;";
        oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='advertisementProcessDef.deleteAdvertisement(\""
                + id
                + "\")'>"
                + '<spring:message code="common.delete"/>'
                + "</a>";
               if(rowObj.approvalStatus == '4'  || rowObj.approvalStatus == '3' ){
            	   oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='advertisementProcessDef.editAdvertisement(\""
                       + id
                       + "\")'>"
                       + '<spring:message code="common.edit"/>'
                       + "</a>";
               }
        return oper;
    }
        var advertisementProcessDef = {
                addAdvertisement : function() {
                    modals
                            .openWin({
                                winId : winId,
                                title : '<spring:message code="app.appinfo.new.application.information" />',
                                width : '900px',
                                url : basePath + "/advertisement/form/add"
                            });
                },
                editAdvertisement : function(id) {
                    modals.openWin({
                    	winId : winId,
                    	title : '<spring:message code="sys.advertisement.edit"/>',
                        width : '900px',
                        url : basePath + "/advertisement/form?id=" + id
                    });
                },
                deleteAdvertisement : function(id) {
                    modals
                            .confirm(
                                    '<spring:message code="sys.sure.advertisement.delete" />',
                                    function() {
                                        var params = {};
                                        params["id"] = id;
                                        ajaxPost(
                                                basePath + "/advertisement/delete",
                                                params,
                                                function(data) {

                                                    if (data.code == 200) {
                                                        modals
                                                                .correct('<spring:message code="app.appinfo.the.data.has.been.deleted" />');
                                                        advertisementTable.reloadRowData();
                                                    } else {
                                                        modals.error(data.message);
                                                    }
                                                });
                                    })
                }
            }
</script>
