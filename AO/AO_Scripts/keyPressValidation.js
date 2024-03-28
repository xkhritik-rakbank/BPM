function RECommon(act){
	var re;
	
	switch(act) 
	{
		case "alpha":re = /[^a-z ]+/i;break;
		case "numeric":re = /[^0-9]/g;break;
		case "nonzeronumeric":re = /[^0-9]/g;break;
		case "float":re = /[^0-9.]/g;break;
		case "negativeamount":re = /[^0-9.-]/g;break;
		case "alphanumeric2":re=/^[0-9a-z ]*$/i;break;
		case "alphanumeric":re = /[^a-zA-Z0-9.,()@$%/\s-_]/g;break;
		case "alphanumeric3":re = /[^a-zA-Z0-9\s]/g;break;
		case "dashdigitsOnly":re = /[^0-9/-]/g;break;
		case "name":re=/[^a-zA-Z_.,& \']+/g;break;
		case "numeric82":re = /^([0-9]{0,8}\.|[0-9]{0,8}\.[0-9]{1,2}|[0-9]{0,8})$/;break;	
		case "date":re=/^0[1-9]\/[0-9]{2}|1[012]\/[0-9]{2}$/;break;
		case "blank":re=/[^a-zA-Z0-9_.,&: \']+/g;break;
		case "time":re=/[^a-zA-Z0-9_.,&: \']+/g;break;	
		case "datetime":re=/[^a-zA-Z0-9_.,&: \']+/g;break;	
		case "addaccount":re = /[^a-zA-Z0-9\s]/g;break;	

				
   }
   return re;
}

function validateKeys(e,pattern){
var re="";
re=RECommon(pattern.toLowerCase());
if(pattern=='nonzeronumeric')
{
	if(e.value!='')
	{
		switch(e.value) 
		{
		
			case "1": break;
			case "2": break;
			case "3": break;
			case "4": break;
			case "5": break;
			case "6": break;
			case "7": break;
			case "8": break;
			case "9": break;
			case "10": break;
			default: alert("No of accounts should be numeric values between 1 to 10"); e.value=""; e.focus(); return false;
		}	
	}
}
if(re.test(e.value)){
  e.value = e.value.replace(re, "");
  }
 if(pattern=='addaccount' && window.event.keyCode === 13)
 {
	var select=document.getElementById('1_Account_No_2');
	var addedAccounts=select.options.length;
	var requiredAccounts= document.getElementById('1_No_of_Accounts').value;
	if(requiredAccounts==addedAccounts)
	{
		alert('Cannot add more accounts in the list');
		return false;	
	}	
	
	if(e.value.length==13)
	{
		var isAccountNoInList=false;	
		for(var i=0;i<select.options.length;i++){
			if(select.options[i].value==e.value){
				alert("Account No already in list.");
				isAccountNoInList=true;
				break;
			}
		}
		if(isAccountNoInList)		
			return false;
		
		var opt = document.createElement('option');
		opt.value = e.value;
		opt.innerHTML = e.value;
		opt.className="EWNormalGreenGeneral1";
		select.appendChild(opt);
		e.value="";
	}
	else
	{
		alert("Account No should be alphanumeric and 13 characters");
	}	
 }	
return false;

}
