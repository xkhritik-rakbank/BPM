function OnDoneValidation(flag)
{
		var WSNAME = customform.document.getElementById("wdesk:WS_NAME").value;
		alert("inside ondone validation function");
	 	if(flag=='I')
		{
			/* if(customform.document.getElementById("wdesk:FIRSTNAME").value== '')
			{
				alert("Mandatory to enter first name");
				customform.document.getElementById("wdesk:FIRSTNAME").focus(true);
				return false;
			}
			if(customform.document.getElementById("wdesk:MIDDLENAME").value== '')
			{
				alert("Mandatory to enter middlename");
				customform.document.getElementById("wdesk:MIDDLENAME").focus(true);
				return false;
			} */
			
			if(customform.document.getElementById("selectDecision").value=='')//Decision will always be mandatory for all workstep
			{
				alert('Decision is mandatory');
				customform.document.getElementById('selectDecision').focus(true);
				return false;
			}	
		
	/* 
		if(customform.document.getElementById("selectDecision").value=='Reject'||customform.document.getElementById("selectDecision").value=='Reject to Remittance'||customform.document.getElementById("selectDecision").value=='Reject to Maker'||customform.document.getElementById("selectDecision").value=='Reject to OPS Maker')
		{
			if(customform.document.getElementById("wdesk:REMARKS").value== "")
			{
			  alert("Please provide remarks");
			  customform.document.getElementById('wdesk:REMARKS').focus(true);
			  return false;
			}
			if(customform.document.getElementById('rejReasonCodes').value=='' || customform.document.getElementById('rejReasonCodes').value=='NO_CHANGE')
			{
			  alert("Please provide reject reason.");
			  customform.document.getElementById('RejectReason').focus(true);
			  return false;
			}
		}		 */
		
		return true;	
		}
}