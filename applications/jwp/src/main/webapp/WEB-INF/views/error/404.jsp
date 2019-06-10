<%@page import="com.jiewen.jwp.base.web.ServletsUtils"%>
<%@page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%
response.setStatus(404);

// 如果是异步请求或是手机端，则直接返回信息
if (ServletsUtils.isAjaxRequest(request)) {
	out.print("页面不存在.");
}
else {
%>

<head>
<title><spring:message code="common.sys.success" /></title>
</head>
<body>
	<div class="container-fluid">
		<div class="page-header">
			<h1><spring:message code="sys.error.404.pageNotExsit" /></h1>
		</div>
	</div>
</body>

	<%
out.print("<!--"+request.getAttribute("javax.servlet.forward.request_uri")+"-->");
}
%>