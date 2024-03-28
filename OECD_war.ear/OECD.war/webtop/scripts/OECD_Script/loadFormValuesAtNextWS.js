//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation          
//File Name					 : DropDownCity.jsp          
//Author                     : Amitabh
// Date written (DD/MM/YYYY) : 07-Nov-2017
//Description                : Fetching drop down and searchable drop down for country,city and state
//---------------------------------------------------------------------------------------------------->

function disableAllFieldsAtNextWorkstep(currWorkstep)
{
	if(currWorkstep!='Introduction')
	{
		document.getElementById("CHANNEL").disabled=true;
		document.getElementById("CIF_NUMBER_INI").disabled=true;
		document.getElementById("NAME_INI").disabled=true;
		document.getElementById("CIF_NUMBER").disabled=true;
		document.getElementById("CIF_TYPE").disabled=true;
		document.getElementById("CUST_SEGMENT").disabled=true;
		document.getElementById("CUST_SUBSEGMENT").disabled=true;
		document.getElementById("NFE_TYPE").disabled=true;
		document.getElementById("Country_of_Incorp").disabled=true;
		document.getElementById("CUST_NAME").disabled=true;
		document.getElementById("PREF_ADDRESS").disabled=true;
		document.getElementById("NATIONALITY").disabled=true;
		document.getElementById("DOB").disabled=true;
		document.getElementById("CITY_OF_BIRTH").disabled=true;
		document.getElementById("COUNTRY_OF_BIRTH").disabled=true;
		document.getElementById("CRS_UNDOCUMENTED_FLAG").disabled=true;
		document.getElementById("CRS_UNDOCUMENTED_REASON").disabled=true;
		document.getElementById("ViewSignature").disabled=true;
		//****Added as part of CR 28102020
		document.getElementById("wdesk:SUBMISSION_MODE").disabled=true;
		document.getElementById("wdesk:FINACLE_SRNUMBER").disabled=true;
		document.getElementById("wdesk:RM_CODE").disabled=true;
		document.getElementById("wdesk:PERMANENT_ADDR_LINE1").disabled=true;
		document.getElementById("wdesk:MAILING_ADDR_LINE1").disabled=true;
		document.getElementById("wdesk:PERMANENT_ADDR_LINE2").disabled=true;
		document.getElementById("wdesk:MAILING_ADDR_LINE2").disabled=true;
		document.getElementById("wdesk:PERMANENT_ADDRCITY").disabled=true;
		document.getElementById("wdesk:MAILING_ADDRCITY").disabled=true;
		document.getElementById("wdesk:PERMANENT_ADDRSTATE").disabled=true;
		document.getElementById("wdesk:MAILING_ADDRSTATE").disabled=true;
		document.getElementById("wdesk:PERMANENT_ADDRPOBOX").disabled=true;
		document.getElementById("wdesk:MAILING_ADDRPOBOX").disabled=true;		
		document.getElementById("wdesk:PERMANENT_ADDRCOUNTRY").disabled=true;		
		document.getElementById("wdesk:MAILING_ADDRCOUNTRY").disabled=true;		
		document.getElementById("wdesk:USRELATIONMAIN").disabled=true;		
		document.getElementById("wdesk:FINANCIAL_ENTITY").disabled=true;		
		document.getElementById("wdesk:GIIN").disabled=true;		
		document.getElementById("wdesk:FATCA_ENTITY_TYPE").disabled=true;		
		document.getElementById("wdesk:NAMEOFSECURITYMARKET").disabled=true;		
		document.getElementById("wdesk:NAMETRADEDCORPORATION").disabled=true;		
		document.getElementById("wdesk:CONTROLLINGPERSONUSRELATIONSHIP").disabled=true;		
		document.getElementById("cifid").disabled=true;
		document.getElementById("financialdetailId").disabled=true;
		document.getElementById("relationshiptype").disabled=true;
		document.getElementById("name").disabled=true;
		document.getElementById("residenceaddrline1").disabled=true;
		document.getElementById("residenceaddrline2").disabled=true;
		document.getElementById("mailingaddrline1").disabled=true;
		document.getElementById("mailingaddrline2").disabled=true;
		document.getElementById("residencecity").disabled=true;
		document.getElementById("mailingcity").disabled=true;
		document.getElementById("residencestate").disabled=true;
		document.getElementById("mailingstate").disabled=true;
		document.getElementById("residencezipcode").disabled=true;
		document.getElementById("mailingzipcode").disabled=true;
		document.getElementById("residencecountry").disabled=true;
		document.getElementById("mailingcountry").disabled=true;
		document.getElementById("controllingpersontype").disabled=true;
		document.getElementById("residenceuscitizenship").disabled=true;
		document.getElementById("crsundocumentedflag").disabled=true;
		document.getElementById("crsundocumentedreason").disabled=true;
		
		var tmpdate = document.getElementById("DOB").value;
		if(tmpdate != '')
		{
			var dob1 = tmpdate.split('-');
			tmpdate = dob1[2]+'/'+dob1[1]+'/'+dob1[0];
			document.getElementById("DOB").value=tmpdate;
		}
	}
	if(currWorkstep=='OPS_Maker' || currWorkstep=='OPS_Checker' || currWorkstep=='RM' || currWorkstep=='OPS_Data_Entry_Maker' || currWorkstep=='OPS_Data_Entry_Checker')
		document.getElementById("ViewSignature").disabled=false;

}	

function addOECDRow(){
//if(docTypesString1!='')
	//{
	
		var currWorkstep=document.getElementById("wdesk:CURRENT_WS").value;
		var WINAME=document.getElementById("wdesk:WINAME").value;
		var OecdDetails = loadOECDGridValues(currWorkstep,WINAME);
		//alert("OecdDetails"+OecdDetails);
		var arrayRow=OecdDetails.split('|');
		var table = document.getElementById("OECDGrid");
		var arrayIdentificationDocFieldsForSave=['countryoftaxresidence','taxpayeridentificationno','notinreason','reasonBremarks'];
		for(var k=0;k<arrayRow.length;k++)
		{
			var table_len=(table.rows.length);
			var row = table.insertRow(table_len);
			var arrayCellValues=arrayRow[k].split('~');
			var countryoftaxresidence=arrayCellValues[0];
			var taxpayeridentificationno=arrayCellValues[1];
			var notinreason=arrayCellValues[2];
			var reasonBremarks=arrayCellValues[3];
			
			if(typeof(countryoftaxresidence) == 'undefined')
				countryoftaxresidence = '';
			if(typeof(taxpayeridentificationno) == 'undefined')
				taxpayeridentificationno = '';
			if(typeof(notinreason) == 'undefined')
				notinreason = '';
			if(typeof(reasonBremarks) == 'undefined')
				reasonBremarks = '';
			
			var cell = row.insertCell(0);
			var countryofresid = 'countryoftaxresidence'+table_len;
			var autoComplete='AutocompleteValuesCountry';
			cell.innerHTML="<input type='text' size='25' maxlength='100' onblur='validatecountry(\""+countryofresid+"\",document.getElementById(\""+autoComplete+"\").value);' id='countryoftaxresidence"+table_len+"'>";
			document.getElementById("countryoftaxresidence"+table_len).value=countryoftaxresidence;
			var CountryFields=['countryoftaxresidence'];
			loadCountry(CountryFields,"OECDGrid",table_len);
			
			var cell = row.insertCell(1);
			cell.innerHTML="<input type='text' size='25' maxlength='100' style='width:170px' id='taxpayeridentificationno"+table_len+"'>";
			document.getElementById("taxpayeridentificationno"+table_len).value=taxpayeridentificationno;
			
			var cell = row.insertCell(2);
			cell.innerHTML="<input type ='text' size='25' maxlength='100' style='width:230px;' id='notinreason"+table_len+"'>";
			document.getElementById("notinreason"+table_len).value=notinreason;
			
			var cell = row.insertCell(3);
			cell.innerHTML="<input type ='text' size='20' maxlength='100' style='width:230px;' id='reasonBremarks"+table_len+"'>";
			document.getElementById("reasonBremarks"+table_len).value=reasonBremarks;
			
			disableOECDGridColumns();
		}
}
	

function loadOECDGridValues(currWorkstep,WINAME)
{
		//if(currWorkstep!='Initiation')
		//{
			
			//alert("here i am in loadOECDGridValues");
				var url = '';
				var xhr;
				var ajaxResult;		
				if(window.XMLHttpRequest)
				xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
				xhr=new ActiveXObject("Microsoft.XMLHTTP");
				
				url = '/OECD/CustomForms/OECD_Specific/loadOECDGridData.jsp?WI_NAME='+WINAME;
				//alert("url"+url);
				xhr.open("GET",url,false);
				xhr.send(null);
				if (xhr.status == 200)
				{
					 ajaxResult = xhr.responseText;
					 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
					 //alert("ajaxResult"+ajaxResult);
					 if(ajaxResult=="-1")
					 {
						alert("Error while loading OECD details ");
						return false;
					 }
					 else
					 {
						// alert("The ajax result is "+ajaxResult);
						 return ajaxResult; 		
					 }		
				}
				else 
				{
					alert("Error while Loading OECD Grid Data.");
					return false;
				}
		//}
}

function disableOECDGridColumns()
{
	var table = document.getElementById("OECDGrid");
	var rowCount=(table.rows.length);
	if(rowCount>=1)//When no row added in grid
	{
		for (var i = 1; i < rowCount; i++)   
		{	
			document.getElementById('countryoftaxresidence'+i).disabled=true;
			document.getElementById('taxpayeridentificationno'+i).disabled=true;
			document.getElementById('notinreason'+i).disabled=true;
			document.getElementById('reasonBremarks'+i).disabled=true;
		}
	}
}

//Below code added for checklist details grid on 29102020 as part of CR 

function loadChecklistvalue(currWorkstep,winame)
{
	//alert("inside loadChecklistvalue");
	//deleteRowsFromGrid("checklistGrid"); //Delete the rows from table using Grid Id
	
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	url = '/OECD/CustomForms/OECD_Specific/DropDownLoad.jsp';
	var param = "WINAME="+winame+"&reqType=loadchecklist";
	//param = encodeURIComponent(param);
	xhr.open("POST", url, false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	//alert("Dropdownload"+ xhr);

	if (xhr.status == 200)
	{
		 ajaxResult = xhr.responseText;
		 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		 if(ajaxResult=='-1')
		 {
			alert("Error while loading checklist data.");
			return false;
		 }
		 else
		 {
             ajaxResult=ajaxResult.split('|');
			 for(var i=0;i<ajaxResult.length;i++)
			 {
				var ajaxResultRow=ajaxResult[i].split('~');
				addrowchecklist(ajaxResult[i],currWorkstep)
			 }	
			 // below block added to apply tooltip on field added on 07032018
			$(document).ready(function() {
				$("input:text,select,textarea").wrap("<div class='tooltip-wrapper' style='display:inline'></div>");
				$("div.tooltip-wrapper").mouseover(function() {
					$(this).attr('title', $(this).children().val());
				});
			});
		 }						 
	}
	else 
	{
		alert("Exception while loading checklist data.");
		return false;
	}
}

function addrowchecklist(arrayChecklistRowValues,CurrentWS)
{		
	//alert("Inside addrowchecklist");	
	var disabledOption = '';
	var disabledRemarks = '';
	
	if (CurrentWS != 'Attach_Cust_Doc')
	{
		disabledOption = 'disabled';
	    disabledRemarks = 'disabled';
	 } 
	var table = document.getElementById("checklistGrid");
	var table_len=(table.rows.length)+1;
	
	if(arrayChecklistRowValues!='' && arrayChecklistRowValues.indexOf("~")!=-1)
	{
	if(arrayChecklistRowValues!='')
		arrayChecklistRowValues=arrayChecklistRowValues.split("~");
		var rowIDs='';
		var row = table.insertRow();
		var str2 = /^[0-9]+$/; //regex pattern for digits
		var cell = row.insertCell(0);
		cell.innerHTML="<input type='text' disabled style='border:0px;' id='SRId"+table_len+"' style='width:95%; text-align:center'>";
		document.getElementById("SRId"+table_len).value=arrayChecklistRowValues[0];
		
		var cell = row.insertCell(1);
		cell.innerHTML="<textarea disabled rows='1' style='width:95%; border:0px;' id='checklistdesc"+table_len+"'></textarea>";
		if(arrayChecklistRowValues[0]!='')
			document.getElementById("checklistdesc"+table_len).value=arrayChecklistRowValues[1];
		
		var cell = row.insertCell(2);
	
		  if (CurrentWS == 'OPS_Checker' || CurrentWS == 'RM')
		  {
			if (!arrayChecklistRowValues[0].match(str2))
			{
				var option1=document.getElementById("option"+arrayChecklistRowValues[0].match(/\d+/)[0]).value;
				//var option1=document.getElementById("option"+table_len).value;
				
				if(option1.toUpperCase()=='YES')
				{		
					if(arrayChecklistRowValues[2].toUpperCase()=='YES')
					{
						cell.innerHTML="<select name='option"+arrayChecklistRowValues[0]+"' id='option"+arrayChecklistRowValues[0]+"'   align='center'><option value= ''>--Select--</option> <option value= 'Yes' selected>Yes</option> <option value= 'No' >No</option></select><input type='hidden' disabled style='border:0px;' id='Ids"+arrayChecklistRowValues[0]+"' style='width:95%; text-align:center'>";
					}
					else if(arrayChecklistRowValues[2].toUpperCase()=='NO')
					{
						cell.innerHTML="<select name='option"+arrayChecklistRowValues[0]+"' id='option"+arrayChecklistRowValues[0]+"'   align='center'><option value= ''>--Select--</option> <option value= 'Yes' >Yes</option> <option value= 'No' selected>No</option></select><input type='hidden' disabled style='border:0px;' id='Ids"+arrayChecklistRowValues[0]+"' style='width:95%; text-align:center'>";
					}else{
					    cell.innerHTML="<select name='option"+arrayChecklistRowValues[0]+"' id='option"+arrayChecklistRowValues[0]+"'   align='center'><option value= '' selected>--Select--</option> <option value= 'Yes' >Yes</option> <option value= 'No' >No</option></select><input type='hidden' disabled style='border:0px;' id='Ids"+arrayChecklistRowValues[0]+"' style='width:95%; text-align:center'>";
					}
				}
				else if(option1.toUpperCase()=='NO')
				{			
					if(arrayChecklistRowValues[2].toUpperCase()=='YES')
				    {
					   cell.innerHTML="<select name='option"+arrayChecklistRowValues[0]+"' id='option"+arrayChecklistRowValues[0]+"'  disabled align='center'><option value= ''>--Select--</option> <option value= 'Yes' selected>Yes</option> <option value= 'No' >No</option></select><input type='hidden' disabled style='border:0px;' id='Ids"+arrayChecklistRowValues[0]+"' style='width:95%; text-align:center'>";
					}
					else if(arrayChecklistRowValues[2].toUpperCase()=='NO')
					{
						cell.innerHTML="<select name='option"+arrayChecklistRowValues[0]+"' id='option"+arrayChecklistRowValues[0]+"' disabled  align='center'><option value= ''>--Select--</option> <option value= 'Yes' >Yes</option> <option value= 'No' selected>No</option></select><input type='hidden' disabled style='border:0px;' id='Ids"+arrayChecklistRowValues[0]+"' style='width:95%; text-align:center'>";
					}else{
					cell.innerHTML="<select name='option"+arrayChecklistRowValues[0]+"' id='option"+arrayChecklistRowValues[0]+"' disabled  align='center'><option value= '' selected>--Select--</option> <option value= 'Yes' >Yes</option> <option value= 'No' >No</option></select><input type='hidden' disabled style='border:0px;' id='Ids"+arrayChecklistRowValues[0]+"' style='width:95%; text-align:center'>";
					}
				}
				else
				{
					if(arrayChecklistRowValues[2].toUpperCase()=='YES')
					{
						cell.innerHTML="<select name='option"+arrayChecklistRowValues[0]+"' id='option"+arrayChecklistRowValues[0]+"'  disabled align='center'><option value= ''>--Select--</option> <option value= 'Yes' selected>Yes</option> <option value= 'No' >No</option></select><input type='hidden' disabled style='border:0px;' id='Ids"+arrayChecklistRowValues[0]+"' style='width:95%; text-align:center'>";
					}
					else if(arrayChecklistRowValues[2].toUpperCase()=='NO')
					{
						cell.innerHTML="<select name='option"+arrayChecklistRowValues[0]+"' id='option"+arrayChecklistRowValues[0]+"' disabled  align='center'><option value= ''>--Select--</option> <option value= 'Yes' >Yes</option> <option value= 'No' selected>No</option></select><input type='hidden' disabled style='border:0px;' id='Ids"+arrayChecklistRowValues[0]+"' style='width:95%; text-align:center'>";
					}else{
					cell.innerHTML="<select name='option"+arrayChecklistRowValues[0]+"' id='option"+arrayChecklistRowValues[0]+"' disabled  align='center'><option value= '' selected>--Select--</option> <option value= 'Yes' >Yes</option> <option value= 'No' >No</option></select><input type='hidden' disabled style='border:0px;' id='Ids"+arrayChecklistRowValues[0]+"' style='width:95%; text-align:center'>";
					}
				}
			}
			else
			{
				if(arrayChecklistRowValues[2].toUpperCase()=='YES')
				{
					cell.innerHTML="<select name='option"+arrayChecklistRowValues[0]+"' id='option"+arrayChecklistRowValues[0]+"'   align='center' onchange='validateOptionChecklist("+arrayChecklistRowValues[0]+")'><option value= ''>--Select--</option> <option value= 'Yes' selected>Yes</option> <option value= 'No' >No</option></select><input type='hidden' disabled style='border:0px;' id='Ids"+arrayChecklistRowValues[0]+"' style='width:95%; text-align:center'>";
				}
				else if(arrayChecklistRowValues[2].toUpperCase()=='NO')
				{
					cell.innerHTML="<select name='option"+arrayChecklistRowValues[0]+"' id='option"+arrayChecklistRowValues[0]+"'   align='center' onchange='validateOptionChecklist("+arrayChecklistRowValues[0]+")'><option value= ''>--Select--</option> <option value= 'Yes' >Yes</option> <option value= 'No' selected>No</option></select><input type='hidden' disabled style='border:0px;' id='Ids"+arrayChecklistRowValues[0]+"' style='width:95%; text-align:center'>";
				}else{
					cell.innerHTML="<select name='option"+arrayChecklistRowValues[0]+"' id='option"+arrayChecklistRowValues[0]+"'   align='center' onchange='validateOptionChecklist("+arrayChecklistRowValues[0]+")'><option value= '' selected>--Select--</option> <option value= 'Yes' >Yes</option> <option value= 'No' >No</option></select><input type='hidden' disabled style='border:0px;' id='Ids"+arrayChecklistRowValues[0]+"' style='width:95%; text-align:center'>";
				}
			}
		}  
		else
		{
			if(arrayChecklistRowValues[2].toUpperCase()=='YES')
			{
				cell.innerHTML="<select name='option"+arrayChecklistRowValues[0]+"' id='option"+arrayChecklistRowValues[0]+"'  disabled align='center'><option value= ''>--Select--</option> <option value= 'Yes' selected>Yes</option> <option value= 'No' >No</option></select><input type='hidden' disabled style='border:0px;' id='Ids"+arrayChecklistRowValues[0]+"' style='width:95%; text-align:center'>";
			}
			else if(arrayChecklistRowValues[2].toUpperCase()=='NO')
			{
				cell.innerHTML="<select name='option"+arrayChecklistRowValues[0]+"' id='option"+arrayChecklistRowValues[0]+"' disabled  align='center'><option value= ''>--Select--</option> <option value= 'Yes' >Yes</option> <option value= 'No' selected>No</option></select><input type='hidden' disabled style='border:0px;' id='Ids"+arrayChecklistRowValues[0]+"' style='width:95%; text-align:center'>";
			}else{
				cell.innerHTML="<select name='option"+arrayChecklistRowValues[0]+"' id='option"+arrayChecklistRowValues[0]+"' disabled  align='center'><option value= '' selected>--Select--</option> <option value= 'Yes' >Yes</option> <option value= 'No' >No</option></select><input type='hidden' disabled style='border:0px;' id='Ids"+arrayChecklistRowValues[0]+"' style='width:95%; text-align:center'>";
			}
		 
		}
		
		if (!arrayChecklistRowValues[0].match(str2))
		{			
			var ids='option'+arrayChecklistRowValues[0]+'~';
			rowIDs=document.getElementById("Ids"+arrayChecklistRowValues[0].match(/\d+/)[0]).value+ids;
			document.getElementById("Ids"+arrayChecklistRowValues[0].match(/\d+/)[0]).value=rowIDs;
		}	
		
						
	}
		
	document.getElementById("divchecklistGrid").style.overflowY="scroll";
	document.getElementById("divchecklistGrid").style.height="225px";	
		
}

function isNumber(n){
//console.log(n)
    return Number(n)=== n;
}

function validateOptionChecklist(id)
{
	var ids= document.getElementById("Ids"+id).value.split("~");
	var val= document.getElementById("option"+id).value;
    for(var i = 0; i < ids.length; i++) 
	{
		//alert("ids:"+ids[i]);
		if(val=="Yes")
		{
		   $( "#"+ ids[i]).prop( "disabled", false );
		}
		else
		{
		   $( "#"+ ids[i]).prop( "disabled", true );
		   $( "#"+ ids[i]).val("");
	    }
    }
	
}

function populateOECDDataInShareHolder(arrayOfRowsValues,SignatoryGridDetails)
{
	 var shareholderTable=document.getElementById("shareholderTab2");
	 var table_len=(shareholderTable.rows.length);
	 //alert("table_len"+table_len);
	 var row = shareholderTable.insertRow(table_len);
	 row.id="row"+table_len;
	 var cell0 = row.insertCell(0);
	 cell0.innerHTML = "<input type='radio' name='selectRadio' onclick='editrow("+table_len+","+SignatoryGridDetails+");' id='selected"+table_len+"' value='row"+table_len+"'>";
	 
	 if(SignatoryGridDetails)
		var arrayCustomerFieldsForSave=['cifid','name','relationshiptype','controllingpersontype','financialdetailId','residenceaddrline1','residenceaddrline2','residencecity','residencestate','residencezipcode','residencecountry','mailingaddrline1','mailingaddrline2','mailingcity','mailingstate','mailingzipcode','mailingcountry','residenceuscitizenship','ReportCountryDetails','crsundocumentedflag','crsundocumentedreason'];
	 else
		var arrayCustomerFieldsForSave=['cifid','name','relationshiptype'];
	
	 var j;
	 for(j=1;j<=arrayCustomerFieldsForSave.length;j++)
	 {
		var cell = row.insertCell(j);
		cell.id=arrayCustomerFieldsForSave[j-1]+table_len;
		cell.innerHTML =arrayOfRowsValues[(parseInt(j-1))];//Starting at position 1 as at 0 there is winame
			
		if(arrayCustomerFieldsForSave[j-1]=='cifid' || arrayCustomerFieldsForSave[j-1]=='name' || arrayCustomerFieldsForSave[j-1]=='relationshiptype' || arrayCustomerFieldsForSave[j-1]=='controllingpersontype')
		{
			cell.style.display = 'block';
			
			/*if(document.getElementById("wdesk:Share_Holder_Details").value == "")
				document.getElementById("wdesk:Share_Holder_Details").value = arrayOfRowsValues[(parseInt(j-1))];
			else if(document.getElementById("wdesk:Share_Holder_Details").value != "" && arrayCustomerFieldsForSave[j-1]=='cifid')
				document.getElementById("wdesk:Share_Holder_Details").value = document.getElementById("wdesk:Share_Holder_Details").value +"#"+ arrayOfRowsValues[(parseInt(j-1))];
			else
				document.getElementById("wdesk:Share_Holder_Details").value = document.getElementById("wdesk:Share_Holder_Details").value +"`"+ arrayOfRowsValues[(parseInt(j-1))];*/			
		}
		else
			cell.style.display = 'none';
	 }
}

function editrow(no,GridDetails)
{
	var WSNAME =document.getElementById("wdesk:CURRENT_WS").value;
	//For dropdown values after next workstep.We are setting as it is saved into database.
	var dropDownValuesPopulateAtNexrWs="";
	var CountryFields="";
	var CityFields="";
	var USRelationRetParties = "";
	if(GridDetails)
	{
		dropDownValuesPopulateAtNexrWs=['cifid','name','relationshiptype','controllingpersontype','financialdetailId','residenceaddrline1','residenceaddrline2','residencezipcode','mailingaddrline1','mailingaddrline2','mailingzipcode','ReportCountryDetails','crsundocumentedflag','crsundocumentedreason'];
		CityFields=['residencecity','mailingcity','residencestate','mailingstate'];
		CountryFields=['residencecountry','mailingcountry'];
		USRelationRetParties=['residenceuscitizenship'];
	}
	else
		dropDownValuesPopulateAtNexrWs=['cifid','name','relationshiptype'];
	
	if(WSNAME!='Attach_Cust_Doc' && WSNAME!='System_Update')
	{
		for(var i=0;i<dropDownValuesPopulateAtNexrWs.length;i++)
		{
			if(dropDownValuesPopulateAtNexrWs[i] == 'ReportCountryDetails')
			{
				//populate OECD grid2 and values
				//First we have to clear the grid and then populate the rows else it would be append*************************
				deleteRowsFromOECDGrid();
				//**********************************************************************
				
				var ReportCountryDetails = document.getElementById(dropDownValuesPopulateAtNexrWs[i]+no).innerHTML.replace(/&amp;/g, '&');	
				var table = document.getElementById("OECDGrid2");							
				if(ReportCountryDetails != '')
				{
					if(ReportCountryDetails.indexOf("|") != -1)
					{
						var arrayRow=ReportCountryDetails.split('|');
						for(var k=0;k<arrayRow.length;k++)
						{
							var table_len=(table.rows.length);
							var row = table.insertRow(table_len);
							var arrayCellValues=arrayRow[k].split('~');
							var Cntryoftaxres=arrayCellValues[0].replace(/\s/g, ''); //regex for removing spaces
							var taxPayerIdNumber=arrayCellValues[1].replace(/\s/g, ''); //regex for removing spaces
							var NotinreasonsB=arrayCellValues[2].replace(/\s/g, ''); //regex for removing spaces
							var reasonBremark=arrayCellValues[3].replace(/\s/g, ''); //regex for removing spaces
							
							var cell = row.insertCell(0);
							cell.innerHTML="<input type='text' size='25' maxlength='100' style='width:170px' disabled='disabled' id='countryoftaxres"+table_len+"'>";
							if(Cntryoftaxres != "")
								document.getElementById("countryoftaxres"+table_len).value=Cntryoftaxres;
							
							var cell = row.insertCell(1);
							cell.innerHTML="<input type='text' size='25' maxlength='100' style='width:170px' disabled='disabled' id='taxpayeridentificationNumber"+table_len+"'>";
							if(taxPayerIdNumber != "")
								document.getElementById("taxpayeridentificationNumber"+table_len).value=taxPayerIdNumber;
							
							var cell = row.insertCell(2);
							cell.innerHTML="<input type ='text' size='25' maxlength='100' style='width:230px;' disabled='disabled' id='notinreasonB"+table_len+"'>";
							if(NotinreasonsB != "")
								document.getElementById("notinreasonB"+table_len).value=NotinreasonsB;
							
							var cell = row.insertCell(3);
							cell.innerHTML="<input type ='text' size='25' maxlength='100' style='width:230px;' disabled='disabled' id='reasonBremarksRel"+table_len+"'>";
							if(reasonBremark != "")
								document.getElementById("reasonBremarksRel"+table_len).value=reasonBremark;
							
							var CountryFields1=['countryoftaxres'];
							loadCountry(CountryFields1,"OECDGrid",table_len);
							//disableOECDGridColumns();
						}
					}
					else if(ReportCountryDetails.indexOf("~") != -1)
					{
						var table_len=(table.rows.length);
						var row = table.insertRow(table_len);
						var arrayCellValues=ReportCountryDetails.split('~');
						var Cntryoftaxres=arrayCellValues[0].replace(/\s/g, ''); //regex for removing spaces
						var taxPayerIdNumber=arrayCellValues[1].replace(/\s/g, ''); //regex for removing spaces
						var NotinreasonsB=arrayCellValues[2].replace(/\s/g, ''); //regex for removing spaces
						var reasonBremark=arrayCellValues[3].replace(/\s/g, ''); //regex for removing spaces
						
						var cell = row.insertCell(0);
						cell.innerHTML="<input type='text' size='23' maxlength='100' style='width:170px' disabled='disabled' id='countryoftaxres"+table_len+"'>";
						if(Cntryoftaxres != "")
							document.getElementById("countryoftaxres"+table_len).value=Cntryoftaxres;
						
						var cell = row.insertCell(1);
						cell.innerHTML="<input type='text' size='23' maxlength='100' style='width:170px' disabled='disabled' id='taxpayeridentificationNumber"+table_len+"'>";
						if(taxPayerIdNumber != "")
							document.getElementById("taxpayeridentificationNumber"+table_len).value=taxPayerIdNumber;
						
						var cell = row.insertCell(2);
						cell.innerHTML="<input type ='text' size='23' maxlength='100' style='width:230px;' disabled='disabled' id='notinreasonB"+table_len+"'>";
						if(NotinreasonsB != "")
							document.getElementById("notinreasonB"+table_len).value=NotinreasonsB;
						
						var cell = row.insertCell(3);
						cell.innerHTML="<input type ='text' size='23' maxlength='100' style='width:230px;' disabled='disabled' id='reasonBremarksRel"+table_len+"'>";
						if(reasonBremark != "")
							document.getElementById("reasonBremarksRel"+table_len).value=reasonBremark;
						
						var CountryFields1=['countryoftaxres'];
						loadCountry(CountryFields1,"OECDGrid",table_len);
					}
				}
			}
			else
				document.getElementById(dropDownValuesPopulateAtNexrWs[i]).value=document.getElementById(dropDownValuesPopulateAtNexrWs[i]+no).innerHTML.replace(/&amp;/g, '&');
		}	
		if(CityFields != "")
		{
			loadCity(CityFields,"RadioBtnClick",no);	
		}
		if(CountryFields != "")
		{
			loadCountry(CountryFields,"RadioBtnClick",no);
		}
		if(USRelationRetParties != "")
		{
			loadCity(USRelationRetParties,"RadioBtnClick",no);	
		}
	}
	//Put selected row id in hidden field.we will use this to delete the selected row.
	document.getElementById("rowidselected").value=no;
			
	//Below code will disable all text fields and dropdown on form
	/*if(WSNAME!='Attach_Cust_Doc' && WSNAME!='System_Update')
	{
		$(':text').prop('disabled',true);
		$('select').prop('disabled',true);
		//disabling description field in OECD grid 
		$('textarea').prop('disabled',true);
		//Enabling Remarks field for all WS
		$('textarea[name="remarks"]').prop('disabled', false);
		document.getElementById('selectDecision').disabled=false;
	}*/
	
	// below block added to apply tooltip on field added on 07032018
	$(document).ready(function() {
		$("input:text,select,textarea").wrap("<div class='tooltip-wrapper' style='display:inline'></div>");
		$("div.tooltip-wrapper").mouseover(function() {
			$(this).attr('title', $(this).children().val());
		});
	});
}

function deleteRowsFromOECDGrid()
{
	var table = document.getElementById("OECDGrid2");
	var rowCount = table.rows.length;
	rowCount=rowCount-1;//After delete table chnages his row position internaly.So we are deleating from last row
	while(rowCount>0) //--CR point 029-- Changed the length from '3' to '5' after adding four fields in the grid
	{
		document.getElementById("OECDGrid2").deleteRow(rowCount);
		rowCount--;
	}
}