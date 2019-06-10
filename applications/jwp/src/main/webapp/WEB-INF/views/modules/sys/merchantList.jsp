<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/commonsjs.jsp"%>
<!-- Content Header (Page header) -->
<div id="listForm">
	<!-- Main content -->
	<section class="content">
		<div class="row">
			<div class="col-xs-12">
				<div class="nav-tabs-custom">
					<ul class="nav nav-tabs pull-right">
						<li><a href="#tab-content-edit" data-toggle="tab"
							id="nav-tab-edit"><i class="fa fa-edit"></i></a></li>
						<li class="active"><a href="#tab-content-list"
							data-toggle="tab" id="nav-tab-list"><i class="fa fa-list-ul"></i></a></li>
						<li class=" header"><i class="fa-hourglass-half "></i><small><spring:message
									code="ota.table.device.type.list"></spring:message></small></li>
					</ul>
					<div class="tab-content">
						<div class="tab-pane active" id="tab-content-list">
							<div class="box">
										<div id="merchantSearchDiv" class="dataTables_filter" style="text-align: left;" role="form">
										  <div class="form-group dataTables_filter " style="margin: 1em;">
										  		    <input id="merOrgSelect"  name="orgId" class="form-control"  type="hidden"/>
													<input id="merOrgSelectValue"  name="orgIdValue" class="form-control" type="text" placeholder='<spring:message code="please.select.organ" />'/>
										            <select id="selectMerchants" style="width: 226.5px;" name="merId" class="form-control select2" data-placeholder='<spring:message code="please.select.merchant" />'
															style="width: 100%;">
														<option value=""></option>
														<option value="0"><spring:message code="all" /></option>
													</select>
													<button type="button" class="btn btn-primary" style="height:36px;"
														data-btn-type="search">
														<spring:message code="common.query" />
													</button>
													<button type="button" class="btn btn-default" id="reset" style="height:36px;"
														data-btn-type="reset">
														<spring:message code="common.reset" />
													</button>
													<shiro:hasPermission name="sys:merchant:edit">
														<button type="button" class="btn btn-primary" style="height:36px;"
																data-btn-type="merchantBatchAdd"><spring:message code="batch.import.merchant"/></button>
														<button type="button" class="btn btn-default" style="height:37px;"
															data-btn-type=merchantDelete title="<spring:message code='delete'/>">
															<i class="fa fa-remove"></i>
														</button>
														<button data-btn-type="merchantEdit" class="btn btn-default" style="height:37px;"
															title="<spring:message code='edit'/>" type="button">
															<i class="fa fa-edit"></i>
														</button>
														<button data-btn-type="merchantAdd" class="btn btn-default" style="height:37px;"
															title="<spring:message code='add'/>" type="button">
															<i class="fa fa-plus"></i>
														</button>
													</shiro:hasPermission>
										  </div>
										</div>
							<div class="box-body">
								<table id="merchant_table"
									class="table table-bordered table-bg table-striped table-hover" style="margin-top:0px !important;">
								</table>
							</div>
						</div>
						</div>
						<div class="tab-pane" id="tab-content-edit">
							<form:form id="merchant-form" name="merchant-form" modelAttribute="merchant" class="form-horizontal">
									  <form:hidden path="id" value="${merchant.id }" />
									  <input type='hidden' value='${CSRFToken}' id='csrftoken'>
									  <input type="hidden" id="addOrUpdate" value="" />
										<div class="box-body">
											<div class="col-md-5">
												<div class="form-group">
													<label for="office.id" class="col-sm-3 control-label"><spring:message
															code="sys.user.office" /></label>
													<div class="col-sm-8">
														<input id="merFormOrgSelect" style="width: 253.33px;"
														name="orgId" class="form-control" type="hidden"
														placeholder="${orgId}" />
														<form:input  id="merFormOrgSelectValue" path="orgName" class="form-control" htmlEscape="false"
														maxlength="100" placeholder="${orgName}" onclick="showOrgTree();"/>
														
														<%-- <input type="hidden" id="orgId1" name="orgId" value="${orgId}">
														<input type="text" id="orgName1" name="orgName"
															class="form-control" value="${orgName}"> --%>
															
														<!-- <div id="officetree"></div> -->
													</div>
												</div>
												<div class="form-group">
													<label for="merName" class="col-sm-3 control-label"><spring:message
															code="sys.merchant.name" /><span style="color: red">*</span></label>
													<div class="col-sm-8">
														<form:input type="text" htmlEscape="false" class="form-control"
															id="merName" path="merName" placeholder="${merName}" />
													</div>
												</div>
												<div class="form-group">
													<label for="merId" class="col-sm-3 control-label"><spring:message
															code="sys.merchant.id" /><span style="color: red">*</span></label>
													<div class="col-sm-8">
														<form:input type="text" htmlEscape="false" class="form-control"
															id="merId" path="merId" placeholder="${merId}" />
														<input type="hidden" id="merIdOld" name="merIdOld"  value=""/>	
													</div>
												</div>
												<div class="form-group">
													<label for="linkMan" class="col-sm-3 control-label"><spring:message
															code="sys.merchant.linkMan" /><span style="color: red">*</span></label>
													<div class="col-sm-8">
														<form:input type="text" htmlEscape="false" class="form-control"
															id="linkMan" path="linkMan" placeholder="${linkMan}" />
													</div>
												</div>
												<div class="form-group">
													<label for="linkPhone" class="col-sm-3 control-label"><spring:message
															code="sys.merchant.mobile" /><span style="color: red">*</span></label>
													<div class="col-sm-8">
														<form:input type="text" htmlEscape="false" class="form-control"
															id="linkPhone" path="linkPhone" placeholder="${linkPhone}" />
													</div>
												</div>
												<div class="form-group">
													<label for="address" class="col-sm-3 control-label"><spring:message
															code="sys.merchant.address" /><span style="color: red">*</span></label>
													<div class="col-sm-8">
														<form:input type="text" htmlEscape="false" class="form-control"
															id="address" path="address" placeholder="${address}" />
													</div>
												</div>
												<p style="margin-left: 100px; margin-top: -10px;">
													<font color="green"><spring:message code="tips" /></font>
												</p>
												<div class="form-group">
													<label for="longitude" class="col-sm-3 control-label"><spring:message
															code="longitude" /><span style="color: red">*</span></label>
													<div class="col-sm-8">
														<form:input type="text" htmlEscape="false" class="form-control"
															id="longitude" path="longitude" placeholder="${longitude}" />
													</div>
												</div>
												<div class="form-group">
													<label for="latitude" class="col-sm-3 control-label"><spring:message
															code="latitude" /> <span style="color: red">*</span></label>
													<div class="col-sm-8">
														<form:input type="text" htmlEscape="false" class="form-control"
															id="latitude" path="latitude" placeholder="${latitude}" />
													</div>
												</div>
												<div class="form-group">
													<label for="radius" class="col-sm-3 control-label"><spring:message
															code="device.range.radius" /><span style="color: red">*</span></label>
													<div class="col-sm-8">
														<form:input type="text" htmlEscape="false" class="form-control"
															value="500" id="radius" path="radius" placeholder="${radius}" />
													</div>
												</div>
											</div>
											<div class="col-md-7" id="map">
												<div id="allmap" style="height: 440px;"></div>
											</div>
										</div>
										<div class="box-footer text-right">
											<button type="button" class="btn btn-default" data-btn-type="cancel"
												data-dismiss="modal" id="cancel">
												<spring:message code="common.cancel" />
											</button>
											<button class="btn btn-primary" data-btn-type="save" id="save">
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
	modals.openWin({
				winId : "merFormOrgTree",
				title : '<spring:message code="modules.device.importing.equipment.by.product.batch"/>',
				width : '300px',
				url : basePath
						+ "/sys/office/toOfficeTree?windowId=merFormOrgTree&orgSelect=merFormOrgSelect&orgSelectValue=merFormOrgSelectValue"
			});
}
	//tableId,queryId,conditionContainer
	var merchantTable;
	var winId = "merchantWin";
	
	$("#reset").click(function(){
		 $("select").select2().val("");
		 var secSelect = document.getElementById("selectMerchants");
		 secSelect.options.length = 0;
	});
	$(function() {
		 //编辑区域点击事件
		 $("#nav-tab-edit").click(function(){
			 $("#merFormOrgSelect").val("");
			 $("#merFormOrgSelectValue").val("");
			 $("#merName").val("");
			 $("#merId").val("");
			 $("#merIdOld").val("");
			 $("#linkMan").val("");
			 $("#linkPhone").val("");
			 $("#longitude").attr("value","");
			 $("#address").attr("value","");
			 $("#latitude").attr("value", "");
			 $("#addOrUpdate").val("add");

		 });
		 $("#nav-tab-list").click(function(){
			  setTitle("<spring:message code="sys.merchant.table.name"/>");
		 });
		
		//设置心新增修改参数为新增
		$("#addOrUpdate").val("add");
		 //$("#orgSelect").select2();
		 $("#selectMerchants").select2();
		//查询框是否在一行设置
		var config = {
			resizeSearchDiv : false,
			language : {
				url : basePath + '<spring:message code="common.language"/>'
			}
		};
		//init table and fill data
		merchantTable = new CommonTable("merchant_table", "merchantTable",
				"merchantSearchDiv", "/sys/merchant/list", config);
		$('button[data-btn-type]')
				.click(
						function() {
							var action = $(this).attr('data-btn-type');
							var merchantRowId = merchantTable
									.getSelectedRowId();
							switch (action) {
							case 'merchantAdd':
									 setTitle('<spring:message code="add.merchant"/>');//设置界面显示信息
									 $("#nav-tab-edit").click();
									 $("#merFormOrgSelect").val("");
									 $("#merFormOrgSelectValue").val("");
									 $("#merName").val("");
									 $("#merId").val("");
									 $("#merIdOld").val("");
									 $("#linkMan").val("");
									 $("#linkPhone").val("");
									 $("#longitude").attr("value","");
									 $("#address").attr("value","");
									 $("#latitude").attr("value", "");
									 $("#addOrUpdate").val("add");
									 $(".form-horizontal").data("bootstrapValidator").resetForm();
								break;
							case 'merchantBatchAdd':
								modals.openWin({
											winId : winId,
											title : '<spring:message code="batch.import.merchant"/>',
											width : '900px',
											url : basePath
													+ "/sys/merchant/toBatchAddMerchant"
										});
								break;
							case 'merchantEdit':
								if (!merchantRowId) {
									modals
											.info('<spring:message code="common.promt.edit"/>');
									return false;
								}
								setTitle("<spring:message code="sys.merchant.edit"/>");
								$("#nav-tab-edit").click();
								$("#addOrUpdate").val("update");
								ajaxPost(basePath+"/sys/merchant/MerchantEditOrAdd?id="+merchantRowId, null, function(data) {
											//重置
											 $("#merFormOrgSelect").val("");
											 $("#merFormOrgSelectValue").val("");
											 $("#merName").val("");
											 $("#merId").val("");
											 $("#merIdOld").val("");
											 $("#linkMan").val("");
											 $("#linkPhone").val("");
											 $("#longitude").attr("value","");
											 $("#address").attr("value","");
											 $("#latitude").attr("value", "");
											 //根据orgId查询机构名称
											 ajaxPost(basePath+"/sys/office/get?id="+data.orgId, null, function(dataOrg) {
												 $("#merFormOrgSelectValue").val(dataOrg.name);
											 });
											//赋值
										     $("#id").val(data.id);
											 $("#merFormOrgSelect").val(data.orgId);
											 $("#merName").val(data.merName);
											 $("#merId").val(data.merId);
											 $("#merIdOld").val(data.merId);
											 $("#linkMan").val(data.linkMan);
											 $("#linkPhone").val(data.linkPhone);
											 $("#longitude").attr("value",data.longitude);
											 $("#address").attr("value",data.address);
											 $("#latitude").attr("value", data.latitude);
											// $(".merchant-form").form().data('bootstrapValidator').resetForm();
											 $(".form-horizontal").data("bootstrapValidator").resetForm();
								});
								break;
							case 'merchantDelete':
								if (!merchantRowId) {
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
																+ "/sys/merchant/delete?id="
																+ merchantRowId,
														null,
														function(data) {
															if (data.code == 200) {
																modals
																		.correct({
																			title : '<spring:message code="common.sys.success" />',
																			cancel_label : '<spring:message code="common.confirm" />',
																			text : data.message
																		});
																merchantTable
																		.reloadRowData();
															} else {
																modals
																		.warn(date.message);
															}
														});
											}
										});
								break;
							case 'toBoundTerm':
								$.ajax({
									url : basePath
											+ "/sys/merchant/toBoundTerm",
									dataType : "html",
									success : function(res) {
										$("#listForm").html(res);
									}
								});
								break;
							case 'merTermUnBoundImport':
								modals
										.openWin({
											winId : winId,
											title : '<spring:message code="modules.device.importing.equipment.by.product.batch"/>',
											width : '1200px',
											url : basePath
													+ "/sys/merchant/merTermUnBoundImport"
										});
								break;
							 case 'cancel':
			                        $("#nav-tab-list").click();
			                        $("#addOrUpdate").val("add");
			                     break;
							}

						});
		$("#merchant-form").bootstrapValidator({
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
				},
				merName : {
					validators : {
						notEmpty : {
							message : '<spring:message code="merchant.name.not.empty"/>'
						},
						stringLength : {
							min : 1,
							max : 32,
							message : '<spring:message code="edit.merchantName"/>'
						}
					}
				},
				merId : {
					validators : {
						notEmpty : {
							message : '<spring:message code="sys.merchant.merId.not.empty"/>'
						},
						stringLength : {
							min : 6,
							max : 20,
							message : '<spring:message code="sys.merchant.merId.length.not.invalid"/>'
						},
						remote : {
							url : basePath
									+ "/sys/merchant/checkMerId",
							delay : 2000,
							data: function(validator) {
	                            return {
	                            	merId:$('#merId').val(),
	                            	merIdOld:$('#merIdOld').val(),
	                            	id:$("#id").val()
	                            };
	                        },
							message : '<spring:message code="sys.merchant.exist"/>'
						}
					}
				},
				linkMan : {
					validators : {
						notEmpty : {
							message : '<spring:message code="linkman.not.empty"/>'
						},
						stringLength : {
							min : 1,
							max : 32,
							message : '<spring:message code="edit.merchantLinkMan"/>'
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
				address : {
					validators : {
						notEmpty : {
							message : '<spring:message code="address.not.empty"/>'
						},
						stringLength : {
							min :1,
							max : 32,
							message : '<spring:message code="edit.merchantLinkAddress"/>'
						}
					}
				},
				longitude : {
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
				latitude : {
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
				radius : {
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
		})
.on(
		'success.form.bv',
		function(e) {
			// 阻止默认事件提交
			e.preventDefault();
			modals
					.confirm(
							'<spring:message code="common.confirm.save"/>',
							function() {
								var params = $("#merchant-form").form().getFormSimpleData();
								 ajaxPost(basePath+'/sys/merchant/save', params, function(data, status) {
										if (data.code == '200' || data.code == 200) {
											var addOrUpdate = $("#addOrUpdate").val();
											if (addOrUpdate == "update") {//更新
												modals.info({
							                        title:'<spring:message code="common.sys.info" />', 
							                        cancel_label:'<spring:message code="common.close" />',
							                        text:'<spring:message code="common.editSuccess" />'}); 
													merchantTable.reloadRowData($('#id').val());
											} else if(addOrUpdate == "add") {//新增
												modals.info({
							                        title:'<spring:message code="common.sys.info" />', 
							                        cancel_label:'<spring:message code="common.close" />',
							                        text:'<spring:message code="common.AddSuccess" />'});

												merchantTable.reloadData();
												 $("#merFormOrgSelect").val("");
												 $("#merFormOrgSelectValue").val("");
												 $("#merName").val("");
												 $("#merId").val("");
												 $("#linkMan").val("");
												 $("#linkPhone").val("");
												 $("#longitude").attr("value","");
												 $("#address").attr("value","");
												 $("#latitude").attr("value", "");
											}
											  $("#nav-tab-list").click();
											  setTitle("<spring:message code="sys.merchant.table.name"/>");
											  $("#csrftoken").val("");
										} else{
											modals.error(data.message);
										}
							}); 
						});
		});

	});
	/* class='btn btn-sm btn-primary' */
	function manageTerm(countTerm) {
		var oper = "&nbsp;&nbsp;&nbsp;";
		oper += "<a href='javascript:void(0)'   onclick='toManageTerm()'>"
				+ countTerm + "</a>";
		return oper;
	}
	function toManageTerm() {
		var merchantRowId = merchantTable.getSelectedRowId();
		if(merchantRowId != null && merchantRowId !==''){
			$.ajax({
				url:basePath+'/device/toBoundDevice',
				type:'POST',
				traditional:true,
				data:{'mId':merchantRowId},
				success:function(res){
					$("#listForm").html(res);
				}
			});
		}
	}
	/* $(function() {
		var secSelect = document.getElementById("orgSelect");
		//secSelect.options.length = 0;
		$.ajax({
			url : basePath + '/sys/office/treeData',
			success : function(dataJson) {
				for (var i = 0; i < dataJson.length; i++) {
					var oOption = document.createElement("OPTION");
					oOption.value = dataJson[i].id;
					var parent = dataJson[i].parentId;
					oOption.text = dataJson[i].text;
					var nodes = dataJson[i].nodes;
						$(oOption).attr('parent', parent);
					if (nodes == null) {

					} else {
						childs(nodes);
					}
					secSelect.options.add(oOption);
				}
			}
		});
		function childs(nodeses) {
			for (var i = 0; i < nodeses.length; i++) {
				var oOption = document.createElement("OPTION");
				oOption.value = nodeses[i].id;
				var parent = nodeses[i].parentId;
				oOption.text = nodeses[i].text;
				var nodes = nodeses[i].nodes;
				if (parent !== "0") {
					$(oOption).attr('parent', parent);
				} 
				if (nodes == null) {

				} else {
					childs(nodes);
				}
				secSelect.options.add(oOption);
			}
		}
	}); */

	$(function(){
		$("#merOrgSelectValue").click(function(){
					modals
					.openWin({
						winId : "merOrgTree",
						title : '<spring:message code="modules.device.importing.equipment.by.product.batch"/>',
						width : '300px',
						url : basePath
								+ "/sys/office/toOfficeTree?windowId=merOrgTree&orgSelect=merOrgSelect&orgSelectValue=merOrgSelectValue"
					});
	});
	/* $("#orgSelect").change(function(){
			var secSelect = document.getElementById("selectMerchants");
			var orgId = this.value;
			secSelect.options.length = 0;
			$.ajax({
				url:basePath+'/sys/merchant/merchants?orgId='+orgId,
				success:function(res){
					 var dataJson = res.data;
					 for ( var i = 0; i < dataJson.length; i++) {
						 var oOption = document.createElement("OPTION");
					        oOption.value = dataJson[i].merId;
					        oOption.text = dataJson[i].merName;
					        secSelect.options.add(oOption);
					 }
				}
			});
		}); */
});
	$(function() {
		// 百度地图API功能===================================================================================================
		var geolocationControl = new BMap.GeolocationControl();
		var geolocation = new BMap.Geolocation();
		var lo = 116.331398;
		var la = 39.897445;
		var point = new BMap.Point(lo, la);
		var map = new BMap.Map("allmap");
		map.centerAndZoom(point, 12);
		// 创建地址解析器实例
		var myGeo = new BMap.Geocoder();
		// 添加定位控件

		geolocationControl.addEventListener("locationSuccess", function(e) {
			// 定位成功事件
			var address = '';
			address += e.addressComponent.province;
			address += e.addressComponent.city;
			address += e.addressComponent.district;
			address += e.addressComponent.street;
			address += e.addressComponent.streetNumber;
			modals.info("<spring:message code='current.location.address'/>："
					+ address);
		});
		geolocationControl.addEventListener("locationError", function(e) {
			// 定位失败事件
			modals.info(e.message);
		});
		map.addControl(geolocationControl);
		$("#address")
				.blur(
						function() {
							var addr = this.value;
							// 将地址解析结果显示在地图上,并调整地图视野
							myGeo
									.getPoint(
											addr,
											function(point) {
												if (point) {
													map.centerAndZoom(
															point, 16);
													map
															.addOverlay(new BMap.Marker(
																	point));
													geolocation
															.getCurrentPosition(
																	function(
																			r) {
																		if (this
																				.getStatus() == BMAP_STATUS_SUCCESS) {
																			var mk = new BMap.Marker(
																					point);
																			map
																					.addOverlay(mk);
																			map
																					.panTo(point);
																			$(
																					"#longitude")
																					.attr(
																							"value",
																							point.lng);
																			$(
																					"#latitude")
																					.attr(
																							"value",
																							point.lat);
																		} else {
																			modals.info('failed'
																					+ this
																							.getStatus());
																		}
																	},
																	{
																		enableHighAccuracy : true
																	});
												} else {
													modals.info("<spring:message code='address.not.resolved.to.result'/>");
												}
											}, "北京市");
						});
		map.addEventListener("click", function(e) {
			map.clearOverlays();
			var pt = e.point;
			myGeo.getLocation(pt, function(rs) {
				var addComp = rs.addressComponents;
				var address = addComp.province + addComp.city
						+ addComp.district + addComp.street
						+ addComp.streetNumber;
				$("#address").attr('value', address);
			});
			geolocation.getCurrentPosition(function(r) {
				if (this.getStatus() == BMAP_STATUS_SUCCESS) {
					var mk = new BMap.Marker(pt);
					map.addOverlay(mk);
					map.panTo(pt);
					$("#longitude").attr("value", pt.lng);
					$("#latitude").attr("value", pt.lat);
				} else {
					modals.info('failed' + this.getStatus());
				}
			}, {
				enableHighAccuracy : true
			});
		});
		map.enableScrollWheelZoom(true); //开启鼠标滚轮缩放
		//==============================================================================================================
});
</script>
<style type="text/css">
 .treeview {
		 overflow-y:auto;
		 height:300px;
		 }
</style>
