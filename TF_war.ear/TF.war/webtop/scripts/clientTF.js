/*
client<Cabinetname>.js  for CAC process
*/
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           Function validates on click of save
//***********************************************************************************//
//if (strprocessname == 'TF') 
//{    
	var closedFromCloseButton = '';
    
    var counthash = 0;
    var exception = false;
    var exceptionstring = '';
    var decisionsaved = 'Y';
  
	window.document.write("<script src=\"/TF/webtop/scripts/TF_Script/Validation_TF.js\"></script>");
	//window.document.write("<script src=\"/TF/webtop/scripts/TF_Script/Custom_Validation.js?13\"></script>");
	//window.document.write("<script src=\"/TF/webtop/scripts/TF_Script/aes.js\"></script>");
	window.document.write("<script src=\"/TF/webtop/scripts/TF_Script/json3.min.js?123\"></script>");
	window.document.write("<script src=\"/TF/webtop/scripts/TF_Script/populateCustomValue.js\"></script>");
	window.document.write("<script src=\"/TF/webtop/scripts/TF_Script/calendar_TF.js\"></script>");
	
//}
function DoneClick()
{
	//alert('Done click');
	var flag="D";
	if (strprocessname == 'TF')
	{
	    var WSNAME = customform.document.getElementById("wdesk:WS_NAME").value;
		if(WSNAME=="Credit_Checker" || WSNAME=="Director_Credit" || WSNAME=="CreditApp_OR_Analyst" || WSNAME=="Chief_Credit_Officer" || WSNAME=="UM" || WSNAME=="SM" || WSNAME=="MD" || WSNAME=="HOD" || WSNAME=="RM")
		{
			saveQueryGridData();
		}
		if(WSNAME=="CSO" || WSNAME=="TF_Document_Approver" || WSNAME=="TF_Maker" )
		{
		 saveUTCGridData();
		 //added by stutee for alert
		 if(WSNAME=="TF_Document_Approver"){
			 saveDocApproverUser();
		 }
		}
		return validateOnInroduceClick(flag);
	}	
    
	else
		return true;
}

function saveDocApproverUser()
{
	var loggedInuser = customform.document.getElementById("loggedinuser").innerHTML.split(";")[2];
	var ajaxResult='';
	
    var wi_name =customform.document.getElementById("wdesk:WI_NAME").value;
    var WSNAME =customform.document.getElementById("wdesk:CURRENT_WS").value;
	try 
	{
        var url = '/TF/CustomForms/TF_Specific/InsertInvoiceData.jsp';
		var param = "reqType=InsertDocApproverUser&wi_name="+wi_name+"&gridRow=&loggedInuser="+loggedInuser;
		//param = encodeURIComponent(param);
		var req;
		if (window.XMLHttpRequest) {
            req = new XMLHttpRequest();
        } else if (window.ActiveXObject) {
            isIE = true;
            req = new ActiveXObject("Microsoft.XMLHTTP");
        }
		req.open("POST", url, false);
		req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		req.send(param);
        
		if (req.readyState == 4 && req.status == 200) 
		{
			ajaxResult = req.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '')
			if(ajaxResult=='-1')
			{
				alert('Error while saving Doc Approver User');
				return false;
			}
		}
		else
		{
			alert('Error while saving Doc Approver User\n Response Status '+req.status);
			return false;
		}
    } 
	catch (e) 
	{
        alert("Exception while saving Doc Approver User: " + e);
		return false;
    }
}

function SaveClick() 
{
	//alert('Save click');
	var flag="S";
	var customform = '';
    var formWindow = getWindowHandler(windowList, "formGrid");
    customform = formWindow.frames['customform'];
    var iframe = customform.document.getElementById("frmData");
					
    if (strprocessname == 'TF') 
	{	
		var WSNAME = customform.document.getElementById("wdesk:WS_NAME").value;
		if(WSNAME=="Credit_Checker" || WSNAME=="Director_Credit" || WSNAME=="CreditApp_OR_Analyst" || WSNAME=="Chief_Credit_Officer" || WSNAME=="UM" || WSNAME=="SM" || WSNAME=="MD" || WSNAME=="HOD" || WSNAME=="RM")
		{
			saveQueryGridData();
		} 
		if(WSNAME=="CSO" || WSNAME=="TF_Document_Approver" || WSNAME=="TF_Maker" )
		{
		 saveUTCGridData();
		}
		saveInvoiceAndcommunicationData();
		return validateOnInroduceClick(flag);		
    } 
	else
		return true;
}

function myTrim(x)
{
	return x.replace(/^\s+|\s+$/gm,'');
}

//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           Function validates conditions on click of introduce
//***********************************************************************************//
function IntroduceClick() 
{
	//alert("save IntroduceClick called123");
	var flag="I";	
    if (strprocessname == 'TF') 
	{
		//Start - Saving queue variables value on introduction for slowness in filter added on 19012018
		var WSNAME = customform.document.getElementById("wdesk:WS_NAME").value;
		if (WSNAME=="CSO")
		{			
			var ServiceRequestCode= customform.document.getElementById("wdesk:ServiceRequestCode").value;
			ServiceRequestCode= ServiceRequestCode.replace('TF','').trim();
			//	alert("ServiceRequestCode"+ServiceRequestCode);
			customform.document.getElementById("wdesk:q_ProductCode").value= ServiceRequestCode ;
			
			saveInvoiceAndcommunicationData();
			saveUTCGridData();

			
		}
		//End - Saving queue variables value on introduction for slowness in filter added on 19012018
		var status = validateOnInroduceClick(flag);				
		if (status == true)
		{
			var ServiceRequestCode= customform.document.getElementById("wdesk:ServiceRequestCode").value;
			if(ServiceRequestCode == 'TF019' || ServiceRequestCode == 'TF020' || ServiceRequestCode == 'TF034' || ServiceRequestCode == 'TF036')
				setDynamicFieldInExtTable();
		}	
		return status;	
    } 
	else
		return true;
}

function saveInvoiceAndcommunicationData()
{
	var invoiceSaveStatus=saveinvoiceData();
	if(invoiceSaveStatus)
	{
		var communicationSaveStatus=savecommunicationGridData();
		if(communicationSaveStatus)
		{
			return true;
		}
		else
		return false;
	}
	else
	return false;
}

function saveinvoiceData() 
{	
	var table = customform.document.getElementById("InvoiceDetailsGrid");
	var ajaxResult='';
    var rowCount = table.rows.length;
	if(rowCount==1)//When no row added in grid
		return true;
	
    var wi_name =customform.document.getElementById("wdesk:WI_NAME").value;
    try 
	{       
        var req;
        if (window.XMLHttpRequest) {
            req = new XMLHttpRequest();
        } else if (window.ActiveXObject) {
            isIE = true;
            req = new ActiveXObject("Microsoft.XMLHTTP");
        }
		
		var url = '/TF/CustomForms/TF_Specific/DeleteGridData.jsp';
		var param = "reqType=InvoiceGridData&wi_name="+wi_name;
		//param = encodeURIComponent(param);
		req.open("POST", url, false);
		req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		req.send(param);
			
		if (req.readyState == 4 && req.status == 200) 
		{
			ajaxResult = req.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '')
			if(ajaxResult=='-1')
			{
				alert('Error while saving Invoice Grid Data');
				return false;
			}
		}
		else
		{
			alert('Error while saving Invoice Grid Data\n Response Status '+req.status);
			return false;
		}
    } 
	catch (e) 
	{
        alert("Exception while saving Invoice Grid Data: " + e);
		return false;
    }
	var arrayInvoiceFieldsForSave=['invoicenumber'];
    for (var i = 1; i < rowCount; i++) 
	{
		var gridRow = "";
        var colCount = table.rows[i].cells.length;
        var currentrow = table.rows[i];
        for (var j = 0; j < arrayInvoiceFieldsForSave.length; j++) 
		{
			var value = customform.document.getElementById(arrayInvoiceFieldsForSave[j]+i).innerHTML;
			value = value.split("'").join("''");
            if (gridRow != "") 
			{
                gridRow = gridRow + "," + "'" + value + "'";
            } 
			else 
			{
                gridRow = "'"+i+"',"+"'" + value + "','"+wi_name+"'";
            }
        }
        try 
		{
            var xhr;
            var ajaxResult;
            if (window.XMLHttpRequest)
                xhr = new XMLHttpRequest();
            else if (window.ActiveXObject)
                xhr = new ActiveXObject("Microsoft.XMLHTTP");
			
			gridRow = gridRow.split("'").join("ENSQOUTES");	
            var url = '/TF/CustomForms/TF_Specific/InsertInvoiceData.jsp';
			url=url.replace(/&amp;/g, 'ENCODEDAND');
			var param = "gridRow="+gridRow+"&wi_name="+wi_name;
			//param = encodeURIComponent(param);
			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
			
			if (xhr.status == 200)
				{
					 ajaxResult = xhr.responseText;
					 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
					 if(ajaxResult=='-1')
					 {
						alert("Problem in saving Invoice Grid data");
						return false;
					 }
				}
        } 
		catch (e) 
		{
            alert("Exception while saving Invoice Grid Data:" + e);
			return false;
        }
    }
	return true;
}

function savecommunicationGridData() 
{	
	var table = customform.document.getElementById("CommunicationdtlsGrid");
	var ajaxResult='';
    var rowCount = table.rows.length;
	if(rowCount==1)//When no row added in grid
		return true;
	
    var wi_name =customform.document.getElementById("wdesk:WI_NAME").value;
    var lodgement =customform.document.getElementById("LodgementDate").value;
	
    try 
	{
        var url = '/TF/CustomForms/TF_Specific/DeleteGridData.jsp';
		var param = "reqType=CommunicationGridData&wi_name="+wi_name;
		//param = encodeURIComponent(param);
		var req;
		if (window.XMLHttpRequest) {
            req = new XMLHttpRequest();
        } else if (window.ActiveXObject) {
            isIE = true;
            req = new ActiveXObject("Microsoft.XMLHTTP");
        }
		req.open("POST", url, false);
		req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		req.send(param);
        
		if (req.readyState == 4 && req.status == 200) 
		{
			ajaxResult = req.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '')
			if(ajaxResult=='-1')
			{
				alert('Error while saving Invoice Grid Data');
				return false;
			}
		}
		else
		{
			alert('Error while saving Invoice Grid Data\n Response Status '+req.status);
			return false;
		}
    } 
	catch (e) 
	{
        alert("Exception while saving Invoice Grid Data: " + e);
		return false;
    }
	var arrayCommunicationFieldsForSave=['modeofcommunicationcombo','communicationDate','CommunicationTime','description'];
    for (var i = 1; i < rowCount; i++) 
	{
		var gridRow = "";
        var colCount = table.rows[i].cells.length;
        var currentrow = table.rows[i];
        for (var j = 0; j < arrayCommunicationFieldsForSave.length; j++) 
		{
			var value = customform.document.getElementById(arrayCommunicationFieldsForSave[j]+i).innerHTML;
			value = value.split("'").join("''");
			//alert("communicationcombo--"+value);
            if (gridRow != "") 
			{
                gridRow = gridRow + "," + "'" + value + "'";
            } 
			else 
			{
                gridRow = "'"+i+"','"+wi_name+"',"+"'" + value + "'";
            }
        }
		gridRow = gridRow + "," + "'" + lodgement + "'";
		//alert("gridRow--"+gridRow);
        try 
		{
			gridRow = gridRow.split("'").join("ENSQOUTES");	
            var url = '/TF/CustomForms/TF_Specific/InsertCommunicationData.jsp';
			url=url.replace(/&amp;/g, 'ENCODEDAND');
			var param = "gridRow="+gridRow+"&wi_name="+wi_name;
            var xhr;
            var ajaxResult;
            if (window.XMLHttpRequest)
                xhr = new XMLHttpRequest();
            else if (window.ActiveXObject)
                xhr = new ActiveXObject("Microsoft.XMLHTTP");
            xhr.open("POST", url, false);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
			if (xhr.status == 200)
				{
					 ajaxResult = xhr.responseText;
					 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
					 if(ajaxResult=='-1')
					 {
						alert("Problem in saving Invoice Grid data");
						return false;
					 }
				}
        } 
		catch (e) 
		{
            alert("Exception while saving Invoice Grid Data:" + e);
			return false;
        }
    }
	return true;
}
function saveQueryGridData()
{
	var table = customform.document.getElementById("Query_Details_Grid");
	var ajaxResult='';
    var rowCount = table.rows.length;
	/*if(rowCount==3)//When no row added in grid
	return true;*/
	
    var wi_name =customform.document.getElementById("wdesk:WI_NAME").value;
    var WSNAME =customform.document.getElementById("wdesk:CURRENT_WS").value;
	try 
	{
        var url = '/TF/CustomForms/TF_Specific/DeleteGridData.jsp';
		var param = "reqType=QueryDetailsGrid&wi_name="+wi_name;
		//param = encodeURIComponent(param);
		var req;
		if (window.XMLHttpRequest) {
            req = new XMLHttpRequest();
        } else if (window.ActiveXObject) {
            isIE = true;
            req = new ActiveXObject("Microsoft.XMLHTTP");
        }
		req.open("POST", url, false);
		req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		req.send(param);
        
		if (req.readyState == 4 && req.status == 200) 
		{
			ajaxResult = req.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '')
			if(ajaxResult=='-1')
			{
				alert('Error while saving Query Grid Data');
				return false;
			}
		}
		else
		{
			alert('Error while saving Query Grid Data\n Response Status '+req.status);
			return false;
		}
    } 
	catch (e) 
	{
        alert("Exception while saving QUery Grid Data: " + e);
		return false;
    }
    
	var arrayFieldsForSave=['select_ID','query_Name','credit_Remarks','business_Remarks'];
	var gridRowAll = '';
    for (var i = 1; i <=rowCount-1; i++) 
	{
		var gridRow = "";
        var colCount = table.rows[i].cells.length;
        var currentrow = table.rows[i];
        for (var j = 0; j < arrayFieldsForSave.length; j++) 
		{
			if (arrayFieldsForSave[j] == 'select_ID' && customform.document.getElementById(arrayFieldsForSave[j]+i).value == '')
			{
				gridRow = '';
				break;
			} 
			if (gridRow != "") 
			{
				var colData = customform.document.getElementById(arrayFieldsForSave[j]+i).value;
				gridRow = gridRow + "~" + colData;
			} 
			else 
			{
				var colData = customform.document.getElementById(arrayFieldsForSave[j]+i).value;
				gridRow =  colData;
			}
		
		}
	
		if (gridRowAll != "") 
		{
			if (gridRow != '')
				gridRowAll = gridRowAll+'|'+gridRow;
		}
		else
		{
			if (gridRow != '')
				gridRowAll = gridRow;
		}
		gridRowAll=gridRowAll.split('&').join('AMPNDCHAR');
		gridRowAll=gridRowAll.split('%').join('PPPERCENTTT');
		
		
		
	}
	/*if (gridRowAll == '')	
		return true;*/
	try 
	{
		var url = "/TF/CustomForms/TF_Specific/InsertGridData.jsp";
		var param="&gridRow=" + gridRowAll+"&wi_name="+wi_name+"&WSNAME="+WSNAME;
		var xhr;
		var ajaxResult;
		if (window.XMLHttpRequest)
			xhr = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr = new ActiveXObject("Microsoft.XMLHTTP");
		xhr.open("POST", url, false);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send(param);
		if (xhr.status == 200)
			{
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult=='-1')
				 {
					alert("Problem in saving Query Grid data");
					return false;
				 }
			}
	} 
	catch (e) 
	{
		alert("Exception while saving Query Grid Data:" + e);
		return false;
	}
    
	return true;
}
function saveUTCGridData()
{
	var table = customform.document.getElementById("UTCDetailsGrid");
	var ajaxResult='';
    var rowCount = table.rows.length;
	if(rowCount==1)//When no row added in grid
	return true;
	
	if(customform.document.getElementById("wdesk:UTCDetailsFlag").value != 'Y')
		return true;
	
    var wi_name =customform.document.getElementById("wdesk:WI_NAME").value;
    var WSNAME =customform.document.getElementById("wdesk:CURRENT_WS").value;
	try 
	{
        var url = '/TF/CustomForms/TF_Specific/DeleteGridData.jsp';
		var param = "reqType=UTCDetailsGrid&wi_name="+wi_name;
		//param = encodeURIComponent(param);
		var req;
		if (window.XMLHttpRequest) {
            req = new XMLHttpRequest();
        } else if (window.ActiveXObject) {
            isIE = true;
            req = new ActiveXObject("Microsoft.XMLHTTP");
        }
		req.open("POST", url, false);
		req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		req.send(param);
        
		if (req.readyState == 4 && req.status == 200) 
		{
			ajaxResult = req.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '')
			if(ajaxResult=='-1')
			{
				alert('Error while saving UTC Grid Data');
				return false;
			}
		}
		else
		{
			alert('Error while saving UTC Grid Data\n Response Status '+req.status);
			return false;
		}
    } 
	catch (e) 
	{
        alert("Exception while saving UTC Grid Data: " + e);
		return false;
    }
    
	var arrayFieldsForSave=['DocumentNo','DocumentDate','Currency','TotalInvoiceAmount','BuyerName','SupplierName','LineItemsCount','BanRefNumber','ContractNo','PONumber','AmountInWords','PaymentDueDate','TermsofPayment','BillingAddress','Discount','TaxAmount','TaxNoSupplier','GrossAmount','SupplierAccountNo','SupplierAddressLine1','SupplierAddressLine2','SupplierAddressCity','SupplierAddressCountry','SupplierAddressPOBox','SupplierEmailAddress','SupplierWebsite','SupplierTelephone','BuyerTelephone','BuyerAccountNo','BuyerAddressLine1','BuyerAddressLine2','BuyerAddressCity','BuyerAddressCountry','BuyerAddressPOBox','BuyerEmailAddress','BuyerWebsite','LineItemDescription','HSCode','UnitPrice','SubtotalAmount','Quantity','LineNo','UOM'];
	var gridRowAll = '';
    for (var i = 1; i <=rowCount-1; i++) 
	{
		var gridRow = "";
        var colCount = table.rows[i].cells.length;
        var currentrow = table.rows[i];
		
		
        for (var j = 1; j < colCount; j++) 
		{
			var value = currentrow.cells[j].innerHTML;
			value = value.split("'").join("''");
			
			if (gridRow != "") 
			{
				gridRow = gridRow + "~" + "'" + value + "'";
			} 
			else 
			{
				gridRow = "'"+i+"'~'"+wi_name+"'~"+"'" + value + "'";
			}
		
		
		}
		for(var z = 0; z<(44-colCount); z++){
			gridRow = gridRow + "~";
		}
		gridRow=gridRow.split('|').join('PIPECHAR');
	
		if (gridRowAll != "") 
		{
			if (gridRow != '')
				gridRowAll = gridRowAll+'|'+gridRow;
		}
		else
		{
			if (gridRow != '')
				gridRowAll = gridRow;
		} 
		gridRowAll=gridRowAll.split('&').join('AMPNDCHAR');
		gridRowAll=gridRowAll.split('%').join('PPPERCENTTT');	
		//gridRowAll=gridRowAll.split('|').join('PIPECHAR');	
		
	}
	
	/*if (gridRowAll == '')	
		return true;*/
	try 
	{
	
				
		var url = "/TF/CustomForms/TF_Specific/InsertUTCGridData.jsp";
		var param="&gridRow=" + gridRowAll+"&wi_name="+wi_name+"&WSNAME="+WSNAME;
		var xhr;
		var ajaxResult;
		if (window.XMLHttpRequest)
			xhr = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr = new ActiveXObject("Microsoft.XMLHTTP");
		xhr.open("POST", url, false);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send(param);
		
		if (xhr.status == 200)
			{
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult=='-1')
				 {
					alert("Problem in saving UTC Grid data");
					return false;
				 }
			}
	} 
	catch (e) 
	{
		alert("Exception while saving UTC Grid Data:" + e);
		return false;
	}
    
	return true;
}	
	
function saveException() 
{	
	var WSNAME = customform.document.getElementById("wdesk:CURRENT_WS").value;
    var WINAME = customform.document.getElementById("wdesk:WI_NAME").value;
	var checklistData = customform.document.getElementById('H_CHECKLIST').value;
	if(checklistData!="")
	{
		var xhr;
		if (window.XMLHttpRequest)
			xhr = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr = new ActiveXObject("Microsoft.XMLHTTP");

		var url = "/TF/CustomForms/TF_Specific/SaveException.jsp";
		var param = "WINAME="+encodeURIComponent(WINAME)+"&WSNAME="+encodeURIComponent(WSNAME)+ "&checklistData=" + encodeURIComponent(checklistData);
		//param = encodeURIComponent(param);
		xhr.open("POST", url, false);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send(param);
		
		if (xhr.status == 200 && xhr.readyState == 4) 
		{
			ajaxResult = xhr.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
			if(ajaxResult=='-1')
			 {
				alert("Problem in saving exceptions.");
				return false;
			 }
		} 
		else 
		{
			alert("Error while saving exception data.");
			return false;
		}	
	}
    return true;
}
/*function checkDuplicateWorkitems()
{	
			var customform = '';
			var formWindow = getWindowHandler(windowList, "formGrid");
			customform = formWindow.frames['customform'];
			var ProcessInstanceId = customform.document.getElementById("wdesk:WI_NAME").value;
			var WSNAME = customform.document.getElementById("wdesk:WS_NAME").value;
			var iframe = customform.document.getElementById("frmData");
			var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
			var SubCategoryID = iframeDocument.getElementById("SubCategoryID").value;
			var CategoryID = iframeDocument.getElementById("CategoryID").value;
			var duplicateLogic=customform.document.getElementById("DuplicateCheckLogic").value;
			var arrayDuplicateLogic=duplicateLogic.split('$');
			var TRPARAM=arrayDuplicateLogic[0];
			var EXTPARM=arrayDuplicateLogic[1];
			var tr_table=iframeDocument.getElementById("tr_table").value;
			//alert("--tr_table--"+tr_table);
			var NameData=getNameData();
			var condition='';
			var conditionvalues='';
			var arrayTRPARAM=TRPARAM.split('@');
			//Maiking condition for external table columns
			var arrayEXTPARM=EXTPARM.split('@');
			for(var i=0;i<arrayEXTPARM.length;i++)//Loop For TRPARAM
			{
					if(arrayEXTPARM[i].indexOf('date')!=-1||arrayEXTPARM[i].indexOf('Date')!=-1)
					{	
						//alert("if arrayEXTPARM[i].indexOf('date')");
						if (arrayEXTPARM[i] == 'ApplicationDate' || arrayEXTPARM[i] == 'Product_Type')
						{
							//alert("if (if ApplicationDate or Product_Type) arrayEXTPARM[i].indexOf('date')");
							condition='WHERE CONVERT(VARCHAR(10),EXT.'+arrayEXTPARM[i]+',103)='+"'"+customform.document.getElementById(arrayEXTPARM[i]).value+"'";
							//conditionvalues=customform.document.getElementById(arrayEXTPARM[i]).value;
						}
						else{
							//alert("if (else ApplicationDate or Product_Type) arrayEXTPARM[i].indexOf('date')");
							condition='WHERE CONVERT(VARCHAR(10),EXT.'+arrayEXTPARM[i]+',103)='+"'"+customform.document.getElementById('wdesk:'+arrayEXTPARM[i]).value+"'";
							//conditionvalues=customform.document.getElementById('wdesk:'+arrayEXTPARM[i]).value;
						}
					}
					else
					{
						//alert("else arrayEXTPARM[i].indexOf('date')");
						if (arrayEXTPARM[i] == 'ApplicationDate' || arrayEXTPARM[i] == 'Product_Type')
						{
							//alert("else (if ApplicationDate or Product_Type) arrayEXTPARM[i].indexOf('date')");
							condition=condition+' AND EXT.'+arrayEXTPARM[i]+'='+"'"+customform.document.getElementById(arrayEXTPARM[i]).value+"'";
							//conditionvalues=conditionvalues+"~"+customform.document.getElementById(arrayEXTPARM[i]).value;
						}
						else{
							//alert("else (else ApplicationDate or Product_Type) arrayEXTPARM[i].indexOf('date')");
							condition=condition+' AND EXT.'+arrayEXTPARM[i]+'='+"'"+customform.document.getElementById('wdesk:'+arrayEXTPARM[i]).value+"'";
							//conditionvalues=conditionvalues+"~"+customform.document.getElementById('wdesk:'+arrayEXTPARM[i]).value;
						}			
					}
			}
			//***********************************************************************
			
			//Maiking condition for Transaction table columns
			var arrayTRPARAM=TRPARAM.split('@');
			for(var i=0;i<arrayTRPARAM.length;i++)//Loop For TRPARAM
			{
				   NameData=NameData.substring(0,(NameData.lastIndexOf("~")));
				   var arr=NameData.split('~');
				   for(var j = 0; j < arr.length; j++)//Loop For named date value to match the TRPARAM name and get the values
				   {
						var temp=arr[j].split('#');
						var id=temp[0];
						var nameForMatch=id.substring((id.indexOf('_')+1),id.length);
						if(arrayTRPARAM[i]==nameForMatch)
						{	
							condition=condition+' AND TR.'+nameForMatch+'='+"'"+iframeDocument.getElementById(id).value+"'";
							//conditionvalues=conditionvalues+"~"+iframeDocument.getElementById(id).value;
							break;
						}
				   }
			}
			//alert("--condition=--"+condition);
			//*********************************************************************
			var DuplicateParam=['Product_Category','Product_Type'];
			for(var i=0;i<DuplicateParam.length;i++)//Loop For TRPARAM
			{				
				if(conditionvalues=='')
					conditionvalues=customform.document.getElementById('wdesk:'+DuplicateParam[i]).value;
				else
					conditionvalues=conditionvalues+"~"+customform.document.getElementById('wdesk:'+DuplicateParam[i]).value;				
			}
			//alert("--conditionvalues=--"+conditionvalues);
			//*********************************************************************** 
			var xhr;
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");

			var url = "/TF/CustomForms/TF_Specific/getDuplicateWorkitems.jsp";
			var param = "WI_NAME=" + ProcessInstanceId+"&WSNAME="+WSNAME+"&condition="+condition+"&tr_table="+tr_table+"&reqType=DuplicateWI";
			//param = encodeURIComponent(param);
			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
			//return false;
			if (xhr.status == 200 && xhr.readyState == 4) 
			{
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
					if(ajaxResult=="-1")
					{
					 alert("Problem in getting duplicate workitems list."+ajaxResult);
					 return false;
					}
					else if(ajaxResult=="")//Blank means not found any result
					{
					 return true;
					}
					customform.document.getElementById("duplicateWorkitemsId").innerHTML=ajaxResult; 
					var txt;
					var r = confirm("Duplicate workitems found! Do you want to process the case?");
					if (r == true) 
					{
						if(callInsertDuplicateWorkitems(conditionvalues))
							return true;
						else
							return false;
					} 
					else 
					{
						return false;
					}					
			} 
			else 
			{
				alert("Problem in getting duplicate workitems list."+xhr.status);
				return false;
			}		
}
function checkDuplicateWorkitemsForGrid()
{
			
	var customform = '';
	var formWindow = getWindowHandler(windowList, "formGrid");
	customform = formWindow.frames['customform'];
	var ProcessInstanceId = customform.document.getElementById("wdesk:WI_NAME").value;
	var WSNAME = customform.document.getElementById("wdesk:WS_NAME").value;
	var iframe = customform.document.getElementById("frmData");
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	var SubCategoryID = iframeDocument.getElementById("SubCategoryID").value;
	var CategoryID = iframeDocument.getElementById("CategoryID").value;
	var duplicateLogic=customform.document.getElementById("DuplicateCheckLogic").value;
	var arrayDuplicateLogic=duplicateLogic.split('$');
	var TRPARAM=arrayDuplicateLogic[0];
	var EXTPARM=arrayDuplicateLogic[1];
	var tr_table=iframeDocument.getElementById("tr_table").value;
	//alert("--tr_table--"+tr_table);
	var NameData=getNameData();
	var condition='';
	var conditionvalues='';
	
	//Maiking condition for external table columns
	var arrayEXTPARM=EXTPARM.split('@');
	for(var i=0;i<arrayEXTPARM.length;i++)//Loop For EXTPARM
	{
			if(arrayEXTPARM[i].indexOf('date')!=-1||arrayEXTPARM[i].indexOf('Date')!=-1)
			{
				if(condition=="")
				{	
					condition='WHERE CONVERT(VARCHAR(10),EXT.'+arrayEXTPARM[i]+',103)='+"'"+customform.document.getElementById(arrayEXTPARM[i]).value+"'";
				}
				else
				{
					condition=condition+' AND CONVERT(VARCHAR(10),EXT.'+arrayEXTPARM[i]+',103)='+"'"+customform.document.getElementById(arrayEXTPARM[i]).value+"'";
				}
			}
			else
			{
				if(condition=="")
				{	
					condition='WHERE EXT.'+arrayEXTPARM[i]+'='+"'"+customform.document.getElementById('wdesk:'+arrayEXTPARM[i]).value+"'";
				}
				else
				{
					condition=condition+' AND EXT.'+arrayEXTPARM[i]+'='+"'"+customform.document.getElementById('wdesk:'+arrayEXTPARM[i]).value+"'";
				}
			}
	}
	//***********************************************************************
	
	//Making condition for Transaction table columns
	var arrayTRPARAM=TRPARAM.split('@');
	for(var i=0;i<arrayTRPARAM.length;i++)//Loop For TRPARAM
	{
		   NameData=NameData.substring(0,(NameData.lastIndexOf("~")));
		   var arr=NameData.split('~');
		   for(var j = 0; j < arr.length; j++)//Loop For named date value to match the TRPARAM name and get the values
		   {
				var temp=arr[j].split('#');
				var id=temp[0];
				var nameForMatch=id.substring((id.indexOf('_')+1),id.length);
				if(arrayTRPARAM[i]==nameForMatch)
				{
					var getValuesForGrid=getgridValuesByColumnName(nameForMatch);
					var arrayValuesForGrid=getValuesForGrid.split('@');
					for(var k = 0; k < arrayValuesForGrid.length; k++)
					   {
							condition=condition+' AND TR.'+nameForMatch+' like '+"'PERCENT"+arrayValuesForGrid[k]+"PERCENT'";
					   }
					condition=condition+' AND len('+nameForMatch+')='+getValuesForGrid.length; 
				}     
		   }
	}
	//***********************************************************************	
	var DuplicateParam=['Product_Category','Product_Type'];
	for(var i=0;i<DuplicateParam.length;i++)//Loop For TRPARAM
	{		
		if(conditionvalues=='')
			conditionvalues=customform.document.getElementById('wdesk:'+DuplicateParam[i]).value;
		else
			conditionvalues=conditionvalues+"~"+customform.document.getElementById('wdesk:'+DuplicateParam[i]).value;		
	}
	//alert("--conditionvalues=--"+conditionvalues);
	//**************************************************************************
	var xhr;
	if (window.XMLHttpRequest)
		xhr = new XMLHttpRequest();
	else if (window.ActiveXObject)
		xhr = new ActiveXObject("Microsoft.XMLHTTP");

	var url = "/TF/CustomForms/TF_Specific/getDuplicateWorkitems.jsp";
	var param = "WI_NAME=" + ProcessInstanceId+"&WSNAME="+WSNAME+"&CategoryID=" + CategoryID+"&SubCategoryID="+SubCategoryID+"&condition="+condition+"&tr_table="+tr_table+"&reqType=DuplicateWI";
	//param = encodeURIComponent(param);
	xhr.open("POST", url, false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	//return false;
	if (xhr.status == 200 && xhr.readyState == 4) 
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
			if(ajaxResult=="-1")
			{
			 alert("Problem in getting duplicate workitems list."+ajaxResult);
			 return false;
			}
			else if(ajaxResult=="")//Blank means not found any result
			{
			 return true;
			}
			customform.document.getElementById("duplicateWorkitemsId").innerHTML=ajaxResult; 
			var txt;
			var r = confirm("Duplicate workitems found! Do you want to process the case?");
			if (r == true) 
			{
				if(callInsertDuplicateWorkitems(conditionvalues))
					return true;				
				else
					return false;
			} 
			else 
			{
				return false;
			}					
	} 
	else 
	{
		alert("Error in reading duplicate workitems list."+xhr.status);
		return false;
	}		
}*/
function validateOnInroduceClick(flag) 
{
	var customform = '';
	var formWindow = getWindowHandler(windowList, "formGrid");
	customform = formWindow.frames['customform'];
	var iframe = customform.document.getElementById("frmData");
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	var Product_Category=customform.document.getElementById("Product_Category").value;
	var WSNAME = customform.document.getElementById("wdesk:WS_NAME").value;	
	var ProcessInstanceId = customform.document.getElementById("wdesk:WI_NAME").value;
	
	
     //var CategoryID="";
    if (true) {
	//alert('inside category check');
        var ProcessInstanceId = customform.document.getElementById("wdesk:WI_NAME").value;
        //var isIntegrationCallSuccess = FireIntegrationCall(true, "custom", customform, ProcessInstanceId);

       // if (isIntegrationCallSuccess == "false")
          //  return false;

       // isIntegrationCallSuccess = isIntegrationCallSuccess.split("$$");
       // if (isIntegrationCallSuccess.length == 2) {

          //  if (isIntegrationCallSuccess[0] == "false" && isIntegrationCallSuccess[1] == "false") {
           //     return false;
           // }
           //alert('before calling save data');
		   if(flag=='S'){
				var isSaveSuccess = saveTFData(false, "custom", customform);
			}else{
				var isSaveSuccess = saveTFData(true, "custom", customform);
			}

            if (!isSaveSuccess) {
                return false;
            }
			// below block is commented - ServiceRequest Code has been taken from gettallhiddenparam jsp based on service request selected _ 11092017
			/*if(WSNAME=="CSO")
			{
				fetchSubCatCode();   //function added by shamily to fetch subCategorycode
			}*/
			//*********************************************************************	
			if(WSNAME=="CSO")
			{
				//Save DocGridData in Database
				var DocGridflag=saveDocGridData();
				if(DocGridflag!=true)
					return false;
			}
			if(WSNAME=="CSO" || WSNAME=="TF_Maker" || WSNAME=="TF_Document_Approver" || WSNAME=="TF_Checker")
			{							
				//ChecklistGrid
				var CHECKLIST_WSNAME= customform.document.getElementById("CHECKLIST_WSNAME").value;
				if(CHECKLIST_WSNAME == WSNAME)
				{
					var checklistflag=savechecklistData();
					//alert("checklistflag--"+checklistflag);
					if(checklistflag!=true)
						return false;	
				}					
			}	
			
            if(flag=="I"||flag=="D")
			{
				if(WSNAME=="CSO")
				{
					fetchSubCatCode();
					var subCatCode=customform.document.getElementById("wdesk:ServiceRequestCode").value;
					var transInSus=customform.document.getElementById("isTransInSusAccount").value;
					var currencySelected=customform.document.getElementById("currencySelected").value;
					if(transInSus=="Yes" && currencySelected!=="AED")
					{
						alert("Only AED currency is allowed when the Transaction in Suspended Account is selected as Yes");
						return false;
					}	
				}				
				
					//Code for checking that service request has grid or not
					/* var myname;	
					var inputs = iframeDocument.getElementsByTagName("input");
					var store = "";
					var arrGridBundle = "";
					var singleGridBundle = "";
					for (x = 0; x < inputs.length; x++) {
							myname = inputs[x].getAttribute("id");
							if (myname == null)
								continue;
							if (!(myname.indexOf("_gridbundle_clubbed") == -1)) {
								singleGridBundle = iframeDocument.getElementById(myname).value;
								if (arrGridBundle == "")
									arrGridBundle = singleGridBundle;
								else
									arrGridBundle += "$$$$" + singleGridBundle;
							}
					}
					if (arrGridBundle != '') 
					{ }*/
				
				
				var Exceptionflag=saveException();
				if(Exceptionflag)
				{
				}
				else
				{
					alert("Error in Saving Exception in Exception History Table");
					return false;
				}
				
				if(WSNAME=="CSO" || WSNAME=="TF_Document_Approver")
				{
					//Retrieving the DuplicateWorkitems which are stored in External Table
					var EventDetailsCheckGridData =customform.document.getElementById("wdesk:EventDetailsCheckGridData").value;
					/*if(EventDetailsCheckGridData=='')
					{
						var Document_Approval_Required = customform.document.getElementById("wdesk:Document_Approval_Required").value;
						if (Document_Approval_Required !='Y')
						{
							document.getElementById('customform').contentWindow.loadEventGrid(WSNAME,ProcessInstanceId);
						}
					}
					EventDetailsCheckGridData = customform.document.getElementById("wdesk:EventDetailsCheckGridData").value;*/
					if(EventDetailsCheckGridData!='')//inserting in Duplicate Table if Duplicates found
					{
						if(callInsertDuplicateWorkitems(EventDetailsCheckGridData))
						{
						}
						else
						{
							alert("Error in saving event details check data.");
							return false;
						}
					}
				}
				//below condition added for Mail trigger on TF_Checker WS 19112018
				if(WSNAME=="TF_Checker")
				{
					var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
					var ApplicationFormCode=customform.document.getElementById("wdesk:ServiceRequestCode").value;
					if(ApplicationFormCode == 'TF027' || ApplicationFormCode == 'TF028' || ApplicationFormCode == 'TF038' || ApplicationFormCode == 'TF039')
					{
						if(customform.document.getElementById("selectDecision").value == 'Approve' || customform.document.getElementById("selectDecision").value == 'Partial Release')
						{
							document.getElementById('customform').contentWindow.sendMail(WSNAME);
						}
						
					}
				  /*	if(customform.document.getElementById("selectDecision").value == 'Send for Business Approval' || customform.document.getElementById("selectDecision").value == 'Send for CROPS Action' || customform.document.getElementById("selectDecision").value == 'Send to Business and CROPS')
					{
						document.getElementById('customform').contentWindow.sendMail();
					} */
					
				}
				
				if(WSNAME=="TF_Checker" || WSNAME=="TF_Document_Approver")
				{
					if(customform.document.getElementById("selectDecision").value == 'Hold-External')
					{
						document.getElementById('customform').contentWindow.sendMail(WSNAME);
					}
				}
				
				//added by stutee.mishra
				if(WSNAME=="RM")
				{
					var isDistributed = fetchIsDistributedValue();
					if((customform.document.getElementById("selectDecision").value == 'Approve' || customform.document.getElementById("selectDecision").value == 'Reject') && isDistributed == 'No')
					{
						document.getElementById('customform').contentWindow.sendMail(WSNAME);
					}
				}
				
				alert("The request has been submitted successfully.");
			}
           // alert(isIntegrationCallSuccess[1]);
			//hideProcessingCustom();
			 
            return true;
        //} else {
			//alert("Some error occured while introducing the case.");
            //hideProcessingCustom();
          //  return false;
      //  }
    } else
        return true;
}

//added by stutee.mishra to fetch isDistributed value from DB
function fetchIsDistributedValue()
{
	var reqType = 'fetchIsDistributed';
	var wi_name = customform.document.getElementById("wdesk:WI_NAME").value;
	//var ws_name = customform.document.getElementById("wdesk:WS_NAME").value;
	var xhr;
	if (window.XMLHttpRequest)
		xhr = new XMLHttpRequest();
	else if (window.ActiveXObject)
		xhr = new ActiveXObject("Microsoft.XMLHTTP");

	var url = "/TF/CustomForms/TF_Specific/HandleAjaxProcedures.jsp";
	var param = "&reqType="+reqType+"&wi_name=" + wi_name;
	//param = encodeURIComponent(param);
	xhr.open("POST", url, false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	//return false;
	if (xhr.status == 200 && xhr.readyState == 4) 
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
		return(ajaxResult);
	}
	//else{
		//alert("error while fetching Opd");
	//}
}

//function added by shamily to fetch subCategorycode
function fetchSubCatCode()
{
	var reqType = 'fetchSubCatCode';
	var SubCategoryName = customform.document.getElementById("Product_Type").value;
	var wi_name = customform.document.getElementById("wdesk:WI_NAME").value;
	var xhr;
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");

			var url = "/TF/CustomForms/TF_Specific/HandleAjaxProcedures.jsp";
			var param = "SubCategoryName=" + SubCategoryName+"&reqType="+reqType+"&wi_name=" + wi_name;
			//param = encodeURIComponent(param);
			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
			//return false;
			if (xhr.status == 200 && xhr.readyState == 4) 
			{
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
				customform.document.getElementById("wdesk:ServiceRequestCode").value =ajaxResult;
			}
			else{
				alert("error while fetching code");
			}
}
//added by shamily to fetch opsmaker remarks
function fetchOpsmaker_remarks()
{
	var reqType = 'opsmaker_remarks';
	//var  SubCategoryName = customform.document.getElementById("Product_Category").value;
	var wi_name = customform.document.getElementById("wdesk:WI_NAME").value;
	var ws_name = customform.document.getElementById("wdesk:WS_NAME").value;
	var xhr;
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");

			var url = "/TF/CustomForms/TF_Specific/HandleAjaxProcedures.jsp";
			var param = "ws_name=" + ws_name+"&reqType="+reqType+"&wi_name=" + wi_name;
			//param = encodeURIComponent(param);
			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
			//return false;
			if (xhr.status == 200 && xhr.readyState == 4) 
			{
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
				return(ajaxResult);
			}
			//else{
				//alert("error while fetching Opd");
			//}
}

function saveTFData(IsDoneClicked,donefrm,fobj)
{
	var customform='';
	var IsError='N';
	var WS_LogicalName;
	var tr_table;
	
	if(donefrm=='custom')
	{	//alert('inside donefrm');
	//alert("fobj"+fobj);
		customform=fobj;	
	}
	else
	{   //alert('inside else');
		var formWindow=getWindowHandler(windowList,"formGrid");
		customform=formWindow.frames['customform'];
	}
	
	if(IsDoneClicked)
	{
		var cifId=customform.document.getElementById("wdesk:CIF_ID").value;
		//if(cifId=='' && customform.document.getElementById("selectDecision").value !='Reject') //decision condition added by shamily to not pop up alert when decision reject
		if(cifId=='') // condition added for not to check mandatory when decision is reject on 05092017 - made mandatory for all the decision 
		{
			alert("Please click the search button and select the CIF Id.");
			customform.document.getElementById("Fetch").focus();
			return false;
		}
	}
	
	var iframe = customform.document.getElementById("frmData");
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	//alert("iframeDocument"+iframeDocument);
	var CategoryID=iframeDocument.getElementById("CategoryID").value;
	//alert("CategoryID"+CategoryID);
	var SubCategoryID=iframeDocument.getElementById("SubCategoryID").value;
	//alert("SubCategoryID"+SubCategoryID);
	var IsSaved = customform.document.getElementById("savedFlagFromDB").value;
	//alert("IsSaved"+IsSaved);
	var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
	var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
	var TEMPWINAME=customform.document.getElementById("CategoryID").value;
	var remarks=customform.document.getElementById("remarks").value;
	//modified by shamily to add reject reason parameter to add in history table
	var RejectReason=customform.document.getElementById("rejReasonCodes").value;
	var decisionNew=customform.document.getElementById("selectDecision").value;
	//alert(decisionNew);
	var PANno=iframeDocument.getElementById("CategoryID").value;
	//alert("PANno"+PANno);
	WIDATA=computeWIDATA(iframe,SubCategoryID,WSNAME,IsDoneClicked,CategoryID,fobj);
	
	//alert('WIDATA '+WIDATA);
	
	var test_str = WIDATA;
	var start_pos = test_str.indexOf('#') + 1;
	var end_pos = test_str.indexOf('~',start_pos);
	var text_to_get = test_str.substring(start_pos,end_pos)
//alert(customform.document.getElementById("wdesk:AccountNo").value);
	
	var selectedValues="";
	 var x=customform.document.getElementById("modeofdelivery");
	  for (var i = 0; i < x.options.length; i++) 
	  {
		 if(x.options[i].selected ==true)
		 {
				if(selectedValues=="")
				selectedValues=x.options[i].value;
				else                    
				selectedValues=selectedValues+"&"+x.options[i].value;
		 }            
	  }
	customform.document.getElementById("wdesk:ModeOfDelivery").value=selectedValues;
	
	var inputs = iframeDocument.getElementsByTagName("input");
	
		for (x=0;x<inputs.length;x++)
		{	
			myname = inputs[x].getAttribute("id");
			if(myname==null)
				continue;
					
			if(myname.indexOf("tr_")==0)
			{
				//alert('tr_table'+iframeDocument.getElementById(myname).value);
				tr_table = iframeDocument.getElementById(myname).value;
			}
			else if(myname.indexOf("WS_LogicalName")==0)
			{
				//alert('WS_LogicalName'+iframeDocument.getElementById(myname).value);
				WS_LogicalName = iframeDocument.getElementById(myname).value;
			}
			
		}
				
	var xhr;
	
	if(window.XMLHttpRequest)
		xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		xhr=new ActiveXObject("Microsoft.XMLHTTP");
	//alert('iserror'+iframeDocument.getElementById(SubCategoryID+"_IsError").value);
	//IsError=iframeDocument.getElementById(SubCategoryID+"_IsError").value;	 

	// Start - Checking any row has been added for grid type of reuest or not upon Save or Done
	
	// End - Checking any row has been added for grid type of reuest or not upon Save or Done
	
	if(IsDoneClicked)
	{
			var customform = '';
			var formWindow = getWindowHandler(windowList, "formGrid");
			customform = formWindow.frames['customform'];
			var iframe = customform.document.getElementById("frmData");
			var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
			var ModeDelivery=customform.document.getElementById("wdesk:ModeOfDelivery").value;
			//var emirateexpdate=customform.document.getElementById("wdesk:EmratesIDExpDate").value;
			var NameData=getNameData();
			var IslamicorConventional=customform.document.getElementById("wdesk:Islamic_Or_conventions").value;
			var applicationDate=customform.document.getElementById("wdesk:ApplicationDate").value;
			
			if(applicationDate=='' && customform.document.getElementById("selectDecision").value!='Reject')
			{
				alert("Please enter application date.");
				customform.document.getElementById("wdesk:ApplicationDate").focus();
				return false;
			}
			if(IslamicorConventional=='')
			{
				alert("Please enter Islamic / Conventional");
				customform.document.getElementById("wdesk:Islamic_Or_conventions").focus();
				return false;
			}
			if(WSNAME=="CSO")
			{
				if((customform.document.getElementById("wdesk:Initiation_source").value)=='')  
				{
					alert("Please enter Initiation Source");
					customform.document.getElementById("wdesk:Initiation_source").focus();
					return false;
				}
			}
			if(customform.document.getElementById("wdesk:CIF_ID").value==""  && customform.document.getElementById("selectDecision").value!='Reject') //decision condition added by shamily to not pop up alert when decision reject
			{
				alert("Please select CIF Number from grid.");
				return false;
			}
			
			var myname;	
			var inputs = iframeDocument.getElementsByTagName("input");
			var store = "";
			var arrGridBundle = "";
			var singleGridBundle = "";
			for (x = 0; x < inputs.length; x++) {
					myname = inputs[x].getAttribute("id");
					if (myname == null)
						continue;
					if (!(myname.indexOf("_gridbundle_clubbed") == -1)) {
						singleGridBundle = iframeDocument.getElementById(myname).value;
						if (arrGridBundle == "")
							arrGridBundle = singleGridBundle;
						else
							arrGridBundle += "$$$$" + singleGridBundle;
					}
			}
			if (arrGridBundle != '') 
			{
				//******below code added for WS Condition & if any of the dynamic fields are not mandatory for LCD ISS - Local Cheque Discounting - Issue on Done Click of CSO WS 26112018******
				if(WSNAME=="CSO" || WSNAME=="TF_Document_Approver")
				{
					if(!ValidateGridInTF())
						return false;
				}
			}
			
			if(!Validate(NameData, iframeDocument, "Y"))
			{
			  return false;
			}
			if(customform.document.getElementById("selectDecision").value=="--Select--" || customform.document.getElementById("selectDecision").value=="")
			{
				alert("Please select decision.");
				customform.document.getElementById("selectDecision").focus();
				return false;
			}
			
			customform.document.getElementById("wdesk:Decision").value = customform.document.getElementById("selectDecision").value;
			
			if(customform.document.getElementById("remarks").value.length > 43000)
			{
			  alert("Large images in remarks are not allowed, Please remove/replace it with small size of image.");
			  customform.document.getElementById('RichText').focus(true);
			  return false;
			}
			
			//Mandatory Validations for CheckList Details Grid
			if(WSNAME=="CSO")
			{
				var ChecklistWiname= customform.document.getElementById("CHECKLIST_WSNAME").value;  		
				if(ChecklistWiname == WSNAME)
				{
					var table = customform.document.getElementById("checklistGrid");
					var rowCount=(table.rows.length);
					var arrayIdentificationDocFieldsForSave=['option'];
					for (var i = 1; i < rowCount; i++)
					{
						for (var j = 0; j < arrayIdentificationDocFieldsForSave.length; j++) 
						{							
							if(customform.document.getElementById('Y'+i).checked == false && customform.document.getElementById('N'+i).checked == false && customform.document.getElementById('NA'+i).checked == false)
							{
								alert("Please select radio button of Checklist Details Grid");
								customform.document.getElementById('Y'+i).focus(true);
								return false;
							}															
						}
					}	
				}				
			}
			
			if(WSNAME =='CSO')
			{
				
				if(customform.document.getElementById("selectDecision").value=='Approve')
				{
					//Code added to make no of pages scanned mandatory			
					var Noofpagesscanned=customform.document.getElementById("wdesk:NoOfPagesScanned").value;
					if(Noofpagesscanned=='')
					{
						alert("Please enter No of Pages Scanned");
						customform.document.getElementById("wdesk:NoOfPagesScanned").focus();
						return false;
					}
				
					// commented by ankit on 19062017 to remove mandatory checks for mode of delivery
					//Will run only when printdispatch is Y
					if(customform.document.getElementById("wdesk:Document_Dispatch_Required").value=='Y')
					{				
						  var x=customform.document.getElementById("modeofdelivery");
						  var flag='true';
						  for (var i = 0; i < x.options.length; i++) 
						  {
								 if(x.options[i].selected ==true)
								 {
								   flag='true';
								   break;
								 }
								 else
								 flag='false';			
						  }
						  if(flag=='false')
						  {
							alert("Please select mode of delivery");
							customform.document.getElementById("modeofdelivery").focus();
							return false;
						  }
						  
						  var selectedValues="";
						  for (var i = 0; i < x.options.length; i++) 
						  {
							 if(x.options[i].selected ==true)
							 {
									if(selectedValues=="")
									selectedValues=x.options[i].value;
									else                    
									selectedValues=selectedValues+"&"+x.options[i].value;
							 }            
						  }
						  if(selectedValues=='Branch')
							{
								if(customform.document.getElementById("wdesk:DocumentCollectionBranch").value=='' ||
								customform.document.getElementById("wdesk:DocumentCollectionBranch").value=='--Select--')
								{
									alert("Please select Document Collection Branch");
									customform.document.getElementById("doccollectionbranch").focus();
									return false;
								}
								if(customform.document.getElementById("wdesk:BranchDeliveryMethod").value=='' ||
								customform.document.getElementById("wdesk:BranchDeliveryMethod").value=='--Select--')
								{
									alert("Please select BranchDeliveryMethod");
									customform.document.getElementById("branchDeliveryMethod").focus();
									return false;
								}
							}
							if(selectedValues=='Email')
							{
								if(customform.document.getElementById("wdesk:PrimaryEmailId").value == ''||customform.document.getElementById("wdesk:PrimaryEmailId").value == null || customform.document.getElementById("wdesk:PrimaryEmailId").value =='dummy@rakbank.ae')
									{
										alert("Valid Primary Email id is mandatory for Email");
										customform.document.getElementById("wdesk:PrimaryEmailId").focus();
										return false;
									}
							}
							if(selectedValues=='Branch&Email'||selectedValues=='Email&Branch')
							{
								if(customform.document.getElementById("wdesk:DocumentCollectionBranch").value=='' ||
								customform.document.getElementById("wdesk:DocumentCollectionBranch").value=='--Select--')
								{
									alert("Please select Document Collection Branch");
									customform.document.getElementById("doccollectionbranch").focus();
									return false;
								}				
								if(customform.document.getElementById("wdesk:PrimaryEmailId").value == ''||customform.document.getElementById("wdesk:PrimaryEmailId").value == null || customform.document.getElementById("wdesk:PrimaryEmailId").value =='dummy@rakbank.ae')
								{
									alert("Valid Primary Email id is mandatory for Email");
									customform.document.getElementById("wdesk:PrimaryEmailId").focus();
									return false;
								}
							}
							if(selectedValues=='Courier&Email'||selectedValues=='Email&Courier')
							{				
								if(customform.document.getElementById("wdesk:PrimaryEmailId").value == ''||customform.document.getElementById("wdesk:PrimaryEmailId").value == null || customform.document.getElementById("wdesk:PrimaryEmailId").value =='dummy@rakbank.ae')
								{
									alert("Valid Primary Email id is mandatory for Email");
									customform.document.getElementById("wdesk:PrimaryEmailId").focus();
									return false;
								}
							}
							if(!getMultipleSelectedValue())
							return false;
					
						//Document Types Validation on Done Click
						/* if(selectedValues=="Courier" || selectedValues=='Courier&Email' || selectedValues=='Email&Courier' || selectedValues=='Branch&Email&Courier' || selectedValues=='Email&Branch&Courier' || selectedValues=='Email&Courier&Branch')
						{
							if(!AttachedDocType('Courier_Receipt',true))
							return false;
						} */
					}
					
					
					//Mandatory check for EventDetailsGrid
					/*var EventDetailsGridFlag = customform.document.getElementById("EventDetailsFlag").value;
					if(EventDetailsGridFlag == '')
					{
						alert("Please Perform Event Details Check");
						return false;					
					}*/
					
					//View Sign is mandatory for Approve Decision on CSO WS only 12112018
					/*if(customform.document.getElementById("wdesk:sign_matched_CSO").value=='')
					{
						alert("Please verify signatures while selecting 'Approve' as decision");
						customform.document.getElementById("viewSign").focus();
						return false;
					}*/						
				}
					if(customform.document.getElementById("DeferralWaiverHeldCombo").value=='')
					{
						alert("Please select  Deferral/Waiver Held.");
						customform.document.getElementById("DeferralWaiverHeldCombo").focus();
						return false;
					}
					if(customform.document.getElementById("wdesk:ApprovingAuthority").value==''||customform.document.getElementById("wdesk:ApprovingAuthority").value==null)
					{
						if(customform.document.getElementById("DeferralWaiverHeldCombo").value=='Y')
						{
						alert("Approving Authority(Name) for Deferral is mandatory to fill");
						customform.document.getElementById("wdesk:ApprovingAuthority").focus();
						return false;
						}
					}
					if(customform.document.getElementById("wdesk:DocumentTypedeferred").value==''||customform.document.getElementById("wdesk:DocumentTypedeferred").value==null)
					{
						if(customform.document.getElementById("DeferralWaiverHeldCombo").value=='Y')
						{
						alert("Document Type Deferred is mandatory to fill");
						customform.document.getElementById("wdesk:DocumentTypedeferred").focus();
						return false;
						}
					}
					if(customform.document.getElementById("wdesk:DeferralExpiryDate").value==''||customform.document.getElementById("wdesk:DeferralExpiryDate").value==null)
					{
						if(customform.document.getElementById("DeferralWaiverHeldCombo").value=='Y')
						{
						alert("Deferral Expiry Date is mandatory to fill");
						customform.document.getElementById("wdesk:DeferralExpiryDate").focus();
						return false;
						}
					}			
				
				//if (customform.document.getElementById("wdesk:CIFTYPE").value=='Individual')
					//{
						//if(customform.document.getElementById("DeferralWaiverHeldCombo").value!='Y')
						//{
							//var getMandatoryDocs = iframeDocument.getElementById("mandatoryDocs").value;
							//if (customform.document.getElementById("wdesk:ResidentCountry").value=='AE')
							//{
								//Confirmation dialog if emid number is blank on form wdesk:EmiratesIDHeader
								/*if(customform.document.getElementById("wdesk:EmiratesIDHeader").value=='')
								{
									confirm("EID is not updated in the records");
								}*/
								//****************************************************************
							//	if(getMandatoryDocs!="")
							//	if(!AttachedDocType(getMandatoryDocs,true))
							/*	if(customform.document.getElementById("selectDecision").value=="Deferral Closed")
								{
									if(!AttachedDeferralDocType('Deferral_Closure_Document',true))
									return false;
								}	*/
								if(!AttachedDocTypegeneral())
								return false;
							//}  // Removed ResidentCountry check on 29102017
							/*else if (customform.document.getElementById("wdesk:ResidentCountry").value!='AE')
							{
								if(getMandatoryDocs!="")
								{
									if (getMandatoryDocs.indexOf("Emirates_ID")!=-1)
									{
										getMandatoryDocs= getMandatoryDocs.replace("Emirates_ID","Passport");
									}
									if(!AttachedDocType(getMandatoryDocs,true))
									{
										return false;
										customform.document.getElementById("wdesk:DeferralWaiverHeld").value=customform.document.getElementById("DeferralWaiverHeldCombo").value;
									}
								}
							}*/
						//}
					//}
			}
			else if(WSNAME=="TF_Maker")
			{
				if(customform.document.getElementById("wdesk:Document_Dispatch_Required").value=='Y')
				{
					 var x=customform.document.getElementById("modeofdelivery");
					 
					 var flag='true';
					  for (var i = 0; i < x.options.length; i++) 
					  {
							 if(x.options[i].selected ==true)
							 {
							   flag='true';
							   break;
							 }
							 else
							 flag='false';			
					  }
					  if(flag=='false')
					  {
						alert("Please select mode of delivery");
						customform.document.getElementById("modeofdelivery").focus();
						return false;
					  }
					 
					 var selectedValues="";
					  for (var i = 0; i < x.options.length; i++) 
					  {
						 if(x.options[i].selected ==true)
						 {
								if(selectedValues=="")
								selectedValues=x.options[i].value;
								else                    
								selectedValues=selectedValues+"&"+x.options[i].value;
						 }            
					  }
							  
					if(selectedValues=='Branch')
					{					
						if(customform.document.getElementById("wdesk:DocumentCollectionBranch").value=='' ||
						customform.document.getElementById("wdesk:DocumentCollectionBranch").value=='--Select--')
						{
							alert("Please select Document Collection Branch");
							customform.document.getElementById("doccollectionbranch").focus();
							return false;
						}
						
						if(customform.document.getElementById("wdesk:BranchDeliveryMethod").value=='' ||
						customform.document.getElementById("wdesk:BranchDeliveryMethod").value=='--Select--')
						{
							alert("Please select Branch Delivery Method");
							customform.document.getElementById("branchDeliveryMethod").focus();
							return false;
						}
					}
					//Mandatory Validation added for Courier Company Name and Courier AWB Number based on Decision selected 08112018
					if(customform.document.getElementById("selectDecision").value=='Approve')
					{ 
						if(selectedValues=='Courier')
						{					
							if(customform.document.getElementById("wdesk:CourierAWBNumber").value=='')
							{
								alert("Please enter Courier AWB Number");
								customform.document.getElementById("wdesk:CourierAWBNumber").focus();
								return false;
							}
							
							if(customform.document.getElementById("wdesk:CourierCompanyName").value=='')
							{
								alert("Please enter Courier Company Name");
								customform.document.getElementById("wdesk:CourierCompanyName").focus();
								return false;
							}					
						} 
					}
					if(selectedValues=='Email')
					{
						if(customform.document.getElementById("wdesk:PrimaryEmailId").value == ''||customform.document.getElementById("wdesk:PrimaryEmailId").value == null || customform.document.getElementById("wdesk:PrimaryEmailId").value =='dummy@rakbank.ae')
						{
							alert("Valid Primary Email id is mandatory for Email");
							customform.document.getElementById("wdesk:PrimaryEmailId").focus();
							return false;
						}
					}
					if(selectedValues=='Branch&Email'||selectedValues=='Email&Branch')
					{
						if(customform.document.getElementById("wdesk:DocumentCollectionBranch").value=='' ||
						customform.document.getElementById("wdesk:DocumentCollectionBranch").value=='--Select--')
						{
							alert("Please select Document Collection Branch");
							customform.document.getElementById("doccollectionbranch").focus();
							return false;
						}				
						if(customform.document.getElementById("wdesk:PrimaryEmailId").value == ''||customform.document.getElementById("wdesk:PrimaryEmailId").value == null || customform.document.getElementById("wdesk:PrimaryEmailId").value =='dummy@rakbank.ae')
						{
							alert("Valid Primary Email id is mandatory for Email");
							customform.document.getElementById("wdesk:PrimaryEmailId").focus();
							return false;
						}
					}
					if(selectedValues=='Courier&Email'||selectedValues=='Email&Courier')
					{				
						if(customform.document.getElementById("wdesk:PrimaryEmailId").value == ''||customform.document.getElementById("wdesk:PrimaryEmailId").value == null || customform.document.getElementById("wdesk:PrimaryEmailId").value =='dummy@rakbank.ae')
						{
							alert("Valid Primary Email id is mandatory for Email");
							customform.document.getElementById("wdesk:PrimaryEmailId").focus();
							return false;
						}
					}
					if(!getMultipleSelectedValue())
						return false;
				}	
				
				//Validation added on CSO WS only 12112018
				/*if(customform.document.getElementById("selectDecision").value=='Approve')
				{
					if(customform.document.getElementById("wdesk:sign_matched_maker").value=='')
					{
						alert("Please verify signatures while selecting 'Approve' as decision");
						customform.document.getElementById("viewSign").focus();
						return false;
					}	
				}
				else*/ if(customform.document.getElementById("selectDecision").value=='Reject to CSO'){
					customform.document.getElementById("wdesk:OPSMakerRejectFlag").value ='Y';
				}
				
				//Document Types Validation on Done Click
				/* if(selectedValues=="Courier" || selectedValues=='Courier&Email' || selectedValues=='Email&Courier' || selectedValues=='Branch&Email&Courier' || selectedValues=='Email&Branch&Courier' || selectedValues=='Email&Courier&Branch')
				{
					if(!AttachedDocType('Courier_Receipt',true))
					return false;
				} */
				
				if(customform.document.getElementById("selectDecision").value=='Approve' && customform.document.getElementById("wdesk:ServiceRequestCode").value == 'TF007'){
					var ChecklistWiname= customform.document.getElementById("CHECKLIST_WSNAME").value;  		
					if(ChecklistWiname != WSNAME)
					{
						alert("Please select Checklist for Trade Finance Maker");
						customform.document.getElementById("Checklist_For").focus(true);
						return false;
					}
					if(ChecklistWiname == WSNAME)
					{
						var table = customform.document.getElementById("checklistGrid");
						var rowCount=(table.rows.length);
						var arrayIdentificationDocFieldsForSave=['option'];
						for (var i = 1; i < rowCount; i++)
						{
							for (var j = 0; j < arrayIdentificationDocFieldsForSave.length; j++) 
							{							
								if(customform.document.getElementById('Y'+i).checked == false && customform.document.getElementById('N'+i).checked == false && customform.document.getElementById('NA'+i).checked == false)
								{
									alert("Please select radio button of Checklist Details Grid");
									customform.document.getElementById('Y'+i).focus(true);
									return false;
								}															
							}
						}	
					}				
				}
				if(customform.document.getElementById("wdesk:UTCDetailsFlag").value=='Y' && ((customform.document.getElementById("wdesk:ServiceRequestCode").value == 'TF001')||(customform.document.getElementById("wdesk:ServiceRequestCode").value == 'TF007')|| (customform.document.getElementById("wdesk:ServiceRequestCode").value == 'TF011')|| (customform.document.getElementById("wdesk:ServiceRequestCode").value == 'TF032')))
				{
					if(customform.document.getElementById("wdesk:BATCH_NO").value == '') 
					{
						alert("Please enter BatchNo.");
						customform.document.getElementById("wdesk:BATCH_NO").focus();
						return false;
					}
					if(customform.document.getElementById("wdesk:DOCUMENT_COUNT").value == '')	
					{
						alert("Please enter DocumentCount.");
						customform.document.getElementById("wdesk:DOCUMENT_COUNT").focus();
						return false;
					}
					if(customform.document.getElementById("wdesk:DOCUMENT_TYPE").value == '')	
					{
						alert("Please enter Document Type.");
						customform.document.getElementById("wdesk:DOCUMENT_TYPE").focus();
						return false;
					}
					if(customform.document.getElementById("wdesk:DOCUMENT_SUB_TYPE").value == '')	
					{
						alert("Please enter Document SubType.");
						customform.document.getElementById("wdesk:DOCUMENT_SUB_TYPE").focus();
						return false;
					}
					if(customform.document.getElementById("wdesk:CUSTOMER_NAME").value == '')	
					{
						alert("Please enter Customer Name.");
						customform.document.getElementById("wdesk:CUSTOMER_NAME").focus();
						return false;
					}
					/*if(customform.document.getElementById("wdesk:CUSTOMER_TAX_NO").value == '')	
					{
						alert("Please enter Customer TaxNo.");
						customform.document.getElementById("wdesk:CUSTOMER_TAX_NO").focus();
						return false;
					}*/
					if(customform.document.getElementById("wdesk:CUSTOMER_BUYER_OR_SUPPLIER").value == '')	
					{
						alert("Please enter Customer Buyer Or Supplier.");
						customform.document.getElementById("wdesk:CUSTOMER_BUYER_OR_SUPPLIER").focus();
						return false;
					}
					/*if(customform.document.getElementById("wdesk:CUSTOMER_TRADE_NO").value == '')	
					{
						alert("Please enter Customer Trade LicenseNo.");
						customform.document.getElementById("wdesk:CUSTOMER_TRADE_NO").focus();
						return false;
					}*/
					if(customform.document.getElementById("wdesk:OVERRIDE").value == '')	
					{
						alert("Please enter Customer Trade Override.");
						customform.document.getElementById("wdesk:OVERRIDE").focus();
						return false;
					}
					if(customform.document.getElementById("selectDecision").value=='Approve')
					{	
						var table = customform.document.getElementById("UTCDetailsGrid");
						var ajaxResult='';
						var rowCount = table.rows.length;
						if(rowCount==1)//When no row added in grid
						{
							alert("Mandatory, to add 1 row in the grid, if user is selecting the decision as 'Approve' ");
							customform.document.getElementById("AddUTC").focus();
							return false;
						}
					}					
								

				}
									
									
			}
			
			else if(WSNAME=="TF_Checker")
			{
				if(customform.document.getElementById("selectDecision").value=='Reject to TF Maker' || customform.document.getElementById("selectDecision").value=='Reject to CSO'){
					customform.document.getElementById("wdesk:OPSMakerRejectFlag").value ='Y';
				}
				
				//Checker can only be able to take Maker selected Decision amended with Reject to TF Maker
				if( !(customform.document.getElementById("selectDecision").value == 'Send for Business Approval' || customform.document.getElementById("selectDecision").value == 'Send for CROPS Action' || customform.document.getElementById("selectDecision").value == 'Send to Business and CROPS') )
				{
					if(customform.document.getElementById("selectDecision").value != customform.document.getElementById("wdesk:TFMakerDecision").value)
					{
						if(customform.document.getElementById("selectDecision").value != 'Reject to TF Maker')
						{
								alert("Decision allowed to take either Maker selected Decision or Reject to TF Maker");
								customform.document.getElementById("selectDecision").focus();
								return false;				
						}
					}
				}
				
				if(customform.document.getElementById("selectDecision").value=='Approve')
				{
					//validation added on CSO WS only 12112018
					/* if(customform.document.getElementById("wdesk:sign_matched_checker").value=='')
					{
						alert("Please verify signatures while selecting 'Approve' as decision");
						customform.document.getElementById("viewSign").focus();
						return false;
					}
					else if(customform.document.getElementById("wdesk:sign_matched_maker").value!='' && customform.document.getElementById("wdesk:sign_matched_checker").value == 'No')
					{
						alert("Signatures should be matched before selecting 'Approve' as decision");
						customform.document.getElementById("viewSign").focus();
						return false;
					} */
					if(customform.document.getElementById("wdesk:ServiceRequestCode").value == 'TF007'){
						var ChecklistWiname= customform.document.getElementById("CHECKLIST_WSNAME").value;  		
						if(ChecklistWiname != WSNAME)
						{
							alert("Please select Checklist for Trade Finance Checker");
							customform.document.getElementById("Checklist_For").focus(true);
							return false;
						}
						if(ChecklistWiname == WSNAME)
						{
							var table = customform.document.getElementById("checklistGrid");
							var rowCount=(table.rows.length);
							var arrayIdentificationDocFieldsForSave=['option'];
							for (var i = 1; i < rowCount; i++)
							{
								for (var j = 0; j < arrayIdentificationDocFieldsForSave.length; j++) 
								{							
									if(customform.document.getElementById('Y'+i).checked == false && customform.document.getElementById('N'+i).checked == false && customform.document.getElementById('NA'+i).checked == false)
									{
										alert("Please select radio button of Checklist Details Grid");
										customform.document.getElementById('Y'+i).focus(true);
										return false;
									}															
								}
							}	
						}
					}
					//ProcessedDateAtChecker field at Checker on 14102018 -- setting current date and time
					if (customform.document.getElementById("wdesk:ProcessedDateAtChecker").value == '' || customform.document.getElementById("wdesk:ProcessedDateAtChecker").value == null)
					{
						var d = new Date();
						var today = formatDate(d,5);
						customform.document.getElementById("wdesk:ProcessedDateAtChecker").value = today;						
					} 
				}
				if(customform.document.getElementById("wdesk:ARMCode").value == '')
				{
					if((customform.document.getElementById("selectDecision").value == 'Send for Business Approval' )||(customform.document.getElementById("selectDecision").value == 'Send to Business and CROPS' ))
					{
						if(customform.document.getElementById("wdesk:Secondary_RM_Code").value == '')
						{
							alert("Please Enter Secondary RM Code");
							customform.document.getElementById("wdesk:Secondary_RM_Code").focus();
							return false;
						}
						if(customform.document.getElementById("wdesk:SM").value == '')
						{
							alert("Please Enter SM");
							customform.document.getElementById("wdesk:SM").focus();
							return false;
						}						
					}		
				}
				
				
			}
			else if(WSNAME=="CSO_Reject")
			{
				if(customform.document.getElementById("wdesk:ArchivalDecision").value == 'Reject to CSO' && customform.document.getElementById("wdesk:PreviouslyRejectedBy").value == 'TF_Archival' && customform.document.getElementById("selectDecision").value !='Rectification Provided')
				{
						alert("Decision allowed to take as 'Rectification Provided' as workitem was rejected by Archival");
						customform.document.getElementById("selectDecision").focus();
						return false;				
				}			
			}
			
			//Mandatory check for EventDetailsGrid on TF Doc Approver WS 04122018
			if(WSNAME=="TF_Document_Approver")
			{			
				var EventDetailsGridFlag = customform.document.getElementById("EventDetailsFlag").value;
				if(EventDetailsGridFlag == '')
				{
					alert("Please Perform Event Details Check");
					return false;					
				}
				if(customform.document.getElementById("wdesk:UTCDetailsFlag").value=='Y' && ((customform.document.getElementById("wdesk:ServiceRequestCode").value == 'TF001')||(customform.document.getElementById("wdesk:ServiceRequestCode").value == 'TF007')|| (customform.document.getElementById("wdesk:ServiceRequestCode").value == 'TF011')|| (customform.document.getElementById("wdesk:ServiceRequestCode").value == 'TF032')))
				{
					if(customform.document.getElementById("wdesk:BATCH_NO").value == '') 
					{
						alert("Please enter BatchNo.");
						customform.document.getElementById("wdesk:BATCH_NO").focus();
						return false;
					}
					if(customform.document.getElementById("wdesk:DOCUMENT_COUNT").value == '')	
					{
						alert("Please enter Document Count.");
						customform.document.getElementById("wdesk:DOCUMENT_COUNT").focus();
						return false;
					}
					if(customform.document.getElementById("wdesk:DOCUMENT_TYPE").value == '')	
					{
						alert("Please enter Document Type.");
						customform.document.getElementById("wdesk:DOCUMENT_TYPE").focus();
						return false;
					}
					if(customform.document.getElementById("wdesk:DOCUMENT_SUB_TYPE").value == '')	
					{
						alert("Please enter Document Sub Type.");
						customform.document.getElementById("wdesk:DOCUMENT_SUB_TYPE").focus();
						return false;
					}
					if(customform.document.getElementById("wdesk:CUSTOMER_NAME").value == '')	
					{
						alert("Please enter Customer Name.");
						customform.document.getElementById("wdesk:CUSTOMER_NAME").focus();
						return false;
					}
					/*if(customform.document.getElementById("wdesk:CUSTOMER_TAX_NO").value == '')	
					{
						alert("Please enter Customer TaxNo.");
						customform.document.getElementById("wdesk:CUSTOMER_TAX_NO").focus();
						return false;
					}*/
					if(customform.document.getElementById("wdesk:CUSTOMER_BUYER_OR_SUPPLIER").value == '')	
					{
						alert("Please enter Customer Buyer Or Supplier.");
						customform.document.getElementById("wdesk:CUSTOMER_BUYER_OR_SUPPLIER").focus();
						return false;
					}
					/*if(customform.document.getElementById("wdesk:CUSTOMER_TRADE_NO").value == '')	
					{
						alert("Please enter Customer Trade LicenseNo.");
						customform.document.getElementById("wdesk:CUSTOMER_TRADE_NO").focus();
						return false;
					}*/
					if(customform.document.getElementById("wdesk:OVERRIDE").value == '')	
					{
						alert("Please enter Customer Trade Override.");
						customform.document.getElementById("wdesk:OVERRIDE").focus();
						return false;
					}
					if(customform.document.getElementById("selectDecision").value=='Approve')
					{	
						var table = customform.document.getElementById("UTCDetailsGrid");
						var ajaxResult='';
						var rowCount = table.rows.length;
						if(rowCount==1)//When no row added in grid
						{
							alert("Mandatory, to add 1 row in the grid, if user is selecting the decision as 'Approve' ");
							customform.document.getElementById("AddUTC").focus();
							return false;
						}
					}					
								

				}
				
			}
			
			//Below code added for validation of holdtilldate and retentionexpdate fields 29112018*********
			var holdtilldate=customform.document.getElementById("HoldtillDate").value;
			/*if(WSNAME=="TF_Document_Approver" || WSNAME=="TF_Maker" || WSNAME=="TF_Checker")
			{	
				if(holdtilldate=="" && (customform.document.getElementById("selectDecision").value == "Hold-Internal" || customform.document.getElementById("selectDecision").value == "Hold-External"))
				{
					alert("Please enter holdtilldate.");
					customform.document.getElementById("HoldtillDate").focus();
					return false;			
				}
			}*/
			//**********************************************************************************************
			if(WSNAME=="Del_Retention_Expire")
			{			
					var retentionexpdate=customform.document.getElementById("RetentionExpDate").value;
					/*if(holdtilldate=='' && customform.document.getElementById("selectDecision").value=='Retention Extended')
					{
						alert("Please enter holdtilldate.");
						customform.document.getElementById("HoldtillDate").focus();
						return false;
					}*/
					if(retentionexpdate=='' && customform.document.getElementById("selectDecision").value=='Retention Extended')
					{
						alert("Please enter RetentionExpiryDate.");
						customform.document.getElementById("RetentionExpDate").focus();
						return false;
					}
			}
			
			//Mandatory Validation for Reject Reason (added for Reject to Initiator case also by sowmya)
			if(customform.document.getElementById("selectDecision").value=='Reject' || customform.document.getElementById("selectDecision").value=='Reject to CSO' || customform.document.getElementById("selectDecision").value=='Hold-Internal' || customform.document.getElementById("selectDecision").value=='Hold-External' || customform.document.getElementById("selectDecision").value=='Reject to TF Approve' || customform.document.getElementById("selectDecision").value=='Reject to Initiator')
            {
				if(customform.document.getElementById('rejReasonCodes').value=='' || customform.document.getElementById('rejReasonCodes').value=='NO_CHANGE')
				{
				  alert("Please provide reject reason.");
				  customform.document.getElementById('RejectReason').focus(true);
				  return false;
				}
			}
			
			if(customform.document.getElementById('rejReasonCodes').value!='' && customform.document.getElementById('rejReasonCodes').value!='NO_CHANGE'){
				if(customform.document.getElementById("selectDecision").value!='Reject' && customform.document.getElementById("selectDecision").value!='Reject to CSO' && customform.document.getElementById("selectDecision").value!='Hold-Internal' && customform.document.getElementById("selectDecision").value!='Hold-External' && customform.document.getElementById("selectDecision").value!='Reject to TF Approve' && customform.document.getElementById("selectDecision").value!='Reject to Initiator' && customform.document.getElementById("selectDecision").value!='Send for Business Approval' && customform.document.getElementById("selectDecision").value!='Send for CROPS Action' && customform.document.getElementById("selectDecision").value!='Send to Business and CROPS')
				{
					alert("Reject Reasons are selected, Please select appropriate decision.");
					return false;
				}
			}
			if(WSNAME=='RM'||WSNAME=='UM'||WSNAME=='SM'||WSNAME=='MD'||WSNAME=='HOD')
			{		
					if(customform.document.getElementById("DeferralWaiverHeldCombo").value=='')
					{
						alert("Please select  Deferral/Waiver Held.");
						customform.document.getElementById("DeferralWaiverHeldCombo").focus();
						return false;
					}
					if(customform.document.getElementById("wdesk:ApprovingAuthority").value==''||customform.document.getElementById("wdesk:ApprovingAuthority").value==null)
					{
						if(customform.document.getElementById("DeferralWaiverHeldCombo").value=='Y')
						{
						alert("Approving Authority(Name) for Deferral is mandatory to fill");
						customform.document.getElementById("wdesk:ApprovingAuthority").focus();
						return false;
						}
					}
					if(customform.document.getElementById("wdesk:DocumentTypedeferred").value==''||customform.document.getElementById("wdesk:DocumentTypedeferred").value==null)
					{
						if(customform.document.getElementById("DeferralWaiverHeldCombo").value=='Y')
						{
						alert("Document Type Deferred is mandatory to fill");
						customform.document.getElementById("wdesk:DocumentTypedeferred").focus();
						return false;
						}
					}
					if(customform.document.getElementById("wdesk:DeferralExpiryDate").value==''||customform.document.getElementById("wdesk:DeferralExpiryDate").value==null)
					{
						if(customform.document.getElementById("DeferralWaiverHeldCombo").value=='Y')
						{
						alert("Deferral Expiry Date is mandatory to fill");
						customform.document.getElementById("wdesk:DeferralExpiryDate").focus();
						return false;
						}
					}
			}
			
			//Mandatory Validation added to view Decision History on all WS except CSO
			if(WSNAME != "CSO")
			{
				if(customform.document.getElementById("DecisionHistoryFlag").value != "true")
				{
					alert("Please view Decision History.");
					customform.document.getElementById("history").focus();
					return false;
				}
			}
			//Mandatory Validation for queue and user field
			if(customform.document.getElementById("selectDecision").value=='Send within Credit' || customform.document.getElementById("selectDecision").value=='Send to Business' || customform.document.getElementById("selectDecision").value=='Send within Business')
            {
				if(customform.document.getElementById('selectQueue').value=='' || customform.document.getElementById('selectQueue').value=='--Select--')
				{
				  alert("Please select the Queue");
						customform.document.getElementById("selectQueue").focus();
						return false;
				}
			}
			if(customform.document.getElementById("selectDecision").value=='Send within Credit' && customform.document.getElementById("selectQueue").value=='CreditApp_OR_Analyst')
            {
				if((customform.document.getElementById("selectUser").value)=='' || (customform.document.getElementById("selectUser").value)=='--Select--')  
				{
						alert("Please select the User");
						customform.document.getElementById("selectUser").focus();
						return false;
				}
			}
		
			
	}	
	

	var url="";
	var param="";
	
	// not calling save data while closing the workitem at cso
	if(IsDoneClicked == false && WSNAME == 'CSO')
	{
		return true;
	}
	//*********************************************
	
	if(true)
	{
		
		var abc=Math.random
		
		url ="/TF/CustomForms/TF_Specific/TFDataSave.jsp";
		//alert("Hi");
		//alert("WIData"+WIDATA);
		var Category=customform.document.getElementById("Product_Category").value;
		var ApplicationFormCode=customform.document.getElementById("wdesk:ServiceRequestCode").value;
		//alert("ApplicationFormCode--"+ApplicationFormCode);
		remarks = remarks.split("'").join("");
		remarks = remarks.split("~").join("");
		remarks = remarks.split("<").join("");
		var ProductType=customform.document.getElementById("Product_Type").value;
		param="WINAME="+WINAME+"&tr_table="+tr_table+"&WSNAME="+WSNAME+"&WS_LogicalName="+WS_LogicalName+"&CategoryID="+CategoryID+"&SubCategoryID="+SubCategoryID+"&IsDoneClicked="+IsDoneClicked+"&IsError="+IsError+"&IsSaved="+IsSaved+"&WIDATA="+WIDATA+"&PANno="+PANno+"&abc="+abc+"&TEMPWINAME="+TEMPWINAME+"&decisionsaved="+decisionsaved+"&exceptionstring="+exceptionstring+"&Category="+Category+"&ProductType="+ProductType+"&remarks="+encodeURIComponent(remarks)+"&decisionNew="+decisionNew+"&RejectReason="+RejectReason+"&Application_FormCode="+ApplicationFormCode;
		//  alert('param'+param);
	  
		   
			

		
		url=replaceUrlChars(url);
		//window.open(url);
		param=replaceUrlChars(param);
		//alert(param);
		xhr.open("POST",url,false); 
		xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
		xhr.send(param);
		//alert('xhr.status'+xhr.status);
		//alert('xhr.readyState'+xhr.readyState);
		if (xhr.status == 200 && xhr.readyState == 4)
		{
			//ajaxResult=Trim(xhr.responseText);
			ajaxResult=myTrim(xhr.responseText);
			arrAjaxResult = ajaxResult.split("~");
		//	alert("arrAjaxResult"+arrAjaxResult);
			ajaxResultFinal= arrAjaxResult[0];

			if(ajaxResultFinal == '15')
			{
				alert("There is some error at database end.");
				return false;
			}
			else if(ajaxResultFinal == '11')
			{
				alert("User session expired. Please re-login.");
				return false;
			}else if(ajaxResultFinal == 'SUBCAT4DATABLANK') // handled specifically for sub category 4
			{
				alert("Please add LCD Reference Number in grid");
				return false;
			}
			else if(ajaxResultFinal != '0')
			{
				//alert(ajaxResultFinal+"hello");
				alert("There is some problem at server end with error code as "+ajaxResultFinal+". Please contact administrator!");
				return false;
			}		
		}
		else
		{
			alert("Problem in saving Transaction Table data.");
			return false;
		}
	}	   
	return true;
}


function getCutofftime(WINAME) {
			var wi_name = WINAME;

			var xhr;
			var ajaxResult;
			ajaxResult = "";
			var reqType = "GetCutOfftime";

			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");

			var url = '/TF/CustomForms/TF_Specific/HandleAjaxProcedures.jsp';
			var param = "wi_name="+wi_name+"&reqType="+reqType;
			//param = encodeURIComponent(param);
			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);

			if (xhr.status == 200) {
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');

				if (ajaxResult.indexOf("Exception") == 0) {
					alert("Some problem in fetching cutofftime.");
					return false;
				}
				//ajaxResult=ajaxResult.replaceall('-','/');
				customform.document.getElementById("wdesk:CUTOFFDATETIME").value = ajaxResult;
			} else {
				alert("Error while getting cutofftime");
				return "";
			}
			return ajaxResult;
		}

//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           Function validates on click of done
//***********************************************************************************//

function computeWIDATA(iframe, SubCategoryID, WSNAME, IsDoneClicked, CategoryID, fobj) {
    var customform = '';
    customform = fobj;

    var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
    var WIDATA = "";
    var myname;
    var tr_table;
    var eleValue;
    var eleName;
    var eleName2;
    var check;
    var inputs = iframeDocument.getElementsByTagName("input");
    var textareas = iframeDocument.getElementsByTagName("textarea");
    var selects = iframeDocument.getElementsByTagName("select");

    var WSNAME = iframeDocument.getElementById("WS_NAME").value;
    var intCallStatus = "";

    if (WSNAME == 'CSO')
        intCallStatus = customform.document.getElementById("wdesk:IntegrationStatus").value;
    else
        intCallStatus = "false";

    var store = "";
    try {
        for (x = 0; x < inputs.length; x++) {

            if (!(inputs[x].type == 'radio')) {
                eleName2 = inputs[x].getAttribute("name");

                if (eleName2 == null)
                    continue;
                eleName2 += "#";
                var temp = eleName2.split('#');
                var IsRepeatable = temp[4];
                myname = inputs[x].getAttribute("id");
				//alert("myname ID"+myname);
            } else {
                eleName2 = inputs[x].getAttribute("id");

                if (eleName2 == null)
                    continue;
                eleName2 += "#";
                var temp = eleName2.split('#');
                var IsRepeatable = temp[4];
                myname = inputs[x].getAttribute("name");
				//alert("myname NAME"+myname);
            }



            if (myname == null)
                continue;
            if (myname.indexOf(SubCategoryID + "_") != 0) {
                if ((inputs[x].type == 'hidden')) {

                    if (myname.indexOf(SubCategoryID + "_gridbundle_WIDATA") > -1) {
                        var temp = CustomEncodeURI(iframeDocument.getElementById(myname).value);

                        if (SubCategoryID == '3') {
                            var cardNoOrg = temp.substring(temp.indexOf("card_number#"), temp.length);
                            cardNoOrg = cardNoOrg.substring(0, cardNoOrg.indexOf("~"));
                            if (intCallStatus == "false") {
                                cardNoOrg = "~" + cardNoOrg;

                                var maskedCardNoData = temp.substring(temp.indexOf("masked_card_no#"), temp.length);
                                maskedCardNoData = "~" + maskedCardNoData.substring(0, maskedCardNoData.indexOf("~"));
                                temp = temp.replace(cardNoOrg, "");
                                temp = temp.replace(maskedCardNoData, "");
                            } else {
                                var cardNoOrgData = cardNoOrg;
                                var cardNoColumnName = cardNoOrgData.substring(0, cardNoOrgData.indexOf("#") + 1);
                                cardNoOrgData = cardNoOrgData.substring(cardNoOrgData.indexOf("#") + 1, cardNoOrgData.length);


                                var arrCardNoOrgData = cardNoOrgData.split("@");

                                var CardNoOrgData = "";
                                var finalMaskCardNoData = "";
                                for (var i = 0; i < arrCardNoOrgData.length; i++) {

                                    if (arrCardNoOrgData.length - i == 1) {
                                        if (WSNAME == 'CSO')
                                            finalMaskCardNoData = finalMaskCardNoData + maskCardNo(arrCardNoOrgData[i]);

                                        arrCardNoOrgData[i] = Encrypt(arrCardNoOrgData[i]);

                                    } else {
                                        if (WSNAME == 'CSO')
                                            finalMaskCardNoData = finalMaskCardNoData + maskCardNo(arrCardNoOrgData[i]) + "@";

                                        arrCardNoOrgData[i] = Encrypt(arrCardNoOrgData[i]) + "@";
                                    }

                                    CardNoOrgData = CardNoOrgData + arrCardNoOrgData[i];
                                }

                                CardNoOrgData = cardNoColumnName + CardNoOrgData;
                                temp = temp.replace(cardNoOrg, CardNoOrgData);

                                if (WSNAME == 'CSO') {
                                    var maskedCardNoData = temp.substring(temp.indexOf("masked_card_no#"), temp.length);
                                    maskedCardNoData = maskedCardNoData.substring(0, maskedCardNoData.indexOf("~"));
                                    var tst = maskedCardNoData;
                                    var maskCardNoColumnName = tst.substring(0, tst.indexOf("#") + 1);
                                    var arrStr2;
                                    finalMaskCardNoData = maskCardNoColumnName + finalMaskCardNoData;
                                    temp = temp.replace(maskedCardNoData, finalMaskCardNoData);
                                }
                            }
                        }

                        WIDATA += temp + "~";

                    }
                    continue;
                }
            }

            if (IsRepeatable != 'Y') {
                if (myname.indexOf(SubCategoryID + "_") == 0) {
                    if ((inputs[x].type == 'radio')) {
                        eleName = inputs[x].getAttribute("name");
                        if (store != eleName) {
                            store = eleName;
                            var ele = iframeDocument.getElementsByName(eleName);
							alert('ele : '+ele);
							alert('eleName : '+eleName);
                            for (var i = 0; i < ele.length; i++) {
                                eleName2 = ele[i].id;
                                eleName2 += "#radio";
                                if (ele[i].checked) {
                                    eleValue = encodeURIComponent(ele[i].value);
									eleName = /_(.+)/.exec(eleName)[1];
								//	alert('eleName : '+eleName);
                                    WIDATA += eleName + "#" + eleValue + "~";
                                    counthash++;
                                }

                            }
                        }

                    } else if ((inputs[x].type == 'checkbox')) {

                        eleName2 = inputs[x].getAttribute("name");
                        eleName2 += "#";
                        var temp = eleName2.split('#');
                        var is_workstep_req = temp[3];
                        var IsRepeatable = temp[4];
						//alert('myname : '+myname);
                        if (iframeDocument.getElementById(myname).value == '') {
							//Added by Badri to delete Product_Category number from the ID
							myname = /_(.+)/.exec(myname)[1];
                            WIDATA += myname + "#NULL" + "~";

                        } else {
                            if (iframeDocument.getElementById(myname).checked) {
								//Added by Badri to delete Product_Category number from the ID
								myname = /_(.+)/.exec(myname)[1];
                                if (is_workstep_req == 'Y')
                                    WIDATA += myname + "#" + WSNAME + "$" + "true" + "~";
                                else
                                    WIDATA += myname + "#" + "true" + "~";
                            } else {
								myname = /_(.+)/.exec(myname)[1];
                                if (is_workstep_req == 'Y')
                                    WIDATA += myname + "#" + WSNAME + "$" + "false" + "~";
                                else
                                    WIDATA += myname+ "#" + "false" + "~";
                            }
                        }

                    } else if (!(inputs[x].type == 'radio')) {
                        eleName2 = inputs[x].getAttribute("name");
                        eleName2 += "#";
                        var temp = eleName2.split('#');
                        var is_workstep_req = temp[3];
                        var IsRepeatable = temp[4];
						
                        if (iframeDocument.getElementById(myname).value == '') {
							//alert('myname : '+myname);
							myname = /_(.+)/.exec(myname)[1];
							//alert('myname : '+myname);
                            WIDATA += myname + "#NULL" + "~";
							//alert('WIDATA'+WIDATA);
                            counthash++;
                        } else {
                            if (is_workstep_req == 'Y') {
                                {
                                    WIDATA += myname + "#" + WSNAME + "$" + encodeURIComponent(iframeDocument.getElementById(myname).value) + "~";
                                    counthash++;
                                }
                            } else {
								myname_final = /_(.+)/.exec(myname)[1];
                                WIDATA += myname_final + "#" + encodeURIComponent(iframeDocument.getElementById(myname).value) + "~";
                                counthash++;
                            }
                        }
                    }
                }
            }
            //Added by Aishwarya 14thApril2014
            else if (myname.indexOf("tr_") == 0) {
                tr_table = iframeDocument.getElementById(myname).value;
            }
        }
    } catch (err) {
        exception = true;
        exceptionstring = exceptionstring + "textboxexception:";
        return;
    }
    try {
        for (x = 0; x < textareas.length; x++) {
            eleName2 = textareas[x].getAttribute("name");
            if (eleName2 == null)
                continue;
            eleName2 += "#";
            var temp = eleName2.split('#');
            var IsRepeatable = temp[4];
            myname = textareas[x].getAttribute("id");
            if (myname == null)
                continue;
            if (IsRepeatable != 'Y') {
                if (myname.indexOf(SubCategoryID + "_") == 0) {
                    eleName2 = textareas[x].getAttribute("name");
                    var temp = eleName2.split('#');
                    var is_workstep_req = temp[3];
                    var IsRepeatable = temp[4];
                    if (iframeDocument.getElementById(myname).value == '')
					{
						myname = /_(.+)/.exec(myname)[1];
					//		alert('myname : '+myname);
					WIDATA += myname + "#NULL" + "~"; }
                    else {
                        if (is_workstep_req == 'Y') {
							myname_final = /_(.+)/.exec(myname)[1];
                            WIDATA += myname_final + "#" + WSNAME + "$" + encodeURIComponent(iframeDocument.getElementById(myname).value) + "~";
                        } else {
							myname_final = /_(.+)/.exec(myname)[1];
                            WIDATA += myname_final + "#" + encodeURIComponent(iframeDocument.getElementById(myname).value) + "~";
                        }
                    }
                }
            }
        }
    } catch (err) {
        exception = true;
        exceptionstring += "textareaexception:";
        return;
    }
    try {
        for (x = 0; x < selects.length; x++) {
            eleName2 = selects[x].getAttribute("name");
            if (eleName2 == null)
                continue;
            eleName2 += "#select";
            myname = selects[x].getAttribute("id");
            if (myname == null)
                continue;
            var temp = eleName2.split('#');
            var is_workstep_req = temp[3];
            var IsRepeatable = temp[4];
            var e = iframeDocument.getElementById(myname);
            if (IsRepeatable != 'Y') {

                if (e.selectedIndex != -1) {
					var Value='';
					//Added by Amitabh for multiselect dropdwon
					if(myname.indexOf('Banknames')>0){
					var e=iframeDocument.getElementById(myname);
					var selectedValues="";
						for (var i = 0; i < e.options.length; i++){
						 if(e.options[i].selected ==true){
								if(selectedValues=="")
								selectedValues=e.options[i].value;
								else                    
								selectedValues=selectedValues+"@"+e.options[i].value;
							}            
						}
						Value=selectedValues;
					}
					//*********************************************
					else{
						Value = e.options[e.selectedIndex].value;
					}
                    if (myname.indexOf(SubCategoryID + "_") == 0) {
                        if (Value == '--Select--') {
							myname = /_(.+)/.exec(myname)[1];
							//alert('myname : '+myname);
                            WIDATA += myname + "#NULL" + "~";

                        } else {
                            if (is_workstep_req == 'Y') {
								myname = /_(.+)/.exec(myname)[1];
                                WIDATA += myname + "#" + WSNAME + "$" + encodeURIComponent(Value) + "~";
                            } else {
								myname = /_(.+)/.exec(myname)[1];
                                WIDATA += myname + "#" + encodeURIComponent(Value) + "~";
                            }

                        }
                    }
                }
            }
        }
    } catch (err) {
        exception = true;
        exceptionstring += "selectexception:";
        return;
    }
    if (IsDoneClicked && CategoryID == '1' && SubCategoryID == '1' && (WSNAME == 'Q1' || WSNAME == 'Q2' || WSNAME == 'Q3') && (WIDATA.indexOf("Decision") == -1)) {
        try {
            var declinereasonfromform = "Decline_Reason#NULL";

            var decisionfromform = "";
            if (iframeDocument.getElementById("1_Decision") != null && iframeDocument.getElementById("1_Decision").value != null && iframeDocument.getElementById("1_Decision").value != '') {
                decisionfromform = encodeURIComponent(iframeDocument.getElementById("1_Decision").value);
                if (decisionfromform == 'Reject' && (WIDATA.indexOf("Decline_Reason") == -1)) {
                    if (iframeDocument.getElementById("1_Decline_Reason") != null && iframeDocument.getElementById("1_Decline_Reason").value != null && iframeDocument.getElementById("1_Decline_Reason").value != '') {
                        declinereasonfromform = "Decline_Reason#" + WSNAME + "$" + encodeURIComponent(iframeDocument.getElementById("1_Decline_Reason").value) + "~";
                    } else {
                        exception = true;
                        exceptionstring += "decisionsaveexception1:";
                        return;
                    }
                }
                if (WIDATA.charAt(WIDATA.length - 1) == '~')
                    WIDATA = WIDATA + 'Decision#' + WSNAME + "$" + decisionfromform + "~" + declinereasonfromform;
                else
                    WIDATA = WIDATA + '~Decision#' + WSNAME + "$" + decisionfromform + "~" + declinereasonfromform;
                counthash = counthash + 2;
                decisionsaved = 'N';
            } else {
                exception = true;
                exceptionstring += "decisionsaveexception2:";
                return;
            }

        } catch (err) {
            alert("Exception in saving the decision on form. Please contact administrator.");
            exception = true;
            exceptionstring += "decisionsaveexception1:";
            return;
        }

    }
    //code added for encryption and masking of card numbers in BT/CCC
    /*if (CategoryID == 1 && SubCategoryID == 4) {
        if (intCallStatus == "false") {
            var splitWIDATA = WIDATA.split("~");
            for (var i = 0; i < splitWIDATA.length; i++) {
                if (splitWIDATA[i].indexOf('card_number#') > -1)
                    WIDATA = WIDATA.replace(splitWIDATA[i] + '~', "");
                else if (splitWIDATA[i].indexOf('card_no#') > -1)
                    WIDATA = WIDATA.replace(splitWIDATA[i] + '~', "");
                else if (splitWIDATA[i].indexOf('card_no_1#') > -1)
                    WIDATA = WIDATA.replace(splitWIDATA[i] + '~', "");
                else if (splitWIDATA[i].indexOf('rakbank_eligible_card_no#') > -1)
                    WIDATA = WIDATA.replace(splitWIDATA[i] + '~', "");
                else if (splitWIDATA[i].indexOf('card_no_masked#') > -1)
                    WIDATA = WIDATA.replace(splitWIDATA[i] + '~', "");
                else if (splitWIDATA[i].indexOf('card_number_masked#') > -1)
                    WIDATA = WIDATA.replace(splitWIDATA[i] + '~', "");
                if (splitWIDATA[i].indexOf('card_no_1_masked#') > -1)
                    WIDATA = WIDATA.replace(splitWIDATA[i] + '~', "");
                if (splitWIDATA[i].indexOf('rak_elig_card_masked#') > -1)
                    WIDATA = WIDATA.replace(splitWIDATA[i] + '~', "");
            }
        } else {
            var encryptedcardmap = iframeDocument.getElementById('encryptedmap').value;
            var obj = JSON.parse(encryptedcardmap);
            //alert('CCC->'+WIDATA+"hello");
            var wiDataElements = WIDATA.split("~");
            var encryptedStringToSave = "";
            var maskedStringToSave = "";
            var colNameValue = "";
            var cardNumbers = "";
            var cardNumbersForMasking = "";
            var org_card_number = ""
            var org_card_no = ""
            var org_card_no_1 = ""
            var org_rak_elig_cardno = ""
                //block to replace actual card numbers with masked values
            for (var counter = 0; counter < wiDataElements.length; counter++) {
                colNameValue = wiDataElements[counter].split("#");
                if (colNameValue[0] == 'card_number' || colNameValue[0] == 'card_no' || colNameValue[0] == 'card_no_1' || colNameValue[0] == 'rakbank_eligible_card_no') {
                    encryptedStringToSave = "";
                    if (colNameValue[0] == 'card_number')
                        org_card_number = colNameValue[1];
                    else if (colNameValue[0] == 'card_no')
                        org_card_no = colNameValue[1];
                    else if (colNameValue[0] == 'card_no_1')
                        org_card_no_1 = colNameValue[1];
                    else if (colNameValue[0] == 'rakbank_eligible_card_no')
                        org_rak_elig_cardno = colNameValue[1];

                    cardNumbers = colNameValue[1].split("@");
                    for (var c = 0; c < cardNumbers.length; c++) {
                        encryptedStringToSave += obj[cardNumbers[c]] + '@';
                    }
                    encryptedStringToSave = encryptedStringToSave.substring(0, encryptedStringToSave.lastIndexOf('@'));
                    colNameValue[1] = encryptedStringToSave;
                }
                colNameValue = colNameValue.join("#");
                wiDataElements[counter] = colNameValue;
            }
            //block to add masking values to hidden cols
            for (var counter = 0; counter < wiDataElements.length; counter++) {
                colNameValue = wiDataElements[counter].split("#");
                if (colNameValue[0] == 'card_no_masked' || colNameValue[0] == 'card_number_masked' || colNameValue[0] == 'card_no_1_masked' || colNameValue[0] == 'rak_elig_card_masked') {
                    maskedStringToSave = "";

                    if (colNameValue[0] == 'card_no_masked')
                        cardNumbersForMasking = org_card_no.split("@");
                    else if (colNameValue[0] == 'card_number_masked')
                        cardNumbersForMasking = org_card_number.split("@");
                    else if (colNameValue[0] == 'card_no_1_masked')
                        cardNumbersForMasking = org_card_no_1.split("@");
                    else if (colNameValue[0] == 'rak_elig_card_masked')
                        cardNumbersForMasking = org_rak_elig_cardno.split("@");

                    for (var c = 0; c < cardNumbersForMasking.length; c++) {
                        maskedStringToSave += maskCardNo(cardNumbersForMasking[c]) + '@';
                    }
                    maskedStringToSave = maskedStringToSave.substring(0, maskedStringToSave.lastIndexOf('@'));
                    colNameValue[1] = maskedStringToSave;
                }
                colNameValue = colNameValue.join("#");
                wiDataElements[counter] = colNameValue;
            }
            WIDATA = wiDataElements.join("~");
        }
    } else if (CategoryID == 1 && SubCategoryID == 2) {
        if (intCallStatus == "false") {
            var splitWIDATA = WIDATA.split("~");
            for (var i = 0; i < splitWIDATA.length; i++) {
                if (splitWIDATA[i].indexOf('rak_card_no#') > -1)
                    WIDATA = WIDATA.replace(splitWIDATA[i] + '~', "");
                else if (splitWIDATA[i].indexOf('card_no#') > -1)
                    WIDATA = WIDATA.replace(splitWIDATA[i] + '~', "");
                else if (splitWIDATA[i].indexOf('card_number#') > -1)
                    WIDATA = WIDATA.replace(splitWIDATA[i] + '~', "");
                else if (splitWIDATA[i].indexOf('rakbank_eligible_card_no#') > -1)
                    WIDATA = WIDATA.replace(splitWIDATA[i] + '~', "");
                else if (splitWIDATA[i].indexOf('rak_card_no_masked#') > -1)
                    WIDATA = WIDATA.replace(splitWIDATA[i] + '~', "");
                else if (splitWIDATA[i].indexOf('card_no_masked#') > -1)
                    WIDATA = WIDATA.replace(splitWIDATA[i] + '~', "");
                if (splitWIDATA[i].indexOf('card_number_masked#') > -1)
                    WIDATA = WIDATA.replace(splitWIDATA[i] + '~', "");
                if (splitWIDATA[i].indexOf('rak_elig_card_masked#') > -1)
                    WIDATA = WIDATA.replace(splitWIDATA[i] + '~', "");
            }
        } else {
            var encryptedcardmap = iframeDocument.getElementById('encryptedmap').value;
            var obj = JSON.parse(encryptedcardmap);
            //alert('BT-->'+WIDATA+"hello");
            var wiDataElements = WIDATA.split("~");
            var encryptedStringToSave = "";
            var maskedStringToSave = "";
            var colNameValue = "";
            var cardNumbers = "";
            var cardNumbersForMasking = "";
            var org_card_number = ""
            var org_card_no = ""
            var org_card_no_1 = ""
            var org_rak_elig_cardno = ""
                //block to replace actual card numbers with masked values
            for (var counter = 0; counter < wiDataElements.length; counter++) {
                colNameValue = wiDataElements[counter].split("#");
                if (colNameValue[0] == 'rak_card_no' || colNameValue[0] == 'card_no' || colNameValue[0] == 'card_number' || colNameValue[0] == 'rakbank_eligible_card_no') {
                    encryptedStringToSave = "";
                    if (colNameValue[0] == 'rak_card_no')
                        org_card_number = colNameValue[1];
                    else if (colNameValue[0] == 'card_no')
                        org_card_no = colNameValue[1];
                    else if (colNameValue[0] == 'card_number')
                        org_card_no_1 = colNameValue[1];
                    else if (colNameValue[0] == 'rakbank_eligible_card_no')
                        org_rak_elig_cardno = colNameValue[1];

                    cardNumbers = colNameValue[1].split("@");
                    for (var c = 0; c < cardNumbers.length; c++) {
                        encryptedStringToSave += obj[cardNumbers[c]] + '@';
                    }
                    encryptedStringToSave = encryptedStringToSave.substring(0, encryptedStringToSave.lastIndexOf('@'));
                    colNameValue[1] = encryptedStringToSave;
                }
                colNameValue = colNameValue.join("#");
                wiDataElements[counter] = colNameValue;
            }
            //block to add masking values to hidden cols
            for (var counter = 0; counter < wiDataElements.length; counter++) {
                colNameValue = wiDataElements[counter].split("#");
                if (colNameValue[0] == 'rak_card_no_masked' || colNameValue[0] == 'card_no_masked' || colNameValue[0] == 'card_number_masked' || colNameValue[0] == 'rak_elig_card_masked') {
                    maskedStringToSave = "";

                    /*if(colNameValue[0]=='rak_card_no_masked')
                    	cardNumbersForMasking=org_card_no.split("@");
                    else if(colNameValue[0]=='card_no_masked')
                    	cardNumbersForMasking=org_card_number.split("@");*/

                    /*if (colNameValue[0] == 'rak_card_no_masked')
                        cardNumbersForMasking = org_card_number.split("@");
                    else if (colNameValue[0] == 'card_no_masked')
                        cardNumbersForMasking = org_card_no.split("@");
                    else if (colNameValue[0] == 'card_number_masked')
                        cardNumbersForMasking = org_card_no_1.split("@");
                    else if (colNameValue[0] == 'rak_elig_card_masked')
                        cardNumbersForMasking = org_rak_elig_cardno.split("@");

                    //alert("columnvalue-->"+colNameValue[0]);
                    //alert('masked string-->'+maskedStringToSave);
                    for (var c = 0; c < cardNumbersForMasking.length; c++) {
                        maskedStringToSave += maskCardNo(cardNumbersForMasking[c]) + '@';
                    }
                    maskedStringToSave = maskedStringToSave.substring(0, maskedStringToSave.lastIndexOf('@'));
                    colNameValue[1] = maskedStringToSave;
                }
                colNameValue = colNameValue.join("#");
                wiDataElements[counter] = colNameValue;
            }
            WIDATA = wiDataElements.join("~");
            //alert("WIDATA :"+WIDATA);
        }
    }*/
    //alert("WIDATA :"+WIDATA);
    //return false;
    return WIDATA;
}
function getNameData()
{

	var customform = '';
	var formWindow = getWindowHandler(windowList, "formGrid");
	customform = formWindow.frames['customform'];
	var iframe = customform.document.getElementById("frmData");
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	var SubCategoryID = iframeDocument.getElementById("SubCategoryID").value;
    var CategoryID = iframeDocument.getElementById("CategoryID").value;
	var NameData = "";
    var myname;
    var WS_LogicalName;
    var eleValue;
    var eleName;
    var eleName2;
    var eleName3;
    var check;
    var inputs = iframeDocument.getElementsByTagName("input");
    var textareas = iframeDocument.getElementsByTagName("textarea");
    var selects = iframeDocument.getElementsByTagName("select");
    var store = "";
    var arrGridBundle = "";
    var singleGridBundle = "";
	
	try 
	{
        for (x = 0; x < inputs.length; x++) {
            myname = inputs[x].getAttribute("id");
            if (myname == null)
                continue;
            if (!(myname.indexOf("_gridbundle_clubbed") == -1)) {
                singleGridBundle = iframeDocument.getElementById(myname).value;
                if (arrGridBundle == "")
                    arrGridBundle = singleGridBundle;
                else
                    arrGridBundle += "$$$$" + singleGridBundle;
            }

            if (myname.indexOf(SubCategoryID + "_") == 0) {
                if ((inputs[x].type == 'radio')) {
                    eleName = inputs[x].getAttribute("name");
                    //alert("eleName:"+eleName);
                    if (store != eleName) {
                        store = eleName;
                        var ele = iframeDocument.getElementsByName(eleName);
                        for (var i = 0; i < ele.length; i++) {

                            eleName2 = ele[i].id;
                            //alert("eleName2:"+eleName2);

                            eleName2 += "#radio";
                            //alert("eleName2:::"+eleName2);
                            NameData += eleName + "#" + eleName2 + "~";
                            //alert("NameData:"+NameData);
                        }
                    }
                } else if (inputs[x].type == 'checkbox') {
                    eleName3 = inputs[x].getAttribute("name");
                    eleName3 += "#checkbox";
                    NameData += myname + "#" + eleName3 + "~";
                } else if (!(inputs[x].type == 'radio')) {
                    eleName2 = inputs[x].getAttribute("name");
                    eleName2 += "#";
                    NameData += myname + "#" + eleName2 + "~";
                }

            }
            
            else if (myname.indexOf("tr_") == 0) {
                tr_table = iframeDocument.getElementById(myname).value;
            } else if (myname.indexOf("WS_LogicalName") == 0) {
                WS_LogicalName = iframeDocument.getElementById(myname).value;
            }

        }
    } 
	catch (err) 
	{
        return "exception";
    }
	
	try 
	{
        for (x = 0; x < selects.length; x++) {
            eleName2 = selects[x].getAttribute("name");
            if (eleName2 == null)
                continue;
            eleName2 += "#select";
            myname = selects[x].getAttribute("id");
            if (myname == null)
                continue;
            var e = iframeDocument.getElementById(myname);
            if (e.selectedIndex != -1) {
                var Value = e.options[e.selectedIndex].value;
                if (myname.indexOf(SubCategoryID + "_") == 0) {
                    NameData += myname + "#" + eleName2 + "~";
                }
            }

        }
    } 
	catch (err) 
	{
        return "exception";
    }
	
	try 
	{
        for (x = 0; x < textareas.length; x++) 
		{
            myname = textareas[x].getAttribute("id");
            if (myname == null)
                continue;
            if (myname.indexOf(SubCategoryID + "_") == 0) {
                eleName2 = textareas[x].getAttribute("name");
                eleName2 += "#";
                NameData += myname + "#" + eleName2 + "~";
            }

        }
    } 
	catch (err) 
	{
        return "exception";
    }
	return NameData;
}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           Function is used to insert duplicate workitem data in table on click of done
//***********************************************************************************//

function callInsertDuplicateWorkitems(EventDetailsCheckGridData) 
{
	//alert("values--"+values);
    var wi_name =customform.document.getElementById("wdesk:WI_NAME").value;
    var CIF_ID =customform.document.getElementById("wdesk:CIF_ID").value;
	var insertStatusFlag = true;
	if(EventDetailsCheckGridData.indexOf('|')!=-1)
	{
		var EventDetailsGrid=EventDetailsCheckGridData.split('|');
		var gridRow = "";
		
		for(var i=0;i<EventDetailsGrid.length;i++)
		{
			var Row=EventDetailsGrid[i];
			var eachrow=Row.split('~');
			gridRow='';
				
			for(var j=0;j<eachrow.length;j++)
			{
				if (gridRow != "") 
				{
					gridRow = gridRow + "," + "'" + eachrow[j] + "'";
				} 
				else 
				{
					gridRow = "'" + eachrow[j] + "'";
				}
			}
			gridRow += ",'" + wi_name + "','" + CIF_ID + "'";	
			
			var insertStatus = InsertIntoDuplicationWorkitemTable(gridRow);	
			if (insertStatus == false)
			{
				insertStatusFlag=false;
				break;
			}			
		}	
	}
	else if(EventDetailsCheckGridData.indexOf('~')!=-1)
	{
		var eachrow=EventDetailsCheckGridData.split('~');
		var gridRow='';
			
		for(var j=0;j<eachrow.length;j++)
		{
			if (gridRow != "") 
			{
				gridRow = gridRow + "," + "'" + eachrow[j] + "'";
			} 
			else 
			{
				gridRow = "'" + eachrow[j] + "'";
			}
		}
		gridRow += ",'" + wi_name + "','" + CIF_ID + "'";	
		var insertStatus = InsertIntoDuplicationWorkitemTable(gridRow);	
		if (insertStatus == false)
		{
			insertStatusFlag=false;
		}	
	}
	return insertStatusFlag;
}

function InsertIntoDuplicationWorkitemTable(gridRow)
{
	try 
	{           
		var xhr;
		var ajaxResult;

		if (window.XMLHttpRequest)
			xhr = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr = new ActiveXObject("Microsoft.XMLHTTP");
		
		var url = '/TF/CustomForms/TF_Specific/InsertDuplicateWI.jsp';
		var param = "gridRow="+gridRow;
		//param = encodeURIComponent(param);
		xhr.open("POST", url, false);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send(param);
	
		if (xhr.status == 200 && xhr.readyState == 4) 
		{
			ajaxResult = xhr.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
			if(ajaxResult=="-1")
			{
			 alert("Problem in Inserting duplicate workitems list."+ajaxResult);
			 return false;
			}
			else 
				return true;
		}
		else
		{
			alert("Error while Inserting the DuplicateWorkitems");
			return false;
		}
    } 
	catch (e) 
	{
        alert("Exception while adding Duplicate workitem in Event Details Grid : " + e);
		return false;
    }
}

function ValidateGridInTF()
{
	var customform = '';
	var formWindow = getWindowHandler(windowList, "formGrid");
	customform = formWindow.frames['customform'];
	var iframe = customform.document.getElementById("frmData");
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	var header=iframeDocument.getElementById("Header").value;
	var gridTable=header+"_GridTable";
	
	var tableRowCount=iframeDocument.getElementById(gridTable).rows.length;
	// condition added for not to check mandatory when decision is reject on 05092017
	if (customform.document.getElementById("selectDecision").value !='Reject')
	{		
		if(tableRowCount==1)//1 because there is already header will be there then if blank grid the rows length will come 1
		{
			alert("Please add rows in grid.");
			return false;
		}
	}
	return true;
}
function validateExpiryDate(value,id)
	{
		var pattern = /^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/;
		if (value == null || value == "" || !pattern.test(value)) 
		{
			alert("Invalid date format for emirates expiry date");
			if(id=='EmratesIDExpDate')
				customform.document.getElementById("wdesk:EmratesIDExpDate").value = "";
			else if(id=='TLIDExpDate')
				customform.document.getElementById("wdesk:TLIDExpDate").value = "";
			return false;
		}
		else 
		{
			//var currentDate = new Date();
			//alert("currentDate Before "+currentDate);
			// added by shamily for EmidExpirydate parametrized value
			var EmidExpirydate_param = customform.document.getElementById('EmidExpirydate_param').value;
			//currentDate.setDate(currentDate.getDate() +EmidExpirydate_param);
			var currentDate = addDays (new Date(),EmidExpirydate_param);
			//alert("currentDate After "+currentDate);
			//var arrStartDate="15/05/2018";
			var arrStartDate = value.split("/");            
			var date2 = new Date(arrStartDate[2], arrStartDate[1] - 1, arrStartDate[0]);
			//var timeDiff = date2.getTime() - currentDate.getTime();
			var timeDiff = currentDate.getTime() - date2.getTime(); // for expiry date check validation
			//alert("Diff "+timeDiff);
			if(timeDiff>=0)
			{
				
				if(id=='EmratesIDExpDate')
				{
					alert("Emirates expiry date should not be less then sum of today's date and "+EmidExpirydate_param+" days.");
					return false;
				}				   //alert modified by shamily for  parametrized days as given in master
				else if(id=='TLIDExpDate')
				{
					var r = confirm("Trade License expiry date should not be less then sum of today's date and "+EmidExpirydate_param+" days, Press OK to Proceed");
					if (r == false) 
					{
						return false;
					} else if (r == true) 
					{
						return true;
					} 
				}
			}
			else 
			return true;
		}
}

function addDays(theDate, days)
{
	return new Date(theDate.getTime() + days*24*60*60*1000);
}
function getMultipleSelectedValue()
  {
	 	var customform = '';
		var formWindow = getWindowHandler(windowList, "formGrid");
		customform = formWindow.frames['customform'];
        var x=customform.document.getElementById("modeofdelivery");
        var selectedValues="";
        for (var i = 0; i < x.options.length; i++) 
          {
             var applicabeleValues ="Email&Branch,Branch&Email,Email&Courier,Courier&Email,Branch,Courier,Email";
             if(x.options[i].selected ==true)
             {
                    if(selectedValues=="")
                    selectedValues=x.options[i].value;
                    else                    
                    selectedValues=selectedValues+"&"+x.options[i].value;
             }            
          }
           if(applicabeleValues.indexOf(selectedValues)==-1)
           {
            alert("Only Email & Branch or Email & Courier is allowed in combination.");
			return false;
           }
		   return true;
 }
 function getgridValuesByColumnName(nameForMatch)
 {
		var colValue='';
		var customform = '';
		var formWindow = getWindowHandler(windowList, "formGrid");
		customform = formWindow.frames['customform'];
		var iframe = customform.document.getElementById("frmData");
		var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
		var header=iframeDocument.getElementById("Header").value;
		var gridTable=header+"_GridTable";
		var tableRowCount=iframeDocument.getElementById(gridTable).rows.length;
		var SubCategoryID=iframeDocument.getElementById("SubCategoryID").value;		
		for (var i = 0; i < tableRowCount; i++) {
			if(i==0)
			continue;
			var id='grid_'+SubCategoryID+'_'+nameForMatch+'_'+(i-1);
			if(colValue=='')
			colValue=iframeDocument.getElementById(id).value;
			else
			colValue=colValue+'@'+iframeDocument.getElementById(id).value;
		}
		return colValue;
 }

function AttachedDocType(sDocTypeNames,Mandatory){
	var arrAvailableDocList = getInterfaceData("D");
	//var arrAvailableDocList = document.getElementById('wdesk:docCombo');
	var arrSearchDocList = sDocTypeNames.split(",");
	var bResult=false;
	// condition added for not to check mandatory when decision is reject on 05092017
	if (customform.document.getElementById("selectDecision").value !='Reject') 
	{
		if(Mandatory)
		{
			for(var iSearchCounter=0;iSearchCounter<arrSearchDocList.length;iSearchCounter++){
				bResult=false;
				for(var iDocCounter=0;iDocCounter<arrAvailableDocList.length;iDocCounter++){
					if(arrAvailableDocList[iDocCounter].name.toUpperCase().indexOf(arrSearchDocList[iSearchCounter].toUpperCase())>=0){

						bResult = true;
						break;
					}
				}
				if(!bResult){
					alert("Please attach " + arrSearchDocList[iSearchCounter]+"/Deferral Waiver for " + arrSearchDocList[iSearchCounter]+" to proceed further.");
					return false;
				}
			}
		}
	}
	return true;
}

//changes by stutee.mishra
function AttachedDocTypegeneral(){
	//var arrAvailableDocList = document.getElementById('wdesk:docCombo');
	var arrAvailableDocList = getInterfaceData("D");
	var bResult=false;
	if (customform.document.getElementById("selectDecision").value !='Reject') 
	{
		if(arrAvailableDocList.length>0)
			{
				bResult = true;
			}
		if(!bResult)
			{
				alert("Please attach any one of the documents to proceed further.");
				return false;
			}							
		
	}
	return true;
}
/*function AttachedDeferralDocType(sDocTypeNames,Mandatory){
	var arrAvailableDocList = document.getElementById('wdesk:docCombo');
	var arrSearchDocList = sDocTypeNames.split(",");
	var bResult=false;
	if(Mandatory)
	{
		for(var iSearchCounter=0;iSearchCounter<arrSearchDocList.length;iSearchCounter++){
			bResult=false;
			for(var iDocCounter=0;iDocCounter<arrAvailableDocList.length;iDocCounter++){
				if(arrAvailableDocList[iDocCounter].text.toUpperCase().indexOf(arrSearchDocList[iSearchCounter].toUpperCase())>=0){

					bResult = true;
					break;
				}
			}
			if(!bResult){
				alert("Please attach Deferral Closure Document as Decision is selected as Deferral Closed");
				return false;
			}
		}
	}
	
	return true;
}
*/
function formatDate(dateObj,format)
{
    var curr_date = dateObj.getDate();
    var curr_month = dateObj.getMonth();
    curr_month = curr_month + 1;
    var curr_year = dateObj.getFullYear();
    var curr_min = dateObj.getMinutes();
    var curr_hr= dateObj.getHours();
    var curr_sc= dateObj.getSeconds();
    if(curr_month.toString().length == 1)
    curr_month = '0' + curr_month;      
    if(curr_date.toString().length == 1)
    curr_date = '0' + curr_date;
    if(curr_hr.toString().length == 1)
    curr_hr = '0' + curr_hr;
    if(curr_min.toString().length == 1)
    curr_min = '0' + curr_min;
	if(curr_sc.toString().length == 1)
    curr_sc = '0' + curr_sc;
    if(format ==1)//dd-mm-yyyy
    {
        return curr_date + "-"+curr_month+ "-"+curr_year;       
    }
    else if(format ==2)//yyyy-mm-dd
    {
        return curr_year + "-"+curr_month+ "-"+curr_date;       
	}
    else if(format ==3)//dd/mm/yyyy
    {
        return curr_date + "/"+curr_month+ "/"+curr_year;       
    }
    else if(format ==4)// MM/dd/yyyy HH:mm:ss
    {
        return curr_month+"/"+curr_date +"/"+curr_year+ " "+curr_hr+":"+curr_min+":"+curr_sc;       
    }
	else if(format ==5)// dd/MM/yyyy HH:mm:ss
    {
        return curr_date+"/"+curr_month +"/"+curr_year+ " "+curr_hr+":"+curr_min+":"+curr_sc;       
    }
}


 
	//**********************************************************************************//
	
function savechecklistData() 
{	
	var wi_name =customform.document.getElementById("wdesk:WI_NAME").value;
	var wsname =customform.document.getElementById("wdesk:WS_NAME").value;
	//alert("wsname--"+wsname);
	try 
	{
		var req;
		if (window.XMLHttpRequest) {
			req = new XMLHttpRequest();
		} else if (window.ActiveXObject) {
			isIE = true;
			req = new ActiveXObject("Microsoft.XMLHTTP");
		}
		
		var url = '/TF/CustomForms/TF_Specific/DeleteGridData.jsp';
		var param = "reqType=checklistData&wi_name="+wi_name+"&ws_name="+wsname;
		//param = encodeURIComponent(param);
		req.open("POST", url, false);
		req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		req.send(param);
			
		if (req.readyState == 4 && req.status == 200) 
		{
			ajaxResult = req.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '')
			if(ajaxResult=='-1')
			{
				alert('Error while delete checklistData');
				return false;
			}
		}
		else
		{
			alert('Error while delete checklistData\n Response Status '+req.status);
			return false;
		}
	} 
	catch (e) 
	{
		alert("Exception while delete checklistData: " + e);
	}
	//alert("inside savechecklistdata function");
	var table = customform.document.getElementById("checklistGrid");
	var ajaxResult='';
    var rowCount = table.rows.length;
	//alert("rowCount---"+rowCount);
	if(rowCount==1)//When no row added in grid
	return true;
	
     var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
	
	var arrayUIDFieldsForSave=['checklistdesc','remarks'];
    for (var i =1; i < rowCount; i++) 
	{
		var gridRow = "";
        //var colCount = table.rows[i].cells.length;
        //var currentrow = table.rows[i];
        for (var j = 0; j < arrayUIDFieldsForSave.length; j++) 
		{			
			var value = customform.document.getElementById(arrayUIDFieldsForSave[j]+i).value;
			value = value.split("'").join("''");
			if (gridRow != "") 
			{
				gridRow = gridRow + "," + "'" + value + "'";
				//alert("each gridRow value"+gridRow);
			} 
			else 
			{
				gridRow = "'"+i+"','"+WINAME+"',"+"'" + value + "'";
				//alert("each gridRow value"+gridRow);
			}
		}
		//Getting the radioButton Value of ChecklistGrid					
		if(customform.document.getElementById('Y'+i).checked==true)
		{
			var value = customform.document.getElementById('Y'+i).value;
			value = value.split("'").join("''");
			if (gridRow != "") 
			{
				gridRow = gridRow + "," + "'" + value + "'";
				//alert("each gridRow value"+gridRow);
			} 					
		}
		else if(customform.document.getElementById('N'+i).checked==true)
		{
			var value = customform.document.getElementById('N'+i).value;
			value = value.split("'").join("''");
			if (gridRow != "") 
			{
				gridRow = gridRow + "," + "'" + value + "'";
				//alert("each gridRow value"+gridRow);
			} 					
		}
		else if(customform.document.getElementById('NA'+i).checked==true)
		{
			var value = customform.document.getElementById('NA'+i).value;
			value = value.split("'").join("''");
			if (gridRow != "") 
			{
				gridRow = gridRow + "," + "'" + value + "'";
				//alert("each gridRow value"+gridRow);
			} 					
		}
		else 
		{
			if (gridRow != "") 
			{
				gridRow = gridRow + "," + "''";
				//alert("each gridRow value"+gridRow);
			} 		
		}
				
			
        
		gridRow = gridRow + "," + "'" + wsname + "'";
		//alert("gridRow--"+gridRow);
		
        try 
		{
			//alert("inside try");
			//gridRow = gridRow.split("'").join("ENSQOUTES");            
            var xhr;
            var ajaxResult;
            if (window.XMLHttpRequest)
                xhr = new XMLHttpRequest();
            else if (window.ActiveXObject)
                xhr = new ActiveXObject("Microsoft.XMLHTTP");
			
			var url = '/TF/CustomForms/TF_Specific/Savechecklistdata.jsp';
			url=url.replace(/&amp;/g, 'ENCODEDAND');
			var param = "gridRow="+gridRow+"&WINAME="+WINAME;
			//param = encodeURIComponent(param);
			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
			
			if (xhr.status == 200)
				{
					 ajaxResult = xhr.responseText;
					 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
					 if(ajaxResult=='-1')
					 {
						alert("Problem in saving checklist data");
						return false;
					 }
				}
				else
				{
					alert("Error while saving checklist");
					return false;
				}
        } 
		catch (e) 
		{
            alert("Exception while saving checklist Data:" + e);
			return false;
        }
    }
	return true;
} 
	
function saveDocGridData() 
{	
	var wi_name =customform.document.getElementById("wdesk:WI_NAME").value;
	try 
	{
		var req;
		if (window.XMLHttpRequest) {
			req = new XMLHttpRequest();
		} else if (window.ActiveXObject) {
			isIE = true;
			req = new ActiveXObject("Microsoft.XMLHTTP");
		}
		
		var url = '/TF/CustomForms/TF_Specific/DeleteGridData.jsp';
		var param = "reqType=DocGridData&wi_name="+wi_name;
		//param = encodeURIComponent(param);
		req.open("POST", url, false);
		req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		req.send(param);
		
		if (req.readyState == 4 && req.status == 200) 
		{
			ajaxResult = req.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '')
			if(ajaxResult=='-1')
			{
				alert('Error while delete DocGridData');
				return false;
			}
		}
		else
		{
			alert('Error while delete DocGridData\n Response Status '+req.status);
			return false;
		}
	} 
	catch (e) 
	{
		alert("Exception while delete DocGridData: " + e);
	}	
	//alert("inside savechecklistdata function");
	var table = customform.document.getElementById("DocumentGRid");
	var ajaxResult='';
    var rowCount = table.rows.length;
	if(rowCount==1)//When no row added in grid
	return true;
	
     var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
	
	var arrayDocFieldsForSave=['DocName','originals','copies'];
    for (var i =1; i < rowCount; i++) 
	{
		var gridRow = "";
        //var colCount = table.rows[i].cells.length;
        //var currentrow = table.rows[i];
        for (var j = 0; j < arrayDocFieldsForSave.length; j++) 
		{
			var value = customform.document.getElementById(arrayDocFieldsForSave[j]+i).value;
			value = value.split("'").join("''");
            if (gridRow != "") 
			{
                gridRow = gridRow + "," + "'" + value + "'";
				//alert("each gridRow value"+gridRow);
            } 
			else 
			{
                gridRow = "'"+i+"','"+WINAME+"',"+"'" + value + "'";
				//alert("each gridRow value"+gridRow);
            }
        }
	
        try 
		{
			//alert("inside try");
			//gridRow = gridRow.split("'").join("ENSQOUTES");	            
            var xhr;
            var ajaxResult;
            if (window.XMLHttpRequest)
                xhr = new XMLHttpRequest();
            else if (window.ActiveXObject)
                xhr = new ActiveXObject("Microsoft.XMLHTTP");
			
			var url = '/TF/CustomForms/TF_Specific/SaveDocumentGridData.jsp';
			url=url.replace(/&amp;/g, 'ENCODEDAND');
			var param = "gridRow="+gridRow+"&WINAME="+WINAME;
			//param = encodeURIComponent(param);
			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
			
			if (xhr.status == 200)
				{
					 ajaxResult = xhr.responseText;
					 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
					 if(ajaxResult=='-1')
					 {
						alert("Problem in saving DocGrid data");
						return false;
					 }
				}
				else
				{
					alert("Error while saving DocGrid");
					return false;
				}
        } 
		catch (e) 
		{
            alert("Exception while saving DocGrid Data:" + e);
			return false;
        }
    }
	return true;
}

function setDynamicFieldInExtTable()
{
	var customform = '';
	var formWindow = getWindowHandler(windowList, "formGrid");
	customform = formWindow.frames['customform'];
	var iframe = customform.document.getElementById("frmData");
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	var NameData='';
	var selects = iframeDocument.getElementsByTagName("select");
	var inputs = iframeDocument.getElementsByTagName("input");
	try 
	{
		for (x = 0; x < selects.length; x++) 
		{
			eleName2 = selects[x].getAttribute("name");
			if (eleName2 == null)
				continue;
			eleName2 += "#select";
			myname = selects[x].getAttribute("id");
			if (myname == null)
				continue;
			
		}
	}
	catch (err) 
	{
		return "exception";
	}
}

function CustomEncodeURI(data)
{
	return data.split("%").join("CHARPERCENTAGE").split("&").join("CHARAMPERSAND");
}

//**********************************************************************************//

