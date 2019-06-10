<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<link rel="stylesheet" href="${ctxStatic}/common/libs/webuploader/webuploader.css">
<script src="${ctxStatic}/common/libs/webuploader/webuploader.js"></script>
<spring:message code="app.release.client" var="releaseclient"/>
<spring:message code="common.delete" var="commdelete"/>
<spring:message code="app.release.wait.to.upload" var="waituploading"/>

<style type="text/css">
.importBtnStyleInit {
	float:right;
	display:inline-block;
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


<div class="modal-body" id="fileImportDiv">
	<div class="box-body">
	 <button class="btn btn-info btn lg text-center" id="downLoadMerTemp"><spring:message code="app.release.download.file.information.template"/></button>
	  <button class="btn btn-info btn lg text-center" onclick="clickCancelBtn()"><spring:message code="app.release.cancel.uploading"/></button>
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
</div>

<!-- Main content -->
<div class="modal-body">
	<div class="row">
		<div class="col-xs-12">
				<div class="form-horizontal" id="deviceSearchDiv">
					
					<div class="form-group" style="margin: 1em;">
						<label class="col-sm-2 control-label"><spring:message code="app.release.industry"/></label>
						<div class="col-sm-3">
								<select name="industry" id="industry"  data-placeholder='<spring:message code="app.release.please.choose.the.industry"/>' onchange="clickIndustry()" class="form-control select2" style="width: 191px">
									   <option value=""></option>
									  <c:forEach items="${industryList}" var="industry" varStatus="idxStatus">
								      			<option value="${industry.value}">${industry.label }</option>
								      </c:forEach>
								</select>
						</div>
						
						<label class="col-sm-2 control-label"><spring:message code="app.release.client"/></label>
						<div class="col-sm-3" style="width:220px">
							<sys:treeselect id="client" name="clientNo" value="${client.parentId}" labelName="parentName" labelValue="${client.customerName}"
						title="${releaseclient }" url="/client/treeData" extId="${client.customerId}" cssClass="form-control" allowClear="true"/>
						</div>
					</div>
					
					
					
					<div class="form-group" style="margin: 1em;">
						<label class="col-sm-2 control-label"><spring:message code="app.release.manufacturer"/></label>
						<div class="col-sm-3">
							<select name="manufacturerNo" id="manufacturerNo" onchange="manuFacturerChange()" 
							data-placeholder='<spring:message code="app.apprecord.please.select.the.equipment.manufacturer"/>' class="form-control select2" style="width: 190px">
							   <option value=""></option>
							  <c:forEach items="${manuFacturerList}" var="manuFacturer" varStatus="idxStatus">
						      			<option value="${manuFacturer.manufacturerNo}">${manuFacturer.manufacturerName }</option>
						      </c:forEach>
							</select>
						</div>
						
						<label class="col-sm-2 control-label"><spring:message code="ota.table.device.type"/></label>
						<div class="col-sm-3">
							<select name="deviceType" id="deviceTypeId"  onchange="deviceTypeChange()"
							data-placeholder='<spring:message code="app.apprecord.please.select.the.device.type"/>' class="form-control select2" style="width: 190px;">
							   <option value=""><spring:message code="app.apprecord.please.select.the.device.type"/></option>
							</select>
						</div>
					</div>
					
					
					<div class="form-group" style="margin: 1em;">
						<label class="col-sm-2 control-label"><spring:message code="ota.table.device.sn"/></label>
						<div class="col-sm-3">
							<input placeholder='<spring:message code="app.apprecord.please.enter.the.device.sn.number"/>' id="deviceSn" name="deviceSn" class="form-control"
								type="search" title='<spring:message code="app.apprecord.please.enter.the.device.sn.number"/>' style="width:190px"/> 
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
					    <label>
						<input type="checkbox" class="square-green" id="singleCheckBox" name="singleCheckBox"/>
						<spring:message code="app.release.single.page.submission"/>
						</label>
						&nbsp;&nbsp;
						<label>
						<input type="checkbox" class="square-green" id="allCheckBox" name="allCheckBox"/>
						<spring:message code="app.release.all.page.submissions"/>
						</label>
					</div>
						<div class="btn-group importBtnStyleInit"> 
						<button type="button" class="btn btn-success" onclick="clickImportBtn()" > <spring:message code="app.release.import.device.sn.file"/></button>
						<button type="button" class="btn btn-success" onclick="clearSnCache()" id="clearSnCacheBtn" style="display:none;"><spring:message code="app.release.canceling.file.search"/></button> 
					</div>
					<div class="btn-group"> 
						<span id="availabDeviceCountId" class="label label-success" ></span>
					</div>
					<table id="device_table"
						class="table table-bordered table-striped table-hover">
					</table>
				</div>
				
				<div class="box-footer text-right">
					<!--以下两种方式提交验证,根据所需选择-->
					<button type="button" class="btn btn-default" data-btn-type="cancel"
						data-dismiss="modal"><spring:message code="common.cancel"/></button>
					 <button type="button" onclick="submitDevice()" class="btn btn-primary"><spring:message code="common.submit"/></button>
				</div>
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</div>

<script>
var deviceform = $("#deviceSearchDiv").form({baseEntity: false});
deviceform.initComponent();
	var deviceTable,winId = "appInfoWin";
	var config={
			singleSelect:null
	};
	var checkIds = [];
	var isInitFlag = true;
	$(function() {
		checkBox();
		clearSnCache();
		//隐藏文件上传div
		$("#fileImportDiv").hide();
		
	})
	
	function loadTableSource(deviceSnCount) {
		$("#fileImportDiv").hide();
		$("#clearSnCacheBtn").show();
		deviceTable.reloadRowData();
		$("#availabDeviceCountId").html($.i18n.prop("app.release.upload.sn.count",deviceSnCount));
	}
	
	var $appUploder;
	//导入设备SN文件
	function clickImportBtn() {
		$("#fileImportDiv").show();
		if($appUploder)
			$appUploder.destroy();
		$appUploder = appUploader();
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
		var url = "/osRom/clearDeviceSnCache?romOrApp=APP";
		 $.when(
				ajaxPostWithDeferred(basePath + url, function(data,
						status) {
				})).done(function(data) {
				layer.close(index);
			if (data.code == 200) {
			if (isInitFlag == true) {
					var appId = '${id}';
					var clientIdentification = '${clientIdentification}';
					//init table and fill data
					deviceTable = new CommonTable("device_table", "os_device_list", "deviceSearchDiv",
							"/device/noPublishAppDeviceList?appId=" + appId + "&clientIdentification=" + clientIdentification
							, config);
					isInitFlag = false;
				}else {
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
	
	function ajaxProgressDef(url,params){
		layer.msg('<spring:message code="app.release.its.being.released.please.wait.a.little.later"/>', {icon: 16,tips: [1, '#3595CC'],area: ['250px', '70px'],shade: [0.5, '#f5f5f5'],scrollbar: false,time: 500000}) ; 
		var index = layer.index;
		$.when(ajaxPostWithDeferred(basePath+url, params, function(data, status) {})).done(function(data){
			layer.close(index);
			if(data.code == 200){
				modals.correct(data.message);
				modals.hideWin(winId);
			}else{
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
	
	function submitDevice(){
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
		if(ids == ''){
			modals.info('<spring:message code="app.release.please.select.the.least.one.device"/>');
			return;
		}
		
		layer.msg('<spring:message code="app.release.its.being.released.please.wait.a.little.later"/>', {icon: 16,tips: [1, '#3595CC'],area: ['250px', '70px'],shade: [0.5, '#f5f5f5'],scrollbar: false,time: 500000}) ; 
	
		//系统版本id
		var appId = '${id}';
		var deviceSn = $("#deviceSn").val();
		var manufacturerNo = $("#manufacturerNo").val();
		var deviceType = $("#deviceTypeId").val();
		var clientId = $("#clientId").val();
		
		var params = {};
		params['id'] = appId;
		params['deviceSn'] = deviceSn;		
		params['manufacturerNo'] = manufacturerNo;	
		params['deviceType'] = deviceType;	
		params['clientNo'] = clientId;
		//type: 0 被动 1 主动 
		params['isJPushMessage'] = '${type}';
		
		//选择所有页
		if($("#allCheckBox").prop("checked")){
			ajaxProgressDef("/appDevice/saveAllAppDevice/",params);
		}else { //选择单页 或 点选
			//id数组
			params['ids'] = ids;
			ajaxProgressDef("/appDevice/saveAppDevice/" + appId,params);
		}
	}
	
	$("#singleCheckBox").on("ifClicked",function(event){
		if(event.target.checked){
			$("input[name='box']:checkbox").iCheck("uncheck");
			$("input[name='box']:checkbox").iCheck("enable");
			$("#allCheckBox").iCheck("enable");
		}else{
			$("input[name='box']:checkbox").iCheck("check");
			$("input[name='box']:checkbox").iCheck("disable");
			$("#allCheckBox").iCheck("disable");
		}
	})
	
	$("#allCheckBox").on("ifClicked",function(event){
		if(event.target.checked){
			$("input[name='box']:checkbox").iCheck("uncheck");
			$("input[name='box']:checkbox").iCheck("enable");
			$("#singleCheckBox").iCheck("enable");
		}else{
			$("input[name='box']:checkbox").iCheck("check");
			$("input[name='box']:checkbox").iCheck("disable");
			$("#singleCheckBox").iCheck("disable");
		}
	})
	
	function clickIndustry(){
		var value = $("#industry").val();
		$("#industryId").val(value);
	}
	
	
	
	/**文件上传js代码*/
	$("#downLoadMerTemp").click(function() {
		$.download(basePath + "/device/download?type=releaseType", "post", "");
	})
function appUploader(){
		  var $ = jQuery,
	        $list = $('#thelist'),
	        $btn = $('#ctlBtn'),
	        state = 'pending',
	        uploader;

		   uploader = WebUploader.create({

		    // swf文件路径
		    swf: basePath + '/common/libs/webuploader/Uploader.swf',

		    // 文件接收服务端。
		    server: basePath + "/osRom/uploadDeviceSn?romOrApp=APP",

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
		    	 title: 'EXCEL',
		         extensions: 'xls,xlsx',
		         mimeTypes: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
		    },
		    duplicate: false
		});
		
		// 当有文件被添加进队列的时候
		uploader.on( 'fileQueued', function( file ) {
			var comdelete = '${commdelete}';
			var waituploading = '${waituploading}';
			var $li = $('<div id="' + file.id + '" class="item">' +
	        '<button class="close" title="' + comdelete + '"><li class="fa fa-remove"></li></button> <h4 class="info">' + file.name + '</h4>' +
	        '<p class="state">' + waituploading + '</p>' +
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

		    $li.find('p.state').text('<spring:message code="app.release.wait.to.upload"/>');

		    $percent.css( 'width', percentage * 100 + '%' );
		});
		
		uploader.on( 'uploadSuccess', function( file, data) {
			
			if (data.code == 200) {
    		    loadTableSource(data.data);  
    		    //移除上传按钮
		        $( '#'+file.id ).find('p.state').text('<spring:message code="app.release.the.file.has.been.uploaded.successfully.and.the.system.background.processing.is.successful"/>');
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

