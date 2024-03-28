var CONST_ALERT_NUMERIC='Please enter numbers only';
var CONST_ALERT_CHARACTER='Please input characters only';
var CONST_ALERT_ALPHANUMERIC='Please input alphanumeric only';
var CONST_ALERT_DATE1='Invalid date format.Date should be in dd/mm/yyyy format';
var CONST_ALERT_DATE2='Date should be future date.';
var CONST_ALERT_DATE3='Date of birth should not be future date';

function ValidateNumeric(id) {
    var inputtxt = document.getElementById(id);
    if (inputtxt.value == '')
        return;
    var inputtxt = document.getElementById(id);
    var numbers = /^[0-9]+$/;
    if (inputtxt.value.match(numbers))
        return true;
    else {
        alert(CONST_ALERT_NUMERIC);
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


function validateDate(value,field)
	{
		//alert("inside date");
		if(value=='')
		return;
		var pattern = /^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/;
		if (!pattern.test(value)) 
		{
			alert(CONST_ALERT_DATE1);		
			document.getElementById(field).value = "";	
			document.getElementById(field).focus();
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
            var timeDiffPassport = date2.getTime() - currentTime.getTime();
			
			if (field == "wdesk:PASSPORTEXPIRYDATE" || field == "wdesk:EIDEXPIRYDATE") {
				if(timeDiffPassport < 0)
				{
					alert(CONST_ALERT_DATE2);
					document.getElementById(field).value = "";
					document.getElementById(field).focus();
					return false;			
				}
			}
			else if(field == "wdesk:DOB"){
				if(timeDiffPassport > 0)
				{
					alert(CONST_ALERT_DATE3);
					document.getElementById(field).value = "";
					document.getElementById(field).focus();
					return false;			
				}
			}
		}
	}	
	
	
function ValidateAlphabetAndSpecialChar(id) {
    var inputtxt = document.getElementById(id);
    if (inputtxt.value == '')
        return;
    var inputtxt = document.getElementById(id);
    var characters = /^[a-zA-Z,.(-/) ]*$/;
    if (inputtxt.value.match(characters))
        return true;
    else {
        alert(CONST_ALERT_CHARACTER);
        document.getElementById(id).value = "";
        document.getElementById(id).focus();
        return false;
    }
}	

function validateKeys(e,pattern)
{
	var re="";
	re=RECommon(pattern.toLowerCase());
	if(pattern=='uptotwodecimal')
	{
		//alert("pattern "+pattern);
		
			//var Number= e.value;
			
			//alert(Number);
			
			//var CommaSeparated = Number(parseFloat(e.value).toFixed(2)).toLocaleString('en', {
			//minimumFractionDigits: 2});
			//e.value=CommaSeparated;
			//alert("CommaSeparated "+CommaSeparated);
		
		//alert("here" +re);
		 if(!re.test(e.value) && e.value!=''){
			e.value = "";
			alert("Please enter the value upto two decimal places only.");
			e.focus();
	  }
		if(document.getElementById("SubCategoryID").value==2)
		clickFunction('onchange','BT Amount Requested');
		else if(document.getElementById("SubCategoryID").value==4)
		clickFunction('onchange','CCC Amt Requested');
	}
	else if(re.test(e.value)){
	  e.value = e.value.replace(re, "");
	}

	if(pattern=='cccnameoncard')
	{
	  document.getElementById("4_eligibility").value='';
	}
	  
	return false;

}

function initialize(eleId) {
	var cal1 = new calendarfn(document.getElementById(eleId));
	cal1.year_scroll = true;
	cal1.time_comp = false;
	cal1.popup();
	return true;
}
//Validation for Only number should be allowed. The number should not start from 0
function ValidateNumericStart(id,labelName)
{
	var inputtxt=document.getElementById(id);
	if(inputtxt.value=='')
	return;
	var inputtxt=document.getElementById(id);
	var numbers = /^(?:[1-9]\d*|0)$/;
	if(inputtxt.value=='0'){
	alert('only numbers not starting with 0 '+labelName+".");
		document.getElementById(id).value="";
		
	}
	
}
//Validation for Number with 2 decimal places
function onBlurForDecimal(id)
{
	var value = id.value;
	if (value != ''){
	id.value=parseFloat(value).toFixed(2);
	}
}
//Validation for Number with dot 2 decimal places
function ValidateNumericWithDot(id,labelName) {
     var inputtxt = document.getElementById(id);
    if (inputtxt.value == '')
        return;
    var inputtxt = document.getElementById(id);
    //var numbers = /^[0-9]+$/;
    var numbers = /^\d+\.{0,1}\d{0,2}$/;
    if (inputtxt.value.match(numbers))
        return true;
    else {
        alert('Please input two numeric values after decimal for '+labelName+".");
        document.getElementById(id).value = "";
        document.getElementById(id).focus();
        return false;
    }
}
		