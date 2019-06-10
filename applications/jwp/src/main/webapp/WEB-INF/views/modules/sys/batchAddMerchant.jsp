<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<link rel="stylesheet" href="${ctxStatic}/common/libs/webuploader/webuploader.css">
<script src="${ctxStatic}/common/libs/webuploader/webuploader.js"></script>
<spring:message code="ota.table.client" var="tableClient" />
<style>
.col-sm-3 {
	width: 23%;
}
</style>

<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title">
		<spring:message
			code="modules.device.business.system.importing.equipment" />
	</h5>
</div>

<div class="modal-body">
	<div class="box-body">
		<button class="btn btn-info btn lg text-center" id="downLoadMerTemp">
			下载批量导入商户模板
		</button>
		<div id="uploader" class="wu-example">
			<!--用来存放文件信息-->
			<div id="thelist" class="uploader-list"></div>
			<div class="btns">
				<div id="picker"><spring:message code="app.release.select.file"/></div>
				<button id="ctlBtn" class="btn btn-default">
					<spring:message code="app.release.start.uploading" />
				</button>
			</div>
		</div>
		<div class="box-footer text-right">
			<button type="button" class="btn btn-default" data-btn-type="cancel"
				data-dismiss="modal">
				<spring:message code="common.cancel" />
			</button>
		</div>
	</div>
</div>

<script>
$("#downLoadMerTemp").click(function() {
	$.download(basePath + "/sys/merchant/downloadMerchantTemplate", "post", "");
})
	$(function() {
		var $ = jQuery, $list = $('#thelist'), $btn = $('#ctlBtn'), state = 'pending', uploader;

		uploader = WebUploader
				.create({

					// swf文件路径
					swf : basePath + '/common/libs/webuploader/Uploader.swf',

					// 文件接收服务端。
					server : basePath + "/sys/merchant/batchAddMerchant",

					// 选择文件的按钮。可选。
					// 内部根据当前运行是创建，可能是input元素，也可能是flash.
					pick : {
						id : '#picker',
						multiple : false
					},
					fileNumLimit : 1,

					// 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
					resize : false,
					accept : {
						title : 'EXCEL',
						extensions : 'xls,xlsx',
						mimeTypes : 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
					},
					duplicate : false
				});

		// 当有文件被添加进队列的时候
		uploader
				.on(
						'fileQueued',
						function(file) {
							var commondelete = '${commondelete}';
							var waitUploading = '${waitUploading}';
							var $li = $('<div id="' + file.id + '" class="item">'
									+ '<button class="close" title="'+commondelete+'"><li class="fa fa-remove"></li></button> <h4 class="info">'
									+ file.name
									+ '</h4>'
									+ '<p class="state">'
									+ waitUploading + '</p>' + '</div>');
							$list.append($li);
							$('.close').on('click', function() {
								//将文件移除上传序列
								uploader.removeFile(file, true);
								var $li = $('#' + file.id);
								$li.off().remove();
							});
						});

		// 文件上传过程中创建进度条实时显示。
		uploader
				.on(
						'uploadProgress',
						function(file, percentage) {
							var $li = $('#' + file.id), $percent = $li
									.find('.progress .progress-bar');

							// 避免重复创建
							if (!$percent.length) {
								$percent = $(
										'<div class="progress progress-striped active">'
												+ '<div class="progress-bar" role="progressbar" style="width: 0%">'
												+ '</div>' + '</div>')
										.appendTo($li).find('.progress-bar');
							}

							$li
									.find('p.state')
									.text(
											'<spring:message code="app.release.uploading"/>');

							$percent.css('width', percentage * 100 + '%');
						});

		uploader.on('uploadSuccess', function(file, response) {

			if (response.code == 200) {
				modals.correct(response.message);
				modals.hideWin(winId);
				deviceTable.reloadRowData();
			}
			$('#' + file.id).find('p.state').text(response.message);

		});

		uploader
				.on(
						'uploadError',
						function(file, response) {
							$('#' + file.id)
									.find('p.state')
									.text(
											'<spring:message code="modules.device.upload.error.please.check.the.file.is.correct"/>');
						});

		uploader.on('error', function(handler) {
			//alert(handle);
		});

		uploader.on('uploadComplete', function(file) {
			$('#' + file.id).find('.progress').fadeOut();
		});
		uploader
				.on(
						'all',
						function(type) {
							if (type === 'startUpload') {
								state = 'uploading';
							} else if (type === 'stopUpload') {
								state = 'paused';
							} else if (type === 'uploadFinished') {
								state = 'done';
							}

							if (state === 'uploading') {
								$btn
										.text('<spring:message code="app.release.pause.upload"/>');
							} else {
								$btn
										.text('<spring:message code="app.release.start.uploading"/>');
							}

						});

		$btn.on('click', function() {
			if (state === 'uploading') {
				uploader.stop();
			} else {
				uploader.upload();
			}
		});
	});
</script>

