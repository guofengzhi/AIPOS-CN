<%@ page contentType="text/html;charset=UTF-8"%>

<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<!-- Main content -->
<section class="content">
    <div class="row">
        <div class="col-sm-12">
				<div class="ibox-content">
					<form class="form-horizontal m-t" id="signupForm">
						<div class="form-group">
							<label class="col-sm-3 control-label"><spring:message code="sys.selectTable.Author"/>：</label>
							<div class="col-sm-8">
								<input id="author" name="author" class="form-control"
									type="text" value="${property.author}">
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 control-label"><spring:message code="workflow.user.email"/>：</label>
							<div class="col-sm-8">
								<input id="email" name="email" class="form-control" type="text"
									value="${property.email}" >
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 control-label"><spring:message code="sys.selectTable.PackAge"/>：</label>
							<div class="col-sm-8">
								<input id="packPath" name=packPath class="form-control"
									type="text" value="${property.packPath}">
							</div>
						</div>
						<div class="form-group">
							<div class="col-sm-8 col-sm-offset-3">
								<button type="submit" class="btn btn-primary" onCLick="update()"><spring:message code="common.submit"/></button>
							</div>
						</div>
					</form>
				</div>
			</div>
        <!-- /.col -->
    </div>
    <!-- /.row -->
</section>

<script>
function update() {
	$.ajax({
		cache : true,
		type : "POST",
		url :  basePath + "/generator/update",
		data : $('#signupForm').serialize(),// 你的formid
		async : false,
		error : function(request) {
			parent.layer.alert('<spring:message code="sys.selectTable.NetWorkConnectionTimeOut"/>'); 
		},
		success : function(data) {
			if (data.code == 200) {
				parent.layer.alert('<spring:message code="common.sys.success" />');
				
			} else {
				parent.layer.alert('<spring:message code="common.sys.failure" />');
			}

		}
	});

}
 </script>
 