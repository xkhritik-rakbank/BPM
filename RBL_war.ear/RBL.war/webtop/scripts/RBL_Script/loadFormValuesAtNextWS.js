function loadUIDGridValues(currWorkstep,WINAME)
{
		//alert("inside loaduidatnectws");
			var url = '';
			var xhr;
			var table = document.getElementById("UIDGrid");
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			var param="&WI_NAME=" + WINAME;
			url = "/RBL/CustomForms/RBL_Specific/loadUIDDetails.jsp";
			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.send(param);
			
			if (xhr.status == 200)
			{
				//alert("status"+xhr.status);
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult=="-1")
				 {
					alert("Error while loading UID details ");
					return false;
				 }
				 else if(ajaxResult=='0')//Means no record found in database
				 {
					//addrowUID('');
				 }
				 else
				 {
					ajaxResult=ajaxResult.split('|');
					for(var i=0;i<ajaxResult.length;i++)
					{
						addrowUID(ajaxResult[i],currWorkstep);
					}							
				 }
				var table_len=table.rows.length;
				//alert('Table length is '+table_len);
				document.getElementById('UIDTableLength').value=table_len;
			}
			else 
			{
				alert("Error while Loading UID Grid Data.");
				return false;
			}
			
		
}

function loadDeferralGridValues(currWorkstep,WINAME)
{
		//alert("inside loaduidatnectws");
			var url = '';
			var xhr;
			var table = document.getElementById("DeferralGrid");
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			var param="&WI_NAME=" + WINAME;
			url = "/RBL/CustomForms/RBL_Specific/loadDeferralDetails.jsp";
			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.send(param);
			
			if (xhr.status == 200)
			{
				//alert("status"+xhr.status);
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult=="-1")
				 {
					alert("Error while loading UID details ");
					return false;
				 }
				 else if(ajaxResult=='0')//Means no record found in database
				 {
					//addrowUID('');
				 }
				 else
				 {
					ajaxResult=ajaxResult.split('|');
					for(var i=0;i<ajaxResult.length;i++)
					{
						addrowDeferral(ajaxResult[i],currWorkstep);
					}							
				 }
				var table_len=table.rows.length;
				//alert('Table length is '+table_len);
				document.getElementById('DeferralTableLength').value=table_len;
			}
			else 
			{
				alert("Error while Loading Deferral Grid Data.");
				return false;
			}
			
		
}


