//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation  6        
//File Name					 : RAOIntegrate.js       
//Author                     : Nikita Singhal
// Date written (DD/MM/YYYY) : 16-Mar-2018
//Description                : Account Summary integration 
//---------------------------------------------------------------------------------------------------->	

//below function added for Account Summary Call		
function fetchAccountDetails(selectedCifId)
{		
		var xhr;
		if (window.XMLHttpRequest)
			xhr = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr = new ActiveXObject("Microsoft.XMLHTTP");
			
		//var selectedCifId = document.getElementById("custcifid").value;
		var url = "";
		
		var url = "/OECD/CustomForms/OECD_Specific/FetchAccounts.jsp?CIFID=" + selectedCifId;
		xhr.open("POST", url, false);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send();
		
		if (xhr.status == 200 && xhr.readyState == 4) 
		{
			
			ajaxResult = xhr.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
			var arrayAjaxResult=ajaxResult.split("~");
			if(arrayAjaxResult[0]=='CINF362')   //added by shamily to show alert when account details not available in finacle
			{
			  alert("Account Details Not Found for the Given Data");
			  return;
			}
			else if(arrayAjaxResult[0]!='0000' && arrayAjaxResult[0]!='CINF362')
			{
			  alert("Error in fetching account nos.");
			  return;
			}
				var accountNo=arrayAjaxResult[1];
				//alert("accountNo"+accountNo);
				if (accountNo.length == 0)
				{
				  alert("No Account Details Found for the Given Data");
				  return;
				}
				 
				var AccountnoSig=accountNo+'@';  
				document.getElementById("wdesk:AccountnoSig").value = AccountnoSig;
				//alert("AccountnoSig  new----->"+document.getElementById("wdesk:AccountnoSig").value);
				document.getElementById("wdesk:ACCOUNTNO").value = document.getElementById("wdesk:AccountnoSig").value; 	
				 
				return accountNo;
				
		} 
		else 
		{
			alert("Problem in Fetching AccountDetails.");
			return false;
		}
}