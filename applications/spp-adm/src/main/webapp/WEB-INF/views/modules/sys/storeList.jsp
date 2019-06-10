<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<div id="listForm">
<section class="content-header">
	<ol class="breadcrumb">
		<li><a href="${basePath}"><i class="fa fa-dashboard"></i><spring:message code="common.homepage"/></a></li>
		<li><a href="#"><spring:message code="common.sys.management"/></a></li>
		<li class="active"><spring:message code="store.manage"/></li>
	</ol>
	<div class="col-sm-12"></div>
</section>

<!-- Main content -->
<section class="content" >
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<!-- /.box-header -->
				<div id="storeSearchDiv" role="form" class="dataTables_filter" style="text-align: left;"><!-- form-horizontal -->
						<div class="has-feedback form-group">
							<input id="storeOrgSelect" style="width: 226.5px;" name="orgId" class="form-control"  type="hidden"/>
							<input id="storeOrgSelectValue" style="width: 226.5px;margin-left:0px;" name="orgIdValue" class="form-control" type="text" placeholder='<spring:message code="please.select.organ"/>'/>
						</div>
						<div class="has-feedback form-group">
								<select id="selectMerchants" name="merId" class="form-control select2" data-placeholder='<spring:message code="please.select.merchant"/>'
									style="width: 226.5px;">
									<option value=""></option>
								</select>
						</div>
						<div class="has-feedback form-group">
								<select id="selectStores" name="storeId" class="form-control select2" data-placeholder='<spring:message code="please.select.store"/>'
									style="width: 226.5px;">
									<option value=""></option>
								</select>
						</div>
						<div class="btn-group">
							<button type="button" class="btn btn-primary"
								data-btn-type="search"><spring:message code="common.query"/></button>
							<button type="button" class="btn btn-default"
								data-btn-type="reset"><spring:message code="common.reset"/></button>
						</div>
						<!-- <div class="col-sm-12 form-group" style="float: right;margin-top:10px;margin-right:-14px;"> -->
						<div style="width:100%;margin-top:5px;">
							<shiro:hasPermission name="sys:merchant:edit">
								<button type="button" class="btn btn-default"  data-btn-type="storeDelete" title="<spring:message code="delete"/>" style="float:right">
									<i class="fa fa-remove"></i>
								</button>
								<button data-btn-type="storeEdit" class="btn btn-default"  title='<spring:message code="edit"/>' type="button" style="float:right">
									<i class="fa fa-edit"></i>
								</button>
								<button data-btn-type="storeAdd" class="btn btn-default"  title='<spring:message code="add"/>' type="button" style="float:right">
									<i class="fa fa-plus"></i>
								</button>
							</shiro:hasPermission>
						</div>
					</div>
						<div class="box-body">
							<table id="store_table"
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
</div>
<script>
$(function(){
	$("#selectMerchants").change(function(){
		var secSelect = document.getElementById("selectStores");
		var merId = this.value;
		//secSelect.options.length = 0;
		$.ajax({
			url:basePath+'/sys/store/stores?merId='+merId,
			success:function(res){
				 var dataJson = res.data;
				 var oOption = document.createElement("OPTION");
				 oOption.value = "";
			     oOption.text = "<spring:message code='all'/>";
			     secSelect.options.add(oOption);	
				 for ( var i = 0; i < dataJson.length; i++) {
						var oOption = document.createElement("OPTION");
						oOption.value = dataJson[i].storeId;
						oOption.text = dataJson[i].storeName;
						secSelect.options.add(oOption);
					}
				}
			});
		});
	});
	//tableId,queryId,conditionContainer
	var storeTable;
	var winId = "storeWin";
	$("#reset").click(function(){
		 $("select").select2().val("");
		 var secSelect = document.getElementById("selectMerchants");
		 secSelect.options.length = 0;
	});
	$(function() {
		/* $("#orgSelect").select2(); */
		$("#selectMerchants").select2();
		$("#selectStores").select2();
		//查询框是否在一行设置
		var config = {
			resizeSearchDiv : false,
			language : {
				url : basePath + '<spring:message code="common.language"/>'
			}
		};
		storeTable = new CommonTable("store_table", "storeTable",
				"storeSearchDiv", "/sys/store/list", config);
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var storeRowId = storeTable.getSelectedRowId();
							switch (action) {
							case 'storeAdd':
								modals
										.openWin({
											winId : winId,
											title : "<spring:message code='store.add'/>",
											width : '1100px',
											url : basePath + "/sys/store/form"
										});
								break;
							case 'toBoundTerm':
								$.ajax({
									url : basePath
											+ "/sys/store/toBoundStoreTerm",
									dataType : "html",
									success : function(res) {
										$("#listForm").html(res);
									}
								});
								break;
							case 'storeEdit':
								if (!storeRowId) {
									modals
											.info('<spring:message code="common.promt.edit"/>');
									return false;
								}
								modals
										.openWin({
											winId : winId,
											title : '<spring:message code="store.edit"/>【'
													+ storeTable
															.getSelectedRowData().name
													+ '】',
											width : '1100px',
											url : basePath
													+ "/sys/store/form?id="
													+ storeRowId
										});
								break;
							case 'storeDelete':
								if (!storeRowId) {
									modals
											.info('<spring:message code="common.promt.delete"/>');
									return false;
								}
								modals
										.confirm({
											cancel_label : "<spring:message code="common.cancel" />",
											title : "<spring:message code="common.sys.confirmTip" />",
											ok_label : "<spring:message code="common.confirm" />",
											text : "<spring:message code="common.confirm.delete" />",
											callback : function() {
												ajaxPost(
														basePath
																+ "/sys/store/delete?id="
																+ storeRowId,
														null,
														function(data) {
															if (data.code == 200) {
																modals
																		.correct({
																			title : '<spring:message code="common.sys.success" />',
																			cancel_label : '<spring:message code="common.confirm" />',
																			text : data.message
																		});
																storeTable
																		.reloadRowData();
															} else {
																modals
																		.warn(date.message);
															}
														});
											}
										});
								break;
							}

						});

	});
	/* 	$(function(){
	 var secSelect = document.getElementById("orgSelect");
	 //var secSelect = $("#orgSelect");
	 secSelect.options.length = 0;
	 $.ajax({
	 url:basePath+'/sys/office/treeData',
	 success:function(dataJson){
	 for ( var i = 0; i < dataJson.length; i++) {
	 var oOption = document.createElement("OPTION");
	 oOption.value = dataJson[i].id;
	 var parent = dataJson[i].parentId;
	 oOption.text = dataJson[i].text;
	 var nodes = dataJson[i].nodes;
	 if(parent!=="0"){
	 $(oOption).attr('parent',parent);
	 }
	 if(nodes===null){
	
	 }else{
	 childs(nodes);
	 }
	 secSelect.options.add(oOption);
	 }
	 }
	 });
	 function childs(nodeses){
	 for ( var i = 0; i < nodeses.length; i++) {
	 var oOption = document.createElement("OPTION");
	 oOption.value = nodeses[i].id;
	 var parent = nodeses[i].parentId;
	 oOption.text = nodeses[i].text;
	 var nodes = nodeses[i].nodes;
	 if(parent!=="0"){
	 $(oOption).attr('parent',parent);
	 }
	 if(nodes===null){
	
	 }else{
	 childs(nodes);
	 }
	 secSelect.options.add(oOption);
	 }
	 }
	 }); */
	function manageTerm(countTerm) {
		var oper = "&nbsp;&nbsp;&nbsp;";
		oper += "<a href='javascript:void(0)'   onclick='toManageTerm()'>"
				+ countTerm + "</a>";
		return oper;
	}
	$("#storeOrgSelectValue")
			.click(
					function() {
						modals
								.openWin({
									winId : "storeOrgTree",
									title : '<spring:message code="modules.device.importing.equipment.by.product.batch"/>',
									width : '300px',
									url : basePath + "/sys/office/toOfficeTree?windowId=storeOrgTree&orgSelect=storeOrgSelect&orgSelectValue=storeOrgSelectValue"
								});
					});
	function toManageTerm() {
		var storeRowId = storeTable.getSelectedRowId();
		if (storeRowId != null && storeRowId !== '') {
			$.ajax({
				url : basePath + '/device/toBoundStoreDevice',
				type : 'POST',
				traditional : true,
				data : {
					'sId' : storeRowId
				},
				success : function(res) {
					$("#listForm").html(res);
				}
			});
		}
	}
</script>
