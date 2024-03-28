function addrowInvoice()
{	

	var invoicenumber = document.getElementById("invoicenumber").value;
	if(invoicenumber == '')
	{
		alert("Mandatory to enter Invoice Number");
		document.getElementById("invoicenumber").focus(true);
		return false;
	}
	else{
	if (getduplicateinvoice(invoicenumber) == false)
			{
				return false;
			}	
	}
	 var InvoiceTable=document.getElementById("InvoiceDetailsGrid");
	 var table_len=(InvoiceTable.rows.length);
	 if(table_len<31)
	 {
		 var row = InvoiceTable.insertRow(table_len);
		 row.id="row"+table_len;
		 var cell0 = row.insertCell(0);
		 cell0.innerHTML = "<input type='radio' name='selectRadio' onclick='editrowInvoice();' id='selected"+table_len+"' value='row"+table_len+"'>";
		 
		 var arrayInvoiceFieldsForSave=['invoicenumber'];
		 var j;
		 for(j=1;j<=arrayInvoiceFieldsForSave.length;j++)
		 {
			var cell = row.insertCell(j);
			cell.id=arrayInvoiceFieldsForSave[j-1]+table_len;
			cell.innerHTML =document.getElementById(arrayInvoiceFieldsForSave[j-1]).value;
			
			
			if(arrayInvoiceFieldsForSave[j-1]=='invoicenumber')
			{
				cell.style.display = 'block';
			}
			else
			cell.style.display = 'none';
		 }

		 //Clear all field after adding row from form
		 clearAllInvoiceDetails();
	}
	else
	{
		alert("Only Maximum of 30 rows can be added");
	}
}

function getduplicateinvoice(invoicenumberformfield)
{
	var table =document.getElementById("InvoiceDetailsGrid");
	var rowCount = table.rows.length;
	var FieldValuesArray=''
	if(rowCount>1)//When no row added in grid
	{
		for (var i = 1; i < rowCount; i++) 
		{
			var currentrow = table.rows[i];
			if(currentrow.cells[1].innerHTML != '')
			{
				var invoiceno=document.getElementById('invoicenumber'+i).innerHTML;
				if (invoiceno == invoicenumberformfield)
				{
					alert("Same Invoice cannot be added twice");
					return false;	
					break;
				}
			}
		}
	}
}

function editrowInvoice()
{
	var WSNAME =document.getElementById("wdesk:CURRENT_WS").value;
	var InvoiceTable=document.getElementById("InvoiceDetailsGrid");
	var table_len=(InvoiceTable.rows.length);
	//alert("table_len--"+table_len);
	for(var i=1;i<table_len;i++)
	{
		if(document.getElementById("selected"+i).checked==true)
		{
			//alert("checked--"+i);
			document.getElementById("rowidselected").value=i;
			var invoicenumber=document.getElementById("invoicenumber"+i).innerHTML.replace(/&amp;/g, '&');
			document.getElementById("invoicenumber").value=invoicenumber;
		}
	}
	//alert("editrowInvoice--"+document.getElementById("rowidselected").value);	
	
	//Below code will disable all text fields and dropdown on form
	if(WSNAME!='CSO')
	{
		$(':text').prop('disabled',true);
		$('select').prop('disabled',true);
		//disabling description field in OECD grid 
		$('textarea').prop('disabled',true);
		//Enabling Remarks field for all WS
		$('textarea[name="remarks"]').prop('disabled', false);
		document.getElementById('selectDecision').disabled=false;
	}
	
	// below block added to apply tooltip on field added on 07032018
	$(document).ready(function() {
		$("input:text,select,textarea").wrap("<div class='tooltip-wrapper' style='display:inline'></div>");
		$("div.tooltip-wrapper").mouseover(function() {
			$(this).attr('title', $(this).children().val());
		});
	});
}
function populateInvoiceData(arrayOfRowsValues)
{
	 /*if(document.getElementById("wdesk:CURRENT_WS").value!='Initiation')
	 {
		 document.getElementById("Add").disabled=true;
		 document.getElementById("Modify").disabled=true;
		 document.getElementById("Delete").disabled=true;
	 }*/
	 var InvoiceTable=document.getElementById("InvoiceDetailsGrid");
	 var table_len=(InvoiceTable.rows.length);
	 var row = InvoiceTable.insertRow(table_len);
	 if(arrayOfRowsValues!="")
	 {
		 row.id="row"+table_len;
		 var cell0 = row.insertCell(0);
		 cell0.innerHTML = "<input type='radio' name='selectRadio' onclick='editrowInvoice();' id='selected"+table_len+"' value='row"+table_len+"'>";
		 
		 var arrayInvoiceFieldsForSave=['invoicenumber'];//added by amitabh for CIFUPDATE
		 var j;
		 for(j=1;j<=arrayInvoiceFieldsForSave.length;j++)
		 {
			var cell = row.insertCell(j);
			cell.id=arrayInvoiceFieldsForSave[j-1]+table_len;
			cell.innerHTML =arrayOfRowsValues[parseInt(j)];//Starting at position 2 as at 0 there is sr no and at 1 there is winame
		
			if(arrayInvoiceFieldsForSave[j-1]=='invoicenumber')
			{
				cell.style.display = 'block';
			}
			else
			cell.style.display = 'none';
		 }
	 }

}
function clearAllInvoiceDetails()
{
	 var allInvoiceFields=['invoicenumber'];
	 for(var i=0;i<allInvoiceFields.length;i++)
	 {
		document.getElementById(allInvoiceFields[i]).value="";
	 }
}
function deleterowInvoice()
{
		//get selected row no from hidden field to delete the row.
		var rowidselected=document.getElementById("rowidselected").value;
		//alert("rowidselected--"+rowidselected);
		var table = document.getElementById("InvoiceDetailsGrid");				
		var rowCount = table.rows.length;
		if(rowidselected=='')
		{
			alert("Please select a row to delete.");
			return false;
		}
		if(rowCount==2)//means only one row added then no need to update id's.Just delete the row
		{
			table.deleteRow(rowidselected);
		}
		else if(rowidselected==(rowCount-1))
		{
			table.deleteRow(rowidselected);//means last row is being deleated then no need to update id's.Just delete the row
		} 
		else
		{
			var arrayInvoiceFieldsForSave=['selected','invoicenumber'];
		
			for(var k=0;k<arrayInvoiceFieldsForSave.length;k++)
			 {
				for(var j=rowidselected;j<(rowCount-1);j++)
				{
					var currentRowId=parseInt(j)+1;				
					document.getElementById(arrayInvoiceFieldsForSave[k]+currentRowId).id = arrayInvoiceFieldsForSave[k] + (j);
				}
			 }
		     table.deleteRow(rowidselected);
		}
		document.getElementById("rowidselected").value='';//after row deletion making rowidselected hidden field to blank as that row has been deleted. 
		//Clear all customer data from form fields after delete row from table.
		clearAllInvoiceDetails();
}
function modifyInvoicerow()
{
		
		var rowidselected=document.getElementById("rowidselected").value;
		var table =document.getElementById("InvoiceDetailsGrid");
		var rowCount = table.rows.length;
		if(rowidselected=='')
		{
			alert("Please select a row to modify.");
			return false;
		}
//Customer Fields Validation************************************************************
	var InvoiceFields=['invoicenumber~Invoice Number'];
	
	for(var i=0;i<InvoiceFields.length;i++)
	{
		var arrayTypeAndField=InvoiceFields[i].split('~');
		if(document.getElementById(arrayTypeAndField[0]).value=='')
		{
			alert(arrayTypeAndField[1]+" is mandatory.");
			document.getElementById(arrayTypeAndField[0]).focus(true);
			return false;
		}
	
	}

		if(true)
		{
			if(document.getElementById('selected'+rowidselected).checked)
			{
				//Customer Details data******************************************************
				
				document.getElementById("invoicenumber"+rowidselected).innerHTML=document.getElementById("invoicenumber").value;
			
				document.getElementById("rowidselected").value='';//after row deletion making rowidselected hidden field to blank as that row has been deleted.
				//Clear all customer data from form fields after delete row from table.
				clearAllInvoiceDetails();
			}
		}
		document.getElementById('selected'+rowidselected).checked = false;
}

function addrowCommunication()
{	
		var modeofcommunicationcombo= document.getElementById("modeofcommunicationcombo").value;
		if(modeofcommunicationcombo== '')
			{
				alert("Mandatory to enter Mode of Communication");
				document.getElementById("modeofcommunicationcombo").focus(true);
				return false;
			}
		else{
				if (getduplicateModeofcommununi(modeofcommunicationcombo) == false)
						{
							return false;
						}	
			}	
	if(document.getElementById("communicationDate").value== '')
			{
				alert("Mandatory to enter Communication Date");
				document.getElementById("communicationDate").focus(true);
				return false;
			}
	if(document.getElementById("CommunicationTime").value== '')
			{
				alert("Mandatory to enter Communication Time");
				document.getElementById("CommunicationTime").focus(true);
				return false;
			}
	if(document.getElementById("description").value== '')
			{
				alert("Mandatory to enter Description");
				document.getElementById("description").focus(true);
				return false;
			}
			
	 var CommunicationTable=document.getElementById("CommunicationdtlsGrid");
	 var table_len=(CommunicationTable.rows.length);
	 var row = CommunicationTable.insertRow(table_len);
	 row.id="row"+table_len;
	 var cell0 = row.insertCell(0);
	 cell0.innerHTML = "<input type='radio' name='selectRadio' onclick='editrowCommunication();' id='select"+table_len+"' value='row"+table_len+"'>";
	 
	 var arrayCommunicationFieldsForSave=['modeofcommunicationcombo','communicationDate','CommunicationTime','description','DATE'];
	 var j;
	 for(j=1;j<=arrayCommunicationFieldsForSave.length;j++)
	 {
		var cell = row.insertCell(j);
		cell.id=arrayCommunicationFieldsForSave[j-1]+table_len;
		cell.innerHTML =document.getElementById(arrayCommunicationFieldsForSave[j-1]).value;
		
		
		if(arrayCommunicationFieldsForSave[j-1]=='modeofcommunicationcombo','communicationDate','CommunicationTime','description','DATE')
		{
			cell.style.display = 'block';
		}
		else
			cell.style.display = 'none';
	 }

	 //Clear all field after adding row from form
	 clearAllCommunicationDetails();
	
}

function getduplicateModeofcommununi(modeofcommunicationcombo)
{
	var table =document.getElementById("CommunicationdtlsGrid");
	var rowCount = table.rows.length;
	var FieldValuesArray=''
	if(rowCount>1)//When no row added in grid
	{
		for (var i = 1; i < rowCount; i++) 
		{
			var currentrow = table.rows[i];
			if(currentrow.cells[1].innerHTML != '')
			{
				var modeofcommunication=document.getElementById('modeofcommunicationcombo'+i).innerHTML;
				if (modeofcommunication == modeofcommunicationcombo)
				{
					alert("Same Mode of Communication cannot be added twice");
					return false;	
					break;
				}
			}
		}
	}
}

function clearAllCommunicationDetails()
{
	 var allcommunicationFields=['modeofcommunicationcombo','templatecombo','communicationDate','CommunicationTime','description'];
	 for(var i=0;i<allcommunicationFields.length;i++)
	 {
		document.getElementById(allcommunicationFields[i]).value="";
	 } 
	 
}
function editrowCommunication()
{	
	var CommunicationTable=document.getElementById("CommunicationdtlsGrid");
	var table_len=(CommunicationTable.rows.length);
	//alert("table_len--"+table_len);
	for(var i=1;i<table_len;i++)
	{
		if(document.getElementById("select"+i).checked==true)
		{
			//alert("checked--"+i);
			document.getElementById("rowidselectedcommunication").value=i;
			
			document.getElementById("modeofcommunicationcombo").value=document.getElementById("modeofcommunicationcombo"+i).innerHTML.replace(/&amp;/g, '&');
			document.getElementById("communicationDate").value=document.getElementById("communicationDate"+i).innerHTML.replace(/&amp;/g, '&');
			document.getElementById("CommunicationTime").value=document.getElementById("CommunicationTime"+i).innerHTML.replace(/&amp;/g, '&');
			document.getElementById("description").value=document.getElementById("description"+i).innerHTML.replace(/&amp;/g, '&');
			document.getElementById("DATE").value=document.getElementById("DATE"+i).innerHTML.replace(/&amp;/g, '&');
		}
	}	
	
	// below block added to apply tooltip on field added on 07032018
	$(document).ready(function() {
		$("input:text,select,textarea").wrap("<div class='tooltip-wrapper' style='display:inline'></div>");
		$("div.tooltip-wrapper").mouseover(function() {
			$(this).attr('title', $(this).children().val());
		});
	});
}
function populateCommunicationData(arrayOfRowsValues)
{
	 /*if(document.getElementById("wdesk:CURRENT_WS").value!='Initiation')
	 {
		 document.getElementById("Add").disabled=true;
		 document.getElementById("Modify").disabled=true;
		 document.getElementById("Delete").disabled=true;
	 }*/
	 var CommunicationTable=document.getElementById("CommunicationdtlsGrid");
	 var table_len=(CommunicationTable.rows.length);
	 var row = CommunicationTable.insertRow(table_len);
	 row.id="row"+table_len;
	 var cell0 = row.insertCell(0);
	 cell0.innerHTML = "<input type='radio' name='selectRadio' onclick='editrowCommunication();' id='select"+table_len+"' value='row"+table_len+"'>";
	 
	 var arrayCommunicationFieldsForSave=['modeofcommunicationcombo','communicationDate','CommunicationTime','description','DATE'];//added by amitabh for CIFUPDATE
	 var j;
	 for(j=1;j<=arrayCommunicationFieldsForSave.length;j++)
	 {
		var cell = row.insertCell(j);
		cell.id=arrayCommunicationFieldsForSave[j-1]+table_len;
		cell.innerHTML =arrayOfRowsValues[(parseInt(j)+1)];//Starting at position 2 as at 0 there is sr no and at 1 there is winame
	
		if(arrayCommunicationFieldsForSave[j-1]=='modeofcommunicationcombo','communicationDate','CommunicationTime','description','DATE')
		{
			cell.style.display = 'block';
		}
		else
		cell.style.display = 'none';
	 }

}
function deleterowCommunication()
{
		//get selected row no from hidden field to delete the row.
		var rowidselected=document.getElementById("rowidselectedcommunication").value;
		var table = document.getElementById("CommunicationdtlsGrid");				
		var rowCount = table.rows.length;
		if(rowidselected=='')
		{
			alert("Please select a row to delete.");
			return false;
		}
		if(rowCount==2)//means only one row added then no need to update id's.Just delete the row
		{
			table.deleteRow(rowidselected);
		}
		else if(rowidselected==(rowCount-1))
		{
			table.deleteRow(rowidselected);//means last row is being deleated then no need to update id's.Just delete the row
		}
		else
		{
			var arrayCommunicationFieldsForSave=['select','modeofcommunicationcombo','communicationDate','CommunicationTime','description','DATE'];
		
			for(var k=0;k<arrayCommunicationFieldsForSave.length;k++)
			 {
				for(var j=rowidselected;j<(rowCount-1);j++)
				{
					var currentRowId=parseInt(j)+1;
					document.getElementById(arrayCommunicationFieldsForSave[k]+currentRowId).id = arrayCommunicationFieldsForSave[k] + (j);
				}
			 }
		     table.deleteRow(rowidselected);
		}
		document.getElementById("rowidselectedcommunication").value='';//after row deletion making rowidselected hidden field to blank as that row has been deleted. 
		//Clear all customer data from form fields after delete row from table.
		clearAllCommunicationDetails();
}
function modifyCommunicationrow()
{
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth()+1; //January is 0!

		var yyyy = today.getFullYear();
		if(dd<10){
			dd='0'+dd;
		} 
		if(mm<10){
			mm='0'+mm;
		} 
		var today = dd+'/'+mm+'/'+yyyy;
		document.getElementById("DATE").value = today;
		var rowidselected=document.getElementById("rowidselectedcommunication").value;
		var table =document.getElementById("CommunicationdtlsGrid");
		var rowCount = table.rows.length;
		if(rowidselected=='')
		{
			alert("Please select a row to modify.");
			return false;
		}
//Customer Fields Validation************************************************************
	var CommunicationFields=['modeofcommunicationcombo~Mode','communicationDate~Date','CommunicationTime~Time','description~Description','DATE~Logged Date'];
	
	
	for(var i=0;i<CommunicationFields.length;i++)
	{
		var arrayTypeAndField=CommunicationFields[i].split('~');
		if(document.getElementById(arrayTypeAndField[0]).value=='')
		{
			alert(arrayTypeAndField[1]+" is mandatory.");
			document.getElementById(arrayTypeAndField[0]).focus(true);
			return false;
		}
	
	}

		if(true)
		{
			if(document.getElementById('select'+rowidselected).checked)
			{
				//Customer Details data******************************************************
				
				document.getElementById("modeofcommunicationcombo"+rowidselected).innerHTML=document.getElementById("modeofcommunicationcombo").value;
				document.getElementById("communicationDate"+rowidselected).innerHTML=document.getElementById("communicationDate").value;
				document.getElementById("description"+rowidselected).innerHTML=document.getElementById("description").value;
				document.getElementById("CommunicationTime"+rowidselected).innerHTML=document.getElementById("CommunicationTime").value;
				document.getElementById("DATE"+rowidselected).innerHTML=document.getElementById("DATE").value;
				
			
				document.getElementById("rowidselectedcommunication").value='';//after row deletion making rowidselected hidden field to blank as that row has been deleted.
				//Clear all customer data from form fields after delete row from table.
				clearAllCommunicationDetails();
			}
		}
		document.getElementById('select'+rowidselected).checked = false;
}


function validateMandatoryFieldsforinvoice() 
{
	if(document.getElementById("invoicenumber").value== '')
			{
				alert("Mandatory to enter Invoice Number");
				document.getElementById("invoicenumber").focus(true);
				return false;
			}
}

function validateMandatoryFieldsforcommunication()
{
	if(document.getElementById("modeofcommunicationcombo").value== '')
			{
				alert("Mandatory to enter Mode of Communicationr");
				document.getElementById("modeofcommunicationcombo").focus(true);
				return false;
			}
	if(document.getElementById("communicationDate").value== '')
			{
				alert("Mandatory to enter Communication Date");
				document.getElementById("communicationDate").focus(true);
				return false;
			}
	if(document.getElementById("CommunicationTime").value== '')
			{
				alert("Mandatory to enter Communication Time");
				document.getElementById("CommunicationTime").focus(true);
				return false;
			}
	if(document.getElementById("description").value== '')
			{
				alert("Mandatory to enter Description");
				document.getElementById("description").focus(true);
				return false;
			}
	
}

function addrowEventGrid(arrayChecklistRowValues,CurrentWS)
{
		var ProductType= document.getElementById("wdesk:Product_Type").value;
		var Application_Date= document.getElementById("wdesk:ApplicationDate").value;
		
		//Formatting the Date dd/mm/yyyy
		var ApplicationDate=Application_Date.substring(0,10); 			
			
		var Amount= document.getElementById("wdesk:Amount").value;
		var Currency= document.getElementById("wdesk:Currency").value;
		
		var table = document.getElementById("EventDetailsGrid");
		var table_len=(table.rows.length);
		var lastRow = table.rows[ table.rows.length-1 ];
		var Date_Event="";
		var App_Date="";
		var PossibleDuplicate="";
		
				
		if(arrayChecklistRowValues!='' && arrayChecklistRowValues.indexOf("~")!=-1)
		{
			if(arrayChecklistRowValues!='')
			arrayChecklistRowValues=arrayChecklistRowValues.split("~");			
			
			if(arrayChecklistRowValues[0] != '') //Formatting the Date dd/mm/yyyy
			{
			var DateEvent=arrayChecklistRowValues[0].substring(0,10);
			var Date1=DateEvent.split("-");
			Date_Event=Date1[2]+"/"+Date1[1]+"/"+Date1[0];
			}
			
			//Formatting the Date dd/mm/yyyy
			var AppDate=arrayChecklistRowValues[1].substring(0,10); 			
			var Date2=AppDate.split("-");
			App_Date=Date2[2]+"/"+Date2[1]+"/"+Date2[0];
			var LabelStart = "";
			var LabelEnd = "";
			//Highlight the Duplicate WI
			if(App_Date == ApplicationDate && arrayChecklistRowValues[3] == ProductType &&  arrayChecklistRowValues[5] == Amount && arrayChecklistRowValues[6] == Currency)
			{
				PossibleDuplicate="Yes";
				LabelStart = "<label><font size='2' color='#f44336'>";
				LabelEnd = "</font></label>";
			}	
			else
			{
				PossibleDuplicate="No";
				LabelStart = "<label><font size='2'>";
				LabelEnd = "</font></label>";
			}
			var row = table.insertRow();
			var cell = row.insertCell(0);			
			cell.innerHTML="<tr><td>"+LabelStart+Date_Event+LabelEnd+"</td>";

			var cell = row.insertCell(1);
			cell.innerHTML="<td>"+LabelStart+App_Date+LabelEnd+"</td>";
			
			var cell = row.insertCell(2);
			cell.innerHTML="<td>"+LabelStart+arrayChecklistRowValues[2]+LabelEnd+"</td>";
		
			var cell = row.insertCell(3);			
			cell.innerHTML="<td>"+LabelStart+arrayChecklistRowValues[3]+LabelEnd+"</td>";
		
			var cell = row.insertCell(4);
			cell.innerHTML="<td>"+LabelStart+arrayChecklistRowValues[4]+LabelEnd+"</td>";
		
			var cell = row.insertCell(5);
			cell.innerHTML="<td>"+LabelStart+arrayChecklistRowValues[5]+LabelEnd+"</td>";
		
			var cell = row.insertCell(6);
			cell.innerHTML="<td>"+LabelStart+arrayChecklistRowValues[6]+LabelEnd+"</td>";
			
			var cell = row.insertCell(7);
			cell.innerHTML="<td>"+LabelStart+arrayChecklistRowValues[7]+LabelEnd+"</td>";
			
			var cell = row.insertCell(8);
			cell.innerHTML="<td>"+LabelStart+PossibleDuplicate+LabelEnd+"</td></tr>";
		}

		// below block added to apply tooltip on field added on 07032018
		$(document).ready(function() {
			$("input:text,select,textarea").wrap("<div class='tooltip-wrapper' style='display:inline'></div>");
			$("div.tooltip-wrapper").mouseover(function() {
				$(this).attr('title', $(this).children().val());
			});
		});
		
}
function addrowDocumentgrid(arrayDOCRowValues,CurrentWS)
{
		var disabled = '';
		var disabledRemarks = '';
		/*if (CurrentWS != 'CBWC_Checker')
		{
			disabled = 'disabled';
			disabledRemarks = 'disabled';
		}
		if (CurrentWS == 'CBWC_Checker')
		{
			disabledRemarks = 'disabled';
		}
		if (CurrentWS == 'Control')
		{
			disabledRemarks = '';
		}		
		*/
		var table = document.getElementById("DocumentGRid");
		var table_len=(table.rows.length);
		var lastRow = table.rows[ table.rows.length-1 ];		
			
		if(arrayDOCRowValues!='' && arrayDOCRowValues.indexOf("~")!=-1)
		{
			//alert("arrayDOCRowValues.split(~)");
			var row = table.insertRow();
			arrayDOCRowValues=arrayDOCRowValues.split("~");		
			
			var cell = row.insertCell(0);
			cell.innerHTML="<input type='text' style='width:90%; border:0px;' readonly maxlength='100' size='25' id='DocName"+table_len+"' onkeyup=''>";
			if(arrayDOCRowValues!='')
			document.getElementById("DocName"+table_len).value=arrayDOCRowValues[0];
			
			var cell = row.insertCell(1);
			cell.innerHTML="<input type='text' style='width:90%;' maxlength='3' size='25' id='originals"+table_len+"' onkeyup=''>";
			if(arrayDOCRowValues!='')
			document.getElementById("originals"+table_len).value=arrayDOCRowValues[1];
		
			var cell = row.insertCell(2);
			cell.innerHTML="<input type='text' style='width:90%;' maxlength='3' size='25' id='copies"+table_len+"' onkeyup=''>";
			if(arrayDOCRowValues!='')
			document.getElementById("copies"+table_len).value=arrayDOCRowValues[2];
		}
		else if(arrayDOCRowValues!='' && arrayDOCRowValues.indexOf("|")!=-1)
		{
			//alert("arrayDOCRowValues.split(|)");
			arrayDOCRowValues=arrayDOCRowValues.split("|");	
			
			for(var i=0;i<arrayDOCRowValues.length;i++)
			{
				//alert("arrayDOCRowValues[i]"+table_len);
			var row = table.insertRow();
			var cell = row.insertCell(0);
			cell.innerHTML="<input type='text' style='width:90%; border:0px;' readonly maxlength='100' size='25' id='DocName"+table_len+"' onkeyup=''>";
			if(arrayDOCRowValues!='')
				document.getElementById("DocName"+table_len).value=arrayDOCRowValues[i];			
		
			var cell = row.insertCell(1);
			cell.innerHTML="<input type='text' style='width:90%;' maxlength='3' size='25' id='originals"+table_len+"' onkeyup=''>";
			if(arrayDOCRowValues!='')
				document.getElementById("originals"+table_len).value="";			
		
			var cell = row.insertCell(2);
			cell.innerHTML="<input type='text' style='width:90%;' maxlength='3' size='25' id='copies"+table_len+"' onkeyup=''>";	
			if(arrayDOCRowValues!='')
				document.getElementById("copies"+table_len).value="";	

				table_len=table_len+1;
			}
			
		}
		else {
			//alert("No data for DocumentGRid");
			return false;
		}
		//Enabling the scrollbar for DocGrid 05122018
		if(arrayDOCRowValues!='' && arrayDOCRowValues.length>4)
		{
			document.getElementById("DocGrid").style.overflowY="scroll";
			document.getElementById("DocGrid").style.height="150px";
		}
		
		// below block added to apply tooltip on field added on 07032018
		/*$(document).ready(function() {
			$("input:text,select,textarea").wrap("<div class='tooltip-wrapper' style='display:inline'></div>");
			$("div.tooltip-wrapper").mouseover(function() {
				$(this).attr('title', $(this).children().val());
			});
		});*/
	return true;	
}	
function addrowchecklist(arrayChecklistRowValues,CurrentWS)
{		
		
		var disabled = '';
		var disabledRemarks = '';
		/*if (CurrentWS != 'CBWC_Checker')
		{
			disabled = 'disabled';
			disabledRemarks = 'disabled';
		}
		if (CurrentWS == 'CBWC_Checker')
		{
			disabledRemarks = 'disabled';
		}
		if (CurrentWS == 'Control')
		{
			disabledRemarks = '';
		}		
		*/
		var table = document.getElementById("checklistGrid");
		var table_len=(table.rows.length);
		var lastRow = table.rows[ table.rows.length-1 ];
		if(arrayChecklistRowValues!='' && arrayChecklistRowValues.indexOf("~")!=-1)
		{
			if(arrayChecklistRowValues!='')
			arrayChecklistRowValues=arrayChecklistRowValues.split("~");
			//document.getElementById("checklistcombo").value=arrayChecklistRowValues[3];			
			if (arrayChecklistRowValues[3].indexOf(CurrentWS)==-1)
			{	
				var row = table.insertRow();
				var cell = row.insertCell(0);
				cell.innerHTML="<input type='text' readonly style='border:0px;' id='SRId"+table_len+"'>";
				document.getElementById("SRId"+table_len).value=table_len;
				
				var cell = row.insertCell(1);
				cell.innerHTML="<input type='text' readonly maxlength='20' size='25' style='width:90%; border:0px;' id='checklistdesc"+table_len+"' onkeyup=''>";
				if(arrayChecklistRowValues[0]!='')
					document.getElementById("checklistdesc"+table_len).value=arrayChecklistRowValues[0];
				
				var cell = row.insertCell(2);
			//	cell.innerHTML="<input type='text' maxlength='20' size='25' id='option"+table_len+"' onkeyup=''>";
				cell.innerHTML="<input type='radio' disabled name='option"+table_len+"' id='Y"+table_len+"' value='Y'> Yes <input type='radio' disabled name='option"+table_len+"' id='N"+table_len+"'  value='N'> No <input type='radio' disabled name='option"+table_len+"' id='NA"+table_len+"' value='NA'> NA";
				if(arrayChecklistRowValues[1]!='')
					document.getElementById(arrayChecklistRowValues[1]+table_len).checked=true;
			
				var cell = row.insertCell(3);
				cell.innerHTML="<input type='text' disabled style='width:90%;' maxlength='20' size='25' id='remarks"+table_len+"' onkeyup='ValidateAlphaNumeric('remarks"+table_len+"')'>";
				if(arrayChecklistRowValues[2]!='')
					document.getElementById("remarks"+table_len).value=arrayChecklistRowValues[2];
				
				document.getElementById("CHECKLIST_WSNAME").value=arrayChecklistRowValues[3];
				//Clearing the ChecklistCombo
				document.getElementById("wdesk:ChecklistFor").value="";
				/* cell = row.insertCell(3);
				cell.innerHTML = "<img id='"+table_len+"' "+disabled+" src='/TF/webtop/images/delete.gif' style='width:21px;height:21px;border:0;' onclick='deleteRowsFromchecklistGridWithIndex();'>"; */	
			}
			else
			{	
				var row = table.insertRow();
				var cell = row.insertCell(0);
				cell.innerHTML="<input type='text' readonly style='border:0px;' id='SRId"+table_len+"'>";
				document.getElementById("SRId"+table_len).value=table_len;
				
				var cell = row.insertCell(1);
				cell.innerHTML="<input type='text' readonly maxlength='20' size='25' style='width:90%; border:0px;' id='checklistdesc"+table_len+"' onkeyup=''>";
				if(arrayChecklistRowValues[0]!='')
					document.getElementById("checklistdesc"+table_len).value=arrayChecklistRowValues[0];
				
				var cell = row.insertCell(2);
			//	cell.innerHTML="<input type='text' maxlength='20' size='25' id='option"+table_len+"' onkeyup=''>";
				cell.innerHTML="<input type='radio' name='option"+table_len+"' id='Y"+table_len+"' value='Y'> Yes <input type='radio' name='option"+table_len+"' id='N"+table_len+"'  value='N'> No <input type='radio' name='option"+table_len+"' id='NA"+table_len+"' value='NA'> NA";
				if(arrayChecklistRowValues[1]!='')
					document.getElementById(arrayChecklistRowValues[1]+table_len).checked=true;
			
				var cell = row.insertCell(3);
				cell.innerHTML="<input type='text' style='width:90%;' maxlength='20' size='25' id='remarks"+table_len+"' onkeyup='ValidateAlphaNumeric('remarks"+table_len+"')'>";
				if(arrayChecklistRowValues[2]!='')
					document.getElementById("remarks"+table_len).value=arrayChecklistRowValues[2];
				
				document.getElementById("CHECKLIST_WSNAME").value=arrayChecklistRowValues[3];
				
				//Saving ChecklistFor field in DB
				var checklist = document.getElementById('Checklist_For');
				var selectedChecklist = checklist.options[checklist.selectedIndex].value;				
				document.getElementById("wdesk:ChecklistFor").value=selectedChecklist;
				
				/* cell = row.insertCell(3);
				cell.innerHTML = "<img id='"+table_len+"' "+disabled+" src='/TF/webtop/images/delete.gif' style='width:21px;height:21px;border:0;' onclick='deleteRowsFromchecklistGridWithIndex();'>"; */	
			}
			
		}		

		// below block added to apply tooltip on field added on 07032018
		$(document).ready(function() {
			$("input:text,select,textarea").wrap("<div class='tooltip-wrapper' style='display:inline'></div>");
			$("div.tooltip-wrapper").mouseover(function() {
				$(this).attr('title', $(this).children().val());
			});
		});
		
}	
function addrowcommngrid(arraycommngridValues,CurrentWS)
{	
	//alert("inside addrowcommngrid");		
		var disabled = '';
		var disabledRemarks = '';
		/*if (CurrentWS != 'CBWC_Checker')
		{
			disabled = 'disabled';
			disabledRemarks = 'disabled';
		}
		if (CurrentWS == 'CBWC_Checker')
		{
			disabledRemarks = 'disabled';
		}
		if (CurrentWS == 'Control')
		{
			disabledRemarks = '';	
		}		
		*/
		if(arraycommngridValues!='')
		{
			arraycommngridValues=arraycommngridValues.split("~");
			//document.getElementById("checklistcombo").value=arrayChecklistRowValues[3];
			
			var table = document.getElementById("CommunicationdtlsGrid");
			var table_len=(table.rows.length);
			var lastRow = table.rows[ table.rows.length-1 ];
			//var row = table.insertRow();
			var row = table.insertRow(table_len);
			row.id="row"+table_len;
			var cell0 = row.insertCell(0);
			cell0.innerHTML = "<input type='radio' name='selectRadio' onclick='editrowCommunication();' id='select"+table_len+"' value='row"+table_len+"'>";
		//	cell.innerHTML="<input type='text' maxlength='20' size='25' id='option"+table_len+"' onkeyup=''>";
			//cell.innerHTML="<tr class='EWNormalGreenGeneral1'><td><input type='radio' name='selected"+table_len+"' id='select"+table_len+"' value=''></td>";
			
			var cell = row.insertCell(1);
			cell.id="modeofcommunicationcombo"+table_len;
			//cell.innerHTML="<input type='text' maxlength='20' size='25' id='modeofcommunicationcombo"+table_len+"' onkeyup=''>";
			cell.innerHTML=arraycommngridValues[0];
			//if(arraycommngridValues!='')
			//document.getElementById("modeofcommunicationcombo"+table_len).value=arraycommngridValues[0];
		
			var cell = row.insertCell(2);
			cell.id="communicationDate"+table_len;
			//cell.innerHTML="<input type='text' maxlength='20' size='25' id='communicationDate"+table_len+"' onkeyup=''>";
			cell.innerHTML=arraycommngridValues[1];
			//if(arraycommngridValues!='')
			//document.getElementById("communicationDate"+table_len).value=arraycommngridValues[1];
		
			var cell = row.insertCell(3);
			cell.id="CommunicationTime"+table_len;
			//cell.innerHTML="<input type='text' maxlength='20' size='25' id='CommunicationTime"+table_len+"' onkeyup=''>";
			cell.innerHTML=arraycommngridValues[2];
			//if(arraycommngridValues!='')
			//document.getElementById("CommunicationTime"+table_len).value=arraycommngridValues[2];

			var cell = row.insertCell(4);
			cell.id="description"+table_len;
			//cell.innerHTML="<input type='text' maxlength='20' size='25' id='description"+table_len+"' onkeyup=''>";
			cell.innerHTML=arraycommngridValues[3];
			//if(arraycommngridValues!='')
			//document.getElementById("description"+table_len).value=arraycommngridValues[3];
		
			var cell = row.insertCell(5);
			cell.id="DATE"+table_len;
			//cell.innerHTML="<input type='text' maxlength='20' size='25' id='DATE"+table_len+"' onkeyup=''>";
			cell.innerHTML=arraycommngridValues[4];
			//if(arraycommngridValues!='')
			//document.getElementById("DATE"+table_len).value=arraycommngridValues[4];
			
			/* cell = row.insertCell(3);
			cell.innerHTML = "<img id='"+table_len+"' "+disabled+" src='/TF/webtop/images/delete.gif' style='width:21px;height:21px;border:0;' onclick='deleteRowsFromchecklistGridWithIndex();'>"; */	
		}

		// below block added to apply tooltip on field added on 07032018
		$(document).ready(function() {
			$("input:text,select,textarea").wrap("<div class='tooltip-wrapper' style='display:inline'></div>");
			$("div.tooltip-wrapper").mouseover(function() {
				$(this).attr('title', $(this).children().val());
			});
		});
		
}

function Deleterow_Query()
{

		var QueryTable=document.getElementById("Query_Details_Grid");
		var table_len=(QueryTable.rows.length);
		var rowidselected="";
		var rowNo='';
		for(var i=1;i<table_len;i++)
		{
			if(document.getElementById("select_ID"+i).checked==true)
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
