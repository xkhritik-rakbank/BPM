try
{
	var pname=window.parent.strprocessname;
	window.document.write("<script src="+"/TWC/webtop/scripts/TWC_Script/MandatoryFieldValidation.js"+"></script>");
	window.document.write("<script src="+"/TWC/webtop/scripts/TWC_Script/loadFormValuesAtNextWS.js"+"></script>");
	window.document.write("<script src="+"/TWC/webtop/scripts/TWC_Script/calender_TWC.js"+"></script>");
}
catch(ex){
    alert("Exception occured: "+ex);
}





function IntroduceClick() 
{
	flag="I";
	var validateStatus=OnDoneValidation(flag);
	if(validateStatus)
	{
		if (saveGridData() == false)
			return false;
		
		if (TWCSaveData(true) == false) 
			return false;
		
		else 
			return true;
	}
	else
		return false;
}
function SaveClick() 
{
	
	var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
	//checkBlankFieldInDocDesc();
	if (saveGridData() == false)
		return false;
	if(saveUIDGridData()==false)
		return false;
	 
	return true;
	
}

function DoneClick() 
{
	flag="D";
	var facilityStatus=false;
	var validateStatus=OnDoneValidation(flag);
	if(validateStatus)
		facilityStatus=checkMasterFacilityValueonDone();
	if(facilityStatus)
	{
		if (validateAtDone(flag) == false)
			return false;
		if (saveGridData() == false)
			return false;
		if(saveUIDGridData()==false)
			return false;
		if(saveException()==false)
			return false;	
		if (TWCSaveData(true) == false) 
			return false;
		else 
		{
			alert("The request has been submitted successfully.");
			return true;
		}
	}
	else
		return false;
	
}
function validateAtDone(flag)
{
	var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
	if(flag=="I"||flag=="D")
	{
		//Modified on 21/02/2019 as Sales_Attach_Doc is removed
		//if(WSNAME=="Sales_Attach_Doc"||WSNAME=="Credit_Analyst")
		if(WSNAME=="Credit_Analyst")
		{
			if(checkDuplicateWorkitems())
				return true;	
			else
				return false;
		}
	}
	
}
//calender window
function initialize(eleId)
{
	var cal1 = new calendarfn(document.getElementById(eleId));
	cal1.year_scroll = true;
	cal1.time_comp = false;
	cal1.popup();
	return true;
}

function checkBlankFieldInDocDesc()
{
	var Securitytable=customform.document.getElementById("Security_Document_Details_Grid");
	var rows=Securitytable.rows.length;
	for(var i=1;i<rows;i++)
	{
		var docDescValue=customform.document.getElementById('securityDocumentDescription'+i).value;
		var number=docDescValue.split('___').length;
		if(parseInt(number)>2)
		{
			return false;
		}
		
	}
}

//Add New Row onclick Add Button
function addrow(CurrentWS,buttonid,arrayRowValues)
{	
	arrayRowValues=arrayRowValues.split('<br>').join('\r');
	//alert("button id of the button is :"+buttonid);
	var decCropsFinalChecker=document.getElementById("wdesk:Dec_Crops_Finalisation_Checker").value;
	
	//Add Facility Details Grid
	if(buttonid=='add_row_Facility_Details')
	{
		var Purpose='';
		var arrayFacilityRowValues=arrayRowValues;
		if(arrayFacilityRowValues!='')
		{
			arrayFacilityRowValues=arrayFacilityRowValues.split('AMPNDCHAR').join('&');
			arrayFacilityRowValues=arrayFacilityRowValues.split('CCCOMMAAA').join(',');
			arrayFacilityRowValues=arrayFacilityRowValues.split('PPPERCCCENTT').join('%');
			
			arrayFacilityRowValues=arrayFacilityRowValues.split("~");
		}
		var table = document.getElementById("Facility_Details_Grid");
		var table_len=table.rows.length;
		var lastRow = table.rows[ table.rows.length];
		var row = table.insertRow();
		
		var cell = row.insertCell(0);
		var Facility_Existing_id = 'Facility_Existing'+table_len;
		cell.innerHTML="<input type='text' id='Facility_Existing"+table_len+"' maxlength='24' style='width:80px' onkeyup='ValidateNumeric(\""+Facility_Existing_id+"\"); validateLengthForAmount(\""+Facility_Existing_id+"\",\"15\")' onblur='onBlurForAmount(\""+Facility_Existing_id+"\");autoCalculateFields();'>";
		if(arrayFacilityRowValues!='')
			document.getElementById("Facility_Existing"+table_len).value=arrayFacilityRowValues[0];
		
		var cell = row.insertCell(1);
		var Faciltiy_Sought_id = 'Faciltiy_Sought'+table_len;
		cell.innerHTML="<input type='text' id='Faciltiy_Sought"+table_len+"' maxlength='24' style='width:80px' onkeyup='ValidateNumeric(\""+Faciltiy_Sought_id+"\"); validateLengthForAmount(\""+Faciltiy_Sought_id+"\",\"15\")' onblur='onBlurForAmount(\""+Faciltiy_Sought_id+"\"); autoCalculateFields();'>";
		if(arrayFacilityRowValues!='')
			document.getElementById("Faciltiy_Sought"+table_len).value=arrayFacilityRowValues[1];
		
		var cell = row.insertCell(2);
		var No_id = 'No'+table_len;
		cell.innerHTML="<input type='text' id='No"+table_len+"' maxlength='5' style='width:60px' onkeyup='ValidateAlphaNumeric(\""+No_id+"\");'>";
		if(arrayFacilityRowValues!='')
			document.getElementById("No"+table_len).value=arrayFacilityRowValues[2];
		
		var cell = row.insertCell(3);
		var Usage = 'Usage'+table_len;
		//Modified on 27/03/2019 to get sum of only those value for which usage is changed to Outer.
		cell.innerHTML="<select class='NGReadOnlyView' id='Usage"+table_len+"' maxlength='100' style='width:70px' onchange='autoCalculateFields();' >"
						+"<option value=''>--Select--</option>"
						+"<option value='Inner'>Inner</option>"
						+"<option value='Outer'>Outer</option>"
						+"</select>";
		if(arrayFacilityRowValues!='')
			document.getElementById("Usage"+table_len).value=arrayFacilityRowValues[3];
		
		//Added on 02/04/2019
		var Commission_Id = 'Commission'+table_len;
		
		//Modified on 11/04/2019
		var cell = row.insertCell(4);
		var Nature_of_Facility_Id = 'Nature_of_Facility'+table_len;
		var autoComplete='AutocompleteValuesNatureOfFacility';
		cell.innerHTML="<textarea class='NGReadOnlyView' id='Nature_of_Facility"+table_len+"' style='width:100%,height:100%' cols=20 rows=2 onblur='auto_grow(this);validateFacilityType(this.id);enableTrancheDetails();'></textarea>";
						
		//loading drop down values.
		//var loadDropDownNatureOfFacility=loadNatureOfFacility(Nature_of_Facility_Id);
		if(arrayFacilityRowValues!='')
		{
			document.getElementById("Nature_of_Facility"+table_len).value=arrayFacilityRowValues[4];
			auto_grow(document.getElementById(Nature_of_Facility_Id));
		}
		//Added on 02/04/2019
		var natureofFacilitydropdown=setAutocompleteDataForgridCombo(table_len);
		
		//onSelectPopulate(table_len);
		/*var cell = row.insertCell(5);
		var Type = 'Type'+table_len;
		cell.innerHTML="<select class='NGReadOnlyView' id='Type"+table_len+"' style='width:70px'>"
						+"<option value=''>--Select--</option>"
						+"<option value='Local1'>Local1</option>"
						+"</select>";
		if(arrayFacilityRowValues!='')
			document.getElementById("Type"+table_len).value=arrayFacilityRowValues[5];*/
		
	
		var cell = row.insertCell(5);
		var Purpose_id = 'Purpose'+table_len;
		//var autoCompletepurpose='AutocompleteValuesFacilityPurpose';
		cell.innerHTML="<textarea id='Purpose"+table_len+"' maxlength='1000' onblur='auto_grow(this);checkRemarks(\""+Purpose_id+"\",\"1000\");' rows=4 cols=30></textarea>"		
		if(arrayFacilityRowValues!='')
		{
			document.getElementById("Purpose"+table_len).value=arrayFacilityRowValues[5];
			auto_grow(document.getElementById(Purpose_id));
			
		}
		//Added on 02/04/2019
		//var purposedropdown=setAutocompleteDataForgridCombo(table_len);
		
		var cell = row.insertCell(6);
		var Tenor_Value_id = 'Tenor_Value'+table_len;
		cell.innerHTML="<input type='text'  id='Tenor_Value"+table_len+"' maxlength='5' style='width:80px' onkeyup='ValidateNumeric(\""+Tenor_Value_id+"\");'>";
		if(arrayFacilityRowValues!='')
			document.getElementById("Tenor_Value"+table_len).value=arrayFacilityRowValues[6];
		
		var cell = row.insertCell(7);
		var Tenor_Frequency_id = 'Tenor_Frequency'+table_len;
		cell.innerHTML="<select class='NGReadOnlyView' id='Tenor_Frequency"+table_len+"' style='width:80px' >"
						+"<option value=''>--Select--</option>"
						+"</select>";
		//loading drop down values.
		var loadDropDownTenorFrequency=loadTenorFrequency(Tenor_Frequency_id);
		if(arrayFacilityRowValues!='')
			document.getElementById("Tenor_Frequency"+table_len).value=arrayFacilityRowValues[7];
		
		
		
		var cell = row.insertCell(8);
		var Cash_Margin_id = 'Cash_Margin'+table_len;
		cell.innerHTML="<input type='text' id='Cash_Margin"+table_len+"' maxlength='6' style='width:80px' onkeyup='ValidateNumeric(\""+Cash_Margin_id+"\");' onblur='ValidateDecimal(\""+Cash_Margin_id+"\");'>";
		if(arrayFacilityRowValues!='')
			document.getElementById("Cash_Margin"+table_len).value=arrayFacilityRowValues[8];
		
		var cell = row.insertCell(9);
		var InterestTypeID = 'InterestType'+table_len;
		cell.innerHTML="<select class='NGReadOnlyView' id='InterestType"+table_len+"' style='width:90px'>"
						+"<option value=''>--Select--</option>"
						+"</select>";
		loadInterestType(InterestTypeID);				
		if(arrayFacilityRowValues!='')
			document.getElementById("InterestType"+table_len).value=arrayFacilityRowValues[9];
		
		var cell = row.insertCell(10);
		var Interest_id = 'Interest'+table_len;
		cell.innerHTML="<textarea class='NGReadOnlyView' id='Interest"+table_len+"' style='width:100%,height:100%' cols=30 rows=3 onblur='auto_grow(this);checkRemarks(\""+Interest_id+"\",\"1000\");'></textarea>";
		if(arrayFacilityRowValues!='') {
			document.getElementById("Interest"+table_len).value=arrayFacilityRowValues[10];
			auto_grow(document.getElementById(Interest_id));
		}	
		setAutocompleteDataForgridCombo(table_len);
		
		var cell = row.insertCell(11);
		var InterestMargin_id = 'InterestMargin'+table_len;
		cell.innerHTML="<input type='text' id='InterestMargin"+table_len+"' maxlength='100' style='width:100px' onkeyup='SpecificFieldAndSpecialChar(\""+InterestMargin_id+"\");'>";
		if(arrayFacilityRowValues!='')
			document.getElementById("InterestMargin"+table_len).value=arrayFacilityRowValues[11];
		
		
		var cell = row.insertCell(12);
		var Interest_Rate_Standard_Grid = 'Interest_Rate_Standard_Grid'+table_len;
		cell.innerHTML="<select class='NGReadOnlyView' id='Interest_Rate_Standard_Grid"+table_len+"' style='width:100px' >"
						+"<option value=''>--Select--</option>"
						+"<option value='Yes'>Yes</option>"
						+"<option value='No'>No</option>"
						+"</select>";
		if(arrayFacilityRowValues!='')
			document.getElementById("Interest_Rate_Standard_Grid"+table_len).value=arrayFacilityRowValues[12];
		
		
		/*var cell = row.insertCell(13);
		var Margin_percent_id = 'Margin_percent'+table_len; 
		cell.innerHTML="<input type='text' id='Margin_percent"+table_len+"' maxlength='100' onkeyup='checkRemarks(\""+Margin_percent_id+"\",\"100\");' style='width:80px'>";
		if(arrayFacilityRowValues!='')
			document.getElementById("Margin_percent"+table_len).value=arrayFacilityRowValues[13]; */
		
		var cell = row.insertCell(13);
		//Commented on 02/04/2019
		// Defined before Nature of Facility
		//var Commission = 'Commission'+table_len;
		
		//Modified on 02/04/2019
		//cell.innerHTML="<input type='text' id='Commission"+table_len+"' maxlength='100' style='width:80px'>";
		cell.innerHTML="<textarea id='Commission"+table_len+"' maxlength='1000' onkeyup='checkRemarks(\""+Commission_Id+"\",\"1000\");' rows=4 cols=30></textarea>";
		
		if(arrayFacilityRowValues!='')
			document.getElementById("Commission"+table_len).value=arrayFacilityRowValues[13];
		
		var cell = row.insertCell(14);
		var Product_Level_Conditions = 'Product_Level_Conditions'+table_len;
		cell.innerHTML="<textarea id='Product_Level_Conditions"+table_len+"' maxlength='3000' onkeyup='checkRemarks(\""+Product_Level_Conditions+"\",\"3000\");' rows=4 cols=30></textarea>"; 
		if(arrayFacilityRowValues!='')
			document.getElementById("Product_Level_Conditions"+table_len).value=arrayFacilityRowValues[14].split('NEWTAB').join('\t');
			
			
		
		var cell = row.insertCell(15);
		var remarksid = 'remark'+table_len;
		cell.innerHTML="<textarea id='remark"+table_len+"' maxlength='1000' onkeyup='checkRemarks(\""+remarksid+"\",\"1000\");' rows=4 cols=30></textarea>";
		if(arrayFacilityRowValues!='')
		document.getElementById("remark"+table_len).value=arrayFacilityRowValues[15];
		
		cell = row.insertCell(16);
		var deleteid='facilityImage'+table_len;
		cell.innerHTML = "<img id='facilityImage"+table_len+"' src='/TWC/webtop/images/delete.gif' style='width:21px;height:21px;border:0' onclick='deleteRowsFromGridWithIndex(this.id)';>";	
		
		var facilityExisitingDisable=document.getElementById("Facility_Existing"+table_len);
		var facilitySoughtDisable=document.getElementById("Faciltiy_Sought"+table_len);
		var noDisable=document.getElementById("No"+table_len);
		var usageDisable=document.getElementById("Usage"+table_len);
		var natureofFacilityDisable=document.getElementById("Nature_of_Facility"+table_len);
		var typeDisable=document.getElementById("Type"+table_len);
		var purposeDisable=document.getElementById("Purpose"+table_len);
		var tenorValueDisable=document.getElementById("Tenor_Value"+table_len);
		var tenorFrequencyValueDisable=document.getElementById("Tenor_Frequency"+table_len);
		var cashMarginDisable=document.getElementById("Cash_Margin"+table_len);
		var InterestTypeDisable=document.getElementById("InterestType"+table_len);
		var interestValueDisable=document.getElementById("Interest"+table_len);
		var interestMargingDisable=document.getElementById("InterestMargin"+table_len);
		var interestRateStandardDisable=document.getElementById("Interest_Rate_Standard_Grid"+table_len);
		var commissionDisable=document.getElementById("Commission"+table_len);
		var productLevelConditionsDisable=document.getElementById("Product_Level_Conditions"+table_len);
		var remarksDisable=document.getElementById("remark"+table_len);
		var deleteDisable=document.getElementById("facilityImage"+table_len);
		if(decCropsFinalChecker=='Approve')
		{
			facilityExisitingDisable.disabled=true;
			facilitySoughtDisable.disabled=true;
			noDisable.disabled=true;
			usageDisable.disabled=true;
			natureofFacilityDisable.disabled=true;
			purposeDisable.disabled=true;
			tenorValueDisable.disabled=true;
			tenorFrequencyValueDisable.disabled=true;
			cashMarginDisable.disabled=true;
			InterestTypeDisable.disabled=true;
			interestValueDisable.disabled=true;
			interestMargingDisable.disabled=true;
			interestRateStandardDisable.disabled=true;
			commissionDisable.disabled=true;
			productLevelConditionsDisable.disabled=true;
			remarksDisable.disabled=true;
			deleteDisable.disabled=true;
		}
		//Added on 02/04/2019 to disable Facility Grid on Credit queues
		if(CurrentWS.indexOf("Credit")!=-1)
		{
			facilityExisitingDisable.disabled=false;
			facilitySoughtDisable.disabled=false;
			noDisable.disabled=false;
			usageDisable.disabled=false;
			natureofFacilityDisable.disabled=false;
			purposeDisable.disabled=false;
			tenorValueDisable.disabled=false;
			tenorFrequencyValueDisable.disabled=false;
			cashMarginDisable.disabled=false;
			InterestTypeDisable.disabled=false;
			interestValueDisable.disabled=false;
			interestMargingDisable.disabled=false;
			interestRateStandardDisable.disabled=false;
			commissionDisable.disabled=false;
			productLevelConditionsDisable.disabled=false;
			remarksDisable.disabled=false;
			deleteDisable.disabled=false;
		}
		//facilityExisitingDisable.disabled=true; // always disabling facility existing
		//setAutocompleteDataForgridCombo(table_len);
		//onSelectPopulate(table_len);
		
	}
	
	//Add General Condition Grid
	if(buttonid=='add_row_General_Condition')
	{
		var arrayGeneralConditionRowValues=arrayRowValues;
		if(arrayGeneralConditionRowValues!='')
		{
			arrayGeneralConditionRowValues=arrayGeneralConditionRowValues.split('AMPNDCHAR').join('&');
			arrayGeneralConditionRowValues=arrayGeneralConditionRowValues.split('CCCOMMAAA').join(',');
			arrayGeneralConditionRowValues=arrayGeneralConditionRowValues.split('PPPERCCCENTT').join('%');
			arrayGeneralConditionRowValues=arrayGeneralConditionRowValues.split("~");

		}
		var table = document.getElementById("General_Condition_Grid");
		var table_len=table.rows.length;
		var lastRow = table.rows[ table.rows.length];
		var row = table.insertRow();
		var cell = row.insertCell(0);
		var generalConditionid = 'generalCondition'+table_len;
		cell.innerHTML="<textarea id='generalCondition"+table_len+"' style='width:99%' onblur='checkRemarks(\""+generalConditionid+"\",\"1000\");'  onkeyup='checkRemarks(\""+generalConditionid+"\",\"1000\");auto_grow(this);'></textarea>";
		if(arrayGeneralConditionRowValues!=''){
			document.getElementById("generalCondition"+table_len).value=arrayGeneralConditionRowValues[0];
			auto_grow(document.getElementById(generalConditionid));
		}
		
		cell = row.insertCell(1);
		var deleteid='generalImage'+table_len;
		cell.innerHTML = "<img id='generalImage"+table_len+"' src='/TWC/webtop/images/delete.gif' style='width:21px;height:21px;border:0;' onclick='deleteRowsFromGridWithIndex(this.id);'>";
		
		var generalConditionDisable=document.getElementById("generalCondition"+table_len);
		var deleteDisable=document.getElementById("generalImage"+table_len);
		if(decCropsFinalChecker=='Approve')
		{
			generalConditionDisable.disabled=true;
			deleteDisable.disabled=true;
			
		}
	}
	
	//Add Security Details Grid
	if(buttonid=='add_row_Security_Document_Details')
	{
		//var SecurityDocDesciption='';
		var arraySecurityValues=arrayRowValues;
		if(arraySecurityValues!='')
		{
			arraySecurityValues=arraySecurityValues.split('AMPNDCHAR').join('&');
			arraySecurityValues=arraySecurityValues.split('CCCOMMAAA').join(',');
			arraySecurityValues=arraySecurityValues.split('PPPERCCCENTT').join('%');
			arraySecurityValues=arraySecurityValues.split("~");		
		}
		var table = document.getElementById("Security_Document_Details_Grid");
		var table_len=table.rows.length;
		var lastRow = table.rows[table.rows.length];
		var row = table.insertRow();
		
		var securityDocumentDescription_Id = 'securityDocumentDescription'+table_len;		
		
		//Modified on 11/04/2019
		var cell = row.insertCell(0);
		var securityDocumentType_Id= 'securityDocumentType'+table_len;
		var autoComplete='AutocompleteValuesSecurityDocType';
		/*cell.innerHTML="<input type='text' class='NGReadOnlyView' id='securityDocumentType"+table_len+"' style='width:100%,height:100%' onblur='setDocDescription(\""+securityDocumentType_Id+"\",\""+securityDocumentDescription_Id+"\");'>";*/
		//Modified on 04/04/2019
		cell.innerHTML="<textarea class='NGReadOnlyView' id='securityDocumentType"+table_len+"' maxlength='1000' style='width:100%,height:100%' cols=25 rows=5 ' onblur='auto_grow(this);'></textarea>";
		
		
		var securityDocTypeDropDow=setAutocompleteDataForgridCombo(table_len);
		if(arraySecurityValues!='')
			document.getElementById("securityDocumentType"+table_len).value=arraySecurityValues[0];
		
		var cell = row.insertCell(1);
		var descriptionId='securityDocumentDescription'+table_len;
		cell.innerHTML="<textarea id='securityDocumentDescription"+table_len+"' maxlength='1000' rows='6' cols='50' onkeydown='enableTab(\""+descriptionId+"\");' ></textarea>";
		if(arraySecurityValues!='')
			document.getElementById("securityDocumentDescription"+table_len).value=arraySecurityValues[1];
		
		//Modified on 27/03/2019. Onchange event added.
		var cell = row.insertCell(2);
		var TI = 'TI'+table_len;
		cell.innerHTML="<select class='NGReadOnlyView' id='TI"+table_len+"' style='width:80px'>"
						+"<option value=''>--Select--</option>"
						+"<option value='T'>T</option>"
						+"<option value='I'>I</option>"
						+"</select>";
		if(arraySecurityValues!='')
			document.getElementById("TI"+table_len).value=arraySecurityValues[2];
		
		//Modified on 27/03/2019. Onblur event added.
		var cell = row.insertCell(3);
		var value = 'value'+table_len;
		var valueId='value'+table_len;
		cell.innerHTML="<input type='text' id='value"+table_len+"' style='width:100px' maxlength='25' onkeyup='SpecificFieldAndSpecialChar(\""+valueId+"\");'>";
		if(arraySecurityValues!='')
			document.getElementById("value"+table_len).value=arraySecurityValues[3];
		
		//Modified on 27/03/2019. Onblur event added.
		var cell = row.insertCell(4);
		var FSV = 'FSV'+table_len;
		cell.innerHTML="<input type='text' id='FSV"+table_len+"' style='width:100px' maxlength='100' onkeyup='SpecificFieldAndSpecialChar(\""+FSV+"\");'>";
		if(arraySecurityValues!='')
			document.getElementById("FSV"+table_len).value=arraySecurityValues[4];
		
		var cell = row.insertCell(5);
		var limitedCovered = 'limitedCovered'+table_len;
		cell.innerHTML="<input type='text' id='limitedCovered"+table_len+"' style='width:100px' maxlength='100' onkeyup='SpecificFieldAndSpecialChar(\""+limitedCovered+"\");'>";
		if(arraySecurityValues!='')
			document.getElementById("limitedCovered"+table_len).value=arraySecurityValues[5];
		
		var cell = row.insertCell(6);
		var Held = 'Held'+table_len;
		cell.innerHTML="<select class='NGReadOnlyView' id='Held"+table_len+"' style='width:100px'>"
						+"<option value=''>--Select--</option>"
						+"<option value='Yes'>Yes</option>"
						+"<option value='No'>No</option>"
						+"</select>";
		if(arraySecurityValues!='')
			document.getElementById("Held"+table_len).value=arraySecurityValues[6];
		
		//Modified on 11/04/2019
		var cell = row.insertCell(7);
		var Conditionsid = 'Conditions'+table_len;
		cell.innerHTML="<textarea id='Conditions"+table_len+"' onblur='checkRemarks(\""+Conditionsid+"\",\"1000\");' onkeyup='checkRemarks(\""+Conditionsid+"\",\"1000\");auto_grow(this);' rows=5 cols=30></textarea>";
		if(arraySecurityValues!='')
		{
			document.getElementById("Conditions"+table_len).value=arraySecurityValues[7];
			auto_grow(document.getElementById(Conditionsid));
		}
		
		cell = row.insertCell(8);
		var deleteid='securityImage'+table_len;
		cell.innerHTML = "&nbsp;<img id='securityImage"+table_len+"' src='/TWC/webtop/images/delete.gif' style='width:50%;height:50%;border:0' onclick='deleteRowsFromGridWithIndex(this.id)'>";
		
		var securityDocumentTypeDisable=document.getElementById("securityDocumentType"+table_len);
		var securityDocumentDescDisable=document.getElementById("securityDocumentDescription"+table_len);
		var tIDisable=document.getElementById("TI"+table_len);
		var valueDisable=document.getElementById("value"+table_len);
		var fsvDisable=document.getElementById("FSV"+table_len);
		var limitedCoveredDisable=document.getElementById("limitedCovered"+table_len);
		var heldDisable=document.getElementById("Held"+table_len);
		var conditionsDisable=document.getElementById("Conditions"+table_len);
		var deleteDisable=document.getElementById("securityImage"+table_len);
		if(decCropsFinalChecker=='Approve')
		{
			securityDocumentTypeDisable.disabled=true;
			securityDocumentDescDisable.disabled=true;
			tIDisable.disabled=true;
			valueDisable.disabled=true;
			fsvDisable.disabled=true;
			limitedCoveredDisable.disabled=true;
			heldDisable.disabled=true;
			conditionsDisable.disabled=true;
			deleteDisable.disabled=true;
			
		}
		if(CurrentWS.indexOf("Credit")!=-1)
		{
			securityDocumentDescDisable.disabled=true;
		}
	}
	
	//Add Special Convenants Internal
	if(buttonid=='add_row_Special_Covenants_Internal')
	{
		var arraySpecialInternalValues=arrayRowValues;
		if(arraySpecialInternalValues!='')
		{
			arraySpecialInternalValues=arraySpecialInternalValues.split('AMPNDCHAR').join('&');
			arraySpecialInternalValues=arraySpecialInternalValues.split('CCCOMMAAA').join(',');
			arraySpecialInternalValues=arraySpecialInternalValues.split('PPPERCCCENTT').join('%');
			arraySpecialInternalValues=arraySpecialInternalValues.split("~");
		}
		var table = document.getElementById("Special_Covenants_Internal_Grid");
		var table_len=table.rows.length;
		var lastRow = table.rows[table.rows.length];
		var row = table.insertRow();
				
		var cell = row.insertCell(0);
		var specialCovenantsInternal = 'specialCovenantsInternal'+table_len;
		cell.innerHTML="<textarea id='specialCovenantsInternal"+table_len+"' style='width:99%' onblur='checkRemarks(\""+specialCovenantsInternal+"\",\"1000\");' onkeyup='checkRemarks(\""+specialCovenantsInternal+"\",\"1000\");auto_grow(this);'></textarea>";
		if(arraySpecialInternalValues!=''){
			document.getElementById("specialCovenantsInternal"+table_len).value=arraySpecialInternalValues[0];
			auto_grow(document.getElementById(specialCovenantsInternal));
		}
		
		cell = row.insertCell(1);
		var deleteid='internalImage'+table_len;
		cell.innerHTML = "&nbsp;<img id='internalImage"+table_len+"' src='/TWC/webtop/images/delete.gif' style='width:25%;height:25%;border:0' onclick='deleteRowsFromGridWithIndex(this.id)'>";
		
		var specialCovenantsInternalDisable=document.getElementById("specialCovenantsInternal"+table_len);
		var deleteDisable=document.getElementById("internalImage"+table_len);
		if(decCropsFinalChecker=='Approve')
		{
			specialCovenantsInternalDisable.disabled=true;
			deleteDisable.disabled=true;
		}
		
	}
	//Add Special Convenants External
	if(buttonid=='add_row_Special_Covenants_External')
	{
		var arraySpecialExternalValues=arrayRowValues;
		if(arraySpecialExternalValues!='')
		{
			arraySpecialExternalValues=arraySpecialExternalValues.split("AMPNDCHAR").join("&");		
			arraySpecialExternalValues=arraySpecialExternalValues.split("CCCOMMAAA").join(",");		
			arraySpecialExternalValues=arraySpecialExternalValues.split("PPPERCCCENTT").join("%");		
			arraySpecialExternalValues=arraySpecialExternalValues.split("~");
			
		}
		var table = document.getElementById("Special_Covenants_External_Grid");
		var table_len=table.rows.length;
		var lastRow = table.rows[table.rows.length];
		var row = table.insertRow();
				
		var cell = row.insertCell(0);
		var specialCovenantsExternal = 'specialCovenantsExternal'+table_len;
		cell.innerHTML="<textarea id='specialCovenantsExternal"+table_len+"' style='width:99%' onblur='checkRemarks(\""+specialCovenantsExternal+"\",\"1000\");' onkeyup='checkRemarks(\""+specialCovenantsExternal+"\",\"1000\");auto_grow(this);'></textarea>";
		if(arraySpecialExternalValues!=''){
			document.getElementById("specialCovenantsExternal"+table_len).value=arraySpecialExternalValues[0];
			auto_grow(document.getElementById(specialCovenantsExternal));
			}
		
		cell = row.insertCell(1);
		var deleteid='externalImage'+table_len;
		cell.innerHTML = "&nbsp;<img id='externalImage"+table_len+"' src='/TWC/webtop/images/delete.gif' style='width:25%;height:25%;border:0' onclick='deleteRowsFromGridWithIndex(this.id)'>";
		
		var specialCovenantsExternalDisable=document.getElementById("specialCovenantsExternal"+table_len);
		var deleteDisable=document.getElementById("externalImage"+table_len);
		if(decCropsFinalChecker=='Approve')
		{
			specialCovenantsExternalDisable.disabled=true;
			deleteDisable.disabled=true;
		}
	}
	
	//Add Deferral Details
	if(buttonid=='add_row_Defferal_Details')
	{
		var arrayDeferralRowValues=arrayRowValues;
		if(arrayDeferralRowValues!='')
		{
			
			arrayDeferralRowValues=arrayDeferralRowValues.split('AMPNDCHAR').join('&');
			arrayDeferralRowValues=arrayDeferralRowValues.split('CCCOMMAAA').join(',');
			arrayDeferralRowValues=arrayDeferralRowValues.split('PPPERCCCENTT').join('%');
			
			arrayDeferralRowValues=arrayDeferralRowValues.split("~");
			
		}
		var table = document.getElementById("Defferal_Details_Grid");
		var table_len=table.rows.length;
		var lastRow = table.rows[table.rows.length];
		var row = table.insertRow();
				
		var cell = row.insertCell(0);
		var deferralSNo = 'deferralSNo'+table_len;
		cell.innerHTML="<input type='text' disabled id='deferralSNo"+table_len+"' value='"+table_len+"' style='width:100%' readonly>";
		if(arrayDeferralRowValues!='')
			document.getElementById("deferralSNo"+table_len).value=arrayDeferralRowValues[0];
		
		var cell = row.insertCell(1);
		var document_type  = 'document_type'+table_len;
		cell.innerHTML="<input type='text' id='document_type"+table_len+"' style='width:100%' maxlength='100'>";
		if(arrayDeferralRowValues!='')
			document.getElementById("document_type"+table_len).value=arrayDeferralRowValues[1];
		
		var cell = row.insertCell(2);
		var approving_authority  = 'approving_authority'+table_len;
		cell.innerHTML="<input type='text' id='approving_authority"+table_len+"' style='width:100%' maxlength='200'>";
		if(arrayDeferralRowValues!='')
			document.getElementById("approving_authority"+table_len).value=arrayDeferralRowValues[2];
		
		var cell = row.insertCell(3);
		var deferral_expiry_date_id  = 'deferral_expiry_date'+table_len;
		cell.innerHTML="<input type='text' id='deferral_expiry_date"+table_len+"' style='width:80%' onBlur='validateDate(this.value,\""+deferral_expiry_date_id+"\");'>&nbsp;<img src='/TWC/webtop/images/cal.gif' id='deferral_calender"+table_len+"' style='width:7%;height:7%' border='0' alt='' onclick='initialize(\""+deferral_expiry_date_id+"\");'/>";
		if(arrayDeferralRowValues!='')
			document.getElementById("deferral_expiry_date"+table_len).value=arrayDeferralRowValues[3];
			
		//New Field Added by Sajan 17-03-2019
		var cell = row.insertCell(4);
		var def_remarks_id  = 'def_remarks'+table_len;
		cell.innerHTML="<textarea id='def_remarks"+table_len+"' maxlength='1000' style='width:95%'></textarea>";
		if(arrayDeferralRowValues!='')
			document.getElementById("def_remarks"+table_len).value=arrayDeferralRowValues[4];

		
		cell = row.insertCell(5);
		var deleteid='deferralImage'+table_len;
		cell.innerHTML = "&nbsp;<img id='deferralImage"+table_len+"' src='/TWC/webtop/images/delete.gif' style='width:50%;height:50%;border:0' onclick='deleteRowsFromGridWithIndex(this.id)'>";
		
		if(CurrentWS=='Sales_Data_Entry')
			document.getElementById(approving_authority).disabled=true;
		
		if(CurrentWS.indexOf("Credit")!=-1)
		{
			document_type.disabled=true;
			approving_authority.disabled=true;
			deferral_expiry_date_id.disabled=true;
			def_remarks_id.disabled=true;
			deleteid.disabled=true;
		}	
		
	}
	//Added on 20/02/2019 to Add Tranche Details 	
	//Start
	if(buttonid=='add_row_Tranche_Details')
	{
		var arrayTrancheRowValues=arrayRowValues;
		if(arrayTrancheRowValues!='')
		{
			
			arrayTrancheRowValues=arrayTrancheRowValues.split("AMPNDCHAR").join("&");		
			arrayTrancheRowValues=arrayTrancheRowValues.split("CCCOMMAAA").join(",");
			arrayTrancheRowValues=arrayTrancheRowValues.split("PPPERCCCENTT").join("%");

			arrayTrancheRowValues=arrayTrancheRowValues.split("~");
			
		}
		var table = document.getElementById("Tranche_Details_Grid");
		var table_len=table.rows.length;
		var lastRow = table.rows[table.rows.length];
		var row = table.insertRow();
				
		var cell = row.insertCell(0);
		var trancheSNo = 'trancheSNo'+table_len;
		cell.innerHTML="<input type='text' disabled id='trancheSNo"+table_len+"' value='"+table_len+"' style='width:100%' readonly>";
		if(arrayTrancheRowValues!='')
			document.getElementById("trancheSNo"+table_len).value=arrayTrancheRowValues[0];
		
		var cell = row.insertCell(1);
		var tranche_amount_id  = 'tranche_amount'+table_len;
		cell.innerHTML="<input type='text' id='tranche_amount"+table_len+"' maxlength='23' style='width:100%' onkeyup='ValidateNumeric(\""+tranche_amount_id+"\");validateLengthForAmount(\""+tranche_amount_id+"\",\"15\")' onblur='onBlurForAmount(\""+tranche_amount_id+"\");'>";
		if(arrayTrancheRowValues!='')
			document.getElementById("tranche_amount"+table_len).value=arrayTrancheRowValues[1];
		
		var cell = row.insertCell(2);
		var tranche_status_id  = 'tranche_status'+table_len;
		cell.innerHTML="<select class='NGReadOnlyView' id='tranche_status"+table_len+"' style='width:99%' maxlength='100'>"
						+"<option value=''>--Select--</option>"
						+"</select>";
		//loading drop down values.
		var loadDropDownTrancheStatus=loadTrancheStatus(tranche_status_id);
		if(arrayTrancheRowValues!='')
			document.getElementById("tranche_status"+table_len).value=arrayTrancheRowValues[2];
		
		//Added on  03/04/2019. 3 New Columns added.
		//Start
		var cell =row.insertCell(3);
		var tranche_available_period_id  = 'tranche_available_period'+table_len;
		cell.innerHTML="<input type='text' id='tranche_available_period"+table_len+"' style='width:80%' onBlur='validateDate(this.value,\""+tranche_available_period_id+"\");'>&nbsp;<img src='/TWC/webtop/images/cal.gif' id='tranche_calender_1"+table_len+"' class = 'NGReadOnlyView' style='width:10%;height:10%' style='CURSOR: pointer' border='0' alt='' onclick='initialize(\""+tranche_available_period_id+"\");'/>";
		if(arrayTrancheRowValues!='')
			document.getElementById("tranche_available_period"+table_len).value=arrayTrancheRowValues[3];
		
		var cell =row.insertCell(4);
		var tranche_disbursal_date_id  = 'tranche_disbursal_date'+table_len;
		cell.innerHTML="<input type='text' id='tranche_disbursal_date"+table_len+"' style='width:80%' onBlur='validateDate(this.value,\""+tranche_disbursal_date_id+"\");'>&nbsp;<img src='/TWC/webtop/images/cal.gif' id='tranche_calender_2"+table_len+"' class = 'NGReadOnlyView' style='width:10%;height:10%' style='CURSOR: pointer' border='0' alt='' onclick='initialize(\""+tranche_disbursal_date_id+"\");'/>";
		if(arrayTrancheRowValues!='')
			document.getElementById("tranche_disbursal_date"+table_len).value=arrayTrancheRowValues[4];
		
		var cell = row.insertCell(5);
		var tranche_remarks_id = 'tranche_remarks'+table_len;
		cell.innerHTML="<textarea id='tranche_remarks"+table_len+"' maxlength='1000' onkeyup='checkRemarks(\""+tranche_remarks_id+"\",\"1000\");' style='width:95%'></textarea>";
		if(arrayTrancheRowValues!='')
			document.getElementById("tranche_remarks"+table_len).value=arrayTrancheRowValues[5];
		//End
		
		//Modified on 03/04/2019. 
		cell = row.insertCell(6);
		var deleteid='trancheImage'+table_len;
		cell.innerHTML = "&nbsp;<img id='trancheImage"+table_len+"' src='/TWC/webtop/images/delete.gif' style='width:25%;height:25%;border:0' onclick='deleteRowsFromGridWithIndex(this.id)' >";
		
		//Disable Tranche Grid at all worksteps other than Tranche_Disbursal_Hold
		//Added on 01/03/2019
		//Modified on 03/04/2019. 3 New Columns added.
		var trancheSNoDisable=document.getElementById("trancheSNo"+table_len);
		var trancheAmountDisable=document.getElementById("tranche_amount"+table_len);
		var trancheStatusDisable=document.getElementById("tranche_status"+table_len);
		var trancheImageDisable=document.getElementById("trancheImage"+table_len);
		var trancheAvailablePeriodDisable=document.getElementById("tranche_available_period"+table_len);
		var trancheDisbursalDateDisable=document.getElementById("tranche_disbursal_date"+table_len);
		var trancheRemarksDisable=document.getElementById("tranche_remarks"+table_len);
		var trancheCalendar1Disable=document.getElementById("tranche_calender_1"+table_len);
		var trancheCalendar2Disable=document.getElementById("tranche_calender_2"+table_len);
		
		var trancheButtonDisable=document.getElementById("add_row_Tranche_Details");
		//Condition Modified on 03/04/2019
		if((CurrentWS=="CROPS_Admin_Maker" || CurrentWS=='CROPS_Admin_Checker'|| CurrentWS=='CROPS_Disbursal_Maker' || CurrentWS=='CROPS_Disbursal_Checker'||CurrentWS=='Sales_Data_Entry') && trancheButtonDisable.disabled == false)
		{
			//trancheSNoDisable.disabled=false;
			trancheAmountDisable.disabled=false;
			trancheStatusDisable.disabled=false;
			trancheImageDisable.disabled=false;
			if(CurrentWS!='Sales_Data_Entry'){
				trancheAvailablePeriodDisable.disabled=false;
				trancheDisbursalDateDisable.disabled=false;
				trancheCalendar1Disable.disabled=false;
				trancheCalendar2Disable.disabled=false;
			}else{
				trancheAvailablePeriodDisable.disabled=true;
				trancheDisbursalDateDisable.disabled=true;
				trancheCalendar1Disable.disabled=true;
				trancheCalendar2Disable.disabled=true;
			}
			trancheRemarksDisable.disabled=false;
		}
		else 
		{
			trancheSNoDisable.disabled=true;
			trancheAmountDisable.disabled=true;
			trancheStatusDisable.disabled=true;
			trancheImageDisable.disabled=true;
			trancheAvailablePeriodDisable.disabled=true;
			trancheDisbursalDateDisable.disabled=true;
			trancheRemarksDisable.disabled=true;
			trancheCalendar1Disable.disabled=true;
			trancheCalendar2Disable.disabled=true;
		}
	}
	//End
	
	//Add UID Details
	if(buttonid=='add_row_UID')
	{
		var arrayUIDRowValues=arrayRowValues;
		if(arrayUIDRowValues!='')
		{
			arrayUIDRowValues=arrayUIDRowValues.split("AMPNDCHAR").join("&");
			arrayUIDRowValues=arrayUIDRowValues.split("CCCOMMAAA").join(",");	
			arrayUIDRowValues=arrayUIDRowValues.split("PPPERCCCENTT").join("%");				
			
			
			arrayUIDRowValues=arrayUIDRowValues.split("~");
			
		}
		var table = document.getElementById("UID_Grid");
		var table_len=table.rows.length;
		var lastRow = table.rows[table.rows.length];
		var row = table.insertRow();
				
		var cell = row.insertCell(0);
		var UIDSNo = 'UIDSNo '+table_len;
		cell.innerHTML="<input type='text' disabled id='UIDSNo"+table_len+"' value='"+table_len+"' style='width:100%'>";
		if(arrayUIDRowValues!='')
			document.getElementById("UIDSNo"+table_len).value=arrayUIDRowValues[0];
		
		var cell = row.insertCell(1);
		var UID_id = 'UID'+table_len;
		cell.innerHTML="<input type='text' id='UID"+table_len+"' maxlength='20' style='width:100%' onkeyup='ValidateAlphaNumeric(\""+UID_id+"\");'>";
		if(arrayUIDRowValues!='')
			document.getElementById("UID"+table_len).value=arrayUIDRowValues[1];
		
		var cell = row.insertCell(2);
		var Remarks= 'Remarks'+table_len;
		cell.innerHTML="<textarea id='Remarks"+table_len+"' maxlength='1000' style='width:95%' onkeyup='checkRemarks(\""+Remarks+"\",\"1000\");'></textarea>";
		if(arrayUIDRowValues!='')
			document.getElementById("Remarks"+table_len).value=arrayUIDRowValues[2];
		
		cell = row.insertCell(3);
		var deleteid='UIDImage'+table_len;
		cell.innerHTML = "&nbsp;<img id='UIDImage"+table_len+"' src='/TWC/webtop/images/delete.gif' style='width:30%;height:30%;border:0' onclick='deleteRowsFromGridWithIndex(this.id)'>";
		
		//var UIDSNoDisable=document.getElementById("UIDSNo"+table_len);
		var UIDDisable=document.getElementById("UID"+table_len);
		var RemarksDisable=document.getElementById("Remarks"+table_len);
		var deleteDisable=document.getElementById("UIDImage"+table_len);
		
		//Disable UID Grid at all worksteps other than CBRB Checker.
		if(CurrentWS=='Quality_Control') //Workstep name modified on 20/02/2019
		{
			UIDDisable.disabled=false;
			RemarksDisable.disabled=true;
			deleteDisable.disabled=false;
		}
		else if(CurrentWS=='Business_Approver_1st' || CurrentWS=='Business_Approver_2nd')
		{
			UIDDisable.disabled=true;
			RemarksDisable.disabled=false;
			deleteDisable.disabled=true;
		}
		else{
			UIDDisable.disabled=true;
			RemarksDisable.disabled=true;
			deleteDisable.disabled=true;
		}
		/*else 
		{
			//Disable delete at CBWC Checker for already added row when workitem is submitted by CBWC Checker previously.
			var Dec_CBWCChecker= document.getElementById("wdesk:Dec_CBWC_Checker").value;
			if(disableFlag=='Y' && Dec_CBWCChecker!='')
				deleteDisable.disabled=true;
		}*/
		
	}
	
}
//Delete Row from Grid
function deleteRowsFromGridWithIndex(id)
{
	//Delete Row from Facility Details 
	if(id.indexOf("facilityImage")!=-1)
	{
		if (document.getElementById("add_row_Facility_Details").disabled == true)
			return true;
		
		var r = confirm("Do you want to delete the row?");
		if(r == true)
		{
			var row = window.event.srcElement;
			row = row.parentNode.parentNode;
			var rowindex=row.rowIndex;
			var table = document.getElementById("Facility_Details_Grid");
			var rowCount = table.rows.length;
			if(rowCount==2)//means only one row added then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			
			else if((rowCount-1)==rowindex)//means last row is being deleted then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			else
			{
				var arrayFacilityFieldsForSave=['Facility_Existing','Faciltiy_Sought','No','Usage','Nature_of_Facility','Purpose','Tenor_Value','Tenor_Frequency','Cash_Margin','InterestType','Interest','InterestMargin','Interest_Rate_Standard_Grid','Commission','Product_Level_Conditions','remark'];
				
					for(var k=0;k<arrayFacilityFieldsForSave.length;k++)
					 {
						for(var j=rowindex;j<(rowCount-1);j++)
						{
							var currentRowId=parseInt(j)+1;
							document.getElementById(arrayFacilityFieldsForSave[k]+currentRowId).id = arrayFacilityFieldsForSave[k] +(j);
						}
					 }
					 table.deleteRow(rowindex);
			}
			//Auto calculate Total Facility Existing and Total Facility Sought after deleting Row.
			autoCalculateFields();
		}
		
	}
	
	//Delete Row from General Details 
	if(id.indexOf("generalImage")!=-1)
	{
		if (document.getElementById("add_row_General_Condition").disabled == true)
			return true;
		
		var r = confirm("Do you want to delete the row?");
		if(r == true)
		{
			var row = window.event.srcElement;
			row = row.parentNode.parentNode;
			var rowindex=row.rowIndex;
			var table = document.getElementById("General_Condition_Grid");
			var rowCount = table.rows.length;
			if(rowCount==2)//means only one row added then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			
			else if((rowCount-1)==rowindex)//means last row is being deleted then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			else
			{
				var arrayGeneralFieldsForSave=['generalCondition'];
				
					for(var k=0;k<arrayGeneralFieldsForSave.length;k++)
					 {
						for(var j=rowindex;j<(rowCount-1);j++)
						{
							var currentRowId=parseInt(j)+1;
							document.getElementById(arrayGeneralFieldsForSave[k]+currentRowId).id = arrayGeneralFieldsForSave[k] +(j);
						}
					 }
					 table.deleteRow(rowindex);
			}
			document.getElementById('generalgridflag').value='true'; // added by Sowmya on 28072022 to avoid auto delete data in grid
		}
	}
	
	//Delete Row from Security Details 
	if(id.indexOf("securityImage")!=-1)
	{
		if (document.getElementById("add_row_Security_Document_Details").disabled == true)
			return true;
			
		var r = confirm("Do you want to delete the row?");
		if(r == true)
		{
			var row = window.event.srcElement;
			row = row.parentNode.parentNode;
			var rowindex=row.rowIndex;
			var table = document.getElementById("Security_Document_Details_Grid");
			var rowCount = table.rows.length;
			if(rowCount==2)//means only one row added then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			
			else if((rowCount-1)==rowindex)//means last row is being deleted then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			else
			{
				var arraySecurityFieldsForSave=['securityDocumentType','securityDocumentDescription','TI','value','FSV','limitedCovered','Held','Conditions'];
				
					for(var k=0;k<arraySecurityFieldsForSave.length;k++)
					 {
						for(var j=rowindex;j<(rowCount-1);j++)
						{
							var currentRowId=parseInt(j)+1;
							document.getElementById(arraySecurityFieldsForSave[k]+currentRowId).id = arraySecurityFieldsForSave[k] + (j);
						}
					 }
					 table.deleteRow(rowindex);
			}
			//Added on 27/03/2019 
			//Auto Calculate Fields Sum of FSV and Sum of Value after deleting the row.
			//autoCalculateSecurityFields();
			document.getElementById('securitygridflag').value='true'; // added by Sowmya on 28072022 to avoid auto delete data in grid
		}
	}
	
	//Delete Row from SpecialCovenantsInternalGrid 
	if(id.indexOf("internalImage")!=-1)
	{
		if (document.getElementById("add_row_Special_Covenants_Internal").disabled == true)
			return true;
			
		var r = confirm("Do you want to delete the row?");
		if(r == true)
		{
			var row = window.event.srcElement;
			row = row.parentNode.parentNode;
			var rowindex=row.rowIndex;
			var table = document.getElementById("Special_Covenants_Internal_Grid");
			var rowCount = table.rows.length;
			if(rowCount==2)//means only one row added then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			
			else if((rowCount-1)==rowindex)//means last row is being deleted then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			else
			{
				var arrayInternalFieldsForSave=['specialCovenantsInternal'];
				
					for(var k=0;k<arrayInternalFieldsForSave.length;k++)
					 {
						for(var j=rowindex;j<(rowCount-1);j++)
						{
							var currentRowId=parseInt(j)+1;
							document.getElementById(arrayInternalFieldsForSave[k]+currentRowId).id = arrayInternalFieldsForSave[k] + (j);
						}
					 }
					 table.deleteRow(rowindex);
			}
			document.getElementById('internalcondgridflag').value='true'; // added by Sowmya on 28072022 to avoid auto delete data in grid
		}
	}
	
	//Delete Row from SpecialCovenantsExternalGrid 
	if(id.indexOf("externalImage")!=-1)
	{
		if (document.getElementById("add_row_Special_Covenants_External").disabled == true)
			return true;
			
		var r = confirm("Do you want to delete the row?");
		if(r == true)
		{
			var row = window.event.srcElement;
			row = row.parentNode.parentNode;
			var rowindex=row.rowIndex;
			var table = document.getElementById("Special_Covenants_External_Grid");
			var rowCount = table.rows.length;
			if(rowCount==2)//means only one row added then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			
			else if((rowCount-1)==rowindex)//means last row is being deleted then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			else
			{
				var arrayExternalFieldsForSave=['specialCovenantsExternal'];
				
					for(var k=0;k<arrayExternalFieldsForSave.length;k++)
					 {
						for(var j=rowindex;j<(rowCount-1);j++)
						{
							var currentRowId=parseInt(j)+1;
							document.getElementById(arrayExternalFieldsForSave[k]+currentRowId).id = arrayExternalFieldsForSave[k] + (j);
						}
					 }
					 table.deleteRow(rowindex);
			}
			document.getElementById('externalcondgridflag').value='true'; // added by Sowmya on 28072022 to avoid auto delete data in grid
		}
	}
	
	//Delete Row from Deferral Grid
	if(id.indexOf("deferralImage")!=-1)
	{
		if (document.getElementById("add_row_Defferal_Details").disabled == true)
			return true;
			
		var r = confirm("Do you want to delete the row?");
		if(r == true)
		{
			var row = window.event.srcElement;
			row = row.parentNode.parentNode;
			var rowindex=row.rowIndex;
			var table = document.getElementById("Defferal_Details_Grid");
			var rowCount = table.rows.length;
			if(rowCount==2)//means only one row added then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			
			else if((rowCount-1)==rowindex)//means last row is being deleted then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			else
			{
				var arrayDefferalFieldsForSave=['deferralSNo','document_type','approving_authority','deferral_expiry_date'];
				
					for(var k=0;k<arrayDefferalFieldsForSave.length;k++)
					 {
						for(var j=rowindex;j<(rowCount-1);j++)
						{
							var currentRowId=parseInt(j)+1;
							if(arrayDefferalFieldsForSave[k]=='deferralSNo')
								document.getElementById(arrayDefferalFieldsForSave[k]+currentRowId).value=j;
							document.getElementById(arrayDefferalFieldsForSave[k]+currentRowId).id = arrayDefferalFieldsForSave[k] + (j);
							
						}
					 }
					 table.deleteRow(rowindex);
			}
		}
	}
	
	//Delete Row from Tranche Details Grid 
	//Added on 20/02/2019
	//Start
	//Modified on 03/04/2019. 3 New Columns added
	if(id.indexOf("trancheImage")!=-1)
	{
	
		if (document.getElementById("add_row_Tranche_Details").disabled == true)
			return true;
			
		var r = confirm("Do you want to delete the row?");
		if(r == true)
		{
			var row = window.event.srcElement;
			row = row.parentNode.parentNode;
			var rowindex=row.rowIndex;
			var table = document.getElementById("Tranche_Details_Grid");
			var rowCount = table.rows.length;
			if(rowCount==2)//means only one row added then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			
			else if((rowCount-1)==rowindex)//means last row is being deleted then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			else
			{
				var arrayTranceFieldsForSave=['trancheSNo','tranche_amount','tranche_status','tranche_available_period','tranche_disbursal_date','tranche_remarks'];
				
					for(var k=0;k<arrayTranceFieldsForSave.length;k++)
					 {
						for(var j=rowindex;j<(rowCount-1);j++)
						{
							var currentRowId=parseInt(j)+1;
							if(arrayTranceFieldsForSave[k]=='deferralSNo')
								document.getElementById(arrayTranceFieldsForSave[k]+currentRowId).value=j;
							document.getElementById(arrayTranceFieldsForSave[k]+currentRowId).id = arrayTranceFieldsForSave[k] + (j);
							
						}
					 }
					 table.deleteRow(rowindex);
			}
		}
	}
	//End
	
	//Delete Row from UID Grid
	if(id.indexOf("UIDImage")!=-1)
	{
		if (document.getElementById("add_row_UID").disabled == true)
			return true;
			
		var r = confirm("Do you want to delete the row?");
		if(r == true)
		{
			var row = window.event.srcElement;
			row = row.parentNode.parentNode;
			var rowindex=row.rowIndex;
			var table = document.getElementById("UID_Grid");
			var rowCount = table.rows.length;
			if(rowCount==2)//means only one row added then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			
			else if((rowCount-1)==rowindex)//means last row is being deleted then no need to update id's.Just delete the row
				table.deleteRow(rowindex);
			else
			{
				var arrayUIDFieldsForSave=['UIDSNo','UID','Remarks'];
				
					for(var k=0;k<arrayUIDFieldsForSave.length;k++)
					 {
						for(var j=rowindex;j<(rowCount-1);j++)
						{
							var currentRowId=parseInt(j)+1;
							if(arrayUIDFieldsForSave[k]=='UIDSNo')
								document.getElementById(arrayUIDFieldsForSave[k]+currentRowId).value=j;
							document.getElementById(arrayUIDFieldsForSave[k]+currentRowId).id = arrayUIDFieldsForSave[k] + (j);
							
						}
					 }
					 table.deleteRow(rowindex);
			}
		}
	}
}

//added by stutee.mishra
var dialogToOpenType = null;
var popupWindow=null;
function setValue(val1) 
{
   //you can use the value here which has been returned by your child window
   popupWindow = val1;
   if(dialogToOpenType == 'Exception_History'){
	   if(popupWindow != 'undefined' && popupWindow!=null && popupWindow!="NO_CHANGE" && popupWindow!='[object Window]') {
				var result = popupWindow.split("@");
				document.getElementById('H_CHECKLIST').value = result[0];
				//alert("the values are " +document.getElementById('H_CHECKLIST').value);
			}
   }else if(dialogToOpenType == 'Reject_Reason'){
		if (popupWindow!="NO_CHANGE" && popupWindow!='[object Window]')
				document.getElementById('rejReasonCodes').value = popupWindow;
   }		
}
//ends here.

// onclick Reject Reason, DecisionHistory and Exception History
function openCustomDialog(dialogToOpenID,workstepName)
{
	dialogToOpenType = dialogToOpenID;
	if (workstepName!=null &&  workstepName!='')
	{
		//var popupWindow=null;
		var sOptions;
		if (dialogToOpenID=='Reject_Reason')
		{
			var WSNAME =  document.getElementById("wdesk:Current_WS").value;
			var WINAME = document.getElementById("wdesk:WI_NAME").value;
			//alert("workstep name"+WSNAME);
			//alert("workitem name"+WINAME);
			var rejectReasons = document.getElementById('rejReasonCodes').value;
			//alert("reject reason"+rejectReasons);
			sOptions = 'dialogWidth:500px; dialogHeight:500px; dialogLeft:450px; dialogTop:50px; status:no; scroll:no; help:no; resizable:no';
			//popupWindow = window.showModalDialog('../TWC_Specific/RejectReasons.jsp?workstepName=' + WSNAME + "&WINAME=" + WINAME + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null, sOptions);
			
			//added below to handle window.open/window.showModalDialog according to type of browser starts here.
			/***********************************************************/
			var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
			if (window.showModalDialog) {
				popupWindow = window.showModalDialog('../TWC_Specific/RejectReasons.jsp?workstepName=' + WSNAME + "&WINAME=" + WINAME + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null, sOptions);
			} else {
				popupWindow = window.open('../TWC_Specific/RejectReasons.jsp?workstepName=' + WSNAME + "&WINAME=" + WINAME + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null,windowParams);
			}
			/************************************************************/
			//added below to handle window.open/window.showModalDialog according to type of browser  ends here.
					
					
			//Set the response code to the input with id = rejReasonCodes
			if (popupWindow!="NO_CHANGE" && popupWindow!='[object Window]')
				document.getElementById('rejReasonCodes').value = popupWindow;	
		}
		if(dialogToOpenID=='Decision_History')
		{
			var WINAME = document.getElementById("wdesk:WI_NAME").value;
			//window.showModalDialog("../TWC_Specific/DecisionHistory.jsp?WINAME="+WINAME,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
			//added below to handle window.open/window.showModalDialog according to type of browser starts here.
			/***********************************************************/
			var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
			if (window.showModalDialog) {
				window.showModalDialog("../TWC_Specific/DecisionHistory.jsp?WINAME="+WINAME,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
			} else {
				window.open("../TWC_Specific/DecisionHistory.jsp?WINAME="+WINAME,"",windowParams);
			}
			/************************************************************/
			//added below to handle window.open/window.showModalDialog according to type of browser  ends here.
		}
		
		else if (dialogToOpenID=='Exception_History') {
			var workstepName = document.getElementById("wdesk:Current_WS").value;
			var wi_name = document.getElementById("wdesk:WI_NAME").value;
			var H_CHECKLIST = document.getElementById('H_CHECKLIST').value;

			sOptions = 'dialogWidth:850px; dialogHeight:500px; dialogLeft:250px; dialogTop:80px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;';

			//popupWindow = window.showModalDialog('/TWC/CustomForms/TWC_Specific/ExceptionChecklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST),null,sOptions);
			
			//added below to handle window.open/window.showModalDialog according to type of browser starts here.
			/***********************************************************/
			var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
			if (window.showModalDialog) {
				popupWindow = window.showModalDialog('/TWC/CustomForms/TWC_Specific/ExceptionChecklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST),null,sOptions);
			} else {
				popupWindow = window.open('/TWC/CustomForms/TWC_Specific/ExceptionChecklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST), null,windowParams);
			}
			/************************************************************/
			//added below to handle window.open/window.showModalDialog according to type of browser  ends here.


			//Set the response code to the input with id = H_CHECKLIST
			if(popupWindow != 'undefined' && popupWindow!=null && popupWindow!="NO_CHANGE" && popupWindow!='[object Window]') {
				var result = popupWindow.split("@");
				document.getElementById('H_CHECKLIST').value = result[0];
				//alert("the values are " +document.getElementById('H_CHECKLIST').value);
			}
			
		}
		else if (dialogToOpenID=='View Signature')
		{
			var custid = document.getElementById("wdesk:CIF_Id").value;
			if(custid == "")
			{
				alert("Please enter cif id");
				document.getElementById("wdesk:CIF_Id").focus(true);
				return false;
			}
			
			var popupWindow = null;
			var AccountnoSig = fetchAccountDetails(custid);
			
			var sOptions = 'left=200,top=50,width=850,height=650,scrollbars=1,resizable=1; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;';
			
			var url = "/TWC/CustomForms/TWC_Specific/OpenImage.jsp?acc_num_new="+AccountnoSig+"&ws_name="+workstepName;
			
			popupWindow = window.open(url, "_blank", sOptions);
		}
		//added below as a part of TWC_Copy_Profile changes on 16/06/23
		else if (dialogToOpenID=='ParentWI_UID_History')
		{
			var Parent_WI = document.getElementById("wdesk:Parent_WI").value;
			var Par_WINAME_Source = document.getElementById("wdesk:Source_Parent_WI").value;
			//added below to handle window.open/window.showModalDialog according to type of browser starts here.
			/***********************************************************/
			var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
			if (window.showModalDialog) {
				window.showModalDialog("../TWC_Specific/ParentWIUIDHistory.jsp?Parent_WI="+Parent_WI+"&ParentSource="+Par_WINAME_Source,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
			} else {
				window.open("../TWC_Specific/ParentWIUIDHistory.jsp?Parent_WI="+Parent_WI+"&ParentSource="+Par_WINAME_Source,"",windowParams);
			}
			/************************************************************/
			//added below to handle window.open/window.showModalDialog according to type of browser  ends here.
		}
		
		else if(dialogToOpenID=='ParentWI_Decision_History')
		{
			var WINAME = document.getElementById("wdesk:Parent_WI").value;
			var Par_WINAME_Source = document.getElementById("wdesk:Source_Parent_WI").value;
			if(Par_WINAME_Source == 'iBPS' || Par_WINAME_Source == 'IBPS')
			{
				var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
				if (window.showModalDialog) {
					window.showModalDialog("../TWC_Specific/DecisionHistory.jsp?WINAME="+WINAME,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
				} 
				else
				{
					window.open("../TWC_Specific/DecisionHistory.jsp?WINAME="+WINAME,"",windowParams);
				}
			}
			else
			{
				var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
				if (window.showModalDialog) {
					window.showModalDialog("../TWC_Specific/ParentWIDecisionHistory.jsp?WINAME="+WINAME,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
				} else {
					window.open("../TWC_Specific/ParentWIDecisionHistory.jsp?WINAME="+WINAME,"",windowParams);
				}
				/************************************************************/
			}
			
			//added below to handle window.open/window.showModalDialog according to type of browser  ends here.
		}
		/*else if (dialogToOpenID=='ParentWI_Decision_History')
		{
			var Parent_WI = document.getElementById("wdesk:Parent_WI").value;
			//added below to handle window.open/window.showModalDialog according to type of browser starts here.
			var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
			if (window.showModalDialog) {
				window.showModalDialog("../TWC_Specific/ParentWIDecisionHistory.jsp?Parent_WI="+Parent_WI,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
			} else {
				window.open("../TWC_Specific/ParentWIDecisionHistory.jsp?Parent_WI="+Parent_WI,"",windowParams);
			}
			//added below to handle window.open/window.showModalDialog according to type of browser  ends here.
		}	 */
	}
}

function setSignMatchValues(wsname,signMatchStatus)
{
	if(wsname == 'CROPS_Disbursal_Maker') 
	{
		document.getElementById('sign_matched_cropsDisbursal_maker').value = signMatchStatus;
	}
	else if(wsname == 'CROPS_Disbursal_Checker') 
	{
		document.getElementById('sign_matched_cropsDisbursal_checker').value = signMatchStatus;
	}
	if(wsname == 'CROPS_Deferral_Maker') 
	{
		document.getElementById('sign_matched_cropsDeferral_maker').value = signMatchStatus;
	}
	else if(wsname == 'CROPS_Deferral_Checker') 
	{
		document.getElementById('sign_matched_cropsDeferral_checker').value = signMatchStatus;
	}
}

//Save Exception
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
	
    var xhr;
    if (window.XMLHttpRequest)
        xhr = new XMLHttpRequest();
    else if (window.ActiveXObject)
        xhr = new ActiveXObject("Microsoft.XMLHTTP");

    var url = "/TWC/CustomForms/TWC_Specific/SaveException.jsp";
	var param = "&WINAME=" + WINAME + "&WSNAME=" + WSNAME + "&checklistData=" + checklistData;
    xhr.open("POST", url, false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.send(param);
	
    if (xhr.status == 200 && xhr.readyState == 4) 
	{
        ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
        if (ajaxResult == '' || ajaxResult=="" || ajaxResult==null)
		{
            alert("Problem in saving exception");
            return false;
        }
		else if(ajaxResult=='-1')
		{
			alert("Problem in saving exceptions");
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
	var table = customform.document.getElementById("UID_Grid");
	var ajaxResult='';
    var rowCount = table.rows.length;
	/*if(rowCount==1)//When no row added in grid
	return true;*/
	
    var wi_name =customform.document.getElementById("wdesk:WI_NAME").value;
	var WSNAME =customform.document.getElementById("wdesk:Current_WS").value;
	var arrayUIDFieldsForSave=['UID','Remarks'];
	var gridRowAll = '';
    for (var i = 1; i < rowCount; i++) 
	{
		var gridRow = "";
        var colCount = table.rows[i].cells.length;
        var currentrow = table.rows[i];
        for (var j = 0; j < arrayUIDFieldsForSave.length; j++) 
		{
			if (arrayUIDFieldsForSave[j] == 'UID' && customform.document.getElementById(arrayUIDFieldsForSave[j]+i).value == '')
			{
				gridRow = '';
				break;
			} 
			if (gridRow != "") 
			{
				var value = customform.document.getElementById(arrayUIDFieldsForSave[j]+i).value;
				value=value.split("&").join("AMPNDCHAR");
				value=value.split(",").join("CCCOMMAAA");
				value=value.split("%").join("PPPERCCCENTT");
				value=value.split("+").join("PLUSCHAR");
				value=value.split("'").join("ENSQOUTES");
				value=value.split(/(\r)/).join('<br>');
				value=value.split('~').join('');
				value=value.split('|').join('');
				gridRow = gridRow + "~" +  value;
			} 
			else 
			{
				var value = customform.document.getElementById(arrayUIDFieldsForSave[j]+i).value;
				value=value.split("&").join("AMPNDCHAR");
				value=value.split(",").join("CCCOMMAAA");
				value=value.split("%").join("PPPERCCCENTT");
				value=value.split("+").join("PLUSCHAR");
				value=value.split("'").join("ENSQOUTES");
				value=value.split(/(\r)/).join('<br>');
				value=value.split('~').join('');
				value=value.split('|').join('');
				gridRow = i+"~"+ value;
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
            var url = "/TWC/CustomForms/TWC_Specific/InsertUIDData.jsp";
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
//Save All the Grid Data
function saveGridData() 
{	
	var Facilitytable=customform.document.getElementById("Facility_Details_Grid");
	var Generaltable=customform.document.getElementById("General_Condition_Grid");
	var Securitytable=customform.document.getElementById("Security_Document_Details_Grid");
	var Internaltable=customform.document.getElementById("Special_Covenants_Internal_Grid");
	var Externaltable=customform.document.getElementById("Special_Covenants_External_Grid");
	var Deferraltable=customform.document.getElementById("Defferal_Details_Grid");
	//var UIDtable = customform.document.getElementById("UID_Grid");
	var wi_name =customform.document.getElementById("wdesk:WI_NAME").value;
	var WSNAME =customform.document.getElementById("wdesk:Current_WS").value;
	//Added on 21/02/2019 
	var Tranchetable=customform.document.getElementById("Tranche_Details_Grid");
	//Modified on 21/02/2019
	var tableArray=[Facilitytable,Generaltable,Securitytable,Internaltable,Externaltable,Deferraltable,Tranchetable];
		
	for(var table=0;table<tableArray.length;table++)
	{
		var ajaxResult="";
		//var table_name="";
		var procName="";
		var rowCount="";
		var arrayFieldsForSave="";
		var column_names="";
		var gridRowAll="";
		var isDeleted='false';
		if(tableArray[table].id=='Facility_Details_Grid')
		{
			if (customform.document.getElementById("add_row_Facility_Details").disabled == true && WSNAME!='CROPS_Finalization_Maker' && WSNAME!='CROPS_Finalization_Checker' && WSNAME!='CROPS_Disbursal_Maker' && WSNAME!='CROPS_Disbursal_Checker') //save only when enabled added on 21042019
				continue;
			procName='TWC_InsertFacilityDetails';
			arrayFieldsForSave=['Facility_Existing','Faciltiy_Sought','No','Usage','Nature_of_Facility','Purpose','Tenor_Value','Tenor_Frequency','Cash_Margin','InterestType','Interest','InterestMargin','Interest_Rate_Standard_Grid','Commission','Product_Level_Conditions','remark'];
			column_names="FACILITY_SR_NO,WINAME,Facility_Existing,Facility_Sought,No,Usage,Nature_of_Facility,Purpose,Tenor_Value,Tenor_Frequency,Cash_Margin,InterestType,Interest,InterestMargin,Is_Interest_Below_Grid,Commission,Product_level_Conditions,Remarks";
			
		}
		else if(tableArray[table].id=='General_Condition_Grid')
		{
			if (customform.document.getElementById("add_row_General_Condition").disabled == true) //save only when enabled added on 21042019
				continue;
			procName='TWC_InsertGeneralConditions';
			arrayFieldsForSave=['generalCondition'];
			column_names="GENERAL_SR_NO,WINAME,General_Conditions";
			isDeleted=customform.document.getElementById('generalgridflag').value;
		}
		else if(tableArray[table].id=='Security_Document_Details_Grid')
		{
			if (customform.document.getElementById("add_row_Security_Document_Details").disabled == true)//save only when enabled added on 21042019
				continue;
			procName='TWC_InsertSecurityDocument';
			arrayFieldsForSave=['securityDocumentType','securityDocumentDescription','TI','value','FSV','limitedCovered','Held','Conditions'];
			column_names="Security_Sr_No,WINAME,Security_Document_Type,Security_Document_Desc,TI,Value,FSV,Limit_Covered,Held,Conditions";
			isDeleted=customform.document.getElementById('securitygridflag').value;
		}
		else if(tableArray[table].id=='Special_Covenants_Internal_Grid')
		{
			if (customform.document.getElementById("add_row_Special_Covenants_Internal").disabled == true)//save only when enabled added on 21042019
				continue;
			procName='TWC_InsertInternalConditions';
			arrayFieldsForSave=['specialCovenantsInternal'];
			column_names="Internal_Sr_No,WINAME,Internal_Conditions";
			isDeleted=customform.document.getElementById('internalcondgridflag').value;
			
		}
		else if(tableArray[table].id=='Special_Covenants_External_Grid')
		{
			if (customform.document.getElementById("add_row_Special_Covenants_External").disabled == true)//save only when enabled added on 21042019
				continue;
			procName='TWC_InsertExternalConditions';
			arrayFieldsForSave=['specialCovenantsExternal'];
			column_names="EXTERNAL_SR_NO,WINAME,External_Conditions";
			isDeleted=customform.document.getElementById('externalcondgridflag').value;
		}
		else if(tableArray[table].id=='Defferal_Details_Grid')
		{
			if (customform.document.getElementById("add_row_Defferal_Details").disabled == true)//save only when enabled added on 21042019
				continue;
			procName='TWC_InsertDeferralDetails';
			arrayFieldsForSave=['document_type','approving_authority','deferral_expiry_date','def_remarks'];
			column_names="SR_NO,WINAME,DOCUMENT_TYPE,APPROVING_AUTH_NAME,DEFERRAL_EXPIRY_DATE,REMARKS";
		}
		//Added on 21/02/2019 to Tranche Details in USR_0_TWC_TRANCHE_DTLS_GRID Table
		//Modified on 03/04/2019
		else if(tableArray[table].id=='Tranche_Details_Grid')
		{
			if (customform.document.getElementById("add_row_Tranche_Details").disabled == true)//save only when enabled added on 21042019
				continue;
			procName='TWC_InsertTrancheDetails';
			arrayFieldsForSave=['tranche_amount','tranche_status','tranche_available_period','tranche_disbursal_date','tranche_remarks'];
			column_names="TRANCHE_SR_NO,WINAME,TRANCHE_AMOUNT,TRANCHE_STATUS,Available_Period,Disbursal_Date,Tranche_Remarks";
		}		
		// Commented by Sajan to save UID data through procedure
		/*else if(tableArray[table].id=='UID_Grid')
		{
			table_name='USR_0_TWC_UID_DTLS_GRID';
			arrayFieldsForSave=['UID','Remarks'];
			column_names="UID_SR_NO,WINAME,UID,REMARKS";
		}*/
		else
		{
			alert('Error table name not found');
			return false;
		}
		rowCount = tableArray[table].rows.length;
		/*if(rowCount>1)
		{*/
			ajaxResult="";
			for (var i = 1; i < rowCount; i++) 
			{
				var gridRow = "";
				var colCount = tableArray[table].rows[i].cells.length;
				var currentrow = tableArray[table].rows[i];
				if(tableArray[table].id=='Security_Document_Details_Grid')
				{
					if(customform.document.getElementById('securityDocumentType'+i).value=='')
					{
						continue;
					}
				}
				else if(tableArray[table].id=='General_Condition_Grid')
				{
					if(customform.document.getElementById('generalCondition'+i).value=='')
					{
						continue;
					}
				}
				else if(tableArray[table].id=='Special_Covenants_Internal_Grid')
				{
					if(customform.document.getElementById('specialCovenantsInternal'+i).value=='')
					{
						continue;
					}
				}
				else if(tableArray[table].id=='Defferal_Details_Grid')
				{
					if(customform.document.getElementById('document_type'+i).value=='')
					{
						continue;
					}
				}
				else if(tableArray[table].id=='Tranche_Details_Grid')
				{
					if(customform.document.getElementById('tranche_amount'+i).value=='')
					{
						continue;
					}
				}
				for (var j = 0; j < arrayFieldsForSave.length; j++) 
				{
					if (gridRow != "") 
					{
						
						var value=customform.document.getElementById(arrayFieldsForSave[j]+i).value;
						//alert("value of the data being saved in grid--"+value);
						
						value=value.split("&").join("AMPNDCHAR");
						value=value.split(",").join("CCCOMMAAA");
						value=value.split("%").join("PPPERCCCENTT");
						value=value.split("+").join("PLUSCHAR");
						value=value.split("'").join("ENSQOUTES");
						value=value.split(/(\r)/).join('<br>');
						if(arrayFieldsForSave[j]=='Product_Level_Conditions')
						{
							value=value.split("\t").join('NEWTAB');
						}	
						value=value.split('~').join('');
						value=value.split('|').join('');
						gridRow =  gridRow + "~" + value;
					} 
					else 
					{
						var value=customform.document.getElementById(arrayFieldsForSave[j]+i).value;
						value=value.split("&").join("AMPNDCHAR");
						value=value.split(",").join("CCCOMMAAA");
						value=value.split("%").join("PPPERCCCENTT");
						value=value.split("+").join("PLUSCHAR");
						value=value.split("'").join("ENSQOUTES");
						value=value.split(/(\r)/).join('<br>');
						value=value.split('~').join('');
						value=value.split('|').join('');
						gridRow = i+"~"+ value;
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
				//alert("gridRowAll::"+gridRowAll)
				if ((gridRowAll != '' && gridRowAll != null) || isDeleted=='true' )	{ // Added by Sowmya on 28July2022 to avoid auto delete issue in Grids
					
				try 
				{
					var url = "/TWC/CustomForms/TWC_Specific/InsertGridData.jsp";
					var param="&gridRow=" + gridRowAll+"&wi_name="+wi_name+"&ProcName="+procName+"&WSNAME="+WSNAME;
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
							alert("Problem in saving"+ procName+"  data");
							return false;
						}
					}
				} 
				catch (e) 
				{
					alert("Exception while "+ procName+"saving Grid Data:" + e);
					return false;
				}
			}
	
	}
	
	//Added on 27/02/2019
	//calling saveSelectedProductIdentifier() to save in RB_TWC_EXTTABLE
	saveSelectedProductIdentifier();
	
	saveSelectedTypeOfLA();
	saveSelectedRequestType();
    
	return true;
}
//Save TWC Decision Data
function TWCSaveData(IsDoneClicked) 
{	
	var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
    var WINAME = customform.document.getElementById("wdesk:WI_NAME").value;
	var rejectReasons = customform.document.getElementById('rejReasonCodes').value;
    var Decision = '';
	Decision = customform.document.getElementById("selectDecision").value;
	//alert("Decision:--"+Decision);
    var Remarks = customform.document.getElementById('wdesk:Remarks').value;
	//Remarks=Remarks.replace("&","AMPNDCHAR");
	//Remarks=Remarks.replace(",","CCCOMMAAA");
		Remarks=Remarks.split("&").join("AMPNDCHAR");
		Remarks=Remarks.split(",").join("CCCOMMAAA");
		Remarks=Remarks.split("%").join("PPPERCCCENTT");
		Remarks=Remarks.split("+").join("PLUSCHAR");
		Remarks=Remarks.split("'").join("ENSQOUTES");
		Remarks=Remarks.split(/(\r)/).join('<br>');
		Remarks=Remarks.split('~').join('');
		Remarks=Remarks.split('|').join('');
	
	//for inserting decision in decision history
    var xhr;
    if (window.XMLHttpRequest)
        xhr = new XMLHttpRequest();
    else if (window.ActiveXObject)
        xhr = new ActiveXObject("Microsoft.XMLHTTP");
    var abc = Math.random;

    var url = "/TWC/CustomForms/TWC_Specific/SaveHistory.jsp";
    var param = "&WINAME=" + WINAME + "&WSNAME=" + WSNAME + "&Decision=" + Decision + "&Remarks=" + Remarks + "&rejectReasons=" + rejectReasons + "&IsDoneClicked=" + IsDoneClicked + "&IsSaved=Y&abc=" + abc;

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
		
		//Added on 01/03/2019
		//Modified on 04/03/2019
		//Start
		var currDate =  new Date();
		
		var formatedMidNightDateTime =((currDate.getMonth()+1)+ "/"+ currDate.getDate()+ "/" + currDate.getFullYear() +" " +"23:59:59");
		var MidNight_DateTime = new Date(formatedMidNightDateTime);
		
		var formated7PMDateTime =((currDate.getMonth()+1)+ "/"+ currDate.getDate()+ "/" + currDate.getFullYear() +" " +"19:00:00");
		var Time7PM_DateTime = new Date(formated7PMDateTime);
		
		var utcCurrDateTime = Date.UTC(currDate.getFullYear(), currDate.getMonth(), currDate.getDate(), currDate.getTime());
		var utc7PMDateTime = Date.UTC(Time7PM_DateTime.getFullYear(), Time7PM_DateTime.getMonth(), Time7PM_DateTime.getDate(), Time7PM_DateTime.getTime());
		var utcMidnightDateTime=Date.UTC(MidNight_DateTime.getFullYear(), MidNight_DateTime.getMonth(), MidNight_DateTime.getDate(), MidNight_DateTime.getTime());
		
		var per_min=(1000*60*60*24);
			
		if (WSNAME == "Business_Approver_1st" && Decision =="Forward for Manager Review" ) 
		{
			//alert("currDate:: "+currDate.getTime());
			//After 7pm
			if((utcCurrDateTime/per_min) > (utc7PMDateTime/per_min))
			{
				customform.document.getElementById("wdesk:Auto_Expiry_Business_Time").value  =  Math.floor(((MidNight_DateTime.getTime() - currDate.getTime())/1000)/60) + 660;
				//difference in Tomorrow 8:00 AM and Current Date + 3hrs
			}
			//Before 7pm	
			else
			{
				customform.document.getElementById("wdesk:Auto_Expiry_Business_Time").value = 180;
			}
		}   
		//Modified on 05/03/2019
		if ((WSNAME == "Credit_Analyst" && Decision == "Forward for Second Level Credit Approver") || (WSNAME == "Credit_Approver_1st" && Decision == "Forward for Manager Review" ) )
		{
			//After 7pm
			if ((utcCurrDateTime/per_min) > (utc7PMDateTime/per_min))
			{
				customform.document.getElementById("wdesk:Auto_Expiry_Credit_Time").value  =  Math.floor(((MidNight_DateTime.getTime() - currDate.getTime())/1000)/60) + 600;
				//difference in Tomorrow 8:00 AM and Current Date + 2hrs
			}
			//Before 7pm	
			else
			{
				customform.document.getElementById("wdesk:Auto_Expiry_Credit_Time").value = 120;
				
			}
		}
		//End
		
    } else {
        alert("Problem in saving data");
        return false;
    }
    return true;
}
//Check Duplicate Workitems 
function checkDuplicateWorkitems()
{
	var ProcessInstanceId = customform.document.getElementById("wdesk:WI_NAME").value;
	var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
	//Commented on 21/02/2019 as Sales_Attach_Doc is removed
	//var Dec_SalesAttachDoc=customform.document.getElementById("wdesk:Dec_Sales_Attach_Doc").value;
	var Dec_CreditAnalyst=customform.document.getElementById("wdesk:Dec_Credit_Analyst").value;
	var TLNumber=customform.document.getElementById("wdesk:TL_Number").value;
	
	var xhr;
	if (window.XMLHttpRequest)
		xhr = new XMLHttpRequest();
	else if (window.ActiveXObject)
		xhr = new ActiveXObject("Microsoft.XMLHTTP");

	var url = "/TWC/CustomForms/TWC_Specific/GetDuplicateWorkitems.jsp";
	//Modified on 21/02/2019 as Sales_Attach_Doc is removed
	//var param = "&WI_NAME=" + ProcessInstanceId+"&WSNAME="+WSNAME+"&TLNumber="+TLNumber+"&Dec_SalesAttachDoc="+Dec_SalesAttachDoc+"&Dec_CreditAnalyst="+Dec_CreditAnalyst;
	var param = "&WI_NAME=" + ProcessInstanceId+"&WSNAME="+WSNAME+"&TLNumber="+TLNumber+"&Dec_CreditAnalyst="+Dec_CreditAnalyst;
	xhr.open("POST", url, false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
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
			return true;
		
		customform.document.getElementById("Duplicate_Workitems").innerHTML=ajaxResult; 
		var txt;
		
		var r = confirm("Duplicate workitems found! Do you want to process the case?");
		if (r == true) 
		{
			if(callInsertDuplicateWorkitems()==false)
				return false;
			else
			{
				//Commented on 21/02/2019 as Sales_Attach_Doc is removed
				//if(WSNAME=='Sales_Attach_Doc')
					//customform.document.getElementById("wdesk:Dec_Sales_Attach_Doc").value='Y';
				/*if(WSNAME=='Credit_Analyst')
					customform.document.getElementById("wdesk:Dec_Credit_Analyst").value='Y';*/
			}
			return true;
				
		}
		else 
			return false;
	} 
	else 
	{
		alert("Problem in getting duplicate workitems list."+xhr.status);
		return false;
	}	
	
	return true;
}

function callInsertDuplicateWorkitems() 
{

    var wi_name =customform.document.getElementById("wdesk:WI_NAME").value;
	var table_name='USR_0_TWC_DUPLICATEWORKITEMS';
	var column_names='DUPLICATEWI_NAME,IntroductionDateAndTime,intoducedBy,SOLID,WI_NAME';
    try 
	{
        var url = "/TWC/CustomForms/TWC_Specific/DeleteGridDataOnSave.jsp";
		var param="&wi_name="+wi_name+"&table_name="+table_name;
        var req;
        if (window.XMLHttpRequest) 
            req = new XMLHttpRequest();
        else if (window.ActiveXObject) 
		{
            isIE = true;
            req = new ActiveXObject("Microsoft.XMLHTTP");
        }
		var ajaxResult='';
        req.open("POST", url, false);
		req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.send(param);
		if (req.readyState == 4 && req.status == 200) 
		{
			ajaxResult = req.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '')
			if(ajaxResult=='-1')
			{
				alert('Error while deleting '+ table_name+'Grid Data');
				return false;
			}
		}
		else
		{
			alert('Error while deleting'+ table_name+'Grid Data\n Response Status '+req.status);
			return false;
		}
    } 
	catch (e) 
	{
		alert("Exception while deleting duplicate workitem Grid Details: " + e);
		return false;
	}

    var table = customform.document.getElementById("Duplicate_Workitems_Grid");
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
                gridRow = gridRow + "," + "'" + currentrow.cells[j].innerHTML + "'";
			else
                gridRow = "'" + currentrow.cells[j].innerHTML+ "'";
        }
        gridRow += ",'" + wi_name + "'";

        try 
		{
            var url = "/TWC/CustomForms/TWC_Specific/InsertGridDataOnSave.jsp";
			var param="&gridRow="+gridRow+"&table_name="+table_name+"&column_names="+column_names;
            var xhr;
            var ajaxResult='';

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
					alert("Problem in saving"+ table_name+" Grid data");
					return false;
				}
			}

        } 
		catch (e) 
		{
            alert("Exception while adding Duplicate workitem Grid Details: " + e);
			return false;
		}
    }
	return true;
}
//Added on 22/02/2019 to save values of product Identifier
//Modified on 27/02/2019
//Start
function saveSelectedProductIdentifier()
{
	var productIdentifierDropdown = customform.document.getElementById("ProductIdentifierSeleceted");
	var productIdentifierValue= "";
	var opt=[] ,tempStr="";
	var len=productIdentifierDropdown.options.length;
	for(var i=0;i<len; i++)
	{
		opt = productIdentifierDropdown.options[i];
		productIdentifierValue=productIdentifierValue+opt.value+"|";
		
	}
	productIdentifierValue=productIdentifierValue.substring(0,productIdentifierValue.length-1);
	customform.document.getElementById("wdesk:Product_Identifier").value=productIdentifierValue;
	//alert("val:--"+customform.document.getElementById("wdesk:Product_Identifier").value);
}
//end

function saveSelectedTypeOfLA()
{
	var TypeOfLADropdown = customform.document.getElementById("TypeOfLASeleceted");
	var TypeOfLAValue= "";
	var opt=[] ,tempStr="";
	var len=TypeOfLADropdown.options.length;
	for(var i=0;i<len; i++)
	{
		opt = TypeOfLADropdown.options[i];
		TypeOfLAValue=TypeOfLAValue+opt.value+"|";
		
	}
	TypeOfLAValue=TypeOfLAValue.substring(0,TypeOfLAValue.length-1);
	customform.document.getElementById("wdesk:Type_Of_LA").value=TypeOfLAValue;
}

function saveSelectedRequestType()
{
	var RequestTypeDropdown = customform.document.getElementById("RequestTypeSeleceted");
	var RequestTypeValue= "";
	var opt=[] ,tempStr="";
	var len=RequestTypeDropdown.options.length;
	for(var i=0;i<len; i++)
	{
		opt = RequestTypeDropdown.options[i];
		RequestTypeValue=RequestTypeValue+opt.value+"|";
		
	}
	RequestTypeValue=RequestTypeValue.substring(0,RequestTypeValue.length-1);
	customform.document.getElementById("wdesk:Request_Type").value=RequestTypeValue;
}
	

	
	
	
		
		
			
			
			
		
		
	
		
	
				
		
    
