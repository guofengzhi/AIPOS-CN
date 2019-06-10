/*!
 * BaseDataSource.
 */
(function($, window, document, undefined) {
    'use strict';
    var BaseDataSource = function() {

    };

    BaseDataSource.prototype.getDictList = function(code) {
        var dict = null;
        var obj = {
            "code" : code
        };
        $.ajax({
            type : "post",
            async : false,
            url : basePath+"/sys/dict/listData",
            data : obj,
            dataType : "json",
            success : function(data) {
                dict = data;
            },
            error : function() {
                modals.error($.i18n.prop("common.sys.dict.get.error",code));
            }
        });
        return dict;
    };

    /**
     * dictCode 字典编码 callback 回调函数
     */
    BaseDataSource.prototype.getDict = function(dictCode, callback) {
        if (!dictCode)
            return null;
        var dict = this.getDictList(dictCode);
        if (dict && dict.length > 0&&callback) {
            callback(dict);
        }
    };

    BaseDataSource.prototype.getDataByUrl = function(url, callback) {
        if (!url)
            return null;
        var data = this.getData(url);
        if (data&&data.length>0&&callback) {
            callback(data);
        } 
    };
   

    BaseDataSource.prototype.getData = function(url) {
        var dict = null;
        $.ajax({
            type : "post",
            async : false,
            url : basePath+url,
            data : null,
            dataType : "json",
            success : function(data) {
                dict = data;
            },
            error : function() {
                modals.error($.i18n.prop("common.sys.dict.get.data.error",url));
            }
        });
        return dict;
    };
    
    BaseDataSource.prototype.getDataByArray = function(data, callback) {
        if (!data)
            return null;
        var data = this.getArrayData(data);
        if (data&&data.length>0&&callback) {
            callback(data);
        } 
    };
    
    BaseDataSource.prototype.getArrayData = function(data) {
         if(!data)
            return null;
        var dict = new Array();
        $.each(data,function(index,value){
        	dict[index] = {id:value,name:value};
        });
        return dict;
    };

    window.$dataSource = new BaseDataSource();

})(jQuery, window, document);