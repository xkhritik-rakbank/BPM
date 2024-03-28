function OnDoneValidation(flag)
{

		//checkForUIDException();
		 var WSNAME = customform.document.getElementById("wdesk:CURRENT_WS").value;
		 
		 		
		if(flag=='I' || flag=='D')
		{
			/*var customerTable =customform.document.getElementById("OECDGrid");//Customer grid count check.if No row added the give alert and return false
			
			var customerTableCount = customerTable.rows.length;
			
			if(customerTableCount==1)//When no row added in grid
			{
				alert('Please add OECD details in grid');
				return false;
			}*/
						
			//this function is used to check mandatory document generation on done click. 
			/*var docgenStatus=DocumentGenerationValidation();
			if(!docgenStatus)
			return false;*/
			
			if(customform.document.getElementById("selectDecision").value=='')//Decision will always be mandatory for all workstep
			{
				alert('Decision is mandatory');
				customform.document.getElementById('selectDecision').focus(true);
				return false;
			}
		}
			
		
		/*if(WSNAME=="Control")
		{
			if(customform.document.getElementById("RETAIL_OR_CORPORATE").value=='Retail')
			{
				alert("RETAIL_OR_CORPORATE field -----"+customform.document.getElementById("RETAIL_OR_CORPORATE").value);
				/*customform.document.getElementById('wdesk:RETAIL_OR_CORPORATE').focus(true);
				return false;
			}
			
			else if(customform.document.getElementById("RETAIL_OR_CORPORATE").value=='Corporate')
			{
				alert("RETAIL_OR_CORPORATE field -----"+customform.document.getElementById("RETAIL_OR_CORPORATE").value);
				/*customform.document.getElementById('wdesk:RETAIL_OR_CORPORATE').focus(true);
				return false;
			}
			
			else
			{
				alert("Please enter RETAIL_OR_CORPORATE field as either 'RETAIL' or 'CORPORATE' and click save button");
				customform.document.getElementById('RETAIL_OR_CORPORATE').focus(true);
				return false;				
			}
		}*/
	
		if(WSNAME=="Attach_Cust_Doc")
		{
				 //Document attach validation
				if(document.getElementById('wdesk:docCombo').value!='')
				{
					customform.document.getElementById("wdesk:IS_DOC_ATTACHED").value='Yes';
					alert("Document is attached in "+WSNAME);		
				}
				else
				{		
					customform.document.getElementById("wdesk:IS_DOC_ATTACHED").value='No';
					alert("Document is not attached in "+WSNAME);
				}
		}
		
		if(WSNAME=="OPS_Maker")
		{
			
			if(customform.document.getElementById("selectDecision").value=="Approve")
			{
				if(customform.document.getElementById("wdesk:SIGN_MATCHED_MAKER").value=='' || customform.document.getElementById("wdesk:SIGN_MATCHED_MAKER").value== null)
				{
					alert("Please verify signatures while selecting 'Approve' as decision");
					customform.document.getElementById('ViewSignature').focus();
				
					return false;
				}
				else if(customform.document.getElementById("wdesk:SIGN_MATCHED_MAKER").value!='' && customform.document.getElementById("wdesk:SIGN_MATCHED_MAKER").value == 'No')
				{
					alert("Signatures should be matched before selecting 'Approve' as decision");
					customform.document.getElementById('ViewSignature').focus();
					return false;
				}
				
			}
		}
		
		if(WSNAME=="OPS_Checker")
		{
			if(customform.document.getElementById("selectDecision").value=="Approve")
			{
				
				if(customform.document.getElementById("wdesk:SIGN_MATCHED_CHECKER").value==''||customform.document.getElementById("wdesk:SIGN_MATCHED_CHECKER").value==null)
				{
					alert("Please verify signatures while selecting 'Approve' as decision");
				
					customform.document.getElementById("ViewSignature").focus();
					
					return false;
				}
				else if(customform.document.getElementById("wdesk:SIGN_MATCHED_CHECKER").value!='' && customform.document.getElementById("wdesk:SIGN_MATCHED_CHECKER").value == 'No')
				{
					alert("Signatures should be matched before selecting 'Approve' as decision otherwise select decision as reject if signature is not matched");
					customform.document.getElementById("ViewSignature").focus();
					return false;
				}
				
			
				if(customform.document.getElementById("CIF_TYPE").value == 'Corporate')
				{
					var table = customform.document.getElementById("checklistGrid");
					var rowCount=(table.rows.length);
					for (var i = 1; i < rowCount+1; i++)
					{
						var SRId=customform.document.getElementById("SRId"+i).value;
						//console.log("SRId"+SRId)
						var str = /^[0-9]+$/;
						if(SRId.match(str))
						{	
							if(customform.document.getElementById('option'+SRId).value == '')
							{
								alert("Please select option of Checklist Details Grid");
								customform.document.getElementById('option'+SRId).focus();
								return false;
							}															
						
						}  
						else
						{
							var option1=customform.document.getElementById("option"+SRId.match(/\d+/)[0]).value;
							if(option1.toUpperCase()=='YES' && customform.document.getElementById('option'+SRId).value == '' )
							{
								alert("Please select subdivision option of Checklist Details Grid");
								customform.document.getElementById('option'+SRId).focus();
								return false;
							}
						
						}
					}
				}
			}
		}
		
		if(WSNAME=="RM")
		{
			if(customform.document.getElementById("selectDecision").value=="Approve")
			{	
				if(customform.document.getElementById("CIF_TYPE").value == 'Corporate')
				{					
					var table = customform.document.getElementById("checklistGrid");
					var rowCount=(table.rows.length);
					for (var i = 1; i < rowCount+1; i++)
					{
						var SRId=customform.document.getElementById("SRId"+i).value;
						//console.log("SRId"+SRId)
						var str = /^[0-9]+$/;
						if(SRId.match(str))
						{	
							if(customform.document.getElementById('option'+SRId).value == '')
							{
								alert("Please select option of Checklist Details Grid");
								customform.document.getElementById('option'+SRId).focus();
								return false;
							}															
						
						}  
						else
						{
							var option1=customform.document.getElementById("option"+SRId.match(/\d+/)[0]).value;
							if(option1.toUpperCase()=='YES' && customform.document.getElementById('option'+SRId).value == '' )
							{
								alert("Please select subdivision option of Checklist Details Grid");
								customform.document.getElementById('option'+SRId).focus();
								return false;
							}
						
						}
					}
				}
			}
		}
		
		/*if(WSNAME=='"CBWC_Checker"')
		{
			var returnUIDRaiseFlag=checkForUIDException();
			if(returnUIDRaiseFlag)
			{
				if(customform.document.getElementById("selectDecision").value!='Exception Approval Required')
				{
				 alert('Please select decision Exception Approval Required');
				 return false;
				}
			}
			return false;
		}*/  
	
		if(customform.document.getElementById("selectDecision").value=='Reject'||customform.document.getElementById("selectDecision").value=='Reject to OPS Maker' || customform.document.getElementById("selectDecision").value=='Reject to OPS Data Entry Maker')
		{
			if(customform.document.getElementById("remarks").value== "")
			{
			  alert("Please provide remarks");
			  customform.document.getElementById('remarks').focus(true);
			  return false;
			}
			if(customform.document.getElementById('rejReasonCodes').value=='' || customform.document.getElementById('rejReasonCodes').value=='NO_CHANGE')
			{
			  alert("Please provide reject reason.");
			  customform.document.getElementById('RejectReason').focus(true);
			  return false;
			}
		}	
      		
		return true;	
}
function AttachedDocType(sDocTypeNames){
    var arrAvailableDocList = window.parent.getInterfaceData("D");
    var arrSearchDocList = sDocTypeNames.split(",");
	//alert("arrSearchDocList"+arrSearchDocList);
    var bResult=false;
    // condition added for not to check mandatory when decision is reject on 05092017
    
        
            for(var iSearchCounter=0;iSearchCounter<arrSearchDocList.length;iSearchCounter++){
                bResult=false;
					for(var iDocCounter=0;iDocCounter<arrAvailableDocList.length;iDocCounter++){
						//alert("arrSearchDocList---"+arrSearchDocList[iSearchCounter]);
						//alert("arrAvailableDocList---"+arrAvailableDocList[iDocCounter].name);
						if(arrAvailableDocList[iDocCounter].name == arrSearchDocList[iSearchCounter]){
	 
							bResult = true;
							break;
						}
					}
				}
                if(!bResult){
                    //alert("Please attach " + arrSearchDocList[iSearchCounter]+" to proceed further.");
                    return false;
                }
            
        
    
    return true;
}
function docTypevalidationForIdentificationGrid()
{
	if(document.getElementById("custcntryofres").value=='UNITED ARAB EMIRATES')
	{
		var identificationTable=document.getElementById("identificationDocGrid");
		var mandatEDocType='Emirates ID,Marsoon ID';
		var Matchflag=true;
		for(var i=3;i<identificationTable.rows.length;i++)
		{
					if(mandatEDocType.indexOf(document.getElementById('identificationdoctype'+i).value)==-1){
						Matchflag=false;
					}else{
						Matchflag=true;
						break;
					}
		}
		if(!Matchflag)
		{
			alert("Document Type 'Emirates ID' or 'Emirated ID Registration Form' or 'Marsoon ID' should be added, if 'Country of Residence' is selected as UNITED ARAB EMIRATES");
			return false;
		}
	}
	if(document.getElementById("custnationality").value!='UNITED ARAB EMIRATES')
	{
		var identificationTable=document.getElementById("identificationDocGrid");
		var mandatEDocType='Passport';
		var Matchflag=true;
		for(var i=3;i<identificationTable.rows.length;i++)
		{
					if(mandatEDocType.indexOf(document.getElementById('identificationdoctype'+i).value)==-1)
					{
						Matchflag=false;
					}
					else
					{
						Matchflag=true;
						break;
					}
		}
		if(!Matchflag)
		{
			alert("Document Type 'Passport' should be added, if 'Nationality' is NOT selected as UNITED ARAB EMIRATES");
			return false;
		}
	}
	return true
}	
function getApplicantDetails(applicanyType)
{
	var table =customform.document.getElementById("CustDetailsGrid");
	var rowCount = table.rows.length;
	var flagMinor='false';
	var FieldValuesArray=''
	if(rowCount>1)//When no row added in grid
	{
		for (var i = 1; i < rowCount; i++) 
		{
			var currentrow = table.rows[i];
			if(currentrow.cells[1].innerHTML==applicanyType)
			{
				var currDate = new Date();
				var dob =customform.document.getElementById('custdob'+i).innerHTML;
				var arrStartDate = dob.split("/");
				var yearDiff = currDate.getFullYear() - (arrStartDate[2]);
				if (yearDiff < 16) 
				{
					flagMinor='true';
				}
				var existingcust=customform.document.getElementById('existingcust'+i).innerHTML;
				var NoOfDependent=customform.document.getElementById('custnoofdependents'+i).innerHTML;
				var isMinor=flagMinor;
				FieldValuesArray=(existingcust+'#'+NoOfDependent+'#'+isMinor);
				break;
			}
			else
			{
				FieldValuesArray='NOTFOUND#NOTFOUND';
			}
		}
	}
	return FieldValuesArray;
}		
function DocumentGenerationValidation()
{	
	var accounttable = customform.document.getElementById("AccountGrid");//Account grid count check.if No row added the give alert and return false
	var customerTable =customform.document.getElementById("CustDetailsGrid");
	//var customerTableCount = customerTable.rows.length;
	//For Application form conventional and Islamic validation
	for(var i=3;i<accounttable.rows.length;i++)
	{
			if(customform.document.getElementById('accounttype'+i).value=='Conventional Account' && customform.document.getElementById('wdesk:PDF_GENFLAG_APP_FORM_CONVENTIONAL').value=='')
			{
				alert("Please generate Application Form Conventional.");
				return false;
			}
			/*if(customform.document.getElementById('accounttype'+i).value=='Islamic Account')
			{
				alert("Please generate Application Form Islamic.");
				return false;
			}*/
	}
	var arrayReturnValues=getApplicantDetails('Primary').split('#');
	if(arrayReturnValues[2]=='true' && customform.document.getElementById('wdesk:PDF_GENFLAG_MINOR_CONSENT_FORM_PRIMARY').value=='')
	{
			alert("Please generate Minor Consent Form.");
			return false;
	}
	if(customform.document.getElementById('wdesk:PDF_GENFLAG_KYC_PRIMARY').value=='')
	{
		alert("Please generate KYC form for Primary applicant.");
		return false;
	}
	var arrayReturnValues=getApplicantDetails('Joint').split('#');
	if(arrayReturnValues[0]!='NOTFOUND')
	{
		if(customform.document.getElementById('wdesk:PDF_GENFLAG_KYC_JOINT').value=='')
		{
			alert("Please generate KYC form for Joint 1 applicant.");
			return false;
		}
	}
	if(customform.document.getElementById('wdesk:PDF_GENFLAG_FATCA_DECLARE_PRIMARY').value=='')
	{
			alert("Please generate FATCA Declaration Form for Primary customer.");
			return false;
	}
	var arrayReturnValues=getApplicantDetails('Joint').split('#');
	if(arrayReturnValues[0]!='NOTFOUND')
	{
		if(customform.document.getElementById('wdesk:PDF_GENFLAG_FATCA_DECLARE_JOINT').value=='')
		{
			alert("Please generate FATCA Declaration Form for Joint customer.");
			return false;
		}
	}
	var arrayReturnValues=getApplicantDetails('Primary').split('#');
	if(arrayReturnValues[0]=='No')
	{
		if(customform.document.getElementById('wdesk:PDF_GENFLAG_CRS_INDIVIDUAL_PRIMARY').value=='')
		{
			alert("Please generate CRS (OECD) Individual Form for Primary customer.");
			return false;
		}
	}
	var arrayReturnValues=getApplicantDetails('Joint').split('#');
	var noOfjointApplicant=customform.document.getElementById('wdesk:NO_OF_JOINT_APPLICANTS').value;
	if(arrayReturnValues[0]=='No' && noOfjointApplicant=='1')
	{
		if(customform.document.getElementById('wdesk:PDF_GENFLAG_CRS_INDIVIDUAL_JOINT').value=='')
		{
			alert("Please generate CRS (OECD) Individual Form for Joint customer.");
			return false;
		}
	}
	if(customform.document.getElementById('wdesk:PDF_GENFLAG_CHECKLIST_AO').value=='')
	{
		alert("Please generate Checklist-Personal Account Opening Form.");
		return false;
	}
	if(customform.document.getElementById('wdesk:PDF_GENFLAG_FATCA_INDIVIDUAL_CHEKLIST').value=='')
	{
		alert("Please generate FATCA Individual Checklist Form.");
		return false;
	}
	/*if(customform.document.getElementById('wdesk:wdesk:VIEW_SIGNATURE_GENFLAG_PRIMARY').value=='')
	{
		alert("Please View Signature for : Primary.");
		return false;
	}
	var arrayReturnValues=getApplicantDetails('Joint').split('#');
	if(arrayReturnValues[0]!='NOTFOUND')
	{
		if(customform.document.getElementById('wdesk:VIEW_SIGNATURE_GENFLAG_JOINT').value=='')
		{
			alert("Please View Signature for : Joint1.");
			return false;
		}
	}*/	
	return true;
}
function getDateTime() 
{
	var monthNames = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
	now = new Date();
	year = "" + now.getFullYear();
	month = "" + monthNames[now.getMonth()];
	day = "" + now.getDate(); if (day.length == 1) { day = "0" + day; }
	hour = "" + now.getHours(); if (hour.length == 1) { hour = "0" + hour; }
	minute = "" + now.getMinutes(); if (minute.length == 1) { minute = "0" + minute; }
	second = "" + now.getSeconds(); if (second.length == 1) { second = "0" + second; }
	return day + "/" + month + "/" + year + "  " + hour + ":" + minute + ":" + second;
}
function checkForUIDException()
{
	var flag=true;
	var OECDTable=customform.document.getElementById("uidtable");
	if(OECDTable.rows.length>3)
	{
	  //then need to raise UID Exception
	  var WSNAME = customform.document.getElementById("wdesk:CURRENT_WS").value;
	  var currCheckList=customform.document.getElementById('H_CHECKLIST').value;
	  var currUser='amitabh';
	  alert('found '+currCheckList.indexOf('1~[Raised'));
	  if(currCheckList.indexOf('1~[Raised')==-1)//Means this exception is not raised as of now 1-means UID exception
	  {
		if(currCheckList=='')
		currCheckList='1~[Raised-'+currUser+'-'+WSNAME+'-'+getDateTime()+']';
		else
		currCheckList=currCheckList+'#'+'1~[Raised-'+currUser+'-'+WSNAME+'-'+getDateTime()+']';
		
		customform.document.getElementById('H_CHECKLIST').value=currCheckList;
		flag=true;
	  }
	  else
	  flag=false;
	}
	else
	flag=false;
	
	return flag;
}