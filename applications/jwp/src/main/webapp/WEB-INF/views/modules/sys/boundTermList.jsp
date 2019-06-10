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
				<!-- /.box-header -->
				<div>&nbsp;</div>
				<div id="userSearchDiv" class="form-horizontal" role="form">
					<div class="form-group" style="margin: 1em;">
						<label class="col-sm-2 control-label">商户：</label>
						<div class="col-sm-3">
							<select name="merId" id="selectunmerchants"
								data-placeholder='<spring:message code="app.release.please.choose.the.industry"/>'
								class="form-control select2" style="width: 231px">
								<option value=""></option>
								<c:forEach items="${merchants}" var="merchant"
									varStatus="idxStatus">
									<option value="${merchant.merId}">${merchant.merName}</option>
								</c:forEach>
							</select>
						</div>
						<label class="col-sm-2 control-label">设备：</label>
						<div class="col-sm-3">
							<%-- <select name="deviceSn" id="selectunBoundTermSn"
								data-placeholder='<spring:message code="app.release.please.choose.the.industry"/>'
								class="form-control select2" style="width: 231px">
								<option value=""></option>
								<c:forEach items="${unBoundTerms}" var="unBoundTerm"
									varStatus="idxStatus">
									<option value="${unBoundTerm.deviceSn}">${unBoundTerm.deviceType}&nbsp;&nbsp;${unBoundTerm.deviceSn}</option>
								</c:forEach>
							</select> --%>
							<input name="deviceSn" id="deviceSn" class="form-control" type="text"/>
						</div>
					</div>
					<div class="form-group" style="margin: 1em;">
						<label  class="col-sm-2 control-label">查询范围：</label>
						<div class="col-sm-3">
							<select  id="listMode" name="boundState" class="form-control select2" style="width: 231px">
								<option value="">全部</option>
								<option value="0">未绑定</option>
								<option value="1">已绑定</option>
							</select>
						</div>
					</div>
					<div class="box-footer">
						<div class="text-center">
							<button type="button" class="btn btn-primary"
								data-btn-type="search">查询</button>
								&nbsp;&nbsp;&nbsp;&nbsp;
							<button type="button" class="btn btn-primary"
								data-btn-type="boundTerm">绑定</button>
						</div>
					</div>
				</div>
				<div class="dataTables_filter" style="float: left">
					<div class="btn-group col-sm-12">
						<shiro:hasPermission name="sys:merchant:edit">
							<%-- <button type="button" class="btn btn-success" data-btn-type="merchantAdd"><spring:message code="common.add"/></button>
							<button type="button" class="btn btn-success"
								data-btn-type="merchantEdit"><spring:message code="common.edit"/></button>
							<button type="button" class="btn btn-danger"
								data-btn-type="merchantDelete"><spring:message code="common.delete"/></button> --%>
						</shiro:hasPermission>
					 </div>
                  </div>
			<%-- 	<div class="dataTables_filter" style="float: right">
					<div class="btn-group col-sm-12">
						<shiro:hasPermission name="sys:merchant:edit">
							<div class="btn-group">
								<button type="button" class="btn btn-success"
									data-btn-type="batchBoundTerm">批量綁定設備</button>
							</div>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<div class="btn-group">
								<button type="button" class="btn btn-success"
									data-btn-type="batchUnBoundTerm">批量解綁設備</button>
							</div>
						</shiro:hasPermission>
					</div>
				</div> --%>
				<div class="box-body">
					<table id="boundTerm_table"
						class="table table-bordered table-bg table-striped table-hover">
					</table>
				</div>
			</div>
		</div>
	</div>
</section>

<script>
	//tableId,queryId,conditionContainer
	var boundTermTable;
	var winId = "boundTermWin";
	$(function() {
		//查询框是否在一行设置
		var config = {
			resizeSearchDiv : false,
			language : {
				url : basePath + '<spring:message code="common.language"/>'
			}
		};
		
		//init table and fill data
			boundTermTable = new CommonTable("boundTerm_table", "boundTermTable",
					"userSearchDiv", "/sys/merchant/boundTermList", config);
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var merchantRowId = boundTermTable
									.getSelectedRowId();
							switch (action) {
							case 'boundTerm':
								
								var mer = $('#selectunmerchants');
								var deviceSn = $('#deviceSn');

								
								var merId = mer.val();
								var merName =  mer.text();
								if(deviceSn===""){
									modals.info("终端号不能为空！");
									return false;
								} 
								if(merId===""){
									modals.info("请选择商户！");
									return false;
								} 
								ajaxPost(basePath + "/sys/merchant/boundOneTerm?merId="+ merId+"&sn="+deviceSn, null, function(data) {
									if (data.code == 200) {
										modals.correct({
											title:'<spring:message code="common.sys.success" />',
											cancel_label:'<spring:message code="common.confirm" />',
											text:'绑定成功！'});
										boundTermTable.reloadRowData();
									} else {
										modals.warn(date.message);
									}
								});
								break;
							case 'batchBoundTerm':
								modals
								.openWin({
									winId : winId,
									title : '批量绑定终端',
									width : '900px',
									url : basePath+ "/sys/merchant/toBatchBoundTerm"
								});
								break;
							case 'batchUnBoundTerm':
								modals
								.openWin({
									winId : winId,
									title : '批量解绑终端',
									width : '900px',
									url : basePath+ "/sys/merchant/toBatchUnBoundTerm"
								});
								break;
							}
						});
	});
	function unBound(id){	
		var oper = "&nbsp;&nbsp;&nbsp;";
		oper += "<a href='javascript:void(0)' class='btn btn-sm btn-primary'  onclick='unBoundTerm(\"" + id +"\")'>"+'<spring:message code="unBound.term"/>'+"</a>";
        return oper;
	}
	function check(id){	
		var oper = "&nbsp;&nbsp;&nbsp;";
		oper += "<input type='checkBox' onclick='sss(\"" + id +"\")'>"+"</input>";
        return oper;
	}
	function unBoundTerm(id){
		$
		.ajax({
			url : basePath
					+ "/sys/merchant/unBoundTerm?id="
					+ id,
			success : function() {
				modals
						.correct({
							title : '<spring:message code="common.sys.success" />',
							cancel_label : '<spring:message code="common.confirm" />',
							text : '解绑成功'
						});
				boundTermTable.reloadRowData();
			}
		});
	}
	function sss(id){
	}
</script>
