<%@ page contentType="text/html;charset=UTF-8"%>
<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"></h5>
</div>
<div class="modal-body">
     <button class="btn btn-info btn lg text-center" id="downLoadMerTemp">下载商户信息模板</button>
	<div class="box-body">
	<form class="form-horizontal bv-form" enctype="multipart/form-data"
					novalidate="novalidate">
					 <input type="hidden"
						name="fileIds" id="fileIds">
					<div class="form-group" id="file_container">
						<input type="file" name="file" id="attachment">
					</div>
	</form>
	</div>
</div>
<script>

$("#downLoadMerTemp").click(function(){
	$.download(basePath + "/agent/merchant/download",
			"post", "");
})

$("#attachment").file({
	title : "请上传附件",
	fileinput : {
		maxFileSize : 10240,
		maxFileCount : 1,
		autoReplace: true
	},
	//如果已经有部分文件(编辑)，在此传文件ids
	fileIdContainer : "[name='fileIds']",
	//showContainer:'#attachment',
	//显示文件类型 edit=可编辑  detail=明细 默认为明细
	//showType:'edit',
	window : false
});
</script>