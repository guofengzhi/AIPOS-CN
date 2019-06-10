<%@page import="javax.validation.ConstraintViolation"%>
<%@page import="javax.validation.ConstraintViolationException"%>
<%@page import="org.springframework.validation.BindException"%>
<%@page import="org.springframework.validation.ObjectError"%>
<%@page import="org.springframework.validation.FieldError"%>
<%@page import="org.slf4j.LoggerFactory"%>
<%@page import="com.jiewen.jwp.common.Exceptions"%>
<%@page import="com.jiewen.jwp.common.StringUtils"%>
<%@page import="com.jiewen.jwp.base.web.ServletsUtils"%>
<%@page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
<%@include file="/WEB-INF/views/common/taglib.jsp"%>
<%
response.setStatus(400);

// 获取异常类
Throwable ex = Exceptions.getThrowable(request);

// 编译错误信息
StringBuilder sb = new StringBuilder("错误信息：\n");
if (ex != null) {
	if (ex instanceof BindException) {
		for (ObjectError e : ((BindException)ex).getGlobalErrors()){
			sb.append("☆" + e.getDefaultMessage() + "(" + e.getObjectName() + ")\n");
		}
		for (FieldError e : ((BindException)ex).getFieldErrors()){
			sb.append("☆" + e.getDefaultMessage() + "(" + e.getField() + ")\n");
		}
		LoggerFactory.getLogger("400.jsp").warn(ex.getMessage(), ex);
	}else if (ex instanceof ConstraintViolationException) {
		for (ConstraintViolation<?> v : ((ConstraintViolationException)ex).getConstraintViolations()) {
			sb.append("☆" + v.getMessage() + "(" + v.getPropertyPath() + ")\n");
		}
	} else {
		//sb.append(Exceptions.getStackTraceAsString(ex));
		sb.append("☆" + ex.getMessage());
	}
} else {
	sb.append("未知错误.\n\n");
}

// 如果是异步请求或是手机端，则直接返回信息
//
if (ServletsUtils.isAjaxRequest(request)) {
	out.print(sb);
}

// 输出异常信息页面
else {
%>
<div class="error-page">
	<div class="error-content">
		<h3>
			<i class="fa fa-warning text-danger"></i> <spring:message code="sys.exception.400.param"/>
		</h3>
		<%=StringUtils.toHtml(sb.toString())%>
	</div>
	<!-- /.error-content -->
</div>
<%
} out = pageContext.pushBody();
%>