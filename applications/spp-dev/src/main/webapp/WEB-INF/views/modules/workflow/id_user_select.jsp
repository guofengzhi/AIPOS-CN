<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<link rel="stylesheet" href="${basePath}/adminlte/plugins/datatables/dataTables.bootstrap.css">
<section class="content-header">
	<div class="modal-header">
	    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
	        <li class="fa fa-remove"></li>
	    </button>
	    <h4 class="modal-title"></h4>
	</div>
</section>

<section class="content">
	<div class="modal-body">
	    <div class="box box-info" style="margin-top:-10px;margin-bottom: 10px;">
	        <input type="hidden" id="userIds">
	        <input type="text" readonly id="userNames" class="form-control" placeholder="<spring:message code='workflow.already.select.user'/>">
	    </div>
	    <div class="box box-primary">
	        <div class="dataTables_filter" id="searchDiv_user_select" style="float: right;">
	            <div class="btn-group">
	                <input placeholder="<spring:message code='sys.login.tip.iputADM'/>" name="name" class="form-control" type="search" likeOption="true"/>
	            </div>
	            <div class="btn-group">
	                <button type="button" class="btn btn-default" data-btn-type="search"><spring:message code="common.query"/></button>
                        <button type="button" class="btn btn-primary" data-btn-type="select" id="selectUser"><spring:message code="workflow.is.select"/></button>
	            </div>
	        </div>
	        <div class="box-body">
	            <table id="user_select_table" class="table table-bordered table-striped table-hover">
	            </table>
	        </div>
	    </div>
	</div>
</section>
<script type="text/javascript" src="${basePath}/adminlte/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript"
        src="${basePath}/adminlte/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="${basePath}/common/js/dataTables.js"></script>
<script type="text/javascript" src="${basePath}/common/js/base-form.js"></script>
<script type="text/javascript" src="${basePath}/common/js/base-datasource.js"></script>
<script>
    var userSelectTable;
    var ids = "${empty ids?0:ids}";//回填ids
    ids = ids == 0 ? '' : ids;
    var multiple = "${empty multiple?0:multiple}";//默认单选

    //用户选择控制器
    var userSelectCtrl = {
    		initTable: function () {
                jQuery("#userIds").val(ids);
                this.updateSelectedUserNames();
                var self = this;
                var config={
                		language : {
            				url: basePath+'<spring:message code="common.language"/>'
            			}
                };
                userSelectTable = new CommonTable("user_select_table", "id_user_list", "searchDiv_user_select", "/activiti/user/getUserList", config);
                
                //回调选中
                userSelectTable.serverCallback = function () {
                    self.setCheckBoxState();
                }
            },
            //查询 换页选择框回填
            setCheckBoxState: function () {
                var selectUserIds = jQuery("#userIds").val();
                if (selectUserIds) {
                    var userIdArr = selectUserIds.split(",");
                    //选中增加的用户
                    jQuery.each(userIdArr, function (index, userId) {
                        if (userSelectTable.table.$("#" + userId).length > 0) {
                            userSelectTable.table.$("#" + userId).find(":checkbox.checkbox_user").prop("checked", true);
                        }
                    });
                    //删除已经选中的
                    userSelectTable.table.$("tr").find(":checkbox.checkbox_user:checked").each(function () {
                        var curUserId = jQuery(this).parents("tr").attr("id");
                        //找不到，已经被删除
                        if (selectUserIds.indexOf(curUserId) == -1) {
                            userSelectTable.table.$("#" + curUserId).find(":checkbox.checkbox_user").prop("checked", false);
                        }
                    });
                } else {
                    jQuery(":checkbox.checkbox_user").prop("checked", false);
                }
            },
            //绑定用户选择事件
            bindSelectUserEvent: function () {
                jQuery("#selectUser").click(function () {
                    var controllerScope = jQuery('div[ng-controller="KisBpmAssignmentPopupCtrl"]').scope();  // Get controller's scope
                    var userIds = jQuery("#userIds").val();
                    var userNames = jQuery("#userNames").val();
                    if (multiple == 0) {
                        controllerScope.setAssignee(userIds, userNames);
                    } else {
                        controllerScope.setCandidateUsers(userIds, userNames);
                    }
                    modals.hideWin("userSelectWin");
                })
            },
            selectThis: function (obj) {
                var isChecked = jQuery(obj).is(":checked");
                //单选
                var userIds = jQuery("#userIds").val();
                if (userIds && userIds.split(',').length == 1 && multiple == 0 && isChecked) {
                    alert("<spring:message code='workflow.only.select.one.user'/>");
                    jQuery(obj).attr("checked", false);
                    return;
                }
                var value = jQuery(obj).parents("tr").eq(0).attr("id");
                var userArr = this.getSelectedUserArr(userIds, value, isChecked);
                jQuery("#userIds").val(userArr.join(","));
                this.updateSelectedUserNames();
            },
            updateSelectedUserNames: function () {
                var userIds = jQuery("#userIds").val();
                if (userIds == 0 || !userIds) {
                    jQuery("#userNames").val("");
                } else {
                    ajaxPost(basePath + "/activiti/user/names", {ids: userIds}, function (map) {
                        jQuery("#userNames").val(map.name);
                    });
                }
            },
            getSelectedUserArr: function (userIdss, curValue, isChecked) {
                var userArr = [];
                if (userIdss)
                    userArr = userIdss.split(",");
                if (isChecked) {
                    var flag = true;
                    for (var i = 0; i < userArr.length; i++) {
                        if (userArr[i] == curValue) {
                            flag = false;
                            break;
                        }
                    }
                    if (flag)
                        userArr.push(curValue);
                } else {
                    for (var i = 0; i < userArr.length; i++) {
                        var userIdValue = userArr[i];
                        if (userIdValue == curValue) {
                            userArr.splice(i, 1);
                            break;
                        }
                    }
                }
                return userArr;
            }
    }


    function fnRenderSelectUser(value) {
        return "<input type='checkbox' value='1' class='checkbox_user' onchange='userSelectCtrl.selectThis(this)'>";
    }
    
    //方法入口
    jQuery(function () {
        userSelectCtrl.initTable();
        userSelectCtrl.bindSelectUserEvent();
    })
</script>
