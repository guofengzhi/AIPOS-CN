<%@page import="com.jiewen.jwp.common.Exceptions"%>
<%@page import="com.jiewen.jwp.common.StringUtils"%>
<%@page import="com.jiewen.jwp.base.web.ServletsUtils"%>
<%@page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
<%@include file="/WEB-INF/views/common/taglib.jsp"%>
<%
response.setStatus(403);

//获取异常类
Throwable ex = Exceptions.getThrowable(request);

// 如果是异步请求或是手机端，则直接返回信息
//
if (!ServletsUtils.isAjaxRequest(request)) {
	if (ex!=null && StringUtils.startsWith(ex.getMessage(), "msg:")){
		out.print(StringUtils.replace(ex.getMessage(), "msg:", ""));
	}else{
		out.print("操作权限不足.");
	}
}

//输出异常信息页面
else {
%>
<div class="error-page">
	<div class="error-content">
		<h3>
			<i class="fa fa-warning text-danger"></i> <spring:message code="sys.exception.403.authorize"/>
		</h3>
		<%
		    if (ex != null) {
		            out.print("<p>" + StringUtils.replace(ex.getMessage(), "msg:", "")
		                    + " <br/> <br/></p>");
		        }
		%>
	</div>
	<!-- /.error-content -->
</div>
<%
} out = pageContext.pushBody();
%>