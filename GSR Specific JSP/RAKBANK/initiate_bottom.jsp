<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation          
//File Name					 : initiate_bottom.jsp          
//Author                     : Manish K. Agrawal
// Date written (DD/MM/YYYY) : 12-Oct-2006
//Description                : 
//---------------------------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			 Change By				Change Description (Bug No. (If Any))
// 24-11-2006	 Manish K. Agrawal		Lost/Got Focus Problem(RKB_RLS_AL_CMA-0010)
// 28-11-2006	 Manish K. Agrawal		Disable Backspace button(RKB-RLS-ALS-CMA-0049/RKB-RLS-ALS-CMA-0050)
//----------------------------------------------------------------------------------------------------
//
//---------------------------------------------------------------------------------------------------->


<html>

<head>
	<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>
</head>
<!----------------------------------------------------------------------------------------------------
// Changed By						:	Manish K. Agrawal
// Reason / Cause (Bug No if Any)	:	(RKB-RLS-ALS-CMA-0049/RKB-RLS-ALS-CMA-0050)
// Change Description				:	add event onkeydown='checkShortcut()' on body load to disable Backspace button
//---------------------------------------------------------------------------------------------------->
<body topmargin=0 onload ="disableprint()" class='EWGeneralRB'  onkeydown='checkShortcut()' >

<script language="javascript" src="/webdesktop/webtop/en_us/scripts/RBCommon.js"></script>
<script language="javascript">

//----------------------------------------------------------------------------------------------------
//Function Name                    : save()
//Date Written (DD/MM/YYYY)        : 16-Oct-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : NA
//Output Parameters                : NA
//Return Values                    : NA
//Description                      : Clear the screen if WI introduced successfully
//----------------------------------------------------------------------------------------------------

function save()
{
	if (window.parent.frames['frameProcess'].introduce()!=false ){
		window.parent.frames['frmProcessList'].clearFrames();
	}
}
	
function disableprint()
{

 if(  (window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value).toUpperCase()=="PL_IPDR"||(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value).toUpperCase()=="GSR_EMPADD")
       window.document.forms[0].Print.disabled=true;
	window.document.forms['templateForm'].ProcessName.value=window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()
}

function PrintTemplate()
{
	var topFrame=window.parent.frames['frmData'];
	var dataform=window.parent.frames['frameProcess'].document.forms[0];
	var localForm=window.document.forms["templateForm"];
	var args="";
	localForm.Args.value="";
	for(var i=0;i<dataform.elements.length;i++)
	{
		args=args+"&<"+dataform.elements[i].name+">&"+dataform.elements[i].value+"@10";
	}
	args=args+"&<BranchName>&"+topFrame.jsBranchName+"@10";
	args=args+"&<Today>&"+topFrame.jsToday+"@10";

	localForm.Args.value=args;

	if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()=="GSR_LCOL")
	{
		var cntrl=window.parent.frames['frameProcess'].document.forms['dataform'].CertificateType;		
		if(cntrl.options[cntrl.selectedIndex].value.toUpperCase()=="NO LIABILITY CERTIFICATE")
		{
			window.document.forms['templateForm'].ProcessName.value="GSR_LCOL_NLC";
		}
		else if(cntrl.options[cntrl.selectedIndex].value.toUpperCase()=="LIABILITY CERTIFICATE")
		{
			window.document.forms['templateForm'].ProcessName.value="GSR_LCOL_LC";
		}
		else
		{
			alert("Certificate Type is Mandatory for Print functionality");
			cntrl.focus();
			return false;
		}
	}
	//alert(localForm.Args.value);
	localForm.target="_blank";
	localForm.action="/webdesktop/servlet/testTemplateServlet"
	localForm.submit();

}
//window.parent.frames['frameProcess'].

function PrintHTMLFormat()
{
	if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()=="PL_ES")
	{
		PL_ESHTMLFormat();
		return false;
	}
	if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()=="PL_PD")
	{
		PL_PDHTMLFormat();
		return false;
	}
	if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()=="PL_PS")
	{
		PL_PSHTMLFormat();
		return false;
	}
	if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()=="GSR_LCOL")
	{
		GSR_LCOLHTMLFormat();
		return false;
	}
}

function PL_ESHTMLFormat()
{
	var localDataForm=window.document.forms['PL_ES_templateForm'];
	var otherForm=window.parent.frames['frameProcess'].document.forms['dataform'];
	var topForm =window.parent.frames['frmData'].document.forms['dataform'];
	localDataForm.ModeOfPayment.value=otherForm.ModeOfPayment.options[otherForm.ModeOfPayment.selectedIndex].value;
	localDataForm.AmountReceived.value=otherForm.AmountReceived.value;
	localDataForm.CustomerName.value=otherForm.CustomerName.value;
	localDataForm.ChargesReceived.value=otherForm.ChargesReceived.value;	localDataForm.TAKEOVERBYOOTHERBANK.value=otherForm.TAKEOVERBYOOTHERBANK.options[otherForm.TAKEOVERBYOOTHERBANK.selectedIndex].value;	localDataForm.TAKEOVERBYOOTHERBANK.value=otherForm.TAKEOVERBYOOTHERBANK.options[otherForm.TAKEOVERBYOOTHERBANK.selectedIndex].value;
	localDataForm.IssueNoLiabilityLetter.value=otherForm.IssueNoLiabilityLetter.options[otherForm.IssueNoLiabilityLetter.selectedIndex].value;
	localDataForm.EarlySettlementReason.value=otherForm.EarlySettlementReason.options[otherForm.EarlySettlementReason.selectedIndex].value;

	localDataForm.Reason.value=otherForm.Reason.value;
	localDataForm.Notes.value=otherForm.Notes.value;
	localDataForm.WAIVEROFESFEESAPPBY.value=otherForm.WAIVEROFESFEESAPPBY.options[otherForm.WAIVEROFESFEESAPPBY.selectedIndex].value;
	localDataForm.DebitAccount.value=otherForm.DebitAccount.value;
	localDataForm.MOBILENO.value=otherForm.MOBILENO.value;
	localDataForm.SETTLEMENTFEEPERCENT.value=otherForm.SETTLEMENTFEEPERCENT.value;
    localDataForm.LANDLINENO.value=otherForm.LANDLINENO.value;

	localDataForm.AgreementNo.value=otherForm.AgreementNo.value;
	localDataForm.EquationLoanAccNo.value=otherForm.EquationLoanAccNo.value;
	localDataForm.BranchCodeName.value=topForm.BranchCodeName.value.substring(topForm.BranchCodeName.value.indexOf("_")+3,topForm.BranchCodeName.value.length);


	localDataForm.action="../RAKBANK/PrintHTMLFormat/PL_ES.jsp";
	localDataForm.target="_blank";	
	localDataForm.submit();	
}

function PL_PDHTMLFormat()
{
	var localDataForm=window.document.forms['PL_PD_templateForm'];
	var otherForm=window.parent.frames['frameProcess'].document.forms['dataform'];
	var topForm =window.parent.frames['frmData'].document.forms['dataform'];
	localDataForm.DeferInstDueOn.value=otherForm.DeferInstDueOn.value;
	localDataForm.ChargesRecvd.value=otherForm.ChargesRecvd.value;
	localDataForm.ModeOfPayment.value=otherForm.ModeOfPayment.options[otherForm.ModeOfPayment.selectedIndex].value;	localDataForm.DebitAccount.value=otherForm.DebitAccount.value;
	localDataForm.CustomerName.value=otherForm.CustomerName.value;
	localDataForm.ReasonOfRequest.value=otherForm.ReasonOfRequest.value;
	localDataForm.Notes.value=otherForm.Notes.value;
	localDataForm.LastDeferralDate.value=otherForm.LastDeferralDate.value;
	localDataForm.NOOFINSTPAIDLASTDEF.value=otherForm.NOOFINSTPAIDLASTDEF.value;
	localDataForm.MOBILENO.value=otherForm.MOBILENO.value;
	localDataForm.LANDLINENO.value=otherForm.LANDLINENO.value;
	localDataForm.PRECREDITAPPROVALDECISION.value=otherForm.PRECREDITAPPROVALDECISION.options[otherForm.PRECREDITAPPROVALDECISION.selectedIndex].value;
	localDataForm.AgreementNo.value=otherForm.AgreementNo.value;
	localDataForm.EquationLoanAccNo.value=otherForm.EquationLoanAccNo.value;
	localDataForm.BranchCodeName.value=topForm.BranchCodeName.value.substring(topForm.BranchCodeName.value.indexOf("_")+3,topForm.BranchCodeName.value.length);
	


	localDataForm.action="../RAKBANK/PrintHTMLFormat/PL_PD.jsp";
	localDataForm.target="_blank";	
	localDataForm.submit();	
}

function PL_PSHTMLFormat()
{
	var localDataForm=window.document.forms['PL_PS_templateForm'];
	var otherForm=window.parent.frames['frameProcess'].document.forms['dataform'];
	var topForm =window.parent.frames['frmData'].document.forms['dataform'];
	localDataForm.MOBILENO.value=otherForm.MOBILENO.value;
	localDataForm.LANDLINENO.value=otherForm.LANDLINENO.value;
	localDataForm.LoanRestructure.value=otherForm.LoanRestructure.options[otherForm.LoanRestructure.selectedIndex].value;
    localDataForm.ServiceType.value=otherForm.ServiceType.options[otherForm.ServiceType.selectedIndex].value;
	localDataForm.DebitAccount.value=otherForm.DebitAccount.value;
	localDataForm.NoOfInstallments.value=otherForm.NoOfInstallments.value;
	localDataForm.ModeOfPayment.value=otherForm.ModeOfPayment.options[otherForm.ModeOfPayment.selectedIndex].value;
    localDataForm.AmountReceived.value=otherForm.AmountReceived.value;
	localDataForm.ChargesReceived.value=otherForm.ChargesReceived.value;
	localDataForm.Reason.value=otherForm.Reason.value;
	localDataForm.Notes.value=otherForm.Notes.value;
	localDataForm.CustomerName.value=otherForm.CustomerName.value;
    
	localDataForm.AgreementNo.value=otherForm.AgreementNo.value;
	localDataForm.EquationLoanAccNo.value=otherForm.EquationLoanAccNo.value;
	localDataForm.BranchCodeName.value=topForm.BranchCodeName.value.substring(topForm.BranchCodeName.value.indexOf("_")+3,topForm.BranchCodeName.value.length);


	localDataForm.action="../RAKBANK/PrintHTMLFormat/PL_PS.jsp";
	localDataForm.target="_blank";	
	localDataForm.submit();	
}
function GSR_LCOLHTMLFormat()
{
	var localDataForm=window.document.forms['GSR_LCOL_templateForm'];
	var otherForm=window.parent.frames['frameProcess'].document.forms['dataform'];
	var topForm =window.parent.frames['frmData'].document.forms['dataform'];
	localDataForm.CertificateType.value=otherForm.CertificateType.options[otherForm.CertificateType.selectedIndex].value;
	localDataForm.CustomerType.value=otherForm.CustomerType.options[otherForm.CustomerType.selectedIndex].value;
	localDataForm.ToBeDeliveredTo.value=otherForm.ToBeDeliveredTo.options[otherForm.ToBeDeliveredTo.selectedIndex].value;
	localDataForm.RetentionOfProduct.value=otherForm.RetentionOfProduct.options[otherForm.RetentionOfProduct.selectedIndex].value;
	localDataForm.MOBILENO.value=otherForm.MOBILENO.value;
	localDataForm.LANDLINENO.value=otherForm.LANDLINENO.value;
	localDataForm.AddressedToName.value=otherForm.AddressedToName.value;
	localDataForm.Language.value=otherForm.Language.options[otherForm.Language.selectedIndex].value;
    localDataForm.Amount.value=otherForm.Amount.value;
	localDataForm.CHARGESTOBERECFROM.value=otherForm.CHARGESTOBERECFROM.options[otherForm.CHARGESTOBERECFROM.selectedIndex].value;

	localDataForm.DebitAccount.value=otherForm.DebitAccount.value;
	localDataForm.Notes.value=otherForm.Notes.value;
	localDataForm.CustomerName.value=otherForm.CustomerName.value;
	localDataForm.BranchCodeName.value=topForm.BranchCodeName.value.substring(topForm.BranchCodeName.value.indexOf("_")+3,topForm.BranchCodeName.value.length);
	localDataForm.AgreementNo.value=otherForm.AgreementNo.value;
	localDataForm.EquationLoanAccNo.value=otherForm.EquationLoanAccNo.value;
	if(localDataForm.CertificateType.value=="" || localDataForm.CertificateType.value=='---------------Select------------')
	{
		alert("Please select a value from Certificate Type");
		otherForm.CertificateType.focus();
		return false;
	}	
	if(localDataForm.CertificateType.value.toUpperCase()=="NO LIABILITY CERTIFICATE")
	{
	localDataForm.action="../RAKBANK/PrintHTMLFormat/GSR_LCOL_NLC.jsp";
	}
	if(localDataForm.CertificateType.value.toUpperCase()=="LIABILITY CERTIFICATE")
	{
	localDataForm.action="../RAKBANK/PrintHTMLFormat/GSR_LCOL_LC.jsp";
	}
	localDataForm.target="_blank";	
	localDataForm.submit();	
}
</script>

<form >
<table border=1 cellspacing=1 cellpadding=1 width=100%>
	<tr width=100%>
		<td align="center" width=100%>
			<!--<input type=button onclick="window.parent.frames['frameProcess'].introduce();window.parent.frames['frmProcessList'].clearFrames()" value="Introduce" class="EWButtonRB" style='width:80px'>-->
			<input name ='Introduce' type=button onclick="save()" value="Introduce" class="EWButtonRB" style='width:80px'>
			<input name = 'ClearAll' type=button onclick="window.parent.frames['frameProcess'].ClearAll()" value="Clear All" class="EWButtonRB" style='width:80px'>

			<!-- <input name = 'Print' type=button onclick="PrintTemplate()" value="Print" class="EWButtonRB" style='width:80px'>
            
			 <input name = 'Print' type=button onclick="window.parent.frames['frameProcess'].Print()" value="Print" class="EWButtonRB" style='width:80px'> -->
			 
			 <input name = 'Print' type=button onclick="PrintHTMLFormat()" value="Print" class="EWButtonRB" style='width:80px'> 
		</td>
	</tr>
</table>


</form>

<form name="templateForm"   method="post">
<input type="hidden" name="Args">
<input type="hidden" name="ProcessName" value="">
</form>

<form name="PL_ES_templateForm"   method="post">
	<input type="hidden" name="ModeOfPayment" value="">
	<input type="hidden" name="AmountReceived" value="">
	<input type="hidden" name="ChargesReceived" value="">
	<input type="hidden" name="TAKEOVERBYOOTHERBANK" value="">
	<input type="hidden" name="IssueNoLiabilityLetter" value="">
	<input type="hidden" name="EarlySettlementReason" value="">
	<input type="hidden" name="Reason" value="">
	<input type="hidden" name="Notes" value="">
	<input type="hidden" name="WAIVEROFESFEESAPPBY" value="">
	<input type="hidden" name="DebitAccount" value="">
	<input type="hidden" name="MOBILENO" value="">
	<input type="hidden" name="SETTLEMENTFEEPERCENT" value="">
	<input type="hidden" name="LANDLINENO" value="">	
	<input type="hidden" name="AgreementNo" value="">
	<input type="hidden" name="EquationLoanAccNo" value="">	
	<input type="hidden" name="BranchCodeName" value="">
	<input type="hidden" name="CustomerName" value="">
	
</form>

<form name="PL_PD_templateForm"   method="post">
	<input type="hidden" name="DeferInstDueOn" value="">
	<input type="hidden" name="ChargesRecvd" value="">
	<input type="hidden" name="ModeOfPayment" value="">
	<input type="hidden" name="DebitAccount" value="">
	<input type="hidden" name="ReasonOfRequest" value="">
	<input type="hidden" name="Notes" value="">
	<input type="hidden" name="LastDeferralDate" value="">
	<input type="hidden" name="NOOFINSTPAIDLASTDEF" value="">
	<input type="hidden" name="MOBILENO" value="">
	<input type="hidden" name="LANDLINENO" value="">
	<input type="hidden" name="PRECREDITAPPROVALDECISION" value="">
	<input type="hidden" name="AgreementNo" value="">
	<input type="hidden" name="EquationLoanAccNo" value="">	
	<input type="hidden" name="BranchCodeName" value="">	
	<input type="hidden" name="CustomerName" value="">
</form>


<form name="PL_PS_templateForm"   method="post">
	<input type="hidden" name="MOBILENO" value="">
	<input type="hidden" name="LANDLINENO" value="">
	<input type="hidden" name="LoanRestructure" value="">
	<input type="hidden" name="ServiceType" value="">
	<input type="hidden" name="DebitAccount" value="">
	<input type="hidden" name="NoOfInstallments" value="">
	<input type="hidden" name="ModeOfPayment" value="">
	<input type="hidden" name="AmountReceived" value="">
	<input type="hidden" name="ChargesReceived" value="">
	<input type="hidden" name="Reason" value="">
	<input type="hidden" name="Notes" value="">
	<input type="hidden" name="AgreementNo" value="">
	<input type="hidden" name="EquationLoanAccNo" value="">	
	<input type="hidden" name="BranchCodeName" value="">	
	<input type="hidden" name="CustomerName" value="">
	
</form>


<form name="GSR_LCOL_templateForm"   method="post">
	<input type="hidden" name="CertificateType" value="">
	<input type="hidden" name="CustomerType" value="">
	<input type="hidden" name="ToBeDeliveredTo" value="">
	<input type="hidden" name="RetentionOfProduct" value="">
	<input type="hidden" name="MOBILENO" value="">
	<input type="hidden" name="LANDLINENO" value="">
	<input type="hidden" name="AddressedToName" value="">
	<input type="hidden" name="Language" value="">
	<input type="hidden" name="Amount" value="">
	<input type="hidden" name="CHARGESTOBERECFROM" value="">
	<input type="hidden" name="DebitAccount" value="">
	<input type="hidden" name="Notes" value="">
	<input type="hidden" name="AgreementNo" value="">
	<input type="hidden" name="EquationLoanAccNo" value="">	
	<input type="hidden" name="BranchCodeName" value="">
	<input type="hidden" name="CustomerName" value="">
</form>

</body>
<script>
  
</script>
</html>