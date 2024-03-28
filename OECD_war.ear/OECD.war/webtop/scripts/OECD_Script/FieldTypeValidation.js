var CONST_ALERT_NUMERIC='Please enter numbers only';
var CONST_ALERT_CHARACTER='Please input characters only';
var CONST_ALERT_ALPHANUMERIC='Please input alphanumeric only';
var CONST_ALERT_TELPHONE='Please enter telephone number starting from +';
var CONST_ALERT_ALPHANUMERIC1='Please enter alphanumeric and .,- characters only';
var CONST_ALERT_ALPHANUMERIC2='Please input alphanumeric and .&#- characters only';
var CONST_ALERT_PERCENTAGE='percentage is out of range';
var CONST_ALERT_DATE1='Invalid date format.Format should be DD/MM/YYYY';
var CONST_ALERT_DATE2='Date should be future date.';
var CONST_ALERT_DATE3='Date should not be future date.';
var CONST_ALERT_DOB='Difference between the Date of Birth and Current Date should not be less than 16 years';


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

function onBlurForISD(id) {
	var inputtxt = document.getElementById(id);
    if (inputtxt.value == '') 
		return;
		var inputtxt = document.getElementById(id);
		var numbers = /^[0-9+]*$/;
		if((inputtxt.value.match(numbers) && inputtxt.value.substring(0, 1) == '+'))
			return true;
        else  {
            alert(CONST_ALERT_TELPHONE);
            document.getElementById(id).value = "";
			document.getElementById(id).focus();
            return false;
        } 
}

function ValidateAlphaNumericSpecialChars(id) {
	
    
    var inputtxt = document.getElementById(id);

    if (inputtxt.value == '')
        return;
    var inputtxt = document.getElementById(id);
	
    var numbers1 = /^[a-zA-Z0-9.\,\-\ ]+$/;
	var numbers2 = /^[a-zA-Z0-9.\,\-\#\&\ ]+$/;
	
	if(id=="res_flatvilla" || id=="home_flatvilla" ||id=="res_building" ||id=="home_building" || id=="res_street" ||id=="home_street" ||id=="res_landmark" ||id=="home_landmark" || id=="res_zipcode" || id=="home_zipcode" || id=="res_pobox" ||id=="home_pobox")
	{
		
		//field accepting alphanumeric and special characters(.,-)
	if (numbers1.test(inputtxt.value))
	return true;
    else {
        alert(CONST_ALERT_ALPHANUMERIC1);
        document.getElementById(id).value = "";
        document.getElementById(id).focus();
        return false;
    }
	}
	else if(id=="custcompname" || id=="previousorginuae")
	{
		//field accepting alphanumeric and special characters(.&#,-)
	if (numbers2.test(inputtxt.value))
        return true;
    else {
        alert(CONST_ALERT_ALPHANUMERIC2);
        document.getElementById(id).value = "";
        document.getElementById(id).focus();
        return false;
    }
	}
	
	
}

function numberWithCommas(obj) 
{
    var val = document.getElementById(obj).value;
    //alert("val"+val);
    if((val - 0) == val && val.length > 0)
    {
        var result = parseFloat(val);
        val = result.toFixed(2);
		document.getElementById(obj).value = val;
		//alert("result" + val);
        return true;
    }
    if(val.length == 0)
    {
        //alert("atbest");
        val = '0.00';
        //return true;
    }
    //obj.value= val;
    //alert("val:::->"+val);
		//obj.value = val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, "");
    //alert("hi" +obj.value);
		//return true;
}



function ValidatePercentValue(str)
{
	//alert("ValidateValue percent");
	
  var x = parseFloat(document.getElementById(str).value).toFixed(); 
  if (isNaN(x) || x < 0 || x > 100) 
  { 
     alert(CONST_ALERT_PERCENTAGE);
	 document.getElementById(str).value = "";
     document.getElementById(str).focus();
	 return false;
  }

}

function validateAppDate(value,field)
	{
		
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
			
			//Validation for DOB field			
			if (field == "DOB"){
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
	
	function onBlurForAmount(obj) 
	{
		var val = document.getElementById(obj).value;
			if((val - 0) == val && val.length > 0)
			{
				var result = parseFloat(val);
				val = result.toFixed(2);
				//alert("result" + val);
				//return true;
			}
			if(val.length == 0)
			{
				val = '0.00';
				//return true;
			}
		//obj.value= val;
		//alert("val:::->"+val);
		document.getElementById(obj).value = val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		return true;
	}

		function ValidateEmailId(id) {

		var email = document.getElementById(id);    
		if (email.value == '') return;
		var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;

		if (!filter.test(email.value)) {
			alert('Please provide a valid email address');
			document.getElementById(id).value="";
			document.getElementById(id).focus();
			return false;
		}
	}
	
	function expiryDateset()
	{
		var signed_date = document.getElementById("signeddate").value; 
		
		
		var expdatemth = signed_date.substring(0,6);
		var expyear = signed_date.substring(6,10);
		expyear = parseInt(expyear,10)+3;
		if((expdatemth+expyear).indexOf("NaN")== -1 && (signed_date!="" && signed_date!=null)) //changed to handle junk
		document.getElementById("expirydate").value = expdatemth+expyear;
		else
		document.getElementById("expirydate").value = "";
		
		
	}
	
		function initialize(eleId) {
			var cal1 = new calendarfn(document.getElementById(eleId));
			cal1.year_scroll = true;
			cal1.time_comp = false;
			cal1.popup();
			return true;
		}
		