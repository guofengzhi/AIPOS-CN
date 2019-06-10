<%@page import="com.jiewen.jwp.common.utils.Exceptions"%>
<%@page import="com.jiewen.jwp.common.utils.StringUtils"%>
<%@page import="com.jiewen.base.common.web.ServletsUtils"%>
<%@page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
<%
response.setStatus(404);

// 如果是异步请求或是手机端，则直接返回信息
if (ServletsUtils.isAjaxRequest(request)) {
	out.print("页面不存在.");
}
else {
%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<head>
<title>404 - 页面不存在</title>
</head>
<body>
	<div class="container-fluid">
		<div class="page-header">
			<h1>页面不存在.</h1>
		</div>
	</div>
	<%
out.print("<!--"+request.getAttribute("javax.servlet.forward.request_uri")+"-->");
} out = pageContext.pushBody();
%>