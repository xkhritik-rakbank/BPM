<%@ page import="java.io.*,java.util.*,java.math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<!--<%@ page import="java.lang.Object"%>-->
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@ page import ="java.text.DecimalFormat"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>
<%@ include file="Log.process"%>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->
<head>
<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>
<script language="javascript" src="/webdesktop/webtop/en_us/scripts/CSR_RBCommon.js"></script>
<script language="javascript" src="/webdesktop/webtop/scripts/RAKdatevalidation.js"></script>
<% 

	String URLDecoderSProcessName=URLDecoder.decode(request.getParameter("ProcessName"));
String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderSProcessName, 1000, true) );
String DecodersProcessName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");

String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("CreditCardNo", request.getParameter("CreditCardNo"), 1000, true) );
	String CreditCardNo = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: CreditCardNo: "+CreditCardNo);
	WriteLog("Integration jsp: CreditCardNo 1: "+request.getParameter("CreditCardNo"));
	
	String URLDecoderProcessCode=URLDecoder.decode(request.getParameter("ProcessCode"));
String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessCode", URLDecoderProcessCode, 1000, true) );
String DecoderProcessCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	
String URLDecoderProcessName=URLDecoder.decode(request.getParameter("ProcessName"));
String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderProcessName, 1000, true) );
String DecoderProcessName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
%>
<script>

function validateDateTime(datetime,sysDate){
	
var objWI_Obj=window.top.wi_object;
var enteredDateTime = datetime;
SpaceAt = enteredDateTime.indexOf(" ");
colunAt = enteredDateTime.indexOf(":");
var userDate=enteredDateTime.substring(0,enteredDateTime.indexOf(" "));
var enteredTime=enteredDateTime.substring(enteredDateTime.indexOf(" ")+1,enteredDateTime.length);
if(!RAKisDate(userDate,"Date & Time of L/S/C")){
	//alert("Invalid date time entered. format should be DD/MM/YY hh:mm(24 Hour)");
	return false;
} else if(SpaceAt!="10" || eval(enteredDateTime.indexOf(" "))!=eval(enteredDateTime.lastIndexOf(" "))){
	alert("Invalid date time entered in Date & Time of L/S/C. format should be DD/MM/YYYY hh:mm(24 Hour)");
	return false;
} else if(colunAt!="13" || enteredDateTime.indexOf(":")!=enteredDateTime.lastIndexOf(":")){
	alert("Invalid date time entered in Date & Time of L/S/C. format should be DD/MM/YYYY hh:mm(24 Hour)");
	return false;
} 
var enteredHH=enteredTime.substring(0,enteredTime.indexOf(":"));
var enteredMM = enteredTime.substring(enteredTime.indexOf(":")+1,enteredTime.length);
if(eval(enteredHH)>23){  
	alert("Invalid value of Hour in Date & Time of L/S/C. Hours can not be more than 23");
	return false;
} else if(eval(enteredMM)>59){
	alert("Invalid value of minute in Date & Time of L/S/C. minutes can not be more than 59");
	return false;
}
var enteredDate = userDate.substring(0,2);
var enteredMonth = userDate.substring(3,5);
var enteredYear = userDate.substring(6,userDate.length);
var todayDate = new Date(sysDate);
var dd = todayDate.getDate();
var mm = todayDate.getMonth()+1;
var yy =todayDate.getFullYear();
var currentHours = todayDate.getHours();
var currentMinutes = todayDate.getMinutes();

if(eval(enteredYear)>eval(yy))
{
	alert("Date in Date & Time of L/S/C field can not be a future date");
	return false;
}
else if(eval(enteredYear)==eval(yy))
{
	if (eval(enteredMonth)>eval(mm))
	{
		alert("Date in Date & Time of L/S/C field can not be a future date");
		return false;
	}
	else if (eval(enteredMonth)==eval(mm))
	{
		if(eval(enteredDate)>eval(dd))
		{
			alert("Date in Date & Time of L/S/C field can not be a future date");
			return false;
		}
		else if (eval(enteredDate)==eval(dd))
		{
			if (eval(enteredHH)>eval(currentHours))
			{
				alert("Date in Date & Time of L/S/C field can not be a future date");
				return false;
			}
			else if (eval(enteredHH)==eval(currentHours))
			{
				if (eval(enteredMM)>eval(currentMinutes))
				{
					alert("Date in Date & Time of L/S/C field can not be a future date");
					return false;				
				}
			}
		}
	}
}

/*
if((eval(enteredDate)>eval(dd) && eval(enteredMonth)>=eval(mm)) || (eval(enteredYear)>eval(yy))){
	alert("Date in Date & Time of L/S/C field can not be a future date");
	alert(eval(enteredDate)+eval(dd));
	alert(eval(enteredMonth)+eval(mm));
	alert(eval(enteredYear)+eval(yy));
	return false;
} else if(((eval(enteredDate)==eval(dd)) && (eval(enteredMonth)==eval(mm)) && (eval(enteredYear)==eval(yy))) 
	&& (eval(enteredHH)>eval(currentHours) || ((eval(enteredHH)==eval(currentHours)) && (eval(enteredMM)>eval(currentMinutes))))){
	alert("Time in Date & Time of L/S/C time field can not be a future time");
	
	return false;
}*/
	return true;
}
function validateEmail(str) {
		var at="@"
		var dot="."
		var lat=str.indexOf(at)
		var lstr=str.length
		var ldot=str.indexOf(dot)
		if (str.indexOf(at)==-1){
		    return false
		}
		for(i=0;i<lstr-1;i++){
			if(str.charAt(i)=='.' && str.charAt(i+1)=='.' ){
				return false;
			}
			if(str.charAt(i)=='@' && str.charAt(i+1)=='@' ){
				return false;
			}
		}
		if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr){
		  return false
		}

		if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr || str.lastIndexOf(dot)==lstr-1){
		  return false
		}

		 if (str.indexOf(at,(lat+1))!=-1){
		   return false
		 }

		 if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
		    return false
		 }

		 if (str.indexOf(dot,(lat+2))==-1){
		   return false
		 }
		
		 if (str.indexOf(" ")!=-1){
		   return false
		 }

 		 return true					
	}

function CheckDataType(cntrlValue,dataType)
{
	if(cntrlValue=="")
		return true;
	switch(dataType){
		case "Numeric":
			regex=/^[0-9]*$/;
			break;
		case "character":
			regex=/^[a-z ]*$/i;
			break;
		case "AlphaNumeric":
			regex=/^[0-9a-z ]*$/i;
			break;
		case "date":
			regex=/^0[1-9]\/[0-9]{2}|1[012]\/[0-9]{2}$/;
			break;
		case "numeric82":			
			regex = /^([0-9]{0,8}\.[0-9]{1,2}|[0-9]{0,8})$/;						
			break;
        case "amount" :
			regex=/^[0-9,.]*$/;
		    break;
		 case "float":
			regex=/^[0-9,.,-]*$/;
		    break;
        case "name":
			regex=/^[a-z,\'_. &]*$/i;
			break;
		case "month":
			regex=/^[0123]*$/i;
			break;
	}
	return regex.test(cntrlValue);
}
var processName='<%=DecoderProcessCode%>';
function validateProcessData()
{

		var dataForm=window.document.forms['dataform'];
			//alert(dataForm.CCI_CCRNNo.value.length);

			//#####################################
			for(var i=0;i<dataForm.elements.length;i++)
			{
				if(dataForm.elements[i].type=="text"||dataForm.elements[i].type=="textarea")
				{
					dataForm.elements[i].value=trim(dataForm.elements[i].value);
				}
			}
			//#####################################
		/*if(trim(dataForm.CCI_CName.value)==""){
			alert("Customer Name is Mandatory");
			dataForm.CCI_CName.focus();
			return false;
		}else if(!CheckDataType(trim(dataForm.CCI_CName.value),"character")){
			alert("Invalid Data in Customer Name Only Characters are allowed ");
			dataForm.CCI_CName.focus();
			return false;
		}
		if(trim(dataForm.CCI_ExpD.value)==""){
			alert("Expiry Date is Mandatory");
			dataForm.CCI_ExpD.focus();
			return false;
		}else if(!CheckDataType(trim(dataForm.CCI_ExpD.value),"date")){
			alert("Invalid Data in Expiry Date Only MM/YY format  is allowed");
			dataForm.CCI_ExpD.focus();
			return false;
		}*/
//----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group			         : Application –Projects
//Product / Project	     : RAKBank 
//Module                 : Update Request
//Author                     : Lalit Kumar
// Date written (DD/MM/YYYY) : 01-March-2008
//Description                : validation for card type .
//------------------------------------------------------------------------------------------------------------------------------------>
		if(processName=="CSR_BT" || processName=="CSR_CCC" ) {
			if(dataForm.CCI_CrdtCN.value.charAt(13)==0 && dataForm.CCI_CT.value == 'L'){
				alert("Current Card Type is not allowed for this request");
				return false;
			}

		}
/*

	Product/Project :       Rak Bank
	Module          :       Credit Card Cheque
	File            :       CCC_SaveDone.js
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/069				   Saurabh Arora
*/
		if(processName=="CSR_CCC")
		{
			if (dataForm.REMARKS.value.length>500)
			{
			alert("Remarks/Reason can't be greater than 500 characters");
			return false;
			}
		}
		if(processName=="CSR_CCB" || processName=="CSR_CBR")
			{
			if(dataForm.CCI_CT.value == 'L'){
				alert("Current Card Type is not allowed for this request");
				return false;
			}

		}
//----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group			         : Application –Projects
//Product / Project	     : RAKBank 
//Module                 : Update Request
//Author                     : Lalit Kumar
// Date written (DD/MM/YYYY) : 06-March-2008
//Description                : validation for card type .
//------------------------------------------------------------------------------------------------------------------------------------>
		if(processName=="CSR_OCC") {
			if(dataForm.request_type.value=="Card Upgrade"){
				if (!(dataForm.CCI_CT.value=='V')) 	{
					alert("Current Card Type is not allowed for this request");
					return false;
				}
			}

			if(dataForm.request_type.value=="Credit Limit Increase" || dataForm.request_type.value=="Change in Standing Instructions" || dataForm.request_type.value=="Card Upgrade" ||dataForm.request_type.value=="Setup Suppl. Card Limit" || dataForm.request_type.value=="Credit Shield" ){
				//alert("cardDetails: "+dataForm.cardDetails.value.split('~')[1]);
				if(dataForm.cardDetails.value.split('~')[1]!=1){
					alert("Only Primary Cards Allowed");
					return false;
				}
			}
			//alert("test card type:"+dataForm.CCI_CT.value);
			if((dataForm.CCI_CT.value == 'L') && (dataForm.request_type.value=="Re-Issue of PIN" ||dataForm.request_type.value=="Card Replacement" ||dataForm.request_type.value=="Credit Limit Increase" ||dataForm.request_type.value=="Early Card Renewal" ||dataForm.request_type.value=="Transaction Dispute"  ||dataForm.request_type.value=="Card Delivery Request" ||dataForm.request_type.value=="Setup Suppl. Card Limit")){
				alert("Current Card Type is not allowed for this request");
					return false;
				
			}

		
			//alert("test :"+dataForm.CCI_CT.value);
		}
/*
	Product/Project :       Rak Bank
	Module          :       Reversal Request
	File            :       CSR_Initiate_center.jsp
	Purpose         :       For supplementary Cards reversal requests should not be accepted
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/034					23/09/2008	 Saurabh Arora
*/
	if(processName=="CSR_RR")
	{	
		if (dataform.CCI_CCRNNo.value.charAt(7)=='0'&&dataform.CCI_CCRNNo.value.charAt(8)=='0')
		{
		}
		else
		{
			alert("Supplementary Cards are not allowed for this request");
			return false;
		}
	}
/*
	Product/Project :       Rak Bank
	Module          :       CBR/CCC/BT
	File            :       CSR_Initiate_center.jsp
	Purpose         :       Supplementary Cards should not be accepted for CBR/CCC/BT requests
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/095					1/6/2009	 Saurabh Arora
*/
	if(processName=="CSR_BT")
	{	
		if (dataform.CCI_CCRNNo.value.charAt(7)=='0'&&dataform.CCI_CCRNNo.value.charAt(8)=='0')
		{
		}
		else
		{
			alert("Supplementary Cards are not allowed for this request");
			return false;
		}
	}
	if(processName=="CSR_CBR")
	{	
		if (dataform.CCI_CCRNNo.value.charAt(7)=='0'&&dataform.CCI_CCRNNo.value.charAt(8)=='0')
		{
		}
		else
		{
			alert("Supplementary Cards are not allowed for this request");
			return false;
		}
	}	
	if(processName=="CSR_CCC")
	{	
		if (dataform.CCI_CCRNNo.value.charAt(7)=='0'&&dataform.CCI_CCRNNo.value.charAt(8)=='0')
		{
		}
		else
		{
			alert("Supplementary Cards are not allowed for this request");
			return false;
		}
	}
		if(trim(dataForm.CCI_ExtNo.value)==""){
			alert("Ext No. is Mandatory");
			dataForm.CCI_ExtNo.focus();
			return false;
		}else if(!CheckDataType(trim(dataForm.CCI_ExtNo.value),"Numeric")){
			alert("Invalid Data in Ext No. Only Numeric are allowed");
			dataForm.CCI_ExtNo.focus();
			return false;
		}else if(trim(dataForm.CCI_ExtNo.value).length < 4){
			alert("Ext No. should be of 4 digits");
			dataForm.CCI_ExtNo.focus();
			return false;
		}
		/*if(trim(dataForm.CCI_CCRNNo.value)==""){
			alert("Card CRN No is Mandatory");
			dataForm.CCI_CCRNNo.focus();
			return false;
		}else if(!CheckDataType(dataForm.CCI_CCRNNo.value,"Numeric")){
			alert("Invalid Data in Card CRN No Only Numerics are allowed");
			dataForm.CCI_CCRNNo.focus();
			return false;
			
		}else if(dataForm.CCI_CCRNNo.value.length < 9){
			alert("Card CRN No should be of nine digits");
			dataForm.CCI_CCRNNo.focus();
			return false;
		}*/
//----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group			         : Application –Projects
//Product / Project	     : RAKBank 
//Module                 : Update Request
//Author                     : Lalit Kumar
// Date written (DD/MM/YYYY) : 28-Feb-2008
//Description                : Source Code field is currently accepting 7 digits only. It must accept 6 as well as 7 digits .
//------------------------------------------------------------------------------------------------------------------------------------>
		if(processName=="CSR_BT"||processName=="CSR_CCC")
		{
			if((dataForm.CCI_SC.value)==""){
				alert("Source Code is Mandatory");
				dataForm.CCI_SC.focus();
				return false;
			}else if(!CheckDataType(dataForm.CCI_SC.value,"AlphaNumeric")){
				alert("Invalid Data in Source Code Only Alphanumerics are allowed");
				dataForm.CCI_SC.focus();
				return false;
			}else if(dataForm.CCI_SC.value.length < 6){
					alert("Source Code should be of six or seven digits");
					dataForm.CCI_SC.focus();
					return false;
				}
		}
		
		/*if(trim(dataForm.CCI_MONO.value)==""){
			alert("Mobile No. is Mandatory");
			dataForm.CCI_MONO.focus();
			return false;
		}else if(!CheckDataType(dataForm.CCI_ExtNo.value,"Numeric")){
			alert("Invalid Data in Mobile No.  Only Numeric are allowed");
			dataForm.CCI_ExtNo.focus();
			return false;
		}
		//**********************
		if(trim(dataForm.CCI_AccInc.value)==""){
			alert("Accessed Income is Mandatory");
			dataForm.CCI_AccInc.focus();
			return false;
		}else if(!CheckDataType(dataForm.CCI_AccInc.value,"numeric82")){
			alert("Invalid Data in Accessed Income  Only Numeric 10,2 are allowed");
			dataForm.CCI_AccInc.focus();
			return false;
		}
		if(trim(dataForm.CCI_CT.value)==""){
			alert("Card Type is Mandatory");
			dataForm.CCI_CT.focus();
			return false;
		}else if(!CheckDataType(dataForm.CCI_CT.value,"character")){
			alert("Invalid Data in Card Type Only Character are allowed");
			dataForm.CCI_CT.focus();
			return false;
		}*/

		if(dataForm.VD_TINCheck.checked==false&&dataForm.VD_MoMaidN.checked==false){
			alert("Atleast one of Verification Details is Mandatory");
			dataForm.VD_TINCheck.focus();
			return false;
		}
		if(dataForm.VD_MoMaidN.checked==true){
			var i=0;
			if(dataForm.VD_POBox.checked==true) i++;
			if(dataForm.VD_Oth.checked==true) i++;
			if(dataForm.VD_MRT.checked==true) i++;
			if(dataForm.VD_StaffId.checked==true) i++;
			if(dataForm.VD_EDC.checked==true) i++;
			if(dataForm.VD_PassNo.checked==true) i++;
			if(dataForm.VD_NOSC.checked==true) i++;
			if(dataForm.VD_SD.checked==true) i++;
			if(dataForm.VD_TELNO.checked==true) i++;
			if(dataForm.VD_DOB.checked==true) i++;
			if(i<4) {			
				alert("Please select at least 4 Random questions");
				dataForm.VD_POBox.focus();
				return false;
			}
			
		}

	if(processName=="CSR_BT")
	{
			if(trim(dataForm.BTD_OBC_CT.options[dataForm.BTD_OBC_CT.selectedIndex].value)==""){
				alert("Card Type is Mandatory");
				dataForm.BTD_OBC_CT.focus();
				return false;
			}
			/*if(dataForm.BTD_OBC_CT.options[dataForm.BTD_OBC_CT.selectedIndex].value.toUpperCase()=="OTHERS"){				
					if(dataForm.BTD_OBC_OBN.options[dataForm.BTD_OBC_OBN.selectedIndex].value==""){
						alert("Other Bank Name is Mandatory");
						dataForm.BTD_OBC_OBN.focus();
						return false;
					}
					if(trim(dataForm.BTD_OBC_OBNO.value)==""){
						alert("Others (Pls. Specify) is Mandatory");
						dataForm.BTD_OBC_OBNO.focus();
						return false;
					}else if(!CheckDataType(replaceAll(dataForm.BTD_OBC_OBNO.value,"-",""),"Numeric")){
						alert("Invalid Data in Others (Pls. Specify) Only Numerics are allowed");
						dataForm.BTD_OBC_OBNO.focus();
						return false;
					}
					if(trim(dataForm.BTD_OBC_OBCNO.value)==""){
						alert("Other Bank Card No. is Mandatory");
						dataForm.BTD_OBC_OBCNO.focus();
						return false;
					}else if(!CheckDataType(replaceAll(dataForm.BTD_OBC_OBCNO.value,"-",""),"Numeric")){
						alert("Invalid Data in Other Bank Card No. Only Numerics are allowed");
						dataForm.BTD_OBC_OBCNO.focus();
						return false;
					}			
			}*/
							
			if(dataForm.BTD_OBC_OBN.options[dataForm.BTD_OBC_OBN.selectedIndex].value==""){
				alert("Other Bank Name is Mandatory");
				dataForm.BTD_OBC_OBN.focus();
				return false;
			}			
			if(dataForm.BTD_OBC_CT.options[dataForm.BTD_OBC_CT.selectedIndex].value.toUpperCase()=="OTHERS"||dataForm.BTD_OBC_OBN.options[dataForm.BTD_OBC_OBN.selectedIndex].value.toUpperCase()=="OTHERS"){									
					if(dataForm.BTD_OBC_OBNO.value==""){
						alert("Others (Pls. Specify) is Mandatory");
						dataForm.BTD_OBC_OBNO.disabled=false;
						dataForm.BTD_OBC_OBNO.focus();
						return false;
					}else if(!CheckDataType(replaceAll(dataForm.BTD_OBC_OBNO.value,"-",""),"character")){
						alert("Invalid Data in Others (Pls. Specify) Only character are allowed");
						dataForm.BTD_OBC_OBNO.focus();
						return false;
					}						
			}
			if(dataForm.BTD_OBC_OBCNO.value==""){
						alert("Other Bank Card No. is Mandatory");
						dataForm.BTD_OBC_OBCNO.focus();
						return false;
			}else if(!CheckDataType(replaceAll(dataForm.BTD_OBC_OBCNO.value,"-",""),"Numeric")){
						alert("Invalid Data in Other Bank Card No. Only Numerics are allowed");
						dataForm.BTD_OBC_OBCNO.focus();
						return false;
			}


			if(trim(dataForm.BTD_OBC_NOOC.value)==""){
				alert("Name on Other Card is Mandatory");
				dataForm.BTD_OBC_NOOC.focus();
				return false;
			}else if(!CheckDataType(dataForm.BTD_OBC_NOOC.value,"name")){
				alert("Invalid Data in Name on Other Card Only characters , .,& , _ and ' are allowed");
				dataForm.BTD_OBC_NOOC.focus();
				return false;
			}
			if(dataForm.BTD_OBC_DT.options[dataForm.BTD_OBC_DT.selectedIndex].value==""){
				alert("Deliver To is Mandatory");
				dataForm.BTD_OBC_DT.focus();
				return false;
			}
			if(dataForm.BTD_OBC_DT.options[dataForm.BTD_OBC_DT.selectedIndex].value.toUpperCase()=="BANK"){
				if(dataForm.BTD_OBC_BN.value==""){
					alert("Branch Name is Mandatory");
					dataForm.BTD_OBC_BN.focus();
					return false;
				}
			}
			/*if((dataForm.BTD_RBC_RBCN1.options[dataForm.BTD_RBC_RBCN1.selectedIndex].value==""&&dataForm.BTD_RBC_RBCN2.options[dataForm.BTD_RBC_RBCN2.selectedIndex].value=="")||(dataForm.BTD_RBC_RBCN2.options[dataForm.BTD_RBC_RBCN2.selectedIndex].value==""&&dataForm.BTD_RBC_RBCN3.options[dataForm.BTD_RBC_RBCN3.selectedIndex].value=="")||(dataForm.BTD_RBC_RBCN3.options[dataForm.BTD_RBC_RBCN3.selectedIndex].value==""&&dataForm.BTD_RBC_RBCN1.options[dataForm.BTD_RBC_RBCN1.selectedIndex].value=="")){
				alert("Any two of the RAKBANK card no.'s is Mandatory");			
				return false;
			}*/

			if(dataForm.BTD_RBC_RBCN1.options[dataForm.BTD_RBC_RBCN1.selectedIndex].value==""&&dataForm.BTD_RBC_RBCN2.options[dataForm.BTD_RBC_RBCN2.selectedIndex].value==""&&dataForm.BTD_RBC_RBCN3.options[dataForm.BTD_RBC_RBCN3.selectedIndex].value==""){
				alert("Any one of the RAKBANK Card no.'s is Mandatory");			
				return false;
			}

		var rakbankcardno1Value=dataForm.BTD_RBC_RBCN1.options[dataForm.BTD_RBC_RBCN1.selectedIndex].value;	
		var rakbankcardno2Value=dataForm.BTD_RBC_RBCN2.options[dataForm.BTD_RBC_RBCN2.selectedIndex].value;	
		var rakbankcardno3Value=dataForm.BTD_RBC_RBCN3.options[dataForm.BTD_RBC_RBCN3.selectedIndex].value;	
		if((rakbankcardno1Value!=""&&rakbankcardno2Value!=""&&rakbankcardno1Value==rakbankcardno2Value)||(rakbankcardno2Value!=""&&rakbankcardno3Value!=""&&rakbankcardno2Value==rakbankcardno3Value)||(rakbankcardno3Value!=""&&rakbankcardno1Value!=""&&rakbankcardno3Value==rakbankcardno1Value)){
				alert("RAKBANK Card no.'s Should be unique");			
				return false;
			}
//alert("klkll"+dataForm.BTD_RBC_CT1.value);
	
			//BTD_RBC_RBCN1 any two are mandatory
			if(dataForm.BTD_RBC_RBCN1.options[dataForm.BTD_RBC_RBCN1.selectedIndex].value!="")
			{
				if(trim(dataForm.BTD_RBC_CT1.value)==""){
					alert("Card Type is Mandatory");
					dataForm.BTD_RBC_CT1.focus();
					return false;
				}
				/*else if(!CheckDataType(dataForm.BTD_RBC_CT1.value,"character")){
					alert("Invalid Data in Card Type Only characters are allowed");
					dataForm.BTD_RBC_CT1.focus();
					return false;
				}*/
				if(trim(dataForm.BTD_RBC_ExpD1.value)==""){
					alert("Expiry Date is Mandatory");
					dataForm.BTD_RBC_ExpD1.focus();
					return false;
				}else if(!CheckDataType(dataForm.BTD_RBC_ExpD1.value,"date")){
					alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
					dataForm.BTD_RBC_ExpD1.focus();
					return false;
				}
				if(trim(dataForm.BTD_RBC_BTA1.value)==""){
					alert("BT Amount(AED) is Mandatory");
					dataForm.BTD_RBC_BTA1.focus();
					return false;
				}else if(!CheckDataType(replaceAll(dataForm.BTD_RBC_BTA1.value,",",""),"numeric82")){
					alert("Invalid Data in BT Amount(AED) Only Numerics(10,2) are allowed");
					dataForm.BTD_RBC_BTA1.focus();
					return false;
				}
				if(trim(dataForm.BTD_RBC_AppC1.value)==""){
					alert("Approval Code is Mandatory");
					dataForm.BTD_RBC_AppC1.focus();
					return false;
				}else if(!CheckDataType(dataForm.BTD_RBC_AppC1.value,"Numeric")){
					alert("Invalid Data in Approval Code Only Numeric value's are allowed");
					dataForm.BTD_RBC_AppC1.focus();
					return false;
				}
				
			}
			if(dataForm.BTD_RBC_RBCN2.options[dataForm.BTD_RBC_RBCN2.selectedIndex].value!="")
			{
				if(trim(dataForm.BTD_RBC_CT2.value)==""){
					alert("Card Type is Mandatory");
					dataForm.BTD_RBC_CT2.focus();
					return false;
				}/*else if(!CheckDataType(dataForm.BTD_RBC_CT2.value,"character")){
					alert("Invalid Data in Card Type Only characters are allowed");
					dataForm.BTD_RBC_CT2.focus();
					return false;
				}*/
				if(trim(dataForm.BTD_RBC_ExpD2.value)==""){
					alert("Expiry Date is Mandatory");
					dataForm.BTD_RBC_ExpD2.focus();
					return false;
				}else if(!CheckDataType(dataForm.BTD_RBC_ExpD2.value,"date")){
					alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
					dataForm.BTD_RBC_ExpD2.focus();
					return false;
				}
				if(trim(dataForm.BTD_RBC_BTA2.value)==""){
					alert("BT Amount(AED) is Mandatory");
					dataForm.BTD_RBC_BTA2.focus();
					return false;
				}else if(!CheckDataType(replaceAll(dataForm.BTD_RBC_BTA2.value,",",""),"numeric82")){
					alert("Invalid Data in BT Amount(AED) Only Numerics(10,2) are allowed");
					dataForm.BTD_RBC_BTA2.focus();
					return false;
				}
				if(trim(dataForm.BTD_RBC_AppC2.value)==""){
					alert("Approval Code is Mandatory");
					dataForm.BTD_RBC_AppC2.focus();
					return false;
				}else if(!CheckDataType(dataForm.BTD_RBC_AppC2.value,"Numeric")){
					alert("Invalid Data in Approval Code Only Numeric value's are allowed");
					dataForm.BTD_RBC_AppC2.focus();
					return false;
				}
			}
			if(dataForm.BTD_RBC_RBCN3.options[dataForm.BTD_RBC_RBCN3.selectedIndex].value!="")
			{
				if(dataForm.BTD_RBC_CT3.value==""){
					alert("Card Type is Mandatory");
					dataForm.BTD_RBC_CT3.focus();
					return false;
				}/*else if(!CheckDataType(dataForm.BTD_RBC_CT3.value,"character")){
					alert("Invalid Data in Card Type Only characters are allowed");
					dataForm.BTD_RBC_CT3.focus();
					return false;
				}*/
				if(dataForm.BTD_RBC_ExpD3.value==""){
					alert("Expiry Date is Mandatory");
					dataForm.BTD_RBC_ExpD3.focus();
					return false;
				}else if(!CheckDataType(dataForm.BTD_RBC_ExpD3.value,"date")){
					alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
					dataForm.BTD_RBC_ExpD3.focus();
					return false;
				}
				if(dataForm.BTD_RBC_BTA3.value==""){
					alert("BT Amount(AED) is Mandatory");
					dataForm.BTD_RBC_BTA3.focus();
					return false;
				}else if(!CheckDataType(replaceAll(dataForm.BTD_RBC_BTA3.value,",",""),"numeric82")){
					alert("Invalid Data in BT Amount(AED) Only Numerics(10,2) are allowed");
					dataForm.BTD_RBC_BTA3.focus();
					return false;
				}
				if(dataForm.BTD_RBC_AppC3.value==""){
					alert("Approval Code is Mandatory");
					dataForm.BTD_RBC_AppC3.focus();
					return false;
				}else if(!CheckDataType(dataForm.BTD_RBC_AppC3.value,"Numeric")){
					alert("Invalid Data in Approval Code Only Numeric value's are allowed");
					dataForm.BTD_RBC_AppC3.focus();
					return false;
				}
			}


/*
	Product/Project :       Rak Bank
	Module          :       Balance Transfer
	File            :       CSR_Initiate_center.jsp
	Purpose         :       Approval code should be mandated to 6 digits. It is currently accepting 5 digits
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/005					02/09/2008	 Saurabh Arora

*/
			if (dataForm.BTD_RBC_AppC1.value=="")
			{
			}
			else if (dataForm.BTD_RBC_AppC1.value.length!=6)
			{
				alert("Approval Code should be of 6 digits");
				dataForm.BTD_RBC_AppC1.focus();
				return false;
			}
			if (dataForm.BTD_RBC_AppC2.value=="")
			{
			}
			else if (dataForm.BTD_RBC_AppC2.value.length!=6)
			{
				alert("Approval Code should be of 6 digits");
				dataForm.BTD_RBC_AppC2.focus();
				return false;
			}
			if (dataForm.BTD_RBC_AppC3.value=="")
			{
			}
			else if (dataForm.BTD_RBC_AppC3.value.length!=6)
			{
				alert("Approval Code should be of 6 digits");
				dataForm.BTD_RBC_AppC3.focus();
				return false;
			}			


			var sumvar="0";
			if(dataForm.BTD_RBC_BTA1.value!="")	
				sumvar=parseFloat(sumvar)+parseFloat(replaceAll(dataForm.BTD_RBC_BTA1.value,",",""));	
			if(dataForm.BTD_RBC_BTA2.value!="")	
				sumvar=parseFloat(sumvar)+parseFloat(replaceAll(dataForm.BTD_RBC_BTA2.value,",",""));	
			if(dataForm.BTD_RBC_BTA3.value!="")	
				sumvar=parseFloat(sumvar)+parseFloat(replaceAll(dataForm.BTD_RBC_BTA3.value,",",""));	
			//alert(sumvar);
			//alert((parseFloat(dataForm.BTD_RBC_BTA1.value)+parseFloat(dataForm.BTD_RBC_BTA2.value)+parseFloat(dataForm.BTD_RBC_BTA3.value)));
			//alert((parseFloat(dataForm.BTD_RBC_BTA1.value)+parseFloat(dataForm.BTD_RBC_BTA2.value)+parseFloat(dataForm.BTD_RBC_BTA3.value))<parseFloat("1000.00"));
			if(sumvar<parseFloat("1000.00"))
			{
				alert("Sum of BT Amount(AED)'s should be greater than or equal to 1000");
				return false;
			}	
			if(dataForm.BTD_OBC_DT.options[dataForm.BTD_OBC_DT.selectedIndex].value.toUpperCase()=="OTHERS"){
				if(dataForm.BTD_RBC_RR.value==""){
					alert("Remarks/ Reason is Mandatory");
					dataForm.BTD_RBC_RR.focus();
					return false;
				}
/*

	Product/Project :       Rak Bank
	Module          :       Balance Transfer
	File            :       BT_SaveDone.js
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/068				   Saurabh Arora
*/
				if(dataForm.BTD_RBC_RR.value.length>500)
				{		
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.BTD_RBC_RR.focus();
					return false;
				}
			}
	}

	   if(processName=="CSR_CCC")

        {
			
			
			if(dataForm.BANEFICIARY_NAME.value==""){
				alert("Beneficiary Name is Mandatory");
				dataForm.BANEFICIARY_NAME.focus();
				return false;

			}else if(!CheckDataType(dataForm.BANEFICIARY_NAME.value,"name")){
				alert("Invalid Data in Beneficiary Name Only characters, ., and _ are allowed");
				dataForm.BANEFICIARY_NAME.focus();
				return false;
			}

			if(dataForm.DELIVERTO.options[dataForm.DELIVERTO.selectedIndex].value==""){
				alert("Deliver To is Mandatory");
				dataForm.DELIVERTO.focus();
				return false;
			}
			if(dataForm.DELIVERTO.options[dataForm.DELIVERTO.selectedIndex].value.toUpperCase()=="BANK"){
				if(dataForm.BRANCHCODE.value==""){
					alert("Branch Name is Mandatory");
					dataForm.BRANCHCODE.focus();
					return false;
				}
			}
			/*if((dataForm.CARDNO1.options[dataForm.CARDNO1.selectedIndex].value==""&&dataForm.CARDNO2.options[dataForm.CARDNO2.selectedIndex].value=="")||(dataForm.CARDNO2.options[dataForm.CARDNO2.selectedIndex].value==""&&dataForm.CARDNO3.options[dataForm.CARDNO3.selectedIndex].value=="")||(dataForm.CARDNO3.options[dataForm.CARDNO3.selectedIndex].value==""&&dataForm.CARDNO1.options[dataForm.CARDNO1.selectedIndex].value=="")){
				alert("Any two of the RAKBANK card no.'s is Mandatory");			
				return false;
			}

			if((dataForm.CARDNO1.options[dataForm.CARDNO1.selectedIndex].value==dataForm.CARDNO2.options[dataForm.CARDNO2.selectedIndex].value)||(dataForm.CARDNO2.options[dataForm.CARDNO2.selectedIndex].value==dataForm.CARDNO3.options[dataForm.CARDNO3.selectedIndex].value)||(dataForm.CARDNO3.options[dataForm.CARDNO3.selectedIndex].value==dataForm.CARDNO1.options[dataForm.CARDNO1.selectedIndex].value)){
				alert("RAKBANK card no.'s Should be unique");			
				return false;
			}*/

			if(dataForm.CARDNO1.options[dataForm.CARDNO1.selectedIndex].value==""&&dataForm.CARDNO2.options[dataForm.CARDNO2.selectedIndex].value==""&&dataForm.CARDNO3.options[dataForm.CARDNO3.selectedIndex].value==""){
				alert("Any one of the RAKBANK Card no.'s is Mandatory");			
				return false;
			}

			var rakbankcardno1Value=dataForm.CARDNO1.options[dataForm.CARDNO1.selectedIndex].value;	
			var rakbankcardno2Value=dataForm.CARDNO2.options[dataForm.CARDNO2.selectedIndex].value;	
			var rakbankcardno3Value=dataForm.CARDNO3.options[dataForm.CARDNO3.selectedIndex].value;	
			//change by stutee.mishra to handle browser compatibility.
			if(rakbankcardno1Value == '--select--')
				rakbankcardno1Value = '';
			if(rakbankcardno2Value == '--select--')
				rakbankcardno2Value = '';
			if(rakbankcardno3Value == '--select--')
				rakbankcardno3Value = '';
			//ends here.
			if((rakbankcardno1Value!=""&&rakbankcardno2Value!=""&&rakbankcardno1Value==rakbankcardno2Value)||(rakbankcardno2Value!=""&&rakbankcardno3Value!=""&&rakbankcardno2Value==rakbankcardno3Value)||(rakbankcardno3Value!=""&&rakbankcardno1Value!=""&&rakbankcardno3Value==rakbankcardno1Value)){
					alert("RAKBANK Card no.'s Should be unique");			
					return false;
				}

			//BTD_RBC_RBCN1 any two are mandatory
			if(dataForm.CARDNO1.options[dataForm.CARDNO1.selectedIndex].value!="")
			{
				if(dataForm.CARDTYPE1.value==""){
					alert("Card Type is Mandatory");
					dataForm.CARDTYPE1.focus();
					return false;
				}
				/*else if(!CheckDataType(dataForm.CARDTYPE1.value,"character")){
					alert("Invalid Data in Card Type Only characters are allowed");
					dataForm.CARDTYPE1.focus();
					return false;
				}*/
				if(dataForm.CARDEXPIRY_DATE1.value==""){
					alert("Expiry Date is Mandatory");
					dataForm.CARDEXPIRY_DATE1.focus();
					return false;
				}else if(!CheckDataType(dataForm.CARDEXPIRY_DATE1.value,"date")){
					alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
					dataForm.CARDEXPIRY_DATE1.focus();
					return false;
				}
				if(dataForm.CHQ_AMOUNT1.value==""){
					alert("Cheque Amount(AED) is Mandatory");
					dataForm.CHQ_AMOUNT1.focus();
					return false;
				}else if(!CheckDataType(dataForm.CHQ_AMOUNT1.value,"amount")){
					alert("Invalid Data in Cheque Amount(AED) Only Numerics are allowed");
					dataForm.CHQ_AMOUNT1.focus();
					return false;
				}
				if(dataForm.ApprovalCode1.value==""){
					alert("Approval Code is Mandatory");
					dataForm.ApprovalCode1.focus();
					return false;
				}else if(!CheckDataType(dataForm.ApprovalCode1.value,"Numeric")){
					alert("Invalid Data in Approval Code Only Numeric value's are allowed");
					dataForm.ApprovalCode1.focus();
					return false;
				}
			}
			if(rakbankcardno2Value!="")
			{
				if(dataForm.CARDTYPE2.value==""){
					alert("Card Type is Mandatory");
					dataForm.CARDTYPE2.focus();
					return false;
				}
				/*else if(!CheckDataType(dataForm.CARDTYPE2.value,"character")){
					alert("Invalid Data in Card Type Only characters are allowed");
					dataForm.CARDTYPE2.focus();
					return false;
				}*/
				if(dataForm.CARDEXPIRY_DATE2.value==""){
					alert("Expiry Date is Mandatory");
					dataForm.CARDEXPIRY_DATE2.focus();
					return false;
				}else if(!CheckDataType(dataForm.CARDEXPIRY_DATE2.value,"date")){
					alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
					dataForm.CARDEXPIRY_DATE2.focus();
					return false;
				}
				if(dataForm.CHQ_AMOUNT2.value==""){
					alert("Cheque Amount(AED) is Mandatory");
					dataForm.CHQ_AMOUNT2.focus();
					return false;
				}else if(!CheckDataType(dataForm.CHQ_AMOUNT2.value,"amount")){
					alert("Invalid Data in Cheque Amount(AED) Only Numerics are allowed");
					dataForm.CHQ_AMOUNT2.focus();
					return false;
				}
				if(dataForm.ApprovalCode2.value==""){
					alert("Approval Code is Mandatory");
					dataForm.ApprovalCode2.focus();
					return false;
				}else if(!CheckDataType(dataForm.ApprovalCode2.value,"Numeric")){
					alert("Invalid Data in Approval Code Only Numeric value's are allowed");
					dataForm.ApprovalCode2.focus();
					return false;
				}
			}
			if(rakbankcardno3Value!="")
			{
				if(dataForm.CARDTYPE3.value==""){
					alert("Card Type is Mandatory");
					dataForm.CARDTYPE3.focus();
					return false;
				}
				/*else if(!CheckDataType(dataForm.CARDTYPE3.value,"character")){
					alert("Invalid Data in Card Type Only characters are allowed");
					dataForm.CARDTYPE3.focus();
					return false;
				}*/
				if(dataForm.CARDEXPIRY_DATE3.value==""){
					alert("Expiry Date is Mandatory");
					dataForm.CARDEXPIRY_DATE3.focus();
					return false;
				}else if(!CheckDataType(dataForm.CARDEXPIRY_DATE3.value,"date")){
					alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
					dataForm.CARDEXPIRY_DATE3.focus();
					return false;
				}
				if(dataForm.CHQ_AMOUNT3.value==""){
					alert("Cheque Amount(AED) is Mandatory");
					dataForm.CHQ_AMOUNT3.focus();
					return false;
				}else if(!CheckDataType(dataForm.CHQ_AMOUNT3.value,"amount")){
					alert("Invalid Data in Cheque Amount(AED) Only Numerics are allowed");
					dataForm.CHQ_AMOUNT3.focus();
					return false;
				}
				if(dataForm.ApprovalCode3.value==""){
					alert("Approval Code is Mandatory");
					dataForm.ApprovalCode3.focus();
					return false;
				}else if(!CheckDataType(dataForm.ApprovalCode3.value,"Numeric")){
					alert("Invalid Data in Approval Code Only Numeric value's are allowed");
					dataForm.ApprovalCode3.focus();
					return false;
				}
			}

/*
	Product/Project :       Rak Bank
	Module          :       Credit Card Cheque
	File            :       CSR_Initiate_center.jsp
	Purpose         :       Approval code should be mandated to 6 digits. It is currently accepting 5 digits
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/006					02/09/2008	 Saurabh Arora

*/

				if (dataForm.ApprovalCode1.value=="")
				{
				}
				else if (dataForm.ApprovalCode1.value.length!=6)
				{
					alert("Approval Code should be of 6 digits");
					dataForm.ApprovalCode1.focus();
					return false;
				}
				if (dataForm.ApprovalCode2.value=="")
				{
				}
				else if (dataForm.ApprovalCode2.value.length!=6)
				{
					alert("Approval Code should be of 6 digits");
					dataForm.ApprovalCode2.focus();
					return false;
				}
				if (dataForm.ApprovalCode3.value=="")
				{
				}
				else if (dataForm.ApprovalCode3.value.length!=6)
				{
					alert("Approval Code should be of 6 digits");
					dataForm.ApprovalCode3.focus();
					return false;
				}	
				

			var sumvar="0";
			if(dataForm.CHQ_AMOUNT1.value!="")	
				sumvar=parseFloat(sumvar)+parseFloat(replaceAll(dataForm.CHQ_AMOUNT1.value,",",""));	
			if(dataForm.CHQ_AMOUNT2.value!="")	
				sumvar=parseFloat(sumvar)+parseFloat(replaceAll(dataForm.CHQ_AMOUNT2.value,",",""));	
			if(dataForm.CHQ_AMOUNT3.value!="")	
				sumvar=parseFloat(sumvar)+parseFloat(replaceAll(dataForm.CHQ_AMOUNT3.value,",",""));	
			
			if(sumvar<parseFloat("1000.00"))
			{
				alert("Sum of Cheque Amount(AED)'s should be greater than or equal to 1000");
				return false;
			}
			if(dataForm.DELIVERTO.options[dataForm.DELIVERTO.selectedIndex].value.toUpperCase()=="OTHERS"){
				if(dataForm.REMARKS.value==""){
					alert("Remarks/ Reason is Mandatory");
					dataForm.REMARKS.focus();
					return false;
				}
			}			
	     }


 if(processName=="CSR_CBR")
        {	
			if(dataForm.CASHBACK_TYPE.options[dataForm.CASHBACK_TYPE.selectedIndex].value==""){
				alert("Type is Mandatory");
				dataForm.CASHBACK_TYPE.focus();
				return false;
			}
			if(dataForm.CASHBACK_TYPE.options[dataForm.CASHBACK_TYPE.selectedIndex].value.toUpperCase()=="REDEMPTION"){
				if(dataForm.AMOUNT.value==""){
					alert("Amount is Mandatory");
					dataForm.AMOUNT.focus();
					return false;
				}
				if(dataForm.AMOUNT.value<parseFloat("100.00"))
				{
					alert("Amount should be greater than 100");
					return false;
				}
			}
			if(dataForm.CASHBACK_TYPE.options[dataForm.CASHBACK_TYPE.selectedIndex].value.toUpperCase()=="UN-ENROLLMENT"){
				if(dataForm.REMARKS.value==""){
					alert("Remarks/ Reason is Mandatory");
					dataForm.REMARKS.focus();
					return false;
				}
			}
			if(dataForm.REMARKS.value.length>500)
				{		
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.REMARKS.focus();
					return false;
				}
	     }
/*  Start Code for card blocking*/
if(processName=="CSR_CCB")

        {	
			try{
				
			if(dataForm.REASON_HOTLIST.value==""){
				alert("Reson for hot listing is Mandatory");
				dataForm.REASON_HOTLIST.focus();
				return false;
			}
			
			
			if((dataForm.REASON_HOTLIST.options[dataForm.REASON_HOTLIST.selectedIndex].value=="Others")&& (dataForm.HOST_OTHER.value=="")){
				alert("Others(pls) specify is mandatory");
				dataForm.HOST_OTHER.focus();
				return false;
			}
		
			if((dataForm.REASON_HOTLIST.options[dataForm.REASON_HOTLIST.selectedIndex].value=="Others")&& 				(dataForm.HOST_OTHER.value!="") && (!space_Check(dataForm.HOST_OTHER.value))){
				alert("Invalid Data in Others (Pls. Specify). Only spaces are not allowed");
				dataForm.HOST_OTHER.focus();
				return false;
			} 
	if((dataForm.REASON_HOTLIST.options[dataForm.REASON_HOTLIST.selectedIndex].value=="Lost")||
		(dataForm.REASON_HOTLIST.options[dataForm.REASON_HOTLIST.selectedIndex].value=="Stolen")||
		(dataForm.REASON_HOTLIST.options[dataForm.REASON_HOTLIST.selectedIndex].value=="Captured")||
		(dataForm.REASON_HOTLIST.options[dataForm.REASON_HOTLIST.selectedIndex].value=="Blocked"))
		{
				if(dataForm.CB_DateTime.value==""){
					alert("Date and Time is mandatory");
					dataForm.CB_DateTime.focus();
					return false;
				}
				else if(!validateDateTime(dataForm.CB_DateTime.value,dataForm.sysDate_CCB.value)){
					 dataForm.CB_DateTime.focus();
					 return false;
		         }
				if(dataForm.PLACE.value==""){
					alert("Place is mandatory");
					dataForm.PLACE.focus();
					return false;
				}
								
			} 
			if(dataForm.CB_DateTime.value!=""){
				if(!validateDateTime(dataForm.CB_DateTime.value,dataForm.sysDate_CCB.value)){
					 dataForm.CB_DateTime.focus();
					 return false;
		         }
			}
			if((dataForm.REASON_HOTLIST.options[dataForm.REASON_HOTLIST.selectedIndex].value=="Email From")&& (dataForm.EMAIL_FROM.value=="")){
				alert("Email from is mandatory");
				dataForm.EMAIL_FROM.focus();
				return false;
			}
			if(dataForm.EMAIL_FROM.value!=""){
				if(!validateEmail(dataForm.EMAIL_FROM.value)){
					 alert("Please enter valid email address");
					 dataForm.EMAIL_FROM.focus();
					 return false;
		         }
			}
			if((dataForm.REASON_HOTLIST.options[dataForm.REASON_HOTLIST.selectedIndex].value=="Wrong Embossing Name")&& (dataForm.EMBOSING_NAME.value=="")){
				alert("Embossing Name is mandatory");
				dataForm.EMBOSING_NAME.focus();
				return false;
			}
			if(dataForm.EMBOSING_NAME.value!="" && (!CheckDataType(dataForm.EMBOSING_NAME.value,"character"))){
				alert("Invalid Embossing Name is entered. Only Characters are allowed");
				dataForm.EMBOSING_NAME.focus();
				return false;
			}

			if(dataForm.AVAILABLE_BALANCE.value==""){
				alert("Available balance is mandatory");
				dataForm.AVAILABLE_BALANCE.focus();
				return false;
			}

			else if(!CheckDataType(replaceAll(replaceAll(dataForm.AVAILABLE_BALANCE.value,",",""),"-",""),"numeric82")){
					alert("Invalid Data in Available balance Only Numerics(10,2) are allowed");
					dataForm.AVAILABLE_BALANCE.focus();
					return false;
				}
			
			if(dataForm.C_STATUS_B_BLOCK.value==""){
				alert("Card status before block is Mandatory");
				dataForm.C_STATUS_B_BLOCK.focus();
				return false;
			}
			else if(!CheckDataType(dataForm.C_STATUS_B_BLOCK.value,"Numeric")){
					alert("Invalid Data in Card status before block. Only Numeric are allowed");
					dataForm.C_STATUS_B_BLOCK.focus();
					return false;
			}
			

			if(dataForm.C_STATUS_A_BLOCK.value==""){
				alert("Card status after block is Mandatory");
				dataForm.C_STATUS_A_BLOCK.focus();
				return false;
			}
			else if(!CheckDataType(dataForm.C_STATUS_A_BLOCK.value,"Numeric")){
					alert("Invalid Data in Card status after block. Only Numeric are allowed");
					dataForm.C_STATUS_A_BLOCK.focus();
					return false;
			}
			
/*
	Product/Project :       Rak Bank
	Module          :       Credit Card Blocking Request
	File            :       CSR_Initiate_center.jsp
	Purpose         :       Approval code should be mandated to 6 digits. It is currently accepting 5 digits
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/008					03/09/2008	 Saurabh Arora
*/
			if(dataForm.C_STATUS_A_BLOCK.value==dataForm.C_STATUS_B_BLOCK.value)
			{
				alert("Card status before block and Card status after block cannot be same");
				dataForm.C_STATUS_B_BLOCK.focus();
				return false;
			}

/*
	Product/Project :       Rak Bank
	Module          :       CCB
	File            :       CSR_Initiate_center.jsp
	Purpose         :       CCB blocking requests should not accept the Value 00 under ‘Card Status after blocking’
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/096					1/6/2009	 Saurabh Arora
*/			if(dataForm.C_STATUS_A_BLOCK.value=="00")
			{
				alert("Card status After Block cannot be 00");
				dataForm.C_STATUS_A_BLOCK.focus();
				return false;
			}
			
			if(dataForm.ACTION_TAKEN.value=="")
			{
					alert("Action Taken is mandatory");
					dataForm.ACTION_TAKEN.focus();
					return false;
			}
			if((dataForm.ACTION_TAKEN.options[dataForm.ACTION_TAKEN.selectedIndex].value=="Issue Replacement")&& (dataForm.DELIVER_TO.value=="")){
				alert("Deliver to is mandatory");
				dataForm.DELIVER_TO.focus();
				return false;
			}
			if((dataForm.ACTION_TAKEN.options[dataForm.ACTION_TAKEN.selectedIndex].value=="Others")&& (dataForm.ACTION_OTHER.value=="")){
				alert("Others (Pls specify) is mandatory");
				dataForm.ACTION_OTHER.focus();
				return false;
			}
			if((dataForm.ACTION_TAKEN.options[dataForm.ACTION_TAKEN.selectedIndex].value=="Others")&& (dataForm.ACTION_OTHER.value!="") && (!space_Check(dataForm.ACTION_OTHER.value))){
				alert("Invalid Data in Others (Pls. Specify). Only spaces are not allowed");
				dataForm.ACTION_OTHER.focus();
				return false;
			}

			if((dataForm.DELIVER_TO.options[dataForm.DELIVER_TO.selectedIndex].value=="International Address")&& (dataForm.REMARKS.value=="")){
				alert("Remarks/Reason is mandatory");
				dataForm.REMARKS.focus();
				return false;
			}
/*

	Product/Project :       Rak Bank
	Module          :       Credit Card Blocking Request
	File            :       CSR_Initiate_center.jsp
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/070				   Saurabh Arora
*/
			if(dataForm.REMARKS.value.length>500)
				{		
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.REMARKS.focus();
					return false;
				}

			if(dataForm.DELIVER_TO.options[dataForm.DELIVER_TO.selectedIndex].value=="Bank")
				{
				if(dataForm.BRANCH_NAME.value=="")
					{
				
				//dataForm.BRANCH_NAME.disabled=false;
				alert("Branch Name is mandatory");
				dataForm.BRANCH_NAME.focus();
				return false;
				}
			}
			var amount =  dataForm.AVAILABLE_BALANCE.value;
			dataForm.AVAILABLE_BALANCE.value = replaceAll(amount,",","")

			}catch(e){
				alert("Exception: "+e);
			}
			return true;
		} 


/* end   */



/* Misc*/
     if(processName=="CSR_MR")
	{
		  if(dataForm.REMARKS.value==""){
				alert("Remarks/Reason is Mandatory.");
				dataForm.REMARKS.focus();
				return false;
			}
/*

	Product/Project :       Rak Bank
	Module          :       Miscellaneous Requests
	File            :       CSR_Initiate_center.jsp
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/072				   Saurabh Arora
*/
			if(dataForm.REMARKS.value.length>500)
				{		
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.REMARKS.focus();
					return false;
				}
			else if(!space_Check(dataForm.REMARKS.value)){
			alert("Invalid Data in REMARKS. Only spaces are not allowed");
			dataForm.REMARKS.focus();
			return false;
			} 

	}




/*End*/


	if(processName=="CSR_RR")
	{	
			if(dataForm.RRD_RFC.options[dataForm.RRD_RFC.selectedIndex].value=="")
			{
			alert("Reversal For is Mandatory");
			dataForm.RRD_RFC.focus();
			return false;
			}
			if(dataForm.RRD_RFC.options[dataForm.RRD_RFC.selectedIndex].value.toUpperCase()=="OTHERS PLS. SPECIFY"&&dataForm.RRD_RFC_OTH.value=="")
			{
			alert("Others (Pls. Specify) is Mandatory");
			dataForm.RRD_RFC_OTH.disabled=false;
			dataForm.RRD_RFC_OTH.focus();
			return false;
			}
			if(dataForm.RRD_RR.value=="")
			{
			alert("Remarks/Reasons (if any). is Mandatory");
			dataForm.RRD_RR.focus();
			return false;
			}
	}

	if(processName=="CSR_OCC")
	{		
		var srequest_type=dataForm.request_type.options[dataForm.request_type.selectedIndex].value;
			if(srequest_type=="")
			{
			alert("Process Name is Mandatory");
			dataForm.request_type.focus();
			return false;
			}
			if(srequest_type=="Re-Issue of PIN")
			{	
				if(dataForm.oth_rip_reason.options[dataForm.oth_rip_reason.selectedIndex].value=="")
				{					
					alert("Reason is Mandatory");
					dataForm.oth_rip_reason.focus();
					return false;
				}
				if(dataForm.oth_rip_DC.options[dataForm.oth_rip_DC.selectedIndex].value=="")
				{					
					alert("Delivery Channel is Mandatory");
					dataForm.oth_rip_DC.focus();
					return false;
				}				if(dataForm.oth_rip_DC.options[dataForm.oth_rip_DC.selectedIndex].value.toUpperCase()=="BRANCH"&&dataForm.oth_rip_BN.options[dataForm.oth_rip_BN.selectedIndex].value=="")
				{					
					alert("Branch Name is Mandatory");
					dataForm.oth_rip_BN.focus();
					return false;
				}
				if(dataForm.oth_rip_BN.options[dataForm.oth_rip_BN.selectedIndex].text.toUpperCase()=="OTHERS"&&dataForm.oth_rip_RR.value=="")
				{					
					alert("Remarks/Reasons is Mandatory");
					dataForm.oth_rip_RR.focus();
					return false;
				}
/* 
	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       CSR_Initiate_Center.jsp
	Purpose         :       Additional field ‘Card Delivery Option’ needs to be added at the initiation work step
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/057								 Saurabh Arora
*/
				if(dataForm.oth_rip_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_rip_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Card Replacement")
			{	
				if(dataForm.oth_cr_reason.options[dataForm.oth_cr_reason.selectedIndex].value=="")
				{					
					alert("Reason is Mandatory");
					dataForm.oth_cr_reason.focus();
					return false;
				}
				if(dataForm.oth_cr_reason.options[dataForm.oth_cr_reason.selectedIndex].text.toUpperCase()=="OTHERS"&&dataForm.oth_cr_OPS.value=="")
				{					
					alert("Others Pls Specify is Mandatory");
					dataForm.oth_cr_OPS.focus();
					return false;
				}	
				if(dataForm.oth_cr_DC.options[dataForm.oth_cr_DC.selectedIndex].value.toUpperCase()=="")
				{					
					alert("Delivery Channel is Mandatory");
					dataForm.oth_cr_DC.focus();
					return false;
				}
				if(dataForm.oth_cr_DC.options[dataForm.oth_cr_DC.selectedIndex].value.toUpperCase()=="BRANCH"&&dataForm.oth_cr_BN.options[dataForm.oth_cr_BN.selectedIndex].value=="")
				{					
					alert("Branch Name is Mandatory");
					dataForm.oth_cr_BN.focus();
					return false;
				}
				if(dataForm.oth_cr_BN.options[dataForm.oth_cr_BN.selectedIndex].text.toUpperCase()=="OTHERS"&&dataForm.oth_cr_RR.value=="")
				{					
					alert("Remarks/Reasons is Mandatory");
					dataForm.oth_cr_RR.focus();
					return false;
				}
/* 
	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       CSR_Initiate_Center.jsp
	Purpose         :       Additional field ‘Card Delivery Option’ needs to be added at the initiation work step
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/057								 Saurabh Arora
*/
				if(dataForm.oth_cr_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_cr_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Credit Limit Increase")
			{	
				if(dataForm.oth_cli_type.options[dataForm.oth_cli_type.selectedIndex].value=="")
				{					
					alert("Type is Mandatory");
					dataForm.oth_cli_type.focus();
					return false;
				}	if(dataForm.oth_cli_type.options[dataForm.oth_cli_type.selectedIndex].value.toUpperCase()=="TEMPORARY"&&dataForm.oth_cli_months.value=="")
				{					
					alert("Months is Mandatory");
					dataForm.oth_cli_months.focus();
					return false;
				}
			
				if(dataForm.oth_cli_months.value!=""&&!CheckDataType(dataForm.oth_cli_months.value,"month"))
				{					
					alert("Invalid data in Months Only 0,1,2,3 are allowed. ");
					dataForm.oth_cli_months.focus();
					return false;
				}	
/* 
	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       CSR_Initiate_Center.jsp
	Purpose         :       Additional field ‘Card Delivery Option’ needs to be added at the initiation work step
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/057								 Saurabh Arora
*/
				if(dataForm.oth_cli_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_cli_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Early Card Renewal")
			{	
				//## past date validation required

				if(dataForm.oth_ecr_RB.value=="")
				{					
					alert("Required by date is Mandatory");
					dataForm.oth_ecr_RB.focus();
					return false;
				}	
				//alert(checkMonthDiff());
				//################################################
				if(dataForm.oth_ecr_RB.value!="")
				{
					var month1=dataForm.CCI_ExpD.value.substring(0,2);
					var year1=dataForm.CCI_ExpD.value.substring(3,5);

					var month2=dataForm.oth_ecr_RB.value.substring(0,2);
					var year2=dataForm.oth_ecr_RB.value.substring(3,5);

					var dt1=new Date("20"+year1,month1-1);
					var dt2=new Date("20"+year2,month2-1);

					if(dt2>dt1)
					{
						alert("Required By date can't be greater than expiry date");
						dataForm.oth_ecr_RB.focus();
						return false;
					}
				}
				//################################################
				if(dataForm.oth_ecr_RB.value!=""&&!checkMonthDiff())
				{					
					alert("Difference between Expiry Date and Required by can't be greater than 3 Months ");
					dataForm.oth_ecr_RB.focus();
					return false;
				}
/* 
	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       CSR_Initiate_Center.jsp
	Purpose         :       Additional field ‘Card Delivery Option’ needs to be added at the initiation work step
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/057								 Saurabh Arora
*/
				if(dataForm.oth_ecr_dt.value=="")
				{
					alert("Deliver To is mandatory");
					dataform.oth_ecr_dt.focus();
					return false;
				}
				if(dataForm.oth_ecr_dt.value=="Bank")
				{
					if(dataform.oth_ecr_bn.value=="")
					{
						alert("Branch Name is mandatory");
						dataform.oth_ecr_bn.focus();
						return false;				
					}
				}
				if(dataForm.oth_ecr_RR.value.length=="")
				{					
					alert("Remarks/Reasons is Mandatory");
					dataForm.oth_ecr_RR.focus();
					return false;
				}
/* 
	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       CSR_Initiate_Center.jsp
	Purpose         :       Additional field ‘Card Delivery Option’ needs to be added at the initiation work step
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/057								 Saurabh Arora
*/
				if(dataForm.oth_ecr_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_ecr_RR.focus();
					return false;
				}
			}

	//----------------------------------------------------------------------------------------------------------------------------------
	//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	//Group			         : Application –Projects
	//Product / Project	     : RAKBank 
	//Module                 : Update Request
	//Author                     : Lalit Kumar
	// Date written (DD/MM/YYYY) : 07-March-2008
	//Description                : Validation for the checking for at least one field should be selected  .
	//------------------------------------------------------------------------------------------------------------------------------------>
			if(srequest_type=="Change in Standing Instructions")
			{	
				//## New Date validation to be developed
				if(dataForm.oth_csi_PH.checked==false && dataForm.oth_csi_CSIP.checked==false && dataForm.oth_csi_CDACNo.checked==false && dataForm.oth_csi_RR.value=="")
				{
					alert("At least one Instruction should be checked/selected.");
					return false;
				}
				if(dataForm.oth_csi_PH.checked==true&&dataForm.oth_csi_TOH.options[dataForm.oth_csi_TOH.selectedIndex].value=="")
				{					
					alert("Type of Hold is Mandatory");
					dataForm.oth_csi_TOH.focus();
					return false;
				}	
				if(dataForm.oth_csi_TOH.options[dataForm.oth_csi_TOH.selectedIndex].value.toUpperCase()=="TEMPORARY"&&dataForm.oth_csi_NOM.options[dataForm.oth_csi_NOM.selectedIndex].value=="")
				{					
					alert("Months is Mandatory");
					dataForm.oth_csi_NOM.focus();
					return false;
				}
				if(dataForm.oth_csi_CSIP.checked==true&&dataForm.oth_csi_POSTMTB.value=="")
				{					
					alert("% Of STMT Balance is Mandatory.");
					dataForm.oth_csi_POSTMTB.focus();
					return false;
				}
				if(dataForm.oth_csi_CSIP.checked==true&&!(parseInt(dataForm.oth_csi_POSTMTB.value)>2&&parseInt(dataForm.oth_csi_POSTMTB.value)<101))
				{					
					//alert("% Of STMT Balance should be between 3 and 100 both inclusive.");
					//dataForm.oth_csi_POSTMTB.focus();
					return false;
				}
				//-----
				if(dataForm.oth_csi_CSID.checked==true&&dataForm.oth_csi_ND.value=="")
				{					
					alert("New date is Mandatory.");
					dataForm.oth_csi_ND.focus();
					return false;
				}
				if(dataForm.oth_csi_CSID.checked==true&&!CheckDataType(dataForm.oth_csi_ND.value,"Numeric"))
				{					
					alert("New date Should be Numeric"); 
					dataForm.oth_csi_ND.focus();
					return false;
				}
				//alert();
				if(dataForm.oth_csi_CSID.checked==true&&parseInt(dataForm.oth_csi_ND.value)>31)
				{					
					alert("New date can't be greater than 31"); 
					dataForm.oth_csi_ND.focus();
					return false;
				}
				if(dataForm.oth_csi_CSID.checked==true&&parseInt(dataForm.oth_csi_ND.value)==0)
				{					
					alert("New date can't be zero"); 
					dataForm.oth_csi_ND.focus();
					return false;
				}
				//-----=
				
				if(dataForm.oth_csi_CDACNo.checked==true&&dataForm.oth_csi_AccNo.value=="")
				{					
					alert("Account No. is Mandatory");
					dataForm.oth_csi_AccNo.focus();
					return false;
				}
				if(dataForm.oth_csi_CDACNo.checked==true&&!CheckDataType(dataForm.oth_csi_AccNo.value,"Numeric"))
				{					
					alert("Only Numerics are allowed in Account No.");
					dataForm.oth_csi_AccNo.focus();
					return false;
				}	
				if(dataForm.oth_csi_CDACNo.checked==true&&dataForm.oth_csi_AccNo.value.length<13)
				{					
					alert("Account No. Should be of length 13");
					dataForm.oth_csi_AccNo.focus();
					return false;
				}
				if(dataForm.oth_csi_CDACNo.checked==true&&parseInt(dataForm.oth_csi_AccNo.value)==0)
				{					
					alert("Account No. can't be Zero");
					dataForm.oth_csi_AccNo.value="";
					dataForm.oth_csi_AccNo.focus();
					return false;
				}
				if(dataForm.oth_csi_TOH.options[dataForm.oth_csi_TOH.selectedIndex].value.toUpperCase()=="TEMPORARY"&&dataForm.oth_csi_RR.value.length=="")
				{					
					alert("Remarks/Reasons is Mandatory");
					dataForm.oth_csi_RR.focus();
					return false;
				}
				if(dataForm.oth_csi_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_csi_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Transaction Dispute")
			{	
				if(dataForm.oth_td_RNO.value=="")
				{					
					alert("Reference No. is Mandatory");
					dataForm.oth_td_RNO.focus();
					return false;
				}
//----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group			         : Application –Projects
//Product / Project	     : RAKBank 
//Module                 : Update Request
//Author                     : Lalit Kumar
// Date written (DD/MM/YYYY) : 08-March-2008
//Description                : Remove the check on the reference number as it is currently allowing only 10 digits only.
//------------------------------------------------------------------------------------------------------------------------------------>
				/*if(dataForm.oth_td_RNO.value.length<10)
				{					
					alert("Reference No. Should of length 10");
					dataForm.oth_td_RNO.focus();
					return false;
				}*/
				if(!CheckDataType(dataForm.oth_td_RNO.value,"Numeric"))
				{					
					alert("Only Numerics are allowed in Reference No.");
					dataForm.oth_td_RNO.focus();
					return false;
				}				
				if(dataForm.oth_td_Amount.value=="")
				{					
					alert("Amount is Mandatory");
					dataForm.oth_td_Amount.focus();
					return false;
				}	
				if(!CheckDataType(replaceAll(dataForm.oth_td_Amount.value,",",""),"numeric82"))
				{					
					alert("Only Numerics(10,2) are allowed in Amount");
					dataForm.oth_td_Amount.focus();
					return false;
				}					
/* 
	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       CSR_Initiate_Center.jsp
	Purpose         :       Additional field ‘Card Delivery Option’ needs to be added at the initiation work step
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/057								 Saurabh Arora
*/
				if(dataForm.oth_td_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_td_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Card Upgrade")
			{	
				if(dataForm.CCI_CT.value.toUpperCase()=="T")
				{					
					alert("Card can't be upgraded as card type is Titanium");					
					return false;
				}
				if(dataForm.oth_cu_RR.value.length=="")
				{					
					alert("Remarks/Reasons is Mandatory");
					dataForm.oth_cu_RR.focus();
					return false;
				}
/* 
	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       CSR_Initiate_Center.jsp
	Purpose         :       Additional field ‘Card Delivery Option’ needs to be added at the initiation work step
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/057								 Saurabh Arora
*/
				if(dataForm.oth_cu_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_cu_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Setup Suppl. Card Limit")
			{	//Suplllementary Card No. validation to be developed
				if(dataForm.oth_ssc_Amount.value.length=="")
				{					
					alert("Amount is Mandatory");
					dataForm.oth_ssc_Amount.focus();
					return false;
				}
				if(!CheckDataType(replaceAll(dataForm.oth_ssc_Amount.value,",",""),"numeric82"))
				{					
					alert("Only Numerics(10,2) are allowed in Amount");
					dataForm.oth_ssc_Amount.focus();
					return false;
				}
/*
	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       CSR_Initiate_center.jsp
	Purpose         :       Set up Supplement Card limit: It accepts requests to set the limit where amount is less than the minimum limit of AED 500. This validation needs to be built in
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/033					23/09/2008	 Saurabh Arora
*/
				if (dataform.oth_ssc_Amount.value<500)
				{
					alert("Value in amount field cannot be less than 500");
					dataform.oth_ssc_Amount.focus();
					return false;
				}
				if(dataForm.oth_ssc_SCNo.value.length=="")
				{					
					alert("Suplementary Card No. is Mandatory");
					dataForm.oth_ssc_SCNo.focus();
					return false;
				}
				if(dataForm.oth_ssc_RR.value.length=="")
				{					
					alert("Remarks/Reasons is Mandatory");
					dataForm.oth_ssc_RR.focus();
					return false;
				}
/*

	Product/Project :       Rak Bank
	Module          :       Reversal Request
	File            :       CSR_Initiate_center.jsp
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/074					 Saurabh Arora
*/
				if(dataForm.oth_ssc_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_ssc_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Card Delivery Request")
			{	
				if(dataForm.oth_cdr_CDT.options[dataForm.oth_cdr_CDT.selectedIndex].value=="")
				{					
					alert("Card Delivery To is Mandatory");
					dataForm.oth_cdr_CDT.focus();
					return false;
				}
				if(dataForm.oth_cdr_CDT.options[dataForm.oth_cdr_CDT.selectedIndex].value.toUpperCase()=="BANK"&&dataForm.oth_cdr_BN.options[dataForm.oth_cdr_BN.selectedIndex].value=="")
				{					
					alert("Branch Name is Mandatory");
					dataForm.oth_cdr_BN.focus();
					return false;
				}
				
				if(dataForm.oth_cdr_RR.value.length==""&&dataForm.oth_cdr_BN.options[dataForm.oth_cdr_BN.selectedIndex].text.toUpperCase()=="OTHERS")
				{					
					alert("Remarks/Reasons is Mandatory");
					dataForm.oth_cdr_RR.focus();
					return false;
				}
/*

	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       CSR_Initiate_center.jsp
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/073				   Saurabh Arora
*/
				if(dataForm.oth_cdr_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_cdr_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Credit Shield")
			{	
				if(dataForm.oth_cs_CS.options[dataForm.oth_cs_CS.selectedIndex].value=="")
				{					
					alert("Credit Shield is Mandatory");
					dataForm.oth_cs_CS.focus();
					return false;
				}
				if(dataForm.oth_cs_CSR.checked==true&&dataForm.oth_cs_Amount.value=="")
				{					
					alert("Amount is Mandatory");
					dataForm.oth_cs_Amount.focus();
					return false;
				}

				if(dataForm.oth_cs_CSR.checked==true&&!CheckDataType(replaceAll(dataForm.oth_cs_Amount.value,",",""),"numeric82"))
				{					
					alert("Only Numerics(10,2) are allowed in Amount");
					dataForm.oth_cs_Amount.focus();
					return false;
				}					
				if(dataForm.oth_cs_RR.value.length==""&&dataForm.oth_cs_CS.options[dataForm.oth_cs_CS.selectedIndex].value.toUpperCase()=="UN-ENROLLEMENT")
				{					
					alert("Remarks/Reasons is Mandatory");
					dataForm.oth_cs_RR.focus();
					return false;
				}
/*

	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       CSR_Initiate_center.jsp
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/073				   Saurabh Arora
*/
				if(dataForm.oth_cs_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_cs_RR.focus();
					return false;
				}
			}
	}
	for(var i=0;i<dataForm.elements.length;i++)
			{
				if(dataForm.elements[i].type=="textarea"&&dataForm.elements[i].name.toUpperCase().indexOf("RR")!=-1&&dataForm.elements[i].value.length>500)
				{
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.elements[i].focus();
					return false;
				}
			}

	return true;
}


function validateProcessDataForPending()
{

		var dataForm=window.document.forms['dataform'];
			//alert(dataForm.CCI_CCRNNo.value.length);

			//#####################################
			for(var i=0;i<dataForm.elements.length;i++)
			{
				if(dataForm.elements[i].type=="text"||dataForm.elements[i].type=="textarea")
				{
					dataForm.elements[i].value=trim(dataForm.elements[i].value);
				}
			}
			//#####################################
		/* if(!CheckDataType(trim(dataForm.CCI_CName.value),"character")){
			alert("Invalid Data in Customer Name Only Characters are allowed ");
			dataForm.CCI_CName.focus();
			return false;
		}
		 if(!CheckDataType(trim(dataForm.CCI_ExpD.value),"date")){
			alert("Invalid Data in Expiry Date Only MM/YY format  is allowed");
			dataForm.CCI_ExpD.focus();
			return false;
		}*/
		 if(!CheckDataType(trim(dataForm.CCI_ExtNo.value),"Numeric")){
			alert("Invalid Data in Ext No. Only Numeric are allowed");
			dataForm.CCI_ExtNo.focus();
			return false;
		}
		/* if(!CheckDataType(dataForm.CCI_CCRNNo.value,"Numeric")){
			alert("Invalid Data in Card CRN No Only Numerics are allowed");
			dataForm.CCI_CCRNNo.focus();

			return false;
			
		}*/
		if(processName=="CSR_BT" || processName=="CSR_CCC" ) {
			if(dataForm.CCI_CrdtCN.value.charAt(13)==0 && dataForm.CCI_CT.value == 'L'){
				alert("Current Card Type is not allowed for this request");
				return false;
			}

		}
		if(processName=="CSR_CCC")
		{
			if (dataForm.REMARKS.value.length>500)
			{
			alert("Remarks/Reason can't be greater than 500 characters");
			return false;
			}
		}
		if(processName=="CSR_CCB" || processName=="CSR_CBR")
			{
			if(dataForm.CCI_CT.value == 'L'){
				alert("Current Card Type is not allowed for this request");
				return false;
			}

		}
		if(processName=="CSR_OCC") {
			if(dataForm.request_type.value=="Card Upgrade"){
				if (!(dataForm.CCI_CT.value=='V')) 	{
					alert("Current Card Type is not allowed for this request");
					return false;
				}
			}

			if(dataForm.request_type.value=="Credit Limit Increase" || dataForm.request_type.value=="Change in Standing Instructions" || dataForm.request_type.value=="Card Upgrade" ||dataForm.request_type.value=="Setup Suppl. Card Limit" || dataForm.request_type.value=="Credit Shield" ){
				if (!(dataForm.CCI_CrdtCN.value.charAt(13)==0 ) )	{
					alert("Only Primary Cards Allowed");
					return false;
				}
			}
			//alert("test card type:"+dataForm.CCI_CT.value);
			if((dataForm.CCI_CT.value == 'L') && (dataForm.request_type.value=="Re-Issue of PIN" ||dataForm.request_type.value=="Card Replacement" ||dataForm.request_type.value=="Credit Limit Increase" ||dataForm.request_type.value=="Early Card Renewal" ||dataForm.request_type.value=="Transaction Dispute"  ||dataForm.request_type.value=="Card Delivery Request" ||dataForm.request_type.value=="Setup Suppl. Card Limit")){
				alert("Current Card Type is not allowed for this request");
					return false;
				
			}
			}
		if(processName=="CSR_BT"||processName=="CSR_CCC")
		{			
			 if(!CheckDataType(dataForm.CCI_SC.value,"AlphaNumeric")){
				alert("Invalid Data in Source Code Only Alphanumeric are allowed");
				dataForm.CCI_SC.focus();
				return false;
			}
		}

		if(processName=="CSR_CCC")
		{
			if (dataForm.REMARKS.value.length>500)
			{
			alert("Remarks/Reason can't be greater than 500 characters");
			return false;
			}
		}
		 if(!CheckDataType(dataForm.CCI_ExtNo.value,"Numeric")){
			alert("Invalid Data in Mobile No.  Only Numeric are allowed");
			dataForm.CCI_ExtNo.focus();
			return false;
		}
		//**********************
		/* if(!CheckDataType(dataForm.CCI_AccInc.value,"numeric82")){
			alert("Invalid Data in Accessed Income  Only Numeric (10,2) are allowed");
			dataForm.CCI_AccInc.focus();
			return false;
		}
		if(!CheckDataType(dataForm.CCI_CT.value,"character")){
			alert("Invalid Data in Card Type Only Character are allowed");
			dataForm.CCI_CT.focus();
			return false;
		}	*/	
		/*if(dataForm.VD_MoMaidN.checked==true){
			
			if(!CheckDataType(dataForm.VD_Oth.value,"character")){
				alert("Invalid Data in Others (Pls. Specify) Only Character are allowed");
				dataForm.VD_Oth.focus();
				return false;
			}
		}*/
	if(processName=="CSR_BT")
	{
			
			if(dataForm.BTD_OBC_CT.options[dataForm.BTD_OBC_CT.selectedIndex].value.toUpperCase()=="OTHERS"){				
					
					 if(!CheckDataType(replaceAll(dataForm.BTD_OBC_OBNO.value,"-",""),"Numeric")){
						alert("Invalid Data in Others (Pls. Specify) Only Numerics are allowed");
						dataForm.BTD_OBC_OBNO.focus();
						return false;
					}
					if(!CheckDataType(replaceAll(dataForm.BTD_OBC_OBCNO.value,"-",""),"Numeric")){
						alert("Invalid Data in Other Bank Card No. Only Numerics are allowed");
						dataForm.BTD_OBC_OBCNO.focus();
						return false;
					}			
			}
			if(!CheckDataType(dataForm.BTD_OBC_NOOC.value,"name")){
				alert("Invalid Data in Name on Other Card Only characters , .,& , _ and ' are allowed");
				dataForm.BTD_OBC_NOOC.focus();
				return false;
			}		
			
			/*if((dataForm.BTD_RBC_RBCN1.options[dataForm.BTD_RBC_RBCN1.selectedIndex].value==dataForm.BTD_RBC_RBCN2.options[dataForm.BTD_RBC_RBCN2.selectedIndex].value)||(dataForm.BTD_RBC_RBCN2.options[dataForm.BTD_RBC_RBCN2.selectedIndex].value==dataForm.BTD_RBC_RBCN3.options[dataForm.BTD_RBC_RBCN3.selectedIndex].value)||(dataForm.BTD_RBC_RBCN3.options[dataForm.BTD_RBC_RBCN3.selectedIndex].value==dataForm.BTD_RBC_RBCN1.options[dataForm.BTD_RBC_RBCN1.selectedIndex].value)){
				alert("RAKBANK card no.'s Should be unique");			
				return false;
			}*/

			var rakbankcardno1Value=dataForm.BTD_RBC_RBCN1.options[dataForm.BTD_RBC_RBCN1.selectedIndex].value;	
			var rakbankcardno2Value=dataForm.BTD_RBC_RBCN2.options[dataForm.BTD_RBC_RBCN2.selectedIndex].value;	
			var rakbankcardno3Value=dataForm.BTD_RBC_RBCN3.options[dataForm.BTD_RBC_RBCN3.selectedIndex].value;	
			if((rakbankcardno1Value!=""&&rakbankcardno2Value!=""&&rakbankcardno1Value==rakbankcardno2Value)||(rakbankcardno2Value!=""&&rakbankcardno3Value!=""&&rakbankcardno2Value==rakbankcardno3Value)||(rakbankcardno3Value!=""&&rakbankcardno1Value!=""&&rakbankcardno3Value==rakbankcardno1Value)){
					alert("RAKBANK Card no.'s Should be unique");			
					return false;
				}

			//BTD_RBC_RBCN1 any two are mandatory
			if(dataForm.BTD_RBC_RBCN1.options[dataForm.BTD_RBC_RBCN1.selectedIndex].value!="")
			{
				
			 /*if(!CheckDataType(dataForm.BTD_RBC_CT1.value,"character")){
					alert("Invalid Data in Card Type Only characters are allowed");
					dataForm.BTD_RBC_CT1.focus();
					return false;
				}*/
				 if(!CheckDataType(dataForm.BTD_RBC_ExpD1.value,"date")){
					alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
					dataForm.BTD_RBC_ExpD1.focus();
					return false;
				}
				 if(!CheckDataType(replaceAll(dataForm.BTD_RBC_BTA1.value,",",""),"numeric82")){
					alert("Invalid Data in BT Amount(AED) Only Numerics(10,2) are allowed");
					dataForm.BTD_RBC_BTA1.focus();
					return false;
				}
				if(!CheckDataType(dataForm.BTD_RBC_AppC1.value,"Numeric")){
					alert("Invalid Data in Approval Code Only Numeric value's are allowed");
					dataForm.BTD_RBC_AppC1.focus();
					return false;
				}
			}
			if(dataForm.BTD_RBC_RBCN2.options[dataForm.BTD_RBC_RBCN2.selectedIndex].value!="")
			{
				 /*if(!CheckDataType(dataForm.BTD_RBC_CT2.value,"character")){
					alert("Invalid Data in Card Type Only characters are allowed");
					dataForm.BTD_RBC_CT2.focus();
					return false;
				}*/
				 if(!CheckDataType(dataForm.BTD_RBC_ExpD2.value,"date")){
					alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
					dataForm.BTD_RBC_ExpD2.focus();
					return false;
				}
				 if(!CheckDataType(replaceAll(dataForm.BTD_RBC_BTA2.value,",",""),"numeric82")){
					alert("Invalid Data in BT Amount(AED) Only Numerics(10,2) are allowed");
					dataForm.BTD_RBC_BTA2.focus();
					return false;
				}
				if(!CheckDataType(dataForm.BTD_RBC_AppC2.value,"Numeric")){
					alert("Invalid Data in Approval Code Only Numeric value's are allowed");
					dataForm.BTD_RBC_AppC2.focus();
					return false;
				}
			}
			if(dataForm.BTD_RBC_RBCN3.options[dataForm.BTD_RBC_RBCN3.selectedIndex].value!="")
			{
				 /*if(!CheckDataType(dataForm.BTD_RBC_CT3.value,"character")){
					alert("Invalid Data in Card Type Only characters are allowed");
					dataForm.BTD_RBC_CT3.focus();
					return false;
				}*/
				if(!CheckDataType(dataForm.BTD_RBC_ExpD3.value,"date")){
					alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
					dataForm.BTD_RBC_ExpD3.focus();
					return false;
				}
				if(!CheckDataType(replaceAll(dataForm.BTD_RBC_BTA3.value,",",""),"numeric82")){
					alert("Invalid Data in BT Amount(AED) Only Numerics(10,2) are allowed");
					dataForm.BTD_RBC_BTA3.focus();
					return false;
				}
				if(!CheckDataType(dataForm.BTD_RBC_AppC3.value,"Numeric")){
					alert("Invalid Data in Approval Code Only Numeric value's are allowed");
					dataForm.BTD_RBC_AppC3.focus();
					return false;
				}
			}

		
/*

	Product/Project :       Rak Bank
	Module          :       Balance Transfer
	File            :       BT_SaveDone.js
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/068				   Saurabh Arora
*/			
			if (dataForm.BTD_RBC_RR.value.length>500)
				{
					alert("Remarks/Reasons can't be greater than 500 Characters");
					return false;
				}
									
	}
      
	   if(processName=="CSR_CCC")

        {
			
			
		 if(!CheckDataType(dataForm.BANEFICIARY_NAME.value,"name")){
				alert("Invalid Data in Beneficiary Name Only characters, ., and _ are allowed");
				dataForm.BANEFICIARY_NAME.focus();
				return false;
			}

		if (dataForm.REMARKS.value.length>500)
		{
			alert("Remarks/Reasons can't be greater than 500 Characters");
			return false;
		}
		
			
			

			/*if((dataForm.CARDNO1.options[dataForm.CARDNO1.selectedIndex].value==dataForm.CARDNO2.options[dataForm.CARDNO2.selectedIndex].value)||(dataForm.CARDNO2.options[dataForm.CARDNO2.selectedIndex].value==dataForm.CARDNO3.options[dataForm.CARDNO3.selectedIndex].value)||(dataForm.CARDNO3.options[dataForm.CARDNO3.selectedIndex].value==dataForm.CARDNO1.options[dataForm.CARDNO1.selectedIndex].value)){
				alert("RAKBANK card no.'s Should be unique");			
				return false;
			}*/

			var rakbankcardno1Value=dataForm.CARDNO1.options[dataForm.CARDNO1.selectedIndex].value;	
			var rakbankcardno2Value=dataForm.CARDNO2.options[dataForm.CARDNO2.selectedIndex].value;	
			var rakbankcardno3Value=dataForm.CARDNO3.options[dataForm.CARDNO3.selectedIndex].value;	
			if((rakbankcardno1Value!=""&&rakbankcardno2Value!=""&&rakbankcardno1Value==rakbankcardno2Value)||(rakbankcardno2Value!=""&&rakbankcardno3Value!=""&&rakbankcardno2Value==rakbankcardno3Value)||(rakbankcardno3Value!=""&&rakbankcardno1Value!=""&&rakbankcardno3Value==rakbankcardno1Value)){
					alert("RAKBANK Card no.'s Should be unique");			
					return false;
				}

			//BTD_RBC_RBCN1 any two are mandatory
			if(dataForm.CARDNO1.options[dataForm.CARDNO1.selectedIndex].value!="")
			{
				 /*if(!CheckDataType(dataForm.CARDTYPE1.value,"character")){
					alert("Invalid Data in Card Type Only characters are allowed");
					dataForm.CARDTYPE1.focus();
					return false;
				}*/
				 if(!CheckDataType(dataForm.CARDEXPIRY_DATE1.value,"date")){
					alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
					dataForm.CARDEXPIRY_DATE1.focus();
					return false;
				}
				 if(!CheckDataType(dataForm.CHQ_AMOUNT1.value,"amount")){
					alert("Invalid Data in Cheque Amount(AED) Only Numerics are allowed");
					dataForm.CHQ_AMOUNT1.focus();
					return false;
				}
				if(!CheckDataType(dataForm.ApprovalCode1.value,"Numeric")){
					alert("Invalid Data in Approval Code Only Numeric value's are allowed");
					dataForm.ApprovalCode1.focus();
					return false;
				}

			}
			if(dataForm.CARDNO2.options[dataForm.CARDNO2.selectedIndex].value!="")
			{
				 /*if(!CheckDataType(dataForm.CARDTYPE2.value,"character")){
					alert("Invalid Data in Card Type Only characters are allowed");
					dataForm.CARDTYPE2.focus();
					return false;
				}*/
				 if(!CheckDataType(dataForm.CARDEXPIRY_DATE2.value,"date")){
					alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
					dataForm.CARDEXPIRY_DATE2.focus();
					return false;
				}
				if(!CheckDataType(dataForm.CHQ_AMOUNT2.value,"amount")){
					alert("Invalid Data in Cheque Amount(AED) Only Numerics are allowed");
					dataForm.CHQ_AMOUNT2.focus();
					return false;
				}
				if(!CheckDataType(dataForm.ApprovalCode2.value,"Numeric")){
					alert("Invalid Data in Approval Code Only Numeric value's are allowed");
					dataForm.ApprovalCode2.focus();
					return false;
				}
			}
			if(dataForm.CARDNO3.options[dataForm.CARDNO3.selectedIndex].value!="")
			{
				 /*if(!CheckDataType(dataForm.CARDTYPE3.value,"character")){
					alert("Invalid Data in Card Type Only characters are allowed");
					dataForm.CARDTYPE3.focus();
					return false;
				}*/
				if(!CheckDataType(dataForm.CARDEXPIRY_DATE3.value,"date")){
					alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
					dataForm.CARDEXPIRY_DATE3.focus();
					return false;
				}
				if(!CheckDataType(dataForm.CHQ_AMOUNT3.value,"amount")){
					alert("Invalid Data in Cheque Amount(AED) Only Numerics are allowed");
					dataForm.CHQ_AMOUNT3.focus();
					return false;
				}
				if(!CheckDataType(dataForm.ApprovalCode3.value,"Numeric")){
					alert("Invalid Data in Approval Code Only Numeric value's are allowed");
					dataForm.ApprovalCode3.focus();
					return false;
				}
			}		
				
	     }


	if(processName=="CSR_CBR")
	{
		if(dataForm.CASHBACK_TYPE.options[dataForm.CASHBACK_TYPE.selectedIndex].value==""){
				alert("Type is Mandatory");
				dataForm.CASHBACK_TYPE.focus();
				return false;
			}
			if(dataForm.CASHBACK_TYPE.options[dataForm.CASHBACK_TYPE.selectedIndex].value.toUpperCase()=="REDEMPTION"){
				if(dataForm.AMOUNT.value==""){
					alert("Amount is Mandatory");
					dataForm.AMOUNT.focus();
					return false;
				}
				if(dataForm.AMOUNT.value<parseFloat("100.00"))
				{
					alert("Amount should be greater than 100");
					return false;
				}
			}
		
		if(dataForm.CASHBACK_TYPE.options[dataForm.CASHBACK_TYPE.selectedIndex].value.toUpperCase()=="UN-ENROLLMENT"){
				if(dataForm.REMARKS.value==""){
					alert("Remarks/ Reason is Mandatory");
					dataForm.REMARKS.focus();
					return false;
				}
			}
/*

	Product/Project :       Rak Bank
	Module          :       Cash Back Request
	File            :       CSR_Initiate_center.jsp
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/071				   Saurabh Arora
*/
			if(dataForm.REMARKS.value.length>500)
				{		
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.REMARKS.focus();
					return false;
				}
		if (dataForm.REMARKS.value.length>500)
		       {
			         alert("Remarks/Reasons can't be greater than 500 Characters");
			        return false;
		        }
	}
	     
/*  Start Code for card blocking*/
	if(processName=="CSR_CCB")
	{
		try{		
		
			if((dataForm.REASON_HOTLIST.options[dataForm.REASON_HOTLIST.selectedIndex].value=="Others")&& 				(dataForm.HOST_OTHER.value!="") && (!space_Check(dataForm.HOST_OTHER.value))){
				alert("Invalid Data in Others (Pls. Specify). Only spaces are not allowed");
				dataForm.HOST_OTHER.focus();
				return false;
			} 

		var tempDate;
		tempDate = dataForm.CB_DateTime.value;
		if (tempDate=="dd/MM/yyyy<space>hh:mm")
			{
				tempDate="";
			}

	if((dataForm.REASON_HOTLIST.options[dataForm.REASON_HOTLIST.selectedIndex].value=="Lost")||
		(dataForm.REASON_HOTLIST.options[dataForm.REASON_HOTLIST.selectedIndex].value=="Stolen")||
		(dataForm.REASON_HOTLIST.options[dataForm.REASON_HOTLIST.selectedIndex].value=="Captured")||
		(dataForm.REASON_HOTLIST.options[dataForm.REASON_HOTLIST.selectedIndex].value=="Blocked"))
		{
				if(!validateDateTime(tempDate,dataForm.sysDate_CCB.value)){
					 dataForm.CB_DateTime.focus();
					 return false;
		         }								
			} 
	if(tempDate!="")
			{
			if(!validateDateTime(dataForm.CB_DateTime.value,dataForm.sysDate_CCB.value))
				{
					 dataForm.CB_DateTime.focus();
					 return false;
				}
			}
		if (dataForm.CB_DateTime.value=="dd/MM/yyyy<space>hh:mm")
			{
				dataForm.CB_DateTime.value="";
			}

			if(dataForm.EMAIL_FROM.value!=""){
				if(!validateEmail(dataForm.EMAIL_FROM.value)){
					 alert("Please enter valid email address");
					 dataForm.EMAIL_FROM.focus();
					 return false;
		         }
			}
			if(dataForm.EMBOSING_NAME.value!="" && (!CheckDataType(dataForm.EMBOSING_NAME.value,"character"))){
				alert("Invalid Embossing Name is entered. Only Characters are allowed");
				dataForm.EMBOSING_NAME.focus();
				return false;
			}
			if(!CheckDataType(replaceAll(replaceAll(dataForm.AVAILABLE_BALANCE.value,",",""),"-",""),"numeric82")){
					alert("Invalid Data in Available balance Only Numerics(10,2) are allowed");
					dataForm.AVAILABLE_BALANCE.focus();
					return false;
				}
			 if(!CheckDataType(dataForm.C_STATUS_B_BLOCK.value,"Numeric")){
					alert("Invalid Data in Card status before block. Only Numeric are allowed");
					dataForm.C_STATUS_B_BLOCK.focus();
					return false;
			}

			if(!CheckDataType(dataForm.C_STATUS_A_BLOCK.value,"Numeric")){
					alert("Invalid Data in Card status after block. Only Numeric are allowed");
					dataForm.C_STATUS_A_BLOCK.focus();
					return false;
			}
			if((dataForm.ACTION_TAKEN.options[dataForm.ACTION_TAKEN.selectedIndex].value=="Others")&& (dataForm.ACTION_OTHER.value!="") && (!space_Check(dataForm.ACTION_OTHER.value))){
				alert("Invalid Data in Others (Pls. Specify). Only spaces are not allowed");
				dataForm.ACTION_OTHER.focus();
				return false;
			}
			if(dataForm.REMARKS.value.length>500)
				{		
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.REMARKS.focus();
					return false;
				}
			var amount =  dataForm.AVAILABLE_BALANCE.value;
			dataForm.AVAILABLE_BALANCE.value = replaceAll(amount,",","")
			}catch(e){
				alert("Exception: "+e);
			}
			return true;
		} 


/* end   */



/* Misc*/
     if(processName=="CSR_MR")
	{
		 if(dataForm.REMARKS.value.length>500)
				{		
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.REMARKS.focus();
					return false;
				}
		 

	}




/*End*/


	if(processName=="CSR_RR")
	{	
		if (dataForm.RRD_RR.value.length>500)
		{
			alert("Remarks/Reasons can't be greater than 500 Characters");
			dataForm.RRD_RR.focus();
			return false;
		}	
	}

	if(processName=="CSR_OCC")
	{		
		var srequest_type=dataForm.request_type.options[dataForm.request_type.selectedIndex].value;
			if(srequest_type=="")
			{
			alert("Process Name is Mandatory");
			dataForm.request_type.focus();
			return false;
			}
/*

	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       CSR_Initiate_center.jsp
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/073				   Saurabh Arora
*/
			if(srequest_type=="Re-Issue of PIN")
			{	
				if(dataForm.oth_rip_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_rip_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Card Replacement")
			{	
				
				if(dataForm.oth_cr_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_cr_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Credit Limit Increase")
			{	
							
				if(dataForm.oth_cli_months.value!=""&&!CheckDataType(dataForm.oth_cli_months.value,"month"))
				{					
					alert("Invalid data in Months Only 0,1,2,3 are allowed. ");
					dataForm.oth_cli_months.focus();
					return false;
				}	
				if(dataForm.oth_cli_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_cli_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Early Card Renewal")
			{	
				//## past date validation required

				//alert(checkMonthDiff());
				//################################################
				if(dataForm.oth_ecr_RB.value!="")
				{
					var month1=dataForm.CCI_ExpD.value.substring(0,2);
					var year1=dataForm.CCI_ExpD.value.substring(3,5);

					var month2=dataForm.oth_ecr_RB.value.substring(0,2);
					var year2=dataForm.oth_ecr_RB.value.substring(3,5);

					var dt1=new Date("20"+year1,parseInt(month1)-1);
					var dt2=new Date("20"+year2,parseInt(month2)-1);
					if(dt2>dt1)
					{
						alert("Required By date can't be greater than expiry date");
						dataForm.oth_ecr_RB.focus();
						return false;
					}
				}
				//################################################
				if(dataForm.oth_ecr_RB.value!=""&&!checkMonthDiff())
				{					
					alert("Difference between Expiry Date and Required by can't be greater than 3 Months ");
					dataForm.oth_ecr_RB.focus();
					return false;
				}
				
				if(dataForm.oth_ecr_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_ecr_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Change in Standing Instructions")
			{	
				//## New Date validation to be developed
				if(dataForm.oth_csi_CSIP.checked==true&&!(parseInt(dataForm.oth_csi_POSTMTB.value)>2&&parseInt(dataForm.oth_csi_POSTMTB.value)<101))
				{					
					//alert("% Of STMT Balance should be between 3 and 100 both inclusive.");
					//dataForm.oth_csi_POSTMTB.focus();
					return false;
				}
				//-----
				
				if(dataForm.oth_csi_CSID.checked==true&&dataForm.oth_csi_ND.value!=""&&!CheckDataType(dataForm.oth_csi_ND.value,"Numeric"))
				{					
					alert("New date Should be Numeric"); 
					dataForm.oth_csi_ND.focus();
					return false;
				}
				//alert();
				if(dataForm.oth_csi_CSID.checked==true&&dataForm.oth_csi_ND.value!=""&&parseInt(dataForm.oth_csi_ND.value)>31)
				{					
					alert("New date can't be greater than 31"); 
					dataForm.oth_csi_ND.focus();
					return false;
				}
				if(dataForm.oth_csi_CSID.checked==true&&dataForm.oth_csi_ND.value!=""&&parseInt(dataForm.oth_csi_ND.value)==0)
				{					
					alert("New date can't be zero"); 
					dataForm.oth_csi_ND.focus();
					return false;
				}
				//-----=
				
				
				if(dataForm.oth_csi_CDACNo.checked==true&&!CheckDataType(dataForm.oth_csi_AccNo.value,"Numeric"))
				{					
					alert("Only Numerics are allowed in Account No.");
					dataForm.oth_csi_AccNo.focus();
					return false;
				}	
				if(dataForm.oth_csi_CDACNo.checked==true&&dataForm.oth_csi_AccNo.value.length<13)
				{					
					alert("Account No. Should be of length 13");
					dataForm.oth_csi_AccNo.focus();
					return false;
				}
				if(dataForm.oth_csi_CDACNo.checked==true&&parseInt(dataForm.oth_csi_AccNo.value)==0)
				{					
					alert("Account No. can't be Zero");
					dataForm.oth_csi_AccNo.value="";
					dataForm.oth_csi_AccNo.focus();
					return false;
				}
				
				if(dataForm.oth_csi_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_csi_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Transaction Dispute")
			{	
				
				/*if(dataForm.oth_td_RNO.value!=""&&dataForm.oth_td_RNO.value.length<10)
				{					
					alert("Reference No. Should of length 10");
					dataForm.oth_td_RNO.focus();
					return false;
				}*/
				if(!CheckDataType(dataForm.oth_td_RNO.value,"Numeric"))
				{					
					alert("Only Numerics are allowed in Reference No.");
					dataForm.oth_td_RNO.focus();
					return false;
				}				
				
				if(!CheckDataType(replaceAll(dataForm.oth_td_Amount.value,",",""),"numeric82"))
				{					
					alert("Only Numerics(10,2) are allowed in Amount");
					dataForm.oth_td_Amount.focus();
					return false;
				}					
				if(dataForm.oth_td_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_td_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Card Upgrade")
			{	
				
				if(dataForm.oth_cu_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_cu_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Setup Suppl. Card Limit")
			{	//Suplllementary Card No. validation to be developed
				
				if(!CheckDataType(replaceAll(dataForm.oth_ssc_Amount.value,",",""),"numeric82"))
				{					
					alert("Only Numerics(10,2) are allowed in Amount");
					dataForm.oth_ssc_Amount.focus();
					return false;
				}	
								
	/*

	Product/Project :       Rak Bank
	Module          :       Reversal Request
	File            :       CSR_Initiate_center.jsp
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/074					 Saurabh Arora
*/			if(dataForm.oth_ssc_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_ssc_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Card Delivery Request")
			{	
				if(dataForm.oth_cdr_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_cdr_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Credit Shield")
			{	
				
				if(dataForm.oth_cs_CSR.checked==true&&!CheckDataType(replaceAll(dataForm.oth_cs_Amount.value,",",""),"numeric82"))
				{					
					alert("Only Numerics(10,2) are allowed in Amount");
					dataForm.oth_cs_Amount.focus();
					return false;
				}					
				if(dataForm.oth_cs_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					dataForm.oth_cs_RR.focus();
					return false;
				}
			}
	}

	return true;
}

function trim(str) 
{ 
	//alert(" in trim str--"+str);
	var i=0;
	var j=0;
     
	for (i=0;i < str.length;i++) 
	{
		if (str.charAt(i) != ' ') break; 
	} 

	for (j=str.length - 1;j>= 0; j--) 
	{ 
		if (str.charAt(j) != ' ') 
		break; 
	}

	if (j < i) 
		j = i-1; 
		str = str.substring(i, j+1); 
	return str; 
}

function trimZeros(str) 
{ 
	//alert(" in trim str--"+str);
	var i=0;
	var j=0;
     
	for (i=0;i < str.length;i++) 
	{
		if (str.charAt(i) != ' ') break; 
	} 	

	if (j < i) 
		j = i-1; 
		str = str.substring(i, j+1); 
	return str; 
}

function checkForPastDate(cntrl)
{
	if(cntrl.value=="")
		return true;
	var serverdate=sDate.substring(0,2);
	var serverMonth=sDate.substring(3,5);
	var serverYear=sDate.substring(6,10);
	var dt1=new Date(serverYear,serverMonth-1,serverdate);

	var dataToCheck=cntrl.value;
	var dataToCheckdate=dataToCheck.substring(0,2);
	var dataToCheckMonth=dataToCheck.substring(3,5);
	var dataToCheckYear=dataToCheck.substring(6,10);
	var dt2=new Date(dataToCheckYear,dataToCheckMonth-1,dataToCheckdate);
	
	return dt2>dt1||(dt2.getDate()==dt1.getDate()&&dt2.getMonth()==dt1.getMonth()&&dt2.getFullYear()==dt1.getFullYear());
}

function checkMonthDiff()
{
	var dataForm=window.document.forms['dataform'];
	if(dataForm.CCI_ExpD.value==""||dataForm.oth_ecr_RB.value=="")
		return true;
	var month1=dataForm.CCI_ExpD.value.substring(0,2);
	var year1=dataForm.CCI_ExpD.value.substring(3,5);

	var month2=dataForm.oth_ecr_RB.value.substring(0,2);
	var year2=dataForm.oth_ecr_RB.value.substring(3,5);

	var dt1=new Date("20"+year1,Number(month1)-1);
	var dt2=new Date("20"+year2,Number(month2)-1);

	if(Number(month2)+3>12)
	{
		var year=dt2.getFullYear();
		dt2.setFullYear(Number(year)+1);
		dt2.setMonth(Number(month2)+2-12);
	}
	else
	{
		dt2.setMonth(Number(month2)+2);
	}
	
	return dt2>dt1||dt1==dt2;
}

function introduce(args)
{
	//alert('1');
	//alert("inside introduce and disabling the button");
	
	//alert('2');
	if(args=="Introduce")
	{
	
		if(!validateProcessData())
		{
	
			//window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
			//window.parent.frames['frameClose'].document.forms[0].elements["Pending"].setAttribute('disabled', false);
			return false;
		}

		//Commented below line for offshore testing
		window.document.forms["dataform"].initiateDecision.value="BranchApprover";
		
	}
	else
	{

		if(!validateProcessDataForPending())
		{

			window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
			window.parent.frames['frameClose'].document.forms[0].elements["Pending"].setAttribute('disabled', false);
			return false;
		}	
		//Commented below line for offshore testing
		window.document.forms["dataform"].initiateDecision.value="Pending";
	}
	//alert('34');
	var sFeatures="dialogHeight:0px; dialogWidth:0px; center=yes; dialogLeft:1500;dialogTop:1500;status:yes; ";
	var sResult;
	//var sResult = window.showModalDialog('WIIntroduceFrameset.jsp',document.forms.dataform,sFeatures);
	//var sResult = window.open('WIIntroduceFrameset.jsp',document.forms.dataform,sFeatures);
	//added below to handle window.open/window.showModalDialog according to type of browser starts here.
	/***********************************************************/
	var windowParams="height=0px,width=0px,toolbar=no,directories=no,status=yes,center=yes";
	//to get Wi data
	var dataForm=window.document.forms['dataform'];
	for(var i=0;i<dataForm.elements.length;i++)
		{
			//dataForm.elements[i].value=escape(dataForm.elements[i].value);
			if(dataForm.elements[i].type=='text'  || dataForm.elements[i].type=='textarea')
			{
				//if(dataForm.elements[i].name!='RequestName' && dataForm.elements[i].name != 'TypeName' && dataForm.elements[i].name!='RequestName' && dataForm.elements[i].name != 'TypeID' && dataForm.elements[i].name!='RequestName' && dataForm.elements[i].name != 'RequestID' && dataForm.elements[i].name != '' && dataForm.elements[i].name != undefined && dataForm.elements[i].value!='')
				if(dataForm.elements[i].name!='Header' && dataForm.elements[i].name != 'ServiceTypeName' && dataForm.elements[i].name!='BranchNameForPrinting' && dataForm.elements[i].name != 'ProcessCode' && dataForm.elements[i].name != '' && dataForm.elements[i].name != undefined )
				{
					//dataForm.elements[i].value=replaceAll(dataForm.elements[i].value ,"'","''");
					//if(dataForm.elements[i].id=='D')
					/*if(dataForm.elements[i].id.indexOf('Date_')!=-1)
					{
						//var str = replaceAll(dataForm.elements[i].value,'-','/'); //pass date in DD/MM/YYYY format
						document.forms.dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + LocalToDB(dataForm.elements[i].value, strDateFormat) + '\31' ;
					}
					else
					{
						if(dataForm.elements[i].id.indexOf('F_')!=-1)
						{
						  dataForm.elements[i].value =replaceAll (dataForm.elements[i].value,',','') ;
						 // alert( dataForm.elements[i].value);
						}*/
						var svar=replaceAll(dataForm.elements[i].value,"-","");
						svar=replaceAll(dataForm.elements[i].value,",","");						
						dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + svar + '\31' ;
					//}
				}
			}
            if(dataForm.elements[i].type=='hidden')
			{
				if(dataForm.elements[i].name != undefined && dataForm.elements[i].name != '')
				{
					//alert(dataForm.elements[i].name+"------"+dataForm.elements[i][dataForm.elements[i].selectedIndex].value);
					if(dataForm.elements[i].name == 'userEmailID'){
						var svar=replaceAll(dataForm.elements[i].value,"-","");
						svar=replaceAll(dataForm.elements[i].value,",","");
						dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + svar + '\31' ;
					}
				}
			}
			if(dataForm.elements[i].type=='select-one')
			{
				if(dataForm.elements[i].name != undefined && dataForm.elements[i].name != '')
				{
					//alert(dataForm.elements[i].name+"------"+dataForm.elements[i][dataForm.elements[i].selectedIndex].value);
					var svar=replaceAll(dataForm.elements[i][dataForm.elements[i].selectedIndex].value,"-","");
						svar=replaceAll(dataForm.elements[i][dataForm.elements[i].selectedIndex].value,",","");	
					dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + svar + '\31' ;
				}
			}
			/*if(dataForm.elements[i].type=='select-multiple' && window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="CSR_CCC")
			{
				if(dataForm.elements[i].name != undefined && dataForm.elements[i].name != '')
				{
					//alert(dataForm.elements[i].name+"------"+dataForm.elements[i][dataForm.elements[i].selectedIndex].value);
					var svar=replaceAll(dataForm.elements[i][dataForm.elements[i].selectedIndex].value,"-","");
						svar=replaceAll(dataForm.elements[i][dataForm.elements[i].selectedIndex].value,",","");	
					dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + svar + '\31' ;
				}
			}*/
			if(dataForm.elements[i].type=='checkbox')
			{
				if(dataForm.elements[i].name != undefined && dataForm.elements[i].name != '')
				{
					if(dataForm.elements[i].checked==true)
						dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + "Y" + '\31' ;
					else
						dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + "N" + '\31' ;
				}					
			}
		}
	
	//alert('1');
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	var WSNAME = "";//customform.document.getElementById("wdesk:Current_WS").value; // unnecessary this was passed which was creating issue at DataEntry maker and Checker, fixed it in Standalone, need to check in cluster and in prod
	url = "/webdesktop/CustomForms/CSRProcessSpecific/WIIntroduce.jsp";
	//alert('2');
	//for mail and SMS trigger by Aditya.rai --Start
	var ProcessCode = dataForm.ProcessCode.value;
	if(ProcessCode == 'CSR_BT'){
		var Mobile_No = dataForm.CCI_MONO.value;
		var Amount = dataForm.BTD_RBC_BTA1.value;
		var param="&ProcessName="+processName+"&subProcessShortName="+window.document.getElementById("subProcessShortName").value+"&WIData="+window.document.getElementById("WIData").value+"&Amount="+Amount+"&Mobile_No="+Mobile_No+"&ProcessCode="+ProcessCode+"&args="+args+"&Card_No="+(window.document.getElementById("CCI_CrdtCN").value).substring(12,16);
	}
	else if(ProcessCode == 'CSR_CCC'){
		var Mobile_No = dataForm.CCI_MONO.value;
		var Amount = dataForm.CHQ_AMOUNT1.value;
		var pendingfor = dataForm.PendingOptionsFinal.value;
		//alert("pendingfor--"+pendingfor);
		var param="&ProcessName="+processName+"&subProcessShortName="+window.document.getElementById("subProcessShortName").value+"&WIData="+window.document.getElementById("WIData").value+"&Amount="+Amount+"&Mobile_No="+Mobile_No+"&ProcessCode="+ProcessCode+"&pendingfor="+pendingfor+"&args="+args+"&Card_No="+(window.document.getElementById("CCI_CrdtCN").value).substring(12,16);
	}
	else if(ProcessCode == 'CSR_RR'){
		var Mobile_No = dataForm.CCI_MONO.value;
		var Amount = dataForm.CCI_AccInc.value;
		var reversalFor = dataForm.RRD_RFC.value;
		var pendingfor = dataForm.PendingOptionsFinal.value;
		var param="&ProcessName="+processName+"&subProcessShortName="+window.document.getElementById("subProcessShortName").value+"&WIData="+window.document.getElementById("WIData").value+"&Amount="+Amount+"&Mobile_No="+Mobile_No+"&ProcessCode="+ProcessCode+"&args="+args+"&reversalFor="+reversalFor+"&pendingfor="+pendingfor+"&Card_No="+(window.document.getElementById("CCI_CrdtCN").value).substring(12,16);
	}
	else if(ProcessCode == 'CSR_OCC'){
		var Mobile_No = dataForm.CCI_MONO.value;
		var Amount = dataForm.CCI_AccInc.value;
		var subprocess = dataForm.request_type.value;
		//alert("subprocess---"+subprocess);
		var param="&ProcessName="+processName+"&subProcessShortName="+window.document.getElementById("subProcessShortName").value+"&WIData="+window.document.getElementById("WIData").value+"&Amount="+Amount+"&subprocess="+subprocess+"&Mobile_No="+Mobile_No+"&ProcessCode="+ProcessCode+"&args="+args+"&Card_No="+(window.document.getElementById("CCI_CrdtCN").value).substring(12,16);
	}
	else if(ProcessCode == 'CSR_MR'){
		var Mobile_No = dataForm.CCI_MONO.value;
		var subprocess = dataForm.CCI_REQUESTTYPE.value;
		var CURAmount = dataForm.Curr_Amount.value;
		var SchoolName = dataForm.SchoolName.value;
		var MerchantName = dataForm.Merchant_Name.value;
		//alert("CURAmount---"+CURAmount+"SchoolName--"+SchoolName+"MerchantName--"+MerchantName);
		var param="&ProcessName="+processName+"&subProcessShortName="+window.document.getElementById("subProcessShortName").value+"&WIData="+window.document.getElementById("WIData").value+"&CURAmount="+CURAmount+"&subprocess="+subprocess+"&Mobile_No="+Mobile_No+"&SchoolName="+SchoolName+"&MerchantName="+MerchantName+"&ProcessCode="+ProcessCode+"&args="+args+"&Card_No="+(window.document.getElementById("CCI_CrdtCN").value).substring(12,16);
	}
	else if(ProcessCode == 'CSR_CCB'){
		var Mobile_No = dataForm.CCI_MONO.value;
		var Amount = dataForm.AVAILABLE_BALANCE.value;
		var param="&ProcessName="+processName+"&subProcessShortName="+window.document.getElementById("subProcessShortName").value+"&WIData="+window.document.getElementById("WIData").value+"&Amount="+Amount+"&Mobile_No="+Mobile_No+"&ProcessCode="+ProcessCode+"&args="+args+"&Card_No="+(window.document.getElementById("CCI_CrdtCN").value).substring(12,16);
	}
	else{
		var Mobile_No = dataForm.CCI_MONO.value;
		var Amount = dataForm.CCI_AccInc.value;
		var param="&ProcessName="+processName+"&subProcessShortName="+window.document.getElementById("subProcessShortName").value+"&WIData="+window.document.getElementById("WIData").value+"&Amount="+Amount+"&Mobile_No="+Mobile_No+"&ProcessCode="+ProcessCode+"&args="+args+"&Card_No="+(window.document.getElementById("CCI_CrdtCN").value).substring(12,16);
	}
	//END
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{
		//alert('3');
		 ajaxResult = xhr.responseText;
		 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		 		sResult = 	 ajaxResult;
		// return ajaxResult;
	}
	/************************************************************/
	//added below to handle window.open/window.showModalDialog according to type of browser  ends here.
	if(sResult == undefined)
	{
		//window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
			//window.parent.frames['frameClose'].document.forms[0].elements["Pending"].setAttribute('disabled', false);
//		alert("Error");

	}
	else
	{
		
		alert(sResult);

		//alert("inside introduce and enabling the button");
		if (sResult.indexOf('Created')==-1)
		{
			
			window.close();	
		}

		window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', true);
	window.parent.frames['frameClose'].document.forms[0].elements["Pending"].setAttribute('disabled', true);
//alert("11");
	}

}
function load()
{
	//alert("123--");
	window.parent.frames['frameClose'].document.location.href="CSR_initiate_bottom.jsp";
	
	//Modified by reddy
	//window.document.forms["dataform"].CCI_ExtNo.focus();
	//document.forms["dataform"].CCI_ExtNo.focus();
	//******
	
	var processName='<%=DecoderProcessName%>';
	if(processName=="Card Service Request - Other Credit Card Requests")
	{
		//alert("123--");
		if(typeof window.document.getElementById("RIP")!="undefined"&&window.document.getElementById("RIP")!=null)
		window.document.getElementById("RIP").style.display='none';
		if(typeof window.document.getElementById("CR")!="undefined"&&window.document.getElementById("CR")!=null)
		window.document.getElementById("CR").style.display='none';
		if(typeof window.document.getElementById("CLI")!="undefined" && window.document.getElementById("CLI")!=null)
		window.document.getElementById("CLI").style.display='none';
		if(typeof window.document.getElementById("ECR")!="undefined" && window.document.getElementById("ECR")!=null)
		window.document.getElementById("ECR").style.display='none';
		if(typeof window.document.getElementById("CSI")!="undefined" && window.document.getElementById("CSI")!=null)
		window.document.getElementById("CSI").style.display='none';
		if(typeof window.document.getElementById("TD")!="undefined" && window.document.getElementById("TD")!=null)
		window.document.getElementById("TD").style.display='none';
		if(typeof window.document.getElementById("CU")!="undefined" && window.document.getElementById("CU")!=null)
		window.document.getElementById("CU").style.display='none';
		if(typeof window.document.getElementById("CR")!="undefined" && window.document.getElementById("CR")!=null)
		window.document.getElementById("CR").style.display='none';
		if(typeof window.document.getElementById("CDR")!="undefined" && window.document.getElementById("CDR")!=null)
		window.document.getElementById("CDR").style.display='none';
		if(typeof window.document.getElementById("CS")!="undefined" && window.document.getElementById("CS")!=null)
		window.document.getElementById("CS").style.display='none';	
		if(typeof window.document.getElementById("SSC")!="undefined" && window.document.getElementById("SSC")!=null)
		window.document.getElementById("SSC").style.display='none';
		window.document.getElementById("subProcessShortName").value="";
		
		
		//alert("123");
	}
	return;
}

function showSubProcess(cntrl)
{
	if(cntrl.options[cntrl.selectedIndex].value=="Re-Issue of PIN")
	{
		if(typeof window.document.getElementById("RIP")!="undefined" && window.document.getElementById("RIP")!=null)
		window.document.getElementById("RIP").style.display='block';
		if(typeof window.document.getElementById("CR")!="undefined" && window.document.getElementById("CR")!=null)
		window.document.getElementById("CR").style.display='none';
		if(typeof window.document.getElementById("CLI")!="undefined" && window.document.getElementById("CLI")!=null)
		window.document.getElementById("CLI").style.display='none';
		if(typeof window.document.getElementById("ECR")!="undefined" && window.document.getElementById("ECR")!=null)
		window.document.getElementById("ECR").style.display='none';
		if(typeof window.document.getElementById("CSI")!="undefined" && window.document.getElementById("CSI")!=null)
		window.document.getElementById("CSI").style.display='none';
		if(typeof window.document.getElementById("TD")!="undefined" && window.document.getElementById("TD")!=null)
		window.document.getElementById("TD").style.display='none';
		if(typeof window.document.getElementById("CU")!="undefined" && window.document.getElementById("CU")!=null)
		window.document.getElementById("CU").style.display='none';
		if(typeof window.document.getElementById("SSC")!="undefined" && window.document.getElementById("SSC")!=null)
		window.document.getElementById("SSC").style.display='none';
		if(typeof window.document.getElementById("CDR")!="undefined" && window.document.getElementById("CDR")!=null)
		window.document.getElementById("CDR").style.display='none';
		if(typeof window.document.getElementById("CS")!="undefined" && window.document.getElementById("CS")!=null)
		window.document.getElementById("CS").style.display='none';
		window.document.getElementById("subProcessShortName").value="RIP";
		
	}
	if(cntrl.options[cntrl.selectedIndex].value=="Setup Suppl. Card Limit")
	{
		if(typeof window.document.getElementById("RIP")!="undefined" && window.document.getElementById("RIP")!=null)
		window.document.getElementById("RIP").style.display='none';
		if(typeof window.document.getElementById("CR")!="undefined" && window.document.getElementById("CR")!=null)
		window.document.getElementById("CR").style.display='none';
		if(typeof window.document.getElementById("CLI")!="undefined" && window.document.getElementById("CLI")!=null)
		window.document.getElementById("CLI").style.display='none';
		if(typeof window.document.getElementById("ECR")!="undefined" && window.document.getElementById("ECR")!=null)
		window.document.getElementById("ECR").style.display='none';
		if(typeof window.document.getElementById("CSI")!="undefined" && window.document.getElementById("CSI")!=null)
		window.document.getElementById("CSI").style.display='none';
		if(typeof window.document.getElementById("TD")!="undefined" && window.document.getElementById("TD")!=null)
		window.document.getElementById("TD").style.display='none';
		if(typeof window.document.getElementById("CU")!="undefined" && window.document.getElementById("CU")!=null)
		window.document.getElementById("CU").style.display='none';
		if(typeof window.document.getElementById("SSC")!="undefined" && window.document.getElementById("SSC")!=null)
		window.document.getElementById("SSC").style.display='block';
		if(typeof window.document.getElementById("CDR")!="undefined" && window.document.getElementById("CDR")!=null)
		window.document.getElementById("CDR").style.display='none';
		if(typeof window.document.getElementById("CS")!="undefined" && window.document.getElementById("CS")!=null)
		window.document.getElementById("CS").style.display='none';
		window.document.getElementById("subProcessShortName").value="SSC";
		
	}		
	if(cntrl.options[cntrl.selectedIndex].value=="Card Replacement")
	{
		if(typeof window.document.getElementById("RIP")!="undefined" && window.document.getElementById("RIP")!=null)
		window.document.getElementById("RIP").style.display='none';
		if(typeof window.document.getElementById("CR")!="undefined" && window.document.getElementById("CR")!=null)
		window.document.getElementById("CR").style.display='block';
		if(typeof window.document.getElementById("CLI")!="undefined" && window.document.getElementById("CLI")!=null)
		window.document.getElementById("CLI").style.display='none';
		if(typeof window.document.getElementById("ECR")!="undefined" && window.document.getElementById("ECR")!=null)
		window.document.getElementById("ECR").style.display='none';
		if(typeof window.document.getElementById("CSI")!="undefined" && window.document.getElementById("CSI")!=null)
		window.document.getElementById("CSI").style.display='none';
		if(typeof window.document.getElementById("TD")!="undefined" && window.document.getElementById("TD")!=null)
		window.document.getElementById("TD").style.display='none';
		if(typeof window.document.getElementById("CU")!="undefined" && window.document.getElementById("CU")!=null)
		window.document.getElementById("CU").style.display='none';
		if(typeof window.document.getElementById("SSC")!="undefined" && window.document.getElementById("SSC")!=null)
		window.document.getElementById("SSC").style.display='none';
		if(typeof window.document.getElementById("CDR")!="undefined" && window.document.getElementById("CDR")!=null)
		window.document.getElementById("CDR").style.display='none';
		if(typeof window.document.getElementById("CS")!="undefined" && window.document.getElementById("CS")!=null)
		window.document.getElementById("CS").style.display='none';
		window.document.getElementById("subProcessShortName").value="CR";
		
		
	}
	if(cntrl.options[cntrl.selectedIndex].value=="Credit Limit Increase")
	{
		if(typeof window.document.getElementById("RIP")!="undefined" && window.document.getElementById("RIP")!=null)
		window.document.getElementById("RIP").style.display='none';
		if(typeof window.document.getElementById("CR")!="undefined" && window.document.getElementById("CR")!=null)
		window.document.getElementById("CR").style.display='none';
		if(typeof window.document.getElementById("CLI")!="undefined" && window.document.getElementById("CLI")!=null)
		window.document.getElementById("CLI").style.display='block';
		if(typeof window.document.getElementById("ECR")!="undefined" && window.document.getElementById("ECR")!=null)
		window.document.getElementById("ECR").style.display='none';
		if(typeof window.document.getElementById("CSI")!="undefined" && window.document.getElementById("CSI")!=null)
		window.document.getElementById("CSI").style.display='none';
		if(typeof window.document.getElementById("TD")!="undefined" && window.document.getElementById("TD")!=null)
		window.document.getElementById("TD").style.display='none';
		if(typeof window.document.getElementById("CU")!="undefined" && window.document.getElementById("CU")!=null)
		window.document.getElementById("CU").style.display='none';		
		if(typeof window.document.getElementById("SSC")!="undefined" && window.document.getElementById("SSC")!=null)
		window.document.getElementById("SSC").style.display='none';
		if(typeof window.document.getElementById("CDR")!="undefined" && window.document.getElementById("CDR")!=null)
		window.document.getElementById("CDR").style.display='none';
		if(typeof window.document.getElementById("CS")!="undefined" && window.document.getElementById("CS")!=null)
		window.document.getElementById("CS").style.display='none';
		window.document.getElementById("subProcessShortName").value="CLI";
		
	}
	if(cntrl.options[cntrl.selectedIndex].value=="Early Card Renewal")
	{
		if(typeof window.document.getElementById("RIP")!="undefined" && window.document.getElementById("RIP")!=null)
		window.document.getElementById("RIP").style.display='none';
		if(typeof window.document.getElementById("CR")!="undefined" && window.document.getElementById("CR")!=null)
		window.document.getElementById("CR").style.display='none';
		if(typeof window.document.getElementById("CLI")!="undefined" && window.document.getElementById("CLI")!=null)
		window.document.getElementById("CLI").style.display='none';
		if(typeof window.document.getElementById("ECR")!="undefined" && window.document.getElementById("ECR")!=null)
		window.document.getElementById("ECR").style.display='block';
		if(typeof window.document.getElementById("CSI")!="undefined" && window.document.getElementById("CSI")!=null)
		window.document.getElementById("CSI").style.display='none';
		if(typeof window.document.getElementById("TD")!="undefined" && window.document.getElementById("TD")!=null)
		window.document.getElementById("TD").style.display='none';
		if(typeof window.document.getElementById("CU")!="undefined" && window.document.getElementById("CU")!=null)
		window.document.getElementById("CU").style.display='none';		
		if(typeof window.document.getElementById("SSC")!="undefined" && window.document.getElementById("SSC")!=null)
		window.document.getElementById("SSC").style.display='none';
		if(typeof window.document.getElementById("CDR")!="undefined" && window.document.getElementById("CDR")!=null)
		window.document.getElementById("CDR").style.display='none';
		if(typeof window.document.getElementById("CS")!="undefined" && window.document.getElementById("CS")!=null)
		window.document.getElementById("CS").style.display='none';
		window.document.getElementById("subProcessShortName").value="ECR";
		
	}
	if(cntrl.options[cntrl.selectedIndex].value=="Change in Standing Instructions")
	{
		if(typeof window.document.getElementById("RIP")!="undefined" && window.document.getElementById("RIP")!=null)
		window.document.getElementById("RIP").style.display='none';
		if(typeof window.document.getElementById("CR")!="undefined" && window.document.getElementById("CR")!=null)
		window.document.getElementById("CR").style.display='none';
		if(typeof window.document.getElementById("CLI")!="undefined" && window.document.getElementById("CLI")!=null)
		window.document.getElementById("CLI").style.display='none';
		if(typeof window.document.getElementById("ECR")!="undefined" && window.document.getElementById("ECR")!=null)
		window.document.getElementById("ECR").style.display='none';
		if(typeof window.document.getElementById("CSI")!="undefined" && window.document.getElementById("CSI")!=null)
		window.document.getElementById("CSI").style.display='block';
		if(typeof window.document.getElementById("TD")!="undefined" && window.document.getElementById("TD")!=null)
		window.document.getElementById("TD").style.display='none';
		if(typeof window.document.getElementById("CU")!="undefined" && window.document.getElementById("CU")!=null)
		window.document.getElementById("CU").style.display='none';		
		if(typeof window.document.getElementById("SSC")!="undefined" && window.document.getElementById("SSC")!=null)
		window.document.getElementById("SSC").style.display='none';
		if(typeof window.document.getElementById("CDR")!="undefined" && window.document.getElementById("CDR")!=null)
		window.document.getElementById("CDR").style.display='none';
		if(typeof window.document.getElementById("CS")!="undefined" && window.document.getElementById("CS")!=null)
		window.document.getElementById("CS").style.display='none';
		window.document.getElementById("subProcessShortName").value="CSI";
		
	}
	if(cntrl.options[cntrl.selectedIndex].value=="Transaction Dispute")
	{
		if(typeof window.document.getElementById("RIP")!="undefined" && window.document.getElementById("RIP")!=null)
		window.document.getElementById("RIP").style.display='none';
		if(typeof window.document.getElementById("CR")!="undefined" && window.document.getElementById("CR")!=null)
		window.document.getElementById("CR").style.display='none';
		if(typeof window.document.getElementById("CLI")!="undefined" && window.document.getElementById("CLI")!=null)
		window.document.getElementById("CLI").style.display='none';
		if(typeof window.document.getElementById("ECR")!="undefined" && window.document.getElementById("ECR")!=null)
		window.document.getElementById("ECR").style.display='none';
		if(typeof window.document.getElementById("CSI")!="undefined" && window.document.getElementById("CSI")!=null)
		window.document.getElementById("CSI").style.display='none';
		if(typeof window.document.getElementById("TD")!="undefined" && window.document.getElementById("TD")!=null)
		window.document.getElementById("TD").style.display='block';
		if(typeof window.document.getElementById("CU")!="undefined" && window.document.getElementById("CU")!=null)
		window.document.getElementById("CU").style.display='none';		
		if(typeof window.document.getElementById("SSC")!="undefined" && window.document.getElementById("SSC")!=null)
		window.document.getElementById("SSC").style.display='none';
		if(typeof window.document.getElementById("CDR")!="undefined" && window.document.getElementById("CDR")!=null)
		window.document.getElementById("CDR").style.display='none';
		if(typeof window.document.getElementById("CS")!="undefined" && window.document.getElementById("CS")!=null)
		window.document.getElementById("CS").style.display='none';
		window.document.getElementById("subProcessShortName").value="TD";
		
	}
	if(cntrl.options[cntrl.selectedIndex].value=="Card Upgrade")
	{
		if(typeof window.document.getElementById("RIP")!="undefined" && window.document.getElementById("RIP")!=null)
		window.document.getElementById("RIP").style.display='none';
		if(typeof window.document.getElementById("CR")!="undefined" && window.document.getElementById("CR")!=null)
		window.document.getElementById("CR").style.display='none';
		if(typeof window.document.getElementById("CLI")!="undefined" && window.document.getElementById("CLI")!=null)
		window.document.getElementById("CLI").style.display='none';
		if(typeof window.document.getElementById("ECR")!="undefined" && window.document.getElementById("ECR")!=null)
		window.document.getElementById("ECR").style.display='none';
		if(typeof window.document.getElementById("CSI")!="undefined" && window.document.getElementById("CSI")!=null)
		window.document.getElementById("CSI").style.display='none';
		if(typeof window.document.getElementById("TD")!="undefined" && window.document.getElementById("TD")!=null)
		window.document.getElementById("TD").style.display='none';
		if(typeof window.document.getElementById("CU")!="undefined" && window.document.getElementById("CU")!=null)
		window.document.getElementById("CU").style.display='block';		
		if(typeof window.document.getElementById("SSC")!="undefined" && window.document.getElementById("SSC")!=null)
		window.document.getElementById("SSC").style.display='none';
		if(typeof window.document.getElementById("CDR")!="undefined" && window.document.getElementById("CDR")!=null)
		window.document.getElementById("CDR").style.display='none';
		if(typeof window.document.getElementById("CS")!="undefined" && window.document.getElementById("CS")!=null)
		window.document.getElementById("CS").style.display='none';
		window.document.getElementById("subProcessShortName").value="CU";
		
	}
	if(cntrl.options[cntrl.selectedIndex].value=="Card Delivery Request")
	{
		if(typeof window.document.getElementById("RIP")!="undefined" && window.document.getElementById("RIP")!=null)
		window.document.getElementById("RIP").style.display='none';
		if(typeof window.document.getElementById("CR")!="undefined" && window.document.getElementById("CR")!=null)
		window.document.getElementById("CR").style.display='none';
		if(typeof window.document.getElementById("CLI")!="undefined" && window.document.getElementById("CLI")!=null)
		window.document.getElementById("CLI").style.display='none';
		if(typeof window.document.getElementById("ECR")!="undefined" && window.document.getElementById("ECR")!=null)
		window.document.getElementById("ECR").style.display='none';
		if(typeof window.document.getElementById("CSI")!="undefined" && window.document.getElementById("CSI")!=null)
		window.document.getElementById("CSI").style.display='none';
		if(typeof window.document.getElementById("TD")!="undefined" && window.document.getElementById("TD")!=null)
		window.document.getElementById("TD").style.display='none';
		if(typeof window.document.getElementById("CU")!="undefined" && window.document.getElementById("CU")!=null)
		window.document.getElementById("CU").style.display='none';	
		if(typeof window.document.getElementById("SSC")!="undefined" && window.document.getElementById("SSC")!=null)
		window.document.getElementById("SSC").style.display='none';
		if(typeof window.document.getElementById("CDR")!="undefined" && window.document.getElementById("CDR")!=null)
		window.document.getElementById("CDR").style.display='block';
		if(typeof window.document.getElementById("CS")!="undefined" && window.document.getElementById("CS")!=null)
		window.document.getElementById("CS").style.display='none';
		window.document.getElementById("subProcessShortName").value="CDR";
		
	}
	if(cntrl.options[cntrl.selectedIndex].value=="Credit Shield")
	{
		if(typeof window.document.getElementById("RIP")!="undefined" && window.document.getElementById("RIP")!=null)
		window.document.getElementById("RIP").style.display='none';
		if(typeof window.document.getElementById("CR")!="undefined" && window.document.getElementById("CR")!=null)
		window.document.getElementById("CR").style.display='none';
		if(typeof window.document.getElementById("CLI")!="undefined" && window.document.getElementById("CLI")!=null)
		window.document.getElementById("CLI").style.display='none';
		if(typeof window.document.getElementById("ECR")!="undefined" && window.document.getElementById("ECR")!=null)
		window.document.getElementById("ECR").style.display='none';
		if(typeof window.document.getElementById("CSI")!="undefined" && window.document.getElementById("CSI")!=null)
		window.document.getElementById("CSI").style.display='none';
		if(typeof window.document.getElementById("TD")!="undefined" && window.document.getElementById("TD")!=null)
		window.document.getElementById("TD").style.display='none';
		if(typeof window.document.getElementById("CU")!="undefined" && window.document.getElementById("CU")!=null)
		window.document.getElementById("CU").style.display='none';		
		if(typeof window.document.getElementById("SSC")!="undefined" && window.document.getElementById("SSC")!=null)
		window.document.getElementById("SSC").style.display='none';
		if(typeof window.document.getElementById("CDR")!="undefined" && window.document.getElementById("CDR")!=null)
		window.document.getElementById("CDR").style.display='none';
		if(typeof window.document.getElementById("CS")!="undefined" && window.document.getElementById("CS")!=null)
		window.document.getElementById("CS").style.display='block';
		window.document.getElementById("subProcessShortName").value="CS";
		
	}	
	if(cntrl.options[cntrl.selectedIndex].value=="")
	{
		if(typeof window.document.getElementById("RIP")!="undefined" && window.document.getElementById("RIP")!=null)
		window.document.getElementById("RIP").style.display='none';
		if(typeof window.document.getElementById("CR")!="undefined" && window.document.getElementById("CR")!=null)
		window.document.getElementById("CR").style.display='none';
		if(typeof window.document.getElementById("CLI")!="undefined" && window.document.getElementById("CLI")!=null)
		window.document.getElementById("CLI").style.display='none';
		if(typeof window.document.getElementById("ECR")!="undefined" && window.document.getElementById("ECR")!=null)
		window.document.getElementById("ECR").style.display='none';
		if(typeof window.document.getElementById("CSI")!="undefined" && window.document.getElementById("CSI")!=null)
		window.document.getElementById("CSI").style.display='none';
		if(typeof window.document.getElementById("TD")!="undefined" && window.document.getElementById("TD")!=null)
		window.document.getElementById("TD").style.display='none';
		if(typeof window.document.getElementById("CU")!="undefined" && window.document.getElementById("CU")!=null)
		window.document.getElementById("CU").style.display='none';		
		if(typeof window.document.getElementById("SSC")!="undefined" && window.document.getElementById("SSC")!=null)
		window.document.getElementById("SSC").style.display='none';
		if(typeof window.document.getElementById("CDR")!="undefined" && window.document.getElementById("CDR")!=null)
		window.document.getElementById("CDR").style.display='none';
		if(typeof window.document.getElementById("CS")!="undefined" && window.document.getElementById("CS")!=null)
		window.document.getElementById("CS").style.display='none';
		window.document.getElementById("subProcessShortName").value="";
		
	}
	return;
}

function replaceAll(data,searchfortxt,replacetxt)
{
	var startIndex=0;
	while(data.indexOf(searchfortxt)!=-1)
	{
		data=data.substring(startIndex,data.indexOf(searchfortxt))+data.substring(data.indexOf(searchfortxt)+1,data.length);
	}	
	return data;
}

</script>
</head>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' onload="load();" >
<form name="dataform">
<%String sProcessName=DecodersProcessName;%>

<%String sCCN=CreditCardNo.toString();%>
<jsp:include page="CSR_CommonBlocks.jsp">
<jsp:param name="CrdtCN" value="<%=sCCN%>"/>
<jsp:param name="ProcessName" value="<%=sProcessName%>"/>
</jsp:include>

<%if(sProcessName.equals("Card Service Request - Balance Transfer")){%>
<jsp:include page="../CSRProcessSpecific/CSR_ProcessSpec_BT.jsp" >
<jsp:param name="CrdtCN" value="<%=sCCN%>"/>
</jsp:include>
<%}
   else if(sProcessName.equals("Card Service Request - Credit Card Cheque")) 
	   {%>
<jsp:include page="../CSRProcessSpecific/CSR_ProcessSpec_CCC.jsp" >
<jsp:param name="CrdtCN" value="<%=sCCN%>"/>
</jsp:include>

<%}
   else if(sProcessName.equals("Card Service Request - Cash Back Request")) 
	   {%>
<jsp:include page="../CSRProcessSpecific/CSR_ProcessSpec_CBR.jsp" >
<jsp:param name="CrdtCN" value="<%=sCCN%>"/>
</jsp:include>

<%}
 else if(sProcessName.equals("Card Service Request - Reversals Request")) 
	   {%>
<jsp:include page="../CSRProcessSpecific/CSR_ProcessSpec_RR.jsp" >
<jsp:param name="CrdtCN" value="<%=sCCN%>"/>
</jsp:include>   

<%} else if(sProcessName.equals("Card Service Request - Credit Card Blocking Request")) {%>
<jsp:include page="../CSRProcessSpecific/CSR_ProcessSpec_CCB.jsp" >
<jsp:param name="CrdtCN" value="<%=sCCN%>"/>
</jsp:include>
<%}
 else if(sProcessName.equals("Card Service Request - Miscellaneous Requests")) {%>
<jsp:include page="../CSRProcessSpecific/CSR_ProcessSpec_MR.jsp" >
<jsp:param name="CrdtCN" value="<%=sCCN%>"/>
</jsp:include>
<%}

%>
<input type="text" id="PendingFor"name="PendingFor" style="visibility:hidden" >
<input type="text" id="PendingForECR"name="PendingForECR" style="visibility:hidden" >
<input type="text" id="PendingForCR"name="PendingForCR" style="visibility:hidden" >
<input type="text" id="PendingForCU"name="PendingForCU" style="visibility:hidden" >
<input type="text" id="PendingForCLI"name="PendingForCLI" style="visibility:hidden" >
<input type="text" id="PendingForRIP"name="PendingForRIP" style="visibility:hidden" >
<input type="text" id="PendingForSSC"name="PendingForSSC" style="visibility:hidden" >
<input type="text" id="PendingForCSI"name="PendingForCSI" style="visibility:hidden" >
<input type=text readOnly name="ProcessCode" id="ProcessCode" value='<%=DecoderProcessCode%>' style='display:none'>
<input type=text readOnly name="CCI_CrdtCN" id="CCI_CrdtCN" value='<%=CreditCardNo%>' style='display:none'>
<input type='text' style='display:none' id='WIData'>
</form>
</body>