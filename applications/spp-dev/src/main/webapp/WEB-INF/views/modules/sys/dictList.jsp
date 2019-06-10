<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<!-- Main content -->
<section class="content">
    <div class="row">
        <div class="col-xs-12">
	        <div class="nav-tabs-custom">
	        	<ul class="nav nav-tabs pull-right">
	                    <li><a href="#tab-content-edit" data-toggle="tab" id="nav-tab-edit"><i class="fa fa-edit"></i></a></li>
	                    <li class="active"><a href="#tab-content-list" data-toggle="tab" id="nav-tab-list"><i class="fa fa-list-ul"></i></a></li>
	                    <li class=" header"><i class="fa fa-adjust"></i><small><spring:message code="common.dictList"></spring:message></small></li>
	            </ul>
	            <div class="tab-content">
                 		<div class="tab-pane active" id="tab-content-list">
			              <div class="box">
			                <div id="dictSearchDiv" class="form-horizontal" role="form">
			                    <div class="form-group dataTables_filter " style="margin: 1em;">
			                          <select id="lang" name="lang" class="form-control select2" style="width:140px">
					                            <c:if test="${localLang == 'en_us'}"><option value="">All</option></c:if>
					                            <c:if test="${localLang == 'zh_cn' || localLang == 'zh_tw'}"><option value="">全部</option></c:if>
					                            <c:forEach items="${langTypeList}" var="language" varStatus="status">
						                              <c:choose>
						                                  <c:when test="${language.value == localLang}">
						                                      <option value="${language.value}" selected="selected">${language.label}</option>
						                                  </c:when>
						                                  <c:otherwise>
						                                      <option value="${language.value}">${language.label}</option>
						                                  </c:otherwise>
						                              </c:choose>
					                            </c:forEach>
			                        </select>
			                           <input placeholder='<spring:message code="sys.dict.promt.type.description"/>' name="description"
			                            class="form-control" type="search" title='<spring:message code="sys.dict.promt.type.description"/>' />  
			                           <input placeholder='<spring:message code="sys.dict.promt.label"/>' name="label" class="form-control"
			                            type="search" title='<spring:message code="sys.dict.promt.label"/>' />
			                            <button type="button" class="btn btn-primary" id="queryId"
			                                data-btn-type="search"><spring:message code="common.query"/></button>
			                            <button type="button" class="btn btn-default"
			                                data-btn-type="reset"><spring:message code="common.reset"/></button>
			                                
			                            <shiro:hasPermission name="sys:dict:edit">
				                            <button type="button" class="btn btn-default" data-btn-type="add"><spring:message code="common.add"/></button>
				                            <button type="button" class="btn btn-default"
				                                data-btn-type="edit"><spring:message code="common.edit"/></button>
				                            <button type="button" class="btn btn-default"
				                                data-btn-type="delete"><spring:message code="common.delete"/></button>
			                            </shiro:hasPermission>    
			                    </div>
			                </div>
			                    <div class="dataTables_filter">
			                    <div style="text-align: right;">
			                   
			                    </div>
			                    </div>       
			                <div class="box-body" style="padding-top: 0px;">
			                    <table id="dict_table"
			                        class="table table-bordered table-striped table-hover">
			                    </table>
			                </div>
			            </div>
                 		</div>
                 		<div class="tab-pane " id="tab-content-edit">
                 			<form:form id="dict-form" name="dict-form" class="form-horizontal"
						modelAttribute="dict">
						<form:hidden path="id" />
						<input type='hidden' value='${CSRFToken}' id='csrftoken'>
						<input type='hidden' value="" id='addOrUpdate'>
						<input type='hidden' value='${dict.lang}' id='lang' name="lang">
						<div class="box-body">
				            <div class="row">
				                <div class="form-group">
				                    <label for="value" class="col-sm-1 control-label"><spring:message code="sys.dict.value"/><span style="color:red">*</span></label>
				                    <div class="col-sm-5">
				                        <form:input path="value" htmlEscape="false" maxlength="50"
				                            class="form-control" placeholder="${dictValue}" />
				                    </div>
				                    <label for="label" class="col-sm-1 control-label"><spring:message code="sys.dict.label"/><span style="color:red">*</span></label>
				                    <div class="col-sm-5">
				                        <form:input path="label" class="form-control" placeholder="${dictLabel}" />
				                    </div>
				                </div>
				             </div> 
				            <div class="row">    
				                <div class="form-group">
				                    <label for="type" class="col-sm-1 control-label"><spring:message code="sys.dict.type"/><span style="color:red">*</span></label>
				                    <div class="col-sm-5">
				                        <form:input path="type" class="form-control" htmlEscape="false"
				                            placeholder="${dictType}" />
				                    </div>
				                     <label for="description" class="col-sm-1 control-label"><spring:message code="sys.dict.description"/><span style="color:red">*</span></label>
				                    <div class="col-sm-5">
				                        <form:input path="description" htmlEscape="false" maxlength="50"
				                            class="form-control"/>
				                    </div>
				                </div>
				            </div>
				            <div class="row">
				                <div class="form-group">
				                    <label for="sort" class="col-sm-1 control-label"><spring:message code="sys.dict.sort"/></label>
				                    <div class="col-sm-5">
				                       <form:input path="sort" htmlEscape="false" class="form-control" />
				                    </div>
				                </div>
				            </div>
				             <div class="row">
				               <div class="row">
				                  <label for="remarks" class="col-sm-1 control-label"><spring:message code="sys.dict.demonstration"/></label>
						       <div class="col-sm-11">
						           <form:textarea path="remarks" class="form-control" style="width:97%; height: 114px;"
						               htmlEscape="false" rows="3" maxlength="200" placeholder="${dictDemostration}" />
						       </div>
				                </div>
				             </div>
				        </div>
						<!-- /.box-body -->
						<div class="box-footer text-right">
							<button type="button" class="btn btn-default" data-btn-type="cancel"
								data-dismiss="modal"><spring:message code="common.cancel"/></button>
							<shiro:hasPermission name="sys:dict:edit">
								<button type="submit" class="btn btn-primary" data-btn-type="save"><spring:message code="common.submit"/></button>&nbsp;</shiro:hasPermission>
				
						</div>
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
function setTitle(title){
    $("ul.nav-tabs li.header small").text(title);
 }
var form = $("#dictSearchDiv").form({baseEntity: false});
    form.initComponent();
    //tableId,queryId,conditionContainer
    var dictTable;
    var winId = "dictWin";
    var formEdit=null;
    $(function() {
    	//初始化未空
    	$("#addOrUpdate").val("");
    	formEdit=$("#dict-form").form();
        //init table and fill data
          var config = {
            resizeSearchDiv:false,
            language : {
                url: basePath+'<spring:message code="common.language"/>'
            }
        };
        dictTable = new CommonTable("dict_table", "dict_list", "dictSearchDiv", "/sys/dict/list", config);
        
        $("#lang").change(function(){
        	$('#queryId').trigger("click");
       });
        
        //button event
        $('button[data-btn-type]').click(
                        function() {
                            var action = $(this).attr('data-btn-type');
                            var rowId = dictTable.getSelectedRowId();
                            var lang = $("#lang").val();
                            switch (action) {
                            case 'add':
       	                        setTitle('<spring:message code="sys.dict.add"/>');
       	                        $("#nav-tab-edit").click();
       	                        formEdit.clearForm();
       	                    	$("#addOrUpdate").val("add");
                                break;
                            case 'edit':
                                if (!rowId) {
                                    modals.info({
                                        title:'<spring:message code="common.sys.info" />', 
                                        cancel_label:'<spring:message code="common.cancel" />',
                                        text:'<spring:message code="common.promt.edit"/>'});
                                    return false;
                                }
                              setTitle("<spring:message code="sys.dict.edit"/>【"+dictTable.getSelectedRowData().value+"】");
    	                        $("#nav-tab-edit").click();
    	                    	$("#addOrUpdate").val("update");
    	                    	ajaxPost(basePath+"/sys/dict/selectDict?id="+ rowId,null,function(data){
	   	                        	 //重置
	   	                        	 formEdit.clearForm();
	   	                        	 //赋值
	   	                        	 formEdit.initFormData(data);
   	         			  });
                                break;
                            case 'delete':
                                if (!rowId) {
                                    modals.info({
                                        title:'<spring:message code="common.sys.info" />', 
                                        cancel_label:'<spring:message code="common.cancel" />',
                                        text:'<spring:message code="common.promt.delete"/>'});
                                    return false;
                                }
                                modals.confirm({
                                    cancel_label:'<spring:message code="common.cancel" />',
                                    title:'<spring:message code="common.sys.confirmTip" />',
                                    ok_label:'<spring:message code="common.confirm" />',
                                    text:'<spring:message code="common.confirm.delete" />', 
                                    callback: function() {
                                    ajaxPost(
                                            basePath
                                                    + "/sys/dict/delete/"
                                                    + rowId,
                                            null,
                                            function(data) {
                                                if (data.code == 200) {
                                                    modals.correct({
                                                        title:'<spring:message code="common.sys.success" />', 
                                                        cancel_label:'<spring:message code="common.sys.confirmbutton" />',
                                                        text:'<spring:message code="common.promt.deleted"/>'});
                                                    dictTable.reloadRowData();
                                                } else {
                                                    modals.error(data.message);
                                                }
                                            });
                                }});
                                break;
                            case 'cancel':
                                $("#nav-tab-list").click();
                                break;
                            }
                        });
     		 //数据校验
		$("#dict-form").bootstrapValidator({
			message : '<spring:message code="common.promt.value"/>',
			feedbackIcons : {
				valid : 'glyphicon glyphicon-ok',
				invalid : 'glyphicon glyphicon-remove',
				validating : 'glyphicon glyphicon-refresh'
			},
			fields : {
				value : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.dict.promt.value"/>'
						}
					}
				},
				label : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.dict.promt.label"/>'
						}
					}
				},
				type : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.dict.promt.type"/>'
						}
					}
				},
				description:{
					validators : {
						notEmpty:{
							message : '<spring:message code="sys.dict.promt.type.description"/>'
						}
					}
				}
				
			}
		}).on("success.form.bv",function(e){
			    e.preventDefault();
				modals.confirm({
					cancel_label:'<spring:message code="common.cancel" />',
					title:'<spring:message code="common.sys.confirmTip" />',
					ok_label:'<spring:message code="common.confirm" />',
					text:'<spring:message code="common.confirm.save"/>',
					callback: function() {
					//Save Data，对应'submit-提交'
					var params = formEdit.getFormSimpleData();
					console.log(params);
					var addOrUpdate=$("#addOrUpdate").val();
					ajaxPost(basePath+'/sys/dict/save?addOrUpdate='+addOrUpdate, params, function(data, status) {
						if(data.code == 200){
							if(id!="0"){//更新
								modals.info({
			                        title:'<spring:message code="common.sys.info" />', 
			                        cancel_label:'<spring:message code="common.close" />',
			                        text:'<spring:message code="common.editSuccess" />'}); 
								dictTable.reloadRowData(id);
							}else{//新增 
								modals.info({
			                        title:'<spring:message code="common.sys.info" />', 
			                        cancel_label:'<spring:message code="common.close" />',
			                        text:'<spring:message code="common.AddSuccess" />'});
								 dictTable.reloadData();
							}
							  $("#nav-tab-list").click();
							  $("#csrftoken").val("");
						}else{
							modals.error(data.message);
						}				 
					});
				}});
		});
    });
</script>
