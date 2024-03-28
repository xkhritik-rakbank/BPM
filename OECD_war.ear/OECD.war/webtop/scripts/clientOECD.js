//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           Function validates on click of save
//***********************************************************************************//

//Added by siva
try
{
var pname=window.parent.strprocessname;
//if(pname=='RAO')
//{
window.document.write("<script src="+"/OECD/webtop/scripts/OECD_Script/MandatoryFieldValidation.js"+"></script>");
}
catch(ex){
    //added by Nishant Parmar (04 AUG 16):
    alert("#EXCEPTION occured: "+ex);
}

function SaveClick() 
{	
	//return true;
	var flag="S";
	//var validateStatus=validateAtDone(flag);

	
	if(true)
	{
		savechecklistData();
		//saveException();
		//alert("Data saved successfully.");
		return true;
	}
		
	/*if(WSNAME=='Initiation')
	{
		return saveCustomerAndAccountData();
	}*/
	/*if(WSNAME=='Introduction')
	{
		return saveUIDGridData();
	}*/
    
}

function IntroduceClick() 
{
	var flag="I";
    var validateStatus=validateAtDone(flag);
	if(validateStatus)
	{
		/*var validateCustomerAndAccountSave=saveCustomerAndAccountData();
		if(validateCustomerAndAccountSave)
		{*/
			OECDSAVEDATA(true);
			alert("The request has been submitted successfully.");
			return true;
			
			//savechecklistData();
		/*}
		else
		return false;*/
	}
	else
	return false;
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
function DoneClick() 
{   
	var flag="D";
	
    var validateStatus=validateAtDone(flag);
	
	if(validateStatus)
	{
			savechecklistData();
			OECDSAVEDATA(true);
			alert("The request has been submitted successfully.");
			return true;
	}	
	else
		return false;
}
function saveCustomerData() 
{	
	var table = customform.document.getElementById("CustDetailsGrid");
	var ajaxResult='';
	var saveFalg=false;
    var rowCount = table.rows.length;
	if(rowCount==1)//When no row added in grid
	return true;
	
    var wi_name =customform.document.getElementById("wdesk:WINAME").value;
    try 
	{
        var url = '/RAO/CustomForms/RAO_Specific/DeleteCustomerData.jsp?wi_name=' + wi_name;
        var req;
        if (window.XMLHttpRequest) {
            req = new XMLHttpRequest();
        } else if (window.ActiveXObject) {
            isIE = true;
            req = new ActiveXObject("Microsoft.XMLHTTP");
        }
		req.open("POST", url, false);
        req.send();
		if (req.readyState == 4 && req.status == 200) 
		{
			ajaxResult = req.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '')
			if(ajaxResult=='-1')
			{
				alert('Error while saving Customer Data');
				return false;
			}
		}
		else
		{
			alert('Error while saving Customer Data\n Response Status '+req.status);
			return false;
		}
    } 
	catch (e) 
	{
        alert("Exception while saving Customer Data: " + e);
    }
	var arrayCustomerFieldsForSave=['applicanttype','custfirstname','custcifid','existingcust','existaccno','existcardno','custtitle','custgender','custmiddlename','custdob','custlastname','custmothermaidenname','custcntryofres','custmaritalstatus','custnationality','custnoofdependents','relationshiptominor','guardiantitle','guardianfirstname','guardianmiddlename','guardianlastname','restype','prefermailaddr','holdmailbranch','res_flatvilla','home_flatvilla','res_building','home_building','res_street','home_street','res_landmark','home_landmark','res_city','home_city','res_zipcode','home_zipcode','res_pobox','home_pobox','res_state','home_state','res_country','home_country','restelephone','home_telephone','custemptype','custempstatus','custdesignation','custoccupation','custdepartment','custempno','custempcode','custcompname','custpobox','custtelephone','custemploymentcity','custtelephnext','custempmntcountry','custempmntfax','custgrosssalary','employmentdob','custindussegment','custindussubsegment','custnatureofbusiness','custyrinbusiness','custdealingwithcountry','previousorginuae','timeinpreviousorg','contactpreferemailid','contactprefercontact','contactmobile1','contactmobile2','contactemailid1','contactemailid2','oth_custtype','oth_segment','oth_PEP','oth_subsegment','kyc_existingheld','kyc_existingreviewdate','kyc_held','kyc_reviewdate','kyc_monthlycreditamount','kyc_monthlycreditcurrency','kyc_monthlycreditpercentage','kyc_monthlycashpercentage','kyc_monthlynon_cashpercentage','kyc_highesttransactionamount','kyc_highesttransactioncurrency','kyc_highestnoncash_amount','kyc_highestnonnoncash_currency','aecbeligible','usrelation','doccollected','signeddate','expirydate','tax_cityofbirth','tax_countryofbirth','crsundocumentedflag','crsundocumentedflagreason','restelephone_isd','home_telephone_isd','custtelephone_isd','custempmntfax_isd','contactmobile1_isd','contactmobile2_isd','riskscore'];
    for (var i = 1; i < rowCount; i++) 
	{
        var gridRow = "";
        var colCount = table.rows[i].cells.length;
        var currentrow = table.rows[i];
		//creating hidden fields for saving FATCA_Document and FATCA_Reason in database
		var FatcaReason="";
		var FatcaDocument="";
        for (var j = 0; j < arrayCustomerFieldsForSave.length; j++) 
		{					
				if (gridRow != "") 
				{
					gridRow = gridRow + "," + "'" + customform.document.getElementById(arrayCustomerFieldsForSave[j]+i).innerHTML + "'";
				} 
				else 
				{
					gridRow = "'"+i+"','"+wi_name+"',"+"'" + customform.document.getElementById(arrayCustomerFieldsForSave[j]+i).innerHTML+ "'";
				}
				
				if(customform.document.getElementById(arrayCustomerFieldsForSave[j]+i).innerHTML=='Primary')
				{
					//alert("window.parent.FATCA_document_Primary"+window.parent.FATCA_document_Primary);
					//alert("window.parent.FATCA_reason_Primary"+window.parent.FATCA_reason_Primary);
					FatcaReason=window.parent.FATCA_reason_Primary;
					FatcaDocument=window.parent.FATCA_document_Primary;
				}
			
				else if(customform.document.getElementById(arrayCustomerFieldsForSave[j]+i).innerHTML=='Joint')
				{
					//alert("window.parent.FATCA_document_Joint"+window.parent.FATCA_document_Joint);
					//alert("window.parent.FATCA_reason_Joint"+window.parent.FATCA_reason_Joint);
					FatcaReason=window.parent.FATCA_reason_Joint;
					FatcaDocument=window.parent.FATCA_document_Joint;
				}
			
        }
		
        try 
		{
						
            var url = '/RAO/CustomForms/RAO_Specific/InsertCustomerData.jsp?gridRow=' + gridRow+"&wi_name="+wi_name+"&FATCA_Document="+FatcaDocument+"&FATCA_Reason="+FatcaReason; //Passing FATCA_reason and FATCA_Document values
			url=url.replace(/&amp;/g, 'ENCODEDAND');
            var xhr;
            var ajaxResult;
            if (window.XMLHttpRequest)
                xhr = new XMLHttpRequest();
            else if (window.ActiveXObject)
                xhr = new ActiveXObject("Microsoft.XMLHTTP");
            xhr.open("POST", url, false);
            xhr.send();
			if (xhr.status == 200)
				{
					 ajaxResult = xhr.responseText;
					 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
					 if(ajaxResult=='0')
					 {
						var returnStatus=saveIdentificationDocData(i,wi_name);
						if(returnStatus)
						{
							var returnStatus=saveOECDGridData(i,wi_name);
							if(returnStatus)
							{
							  saveFalg=true;
							  //meand for first customer in grid identification and OECD data has been inserted successfully.Now will add the same for other rows of gridif added.
							}
							else
							return returnStatus;
						}
						else
						return returnStatus;
					 }
					 else
					 {
						alert("Problem in saving customer data");
						return false;
					 }
				}
        } 
		catch (e) 
		{
            alert("Exception while saving Customer Data: " + e);
			return false;
        }
    }
	return saveFalg;
}
function OECDSAVEDATA(IsDoneClicked) 
{	
	var WSNAME = customform.document.getElementById("wdesk:CURRENT_WS").value;
    var WINAME = customform.document.getElementById("wdesk:WINAME").value;
	var rejectReasons = customform.document.getElementById('rejReasonCodes').value;
    var Decision = '';
	Decision = customform.document.getElementById("selectDecision").value;
   
    var Remarks = customform.document.getElementById('remarks').value
	//for inserting decision in decision history
    var xhr;
    if (window.XMLHttpRequest)
        xhr = new XMLHttpRequest();
    else if (window.ActiveXObject)
        xhr = new ActiveXObject("Microsoft.XMLHTTP");
    var abc = Math.random;

    var url = "/OECD/CustomForms/OECD_Specific/SaveHistory.jsp";
    var param = "WINAME=" + WINAME + "&WSNAME=" + WSNAME + "&Decision=" + Decision + "&Remarks=" + Remarks + "&rejectReasons=" + rejectReasons + "&IsDoneClicked=" + IsDoneClicked + "&IsSaved=Y&abc=" + abc;

    xhr.open("POST", url, false);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.send(param);
	
    if (xhr.status == 200 && xhr.readyState == 4) {
        ajaxResult = Trim(xhr.responseText);

        if (ajaxResult == 'NoRecord') {
            alert("No record found.");
            return false;
        } else if (ajaxResult == 'Error') {
            alert("Some problem in creating workitem.");
            return false;
        }
    } else {
        alert("Problem in saving data");
        return false;
    }
		
	
    return true;
}
function saveAccountGridData() 
{	
	var table = customform.document.getElementById("AccountGrid");
	var ajaxResult='';
    var rowCount = table.rows.length;
	if(rowCount==3)//When no row added in grid
	return true;
	
    var wi_name =customform.document.getElementById("wdesk:WINAME").value;
    try 
	{
        var url = '/RAO/CustomForms/RAO_Specific/DeleteAccountData.jsp?wi_name=' + wi_name;
        var req;
        if (window.XMLHttpRequest) {
            req = new XMLHttpRequest();
        } else if (window.ActiveXObject) {
            isIE = true;
            req = new ActiveXObject("Microsoft.XMLHTTP");
        }
		req.open("POST", url, false);
        req.send();
		if (req.readyState == 4 && req.status == 200) 
		{
			ajaxResult = req.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '')
			if(ajaxResult=='-1')
			{
				alert('Error while saving Account Grid Data');
				return false;
			}
		}
		else
		{
			alert('Error while saving Account Grid Data\n Response Status '+req.status);
			return false;
		}
    } 
	catch (e) 
	{
        alert("Exception while saving Account Grid Data: " + e);
		return false;
    }
	var arrayAccountFieldsForSave=['accounttype','accountcurrency','rakvaluepackage','statementfreq','debitcardreq','chequebookreq','receivecreditinterest','accountno'];
    for (var i = 3; i < rowCount; i++) 
	{
		var gridRow = "";
        var colCount = table.rows[i].cells.length;
        var currentrow = table.rows[i];
        for (var j = 0; j < arrayAccountFieldsForSave.length; j++) 
		{
            if (gridRow != "") 
			{
                gridRow = gridRow + "," + "'" + customform.document.getElementById(arrayAccountFieldsForSave[j]+i).value + "'";
            } 
			else 
			{
                gridRow = "'"+(i-2)+"','"+wi_name+"',"+"'" + customform.document.getElementById(arrayAccountFieldsForSave[j]+i).value+ "'";
            }
        }
        try 
		{
            var url = '/RAO/CustomForms/RAO_Specific/InsertAccountData.jsp?gridRow=' + gridRow+"&wi_name="+wi_name;
            var xhr;
            var ajaxResult;
            if (window.XMLHttpRequest)
                xhr = new XMLHttpRequest();
            else if (window.ActiveXObject)
                xhr = new ActiveXObject("Microsoft.XMLHTTP");
            xhr.open("POST", url, false);
            xhr.send();
			if (xhr.status == 200)
				{
					 ajaxResult = xhr.responseText;
					 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
					 if(ajaxResult=='-1')
					 {
						alert("Problem in saving Account Grid data");
						return false;
					 }
				}
        } 
		catch (e) 
		{
            alert("Exception while saving Account Grid Data:" + e);
			return false;
        }
    }
	return true;
}
function saveIdentificationDocData(cutomerRowcount,wi_name)
{
	//First Deleting saved data for current workitem*************************************************
	try 
	{
        var url = '/RAO/CustomForms/RAO_Specific/DeleteIndentificationDocsData.jsp?wi_name=' + wi_name+'&CUST_SR_NO='+cutomerRowcount;
        var req;
        if (window.XMLHttpRequest) {
            req = new XMLHttpRequest();
        } else if (window.ActiveXObject) {
            isIE = true;
            req = new ActiveXObject("Microsoft.XMLHTTP");
        }
		req.open("POST", url, false);
        req.send();
		if (req.readyState == 4 && req.status == 200) 
		{
			ajaxResult = req.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '')
			if(ajaxResult=='-1')
			{
				alert('Error while saving Customer Data');
				return false;
			}
		}
		else
		{
			alert('Error while saving Customer Data\n Response Status '+req.status);
			return false;
		}
    } 
	catch (e) 
	{
        alert("Exception while saving Customer Data: " + e);
		return false;
    }
	//******************************************************************************************************	
	var docCellValue=customform.document.getElementById('IDENTIFICATIONDOCID'+cutomerRowcount).innerHTML;
	var arrayRow=docCellValue.split('|');
	for(var k=0;k<arrayRow.length;k++)
	{
		var arrayCellValues=arrayRow[k].split('~');
		var cellValuesForSave='';
		for(var l=0;l<arrayCellValues.length;l++)
		{
			if(cellValuesForSave=='')
			{
				cellValuesForSave="'"+cutomerRowcount+"','"+(k+1)+"','"+wi_name+"',"+"'"+arrayCellValues[l]+"'";//Here cutomerRowcount  is for inserting sr no of customer row and K is for Doc Sr No and
			}
			else
			{
			cellValuesForSave=cellValuesForSave+","+"'" +arrayCellValues[l] + "'";
			}
		}
		try 
		{
            var url = '/RAO/CustomForms/RAO_Specific/InsertIdentificationDocs.jsp?cellValuesForSave=' + cellValuesForSave+"&wi_name="+wi_name;
            var xhr;
            var ajaxResult;
            if (window.XMLHttpRequest)
                xhr = new XMLHttpRequest();
            else if (window.ActiveXObject)
                xhr = new ActiveXObject("Microsoft.XMLHTTP");
            xhr.open("POST", url, false);
            xhr.send();
			if (xhr.status == 200)
				{
					 ajaxResult = xhr.responseText;
					 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
					 if(ajaxResult=='-1')
					 {
						alert("Problem in saving customer data");
						return false;
					 }
				}
				else
				{
					alert("Problem in saving customer data");
					return false;
				}
        } 
		catch (e) 
		{
            alert("Exception while saving customer data: " + e);
			return false;
        }
	}	
	return true;
}
function saveOECDGridData(cutomerRowcount,wi_name)
{
	//First Deleting saved data for current workitem*************************************************
	try 
	{
        var url = '/OECD/CustomForms/OECD_Specific/DeleteOECDData.jsp?wi_name=' + wi_name+'&CUST_SR_NO='+cutomerRowcount;
        var req;
        if (window.XMLHttpRequest) {
            req = new XMLHttpRequest();
        } else if (window.ActiveXObject) {
            isIE = true;
            req = new ActiveXObject("Microsoft.XMLHTTP");
        }
		req.open("POST", url, false);
        req.send();
		if (req.readyState == 4 && req.status == 200) 
		{
			ajaxResult = req.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '')
			if(ajaxResult=='-1')
			{
				alert('Error while saving Customer Data');
				return false;
			}
		}
		else
		{
			alert('Error while saving Customer Data\n Response Status '+req.status);
			return false;
		}
    } 
	catch (e) 
	{
        alert("Exception while saving Customer Data: " + e);
		return false;
    }
	//******************************************************************************************************	
	var docCellValue=customform.document.getElementById('OECDID'+cutomerRowcount).innerHTML;
	var arrayRow=docCellValue.split('|');
	for(var k=0;k<arrayRow.length;k++)
	{
		var arrayCellValues=arrayRow[k].split('~');
		var cellValuesForSave='';
		for(var l=0;l<arrayCellValues.length;l++)
		{
			if(cellValuesForSave=='')
			{
				cellValuesForSave="'"+cutomerRowcount+"','"+(k+1)+"','"+wi_name+"',"+"'"+arrayCellValues[l]+"'";//Here cutomerRowcount  is for inserting sr no of customer row and K is for Doc Sr No and
			}
			else
			{
			cellValuesForSave=cellValuesForSave+","+"'" +arrayCellValues[l] + "'";
			}
		}
		try 
		{
            var url = '/OECD/CustomForms/OECD_Specific/InsertOECDGridData.jsp?cellValuesForSave=' + cellValuesForSave+"&wi_name="+wi_name;
            var xhr;
            var ajaxResult;
            if (window.XMLHttpRequest)
                xhr = new XMLHttpRequest();
            else if (window.ActiveXObject)
                xhr = new ActiveXObject("Microsoft.XMLHTTP");
            xhr.open("POST", url, false);
            xhr.send();
			if (xhr.status == 200)
				{
					 ajaxResult = xhr.responseText;
					 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
					 if(ajaxResult=='-1')
					 {
						alert("Problem in saving customer data");
						return false;
					 }
				}
				else
				{
					alert("Problem in saving customer data");
					return false;
				}
        } 
		catch (e) 
		{
            alert("Exception while saving customer data: " + e);
			return false;
        }
	}	
	return true;
}
function saveUIDGridData() 
{	
	var table = customform.document.getElementById("uidtable");
	var ajaxResult='';
    var rowCount = table.rows.length;
	if(rowCount==3)//When no row added in grid
	return true;
	
    var wi_name =customform.document.getElementById("wdesk:WINAME").value;
    try 
	{
        var url = '/RAO/CustomForms/RAO_Specific/DeleteUIDData.jsp?wi_name=' + wi_name;
        var req;
        if (window.XMLHttpRequest) {
            req = new XMLHttpRequest();
        } else if (window.ActiveXObject) {
            isIE = true;
            req = new ActiveXObject("Microsoft.XMLHTTP");
        }
		req.open("POST", url, false);
        req.send();
		if (req.readyState == 4 && req.status == 200) 
		{
			ajaxResult = req.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '')
			if(ajaxResult=='-1')
			{
				alert('Error while saving UID Grid Data');
				return false;
			}
		}
		else
		{
			alert('Error while saving UID Grid Data\n Response Status '+req.status);
			return false;
		}
    } 
	catch (e) 
	{
        alert("Exception while saving UID Grid Data: " + e);
		return false;
    }
	var arrayUIDFieldsForSave=['uid','remark'];
    for (var i = 3; i < rowCount; i++) 
	{
		var gridRow = "";
        var colCount = table.rows[i].cells.length;
        var currentrow = table.rows[i];
        for (var j = 0; j < arrayUIDFieldsForSave.length; j++) 
		{
            if (gridRow != "") 
			{
                gridRow = gridRow + "," + "'" + customform.document.getElementById(arrayUIDFieldsForSave[j]+i).value + "'";
            } 
			else 
			{
                gridRow = "'"+(i-2)+"','"+wi_name+"',"+"'" + customform.document.getElementById(arrayUIDFieldsForSave[j]+i).value+ "'";
            }
        }
        try 
		{
            var url = '/RAO/CustomForms/RAO_Specific/InsertUIDData.jsp?gridRow=' + gridRow+"&wi_name="+wi_name;
            var xhr;
            var ajaxResult;
            if (window.XMLHttpRequest)
                xhr = new XMLHttpRequest();
            else if (window.ActiveXObject)
                xhr = new ActiveXObject("Microsoft.XMLHTTP");
            xhr.open("POST", url, false);
            xhr.send();
			if (xhr.status == 200)
				{
					 ajaxResult = xhr.responseText;
					 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
					 if(ajaxResult=='-1')
					 {
						alert("Problem in saving UID Grid data");
						return false;
					 }
				}
        } 
		catch (e) 
		{
            alert("Exception while saving UID Grid Data:" + e);
			return false;
        }
    }
	return true;
}
function validateAtDone(flag)
{
	return OnDoneValidation(flag);
}
function saveCustomerAndAccountData()
{
	var customerSaveStatus=saveCustomerData();
	if(customerSaveStatus)
	{
		var accountSaveStatus=saveAccountGridData();
		if(accountSaveStatus)
		{
			return true;
		}
		else
		return false;
	}
	else
	return false;
}
function saveException() 
{	
	var WSNAME = customform.document.getElementById("wdesk:CURRENT_WS").value;
    var WINAME = customform.document.getElementById("wdesk:WINAME").value;
	var checklistData = customform.document.getElementById('H_CHECKLIST').value;
    var xhr;
    if (window.XMLHttpRequest)
        xhr = new XMLHttpRequest();
    else if (window.ActiveXObject)
        xhr = new ActiveXObject("Microsoft.XMLHTTP");

    var url = "/OECD/CustomForms/OECD_Specific/SaveException.jsp?WINAME=" + WINAME + "&WSNAME=" + WSNAME + "&checklistData=" + checklistData;
    xhr.open("GET", url, false);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.send(null);
	
    if (xhr.status == 200 && xhr.readyState == 4) 
	{
        ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
        if (ajaxResult == 'NoRecord') {
            alert("No record found.");
            return false;
        } else if (ajaxResult == 'Error') {
            alert("Some problem in creating workitem.");
            return false;
        }
		else if(ajaxResult=='-1')
		 {
			alert("Error while loading customer data.");
			return false;
		 }
    } 
	else 
	{
        alert("Problem in saving exceptions.");
        return false;
    }
    return true;
}


//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :          This function is used to validate that signature should be viewed 

//***********************************************************************************//				
	
function setSignMatchValues(wsname,signMatchStatus)
{
	if(wsname == 'OPS_Maker') 
	{
		document.getElementById('wdesk:SIGN_MATCHED_MAKER').value = signMatchStatus;
	}
	
	else if(wsname == 'OPS_Checker')
	{
		document.getElementById('wdesk:SIGN_MATCHED_CHECKER').value = signMatchStatus;
	}	
}


//added below code for checklistdetails grid on 29102020 as a part of CR
function savechecklistData() 
{
    //alert("save checklistdata function");
	var table = customform.document.getElementById("checklistGrid");
	var ajaxResult='';
	var rowCount = table.rows.length;
	if(rowCount==0)//When no row added in grid
		return true;
	var WINAME=customform.document.getElementById("wdesk:WINAME").value;
	var WSNAME =customform.document.getElementById("wdesk:CURRENT_WS").value;	
	if(WSNAME!='OPS_Checker' && WSNAME!='RM')//When no row added in grid
		return true;
	var arrayChecklistFieldsForSave=['checklistdesc','optionId'];
	var gridRowAll = '';
	for (var i =1; i < rowCount+1; i++) 
	{
	   var gridRow = "";
	   var SRId=customform.document.getElementById("SRId"+i).value;
      
		if (gridRowAll != "") 
		{
			gridRowAll = gridRowAll + "" + SRId;
		}
		else
		{
		  gridRowAll = SRId;
		 } 
		 var checklistdesc = customform.document.getElementById('checklistdesc'+i).value;
			if (gridRowAll != "") 
			{
				gridRowAll = gridRowAll + "~" + checklistdesc;
			}
		 var value = customform.document.getElementById('option'+SRId).value;
		
			if (gridRowAll != "") 
			{
				gridRowAll = gridRowAll + "~" + value+"|";
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
		
		var url = '/OECD/CustomForms/OECD_Specific/InsertChecklistData.jsp';
		url=url.replace(/&amp;/g, 'ENCODEDAND');
		gridRowAll = gridRowAll.split("&").join("ENCODEDAND");
		gridRowAll = gridRowAll.split("%").join("ENCPERCENTAGE");
		var param = "gridRow="+gridRowAll+"&WINAME="+WINAME+"&WSNAME="+WSNAME;
		//param = encodeURIComponent(param);
		xhr.open("POST", url, false);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send(param);
		//console.log("xhr:" +xhr)
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
    
	return true;
	
	
	
}