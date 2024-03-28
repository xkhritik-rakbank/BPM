/*------------------------------------------------------------------------------------------------------
                                                NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group                                       									: Application -Projects
Project/Product                                               					: RAKBANK- AO
Application                                                      				: Account Opening
Module                                                            				: FormLoad Options 
File Name                                                       				: formLoad_AO.js		 	
Author                                                             				: Amandeep
Date (DD/MM/YYYY)                         										: 2-Feb-2015
Description                                                      				: This file contains all function definitions
																				  required at form load
-------------------------------------------------------------------------------------------------------
CHANGE HISTORY
-------------------------------------------------------------------------------------------------------

Problem No/CR No   Change Date   Changed By    Change Description
------------------------------------------------------------------------------------------------------*/

function Trim(val,character){
	if(typeof character=='undefined')
		character = ' ';
	val = new String(val);
	var len = val.length;
    if(len != 0){
		while(1){
			if(val.charAt(0) != character){
				break;
			}
			else{
				val = val.substr(1);
			}
		}
	}
	len = val.length;
	if(len != 0){
		while(1){
			if(val.charAt(len - 1) != character){
				return val;
			}
			else{
				len -= 1;
				val = val.substr(0,len);
			}
		}
	}
    return val;
}
function params() {
    var WSNAME;
    var loggedInUser;  
     
}

function replaceAll(string, find, replace) {
  return string.replace(new RegExp(escapeRegExp(find), 'g'), replace);
}

function escapeRegExp(string) {
    return string.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
}

function getDateTime() {
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

//added by stutee.mishra
var dialogToOpenType = null;
var updatedValue;
var rejectReasonFieldType;
var currentWSNAME;
var checklistFieldType;
function setValue(val1) 
{
   //you can use the value here which has been returned by your child window
   updatedValue = val1;
   if(dialogToOpenType == 'Reject Reasons'){
	   if (updatedValue!="NO_CHANGE" && updatedValue!='[object Window]'){
		    window.parent.window.document.getElementById(rejectReasonFieldType).value=decodeURIComponent(updatedValue);
			if(currentWSNAME=='OPS_Checker' && document.getElementById("1_Account_No_2").options.length==0)
			{
				var OPSMakerDecision=window.parent.window.document.getElementById("OPSMakerDecision").value;
				var exceptionStatus = IsExceptionRaised(currentWSNAME,WINAME,window.parent.window.document.getElementById("H_Checklist").value);
				
				var rejectReasonsSelected = false;
				if(updatedValue!='')
					rejectReasonsSelected=true;//val4
				if(exceptionStatus=='0' && !rejectReasonsSelected && (OPSMakerDecision=='Data Entry Done'||OPSMakerDecision=='Exception Found'))
				{
					document.getElementsByName("Fetch")[0].disabled=false;
				}
				else
				{
					document.getElementsByName("Fetch")[0].disabled=true;
				}
			}
	   }
			
   }else if(dialogToOpenType == 'Exception Checklist'){
	    if (updatedValue!="NO_CHANGE" && updatedValue!='[object Window]'){
			    window.parent.window.document.getElementById(checklistFieldType).value=decodeURIComponent(updatedValue);
				if(currentWSNAME=='OPS_Checker' && document.getElementById("1_Account_No_2").options.length==0)
				{
					var OPSMakerDecision=window.parent.window.document.getElementById("OPSMakerDecision").value;
					var exceptionStatus = IsExceptionRaised(currentWSNAME,WINAME,updatedValue);
					var H_RejectReasons=window.parent.window.document.getElementById("H_RejectReasons").value;
					var rejectReasonsSelected = false;
					if(H_RejectReasons!='')
						rejectReasonsSelected=true;//val4
					if(exceptionStatus=='0' && !rejectReasonsSelected && (OPSMakerDecision=='Data Entry Done'||OPSMakerDecision=='Exception Found'))
					{
						document.getElementsByName("Fetch")[0].disabled=false;
					}
					else
					{
						document.getElementsByName("Fetch")[0].disabled=true;
					}

				}				
			
			
				if(window.parent.window.document.getElementById("CheckListViewed").value!='Y' && currentWSNAME=='CB-WC Maker')
				{
					alert('You can Upload/Add Documents/Images. ');
					window.parent.window.document.getElementById("CheckListViewed").value="Y";
				}
				
				return true;
		}
	   
   }
}
//ends here.

function clickFunction(event,labelname){
	var username=window.parent.window.document.getElementById("username").value;
	var WSNAME = document.getElementById("WS_NAME").value;
	currentWSNAME = WSNAME;
	var H_Checklist="";
	var checklistField="";
	var labelname=labelname.replace('*','');
	var WINAME = document.getElementById("1_Workitem_Number").value;
	
	
	
	if(event=='onclick')
	{
		if(labelname=='Reject Reasons'){
			dialogToOpenType='Reject Reasons';
			var isURL2=false;
			var rejectReasonField="";
			if (WSNAME=='PB_Credit')
			{
				rejectReasonField="PBCreditRejectReasons";
			}	
			else if (WSNAME=='SME_Controls')
			{
				rejectReasonField="SMECtrlRejectReasons";
			}	
			else if (WSNAME=='WM_Controls')
			{
				rejectReasonField="WMCtrlRejectReasons";
			}	
			else if (WSNAME=='Branch_Controls')
			{
				rejectReasonField="BranchCtrlRejectReasons";
			}	
			else if (WSNAME=='OPS_Maker')
			{
				rejectReasonField="H_RejectReasons";
				isURL2=true;
			}	
			else if (WSNAME=='OPS_Checker')
			{
				rejectReasonField="H_RejectReasons";
				isURL2=true;
			}	
			else
			{
				rejectReasonField="H_RejectReasons";
			}	
				
			rejectReasonFieldType = rejectReasonField;
			var reasonCodes=window.parent.window.document.getElementById(rejectReasonField).value;			
			
			if (WSNAME=='CSO_Rejects')
			{    
			
				var SMEReasonCodes=	window.parent.window.document.getElementById("SMECtrlRejectReasons").value;
				window.parent.window.document.getElementById("alertDisplayed").value="done";
				
				if(reasonCodes!='')
				{
					if(SMEReasonCodes!='') 
						reasonCodes+="#"+SMEReasonCodes;
				}
				else
					reasonCodes=SMEReasonCodes;
					
				var WMReasonCodes=	window.parent.window.document.getElementById("WMCtrlRejectReasons").value;
				if(reasonCodes!='')
				{
					if(WMReasonCodes!='') 
						reasonCodes+="#"+WMReasonCodes;
				}
				else
					reasonCodes=WMReasonCodes;
					
				var BranchReasonCodes=	window.parent.window.document.getElementById("BranchCtrlRejectReasons").value;
				if(reasonCodes!='')
				{
					if(BranchReasonCodes!='') 
						reasonCodes+="#"+BranchReasonCodes;
				}
				else
					reasonCodes=BranchReasonCodes;
					
				var PBCreditRReasonCodes=window.parent.window.document.getElementById("PBCreditRejectReasons").value;
				if(reasonCodes!='')
				{
					if(PBCreditRReasonCodes!='') 
						reasonCodes+="#"+PBCreditRReasonCodes;
				}
				else
					reasonCodes=PBCreditRReasonCodes;
				
			}
			
			//url edited for Email CR 08/11/2015
			var url="Reject_Reasons.jsp?ReasonCodes="+encodeURIComponent(reasonCodes)+"&WSNAME="+WSNAME+"&WINAME="+WINAME+"&username="+username;
			var target="_blank";
			//var windowParams="dialogWidth:450px; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:no; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no; modal=yes";
			var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
			
			if(!isURL2 && reasonCodes.indexOf(":")>=0)
				isURL2=true;
			
			if(isURL2)	
			{
				//url edited for Email CR 08/11/2015
				url="Documents_List.jsp?docList="+encodeURIComponent(reasonCodes)+"&WSNAME="+WSNAME+"&WINAME="+WINAME+"&username="+username;
				//windowParams="dialogWidth:650px; dialogHeight:580px; center:yes;edge:raised; help:no; resizable:no; scroll:no; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;";
				windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
			}	
			//window.open(url,"_blank",windowParams);
			//alert(url);
			//commented below as window.showModalDialog works only in IE by stutee.mishra
			//var updatedValue = window.showModalDialog(url,target,windowParams);
			
			//added below to handle window.open/window.showModalDialog according to type of browser by stutee.mishra starts here.
			/***********************************************************/
			//var updatedValue;
			if (window.showModalDialog) {
			  updatedValue = window.showModalDialog(url,target,windowParams);
			} else {
			  updatedValue = window.open(url,target,windowParams);
			}
            /************************************************************/
			//added below to handle window.open/window.showModalDialog according to type of browser by stutee.mishra ends here.
			if(updatedValue=="NO_CHANGE" || updatedValue=='[object Window]')
			{
				return true;
			}	
			else	
			{
				window.parent.window.document.getElementById(rejectReasonField).value=decodeURIComponent(updatedValue);
				if(WSNAME=='OPS_Checker' && document.getElementById("1_Account_No_2").options.length==0)
				{
					var OPSMakerDecision=window.parent.window.document.getElementById("OPSMakerDecision").value;
					var exceptionStatus = IsExceptionRaised(WSNAME,WINAME,window.parent.window.document.getElementById("H_Checklist").value);
					
					var rejectReasonsSelected = false;
					if(updatedValue!='')
						rejectReasonsSelected=true;//val4
					if(exceptionStatus=='0' && !rejectReasonsSelected && (OPSMakerDecision=='Data Entry Done'||OPSMakerDecision=='Exception Found'))
					{
						document.getElementsByName("Fetch")[0].disabled=false;
					}
					else
					{
						document.getElementsByName("Fetch")[0].disabled=true;
					}
				}
			}	
		}
		else if(labelname=='Exception Checklist'){
			
			//Code added to compare number of applicants on the signature page of the form to the number of signatures auto-cropped
			dialogToOpenType = 'Exception Checklist';
			if(WSNAME=='OPS_Maker')
			{
			var count=0;
			
			var arrAvailableDocList = window.parent.window.parent.window.document.getElementById('wdesk:docCombo');		
			for(var iDocCounter=0;iDocCounter<arrAvailableDocList.length;iDocCounter++)
			  {
				if(arrAvailableDocList[iDocCounter].text.toUpperCase().indexOf('SIGNATURE_')>-1)
				{
			     count++;
				}
              }
			  
			window.parent.window.document.getElementById("NoOfSignatures").value=count;			
            var isSignAttached=false;
			for(var iDocCounter1=0;iDocCounter1<arrAvailableDocList.length;iDocCounter1++)
			  { 					    
				if(arrAvailableDocList[iDocCounter1].text.toUpperCase().indexOf('SIGNATURE_1')>-1)
				{
			     isSignAttached=true;
				  break;
				}
              } 
			  if(!isSignAttached)
			  {
			   alert("Signature is mandatory. Please crop the signatures manually.");
			  }
			}
			
			if(WSNAME=='OPS_Checker')
			{
			 //alert(window.parent.window.document.getElementById("IsSignatureCropped").value);
			 var SignatureCropped=window.parent.window.document.getElementById("IsSignatureCropped").value;
			 if(SignatureCropped=='Y')
			 {
			   alert("Signatures were manually cropped by OPS Maker. Please review the signatures.");
			 }
			}
			checklistField="H_Checklist";		
			//alerwindow.parent.window.document.getElementById(checklistField).value);
				
			H_Checklist=window.parent.window.document.getElementById(checklistField).value;
			var segment = document.getElementById("1_Segment").value;	
			params.WSNAME = WSNAME;
			params.loggedInUser=username;
			H_Checklist=replaceAll(H_Checklist,"Exception Raised","ER");//To handle too much unsaved data at one step
			H_Checklist=replaceAll(H_Checklist,"Exception Unraised","EU");//To handle too much unsaved data at one step
			var updatedValue = '';
			//var updatedValue = window.showModalDialog("Exception_Checklist.jsp?WINAME="+WINAME+"&WSNAME="+WSNAME+"&segment="+segment+"&H_CHECKLIST="+encodeURIComponent(H_Checklist)+"&username="+username,params, "dialogWidth:850px; dialogHeight:600px; center:yes;edge:raised; help:no; resizable:no; scroll:no; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
			
			//added below to handle window.open/window.showModalDialog according to type of browser by stutee.mishra starts here.
			/***********************************************************/
			checklistFieldType = checklistField;
			var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
			if (window.showModalDialog) {
			    updatedValue = window.showModalDialog("Exception_Checklist.jsp?WINAME="+WINAME+"&WSNAME="+WSNAME+"&segment="+segment+"&H_CHECKLIST="+encodeURIComponent(H_Checklist)+"&username="+username,params,"dialogWidth:850px; dialogHeight:600px; center:yes;edge:raised; help:no; resizable:no; scroll:no; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
			} else {
		        updatedValue = window.open("Exception_Checklist.jsp?WINAME="+WINAME+"&WSNAME="+WSNAME+"&segment="+segment+"&H_CHECKLIST="+encodeURIComponent(H_Checklist)+"&username="+username,params,windowParams);
			}
            /************************************************************/
			//added below to handle window.open/window.showModalDialog according to type of browser by stutee.mishra ends here.
			
			if(updatedValue=="NO_CHANGE" || updatedValue=='[object Window]')
			{
				//
				//return true;
			}	
			else	
			{
				window.parent.window.document.getElementById(checklistField).value=decodeURIComponent(updatedValue);
				if(WSNAME=='OPS_Checker' && document.getElementById("1_Account_No_2").options.length==0)
				{
					var OPSMakerDecision=window.parent.window.document.getElementById("OPSMakerDecision").value;
					var exceptionStatus = IsExceptionRaised(WSNAME,WINAME,updatedValue);
					var H_RejectReasons=window.parent.window.document.getElementById("H_RejectReasons").value;
					var rejectReasonsSelected = false;
					if(H_RejectReasons!='')
						rejectReasonsSelected=true;//val4
					if(exceptionStatus=='0' && !rejectReasonsSelected && (OPSMakerDecision=='Data Entry Done'||OPSMakerDecision=='Exception Found'))
					{
						document.getElementsByName("Fetch")[0].disabled=false;
					}
					else
					{
						document.getElementsByName("Fetch")[0].disabled=true;
					}

				}				
			
			
			if(window.parent.window.document.getElementById("CheckListViewed").value!='Y' && WSNAME=='CB-WC Maker')
			{
				alert('You can Upload/Add Documents/Images. ');
				window.parent.window.document.getElementById("CheckListViewed").value="Y";
			}
			
			return true;
			}
		}
		else if(labelname=='Fetch'){
			//Call JSP for A/c No Fetch Call
			
			var blockUrl="/webdesktop/CustomForms/AO_Specific/FetchAccounts.jsp?CIFID="+document.getElementById('1_CIF_Id').value+"&SRNo="+document.getElementById('1_FINACLE_SR_No').value;
			
			blockUrl=replaceUrlChars(blockUrl);			
			var ResponseList;	
			var xhr;
			var ajaxResult;
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			//window.open(blockUrl);
			 xhr.open("GET",blockUrl,false); 
			 xhr.send(null);
			if (xhr.status == 200 && xhr.readyState == 4)
			{
				ajaxResult=Trim(xhr.responseText);
				//alert(ajaxResult);
			}
			else
			{
				alert("Error while fetching accounts");
				return false;
			}
			ResponseList = ajaxResult.split("~");
			var responseMainCode=ResponseList[0];
			var responseAccountNo=ResponseList[1].split('#');
			
			if(responseMainCode=='0')
			{
				var i;
				var select=document.getElementById("1_Account_No_2");
				var requiredAccount=document.getElementById("1_No_of_Accounts").value;
				for(i = select.options.length-1; i >=0; i--) {					
						select.remove(i);						
				}
				
				for(i=0; i<responseAccountNo.length; i++)
				{
					var opt = document.createElement('option');
					opt.value = responseAccountNo[i];
					opt.innerHTML = responseAccountNo[i];
					opt.className="EWNormalGreenGeneral1";
					select.appendChild(opt);					
				}
				if(responseAccountNo.length<requiredAccount)
					document.getElementById("1_Account_No_1").disabled=false;	
				if(responseAccountNo.length!=0)
				{
					document.getElementsByName("Fetch")[0].disabled=true;	
					//document.getElementById("1_RVC_IMD_Req").disabled=false;		//commented for rvc imd change				
				}	
			}
			else
			{
				alert("Error while fetching accounts");
			}			
		}
		else if(labelname=='Upload'){
			//Upload Fetch Call
			
			var sUrl="/webdesktop/CustomForms/AO_Specific/UploadSignatures.jsp?WINAME="+WINAME;
			window.open(sUrl,"_blank", "dialogWidth:1050px; dialogHeight:600px; center:yes;edge:raised; help:no; resizable:no; scroll:no; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
										
		}
	}	
	else if(event=='onblur')
	{
	
	    if(labelname=='FINACLE SR. No.')
		{
		document.getElementById('1_FINACLE_SR_No').value=document.getElementById('1_FINACLE_SR_No').value.toUpperCase();
		}
		if(labelname=='Decision')
		{
			//validate dcision			
			var decision=document.getElementById('1_Decision').value;
			var MH_Checklist="";
			var updateRecord="";
			
			checklistField="H_Checklist";		
				
			H_Checklist=window.parent.window.document.getElementById(checklistField).value;
			
			if(WSNAME.indexOf('Controls')>-1)
			{
				
			}
			else if(WSNAME==('PB_Credit'))
			{
				
			}
			else if(WSNAME==('OPS_Maker'))
			{
				//
			}
			else if(WSNAME==('OPS_Checker'))
			{
				//
			}
			else if(WSNAME==('AML_Compliance'))
			{
			
			}
			else if(WSNAME==('Error'))
			{
				//
			}
			else if(WSNAME==('CSO_Rejects'))
			{
				
			}
			else if(WSNAME=='CSM')
			{
				
			}
		}
	}	
	return true;
}
function IsExceptionRaised(WSNAME,workitemName,H_Checklist)
{
	var ajaxReq;
	if (window.XMLHttpRequest) {
		ajaxReq= new XMLHttpRequest();
	} else if (window.ActiveXObject) {
		ajaxReq= new ActiveXObject("Microsoft.XMLHTTP");
	}
				
	var url = "/webdesktop/CustomForms/AO_Specific/CheckIfExceptionRaised.jsp?CheckFor="+WSNAME+"&WorkitemName="+workitemName+"&H_Checklist="+H_Checklist;

	ajaxReq.open("POST",url,false); 
	ajaxReq.setRequestHeader('Content-Type','application/x-www-form-urlencoded');	
	ajaxReq.send(null);
	if (ajaxReq.status == 200 && ajaxReq.readyState == 4) 
	{
		var result=ajaxReq.responseText.split("~");
		return  result[0];
	}
	else
	{
		alert("some error occured while fetching exception status");
		return -1;
	}
}
function formLoadCheck(){
	//Do Nothing
}
function setCharAt(str,index,chr) {
    if(index > str.length-1) return str;
    return str.substr(0,index) + '~' +chr + str.substr(index+1)+']';
}
