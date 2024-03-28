<%@ page import="java.io.*,java.util.*,java.math.*,java.lang.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@ page import ="java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="Log.process"%>

<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>

<head>
	<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>
	<script language="javascript" src="/webdesktop/webtop/en_us/scripts/DSR_RBCommon.js"></script>
	<script language="javascript" src="/webdesktop/webtop/scripts/DSR_Scripts/RAKdatevalidation.js"></script>
	<script language="javascript" src="/webdesktop/webtop/scripts/calendar1.js"></script>
	<script language="javascript">
		var strDateFormat="dd/MM/yyyy";
		function numericapprovalcode(e)
		{
			var re;
			re = /[^0-9]/g;
			if(re.test(e.value))
			{
				e.value ="";
			}
			return true;
		}
		function validateNumericDataOnKeyUp(cntrl)
		{
			var regex = /[^0-9]/g;
			if (regex.test(cntrl.value))
			{
				cntrl.value="";		
				cntrl.focus();
				return false;
			}
		}
		function validateAmountDataOnKeyUp(cntrl)
		{
			re=/^([0-9]{0,8}\.|[0-9]{0,8}\.[0-9]{1,2}|[0-9]{0,8})$/;	
			if(!re.test(replaceAll(cntrl.value,",","")))
			{
				cntrl.value="";
				cntrl.value = cntrl.value.replace(re,""); 
			}
			return false;
/*			var regex =  /^([0-9]{0,8}\.|[0-9]{0,8}\.[0-9]{1,2}|[0-9]{0,8})$/;
			if (!regex.test(cntrl.value))
			{
				cntrl.value="";		
				cntrl.focus();
				return false;
			}
*/
		}
		function validateAmountDataOnKeyUpLimitAed(cntrl)
		{
			if (cntrl.value=="0"||cntrl.value=="0.0"||cntrl.value=="0.00")
			{
				return true;
			}
			re=/^([0-9]{0,8}\.|[0-9]{0,8}\.[0-9]{1,2}|[0-9]{0,8})$/;	
			if(!re.test(replaceAll(cntrl.value,",","")))
			{
				cntrl.value="";
				cntrl.value = cntrl.value.replace(re,""); 
			}
			return false;
		}
		function validateKeys_OnBlurLimitAed(cntrl)
		{
			if (cntrl.value=="0"||cntrl.value=="0.0"||cntrl.value=="0.00")
			{
				cntrl.value="0.00";
				return true;
			}
			re = /[^0-9.,]/g;
			if(re.test(cntrl.value))
			{
				alert("Only numbers and . are allowed.");
				cntrl.value = cntrl.value.replace(re,""); 
				cntrl.focus();
			}
			re = /[^0-9.]/g;
			cntrl.value = cntrl.value.replace(re,"");
			cntrl.value = cntrl.value.replace(/^[0]+/g,""); 
			dollarAmount(cntrl); 
			return false;		
		}
		function validateAmountDataOnKeyUpWithNegative(cntrl)
		{
			re=/^([0-9]{0,8}\.|[0-9]{0,8}\.[0-9]{1,2}|[0-9]{0,8})$/;
			if (cntrl.value=="0"||cntrl.value=="0.0"||cntrl.value=="0.00")
			{
				return true;
			}
			if (cntrl.value.substring(0,1)=="-")
			{
				if(!re.test(replaceAll(cntrl.value.substring(1,cntrl.value.length),",","")))
				{
					cntrl.value="";
					cntrl.value = cntrl.value.replace(re,""); 
				}			
			}
			else if (cntrl.value.substring(0,1)!="-")
			{
				if(!re.test(replaceAll(cntrl.value,",","")))
				{
					cntrl.value="";
					cntrl.value = cntrl.value.replace(re,""); 
				}
			}
			return false;
		}
		function validateKeys_OnBlurWithNegative(cntrl)
		{
			re = /[^0-9.,]/g;
			if (cntrl.value=="0"||cntrl.value=="0.0"||cntrl.value=="0.00"||cntrl.value=="-0.00"||cntrl.value=="-0.0"||cntrl.value=="-0")
			{
				cntrl.value="0.00";
				return true;
			}
			else if (cntrl.value=="-")
			{
				cntrl.value="";
			}
			if (cntrl.value.substring(0,1)=="-")
			{
				if(re.test(cntrl.value.substring(1,cntrl.value.length)))
				{
					alert("Only numbers and . are allowed.");
					cntrl.value = cntrl.value.replace(re,""); 
					cntrl.focus();
				}
				re = /[^0-9.]/g;
				cntrl.value = cntrl.value.replace(re,"");
				cntrl.value = cntrl.value.replace(/^[0]+/g,""); 
				cntrl.value = "-" + cntrl.value;
				dollarAmountWithNegative(cntrl); 
				return false;	
			}
			if(re.test(cntrl.value))
			{
				alert("Only numbers and . are allowed.");
				cntrl.value = cntrl.value.replace(re,""); 
				cntrl.focus();
			}
			re = /[^0-9.]/g;
			cntrl.value = cntrl.value.replace(re,"");
			cntrl.value = cntrl.value.replace(/^[0]+/g,""); 
			dollarAmountWithNegative(cntrl); 
			return false;		
		}
		function dollarAmountWithNegative(field) 
		{
			if (field.value.substring(0,1)=="-")
			{
				Num = "" + field.value.substring(1,field.value.length);
				dec = Num.indexOf(".");
				end = ((dec > -1) ? "" + Num.substring(dec,Num.length) : ".00");
				Num = "" + parseInt(Num);
				var temp1 = "";
				var temp2 = "";
				if (checkNum(Num) == 0)
				{
				}
				else
				{
					if (end.length == 2) end += "0";
					if (end.length == 1) end += "00";
					if (end == "") end += ".00";
					var count = 0;
					for (var k = Num.length-1; k >= 0; k--)
					{
						var oneChar = Num.charAt(k);
						if (count == 3)
						{
							temp1 += ",";
							temp1 += oneChar;
							count = 1;
							continue;
						}
						else 
						{
							temp1 += oneChar;
							count ++;
						}
					}
					for (var k = temp1.length-1; k >= 0; k--)
					{
						var oneChar = temp1.charAt(k);
						temp2 += oneChar;
					}
					temp2 = temp2 + end;
					field.value="-"+temp2;
				}			
			}
			else if (field.value.substring(0,1)!="-")
			{
				Num = "" + field.value;
				dec = Num.indexOf(".");
				end = ((dec > -1) ? "" + Num.substring(dec,Num.length) : ".00");
				Num = "" + parseInt(Num);
				var temp1 = "";
				var temp2 = "";
				if (checkNum(Num) == 0)
				{
				}
				else
				{
					if (end.length == 2) end += "0";
					if (end.length == 1) end += "00";
					if (end == "") end += ".00";
					var count = 0;
					for (var k = Num.length-1; k >= 0; k--)
					{
						var oneChar = Num.charAt(k);
						if (count == 3)
						{
							temp1 += ",";
							temp1 += oneChar;
							count = 1;
							continue;
						}
						else 
						{
							temp1 += oneChar;
							count ++;
						}
					}
					for (var k = temp1.length-1; k >= 0; k--)
					{
						var oneChar = temp1.charAt(k);
						temp2 += oneChar;
					}
					temp2 = temp2 + end;
					field.value=temp2;
				}				
			}
		}
		function validateAlphaNumericDataOnKeyUp(cntrl)
		{
			var regex = /[^a-zA-Z0-9.,()@$/\s-_]/g;
			if (regex.test(cntrl.value))
			{
				cntrl.value="";		
				cntrl.focus();
				return false;
			}
		}
		function initialise(TxtboxInputID)
		{
			document.getElementById(TxtboxInputID).value='';
			var cal1 = new calendar1(document.getElementById(TxtboxInputID));
			cal1.year_scroll = true;
			cal1.time_comp = false;
			cal1.popup();
			return true;			
		}
		function CheckMxLength(cntrl,val)
		{
			var issue=cntrl.value;
			if(issue.length>=val+1)
			{
				alert("Field length can't be greater than "+val+" Characters");
				var lengthRR="";
				lengthRR=issue.substring(0,val);
				cntrl.value=lengthRR;
			}
			return true;
		}
		function clearFrames()
		{
			window.parent.frames['frmData'].document.location.href="EAR_blank_withLogo.jsp"; 
			return false;
		}
		function exit()
		{
			window.parent.close();
			return false;
		}
		function validateProcessData()
		{
			/*if (document.getElementById("referenceNo").value=='')
			{
				alert('Reference Number cannot be blank');
				document.getElementById("referenceNo").focus();
				return false;
			}*/
			
			/*
			if (document.getElementById("referenceNo").value!='')
			{
				if (document.getElementById("referenceNo").value.length!=13)
				{
					alert('Length of Reference Number should be 13');
					document.getElementById("referenceNo").focus();
					return false;
				}
			}
			
			else */ if (document.getElementById("accountNo").value=='')
			{
				alert('A/C No. cannot be blank');
				document.getElementById("accountNo").focus();
				return false;
			}
			else if (document.getElementById("accountNo").value.length!=13)
			{
				alert('Length of A/C No. should be 13');
				document.getElementById("accountNo").focus();
				return false;
			}
			else if (document.getElementById("name").value=='')
			{
				alert('Name cannot be blank');
				document.getElementById("name").focus();
				return false;
			}
/*			else if (document.getElementById("limitAED").value=='')
			{
				alert('Limit AED cannot be blank');
				document.getElementById("limitAED").focus();
				return false;
			}
			else if (document.getElementById("limitExpiryDate").value=='')
			{
				alert('Please select Limit Expiry Date');
				document.getElementById("limitExpiryDate").focus();
				return false;
			}*/
			else if (document.getElementById("previousBalance").value=='')
			{
				alert('Previous Balance cannot be blank');
				document.getElementById("previousBalance").focus();
				return false;
			}
			else if (document.getElementById("thisTrxAED").value=='')
			{
				alert('This Trx AED cannot be blank');
				document.getElementById("thisTrxAED").focus();
				return false;
			}
			else if (document.getElementById("excessCreated").value=='')
			{
				alert('Excess created cannot be blank');
				document.getElementById("excessCreated").focus();
				return false;
			}
			else if (document.getElementById("newBalance").value=='')
			{
				alert('New Balance cannot be blank');
				document.getElementById("newBalance").focus();
				return false;
			}
			else if (document.getElementById("dateACLastRegular").value=='')
			{
				alert('Please select Date A/C last regular');
				document.getElementById("dateACLastRegular").focus();
				return false;
			}
			else if (!Datediff2(document.getElementById("dateACLastRegular").value,'Date A/C Last Regular'))
			{
				return false;
			}
			else if (document.getElementById("regularizationDate").value=='')
			{
				alert('Please select Reqularization Date');
				document.getElementById("regularizationDate").focus();
				return false;
			}
			else
			{
				var result=Datediff(document.getElementById("regularizationDate").value,'Regularization Date');
				return result;
			}
			return true;
		}
		function Datediff2(DateField,dateFieldName)
		{ 
			var depDate=DateField;
			if(depDate=="")
			{
				return false;
			}
			var dd1=depDate.substring(0,2);
			var mm1=depDate.substring(3,5);
			var yy1=depDate.substring(6,10);
			var depDate1=yy1+'/'+mm1+'/'+dd1;
			var Cur1Date=document.getElementById("sysDate").value;
			var dd2=Cur1Date.substring(0,2);
			var mm2=Cur1Date.substring(3,5);
			var yy2=Cur1Date.substring(6,10);
			var CurDate1=yy2+'/'+mm2+'/'+dd2;
			var CurDate2=new Date(CurDate1);
			var depDate2=new Date(depDate1);
			var days = ((depDate2.getTime() - CurDate2.getTime())/(1000*60*60*24));	
			if (Number(days) > 0)
			{
				alert(dateFieldName+" cannot be greater than Current Date");
				document.getElementById("dateACLastRegular").value="";
				return false;
			}
			return true;
		}
		function Datediff(DateField,DateFieldValue)
		{ 
			var depDate=DateField;
			if(depDate=="")
			{
				return false;
			}
			var dd1=depDate.substring(0,2);
			var mm1=depDate.substring(3,5);
			var yy1=depDate.substring(6,10);
			var depDate1=yy1+'/'+mm1+'/'+dd1;
			var Cur1Date=document.getElementById("sysDate").value;
			var dd2=Cur1Date.substring(0,2);
			var mm2=Cur1Date.substring(3,5);
			var yy2=Cur1Date.substring(6,10);
			var CurDate1=yy2+'/'+mm2+'/'+dd2;
			var CurDate2=new Date(CurDate1);
			var depDate2=new Date(depDate1);
			var days = ((depDate2.getTime() - CurDate2.getTime())/(1000*60*60*24));	
			if (Number(days) < 0)
			{
				alert(DateFieldValue+" cannot be less than Current Date");
				document.getElementById("regularizationDate").value="";
				return false;
			}
			return true;
		}
		function validateKeys_OnBlur(cntrl)
		{
			re = /[^0-9.,]/g;
			if(re.test(cntrl.value))
			{
				alert("Only numbers and . are allowed.");
				cntrl.value = cntrl.value.replace(re,""); 
				cntrl.focus();
			}
			re = /[^0-9.]/g;
			cntrl.value = cntrl.value.replace(re,"");
			cntrl.value = cntrl.value.replace(/^[0]+/g,""); 
			dollarAmount(cntrl); 
			return false;		
		}
		function dollarAmount(field) 
		{
			Num = "" + field.value;
			dec = Num.indexOf(".");
			end = ((dec > -1) ? "" + Num.substring(dec,Num.length) : ".00");
			Num = "" + parseInt(Num);
			var temp1 = "";
			var temp2 = "";
			if (checkNum(Num) == 0)
			{
			}
			else
			{
				if (end.length == 2) end += "0";
				if (end.length == 1) end += "00";
				if (end == "") end += ".00";
				var count = 0;
				for (var k = Num.length-1; k >= 0; k--)
				{
					var oneChar = Num.charAt(k);
					if (count == 3)
					{
						temp1 += ",";
						temp1 += oneChar;
						count = 1;
						continue;
					}
					else 
					{
						temp1 += oneChar;
						count ++;
					}
				}
				for (var k = temp1.length-1; k >= 0; k--)
				{
					var oneChar = temp1.charAt(k);
					temp2 += oneChar;
				}
				temp2 = temp2 + end;
				field.value=temp2;
			}
		}
		function introduce()
		{
			if(!validateProcessData())
				return false;

			var sFeatures="dialogHeight:0px; dialogWidth:0px; center=yes; dialogLeft:1500;dialogTop:1500;status:yes; ";
			var sResult = window.showModalDialog('EARIntroduceFrameset.jsp',document.forms.dataform,sFeatures);

			if(sResult == undefined)
			{
			}
			else
			{
				alert(sResult);
				if (sResult.indexOf('Created')==-1)
					window.parent.close();
				else
					window.parent.frames['frmData'].document.location.href="EAR_blank_withLogo.jsp"; 
			}

		}
	</script>
<%
	String strBranchCode=request.getParameter("BranchCode");
	String strBranchName=request.getParameter("BranchName");
	String strProcessCode=request.getParameter("ProcessCode");
	String strProcessName=request.getParameter("ProcessName");
	StringTokenizer stk=new StringTokenizer(strBranchName,"~");
	StringTokenizer stk2=new StringTokenizer(strBranchCode,"~");
	while (stk.hasMoreElements()&&stk2.hasMoreElements())
	{
		strBranchName=(String)stk.nextElement();
		strBranchCode=(String)stk2.nextElement();
	}
	String sCabname=null;
	String sSessionId = null;
	String sJtsIp = null;
	int iJtsPort = 0;
	boolean bError=false;
	try
	{
		sCabname=wfsession.getEngineName();
		sSessionId = wfsession.getSessionId();
		sJtsIp = wfsession.getJtsIp();
		iJtsPort = wfsession.getJtsPort();
	}
	catch(Exception ignore)
	{
		bError=true;
		WriteLog(ignore.toString());
	}
%>
</head>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB'>
	<table width=100% border=0>
		<tr width=100%>
			<td width=60% class="EWLargeLabel" align=right valign=center>Excess Authorization Request Initiation Module</td>
			<td width=40% align=right valign=center><img src="\webdesktop\webtop\images\rak-logo.gif"></td>
		</tr>
	</table>
	<table border=0 cellspacing=0 cellpadding=0 width=98.4% >
		<TR class="EWHeader" width=100%>
			<td class="EWLabelRB2" colspan=1>&nbsp;&nbsp;</b></td>
			<td class="EWLabelRB2" align=right>
			</td>
		</tr>
	</table>
	<form name="dataform"> 
		<table border="1" cellspacing="1" cellpadding="1" width=100% >
			<TR>
				<td nowrap width="150" height="16" class="EWLabelRB" id="userIDLabel">User ID</td>
				<td nowrap  width="150"><input type="text" name="userID" value='<%=wfsession.getUserName()%>' disabled size="8" maxlength=90 style='width:150px;' ></td>
			</tr>	
			<TR>
				<td nowrap width="150" height="16" class="EWLabelRB" id="sysDateLabel">Date</td>
				<td nowrap  width="150"><input type="text" name="sysDate" value='<%=new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date())%>' disabled size="8" maxlength=90 style='width:150px;' ></td>
			</tr>		
			<TR>
				<td nowrap width="150" height="16" class="EWLabelRB" id="USER_BRANCHLabel">Branch</td>
				<td nowrap  width="150"><input type="text" name="USER_BRANCH" value='<%=strBranchName%>' disabled size="8" maxlength=90 style='width:150px;' ></td>
			</tr>
		</table>
		<br>
		<table border="1" cellspacing="1" cellpadding="1" width=100% >
			<TR>
				<td nowrap width="150" height="16" class="EWLabelRB" id="referenceNoLabel">Reference Number</td>
				<td nowrap  width="150"><input type="text" name="referenceNo" size="8" maxlength=13 onKeyUp="validateNumericDataOnKeyUp(this);" onblur="validateNumericDataOnKeyUp(this);" style='width:150px;' ></td>
				<td nowrap width="150" height="16" class="EWLabelRB" id="accountNoLabel">A/C No.</td>
				<td nowrap  width="150"><input type="text" name="accountNo" size="8" maxlength=13 onKeyUp="validateNumericDataOnKeyUp(this);"  onblur="validateNumericDataOnKeyUp(this);" style='width:150px;' ></td>
			</tr>
			<TR>
				<td nowrap width="150" height="16" class="EWLabelRB" id="nameLabel">Name</td>
				<td nowrap  width="150"><input type="text" name="name" size="8" maxlength=70 onKeyUp="validateAlphaNumericDataOnKeyUp(this);" style='width:150px;' ></td>
				<td nowrap width="150" height="16" class="EWLabelRB" id="limitAEDLabel">Limit AED</td>
				<td nowrap  width="150"><input type="text" name="limitAED" size="8" maxlength=11 onKeyUp="validateAmountDataOnKeyUpLimitAed(this);" onblur="validateKeys_OnBlurLimitAed(this);" style='width:150px;' ></td>
			</tr>	
			<TR>
				<td nowrap width="150" height="16" class="EWLabelRB" id="limitExpiryDateLabel">Limit Expiry Date</td>
				<td nowrap  width="150"><input type="text" id="limitExpiryDate" name="limitExpiryDate" size="8" readonly maxlength=70 style='width:125px;'>&nbsp;&nbsp;<a href='1' onclick = "initialise('limitExpiryDate');return false;" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>
				<td nowrap width="150" height="16" class="EWLabelRB" id="previousBalanceLabel">Previous Balance</td>
				<td nowrap  width="150"><input type="text" name="previousBalance" size="8" maxlength=11 onKeyUp="validateAmountDataOnKeyUpWithNegative(this);" onblur="validateKeys_OnBlurWithNegative(this);" style='width:150px;' ></td>
			</tr>	
			<TR>
				<td nowrap width="150" height="16" class="EWLabelRB" id="thisTrxAEDLabel">This Trx AED</td>
				<td nowrap  width="150"><input type="text" name="thisTrxAED" size="8" maxlength=11 onKeyUp="validateAmountDataOnKeyUp(this);" onblur="validateKeys_OnBlur(this);" style='width:150px;'></td>
				<td nowrap width="150" height="16" class="EWLabelRB" id="excessCreatedLabel" size="8" maxlength=10 style='width:125px;'>Excess created</td>
				<td nowrap  width="150"><input type="text" name="excessCreated" size="8" maxlength=11 onKeyUp="validateAmountDataOnKeyUp(this);" onblur="validateKeys_OnBlur(this);" style='width:150px;' ></td>
			</tr>	
			<TR>
				<td nowrap width="150" height="16" class="EWLabelRB" id="newBalanceLabel">New Balance</td>
				<td nowrap  width="150"><input type="text" name="newBalance" size="8" maxlength=11 onKeyUp="validateAmountDataOnKeyUpWithNegative(this);" onblur="validateKeys_OnBlurWithNegative(this);" style='width:150px;' ></td>
				<td nowrap width="150" height="16" class="EWLabelRB" id="dateACLastRegularLabel">Date A/C last regular
				</td>
				<td nowrap  width="150"><input type="text" id="dateACLastRegular" name="dateACLastRegular" size="8" value="<%=new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date())%>" readonly maxlength=70 style='width:125px;'>&nbsp;&nbsp;<a href='1' onclick = "initialise('dateACLastRegular');return false;" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>
			</tr>	
			<TR>
				<td nowrap width="150" height="16" class="EWLabelRB" id="regularizationDateLabel">Reqularization Date</td>
				<td nowrap  width="150"><input type="text" id="regularizationDate" name="regularizationDate" size="8" readonly maxlength=70 style='width:125px;'>&nbsp;&nbsp;<a href='1' onclick = "initialise('regularizationDate');return false;" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>
				<td></td>
				<td></td>
			</tr>				
			<TR>
				<td nowrap width="150" height="16" class="EWLabelRB" id="justificationLabel">Justification</td>
				<td nowrap width="150"><textarea id="justification" name="justification" value="" cols=18  rows=2  size="250"  onKeyup="CheckMxLength(this,250);" maxlength="250" ></textarea></td>
				<td nowrap width="150" height="16" class="EWLabelRB" id="branchUser_RemarksLabel">Remarks</td>
				<td nowrap width="150"><textarea id="branchUser_Remarks" name="branchUser_Remarks" value="" cols=18  rows=2  size="250" onKeyup="CheckMxLength(this,250);" maxlength="250" ></textarea></td>
			</tr>		
			
		</table>
		<input type="hidden" name="ProcessName" id="ProcessName" value="ExcessAuthReq">
	</form>

	<form>
	<table border=1 cellspacing=1 cellpadding=1 width=100%>
		<tr width=100%>
			<td align="center" width=100%>
				<input name ='Introduce' type=button onclick="introduce()" value="Introduce" class="EWButtonRB" style='width:80px'>
				<input name = 'Clear' type=button  value="Clear" class="EWButtonRB" onclick="clearFrames()" style='width:80px'>
				<input name = 'Exit' type=button  value="Exit" class="EWButtonRB" onclick="exit()" style='width:80px'>
			</td>
		</tr>
	</table>
	</form>
</BODY>