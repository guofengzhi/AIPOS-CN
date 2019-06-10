<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<link rel="stylesheet" href="${basePath}/adminlte/plugins/datatables/dataTables.bootstrap.css">
<style>
    table.dataTable thead > tr > th {
        padding-right: 0px;
    }
</style>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
        <li class="fa fa-remove"></li>
    </button>
    <h4 class="modal-title"></h4>
</div>
<div class="modal-body">
    <div class="row" style="margin-top:-10px;margin-bottom: 10px;">
        <input type="hidden" id="groupIds">
        <div class="col-xs-7">
            <input type="text" readonly id="groupNames" class="form-control"  placeholder="<spring:message code='workflow.already.select.user.group'/>">
        </div>
        <div class="col-xs-5">
            <span id="userTitle"><h5 id='groupName' class='pull-left'><spring:message code="workflow.user.list" /></h5></span>
        </div>
    </div>
    <div class="row">
        <div class="col-xs-7">
            <div class="box">
                <div class="dataTables_filter" id="searchDiv_group_select">
                    <div class="btn-group">
                        <input placeholder="<spring:message code='workflow.print.user.nameorcode' />" name="name" class="form-control" type="search" likeOption="true"/>
                    </div>
                    <div class="btn-group">
                        <button type="button" class="btn btn-default" data-btn-type="search"><spring:message code="common.query"/></button>
                        <button type="button" class="btn btn-primary" data-btn-type="select" id="selectUser"><spring:message code="workflow.is.select"/></button>
                    </div>
                </div>
                <div class="box-body">
                    <table id="group_select_table" class="table table-bordered table-stripped table-hover">
                    </table>
                </div>
            </div>
        </div>
        <div class="col-xs-5">
            <div class="box">
                <!--隐藏域保存选中的用户-->
                <div class="dataTables_filter" id="searchDiv_user_select">
                    <div class="btn-group">
                        <input placeholder="<spring:message code='sys.login.tip.iputADM'/>" name="name" class="form-control" type="search"
                               likeOption="true"/>
                        <input type="hidden" name="groupId" id="groupId" operator="eq" likeOption="false" value="-1"/>
                    </div>
                    <div class="btn-group">
                        <button type="button" class="btn btn-default" data-btn-type="search"><spring:message code="common.query"/></button>
                    </div>
                </div>
                <div class="box-body">
                    <table id="user_select_table" class="table table-bordered table-stripped table-hover">
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript" src="${basePath}/adminlte/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript"
        src="${basePath}/adminlte/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="${basePath}/common/js/dataTables.js"></script>
<script type="text/javascript" src="${basePath}/common/js/base-form.js"></script>
<script type="text/javascript" src="${basePath}/common/js/base-datasource.js"></script>
<script>
    var groupSelectTable;
    var userSelectTable;
    var ids = "${empty ids?0:ids}";//回填ids
    ids = ids == 0 ? '' : ids;
    //用户选择控制器
    var userSelectCtrl = {
        initTable: function () {
            jQuery("#groupIds").val(ids);
            this.updateSelectedUserNames();
            var self = this;
            var config = {
                rowClick: function (row, isSelected) {
                    jQuery("#groupId").val(isSelected ? row.id : "-1");
                    jQuery("#groupName").remove();
                    if (isSelected)
                        jQuery("#userTitle").append("<h5 id='groupName' class='pull-left'>【" + row.name + "】</h5>");
                    userSelectTable.reloadData();
                },
                language : {
            		url: basePath+'<spring:message code="common.language"/>'
            	}
            };
            groupSelectTable = new CommonTable("group_select_table", "id_group_list", "searchDiv_group_select","/activiti/user/getGroupList", config);
            //回调选中
            groupSelectTable.serverCallback = function () {
                self.setCheckBoxState();
            };

            var userConfig={
                lengthChange:false,
                pagingType:'simple_numbers',
                language : {
            		url: basePath+'<spring:message code="common.language"/>'
            	}
            };
            userSelectTable = new CommonTable("user_select_table", "id_membership_list", "searchDiv_user_select","/activiti/user/getUserList", userConfig);
        },
        //查询 换页选择框回填
        setCheckBoxState: function () {
            var selectUserIds = jQuery("#groupIds").val();
            if (selectUserIds) {
                var userIdArr = selectUserIds.split(",");
                //选中增加的用户
                jQuery.each(userIdArr, function (index, userId) {
                    if (groupSelectTable.table.$("#" + userId).length > 0) {
                        groupSelectTable.table.$("#" + userId).find(":checkbox.checkbox_group").prop("checked", true);
                    }
                });
                //删除已经选中的
                groupSelectTable.table.$("tr").find(":checkbox.checkbox_group:checked").each(function () {
                    var curUserId = jQuery(this).parents("tr").attr("id");
                    //找不到，已经被删除
                    if (selectUserIds.indexOf(curUserId) == -1) {
                        groupSelectTable.table.$("#" + curUserId).find(":checkbox.checkbox_group").prop("checked", false);
                    }
                });
            } else {
                jQuery(":checkbox.checkbox_group").prop("checked", false);
            }
        },
        //绑定用户组选择事件
        bindSelectUserEvent: function () {
            jQuery("#selectUser").click(function () {
                var controllerScope = jQuery('div[ng-controller="KisBpmAssignmentPopupCtrl"]').scope();  // Get controller's scope
                var userIds = jQuery("#groupIds").val();
                var userNames = jQuery("#groupNames").val();
                controllerScope.setCandidateGroups(userIds, userNames);
                modals.hideWin("groupSelectWin");
            })
        },
        selectThis: function (obj) {
            var isChecked = jQuery(obj).is(":checked");
            //单选
            var userIds = jQuery("#groupIds").val();
            var value = jQuery(obj).parents("tr").eq(0).attr("id");
            var userArr = this.getSelectedUserArr(userIds, value, isChecked);
            jQuery("#groupIds").val(userArr.join(","));
            this.updateSelectedUserNames();
        },
        updateSelectedUserNames: function () {
            var userIds = jQuery("#groupIds").val();
            if (userIds == 0 || !userIds) {
                jQuery("#groupNames").val("");
            } else {
                ajaxPost(basePath + "/activiti/group/names", {ids: userIds}, function (map) {
                    jQuery("#groupNames").val(map.name);
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
        return "<input type='checkbox' value='1' class='checkbox_group' onchange='userSelectCtrl.selectThis(this)'>";
    }
    //方法入口
    jQuery(function () {
        userSelectCtrl.initTable();
        userSelectCtrl.bindSelectUserEvent();
    })
</script>
