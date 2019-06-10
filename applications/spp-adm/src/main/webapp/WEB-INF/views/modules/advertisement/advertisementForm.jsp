<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<spring:message code="sys.advertisement.adName" var="adNameForm"/>
<spring:message code="sys.advertisement.adDesc" var="adDescForm"/>
<spring:message code="sys.advertisement.adType" var="adTypeForm"/>
<spring:message code="sys.advertisement.adContent" var="adContentForm"/>
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
	<h5 class="modal-title"><spring:message code="sys.advertisement.add"/></h5>
</div>

<div class="modal-body">
	<form:form id="advertisement-form" name="advertisement-form"
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
                        <form:input type="text" htmlEscape="false" class="form-control"
                            id="adName" path="adName" placeholder="${adNameForm}" maxlength="20"/>               
                     </div>               
                </div> 
                 
                 <!--  div class="form-group">
                    <label for="adTitle" class="col-sm-3 control-label"><spring:message code="sys.advertisement.adTitle"/><span style="color:red">*</span></label>
                    <div class="col-sm-8">                    
                        <form:input type="text" htmlEscape="false" class="form-control"
                            id="adTitle" path="adTitle" placeholder="${adTitleForm}" maxlength="30"/>               
                     </div>               
                </div-->
                 
               <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="sys.advertisement.adType"/><span style="color:red">*</span></label>
                                       
                    <div class="col-sm-8">
                        <form:select path="adType" class="form-control select" style="width: 100%;"  >
                            <form:options items="${fns:getDictList('sys_advertisement_type')}"
                                itemLabel="label" itemValue="value" htmlEscape="false" />
                        </form:select>
                    </div>
                </div>    
                
                <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="sys.advertisement.adAttribution"/><span style="color:red">*</span></label>
                                       
                    <div class="col-sm-8">
                        <form:select path="adAttribution" class="form-control select" style="width: 100%;"  >
                            <form:option value="" label="${formSelect}" />
                            <form:options items="${fns:getDictList('sys_advertisement_adAttribution')}"
                                itemLabel="label" itemValue="value" htmlEscape="false" />
                        </form:select>
                    </div>
                </div>  
                                                           
                <div class="form-group">
                    <label class="col-sm-3 control-label" for="adStartTime"><spring:message code="sys.advertisement.adStartTime"/><span style="color:red">*</span></label>
                    <div class="col-sm-8">
                        <div class="input-group date">
                            <div class="input-group-addon">
                                <i class="fa fa-calendar"></i>
                            </div>
                            <span style="position: relative; z-index: 9999;"><form:input class="form-control pull-right" id="adStartTime"
                                type="text" path="adStartTime"  placeholder="${adStartTime }"
                                data-flag="datepicker" data-format="yyyy/MM/dd hh:mm:ss"  ></form:input></span>
                        </div>
                    </div>
            </div>             
             <div class="form-group">                    
                <label class="col-sm-3 control-label" for="adEndTime"><spring:message code="sys.advertisement.adEndTime"/><span style="color:red">*</span></label>
                <div class="col-sm-8">
                    <div class="input-group date">
                        <div class="input-group-addon">
                            <i class="fa fa-calendar"></i>
                        </div>
                        <span style="position: relative; z-index: 9999;"><form:input class="form-control pull-right" id="adEndTime" type="text"
                            path="adEndTime" placeholder="${adEndTime }"  data-flag="datepicker" data-format="yyyy/MM/dd hh:mm:ss"></form:input></span>
                    </div>
                </div>
            </div>  
                					
			<div class="form-group">
						<label  for="adImg" class="col-sm-3 control-label"><spring:message code="sys.advertisement.adImg"/><span style="color:red">*</span></label>
						<div class="col-sm-8" id="adContent3">						                         						                     				
                     		 <input type="hidden" name="appVersionId" id="appVersionId" value="${advertisement.adImg}" />
							 <input type="file" name="file" multiple="multiple" class="file-loading" id="adImg" 
								 placeholder='${adImgForm}' />
						</div>
						<%-- <div><h5><span style="color:red"><spring:message code="sys.advertisement.adImgForm"/></span></h5></div>  --%>
				</div>
				<div class="form-group">
				<label  for="adImg" class="col-sm-3 control-label"></label>                       
                        <div class="col-sm-8">
                        <h5><span style="color:red"><spring:message code="sys.advertisement.adImgForm"/></span></h5></div> 
                </div> 
				
				 <div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="sys.advertisement.adDesc"/></label>
                    <div class="col-sm-8">
                        <textarea id="adDesc" name="adDesc"  rows="6" maxlength="300"
                          htmlEscape="false" class="form-control" id="adDesc" path="adDesc" placeholder="${adDesc}">${advertisement.adDesc}</textarea>
                    </div>                   
                </div>  
				 <!-- div class="form-group">
                    <label class="col-sm-3 control-label"><spring:message code="sys.advertisement.adContent"/><span style="color:red">*</span></label>
                    <div class="col-sm-8">
                        <textarea id="adContent" name="adContent"  rows="6" 
                          htmlEscape="false" class="form-control" id="adContent" path="adContent" placeholder="${adContent}">${advertisement.adContent}</textarea>
                    </div>                   
                </div -->  
								
              </div>
			</div>
		</div>
		<!-- /.box-body -->
		<div class="box-footer text-right">
			<!--以下两种方式提交验证,根据所需选择-->
			<button type="button" class="btn btn-default" data-btn-type="cancel"
				data-dismiss="modal">
				<spring:message code="common.cancel" />
			</button>
			<button type="submit" id="submit" class="btn btn-primary"
				data-btn-type="save">
				<spring:message code="common.submit" />
			</button>
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
    var advertisementform = null;
    var id = "${empty advertisement.id?0:advertisement.id}";
    $(".select2").select2();
	$(function() {

		var advertisementform = $("#advertisement-form").form();
        
        $("#adStartTime").datepicker({
            language: "zh-CN",
            autoclose: true,//选中之后自动隐藏日期选择框
            clearBtn: true,//清除按钮
            todayBtn: true,//今日按钮
            format: "yyyy-mm-dd"//日期格式，详见 http://bootstrap-datepicker.readthedocs.org/en/release/options.html#format
        });
               
        $("#adEndTime").datepicker({
            language: "zh-CN",
            autoclose: true,//选中之后自动隐藏日期选择框
            clearBtn: true,//清除按钮
            todayBtn: true,//今日按钮
            format: "yyyy-mm-dd"//日期格式，详见 http://bootstrap-datepicker.readthedocs.org/en/release/options.html#format
        });
       
       var beginDateStr = '${advertisement.adStartTime }';
       var endDateStr = '${advertisement.adEndTime}';
       var adStartTime = new Date(beginDateStr);
       var adEndTime = new Date(endDateStr);      
       if(beginDateStr == null || beginDateStr == ''){
           $("#adStartTime").val(formatDate(new Date(), "yyyy-MM-dd"));
           $("#adEndTime").val(formatDate(new Date().setMonth(new Date().getMonth()+1), "yyyy-MM-dd"));             
       }else {
           $("#adStartTime").val(formatDate(adStartTime, "yyyy-MM-dd"));
           $("#adEndTime").val(formatDate(adEndTime, "yyyy-MM-dd"));              
       }
     
       $("input[type=file]").each(function(k,v){
           $('#'+this.id).file({
               fileinput: {
                   uploadUrl:"",
                   overwriteInitial: true,
                   showClose: true,
                   showCaption: false,
                   browseLabel: this.placeholder,
                   allowedFileExtensions: ['jpg', 'gif', 'png', 'bmp'],//接收的文件后缀
                   removeLabel: '删除图片',
                   removeClass: 'btn btn-danger',
                   otherActionButtons:"",
                   browseIcon: '<i class="glyphicon glyphicon-folder-open"></i>',
                   maxFileSize: 1024,
                   /* minImageWidth: 670, //图片的最小宽度
                   minImageHeight: 300,//图片的最小高度
                   maxImageWidth: 850,//图片的最大宽度
                   maxImageHeight: 400,//图片的最大高度 */
                   deleteUrl:'', 
                   maxFileCount:1,
                   autoReplace: true,
                   layoutTemplates: {main2: '{preview}  {browse} {remove}'}
               },
               fileIdContainer:"[name='appVersionId']",
               window:false,
               showUrl:basePath+"/advertisement/getFiles?aId="
               + id
           });
       })
        
	$("#advertisement-form")
                .bootstrapValidator(
                        {
                            message : '<spring:message code="app.appinfo.please.enter.a.valid.value" />',
                            feedbackIcons : {
                                valid : 'glyphicon glyphicon-ok',
                                invalid : 'glyphicon glyphicon-remove',
                                validating : 'glyphicon glyphicon-refresh'
                            },
                            excluded:[":disabled"],
                            fields : {                                                                                         
                                    adName : {
                                        validators : {
                                            notEmpty : {
                                                message : '<spring:message code="sys.advertisement.promt.adName"/>'
                                            },                                                                       
                                             remote:{
                                                    url:basePath+"/advertisement/checkAdName", 
                                                    delay :  2000,
                                                    data: function(validator) {
                                                        return {
                                                            adName:$('#adName').val(),
                                                            oldAdName:$('#oldAdName').val(),
                                                            id:$('#id').val()
                                                        };
                                                    },
                                                    message:'<spring:message code="sys.advertisement.promt.name.used"/>'
                                                } 
                                        }
                                    },                            
                                    adType : {
                                    	trigger:"change",
                                        validators : {
                                            notEmpty : {
                                                message : '<spring:message code="sys.advertisement.promt.adType"/>'
                                            },                                                                                                       
                                        }
                                    },
                                    /* adDesc : {
                                        validators : {
                                            notEmpty : {
                                                message : '<spring:message code="sys.advertisement.promt.adDesc"/>',
                                            }                                     
                                        }
                                    } , */
                                   /*  adTitle : {
                                        validators : {
                                            notEmpty : {
                                                message : '<spring:message code="sys.advertisement.promt.adTitle"/>',
                                            }                                        
                                        }
                                    } ,  */
                                    adImg : {
                                    	validators : {
                                            notEmpty : {
                                                message : '<spring:message code="sys.advertisement.promt.adImg"/>',
                                            }                                     
                                        }
                                    } ,
                                   /*  adContent : {
                                        validators : {
                                            notEmpty : {
                                                message : '<spring:message code="sys.advertisement.promt.adContent"/>',
                                            }                                     
                                        }
                                    } , */
                                    adAttribution : {
                                        validators : {
                                            notEmpty : {
                                                message : '<spring:message code="sys.advertisement.promt.adAttribution"/>',
                                            }                                     
                                        }
                                    } ,                           
                                    adStartTime : {
                                        validators : {
                                            notEmpty : {
                                                message : '<spring:message code="sys.advertisement.promt.adStartTime"/>',
                                            },                                     
                                            date : {
                                                format : 'YYYY-MM-DD',
                                                message : '<spring:message code="sys.log.tip.tiemFromatIncorrect"/>'
                                            },
                                            callback: {
                                                message: '<spring:message code="sys.log.tip.beginTimeTooBig"/>',
                                                callback:function(value, validator,$field,options){
                                                    var end = $("input[name='adEndTime']").val();
                                                    if(value == "" && end == ""){
                                                        return true;
                                                    }else {
                                                        value = new Date(value).getTime();
                                                        end = new Date(end).getTime();
                                                        return parseInt(value)<parseInt(end);
                                                    }                                               
                                                }
                                            }
                                        }
                                    } ,
                                    adEndTime : {
                                        validators : {
                                            notEmpty : {
                                                message : '<spring:message code="sys.advertisement.promt.adEndTime"/>',
                                            } , 
                                            date : {
                                                format : 'YYYY-MM-DD',
                                                message : '<spring:message code="sys.log.tip.tiemFromatIncorrect"/>'
                                            },
                                            remote:{
                                                url:basePath+"/advertisement/checkDate", 
                                                delay :  2000,
                                                data: function(validator) {
                                                    return {
                                                    	adStartTime:$('#adStartTime').val(),
                                                        adEndTime:$('#adEndTime').val(),
                                                        id:$('#id').val()
                                                    };
                                                },
                                                message:'<spring:message code="sys.advertisement.promt.adStartTime.limit"/>'
                                            },
                                            callback: {
                                                message: '<spring:message code="sys.log.tip.endTimeTooSmall"/>',
                                                callback:function(value, validator,$field){
                                                    var begin = $("input[name='adStartTime']").val();
                                                    $("input[name='adStartTime']").keypress();
                                                    if(value == "" && begin==""){
                                                        return true;
                                                    }else{
                                                        value = new Date(value).getTime();
                                                        begin = new Date(begin).getTime();
                                                        validator.updateStatus('adStartTime', 'VALID');
                                                        return parseInt(value)>parseInt(begin); 
                                                    }                                                   
                                                }
                                            }                              
                                        }
                                    }                                                                                               
                            }
                        })
                .on(
						'success.form.bv',
						function(e) {
							// 阻止默认事件提交
							e.preventDefault();
							if($("#adImg").val() == ''){
								modals.info("<spring:message code='models.info.upload.ad.img' />");
								return;
							}
							debugger;
							 modals.confirm({
                                 cancel_label:'<spring:message code="common.cancel" />',
                                 title:'<spring:message code="common.sys.confirmTip" />',
                                 ok_label:'<spring:message code="common.confirm" />',
                                 text:'<spring:message code="common.confirm.save"/>',
                                 callback: function() {
                                                                                                     
                                     //Save Data，对应'submit-提交'                               
                                                                                                   
                                          var params = new FormData($("#advertisement-form")[0]);
                                          debugger;
                                          ajaxPostFileForm(basePath+'/advertisement/save',params,function(data,status){
                                              if(data.code == 200){                                         	 
                                                  modals.correct(data.message);
                                                  modals.hideWin(winId);                                                 
                                                  advertisementTable.reloadRowData();                                                 
                                              }else{
                                                  modals.info(data.message);
                                                  $('#submit').removeAttr("disabled");
                                              }                
                                       });
                                          var adId='${advertisement.adId }';                                         
                                          var paramsAd = {
                                                  adId:adId                                                        
                                                  };  
                                          flag = ajaxPost(basePath + '/advertisement/advertisementCountValidator', paramsAd, function(data) {                                     
                                           });
                                           if(flag==1){
                                              // alert("现在有效广告数已经超过5个，系统将会按时间自动分配终端展示的广告");
                                              modals.info('<spring:message code="common.advertisement.limit" />');                                               
                                           } 
                                     
                                 }});
							

						})

	});

	 
    function resetadvertisementForm() {
        advertisementform.clearForm();
        $("#advertisement-form").data('bootstrapValidator').resetForm();
    }
	
</script>
