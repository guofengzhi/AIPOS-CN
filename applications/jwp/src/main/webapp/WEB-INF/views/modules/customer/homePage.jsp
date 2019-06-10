<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>
<style>
.info-box {
	border: 1px solid rgba(0, 0, 0, 0.1);
}

.info-box-text {
	text-transform: none;
}

.info-box:hover .info-box-icon {
	font-size: 60px;
}

.info-box-text-sm {
	font-size: 12px;
	font-style: normal;
}

.info-box-text-italic {
	font-size: 14px;
	font-style: italic;
	font-weight: normal;
}

.text-blod {
	font-weight: bold;
}

.title-sm {
	font-weight: normal;
	margin-left: 10px;
}

.info-box-icon {
    border-top-left-radius: 2px;
    border-top-right-radius: 0;
    border-bottom-right-radius: 0;
    border-bottom-left-radius: 2px;
    display: block;
    float: left;
    height: 90px;
    width: 190px; 
    text-align: center;
    font-size: 25px;
    line-height: 90px;
    background: rgba(0,0,0,0.2);
}

.info-box-content {
    /* padding: 5px 10px; */
    /* margin-left: 90px; */
    text-align: center;
    margin-top: 16px;
    font-size: 30px;
}

.info-box:hover .info-box-icon {
    font-size: 30px;
}

</style>
<section class="content-header">
	
	<ol class="breadcrumb">
		<li><a href="#"><i class="fa fa-dashboard"></i> <spring:message code="common.homepage"/></a></li>
		<li class="active">OTA </li>
	</ol>
</section>

<!-- Main content -->
<section class="content">
	<!-- Info boxes -->
	<a name="top"></a>
	<div class="row">
		<div class="col-md-12">
			<div class="box box-info">
				<!-- /.box-header -->
				<div class="box-body bg-info text-center">
					<div class="row">
						<div class="col-md-6 text-right">
							<img src="${ctxStatic}/common/images/admineap.png"
								width="80px" height="80px" alt="AdminEAP" />
						</div>
						<div class="col-md-6 text-left" style="padding-left: 0">
							<h1 class="box-title text-blod"><spring:message code="sys.ota.service.platform"/></h1>
						</div>
					</div>
					<div class="row" style="padding: 5px;">
						<div class="col-md-12">
							<label class="info-box-text-italic">
							<spring:message code="sys.ota.service.description"/>
							</label>
						</div>
					</div>
				</div>

				<!-- /.row -->
			</div>
			<!-- ./box-body -->
		</div>
		<!-- /.box -->
	</div>
	
	<!-- /.col -->
	<a name="curd"></a>
	<div class="row">
		<div class="col-md-12">
			<div class="box box-danger">
				<div class="box-header">
					<h3 class="box-title"><spring:message code="sys.ota.basic.infomation"/></h3>
					<label class="title-sm"></label>
					<div class="box-tools pull-right">
						<button type="button" class="btn btn-box-tool"
							data-widget="collapse">
							<i class="fa fa-minus"></i>
						</button>
						<a type="button" class="btn btn-box-tool" href="#top" title='<spring:message code="sys.ota.back.to.top"/>'>
							<i class="fa fa-arrow-up"></i>
						</a>
					</div>
				</div>
				<!-- /.box-header -->
				<div class="box-body">
					<div class="row">
						<div class="col-md-4 col-sm-8 col-xs-12">
							<div class="info-box" data-url="/user/list">
								<span class="info-box-icon bg-red" onclick="clickMenu('/customer/device/index')"><spring:message code="sys.ota.device"/></span>
								<div class="info-box-content">
									<span id="deviceCount"></span><spring:message code="sys.ota.device.unit"/>
								</div>
								<!-- /.info-box-content -->
							</div>
							<!-- /.info-box -->
						</div>
						<!-- /.col -->
					</div>
					<!-- /.col -->
				</div>

				<!-- /.row -->
			</div>
			
			<div class="box box-danger">
				<div class="box-header">
					<h3 class="box-title"><spring:message code="sys.ota.device.active.information.of.the.last"/></h3>
					<label class="title-sm"></label>
					<div class="box-tools pull-right">
						<button type="button" class="btn btn-box-tool"
							data-widget="collapse">
							<i class="fa fa-minus"></i>
						</button>
						<a type="button" class="btn btn-box-tool" href="#top" title='<spring:message code="sys.ota.back.to.top"/>'>
							<i class="fa fa-arrow-up"></i>
						</a>
					</div>
				</div>
				<!-- /.box-header -->
				<div class="box-body">
					<div class="row">
						<div class="col-md-4 col-sm-8 col-xs-12">
							<div class="info-box" data-url="/user/list">
								<span class="info-box-icon bg-red" ><spring:message code="sys.ota.one.day"/></span>
								<div class="info-box-content">
									<span id="activeDayDeviceCount"></span><spring:message code="sys.ota.device.unit"/>
								</div>
								<!-- /.info-box-content -->
							</div>
							<!-- /.info-box -->
						</div>
						<div class="col-md-4 col-sm-8 col-xs-12">
							<div class="info-box" data-url="/user/tab/list">
								<span class="info-box-icon bg-aqua" ><spring:message code="sys.ota.one.week"/></span>
								<div class="info-box-content">
									<span id="activeWeekDeviceCount"></span><spring:message code="sys.ota.device.unit"/>
								</div>
								<!-- /.info-box-content -->
							</div>
							<!-- /.info-box -->
						</div>
						<!-- /.col -->
						<!-- /.col -->
						<!-- fix for small devices only -->
						<div class="clearfix visible-sm-block"></div>

						<div class="col-md-4 col-sm-8 col-xs-12">
							<div class="info-box" data-url="/user/page/list">
								<span class="info-box-icon bg-green"><spring:message code="sys.ota.one.month"/></span>
								<div class="info-box-content">
									<span id="activeMonthDeviceCount"></span><spring:message code="sys.ota.device.unit"/>
								</div>
								<!-- /.info-box-content -->
							</div>
							<!-- /.info-box -->
						</div>
						<!-- /.col -->
					</div>
					<!-- /.col -->
				</div>

				<!-- /.row -->
			</div>
			
			<!-- ./box-body -->
		</div>
		<!-- /.box -->
	</div>
	
	<div class="row" style="">
		<div class="col-md-12">
		</div>
	</div>
</section>
<!-- /.content -->
<!-- /.content-wrapper -->

<script type="text/javascript">
    $(function () {
        $(".info-box").each(function (index, item) {
            $(item).hover(function () {
                //$(this).css({"background":"red"});
                var bg = $(this).find("span:eq(0)").attr("class").replace("info-box-icon", "").trim();
                if(bg) {
                    $(this).find("span:eq(0)").removeClass(bg);
                    $(this).addClass(bg);
                }else{
                    bg = $(this).attr("class").replace("info-box", "").trim();
                    $(this).find("span:eq(0)").addClass(bg);
                    $(this).removeClass(bg);
                }
            }, function () {
                var bg = $(this).attr("class").replace("info-box", "").trim();
                if(bg) {
                    $(this).find("span:eq(0)").addClass(bg);
                    $(this).removeClass(bg);
                }else {
                    bg = $(this).find("span:eq(0)").attr("class").replace("info-box-icon", "").trim();
                    $(this).find("span:eq(0)").removeClass(bg);
                    $(this).addClass(bg);
                }
            });
        });

        $(".info-box").each(function (index, item) {
            $(item).click(function () {
                if($(this).data("flag")){
                    return;
                }
                if ($(this).data("url")) {
                    location.hash = "#main";
                    loadPage(basePath + $(this).data("url"));
                }
                else
                    modals.info('<spring:message code="sys.ota.the.function"/>');
            })
        });
        
        //加载数量
        ajaxPost(basePath+"/customer/device/getDeviceCount",null,function(data) {
        	$("#deviceCount").html(data.data);
        });
		ajaxPost(basePath+"/customer/device/getDeviceCount?type=day",null,function(data) {
	       	$("#activeDayDeviceCount").html(data.data);
	    });
		ajaxPost(basePath+"/customer/device/getDeviceCount?type=week",null,function(data) {
	       	$("#activeWeekDeviceCount").html(data.data);
	    });
		ajaxPost(basePath+"/customer/device/getDeviceCount?type=month",null,function(data) {
	       	$("#activeMonthDeviceCount").html(data.data);
	    });
		
    });
    
    function clickMenu(url){
    	loadPage(basePath + url, true);
    }
    
</script>