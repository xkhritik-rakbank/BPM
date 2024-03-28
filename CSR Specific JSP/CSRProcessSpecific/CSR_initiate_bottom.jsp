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
<HEAD>
<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>
</HEAD>
<!----------------------------------------------------------------------------------------------------
// Changed By						:	Manish K. Agrawal
// Reason / Cause (Bug No if Any)	:	(RKB-RLS-ALS-CMA-0049/RKB-RLS-ALS-CMA-0050)
// Change Description				:	add event onkeydown='checkShortcut()' on body load to disable Backspace button
//---------------------------------------------------------------------------------------------------->
<body topmargin=0  class='EWGeneralRB'   >

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

function clearFrames()
{
window.parent.frames['frameProcess'].document.location.href="CSR_blank.jsp"; window.parent.frames['frameClose'].document.location.href="CSR_blank.jsp";
return false;
}

function exit()
{
window.parent.close();
return false;
}

function save(args)
{
		if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()=="CSR_MR"){
			if(args=="Pending"){
				if(window.parent.frames['frameProcess'].document.forms['dataform'].PendingOptionsFinal.value==""){
					alert("Please select a Pending For reason");
				}
				else{
	if (window.parent.frames['frameProcess'].introduce(args)!=false ){
		
		if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="CSR_OCC")
		{
			window.parent.frames['frmProcessList'].clearFrames();
		}
		else 
		{
			window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
			window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
		}
	}
				}
			}
			else if(args=="Introduce"){
				if((window.parent.frames['frameProcess'].document.forms['dataform'].CCI_REQUESTTYPE.value == "EPP CONVERSION")||(window.parent.frames['frameProcess'].document.forms['dataform'].CCI_REQUESTTYPE.value == "EXCESS CREDIT") || (window.parent.frames['frameProcess'].document.forms['dataform'].CCI_REQUESTTYPE.value == "TRANSFER") || (window.parent.frames['frameProcess'].document.forms['dataform'].CCI_REQUESTTYPE.value == "DUPLICATE PAYMENT")){
					if(((window.parent.frames['frameProcess'].document.forms['dataform'].Curr_Amount.value == "") || (window.parent.frames['frameProcess'].document.forms['dataform'].Merchant_Name.value == "")) && (window.parent.frames['frameProcess'].document.forms['dataform'].CCI_REQUESTTYPE.value == "EPP CONVERSION")){
					alert("Please Enter CUR(Amount) and Merchant Name.");
					}
					else if (window.parent.frames['frameProcess'].document.forms['dataform'].Curr_Amount.value == "")
					{
						alert("Please Enter CUR(Amount).");
					}
					else {
						window.parent.frames['frameProcess'].document.forms['dataform'].PendingOptionsFinal.value="";
						if (window.parent.frames['frameProcess'].introduce(args)!=false ){
						if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="CSR_OCC")
							{
									window.parent.frames['frmProcessList'].clearFrames();
							}
						else 
							{
									window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
									window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
							}
						}
					}
				}
				 else if ((window.parent.frames['frameProcess'].document.forms['dataform'].CCI_REQUESTTYPE.value == "EPP CONVERSION SCHOOL EPP")){
					if((window.parent.frames['frameProcess'].document.forms['dataform'].Curr_Amount.value == "") || (window.parent.frames['frameProcess'].document.forms['dataform'].SchoolName.value == "")){
					alert("Please Enter CUR(Amount) and School Name.");
					}
					else {
						window.parent.frames['frameProcess'].document.forms['dataform'].PendingOptionsFinal.value="";
						if (window.parent.frames['frameProcess'].introduce(args)!=false ){
						if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="CSR_OCC")
							{
									window.parent.frames['frmProcessList'].clearFrames();
							}
						else 
							{
									window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
									window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
							}
						}
					}
				}
				else {
						window.parent.frames['frameProcess'].document.forms['dataform'].PendingOptionsFinal.value="";
						if (window.parent.frames['frameProcess'].introduce(args)!=false ){
						if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="CSR_OCC")
							{
									window.parent.frames['frmProcessList'].clearFrames();
							}
						else 
							{
									window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
									window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
							}
						}
					}
			}
			else{
				if (window.parent.frames['frameProcess'].introduce(args)!=false ){
				if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="CSR_OCC")
				{
					window.parent.frames['frmProcessList'].clearFrames();
				}
				else 
				{
					window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
					window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
				}
				}
			}
		}
		else if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()=="CSR_OCC"){
			if(args=="Pending"){
				if((!(window.parent.frames['frameProcess'].document.forms['dataform'].PendingForCR.value=="")) ||(!(window.parent.frames['frameProcess'].document.forms['dataform'].PendingFor.value=="")) || (!(window.parent.frames['frameProcess'].document.forms['dataform'].PendingForECR.value=="")) ||(!(window.parent.frames['frameProcess'].document.forms['dataform'].PendingForCSI.value=="")) ||(!(window.parent.frames['frameProcess'].document.forms['dataform'].PendingForRIP.value=="")) || (!(window.parent.frames['frameProcess'].document.forms['dataform'].PendingForCLI.value=="")) || (!(window.parent.frames['frameProcess'].document.forms['dataform'].PendingForCU.value=="")) || (!(window.parent.frames['frameProcess'].document.forms['dataform'].PendingForSSC.value==""))){
					if (window.parent.frames['frameProcess'].introduce(args)!=false ){
					if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="CSR_OCC")
					{
						window.parent.frames['frmProcessList'].clearFrames();
					}
					else 
					{
						window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
						window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
					}
					}
				}
				else{
					alert("Please select a Pending For reason");
				}
			}
			else if(args=="Introduce"){
				if (window.parent.frames['frameProcess'].introduce(args)!=false ){
				if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="CSR_OCC")
					{
						window.parent.frames['frmProcessList'].clearFrames();
					}
					else 
					{
						window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
						window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
					}
				}	
			}
			else{
				if (window.parent.frames['frameProcess'].introduce(args)!=false ){
				if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="CSR_OCC")
				{
					window.parent.frames['frmProcessList'].clearFrames();
				}
				else 
				{
					window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
					window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
				}
				}
			}
		}
		else if((window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()=="CSR_BT") ||(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()=="CSR_CCC")){
			if(args=="Pending"){
				if(window.parent.frames['frameProcess'].document.forms['dataform'].PendingOptionsFinal.value==""){
					alert("Please select a Pending For reason");
				}
				else{
					if (window.parent.frames['frameProcess'].introduce(args)!=false ){
					if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="CSR_OCC")
					{
						window.parent.frames['frmProcessList'].clearFrames();
					}
					else 
					{
						window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
						window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
					}
					}
				}
			}
			else if(args=="Introduce"){
				if (window.parent.frames['frameProcess'].introduce(args)!=false ){
				if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="CSR_OCC")
					{
						window.parent.frames['frmProcessList'].clearFrames();
					}
					else 
					{
						window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
						window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
					}
				}	
			}
			else{
				if (window.parent.frames['frameProcess'].introduce(args)!=false ){
				if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="CSR_OCC")
				{
					window.parent.frames['frmProcessList'].clearFrames();
				}
				else 
				{
					window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
					window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
				}
				}
			}
		}
		else if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()=="CSR_RR"){
			if(args=="Pending"){
				if(window.parent.frames['frameProcess'].document.forms['dataform'].PendingOptionsFinal.value==""){
					alert("Please select a Pending For reason");
				}
				else{
					if (window.parent.frames['frameProcess'].introduce(args)!=false ){
					if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="CSR_OCC")
					{
						window.parent.frames['frmProcessList'].clearFrames();
					}
					else 
					{
						window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
						window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
					}
					}
				}
			}
			else if(args=="Introduce"){
				window.parent.frames['frameProcess'].document.forms['dataform'].PendingOptionsFinal.value="";//mirza
				if (window.parent.frames['frameProcess'].introduce(args)!=false ){
				if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="CSR_OCC")
					{
						window.parent.frames['frmProcessList'].clearFrames();
					}
					else 
					{
						window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
						window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
					}
				}	
			}
			else{
				if (window.parent.frames['frameProcess'].introduce(args)!=false ){
				if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="CSR_OCC")
				{
					window.parent.frames['frmProcessList'].clearFrames();
				}
				else 
				{
					window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
					window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
				}
				}
			}
		}
		else{
			if (window.parent.frames['frameProcess'].introduce(args)!=false ){
			if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="CSR_OCC")
			{
				window.parent.frames['frmProcessList'].clearFrames();
			}
			else 
			{
				window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
				window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
			}
			}
		}
	
}
	
function disableprint()
{
 if(  (window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value).toUpperCase()=="PL_IPDR")
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
	//alert(localForm.Args.value);
	localForm.submit();

}
//window.parent.frames['frameProcess'].
</script>

<form >
<table border=1 cellspacing=1 cellpadding=1 width=100%>
	<tr width=100%>
		<td align="center" width=100%>
			<!--<input type=button onclick="window.parent.frames['frameProcess'].introduce();window.parent.frames['frmProcessList'].clearFrames()" value="Introduce" class="EWButtonRB" style='width:80px'>-->
			<input name ='Introduce' type=button onclick="save('Introduce')" value="Introduce" class="EWButtonRB" style='width:80px'>
			<input name ='Pending' type=button onclick="save('Pending')" value="Pending" class="EWButtonRB" style='width:80px'>
			<input name = 'Clear' type=button  value="Clear" class="EWButtonRB" onclick="clearFrames()" style='width:80px'>
			<input name = 'Exit' type=button  value="Exit" class="EWButtonRB" onclick="exit()" style='width:80px'>
            
			<!-- <input name = 'Print' type=button onclick="window.parent.frames['frameProcess'].Print()" value="Print" class="EWButtonRB" style='width:80px'> -->
		</td>
	</tr>
</table>


</form>

<form name="templateForm" action="/webdesktop/servlet/testTemplateServlet" target="_Default" method="post">
<input type="hidden" name="Args">
<input type="hidden" name="ProcessName" value="">
</form>

</body>
<script>
  
</script>
</html>