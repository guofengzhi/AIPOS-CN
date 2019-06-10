﻿<%@ page contentType="text/html;charset=UTF-8"%>
<script type="text/javascript" src="${basePath}/common/libs/avatar/swfobject.js"></script>
<script type="text/javascript" src="${basePath}/common/libs/avatar/fullAvatarEditor.js"></script>
<div class="modal-body">
		<div class="box-body">
			<div style="width: 680px;height:360px;margin: 0 auto;">
				<div>
					<p id="swfContainer">
						本组件需要安装Flash Player后才可使用，请从
						<a href="http://www.adobe.com/go/getflashplayer">这里</a>下载安装。
					</p>
				</div>
			</div>
		</div>
	<div class="box-footer text-right">
		<button type="button" class="btn btn-info btn-sm" data-btn-type="cancel" data-dismiss="modal"><i class="fa fa-remove">&nbsp;&nbsp;取消</i> </button>
	</div>
</div>
<script>

		var swf = new fullAvatarEditor("swfContainer", {
					id: 'swfUploader',
					upload_url: basePath+'/file/avatarUpload',
				   //src_url:avatarPath,
					src_upload:1,
					src_size:"5MB",
					avatar_sizes:"160*160",
					avatar_sizes_desc:"160*160像素",
					browse_tip:"仅支持JPG、JPEG、GIF、PNG格式的图片文件\n文件不能大于5MB",
					src_size_over_limit:'文件大小（{0}）超出限制（5MB）\n请重新上传'
				}, function (msg) {
					switch(msg.code)
					{
							/**
							 case 1 : alert("页面成功加载了组件！");break;
							 case 2 : alert("已成功加载默认指定的图片到编辑面板。");break;
							 case 3 :
							 if(msg.type == 0)
							 {
                                 alert("摄像头已准备就绪且用户已允许使用。");
                             }
							 else if(msg.type == 1)
							 {
                                 alert("摄像头已准备就绪但用户未允许使用！");
                             }
							 else
							 {
                                 alert("摄像头被占用！");
                             }
							 break;
							 **/
						case 5 :
							if(msg.type == 0)
							{
								var isAdd=true;
								if($("#userId").val()!=''&&$("#userId").val()!='0'){
									isAdd=false;
								}
								if(msg.content.sourceUrl)
								{
									modals.correct("头像已成功保存");
									setAvatar(msg.content.msg,msg.content.avatarUrls[i],isAdd);
								}
								for(var i=0;i<msg.content.avatarUrls.length;i++){
									setAvatar(msg.content.msg,msg.content.avatarUrls[i],isAdd);
								}
							}
							else if(msg.type==1){
								modals.error('头像上传失败，原因：' + msg.content.msg);
							}
							else if(msg.type==2){
								modals.error('头像上传失败，原因：指定的上传地址不存在或有问题！');
							}
							else if(msg.type==3){
								modals.error('头像上传失败，原因：发生了安全性错误！请联系站长添加crossdomain.xml到网站根目录。');
							}
								modals.hideWin("avatarWin");
							break;
					}
				}
		);
	});
</script>
