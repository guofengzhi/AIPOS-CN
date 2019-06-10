<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<!-- Content Header (Page header) -->
<div id="listForm">
	<section class="content-header">
		<ol class="breadcrumb">
			<li><a href="${basePath}"><i class="fa fa-dashboard"></i>
				<spring:message code="common.homepage" /></a></li>
			<li><a href="#"><spring:message code="common.sys.management" /></a></li>
			<li class="active"><spring:message
					code="sys.merchant.management" /></li>
		</ol>
		<div class="col-sm-12"></div>
	</section>

	<!-- Main content -->
	<section class="content">
		<div class="row">
			<div class="col-xs-12">
				<div class="box">
					<div id="merchantSearchDiv" class="dataTables_filter" style="text-align: left;" role="form">
							<div class="has-feedback form-group">
								<input id="merOrgSelect" style="width: 226.5px;" name="orgId" class="form-control"  type="hidden"/>
								<input id="merOrgSelectValue" style="width: 226.5px;margin-left:0px;" name="orgIdValue" class="form-control" type="text" placeholder='<spring:message code="please.select.organ" />'/>
							</div>

							<div class="has-feedback form-group">
								<select id="selectMerchants" style="width: 226.5px;" name="merId" class="form-control select2" data-placeholder='<spring:message code="please.select.merchant" />'
										style="width: 100%;">
									<option value=""></option>
									<option value="0"><spring:message code="all" /></option>
								</select>
							</div>
						<div class="btn-group">
							<button type="button" class="btn btn-primary"
									data-btn-type="search">
									<spring:message code="common.query" />
								</button>
								<button type="button" class="btn btn-default" id="reset"
									data-btn-type="reset">
									<spring:message code="common.reset" />
								</button>
						</div>
						<!-- <div class="col-sm-12 form-group" style="float: right;margin-top:10px;margin-right:-15px;"> -->
						<div style="width:100%;margin-top:5px;">
							<shiro:hasPermission name="sys:merchant:edit">
								<button type="button" class="btn btn-primary" style="float:left;"
									data-btn-type="merchantBatchAdd"><spring:message code="batch.import.merchant"/></button>
							<button type="button" class="btn btn-default" style="float: right;"
								data-btn-type=merchantDelete title="<spring:message code='delete'/>">
								<i class="fa fa-remove"></i>
							</button>
							<button data-btn-type="merchantEdit" class="btn btn-default" style="float: right;"
								title="<spring:message code='edit'/>" type="button">
								<i class="fa fa-edit"></i>
							</button>
							<button data-btn-type="merchantAdd" class="btn btn-default" style="float: right;"
								title="<spring:message code='add'/>" type="button">
								<i class="fa fa-plus"></i>
							</button>
							</shiro:hasPermission>
						</div>
					</div>
					<div class="box-body">
						<table id="merchant_table"
							class="table table-bordered table-bg table-striped table-hover" style="margin-top:0px !important;">
						</table>
					</div>
				</div>
			</div>
			<!-- /.col -->
		</div>
		<!-- /.row -->
	</section>
</div>
<script>
	//tableId,queryId,conditionContainer
	var merchantTable;
	var winId = "merchantWin";
	$("#reset").click(function(){
		 $("select").select2().val("");
		 var secSelect = document.getElementById("selectMerchants");
		 secSelect.options.length = 0;
	});
	$(function() {
		 //$("#orgSelect").select2();
		 $("#selectMerchants").select2();
		//查询框是否在一行设置
		var config = {
			resizeSearchDiv : false,
			language : {
				url : basePath + '<spring:message code="common.language"/>'
			}
		};
		//init table and fill data
		merchantTable = new CommonTable("merchant_table", "merchantTable",
				"merchantSearchDiv", "/sys/merchant/list", config);
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var merchantRowId = merchantTable
									.getSelectedRowId();
							switch (action) {
							case 'merchantAdd':
								modals
										.openWin({
											winId : winId,
											title : '<spring:message code="add.merchant"/>',
											width : '1000px',
											url : basePath
													+ "/sys/merchant/form"
										});
								break;
							case 'merchantBatchAdd':
								modals
										.openWin({
											winId : winId,
											title : '<spring:message code="batch.import.merchant"/>',
											width : '900px',
											url : basePath
													+ "/sys/merchant/toBatchAddMerchant"
										});
								break;
							case 'merchantEdit':
								if (!merchantRowId) {
									modals
											.info('<spring:message code="common.promt.edit"/>');
									return false;
								}
								modals
										.openWin({
											winId : winId,
											title : '<spring:message code="sys.merchant.edit"/>【'
													+ merchantTable
															.getSelectedRowData().merName
													+ '】',
											width : '1000px',
											url : basePath
													+ "/sys/merchant/form?id="
													+ merchantRowId
										});
								break;
							case 'merchantDelete':
								if (!merchantRowId) {
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
																+ "/sys/merchant/delete?id="
																+ merchantRowId,
														null,
														function(data) {
															if (data.code == 200) {
																modals
																		.correct({
																			title : '<spring:message code="common.sys.success" />',
																			cancel_label : '<spring:message code="common.confirm" />',
																			text : data.message
																		});
																merchantTable
																		.reloadRowData();
															} else {
																modals
																		.warn(date.message);
															}
														});
											}
										});
								break;
							case 'toBoundTerm':
								$.ajax({
									url : basePath
											+ "/sys/merchant/toBoundTerm",
									dataType : "html",
									success : function(res) {
										$("#listForm").html(res);
									}
								});
								break;
							case 'merTermUnBoundImport':
								modals
										.openWin({
											winId : winId,
											title : '<spring:message code="modules.device.importing.equipment.by.product.batch"/>',
											width : '1200px',
											url : basePath
													+ "/sys/merchant/merTermUnBoundImport"
										});
								break;
							}

						});

	});
	/* class='btn btn-sm btn-primary' */
	function manageTerm(countTerm) {
		var oper = "&nbsp;&nbsp;&nbsp;";
		oper += "<a href='javascript:void(0)'   onclick='toManageTerm()'>"
				+ countTerm + "</a>";
		return oper;
	}
	function toManageTerm() {
		var merchantRowId = merchantTable.getSelectedRowId();
		if(merchantRowId != null && merchantRowId !==''){
			$.ajax({
				url:basePath+'/device/toBoundDevice',
				type:'POST',
				traditional:true,
				data:{'mId':merchantRowId},
				success:function(res){
					$("#listForm").html(res);
				}
			});
		}
	}
	/* $(function() {
		var secSelect = document.getElementById("orgSelect");
		//secSelect.options.length = 0;
		$.ajax({
			url : basePath + '/sys/office/treeData',
			success : function(dataJson) {
				for (var i = 0; i < dataJson.length; i++) {
					var oOption = document.createElement("OPTION");
					oOption.value = dataJson[i].id;
					var parent = dataJson[i].parentId;
					oOption.text = dataJson[i].text;
					var nodes = dataJson[i].nodes;
						$(oOption).attr('parent', parent);
					if (nodes == null) {

					} else {
						childs(nodes);
					}
					secSelect.options.add(oOption);
				}
			}
		});
		function childs(nodeses) {
			for (var i = 0; i < nodeses.length; i++) {
				var oOption = document.createElement("OPTION");
				oOption.value = nodeses[i].id;
				var parent = nodeses[i].parentId;
				oOption.text = nodeses[i].text;
				var nodes = nodeses[i].nodes;
				if (parent !== "0") {
					$(oOption).attr('parent', parent);
				} 
				if (nodes == null) {

				} else {
					childs(nodes);
				}
				secSelect.options.add(oOption);
			}
		}
	}); */

	$(function(){
		$("#merOrgSelectValue").click(function(){
					modals
					.openWin({
						winId : "merOrgTree",
						title : '<spring:message code="modules.device.importing.equipment.by.product.batch"/>',
						width : '300px',
						url : basePath
								+ "/sys/office/toOfficeTree?windowId=merOrgTree&orgSelect=merOrgSelect&orgSelectValue=merOrgSelectValue"
					});
	});
	/* $("#orgSelect").change(function(){
			var secSelect = document.getElementById("selectMerchants");
			var orgId = this.value;
			secSelect.options.length = 0;
			$.ajax({
				url:basePath+'/sys/merchant/merchants?orgId='+orgId,
				success:function(res){
					 var dataJson = res.data;
					 for ( var i = 0; i < dataJson.length; i++) {
						 var oOption = document.createElement("OPTION");
					        oOption.value = dataJson[i].merId;
					        oOption.text = dataJson[i].merName;
					        secSelect.options.add(oOption);
					 }
				}
			});
		}); */
});
</script>
