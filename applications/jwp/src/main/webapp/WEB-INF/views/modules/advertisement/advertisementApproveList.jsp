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
                <div id="advertisementSearchDiv" class="dataTables_filter" role="form" style="text-align: left;">
                
                  <div class="form-group dataTables_filter " style="margin: 1em;">
                   	 <input class="form-control" id="adName" type="text"  style="height:37px;margin-left:0px;width: 226.5px;"
                                name="adName" placeholder='<spring:message code="sys.advertisement.adName"/>' />
                     <input class="form-control" id="adTitle" type="text" style="height:37px;margin-left:0px;width: 226.5px;"
                                name="adTitle" placeholder='<spring:message code="sys.advertisement.adTitle"/>' />
                     <button type="button" class="btn btn-primary" style="height:37px"
                                data-btn-type="search"><spring:message code="common.query"/></button>
                     <button type="button" class="btn btn-default" style="height:37px"
                                data-btn-type="reset"><spring:message code="common.reset"/></button>
                     <button type="button" class="btn btn-primary" style="height:37px"
		                         data-btn-type="advertisementDetail"><spring:message code="audit"/></button> 
                  </div>
                </div>
                    <div class="box-body" style="padding 0px 10px 10px 10px">
                        <table id="advertisement_table"
                            class="table table-bordered table-bg table-striped table-hover" style="margin-top:0px !important;">
                        </table>
                    </div>
                </div>
            </div>
        </div>
</section>

<script>
    //tableId,queryId,conditionContainer
    
    var advertisementform = $("#advertisementSearchDiv").form({baseEntity: false});
    advertisementform.initComponent();
    
    var advertisementTable;
    var winId = "advertisementWin";
    $(function() {
    	$("#advertisementSearchDiv").bootstrapValidator({
            message : '<spring:message code="common.promt.value"/>',
            feedbackIcons : {
                valid : 'glyphicon glyphicon-ok',
                invalid : 'glyphicon glyphicon-remove',
                validating : 'glyphicon glyphicon-refresh'
            },
            fields : {
            	/* adStartTime1 : {
                    validators : {
                        date : {  
                            format : 'YYYY-MM-DD',  
                            message : '<spring:message code="sys.log.tip.tiemFromatIncorrect"/>'  
                        },
                        callback: {
                            message: '<spring:message code="sys.log.tip.beginTimeTooBig"/>',
                            callback:function(value, validator,$field,options){
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
                                    return parseInt(value)>=parseInt(begin);    
                                }
                                    
                            }
                        }
                    }
                }  */
            }
        }).on('success.form.fv', function(e) {
            e.preventDefault();
        });
        //查询框是否在一行设置
        var config={
            resizeSearchDiv:false,
            language : {
                url: basePath+'<spring:message code="common.language"/>'
            },
            scrollX:true,
        };
        //init table and fill data
        advertisementTable = new CommonTable("advertisement_table", "advertisement_list", "advertisementSearchDiv",
                "/advertisement/approveList",config);

        //button event
        $('button[data-btn-type]')
                .click(
                        function() {
                            var action = $(this).attr('data-btn-type');                     
                            var advertisementRowId = advertisementTable.getSelectedRowId();                       
                            switch (action) {
                            case 'advertisementDetail':
                                if (!advertisementRowId) {
                                    modals.info('<spring:message code="please.select.audit.row"/>');
                                    return false;
                                }
                                modals.openWin({
                                    winId : winId,
                                    title : '<spring:message code="sys.advertisement.details" />',
                                    width : '900px',
                                    url : basePath + "/advertisement/advertisementApproveForm?id=" + advertisementRowId
                                });
                            }
                        });
        //form_init();
       
        function resetAdvertisementForm(){
        	advertisementform.clearForm();
            $("#advertisement-form").data('bootstrapValidator').resetForm();
        }
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
            oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='advertisementProcessDef.advertisementDetail(\""
                    + id + "\")'>" + '<spring:message code="audit" />' + "</a>";
            return oper;
        }
        
        var advertisementProcessDef = {
        		advertisementDetail : function(id) {
                    modals.openWin({
                        winId : winId,
                        title : '<spring:message code="sys.advertisement.details" />',
                        width : '900px',
                        url : basePath + "/advertisement/advertisementApproveForm?id=" + id
                    });
                }
            }
</script>
