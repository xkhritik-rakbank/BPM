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
//if (strprocessname == 'SRB') 
//{    
	var closedFromCloseButton = '';
    
    var counthash = 0;
    var exception = false;
    var exceptionstring = '';
    var decisionsaved = 'Y';
  
	window.document.write("<script src=\"/SRB/webtop/scripts/SRB_Scripts/Validation_SRB.js\"></script>");
	window.document.write("<script src=\"/SRB/webtop/scripts/SRB_Scripts/Custom_Validation.js?13\"></script>");
	window.document.write("<script src=\"/SRB/webtop/scripts/SRB_Scripts/aes.js\"></script>");
	window.document.write("<script src=\"/SRB/webtop/scripts/SRB_Scripts/json3.min.js?123\"></script>");
	window.document.write("<script src=\"/SRB/webtop/scripts/SRB_Scripts/populateCustomValue.js\"></script>");
	window.document.write("<script src=\"/SRB/webtop/scripts/SRB_Scripts/calendar_SRB.js\"></script>");
	
//}
function DoneClick()
{
	//alert('Done click');
	var flag="D";
	if (strprocessname == 'SRB') 
	{
        return (validateOnInroduceClick(flag));
    } 
	else
    return true;
}

function SaveClick() 
{
	//alert('Save click');
	var flag="S";
	var customform = '';
    var formWindow = getWindowHandler(windowList, "formGrid");
    customform = formWindow.frames['customform'];
    var iframe = customform.document.getElementById("frmData");
    if (strprocessname == 'SRB') 
	{		
		return (validateOnInroduceClick(flag));	
		
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
    if (strprocessname == 'SRB') 
	{
		//Start - Saving queue variables value on introduction for slowness in filter added on 19012018
		var WSNAME = customform.document.getElementById("wdesk:WS_NAME").value;
		if (WSNAME=="CSO")
		{
			var solid = customform.document.getElementById("wdesk:SOLID").value;
			//	alert("solid"+solid);
			customform.document.getElementById("wdesk:q_SOLID").value= solid ;
			
			var doccollectionbranch= customform.document.getElementById("doccollectionbranch").value;
			//	alert("doccollectionbranch"+doccollectionbranch);
			customform.document.getElementById("wdesk:q_DocumentCollectionBranch").value= doccollectionbranch ;
			
			
			var ServiceRequestCode= customform.document.getElementById("wdesk:ServiceRequestCode").value;
			ServiceRequestCode= ServiceRequestCode.replace('SRB','').trim();
			//	alert("ServiceRequestCode"+ServiceRequestCode);
			customform.document.getElementById("wdesk:q_ServiceRequestCode").value= ServiceRequestCode ;
		}
		//End - Saving queue variables value on introduction for slowness in filter added on 19012018
		return (validateOnInroduceClick(flag));
		
		
    } 
	else
    return true;
}

function checkDuplicateWorkitems()
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
			var NameData=getNameData();
			var condition='';
			var arrayTRPARAM=TRPARAM.split('@');
			//Maiking condition for external table columns
			var arrayEXTPARM=EXTPARM.split('@');
			for(var i=0;i<arrayEXTPARM.length;i++)//Loop For TRPARAM
			{
					if(arrayEXTPARM[i].indexOf('date')!=-1||arrayEXTPARM[i].indexOf('Date')!=-1)
					{	
						condition='WHERE CONVERT(VARCHAR(10),EXT.'+arrayEXTPARM[i]+',103)='+"'"+customform.document.getElementById('wdesk:'+arrayEXTPARM[i]).value+"'";
					}
					else
					{
						condition=condition+' AND EXT.'+arrayEXTPARM[i]+'='+"'"+customform.document.getElementById('wdesk:'+arrayEXTPARM[i]).value+"'";
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
							break;
						}
				   }
			}
			//*********************************************************************** 
			var xhr;
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");

			var url = "/SRB/CustomForms/SRB_Specific/getDuplicateWorkitems.jsp";
			var param = "WI_NAME=" + ProcessInstanceId+"&WSNAME="+WSNAME+"&CategoryID=" + CategoryID+"&SubCategoryID="+SubCategoryID+"&condition="+condition+"&tr_table="+tr_table;
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
						callInsertDuplicateWorkitems();
						return true;
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
	var NameData=getNameData();
	var condition='';
	
	//Maiking condition for external table columns
	var arrayEXTPARM=EXTPARM.split('@');
	for(var i=0;i<arrayEXTPARM.length;i++)//Loop For EXTPARM
	{
			if(arrayEXTPARM[i].indexOf('date')!=-1||arrayEXTPARM[i].indexOf('Date')!=-1)
			{	
				condition='WHERE CONVERT(VARCHAR(10),EXT.'+arrayEXTPARM[i]+',103)='+"'"+customform.document.getElementById('wdesk:'+arrayEXTPARM[i]).value+"'";
			}
			else
			{
				condition=condition+' AND EXT.'+arrayEXTPARM[i]+'='+"'"+customform.document.getElementById('wdesk:'+arrayEXTPARM[i]).value+"'";
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
	var xhr;
	if (window.XMLHttpRequest)
		xhr = new XMLHttpRequest();
	else if (window.ActiveXObject)
		xhr = new ActiveXObject("Microsoft.XMLHTTP");

	var url = "/SRB/CustomForms/SRB_Specific/getDuplicateWorkitems.jsp";
	var param = "WI_NAME=" + ProcessInstanceId+"&WSNAME="+WSNAME+"&CategoryID=" + CategoryID+"&SubCategoryID="+SubCategoryID+"&condition="+condition+"&tr_table="+tr_table;
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
				callInsertDuplicateWorkitems();
				return true;
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
function validateOnInroduceClick(flag) 
{
	var customform = '';
	var formWindow = getWindowHandler(windowList, "formGrid");
	customform = formWindow.frames['customform'];
	var iframe = customform.document.getElementById("frmData");
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	var subCategory=customform.document.getElementById("SubCategory").value;
	/*var cifId=customform.document.getElementById("wdesk:CifId").value;
	if(cifId=='')
	{
		alert("Please click the search button and select the CIF Id.");
		customform.document.getElementById("Fetch").focus();
		return false;
	}*/
	//var SubCategoryID = iframeDocument.getElementById("SubCategoryID").value;
	//var CategoryID = iframeDocument.getElementById("CategoryID").value;
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
				if (WSNAME == 'Q6')
				{
					customform.document.getElementById("wdesk:DocumentCollectionBranch").value = customform.document.getElementById("ExistingDocCollBranch").value;
				}				
				var isSaveSuccess = saveSRBData(false, "custom", customform);
			}else{
				var isSaveSuccess = saveSRBData(true, "custom", customform);
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
			
			// Setting flag for doc attachment
			if (!AttachedDocTypeCheck("Proof_Of_Address_And_Physical_Location")) {
				customform.document.getElementById('wdesk:isDoc_POA_Attached').value = 'N';
			}
			else {
				customform.document.getElementById('wdesk:isDoc_POA_Attached').value = 'Y';
			}
			
			if (!AttachedDocTypeCheck("KYC_RiskScore_KYCAnnexture_PEPForm")) {
				customform.document.getElementById('wdesk:isDoc_KYC_Risk_PEP_Attached').value = 'N';
			}
			else {
				customform.document.getElementById('wdesk:isDoc_KYC_Risk_PEP_Attached').value = 'Y';
			}
			
			if (!AttachedDocTypeCheck("DormancyForm_BankStatement_Contracts_Invoices")) {
				customform.document.getElementById('wdesk:isDoc_Dormancy_BankStmt_Contract_Invoices_Attached').value = 'N';
			}
			else {
				customform.document.getElementById('wdesk:isDoc_Dormancy_BankStmt_Contract_Invoices_Attached').value = 'Y';
			}
			///////////////////////////////////////////
			
			
          if(flag=="I"||flag=="D")
			{
				// added by ankit 30042018
				if(WSNAME=="CSO")
				{
					setArchivalPathForLoan();
					var subCatCode=customform.document.getElementById("wdesk:ServiceRequestCode").value;
					var transInSus=customform.document.getElementById("isTransInSusAccount").value;
					var currencySelected=customform.document.getElementById("currencySelected").value;
					if(transInSus=="Yes" && currencySelected!=="AED")
					{
						alert("Only AED currency is allowed when the Transaction in Suspended Account is selected as Yes");
						return false;
					}
				}
				
				// added by ankit 30042018
				
				if(WSNAME=="CSO" && customform.document.getElementById("DubplicateWorkitemVisible").value=='Y')
				{
					if(customform.document.getElementById("DuplicateCheckLogic").value!='')
					{
						//Code for checking that service request has grid or not
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
							if(checkDuplicateWorkitemsForGrid())
							{
								alert("The request has been submitted successfully.");	
								return true;
							}
							else
							{
								return false;
							}
						}
						else
						{
							//Service request has not grid
							if(checkDuplicateWorkitems())
							{
								alert("The request has been submitted successfully.");	
								return true;	
							}
							else
							{
								return false;
							}
						}
					}
					else
					{
						alert("Duplicate flag is active for this service request but duplicate logic is not maintained.");
						return false;
					}
				}
				
				// increasing MultipleApprovalCount just before done added by Angad on 01102018
				var isMultipleApprovalReq = customform.document.getElementById("wdesk:isMultipleApprovalReq").value;
				if ((WSNAME == 'Q4' || WSNAME == 'Q12' || WSNAME == 'Q18' || WSNAME == 'Q21' || WSNAME == 'Q24') && isMultipleApprovalReq=='Y') // All Checker
				{
					if(customform.document.getElementById("selectDecision").value=='Activity Verified')
					{
						
						var existApprovalCount = customform.document.getElementById("wdesk:MultipleApprovalCount").value;
											
						if (existApprovalCount=='' || existApprovalCount=='NULL' || existApprovalCount=='null')
							existApprovalCount=0;	
						
						var NoOfApprovalRequired = customform.document.getElementById("wdesk:NoOfApprovalRequired").value;	
						if(parseInt(NoOfApprovalRequired) == (parseInt(existApprovalCount)+1))
						{
							alert("Decision cannot be taken as Activity Verified as it reached Final Iteration "+(parseInt(existApprovalCount)+1));
							customform.document.getElementById("selectDecision").focus();
							return false;
						}						
						
						customform.document.getElementById("wdesk:MultipleApprovalCount").value = parseInt(existApprovalCount)+1;
					}
				}
				//********************************************************
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

//added by ankit for setting archival path for loan service
function setArchivalPathForLoan()
{
	var producttype=''; //get producttype id based on the subcategory
	var AgreementNumber='';
	
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
			else if(myname.indexOf("ProductType") != -1)
			{
				//***********************************************************************************************
				producttype = iframeDocument.getElementById(myname).options.value;
				customform.document.getElementById("wdesk:LoanProductType").value = producttype;
				
			}
			else if(myname.indexOf("AgreementNumber") != -1)
			{
				AgreementNumber = iframeDocument.getElementById(myname).options.value;
				customform.document.getElementById("wdesk:AgreementNumber").value = AgreementNumber;	
			}
		}
	}
	catch (err) 
	{
		return "exception";
	}
	
	if(customform.document.getElementById('wdesk:ROUTECATEGORY').value == 'LoanServices')
	{
		if(producttype == 'Auto')
		{
			customform.document.getElementById("wdesk:ARCHIVALPATH").value='CreditOperation\\AutoLoan\\Approved\\Additional\\&<WI_NAME>&';
			customform.document.getElementById("wdesk:ARCHIVALPATHREJECT").value='CreditOperation\\AutoLoan\\Approved\\Additional\\Rejected\\&<WI_NAME>&';
		}
		else if(producttype == 'Personal')
		{
			customform.document.getElementById("wdesk:ARCHIVALPATH").value='CreditOperation\\PersonalLoan\\Approved\\Additional\\&<WI_NAME>&';
			customform.document.getElementById("wdesk:ARCHIVALPATHREJECT").value='CreditOperation\\PersonalLoan\\Approved\\Additional\\Rejected\\&<WI_NAME>&';
		}
		else if(producttype == 'RAKFINANCE')
		{
			customform.document.getElementById("wdesk:ARCHIVALPATH").value='CreditOperation\\RakFinance\\Approved\\Additional\\&<WI_NAME>&';
			customform.document.getElementById("wdesk:ARCHIVALPATHREJECT").value='CreditOperation\\RakFinance\\Approved\\Additional\\Rejected\\&<WI_NAME>&';
		}
		else if(producttype == 'Mortgage')
		{
			customform.document.getElementById("wdesk:ARCHIVALPATH").value='CreditOperation\\MortgageLoan\\Approved\\Additional\\&<WI_NAME>&';
			customform.document.getElementById("wdesk:ARCHIVALPATHREJECT").value='CreditOperation\\MortgageLoan\\Approved\\Additional\\Rejected\\&<WI_NAME>&';
		}
	}
}

//function added by shamily to fetch subCategorycode
function fetchSubCatCode()
{
	var reqType = 'fetchSubCatCode';
	var  SubCategoryName = customform.document.getElementById("SubCategory").value;
	var wi_name = customform.document.getElementById("wdesk:WI_NAME").value;
	var xhr;
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");

			var url = "/SRB/CustomForms/SRB_Specific/HandleAjaxProcedures.jsp";
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
	//var  SubCategoryName = customform.document.getElementById("SubCategory").value;
	var wi_name = customform.document.getElementById("wdesk:WI_NAME").value;
	var ws_name = customform.document.getElementById("wdesk:WS_NAME").value;
	var xhr;
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");

			var url = "/SRB/CustomForms/SRB_Specific/HandleAjaxProcedures.jsp";
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

function saveSRBData(IsDoneClicked,donefrm,fobj)
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
		var cifId=customform.document.getElementById("wdesk:CifId").value;
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
			var emirateexpdate=customform.document.getElementById("wdesk:EmratesIDExpDate").value;
			var NameData=getNameData();
			var applicationDate=customform.document.getElementById("wdesk:ApplicationDate").value;
			if(applicationDate=='' && customform.document.getElementById("selectDecision").value!='Reject')
			{
				alert("Please enter application date.");
				//customform.document.getElementById("wdesk:ApplicationDate").focus();
				return false;
			}
			if(customform.document.getElementById("wdesk:CifId").value==""  && customform.document.getElementById("selectDecision").value!='Reject') //decision condition added by shamily to not pop up alert when decision reject
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
				if(customform.document.getElementById("wdesk:WS_NAME").value =='CSO')
				{
					if(!ValidateGridInSRB())
						return false;
				}
			}
			
			if(!Validate(NameData, iframeDocument, "Y"))
			{
			  return false;
			}
			if(myTrim(customform.document.getElementById("selectDecision").value)=="--Select--" || myTrim(customform.document.getElementById("selectDecision").value)=="" || myTrim(customform.document.getElementById("selectDecision").value)=="NULL" || myTrim(customform.document.getElementById("selectDecision").value)=="null")
			{
				alert("Please select decision.");
				customform.document.getElementById("selectDecision").focus();
				return false;
			}
			if(myTrim(customform.document.getElementById("wdesk:Decision").value)=="--Select--" || myTrim(customform.document.getElementById("wdesk:Decision").value)=="" || myTrim(customform.document.getElementById("wdesk:Decision").value)=="NULL" || myTrim(customform.document.getElementById("wdesk:Decision").value)=="null")
			{
				alert("Please select decision");
				customform.document.getElementById("selectDecision").focus();
				return false;
			}
			if(customform.document.getElementById("selectDecision").value=='Reject'||customform.document.getElementById("selectDecision").value=='Reject to CSO'||customform.document.getElementById("selectDecision").value=='Reject to OPS'||customform.document.getElementById("selectDecision").value=='Reject to Card Settlement'||customform.document.getElementById("selectDecision").value=='Reject to Card Maker')
            {
				if(customform.document.getElementById('rejReasonCodes').value=='' || customform.document.getElementById('rejReasonCodes').value=='NO_CHANGE')
				{
				  alert("Please provide reject reason.");
				  customform.document.getElementById('RejectReason').focus(true);
				  return false;
				}
			}
			
			if(customform.document.getElementById('rejReasonCodes').value!='' && customform.document.getElementById('rejReasonCodes').value!='NO_CHANGE'){
				if(customform.document.getElementById("selectDecision").value!='Reject' && customform.document.getElementById("selectDecision").value!='Reject to CSO' && customform.document.getElementById("selectDecision").value!='Reject to OPS' && customform.document.getElementById("selectDecision").value!='Reject to Card Settlement' && customform.document.getElementById("selectDecision").value!='Reject to Card Maker')
				{
					alert("Reject Reasons are selected, Please select appropriate decision.");
					return false;
				}
			}
			if(customform.document.getElementById("wdesk:WS_NAME").value =='CSO')
			{
				if(customform.document.getElementById("selectDecision").value=='Approve')
				{
					// commented by ankit on 19062017 to remove mandatory checks for mode of delivery
					if(customform.document.getElementById("wdesk:printDispatchRequired").value=='Y')//Will run only when printdispatch is Y
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
						  /*if(flag=='false')
						  {
							alert("Please select mode of delivery");
							customform.document.getElementById("modeofdelivery").focus();
							return false;
						  }*/
						  
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
							}
							/*if(selectedValues=='Email')
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
							return false;*/
							
							// Start - Courier mode of delivery cannot be select for Digital Banking Services CR added on 10102017
							if(selectedValues=='Courier' || selectedValues=='Courier&Branch' || selectedValues=='Branch&Courier')
							{
								var SRCode = customform.document.getElementById("wdesk:ServiceRequestCode").value;
								//if (SRCode == 'SRB053' || SRCode == 'SRB054' || SRCode == 'SRB055') {
								if (SRCode == 'SRB054') {
									alert("Mode of Delivery-Courier is not applicable for this Service Request");
									return false;
								}
							}
							// End - Courier mode of delivery cannot be select for Digital Banking Services CR added on 10102017
							
							// validation applied - multiple mode of delivery cannot be selected - 09092019
							if (selectedValues.indexOf('&') != -1)
							{
								alert("Multiple Mode of Delivery cannot be selected, Kindly select any one mode.");
								return false;
							}
							if(selectedValues == 'Courier Authorised Person')
							{
								if (myTrim(customform.document.getElementById("wdesk:AuthorizedPersonName").value) == '')
								{
									alert("Please Enter Authorized Person Name.");
									customform.document.getElementById("wdesk:AuthorizedPersonName").focus(true);
									return false;
								}
								if (myTrim(customform.document.getElementById("wdesk:AuthorizedPersonMobNumber").value) == '')
								{
									alert("Please Enter Authorized Person Mobile Number.");
									customform.document.getElementById("wdesk:AuthorizedPersonMobNumber").focus(true);
									return false;
								}
								if (myTrim(customform.document.getElementById("wdesk:AuthorizedPersonEmid").value) == '')
								{
									alert("Please Enter Authorized Person Emirates ID.");
									customform.document.getElementById("wdesk:AuthorizedPersonEmid").focus(true);
									return false;
								}
							}
							//*******************************************************
							
							customform.document.getElementById("wdesk:ModeOfDelivery").value=selectedValues;
					}
					// commented by ankit ends on 19062017 to remove mandatory checks for mode of delivery
					if(customform.document.getElementById("DeferralWaiverHeldCombo").value=='')
					{
						alert("Please select  Deferral/Waiver Held.");
						customform.document.getElementById("DeferralWaiverHeldCombo").focus();
						return false;
					}
					//After sign off CR 11-04-2017
					
					if(customform.document.getElementById("WaiverHeldCombo").value==''||customform.document.getElementById("WaiverHeldCombo").value==null)
					{
						alert("Please select Waiver Held.");
						customform.document.getElementById("WaiverHeldCombo").focus();
						return false;
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
					
					
					if(customform.document.getElementById("wdesk:DocumentTypeWaivered").value==''||customform.document.getElementById("wdesk:DocumentTypeWaivered").value==null)
					{
						if(customform.document.getElementById("WaiverHeldCombo").value=='Y')
						{
						alert("Document Type Waivered is mandatory to fill");
						customform.document.getElementById("wdesk:DocumentTypeWaivered").focus();
						return false;
						}
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
					if(customform.document.getElementById("wdesk:ApprovingAuthorityWaiver").value==''||customform.document.getElementById("wdesk:ApprovingAuthorityWaiver").value==null)
					{
						if(customform.document.getElementById("WaiverHeldCombo").value=='Y')
						{
						alert("Approving Authority(Name) for Waiver is mandatory to fill");
						customform.document.getElementById("wdesk:ApprovingAuthorityWaiver").focus();
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
					//added by shamily to save DeferralWaiverHeld dropdown value  in db
					
					customform.document.getElementById("wdesk:DeferralWaiverHeld").value=customform.document.getElementById("DeferralWaiverHeldCombo").value;
					
					// emirates id expiry date not checking for police letter request_ change on BAT _ 17072017
					var isEMIDExpiryChkReq = customform.document.getElementById("isEMIDExpiryChkReq").value;
					if(customform.document.getElementById("wdesk:EmratesIDExpDate").value!='' && customform.document.getElementById("wdesk:CIFTYPE").value=='Individual' && isEMIDExpiryChkReq == 'Y')
					{
						if(customform.document.getElementById("DeferralWaiverHeldCombo").value!='Y')
						{
							if(!validateExpiryDate(customform.document.getElementById("wdesk:EmratesIDExpDate").value,'EmratesIDExpDate'))
							{
							
								return false;
							}
						}	
						else
						{
							var idname=document.getElementById("wdesk:docCombo").innerHTML;		
							var getMandatoryDocs = iframeDocument.getElementById("mandatoryDocs").value;
							if(getMandatoryDocs!="")
							{
								if (getMandatoryDocs.indexOf("Emirates_ID")!=-1)
								{
									// nothing to do as mandatory check is already done below
								}
							}
							else 
							{
								var r = confirm("Please update the Emirates ID!Do you want to process the case?");
								if (r == false) 
								{
									return false;
								} 
							}
						}		
					}
					
					else if (customform.document.getElementById("wdesk:TLIDExpDate").value!='' && customform.document.getElementById("wdesk:CIFTYPE").value=='Non-Individual' && isEMIDExpiryChkReq == 'Y')
					{
						if(customform.document.getElementById("DeferralWaiverHeldCombo").value!='Y')
						{
							if(!validateExpiryDate(customform.document.getElementById("wdesk:TLIDExpDate").value,'TLIDExpDate'))
							{
								return false;
							}
						}	
					
					}
					
					
					if(customform.document.getElementById("DeferralWaiverHeldCombo").value=='Y')
					{
						if(customform.document.getElementById("wdesk:DeferralExpiryDate").value=='')
						{
							alert("Please select Deferral Expiry Date.");
							customform.document.getElementById("wdesk:DeferralExpiryDate").focus();
							return false;
						}	
							
						if(customform.document.getElementById("wdesk:ApprovingAuthority").value=='')
						{
							alert("Please enter Approving Authority.");
							customform.document.getElementById("wdesk:ApprovingAuthority").disabled=false;
							customform.document.getElementById("wdesk:ApprovingAuthority").focus();
							return false;
						}					
					}
					// checking mandatory document to be attached for Service Request	
					if (customform.document.getElementById("wdesk:CIFTYPE").value=='Individual')
					{
						//if(customform.document.getElementById("DeferralWaiverHeldCombo").value!='Y')
						//{
							var getMandatoryDocs = iframeDocument.getElementById("mandatoryDocs").value;
							//if (customform.document.getElementById("wdesk:ResidentCountry").value=='AE')
							//{
								//Confirmation dialog if emid number is blank on form wdesk:EmiratesIDHeader
								if(customform.document.getElementById("wdesk:EmiratesIDHeader").value=='')
								{
									confirm("EID is not updated in the records");
								}
								//****************************************************************
								if(getMandatoryDocs!="")
								if(!AttachedDocType(getMandatoryDocs,true))
								return false;
								customform.document.getElementById("wdesk:DeferralWaiverHeld").value=customform.document.getElementById("DeferralWaiverHeldCombo").value;
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
					}
					
					// Condition added to validate mandatory doc attachment for Non Individual cases for SRB173
					if(customform.document.getElementById("wdesk:ServiceRequestCode").value == 'SRB173')
					{
						var getMandatoryDocs = iframeDocument.getElementById("mandatoryDocs").value;
						if(getMandatoryDocs!="")
							if(!AttachedDocType(getMandatoryDocs,true))
								return false;
					}
					
					// function call to check stale restriction days added by angad on 19032018
					if (checkStaleDatedRequest() == false) 
						return false;
					
					// Setting IslamicConventional field for LoanServices added on 14052018
					if (customform.document.getElementById("wdesk:ROUTECATEGORY").value=='LoanServices')
						document.getElementById('customform').contentWindow.islamicval();
					//***************************************************	
				}				
			}
			
			if(WSNAME=="Q4")//OPS Checker
			{
				//commented by shamily for BAT_SRB CR point 12
				/*if(remarks=='' && customform.document.getElementById("selectDecision").value!='Approve') //Condition modified by shamily to pop up alert in case of reject cases only 
				{
					alert("Remarks are mandatory to fill at OPS Checker queue");  //Alert Corrected by shamily
					customform.document.getElementById("remarks").focus();
					return false;
				}
				else 
				*/
				// added by shamily for BAT_SRB CR point 12
				if(remarks=='' && customform.document.getElementById("rejReasonCodes").value.indexOf('199')!=-1) //Condition modified by shamily to pop up alert in case of reject cases only 
				{
					alert("Remarks are mandatory for reject reasons as Others");  //Alert Corrected by shamily
					customform.document.getElementById("remarks").focus();
					return false;
				}
				
				// Drop 2 point 79 and 80
				if(customform.document.getElementById("selectDecision").value=='Reject to Maker' || customform.document.getElementById("selectDecision").value=='Reject to CSO'){
					customform.document.getElementById("wdesk:OPSMakerRejectFlag").value ='Y';
				}
				
				if(customform.document.getElementById("selectDecision").value=='Approve - Sign Verified' || customform.document.getElementById("selectDecision").value=='Approve')
				{
					if(customform.document.getElementById("flagForDecHisButton").value!='Yes' && fetchOpsmaker_remarks()!="" && fetchOpsmaker_remarks() != null)
					{
						alert('Please Click the decision history table');
						return false;
					}
					
					// applied condition for some request type for not to check sign match_ 17072017
					var ServiceRequestCode = customform.document.getElementById("wdesk:ServiceRequestCode").value;
					//if (ServiceRequestCode != 'SRB040' && ServiceRequestCode != 'SRB044' && ServiceRequestCode != 'SRB043' && ServiceRequestCode != 'SRB007' && ServiceRequestCode != 'SRB012' && ServiceRequestCode != 'SRB021' && ServiceRequestCode != 'SRB010' && ServiceRequestCode != 'SRB035' && ServiceRequestCode != 'SRB056'&& ServiceRequestCode != 'SRB057' && ServiceRequestCode != 'SRB058' && ServiceRequestCode != 'SRB046' && ServiceRequestCode != 'SRB047')
					var isSignVerifyAtOPSMand= getIsSignVerifyReqFromSubCatMaster(); // taken from SubCategory master
					if(isSignVerifyAtOPSMand == 'Y' || isSignVerifyAtOPSMand == 'C') // C Means at Checker only, Y means maker checker both
					{
						if(customform.document.getElementById("wdesk:sign_matched_checker").value=='')
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
						}
					}
					
					// validating multiple Approval required data added by Angad on 01102018
					if (validateNoOfApprovalRequired(WSNAME) == false)
						return false;
					
					//ProcessedDateAtChecker field at OPS Checker on 23072017 -- setting current date and time
					if (customform.document.getElementById("wdesk:ProcessedDateAtChecker").value == '' || customform.document.getElementById("wdesk:ProcessedDateAtChecker").value == null)
					{
						var d = new Date();
						var today = formatDate(d,5);
						customform.document.getElementById("wdesk:ProcessedDateAtChecker").value = today;						
					} 
				}
				else if(customform.document.getElementById("selectDecision").value=='Hold' && customform.document.getElementById("wdesk:HoldTillDate").value=='')
				{
					alert("Please select Hold Till Date while selecting 'Hold' as decision");
					customform.document.getElementById("wdesk:HoldTillDate").focus();
					return false;
				}
			}
			//added by badri to make remarks mandatory if reject reason others	
			if(WSNAME == "Q2" ||WSNAME == "Q11" || WSNAME == "Q12" || WSNAME == "Q17" || WSNAME == "Q18" || WSNAME == "Q20" || WSNAME == "Q21")
			{
			if(remarks=='' && customform.document.getElementById("rejReasonCodes").value.indexOf('199')!=-1) //Condition modified by shamily to pop up alert in case of reject cases only 
				{
					alert("Remarks are mandatory for reject reasons as Others");  //Alert Corrected by shamily
					customform.document.getElementById("remarks").focus();
					return false;
				}
			}
			
			
			if(WSNAME == "Q12" || WSNAME == "Q18" || WSNAME == "Q21" || WSNAME == "Q24")
			{
				if(customform.document.getElementById("selectDecision").value=='Approve')
				{
					// validating multiple Approval required data added by Angad on 01102018
					if (validateNoOfApprovalRequired(WSNAME) == false)
						return false;
						
					var isSignVerifyAtOPSMand= getIsSignVerifyReqFromSubCatMaster(); // taken from SubCategory master
					if(isSignVerifyAtOPSMand == 'Y' || isSignVerifyAtOPSMand == 'C') // C Means at Checker only, Y means maker checker both
					{
						if(customform.document.getElementById("wdesk:sign_matched_checker").value=='')
						{
							alert("Please verify signatures while selecting 'Approve'");
							customform.document.getElementById("viewSign").focus();
							return false;
						}
						else if(customform.document.getElementById("wdesk:sign_matched_maker").value!='' && customform.document.getElementById("wdesk:sign_matched_checker").value == 'No')
						{
							alert("Signatures should be matched before selecting 'Approve'");
							customform.document.getElementById("viewSign").focus();
							return false;
						}
					}
					
					//ProcessedDateAtChecker field at Checker on 21032018 -- setting current date and time
					if (customform.document.getElementById("wdesk:ProcessedDateAtChecker").value == '' || customform.document.getElementById("wdesk:ProcessedDateAtChecker").value == null)
					{
						var d = new Date();
						var today = formatDate(d,5);
						customform.document.getElementById("wdesk:ProcessedDateAtChecker").value = today;						
					} 
					
				}
					
			}

     	if(WSNAME == "Q11" || WSNAME == "Q17" || WSNAME == "Q20")
			{
				if(customform.document.getElementById("selectDecision").value=='Approve')
				{
					// validating multiple Approval required data added by Angad on 01102018
					if (validateNoOfApprovalRequired(WSNAME) == false)
						return false;
						
					var isSignVerifyAtOPSMand= getIsSignVerifyReqFromSubCatMaster(); // taken from SubCategory master
					if(isSignVerifyAtOPSMand == 'Y' || isSignVerifyAtOPSMand == 'M') // M Means at Maker only, Y means maker checker both
					{
						if(customform.document.getElementById("wdesk:sign_matched_maker").value=='')
						{
							alert("Please verify signatures while selecting 'Approve");
							customform.document.getElementById("viewSign").focus();
							return false;
						}
						else if(customform.document.getElementById("wdesk:sign_matched_maker").value!='' && customform.document.getElementById("wdesk:sign_matched_maker").value == 'No')
						{
							alert("Signatures should be matched before selecting 'Approve");
							customform.document.getElementById("viewSign").focus();
							return false;
						}
					}
					
				}
					
			}	
				//Added by Badri to for Hold till date validation for loan service maker and checker			
				if(WSNAME=='Q23')
				{
					if(customform.document.getElementById("selectDecision").value=='Hold' && customform.document.getElementById("wdesk:HoldTillDate").value=='')
							{
								alert("Please select Hold Till Date while selecting 'Hold' as decision");
								customform.document.getElementById("wdesk:HoldTillDate").focus();
								return false;
							}
					
					/*if(customform.document.getElementById("selectDecision").value!='Islamic / Conventional category changed')
					{
						if(customform.document.getElementById("wdesk:IslamicConvention").value != customform.document.getElementById("islamic_conventional").value)
						{
							alert("Please select 'Islamic / Conventional category changed' as decision");
							customform.document.getElementById("selectDecision").focus();
							return false;
						}
					}
					else if(customform.document.getElementById("selectDecision").value=='Islamic / Conventional category changed' && customform.document.getElementById("wdesk:IslamicConvention").value == customform.document.getElementById("islamic_conventional").value)
					{
						alert("Please modify value of Islamic field if not changed");
							return false;
					}*/		
		
				}
				if(WSNAME=='Q24')
				{
		
					if(customform.document.getElementById("selectDecision").value=='Hold' && customform.document.getElementById("wdesk:HoldTillDate").value=='')
					{
						alert("Please select Hold Till Date while selecting 'Hold' as decision");
						customform.document.getElementById("wdesk:HoldTillDate").focus();
						return false;
					}
								
				}			
			
			
			if(WSNAME=="Q2")//OPS Maker
			{
				if(customform.document.getElementById("wdesk:printDispatchRequired").value=='Y')//Will run only when printdispatch is Y
				{
				  if(customform.document.getElementById("selectDecision").value=='Approve - Sign Verified' || customform.document.getElementById("selectDecision").value=='Approve')
					{
							if(selectedValues=='Branch&Email'||selectedValues=='Branch')
							{
								if(customform.document.getElementById("branchDeliveryMethod").value=="--Select--")
								{
									alert("Branch Delivery Method is mandatory to fill");
									customform.document.getElementById("branchDeliveryMethod").disabled=false;
									customform.document.getElementById("branchDeliveryMethod").focus();
									return false;
								}
								if(customform.document.getElementById("branchDeliveryMethod").value=="Attachment")
								{
									if(!AttachedDocType('Deliverables',true))
									return false;
								}
							}
							else if(selectedValues=='Email')
							{
							   if(!AttachedDocType('Deliverables',true))
								return false;
							}
							/*else if(selectedValues=='Courier' || selectedValues=='Courier&Email'||selectedValues=='Email&Courier')
							{
								if(customform.document.getElementById("wdesk:CourierAWBNumber").value==''||
								customform.document.getElementById("wdesk:CourierAWBNumber").value==null)
								{
									alert("Courier AWB Number is mandatory to fill");
									customform.document.getElementById("wdesk:CourierAWBNumber").disabled=false;
									customform.document.getElementById("wdesk:CourierAWBNumber").focus();
									return false;
								}
							}*/
					}
					
					//Added by Nikita for SRB CR 03042018 Start
					// below validation removed on 07082018 - as confirmed by Aishwarya
					/*if(customform.document.getElementById("selectDecision").value=='Approve - Sign Verified' || customform.document.getElementById("selectDecision").value=='Approve')
					{
						 if(selectedValues=='Courier')
						 {
						 if(customform.document.getElementById("wdesk:CourierAWBNumber").value==''||
								customform.document.getElementById("wdesk:CourierAWBNumber").value==null){
						 alert("Courier AWB Number is mandatory to enter");
						 customform.document.getElementById("wdesk:CourierAWBNumber").disabled=false;
						 customform.document.getElementById("wdesk:CourierAWBNumber").focus();
						 return false;}
						 
						 }
					}*/
					//Added by Nikita for SRB CR 03042018 End
				}
				//added by shamily for BAT_SRB CR point 22
				// below validation removed on 07082018 - as confirmed by Aishwarya
				 /*if((customform.document.getElementById("wdesk:CourierCompName").value==''|| customform.document.getElementById("wdesk:CourierCompName").value==null) && customform.document.getElementById("wdesk:CourierAWBNumber").value!='' && customform.document.getElementById("wdesk:CourierAWBNumber").value!=null)
				{
					alert("Please enter Courier Company name");
					customform.document.getElementById("wdesk:CourierCompName").disabled=false;
					customform.document.getElementById("wdesk:CourierCompName").focus();
					return false;
				}*/
				if(customform.document.getElementById("selectDecision").value=='Hold' && customform.document.getElementById("wdesk:HoldTillDate").value=='')
				{
					alert("Please select Hold Till Date while selecting 'Hold' as decision");
					customform.document.getElementById("wdesk:HoldTillDate").focus();
					return false;
				}
				else if(customform.document.getElementById("selectDecision").value=='Approve - Sign Verified' || customform.document.getElementById("selectDecision").value=='Approve')
				{
					// applied condition for some request type for not to check sign match_ 17072017
					var ServiceRequestCode = customform.document.getElementById("wdesk:ServiceRequestCode").value;
					//if (ServiceRequestCode != 'SRB040' && ServiceRequestCode != 'SRB044' && ServiceRequestCode != 'SRB043' && ServiceRequestCode != 'SRB007' && ServiceRequestCode != 'SRB012' && ServiceRequestCode != 'SRB021' && ServiceRequestCode != 'SRB010' && ServiceRequestCode != 'SRB035' && ServiceRequestCode != 'SRB056'&& ServiceRequestCode != 'SRB057' && ServiceRequestCode != 'SRB058' && ServiceRequestCode != 'SRB046' && ServiceRequestCode != 'SRB047')
					
					// validating multiple Approval required data added by Angad on 01102018
					if (validateNoOfApprovalRequired(WSNAME) == false)
						return false;
					
					var isSignVerifyAtOPSMand= getIsSignVerifyReqFromSubCatMaster(); // taken from SubCategory master
					if(isSignVerifyAtOPSMand == 'Y' || isSignVerifyAtOPSMand == 'M') // M Means at Maker only, Y means maker checker both
					{
						if(customform.document.getElementById("wdesk:sign_matched_maker").value=='')
						{
							alert("Please verify signatures while selecting 'Approve' as decision");
							customform.document.getElementById("viewSign").focus();
							return false;
						}
						else if(customform.document.getElementById("wdesk:sign_matched_maker").value!='' && customform.document.getElementById("wdesk:sign_matched_maker").value == 'No')
						{
							alert("Signatures should be matched before selecting 'Approve' as decision");
							customform.document.getElementById("viewSign").focus();
							return false;
						}
					}
				}
				// Drop 2 point 79 and 80
				else if(customform.document.getElementById("selectDecision").value=='Reject to CSO'){
					customform.document.getElementById("wdesk:OPSMakerRejectFlag").value ='Y';
				}
				//added by shamily for fetching OPSMAker username drop 2 point 71
				var OPSMakerUser = customform.document.getElementById("loggedinuser").innerHTML;
				OPSMakerUser = OPSMakerUser.replace('<B>&nbsp;&nbsp;','');
				OPSMakerUser = OPSMakerUser.replace('</B>','');
				
				customform.document.getElementById("wdesk:OPSMakerUser").value =  OPSMakerUser;
				
			}
						
			// Start - Sending SMS
			if(WSNAME=="Q3") {
				if(customform.document.getElementById("selectDecision").value=='Information Required from Customer' || customform.document.getElementById("selectDecision").value=='Reject')
				{
					document.getElementById('customform').contentWindow.sendSMS();
					//alert("SMS sent Q3");
				}
			} else if(WSNAME=="Q4") {
				//condition removed by ankit to suppress the sms in case of 'Reject to CSO' decision  || customform.document.getElementById("selectDecision").value=='Reject to CSO')
				if(customform.document.getElementById("wdesk:ROUTECATEGORY").value=='OPS' || customform.document.getElementById("wdesk:ROUTECATEGORY").value=='CardSettlement2OPS')
				{
					if(customform.document.getElementById("selectDecision").value=='Approve - Sign Verified' || customform.document.getElementById("selectDecision").value=='Approve')
					{
						if((customform.document.getElementById("wdesk:ServiceRequestCode").value == 'SRB053' || customform.document.getElementById("wdesk:ServiceRequestCode").value == 'SRB055') && customform.document.getElementById("wdesk:ModeOfDelivery").value == 'Courier')
						{
							// Nothing to do, Mail SMS should not be sent for courier cases for this service added on 27/09/2020
						}
						else
							document.getElementById('customform').contentWindow.sendSMS();
						//alert("SMS sent Q4");
					}
				}
			} /*else if(WSNAME=="Q5") { // commented on 07032018, moved to Q6 entry settings
				if(customform.document.getElementById("selectDecision").value=='Document Received')
				{
					document.getElementById('customform').contentWindow.sendSMS();
					//alert("SMS sent Q5");
				}
			}*/ 
			//Added by Nikita for SRB CR 22032018
			if(WSNAME=="Q6") {
				// commented temporarly as field is removed. to be uncommented when field will be added
				// below validation removed on 07082018 - as confirmed by Aishwarya
				/*if(customform.document.getElementById("selectDecision").value=='Sent by Courier')
				{
					if(customform.document.getElementById("wdesk:BranchAWBNumber").value=='')
					{
					alert("Please enter Branch AWB Number");
					customform.document.getElementById("wdesk:BranchAWBNumber").focus();
					return false;
					}
					
				}*/
				
				// making retention date blank for below decisions at Q6
				if(customform.document.getElementById("selectDecision").value=='Reject to Card Dispatch'
					|| customform.document.getElementById("selectDecision").value=='Reject to Card Maintenance'
					|| customform.document.getElementById("selectDecision").value=='Reject to Card Settlement'
					|| customform.document.getElementById("selectDecision").value=='Reject to OPS')
				{
						customform.document.getElementById("wdesk:RetentionExpiryDate").value ="";
				}
				
				// commented temporarly as branch transfer decision is removed. to be uncommented when decision will be added
				var ExistingDocCollBranch = customform.document.getElementById("ExistingDocCollBranch").value;
				var DocumentCollectionBranch = customform.document.getElementById("wdesk:DocumentCollectionBranch").value;
				if(customform.document.getElementById("selectDecision").value=='Branch Transfer')
				{
					if (ExistingDocCollBranch == DocumentCollectionBranch)
					{
						alert('Please change Document Collection Branch as Branch Transfer Decision is Taken.');
						return false;
					}
				} 
				else
				{
					if (ExistingDocCollBranch != DocumentCollectionBranch)
					{
						alert('Please take Branch Transfer Decision as Document Collection Branch is changed.');
						return false;
					}
				}
				
				// sending SMS at Q6 as part of Branch Enhancement added by Angad on 25062018
				if(customform.document.getElementById("selectDecision").value=='Dispatch Complete' || customform.document.getElementById("selectDecision").value=='Branch Transfer' || customform.document.getElementById("selectDecision").value=='Sent by Courier' || customform.document.getElementById("selectDecision").value=='Sent by Post' || customform.document.getElementById("selectDecision").value=='Destroyed' || customform.document.getElementById("selectDecision").value=='Sent to Archive')
				{
					document.getElementById('customform').contentWindow.sendSMS();
					//alert("SMS sent Q6");
				}
				
			}
			else if(WSNAME=="Q12") {
				if(customform.document.getElementById("wdesk:ROUTECATEGORY").value=='CardSettlement')
				{
					if(customform.document.getElementById("selectDecision").value=='Approve')
					{
						document.getElementById('customform').contentWindow.sendSMS();
					}
				}
			} else if(WSNAME=="Q18") {
				if(customform.document.getElementById("wdesk:ROUTECATEGORY").value=='CardMaintenance')
				{
					if(customform.document.getElementById("selectDecision").value=='Approve')
					{
						document.getElementById('customform').contentWindow.sendSMS();
					}
				}
			} else if(WSNAME=="Q21") {
				if(customform.document.getElementById("wdesk:ROUTECATEGORY").value=='CardDispatch')
				{
					if(customform.document.getElementById("selectDecision").value=='Approve')
					{
						document.getElementById('customform').contentWindow.sendSMS();
					}
				}
			}
			// End - Sending SMS
			//added by badri to make remarks mandatory if decison is hold
			if(WSNAME == "Q2" || WSNAME == "Q4" ||WSNAME == "Q11" || WSNAME == "Q12" || WSNAME == "Q17" || WSNAME == "Q18" || WSNAME == "Q20" || WSNAME == "Q21" || WSNAME == "Q23" || WSNAME == "Q24")
			{
				if(customform.document.getElementById("selectDecision").value=='Hold' && remarks =='')
				{
					alert('Remarks are mandatory when decision taken as Hold');
					customform.document.getElementById("remarks").focus();
					return false;
				}
			}
			
			
			//added by shamily for BAT_SRB point 14
			if(WSNAME == "Q13")
			{
				if(customform.document.getElementById("selectDecision").value=='Other' && remarks =='')
				{
					alert('Remarks are mandatory when decision taken as Others');
					customform.document.getElementById("remarks").focus();
					return false;
				}
			
			}
			
			//Added by siva for the newly added ws for 21 service request start
			if(WSNAME == "Q11" || WSNAME == "Q12" || WSNAME == "Q17" || WSNAME == "Q18" || WSNAME == "Q20" || WSNAME == "Q21" || WSNAME == "Q23" || WSNAME == "Q24")
			{
				if(customform.document.getElementById("selectDecision").value=='Hold' && customform.document.getElementById("wdesk:HoldTillDate").value=='')
				{
					alert("Please select Hold Till Date while selecting 'Hold' as decision");
					customform.document.getElementById("wdesk:HoldTillDate").focus();
					return false;
				}
			}
			
			if(WSNAME == "Q18")//Card Maintenance Checker
			{
				if(customform.document.getElementById("selectDecision").value=='Reject to Card Maintenance Maker' && remarks =='')
				{
					alert('Remarks are mandatory when decision taken as Reject to Card Maintenance Maker');
					customform.document.getElementById("remarks").focus();
					return false;
				} 
			}
			
			else if(WSNAME == "Q21")//Card Dispatch Checker
			{
				if(customform.document.getElementById("selectDecision").value=='Reject to Maker' || customform.document.getElementById("selectDecision").value=='Reject to Card Dispatch' && remarks =='')
				{
					alert('Remarks are mandatory when decision taken as Reject to Card Dispatch or Reject to Maker');
					customform.document.getElementById("remarks").focus();
					return false;
				}
			
			}
			
			else if(WSNAME == "Q12")//Card Settlement Checker
			{
				if(customform.document.getElementById("selectDecision").value=='Reject to Card Settlement Maker' && remarks =='')
				{
					alert('Remarks are mandatory when decision taken as Reject to Card Settlement Maker');
					customform.document.getElementById("remarks").focus();
					return false;
				}
			
			}
			//Added by siva for the newly added ws for 21 service request end
			
			//making signature verification mandatory at Loan Maker 
			if(WSNAME == "Q23")
			{
				if(customform.document.getElementById("selectDecision").value=='Approve')
				{
					// validating multiple Approval required data added by Angad on 01102018
					if (validateNoOfApprovalRequired(WSNAME) == false)
						return false;
								
					var ServiceRequestCode = customform.document.getElementById("wdesk:ServiceRequestCode").value;
					var isSignVerifyAtOPSMand= getIsSignVerifyReqFromSubCatMaster(); // taken from SubCategory master
					if(isSignVerifyAtOPSMand == 'Y' || isSignVerifyAtOPSMand == 'M')
					{
						if(customform.document.getElementById("wdesk:sign_matched_maker").value=='')
						{
							alert("Please verify signatures while selecting 'Approve' as decision");
							customform.document.getElementById("viewSign").focus();
							return false;
						}
						else if(customform.document.getElementById("wdesk:sign_matched_maker").value!='' && customform.document.getElementById("wdesk:sign_matched_maker").value == 'No')
						{
							alert("Signatures should be matched before selecting 'Approve' as decision");
							customform.document.getElementById("viewSign").focus();
							return false;
						}
					}
				}
				
				if(customform.document.getElementById("selectDecision").value=='Reject to CSO' && customform.document.getElementById("remarks").value =='')
				{
					alert('Please enter remarks');
					customform.document.getElementById("remarks").focus();
					return false;
				}
				
				var iframe = customform.document.getElementById("frmData");
				var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
				var SubCategoryID = iframeDocument.getElementById("SubCategoryID").value;
				var id=SubCategoryID+"_IslamicOrConventional";
				var IslamicConvention = iframeDocument.getElementById(id).value;
				var existIslmConvValue =  customform.document.getElementById("wdesk:IslamicConvention").value;
				if (existIslmConvValue != IslamicConvention) // means value has been changed
				{
					if(customform.document.getElementById("selectDecision").value!='Islamic / Conventional category changed')
					{
						alert ('Please take decisioin as Islamic / Conventional category changed');
						return false;
					}
				}
				if(customform.document.getElementById("selectDecision").value=='Islamic / Conventional category changed')
				{
					if (existIslmConvValue == IslamicConvention) // means value has not been changed
					{
						alert ('Decision Taken as Islamic / Conventional category changed, Please change Islamic/Conventional value');
						return false;
					}
					
					var status = updateIslamicConventional(IslamicConvention);
					if (status != '0')
					{
						alert ('IslamicConventional update unsuccessful');
						return false;
					}
					customform.document.getElementById("wdesk:IslamicConvention").value = IslamicConvention;
				}
			}
			//making signature verification mandatory at Loan Checker
			if(WSNAME == "Q24")
			{
				if(customform.document.getElementById("selectDecision").value=='Approve')
				{
					var ServiceRequestCode = customform.document.getElementById("wdesk:ServiceRequestCode").value;
					var isSignVerifyAtOPSMand= getIsSignVerifyReqFromSubCatMaster(); // taken from SubCategory master
					if(isSignVerifyAtOPSMand == 'Y' || isSignVerifyAtOPSMand == 'C')
					{
						if(customform.document.getElementById("wdesk:sign_matched_checker").value=='')
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
						}
					}
				}
				
				if((customform.document.getElementById("selectDecision").value=='Reject to CSO' || customform.document.getElementById("selectDecision").value=='Reject to Loan Services Maker') && customform.document.getElementById("remarks").value =='')
				{
					alert('Please enter remarks');
					customform.document.getElementById("remarks").focus();
					return false;
				}
			}
			
			// sending sms at loan service checker
			if(WSNAME=="Q24") {
				if(customform.document.getElementById("wdesk:ROUTECATEGORY").value=='LoanServices')
				{
					if(customform.document.getElementById("selectDecision").value=='Approve')
					{
						document.getElementById('customform').contentWindow.sendSMS();
					}
				}
			}
			
	}

	var url="";
	var param="";
	if(strprocessname=='SRB')
	{//alert('Process name');
		//if(CategoryID=="3" && ( WSNAME!="CSO" ||( WSNAME=="CSO" && IsSaved=="Y" )))
		//{
		//	alert('New alert');
		//}
		var abc=Math.random
		
		url ="/SRB/CustomForms/SRB_Specific/SRB.jsp";
		//alert("Hi");
		//alert("WIData"+WIDATA);
		var Category=customform.document.getElementById("Category").value;
		
		var SubCategory=customform.document.getElementById("SubCategory").value;
		param="WINAME="+WINAME+"&tr_table="+tr_table+"&WSNAME="+WSNAME+"&WS_LogicalName="+WS_LogicalName+"&CategoryID="+CategoryID+"&SubCategoryID="+SubCategoryID+"&IsDoneClicked="+IsDoneClicked+"&IsError="+IsError+"&IsSaved="+IsSaved+"&WIDATA="+WIDATA+"&PANno="+PANno+"&abc="+abc+"&TEMPWINAME="+TEMPWINAME+"&decisionsaved="+decisionsaved+"&exceptionstring="+exceptionstring+"&Category="+Category+"&SubCategory="+SubCategory+"&remarks="+encodeURIComponent(remarks)+"&decisionNew="+decisionNew+"&RejectReason="+RejectReason;;
	   //alert('param'+param);
	  
	   
	} 	

	
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
		}
		else if(ajaxResultFinal == '-201')
		{
			alert("None of the service request parameters are having any value, Can't save");
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
		alert("Problem in saving data.");
		return false;
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

			var url = '/SRB/CustomForms/SRB_Specific/HandleAjaxProcedures.jsp?wi_name=' + wi_name + "&reqType=" + reqType;

			xhr.open("GET", url, false);
			xhr.send(null);

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
            } else {
                eleName2 = inputs[x].getAttribute("id");

                if (eleName2 == null)
                    continue;
                eleName2 += "#";
                var temp = eleName2.split('#');
                var IsRepeatable = temp[4];
                myname = inputs[x].getAttribute("name");
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
                            for (var i = 0; i < ele.length; i++) {
                                eleName2 = ele[i].id;
                                eleName2 += "#radio";
                                if (ele[i].checked) {
                                    eleValue = encodeURIComponent(ele[i].value);
				    eleName = /_(.+)/.exec(eleName)[1];
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
                        if (iframeDocument.getElementById(myname).value == '') {
				//Added by Badri to delete subcategory number from the ID
				myname = /_(.+)/.exec(myname)[1];
                            	WIDATA += myname + "#NULL" + "~";

                        } else {
                            if (iframeDocument.getElementById(myname).checked) {
				//Added by Badri to delete subcategory number from the ID
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
			        var myname_final = /_(.+)/.exec(myname)[1];
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
			//alert('myname : '+myname);
			WIDATA += myname + "#NULL" + "~"; 
		    }
                    else {
                        if (is_workstep_req == 'Y') {
			    var myname_final = /_(.+)/.exec(myname)[1];
                            WIDATA += myname_final + "#" + WSNAME + "$" + encodeURIComponent(iframeDocument.getElementById(myname).value) + "~";
                        } else {
			    var myname_final = /_(.+)/.exec(myname)[1];
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
								// Start - block written to encrypt Card Number for Card Services added on 03062018 by Angad
								if (myname == 'CreditCardNumber')
								{
									Value = getServerDateTime('EncryptData',Value);
								}
								// End - block written to encrypt Card Number for Card Services added on 03062018 by Angad
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
    if (CategoryID == 1 && SubCategoryID == 4) {
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

                    if (colNameValue[0] == 'rak_card_no_masked')
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
    }
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

function callInsertDuplicateWorkitems() 
{

    var wi_name =customform.document.getElementById("wdesk:WI_NAME").value;

    try 
	{
        var url = '/SRB/CustomForms/SRB_Specific/DeleteAjaxRequest.jsp?wi_name=' + wi_name;

        var req;
        if (window.XMLHttpRequest) {
            req = new XMLHttpRequest();
        } else if (window.ActiveXObject) {
            isIE = true;
            req = new ActiveXObject("Microsoft.XMLHTTP");
        }

        req.open("POST", url, false);
        req.send();

    } 
	catch (e) 
	{
        alert("Exception while deleting duplicate workitem Grid Details: " + e);
    }

    var table = customform.document.getElementById("duplicateWorkItemID");
    var rowCount = table.rows.length;
    for (var i = 0; i < rowCount; i++) 
	{
	    if(i==0 || i==1)//Left two rows as these are headers
		continue;
        var gridRow = "";
        var colCount = table.rows[i].cells.length;

        var currentrow = table.rows[i];

        for (var j = 0; j < colCount; j++) 
		{

            if (gridRow != "") 
			{
                gridRow = gridRow + "," + "'" + currentrow.cells[j].innerHTML + "'";
            } 
			else 
			{

                gridRow = "'" + currentrow.cells[j].innerHTML+ "'";
            }
        }
        gridRow += ",'" + wi_name + "'";

        try {
            var url = '/SRB/CustomForms/SRB_Specific/InsertMailingRequest.jsp?gridRow=' + gridRow;

            var xhr;
            var ajaxResult;

            if (window.XMLHttpRequest)
                xhr = new XMLHttpRequest();
            else if (window.ActiveXObject)
                xhr = new ActiveXObject("Microsoft.XMLHTTP");

            xhr.open("POST", url, false);
            xhr.send();


        } catch (e) 
		{
            alert("Exception while adding Duplicate workitem Grid Details: " + e);
        }
    }
}
function ValidateGridInSRB()
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
					var r = confirm("Emirates ID expiry date should not be less then sum of today's date and "+EmidExpirydate_param+" days, Press OK to Proceed");
					if (r == false) 
					{
						return false;
					} else if (r == true) 
					{
						return true;
					} 
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
//change done by stutee.mishra
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

//function added to get isSignature verification required value from subcategory table added by Angad on 19032018
function getIsSignVerifyReqFromSubCatMaster()
{
	var reqType = 'getSignatureVerifyReq';
	var ServiceRequestCode = customform.document.getElementById("wdesk:ServiceRequestCode").value;
	var wi_name = customform.document.getElementById("wdesk:WI_NAME").value;
	var xhr;
	if (window.XMLHttpRequest)
		xhr = new XMLHttpRequest();
	else if (window.ActiveXObject)
		xhr = new ActiveXObject("Microsoft.XMLHTTP");

	var url = "/SRB/CustomForms/SRB_Specific/HandleAjaxProcedures.jsp";
	var param = "ServiceRequestCode=" + ServiceRequestCode+"&reqType="+reqType+"&wi_name=" + wi_name;
	//param = encodeURIComponent(param);
	xhr.open("POST", url, false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	//return false;
	if (xhr.status == 200 && xhr.readyState == 4) 
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
	}
	else{
		alert("error while fetching isSignVerifyAtOPSMand");
	}
	return ajaxResult;
}

// Below function added to check post dated application date added by Angad on 19032018
function checkStaleDatedRequest()
{
	var date1 = customform.document.getElementById('wdesk:ApplicationDate').value;
	var noOfStaleDays = customform.document.getElementById('wdesk:StaleDateRestrictionDays').value;
	
	if (date1!=null && date1!="")
	{
		var date2 = getServerDateTime('getServerDateTime','');
		var d = new Date();
		var n = d.getDate();
		var m = d.getMonth();

		var yr1 = date1.substring(date1.lastIndexOf("/") + 1);
		var dt1 =  date1.substring(0,date1.indexOf("/"));
		if (dt1.length == 1)
			dt1 = "0"+dt1;
		var temp = date1.substring(date1.indexOf("/") + 1);
		var mon1 =  temp.substring(0,temp.indexOf("/"));

		if (mon1.length == 1)
			mon1 = "0"+mon1;
		
		var dt2  = date2.substring(8,10);
		var mon2 = date2.substring(5,7);
		var yr2  = date2.substring(0,4);
		
		if(yr1.length==2)
			yr1 = yr2.substring(0,2)+yr1;
		date1 = mon1 + "/" + dt1 + "/" + yr1;
		date2 = mon2 + "/" + dt2 + "/" + yr2;
		date1  = new Date(date1);
		date2  = new Date(date2);

		var timeDiff = Math.abs(date2.getTime() - date1.getTime());
		var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24)); 
	
		if(diffDays > noOfStaleDays) 
		{	
			alert("Application Date cannot be more than "+noOfStaleDays+" days older.")
			return false;
		}
	}
}

// below function added to get current datetime of the server added by Angad on 19032018
function getServerDateTime (reqType, data)
{
	var workstepname = "";
	var url = '/SRB/CustomForms/SRB_Specific/SRBUtil.jsp?reqType='+reqType+'&Value='+data;
	var xhr;
	var ajaxResult;
	var response;
	var x ="";

	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	 xhr.open("GET",url,false);
	 xhr.send(null);	 

	if (xhr.status == 200)
	{
		response = xhr.responseText;
		response=response.replace(/^\s+|\s+$/gm,'');
		return response;
	}
	else
	{
		alert("Unable to fetch the Server Date and Time");
		return "";
	}
}

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

// below function is added to update IslamicConventional column in SRB Loan Services Trasanction Table at Loan Service Maker
function updateIslamicConventional(IslamicConvention)
{
	var reqType = 'UpdateLoanIslamicConventional';
	var wi_name = customform.document.getElementById('wdesk:WI_NAME').value;
	var SRCode= customform.document.getElementById("wdesk:ServiceRequestCode").value;
	var xhr;
	if (window.XMLHttpRequest)
		xhr = new XMLHttpRequest();
	else if (window.ActiveXObject)
		xhr = new ActiveXObject("Microsoft.XMLHTTP");

	var url = "/SRB/CustomForms/SRB_Specific/updateInTransactionTable.jsp";
	var param = "WINAME=" + wi_name+"&RequestType="+reqType+"&SRCode="+SRCode+"&IslamicConvention="+IslamicConvention;
	//param = encodeURIComponent(param);
	xhr.open("POST", url, false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	//return false;
	if (xhr.status == 200 && xhr.readyState == 4) 
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
	}
	else{
		alert("error while updating IslamicConvention for Loan Services");
	}
	return ajaxResult;
}
 

function validateNoOfApprovalRequired(WSNAME)
{
	var isMultipleApprovalReq = customform.document.getElementById("wdesk:isMultipleApprovalReq").value;
	if(isMultipleApprovalReq=='Y')
	{
		if (WSNAME == 'Q2' || WSNAME == 'Q11' || WSNAME == 'Q17' || WSNAME == 'Q20' || WSNAME == 'Q23') // all Maker
		{
			var NoOfApprovalRequired = customform.document.getElementById("wdesk:NoOfApprovalRequired").value;
			var MultipleApprovalCount = customform.document.getElementById("wdesk:MultipleApprovalCount").value;
				
			if (NoOfApprovalRequired=='')
			{
				alert("No. Of Approval Required is mandatory");
				customform.document.getElementById("wdesk:NoOfApprovalRequired").focus();
				return false;
			}
			if (NoOfApprovalRequired==0)
			{
				alert("No. Of Approval Required cannot be Zero");
				customform.document.getElementById("wdesk:NoOfApprovalRequired").focus();
				return false;
			}
			if (NoOfApprovalRequired > 25)
			{
				alert("No. Of Approval Required cannot be greater than 25");
				customform.document.getElementById("wdesk:NoOfApprovalRequired").focus();
				return false;
			}		
			
		}
		
		if (WSNAME == 'Q4' || WSNAME == 'Q12' || WSNAME == 'Q18' || WSNAME == 'Q21' || WSNAME == 'Q24') // All Checker
		{
			var NoOfApprovalRequired = customform.document.getElementById("wdesk:NoOfApprovalRequired").value;
			var MultipleApprovalCount = customform.document.getElementById("wdesk:MultipleApprovalCount").value;
			
			if (MultipleApprovalCount=='' || MultipleApprovalCount=='NULL' || MultipleApprovalCount=='null')
			{
				MultipleApprovalCount=0;
			}
			if (NoOfApprovalRequired=='' || NoOfApprovalRequired=='NULL' || NoOfApprovalRequired=='null')
			{
				NoOfApprovalRequired=1;	
			}	
			
			if (MultipleApprovalCount >= (NoOfApprovalRequired-1))
			{
				return true; // means required approval's are completed
			}else{
				alert("Maker Activities are not complete, Approve decision cannot be taken");
				customform.document.getElementById("selectDecision").focus();
				return false;
			}
			
		}
	}
	return true;
} 

function AttachedDocTypeCheck(sDocTypeNames) {
	var arrAvailableDocList = document.getElementById('wdesk:docCombo');
	if (arrAvailableDocList == null || arrAvailableDocList == 'null')
		arrAvailableDocList = customform.document.getElementById('wdesk:docCombo');
	var arrSearchDocList = sDocTypeNames.split(",");
	var bResult = false;
	// condition added for not to check mandatory when decision is reject on 05092017
	for (var iSearchCounter = 0; iSearchCounter < arrSearchDocList.length; iSearchCounter++) {
		bResult = false;
		for (var iDocCounter = 0; iDocCounter < arrAvailableDocList.length; iDocCounter++) {
			if (arrAvailableDocList[iDocCounter].text.toUpperCase().indexOf(arrSearchDocList[iSearchCounter].toUpperCase()) >= 0) {
				bResult = true;
				break;
			}
		}
		if (!bResult) {
			return false;
		}
	}
	return true;
}
function CustomEncodeURI(data)
{
	return data.split("%").join("CHARPERCENTAGE").split("&").join("CHARAMPERSAND");
}
