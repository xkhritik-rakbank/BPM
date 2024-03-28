var CONST_ALERT_NUMERIC='Please enter numbers only';
var CONST_ALERT_CHARACTER='Please input characters only';
var CONST_ALERT_ALPHANUMERIC='Please input alphanumeric value only';
var CONST_ALERT_ALPHABETANDSPECIALCHAR='Please enter alphabet and special characters only';
var CONST_ALERT_DATE1='Invalid date format.Date should be in dd/mm/yyyy format';
var CONST_ALERT_DATE2='Date should be future date.';
var CONST_ALERT_DATE3='Date of birth should not be future date';
var CONST_ALERT_DATE4='BVR Date and Visit Date should not be future date';

//Validation for the Fields that should be numeric
function ValidateNumeric(id)
{
    var inputtxt = document.getElementById(id);
    if (inputtxt.value == '')
        return;
    var inputtxt = document.getElementById(id);
    var numbers = /^[0-9\.,]+$/;
	var number = /^[0-9]+$/;	
	var numberPercent= /^[0-9\.%]+$/;
	var inputvalue =inputtxt.value;
	
	if(id=="wdesk:CIF_Id")
	{
		if(inputvalue.match(number))
			return true;
		else
		{
			alert('CIF must be numeric');
			document.getElementById(id).value = "";
			document.getElementById(id).focus();
			return false;
		}
	}
	else if(id.indexOf("Tenor_Value")!=-1)
	{
		if (inputvalue.match(number))
			return true;
		else 
		{
			alert(CONST_ALERT_NUMERIC);
			document.getElementById(id).value = "";
			document.getElementById(id).focus();
			return false;
		}
	}
	else if(id.indexOf("Margin_percent")!=-1)
	{
		if (inputvalue.match(numberPercent))
			return true;
		else {
			alert(CONST_ALERT_NUMERIC);
			document.getElementById(id).value = "";
			document.getElementById(id).focus();
			return false;
		}
	}
	else if(id.indexOf("UID")!=-1)
	{
		if (inputvalue.match(number))
			return true;
		else {
			alert(CONST_ALERT_NUMERIC);
			document.getElementById(id).value = "";
			document.getElementById(id).focus();
			return false;
		}
	}
	else if(id.indexOf("TL_Number")!=-1)
	{
		if (inputvalue.match(number))
			return true;
		else {
			alert(CONST_ALERT_NUMERIC);
			document.getElementById(id).value = "";
			document.getElementById(id).focus();
			return false;
		}
	}
	else
	{
		if (inputvalue.match(numbers))
			return true;
		else {
			alert('Enter Numbers with one dot only');
			document.getElementById(id).value = "";
			document.getElementById(id).focus();
			return false;
		}
	}
}

function ValidateAlphaandSpecialChar(id) {
    var inputtxt = document.getElementById(id);
    if (inputtxt.value == '')
        return;
    var inputtxt = document.getElementById(id);
    if (inputtxt.value.match("^[a-zA-Z%,.(-/):'<&>_ ]*$"))
        return true;
    else {
        alert(CONST_ALERT_ALPHABETANDSPECIALCHAR);
        document.getElementById(id).value = "";
        document.getElementById(id).focus();
        return false;
    }
}	

function ValidateCharacter(id) {
    var inputtxt = document.getElementById(id);
    if (inputtxt.value == '')
        return;
    var inputtxt = document.getElementById(id);
    var characters = /^[a-zA-Z ]*$/;
    if (inputtxt.value.match(characters))
        return true;
    else {
        alert(CONST_ALERT_CHARACTER);
        document.getElementById(id).value = "";
        document.getElementById(id).focus();
        return false;
    }
}

//Validation for the Fields that should be alphanumeric
function ValidateAlphaNumeric(id) {
    var inputtxt = document.getElementById(id);
    if (inputtxt.value == '')
        return;
    var inputtxt = document.getElementById(id);
    //var numbers = "^[a-zA-Z0-9]*$";
    if (inputtxt.value.match("^[a-zA-Z0-9 ]*$"))
        return true;
    else {
        alert(CONST_ALERT_ALPHANUMERIC);
        document.getElementById(id).value = "";
        document.getElementById(id).focus();
        return false;
    }
}
//Validation for fields with  decimal
function ValidateDecimal(id) 
{
	var inputtxt = document.getElementById(id).value;
	var numbers = /^[0-9\.]+$/;
	if (inputtxt == '') 
		return;
	inputtxt=inputtxt.replace(/%/g,'');
	if(inputtxt.match(numbers))
	{
		if (inputtxt.indexOf('.') == -1)
		{
			if(id.indexOf("Margin_percent")!=-1)
			{
				if(inputtxt.length>3)
				{
					alert('Only Two digits allowed before Decimal');
					document.getElementById(id).value="";
					document.getElementById(id).focus();
					return false;
				}
			}
			else
			{
				if(inputtxt.length>14)
				{
					alert('Please enter Correct Decimal value.');
					document.getElementById(id).value="";
					document.getElementById(id).focus();
					return false;
				}
			}
		}
		else
		{
			if(inputtxt.indexOf('.')==0)
				inputtxt = '0'+inputtxt;
			
			if(id.indexOf("Margin_percent")!=-1)
			
				var numbers = /^([0-9]{0,3})\.([0-9]{1,2})$/;
			else 
				var numbers = /^([0-9]{0,14})\.([0-9]{1,2})$/;
		
			if(inputtxt.match(numbers))
			{
				if(document.getElementById(id).value.indexOf('.')==0)
					document.getElementById(id).value = '0'+document.getElementById(id).value;
				return true;	
			}
			else  
			{
				alert('Value upto 2 Decimal Places is allowed.');
				document.getElementById(id).value="";
				document.getElementById(id).focus();
				return false;
			} 
		}
		
	}	
}

function validateDate(value,field)
{
	if(value=='')
	return;
	var pattern = /^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/;
	if (!pattern.test(value)) 
	{
		alert("Invalid date format.");
		document.getElementById(field).value = "";
		return false;
	}
	else 
	{
		var currentTime = new Date();
		var dd = currentTime.getDate();
		var mm = currentTime.getMonth() + 1; //January is 0!            
		var yyyy = currentTime.getFullYear();            
		var arrStartDate = value.split("/");            
		var date2 = new Date(arrStartDate[2], arrStartDate[1] - 1, arrStartDate[0]);
		var timeDiff = date2.getTime() - currentTime.getTime();
		if (field == "wdesk:Review_Date") {
			if(timeDiff <= 0) 
			{
				alert("Review Date should be future date.");
				document.getElementById(field).value = "";
				return false;			
			}
		}
		if (field.indexOf('deferral_expiry_date')!=-1) {
			if(timeDiff <= 0) 
			{
				alert("Deferral Expiry Date should be future date.");
				document.getElementById(field).value = "";
				return false;			
			}
		}
		//##CR Point 27052019## Past date should not accept for disbursal date**********
		if (field.indexOf('tranche_disbursal_date')!=-1) {
			if(timeDiff <= 0 && (dd != arrStartDate[0] || mm !=arrStartDate[1] || yyyy !=  arrStartDate[2]))
			{
				alert("Disbursal Date should not be past date.");
				document.getElementById(field).value = "";
				return false;			
			}
		}
		//******************************************************************************
	}
}
function onBlurForAmount(id) 
{
	var inputtxt = document.getElementById(id).value;
		var numbers = /^[0-9\.]+$/;
		if (inputtxt == '') return;
		inputtxt=inputtxt.split(",").join("");
		if (inputtxt == '') {
			document.getElementById(id).value=inputtxt;
			return;
		}	
		document.getElementById(id).value=inputtxt;
		if(inputtxt.split('.').length>2)
		{
			inputtxt=inputtxt.split('.').join('');
			document.getElementById(id).value=inputtxt;
		}
		if(inputtxt.indexOf('.')==inputtxt.length-1)
		{
			inputtxt=inputtxt.split('.').join('');
			document.getElementById(id).value=inputtxt;
		}
		if(inputtxt.indexOf('.')==0)
		{
			inputtxt='0'+inputtxt;
			document.getElementById(id).value=inputtxt;
		}
		if(inputtxt.match(numbers))
		{
			if (inputtxt.indexOf('.') == -1)
			{
				inputtxt = inputtxt+'.00';
				document.getElementById(id).value = inputtxt;
			}
			var numbers = /^([0-9]{0,18})\.([0-9]{1,2})$/;
			if(inputtxt.match(numbers))
			{
				var CommaSeparated = Number(parseFloat(inputtxt).toFixed(2)).toLocaleString('en', {
				minimumFractionDigits: 2});
				document.getElementById(id).value=CommaSeparated;
				return true;	
			}
			if(!inputtxt.match(numbers))
			{
				var CommaSeparated = Number(parseFloat(inputtxt).toFixed(2)).toLocaleString('en', {
				minimumFractionDigits: 2});
				document.getElementById(id).value=CommaSeparated;
				return true;	
			}
		}
		else{
			document.getElementById(id).value="";
			document.getElementById(id).focus();
			return false;
		}
}
//Validate Margin 
function ValidateMargin(id) 
{
	var inputtxt = document.getElementById(id).value;
	var numbers = /^[0-9\.]+$%/;
	if (inputtxt == '') 
		return;
	
	if(inputtxt.match(numbers))
	{
		if (inputtxt.indexOf('.') == -1)
		{
			inputtxt = inputtxt+'.00';
			document.getElementById(id).value = inputtxt;
		}
		var numbers = /^([0-9]{0,14})\.([0-9]{1,2})$%/;
		if(inputtxt.match(numbers))
			return true;	
		else 
		{
			alert('Only 2 decimal values');
			document.getElementById(id).value="";
			document.getElementById(id).focus();
			return false;
		} 
	}	
}

function validatemandatory(doctypeid,docdescid)
{
	if(document.getElementById(doctypeid).value=='' || document.getElementById(doctypeid).value==null)
	{
		alert("Please enter Security Document Type");
		document.getElementById(docdescid).value="";
		document.getElementById(docdescid).focus();
		return false;
	}
	
}	

function validateCIFID()
{
	var CIF_ID=document.getElementById("wdesk:CIF_Id");
	if(CIF_ID.value !="")
	{
		if(CIF_ID.value.length<7)
		{
			CIF_ID.value='';
			CIF_ID.focus(true);
			alert("CIF ID should be of 7 digits.");
		}
	}
}

function validateLengthForAmount(id,length)
{
	var element=document.getElementById(id).value.split(',').join('');
	if(element.indexOf('.')!=-1)
		element=element.substring(0,element.indexOf('.'));
	if(element.length>parseInt(length))
	{
		alert("Maximum "+length+" Digits are allowed");
		document.getElementById(id).value=element.substring(0,length);
	}
}

function checkRemarks(id,maxLength)
{
	var value=document.getElementById(id).value;
	var newLength=value.length;
	//var maxLength=1000;
	//value=value.replace(/(\r\n|\n|\r)/gm," ");
	value=value.replace(/[^a-zA-Z0-9_.,'&:;!@#$%*()={}\/\-\\"\r\n\t +]/g,"");
	if(newLength>=maxLength){
		value=value.substring(0,maxLength);		
	}
	//value=value.replace(/&/g,' and ');
	value=value.replace(/(\r\n\r\n\r\n\r\n\r\n)/gm," "); // allow maximum 5 continuous new line 
	document.getElementById(id).value=value;
}

function validatecountry(req,countryvalidate)
{
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
		document.getElementById(req).value='';
		return false;
	}
		
}
function ValidateAlphabetAndSpecialChar(id) 
{
    var inputtxt = document.getElementById(id);
    if (inputtxt.value == '')
        return;
    var inputtxt = document.getElementById(id);
    var characters = /^[a-zA-Z,.(-/) ]*$/;
    if (inputtxt.value.match(characters))
        return true;
    else {
        alert('Please Enter only Characters');
        document.getElementById(id).value = "";
        document.getElementById(id).focus();
        return false;
    }
}

function SpecificFieldAndSpecialChar(id) 
{
    var value=document.getElementById(id).value;
	if(id=='wdesk:Reference_Number')
		value=value.replace(/[^a-zA-Z0-9 /-]/g,"");
	else if(id=='wdesk:TL_Number')
		value=value.replace(/[^a-zA-Z0-9/ ]/g,"");
	else if(id.indexOf('limitedCovered')!=-1)
		value=value.replace(/[^a-zA-Z0-9 ,]/g,"");
	else if(id.indexOf('InterestMargin')!=-1)
		value=value.replace(/[^0-9 +\-,.]/g,"");
	else if(id.indexOf('value')!=-1 || id.indexOf('FSV')!=-1)
		value=value.replace(/[^a-zA-Z0-9 ,.]/g,"");
	else if(id=='wdesk:Related_Part_Name')
		value=value.replace(/[^a-zA-Z0-9 \n]/g,"");	
	else if(id=='wdesk:Campaign_ID')
		value=value.replace(/[^a-zA-Z0-9 /-]/g,"");	
		
	value=value.split("  ").join(" ");	
	document.getElementById(id).value=value;
}

function validateFieldLength(id)
{
	var value=document.getElementById(id).value;
	if (value != '')
	{
		if (id == 'wdesk:FeeDebitedAccount')
		{
			var number = /^[0-9]+$/;
			if (value.match(number))
			{
				if(value.length != 13)
				{
					alert('Account Number should be of exact 13 digit');
					document.getElementById(id).focus();
					return false;
				}
			}
			else 
			{
				alert(CONST_ALERT_NUMERIC);
				document.getElementById(id).value = "";
				document.getElementById(id).focus();
				return false;
			}
		}
	}
}