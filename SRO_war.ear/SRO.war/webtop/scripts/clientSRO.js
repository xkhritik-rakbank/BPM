//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :          Application Projects
//Project                     :          RAKBank eForms Phase-I 
//Date Written                : 		 12-10-2018
//Date Modified               : 		
//Author                      :          Sajan
//Description                 :          Function validates on click of Introduce
//***********************************************************************************//

try
{
var pname=window.parent.strprocessname;
//if(pname=='RAO')
//{
window.document.write("<script src="+"/SRO/webtop/scripts/SRO_Script/MandatoryFieldValidation.js"+"></script>");
}
catch(ex){
    //added by Nishant Parmar (04 AUG 16):
    alert("#EXCEPTION occured: "+ex);
}

function SaveClick() 
{
	//var validateStatus=OnDoneValidation();
	customform.document.getElementById("wdesk:Service_Request_Type").value = customform.document.getElementById("ServiceRequestType").value;
	customform.document.getElementById("wdesk:Team").value = customform.document.getElementById("TeamSearchable").value;
	saveUIDGridData();
	var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
    return true;
}

function IntroduceClick() 
{
	customform.document.getElementById("wdesk:Service_Request_Type").value = customform.document.getElementById("ServiceRequestType").value;
	customform.document.getElementById("wdesk:Team").value = customform.document.getElementById("TeamSearchable").value;
	var ArchivalValue=customform.document.getElementById("wdesk:Archival_Path").value;
	var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
	var validateStatus=OnDoneValidation();
	if(validateStatus)
	{
		var result=FetchSucesssFailurePath(ArchivalValue);
		if(saveUIDGridData() == false)
			return false;
		if(SROSAVEDATA(true) == false) 
			return false;
		else
		{		//Commented for Mail Management Changes
			//customform.document.getElementById("wdesk:Remarks").value = ''; // Clearing Remarks OnSubmit
			alert("The request has been submitted successfully.");
			return true;
		}
	}
	else
	{
		return false;
	}
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
		customform.document.getElementById("wdesk:Service_Request_Type").value = customform.document.getElementById("ServiceRequestType").value;
		customform.document.getElementById("wdesk:Team").value = customform.document.getElementById("TeamSearchable").value;
		var ArchivalValue=customform.document.getElementById("wdesk:Archival_Path").value;
		var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
		var validateStatus=OnDoneValidation();
		if(validateStatus)
		{
			if(WSNAME=='Initiator_Reject' || WSNAME=='Mail_Initiation')
				var result=FetchSucesssFailurePath(ArchivalValue);
			if (saveUIDGridData() == false)
				return false;
			if (SROSAVEDATA(true) == false) 
				return false;
			else
			{			//Commented for Mail Management Changes
				//customform.document.getElementById("wdesk:Remarks").value = ''; // Clearing Remarks OnSubmit
				alert("The request has been submitted successfully.");
				return true;
			}
		}
		else
		{
			return false;
		}
}

function SROSAVEDATA(IsDoneClicked) 
{	
	var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
    var WINAME = customform.document.getElementById("wdesk:WI_NAME").value;
	var rejectReasons = customform.document.getElementById('rejReasonCodes').value;
    var Decision = '';
	Decision = customform.document.getElementById("selectDecision").value;
	var Team=customform.document.getElementById("TeamSearchable").value;
	var InitiatorTeam=customform.document.getElementById("wdesk:IntiatorUserGroup").value;
   
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

    var url = "/SRO/CustomForms/SRO_Specific/SaveHistory.jsp";
    var param = "&WINAME=" + WINAME + "&WSNAME=" + WSNAME + "&Decision=" + Decision + "&Remarks=" + Remarks + "&rejectReasons=" + rejectReasons + "&IsDoneClicked=" + IsDoneClicked + "&IsSaved=Y&TEAM="+ Team +"&abc=" + abc+"&InitiatorTeam=" + InitiatorTeam;

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
function saveUIDGridData() 
{	
	var table = customform.document.getElementById("UIDGrid");
	var ajaxResult='';
    var rowCount = table.rows.length;
	if(rowCount==3)//When no row added in grid
	return true;
	
    var wi_name =customform.document.getElementById("wdesk:WI_NAME").value;
	var WSNAME =customform.document.getElementById("wdesk:Current_WS").value;
	var arrayUIDFieldsForSave=['uid','InitiatorRemark','MakerRemark','CheckerRemark'];
	var gridRowAll = '';
    for (var i = 1; i < rowCount-2; i++) 
	{
		var gridRow = "";
        var colCount = table.rows[i].cells.length;
        var currentrow = table.rows[i];
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
				gridRow = i+"~"+ customform.document.getElementById(arrayUIDFieldsForSave[j]+i).value;
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
	if (gridRowAll == '')	
			return true;
	try 
	{
		gridRowAll = gridRowAll.split("'").join("ENSQOUTES");
		var url = "/SRO/CustomForms/SRO_Specific/InsertUIDData.jsp";
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
			var arrayUIDFieldsForSave=['uid','InitiatorRemark','MakerRemark','CheckerRemark'];
			
				for(var k=0;k<arrayUIDFieldsForSave.length;k++)
				 {
					for(var j=rowindex;j<(rowCount-1);j++)
					{
						var currentRowId=parseInt(j)-1;
						//alert(arrayUIDFieldsForSave[k]+currentRowId);
						document.getElementById(arrayUIDFieldsForSave[k]+currentRowId).id = arrayUIDFieldsForSave[k] + (j);
					}
				 }
				 table.deleteRow(rowindex);
		}
	}
}

function FetchSucesssFailurePath(ArchiveDropDownSelected)
{
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	url = '/SRO/CustomForms/SRO_Specific/FetchArchivalPath.jsp?';
	var param = '&ArchivalDropDownValue='+ArchiveDropDownSelected;
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{
		 ajaxResult = xhr.responseText;
		 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		 if(ajaxResult=='-1')
		 {
			alert("Error while loading drop down values for Success and Failure Path");
			return false;
		 }				 
		 values = ajaxResult.split("~");
		 customform.document.getElementById("wdesk:Success_Path").value=values[0];
		 customform.document.getElementById("wdesk:Failure_Path").value=values[1];
		 customform.document.getElementById("wdesk:DataClass").value=values[2];
		 return true;
	}
	else 
	{
		alert("Error while Loading Drop down Service Request Type.");
		return false;
	}
}
	
function ValidateNumeric(id) {
    var inputtxt = document.getElementById(id);
    if (inputtxt.value == '')
        return;
    var inputtxt = document.getElementById(id);
    var numbers = /^[0-9]+$/;
    if (inputtxt.value.match(numbers))
        return true;
    else {
        alert("Please enter numeric value only");
        document.getElementById(id).value = "";
        document.getElementById(id).focus();
        return false;
    }
}
function ValidateAlphaNumeric(id) {
    var inputtxt = document.getElementById(id);
    if (inputtxt.value == '')
        return;
    var inputtxt = document.getElementById(id);
    //var numbers = "^[a-zA-Z0-9]*$";
    if (inputtxt.value.match("^[a-zA-Z0-9 ]*$"))
        return true;
    else {
        alert("Please enter alphanumeric characters only");
        document.getElementById(id).value = "";
        document.getElementById(id).focus();
        return false;
    }
}
