<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<spring:message code="sys.advertisement.adName" var="adNameForm"/>
<spring:message code="sys.advertisement.adDesc" var="adDescForm"/>
<spring:message code="sys.advertisement.adType" var="adTypeForm"/>
<spring:message code="sys.advertisement.adContent" var="adContentForm"/>
<spring:message code="sys.advertisement.adTitle" var="adTitleForm"/>
<spring:message code="sys.advertisement.adImg" var="adImgForm"/>
<spring:message code="common.form.select" var="formSelect"/>
<spring:message code="sys.advertisement.adStartTime" var="adStartTime"/>
<spring:message code="sys.advertisement.adEndTime" var="adEndTime"/>
<!-- Main content -->
<section class="content">
    <div class="row">
        <div class="col-xs-12">
	        	<div class="nav-tabs-custom">
						<ul class="nav nav-tabs pull-right">
							<li><a href="#tab-content-edit" data-toggle="tab"
								id="nav-tab-edit"><i class="fa fa-edit"></i></a></li>
							<li class="active"><a href="#tab-content-list"
								data-toggle="tab" id="nav-tab-list"><i class="fa fa-list-ul"></i></a></li>
							<li class=" header"><i class="fa-hourglass-half "></i><small><spring:message
										code="ota.table.strategy.list"></spring:message></small></li>
						</ul>
						<div class="tab-content">
								<div class="tab-pane active" id="tab-content-list">
									  <div class="box">
							                <div id="advertisementSearchDiv" class="dataTables_filter" style="text-align: left;" role="form">
							                		  <div class="form-group dataTables_filter " style="margin: 1em;">
							                		     	 <input class="form-control" id="adName"  style="margin-left:0px;width: 226.5px;" type="text"  maxlength="50"
							                               			 name="adName" placeholder='<spring:message code="sys.advertisement.adName"/>' />
							                                  <input class="form-control" id="adTitle"  style="margin-left:0px;width: 226.5px;" type="text"  maxlength="50"
							                             	 	     name="adTitle" placeholder='<spring:message code="sys.advertisement.adTitle"/>' />
							                                  <input class="form-control" id="adStartTime1"  style="margin-left:0px;width: 226.5px;"
							                                    	 type="text" name="adStartTime1" placeholder='<spring:message code="sys.advertisement.adStartTime"/>' onkeypress="notPut(event);"
							                                         data-flag="datepicker" />
							                                  <input class="form-control" id="adEndTime1" type="text"  style="height:37px;margin-left:0px;width: 226.5px;" onkeypress="notPut(event);"
							                                   		 name="adEndTime1" placeholder='<spring:message code="sys.advertisement.adEndTime"/>' data-flag="datepicker" />
							                                  <button type="button" class="btn btn-primary" style="height:37px;"
							                              					  data-btn-type="search"><spring:message code="common.query"/></button>
							                          		  <button type="button" class="btn btn-default" style="height:37px;"
							                              			  data-btn-type="reset"><spring:message code="common.reset"/></button>
							                              	  <shiro:hasPermission name="sys:advertisement:edit">
																	<button type="button" class="btn btn-default"  data-btn-type="advertisementDelete" title='<spring:message code="common.delete"/>'  style="height:37px">
																		<i class="fa fa-remove"></i>
																	</button>
																	<button data-btn-type="advertisementEdit" class="btn btn-default"  title='<spring:message code="common.edit"/>' type="button"  style="height:37px">
																		<i class="fa fa-edit"></i>
																	</button>
																	<button data-btn-type="advertisementAdd" class="btn btn-default"  title='<spring:message code="common.add"/>' type="button"  style="height:37px">
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
								 <div class="tab-pane" id="tab-content-edit">
								 		<form:form id="advertisement-form" name="advertisement-form"
													modelAttribute="advertisement" class="form-horizontal" >
													<form:hidden path="id" value="${advertisement.adId }" />
													<input type='hidden' value='${CSRFToken}' id='csrftoken'>
											        <input type="hidden" id= "language" name ="language" value="${localLang }" /> 
											        <input type="hidden" id="addOrUpdate" value="" />
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
						</div>
						
				</div>				
            </div>
            <!-- /.col -->
        </div>
        <!-- /.row -->
</section>

<script>
function setTitle(title) {
	$("ul.nav-tabs li.header small").text(title);
}
var dataForm=null;
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
    	
    	dataForm=$("#advertisement").form();
		 //编辑区域点击事件
		 $("#nav-tab-edit").click(function(){
				dataForm.clearForm();
		 });
		 $("#nav-tab-list").click(function(){
			  setTitle("<spring:message code="sys.advertisement.table.name"/>");
		 });
		//设置心新增修改参数为新增
		$("#addOrUpdate").val("add");
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
                  /*  minImageWidth: 670, //图片的最小宽度
                   minImageHeight: 300,//图片的最小高度
                   maxImageWidth: 850,//图片的最大宽度
                   maxImageHeight: 400,//图片的最大高度 */
                   deleteUrl:'', 
                   maxFileCount:1,
                   previewSettings: {
                       image: {width: "100%", height: "100%"},
                   },
                   autoReplace: true,
                   layoutTemplates: {main2: '{preview}  {browse} {remove}'}
               },
               fileIdContainer:"[name='appVersionId']",
               window:false,
               showUrl:basePath+"/advertisement/getFiles?aId="
               + id
           });
       })
        
	$("#advertisement-form").bootstrapValidator(
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
                .on('success.form.bv',
						function(e) {
							// 阻止默认事件提交
							e.preventDefault();
							if($("#adImg").val() == ''){
								modals.info("<spring:message code='models.info.upload.ad.img' />");
								return;
							}
							 modals.confirm({
                                 cancel_label:'<spring:message code="common.cancel" />',
                                 title:'<spring:message code="common.sys.confirmTip" />',
                                 ok_label:'<spring:message code="common.confirm" />',
                                 text:'<spring:message code="common.confirm.save"/>',
                                 callback: function() {
                                          var params = new FormData($("#advertisement-form")[0]);
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
                                           $("#nav-tab-list").click();
           								  setTitle("<spring:message code="sys.advertisement.table.name"/>");
           								  $("#csrftoken").val("");
           								  
                                 }});
							

						})
        //button event
        $('button[data-btn-type]')
                .click(
                        function() {
                            var action = $(this).attr('data-btn-type');                     
                            var advertisementRowId = advertisementTable.getSelectedRowId();                       
                            switch (action) {
                            case 'advertisementAdd':
                            	setTitle('<spring:message code="sys.advertisement.add"/>');//设置界面显示信息
								$("#nav-tab-edit").click();
								dataForm.clearForm();//清空文本框数据
								$("#addOrUpdate").val("add");
                                break;
                            case 'advertisementEdit':
                                if (!advertisementRowId) {
                                    modals.info('<spring:message code="common.promt.edit"/>');
                                    return false;
                                }
                            	setTitle("<spring:message code="sys.advertisement.edit"/>");
								$("#nav-tab-edit").click();
								$("#addOrUpdate").val("update");
								ajaxPost(basePath+"/advertisement/AdvertisementEditOrAdd?id="+advertisementRowId, null, function(data) {
											//重置
											dataForm.clearForm();
											//赋值
											dataForm.initFormData(data);
								});
                                break;
                            case 'cancel':
		                        $("#nav-tab-list").click();
		                        $("#addOrUpdate").val("add");
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
