<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<!DOCTYPE html>
<html>
<div class="modal-body">

<section class="content">
    <div class="row form-horizontal">
        <div class="col-sm-12">
            <div class="box box-primary">
                <div class="box-header bg-info" style="padding-bottom: 0">
                    <div class="row" style="padding-bottom:5px;">
                        <div class="col-sm-7">
                            <div clas="form-group">
                              <input class="form-control" type="text" id="title" placeholder='<spring:message code="sys.essay.inputTitle"/>……'>
                            </div>
                        </div>
                        <div class="col-sm-5">
                            <div clas="form-group">
                                <input  type="text" id="keyWords" data-role="tagsinput" placeholder='<spring:message code="sys.essay.inputKeyWords"/>' >
                            </div>
                        </div>
                    </div>
                    <div class="row">
                       <div class="form-group col-sm-7">
                        <div class="col-sm-4">
                            <select id="editormd-theme-select" class="form-control select2">
                                <option selected="selected" value=""><spring:message code="sys.essay.toolStyle"/></option>
                            </select>
                        </div>
                        <div class="col-sm-4">
                            <select id="editor-area-theme-select" class="form-control select2">
                                <option selected="selected" value=""><spring:message code="sys.essay.editStyle"/></option>
                            </select>
                        </div>
                        <div class="col-sm-4">
                            <select id="preview-area-theme-select" class="form-control select2">
                                <option selected="selected" value=""><spring:message code="sys.essay.previewStyle"/></option>
                            </select>
                        </div>
                    </div>
                       <div class="form-group col-sm-5 pull-right">
                        <div class="col-sm-6">
                            <label class="control-label">
                                <input type="checkbox" name="autoHeight" data-flag="icheck" class="square-green"
                                       id="autoHeight"> <spring:message code="sys.essay.adaptHeight"/>
                            </label>
                            <input type="hidden" name="id" id="id">
                        </div>
                        <div class="col-sm-6 text-right">
                            <div class="btn-group ">
                                <button class="btn btn-default"  id="backMD"><i class="fa fa-reply">&nbsp;&nbsp;<spring:message code="sys.essay.back"/></i></button>
                                <button class="btn btn-primary"  id="submitMD"><i class="fa fa-save">&nbsp;&nbsp;<spring:message code="common.save"/></i></button>
                            </div>
                        </div>
                    </div>
                    </div>
                </div>
                <div clas="box-body">
                    <div id="editormd">
                        <textarea style="display:none;"></textarea>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
</div>
</html>

<script>
    var editor;

    $(".select2").select2();
    function themeSelect(id, themes, lsKey, callback) {
        var select = $("#" + id);

        for (var i = 0, len = themes.length; i < len; i++) {
            var theme = themes[i];
            var selected = (localStorage[lsKey] == theme) ? " selected=\"selected\"" : "";

            select.append("<option value=\"" + theme + "\"" + selected + ">" + theme + "</option>");
        }

        select.bind("change", function () {
            var theme = $(this).val();

            if (theme === "") {
                return false;
            }
            localStorage[lsKey] = theme;
            callback(select, theme);
        });

        return select;
    }

    $(function () {
        //---初始化控件-----
        //高度自定义框
        $("#autoHeight").iCheck({
            checkboxClass: 'icheckbox_flat-green',
            radioClass: 'iradio_flat-green'
        });

        var isAutoHeight = localStorage.isAutoHeight ? localStorage.isAutoHeight : false;
        if (isAutoHeight == "false" || !isAutoHeight) {
            $("#autoHeight").iCheck("uncheck");
        } else {
            $("#autoHeight").iCheck("check");
        }
        //高度不自定义时高度
        var clientHeight = (document.body.clientHeight < document.documentElement.clientHeight) ? document.body.clientHeight : document.documentElement.clientHeight;

        $("#autoHeight").on("ifChanged", function (event) {
            isAutoHeight = $("#autoHeight").prop("checked");
            localStorage.isAutoHeight = isAutoHeight;
            if(editor){
                editor.config("autoHeight",isAutoHeight);
                //alert(isAutoHeight+" --> "+clientHeight);
                if(!isAutoHeight)
                    editor.config("height",clientHeight);
            }
        });
        //-----数据回填-------------
        var mid='${id}';
        if(mid!=''){
            $("#title_sm").text('<spring:message code="common.edit"/>');
            ajaxPost(basePath+"/markdown/getEssay/"+mid,null,function(result){
                if(localStorage.mdtitle&&localStorage.mdtitle!=result.data.title){
                    modals.confirm('<spring:message code="sys.essay.formWarn"/>?',function(){
                        fillLocalStorage(result.data);
                        $("#title").val(result.data.title);
                        var a = result.data.keyWords;
                        
                        $("#keyWords").tagsinput("add",result.data.keyWords);
                        editor.setMarkdown(result.data.content);
                    });
                }else{
                    fillLocalStorage(result.data);
                }
                $("#id").val(result.data.id);
            })
        }

        function fillLocalStorage(data){
            localStorage.mdtitle=data.title;
            localStorage.mdkeywords=data.keyWords;
            localStorage.markdownContent=data.content;
        }
        //文章标题
        if(localStorage.mdtitle){
            $("#title").val(localStorage.mdtitle);
        }
        $("#title").on("change",function(event){
            var $title=$(event.target);
            localStorage.mdtitle=$title.val();
        });

        //keyWords 关键字
        $("#keyWords").on("change",function(event){
             var $element=$(event.target);
             var val = $element.val();
             //修复placeholder问题
             if(val){
                 $element.prev(".bootstrap-tagsinput").find("input:eq(0)").attr("placeholder",null);
             }else{
                 $element.prev(".bootstrap-tagsinput").find("input:eq(0)").attr("placeholder",'<spring:message code="sys.essay.keyWords"/>');
             }
            localStorage.mdkeywords=val;
        });
        if(localStorage.mdkeywords){
            //alert(localStorage.mdkeywords);
            $("#keyWords").tagsinput("add",localStorage.mdkeywords);
        }

        //markdown 默认内容
        var markdownContent = null;

        $.ajax({
            type: "get",
            url: basePath + "/common/libs/markdown/readme.md",
            async: false,
            success: function (md) {
                markdownContent = localStorage.markdownContent ? localStorage.markdownContent : md;
            }
        });

        editor = editormd("editormd", {
            width: "100%",
            height: clientHeight,
            theme: (localStorage.theme) ? localStorage.theme : "default",
            previewTheme: (localStorage.previewTheme) ? localStorage.previewTheme : "default",
            editorTheme: (localStorage.editorTheme) ? localStorage.editorTheme : "default",
            path: basePath + '/common/libs/markdown/editor.md/lib/',
            autoHeight: isAutoHeight == "true" ? true : false,

            codeFold : true,
            searchReplace : true,
            saveHTMLToTextarea : true,

            htmlDecode: "style,script,iframe",
            tex: true,
            emoji: true,
            taskList: true,
            flowChart: true,
            sequenceDiagram: true,
            markdown: markdownContent,
            syncScrolling:true,

            //图片上传
            imageUpload: true,
            imageFormats: ["jpg", "jpeg", "gif", "png", "bmp", "webp"],
            imageUploadURL: "/file/markdownUpload",
            onchange: function () {
                localStorage.markdownContent = editor.getMarkdown();
            }
        });


        themeSelect("editormd-theme-select", editormd.themes, "theme", function ($this, theme) {
            editor.setTheme(theme);
        });

        themeSelect("editor-area-theme-select", editormd.editorThemes, "editorTheme", function ($this, theme) {
            editor.setCodeMirrorTheme(theme);
        });

        themeSelect("preview-area-theme-select", editormd.previewThemes, "previewTheme", function ($this, theme) {
            editor.setPreviewTheme(theme);
        });

        //导出pdf
        $("#submitMD").click(function(){
            var obj_md={};
            obj_md["content"]=editor.getMarkdown();
            obj_md["keyWords"]=$("#keyWords").val();
            obj_md["title"]=$("#title").val();
            obj_md["id"]= $("#id").val();
            ajaxPost(basePath+"/markdown/save",obj_md,function(data){
            	if(data.code == 200){
            		modals.info(data.message);
            		returnToList();
				}else{
					modals.warn(data.message);
				}			
            });
        });

        $("#backMD").click(function () {
            returnToList();
        });
    });

    function returnToList(){
        loadPage(basePath+"/markdown/index", true);
    }
</script>
