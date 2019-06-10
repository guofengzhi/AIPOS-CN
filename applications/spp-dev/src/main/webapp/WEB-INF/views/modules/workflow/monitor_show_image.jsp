<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<div id="imageContainer" class="text-center" align="center">
    <img src="${basePath}/common/images/admineap.png">
</div>

<script>
    var instanceId = "${empty instanceId?0:instanceId}";
    var imagePath = "${empty image?0:image}";
    if (imagePath != 0) {
        $("#imageContainer img").attr("src", basePath + imagePath+"?date="+new Date());
    }
</script>
