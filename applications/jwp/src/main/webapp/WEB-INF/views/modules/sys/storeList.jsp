<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<div id="listForm">
<!-- Main content -->
<section class="content" >
	<div class="row">
		<div class="col-xs-12">
			<div class="nav-tabs-custom">
					<ul class="nav nav-tabs pull-right">
						<li><a href="#tab-content-edit" data-toggle="tab"
							id="nav-tab-edit"><i class="fa fa-edit"></i></a></li>
						<li class="active"><a href="#tab-content-list"
							data-toggle="tab" id="nav-tab-list"><i class="fa fa-list-ul"></i></a></li>
						<li class=" header"><i class="fa-hourglass-half "></i><small><spring:message
									code="store.list"></spring:message></small></li>
					</ul>
					<div class="tab-content">
						<div class="tab-pane active" id="tab-content-list">
							<div class="box">
								<!-- /.box-header -->
								<div id="storeSearchDiv" role="form" class="dataTables_filter" style="text-align: left;"><!-- form-horizontal -->
										  <div class="form-group dataTables_filter " style="margin: 1em;">
										 	 <input id="storeOrgSelect" style="width: 226.5px;" name="orgId" class="form-control"  type="hidden"/>
											 <input id="storeOrgSelectValue" style="width: 226.5px;margin-left:0px;" name="orgIdValue" class="form-control" type="text" placeholder='<spring:message code="please.select.organ"/>'/>
										      <select id="selectMerchants" name="merId" class="form-control select2" data-placeholder='<spring:message code="please.select.merchant"/>'
													style="width: 226.5px;">
													<option value=""></option>
											  </select>
										      <select id="selectStores" name="storeId" class="form-control select2" data-placeholder='<spring:message code="please.select.store"/>'
													style="width: 226.5px;">
													<option value=""></option>
											  </select>
											  <button type="button" class="btn btn-primary"  style="height:36px;"
												data-btn-type="search"><spring:message code="common.query"/></button>
											 <button type="button" class="btn btn-default"  style="height:36px;"
												data-btn-type="reset"><spring:message code="common.reset"/></button>
											<shiro:hasPermission name="sys:merchant:edit">
												<button type="button" class="btn btn-default"  data-btn-type="storeDelete" title="<spring:message code="delete"/>"  style="height:37px;">
													<i class="fa fa-remove"></i>
												</button>
												<button data-btn-type="storeEdit" class="btn btn-default"  title='<spring:message code="edit"/>' type="button"  style="height:37px;">
													<i class="fa fa-edit"></i>
												</button>
												<button data-btn-type="storeAdd" class="btn btn-default"  title='<spring:message code="add"/>' type="button"  style="height:37px;">
													<i class="fa fa-plus"></i>
												</button>
											</shiro:hasPermission>
										  </div>
									</div>
										<div class="box-body">
											<table id="store_table"
												class="table table-bordered table-bg table-striped table-hover" style="margin-top:0px !important;">
											</table>
										</div>
									<!-- /.box-body -->
								</div>
						</div>
						<div class="tab-pane" id="tab-content-edit">
							<form:form id="store-form" name="store-form" modelAttribute="store" class="form-horizontal">
									  <form:hidden path="id" value="" />
									  <input type='hidden' value='${CSRFToken}' id='csrftoken'>
									  <input type="hidden" id="addOrUpdate" value="" />
									<div class="box-body">
										<div class="col-md-4">
											<div class="form-group">
												<label for="office.id" class="col-sm-3 control-label"><spring:message
														code="sys.user.office" /></label>
												<div class="col-sm-8">
													<%-- <input  type="hidden" id="orgId" name="orgId" value="${orgId}">
													<input  type="text" id="orgName" name="orgName" class="form-control" value="${orgName}">
													<div id="officetree"></div> --%>
													<input id="storeFormOrgSelect" style="width: 253.33px;"
														name="orgId" class="form-control" type="hidden"
														placeholder="${orgId}" />
													<form:input  id="storeFormOrgSelectValue" path="orgName" class="form-control" htmlEscape="false"
														maxlength="100" placeholder="${orgName}" onclick="showOrgTree();"/>
												</div>
											</div>
											<div class="form-group">
												<label for="office.id" class="col-sm-3 control-label"><spring:message
														code="sys.store.merName" /></label>
												<div class="col-sm-8">
													<form:select path="merId" id="merSelect"
														class="form-control select2" style="width: 100%;">
														<form:options items="${merchants}" itemLabel="merName"
															itemValue="merId" htmlEscape="false"/>
													</form:select>
												</div>
											</div>
											<div class="form-group">
												<label for="storeName" class="col-sm-3 control-label"><spring:message
														code="sys.store.name" /><span
													style="color: red">*</span></label>
												<div class="col-sm-8">
													<form:input type="text" htmlEscape="false" class="form-control"
														id="storeName" path="storeName" placeholder="${storeName}"/>
												</div>
											</div>
											<div class="form-group">
												<label for="storeId" class="col-sm-3 control-label"><spring:message
														code="sys.store.id" /><span
													style="color: red">*</span></label>
												<div class="col-sm-8">
													<form:input type="text" htmlEscape="false" class="form-control"
														id="storeId" path="storeId" placeholder="${storeId}"/>
														<input type="hidden" id="storeIdOld" name="storeIdOld" value=""/>
												</div>
											</div>
											<div class="form-group">
												<label for="linkMan" class="col-sm-3 control-label"><spring:message
														code="sys.store.linkMan" /><span
													style="color: red">*</span></label>
												<div class="col-sm-8">
													<form:input type="text" htmlEscape="false" class="form-control"
														id="linkMan" path="linkMan" placeholder="${linkMan}"/>
												</div>
											</div>
											<div class="form-group">
												<label for="linkPhone" class="col-sm-3 control-label"><spring:message
														code="sys.store.mobile" /><span
													style="color: red">*</span></label>
												<div class="col-sm-8">
													<form:input type="text" htmlEscape="false" class="form-control"
														id="linkPhone" path="linkPhone" placeholder="${linkPhone}"/>
												</div>
											</div>
											<div class="form-group">
												<label for="address" class="col-sm-3 control-label"><spring:message
														code="sys.store.address" /><span
													style="color: red">*</span></label>
												<div class="col-sm-8">
													<form:input type="text" htmlEscape="false" class="form-control"
														id="address" path="address" placeholder="${address}"/>
												</div>
											</div>
											<p style="margin-left:90px;margin-top:-10px;"><font color="green"><spring:message
														code="tips" /></font></p>
												<div class="form-group">
												<label for="longitude" class="col-sm-3 control-label"><spring:message
														code="longitude" /><span
													style="color: red">*</span></label>
												<div class="col-sm-8">
													<form:input type="text" htmlEscape="false" class="form-control"
														id="longitude" path="longitude" placeholder="${longitude}"/>
												</div>
											</div>
											<div class="form-group">
												<label for="latitude" class="col-sm-3 control-label"><spring:message
														code="latitude" /><span
													style="color: red">*</span></label>
												<div class="col-sm-8">
													<form:input type="text" htmlEscape="false" class="form-control"
														id="latitude" path="latitude" placeholder="${latitude}"/>
												</div>
											</div>
											<div class="form-group">
												<label for="radius" class="col-sm-3 control-label"><spring:message
														code="device.range.radius" /><span
													style="color: red">*</span></label>
												<div class="col-sm-8">
													<form:input type="text" htmlEscape="false" class="form-control" value="500"
														id="radius" path="radius" placeholder="${radius}"/>
												</div>
											</div>
										</div>
										<div class="col-md-8" id="map"  style="height: 500px;">
											<div id="allmap"  style="height: 500px;"></div>
										</div>
									</div>
									<div class="box-footer text-right">
									<button type="button" class="btn btn-default"
										data-dismiss="modal" id="cancel">
										<spring:message code="common.cancel" />
									</button>
									<button class="btn btn-primary" data-btn-type="save"
										id="save">
										<spring:message code="common.submit" />
									</button>
								</div>
								</form:form>
						</div>
					</div>
						
			</div>
			</div>
			<!-- /.col -->
		</div>
		<!-- /.row -->
</section>
</div>
<script>
function setTitle(title) {
	$("ul.nav-tabs li.header small").text(title);
}
function showOrgTree() {
	modals
			.openWin({
				winId : "storeFormOrgTree",
				title : '<spring:message code="modules.device.importing.equipment.by.product.batch"/>',
				width : '300px',
				url : basePath
						+ "/sys/office/toOfficeTree?windowId=storeFormOrgTree&orgSelect=storeFormOrgSelect&orgSelectValue=storeFormOrgSelectValue"
			});
}
$(function(){
	$("#selectMerchants").change(function(){
		var secSelect = document.getElementById("selectStores");
		var merId = this.value;
		//secSelect.options.length = 0;
		$.ajax({
			url:basePath+'/sys/store/stores?merId='+merId,
			success:function(res){
				 var dataJson = res.data;
				 var oOption = document.createElement("OPTION");
				 oOption.value = "";
			     oOption.text = "<spring:message code='all'/>";
			     secSelect.options.add(oOption);	
				 for ( var i = 0; i < dataJson.length; i++) {
						var oOption = document.createElement("OPTION");
						oOption.value = dataJson[i].storeId;
						oOption.text = dataJson[i].storeName;
						secSelect.options.add(oOption);
					}
				}
			});
		});
	});
	//tableId,queryId,conditionContainer
	var storeTable;
	var winId = "storeWin";
	$("#reset").click(function(){
		 $("select").select2().val("");
		 var secSelect = document.getElementById("selectMerchants");
		 secSelect.options.length = 0;
	});
	$(function() {
		
		 //编辑区域点击事件
		 $("#nav-tab-edit").click(function(){
			 $("#storeFormOrgSelect").val("");
			 $("#storeFormOrgSelectValue").val("");
			 $("#merId").val("");
			 $("#storeName").val("");
			 $("#storeId").val("");
			 $("#storeIdOld").val("");
			 $("#linkMan").val("");
			 $("#linkPhone").val("");
			 $("#longitude").attr("value","");
			 $("#address").attr("value","");
			 $("#latitude").attr("value", "");
			 $("#addOrUpdate").val("add");

		 });
		 $("#nav-tab-list").click(function(){
			  setTitle("<spring:message code="store.list"/>");
		 });
		
		//设置心新增修改参数为新增
		$("#addOrUpdate").val("add");
		/* $("#orgSelect").select2(); */
		$("#selectMerchants").select2();
		$("#selectStores").select2();
		//查询框是否在一行设置
		var config = {
			resizeSearchDiv : false,
			language : {
				url : basePath + '<spring:message code="common.language"/>'
			}
		};
		storeTable = new CommonTable("store_table", "storeTable",
				"storeSearchDiv", "/sys/store/list", config);
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var storeRowId = storeTable.getSelectedRowId();
							switch (action) {
							case 'storeAdd':
								 setTitle('<spring:message code="store.add"/>');//设置界面显示信息
								 $("#nav-tab-edit").click();
								 $("#storeFormOrgSelect").val("");
								 $("#storeFormOrgSelectValue").val("");
								 $("#merId").val("");
								 $("#storeName").val("");
								 $("#storeId").val("");
								 $("#storeIdOld").val("");
								 $("#linkMan").val("");
								 $("#linkPhone").val("");
								 $("#longitude").attr("value","");
								 $("#address").attr("value","");
								 $("#latitude").attr("value", "");
								 $("#addOrUpdate").val("add");
								 $(".form-horizontal").data("bootstrapValidator").resetForm();
								break;
							case 'toBoundTerm':
								$.ajax({
									url : basePath
											+ "/sys/store/toBoundStoreTerm",
									dataType : "html",
									success : function(res) {
										$("#listForm").html(res);
									}
								});
								break;
							case 'storeEdit':
								if (!storeRowId) {
									modals
											.info('<spring:message code="common.promt.edit"/>');
									return false;
								}
								setTitle("<spring:message code="sys.merchant.edit"/>");
								$("#nav-tab-edit").click();
								$("#addOrUpdate").val("update");
								ajaxPost(basePath+"/sys/store/StoreEditOrAdd?id="+storeRowId, null, function(data) {
									
											//重置
											 $("#storeFormOrgSelect").val("");
											 $("#storeFormOrgSelectValue").val("");
											 $("#merId").val("");
											 $("#storeName").val("");
											 $("#storeId").val("");
											 $("#storeIdOld").val("");
											 $("#linkMan").val("");
											 $("#linkPhone").val("");
											 $("#longitude").attr("value","");
											 $("#address").attr("value","");
											 $("#latitude").attr("value", "");
											//根据orgId查询机构名称
											 ajaxPost(basePath+"/sys/office/get?id="+data.orgId, null, function(dataOrg) {
												 $("#storeFormOrgSelectValue").val(dataOrg.name);
											 });
											//赋值
										     $("#id").val(data.id);
											 $("#merFormOrgSelect").val(data.orgId);
											 $("#merId").val(data.merId);
											 $("#storeName").val(data.storeName);
											 $("#storeId").val(data.storeId);
											 $("#storeIdOld").val(data.storeId);
											 $("#linkMan").val(data.linkMan);
											 $("#linkPhone").val(data.linkPhone);
											 $("#longitude").attr("value",data.longitude);
											 $("#address").attr("value",data.address);
											 $("#latitude").attr("value", data.latitude);
											 $(".form-horizontal").data("bootstrapValidator").resetForm();
								});
								break;
							case 'storeDelete':
								if (!storeRowId) {
									modals
											.info('<spring:message code="common.promt.delete"/>');
									return false;
								}
								modals
										.confirm({
											cancel_label : "<spring:message code="common.cancel" />",
											title : "<spring:message code="common.sys.confirmTip" />",
											ok_label : "<spring:message code="common.confirm" />",
											text : "<spring:message code="common.confirm.delete" />",
											callback : function() {
												ajaxPost(
														basePath
																+ "/sys/store/delete?id="
																+ storeRowId,
														null,
														function(data) {
															if (data.code == 200) {
																modals
																		.correct({
																			title : '<spring:message code="common.sys.success" />',
																			cancel_label : '<spring:message code="common.confirm" />',
																			text : data.message
																		});
																storeTable
																		.reloadRowData();
															} else {
																modals
																		.warn(date.message);
															}
														});
											}
										});
								break;
							 case 'cancel':
			                        $("#nav-tab-list").click();
			                        $("#addOrUpdate").val("add");
			                     break;
							}

						});
		$("#store-form").bootstrapValidator({
			message : '<spring:message code="common.promt.value"/>',
			feedbackIcons : {
				valid : 'glyphicon glyphicon-ok',
				invalid : 'glyphicon glyphicon-remove',
				validating : 'glyphicon glyphicon-refresh'
			},
			fields : {
				orgId : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.store.orgId.not.empty"/>'
						}
					}
				},storeName : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.store.orgId.not.empty"/>'
						}
					}
				},
				storeId : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.store.storeId.not.empty"/>'
						},
						stringLength : {
							min : 6,
							max : 20,
							message : '<spring:message code="sys.store.storeId.length.not.invalid"/>'
						},
						remote : {
							url : basePath
									+ "/sys/store/checkStoreId",
							delay : 2000,
							data: function(validator) {
	                            return {
	                            	storeId:$('#storeId').val(),
	                            	storeIdOld:$('#storeIdOld').val(),
	                            	id:$("#id").val()
	                            };
	                        },
							message : '<spring:message code="sys.merchant.exist"/>'
						}
					}
				}, 
				linkMan:{
					validators : {
						notEmpty : {
							message : '<spring:message code="linkman.not.empty"/>'
						}
					}
				},
				linkPhone : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.user.promt.mobile"/>'
						},
						stringLength : {
							min : 11,
							max : 11,
							message : '<spring:message code="sys.user.promt.mobile.length"/>'
						},
						regexp : {
							regexp : /^1[3|5|8|7]{1}[0-9]{9}$/,
							message : '<spring:message code="sys.user.promt.mobile.error"/>'
						}
					}
				},
				address:{
					validators : {
						notEmpty : {
							message : '<spring:message code="address.not.empty"/>'
						}
					}
				},
				longitude:{
					validators : {
						notEmpty : {
							message : '<spring:message code="longitude.not.empty"/>'
						},
						stringLength : {
							max : 10,
							message : '<spring:message code="longitude.max.length"/>'
						},
						regexp : {
							regexp : /^[+]?\d*\.\d*$/,
							message : '<spring:message code="longitude.only.number"/>'
						}
					}
				},
				latitude:{
					validators : {
						notEmpty : {
							message : '<spring:message code="latitude.not.empty"/>'
						},
						stringLength : {
							max : 10,
							message : '<spring:message code="latitude.max.length"/>'
						},
						regexp : {
							regexp : /^[+]?\d*\.\d*$/,
							message : '<spring:message code="latitude.only.number"/>'
						}
					}
				},
				radius:{
					validators : {
						notEmpty : {
							message : '<spring:message code="device.range.not.empty"/>'
						},
						stringLength : {
							max : 5,
							message : '<spring:message code="device.max.radius"/>'
						},
						regexp : {
							regexp : /^[1-9]\d{0,4}$/,
							message : '<spring:message code="radius.only.number"/>'
						}
					}
				}
			}
		}).on('success.form.bv', function(e) {
				 modals.confirm('<spring:message code="common.confirm.save"/>',function() {
							var params = $("#store-form").form().getFormSimpleData();
							 ajaxPost(basePath+'/sys/store/save', params, function(data, status) {
									if (data.code == '200' || data.code == 200) {
										var addOrUpdate = $("#addOrUpdate").val();
										if (addOrUpdate == "update") {//更新
											modals.info({
						                        title:'<spring:message code="common.sys.info" />', 
						                        cancel_label:'<spring:message code="common.close" />',
						                        text:'<spring:message code="common.editSuccess" />'}); 
												storeTable.reloadRowData($('#id').val());
										} else if(addOrUpdate == "add") {//新增
											modals.info({
						                        title:'<spring:message code="common.sys.info" />', 
						                        cancel_label:'<spring:message code="common.close" />',
						                        text:'<spring:message code="common.AddSuccess" />'});
												storeTable.reloadData();
												 $("#storeFormOrgSelect").val("");
												 $("#storeFormOrgSelectValue").val("");
												 $("#merId").val("");
												 $("#storeName").val("");
												 $("#storeId").val("");
												 $("#storeIdOld").val("");
												 $("#linkMan").val("");
												 $("#linkPhone").val("");
												 $("#longitude").attr("value","");
												 $("#address").attr("value","");
												 $("#latitude").attr("value", "");
												 $("#addOrUpdate").val("add");

										}
										  $("#nav-tab-list").click();
										  setTitle("<spring:message code="store.list"/>");
										  $("#csrftoken").val("");
									} else{
										modals.error(data.message);
									}
						}); 
							/* $.ajax({
								type : 'post',
								url : basePath+storeUrl,
								data : params,
								dataType:'json',
								success : function(res) {
									modals.hideWin(winId);
									storeTable.reloadRowData();
								},
								error:function(res){
									modals.hideWin(winId);
									storeTable.reloadRowData();
								}
							});  */
		          });
		  });
		
});
function manageTerm(countTerm) {
		var oper = "&nbsp;&nbsp;&nbsp;";
		oper += "<a href='javascript:void(0)'   onclick='toManageTerm()'>"
				+ countTerm + "</a>";
		return oper;
	}
	$("#storeOrgSelectValue")
			.click(
					function() {
						modals
								.openWin({
									winId : "storeOrgTree",
									title : '<spring:message code="modules.device.importing.equipment.by.product.batch"/>',
									width : '300px',
									url : basePath + "/sys/office/toOfficeTree?windowId=storeOrgTree&orgSelect=storeOrgSelect&orgSelectValue=storeOrgSelectValue"
								});
					});
	function toManageTerm() {
		var storeRowId = storeTable.getSelectedRowId();
		if (storeRowId != null && storeRowId !== '') {
			$.ajax({
				url : basePath + '/device/toBoundStoreDevice',
				type : 'POST',
				traditional : true,
				data : {
					'sId' : storeRowId
				},
				success : function(res) {
					$("#listForm").html(res);
				}
			});
		}
	}
	$(function(){

		// 百度地图API功能===================================================================================================
		var map = new BMap.Map("allmap");
		var point = new BMap.Point(116.331398,39.897445);
		map.centerAndZoom(point,12);
		// 创建地址解析器实例
		var myGeo = new BMap.Geocoder();
		var geolocation = new BMap.Geolocation();
		  // 添加定位控件
		  var geolocationControl = new BMap.GeolocationControl();
		  geolocationControl.addEventListener("locationSuccess", function(e){
		    // 定位成功事件
		    var address = '';
		    address += e.addressComponent.province;
		    address += e.addressComponent.city;
		    address += e.addressComponent.district;
		    address += e.addressComponent.street;
		    address += e.addressComponent.streetNumber;
		    modals.info("<spring:message code='current.location.address'/>：" + address);
		  });
		  geolocationControl.addEventListener("locationError",function(e){
			    // 定位失败事件
			    modals.info(e.message);
			});
		  map.addControl(geolocationControl);
		$("#address").blur(function(){
			var addr = this.value;
			// 将地址解析结果显示在地图上,并调整地图视野
			myGeo.getPoint(addr, function(point){
				if (point) {
					map.centerAndZoom(point, 16);
					map.addOverlay(new BMap.Marker(point));
					geolocation.getCurrentPosition(function(r){
						if(this.getStatus() == BMAP_STATUS_SUCCESS){
							var mk = new BMap.Marker(point);
							map.addOverlay(mk);
							map.panTo(point);
							$("#longitude").attr("value",point.lng);
							$("#latitude").attr("value",point.lat);
						}
						else {
							modals.info('failed'+this.getStatus());
						}        
					},{enableHighAccuracy: true}); 
				}else{
					modals.info("<spring:message code='address.not.resolved.to.result'/>");
				}
			}, "北京市");
		});
		map.addEventListener("click", function(e){  
			map.clearOverlays();
			var pt = e.point;
			myGeo.getLocation(pt, function(rs){
				var addComp = rs.addressComponents;
				var address = addComp.province + addComp.city  + addComp.district + addComp.street  + addComp.streetNumber;
				$("#address").attr('value',address);
			});   
			geolocation.getCurrentPosition(function(r){
				if(this.getStatus() == BMAP_STATUS_SUCCESS){
					var mk = new BMap.Marker(pt);
					map.addOverlay(mk);
					map.panTo(pt);
					$("#longitude").attr("value",pt.lng);
					$("#latitude").attr("value",pt.lat);
				}
				else {
					modals.info('failed'+this.getStatus());
				}        
			},{enableHighAccuracy: true});     
		});
		map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
	//==============================================================================================================
	});
</script>
<style type="text/css">
 .treeview {
		 overflow-y:auto;
		 height:300px;
		 }
</style>
