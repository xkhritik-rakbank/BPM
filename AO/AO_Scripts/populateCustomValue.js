/*------------------------------------------------------------------------------------------------------
                                                NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group                                       									: Application -Projects
Project/Product                                               					: RAKBANK- AO
Module                                                            				: Populate and save custom values  
File Name                                                       				: populateCustomValue.js		 	
Author                                                             				: Amandeep
Date (DD/MM/YYYY)                         										: 2-Feb-2015
Description                                                      				: This file contains all function to populate custom values on
																				  form load
-------------------------------------------------------------------------------------------------------
CHANGE HISTORY
-------------------------------------------------------------------------------------------------------

Problem No/CR No   Change Date   Changed By    Change Description
------------------------------------------------------------------------------------------------------*/

window.document.write("<script src=\"/webdesktop/webtop/scripts/SRM_Scripts/SRM_constants.js\"></script>");

function getDocHeight(doc) {
    doc = doc || document;
    var body = doc.body, html = doc.documentElement;
    var height = Math.max(body.scrollHeight,body.offsetHeight,html.clientHeight,html.scrollHeight,html.offsetHeight);
    return height;
}

function populateCustomValue(columnList,frameName,selGridModifyBundleID,CategoryID,SubCategoryID,sMode){
	//
}

function customValidationOnSave(columnList,frameName,CategoryID,SubCategoryID){
	//In this function Write Custom Validation and code	on change of grid data.	
	var WSNAME = document.getElementById('WS_NAME').value;	
	return true;
}

function customValidationOnAdd(columnList,frameName,CategoryID,SubCategoryID){
	//In this function Write Custom Validation and code	on Add of grid row.
	return true;
}

function customOnLoad()
{
	var WSNAME = document.getElementById('WS_NAME').value;               
	if(WSNAME=='OPS_Checker')
	{
		var makerDecision = window.parent.document.getElementById("OPSMakerDecision").value;
		var accountNumbers=document.getElementById("1_Account_No_2").options.length;
		var accountsFetched =false;
		if(accountNumbers!='0')
				accountsFetched=true;
		if(makerDecision!='Data Entry Done' )
		{
			document.getElementsByName("Fetch")[0].disabled=true;
		}
		else if(!accountsFetched)                           
		{
			document.getElementsByName("Fetch")[0].disabled=false;
		}
		else
		{
			document.getElementsByName("Fetch")[0].disabled=true;
		}
		//if no account no.s fetched, then rvc/imd to be disabled
		if(!accountsFetched)    
		document.getElementById("1_RVC_IMD_Req").disabled=true;                                              
		if(makerDecision=='RVC/IMD Done')
		document.getElementById("1_RVC_IMD_Req").disabled=true;
		if(makerDecision=='Exception Found')
		document.getElementById("1_RVC_IMD_Req").disabled=true;
}
	parent.resizeIframe(parent.document.getElementById("frmData"));
	if(WSNAME!="Archival Team" && WSNAME!="Error")
	document.getElementsByName("Exceptions for Approval")[0].click();
}

function ValidateDate(){
	
	var CategoryID = document.getElementById("CategoryID").value;
	var SubCategoryID = document.getElementById("SubCategoryID").value;	
}

function replaceUrlChars(sUrl){	
	return sUrl.split("+").join("ENCODEDPLUS");
}

function customValidationOnIntroduce(columnList,frameName,CategoryID,SubCategoryID,donefrm,fobj){
	var customform='';
	if(donefrm=='custom'){	
		customform=fobj;
	}
	else{
		var formWindow=getWindowHandler(windowList,"formGrid");
		customform=formWindow.frames['customform'];
	}
	var iframe = customform.document.getElementById("frmData");
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;	
	var WSNAME = iframeDocument.getElementById('WS_NAME').value;
	
	return true;
}

function myTrim1(x) {
    return x.replace(/^\s+|\s+$/gm,'');
}

function Trim1(x) {
    return x.replace(/^\s+|\s+$/gm,'');
}