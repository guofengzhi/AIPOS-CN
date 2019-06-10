	function deviceTypeChange(){
		
		 var manufacturerNo = $("#manufacturerNo").val();
		 if(manufacturerNo == ''){
			 modals.info('请先选择厂商！');
		 	$("#deviceTypeId").empty('');
		 }
		
	}

	function manuFacturerChange(){
		
		 var params = {};
		 var manufacturerNo = $("#manufacturerNo").val();
		 if (manufacturerNo == '' || manufacturerNo == null) {
			 $("#deviceTypeId").empty('');
		 }
		 if (manufacturerNo == '' || manufacturerNo == null) {
			 $("#deviceTypeId").empty('');
		 }
		 params['manufacturerNo'] = manufacturerNo;
		 ajaxPost(basePath+'/deviceType/getDeviceTypeByManuNo', params, function(data, status) {
				
				if(data.code == 200){
				
					var deviceTypes = data.data;
					$("#deviceTypeId").empty();
					
				 	 for(var i=0;i<deviceTypes.length;i++){
						
					    $("#deviceTypeId").append("<option value=\""+deviceTypes[i].deviceType+"\">"+deviceTypes[i].deviceType+"</ooption>");
					} 
					
				}else{
					modals.warn(data.message);
				}			
		 });
	}
