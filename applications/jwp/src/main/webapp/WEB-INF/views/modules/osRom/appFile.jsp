<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<link rel="stylesheet" href="${ctxStatic}/common/libs/webuploader/webuploader.css">
<script src="${ctxStatic}/common/libs/webuploader/webuploader.js"></script>

<div class="modal-body">
<input type="hidden" id="pathValue"/>
	<div class="box-body">
	    
	    <input id="progressNum" type="hidden" />
		<div id="uploader" class="wu-example">
		
			<div class="form-horizontal">
			<label for="manufacturerNo" class="col-sm-2 control-label"><spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/><span style="color:red">*</label>
			<div class="col-sm-4">
				<select path="manufacturerNo" id="manuNo" class="form-control select2"  style="width: 100%;" data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>'>
				      <option value=""></option>
					  <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
				      		<option value="${manuFacturer.manufacturerNo }">${manuFacturer.manufacturerName }</option>
				      </c:forEach> 
				</select>
			</div>
			</div>
			<br/><br/>
			<br/>		
			<!--用来存放文件信息-->
			<div id="thelist" class="uploader-list"></div>
			<div class="btns">
				<div id="picker"><spring:message code="app.release.select.file"/></div>
				<button id="ctlBtn" class="btn btn-default"><spring:message code="app.release.start.uploading"/></button>
			</div>
		</div>
	</div>

</div>
<script>

$(function(){
	var $ = jQuery,
      $list = $('#thelist'),
      $btn = $('#ctlBtn'),
      state = 'pending',
      uploader;
	  var fileMd5; //文件唯一标识
      /*****下面的参数是自定义的****/
      var fileName; //文件名称
      var fileId; //文件ID
      var oldProgress; //如果该文件之前上传过 已经上传的进度是多少
      var count = 0; //当前正在上传的文件在数组中的下标，一次上传多个文件时使用
      var filesArr = new Array(); //文件数组：每当有文件被添加进队列的时候 就push到数组中
      var map = {}; //key存储文件id，value存储该文件上传过的进度
     
      /********* 监听分块上传过程中的三个时间点 start **********/
      WebUploader.Uploader.register({
          "before-send-file": "beforeSendFile",
          //整个文件上传前 
          "before-send": "beforeSend",
          //每个分片上传前
          "after-send-file": "afterSendFile",
          //分片上传完毕
      },
      {
          //时间点1：//整个文件上传前 调用此函数  
          beforeSendFile: function(file) {
              var deferred = WebUploader.Deferred();
              
              $('#' + file.id).find("p.state").text('<spring:message code="modules.osrom.successful.acquisition.of.file.information"/>');
              deferred.resolve();
              fileName = file.name; //为自定义参数文件名赋值
              fileId = file.id; //为自定义参数文件名赋值
              return deferred.promise();
          },
          //时间点2：如果有分块上传，则每个分块上传之前调用此函数  
          beforeSend: function(block) {
              var deferred = WebUploader.Deferred();
              var param = 'checkChunk';
              ajaxPost(basePath+"/osRom/mergeOrCheckChunks/"+param,{fileName: fileName,
            	  progress : $('#progressNum').val(),
                  fileMd5: fileMd5,
                  //文件唯一标记  
                  chunk: block.chunk,
                  //当前分块下标  
                  chunkSize: block.end - block.start //当前分块大小  
                  },function(data){
                	  if(data.code == 200 ){
                		  if (data.data) {
                              //分块存在，跳过  
                              deferred.reject();
                          } else {
                              //分块不存在或不完整，重新发送该分块内容  
                              deferred.resolve();
                          } 
                	  }else{
                		  modals.error(data.message);
                		  uploader.stop(true);
                		  return;
                	  }
                	  
              });
   
              this.owner.options.formData.fileMd5 = fileMd5;
              deferred.resolve();
              return deferred.promise();
          },
          //时间点3：所有分块上传成功后调用此函数  
          afterSendFile: function(file) {
              //如果分块上传成功，则通知后台合并分块 
              $(".close").hide();
			  $('#' + file.id).find('p.state').text('<spring:message code="modules.osrom.the.file.has.been.uploaded.successfully"/>');
              var param = 'mergeChunks';
              ajaxPost(basePath+'/osRom/mergeOrCheckChunks/'+param,{
                  fileName: fileName,
                  fileMd5: fileMd5,
                  manuNo : $('#manuNo').val()
              },function(data){
            	  if (data.code == 200) {
            		  var manufacturerName = $('#manuNo option:selected').text();//选中的文本
            			var size = parseFloat(data.data.romFileSize);
            			var romFileSize = size / (1.0 * 1024 * 1024);
            			var romSize = '';
            			if (romFileSize >= 1) {
            				  romSize = romFileSize.toFixed(2) + ' M';
            			} else {
            				  romSize = romFileSize = size / (1024 * 1.0);
            				if (romFileSize >= 1) {
            					romSize = romFileSize.toFixed(2) + 'K';
            				} else {
            					romSize = size.toFixed(2) + 'B';
            				}
            			} 
            		    
            		    $('.nav-tabs > .active').next('li').find('a').trigger('click');
            			 $('#filePathId').val(data.data.romPath);
            			 $("#romHash").val(data.data.md5FileValue);
            			 $('#osDeviceType').val(data.data.osDeviceType);
            			 $('#osStartId').val(data.data.osStart);
            			 $('#osEndId').val(data.data.osEnd);
            			 $('#romFileSize').val(size);
            			 $('#romFileSizeMB').val(romSize);
            			 $("#manufacturerNoId").val(data.data.manufacturerNo);
            			 $("#manufacturerName").val(manufacturerName);
            			 $("#clientIdentification").val(data.data.clientIdentification);
                  }
                  count++; //每上传完成一个文件 count+1 
                  if (count <= filesArr.length - 1) {
                      uploader.upload(filesArr[count].id); //上传文件列表中的下一个文件
                  }
                  //合并成功之后的操作 
              });
          }
      });
      /********** 监听分块上传过程中的三个时间点 end ****************/

	   uploader = WebUploader.create({
		   
		//开启分片上传
		chunked: true,
		// 如果要分片，分多大一片？默认大小为5M
        chunkSize: 30 * 1024 * 1024,
        //如果某个分片由于网络问题出错，允许自动重传多少次
        chunkRetry: 3,
        //上传并发数。允许同时最大上传进程数[默认值：3]
        threads: 3,
        //是否重复上传（同时选择多个一样的文件），true可以重复上传
        duplicate: true,
        //上传当前分片时预处理下一分片
        prepareNextFile: true,  
        
        // 禁掉全局的拖拽功能。这样不会出现图片拖进页面的时候，把图片打开。   
        disableGlobalDnd: true,
        

	    // swf文件路径
	    swf: basePath + '/common/libs/webuploader/Uploader.swf',

	    // 文件接收服务端。
	    server: basePath+'/osRom/saveFile',

	    // 选择文件的按钮。可选。
	    // 内部根据当前运行是创建，可能是input元素，也可能是flash.
	    pick: {
	    	id:'#picker',
	    	multiple: false 
	    },
	    fileNumLimit: 1,

	    // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
	    resize: false,
	    accept: {
	    	 title: 'ZIP',
	         extensions: 'zip',
	         mimeTypes: 'application/zip'
	    }
	});
	
	// 当有文件被添加进队列的时候
	uploader.on( 'fileQueued', function( file ) {
		/***如果一次只能选择一个文件，再次选择替换前一个，就增加如下代码********/
        //清空文件队列
        $list.html('');
        //清空文件数组
        filesArr = [];
        /*****如果一次只能选择一个文件，再次选择替换前一个，就增加以上代码*********/
        //将选择的文件添加进文件数组
        filesArr.push(file);
 
        //1、计算文件的唯一标记fileMd5，用于断点续传  如果.md5File(file)
        uploader.md5File(file, 0, file.size).progress(function(percentage) {
        	$list.html('');
            if(percentage<1){
            	$prli = $('<div class="item">' +'<p class="state">'+'<spring:message code="modules.osrom.in.the.calculation.of.file.MD5.information"/>'+ Math.round(percentage * 100) + '%...</p>');
                $list.append($prli);
            }else{
            	$list.html('');
            }
        }).then(function(val) {
        	fileMd5 = val;
            ajaxPost(basePath+"/osRom/selectProgress/"+fileMd5,{},function(data){
            	if(data.data.fileProgress>0){
            		oldProgress = data.data.fileProgress / 100;
            		var progessStyle = 'width:'+ data.data.fileProgress +'%';
            		var $pli= $('<div id="' + file.id + '" class="item">' + '<button class="close btnDelFile" title=""><li class="fa fa-remove"></li></button><h4 class="info">' 
                    		+ file.name + '</h4>' + '<p class="state">'
                    		+ '<spring:message code="modules.osrom.uploaded"/>'
                    		+ data.data.fileProgress + '%</p>' 
                    		+ '<div class="progress progress-striped active">' 
                    		+ '<div class="progress-bar" role="progressbar" style="' 
                    		+ progessStyle + '">' + '</div>' + '</div>' + '</div>')
            		$list.append($pli);
            		 //将上传过的进度存入map集合
                    map[file.id] = oldProgress;
            	}else{
            		var $li = $('<div id="' + file.id + '" class="item">' +
            			      '<button class="close btnDelFile" title='+'<spring:message code="common.delete"/>'+'><li class="fa fa-remove"></li></button> <h4 class="info">' + file.name + '</h4>' +
            			      '<p class="state">'+'<spring:message code="modules.osrom.wait.to.upload"/>'+'</p>' 
            			      +  '</div>') ;
            		 $list.append($li);
            	   }
            });
            
            uploader.stop(true);
    	    $('.btnDelFile').bind('click', function () {
    	    	var fileItem = $(this).parent();
    	        //将文件移除上传序列
    	        uploader.removeFile($(fileItem).attr('id'), true);
    	        $(fileItem).fadeOut(function() {
                    $(fileItem).remove();
                });
    	        //数组中的文件也要删除
                for (var i = 0; i < filesArr.length; i++) {
                    if (filesArr[i].id == $(fileItem).attr('id')) {
                        filesArr.splice(i, 1); //i是要删除的元素在数组中的下标，1代表从下标位置开始连续删除一个元素
                    }
                }
    	       });
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
	    
	  //将实时进度存入隐藏域
        $('#progressNum').val(Math.round(percentage * 100));
        //根据fielId获得当前要上传的文件的进度
        var oldProgressValue = map[file.id];
        
        if (percentage < oldProgressValue && oldProgressValue != 1) {
            $li.find('p.state').text('<spring:message code="app.release.uploading"/>' + Math.round(oldProgressValue * 100) + '%');
            $percent.css('width', Math.round(oldProgressValue * 100) + '%');
        } else {
            $li.find('p.state').text('<spring:message code="app.release.uploading"/>' + Math.round(percentage * 100) + '%');
            $percent.css('width', Math.round(percentage * 100) + '%');
        }
	});

	uploader.on( 'uploadError', function( file, response ) {
		errorUpload = true;
        $btn.text('开始上传');
        uploader.stop(true);
        state = 'paused';
	    $( '#'+file.id ).find('p.state').text('<spring:message code="app.release.error.upload.please.check.the.file.is.correct"/>');
	});
	
	uploader.on( 'uploadSuccess', function( file,response) {
		if(response.code == 200){
			$btn.hide();
			$(".close").hide();
			$('#' + file.id).find('p.state').text('<spring:message code="modules.osrom.the.file.has.been.uploaded.successfully.and.the.system.background.processing.is.successful"/>');
		}else{
			modals.error(response.message);
			uploader.stop(true);
  		    return;
		}
	});

	uploader.on( 'uploadError', function( file, response ) {
		errorUpload = true;
        $btn.text('<spring:message code="app.release.start.uploading"/>');
        uploader.stop(true);
        state = 'paused';
	    $( '#'+file.id ).find('p.state').text('<spring:message code="app.release.error.upload.please.check.the.file.is.correct"/>');
	});
	
	
	uploader.on( 'error', function( handler ) {
	});
	
	
	uploader.on( 'uploadComplete', function( file ) {
		
	    $( '#'+file.id ).find('.progress').fadeOut();
	});
	uploader.on( 'all', function( type ) {
      if ( type === 'startUpload' ) {
          state = 'uploading';
      } else if ( type === 'stopUpload' ) {
          state = 'paused';
      } else if ( type === 'uploadFinished' ) {
          state = 'done';
      }

      if ( state === 'uploading' ) {
          $btn.text('<spring:message code="app.release.pause.upload"/>');
      } else {
          $btn.text('<spring:message code="app.release.start.uploading"/>');
      }
  });

  $btn.on( 'click', function() {
	  if($('#manuNo').val() == ""){
		  modals.info('<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>');
          return false;
	  }
	  if (filesArr.length == 0) {
		  modals.info('<spring:message code="modules.device.select.file"/>');
          return false;
      }
	  currentFileName = filesArr[0].name;
	  if(currentFileName.indexOf(" ") != -1){
		  modals.info('<spring:message code="modules.osrom.the.file.name.is.not.valid.and.there.is.a.space.in.the.name.of.the.file"/>');
		  return false;
	  }
	  currentFileName = currentFileName.replace(".zip", '');
	  var fileNames = currentFileName.split("_");
	  if(fileNames.length != 5) {
		  modals.info('<spring:message code="modules.osrom.uploading.the.file.name.is.not.legal.please.change.the.name.of.the.file"/>');
		  return false;
	  }
	  
      if ( state === 'uploading' ) {
          uploader.stop();
      } else {
    	//当前上传文件的文件名
          var currentFileName;
          //当前上传文件的文件id
          var currentFileId;
          //count=0 说明没开始传 默认从文件列表的第一个开始传
          if (count == 0) {
              currentFileName = filesArr[0].name;
              currentFileId = filesArr[0].id;
          } else {
              if (count <= filesArr.length - 1) {
                  currentFileName = filesArr[count].name;
                  currentFileId = filesArr[count].id;
              }
          }
          //先查询该文件是否上传过 如果上传过已经上传的进度是多少
          ajaxPost(basePath+"/osRom/selectProgress/"+fileMd5,{},function(data){
        	  //如果上传过 将进度存入map
              if (data.data.fileProgress > 0) {
                  map[currentFileId] = data.data.fileProgress / 100;
              }
              //执行上传
              uploader.upload(currentFileId);
          })
      }
  });
})

</script>