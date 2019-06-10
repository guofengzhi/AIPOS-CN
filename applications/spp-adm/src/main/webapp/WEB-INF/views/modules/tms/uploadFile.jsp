<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<link rel="stylesheet" href="${ctxStatic}/common/libs/webuploader/webuploader.css">
<script src="${ctxStatic}/common/libs/webuploader/webuploader.js"></script>

<div class="modal-body">
	
	<div class="box-body">
		<div id="uploader" class="wu-example">
			<div class="form-horizontal">
				<!-- 厂商 -->
				<label for="manufacturerNo" class="col-sm-2 control-label">
					<spring:message code="tms.table.updateItems.manufactureNo"/>
				<span style="color:red">*</label>
				<div class="col-sm-4">
					<select path="manufacturerNo" id="manufacturerNo1" class="form-control select2"  style="width: 100%;" data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>'>
					      <option value=""></option>
					      <c:forEach items="${manufacturerList}" var="manufacturer"
								varStatus="idxStatus">
								<option value="${manufacturer.manufacturerName}">${manufacturer.manufacturerName }</option>
							</c:forEach>
					</select>
				</div>
				<!-- 文件类型 -->
				<label for="fileType" class="col-sm-2 control-label">
					<spring:message code="tms.file.type"/>
				<span style="color:red">*</label>
				<div class="col-sm-4">
					<select path="fileType" id="fileType1" class="form-control select2"  style="width: 100%;" data-placeholder='<spring:message code="tms.file.type"/>'>
					      <option value=""></option>
					      <c:forEach items="${fns:getDictList('tms_file_type')}" var="manufacturer"
								varStatus="idxStatus">
								<option value="${manufacturer.value}">${manufacturer.label}</option>
							</c:forEach>
					</select>
				</div>
			</div>
			<br/><br/><br/>
			<div class="form-horizontal">
				<!-- 文件版本 -->
				<label for="fileVerion" class="col-sm-2 control-label"><spring:message
						code="tms.table.updateItems.fileVersion" /><span
					style="color: red">*</span></label>
				<div class="col-sm-4">
					<input type="text" htmlEscape="false" class="form-control" autocomplete="off"
						id="fileVersion1" path="fileVersion" placeholder="<spring:message code='please.input.updateItems.version'/>" />
				</div>
			</div>
			<br/><br/><br/>
			<!--用来存放文件信息-->
			<div id="thelist" class="uploader-list"></div>
			<div class="btns">
				<div id="picker">选择文件</div>
				<button id="ctlBtn" class="btn btn-default">开始上传</button>
			</div>
		</div>
	</div>
</div>
<script>

$(function(){
	var $list = $("#thelist"),fileSize,md5;
	var uploader = WebUploader.create({
		
		// swf文件路径
	    swf: basePath + '/common/libs/webuploader/Uploader.swf',
	    // 文件接收服务端。
	    server: basePath+'/tms/updateFiles/saveFile',
	    // 选择文件的按钮。可选。
	    // 内部根据当前运行是创建，可能是input元素，也可能是flash.
	    pick: '#picker',
	    // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
	    resize: false,
	    // 文件个数 
	    fileNumLimit:1
	})
	// 当有文件被添加进队列的时候
	uploader.on( 'fileQueued', function( file ) {
	    $list.append( '<div id="' + file.id + '" class="item">' +
	        '<h4 class="info" id="fileNameArea">' + file.name + '</h4>' +
	        '<p class="state">等待上传...</p>' +
	    '</div>' );
	    
	    //计算文件MD5、文件大小
	    uploader.md5File( file ).then(function(val) {
	    	md5 = val;
	    	fileSize = file.size;
	    }); 
	});
	
	// 文件上传过程中创建进度条实时显示。
	uploader.on( 'uploadProgress', function( file, percentage ) {
	    var $li = $( '#'+file.id ),
	        $percent = $li.find('.progress .progress-bar');

	    // 避免重复创建
	    if ( !$percent.length ) {
	        $percent = $('<div class="progress progress-striped active">' +
	          '<div class="progress-bar" role="progressbar" style="width: 0%">' +
	          '</div>' +
	        '</div>').appendTo( $li ).find('.progress-bar');
	    }

	    $li.find('p.state').text('上传中');
	    $percent.css( 'width', percentage * 100 + '%' );
	});
	
	uploader.on( 'uploadSuccess', function( file, response ) {
	    $( '#'+file.id ).find('p.state').text('已上传');
	    $('.nav-tabs > .active').next('li').find('a').trigger('click');
	    
	    $('#md5').val(md5);
	    $('#fileVersion2').val($('#fileVersion1').val());
	    $('#fileName2').val($('#fileNameArea').text());
	    $('#fileSize2').val(fileSize);
	    $("#manufactureNo2").val($('#manufacturerNo1').val());
	    $('#fileType2').val($('#fileType1').val()).trigger('change');
	    $('#fileType3').val($('#fileType1').val());
	    $('#filePath').val(response.message);
	});

	uploader.on( 'uploadError', function( file ) {
	    $( '#'+file.id ).find('p.state').text('上传出错');
	});

	uploader.on( 'uploadComplete', function( file ) {
	    $( '#'+file.id ).find('.progress').fadeOut();
	});
	
	//点击上传按钮开始上传
	$("#ctlBtn").click(function(){
		if($('#manufacturerNo1').val() == ""){
			modals.info('请先选择厂商！');
	        return false;
		}
		if($('#fileType1').val() == ""){
			modals.info('请先选择文件类型！');
	        return false;
		}
		if($('#fileVersion1').val() == ""){
			modals.info('请先输入文件版本！');
	        return false;
		}
		uploader.options.formData = {
			"fileVersion":$("#fileVersion1").val(),
			"fileType":$("#fileType1").val(),
			"manufactureNo":$('#manufacturerNo1').val()
		};
		uploader.upload();
	});
	
	
})

</script>