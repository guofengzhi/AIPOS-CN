<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>


<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title">
		<spring:message code="app.information.approval.detail" />
	</h5>
</div>

<!-- Main content -->
<div class="modal-body">
	<div class="row">
		<div class="col-xs-12">
			<div class="box-body">
				<div class="form-horizontal">
					<div class="form-group">
						<label class="col-sm-2 control-label"><spring:message code="app.information.approval.flag" /><span
							style="color: red">*</span></label>
						<div class="col-sm-3">
							<select name=approveFlag id="approveFlag"
								data-placeholder='请选择审批标识'
								class="form-control select2" style="width: 220px"
								onchange="approveFlagOnChange()">
								<c:forEach items="${approveFlagList}" var="approveFlag"
									varStatus="idxStatus">
									<option value="${approveFlag.value}">${approveFlag.label }</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 control-label"><spring:message code="app.information.approval.remarks" /><span
							style="color: red">*</span></label>
						<div class="col-sm-10">
							<textarea name="remarks" id="remarks" class="form-control"
								rows="3" maxlength="250" style="width: 220px"></textarea>
						</div>
					</div>
					<div id="strategyLabel" style="display: block;" class="form-group">
						<label class="col-sm-2 control-label"><spring:message code="app.information.approval.data.scope" /><span
							style="color: red">*</span></label>
						<div class="col-sm-3">
							<select name="appDataScope" id="appDataScope"
								data-placeholder='<spring:message code="app.information.approval.data.scope" />'
								class="form-control select2" style="width: 220px">
								<c:forEach items="${appDataScopeList}" var="appDataScope"
									varStatus="idxStatus">
									<option value="${appDataScope.value}">${appDataScope.label }</option>
								</c:forEach>
							</select>
						</div>
					</div>
				</div>

				<div class="box-footer text-right">
					<!--以下两种方式提交验证,根据所需选择-->
					<button type="button" class="btn btn-default"
						data-btn-type="cancel" data-dismiss="modal">
						<spring:message code="common.cancel" />
					</button>
					<button type="button" onclick="smtStragy()" class="btn btn-primary">
						<spring:message code="common.submit" />
					</button>
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
		$("#appDataScope").select2();
	});

	function smtStragy() {
		var scope = "";
		var flag = $("#approveFlag").val();
		var remarks = $("#remarks").val();
		
		if(flag == '' || flag == null){
			modals.info("<spring:message code='app.information.please.select.approval.flag' />");
			return;
		}
		if(remarks == '' || flag == ''){
			modals.info("<spring:message code='app.information.please.select.approval.remarks' />");
			return;
		}
		
		if(flag == '0'){
			scope = $("#appDataScope").val();
			if (scope == null || scope == '') {
				modals.info("<spring:message code='app.information.please.select.approval.data.scope' />");
				return;
			}
		}
		parent.window.selectedStragy(flag, remarks, scope);
	}

	function approveFlagOnChange() {
		var approveFlag = $("#approveFlag").val();
		if (approveFlag == '0') {
			$("#strategyLabel").show();
		} else {
			$("#strategyLabel").hide();
		}
	}
</script>

