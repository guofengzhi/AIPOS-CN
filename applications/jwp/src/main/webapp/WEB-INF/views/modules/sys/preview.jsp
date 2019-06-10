<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<!DOCTYPE html>
<html>
<div class="modal-body">
<section class="content-header">
    <h1>
        <span><spring:message code="sys.essay.myEssay"/></span>
        <small id="title_sm"><spring:message code="sys.essay.preview"/></small>
    </h1>
    <ol class="breadcrumb">
       <li><a href="${basePath}"><i class="fa fa-dashboard"></i><spring:message code="common.homepage"/></a></li>
		<li class="active"><spring:message code="sys.essay.preview"/></li>
    </ol>
</section>

<section class="content">
    <div class="row form-horizontal">
        <div class="col-md-12">
            <div class="box box-primary">
                <div class="box-header text-center">
                        <div clas="form-group">
                            <label id="title" style="font-size:21px;font-weight:normal"></label>
                        </div>
                        <div clas="form-group">
                            <label style="font-weight: normal"><spring:message code="sys.essay.keyWords"/>：</label>
                            <label id="keywords"></label>
                        </div>
                </div>
                <div clas="box-body">
                    <div id="editormd">
                        <textarea id="append-test" style="display:none;"></textarea>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <div class="navbar-fixed-middle">
        <div class="box box-primary box-solid">
            <div class="box-header with-border">
                <h4 class="box-title" style="padding-right:20px;"><i class="fa fa-hand-o-left">&nbsp;<spring:message code="sys.essay.catalog"/></i></h4>

                <div class="box-tools pull-right">
                    <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
                    </button>
                </div>
                <!-- /.box-tools -->
            </div>
            <!-- /.box-header -->
            <div class="box-body" style="padding-left:0">
                <div  id="custom-toc-container"></div>
            </div>
            <!-- /.box-body -->
        </div>
    </div>
    </div>
    </div>
</section>
<script type="text/javascript" src="${ctxStatic}/common/libs/markdown/editor.md/lib/marked.min.js"></script>
<script type="text/javascript" src="${ctxStatic}/common/libs/markdown/editor.md/lib/prettify.min.js"></script>
<script type="text/javascript" src="${ctxStatic}/common/libs/markdown/editor.md/lib/raphael.min.js"></script>
<script type="text/javascript" src="${ctxStatic}/common/libs/markdown/editor.md/lib/underscore.min.js"></script>
<script type="text/javascript" src="${ctxStatic}/common/libs/markdown/editor.md/lib/sequence-diagram.min.js"></script>
<script type="text/javascript" src="${ctxStatic}/common/libs/markdown/editor.md/lib/flowchart.min.js"></script>
<script type="text/javascript" src="${ctxStatic}/common/libs/markdown/editor.md/lib/jquery.flowchart.min.js"></script>
<script type="text/javascript" src="${ctxStatic}/common/libs/markdown/editor.md/js/editormd.min.js"></script>
<script>
    var editor;
   /* var height=$(document).height();
    $(".navbar-fixed-middle").css({"top":height/2+"px"});
*/
    $(function () {
        var mid = '${id}';
        ajaxPost(basePath + "/markdown/getEssay/" + mid, null, function (data) {
        	var result = data.data;
            $("#title").text(result.title);
            $("#keywords").text(result.keyWords);
            editor = editormd.markdownToHTML("editormd", {
                markdown: result.content,
                htmlDecode: "style,script,iframe",  // you can filter tags decode
                emoji: true,
                tocm:true ,    // Using [TOCM]
                tocContainer: "#custom-toc-container", // 自定义 ToC 容器层
                tocDropdown:true,
                taskList: true,
                tex: true,  // 默认不解析
                flowChart: true,  // 默认不解析
                sequenceDiagram: true // 默认不解析
            });
        });
    });

    function returnToList() {
        loadPage(basePath + "/markdown/list", true);
    }
</script>
