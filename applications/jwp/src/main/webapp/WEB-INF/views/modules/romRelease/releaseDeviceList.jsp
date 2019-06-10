<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<link rel="stylesheet"
	href="${ctxStatic}/common/libs/webuploader/webuploader.css">
<script src="${ctxStatic}/common/libs/webuploader/webuploader.js"></script>

<spring:message code="app.release.client" var="releaseClient"/>

<style type="text/css">
.importBtnStyleInit {
	float: right;
	display: inline-block;
}
</style>
<!-- Content Header (Page header) -->
<div class="modal-header modalsbg">
	<button type="button" class="close" data-dismiss="modal"
		aria-hidden="true">
		<li class="fa fa-remove"></li>
	</button>
	<h5 class="modal-title"></h5>
</div>

<!-- Main content -->
<div class="modal-body" id="model">
	<div class="box-body" id="fileImportDiv" style="display: none;">
		<button class="btn btn-info btn lg text-center" id="downLoadMerTemp"><spring:message code="app.release.download.file.information.template"/></button>
		<button class="btn btn-info btn lg text-center"
			onclick="clickCancelBtn()"><spring:message code="app.release.cancel.uploading"/></button>
		<div></div>
		<div id="uploader" class="wu-example">
			<!--用来存放文件信息-->
			<div id="thelist" class="uploader-list"></div>
			<div class="btns">
				<div id="picker"><spring:message code="app.release.select.file"/></div>
				<button id="ctlBtn" class="btn btn-default"><spring:message code="app.release.start.uploading"/></button>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-xs-12">
			<!-- /.box-header -->
			<div class="form-horizontal" id="deviceSearchDiv">
				<div class="form-group" style="margin: 1em;">
					<label class="col-sm-2 control-label" for="industry"><spring:message code="app.release.industry"/></label>
					<div class="col-sm-3">
						<select name="industry" id="industry" data-placeholder='<spring:message code="app.release.please.choose.the.industry"/>'
							onchange="clickIndustry()" class="form-control select2"
							style="width: 100%;">
							<option value=""></option>
							<c:forEach items="${industryList}" var="industry"
								varStatus="idxStatus">
								<option value="${industry.value}">${industry.label }</option>
							</c:forEach>
						</select>
					</div>

					<label class="col-sm-2 control-label" for="clientNo">${releaseClient }</label>
					<div class="col-sm-3">
						<sys:treeselect id="clientNo" name="clientNo"
							value="${client.parentId}" labelName="parentName"
							labelValue="${client.customerName}" title='${releaseClient }'
							url="/client/treeData" industryName="1111"
							extId="${client.customerId}" cssClass="form-control"
							allowClear="true" />
					</div>
				</div>

				<div class="form-group" style="margin: 1em;">

					<label class="col-sm-2 control-label" for="deviceSn"><spring:message code="ota.table.device.sn"/></label>
					<div class="col-sm-3">
						<input placeholder='<spring:message code="ota.table.device.sn"/>' id="deviceSn" name="deviceSn"
							class="form-control" type="search"/>
					</div>
					<label class="col-sm-2 control-label"><spring:message code="ota.table.client.identification"/></label>
					<div class="col-sm-3">
						<select name="clientIdentification" id="clientId"
							data-placeholder='<spring:message code="ota.table.client.identification"/>'
							class="form-control select2" style="width: 100%;">
							<option value=""></option>
							<c:forEach items="${clientIdentifyList}" var="clinetid"
								varStatus="idxStatus">
								<option value="${clinetid.value}">${clinetid.label }</option>
							</c:forEach>
						</select>
					</div>
				</div>

				<div class="box-footer">
					<div class="text-center">
						<button type="button" class="btn btn-primary"
							data-btn-type="search"><spring:message code="common.query"/></button>
						&nbsp; &nbsp;
						<button type="button" class="btn btn-default"
							data-btn-type="reset"><spring:message code="common.reset"/></button>
					</div>
				</div>
			</div>

			<div class="box-body">
				<div class="btn-group">
					<label> <input type="checkbox" id="singleCheckBox" /> <spring:message code="app.release.single.page.submission"/>
					</label> &nbsp;&nbsp; <label> <input type="checkbox"
						id="allCheckBox" /> <spring:message code="app.release.all.page.submissions"/>
					</label>
				</div>
				<div class="btn-group importBtnStyleInit">
					<button type="button" class="btn btn-success"
						onclick="clickImportBtn()"><spring:message code="app.release.import.device.sn.file"/></button>
					<button type="button" class="btn btn-success"
						onclick="clearSnCache()" id="clearSnCacheBtn"
						style="display: none;"><spring:message code="app.release.canceling.file.search"/></button>
				</div>
				<div class="btn-group">
					<span id="availabDeviceCountId"	class="label label-success"></span>
				</div>
				<table id="device_table"
					class="table table-bordered table-striped table-hover">
				</table>
			</div>

			<div class="box-footer text-right">
				<!--以下两种方式提交验证,根据所需选择-->
				<button type="button" class="btn btn-default" data-btn-type="cancel"
					data-dismiss="modal"><spring:message code="common.cancel"/></button>
				<button type="button" onclick="submitDevice()"
					class="btn btn-primary"><spring:message code="common.submit"/></button>
			</div>
			<!-- /.box-body -->

		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</div>

<script>
	var deviceform = $("#deviceSearchDiv").form({
		baseEntity : false
	});
	deviceform.initComponent();
	var deviceTable, winId = "win", straWin = "strategyWin", fileId = "fileId";
	var config = {
		singleSelect : null
	};
	//判断是否页面是否为初始化
	var isInitFlag = true;
	var checkIds = [];
	$(function() {
		
		$("#clientId").select2().val('${clinetId}').trigger("change").attr('disabled',true);
		checkBox();
		clearSnCache();
		//隐藏文件上传div
		$('button[data-btn-type]').click(function() {
			var action = $(this).attr('data-btn-type');
			switch (action) {
			case 'addDevice':
				deviceProcessDef.addDeviceInfo()
				break;
			case 'addBatchDevice': {
				deviceProcessDef.addBatchDeviceInfo();
			}
			default:
				break;
			}
		});
	})
	
	function loadTableSource(deviceSnCount) {
		$("#fileImportDiv").hide();
		$("#importBtn").hide();
		$("#clearSnCacheBtn").show();
		deviceTable.reloadRowData();
		$("#availabDeviceCountId").html($.i18n.prop("modules.rom.release.upload.sn.count",deviceSnCount));
	}
	var $dUploder;
	//导入设备SN文件
	function clickImportBtn() {
		$("#fileImportDiv").show();
		if($dUploder){
			$dUploder.destroy();
		}
		$dUploder= deviceUploader();
		$("#clearSnCacheBtn").show();
	}
	
	//清除文件SN缓存
	function clearSnCache() {
		layer.msg('<spring:message code="app.release.the.device.information.is.being.loaded.please.later"/>', {
			icon : 16,
			tips : [ 1, '#3595CC' ],
			area : [ '330px', '70px' ],
			shade : [ 0.5, '#f5f5f5' ],
			scrollbar : false,
			time : 500000
		});
		var index = layer.index;
		var url = "/osRom/clearDeviceSnCache?romOrApp=ROM";
		 $.when(
				ajaxPostWithDeferred(basePath + url, function(data,
						status) {
				})).done(function(data) {
				layer.close(index);
			if (data.code == 200) {
			if (isInitFlag == true) {
					var romId = '${osRomId}';
					//init table and fill data
					deviceTable = new CommonTable("device_table", "os_device_list",
						"deviceSearchDiv", "/device/noPublishlist?romId=" + romId,
						config);
					isInitFlag = false;
				}else{
				$("#fileImportDiv").hide();
				$("#clearSnCacheBtn").hide();
				$("#availabDeviceCountId").html('');
				deviceTable.reloadRowData();
				}	
			} else {
				modals.info(data.message);
			}
		})
	}
	
	function addCheckBox(id){
		var oper = "";
		if ($("#allCheckBox").prop("checked")) {
			oper += "<div class='checkbox checkbox-success checkbox-inline'><input type='checkbox' id='checked" + id +"'  value='" + id +"' name='box' checked disabled/><label for='checked"+id+"'></label></div>";
		} else if($.inArray(id,checkIds) !=-1) {
			oper += "<div class='checkbox checkbox-success checkbox-inline'><input type='checkbox' id='checked" + id +"' value='" + id +"' name='box' checked onClick='dtCheck(this)' /><label for='checked"+id+"'></label></div>";
		}
		else {
			if($("#singleCheckBox").prop("checked")){
				$("#allCheckBox").iCheck("enable");
				$("#singleCheckBox").iCheck("uncheck");
			}
			oper += "<div class='checkbox checkbox-success checkbox-inline'><input type='checkbox' id='checked" + id +"' value='" + id +"' name='box' onClick='dtCheck(this)'/><label for='checked"+id+"'></label></div>";
		}
        return oper;
	}

	function ajaxProgressDef(url, params) {
		var index = layer.index;
		$.when(
				ajaxPostWithDeferred(basePath + url, params, function(data,
						status) {
				})).done(function(data) {
			layer.close(index);
			if (data.code == 200) {
				modals.hideWin(winId);
				modals.correct(data.message);
			} else {
				modals.info(data.message);
			}
		})
	}
	
	function dtCheck(row){
		checkIds = row.checked?union(checkIds,row.value):difference(checkIds,row.value);
		toastr.options = {
				  "closeButton": true,
				  "positionClass": "toast-top-center",
				  "preventDuplicates": false,
				  "showDuration": "300",
				  "hideDuration": "1000",
				  "timeOut": "5000",
				  "extendedTimeOut": "1000",
				  "showEasing": "swing",
				  "hideEasing": "linear",
				  "showMethod": "fadeIn",
				  "hideMethod": "fadeOut"
				}
		toastr["success"]($.i18n.prop("app.release.devices.have.been.selected.count",deviceSnCount), '<spring:message code="app.release.select.device"/>');
	}
	
	function submitDevice() {
		var ids = '';
		if($("#singleCheckBox").prop("checked")||$("#allCheckBox").prop("checked")){
			ids = $("input[name='box']:checkbox").map(function(){
				if(this.checked)
			      return this.value;
			}).get().join(",");
		}else{
			ids = $.map(checkIds,function(id){
				return id;
			}).join(",");
		}
		
		if (ids == '') {
			modals.info('<spring:message code="app.release.please.select.the.least.one.device"/>');
			return;
		}

		modals.openWin({
			winId : straWin,
			title : '<spring:message code="modules.rom.release.select.strategy"/>',
			width : '600px',
			url : basePath + "/romDevice/strategySelect"
		});

	}
	$("#singleCheckBox").on("ifClicked", function(event) {
		if (event.target.checked) {
			$("input[name='box']:checkbox").iCheck("uncheck");
			$("input[name='box']:checkbox").iCheck("enable");
			$("#allCheckBox").iCheck("enable");
		} else {
			$("input[name='box']:checkbox").iCheck("check");
			$("input[name='box']:checkbox").iCheck("disable");
			$("#allCheckBox").iCheck("disable");
		}
	})

	$("#allCheckBox").on("ifClicked", function(event) {
		if (event.target.checked) {
			$("input[name='box']:checkbox").iCheck("uncheck");
			$("input[name='box']:checkbox").iCheck("enable");
			$("#singleCheckBox").iCheck("enable");
		} else {
			$("input[name='box']:checkbox").iCheck("check");
			$("input[name='box']:checkbox").iCheck("disable");
			$("#singleCheckBox").iCheck("disable");
		}
	})

	function clickIndustry() {
		var value = $("#industry").val();
		$("#industryId").val(value);
	}

	/**
	 * 选择策略后回调该方法进行提交
	 * @param strategyId
	 * @returns
	 */
	function selectedStragy(strategyId) {

		modals.hideWin(straWin);
		var ids = '';
		if($("#singleCheckBox").prop("checked")){
			ids = $("input[name='box']:checkbox").map(function(){
				console.log(this.value)
				if(this.checked)
			      return this.value;
			}).get().join(",");
		}else{
			ids = $.map(checkIds,function(id){
				return id;
			}).join(",");
		}
		layer.msg('<spring:message code="app.release.its.being.released.please.wait.a.little.later"/>', {
			icon : 16,
			tips : [ 1, '#3595CC' ],
			area : [ '250px', '70px' ],
			shade : [ 0.5, '#f5f5f5' ],
			scrollbar : false,
			time : 500000
		});
		//系统版本id
		var romId = '${osRomId}';
		var deviceSn = $("#deviceSn").val();
		var clientNo = $("#clientNo").val();
		var industry = $("#industry").val();
		var params = {};
		params['id'] = romId;
		params['deviceSn'] = deviceSn;
		params['clientNo'] = clientNo;
		params['deviceType'] = '${osDeviceType}';
		params['osVersion'] = '${osVersion}';
		params['industry'] = industry;
		params['strategyId'] = strategyId;
		params['isJPushMessage'] = '${releaseType}';

		if (strategyId == '' || strategyId == null) {
			modals.info('<spring:message code="modules.rom.release.please.select.the.strategy"/>');
			return;
		}

		//选择所有页
		if ($("#allCheckBox").prop("checked")) {
			ajaxProgressDef("/romDevice/saveAllRomDevice", params);
		} else { //选择单页 或 点选
			//id数组
			params['ids'] = ids;
			ajaxProgressDef('/romDevice/saveRomDevice/' + romId, params);
		}
	}
	
	
	
	/**文件上传js代码*/
	$("#downLoadMerTemp").click(function() {
		$.download(basePath + "/device/download?type=releaseType", "post", "");
	})
	function deviceUploader(){
		  var $ = jQuery,
	        $list = $('#thelist'),
	        $btn = $('#ctlBtn'),
	        state = 'pending',
	        uploader;
		   uploader = WebUploader.create({

		    // swf文件路径
		    swf: basePath + '/common/libs/webuploader/Uploader.swf',

		    // 文件接收服务端。
		    server: basePath + "/osRom/uploadDeviceSn?romOrApp=ROM",

		    // 选择文件的按钮。可选。
		    // 内部根据当前运行是创建，可能是input元素，也可能是flash.
		    pick: {
		    	id:'#picker',
		    	multiple: false 
		    },
		    fileNumLimit: 1,
		    resize: false,
		    accept: {
		    	 title: 'EXCEL',
		         extensions: 'xls,xlsx',
		         mimeTypes: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
		    },
		    duplicate: false
		});
		   
	    uploader.refresh();
		// 当有文件被添加进队列的时候
		uploader.on( 'fileQueued', function( file ) {
			var $li = $('<div id="' + file.id + '" class="item">' +
	        '<button class="close" title="'+'<spring:message code="common.delete"/>'+'"><li class="fa fa-remove"></li></button> <h4 class="info">' + file.name + '</h4>' +
	        '<p class="state">'+'<spring:message code="app.release.wait.to.upload"/>'+'</p>' +
	    '</div>') ;
		    $list.append($li);
		    $('.close').on('click', function () {
		        //将文件移除上传序列
		        uploader.removeFile(file, true);
		        var $li = $('#' + file.id);
		        $li.off().remove();
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

		    $li.find('p.state').text('<spring:message code="app.release.uploading"/>');

		    $percent.css( 'width', percentage * 100 + '%' );
		});
		
		uploader.on( 'uploadSuccess', function( file, data) {
			
			if (data.code == 200) {
    		    loadTableSource(data.data);
    		    //移除上传按钮
		        $( '#'+file.id ).find('p.state').text('<spring:message code="app.release.uploading"/>');
			} else {
				$( '#'+file.id ).find('p.state').text(data.message);
			}
		    
		});

		uploader.on( 'uploadError', function( file, response ) {
		    $( '#'+file.id ).find('p.state').text('<spring:message code="app.release.error.upload.please.check.the.file.is.correct"/>');
		});
		
		
		uploader.on( 'error', function( handler ) {
			//alert(handle);
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
	        if ( state === 'uploading' ) {
	            uploader.stop();
	        } else {
	            uploader.upload();
	        }
	    });
	    return uploader;
	}
	
	/*取消文件上传*/
	function clickCancelBtn() {
		$("#fileImportDiv").hide();
		var existFileInfo = $("#availabDeviceCountId").html();
		if (existFileInfo == null || existFileInfo == '') {
			$("#clearSnCacheBtn").hide();			
		}
	}
	
</script>



