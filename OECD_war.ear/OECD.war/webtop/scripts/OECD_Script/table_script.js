

/*function addOECDRow()
{
		var table = document.getElementById("OECDGrid");
		var table_len=(table.rows.length);
		var row = table.insertRow(table_len);
		var arrayIdentificationDocFieldsForSave=['countryoftaxresidence','taxpayeridentificationno','notinreason'];
		
		var cell = row.insertCell(0);
		var countryofresid = 'countryoftaxresidence'+table_len;
		var autoComplete='AutocompleteValuesCountry';
		cell.innerHTML="<input type='text' size='32' maxlength='100' id='countryoftaxresidence"+table_len+"' onkeyup='ValidateCharacter(\""+countryofresid+"\");' onblur='validatecountry(\""+countryofresid+"\",document.getElementById(\""+autoComplete+"\").value);'>";
		
		var cell = row.insertCell(1);
		var taxPayerid='taxpayeridentificationno'+table_len;
		cell.innerHTML="<input type='text' size='23' maxlength='100' onkeyup='ValidateCharacter(\""+taxPayerid+"\");' id='taxpayeridentificationno"+table_len+"'>";
		
		var cell = row.insertCell(2);
		cell.innerHTML="<select style='width:230px;' id='notinreason"+table_len+"'><option value=''>--Select--</option></select>";	
		loadDropDownValuesForEditableGrid('Initiation','notinreason',table_len);		

		cell = row.insertCell(3);
		cell.innerHTML = "<img id='"+table_len+"' src='/RAO/webtop/images/delete.gif' style='width:21px;height:21px;border:0;' onclick='deleteRowsFromOECDGridWithIndex();'>";
		
		setAutocompleteDataForgridComboForOECD(table_len);
		 
}*/
//**********************************************************************************//
/*function deleteRowsFromOECDGrid()
{
	var table = document.getElementById("OECDGrid");
	var rowCount = table.rows.length;
	rowCount=rowCount-1;//After delete table chnages his row position internaly.So we are deleating from last row
	while(rowCount>=3)
	{
		document.getElementById("OECDGrid").deleteRow(rowCount);
		rowCount--;
	}
}*/
function deleteRowsFromAccountGridWithIndex()
{
	var r = confirm("Do you want to delete the row?");
	if (r == true) {
		var current = window.event.srcElement;
		current = current.parentNode.parentNode;
		current.parentNode.removeChild(current);
	} 
}
function getOECDGridValues()
{
		var table = document.getElementById("OECDGrid");
		var rowCount = table.rows.length;
		var arrayOECDFieldsForSave=['countryoftaxresidence','taxpayeridentificationno','notinreason'];
		var gridColValues='';
		var gridRowValues=''
		for (var i = 3; i < rowCount; i++)
		{
			for (var j = 0; j < arrayOECDFieldsForSave.length; j++) 
			{
				if (gridColValues != "") 
				{
					gridColValues =gridColValues+"~"+document.getElementById(arrayOECDFieldsForSave[j]+i).value;
				} 
				else 
				{
					gridColValues =document.getElementById(arrayOECDFieldsForSave[j]+i).value;
				}
			}
			if(gridRowValues!="")
			{
			 gridRowValues=gridRowValues+"|"+gridColValues;
			}
			else
			gridRowValues=gridColValues;
			
			gridColValues=''//Resetting this variable to append the next loop cell values and append the gridRowValues variable
		}
		return gridRowValues;
}
function addAccountGird()
{
		var table = document.getElementById("AccountGrid");
		var table_len=(table.rows.length);
		var row = table.insertRow(table_len);
		var arrayIdentificationDocFieldsForSave=['accounttype','accountcurrency','rakvaluepackage','statementfreq','debitcardreq','chequebookreq','receivecreditinterest','accountno'];
		 
		var cell = row.insertCell(0);
		cell.innerHTML="<select id='accounttype"+table_len+"' onchange='AccountChange(this.id,"+table_len+");'><option value=''>--Select--</option></select>";
		loadDropDownValuesForEditableGrid('Initiation','accounttype',table_len);
		
		var cell = row.insertCell(1);
		cell.innerHTML="<select id='accountcurrency"+table_len+"'><option value=''>--Select--</option></select>";
		loadDropDownValuesForEditableGrid('Initiation','accountcurrency',table_len);
		
		var cell = row.insertCell(2);
		cell.innerHTML="<select id='rakvaluepackage"+table_len+"'><option value=''>--Select--</option></select>";
		loadDropDownValuesForEditableGrid('Initiation','rakvaluepackage',table_len);
		
		var cell = row.insertCell(3);
		cell.innerHTML="<select id='statementfreq"+table_len+"'><option value=''>--Select--</option><option value='Monthly'>Monthly</option><option value='Quarterly'>Quarterly</option><option value='Half Yearly'>Half Yearly</option><option value='Yearly'>Yearly</option></select>";
		//loadDropDownValuesForEditableGrid('Initiation','statementfreq',table_len);
		
		var cell = row.insertCell(4);
		cell.innerHTML="<select id='debitcardreq"+table_len+"'><option value=''>--Select--</option><option value='Yes'>Yes</option><option value='No'>No</option></select>";
		
		var cell = row.insertCell(5);
		cell.innerHTML="<select id='chequebookreq"+table_len+"'><option value=''>--Select--</option><option value='Yes'>Yes</option><option value='No'>No</option></select>";
		
		var cell = row.insertCell(6);
		cell.innerHTML="<select id='receivecreditinterest"+table_len+"'><option value=''>--Select--</option><option value='Yes'>Yes</option><option value='No'>No</option></select>";
		
		var cell = row.insertCell(7);
		cell.innerHTML="<input type='text' maxlength='13' size='13' disabled='true' id='accountno"+table_len+"'>";
		
		cell = row.insertCell(8);
		cell.innerHTML = "<img id='"+table_len+"' src='/RAO/webtop/images/delete.gif' style='width:21px;height:21px;border:0;' onclick='deleteRowsFromAccountGridWithIndex();'>";
		 
}//**********************************************************************************//
function AccountChange(currentId,rowId)
{
	var op=document.getElementById('accountcurrency'+rowId).getElementsByTagName('option');
	document.getElementById('accountcurrency'+rowId).selectedIndex = 0 ;
	if(document.getElementById(currentId).value=='Current Account'||document.getElementById(currentId).value=='Savings Account'||document.getElementById(currentId).value=='RAKGoldInvest')
	{
		for(var i=0;i<op.length;i++)
		{
			if(op[i].value=='')
			continue;
			if(op[i].value=='GRM')
			document.getElementById('accountcurrency'+rowId).options[i].disabled=true;
			else
			document.getElementById('accountcurrency'+rowId).options[i].disabled=false;
		}
	}
	else if(document.getElementById(currentId).value=='RAKvantae Account'||document.getElementById(currentId).value=='Fast@Saver')
	{
		for(var i=0;i<op.length;i++)
		{
			if(op[i].value=='')
			continue;
			if(op[i].value=='AED'||op[i].value=='USD')
			document.getElementById('accountcurrency'+rowId).options[i].disabled=false;
			else
			document.getElementById('accountcurrency'+rowId).options[i].disabled=true;
		}
	}
	else if(document.getElementById(currentId).value=='RAKsave Account')
	{
		for(var i=0;i<op.length;i++)
		{
			if(op[i].value=='')
			continue;
			if(op[i].value=='AED'||op[i].value=='USD'||op[i].value=='EUR'||op[i].value=='GBP')
			document.getElementById('accountcurrency'+rowId).options[i].disabled=false;
			else
			document.getElementById('accountcurrency'+rowId).options[i].disabled=true;
		}
	}
	else if(document.getElementById(currentId).value=='Call Account')
	{
		for(var i=0;i<op.length;i++)
		{
			if(op[i].value=='')
			continue;
			if(op[i].value=='GRM'||op[i].value=='USD'||op[i].value=='EUR'||op[i].value=='GBP')
			document.getElementById('accountcurrency'+rowId).options[i].disabled=true;
			else
			document.getElementById('accountcurrency'+rowId).options[i].disabled=false;
		}
	}
	
	else if(document.getElementById(currentId).value=='Conventional Account')
	{
		for(var i=0;i<op.length;i++)
		{
			if(op[i].value=='')
			continue;
		if(op[i].value=='GRM'||op[i].value=='USD'||op[i].value=='EUR'||op[i].value=='GBP'||op[i].value=='AED')
		document.getElementById('accountcurrency'+rowId).options[i].disabled=false;	
		else
		document.getElementById('accountcurrency'+rowId).options[i].disabled=false;		
		}
	}
	
	//For rakvaluepackage********************************************
	if(document.getElementById(currentId).value=='Current Account'||document.getElementById(currentId).value=='RAKvantae Account')
	{
		document.getElementById('rakvaluepackage'+rowId).disabled=false;
	}
	else
	{
		document.getElementById('rakvaluepackage'+rowId).selectedIndex = 0 ;
		document.getElementById('rakvaluepackage'+rowId).disabled=true;
	}
	//******************************************************************
	
	//For debitcardreq *************************************************
	if(document.getElementById(currentId).value=='Call Account'||document.getElementById(currentId).value=='RAKGoldInvest')
	{
		document.getElementById('debitcardreq'+rowId).selectedIndex = 0 ;
		document.getElementById('debitcardreq'+rowId).disabled=true;
	}
	else
	{
		document.getElementById('debitcardreq'+rowId).selectedIndex = 0 ;
		document.getElementById('debitcardreq'+rowId).disabled=false;
	}
	//******************************************************************
	
	//For chequebookreq *************************************************
	if(document.getElementById(currentId).value=='Call Account'||document.getElementById(currentId).value=='RAKGoldInvest'||document.getElementById(currentId).value=='Savings Account'||document.getElementById(currentId).value=='RAKsave Account'||document.getElementById(currentId).value=='Fast@Saver')
	{
		document.getElementById('chequebookreq'+rowId).selectedIndex = 0 ;
		document.getElementById('chequebookreq'+rowId).disabled=true;
	}
	else
	{
		document.getElementById('chequebookreq'+rowId).selectedIndex = 0 ;
		document.getElementById('chequebookreq'+rowId).disabled=false;
	}
	//******************************************************************
	
	//For receivecreditinterest *************************************************
	if(document.getElementById(currentId).value=='Savings Account')
	{
		document.getElementById('receivecreditinterest'+rowId).selectedIndex = 0 ;
		document.getElementById('receivecreditinterest'+rowId).disabled=false;
	}
	else
	{
		document.getElementById('receivecreditinterest'+rowId).selectedIndex = 0 ;
		document.getElementById('receivecreditinterest'+rowId).disabled=true;
	}
	//******************************************************************
}
function populateAccountData(arrayAccountRowValues)
{
		var WSNAME =document.getElementById("wdesk:CURRENT_WS").value;
		arrayAccountRowValues=arrayAccountRowValues.split("~");
		var table = document.getElementById("AccountGrid");
		var table_len=(table.rows.length);
		var row = table.insertRow(table_len);
		var arrayIdentificationDocFieldsForSave=['accounttype','accountcurrency','rakvaluepackage','statementfreq','debitcardreq','chequebookreq','receivecreditinterest','accountno'];
		
		var cell = row.insertCell(0);
		if(WSNAME=='Initiation')
		{
			cell.innerHTML="<select id='accounttype"+table_len+"' onchange='AccountChange(this.id,"+table_len+");'><option value=''>--Select--</option></select>";
			loadDropDownValuesForEditableGrid('Initiation','accounttype',table_len);
			document.getElementById("accounttype"+table_len).value=arrayAccountRowValues[0];
		}
		else
		{
			cell.innerHTML="<select style='width: 130px;' id='accounttype"+table_len+"'></select>";
			document.getElementById("accounttype"+table_len).options.length=0;
			var opt = document.createElement("option");
			opt.text = arrayAccountRowValues[0];
			opt.value =arrayAccountRowValues[0];
			document.getElementById("accounttype"+table_len).options.add(opt);
		}
		
		var cell = row.insertCell(1);
		if(WSNAME=='Initiation')
		{
			cell.innerHTML="<select id='accountcurrency"+table_len+"'><option value=''>--Select--</option></select>";
			loadDropDownValuesForEditableGrid('Initiation','accountcurrency',table_len);
			document.getElementById("accountcurrency"+table_len).value=arrayAccountRowValues[1];
		}
		else
		{
			cell.innerHTML="<select style='width: 100px;' id='accountcurrency"+table_len+"'></select>";
			document.getElementById("accountcurrency"+table_len).options.length=0;
			var opt = document.createElement("option");
			opt.text = arrayAccountRowValues[1];
			opt.value =arrayAccountRowValues[1];
			document.getElementById("accountcurrency"+table_len).options.add(opt);
		}
		var cell = row.insertCell(2);
		if(WSNAME=='Initiation')
		{
			cell.innerHTML="<select id='rakvaluepackage"+table_len+"'><option value=''>--Select--</option></select>";
			loadDropDownValuesForEditableGrid('Initiation','rakvaluepackage',table_len);
			document.getElementById("rakvaluepackage"+table_len).value=arrayAccountRowValues[2];
		}
		else
		{
			cell.innerHTML="<select style='width: 170px;' id='rakvaluepackage"+table_len+"'></select>";
			document.getElementById("rakvaluepackage"+table_len).options.length=0;
			var opt = document.createElement("option");
			if(arrayAccountRowValues[2]=='')
			{
				opt.text ='--Select--';
				opt.value ='-Select--';
				document.getElementById("rakvaluepackage"+table_len).options.add(opt);
			}
			else
			{
				opt.text = arrayAccountRowValues[2];
				opt.value =arrayAccountRowValues[2];
				document.getElementById("rakvaluepackage"+table_len).options.add(opt);
			}
		}
		var cell = row.insertCell(3);
		if(WSNAME=='Initiation')
		{
			cell.innerHTML="<select id='statementfreq"+table_len+"'><option value=''>--Select--</option><option value='Monthly'>Monthly</option><option value='Quarterly'>Quarterly</option><option value='Half Yearly'>Half Yearly</option><option value='Yearly'>Yearly</option></select>";
			//loadDropDownValuesForEditableGrid('Initiation','statementfreq',table_len);
			document.getElementById("statementfreq"+table_len).value=arrayAccountRowValues[3];
		}
		else
		{
			cell.innerHTML="<select style='width: 90px;' id='statementfreq"+table_len+"'></select>";
			document.getElementById("statementfreq"+table_len).options.length=0;
			var opt = document.createElement("option");
			opt.text = arrayAccountRowValues[3];
			opt.value =arrayAccountRowValues[3];
			document.getElementById("statementfreq"+table_len).options.add(opt);
		}
		var cell = row.insertCell(4);
		if(WSNAME=='Initiation')
		{
			cell.innerHTML="<select id='debitcardreq"+table_len+"'><option value=''>--Select--</option><option value='Yes'>Yes</option><option value='No'>No</option></select>";
			document.getElementById("debitcardreq"+table_len).value=arrayAccountRowValues[4];
		}
		else
		{
		cell.innerHTML="<select id='debitcardreq"+table_len+"'><option value=''>--Select--</option><option value='Yes'>Yes</option><option value='No'>No</option></select>";
		document.getElementById("debitcardreq"+table_len).value=arrayAccountRowValues[4];
		}
		
		var cell = row.insertCell(5);
		if(WSNAME=='Initiation')
		{
			cell.innerHTML="<select id='chequebookreq"+table_len+"'><option value=''>--Select--</option><option value='Yes'>Yes</option><option value='No'>No</option></select>";
			document.getElementById("chequebookreq"+table_len).value=arrayAccountRowValues[5];
		}
		else
		{
		cell.innerHTML="<select id='chequebookreq"+table_len+"'><option value=''>--Select--</option><option value='Yes'>Yes</option><option value='No'>No</option></select>";
		document.getElementById("chequebookreq"+table_len).value=arrayAccountRowValues[5];
		}
		var cell = row.insertCell(6);
		if(WSNAME=='Initiation')
		{
			cell.innerHTML="<select id='receivecreditinterest"+table_len+"'><option value=''>--Select--</option><option value='Yes'>Yes</option><option value='No'>No</option></select>";
			document.getElementById("receivecreditinterest"+table_len).value=arrayAccountRowValues[6];
		}
		else
		{
			cell.innerHTML="<select id='receivecreditinterest"+table_len+"'><option value=''>--Select--</option><option value='Yes'>Yes</option><option value='No'>No</option></select>";
			document.getElementById("receivecreditinterest"+table_len).value=arrayAccountRowValues[6];
		}
		
		var cell = row.insertCell(7);
		if(WSNAME=='Initiation')
		{
			cell.innerHTML="<input type='text' maxlength='13' size='13' disabled='true' id='accountno"+table_len+"'>";
			document.getElementById("accountno"+table_len).value=arrayAccountRowValues[7];
		}
		else
		{
		cell.innerHTML="<input type='text' size='13' id='accountno"+table_len+"'>";
		document.getElementById("accountno"+table_len).value=arrayAccountRowValues[7];
		}
		//AccountChange('accounttype'+table_len,table_len);//execute this function for validation on account type
		cell = row.insertCell(8);
		cell.innerHTML = "<img id='delImgAccount"+table_len+"' src='/RAO/webtop/images/delete.gif' style='width:21px;height:21px;border:0;' onclick='deleteRowsFromAccountGridWithIndex();'>";
		if(document.getElementById("wdesk:CURRENT_WS").value!='Initiation')
		document.getElementById("delImgAccount"+table_len).disabled=true;
		 
}//**********************************************************************************//
//function openHideDiv(currId,divId) 
function openHideDiv(divId) 
{
    // Declare all variables
    var i, tabcontent, tablinks;

    // Get all elements with class="tabcontent" and hide them
	
	
	$('.tabcontent').hide(); // all elements with the class myClass will hide.
	
	/*document.getElementById('btnAddRess').style.backgroundColor ="#990033";
	document.getElementById('btnEmp').style.backgroundColor = "#990033";
	document.getElementById('btnCont').style.backgroundColor= "#990033";
	document.getElementById('btnOth').style.backgroundColor = "#990033";
	document.getElementById('btnKYC').style.backgroundColor = "#990033";
	document.getElementById('btnTax').style.backgroundColor = "#990033";*/
	
    /*tabcontent = document.querySelectorAll('.tabcontent');
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }*/

    // Get all elements with class="tablinks" and remove the class "active"
    //tablinks = document.querySelectorAll('.tablinks');
    //for (i = 0; i < tablinks.length; i++) {
   //     tablinks[i].className = tablinks[i].className.replace(" active", "");
   // }

    // Show the current tab, and add an "active" class to the button that opened the tab
    document.getElementById(divId).style.display = "block";
	//document.getElementById(currId.id).style.backgroundColor = "#FF9696";
    //evt.currentTarget.className += " active";
}
function openCal(id,rowNo)
{
	initialize(id+rowNo);
}