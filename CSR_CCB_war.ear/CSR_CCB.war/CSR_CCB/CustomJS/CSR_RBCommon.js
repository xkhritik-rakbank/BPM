//----------------------------------------------------------------------------------------------------------------------------------
//--           NEWGEN SOFTWARE TECHNOLOGIES LIMITED -->

//-- Group						 : Application –Projects--->
//-- Product / Project			 : RAKBank --->
//-- Module                     : Common Function --->     
//-- File Name					 : RBCommon.js--->
//-- Author                     : Manish K. Agrawal--->
//-- Date written (DD/MM/YYYY) : 16-Oct-2006--->
//-- Description                : Common Function.--->
//-- ----------------------------------------------------------------------------------------------------------------------------------->

//------------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			 Change By				Change Description (Bug No. (If Any))
// 28-11-2006	 Manish K. Agrawal		Disable Backspace button(RKB-RLS-ALS-CMA-0049/RKB-RLS-ALS-CMA-0050)
// 05-12-2006	 Manish K. Agrawal		Notes field.(RKB-RLS-ALS-CRF-0010)
// 07-12-2006	 Manish K. Agrawal		Notes field.(RKB-RLS-ALS-CRF-0010)
// 07-12-2006	 Manish K. Agrawal		Validation.(RKB-RLS-ALS-CMA-0095)
// 19-12-2006	 Manish K. Agrawal		Disable the right click mouse event.(RKB-RLS-ALS-CMA-0103/RKB-RLS-ALS-CMA-0105)
// 20-12-2006	 Manish K. Agrawal		Format of float value 16,2.(RKB-RLS-ALS-CRF-0004/RKB-RLS-ALS-CRF-0044/RKB-RLS-ALS-CRF-0045/RKB-RLS-PL-ES-0006)
// 20-12-2006	 Manish K. Agrawal		Validation.(RKB-RLS-ALS-CRF-0046/RKB-RLS-ALS-CRF-0047/RKB-RLS-ALS-CRF-0048/RKB-RLS-ALS-CRF-0049/RKB-RLS-ALS-CRF-0050/RKB-RLS-ALS-CRF-0051/RKB-RLS-ALS-CRF-0052/RKB-RLS-ALS-CRF-0053/RKB-RLS-ALS-CRF-0054/RKB-RLS-ALS-CRF-0055/RKB-RLS-ALS-CRF-0056/RKB-RLS-ALS-CRF-0057/RKB-RLS-ALS-CRF-0058/RKB-RLS-ALS-CRF-0061/RKB-RLS-ALS-CRF-0062/RKB-RLS-GSR-LCOL-0001/RKB-RLS-GSR-LCOL-0005/RKB-RLS-GSR-LCOL-0006/RKB-RLS-GSR-LCOL-0007/RKB-RLS-GSR-LCOL-0007/RKB-RLS-GSR-LCOL-0008/RKB-RLS-GSR-LCOL-0009/RKB-RLS-GSR-LCOL-0010/RKB-RLS-GSR-LCOL-0011/RKB-RLS-GSR-LCOL-0013/RKB-RLS-GSR-LCOL-0014/RKB-RLS-LAI-BC-0001/RKB-RLS-PL-PD-0004)
// 20-12-2006	 Manish K. Agrawal		Format Validation.(RKB-RLS-GSR-LCOL-0004)
// 20-12-2006	 Manish K. Agrawal		Format Validation.(RKB-RLS-GSR-LCOL-0012/RKB-RLS-PL-IHR-0004)
//----------------------------------------------------------------------------------------------------
//
//---------------------------------------------------------------------------------------------------->

var JAN="Jan";
var FEB="Feb";
var MAR="Mar";
var APR="Apr";
var MAY="May";
var JUN="Jun";
var JUL="Jul";
var AUG="Aug";
var SEP="Sep";
var OCT="Oct";
var NOV="Nov";
var DEC="Dec";


var JAN1="JAN";
var FEB1="FEB";
var MAR1="MAR";
var APR1="APR";
var MAY1="MAY";
var JUN1="JUN";
var JUL1="JUL";
var AUG1="AUG";
var SEP1="SEP";
var OCT1="OCT";
var NOV1="NOV";
var DEC1="DEC";

var DATEFORMAT="(mm/dd/yyyy)";
var DATESEPARATOR="/";

var Date_Scripts="..\\..\\..\\webtop\\scripts\\date.js"
var general="..\\..\\..\\webtop\\scripts\\wdgeneral.js"
var generalvalidation="..\\..\\..\\webtop\\scripts\\validation.js"
var constant_script="..\\..\\..\\webtop\\en_us\\scripts\\wdconstants.js"
try
{
	document.write("<script src="+Date_Scripts+"></script>");
	document.write("<script src="+general+"></script>");
	document.write("<script src="+generalvalidation+"></script>");
	document.write("<script src="+constant_script+"></script>");

}
catch(e)
{
	alert(e.message);
}
//It trims the string
//----------------------------------------------------------------------------------------------------
//Function Name                    : Trim(string)
//Date Written (DD/MM/YYYY)        : 17-Oct-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : String
//Output Parameters                : NA
//Return Values                    : string
//Description                      : returns string.
//----------------------------------------------------------------------------------------------------
function Trim(str) { 
	var i=0;
	var j=0;
	for (i=0;i < str.length;i++) 
	{
		if (str.charAt(i) != ' ') 
			break; 
	} 

	for (j=str.length - 1;j>= 0; j--) 
	{ 
		if (str.charAt(j) != ' ') 
		break; 
	}

	if (j < i) j = i-1; str = str.substring(i, j+1); 
		return str; 
} 
function RECommon(act){
	var re
	switch(act) 
	{
		case "alpha":re = /[^a-z ]+/i;break;
		case "numeric":re = /[^0-9]/g;break;
		case "float":re = /[^0-9.]/g;break;
		case "negativeAmount":re = /[^0-9.-]/g;break;
//		case "alphanumeric":re = /[^a-z0-9]+/i;break;
		case "AlphaNumeric2":re=/^[0-9a-z ]*$/i;break;
		case "alphanumeric":re = /[^a-zA-Z0-9.,()@$%/\s-_]/g;break;
//		case "digitsOnly":re = /[^0-9]/g;break;
		case "dashdigitsOnly":re = /[^0-9/-]/g;break;
		case "name":re=/[^a-zA-Z_.,& \']+/g;break;
		case "numeric82":re = /^([0-9]{0,8}\.|[0-9]{0,8}\.[0-9]{1,2}|[0-9]{0,8})$/;break;	
		case "date":re=/^0[1-9]\/[0-9]{2}|1[012]\/[0-9]{2}$/;
			
			break;
   }
   return re;
}
function validateKeys(e,processname){
	//alert(processname);
	var re="";


if ((processname=='CSR_Common'))
{
	
if (e.name.toUpperCase()=='CCI_CCRNNO'){
	re=RECommon('numeric')
  if(re.test(e.value)){
  e.value = e.value.replace(re, "");
  }
return false;
}
if (e.name.toUpperCase()=='CCI_SC'){
	re=RECommon('AlphaNumeric2')
  if(!re.test(e.value)){
   e.value = e.value.replace(re, "");
   
  }
return false;
}
if (e.name.toUpperCase()=='CCI_EXTNO'){
	re=RECommon('numeric')
 if(re.test(e.value)){
   e.value = e.value.replace(re, "");
  }
return false;
}}

if (processname=='CSR_BT')
{
	
if (e.name.toUpperCase()=='BTD_OBC_OBNO'){
	re=RECommon('alpha')
  if(re.test(e.value)){
   e.value = e.value.replace(re, "");
  }
return false;
}
if (e.name.toUpperCase()=='BTD_OBC_OBCNO'){
	re=RECommon('numeric')
  if(re.test(e.value)){
   e.value = e.value.replace(re, "");
  }
return false;
}
if (e.name.toUpperCase()=='BTD_OBC_NOOC'){
	re=RECommon('name')
  if(re.test(e.value)){
   e.value = e.value.replace(re, "");
  }
return false;
}

if ((e.name.toUpperCase()=='BTD_RBC_AppC1')|| (e.name.toUpperCase()=='BTD_RBC_AppC2') || (e.name.toUpperCase()=='BTD_RBC_AppC3')) {
	re=RECommon('numeric')
  if(re.test(e.value)){
   e.value = e.value.replace(re, "");
  }
return false;
}
if ((e.name.toUpperCase()=='BTD_RBC_BTA1')|| (e.name.toUpperCase()=='BTD_RBC_BTA2') || (e.name.toUpperCase()=='BTD_RBC_BTA3')) {
	
	re=RECommon('numeric82');	
  if(!re.test(replaceAll(e.value,",",""))){
	  e.value="";
   e.value = e.value.replace(re,""); 
  
  }

return false;
}

}



if (processname=='CSR_CCC')
{
	

if (e.name.toUpperCase()=='BANEFICIARY_NAME'){
	re=RECommon('name')
  if(re.test(e.value)){
   e.value = e.value.replace(re, "");
  }
return false;
}

if ((e.name.toUpperCase()=='ApprovalCode1')|| (e.name.toUpperCase()=='ApprovalCode2') || (e.name.toUpperCase()=='ApprovalCode3')) {
	re=RECommon('numeric')
  if(re.test(e.value)){
   e.value = e.value.replace(re, "");
  }
return false;
}

if ((e.name.toUpperCase()=='CHQ_AMOUNT1')|| (e.name.toUpperCase()=='CHQ_AMOUNT2') || (e.name.toUpperCase()=='CHQ_AMOUNT3')) {
	
	re=RECommon('float')
  if(re.test(e.value)){
   e.value = e.value.replace(re,""); 
   
  }
return false;
}

}

if (processname=='CSR_CBR')
{
if (e.name.toUpperCase()=='AMOUNT'){
	
	re=RECommon('float')
  if(re.test(e.value)){
   e.value = e.value.replace(re,""); 
   
  }
return false;
}

}
if (processname=='CSR_CCB')
{
if(e.name.toUpperCase()=='AVAILABLE_BALANCE'){
	
	re=RECommon('negativeAmount')
	if(re.test(replaceAll(replaceAll(e.value,",",""),"-",""))){
    e.value = e.value.replace(re,""); 
   
  }
return false;
}

if(e.name.toUpperCase()=='EMBOSING_NAME'){
	
	re=RECommon('alpha')
	if(re.test(e.value)){
    e.value = e.value.replace(re,""); 
   
  }
return false;
}
if(e.name.toUpperCase()=='C_STATUS_A_BLOCK'){
	
	re=RECommon('numeric')
	if(re.test(e.value)){
    e.value = e.value.replace(re,""); 
   
  }
return false;
}
if(e.name.toUpperCase()=='C_STATUS_B_BLOCK'){
	
	re=RECommon('numeric')
	if(re.test(e.value)){
    e.value = e.value.replace(re,""); 
   
  }
return false;
}
}

if (processname=='CSR_OCC_CSI')
{
if (e.name.toUpperCase()=='OTH_CSI_POSTMTB'){
	
	re=RECommon('numeric')
	if(re.test(e.value)){
    e.value = e.value.replace(re,""); 
   
  }
return false;
}
/*if (e.name.toUpperCase()=='OTH_CSI_ND'){
	
	re=RECommon('numeric')
	if(re.test(e.value)){
    e.value = e.value.replace(re,""); 
   
  }
return false;
}*/
if (e.name.toUpperCase()=='OTH_CSI_ACCNO'){
	
	re=RECommon('numeric')
	if(re.test(e.value)){
    e.value = e.value.replace(re,""); 
   
  }
return false;
}

}
if (processname=='CSR_OCC_CLI')
{
if (e.name.toUpperCase()=='OTH_CLI_MONTHS'){
	
	re=RECommon('numeric')
	if(re.test(e.value)){
    e.value = e.value.replace(re,""); 
     }
return false;
}
}

if (processname=='CSR_OCC_TD')
{
if (e.name.toUpperCase()=='OTH_TD_RNO'){
	re=RECommon('numeric')
	if(re.test(e.value)){
    e.value = e.value.replace(re,""); 
  }
 return false;
  }
if (e.name.toUpperCase()=='OTH_TD_AMOUNT'){
   
     re=RECommon('float')
   if(re.test(e.value)){
     e.value = e.value.replace(re,""); 
     }
}
}
if (processname=='CSR_OCC_SSC')
{

if (e.name.toUpperCase()=='OTH_SSC_AMOUNT'){
   
     re=RECommon('float')
   if(re.test(e.value)){
     e.value = e.value.replace(re,""); 
     }
}
}
if (processname=='CSR_OCC_CS')
{

if (e.name.toUpperCase()=='OTH_CS_AMOUNT'){
   
     re=RECommon('float')
   if(re.test(e.value)){
     e.value = e.value.replace(re,""); 
     }
}
}

}
function validateKeys_OnBlur(e,processname){
	
	var re="";
	if(e.value=="")
		return false;

if ((processname=='CSR_Common'))
{
//alert('Common');
if (e.name.toUpperCase()=='CCI_CCRNNO'){
	re=RECommon('numeric')
  if(re.test(e.value)){
   alert("Only numbers are allowed.");
   e.value = e.value.replace(re, "");
   e.focus();
  }
return false;
}
if (e.name.toUpperCase()=='CCI_SC'){
	re=RECommon('AlphaNumeric2')
  if(!re.test(e.value)){
   alert("Only Alphanumeric are allowed.");
   e.value = e.value.replace(re, "");
   e.focus();
  }
return false;
}
if (e.name.toUpperCase()=='CCI_EXTNO'){
	re=RECommon('numeric')
  if(re.test(e.value)){
   alert("Only numbers are allowed.");
   e.value = e.value.replace(re, "");
   e.focus();
  }
return false;
}

}


if (processname=='CSR_BT')
{	
if (e.name.toUpperCase()=='BTD_OBC_OBNO'){
	re=RECommon('alpha')
  if(re.test(e.value)){
   alert('Only alphabets and numbers are allowed');
   e.value = e.value.replace(re, "");
   e.focus();
  }
return false;
}
if (e.name.toUpperCase()=='BTD_OBC_OBCNO'){
	re=RECommon('numeric')
  if(e.value!=""&&re.test(e.value)){
   alert("Only numbers are allowed.");
   e.value = e.value.replace(re, "");
   e.focus();
  }
return false;
}
if (e.name.toUpperCase()=='BTD_OBC_NOOC'){
	re=RECommon('name');
  if(re.test(e.value)){
   alert("Only alphabets, &, ., ' and space are allowed....");
   e.value = e.value.replace(re, "");
   e.focus();
  }
return false;
}

if ((e.name.toUpperCase()=='BTD_RBC_AppC1')|| (e.name.toUpperCase()=='BTD_RBC_AppC2') || (e.name.toUpperCase()=='BTD_RBC_AppC3')) {
	re=RECommon('numeric');
  if(re.test(e.value)){
		   alert("Only numbers are allowed.");
   e.value = e.value.replace(re, "");
   e.focus();
  }
return false;
}

if ((e.name.toUpperCase()=='BTD_RBC_BTA1')|| (e.name.toUpperCase()=='BTD_RBC_BTA2') || (e.name.toUpperCase()=='BTD_RBC_BTA3')) {
	
	//re=RECommon('float');
		re = /[^0-9.,]/g;
  if(re.test(e.value)){
	  alert("Only numbers and . are allowed.");
   e.value = e.value.replace(re,""); 
   e.focus();
   }
re = /[^0-9.]/g;
 e.value = e.value.replace(re,"");
e.value = e.value.replace(/^[0]+/g,""); 
dollarAmount(e); 
return false;
}

}

if (processname=='CSR_CCC')
{
	
if (e.name.toUpperCase()=='BANEFICIARY_NAME'){
	re=RECommon('name')
  if(re.test(e.value)){
 alert("Only alphabets, &, ., ' and space are allowed....");
   e.value = e.value.replace(re, "");
   e.focus();
  }
return false;
}
if ((e.name.toUpperCase()=='CHQ_AMOUNT1')|| (e.name.toUpperCase()=='CHQ_AMOUNT2') || (e.name.toUpperCase()=='CHQ_AMOUNT3')) {
	
	amount_field(e);
	re = /[^0-9.,]/g;
 if(re.test(e.value)){
   alert("Only numbers and . are allowed.");
   e.value = e.value.replace(re,""); 
   e.focus();
   }
	re = /[^0-9.]/g;
	e.value = e.value.replace(re,"");
	e.value = e.value.replace(/^[0]+/g,""); 
	dollarAmount(e); 
	return false;
}
if ((e.name.toUpperCase()=='ApprovalCode1')|| (e.name.toUpperCase()=='ApprovalCode2') || (e.name.toUpperCase()=='ApprovalCode3')) {
	re=RECommon('numeric')
  if(re.test(e.value)){
   alert("Only numbers are allowed.");
   e.value = e.value.replace(re, "");
   e.focus;
   }
 return false;
}
}

if (processname=='CSR_CBR')
{
	
if ((e.name.toUpperCase()=='AMOUNT')){
	
	i = (e.value.indexOf('.'));
		m = (e.value.indexOf('.',i+1));
		if(m!=-1){//multiple '.'
			alert("Invalid value has entered. The format should be 10,2");
			e.value='';
			e.focus();
		}
		if(e.value=='.' || e.value=='.0' || e.value=='.00'){
			alert("Invalid value has entered. The format should be 10,2");
			e.value='';
			e.focus();
		}
		if(e.value.length>1 && e.value.indexOf('.')==e.value.length-1){
			alert("Invalid value has entered. The format should be 10,2");
			e.focus();
		}

		if(i!=-1){
			j=(e.value.substring(i+1).length);
			if(2<j){
				alert("Invalid value has entered. The format should be 10,2");
				e.value='';
				e.focus();
			}			
			j=e.value.substring(0,i).length;
			if(8<j){
				alert("Invalid value has entered. The format should be 10,2");
				e.value='';
				e.focus();
			}
		}
		else{
			if(8<e.value.length){
				alert("Invalid value has entered. The format should be 10,2");
				e.value='';
				e.focus();
			}
		}
	
	re = /[^0-9.,]/g;
  if(re.test(e.value)){
	  alert("Only numbers and . are allowed.");
   e.value = e.value.replace(re,""); 
   e.focus();
   }
re = /[^0-9.]/g;
 e.value = e.value.replace(re,"");
e.value = e.value.replace(/^[0]+/g,""); 
dollarAmount(e); 
return false;
}

}
if (processname=='CSR_CCB')
{
	amount_field(e);
	re = /[^0-9.,-]/g;
 if(re.test(e.value)){
   alert("Only numbers , . and - are allowed.");
   e.value = e.value.replace(re,""); 
   e.focus();
   }
	re = /[^0-9.]/g;
	var status="0";
	//dollarAmountWithNegative
	if(e.value.indexOf("-")!=-1)
	{
		e.value=replaceAll(e.value,"-","");
		status="1";

	}
	e.value = e.value.replace(re,"");
	e.value = e.value.replace(/^[0]+/g,""); 
	dollarAmountWithNegative(e,status); 
	return false;
}

if (processname=='CSR_OCC_CSI')
{
if (e.name.toUpperCase()=='OTH_CSI_POSTMTB'){
	re=RECommon('numeric')
	if(re.test(e.value)){
	 alert("Only numbers are allowed.");
    e.value = e.value.replace(re,""); 
	e.focus();
	return false;
    }

	if (e.value!='' && (e.value<3 || e.value>100))
	{
     alert("Value should be between 3 and 100 both inclusive.");
    e.value = e.value.replace(re,""); 
	e.focus();
	}
return false;

}

if (e.name.toUpperCase()=='OTH_CSI_ND'){
	re=RECommon('numeric')
	if(re.test(e.value)){
	 alert("Only numbers are allowed.");
    e.value = e.value.replace(re,""); 
	e.focus();
	return false;

	if(parseInt(e.value)==0||parseInt(e.value)>31){
	 e.value = e.value.replace(re,""); 
	e.focus();
	return false;
	}   
  }
return false;
}

if (e.name.toUpperCase()=='OTH_CSI_ACCNO'){
	
	re=RECommon('numeric')
	if(re.test(e.value)){
    alert("Only numbers are allowed.");
    e.value = e.value.replace(re,""); 
	e.focus();
   
  }
return false;
}

}

if (processname=='CSR_OCC_CLI')
{
if (e.name.toUpperCase()=='OTH_CLI_MONTHS'){
	re=RECommon('numeric')
	if(re.test(e.value) || e.value<0 || e.value>3){
    alert('Only numbers between 0 to 3 are allowed');
    e.value = ""; 
	e.focus();
   
  }
return false;
}
}
if (processname=='CSR_OCC_TD')
{
if (e.name.toUpperCase()=='OTH_TD_RNO'){
	re=RECommon('numeric')
	if(re.test(e.value)){
    alert('Only numbers are allowed');
    e.value = e.value.replace(re,""); 
	e.focus();
  }
return false;
}
if (e.name.toUpperCase()=='OTH_TD_AMOUNT'){
amount_field(e);
	re = /[^0-9.,]/g;
 if(re.test(e.value)){
   alert("Only numbers and . are allowed.");
   e.value = e.value.replace(re,""); 
   e.focus();
   }
	re = /[^0-9.]/g;
	e.value = e.value.replace(re,"");
	e.value = e.value.replace(/^[0]+/g,""); 
	dollarAmount(e); 
	return false;
}
}
if (processname=='CSR_OCC_SSC')
{
if (e.name.toUpperCase()=='OTH_SSC_AMOUNT'){
amount_field(e);
	re = /[^0-9.,]/g;
 if(re.test(e.value)){
   alert("Only numbers and . are allowed.");
   e.value = e.value.replace(re,""); 
   e.focus();
   }
	re = /[^0-9.]/g;
	e.value = e.value.replace(re,"");
	e.value = e.value.replace(/^[0]+/g,""); 
	dollarAmount(e); 
	return false;
}
}
if (processname=='CSR_OCC_CS')
{
if (e.name.toUpperCase()=='OTH_CS_AMOUNT'){
amount_field(e);
	re = /[^0-9.,]/g;
 if(re.test(e.value)){
   alert("Only numbers and . are allowed.");
   e.value = e.value.replace(re,""); 
   e.focus();
   }
	re = /[^0-9.]/g;
	e.value = e.value.replace(re,"");
	e.value = e.value.replace(/^[0]+/g,""); 
	dollarAmount(e); 
	return false;
}
}

if (processname=='CSR_OCC_ECR')
 {
	
if (e.name.toUpperCase()=='OTH_ECR_RB'){
	re=RECommon('date');
	//alert(re);
	//alert(re.test(e.value));
if(!re.test(e.value)){
   alert("Invalid Date, Only MM/YY format is allowed");
   e.value = e.value.replace(re,""); 
   e.focus();
   }
	return false;
}}	
}
function amount_field(e){
i = (e.value.indexOf('.'));
		m = (e.value.indexOf('.',i+1));
		if(m!=-1){//multiple '.'
			alert("Invalid value has entered. The format should be 10,2");
			e.value='';
			e.focus();
		}
		if(e.value=='.' || e.value=='.0' || e.value=='.00'){
			alert("Invalid value has entered. The format should be 10,2");
			e.value='';
			e.focus();
		}
		if(e.value.length>1 && e.value.indexOf('.')==e.value.length-1){
			alert("Invalid value has entered. The format should be 10,2");
			e.focus();
		}

		if(i!=-1){
			j=(e.value.substring(i+1).length);
			if(j>2){
				alert("Invalid value has entered. The format should be 10,2");
				e.value='';
				e.focus();
			}			
			j=e.value.substring(0,i).length;
			if(j>8){
				alert("Invalid value has entered. The format should be 10,2");
				e.value='';
				e.focus();
			}
		}
		else{
			if(e.value.length>8){
				alert("Invalid value has entered. The format should be 10,2");
				e.value='';
				e.focus();
			}
		}
	} 
//----------------------------------------------------------------------------------------------------
//Function Name                    : chkdate(string,string)
//Date Written (DD/MM/YYYY)        : 17-Oct-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : String,String
//Output Parameters                : String
//Return Values                    : string
//Description                      : returns string.
//----------------------------------------------------------------------------------------------------
function chkdate(objCtrl,format)
{
try{
	var month=new Array()
	month[1]="january";
	month[2]="febuary";
	month[3]="march";
	month[4]="april";
	month[5]="may";
	month[6]="june";
	month[7]="july";
	month[8]="august";
	month[9]="september";
	month[10]="october";
	month[11]="november";
	month[12]="december";

	
	var monfr=format.substring(3,format.lastIndexOf('/'));
	var yrfr=format.substring(3+monfr.length+1, format.length+1);
	var monfrm=objCtrl.value.substring(3,objCtrl.value.lastIndexOf('/'));
	var yrfrm=objCtrl.value.substring(3+monfrm.length+1, objCtrl.value.length+1);
	var dtfrm=objCtrl.value.substring(0,2);
	var validdt=false;

	if(objCtrl.value=="")
		return false;

	if((monfrm.toLowerCase()=="apr") || (monfrm.toLowerCase()=="jun") || (monfrm.toLowerCase()=="sep") || (monfrm.toLowerCase()=="nov") || (monfrm.toLowerCase()=="4") || (monfrm.toLowerCase()=="6") || (monfrm.toLowerCase()=="9") || (monfrm.toLowerCase()=="11") || (monfrm.toLowerCase()=="04") || (monfrm.toLowerCase()=="06") || (monfrm.toLowerCase()=="09"))
		if((eval(dtfrm)>30) || (eval(dtfrm)<1))
		 {
			alert("Please Enter Correct Date in "+format+" Format");
			objCtrl.focus();objCtrl.select();
			return false;
		 }

	
	if((monfrm.toLowerCase()=="feb") || (monfrm.toLowerCase()=="2") || (monfrm.toLowerCase()=="02"))	
		if ((eval(yrfrm) % 4) != 0)
		{
			if((eval(dtfrm)>28)||(eval(dtfrm)<1))
			 {
				alert("Please Enter Correct Date in "+format+" Format");
				objCtrl.focus();objCtrl.select();
				 return false;
			 }
		}
		else if  ((eval(yrfrm) % 4000) == 0)
		{
			if((eval(dtfrm)>29)||(eval(dtfrm)<1))
			{
				alert("Please Enter Correct Date in "+format+" Format");
				objCtrl.focus();objCtrl.select();
				 return false;
			 }
	   }
		else if  ((eval(yrfrm) % 400) == 0)
		{
			if((eval(dtfrm)>29)||(eval(dtfrm)<1))
			{
				alert("Please Enter Correct Date in "+format+" Format");
				objCtrl.focus();objCtrl.select();
				return false;
			}
		}
		else if ((eval(yrfrm) % 100) == 0)
		{
			if((eval(dtfrm)>28)||(eval(dtfrm)<1))
			{
				alert("Please Enter Correct Date in "+format+" Format");
				objCtrl.focus();objCtrl.select();
				return false;
			}
		 }
		else
		{
			if((eval(dtfrm)>29)||(eval(dtfrm)<1))
			{
				alert("Please Enter Correct Date in "+format+" Format");
				objCtrl.focus();objCtrl.select();
				return false;
			}
		}
	
		for(i=1;i<=31;i++)
			if(dtfrm==i)
			{
				validdt=true;
				break;
			}

	if(!validdt)
	{
		alert("Please Enter Correct Date in "+format+" Format");
		objCtrl.focus();objCtrl.select();
		return false;
	}

	validdt=false;
	//if format is DD/MM/YYYY
	if (monfr.length==2)
	{
		for(i=1;i<=12;i++)
			if(monfrm==i)
			{
				validdt=true;
				break;
			}
	}
	else	
			validdt=false;

	//if format is DD/MMM/YYYY
	if(monfr.length==3)
		for(i=1;i<=12;i++)
			if(monfrm.toLowerCase()==month[i].substring(0,3))
			{
				validdt=true;
				break;
			}
	if(!validdt)
		{
			alert("Please Enter Correct Date in "+format+" Format");
			objCtrl.focus();objCtrl.select();
			return false;
		}


	if(yrfr.length!=yrfrm.length)
	{
		alert("Please Enter Correct Date in "+format+" Format");
		objCtrl.focus();objCtrl.select();
		return false;
	}
}catch(e)
	{
		alert(e.message);
		return false;
	}
	return true;
}
function replaceAll(str, from, to) 
{
	var idx = str.indexOf(from);
	while(idx>-1){
		str = str.replace(from,to);
		idx = str.indexOf(from);	
	}
	return str;
}
//Parameter
//	1. sDbDate		: Date to be formatted
//	2. sDateFormat	: Format in which sDbDate to be format
// Function returns date in sDateFormat format.
function DBToLocal(sDbDate,sDateFormat){
	var sDateSeparator='/';
	if(sDbDate=='')
		return ' ';
	var nBegIndex=sDbDate.indexOf("-");
	//Gets the value of the date from DB
	var strYear = sDbDate.substring(0,sDbDate.indexOf("-"));
	var strMonth = sDbDate.substring(nBegIndex+1,sDbDate.lastIndexOf("-"));
	var strDay;
	var strTime="";
	if (sDbDate.indexOf(" ")!=-1)
	{
		strDay = sDbDate.substring(sDbDate.lastIndexOf("-")+1,sDbDate.indexOf(" "));
		var strtimetemp=sDbDate.substring(sDbDate.indexOf(" ")+1,sDbDate.length);
		var index=strtimetemp.indexOf(":");
		var lastIndex=strtimetemp.lastIndexOf(":");

		if(index==lastIndex)
			strTime=strtimetemp;
		else
			strTime = sDbDate.substring(sDbDate.indexOf(" ")+1,sDbDate.lastIndexOf(":")+3);//gets the seconds as well

		if (strTime=="00:00:00")
			strTime="";
	}
	else
		strDay = sDbDate.substring(sDbDate.lastIndexOf("-")+1,sDbDate.length);

	var strtemp1="";
	var strtemp2="";
	var strtemp3="";
	var strResult="";
	var tempDay="";
	var tempMon="";

	// gets the characters from the set date format
	var strChar1=sDateFormat.substring(0,sDateFormat.indexOf("/"));
	var strChar2=sDateFormat.substring(sDateFormat.indexOf("/")+1,sDateFormat.lastIndexOf("/"));
	var strChar3=sDateFormat.substring(sDateFormat.lastIndexOf("/")+1,sDateFormat.length);

	strChar1=strChar1.toUpperCase();
	strChar2=strChar2.toUpperCase();
	strChar3=strChar3.toUpperCase();

	if ((strChar1=="D")||(strChar1=="DD"))
	{
		tempDay=parseInt(strDay,10);
		if ((strChar1=="D")&& (tempDay<10))
			strtemp1=strDay.substring(1,2); //getting the last value like 03 ->3
		else
			strtemp1=strDay;
	}
	else if((strChar1=="M")||(strChar1=="MM"))
	{
		tempMon=parseInt(strMonth,10);
		if ((strChar1=="M")&& (tempMon <10))
			strtemp1=strMonth.substring(1,2); //getting the last value like 03 ->3
		else
			strtemp1=strMonth;
	}
	else
	{
		if ((strChar1=="YY")||(strChar1=="YYYY"))
		{
			if (strChar1=="YY")
				strtemp1=strYear.substring(2,strYear.length);//getting the last two
			else
				strtemp1=strYear;
		}
	}

	if ((strChar2=="D")||(strChar2=="DD"))
	{
		tempDay=parseInt(strDay,10);
		if ((strChar2=="D")&& (tempDay <10))
			strtemp2=strDay.substring(1,2); //getting the last value like 03 ->3
		else
			strtemp2=strDay;
	}
	else if((strChar2=="MM")||(strChar2=="MMM"))
	{
		if (strChar2=="MMM")
		{
			switch(parseInt(strMonth,10))
			{
				case 1:
					strtemp2=JAN;
					break;
				case 2:
					strtemp2=FEB;
					break;
				case 3:
					strtemp2=MAR;
					break;
				case 4:
					strtemp2=APR;
					break;
				case 5:
					strtemp2=MAY;
					break;
				case 6:
					strtemp2=JUN;
					break;
				case 7:
					strtemp2=JUL;
					break;
				case 8:
					strtemp2=AUG;
					break;
				case 9:
					strtemp2=SEP;
					break;
				case 10:
					strtemp2=OCT;
					break;
				case 11:
					strtemp2=NOV;
					break;
				case 12:
					strtemp2=DEC;
					break;
			}
		}
			else
				strtemp2=strMonth;
	}


	if((strChar3=="D")||(strChar3=="DD"))
	{
		tempDay=parseInt(strDay,10);
		if ((strChar3=="D") && (tempDay < 10))
			strtemp3=strDay.substring(1,2); //getting the last value like 03 ->3
		else
			strtemp3=strDay;
	}
	else
	{
		if ((strChar3=="YY")||(strChar3=="YYYY"))
		{
			if (strChar3=="YY")
				strtemp3=strYear.substring(2,strYear.length);//getting the last two
			else
				strtemp3=strYear;
		}
	}
	if ((strtemp1=='')&&(strtemp2==''))
		return strtemp3+" "+strTime;
	else if ((strtemp3=='')&&(strtemp2==''))
		return strtemp1+" "+strTime;
	else if ((strtemp3=='')&&(strtemp1==''))
		return strtemp2+" "+strTime;
	else if (strtemp1=='')
		return strtemp2+sDateSeparator+strtemp3+" "+strTime;
	else if (strtemp2=='')
		return strtemp1+sDateSeparator+strtemp3+" "+strTime;
	else if (strtemp3=='') 
		return strtemp1+sDateSeparator+strtemp2+" "+strTime;

	strResult=strtemp1+sDateSeparator+strtemp2+sDateSeparator+strtemp3+" "+strTime;
	return strResult;
 }
function CheckFormat(e){
	//Check for "xxxx-xxxxxx" if object is NewGuarantorName for PL_CLD process
	if (e.name.toUpperCase()=='NEWGUARANTORNAME'){
		if(e.value=='') return false;
		if (e.value.substring(4,5)!='-' || e.value.length!=11 || e.value.indexOf(' ')!=-1){
			alert("Invalid format of entered value. Please enter New Guarantor A/C Number in XXXX-XXXXXX format.");
			e.value = '';
			e.focus();
		}
	}	
}
//----------------------------------------------------------------------------------------------------
//Function Name                    : getCurrentDateTimeInLocalFormat(string)
//Date Written (DD/MM/YYYY)        : 17-Oct-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : String,String
//Output Parameters                : String
//Return Values                    : string
//Description                      : returns string.
//----------------------------------------------------------------------------------------------------
//gets the current date and then changes into the given dateformat
function getCurrentDateTimeInLocalFormat(sDateFormat){
	var currentDateTime = new Date();
	var day = currentDateTime.getDate();
	var month = currentDateTime.getMonth() +1;
	var year=currentDateTime.getFullYear();
	var hr = currentDateTime.getHours();

	if (hr <10) hr= "0"+hr;

	var min = currentDateTime.getMinutes();
	if (min <10) min= "0"+min;

	var sec = currentDateTime.getSeconds();
	if (sec <10) sec= "0"+sec;

	var temp1;
	var temp2;
	var temp3;
	var Result;
	var DateSep="/"; //date separator.

	var strChar1=sDateFormat.substring(0,sDateFormat.indexOf("/"));
	var strChar2=sDateFormat.substring(sDateFormat.indexOf("/")+1,sDateFormat.lastIndexOf("/"));
	var strChar3=sDateFormat.substring(sDateFormat.lastIndexOf("/")+1,sDateFormat.length);

	strChar1=strChar1.toUpperCase();
	strChar2=strChar2.toUpperCase();
	strChar3=strChar3.toUpperCase();


	if ((strChar1=="D")||(strChar1=="DD"))
	{
		if((strChar1=="DD") && (day <10))
			temp1= "0"+day;
		else
			temp1=day;
	}
	else if((strChar1=="M")||(strChar1=="MM"))
	{
		if((strChar1=="MM") && (month <10))
			  temp1= "0"+month;
		else
			temp1=month;
	}
	else 
		temp1=year;
	
	if ((strChar2=="D")||(strChar2=="DD"))
	{
		if((strChar2=="DD") && (day <10))
			temp2= "0"+day;
		else
			temp2=day;
	}
	else if((strChar2=="MM")||(strChar2=="MMM"))
	{
		if (strChar2=="MMM")
		{
			switch(parseInt(month,10))
			{
				case 1:
					temp2=JAN;
					break;
				case 2:
					temp2=FEB;
					break;
				case 3:
					temp2=MAR;
					break;
				case 4:
					temp2=APR;
					break;
				case 5:
					temp2=MAY;
					break;
				case 6:
					temp2=JUN;
					break;
				case 7:
					temp2=JUL;
					break;
				case 8:
					temp2=AUG;
					break;
				case 9:
					temp2=SEP;
					break;
				case 10:
					temp2=OCT;
					break;
				case 11:
					temp2=NOV;
					break;
				case 12:
					temp2=DEC;
					break;
			}
		}
			else
			{
			if ((strChar2=="MM") && (month<10))
				temp2="0"+month;
			else
				temp2=month;
			}
	}
	if((strChar3=="D")||(strChar3=="DD"))
	{
		if((strChar3=="DD") && (day <10))
			temp3= "0"+day;
		else
			temp3=day;
	}
	else
	{
		if ((strChar3=="YY")||(strChar3=="YYYY"))
		{
			if (strChar3=="YY")
				temp3=year.substring(2,year.length);//getting the last two
			else
				temp3=year;
		}
	}

	Result=temp1 +DateSep +temp2 +DateSep +temp3 +" "+hr +":" +min;
	return Result;
}
//----------------------------------------------------------------------------------------------------
//Function Name                    : checkShortcut(string,string)
//Date Written (DD/MM/YYYY)        : 17-Oct-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : String,String
//Output Parameters                : String
//Return Values                    : string
//Description                      : returns string.
//----------------------------------------------------------------------------------------------------
// Function: deactivate the Backspace button.
//----------------------------------------------------------------------------------------------------
// Changed By						:	Manish K. Agrawal
// Reason / Cause (Bug No if Any)	:	(RKB-RLS-ALS-CMA-0049/RKB-RLS-ALS-CMA-0050)
// Change Description				:	add event onkeydown='checkShortcut()' on body load to disable Backspace button
//---------------------------------------------------------------------------------------------------->
function checkShortcut(){
	if(event.keyCode==8)
	{
		if((event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") || (event.srcElement.tagName == "INPUT"  && event.srcElement.id.substring(0,5)=='Date_')  )
		{
			event.cancelBubble = true;
			event.returnValue = false;
		}		
		if(event.srcElement.name == "CustomerName" || event.srcElement.name == "ProductOrScheme" ||  event.srcElement.name == "NPAStage" || event.srcElement.name == "AppLoanAmt" || event.srcElement.name == "OutstandingLoanAmt" || event.srcElement.name == "InterestRate" || event.srcElement.name == "NextInstAmt" || event.srcElement.name == "ChargesPostDues" || event.srcElement.name == "Tenor" || event.srcElement.name == "NextInstDate" || event.srcElement.name == "TotalPostDues" || event.srcElement.name == "LoanMaturityDate" || event.srcElement.name == "RepaymentMode" || event.srcElement.name == "Bucket" || event.srcElement.name == "FundingACNo" || event.srcElement.name == "Delinquency" || event.srcElement.name == "OK" || event.srcElement.name == "Cancel" || event.srcElement.name == "Introduce" || event.srcElement.name == "ClearAll" || event.srcElement.name == "Print")
		{
			event.cancelBubble = true;
			event.returnValue = false;
		}		
	}
} 
//----------------------------------------------------------------------------------------------------
//Function Name							: browseContent(event)
//Date Written (DD/MM/YYYY)        : 03-Jan-2007
//Author										: Manish K. Agrawal
//Input Parameters						: event
//Output Parameters						: true/false
//Return Values							: boolean
//Description								: enable only TAB/left/right arrow keys on disabled text box to browse contents only.
//----------------------------------------------------------------------------------------------------
function browseContent(e) {
	var e = e || window.event, code = e.charCode || e.keyCode;
	//alert(code);		
	if(code == 9 || code == 37 || code == 39) return true;
	return false;
}
//Validate for past date
function futureDateValidation(givenDate){
	//alert("6");
	var arrDate=givenDate;				
	var dd = arrDate.substring(0,2);
	var mm = arrDate.substring(3,5);
	var yyyy = arrDate.substring(6,10);			
	//alert(dd+"--"+mm+"--"+yyyy);
	var dt=new Date(yyyy,mm-1,dd);
	//alert("form date--"+dt);
	var now=new Date();
	//alert("now date--"+now.getFullYear());
	
	if(now.getFullYear()== yyyy)
	{	
		if((now.getMonth()+1)== mm)
			{
				if(now.getDate()== dd || now.getDate() < dd)
					return true;
			}
		else if((now.getMonth()+1) < mm)	
			return true;
	}
	else if(now.getFullYear() < yyyy)
			return true;
	
	 return false;
}
//Returns difference in no of days
function GetDateDiff(sDate1,sDate2,sDateFormat){
 //Code added by Abhishek Gupta on 1/12/2006
 //sDate1=sDate1.substring(sDate1.indexOf("/")+1,sDate1.lastIndexOf("/")+1)+sDate1.substring(0,sDate1.indexOf("/"))+sDate1.substring(sDate1.lastIndexOf("/"),sDate1.length);
 //*****************************************
 var Date1=LocalToDB(sDate1,sDateFormat);
 var Date2=LocalToDB(sDate2,sDateFormat);
 var Year1=Date1.substring(0,Date1.indexOf("-")); //2003-12-12 12:12:12
 var Year2=Date2.substring(0,Date2.indexOf("-"));
 
 Date1=Date1.substring(Date1.indexOf("-")+1,Date1.length);//12-12 12:12:12
 Date2=Date2.substring(Date2.indexOf("-")+1,Date2.length);
 
 var Month1=Date1.substring(0,Date1.indexOf("-"));
 var Month2=Date2.substring(0,Date2.indexOf("-"));
 Date1=Date1.substring(Date1.indexOf("-")+1,Date1.length);//12 12:12:12
 Date2=Date2.substring(Date2.indexOf("-")+1,Date2.length);
 
 var Day1=Date1.substring(0,Date1.indexOf(" "));
 var Day2=Date2.substring(0,Date2.indexOf(" "));
 Date1=Date1.substring(Date1.indexOf(" ")+1,Date1.length);//12:12:12
 Date2=Date2.substring(Date2.indexOf(" ")+1,Date2.length);
/*
 var Hour1=Date1.substring(0,Date1.indexOf(":"));
 var Hour2=Date2.substring(0,Date2.indexOf(":"));
 Date1=Date1.substring(Date1.indexOf(":")+1,Date1.length);//12:12
 Date2=Date2.substring(Date2.indexOf(":")+1,Date2.length);
 
 var Min1=Date1.substring(0,Date1.indexOf(":"));
 var Min2=Date2.substring(0,Date2.indexOf(":"));
 var Sec1=Date1.substring(Date1.indexOf(":")+1,Date1.length);//12
 var Sec2=Date2.substring(Date2.indexOf(":")+1,Date2.length);
 
//new Date(yy,mm,dd,hh,mm,ss)
 
 var d1=new Date(Year1,Month1-1,Day1,Hour1,Min1,Sec1);
 var d2=new Date(Year2,Month2-1,Day2,Hour2,Min2,Sec2);
*/ 
 var d1=new Date(Year1,Month1-1,Day1);
 var d2=new Date(Year2,Month2-1,Day2);
 
 var i1 = d1.valueOf();
 var i2 = d2.valueOf();
/* 
 var RateLockPeriod=window.top.wi_object.attribute_list['RATELOCKPERIOD'].value;
 var RateLockPeriod=RateLockPeriod*1000*60*60*24;
 i1=i1+RateLockPeriod;
*/ 
 var milli=i2-i1
 var NoOfDays=milli/(1000*60*60*24)
 //alert(NoOfDays);
 return NoOfDays;
 
}
function checkNum(data) {      // checks if all characters
var valid = "0123456789.";     // are valid numbers or a "."
var ok = 1; var checktemp;
for (var i=0; i<data.length; i++) {
checktemp = "" + data.substring(i, i+1);
if (valid.indexOf(checktemp) == "-1") return 0; }
return 1;
}
function dollarAmount(field) { 

//alert('22');
Num = "" + field.value;


dec = Num.indexOf(".");
end = ((dec > -1) ? "" + Num.substring(dec,Num.length) : ".00");

Num = "" + parseInt(Num);


var temp1 = "";
var temp2 = "";

if (checkNum(Num) == 0) {

}
else {

if (end.length == 2) end += "0";
if (end.length == 1) end += "00";
if (end == "") end += ".00";

var count = 0;
for (var k = Num.length-1; k >= 0; k--) {
var oneChar = Num.charAt(k);
if (count == 3) {
temp1 += ",";
temp1 += oneChar;
count = 1;
continue;
}
else {
temp1 += oneChar;
count ++;
   }
}

for (var k = temp1.length-1; k >= 0; k--) {
var oneChar = temp1.charAt(k);
temp2 += oneChar;
}
temp2 = temp2 + end;
//alert("temp2--" + temp2);
field.value=temp2;
   }
}
function dollarAmountWithNegative(field,status) { 

//alert('22');
Num = "" + field.value;


dec = Num.indexOf(".");
end = ((dec > -1) ? "" + Num.substring(dec,Num.length) : ".00");

Num = "" + parseInt(Num);


var temp1 = "";
var temp2 = "";

if (checkNum(Num) == 0) {

}
else {

if (end.length == 2) end += "0";
if (end.length == 1) end += "00";
if (end == "") end += ".00";

var count = 0;
for (var k = Num.length-1; k >= 0; k--) {
var oneChar = Num.charAt(k);
if (count == 3) {
temp1 += ",";
temp1 += oneChar;
count = 1;
continue;
}
else {
temp1 += oneChar;
count ++;
   }
}

for (var k = temp1.length-1; k >= 0; k--) {
var oneChar = temp1.charAt(k);
temp2 += oneChar;
}
temp2 = temp2 + end;
//alert("temp2--" + temp2);
if(status=="1")
	field.value="-"+temp2;
else
	field.value=temp2;
   }
}
//----------------------------------------------------------------------------------------------------
//Function Name                    : right(event)
//Date Written (DD/MM/YYYY)        : 19-Dec-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : event
//Output Parameters                : NA
//Return Values                    : boolean
//Description                      : Code to Disable mouse right click 
//----------------------------------------------------------------------------------------------------
// Function: deactivate the Backspace button.

//----------------------------------------------------------------------------------------------------
// Changed By						:	Manish K. Agrawal
// Reason / Cause (Bug No if Any)	:	(RKB-RLS-ALS-CMA-0103/RKB-RLS-ALS-CMA-0105)
// Change Description				:	Disable the right click mouse event.
//---------------------------------------------------------------------------------------------------->
function right(e) {
	if (navigator.appName == 'Netscape' && (e.which == 3 || e.which == 2))
		return false;
	else if (navigator.appName == 'Microsoft Internet Explorer' && (event.button == 2 || event.button == 3)) 
	{
		//alert("User does not have permission to right click.");
		//return false;
	}
	return true;
}

document.onmousedown=right;
document.onmouseup=right;
if (document.layers) window.captureEvents(Event.MOUSEDOWN);
if (document.layers) window.captureEvents(Event.MOUSEUP);
window.onmousedown=right;
window.onmouseup=right;

function space_Check(str) {
	Test = str;
	for (i=0,n=Test.length;i<n;i++) {
		if(Test.charCodeAt(i)!=32) {
			return true;
		}
	}
	return false;
}
function replaceAll(data,searchfortxt,replacetxt){
	var startIndex=0;
	while(data.indexOf(searchfortxt)!=-1)
	{
		data=data.substring(startIndex,data.indexOf(searchfortxt))+data.substring(data.indexOf(searchfortxt)+1,data.length);
	}	
	return data;
}