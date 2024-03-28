String.prototype.startsWith = function(str)
{
	var tempVar1 = this.toUpperCase();
	var tempVar2 = str.toUpperCase();	
	return (tempVar1.match("^"+tempVar2)==tempVar2)
}

function generate_template(winame)
{
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	url='/TWC/CustomForms/TWC_Specific/TemplateLetterOfOffer.jsp?winame='+winame;
	xhr.open("POST",url,false);
	xhr.send(null);
	var flagDocGenStatus = "";
	if (xhr.status == 200)
	{	
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		var Output = ajaxResult.split("~");
		window.parent.customAddDoc(Output[0],Output[1],Output[2]);
		pdfName = Output[3];
		// start - function called to delete template from server after generating
		//window.onunload(deleteTemplateFromServer(pdfName));
		deleteTemplateFromServer(pdfName);  //function called 
		// end - function called to delete template from server after generating
		 if(ajaxResult.startsWith("ERROR"))
		 {
				alert(ajaxResult);
				return false;	
		 }
	}
	else 
	{
		alert("Error in generating twc template");
		return false;
	}
	
}

function generate_excel_template(winame)
{
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	url='/TWC/CustomForms/TWC_Specific/ExcelTemplateLetterOfOffer.jsp?winame='+winame;
	xhr.open("POST",url,false);
	xhr.send(null);
	var flagDocGenStatus = "";
	if (xhr.status == 200)
	{	
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		var Output = ajaxResult.split("~");
		window.parent.customAddDoc(Output[0],Output[1],Output[2]);
		pdfName = Output[3];
		// start - function called to delete template from server after generating
		//window.onunload(deleteTemplateFromServer(pdfName));
		deleteTemplateFromServer(pdfName);  //function called 
		// end - function called to delete template from server after generating
		 if(ajaxResult.startsWith("ERROR"))
		 {
				alert(ajaxResult);
				return false;	
		 }
	}
	else 
	{
		alert("Error in generating excel twc template");
		return false;
	}
	
}

//Modified on 22/02/2019 to add more fields
function getEntityDetailsCallAfterCifIdSaved(wi_name,event)
{
	//Value of fields
	var CIF_ID=document.getElementById("wdesk:CIF_Id").value;
	var currentWS=document.getElementById("wdesk:Current_WS").value;
	
	if(currentWS!='Sales_Data_Entry' && currentWS!='Business_Approver_1st' && currentWS!='Business_Approver_2nd')
	{
		return true;
	}
	//ID of fields
	var customer_name=document.getElementById("wdesk:Customer_Name");
	var Address_Line_1=document.getElementById("wdesk:Address_Line_1");
	var Address_Line_2=document.getElementById("wdesk:Address_Line_2");
	var Address_Line_3=document.getElementById("wdesk:Address_Line_3");
	var Address_Line_4=document.getElementById("wdesk:Address_Line_4");
	var PO_Box=document.getElementById("wdesk:PO_Box");
	var Emirate=document.getElementById("wdesk:Emirate");
	var Country=document.getElementById("wdesk:Country");
	var Dec_Populate=document.getElementById("wdesk:Dec_Populate");
	var Mobile_Code=document.getElementById("wdesk:Mobile_Code");
	var Mobile_Number=document.getElementById("wdesk:Mobile_Number");
	var Landline_code=document.getElementById("wdesk:Landline_code");
	var Landline_Number=document.getElementById("wdesk:Landline_Number");
	var Email_ID=document.getElementById("wdesk:Email_ID");
	var TLNumber=document.getElementById("wdesk:TL_Number");
	var xmlDoc;
	var x;
	var xLen;
	var request_type = "ENTITY_DETAILS";
	var xhr;
	
	//CIF ID cannot be blank
	CIF_ID= CIF_ID.replace(/^\s+|\s+$/gm, '');
	if(CIF_ID=="" || CIF_ID==null)
	{
			alert("Please enter a CIF Number");
			return false;
	}
	if(event=='load')
	{
		if(customer_name.value!='' && Address_Line_1.value!='')
		{
			return true;
		}
	}
	//alert('CIF Id is '+CIF_ID);
	if (window.XMLHttpRequest)
		xhr = new XMLHttpRequest();
	else if (window.ActiveXObject)
		xhr = new ActiveXObject("Microsoft.XMLHTTP");
	
	var url ="/TWC/CustomForms/TWC_Specific/TWCIntegration.jsp";
	
	var param = "request_type=" + request_type +"&CIF_ID=" + CIF_ID + "&wi_name=" + wi_name;
	xhr.open("POST", url, false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200 && xhr.readyState == 4) 
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
		if (ajaxResult.indexOf("Exception") == 0) 
		{
			alert("Unable to fetch entity details");
			document.getElementById("wdesk:CIF_Id").disabled=false;
			document.getElementById("CIF_Id_populate").disabled=false;
			document.getElementById("CIF_Id_populate").classList.remove("EWButtonRBSRMRejectReason");
            document.getElementById("CIF_Id_populate").classList.add("EWButtonRBSRM");
			return false;
		}
		ajaxResult = ajaxResult.split("~");
		
		customer_name.value = ajaxResult[0];
		// populating preferred address from entity details
		Address_Line_1.value=ajaxResult[2];
		Address_Line_2.value=ajaxResult[3];
		Address_Line_3.value=ajaxResult[4];
		Address_Line_4.value=ajaxResult[5];
		PO_Box.value=ajaxResult[6];
		Emirate.value=ajaxResult[7];
		Country.value=ajaxResult[8];
		
		Mobile_Code.value = ajaxResult[9];
		Mobile_Number.value=ajaxResult[10];
		Landline_code.value=ajaxResult[11];
		Landline_Number.value=ajaxResult[12];
		Email_ID.value=ajaxResult[13];
		TLNumber.value=ajaxResult[14];
		
		
		if((Address_Line_1.value=="null" && Address_Line_2.value=="null" && Address_Line_3.value=="null" && Address_Line_4.value=="null"&& PO_Box.value=="null" && Emirate.value=="null" && Country.value=="null" && Mobile_Code.value=="null" && Mobile_Number.value=="null" && Landline_code.value=="null" && Landline_Number.value=="null" && Email_ID.value=="null")||(Address_Line_1.value=="" && Address_Line_2.value=="" && Address_Line_3.value=="" && Address_Line_4.value==""&&PO_Box.value=="" && Emirate.value=="" && Country.value=="" && Mobile_Code.value=="" && Mobile_Number.value=="" && Landline_code.value=="" && Landline_Number.value=="" && Email_ID.value=="" && TLNumber.value==""))
		{
			//do nothing
		}
		else 
		{
			customer_name.disabled=true;
			Address_Line_1.disabled=true;
			Address_Line_2.disabled=true;
			Address_Line_3.disabled=true;
			Address_Line_4.disabled=true;
			PO_Box.disabled=true;
			Emirate.disabled=true;
			Country.disabled=true;
			//Mobile_Code.disabled=true;
			//Mobile_Number.disabled=true;
			//Landline_code.disabled=true;
			//Landline_Number.disabled=true;
			//Email_ID.disabled=true;
			//TLNumber.disabled=true;
			Dec_Populate.value='Y';
		}
	} 
	else 
	{
		alert("Problem in getting Entity Details.");
		document.getElementById("wdesk:CIF_Id").disabled=false;
		document.getElementById("CIF_Id_populate").disabled=false;
		document.getElementById("CIF_Id_populate").classList.remove("EWButtonRBSRMRejectReason");
        document.getElementById("CIF_Id_populate").classList.add("EWButtonRBSRM");
		return false;
	}
}


function deleteTemplateFromServer (pdfname)
{
	var url = '../../CustomForms/TWC_Specific/DeleteGeneratedTemplate.jsp?pdfname='+pdfname;
	var xhr;
	var ajaxResult;	
	
	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");

	 xhr.open("GET",url,false); 
	 xhr.send(null);

	// alert(xhr.status);
	 
	if (xhr.status == 200) { //Do nothing
	
	//window.parent.close();
	}
	else
	{
		alert("Error while deleting generated template from server");
		return false;
	}
}

//below function added for Account Summary Call		
function fetchAccountDetails(selectedCifId)
{		
	var xhr;
	if (window.XMLHttpRequest)
		xhr = new XMLHttpRequest();
	else if (window.ActiveXObject)
		xhr = new ActiveXObject("Microsoft.XMLHTTP");
		
	var url = "";
	
	var url = "/TWC/CustomForms/TWC_Specific/FetchAccounts.jsp?CIFID=" + selectedCifId;
	xhr.open("POST", url, false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send();
	
	if (xhr.status == 200 && xhr.readyState == 4) 
	{
		
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
		//alert("ajaxResult "+ajaxResult);
		var arrayAjaxResult=ajaxResult.split("~");
		if(arrayAjaxResult[0]=='CINF362')   //to show alert when account details not available in finacle
		{
		  alert("Operative Account does not exists for the cusotmer");
		  return;
		}
		else if(arrayAjaxResult[0]!='0000' && arrayAjaxResult[0]!='CINF362')
		{
		  alert("Error in fetching account nos.");
		  return;
		}
			var accountNo=arrayAjaxResult[1];
			if (accountNo.length == 0)
			{
			  alert("Operative Account does not exists for the cusotmer.");
			  return;
			}
			 
			return accountNo;
			
	} 
	else 
	{
		alert("Problem in Fetching AccountDetails.");
		return false;
	}
}
