<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<%@ include file="/WEB-INF/views/common/treeview.jsp"%>
<!-- Main content -->
    <div class="box-body" style="float: left; width: 450px; height: 500px; margin-left: 5px; margin-right: 20px; border:1px solid #337ab7;">
                <div class="col-sm-12" style="padding:15px 20px; font-size:20px; height:430px; overflow-y:auto">  
                       <ul id="treeDemo" class="ztree"></ul>  
                </div>  
                <div class="box-footer text-right">
			        <!--以下两种方式提交验证,根据所需选择-->
			       <button type="button" class="btn btn-default" id="cancel_button"><spring:message code="common.cancel"/></button>
			       <button type="button" class="btn btn-primary" id="submit_button"><spring:message code="common.submit"/></button>&nbsp;&nbsp;&nbsp;&nbsp;
		        </div>
	</div>
    <div class="box-body" style="overflow-y:auto; overflow-x:hidden; width: auto; height: 500px; border:1px solid #337ab7;">
                <div class="dataTables_filter" id="logFileSearchDiv">
			        <button type="button" class="btn btn-success" id="reset_button"><spring:message code="modules.device.refresh"/></button>
		        </div>
                <table id="log_table"
				     class="table table-bordered table-striped table-hover">
			    </table>
    </div>

<script>
var deviceId = $("#deviceId").val();
var deviceSn = $("#sn").val();

var zTreeObj;
var setting = {   // zTree 的参数配置
		view: {
		    selectedMulti: false, //设置是否能够同时选中多个节点
		    showIcon: true,  //设置是否显示节点图标
		    showLine: true,  //设置是否显示节点与节点之间的连线
		    showTitle: true,  //设置是否显示节点的title提示信息
		   },
		   data: {
		     simpleData: {
		     enable: true, //设置是否启用简单数据格式（zTree支持标准数据格式跟简单数据格式，上面例子中是标准数据格式）
		     idKey: "id",  //设置启用简单数据格式时id对应的属性名称
		     pidKey: "pId" //设置启用简单数据格式时parentId对应的属性名称,ztree根据id及pid层级关系构建树结构
		    },
		    keep:{
		    	parent:true //目录下无叶子结点后，依然是文件夹状态
		    }
		   },
		   /* check: {
			   enable: true,
			   chkStyle: "radio",
			   radioType: "level"
		   }, */
		   check:{
		    enable: true,   //设置是否显示checkbox复选框
		    chkboxType : {"Y": "", "N": ""}
		   }, 
		   callback: {
			    //onClick: onClick,    //定义节点单击事件回调函数
			    //onRightClick: OnRightClick, //定义节点右键单击事件回调函数
			    //beforeRename: beforeRename, //定义节点重新编辑成功前回调函数，一般用于节点编辑时判断输入的节点名称是否合法
			    //onDblClick: onDblClick,  //定义节点双击事件回调函数
			    onCheck: onCheck,    //定义节点复选框选中或取消选中事件的回调函数
		        //onCollapse: collapseNode,  //节点折叠的事件回调函数
		        onExpand: expandNode  //节点展开的事件回调函数
		    },  
};

$(document).ready(function () {

	//初始化加载菜单树
	initTreeNode();
	
	//初始化加载日志文件列表
	initTables();
});

function initTreeNode(){
	//获取菜单树效果
	ajaxPost(
			basePath+'/device/createDeviceAppTree', 
			{deviceId:deviceId},  
			function(data, status) 
			{
				if(data != null){
					zTreeObj = $.fn.zTree.init($("#treeDemo"), setting, data); //初始化zTree，三个参数一次分别是容器(zTree 的容器 className 别忘了设置为 "ztree")、参数配置、数据源
				}
	});
}

//展开文件夹事件  @auther Pang.M 2017年11月15日
function expandNode(e, treeId, treeNode){
	if (!treeNode.isParent) //如果是叶子结点，结束
		 return;
	if(treeNode.target == '0')
		 return;
	if(treeNode.children != null){
		 return;
	}
    //获取当前结点上的相关属性数据，执行相关逻辑
	ajaxPost(
			basePath+'/device/recDirectory', 
			{deviceSn:deviceSn,packageName:treeNode.name,id:treeNode.target},  
			function(data, status) 
			{
				if(data.code == 200){
				    zTreeObj.removeChildNodes(treeNode);
					var node = [
						{name: '<spring:message code="modules.device.loading"/>',nocheck: true}
					] 
					zTreeObj.addNodes(treeNode, node);
					
					//设置等待友好提示窗口
					layer.msg('<spring:message code="modules.device.loading"/>', {icon: 16,tips: [1, '#3595CC'],area: ['250px', '70px'],shade: [0.5, '#f5f5f5'],scrollbar: false,time: 60000}) ; 
					
					recDirectory(treeNode,data.data.id);
					
				}
				if(data.code == 400){
					modals.warn(data.message);
				}
		});
	
}

//获取文件节点  @auther Pang.M 2017年11月15日
function recDirectory(treeNode,recordId){
	$.when(ajaxPostWithDeferred(
			basePath+'/device/createDirectoryNode', 
			{recordId:recordId},  
			function(data, status){})).done(function(data) 
			{
				//关闭等待友好提示窗口
				layer.close(layer.index);
				if(data.code == 200){
					zTreeObj.removeChildNodes(treeNode);
					var node = data.data;
					zTreeObj.addNodes(treeNode, node);
				}
				
				if(data.code == 400){
					zTreeObj.removeChildNodes(treeNode);
					modals.warn(data.message);
				}
			});
}


//提交checkbox，获取文件日志 @auther Pang.M 2017年11月15日
$('#submit_button').click(function(){
	var deviceSn = $("#sn").val();
	var nodes=zTreeObj.getCheckedNodes(true);
	if(nodes.length <= 0){
		modals.info('<spring:message code="modules.device.select.file"/>')
		return;
	}
        
	var jsonObj = {};
	jsonObj["target"]=nodes[0].target;
	jsonObj["name"]=nodes[0].name;
		
	ajaxPost(basePath+'/device/checkLog', {check:JSON.stringify(jsonObj),deviceSn:deviceSn},  function(data, status) {
		if(data.code == 200){
			//上传APP编号
			modals.correct(data.message);
		}else{
			modals.warn(data.message);
		}				 
   });
})

$('#cancel_button').click(function(){
	zTreeObj.checkAllNodes(false);
})

function onCheck(e, treeId, treeNode){
	var nodes=zTreeObj.getCheckedNodes(true);
	for(var i = 0;i<nodes.length;i++){
		if(nodes[i].id != treeNode.id){
			zTreeObj.checkNode(nodes[i]);
		}
	}
}

function download(obj){ 	
	$.download(basePath + "/device/downloadLogFile?logId="+obj.value, "post", "");
}

var logFileTable,winId = "logFileWin";
var config={
		singleSelect:null
};
//获取日志文件列表
function initTables(){
	//init table and fill data
	logFileTable = new CommonTable("log_table", "log_table_list", "logFileSearchDiv",
			"/device/getLogFileList/" + deviceSn,config);
}

function operation(id, type, rowObj){
	var oper = "";
	oper += "<button type='button' class='btn btn-primary' id='download' value="+ id +" onclick='javascript:download(this);'>"+'<spring:message code="modules.device.download"/>'+"</button>";
	return oper;
}
	
$('#reset_button').click(function(){
	logFileTable.reloadData();
})
</script>
