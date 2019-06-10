<%@ page contentType="text/html;charset=UTF-8"%>
<script type="text/javascript">
var basePath="${basePath}";//给外部js文件传递路径参数
var jumppage="<spring:message code='common.table.jumppage' />";//给datatable.js传递跳转页值
var cancel="<spring:message code='common.cancel' />";//给base-org.js传递取消值
var remove="<spring:message code='common.remove' />";//给base-org.js传递移除值
</script>

	<!-- dataTable -->
	<script
		src="${ctxStatic}/adminlte/plugins/datatables/jquery.dataTables.js"></script>
	<script
		src="${ctxStatic}/adminlte/plugins/datatables/dataTables.bootstrap.min.js"></script>
	<script src="${ctxStatic}/common/js/dataTables.js"></script>
	<!-- form -->
	<script
		src="${ctxStatic}/adminlte/plugins/datepicker/bootstrap-datepicker.js"></script>
	<script
		src="${ctxStatic}/adminlte/plugins/datepicker/locales/bootstrap-datepicker.zh-CN.js"></script>
	<script
		src="${ctxStatic}/adminlte/plugins/datepicker/locales/bootstrap-datepicker.zh-TW.js"></script>
	<!-- treeview -->
	<script
		src="${ctxStatic}/adminlte/plugins/bootstrap-treeview/bootstrap-treeview.js"></script>
		<!-- AdminLTE for demo purposes -->
		<script src="${ctxStatic}/adminlte/dist/js/demo.js"></script>
	<!-- select2 -->
	<script src="${ctxStatic}/adminlte/plugins/select2/select2.full.min.js"></script>
	<!-- jquery-number -->
	<script src="${ctxStatic}/common/libs/jquery-number/jquery.number.min.js"></script>
	
	<!-- bootstrap-fileinput -->
	<script src="${ctxStatic}/common/libs/bootstrap-fileinput/js/fileinput.min.js"></script>
	<script src="${ctxStatic}/common/libs/bootstrap-fileinput/js/locales/zh.js"></script>
	<script
		src="${ctxStatic}/common/libs/bootstrap-addtabs/bootstrap.addtabs.js"></script>
	<script
		src="${ctxStatic}/common/libs/textavatar/jquery.textavatar.js"></script>
	<!-- layer.js -->
	<script 
	src="${ctxStatic}/common/libs/layer/layer.js"></script>
	<!-- custom js -->
	<script type="text/javascript" src="${ctxStatic}/common/js/base-language.js"></script>
	<script type="text/javascript" src="${ctxStatic}/common/js/base.js"></script>
	<script type="text/javascript"
		src="${ctxStatic}/common/js/base-modal.js"></script>
		<script type="text/javascript"
		src="${ctxStatic}/common/js/base-org.js"></script>
	<script type="text/javascript"
		src="${ctxStatic}/common/js/base-form.js"></script>
	<script type="text/javascript"
		src="${ctxStatic}/common/js/base-datasource.js"></script>
	<script type="text/javascript"
		src="${ctxStatic}/common/js/base-file.js"></script>
	<script type="text/javascript"
		src="${ctxStatic}/common/libs/markdown/editor.md/js/editormd.min.js"></script>
	<script type="text/javascript"
		src="${ctxStatic}/common/libs/tagsinput/bootstrap-tagsinput.min.js"></script>
	<script type="text/javascript" 
	       src="${ctxStatic}/common/js/contabs.js"></script>	
	<!-- 加入页面的的脚本 -->
	<script>
	$(".select2").select2();
   //加载菜单
   ajaxPost(basePath+"/getMenuList",null,function(data){
	  var $li,$menu_f_ul;
	  $.each(data,function(index,item){
		  if(item.levelCode.length==6){	
			  $li=$('<li class="treeview"></li>');
			  var $menu_f=$('<a href="#">\n'+
					           '<i class="'+item.icon+'"></i> <span>'+item.name+'</span>\n'+
                                ' <span class="pull-right-container">\n'+
					           '<i class="fa fa-angle-left pull-right"></i>\n'+
				            '</span></a>');
			  $li.append($menu_f);
			  $menu_f_ul=$('<ul class="treeview-menu"></ul>');
			  $li.append($menu_f_ul);
			  $("ul.sidebar-menu").append($li); 
		  } 
		  else if(item.levelCode.length==12){
			 //  $menu_s=$('<li><a  class="J_menuItem"  data-addtab="'+item.id+'" href="'+basePath+item.url+'" data-title="'+item.name+'"><i class="'+item.icon+'"></i>'+item.name+'123</a></li>');
			     $menu_s=$('<li><a  class="J_menuItem"  href="'+basePath+item.url+'" data-index="'+index+'"><i class="'+item.icon+'"></i>'+item.name+'</a></li>');
			   $menu_f_ul.append($menu_s); 
		  } 
		  
	  });
   });  
   //计算元素集合的总宽度
   function calSumWidth(elements) {
       var width = 0;
       $(elements).each(function () {
           width += $(this).outerWidth(true);
       });
       return width;
   }
   //滚动到指定选项卡
   function scrollToTab(element) {
       var marginLeftVal = calSumWidth($(element).prevAll()), marginRightVal = calSumWidth($(element).nextAll());
       // 可视区域非tab宽度
       var tabOuterWidth = calSumWidth($(".content-tabs").children().not(".J_menuTabs"));
       //可视区域tab宽度
       var visibleWidth = $(".content-tabs").outerWidth(true) - tabOuterWidth;
       //实际滚动宽度
       var scrollVal = 0;
       if ($(".page-tabs-content").outerWidth() < visibleWidth) {
           scrollVal = 0;
       } else if (marginRightVal <= (visibleWidth - $(element).outerWidth(true) - $(element).next().outerWidth(true))) {
           if ((visibleWidth - $(element).next().outerWidth(true)) > marginRightVal) {
               scrollVal = marginLeftVal;
               var tabElement = element;
               while ((scrollVal - $(tabElement).outerWidth()) > ($(".page-tabs-content").outerWidth() - visibleWidth)) {
                   scrollVal -= $(tabElement).prev().outerWidth();
                   tabElement = $(tabElement).prev();
               }
           }
       } else if (marginLeftVal > (visibleWidth - $(element).outerWidth(true) - $(element).prev().outerWidth(true))) {
           scrollVal = marginLeftVal - $(element).prev().outerWidth(true);
       }
       $('.page-tabs-content').animate({
           marginLeft: 0 - scrollVal + 'px'
       }, "fast");
   }
   function menuItem() {
       // 获取标识数据
       var dataUrl = "/jwp/activiti/task/todo/list",
           dataIndex =0,
           menuName ="&nbsp;&nbsp;&nbsp;<spring:message code="common.homePage" />",
           flag = true;
           var str = '<a href="javascript:;" class="active J_menuTab" data-id="' + dataUrl + '">' + menuName + ' </a>';
         

           // 添加选项卡对应的iframe
           var str1 = '<iframe class="J_iframe" name="iframe' + dataIndex + '" width="100%" height="800px" style="margin-top:3px;vertical-align: middle;"  src="' + dataUrl + '" frameborder="0" data-id="' + dataUrl + '" seamless></iframe>';
           $('.J_mainContent').find('iframe.J_iframe').hide().parents('.J_mainContent').append(str1);

           // 添加选项卡
           $('.J_menuTabs .page-tabs-content').append(str);
           scrollToTab($('.J_menuTab.active'));
          
   }
   $(function(){ 
	   menuItem(); 
	   //首页默认加载
      /*   loadPage(basePath+"/homePage", true);
	    $("a[data-url]").click(function(evt){
		   loadPage($(this).data("url"),true);
		   $("ul.treeview-menu li").removeClass("active");
		   $(this).parent().addClass("active");
	   });  */
   });
   
    function modifyPwd(){
    	var winId = "userWin";
    	 modals.openWin({
				winId : winId,
				title : '修改密码',
				width : '900px',
				url : basePath + "/sys/user/infoData"
			})
    }
    function logout(){
    	  localStorage.rememberLogin = 0;
    	  location.href= basePath+"/logout";
    }
    function updatePh(){
    	var winId = "userWin";
    	 modals.openWin({
				winId : winId,
				title : '编辑头像',
				width : '900px',
				url : basePath + "/sys/user/editPhoto"
			})
    }
</script>
<style type="text/css">
            .treeview-menu {
			 overflow-x:auto;
			 width:165px;
		 }
</style>
