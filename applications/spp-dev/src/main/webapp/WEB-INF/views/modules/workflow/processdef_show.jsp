<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
        <li class="fa fa-remove"></li>
    </button>
    <div>&nbsp;</div>
    <!--<h5 class="modal-title"></h5>-->
    <ul class="nav nav-tabs">
        <li class="active"><a href="#tab-content-xml" data-toggle="tab" id="nav-tab-list"><i class="fa fa-list-ul"></i>&nbsp;xml</a></li>
        <li><a href="#tab-content-edit" data-toggle="tab" id="nav-tab-edit"><i class="fa fa-image"></i>&nbsp;png</a></li>
    </ul>
</div>
<div class="modal-body nav-tabs-custom" style="height: 600px;padding: 0px;">

    <div class="tab-content" style="padding: 0px;">
        <div class="tab-pane active" id="tab-content-xml" style="min-height: 600px;border: 1px solid #e0e0e0;">
        </div>

        <div class="tab-pane" id="tab-content-edit">
            <div id="imageContainer" class="text-center" align="center">
                <img src="${ctxStatic}/common/images/admineap.png">
            </div>
        </div>

    </div>
</div>
<script src="${ctxStatic}/common/libs/ace/src-min-noconflict/ace.js"></script>
<script src="${ctxStatic}/common/libs/ace/src-min-noconflict/ext-language_tools.js"></script>
<script>
    var modelId = "${empty modelId?0:modelId}";
    var xmlPath = "${empty xml?0:xml}";
    var imagePath = "${empty image?0:image}";
    var editor_xml;
    ace.require("ace/ext/language_tools");
    //init ace editor
    editor_xml = ace.edit("tab-content-xml");
    editor_xml.setOptions({
        enableBasicAutocompletion: true,
        enableSnippets: true,
        enableLiveAutocompletion: true
    });

    editor_xml.setTheme("ace/theme/xcode");
    editor_xml.session.setMode("ace/mode/xml");
    editor_xml.setAutoScrollEditorIntoView(true);
    editor_xml.setHighlightActiveLine(false);
    editor_xml.setReadOnly(true);

    editor_xml.renderer.setShowPrintMargin(false);
    editor_xml.setFontSize(14);
    if (xmlPath != 0) {
        $.ajax({
            type: "get",
            url: basePath + xmlPath,
            async: false,
            dataType: 'text',
            success: function (xmlContent) {
                //填充xml代码
                editor_xml.setValue(xmlContent);
                editor_xml.clearSelection();
            }
        });
    }
    if (imagePath != 0) {
        $("#imageContainer img").attr("src", basePath + imagePath);
    }


</script>
