//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 			12-01-2018, Modified by Nikita 
//Author                      :           
//Description                 :           Function validates on click of Introduce
//***********************************************************************************//

try
{
var pname=window.parent.strprocessname;
//if(pname=='RAO')
//{
window.document.write("<script src="+"/RBL/webtop/scripts/RBL_Script/MandatoryFieldValidation.js"+"></script>");
window.document.write("<script src="+"/RBL/webtop/scripts/RBL_Script/FieldValidation.js"+"></script>");
}
catch(ex){
    //added by Nishant Parmar (04 AUG 16):
    alert("#EXCEPTION occured: "+ex);
}

function SaveClick() 
{
		//saveDeferralGridData();
		var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
		if(WSNAME=='Quality_Control' || WSNAME=='Junior_Checker' || WSNAME=='Senior_Checker' || WSNAME=='Quality_Control_Additional' || WSNAME=='AU_Officer')
			saveUIDGridData();
		if(WSNAME=='AttachAdditionalDocs' || WSNAME=='Attach_Final_Docs' || WSNAME=='CROPS_DocsChecker' || WSNAME=='CROPS_DataEntryMaker' || WSNAME=='CROPS_DataEntChecker' || WSNAME=='Deferral_Checker')
			saveDeferralGridData();
		//RMTSAVEDATA(true);
		return true;
}

function IntroduceClick() 
{
	//alert("introduce click");
	var flag="I";
	//alert("Exception raised is "+customform.document.getElementById("H_CHECKLIST").value);
    //var validateStatus=validateAtDone(flag);
	
	//alert("validate status"+validateStatus);
	saveException();
	if(true)
	{
		RMTSAVEDATA(true);
		alert("The request has been submitted successfully.");
		return true;
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
	var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
	var validateStatus=OnDoneValidation(flag);
	if(validateStatus)
	{
		var validateAtDoneStatus= validateAtDone(flag);
		if(validateAtDone){
			saveException();
			if(WSNAME=="AU_Doc_Checker"|| WSNAME=="AttachAdditionalDocs" || WSNAME=="AU_Analyst" || WSNAME=="AU_Officer")
				saveRMMailId();
			if(WSNAME=='Quality_Control' || WSNAME=='Junior_Checker' || WSNAME=='Senior_Checker' || WSNAME=='Quality_Control_Additional' || WSNAME=='AU_Officer')
				saveUIDGridData();
			if(WSNAME=='AttachAdditionalDocs' || WSNAME=='Attach_Final_Docs' || WSNAME=='CROPS_DocsChecker' || WSNAME=='CROPS_DataEntryMaker' || WSNAME=='CROPS_DataEntChecker' || WSNAME=='Deferral_Checker')
				saveDeferralGridData();
			if(RMTSAVEDATA(true) == true)
			{
				alert("The request has been submitted successfully.");
				return true;
			} else
				return false;
		}
		else{
			return false;
		}
	}
	else
	return false;
}

function validateAtDone(flag)
{
			var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
			if(WSNAME=="AU_Officer" || WSNAME=="AU_Analyst" || WSNAME=="AU_Doc_Checker" || WSNAME=="AU_Data_Entry" || WSNAME=="AU_Manager")
			{
				//Service request has not grid
				if(checkDuplicateWorkitems())
				{
					return true;	
				}
				else
				{
					return false;
				}
			}
			else {
				return true;
			}
}

function RMTSAVEDATA(IsDoneClicked) 
{	
	var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
    var WINAME = customform.document.getElementById("wdesk:WI_NAME").value;
	var rejectReasons = customform.document.getElementById('rejReasonCodes').value;
    var Decision = '';
	Decision = customform.document.getElementById("selectDecision").value;
   
    var Remarks = customform.document.getElementById('wdesk:Remarks').value;
	Remarks=Remarks.replace(/&/g,'AMPNDCHAR');
	Remarks = Remarks.split(",").join("CCCOMMAAA");
	//for inserting decision in decision history
    var xhr;
    if (window.XMLHttpRequest)
        xhr = new XMLHttpRequest();
    else if (window.ActiveXObject)
        xhr = new ActiveXObject("Microsoft.XMLHTTP");
    var abc = Math.random;

    var url = "/RBL/CustomForms/RBL_Specific/SaveHistory.jsp";
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
function saveRMMailId()
{
	var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
	var RMCode=customform.document.getElementById("wdesk:RMCode").value;
	//for inserting decision in decision history
    var xhr;
    if (window.XMLHttpRequest)
        xhr = new XMLHttpRequest();
    else if (window.ActiveXObject)
        xhr = new ActiveXObject("Microsoft.XMLHTTP");
    var abc = Math.random;

    var url = "/RBL/CustomForms/RBL_Specific/GetRMMailId.jsp";
    var param = "WSNAME=" + WSNAME +"&RMCode="+RMCode;

    xhr.open("POST", url, false);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.send(param);
	
    if (xhr.status == 200 && xhr.readyState == 4) {
        ajaxResult = Trim(xhr.responseText);
		//alert('ajaxResult is '+ajaxResult);
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
	if(ajaxResult!=-1 || ajaxResult!="")
		customform.document.getElementById("wdesk:RM_MailId").value=ajaxResult;
    return true;
}

function saveException() 
{	
	var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
    var WINAME = customform.document.getElementById("wdesk:WI_NAME").value;
	var checklistData = customform.document.getElementById('H_CHECKLIST').value;
	var checklistDataAtLoad = customform.document.getElementById('H_CHECKLIST_TEMP').value;
	
	if (checklistData == '' || checklistData == 'null')
		return true;
	
	if (checklistDataAtLoad != '')	
		checklistData = checklistData.replace(checklistDataAtLoad,''); // replacing the characters
	
	if (checklistData == '' || checklistData == 'null')
		return true;
	
    var xhr;
    if (window.XMLHttpRequest)
        xhr = new XMLHttpRequest();
    else if (window.ActiveXObject)
        xhr = new ActiveXObject("Microsoft.XMLHTTP");

    var url = "/RBL/CustomForms/RBL_Specific/SaveException.jsp";
	var param = "&WINAME=" + WINAME + "&WSNAME=" + WSNAME + "&checklistData=" + checklistData;
    xhr.open("POST", url, false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.send(param);
	
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


function saveUIDGridData() 
{	
	var table = customform.document.getElementById("UIDGrid");
	var ajaxResult='';
    var rowCount = table.rows.length;
	/*if(rowCount==3)//When no row added in grid
	return true;*/
	
    var wi_name =customform.document.getElementById("wdesk:WI_NAME").value;
	var WSNAME =customform.document.getElementById("wdesk:Current_WS").value;
	var arrayUIDFieldsForSave=['uid','remark'];
	var gridRowAll = '';
    for (var i = 3; i < rowCount; i++) 
	{
		var gridRow = "";
        var colCount = table.rows[i].cells.length;
        var currentrow = table.rows[i];
        for (var j = 0; j < arrayUIDFieldsForSave.length; j++) 
		{
			if (arrayUIDFieldsForSave[j] == 'uid' && customform.document.getElementById(arrayUIDFieldsForSave[j]+i).value == '')
			{
				gridRow = '';
				break;
			} 
			if (gridRow != "") 
			{
				gridRow = gridRow + "~" + customform.document.getElementById(arrayUIDFieldsForSave[j]+i).value ;
			} 
			else 
			{
				gridRow = i-2+"~"+ customform.document.getElementById(arrayUIDFieldsForSave[j]+i).value;
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
    }
		/*if (gridRowAll == '')	
			return true;*/
        try 
		{
            var url = "/RBL/CustomForms/RBL_Specific/InsertUIDData.jsp";
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
	return true;
}

function saveDeferralGridData() 
{	
	var table = customform.document.getElementById("DeferralGrid");
	var ajaxResult='';
    var rowCount = table.rows.length;
	if(rowCount==3)//When no row added in grid
	return true;
	
    var wi_name =customform.document.getElementById("wdesk:WI_NAME").value;
    try 
	{
        var url ="/RBL/CustomForms/RBL_Specific/DeleteDeferralData.jsp";
		var param = "&wi_name=" + wi_name;
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
				alert('Error while Deleting old Deferral Grid Data');
				return false;
			}
			customform.document.getElementById("wdesk:Deferral_Held").value = 'No';
		}
		else
		{
			alert('Error while deleting old deferral Grid Data\n Response Status '+req.status);
			return false;
		}
    } 
	catch (e) 
	{
        alert("Exception while deleting Deferral Grid Data: " + e);
		return false;
    }
	var arrayDeferralFieldsForSave=['doctype','appauth','defexpdate','status'];
    for (var i = 3; i < rowCount; i++) 
	{
		var gridRow = "";
        var colCount = table.rows[i].cells.length;
        var currentrow = table.rows[i];
        for (var j = 0; j < arrayDeferralFieldsForSave.length; j++) 
		{
			
            if (gridRow != "") 
			{
                gridRow = gridRow + "," + "'" + customform.document.getElementById(arrayDeferralFieldsForSave[j]+i).value + "'";
            } 
			else 
			{
                gridRow = "'"+(i-2)+"','"+wi_name+"',"+"'" + customform.document.getElementById(arrayDeferralFieldsForSave[j]+i).value+ "'";
            }
        }
        try 
		{
            var url = "/RBL/CustomForms/RBL_Specific/InsertDeferralData.jsp";
			var param="&gridRow=" + gridRow+"&wi_name="+wi_name;
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
					alert("Problem in saving Deferral Grid data");
					return false;
				 }
				 if(ajaxResult=='0')
				 {
					customform.document.getElementById("wdesk:Deferral_Held").value = 'Yes';
				 }
			}
        } 
		catch (e) 
		{
            alert("Exception while saving Deferral Grid Data:" + e);
			return false;
        }
    }
	return true;
}



function addrowUID(arrayUIDRowValues, CurrentWS)
{
		if(arrayUIDRowValues!='')
		{
			arrayUIDRowValues=arrayUIDRowValues.split("~");
		}
		
		
		var table = document.getElementById("UIDGrid");
		var table_len=table.rows.length;
		var lastRow = table.rows[ table.rows.length-1 ];
		var row = table.insertRow();
		
		var cell = row.insertCell(0);
		var srno = 'srno'+table_len;
		cell.innerHTML="<input type='text' readonly='readonly' maxlength='20' id='srno"+table_len+"'>";
		document.getElementById("srno"+table_len).value=table_len-2;
		
		var cell = row.insertCell(1);
		var uid = 'uid'+table_len;
		//alert("UId is "+uid);
		cell.innerHTML="<input type='text' maxlength='20' size='25' id='uid"+table_len+"' onblur='ValidateAlphaNumeric(this.id);'>";
		if(arrayUIDRowValues!='')
		document.getElementById("uid"+table_len).value=arrayUIDRowValues[0];
		
		var cell = row.insertCell(2);
		var remarksid = 'remark'+table_len;
		cell.innerHTML="<textarea maxlength='2000' rows='2' cols='50' id='remark"+table_len+"' onkeyup='checkRemarksUID(this.id);'></textarea>";
		if(arrayUIDRowValues!='')
		document.getElementById("remark"+table_len).value=arrayUIDRowValues[1];
		
		cell = row.insertCell(3);
		var deleteid='image'+table_len;
		cell.innerHTML = "<img id='image"+table_len+"' src='/RBL/webtop/images/delete.gif' style='width:21px;height:21px;border:0'; onclick='deleteRowsFromUIDGridWithIndex();'>";	
		
		var UIDDisable=document.getElementById("uid"+table_len);
		var remarksDisable=document.getElementById("remark"+table_len);
		var deleteDisable=document.getElementById(deleteid);
		var SRNoDisable=document.getElementById("srno"+table_len);
		deleteDisable.disabled=true;
		SRNoDisable.disabled=true;
		
		if(CurrentWS =='Quality_Control' || CurrentWS =='Quality_Control_Additional')
		{
			UIDDisable.disabled=false;
			deleteDisable.disabled=false;
		}
		else
		{
			UIDDisable.disabled=true;
			deleteDisable.disabled=true;
		}
		if(CurrentWS =='Junior_Checker' || CurrentWS=='Senior_Checker' || CurrentWS=='AU_Officer')
		{
			remarksDisable.disabled=false;
		}
		else
		{
			remarksDisable.disabled=true;
		}
}

function addrowDeferral(arrayDeferralRowValues, CurrentWS)
{
		if(arrayDeferralRowValues!='')
		{
			arrayDeferralRowValues=arrayDeferralRowValues.split("~");
		}
		
		
		var table = document.getElementById("DeferralGrid");
		var srNo=table.rows.length-2;
		var table_len=table.rows.length;
		var lastRow = table.rows[ table.rows.length-1 ];
		var row = table.insertRow();
		
		var cell = row.insertCell(0);
		var srno = 'srno'+table_len;
		cell.innerHTML="<input type='text' readonly='readonly' maxlength='20' id='srno"+table_len+"'>";
		document.getElementById("srno"+table_len).value=srNo;
		document.getElementById("srno"+table_len).value=srNo;
		
		var cell = row.insertCell(1);
		var doctype = 'doctype'+table_len;
		//alert("UId is "+uid);
		cell.innerHTML="<input type='text' maxlength='20' size='25' id='doctype"+table_len+"' onblur='ValidateAlphaNumeric(\""+doctype+"\");'>";
		if(arrayDeferralRowValues!='')
		document.getElementById("doctype"+table_len).value=arrayDeferralRowValues[0];
		
		var cell = row.insertCell(2);
		var appauth='appauth'+table_len;
		cell.innerHTML="<input type='text' maxlength='20' size='25' id='appauth"+table_len+"' onblur='ValidateAlphaNumeric(\""+appauth+"\");'>";
		if(arrayDeferralRowValues!='')
		document.getElementById("appauth"+table_len).value=arrayDeferralRowValues[1];
	
		
		var cell = row.insertCell(3);
		var defexpdate  = 'defexpdate'+table_len;
		cell.innerHTML="<input type='text' id='defexpdate"+table_len+"'>&nbsp;<img src='/RBL/webtop/images/cal.gif' id='calendar"+table_len+"'  onclick='initialize(\""+defexpdate+"\");'/>";
		if(arrayDeferralRowValues!='')
			document.getElementById("defexpdate"+table_len).value=arrayDeferralRowValues[2];
		
	
		var cell = row.insertCell(4);
		var status1='status'+table_len;
		cell.innerHTML="<select class='NGReadOnlyView' id='status"+table_len+"'style='width:100%'>"
						+"<option value=''>--Select--</option>"
						+"<option value='Open'>Open</option>"
						+"<option value='Closed'>Closed</option>"
						+"<option value='Deferred'>Deferred</option>"
						+"</select>";
		if(arrayDeferralRowValues!='')
		document.getElementById("status"+table_len).value=arrayDeferralRowValues[3];
		
		cell = row.insertCell(5);
		var deleteid='image'+table_len;
		cell.innerHTML = "<img id='image"+table_len+"' src='/RBL/webtop/images/delete.gif' style='width:21px;height:21px;border:0'; onclick='deleteRowsFromDeferralGrid();'>";	
		
		var docTypeDisable=document.getElementById("doctype"+table_len);
		var appAuthDisable=document.getElementById("appauth"+table_len);
		var defExpDateDisable=document.getElementById("defexpdate"+table_len);
		var status1=document.getElementById("status"+table_len);
		var deleteDisable=document.getElementById(deleteid);
		var calendar=document.getElementById("calendar"+table_len);
		srNoDisabled=document.getElementById("srno"+table_len);
		//deleteDisable.disabled=true;
		
		docTypeDisable.disabled=true;
		appAuthDisable.disabled=true;
		defExpDateDisable.disabled=true;
		status1.disabled=true;
		deleteDisable.disabled=true;
		calendar.disabled=true;
		srNoDisabled.disabled=true;
		
		
		if(CurrentWS =="CROPS_DataEntryMaker" || CurrentWS=="CROPS_DataEntChecker" || CurrentWS=="CROPS_DocsChecker" || CurrentWS=="AttachAdditionalDocs" || CurrentWS=="Attach_Final_Docs")
		{
			docTypeDisable.disabled=false;
			appAuthDisable.disabled=false;
			defExpDateDisable.disabled=false;
			status1.disabled=false;
			deleteDisable.disabled=false;
			calendar.disabled=false;
		}
		if(CurrentWS=="Deferral_Checker")
		{
			defExpDateDisable.disabled=false;
			status1.disabled=false;
			calendar.disabled=false;
		}
}

function deleteRowsFromDeferralGrid()
{
	var r = confirm("Do you want to delete the row?");
		if(r == true)
		{
			var initialLength=document.getElementById('DeferralTableLength').value;
			var row = window.event.srcElement;
			row = row.parentNode.parentNode;
			var rowindex=row.rowIndex;
			var table = document.getElementById("DeferralGrid");
			var rowCount = table.rows.length;
			if(parseInt(rowindex)<=parseInt(initialLength)-1)
			{
				alert('You cannot delete the row that had previously been added');
				return;
			}
			if(rowCount==4)//means only one row added then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			
			else if((rowCount-1)==rowindex)//means last row is being deleted then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			else
			{
				var arrayDefferalFieldsForSave=['doctype','appauth','defexpdate','status'];
				
					for(var k=0;k<arrayDefferalFieldsForSave.length;k++)
					 {
						for(var j=rowindex;j<(rowCount-1);j++)
						{
							var currentRowId=parseInt(j)+1;
							document.getElementById(arrayDefferalFieldsForSave[k]+currentRowId).id = arrayDefferalFieldsForSave[k] + (j);
							//document.getElementById(arrayDefferalFieldsForSave[k]+currentRowId).id = arrayDefferalFieldsForSave[k] + (j);
						}
					 }
					 table.deleteRow(rowindex);
			}
		}
}

function deleteRowsFromUIDGridWithIndex()
{
	var r = confirm("Do you want to delete the row?");
	if(r == true){
		var row = window.event.srcElement;
		var initialLength=document.getElementById('UIDTableLength').value;
		//alert('initialLength='+initialLength);
		row = row.parentNode.parentNode;
		var rowindex=row.rowIndex;
		var table = document.getElementById("UIDGrid");
		var rowCount = table.rows.length;
		var flag=true;
		//alert("rowIndex is "+rowindex);
		/*if(parseInt(rowindex)<=parseInt(initialLength)-1)
		{
			alert('You cannot delete the row that had previously been added');
			return;
		}*/
		//alert('coming in true');
		//return;
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
			var arrayUIDFieldsForSave=['srno','uid','remark'];
			
				for(var k=0;k<arrayUIDFieldsForSave.length;k++)
				 {
					for(var j=rowindex;j<(rowCount-1);j++)
					{
						var currentRowId=parseInt(j)+1;
						//alert(arrayUIDFieldsForSave[k]+currentRowId);
						document.getElementById(arrayUIDFieldsForSave[k]+currentRowId).id = arrayUIDFieldsForSave[k] + (j);
						if(flag){
							table.deleteRow(rowindex);
							flag=false;
						}
						if (arrayUIDFieldsForSave[k]=='srno')
						{
							document.getElementById(arrayUIDFieldsForSave[k] + (j)).value = j-2;
						}
					}
				 }
				
		}
	}
}

function setComboValueToTextBox(dropdown, inputTextBoxId) 
	{
			if(dropdown.id=='selectDecision')
			{
				document.getElementById(inputTextBoxId).value = dropdown.value;
				
			}
			
			if(document.getElementById('selectDecision').value=='Reject to RO'||document.getElementById('selectDecision').value=='Reject'||document.getElementById('selectDecision').value=='Reject to CBWC Maker'||document.getElementById('selectDecision').value=='Reject to Credit' ||document.getElementById('selectDecision').value=='Reject to CROPS Maker' || document.getElementById('selectDecision').value=='Send to Credit Analyst' || document.getElementById('selectDecision').value=='Reject to AU Officer' || document.getElementById('selectDecision').value=='Reject to AU Analyst' || document.getElementById('selectDecision').value=='Reject to AU Document Checker' || document.getElementById('selectDecision').value=='Send to Business' || document.getElementById('selectDecision').value=='Send to Attach Additional Doc')
			{
				document.getElementById('RejectReason').disabled = false;
			}
			else{
				document.getElementById('RejectReason').disabled = true;
			}
			
			if(document.getElementById('selectDecision').value=='Reperform Checks')
			{
				confirm("Kindly check CBRB/AECB checks are Required or Not Required");
				document.getElementById('wdesk:CBRB_Required').disabled = false;
				document.getElementById('wdesk:CBRB_Required').focus(true);
				document.getElementById('wdesk:AECB_Required').disabled = false;
			}
	}

function checkDuplicateWorkitems()
{
		
			var ProcessInstanceId = customform.document.getElementById("wdesk:WI_NAME").value;
			var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
			var duplicateLogicFlag= customform.document.getElementById("wdesk:duplicateLogicFlag").value;
			var Dec_AU_Analyst=customform.document.getElementById("wdesk:Dec_AU_Analyst").value;
			var CIF_Id=customform.document.getElementById("wdesk:CIF_Id").value;
			var TLNumber=customform.document.getElementById("wdesk:TLNumber").value;
			
			
			var xhr;
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");

			var url = "/RBL/CustomForms/RBL_Specific/getDuplicateWorkitems.jsp";
			var param = "WI_NAME=" + ProcessInstanceId+"&WSNAME="+WSNAME+"&CIF_Id="+CIF_Id+"&Dec_AU_Analyst="+Dec_AU_Analyst+"&TLNumber="+TLNumber;
			
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
						//updatetDuplicateWorkitems();
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
function callInsertDuplicateWorkitems() 
{

    var wi_name =customform.document.getElementById("wdesk:WI_NAME").value;

    try 
	{
        var url = "/RBL/CustomForms/RBL_Specific/DeleteAjaxRequest.jsp";
		var param="&wi_name="+wi_name;
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

    } 
	catch (e) 
	{
        alert("Exception while deleting duplicate workitem Grid Details: " + e);
    }

    var table = customform.document.getElementById("duplicateWorkItemID");
    var rowCount = table.rows.length;
    for (var i = 0; i < rowCount; i++) 
	{
	    if(i==0 || i==1)//Left two rows as these are headers.
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
            var url = "/RBL/CustomForms/RBL_Specific/InsertDuplicateWorkItem.jsp";
			var param="&gridRow="+gridRow;
            var xhr;
            var ajaxResult;

            if (window.XMLHttpRequest)
                xhr = new XMLHttpRequest();
            else if (window.ActiveXObject)
                xhr = new ActiveXObject("Microsoft.XMLHTTP");

            xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.send(param);
			

        } catch (e) 
		{
            alert("Exception while adding Duplicate workitem Grid Details: " + e);
        }
    }
}
function updatetDuplicateWorkitems() 
{

    var wi_name =customform.document.getElementById("wdesk:WI_NAME").value;

    try 
	{
        var url = "/RBL/CustomForms/RBL_Specific/UpdateRequest.jsp";
		var param="&wi_name="+wi_name;
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

    } 
	catch (e) 
	{
        alert("Exception while updating duplicate workitem Grid Details: " + e);
    }
}