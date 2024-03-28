function RECommon(act){
	var re;
	//alert("act"+act);
	switch(act) 
	{
		case "alpha":re = /[^a-z ]+/i;break;
		case "numeric":re = /[^0-9]/g;break;
		case "float":re = /[^0-9.]/g;break;
		case "negativeamount":re = /[^0-9.-]/g;break;
//		case "alphanumeric":re = /[^a-z0-9]+/i;break;
		case "alphanumeric2":re=/^[0-9a-z ]*$/i;break;
		case "alphanumeric":re = /[^a-zA-Z0-9.,()@$%/\s-_]/g;break;
//		case "digitsOnly":re = /[^0-9]/g;break;
		case "dashdigitsOnly":re = /[^0-9/-]/g;break;
		case "name":re=/[^a-zA-Z_.,& \']+/g;break;
		case "numeric82":re = /^([0-9]{0,8}\.|[0-9]{0,8}\.[0-9]{1,2}|[0-9]{0,8})$/;break;	
		case "date":re=/^0[1-9]\/[0-9]{2}|1[012]\/[0-9]{2}$/;break;
		case "blank":re=/[^a-zA-Z0-9_.,&: \']+/g;break;
		case "time":re=/[^a-zA-Z0-9_.,&: \']+/g;break;	
		case "datetime":re=/[^a-zA-Z0-9_.,&: \']+/g;break;	
		case "uptotwodecimal":re =/^\d+(\.\d{0,2})?$/;break;	
		
		//case "uptotwodecimal":re =/^\s*?([\d\,]+(\.\d{1,2})?|\.\d{1,2})\s*$/;break;
		case "cccnameoncard":re = /[^a-z ]+/i;break;
				
   }
   //alert("re "+re);
   return re;
}

function validateKeys(e,pattern){
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
	 if(!re.test(e.value) && e.value!=''){        e.value = "";        alert("Please enter the value upto two decimal places only.");        e.focus();  }
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
