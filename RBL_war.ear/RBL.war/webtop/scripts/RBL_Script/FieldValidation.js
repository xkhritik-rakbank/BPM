var CONST_ALERT_NUMERIC='Please enter numbers only';
var CONST_ALERT_CHARACTER='Please input characters only';
var CONST_ALERT_ALPHANUMERIC='Please input alphanumeric only';
var CONST_ALERT_DATE1='Invalid date format.Date should be in dd/mm/yyyy format';
var CONST_ALERT_DATE2='Date should be future date.';
var CONST_ALERT_DATE3='Date of birth should not be future date';
var CONST_ALERT_DATE4='BVR Date and Visit Date should not be future date';

function ValidateNumeric(id) {
    var inputtxt = document.getElementById(id);
    if (inputtxt.value == '')
        return;
    var inputtxt = document.getElementById(id);
    var numbers = /^[0-9\.]+$/;
	var number = /^[0-9]+$/;	
	
	if(id=='wdesk:Approved_Tenor')
	{
		if(inputtxt.value.match(number))
		{
			return true;
		}
		else
		{
			alert('Approved Tenor must be a numeric');
			document.getElementById(id).value = "";
			document.getElementById(id).focus();
			return false;
		}
	
	}
	else if(id=="wdesk:CIF_Id")
	{
		if(inputtxt.value.match(number))
		{
			return true;
		}
		else
		{
			alert('CIF must be numeric');
			document.getElementById(id).value = "";
			document.getElementById(id).focus();
			return false;
		}
	}
	else if(id=="wdesk:Requested_Tenor")
	{
		if(inputtxt.value.match(number))
		{
			return true;
		}
		else
		{
			alert('Requested Tenor must be a numeric');
			document.getElementById(id).value = "";
			document.getElementById(id).focus();
			return false;
		}
	}
	else
	{
		inputtxt = inputtxt.value.split(",").join("");
		if (inputtxt.match(numbers))
			return true;
		else {
			alert(CONST_ALERT_NUMERIC);
			document.getElementById(id).value = "";
			document.getElementById(id).focus();
			return false;
		}
	}
}


	function onBlurForAmount(id) 
	{
		var inputtxt = document.getElementById(id).value;
		var numbers = /^[0-9\.]+$/;
		if (inputtxt == '') return;
		inputtxt=inputtxt.split(",").join("");
		if (inputtxt == '') return;
		
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
			else  {
				if(id=="wdesk:Approved_Amount")
					alert('Amount(Approved) should have only 2 decimal values');
				else if(id=="wdesk:Outstanding_Amount")
					alert('Ouststanding Amount Proposal should have only 2 decimal values');
				else if(id=="wdesk:Outstanding_Amount_Approval")
					alert('Ouststanding Amount Approval should have only 2 decimal values');
				else if(id=="wdesk:Incremented_Amt_Req")
					alert('Increamental Amount Requested should have only 2 decimal values');
				else if(id=="wdesk:Incremented_Amt_App")
					alert('Increamental Amount Approved should have only 2 decimal values');
				else if(id=="wdesk:Requested_Amount")
					alert('Requested Amount should have only 2 decimal values');
				else if(id=="wdesk:Processing_fee")
					alert('Processing Fee(Base) should have only 2 decimal values');
				else if(id=="wdesk:Processing_Fee_Final")
					alert('Processing Fee(Final) should have only 2 decimal values');
				else if(id=="wdesk:Interest_rate")
					alert('Interest Rate(Base) should have only 2 decimal values');
				else if(id=="wdesk:Interest_Rate_Final")
					alert('Interest Rate(Final) should have only 2 decimal values');
				
				document.getElementById(id).value="";
				document.getElementById(id).focus();
				return false;
			} 
		}	
	}

function checkDecision(){
	
var d=document.getElementById("wdesk:Maker_Done_On").value;
var selectedDecision= $('#selectDecision :selected').text();
if(selectedDecision == "Reperform Checks"){
if(d==""){
	$("#selectDecision").val("--Select--");
	alert("You are not allowed to select this");
}
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
			
			if (field == "wdesk:Deferral_ExpDate") {
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
			else if(field == "wdesk:Visit_Date" || field=="wdesk:BVR_Date"){
				if(timeDiffPassport > 0)
				{
					alert(CONST_ALERT_DATE4);
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


function initialize(eleId) {
	var cal1 = new calendarfn(document.getElementById(eleId));
	cal1.year_scroll = true;
	cal1.time_comp = false;
	cal1.popup();
	return true;
}
		
function checkRemarksUID(id)
{
	var value=document.getElementById(id).value;
	var newLength=value.length;
	var maxLength=2000;
	value=value.replace(/(\r\n|\n|\r)/gm," ");
	value=value.replace(/[^a-zA-Z0-9_.,&: ]/g,"");
	if(newLength>=maxLength){
		value=value.substring(0,maxLength);		
	}
	value=value.replace(/&/g,' and ');
	document.getElementById(id).value=value;
}		