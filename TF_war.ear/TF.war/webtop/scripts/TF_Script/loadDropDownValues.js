function loadDropDownValues(currWorkstep,loggedInUser,WINAME,FlagValue)
	{		
		producttypedropdown(currWorkstep);			
		loadlodgementdate(WINAME,currWorkstep);		
		loadcommngrid(WINAME,FlagValue,currWorkstep);
		loadInvoiceGridValues(FlagValue,WINAME);
		var ServiceRequestCode = document.getElementById("wdesk:ServiceRequestCode").value;
		loadModeOfDelivery(ServiceRequestCode);
		loadQueryGridValues(WINAME,currWorkstep,"");	
	//	loadQueryGridValues(WINAME,currWorkstep,"FIRCO"); // Hritik 09.02.2024
	//	loadQueryGridValues(WINAME,currWorkstep,"FIRCO_UID"); // Hritik 09.02.2024
		getQueueList();
		getUserList();
		loadUTCGridValues(WINAME,currWorkstep);
		loadCurrencyMaster();
		
		//code added to set IslamicOrconventions on load
		if(currWorkstep=='CSO' && FlagValue!='Y'){
		var IslamicOrconventions = document.getElementById("IslamicOrconventions");
		setComboValueToTextBox(IslamicOrconventions,'wdesk:Islamic_Or_conventions');
		}
		
		document.getElementById('wdesk:CUSTOMER_NAME').value=document.getElementById('wdesk:Name').value;
		
	}
	
	
function enableDisable(workstepName)
{
	document.getElementById("selectUser").disabled=true;
	document.getElementById("selectQueue").disabled=true;
	
	if(workstepName!="CSO")
	{
		document.getElementById("InitiationSource").disabled=true;
			
	}
	else
	{
		document.getElementById("InitiationSource").disabled=false; 
		
	}
	if(workstepName!="TF_Checker" && workstepName!="TF_Document_Approver")
	{
		document.getElementById("wdesk:Secondary_RM_Code").disabled=true;
		document.getElementById("wdesk:SM").disabled=true;
	}
	else
	{
		document.getElementById("wdesk:Secondary_RM_Code").disabled=false;
		document.getElementById("wdesk:SM").disabled=false;
	}

	if(workstepName!= "CSO" && workstepName!="TF_Document_Approver" && workstepName!="TF_Maker")
	{
	
		document.getElementById("wdesk:BATCH_NO").disabled=true;
		document.getElementById("wdesk:DOCUMENT_COUNT").disabled=true;
		document.getElementById("wdesk:DOCUMENT_TYPE").disabled=true;
		document.getElementById("wdesk:DOCUMENT_SUB_TYPE").disabled=true;
		document.getElementById("wdesk:CUSTOMER_NAME").disabled=true;
		document.getElementById("wdesk:CUSTOMER_TAX_NO").disabled=true;
		document.getElementById("CUSTOMER_BUYER_OR_SUPPLIER").disabled=true;
		document.getElementById("wdesk:CUSTOMER_TRADE_NO").disabled=true;
		document.getElementById("OVERRIDE").disabled=true;
		
		
	}
	else
	{
		document.getElementById("wdesk:BATCH_NO").disabled=false;
		document.getElementById("wdesk:DOCUMENT_COUNT").disabled=false;
		document.getElementById("wdesk:DOCUMENT_TYPE").disabled=false;
		document.getElementById("wdesk:DOCUMENT_SUB_TYPE").disabled=false;
		document.getElementById("wdesk:CUSTOMER_NAME").disabled=false;
		document.getElementById("wdesk:CUSTOMER_TAX_NO").disabled=false;
		document.getElementById("CUSTOMER_BUYER_OR_SUPPLIER").disabled=false;
		document.getElementById("wdesk:CUSTOMER_TRADE_NO").disabled=false;
		document.getElementById("OVERRIDE").disabled=false;
				
	}	
	if(workstepName!= "RM" && workstepName!="UM" && workstepName!="SM" && workstepName!="MD" && workstepName!="HOD")
	{
	
		document.getElementById("DeferralWaiverHeldCombo").disabled=true;
		document.getElementById("wdesk:ApprovingAuthority").disabled=true;
		document.getElementById("wdesk:DocumentTypedeferred").disabled=true;
		document.getElementById("wdesk:DeferralExpiryDate").disabled=true;
		document.getElementById("DeferralExpiryDateCalImg").disabled=true;
			
	}
	else
	{
		document.getElementById("DeferralWaiverHeldCombo").disabled=false;
		document.getElementById("wdesk:ApprovingAuthority").disabled=false;
		document.getElementById("wdesk:DocumentTypedeferred").disabled=false;
		document.getElementById("wdesk:DeferralExpiryDate").disabled=false;
		document.getElementById("DeferralExpiryDateCalImg").disabled=false;
				
	}	
	
}
function disabledecision(wsname)
{
	var x = document.getElementById("selectDecision");
		if(wsname=='TF_Checker' || wsname=='TF_Document_Approver')
		{
			for (var i = 0; i < x.options.length; i++) 
			{
				if(document.getElementById("wdesk:SubSegment").value=='PSL' || document.getElementById("wdesk:SubSegment").value == 'SME')
				{				
					if(x.options[i].value=='Hold-External')
					{
						x.options[i].disabled = true;
					}
				}
				
				if(document.getElementById("wdesk:SubSegment").value!='PSL' && document.getElementById("wdesk:SubSegment").value != 'SME')
				{				
					if(x.options[i].value=='Send for Business Approval' || x.options[i].value=='Send for CROPS Action' || x.options[i].value=='Send to Business and CROPS')
					{
						x.options[i].disabled = true;
					}
				}
			}
		}
}		

function disablegridColumn(currWorkstep)
{
	/*if(currWorkstep=='CSM_Approval' || currWorkstep=='TF_Call_Back' || currWorkstep=='Returned_Doc_Maker' || currWorkstep=='TF_Document_Approver' || currWorkstep=='TF_Hold' || currWorkstep=='CSO_Reject' || currWorkstep=='Receive_Doc_Branch' || currWorkstep=='Print_and_Dispatch' || currWorkstep=='TF_Checker' || currWorkstep=='Del_Retention_Expire' || currWorkstep=='TF_Archival')
	{
	    var ChecklistWiname= document.getElementById("CHECKLIST_WSNAME").value;
		//alert("ChecklistWiname checklist combo for "+ChecklistWiname);	    
		var table = document.getElementById("checklistGrid");
		var rowCount=(table.rows.length);
		var arrayIdentificationDocFieldsForSave=['SRId','checklistdesc','Y','N','NA','remarks'];
		if(ChecklistWiname==currWorkstep)
		{
			for (var i = 1; i < rowCount; i++)
			{
				for (var j = 0; j < arrayIdentificationDocFieldsForSave.length; j++) 
				{
					document.getElementById(arrayIdentificationDocFieldsForSave[j]+i).disabled=false;			
		        }
	        }	
		}
		else
		{
			for (var i = 1; i < rowCount; i++)
			{
				for (var j = 0; j < arrayIdentificationDocFieldsForSave.length; j++) 
				{
					document.getElementById(arrayIdentificationDocFieldsForSave[j]+i).disabled=true;			
		        }
	        }
			
		}
	  //alert("disabled checklist grid");
	}*/
	if(currWorkstep!='CSO')
	{
		//alert("disabled checklist combo for "+currWorkstep);
	    //document.getElementById("ChecklistFor").disabled=true;	    
		var table = document.getElementById("DocumentGRid");
		var rowCount=(table.rows.length);
		var arrayIdentificationDocFieldsForSave=['DocName','originals','copies'];
			for (var i = 1; i < rowCount; i++)
			{
				for (var j = 0; j < arrayIdentificationDocFieldsForSave.length; j++) 
				{
			   document.getElementById(arrayIdentificationDocFieldsForSave[j]+i).disabled=true;
			
		        }
	        }
			
		if(currWorkstep == "TF_Document_Approver")
			document.getElementById("Event_Button").disabled=false;
		
		else
			document.getElementById("Event_Button").disabled=true;
	  
	}
	if(currWorkstep=='TF_Maker' || currWorkstep=='TF_Call_Back' || currWorkstep=='Returned_Doc_Maker' || currWorkstep=='TF_Document_Approver' || currWorkstep=='TF_Hold' || currWorkstep=='CSO_Reject' || currWorkstep=='Receive_Doc_Branch' || currWorkstep=='Print_and_Dispatch' || currWorkstep=='TF_Checker' || currWorkstep=='Del_Retention_Expire' || currWorkstep=='TF_Archival' || currWorkstep=='Returned_Doc_Checker' || currWorkstep=='CSM_Approval')
	{
		//alert("disabled checklist combo for "+currWorkstep);
	    document.getElementById("invoicenumber").disabled=true;	
		document.getElementById("wdesk:CounterParty").disabled=true;
		var table = document.getElementById("InvoiceDetailsGrid");
		var rowCount=(table.rows.length);
		var arrayIdentificationDocFieldsForSave=['selected','invoicenumber'];
			for (var i = 1; i < rowCount; i++)
			{
				for (var j = 0; j < arrayIdentificationDocFieldsForSave.length; j++) 
				{
			   document.getElementById(arrayIdentificationDocFieldsForSave[j]+i).disabled=true;
			
		        }
	        }	
	  //alert("disabled checklist grid");
	    document.getElementById("modeofcommunicationcombo").disabled=true;	
		document.getElementById("templatecombo").disabled=true;
		document.getElementById("communicationDate").disabled=true;
		document.getElementById("CommunicationTime").disabled=true;
		document.getElementById("description").disabled=true;		
		var table = document.getElementById("CommunicationdtlsGrid");
		var rowCount=(table.rows.length);
		var arrayCommunicationFieldsForSave=['modeofcommunicationcombo','communicationDate','CommunicationTime','description','DATE'];
			for (var i = 1; i < rowCount; i++)
			{
				for (var j = 0; j < arrayCommunicationFieldsForSave.length; j++) 
				{
			   document.getElementById(arrayCommunicationFieldsForSave[j]+i).disabled=true;
			
		        }
	        }
	}
	//for disabling the query grid columns
	if(currWorkstep !="Credit_Checker" && currWorkstep != "CreditApp_OR_Analyst" && currWorkstep !="Director_Credit" && currWorkstep != "Chief_Credit_Officer" && currWorkstep !="RM" && currWorkstep !="UM" && currWorkstep != "SM" && currWorkstep != "MD" && currWorkstep != "HOD")  
	{
		document.getElementById("Add_row_Query").disabled = true;
		//document.getElementById("Modify_row_Query").disabled = true;
		document.getElementById("Delete_row_Query").disabled = true;
		var table = document.getElementById("Query_Details_Grid");
		var table_len=table.rows.length;
		if(table_len>0)
		{
			if(currWorkstep !="Credit_Checker" && currWorkstep != "CreditApp_OR_Analyst" && currWorkstep !="Director_Credit" && currWorkstep != "Chief_Credit_Officer"){
		
				for(var i=1;i<table_len;i++)
				{
					document.getElementById("select_ID"+i).disabled = true;
					document.getElementById("query_Name"+i).disabled = true;
					document.getElementById("credit_Remarks"+i).disabled = true;
					
				}
		
			}
			if(currWorkstep !="RM" && currWorkstep !="UM" && currWorkstep != "SM" && currWorkstep != "MD" && currWorkstep != "HOD")
			{
			
				for(var i=1;i<table_len;i++)
				{
					document.getElementById("select_ID"+i).disabled = true;
					document.getElementById("business_Remarks"+i).disabled = true;
						
				}
			}
		
		}
	}
	else
	{
			if(currWorkstep =="Credit_Checker" || currWorkstep == "CreditApp_OR_Analyst" || currWorkstep =="Director_Credit" || currWorkstep == "Chief_Credit_Officer" || currWorkstep =="RM" || currWorkstep =="UM" || currWorkstep == "SM" || currWorkstep == "MD" || currWorkstep == "HOD") 
			{
				document.getElementById("Add_row_Query").disabled = false;
				document.getElementById("Delete_row_Query").disabled = false;
				var table = document.getElementById("Query_Details_Grid");
				var table_len=table.rows.length;
				if(table_len>0)
				{
					if(currWorkstep =="Credit_Checker" || currWorkstep == "CreditApp_OR_Analyst" || currWorkstep =="Director_Credit" || currWorkstep == "Chief_Credit_Officer"){
				
						for(var i=1;i<table_len;i++)
						{
							document.getElementById("business_Remarks"+i).disabled = true;
							
						}
				
					}
					if(currWorkstep =="RM" || currWorkstep =="UM" || currWorkstep == "SM" || currWorkstep == "MD" && currWorkstep == "HOD")
					{
					
						for(var i=1;i<table_len;i++)
						{
							document.getElementById("query_Name"+i).disabled = true;
							document.getElementById("credit_Remarks"+i).disabled = true;
								
						}
					}
				
				}

				
			}
	}	
	if(currWorkstep !="CSO" && currWorkstep != "TF_Maker" && currWorkstep !="TF_Document_Approver")
	{
		document.getElementById("AddUTC").disabled = true;
		document.getElementById("ModifyUTC").disabled = true;
		document.getElementById("TF_calendar").disabled = true;
		document.getElementById("TF_calendar1").disabled = true;

		var arrayUTCFieldsForSave=['DocumentNo','DocumentDate','UTC_Currency','TotalInvoiceAmount','BuyerName','SupplierName','LineItemsCount','BanRefNumber','ContractNo','PONumber','AmountInWords','PaymentDueDate','TermsofPayment','BillingAddress','Discount','TaxAmount','TaxNoSupplier','GrossAmount','SupplierAccountNo','SupplierAddressLine1','SupplierAddressLine2','SupplierAddressCity','SupplierAddressCountry','SupplierAddressPOBox','SupplierEmailAddress','SupplierWebsite','SupplierTelephone','BuyerTelephone','BuyerAccountNo','BuyerAddressLine1','BuyerAddressLine2','BuyerAddressCity','BuyerAddressCountry','BuyerAddressPOBox','BuyerEmailAddress','BuyerAddressPOBox','LineItemDescription','HSCode','UnitPrice','SubtotalAmount','Quantity','LineNo','UOM'];
		for (var j = 0; j < arrayUTCFieldsForSave.length; j++) 
		{
			
			document.getElementById(arrayUTCFieldsForSave[j]).disabled=true;
	
		}

		
	
	}
	else
	{
		document.getElementById("AddUTC").disabled = false;
		document.getElementById("ModifyUTC").disabled = false;
		document.getElementById("TF_calendar").disabled = false;
		document.getElementById("TF_calendar1").disabled = false;
		
		var arrayUTCFieldsForSave=['DocumentNo','DocumentDate','UTC_Currency','TotalInvoiceAmount','BuyerName','SupplierName','LineItemsCount','BanRefNumber','ContractNo','PONumber','AmountInWords','PaymentDueDate','TermsofPayment','BillingAddress','Discount','TaxAmount','TaxNoSupplier','GrossAmount','SupplierAccountNo','SupplierAddressLine1','SupplierAddressLine2','SupplierAddressCity','SupplierAddressCountry','SupplierAddressPOBox','SupplierEmailAddress','SupplierWebsite','SupplierTelephone','BuyerTelephone','BuyerAccountNo','BuyerAddressLine1','BuyerAddressLine2','BuyerAddressCity','BuyerAddressCountry','BuyerAddressPOBox','BuyerEmailAddress','BuyerAddressPOBox','LineItemDescription','HSCode','UnitPrice','SubtotalAmount','Quantity','LineNo','UOM'];
		for (var j = 0; j < arrayUTCFieldsForSave.length; j++) 
		{
			document.getElementById(arrayUTCFieldsForSave[j]).disabled=false;
			
		}
				
		
	}
	
}
	
function loadDecisionFromMaster(currWorkstep)
{
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
		
			url = '/TF/CustomForms/TF_Specific/DropDownLoad.jsp';
			var param = "reqType="+encodeURIComponent('selectDecision')+"&WSNAME="+encodeURIComponent(currWorkstep);
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
					alert("Error while loading dropdown values for decision");
					return false;
				 }				 
				 values = ajaxResult.split("~");
				 for(var j=0;j<values.length;j++)
				 {
					var opt = document.createElement("option");
					opt.text = values[j];
					opt.value =values[j];
					document.getElementById('selectDecision').options.add(opt);
				 }				 
			}
			else 
			{
				alert("Error while Loading Drowdown decision.");
				return false;
			}
}	


function producttypedropdown(currWorkstep)
	{
		if(currWorkstep=='CSO')
		{
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			
			url = '/TF/CustomForms/TF_Specific/DropDownServiceRequest.jsp';
			xhr.open("GET",url,false);
			xhr.send(null);
			if (xhr.status == 200)
			{	
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult.indexOf("Exception")==0)
				 {
					alert("Unknown Exception while working with request type ");
					return false;
				 }							 
				document.getElementById("AutocompleteValues").value=ajaxResult;
				//alert("document.getElementById(AutocompleteValues).value--"+document.getElementById("AutocompleteValues").value);
			}
			else 
			{
				alert("Error while Loading Drowdown for the current workstep");
				return false;
			}
		}
    }
	
	function loadChecklistdropdown(WINAME,currWorkstep,Checklist_Name)
	{
		if(Checklist_Name != ''){
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			var ApplicationFormCode=document.getElementById("wdesk:ServiceRequestCode").value;
			url ='/TF/CustomForms/TF_Specific/DropDownLoad.jsp';
			var param = "reqType="+encodeURIComponent('loadchecklist')+"&WINAME="+encodeURIComponent(WINAME)+"&Checklist_Name="+encodeURIComponent(Checklist_Name)+"&ServiceRequestCode="+ApplicationFormCode;
			//param = encodeURIComponent(param);
			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
			
			
			if (xhr.status == 200)
			{	
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult=="")
				 {
					//alert("No Checklist data Saved For given "+WINAME);
				 }
				 else if(ajaxResult.indexOf("Exception")==0)
				 {
					alert("Unknown Exception while working with request type ");
					return false;
				 }					 	
                 //alert("ajaxResult is"+ajaxResult);		
				  if(ajaxResult.indexOf('|')!=-1)
				  {
					 ajaxResult=ajaxResult.split('|');
					 for(var i=0;i<ajaxResult.length;i++)
					 {
						addrowchecklist(ajaxResult[i],currWorkstep)
					 }
				  }
				  else				  
					addrowchecklist(ajaxResult,currWorkstep);				
				
			}
			else 
			{
				alert("Error while Loading Drowdown for the current workstep");
				return false;
			}
		}
		
    }

function deleteRowsFromGridWithIndex()
{
	var r = confirm("Do you want to delete the row?");
	if (r == true) {
		var row = window.event.srcElement;
		row = row.parentNode.parentNode;
		var rowindex=row.rowIndex;
		var table = document.getElementById("ChecklistTable");
		var rowCount = table.rows.length;
		if(rowCount==4)//means only one row added then no need to update id's.Just delete the row
		{
			table.deleteRow(rowindex);
		}
		else if((rowCount-1)==rowindex)//means last row is being deleated then no need to update id's.Just delete the row
		{
			table.deleteRow(rowindex);
		}
		else
		{
			var arrayUIDFieldsForSave=['checklistdesc','option','remarks'];
			
				for(var k=0;k<arrayUIDFieldsForSave.length;k++)
				 {
					for(var j=rowindex;j<(rowCount-1);j++)
					{
						var currentRowId=parseInt(j)+1;
						document.getElementById(arrayUIDFieldsForSave[k]+currentRowId).id = arrayUIDFieldsForSave[k] + (j);
					}
				 }
				 table.deleteRow(rowindex);
		}
	}
}


function loadlodgementdate(WINAME,currWorkstep)
{
		if(currWorkstep !="CSO")
		{	
		//alert("insidee checklist"+WINAME);
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			
			url ='/TF/CustomForms/TF_Specific/DropDownLoad.jsp';
			var param = "reqType="+encodeURIComponent('loadlodgementdate')+"&WINAME="+encodeURIComponent(WINAME);
			//param = encodeURIComponent(param);
			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
			if (xhr.status == 200)
			{	
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult.indexOf("Exception")==0)
				 {
					alert("Unknown Exception while working with request type ");
					return false;
				 }	
				  var date;
				  var dateformat;
				 if(ajaxResult.indexOf("-")!=-1)
				 {
					 date=ajaxResult.split(" ");
					 //alert("date 0 is"+date[0]);	
					 //alert("date 1 is"+date[1]);
					 dateformat=date[0].split("-");
					 //alert("date 0 is"+dateformat[2]);	
					 //alert("date 1 is"+dateformat[1]);
					 //alert("date 1 is"+dateformat[0]);
				 }
				 else if(ajaxResult.indexOf("/")!=-1)
				 {
					 date=ajaxResult.split(" ");
					 //alert("date 0 is"+date[0]);	
					 //alert("date 1 is"+date[1]);
					 dateformat=date[0].split("/");
					 //alert("date 0 is"+dateformat[2]);	
					 //alert("date 1 is"+dateformat[1]);
					 //alert("date 1 is"+dateformat[0]);
				 }
				 else
				 {
					alert("check the lodgementDate"); 
					return false;
				 }					
				 document.getElementById("LodgementDate").value=dateformat[2]+"/"+dateformat[1]+"/"+dateformat[0];		//dd/mm/yyyy format
			}
			else 
			{
				alert("Error while Loading date for the workstep"+currWorkstep);
				return false;
			}
		}
		
}

	function loadcommngrid(WINAME,FlagValue,currWorkstep)
	{
		if(FlagValue=='Y'){
		//alert("insidee checklist"+WINAME);
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			
			url ='/TF/CustomForms/TF_Specific/DropDownLoad.jsp';
			var param = "reqType="+encodeURIComponent('loadcommngrid')+"&WINAME="+encodeURIComponent(WINAME);
			//param = encodeURIComponent(param);
			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
	
	
			if (xhr.status == 200)
			{	
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult.indexOf("Exception")==0)
				 {
					alert("Unknown Exception while working with request type ");
					return false;
				 }	
                 //alert("ajaxResult is"+ajaxResult);		
				  if(ajaxResult.indexOf('|')!=-1)
				  {
					 ajaxResult=ajaxResult.split('|');
					 for(var i=0;i<ajaxResult.length;i++)
					 {
						addrowcommngrid(ajaxResult[i],currWorkstep)
					 }
				  }
				  else
					addrowcommngrid(ajaxResult,currWorkstep);			 
				//document.getElementById("AutocompleteValues").value=ajaxResult;
				//alert("document.getElementById(AutocompleteValues).value--"+document.getElementById("AutocompleteValues").value);
			}
			else 
			{
				//alert("Error while Loading communication grid for the current workstep");
				return false;
			}
		}
		
    }
 

function loadDocuments(currWorkstep,RequestCode)
	{
		if(currWorkstep=='CSO')
		{
				deleteRowsFromGrid("DocumentGRid");	//Delete the rows from table using Grid Id
				var url = '';
				var xhr;
				var ajaxResult;		
				if(window.XMLHttpRequest)
				xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
				xhr=new ActiveXObject("Microsoft.XMLHTTP");
				
				url = '/TF/CustomForms/TF_Specific/DropDownLoad.jsp';
				var param = "reqType="+encodeURIComponent('loadDocumentGridOnCIFSearch')+"&ServiceRequestCode="+encodeURIComponent(RequestCode);
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
						alert("Error while loading customer data.");
						return false;
					 }
					 else if(ajaxResult=='0')//Means no record found in database
					 {
						alert("No data found for the selected DOC");
					 }
					 else
					 {							
						addrowDocumentgrid(ajaxResult,currWorkstep);						 
					 }		
				}
				else 
				{
					alert("Exception while loading DOC data.");
					return false;
				}
		}
	}
function loadChecklistCombo(currWorkstep,RequestCode)
{
		if(currWorkstep!='')
		{
				var url = '';
				var xhr;
				var ajaxResult;		
				if(window.XMLHttpRequest)
				xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
				xhr=new ActiveXObject("Microsoft.XMLHTTP");
				
				url = '/TF/CustomForms/TF_Specific/DropDownLoad.jsp';
				var param = "reqType="+encodeURIComponent('loadChecklistCombo')+"&ServiceRequestCode="+encodeURIComponent(RequestCode);
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
						alert("Error while loading ChecklistCombo data.");
						return false;
					 }
					 else if(ajaxResult=='0')//Means no record found in database
					 {
						alert("No data found for the ChecklistCombo data");
					 }
					 else
					 {							
						 values = ajaxResult.split("|");
						 for(var j=0;j<values.length;j++)
						 {
							var opt = document.createElement("option");
							opt.text = values[j];
							opt.value =values[j];
							document.getElementById("Checklist_For").options.add(opt);
						 }								 
					 }		
				}
				else 
				{
					alert("Exception while loading ChecklistCombo data.");
					return false;
				}
		}
}
function loadModeOfDelivery(RequestCode)
{
	if(RequestCode!="")
	{
		var xhr1;
		var ajaxResult;
		ajaxResult = "";
		var reqType = "Load_ModeOfDelivery";

		if (window.XMLHttpRequest)
			xhr1 = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr1 = new ActiveXObject("Microsoft.XMLHTTP");

		var url = '/TF/CustomForms/TF_Specific/DropDownLoad.jsp';
		var param = "reqType="+encodeURIComponent(reqType)+"&ServiceRequestCode="+encodeURIComponent(RequestCode);

		xhr1.open("POST", url, false);
		xhr1.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr1.send(param);

		if (xhr1.status == 200) {
			ajaxResult = xhr1.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
			//alert("ajaxResult---"+ajaxResult);

			if (ajaxResult.indexOf("Exception") == 0) {
				alert("Some problem in Loading Mode Of Delivery Values");
				return false;
			}
			//Clear the ModeOfDelivery Field
			document.getElementById("modeofdelivery").innerText="";
			//Adding values to ModeOfDelivery Field
			var values = ajaxResult.split("~");				
			for(var j=0;j<values.length;j++)
			 {
				 if(values[j]!='')
				 {
				 var opt = document.createElement("option");
				 opt.text = values[j];
				 opt.value =values[j];
				 document.getElementById("modeofdelivery").options.add(opt);
				 }
			 }
				 var e = document.getElementById("modeofdelivery");
				
		} else {
			alert("Error while Loading Mode Of Delivery Values");
			//return "";
		}
	}
}

function ajaxRequest(reqType,field, value)
{
		var xhr1;
		var ajaxResult;
		ajaxResult = "";
		
		if (window.XMLHttpRequest)
			xhr1 = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr1 = new ActiveXObject("Microsoft.XMLHTTP");

		var url = '/TF/CustomForms/TF_Specific/DropDownLoad.jsp';
		var param='UserName='+encodeURIComponent(value)+ "&reqType="+encodeURIComponent(reqType);
		//alert("url"+url);

		xhr1.open("POST", url, false);
		xhr1.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr1.send(param);
		
		if (xhr1.status == 200) {
			ajaxResult = xhr1.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
			//alert("ajaxResult---"+ajaxResult);

			if (ajaxResult.indexOf("Exception") == 0) {
				alert("Some problem in Loading mail ids.");
				return false;
			}
			if(reqType == "getMailIdOfRORM")
			{
				document.getElementById(field).value=ajaxResult;
			}	
		} else {
			alert("Error while Loading mail id");
			//return "";
		}	
}

function loadFircoGridValues(WINAME,currWorkstep)
{
	var table_name='';
	var id_name='addrow_query';
	var url='';
	
	url = "/TF/CustomForms/TF_Specific/loadQueryGridDetails.jsp";
	
	var xhr;
	var ajaxResult="";		
	if(window.XMLHttpRequest)
		xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		xhr=new ActiveXObject("Microsoft.XMLHTTP");
		
	var param="WI_NAME="+WINAME+"&Req_type="+Req_type;
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
	xhr.send(param);
	
	if (xhr.status == 200) {
	
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult=="-1") {
			alert("Error while loading "+table_name+" details ");
			return false;
		}
		else if(ajaxResult=='0') {
			//Means no record found in database 
		}
		else {
			ajaxResult=ajaxResult.split('|');
			
			for(var i=0;i<ajaxResult.length;i++)
			{
				if(Req_type!="FIRCO" || Req_type!="FIRCO_UID") {
					addrow_query(currWorkstep,'Add_row_Query',ajaxResult[i]);
				}
			} 
			if (ajaxResult.length > 0) {
				// below block added to apply tooltip on field added on 07032018
				$(document).ready(function() {
					$("input:text,select,textarea").wrap("<div class='tooltip-wrapper' style='display:inline'></div>");
					$("div.tooltip-wrapper").mouseover(function() {
						$(this).attr('title', $(this).children().val());
					});
				});
			}							
		}		
	}
	else {
		alert("Error while Loading "+table_name+" Grid Data.");
		return false;
	}
	
}

function loadQueryGridValues(WINAME,currWorkstep,Req_type)
{
	var table_name='';
	var id_name='addrow_query';
	var url='';
	
	url = "/TF/CustomForms/TF_Specific/loadQueryGridDetails.jsp";
	
	var xhr;
	var ajaxResult="";		
	if(window.XMLHttpRequest)
		xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		xhr=new ActiveXObject("Microsoft.XMLHTTP");
		
	var param="WI_NAME="+WINAME+"&Req_type="+Req_type;
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
	xhr.send(param);
	
	if (xhr.status == 200) {
	
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult=="-1") {
			alert("Error while loading "+table_name+" details ");
			return false;
		}
		else if(ajaxResult=='0') {
			//Means no record found in database 
		}
		else {
			ajaxResult=ajaxResult.split('|');
			
			for(var i=0;i<ajaxResult.length;i++)
			{
				if(Req_type!='FIRCO_UID' || Req_type!='FIRCO'){
					addrow_query(currWorkstep,'Add_row_Query',ajaxResult[i]);
				}
			} 
			if (ajaxResult.length > 0) {
				// below block added to apply tooltip on field added on 07032018
				$(document).ready(function() {
					$("input:text,select,textarea").wrap("<div class='tooltip-wrapper' style='display:inline'></div>");
					$("div.tooltip-wrapper").mouseover(function() {
						$(this).attr('title', $(this).children().val());
					});
				});
			}							
		}		
	}
	else {
		alert("Error while Loading "+table_name+" Grid Data.");
		return false;
	}
}  

function addrow_Firco(arrayRowValues)
{
	var Firco_type = document.getElementById("Firco_type").value;
	if(Firco_type == '' ||  Firco_type=='--Select--')
	{
		alert("Mandatory to select Firco type");
		document.getElementById("Firco_type").focus(true);
		return false;
	}
	
	var FircoName = document.getElementById("FircoName").value;
	if(FircoName == '' ||  FircoName=='--Select--')
	{
		alert("Mandatory to enter Firco Name");
		document.getElementById("FircoName").focus(true);
		return false;
	}
	
	var FircoTable=document.getElementById("Firco_Details_Grid");
	var table_len=(FircoTable.rows.length);
	var row = FircoTable.insertRow(table_len);
	row.id="row"+table_len;
	var cell0 = row.insertCell(0);
	cell0.innerHTML = "<input type='radio' name='selectRadio' id='selected"+table_len+"' value='row"+table_len+"'>";
	
	var arrayFircoFieldsForSave=['Firco_type','FircoName','FetchFirco'];
	var j;
	for(j=1;j<=arrayFircoFieldsForSave.length;j++)
	{
		var cell = row.insertCell(j);
		cell.id=arrayFircoFieldsForSave[j-1]+table_len;
		cell.innerHTML =document.getElementById(arrayFircoFieldsForSave[j-1]).value;
	}
	//	Clear all field after adding row from form
	clearAllFircoFields();
}


function clearAllFircoFields()
{
	 var arrayFircoFields=['Firco_type','FircoName'];
	 for(var i=0;i<arrayFircoFields.length;i++)
	 {
		document.getElementById(arrayFircoFields[i]).value="";
	 }
}


function Deleterow_Firco() {
	
	var QueryTable=document.getElementById("Firco_Details_Grid");
	var table_len=(QueryTable.rows.length);
	var rowidselected="";
	var rowNo='';
	for(var i=1;i<table_len;i++)
	{
		if(document.getElementById("selected"+i))
		{	
			rowidselected=i;
			rowNo=i;
		}
	}
	
	var rowCount = QueryTable.rows.length;
	if(rowidselected=='')
	{
		alert("Please select a row to delete.");
		return false;
	}
	if(rowCount==2)//means only one row added then no need to update id's.Just delete the row
	{
		QueryTable.deleteRow(rowidselected);
	}
	else if(rowidselected==(rowCount-1))
	{
		QueryTable.deleteRow(rowidselected);//means last row is being deleated then no need to update id's.Just delete the row
	} 
	else
	{
		var arrayQueryFieldsForSave=['select_ID','query_Name','credit_Remarks','business_Remarks'];
	
		for(var k=0;k<arrayQueryFieldsForSave.length;k++)
		 {
			for(var j=rowidselected;j<(rowCount-1);j++)
			{
				var currentRowId=parseInt(j)+1;				
				document.getElementById(arrayQueryFieldsForSave[k]+currentRowId).id = arrayQueryFieldsForSave[k] + (j);
			}
		 }
		 QueryTable.deleteRow(rowidselected);
	}
	document.getElementById("rowidselected").value='';//after row deletion making rowidselected hidden field to blank as that row has been deleted. 
}

function addrow_query(CurrentWS,buttonid,arrayRowValues)
{
	arrayRowValues=arrayRowValues.split('<br>').join('\r');
	if(buttonid=='Add_row_Query')
	{
		var arrayQueryRowValues=arrayRowValues;
		if(arrayQueryRowValues!='')
		{
			
			arrayQueryRowValues=arrayQueryRowValues.split('AMPNDCHAR').join('&');
			arrayQueryRowValues=arrayQueryRowValues.split('CCCOMMAAA').join(',');
			arrayQueryRowValues=arrayQueryRowValues.split('PPPERCCCENTT').join('%');
			
			arrayQueryRowValues=arrayQueryRowValues.split("~");
			
		}
		var table = document.getElementById("Query_Details_Grid");
		var table_len=table.rows.length;
		var lastRow = table.rows[table.rows.length];
		var row = table.insertRow();
		
		if (CurrentWS=="Credit_Checker" || CurrentWS == "CreditApp_OR_Analyst" || CurrentWS =="Director_Credit" || CurrentWS == "Chief_Credit_Officer") 
		{	
			var cell = row.insertCell(0);
			var select_ID = 'select_ID'+table_len;
			cell.innerHTML="<input type='radio' id='select_ID"+table_len+"' name='selectRadio' value='"+table_len+"' style='width:100%'>";
			if(arrayQueryRowValues!='')
				document.getElementById("select_ID"+table_len).value=arrayQueryRowValues[0];
				
			var cell = row.insertCell(1);
			var query_Name  = 'query_Name'+table_len;
			cell.innerHTML="<textarea id='query_Name"+table_len+"' style='width:99%'>";
			if(arrayQueryRowValues!=''){
				var query_NameVal=arrayQueryRowValues[1];
				query_NameVal=query_NameVal.replace(/&amp;/g,'&');
				query_NameVal=query_NameVal.replace(/&lt;/g,'<');
				query_NameVal=query_NameVal.replace(/&gt;/g,'>');
				query_NameVal=query_NameVal.replace(/&quot;/g,'"');
				query_NameVal=query_NameVal.replace(/&apos;/g,"'");
				query_NameVal=query_NameVal.replace(/&per;/g,"%");
				//document.getElementById("query_Name"+table_len).value=arrayQueryRowValues[1];
				document.getElementById("query_Name"+table_len).value=query_NameVal;
				}
			
			var cell = row.insertCell(2);
			var credit_Remarks  = 'credit_Remarks'+table_len;
			cell.innerHTML="<textarea id='credit_Remarks"+table_len+"' style='width:99%'>";
			if(arrayQueryRowValues!=''){
			var credit_RemarksVal=arrayQueryRowValues[2];
				credit_RemarksVal=credit_RemarksVal.replace(/&amp;/g,'&');
				credit_RemarksVal=credit_RemarksVal.replace(/&lt;/g,'<');
				credit_RemarksVal=credit_RemarksVal.replace(/&gt;/g,'>');
				credit_RemarksVal=credit_RemarksVal.replace(/&quot;/g,'"');
				credit_RemarksVal=credit_RemarksVal.replace(/&apos;/g,"'");
				credit_RemarksVal=credit_RemarksVal.replace(/&per;/g,"%");
				//document.getElementById("credit_Remarks"+table_len).value=arrayQueryRowValues[2];
				document.getElementById("credit_Remarks"+table_len).value=credit_RemarksVal;
				}
			
			var cell = row.insertCell(3);
			var business_Remarks  = 'business_Remarks'+table_len;
			cell.innerHTML="<textarea disabled id='business_Remarks"+table_len+"' style='width:99%'>";
			if(arrayQueryRowValues!=''){
				var business_RemarksVal=arrayQueryRowValues[3];
				business_RemarksVal=business_RemarksVal.replace(/&amp;/g,'&');
				business_RemarksVal=business_RemarksVal.replace(/&lt;/g,'<');
				business_RemarksVal=business_RemarksVal.replace(/&gt;/g,'>');
				business_RemarksVal=business_RemarksVal.replace(/&quot;/g,'"');
				business_RemarksVal=business_RemarksVal.replace(/&apos;/g,"'");
				business_RemarksVal=business_RemarksVal.replace(/&per;/g,"%");
				//document.getElementById("business_Remarks"+table_len).value=arrayQueryRowValues[3];
				document.getElementById("business_Remarks"+table_len).value=business_RemarksVal;
				}
		}
		else if (CurrentWS =="RM" || CurrentWS =="UM" || CurrentWS == "SM" || CurrentWS == "MD" || CurrentWS == "HOD") 
		{	
			var cell = row.insertCell(0);
			var select_ID = 'select_ID'+table_len;
			cell.innerHTML="<input type='radio' id='select_ID"+table_len+"' name='selectRadio' value='"+table_len+"' style='width:100%'>";
			if(arrayQueryRowValues!='')
				document.getElementById("select_ID"+table_len).value=arrayQueryRowValues[0];
				
			var cell = row.insertCell(1);
			var query_Name  = 'query_Name'+table_len;
			cell.innerHTML="<textarea disabled id='query_Name"+table_len+"' style='width:99%'>";
			if(arrayQueryRowValues!=''){
				var query_NameVal=arrayQueryRowValues[1];
				query_NameVal=query_NameVal.replace(/&amp;/g,'&');
				query_NameVal=query_NameVal.replace(/&lt;/g,'<');
				query_NameVal=query_NameVal.replace(/&gt;/g,'>');
				query_NameVal=query_NameVal.replace(/&quot;/g,'"');
				query_NameVal=query_NameVal.replace(/&apos;/g,"'");
				query_NameVal=query_NameVal.replace(/&per;/g,"%");
				//document.getElementById("query_Name"+table_len).value=arrayQueryRowValues[1];
				document.getElementById("query_Name"+table_len).value=query_NameVal;
				}
			
			var cell = row.insertCell(2);
			var credit_Remarks  = 'credit_Remarks'+table_len;
			cell.innerHTML="<textarea disabled id='credit_Remarks"+table_len+"' style='width:99%'>";
			if(arrayQueryRowValues!=''){
				var credit_RemarksVal=arrayQueryRowValues[2];
				credit_RemarksVal=credit_RemarksVal.replace(/&amp;/g,'&');
				credit_RemarksVal=credit_RemarksVal.replace(/&lt;/g,'<');
				credit_RemarksVal=credit_RemarksVal.replace(/&gt;/g,'>');
				credit_RemarksVal=credit_RemarksVal.replace(/&quot;/g,'"');
				credit_RemarksVal=credit_RemarksVal.replace(/&apos;/g,"'");
				credit_RemarksVal=credit_RemarksVal.replace(/&per;/g,"%");
				//document.getElementById("credit_Remarks"+table_len).value=arrayQueryRowValues[2];
				document.getElementById("credit_Remarks"+table_len).value=credit_RemarksVal;
				}
							
			var cell = row.insertCell(3);
			var business_Remarks  = 'business_Remarks'+table_len;
			cell.innerHTML="<textarea id='business_Remarks"+table_len+"' style='width:99%'>";
			if(arrayQueryRowValues!=''){
				var business_RemarksVal=arrayQueryRowValues[3];
				business_RemarksVal=business_RemarksVal.replace(/&amp;/g,'&');
				business_RemarksVal=business_RemarksVal.replace(/&lt;/g,'<');
				business_RemarksVal=business_RemarksVal.replace(/&gt;/g,'>');
				business_RemarksVal=business_RemarksVal.replace(/&quot;/g,'"');
				business_RemarksVal=business_RemarksVal.replace(/&apos;/g,"'");
				business_RemarksVal=business_RemarksVal.replace(/&per;/g,"%");
				//document.getElementById("business_Remarks"+table_len).value=arrayQueryRowValues[3];
				document.getElementById("business_Remarks"+table_len).value=business_RemarksVal;
				}
		}
		else
		{
			var cell = row.insertCell(0);
			var select_ID = 'select_ID'+table_len;
			cell.innerHTML="<input type='radio' id='select_ID"+table_len+"' name='selectRadio' value='"+table_len+"' style='width:100%'>";
			if(arrayQueryRowValues!='')
				document.getElementById("select_ID"+table_len).value=arrayQueryRowValues[0];
				
			var cell = row.insertCell(1);
			var query_Name  = 'query_Name'+table_len;
			cell.innerHTML="<textarea id='query_Name"+table_len+"' style='width:99%'>";
			if(arrayQueryRowValues!=''){
				var query_NameVal=arrayQueryRowValues[1];
				query_NameVal=query_NameVal.replace(/&amp;/g,'&');
				query_NameVal=query_NameVal.replace(/&lt;/g,'<');
				query_NameVal=query_NameVal.replace(/&gt;/g,'>');
				query_NameVal=query_NameVal.replace(/&quot;/g,'"');
				query_NameVal=query_NameVal.replace(/&apos;/g,"'");
				query_NameVal=query_NameVal.replace(/&per;/g,"%");
				//document.getElementById("query_Name"+table_len).value=arrayQueryRowValues[1];
				document.getElementById("query_Name"+table_len).value=query_NameVal;
				}
			
			var cell = row.insertCell(2);
			var credit_Remarks  = 'credit_Remarks'+table_len;
			cell.innerHTML="<textarea id='credit_Remarks"+table_len+"' style='width:99%'>";
			if(arrayQueryRowValues!=''){
				var credit_RemarksVal=arrayQueryRowValues[2];
				credit_RemarksVal=credit_RemarksVal.replace(/&amp;/g,'&');
				credit_RemarksVal=credit_RemarksVal.replace(/&lt;/g,'<');
				credit_RemarksVal=credit_RemarksVal.replace(/&gt;/g,'>');
				credit_RemarksVal=credit_RemarksVal.replace(/&quot;/g,'"');
				credit_RemarksVal=credit_RemarksVal.replace(/&apos;/g,"'");
				credit_RemarksVal=credit_RemarksVal.replace(/&per;/g,"%");
				//document.getElementById("credit_Remarks"+table_len).value=arrayQueryRowValues[2];
				document.getElementById("credit_Remarks"+table_len).value=credit_RemarksVal;
				}
			
			var cell = row.insertCell(3);
			var business_Remarks  = 'business_Remarks'+table_len;
			cell.innerHTML="<textarea id='business_Remarks"+table_len+"' style='width:99%'>";
			if(arrayQueryRowValues!=''){
				var business_RemarksVal=arrayQueryRowValues[3];
				business_RemarksVal=business_RemarksVal.replace(/&amp;/g,'&');
				business_RemarksVal=business_RemarksVal.replace(/&lt;/g,'<');
				business_RemarksVal=business_RemarksVal.replace(/&gt;/g,'>');
				business_RemarksVal=business_RemarksVal.replace(/&quot;/g,'"');
				business_RemarksVal=business_RemarksVal.replace(/&apos;/g,"'");
				business_RemarksVal=business_RemarksVal.replace(/&per;/g,"%");
				//document.getElementById("business_Remarks"+table_len).value=arrayQueryRowValues[3];
				document.getElementById("business_Remarks"+table_len).value=business_RemarksVal;
				}
		}
	}
}	

function loadCurrencyMaster()
{

	var url = '';
	var xhr;
	var ajaxResult;
	if (window.XMLHttpRequest)
		xhr = new XMLHttpRequest();
	else if (window.ActiveXObject)
		xhr = new ActiveXObject("Microsoft.XMLHTTP");
	var reqType="Load_Currency";
	url = "/TF/CustomForms/TF_Specific/DropDownLoad.jsp";
	var param = "&reqType=" + encodeURIComponent(reqType);
	xhr.open("POST", url, false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200) {
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
		if (ajaxResult == '-1') {
			alert("Error while loading dropdown values for Currency Value");
			return false;
		}

		values = ajaxResult.split("~");
		for (var j = 0; j < values.length; j++) {
			var opt = document.createElement("option");
			opt.text = values[j];
			opt.value = values[j];
			if (opt.value != "")
				document.getElementById("UTC_Currency").options.add(opt);
		}

	}
	else {
		alert("Error while Loading dropdown for " + dropDownFieldName);
		return false;
	}
	
}
function loadUTCGridValues(WINAME,currWorkstep)
{
		var url = "/TF/CustomForms/TF_Specific/loadUTCGridData.jsp";
		var param="WI_NAME="+WINAME;
		var xhr;
		var ajaxResult="";		
		if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
		else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			
		
		xhr.open("POST",url,false);
		xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
		xhr.send(param);
		
		if (xhr.status == 200)
		{
			//alert("status"+xhr.status);
			ajaxResult = xhr.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
			if(ajaxResult=="-1")
			{
				alert("Error while loading UTC details ");
				return false;
			}
			else if(ajaxResult=='0')//Means no record found in database
			{
				
			}
			else
			{
				ajaxResult=ajaxResult.split('|');
				
				for(var i=0;i<ajaxResult.length;i++)
				{
					var ajaxResultRow=ajaxResult[i].split('~');
					loadUTCDetails(currWorkstep,ajaxResult[i]);
					
				}							
				if (ajaxResult.length > 0)
				{
					// below block added to apply tooltip on field added on 07032018
					$(document).ready(function() {
						$("input:text,select,textarea").wrap("<div class='tooltip-wrapper' style='display:inline'></div>");
						$("div.tooltip-wrapper").mouseover(function() {
							$(this).attr('title', $(this).children().val());
						});
					});
				}
			}		
		}
		else 
		{
			alert("Error while Loading UTC Grid Data.");
			return false;
		}
		
}
function selectRow(element)
{
  
    var table = document.getElementById("UTCDetailsGrid");
   
	var row = table.rows[element.parentNode.parentNode.rowIndex];
	
	if(document.getElementById('utcSelectedRow').value!=element.parentNode.parentNode.rowIndex)
	{
		document.getElementById('utcSelectedRow').value=element.parentNode.parentNode.rowIndex;
		var arrayUTCRowValues=['DocumentNo','DocumentDate','UTC_Currency','TotalInvoiceAmount','BuyerName','SupplierName','LineItemsCount','BanRefNumber','ContractNo','PONumber','AmountInWords','PaymentDueDate','TermsofPayment','BillingAddress','Discount','TaxAmount','TaxNoSupplier','GrossAmount','SupplierAccountNo','SupplierAddressLine1','SupplierAddressLine2','SupplierAddressCity','SupplierAddressCountry','SupplierAddressPOBox','SupplierEmailAddress','SupplierWebsite','SupplierTelephone','BuyerTelephone','BuyerAccountNo','BuyerAddressLine1','BuyerAddressLine2','BuyerAddressCity','BuyerAddressCountry','BuyerAddressPOBox','BuyerEmailAddress','BuyerWebsite','LineItemDescription','HSCode','UnitPrice','SubtotalAmount','Quantity','LineNo','UOM'];
		for (var j=1;j<row.cells.length;j++) 
		{
		   document.getElementById(arrayUTCRowValues[parseInt(j)-1]).value=row.cells[j].innerHTML;
		}
	}else{
		document.getElementById('utcSelectedRow').value='';
		element.checked=false;
		
	}
}
function loadUTCDetails(CurrentWS,arrayRowValues)
{
		var UTCTable=document.getElementById("UTCDetailsGrid");
		var table_len=UTCTable.rows.length;
		var lastRow = UTCTable.rows[UTCTable.rows.length];
		var row = UTCTable.insertRow();
		var values=arrayRowValues.split("~");
		
		var j;
		var cell = row.insertCell(0);
		cell.innerHTML = "<input type='radio' name='selectRadio' id='selected"+table_len+"' value='row"+table_len+"' onclick='selectRow(this)' style='width:100%'>";
		for(j=2;j<values.length;j++)
		{
		
			var cell = row.insertCell(j-1);
			var ReplacedVal=values[j];
			ReplacedVal=ReplacedVal.replace(/&amp;/g,'&');
			ReplacedVal=ReplacedVal.replace(/&lt;/g,'<');
			ReplacedVal=ReplacedVal.replace(/&gt;/g,'>');
			ReplacedVal=ReplacedVal.replace(/&quot;/g,'"');
			ReplacedVal=ReplacedVal.replace(/&apos;/g,"'");
			ReplacedVal=ReplacedVal.replace(/&per;/g,"%");			
			ReplacedVal=ReplacedVal.replace(/&pipw;/g,"|");			
			cell.innerHTML =ReplacedVal;
			if(j>=9)
			{
				cell.style.display = 'none';
			}
		}
		if(CurrentWS !="CSO" && CurrentWS !="TF_Document_Approver" && CurrentWS !="TF_Maker")
		{
			document.getElementById('AddUTC').disabled='disabled';
			document.getElementById('ModifyUTC').disabled='disabled';
			document.getElementById('DeleteUTC').disabled='disabled';
			var arrayUTCRowValues=['DocumentNo','DocumentDate','UTC_Currency','TotalInvoiceAmount','BuyerName','SupplierName','LineItemsCount','BanRefNumber','ContractNo','PONumber','AmountInWords','PaymentDueDate','TermsofPayment','BillingAddress','Discount','TaxAmount','TaxNoSupplier','GrossAmount','SupplierAccountNo','SupplierAddressLine1','SupplierAddressLine2','SupplierAddressCity','SupplierAddressCountry','SupplierAddressPOBox','SupplierEmailAddress','SupplierWebsite','SupplierTelephone','BuyerTelephone','BuyerAccountNo','BuyerAddressLine1','BuyerAddressLine2','BuyerAddressCity','BuyerAddressCountry','BuyerAddressPOBox','BuyerEmailAddress','BuyerWebsite','LineItemDescription','HSCode','UnitPrice','SubtotalAmount','Quantity','LineNo','UOM'];
			for (var j=0;j<arrayUTCRowValues.length;j++) 
			{
			
				document.getElementById(arrayUTCRowValues[parseInt(j)]).disabled='disabled';

			}
		}

}

function addrowUTC(CurrentWS,buttonid,arrayRowValues)
{
	if(CurrentWS =="CSO" || CurrentWS =="TF_Document_Approver" || CurrentWS =="TF_Maker")
	{
		var arrayDisplayUTCRowValues=['DocumentNo','DocumentDate','UTC_Currency','TotalInvoiceAmount','BuyerName','SupplierName','LineItemsCount'];
		var j;
			for(j=0;j<arrayDisplayUTCRowValues.length;j++)
			{
				var val=document.getElementById(arrayDisplayUTCRowValues[(parseInt(j))]).value;
				if(val==''){
				alert(arrayDisplayUTCRowValues[(parseInt(j))] +' is mandatory, please Enter');
				document.getElementById(arrayDisplayUTCRowValues[(parseInt(j))]).focus();
				return false;
				}
			}

			var UTCTable=document.getElementById("UTCDetailsGrid");
			var table_len=UTCTable.rows.length;
			var lastRow = UTCTable.rows[UTCTable.rows.length];
			var row = UTCTable.insertRow();
			row.id="row"+table_len;
			var cell = row.insertCell(0);
		
			cell.innerHTML = "<input type='radio' name='selectRadio' id='selected"+table_len+"' value='row"+table_len+"' onclick='selectRow(this)' style='width:100%'>";
			
		var arrayUTCRowValues=['BanRefNumber','ContractNo','PONumber','AmountInWords','PaymentDueDate','TermsofPayment','BillingAddress','Discount','TaxAmount','TaxNoSupplier','GrossAmount','SupplierAccountNo','SupplierAddressLine1','SupplierAddressLine2','SupplierAddressCity','SupplierAddressCountry','SupplierAddressPOBox','SupplierEmailAddress','SupplierWebsite','SupplierTelephone','BuyerTelephone','BuyerAccountNo','BuyerAddressLine1','BuyerAddressLine2','BuyerAddressCity','BuyerAddressCountry','BuyerAddressPOBox','BuyerEmailAddress','BuyerWebsite','LineItemDescription','HSCode','UnitPrice','SubtotalAmount','Quantity','LineNo','UOM'];
		
			
			for(j=1;j<=arrayDisplayUTCRowValues.length;j++)
			{
				var cell = row.insertCell(j);
				//cell.id=arrayUTCRowValues[j-1]+table_len;
				cell.innerHTML =document.getElementById(arrayDisplayUTCRowValues[(parseInt(j)-1)]).value;
				document.getElementById(arrayDisplayUTCRowValues[(parseInt(j)-1)]).value='';			
			}
			var preLen=arrayDisplayUTCRowValues.length;
			 for(j=0;j<=arrayUTCRowValues.length-1;j++)
			 {
				var cell = row.insertCell(parseInt(preLen)+parseInt(j)+1);
				
				//cell.id=arrayUTCRowValues[j-1]+table_len;
				cell.innerHTML =document.getElementById(arrayUTCRowValues[(parseInt(j))]).value;
				document.getElementById(arrayUTCRowValues[(parseInt(j))]).value='';
				cell.style.display = 'none';
			 }
	}	 
}	 
function modifyrowUTC(CurrentWS)
{
	if(CurrentWS =="CSO" || CurrentWS =="TF_Document_Approver" || CurrentWS =="TF_Maker")
	{
		var utcSelectedRow = document.getElementById('utcSelectedRow').value;
		var table = document.getElementById("UTCDetailsGrid");
   
		var row = table.rows[utcSelectedRow];
		if(utcSelectedRow==''){
			alert('Please select the row to modify');
			return false;
		}
		
		var arrayDisplayUTCRowValues=['DocumentNo','DocumentDate','UTC_Currency','TotalInvoiceAmount','BuyerName','SupplierName','LineItemsCount'];
		var j;
		for(j=0;j<arrayDisplayUTCRowValues.length;j++)
		{
			var val=document.getElementById(arrayDisplayUTCRowValues[(parseInt(j))]).value;
			if(val==''){
			alert(arrayDisplayUTCRowValues[(parseInt(j))] +' is mandatory, please fill');
			document.getElementById(arrayDisplayUTCRowValues[(parseInt(j))]).focus(true);
			return false;
			}
		}  
		
											
		var arrayUTCRowValues=['DocumentNo','DocumentDate','UTC_Currency','TotalInvoiceAmount','BuyerName','SupplierName','LineItemsCount','BanRefNumber','ContractNo','PONumber','AmountInWords','PaymentDueDate','TermsofPayment','BillingAddress','Discount','TaxAmount','TaxNoSupplier','GrossAmount','SupplierAccountNo','SupplierAddressLine1','SupplierAddressLine2','SupplierAddressCity','SupplierAddressCountry','SupplierAddressPOBox','SupplierEmailAddress','SupplierWebsite','SupplierTelephone','BuyerTelephone','BuyerAccountNo','BuyerAddressLine1','BuyerAddressLine2','BuyerAddressCity','BuyerAddressCountry','BuyerAddressPOBox','BuyerEmailAddress','BuyerWebsite','LineItemDescription','HSCode','UnitPrice','SubtotalAmount','Quantity','LineNo','UOM'];
		for (var j=1;j<row.cells.length;j++) 
		{
			row.cells[j].innerHTML=document.getElementById(arrayUTCRowValues[parseInt(j)-1]).value;
			document.getElementById(arrayUTCRowValues[parseInt(j)-1]).value='';
		}
		
		document.getElementById('selected'+utcSelectedRow).checked = false;	
		document.getElementById('utcSelectedRow').value='';		
		
		
	}	
}
function deleteUTCRow()
{
	var utcSelectedRow = document.getElementById('utcSelectedRow').value;
	var table = document.getElementById("UTCDetailsGrid");
   	var row = table.rows[utcSelectedRow];
	var rowCount = table.rows.length;
	if(utcSelectedRow=='')
	{
		alert('Please select the row to delete');
		return false;
	}
	if(rowCount==2)
	{
		table.deleteRow(utcSelectedRow);
	}
	else if(utcSelectedRow==(rowCount-1))
	{
		table.deleteRow(utcSelectedRow);
	}
	else{
	//document.getElementById("UTCDetailsGrid").deleteRow(utcSelectedRow);
	var arrayUTCRowValues=['DocumentNo','DocumentDate','UTC_Currency','TotalInvoiceAmount','BuyerName','SupplierName','LineItemsCount','BanRefNumber','ContractNo','PONumber','AmountInWords','PaymentDueDate','TermsofPayment','BillingAddress','Discount','TaxAmount','TaxNoSupplier','GrossAmount','SupplierAccountNo','SupplierAddressLine1','SupplierAddressLine2','SupplierAddressCity','SupplierAddressCountry','SupplierAddressPOBox','SupplierEmailAddress','SupplierWebsite','SupplierTelephone','BuyerTelephone','BuyerAccountNo','BuyerAddressLine1','BuyerAddressLine2','BuyerAddressCity','BuyerAddressCountry','BuyerAddressPOBox','BuyerEmailAddress','BuyerWebsite','LineItemDescription','HSCode','UnitPrice','SubtotalAmount','Quantity','LineNo','UOM'];
		for(var k=0;k<arrayUTCRowValues.length;k++)
		{
			for (var j=utcSelectedRow;j<(rowCount-1);j++) 
			{
				row.cells[j].innerHTML=document.getElementById(arrayUTCRowValues[parseInt(j)-1]).value;
				document.getElementById(arrayUTCRowValues[parseInt(j)-1]).value='';
			
			}
		}
		table.deleteRow(utcSelectedRow);
	}
	document.getElementById("utcSelectedRow").value='';
	
		clearAllUTCFields();
	
}
function clearAllUTCFields()
{
	 var allUTCFields=['DocumentNo','DocumentDate','UTC_Currency','TotalInvoiceAmount','BuyerName','SupplierName','LineItemsCount','BanRefNumber','ContractNo','PONumber','AmountInWords','PaymentDueDate','TermsofPayment','BillingAddress','Discount','TaxAmount','TaxNoSupplier','GrossAmount','SupplierAccountNo','SupplierAddressLine1','SupplierAddressLine2','SupplierAddressCity','SupplierAddressCountry','SupplierAddressPOBox','SupplierEmailAddress','SupplierWebsite','SupplierTelephone','BuyerTelephone','BuyerAccountNo','BuyerAddressLine1','BuyerAddressLine2','BuyerAddressCity','BuyerAddressCountry','BuyerAddressPOBox','BuyerEmailAddress','BuyerWebsite','LineItemDescription','HSCode','UnitPrice','SubtotalAmount','Quantity','LineNo','UOM'];
	 for(var i=0;i<allUTCFields.length;i++)
	 {
		document.getElementById(allUTCFields[i]).value="";
	 } 
	 
}

