//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation          
//File Name					 : DropDownCity.jsp          
//Author                     : Amitabh,Nikita
// Date written (DD/MM/YYYY) : 07-Nov-2017
//Description                : Fetching drop down and searchable drop down for country,city and state
//---------------------------------------------------------------------------------------------------->
function loadDropDownValues(currWorkstep,loggedInUser)
	{
		if (currWorkstep != 'Exit' && currWorkstep != 'Reject')
			loadDecisionFromMaster(currWorkstep);
			
		//var CountryOfBirth=document.getElementById("COUNTRY_OF_BIRTH").value;
		//loadCountryOfBirth(CountryOfBirth);
		//getSOLIDOfLoggedInUser(currWorkstep,loggedInUser);
		
		//Added as part of Cr 11112020*******************
		var CityFields=['CITY_OF_BIRTH','wdesk:PERMANENT_ADDRCITY','wdesk:MAILING_ADDRCITY','wdesk:PERMANENT_ADDRSTATE','wdesk:MAILING_ADDRSTATE'];
		var CountryFields=['COUNTRY_OF_BIRTH','wdesk:PERMANENT_ADDRCOUNTRY','wdesk:MAILING_ADDRCOUNTRY','NATIONALITY','Country_of_Incorp'];
		var USRelationField=['wdesk:USRELATIONMAIN','wdesk:CONTROLLINGPERSONUSRELATIONSHIP'];
		var FatcaEntityType=['wdesk:FATCA_ENTITY_TYPE'];
		var FinEntity=['wdesk:FINANCIAL_ENTITY'];
		loadCity(CityFields,"OnLoad","");
		loadCity(USRelationField,"OnLoad","");
		loadCity(FatcaEntityType,"OnLoad","");
		loadCity(FinEntity,"OnLoad","");
		loadCountry(CountryFields,"OnLoad","");
		//*****************************************
    }
	
function searchablecountrydropdown(currWorkstep)
	{
		if(currWorkstep=='Introduction')
		{
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			
			url = '/OECD/CustomForms/OECD_Specific/DropDownCountry.jsp';
			xhr.open("GET",url,false);
			xhr.send(null);
			if (xhr.status == 200)
			{	
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult.indexOf("Exception")==0)
				 {
					alert("Unknown Exception while working with request type "+reqType);
					return false;
				 }							 
				document.getElementById("AutocompleteValuesCountry").value=ajaxResult;
			}
			else 
			{
				alert("Error while Loading Drowdown "+reqType+" for the current workstep");
				return false;
			}
		}
    }

	function searchablecountdropdown(currWorkstep)
	{
		if(currWorkstep=='Introduction')
		{
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			
			url = '/OECD/CustomForms/OECD_Specific/DropDownCountry.jsp';
			xhr.open("GET",url,false);
			xhr.send(null);
			if (xhr.status == 200)
			{	
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult.indexOf("Exception")==0)
				 {
					alert("Unknown Exception while working with request type "+reqType);
					return false;
				 }							 
				document.getElementById("AutocompleteValuesCount").value=ajaxResult;
			}
			else 
			{
				alert("Error while Loading Drowdown "+reqType+" for the current workstep");
				return false;
			}
		}
    }
function searchablecitydropdown(currWorkstep)
	{
		if(currWorkstep=='Introduction')
		{
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			
			url = '/OECD/CustomForms/OECD_Specific/DropDownCity.jsp';
			xhr.open("GET",url,false);
			xhr.send(null);
			if (xhr.status == 200)
			{	
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult.indexOf("Exception")==0)
				 {
					alert("Unknown Exception while working with request type "+reqType);
					return false;
				 }							 
				document.getElementById("AutocompleteValuesCity").value=ajaxResult;
			
			}
			else 
			{
				alert("Error while Loading Drowdown "+reqType+" for the current workstep");
				return false;
			}
		}
    }	
	
function setAutocompleteData() 
{
	//alert("setAutocompleteData");
		var data = "";
		var ele = document.getElementById("AutocompleteValuesCountry");
		if (ele)
			
			//data = "country_search="+ele.value;
			data = ele.value;
		if (data != null && data != "") {
			//data = data.replace('{', '').replace('}', '');
			var temp = data.split("=");
			var values = temp[0].split("~");

			//added for country field smart search by siva 
			$(document).ready(function() {
				$("#COUNTRY_OF_BIRTH").autocomplete({source: values}); 
				$("#NATIONALITY").autocomplete({source: values}); 
			});				
		}
		
		
		data = "";
		ele = document.getElementById("AutocompleteValuesCity");
		if (ele)
		
			data = ele.value;
		if (data != null && data != "") {
			var temp = data.split("=");
			var values = temp[0].split("~");
			//added for city field smart search by siva 
			$(document).ready(function() {
				$("#CITY_OF_BIRTH").autocomplete({source: values});
				
			});				
		}
	

		data = "";
		ele = document.getElementById("AutocompleteValuesCount");
		if (ele)
		
			data = ele.value;
		if (data != null && data != "") {
			var temp = data.split("=");
			var values = temp[0].split("~");
			//added for city field smart search by siva 
			$(document).ready(function() {
				$("#CRS_UNDOCUMENTED_FLAG").autocomplete({source: values});
				
			});				
		}
	
}

function validatecountry(req,countryvalidate)
	{
		//alert("inside validate");
		//countryvalidate = countryvalidate.replaceAll1(", ", ",");
		countryvalidate=countryvalidate.split("~");
		var match ='';
		document.getElementById(req).value = myTrim(document.getElementById(req).value);
		for(var i=0;i<=countryvalidate.length;i++)
		{
				if(document.getElementById(req).value==countryvalidate[i])
				match='matched';
		}
		if(match !='matched')
		{
			document.getElementById(req).value="";
			return false;
		}
			
	}
function myTrim(x) 
	{
		return x.replace(/^\s+|\s+$/gm,'');
	}
function setComboValueToTextBox(dropdown, inputTextBoxId) 
	{
		//alert("document.getElementById(wdesk:CURRENT_WS).value"+document.getElementById("wdesk:CURRENT_WS").value);
			if(document.getElementById("wdesk:CURRENT_WS").value=='Introduction' || dropdown.id=='selectDecision' || dropdown.id=='custsegment' || dropdown.id=='CrsUndocReason')
			{
				document.getElementById(inputTextBoxId).value = dropdown.value;
				
			}
	}

function loadDecisionFromMaster(currWorkstep)
{
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
		
			url = '/OECD/CustomForms/OECD_Specific/DropDownLoad.jsp?reqType=selectDecision&WSNAME='+currWorkstep;
			xhr.open("GET",url,false);
			xhr.send(null);
			if (xhr.status == 200)
			{
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult=='-1')
				 {
					alert("Error while loading dropdown values for decision");
					return false;
				 }				 
				 values = ajaxResult.split("~");
				 for(var j=0;j<values.length;j++)
				 {
					var opt = document.createElement("option");
					opt.text = values[j];
					opt.value =values[j];
					document.getElementById('selectDecision').options.add(opt);
				 }				 
			}
			else 
			{
				//alert("Error while Loading Drowdown decision.");
				return false;
			}
}
	
function loadCountry(dropwDownId,Event,RowId)
{
	var reqType = "";	
	var Code = "";
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
		xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	for(var i=0;i<dropwDownId.length;i++)
	{		
		var FieldName=dropwDownId[i].toLowerCase();
		if(FieldName.indexOf("country") != -1)
			reqType="CountryCode";
		
		//var Code = document.getElementById(dropwDownId[i]).value.replace(/&amp;/g, '&');
		if(Event == "OnLoad")
			Code=document.getElementById(dropwDownId[i]).value;
		else if(Event == "RadioBtnClick")
			Code=document.getElementById(dropwDownId[i]+RowId).innerHTML.replace(/&amp;/g, '&');
		else if(Event == "OECDGrid")
		{
			Code=document.getElementById(dropwDownId[i]+RowId).value;
			dropwDownId[i]=dropwDownId[i]+RowId;
		}
		//Code=Code.replace(/\s/g, ''); //regex for removing spaces
		if(Code!="")
		{	
			url = '/OECD/CustomForms/OECD_Specific/DropDownLoad.jsp?reqType=CountryCode&WSNAME='+Code;
			xhr.open("GET",url,false);
			xhr.send(null);
			if (xhr.status == 200)
			{
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 //alert("ajaxResult--"+ajaxResult);
				 if(ajaxResult=='-1')
				 {
					alert("Error while loading values for CountryOfBirth");
					return false;
				 }	
				 else if(ajaxResult!='')
					document.getElementById(dropwDownId[i]).value=ajaxResult;
				 
				else 	
					document.getElementById(dropwDownId[i]).value=Code;					 			 
			}
			else 
			{
				alert("Exception while Loading Country Of Birth.");
				return false;
			}
		}
		else
			document.getElementById(dropwDownId[i]).value="";
	}
}	
/*function getSOLIDOfLoggedInUser(currWorkstep,loggedInUser)
{	
	if(currWorkstep=='Attach_Cust_Doc')
	{
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			
			url = '/OECD/CustomForms/OECD_Specific/getSOLIDOfUser.jsp?userName='+loggedInUser;
			xhr.open("GET",url,false);
			xhr.send(null);
			if (xhr.status == 200)
			{	
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult=='-1')
				 {
					alert("Error while loading comment for users.");
					return false;
				 }
				 else	
				 {
					document.getElementById("wdesk:SOLID").value=ajaxResult;	
					document.getElementById("loggedInUserComment").innerHTML='&nbsp;'+ajaxResult;
				 }
			}
			else 
			{
				alert("Exception while Loading comment for users");
				return false;
			}
	}
	else
	{
			document.getElementById("loggedInUserComment").innerHTML='&nbsp;'+document.getElementById("wdesk:SOLID").value;
	}
}*/

function loadCity(dropwDownId,Event,RowId)
{
	//	alert("inside loadCity")
	var url = '';
	var xhr;
	var ajaxResult;		
	var reqType = "";	
	var Code = "";	
	if(window.XMLHttpRequest)
		xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		xhr=new ActiveXObject("Microsoft.XMLHTTP");
	//alert("xhr"+xhr)
	for(var i=0;i<dropwDownId.length;i++)
	{	
		var FieldName=dropwDownId[i].toLowerCase();
		if(FieldName.indexOf("state") != -1)
			reqType="StateCode";
		else if(FieldName.indexOf("city") != -1)
			reqType="CityCode";
		else if(FieldName.indexOf("country") != -1)
			reqType="CountryCode";
		else if(dropwDownId[i].indexOf("USRELATIONMAIN") != -1 || dropwDownId[i].indexOf("residenceuscitizenship") != -1)
			reqType="USRelationDesc";
		else if(dropwDownId[i].indexOf("CONTROLLINGPERSONUSRELATIONSHIP") != -1)
			reqType="ControllingPersonUSRelationDesc";	
		else if(dropwDownId[i].indexOf("FATCA_ENTITY_TYPE") != -1)
			reqType="FatcaEntityTypeDesc";
		else if(dropwDownId[i].indexOf("FINANCIAL_ENTITY") != -1)
			reqType="FinancialEntityDesc";
		
		//var Code = document.getElementById(dropwDownId[i]).value.replace(/&amp;/g, '&');
		if(Event == "OnLoad")
			Code=document.getElementById(dropwDownId[i]).value;
		else if(Event == "RadioBtnClick")
			Code=document.getElementById(dropwDownId[i]+RowId).innerHTML.replace(/&amp;/g, '&');
		
		if(Code != '')
		{
			url = "/OECD/CustomForms/OECD_Specific/DropDownLoad.jsp?reqType="+reqType+"&WSNAME="+Code;
			xhr.open("GET",url,false);
			xhr.send(null);
			
			if (xhr.status == 200)
			{
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult=='-1')
				 {
					alert("Error while loading dropdown values for "+dropwDownId[i]);
					return false;
				 }
				
				else if(ajaxResult!='')
					document.getElementById(dropwDownId[i]).value=ajaxResult;
				else 
					 document.getElementById(dropwDownId[i]).value=Code;									 
			}
			else 
			{
				alert("Error while Loading Drowdown "+dropwDownId[i]+" for the current workstep");
				return false;
			}
		}
		else 
			document.getElementById(dropwDownId[i]).value="";
	} 
}