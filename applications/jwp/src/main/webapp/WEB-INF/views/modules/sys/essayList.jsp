<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>

<!-- Content Header (Page header) -->
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i><spring:message code="common.homepage"/></a></li>
		<li class="active"><spring:message code="sys.essay.table.name"/></li>
	</ol>
	<div class="col-xs-12"></div>
</section>

<!-- Main content -->
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div>&nbsp;</div>
			<div class="dataTables_filter" id="essaySearchDiv">
						
					<div class="btn-group">
					<input placeholder='<spring:message code="sys.essay.inputTitle"/>' id="title" name="title" class="form-control"
							 type="search" title='<spring:message code="sys.essay.inputTitle"/>' /> 
					</div>
					
					<div class="btn-group">
					<input placeholder='<spring:message code="sys.essay.inputKeyWords"/>' id="keyWords" name="keyWords" class="form-control"
							type="search" title='<spring:message code="sys.essay.inputKeyWords"/>' /> 
					</div>
				<div class="btn-group">
					<button type="button" class="btn btn-primary"
						data-btn-type="search"><spring:message code="common.query"/></button>
					&nbsp;&nbsp;
					<button type="button" class="btn btn-default"
						data-btn-type="reset"><spring:message code="common.reset"/></button>
				</div>
				
				<div class="btn-group">
					<button type="button" class="btn btn-success" data-btn-type="addEssay"><spring:message code="sys.essay.inputAddEssay"/></button>&nbsp;&nbsp;
				</div>
						
				</div>	
				<div class="box-body">
					<table id="essay_table"
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
var form = $("#essaySearchDiv").form({baseEntity: false});
    	form.initComponent();
    
		//tableId,queryId,conditionContainer
		var essayTable;
		var winId = "essayWin";
		$(function() {
			
			$("#essaySearchDiv").bootstrapValidator({
				message : '<spring:message code="sys.essay.effectiveValue"/>',
				feedbackIcons : {
					valid : 'glyphicon glyphicon-ok',
					invalid : 'glyphicon glyphicon-remove',
					validating : 'glyphicon glyphicon-refresh'
				}
			}).on('success.form.fv', function(e) {
			    e.preventDefault();
			});
			 var config={
				singleSelect:null
			};
			//init table and fill data
			essayTable = new CommonTable("essay_table", "essay_list", "essaySearchDiv",
					"/markdown/list", config);
	
			$('button[data-btn-type]').click(
				function() {
					var action = $(this).attr('data-btn-type');
					switch (action) {
					case 'addEssay':
						loadPage(basePath+"/markdown/form",true);
						break;
					}
			});
	});
	
	var essayProcessDef={
			
			deleteEssay:function(id){
				modals.confirm('<spring:message code="sys.essay.confirm"/>', function() {
					
					//Save Data，对应'submit-提交'
					 var params = {};
					 params["id"] = id;
					 ajaxPost(basePath+'/markdown/delete', params, function(data, status) {
					 if(data.code == 200){
						modals.correct(data.message);
						modals.hideWin(winId);	
						essayTable.reloadRowData();
					 }else{
					 	modals.warn(data.message);
					 }				 
					}); 
				});
			},
			edit:function(id){
				loadPage(basePath+"/markdown/form?id=" + id, true);
			},
			preview:function(id){
				loadPage(basePath+"/markdown/preview?id=" + id, true);
			}
	};
	
	function operation(id){
		var oper = "&nbsp;&nbsp;&nbsp;";
		oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='essayProcessDef.preview(\"" + id +"\")'><spring:message code="sys.essay.preview"/></a>";
        oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='essayProcessDef.edit(\"" + id +"\")'><spring:message code="common.edit"/></a>";
        oper += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='essayProcessDef.deleteEssay(\"" + id +"\")'><spring:message code="common.delete"/></a>";
        return oper;
	}
	
</script>
