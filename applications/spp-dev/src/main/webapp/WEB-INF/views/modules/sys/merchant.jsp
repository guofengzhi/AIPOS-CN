<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="nav-tabs-custom">
			    <ul class="nav nav-tabs pull-right">
	                    <li><a href="#tab-content-edit" data-toggle="tab" id="nav-tab-edit"><i class="fa fa-edit"></i></a></li>
	                    <li class="active"><a href="#tab-content-list" data-toggle="tab" id="nav-tab-list"><i class="fa fa-list-ul"></i></a></li>
	                    <li class=" header"><i class="fa fa-user"></i><small>merchant列表</small></li>
	                </ul>
	                <div class="tab-content">
	                 		<div class="tab-pane active" id="tab-content-list">
			                <div class="box">
			                		<div id="merchantDiv" class="form-horizontal" role="form">
									<div class="form-group dataTables_filter " style="margin: 1em;">
										  <!--查询页面-->
									 	 <div class="col-md-12 text-center">
																									 <div class="form-group">
														      <label class="col-xs-3 control-label">序号:</label>
															<div class=" col-xs-5" style="padding-left: 15px; padding-right: 15px;">
															<input style="width:100%" id="id" name="id"  class="form-control" type="text">
														      </div> 
													   </div>
																									 <div class="form-group">
														      <label class="col-xs-3 control-label">商户号:</label>
															<div class=" col-xs-5" style="padding-left: 15px; padding-right: 15px;">
															<input style="width:100%" id="merId" name="merId"  class="form-control" type="text">
														      </div> 
													   </div>
																									 <div class="form-group">
														      <label class="col-xs-3 control-label">商户名称:</label>
															<div class=" col-xs-5" style="padding-left: 15px; padding-right: 15px;">
															<input style="width:100%" id="merName" name="merName"  class="form-control" type="text">
														      </div> 
													   </div>
																									 <div class="form-group">
														      <label class="col-xs-3 control-label">商户简称:</label>
															<div class=" col-xs-5" style="padding-left: 15px; padding-right: 15px;">
															<input style="width:100%" id="merAbbre" name="merAbbre"  class="form-control" type="text">
														      </div> 
													   </div>
																					          </div>
									          <!--按钮居中-->
										    <div class="col-md-12 text-center">
											              <div class="form-group ">
										                           <button shiro:hasPermission="sys:merchant:add" type="button" class="btn  btn-primary" data-btn-type="merchantAdd">
																<i class="fa fa-plus" aria-hidden="true"></i>添加
														    </button>
														    <button shiro:hasPermission="sys:merchant:add" type="button" class="btn  btn-primary" data-btn-type="merchantEdit">
																<i class="fa fa-plus" aria-hidden="true"></i>修改
														    </button>
														    <button shiro:hasPermission="sys:merchant:batchRemove" type="button" class="btn  btn-primary" data-btn-type="merchantDelete">
															  <i class="fa fa-trash" aria-hidden="true"></i>删除
														    </button>
														     <button type="button" class="btn btn-primary"
															data-btn-type="search"><spring:message code="common.query"/></button>
											                </div>
										         </div>
							</div>
							<div class="box-body">
								<table id="merchant_table" class="table table-bordered table-striped table-hover">
								</table>
							</div>
						</div>
			                </div>
			           </div>
			     		<div class="tab-pane " id="tab-content-edit">
	                 					 <form:form id="merchant-form" name="merchant-form" modelAttribute="merchant" enctype="multipart/form-data"
									class="form-horizontal">
										<input type="hidden" id="addOrUpdate" value="" />
										<div class="box-body">
											 <div class="col-md-12 text-center">
																											 <div class="form-group">
															      <label class="col-xs-3 control-label">序号:</label>
																<div class=" col-xs-5" style="padding-left: 15px; padding-right: 15px;">
															      <form:input type="text" htmlEscape="false" class="form-control"
																	id="id" path="id"  placeholder="${id}"  />
															      </div> 
														   </div>
																											 <div class="form-group">
															      <label class="col-xs-3 control-label">商户号:</label>
																<div class=" col-xs-5" style="padding-left: 15px; padding-right: 15px;">
															      <form:input type="text" htmlEscape="false" class="form-control"
																	id="merId" path="merId"  placeholder="${merId}"  />
															      </div> 
														   </div>
																											 <div class="form-group">
															      <label class="col-xs-3 control-label">商户名称:</label>
																<div class=" col-xs-5" style="padding-left: 15px; padding-right: 15px;">
															      <form:input type="text" htmlEscape="false" class="form-control"
																	id="merName" path="merName"  placeholder="${merName}"  />
															      </div> 
														   </div>
																											 <div class="form-group">
															      <label class="col-xs-3 control-label">商户简称:</label>
																<div class=" col-xs-5" style="padding-left: 15px; padding-right: 15px;">
															      <form:input type="text" htmlEscape="false" class="form-control"
																	id="merAbbre" path="merAbbre"  placeholder="${merAbbre}"  />
															      </div> 
														   </div>
																							 	  </div>
										 	  <div class="col-md-12 text-center">
												<button type="button" class="btn btn-default" data-btn-type="cancel"
													data-dismiss="modal"><spring:message code="common.cancel"/></button>
												<button type="submit" class="btn btn-primary" data-btn-type="save"><spring:message code="common.submit"/></button>
											  </div>
										</div>
								</form:form> 
	                 		</div>
			     </div>       
			</div>
		</div>
	</div>
</section>
<script>
function setTitle(title){
    $("ul.nav-tabs li.header small").text(title);
 }
function resetmerchantForm() {
	merchantform.clearForm();
	$("#merchant-form").data('bootstrapValidator').resetForm();
}
var form = null;

     form=$("#merchant-form").form();
    form.initComponent();
    var merchantTable, winId = "merchantWin";
    $(function (){
    
    //初始化加载列表
     var config = {
            resizeSearchDiv:false,
            language : {
                url: basePath+'<spring:message code="common.language"/>'
            }
        };
        merchantTable = new CommonTable("merchant_table", "MerchantTable", "merchantDiv", "/sys/merchant/list", config);
        //变更标题
        $("#nav-tab-list").on("click",function(){
            setTitle("merchant列表");
        });
		       //初始化加载列表名称
			 $('button[data-btn-type]').click(function() {
		      var action = $(this).attr('data-btn-type');
		      var rowId=merchantTable.getSelectedRowData();
		      switch (action) {
		          case 'merchantAdd':
		                   form.clearForm();
		                   setTitle("新增数据");
		                  $("#nav-tab-edit").click();
		              	$("#addOrUpdate").val("add");
		              break;
		          case 'merchantEdit':
		                  if(!rowId){
		                      modals.info('请选择要编辑的行');
		                      return false;
		                  }
		                  form.clearForm();
		                   	$("#addOrUpdate").val("edit");
		                  setTitle("编辑数据")
		                  $("#nav-tab-edit").click();
		                   ajaxPost(basePath+"/sys/merchant/edit?id="+rowId.id,null,function(data){
		                  	 form.initFormData(data);
		   				});
		                  break;
		          case 'merchantDelete':
		          	if (!rowId) {
							modals.info('<spring:message code="common.promt.delete"/>');
							return false;
						}
						modals.confirm({
							cancel_label:"<spring:message code="common.cancel" />",
							title:"<spring:message code="common.sys.confirmTip" />",
							ok_label:"<spring:message code="common.confirm" />",
							text:"<spring:message code="common.confirm.delete" />",
							callback: function() {
							ajaxPost(basePath + "/sys/merchant/remove?id="
									+ rowId.id, null, function(data) {
								if (data.code == 200) {
									modals.correct({
										title:'<spring:message code="common.sys.success" />',
										cancel_label:'<spring:message code="common.confirm" />',
										text:'删除成功'});
									merchantTable.reloadRowData();
								} else {
									modals.warn(date.message);
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
			$("#merchant-form").bootstrapValidator(
							{
								message : '<spring:message code="common.promt.value"/>',
								feedbackIcons : {
									valid : 'glyphicon glyphicon-ok',
									invalid : 'glyphicon glyphicon-remove',
									validating : 'glyphicon glyphicon-refresh'
								},							
								fields : {
								
																	   id : {
										validators : {
											notEmpty : {
												message : '序号'
											}
										}
									},
																	   merId : {
										validators : {
											notEmpty : {
												message : '商户号'
											}
										}
									},
																	   merName : {
										validators : {
											notEmpty : {
												message : '商户名称'
											}
										}
									},
																	   merAbbre : {
										validators : {
											notEmpty : {
												message : '商户简称'
											}
										}
									},
																	'' : {
										validators : {
											
										}
									}
									
								}
							}).on('success.form.bv', function(e) {
								 // 阻止默认事件提交
								 e.preventDefault();
								 
								 modals.confirm({
										cancel_label:'<spring:message code="common.cancel" />',
										title:'<spring:message code="common.sys.confirmTip" />',
										ok_label:'<spring:message code="common.confirm" />',
										text:'<spring:message code="common.confirm.save"/>',
										callback: function() {
											//Save Data，对应'submit-提交'
											var params = form.getFormSimpleData();
											var addOrUpdate = $("#addOrUpdate").val();
											var urlEA="";
												if (addOrUpdate != "add") {//更新
														urlEA=basePath + '/sys/merchant/update';
												}else{
														urlEA=basePath + '/sys/merchant/save';
												}
											ajaxPost(urlEA,
													params, function(data, status) {
														if (data.code == '200' || data.code == 200) {
															if (addOrUpdate != "add") {//更新
																modals.info({
											                        title:'<spring:message code="common.sys.info" />', 
											                        cancel_label:'<spring:message code="common.close" />',
											                        text:'更新成功'}); 
																merchantTable.reloadRowData(id);
															} else {//新增
																modals.info({
											                        title:'<spring:message code="common.sys.info" />', 
											                        cancel_label:'<spring:message code="common.close" />',
											                        text:'添加成功'});

																merchantTable.reloadData();
																form.clearForm();
															}
															  $("#nav-tab-list").click();
														} else{
															modals.error(data.message);
														}
													});
										}});
							});
    });
</script>