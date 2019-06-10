<%@page import="com.jiewen.jwp.common.Exceptions"%>
<%@page import="com.jiewen.jwp.common.StringUtils"%>
<%@page import="com.jiewen.jwp.base.web.ServletsUtils"%>
<%@page import="org.slf4j.LoggerFactory"%>
<%@page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
<%@include file="/WEB-INF/views/common/taglib.jsp"%>
<%
response.setStatus(500);
// 获取异常类
Throwable ex = Exceptions.getThrowable(request);
if (ex != null){
	LoggerFactory.getLogger("500.jsp").error(ex.getMessage(), ex);
}

// 编译错误信息
StringBuilder sb = new StringBuilder("错误信息：\n");
if (ex != null) {
	sb.append(Exceptions.getStackTraceAsString(ex));
} else {
	sb.append("未知错误.\n\n");
}

// 如果是异步请求或是手机端，则直接返回信息
if (ServletsUtils.isAjaxRequest(request)) {
	out.print(sb);
}
// 输出异常信息页面
else {
%>
<div class="error-page">
	<div class="error-content">
		<h3>
			<i class="fa fa-warning text-danger"></i> <spring:message code="sys.error.500.sysError" />.
		</h3>
		<div class="errorMessage">
			<spring:message code="sys.error.500.errorMsg" />
			<c:if test="ex == null">
			<spring:message code="sys.error.unknowError" />
			</c:if>
			<c:if test="ex != null">
			<%=StringUtils.toHtml(ex.getMessage())	%>	
			</c:if>
			<br /> <br /> <spring:message code="sys.error.500.tipSendMsg" /><br /> <br /> 
			&nbsp; <a href="javascript:" onclick="$('.errorMessage').toggle();"
				class="btn"><spring:message code="sys.error.500.sysError" />
				<spring:message code="sys.error.500.tipDetailMsg" />
				</a>
		</div>
		<div class="errorMessage" style="display: none">
			<%=StringUtils.toHtml(sb.toString())%>
			<br /> <a href="javascript:" onclick="$('.errorMessage').toggle();"
				class="btn"><spring:message code="sys.error.500.sysError" /><spring:message code="sys.error.500.tipHIdeDetailMsg" /></a> <br /> <br />
		</div>
	</div>
	<!-- /.error-content -->
</div>
<%
} out = pageContext.pushBody();
%>