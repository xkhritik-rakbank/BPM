var CONST_ALERT_NUMERIC='Please enter numbers only';
var CONST_ALERT_ALPHANUMERIC='Please input alphanumeric only';

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

function validateUIDNumber(id)
{
	var value=document.getElementById(id).value;
	var newLength=value.length;
	var maxLength=20;
	value=value.replace(/(\r\n|\n|\r)/gm," ");
	value=value.replace(/[^a-zA-Z0-9]/g,"");
	if(newLength>=maxLength){
		value=value.substring(0,maxLength);		
	}
	document.getElementById(id).value=value;
}
		