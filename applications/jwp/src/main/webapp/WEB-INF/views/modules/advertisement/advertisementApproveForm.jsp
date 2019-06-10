<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="sys.advertisement.adName" var="adNameForm"/>
<spring:message code="sys.advertisement.adDesc" var="adDescForm"/>
<spring:message code="sys.advertisement.adType" var="adTypeForm"/>
<spring:message code="sys.advertisement.adContent" var="adContentForm"/>
<spring:message code="sys.advertisement.adAttribution" var="adAttributionForm"/>
<spring:message code="sys.advertisement.adTitle" var="adTitleForm"/>
<spring:message code="sys.advertisement.adImg" var="adImgForm"/>
<spring:message code="common.form.select" var="formSelect"/>
<spring:message code="sys.advertisement.adStartTime" var="adStartTime"/>
<spring:message code="sys.advertisement.adEndTime" var="adEndTime"/>
<style>
.krajee-default.file-preview-frame .kv-file-content {
    height: 167px;
    width: 200px;
}
</style>


<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
    <button type="button" class="close" data-dismiss="modal"
        aria-hidden="true">
        <li class="fa fa-remove"></li>
    </button>
    <h5 class="modal-title"><spring:message code="sys.advertisement.details"/></h5>
</div>

<div class="modal-body">
    <form:form id="advertisementApprove-form" name="advertisementApprove-form"
        modelAttribute="advertisement" class="form-horizontal" >
        <form:hidden path="id" value="${advertisement.adId }" />
        <input type='hidden' value='${CSRFToken}' id='csrftoken'>
        <input type="hidden" id= "language" name ="language" value="${localLang }" /> 
        <div class="box-body">
            <div class="col-md-12">
                <div class="row">                   
              <div class="form-group">
                    <label for="adName" class="col-sm-3 control-label"><spring:message code="sys.advertisement.adName"/><span style="color:red">*</span></label>
                    <div class="col-sm-8"> 
                    <input id="oldAdName" name="oldAdName" type="hidden"
                            value="${advertisement.adName}" />
                        <form:input type="text" htmlEscape="false" class="form-control" readonly='true'
                            id="adName" path="adName" placeholder="${adNameForm}" maxlength="20"/>               
                     </div>               
                </div> 
                 
                 <div class="form-group">
                    <label for="adTitle" class="col-sm-3 control-label"><spring:message code="sys.advertisement.adTitle"/><span style="color:red">*</span></label>
                    <div class="col-sm-8">                    
                        <form:input type="text" htmlEscape="false" class="form-control" readonly='true'
                            id="adTitle" path="adTitle" placeholder="${adTitleForm}" maxlength="30"/>               
                     </div>               
                </div> 
                 
                <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="sys.advertisement.adType"/><span style="color:red">*</span></label>
                                       
                    <div class="col-sm-8">
                         <form:input type="text" htmlEscape="false" class="form-control" readonly='true'
                            id="adType" path="adTypeName" placeholder="${adTypeForm}" maxlength="20"/>
                    </div>
                </div>  
                
                <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="sys.advertisement.adAttribution"/><span style="color:red">*</span></label>
                                       
                    <div class="col-sm-8">
                         <form:input type="text" htmlEscape="false" class="form-control" readonly='true'
                            id="adAttribution" path="adAttribution" placeholder="${adAttributionForm}" maxlength="30"/>
                    </div>
                </div>   
                                                           
               <div class="form-group">
                    <label class="col-sm-3 control-label" for="adStartTime"><spring:message code="sys.advertisement.adStartTime"/><span style="color:red">*</span></label>
                     <div class="col-sm-8">
                         <form:input type="text" htmlEscape="false" class="form-control" readonly='true'
                            id="adStartTime" path="adStartTime" placeholder="${adStartTime}" maxlength="20"/>
                    </div>                  
            </div>             
             <div class="form-group">                    
                <label class="col-sm-3 control-label" for="adEndTime"><spring:message code="sys.advertisement.adEndTime"/><span style="color:red">*</span></label>
                <div class="col-sm-8">
                         <form:input type="text" htmlEscape="false" class="form-control" readonly='true'
                            id="adEndTime" path="adEndTime" placeholder="${adEndTime}" maxlength="20"/>
                    </div>                
            </div>   
                  
              <div class="form-group">                 
                        <label  for="adImg" class="col-sm-3 control-label"><spring:message code="sys.advertisement.adImg"/><span style="color:red">*</span></label>
                        <div class="col-sm-8" id="adContent3">                                                                                                                                                                                                       
                             <img src="${advertisement.adImg}"/>                             
                        </div>
                </div>                     
           <%--  <div class="form-group">
                        <label  for="adImg" class="col-sm-3 control-label"><spring:message code="sys.advertisement.adImg"/><span style="color:red">*</span></label>
                        <div class="col-sm-8" id="adContent3">                                                                                                          
                             <input type="hidden" name="appVersionId" id="appVersionId" value="${advertisement.adImg}" />
                             <input type="file" name="file" multiple="multiple" class="file-loading" id="adImg" 
                                 placeholder='${adImgForm}' />
                        </div>
                </div> 
                 --%>
                 <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="sys.advertisement.adDesc"/><span style="color:red">*</span></label>
                    <div class="col-sm-8">
                        <textarea id="adDesc" name="adDesc"  rows="4" maxlength="500" readonly='true'
                          htmlEscape="false" class="form-control" id="adDesc" path="adDesc" placeholder="${adDesc}">${advertisement.adDesc}</textarea>
                    </div>                   
                </div>  
                 <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="sys.advertisement.adContent"/><span style="color:red">*</span></label>
                    <div class="col-sm-8">
                        <textarea id="adContent" name="adContent"  rows="4" readonly='true'
                          htmlEscape="false" class="form-control" id="adContent" path="adContent" placeholder="${adContent}">${advertisement.adContent}</textarea>
                    </div>                   
                </div>  
                  <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="sys.advertisement.approvalOpinion"/><span style="color:red">*</span></label>
                    <div class="col-sm-8">
                        <textarea id="approvalOpinion" name="approvalOpinion"  rows="4" maxlength="300"
                          htmlEscape="false" class="form-control" id="approvalOpinion" path="approvalOpinion" placeholder="${approvalOpinion}">${advertisement.approvalOpinion}</textarea>
                    </div>                   
                </div>  
                
              </div>
            </div>
        </div>
        <!-- /.box-body -->
        <div class="box-footer text-right">
            <!--以下两种方式提交验证,根据所需选择-->
            
            <button type="button" name="notPass" class="btn btn-danger"
                data-btn-type="notPass"><spring:message code="advertisement.notpass" /></button>
            <button type="button" name="pass" class="btn btn-success"
                data-btn-type="pass"><spring:message code="advertisement.pass" /></button>
        </div>

        <!-- /.box-footer -->
    </form:form>


</div>
<script>
    //tableId,queryId,conditionContainer
    var language = $("#language").val();
    var langType = language.substring(3, 5).toUpperCase();
    language = language.replace(language.substring(2, 5), "-" + langType); 
    //tableId,queryId,conditionContainer
    var advertisementApproveform = null;
    var id = "${empty advertisement.id?0:advertisement.id}";
    var appId = $("#id").val();
    $(".select2").select2();
       
    $(function() {

       var advertisementApproveform = $("#advertisementApprove-form").form();
          
       var beginDateStr = '${advertisement.adStartTime }';
       var endDateStr = '${advertisement.adEndTime}';
      
       var adStartTime = new Date(beginDateStr);
       var adEndTime = new Date(endDateStr);      
       if(beginDateStr == null || beginDateStr == ''){
           $("#adStartTime").val(formatDate(new Date(), "yyyy-MM-dd"));
           $("#adEndTime").val(formatDate(new Date(), "yyyy-MM-dd"));             
       }else {
           $("#adStartTime").val(formatDate(adStartTime, "yyyy-MM-dd"));
           $("#adEndTime").val(formatDate(adEndTime, "yyyy-MM-dd"));              
       }
       
       // 广告归属（DA桌面APP、CA收银台APP、SA应用商店APP）
       var adAttributionStr = '${advertisement.adAttribution}'; 
       if(adAttributionStr=='DA'){
    	   $("#adAttribution").val('<spring:message code="desktop.app"/>');
       }else if(adAttributionStr=='CA'){
    	   $("#adAttribution").val('<spring:message code="checkstand.app"/>');
       }else{
    	   $("#adAttribution").val('<spring:message code="app.store.app"/>');
       }
                  
       $('button[data-btn-type]')
       .click(
               function() {
                   var action = $(this).attr('data-btn-type');
                   var approvalOpinion =$("#approvalOpinion").val();
                   switch (action) {
                   case 'pass':
                       modals
                       .confirm(
                               '<spring:message code="common.pass.advertisement" />',
                               function() {
                                   var params = {};                                  
                                   params["id"] = appId;
                                   params["approvalOpinion"] = approvalOpinion;
                                   ajaxPost(
                                           basePath
                                                   + "/advertisement/advertisementPass",
                                           params,
                                           function(data) {
                                               if (data.code == 200) {                                              
                                                   modals.correct(data.message);
                                                   modals.hideWin(winId);  
                                                   advertisementTable
                                                           .reloadRowData();
                                                   resetadvertisementForm();
                                                  
                                               } else {
                                                   modals.error(data.message);
                                                   $('#submit').removeAttr("disabled");
                                               }
                                           });
                               })
                       break;
                   case 'notPass':
                       modals
                               .confirm(
                                       '<spring:message code="common.refused.advertisement" />',
                                       function() {
                                           var params = {};
                                           params["id"] = appId;
                                           params["approvalOpinion"] = approvalOpinion;
                                           ajaxPost(
                                                   basePath
                                                           + "/advertisement/advertisementNotPass",
                                                   params,
                                                   function(data) {
                                                       if (data.code == 200) {
                                                           modals
                                                                   .correct(data.message);
                                                           modals.hideWin(winId);  
                                                           advertisementTable
                                                                   .reloadRowData();
                                                           resetadvertisementForm();
                                                        
                                                       } else {
                                                           modals.error(data.message);
                                                           $('#submit').removeAttr("disabled");
                                                       }
                                                   });
                                       })
                       break;
                   }
               });
      
    });

     
    function resetadvertisementForm() {
        advertisementApproveform.clearForm();
        $("#advertisementApprove-form").data('bootstrapValidator').resetForm();
    }
    
</script>
