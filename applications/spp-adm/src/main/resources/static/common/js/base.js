execI18n();

/**
 * 全局添加pace进度条处理
 */
//$(document).ajaxStart(function() { Pace.restart(); });

/**
 * 
 * @param url
 * @param params
 * @param callback
 * @returns {*}
 */
function loadPage(url,tabs,container){
	if(!container)
		container="#mainDiv";
	if(!tabs){
		if(url.indexOf("druid") != -1){
			$.addtabs({iframe:true,iframeHeight:800});
		}else{
			$.addtabs({iframe:false,contextmenu:false});
		}
		
	}else{
		if(!url.startWith(basePath))
			url = basePath+url;
		if(url.indexOf("druid") != -1){
			var html_1 = "<iframe frameborder=\"0\" id=\"iframepage\" width=\"100%\" height=\"800px\" src=\""+url+"\" style=\"margin-top:3px;vertical-align: middle;\"></iframe>";
			$(container).html(html_1);
		}else {
		
		jQuery(container).load(url,function(response,status,xhr){
			if(status=="success"){
				if(response){
					try{
						var result = jQuery.parseJSON(response);
						if(result.code==100){ 
							$(container).html("");
							modals.warn(result.data);
						}
					}catch(e){
						return response;
					}
				}
			} 
		});
		}
	}
	
	
}

/**
 * Load a url into a page 增加beforeSend以便拦截器在将该请求识别为非ajax请求
 */
var _old_load = jQuery.fn.load;
jQuery.fn.load = function( url, params, callback ) {
	if (typeof url !== "string" && _old_load) {
		return _old_load.apply( this, arguments );
	}

	var selector, type, response,
		self = this,
		off = url.indexOf( " " );
	if ( off > -1 ) {
		selector = jQuery.trim( url.slice( off ) );
		url = url.slice( 0, off );
	}
	if ( jQuery.isFunction( params ) ) {
		callback = params;
		params = undefined;
	} else if ( params && typeof params === "object" ) {
		type = "POST";
	}
	if ( self.length > 0 ) {
		jQuery.ajax( {
			url: url,
			beforeSend: function( xhr ) {  
				    xhr.setRequestHeader('X-Requested-With', {toString: function(){ return ''; }});  
			},  
			type: type || "GET", 
			dataType: "html",
			data: params
		} ).done( function( responseText ) {
			response = arguments;
			// 页面超时跳转到首页
			 if (responseText.startWith("<!--login_page_identity-->")) {
				var top = getTopWinow();
				top.location.href = basePath + "/";
	         } else {			
				self.html( selector ?
					jQuery( "<div>" ).append( jQuery.parseHTML( responseText ) ).find( selector ) :
					responseText );
	          }
		} ).fail(function (jqXHR, status){
			self.html( selector ?
					jQuery( "<div>" ).append("").find( selector ) :
						""); 
			if(status =='error'){
					modals.error({
						    title: '<h2 class="headline text-red">'+jqXHR.status+'</h2>',
		                    text: jQuery.parseHTML( jqXHR.responseText )
		               });
				}
			
		}).always( callback && function( jqXHR, status ) {
				self.each( function() {
					callback.apply( this, response || [ jqXHR.responseText, status, jqXHR ] );
				} );
			
			
		} );
	}

	return this;
};

/**
 * 封装下载工具
 */
jQuery.download = function(url, method,searchDiv){
	var search = $("#" + searchDiv);
	var inputs = "";
	if (search !== null && search.length > 0) {
		var ele = search.find(':input[name]');
		ele.each(function(i) {
			if ($(this).attr("readonly") == "readonly" || $(this).attr("disabled") == "disabled")
				return;
			var key = $(this).attr("name");
			var value = $(this).val();
			inputs+='<input type="hidden" name="'+ key +'" value="'+ value +'" />';
		});
	}
	jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
    .appendTo('body').submit().remove();	
}

// 递归删除空属性防止把null变成空值
function deleteEmptyProp(obj) {
    for (var a in obj) {
        if (typeof(obj[a]) == "object" && obj[a] != null) {
            deleteEmptyProp(obj[a]);
        } else {
            if (!obj[a]) {
                delete obj[a];
            }
        }
    }
    return obj;
}


function ajaxPost(url, params, callback) {
	var result = null;
    var headers={};
    headers['CSRFToken']=$("#csrftoken").val();
    if (params && typeof params == "object") {
        params = deleteEmptyProp(params);
    }
    jQuery.ajax({
		type : 'post',
		async : false,
		url : url,
		data : params,
		dataType : 'json',
		// contentType: "application/json",
		headers:headers,
		success : function(data, status) {
			result = data;
			if(data&&data.code&&data.code=='101'){
				modals.error({title: '<h2 class="headline text-red">'+data.code+'</h2>', text:$.i18n.prop("common.sys.tips",data.message)});
				return false;
			}
			if (callback) { 
				callback.call(this, data, status);
			}
		},
		error : function(err, err1, err2) {
			console.log("ajaxPost发生异常，请仔细检查请求url是否正确");
		    if(err && err.readyState && err.readyState == '4'){
		    	 var sessionstatus = err.getResponseHeader("session-status");
		    	 if (sessionstatus == "timeout") {
	                    // 如果超时就处理 ，指定要跳转的页面
		    		 var top = getTopWinow();
						top.location.href = basePath + "/logout";
	                }else if(err1 == "parsererror"){
	                	 var responseBody = err.responseText;
	                     if(responseBody){   
	                     	 responseBody = "{'retData':"+responseBody;
	                          var resJson = eval('(' + responseBody + ')');
	                          $("#csrftoken").val(resJson.csrf.CSRFToken);
	                          this.success(resJson.retData, 200);
	                     }
	                     return;
	                }else {
	                    modals.error({
	                    	title:'<h2 class="headline text-red">'+err.status+'</h2>',
	                        text: err.responseJSON.message
	                    });
                        return;
	                }
            }
			modals.error({
				title:'<h2 class="headline text-red">'+err.status+'</h2>',
                text: err.responseJSON.message
			});
		}
	});

	return result;
}


function ajaxPostWithDeferred(url, params, callback) {
	var defer = jQuery.Deferred();
	var result = null;
    var headers={};
    headers['CSRFToken']=$("#csrftoken").val();
    if (params && typeof params == "object") {
        params = deleteEmptyProp(params);
    }
    jQuery.ajax({
		type : 'post',
		url : url,
		data : params,
		dataType : 'json',
		headers:headers,
		success : function(data, status) {
			if(data&&data.code&&data.code=='101'){
				modals.error({title:'<h2 class="headline text-red">'+data.code+'</h2>', text:$.i18n.prop("common.sys.tips",data.message)});
				return false;
			}
			defer.resolve(data);
		},
		error : function(err, err1, err2) {
			console.log("ajaxPost发生异常，请仔细检查请求url是否正确");
		    if(err && err.readyState && err.readyState == '4'){
		    	 var sessionstatus = err.getResponseHeader("session-status");
		    	 if (sessionstatus == "timeout") {
	                    // 如果超时就处理 ，指定要跳转的页面
		    		 var top = getTopWinow();
						top.location.href = basePath + "/";
	                }else if(err1 == "parsererror"){
	                	 var responseBody = err.responseText;
	                     if(responseBody){   
	                     	 responseBody = "{'retData':"+responseBody;
	                          var resJson = eval('(' + responseBody + ')');
	                          $("#csrftoken").val(resJson.csrf.CSRFToken);
	                          this.success(resJson.retData, 200);
	                     }
	                     return;
	                }else {
	                    modals.error({
	                    	title:'<h2 class="headline text-red">'+err.status+'</h2>',
	                        text: err.responseJSON.message
	                    });
                        return;
	                }
            }
			modals.error({
				title:'<h2 class="headline text-red">'+err.status+'</h2>',
                text: err.responseJSON.message
			});
		}
	});

	// return result;
    return defer.promise();
}

function ajaxPostForm(url, params, callback) {
	var result = null;
    var headers={};
    headers['CSRFToken']=$("#csrftoken").val();
	$.ajax({
		type : 'post',
		async : false,
		url : url,
		data : params,		
		success : function(data, status) {
			result = data;
			if(data&&data.code&&data.code=='101'){
				modals.error({title:'<h2 class="headline text-red">'+data.code+'</h2>', text:$.i18n.prop("common.sys.tips",data.message)});
				return false;
			}
			if (callback) { 
				callback.call(this, data, status);
			}
		},
		error : function(err, err1, err2) {
			console.log("ajaxPost发生异常，请仔细检查请求url是否正确");
		    if(err && err.readyState && err.readyState == '4'){
		    	 var sessionstatus = err.getResponseHeader("session-status");
		    	 if (sessionstatus == "timeout") {
	                    // 如果超时就处理 ，指定要跳转的页面
		    		 var top = getTopWinow();
						top.location.href = basePath + "/";
	                }else if(err1 == "parsererror"){
	                	 var responseBody = err.responseText;
	                     if(responseBody){   
	                     	 responseBody = "{'retData':"+responseBody;
	                          var resJson = eval('(' + responseBody + ')');
	                          $("#csrftoken").val(resJson.csrf.CSRFToken);
	                          this.success(resJson.retData, 200);
	                     }
	                     return;
	                }else {
	                    modals.error({
	                    	title:'<h2 class="headline text-red">'+err.status+'</h2>',
	                        text: err.responseJSON.message
	                    });
                        return;
	                }
            }
			modals.error({
				title:'<h2 class="headline text-red">'+err.status+'</h2>',
                text: err.responseJSON.message
			});
		}
	});

	return result;
}

function ajaxPostFileForm(url, params, callback) {
	var result = null;
    var headers={};
    headers['CSRFToken']=$("#csrftoken").val();
	$.ajax({
		type : 'post',
		async : false,
		url : url,
		data : params,
		processData: false,
		contentType: false,
		success : function(data, status) {
			result = data;
			if(data&&data.code&&data.code=='101'){
				modals.error({title:'<h2 class="headline text-red">'+data.code+'</h2>', text:$.i18n.prop("common.sys.tips",data.message)});
				return false;
			}
			if (callback) { 
				callback.call(this, data, status);
			}
		},
		error : function(err, err1, err2) {
			console.log("ajaxPost发生异常，请仔细检查请求url是否正确");
		    if(err && err.readyState && err.readyState == '4'){
		    	 var sessionstatus = err.getResponseHeader("session-status");
		    	 if (sessionstatus == "timeout") {
	                    // 如果超时就处理 ，指定要跳转的页面
		    		 var top = getTopWinow();
						top.location.href = basePath + "/";
	                }else if(err1 == "parsererror"){
	                	 var responseBody = err.responseText;
	                     if(responseBody){   
	                     	 responseBody = "{'retData':"+responseBody;
	                          var resJson = eval('(' + responseBody + ')');
	                          $("#csrftoken").val(resJson.csrf.CSRFToken);
	                          this.success(resJson.retData, 200);
	                     }
	                     return;
	                }else {
	                    modals.error({
	                    	title:'<h2 class="headline text-red">'+err.status+'</h2>',
	                        text: err.responseJSON.message
	                    });
                        return;
	                }
            }
			modals.error({
				title:'<h2 class="headline text-red">'+err.status+'</h2>',
                text: err.responseJSON.message
			});
		}
	});

	return result;
}


/**
 * 格式化日期
 */
function formatDate(date, format) {
	if(!date)return date;
	date = (typeof date == "number") ? new Date(date) : date;
	return date.Format(format);
}

Date.prototype.Format = function(fmt) {
	var o = {
		"M+" : this.getMonth() + 1, // 月份
		"d+" : this.getDate(), // 日
		"H+" : this.getHours(), // 小时
		"m+" : this.getMinutes(), // 分
		"s+" : this.getSeconds(), // 秒
		"q+" : Math.floor((this.getMonth() + 3) / 3), // 季度
		"S" : this.getMilliseconds()
	// 毫秒
	};
	if (/(y+)/.test(fmt))
		fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
	for ( var k in o)
		if (new RegExp("(" + k + ")").test(fmt))
			fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
	return fmt;
}

/**
 * 将map类型[name,value]的数据转化为对象类型
 */
function getObjectFromMap(aData) {
	var map = {};
	for (var i = 0; i < aData.length; i++) {
		var item = aData[i];
		if (!map[item.name]) {
			map[item.name] = item.value;
		}
	}
	return map;
}

/**
 * 获取render,并转化为对象数组
 */
function getRenderObject(render) {
	var arr = render.split(",");
	if(arr[0]=="type=dict"){
		arr = render.split(",$");
	}
	var obj = new Object();
	for (var i = 0; i < arr.length; i++) {
		var strA = arr[i].split("=");
		obj[strA[0]] = arr[i].substring(arr[i].indexOf("=") + 1);
	}
	if (!obj.type)
		obj.type = "eq";
	if(obj.type=="dict")
		obj.data = eval("("+obj.data+")");
	return obj;
}

// 获取字典标签
function getDictLabel(data, value, defaultValue){
	for (var i=0; i<data.length; i++){
		var row = data[i];
		if (row.value == value){
			return row.label;
		}
	}
	return defaultValue;
}

/**
 * 获取下一个编码 000001，000001000006，6 得到结果 000001000007
 */
function getNextCode(prefix,maxCode,length){
	if(maxCode==null){
		var str="";
		for(var i=0;i<length-1;i++){
			str+="0";
		}
		return prefix+str+1;
	}else{
		var str="";
		var sno = parseInt(maxCode.substring(prefix.length))+1;
		for(var i=0;i<length-sno.toString().length;i++){
			str+="0";
		}
		return prefix+str+sno;
	}
	
}

function getNextSort(maxCode){
	if(maxCode==null||maxCode=="0"){
		return 0;
	}else {
		var sort = parseInt(maxCode)+10;
		return sort;
	}
	
}

// 获取URL地址参数
function getQueryString(name, url) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    if (!url || url == ""){
	    url = window.location.search;
    }else{	
    	url = url.substring(url.indexOf("?"));
    }
    r = url.substr(1).match(reg)
    if (r != null) return unescape(r[2]); return null;
}

function getJsVal(value){
	var vals = value.split(".");
	var result="";
	var tempVal="";
	$.each(vals,function(index,val){
		tempVal+="."+val;
		result+="!"+(tempVal.substring(1))+"?'':";
	});
	result+=tempVal.substring(1);
	return result;
}




// 获取布尔值
/*
 * String.prototype.BoolValue=function(){ if(this==undefined) return false;
 * if(this=="false"||this=="0") return false; return true; }
 */

String.prototype.startWith = function(s) {
    if (s == null || s == "" || this.length == 0 || s.length > this.length)
        return false;
    if (this.substr(0, s.length) == s)
        return true;
    else
        return false;
}

String.prototype.replaceAll = function(s1, s2) {
    return this.replace(new RegExp(s1, "gm"), s2);
}

function onSelectChange(url,params,selector){
	var sel=$('#'+selector);
    var blank_text = sel.attr("placeholder");
    sel.empty();
    sel.append('<option value="">'+blank_text+ '</option>')
    var initValue = sel.data("init")?sel.data("init"):"";
    var isInit = false;
    if(params != ""){
    	 ajaxPost(url+params,null,function(data,status){
    		 var value=sel.data("value")?sel.data("value"):"id";
    	     var text=sel.data("text")?sel.data("text"):"name";
    	       if(data.length>0){
    	    	   sel.parent().parent().show();
    	    	   for(var i=0;i<data.length;i++){
       	        	if(initValue==data[i][value])
       	        		isInit = true;
       	            var option = $("<option value='" + data[i][value] + "'>" + data[i][text] + "</option>");
       	            sel.append(option);
       	         }
    	       }else{
    	    	   sel.parent().parent().hide();
    	       }
    	        
    	  })
    }
    
    if(isInit)
    	sel.val(initValue)
}

/**
 * 在页面中任何嵌套层次的窗口中获取顶层窗口
 * 
 * @return 当前页面的顶层窗口对象
 */
function getTopWinow(){
  var p = window;
   while(p != p.parent){
   p = p.parent;
  }
  return p;
}


function checkBox(){
	$('input').iCheck({
		checkboxClass: 'icheckbox_minimal-green',
		increaseArea : '20%' // optional
	});
}


//选中事件操作数组  
var union = function(array,ids){  
    //$.each(ids, function (i, id) {  
        if($.inArray(ids,array)==-1){  
            array[array.length] = ids;  
        }  
         ///});  
        return array;  
};  
//取消选中事件操作数组  
var difference = function(array,ids){  
       // $.each(ids, function (i, id) {  
             var index = $.inArray(ids,array);  
             if(index!=-1){  
                 array.splice(index, 1);  
             }  
        // });  
        return array;  
}; 



