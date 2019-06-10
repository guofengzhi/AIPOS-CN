<%@ page contentType="text/html;charset=UTF-8"%>
<script type="text/javascript">
var basePath="${basePath}";//给外部js文件传递路径参数
</script>


	<!-- dataTable -->
	<script
		src="${ctxStatic}/adminlte/plugins/datatables/jquery.dataTables.js"></script>
	<script
		src="${ctxStatic}/adminlte/plugins/datatables/dataTables.bootstrap.min.js"></script>
	<script src="${ctxStatic}/common/js/dataTables.js"></script>
	<script type="text/javascript"
		src="${ctxStatic}/adminlte/plugins/bootstrapvalidator/dist/js/bootstrapValidator.js"></script>
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
	<!-- select2 -->
	<script src="${ctxStatic}/adminlte/plugins/select2/select2.full.min.js"></script>
	<!-- jquery-number -->
	<script src="${ctxStatic}/common/libs/jquery-number/jquery.number.min.js"></script>
	
	<!-- bootstrap-fileinput -->
	<script src="${ctxStatic}/common/libs/bootstrap-fileinput/js/fileinput.min.js"></script>
	<script src="${ctxStatic}/common/libs/bootstrap-fileinput/js/locales/zh.js"></script>
	<script src="${ctxStatic}/common/libs/bootstrap-fileinput/js/locales/zh-TW.js"></script>
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
		src="${ctxStatic}/common/js/base-form.js"></script>
	<script type="text/javascript"
		src="${ctxStatic}/common/js/base-datasource.js"></script>
	<script type="text/javascript"
		src="${ctxStatic}/common/js/base-file.js"></script>
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
			  $menu_s=$('<li><a href="#" data-addtab="'+item.id+'" data-url="'+basePath+item.url+'" data-title="'+item.name+'"><i class="'+item.icon+'"></i>'+item.name+'</a></li>');
			  $menu_f_ul.append($menu_s); 
		  } 
		  
	  });
   });  
   
   $(function(){ 
	   //首页默认加载
        loadPage(basePath+"/homePage", true);
	    $("a[data-url]").click(function(evt){
		   loadPage($(this).data("url"),true);
		   $("ul.treeview-menu li").removeClass("active");
		   $(this).parent().addClass("active");
	   }); 
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
</script>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=4IU3oIAMpZhfWZsMu7xzqBBAf6vMHcoa"></script>