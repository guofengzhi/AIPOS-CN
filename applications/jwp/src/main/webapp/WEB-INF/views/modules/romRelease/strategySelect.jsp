<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>

<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"><spring:message code="modules.rom.release.strategy.selection"/></h5>
</div>

<!-- Main content -->
<div class="modal-body">
	<div class="row">
		<div class="col-xs-12">
			<div class="box-body">
				<div class="form-horizontal" >
					<div class="form-group">
							<label class="col-sm-2 control-label"><spring:message code="modules.rom.release.strategy"/></label>
							<div class="col-sm-3">
									<select name="strategy" id="strategy"  data-placeholder='<spring:message code="modules.rom.release.please.select.the.strategy"/>' class="form-control select2" style="width: 220px">
										   <option value=""></option>
										   <option value="a"><spring:message code="modules.rom.release.none.strategy"/></option>
										  <c:forEach items="${strategyList}" var="strategy" varStatus="idxStatus">
									      		<option value="${strategy.id}">${strategy.strategyName }</option>
									      </c:forEach>
									</select>
							</div>
						</div>
				</div>
				
				<div class="box-footer text-right">
					<!--以下两种方式提交验证,根据所需选择-->
					<button type="button" class="btn btn-default" data-btn-type="cancel"
						data-dismiss="modal"><spring:message code="common.cancel"/></button>
					 <button type="button" onclick="smtStragy()" class="btn btn-primary"><spring:message code="common.submit"/></button>
				</div>
				<!-- /.box-body -->
			</div>
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</div>

<script>

$(function() {
	$("#strategy").select2();
});

function smtStragy() {
	
	var strategyId = $("#strategy").val();
	if (strategyId != null && strategyId != '') {
		parent.window.selectedStragy(strategyId);
	} else {
		modals.info('<spring:message code="modules.rom.release.please.select.the.strategy"/>');
	}
}
	
</script>

