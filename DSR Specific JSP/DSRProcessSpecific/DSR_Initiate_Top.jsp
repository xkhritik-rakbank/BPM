<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation 
//File Name					 : initiate_Top.jsp
//Author                     : Manish K. Agrawal
// Date written (DD/MM/YYYY) : 13-Oct-2006
//Description                : Takes input from user-Agreement No/Loan Eq No.
//---------------------------------------------------------------------------------------------------->



<%@ include file="Log.process"%>
<%@ include file="/generic/wdcustominit.jsp"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<!--<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>-->

<!--File contains function for reading dateformat from webdesktop.ini-->
<%@ include file="/CustomForms/RAKBANK/CommonJsp.jsp"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->


<HTML>
	<HEAD>
		<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>
	</HEAD>

<%

	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("BranchCode", request.getParameter("BranchCode"), 1000, true) );
	String BranchCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: BranchCode: "+BranchCode);
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("BranchName", request.getParameter("BranchName"), 1000, true) );
	String BranchName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	BranchName=BranchName.replace("&#x7e;","~");
	WriteLog("Integration jsp: BranchName: "+BranchName);
	
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessCode", request.getParameter("ProcessCode"), 1000, true) );
	String ProcessCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	WriteLog("Integration jsp: ProcessCode: "+ProcessCode);
	
	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", request.getParameter("ProcessName"), 1000, true) );
	String ProcessName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	WriteLog("Integration jsp: ProcessName: "+ProcessName);
	
	String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("strCSMMailId", request.getParameter("strCSMMailId"), 1000, true) );
	String strCSMMailId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
	WriteLog("Integration jsp: strCSMMailId: "+strCSMMailId);
	
	String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("strBMailId", request.getParameter("strBMailId"), 1000, true) );
	String strBMailId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
	WriteLog("Integration jsp: strBMailId: "+strBMailId);

	//Get parameter values
	String strBranchCode=BranchCode;
	String strBranchName=BranchName;
	String strProcessCode=ProcessCode;
	String strProcessName=ProcessName;
	//String strCSMMailId=request.getParameter("strCSMMailId");
	//String strBMailId=request.getParameter("strBMailId");
	WDUserInfo wDUserInfo = wDSession.getM_objUserInfo();
	String suserName = wDUserInfo.getM_strUserName()+"";
//out.println(strBranchCode);

%>

<!-- <script language="javascript" src="/webdesktop/webtop/en_us/scripts/RBCommon.js"></script> -->
<script language="javascript">

var strDateFormat="<%=DateFormat%>";

if (document.layers)
  document.captureEvents(Event.KEYDOWN);
document.onkeydown =
  function (evt) {
    var keyCode = evt ? (evt.which ? evt.which : evt.keyCode) : event.keyCode;
    if (keyCode == 13) {     
		validate();
        return false;
    }
    else
      return true;
  };


//----------------------------------------------------------------------------------------------------
//Function Name                    : validate()
//Date Written (DD/MM/YYYY)        : 13-Oct-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : NA
//Output Parameters                : NA
//Return Values                    : NA
//Description                      : Mandatory check on AgreementNo/txtAgreementNo.
//----------------------------------------------------------------------------------------------------

function validate()
{
	
	try{
	
	 	
		if(document.forms["dataform"].txtDebitCardNo.value=="")
		{
			alert("Debit Card No is Mandatory");
			document.forms["dataform"].txtDebitCardNo.focus();
			return false;
		}		
		regex=/^[0-9]{16}$/;
		if(regex.test(document.forms["dataform"].txtDebitCardNo.value))
		{
			//alert("Only Numerics are allowed in Debit Card No");

			var vCCN=document.forms["dataform"].txtDebitCardNo.value;
			document.forms["dataform"].txtDebitCardNo.value=vCCN.substring(0,4)+"-"+vCCN.substring(4,8)+"-"+vCCN.substring(8,12)+"-"+vCCN.substring(12,16);

			return false;
		}		

		regex=/^[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{4}$/;
		if(!regex.test(document.forms["dataform"].txtDebitCardNo.value))
		{
			alert("Invalid Debit Card No Format");
			document.forms["dataform"].txtDebitCardNo.value="";
			return false;
		}		
		regex=/^[0-9]{16}$/;
		
		if(!regex.test(replaceAll(document.forms["dataform"].txtDebitCardNo.value,"-","")))
		{
			alert("Length Of Debit Card No Should be exactly 16 digits.");
			document.forms["dataform"].txtDebitCardNo.value="";
			document.forms["dataform"].txtDebitCardNo.focus();
			return false;
		}		
		if(!mod10( replaceAll(document.forms["dataform"].txtDebitCardNo.value,"-","")))
		{
			alert("Invalid Debit Card No.");
			document.forms["dataform"].txtDebitCardNo.value="";
			document.forms["dataform"].txtDebitCardNo.focus();
			return false;
		}
		document.forms["dataform"].DebitCardNo.value=replaceAll(document.forms["dataform"].txtDebitCardNo.value,"-","");
		
		document.forms.dataform.submit();
		return true;
	}catch(e){
		alert(e.message);
	}
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

function mod10( cardNumber ) 
{ 	
           var clen = new Array( cardNumber.length ); 
           var n = 0,sum = 0; 
           for( n = 0; n < cardNumber.length; ++n ) 
		      { 
                      clen [n] = parseInt ( cardNumber.charAt(n) ); 
			  } 
          for( n = clen.length -2; n >= 0; n-=2 ) 
				{
					  clen [n] *= 2; 	
			          if( clen [n] > 9 ) 
				          clen [n]-=9; 
				}

	     for( n = 0; n < clen.length; ++n ) 
		        { 
					  sum += clen [n]; 
		        } 
				
		 return(((sum%10)==0)?true : false);
}

function fetch()
{
	document.forms.dataform.strMessage.style.display="none";
	document.forms.dataform.OK.disabled=false;
}

function clearFrames(){
	try{
		//alert("BC");
		window.parent.frames['frameProcess'].document.location.href="DSR_blank.jsp";
		window.parent.frames['frameClose'].document.location.href="DSR_blank.jsp";
	}catch(e){
		alert(e.message);
	}
}

function validateCCN(cntrl)
{
	
	var keycode=event.keyCode;
	
	var cntrlValue=cntrl.value;

	
	if(keycode!=46&&keycode!=8&&(cntrlValue.length==4||cntrlValue.length==9||cntrlValue.length==14))
		cntrl.value=cntrlValue+"-";
	
}

function validateCCNDataOnKeyUp(cntrl)
{

	var regex=/^[0-9]{16}$/;
		if(regex.test(document.forms["dataform"].txtDebitCardNo.value))
		{
			
			var vCCN=document.forms["dataform"].txtDebitCardNo.value;
			document.forms["dataform"].txtDebitCardNo.value=vCCN.substring(0,4)+"-"+vCCN.substring(4,8)+"-"+vCCN.substring(8,12)+"-"+vCCN.substring(12,16);
			return false;
		}		

	var	regex = /^([0-9]{0,4}|[0-9]{4}-|[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{0,4})$/;	

	var keycode=event.keyCode;
	if(!(keycode>95&&keycode<106)&&!(keycode>47&&keycode<58)&&keycode!=8&&keycode!=145&&keycode!=19&&keycode!=45&&keycode!=33&&keycode!=34&&keycode!=35&&keycode!=36&&keycode!=37&&keycode!=38&&keycode!=39&&keycode!=40&&keycode!=46&&cntrl.value!=""&&!regex.test(cntrl.value))
		{
		alert("Invalid Debit Card No. Format");
		cntrl.value="";
		cntrl.focus();
		return false;
		}		
}
 
</script>

<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' onload='clearFrames()'>
<form name="dataform" action="DSR_Initiate_center.jsp" target="frameProcess" method="post" > 
<table width=100% border=0>
	<tr width=100%>
		<td width=60% class="EWLargeLabel" align=right valign=center>Debitcard Service Request Initiation Module</td>
		<td width=40% align=right valign=center><img src="\webdesktop\webtop\images\rak-logo.gif"></td>
	</tr>
</table>
<table border="1" cellspacing="1" cellpadding="1" width=98.4% >
	<TR class="EWHeader" width=100%>
		<td class="EWLabelRB2" colspan=1>&nbsp;&nbsp;Logged In As <b><%=suserName%></b></td>
		<td class="EWLabelRB2" align=right colspan=3>
		<%
			DateFormat dtFormat = new SimpleDateFormat(DateFormat + " hh:mm");
			String dateFormat = dtFormat.format(new java.util.Date());
			//out.println("<b>"+dateFormat+"</b>");
		%>
		<script>var jsToday="<%=new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date())%>";</script>
		</td>
	</tr>
	<tr>
		<td nowrap width="180" height="16" class="EWLabelRB">Branch Id</td>
		
		<%
		StringTokenizer stk=new StringTokenizer(strBranchName,"~");
		StringTokenizer stk2=new StringTokenizer(strBranchCode,"~");
		while (stk.hasMoreElements()&&stk2.hasMoreElements()){
				strBranchName=(String)stk.nextElement();
				out.println(strBranchName);
				strBranchCode=(String)stk2.nextElement();
				out.println(strBranchCode);
			}

		%>		
		
		<td nowrap class="" colspan=3><b><%=strBranchName%></b>
		<script>var jsBranchName="<%=strBranchName%>"; </script>
		</td>

	</TR>	
	<TR>
		<td nowrap width="180" height="16" class="EWLabelRB">Service Type-Request Type</td>
		<td nowrap colspan=3><b><%=strProcessName%>(<%=strProcessCode%>)</b></td>
	</TR>		
	<TR>
        <td nowrap width="180" height="16" class="EWLabelRB">Debit Card No.</td>
        <td nowrap colspan=3><input type="text" name="txtDebitCardNo" onKeyUp="validateCCNDataOnKeyUp(this);"    
 onkeydown="validateCCN(this);" value='' size="20" maxlength=19 style='width:150px;'> &nbsp;&nbsp;&nbsp;&nbsp;<input name="REFRESH" type=button value="REFRESH" onclick="validate()" class="EWButtonRB" style='width:60px'></td>
	</tr>
	
</table>




<input type=hidden name="BranchCodeName" style="visibility:hidden" value=<%=strBranchCode%>>
<input type=hidden name="ProcessCode" style="visibility:hidden" value=<%=strProcessCode%>>
<input type=hidden name="ProcessName" style="visibility:hidden" value=<%=URLEncoder.encode(strProcessName,"UTF-8")%>>
<input type=hidden name="strCSMMailId" style="visibility:hidden" value=<%=strCSMMailId%>>
<input type=hidden name="strBMailId" style="visibility:hidden" value=<%=strBMailId%>>
<input type=hidden name="DebitCardNo" style="visibility:hidden" >
<input type=hidden name="EquationLoanAccNo" style="visibility:hidden" >
</form>


</body>
</html>