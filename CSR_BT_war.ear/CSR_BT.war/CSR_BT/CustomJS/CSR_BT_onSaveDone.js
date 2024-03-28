

function setCustomControlsValue()
{



if(getValue("CCI_CName")=='' || getValue("CCI_CName")==null)
{
	alert("Please enter card no and click refresh button to fetch card data!");
	setFocus("CCI_CrdtCN");
	return false;
}
if(getValue("CCI_CrdtCN")=='' || getValue("CCI_CrdtCN")==null)
{
	alert("Please enter card no and click refresh button to fetch card data!");
	setFocus("CCI_CrdtCN");
	return false;
}
if(getValue("VD_MoMaidN_Check")==false && getValue("VD_TIN_Check")==false) 
{
	//alert("VD_TIN_Check"+VD_TIN_Check);
	showMessage('VD_TIN_Check','Atleast one of Verification Details is Mandatory!',"error");
	setFocus("VD_TIN_Check");
	return false;
}

if(getValue("VD_MoMaidN_Check")==true)
{
	var i=0;
	if(getValue("VD_DOB_Check")==true) i++;
	if(getValue("VD_StaffId_Check")==true) i++;
	if(getValue("VD_POBox_Check")==true) i++;
	if(getValue("VD_PassNo_Check")==true) i++;
	if(getValue("VD_Oth_Check")==true) i++;
	if(getValue("VD_MRT_Check")==true) i++;
	if(getValue("VD_EDC_Check")==true) i++;
	if(getValue("VD_NOSC_Check")==true) i++;
	if(getValue("VD_TELNO_Check")==true) i++;
	if(getValue("VD_SD_Check")==true) i++;
	if (i < 4)
		{
		  //alert( "Please select atleast 4 Random Questions!");
		  showMessage('VD_MoMaidN_Check',"Please select atleast 4 Random Questions!","error");
		  setFocus("VD_MoMaidN_Check");
		   return false;
		}	
}
	
if(getValue("CCI_ExtNo")=='' || getValue("CCI_ExtNo")==null)
{
	alert("Ext No. is Mandatory!");
	setFocus("CCI_ExtNo");
	return false;
}
else if(getValue("CCI_ExtNo").length!=4)
{
	alert("Ext No. should be of 4 digits!");
	setFocus("CCI_ExtNo");
	return false;
}
if(getValue("CCI_SC")=='' || getValue("CCI_SC")==null)
{
	alert("Source Code is Mandatory!");
	setFocus("CCI_SC");
	return false;
}
else if(getValue("CCI_SC").length!=6 && getValue("CCI_SC").length!=7)
{
	alert("Source Code should be of 6 or 7 Characters!");
	setFocus("CCI_SC");
	return false;
}
if(getValue("BTD_OBC_CT")=='' || getValue("BTD_OBC_CT")==null)
{
	alert(" Card Type is Mandatory!");
	setFocus("BTD_OBC_CT");
	return false;
}
if(getValue("BTD_OBC_OBN")=='' || getValue("BTD_OBC_OBN")==null)
{
	alert(" other Bank Name is Mandatory!");
	setFocus("BTD_OBC_OBN");
	return false;
}
if(getValue("BTD_OBC_OBN")=='Others')
{
	if(getValue("BTD_OBC_OBNO")=='')
	{
	alert(" Others(pls specify) is Mandatory!");
	setFocus("BTD_OBC_OBNO");
	return false;
	}
}
if(getValue("BTD_OBC_OBCNO")==getValue("CreditCardNo1"))
{
	alert("Both Card No. can't be same!");
	setFocus("BTD_OBC_OBCNO");
	return false;

}
if(getValue("BTD_OBC_OBCNO")=='' || getValue("BTD_OBC_OBCNO")==null)
{
	alert(" Other Bank Card No is Mandatory!");
	setFocus("BTD_OBC_OBCNO");
	return false;
}
if(getValue("BTD_OBC_DT")=='' || getValue("BTD_OBC_DT")==null)
{
	alert(" Delivery To is Mandatory!");
	setFocus("BTD_OBC_DT");
	return false;
}
if(getValue("BTD_OBC_DT")=='Bank')
{
	if(getValue("BTD_OBC_BN")=='')
	{
	alert(" Bank Name is Mandatory!");
	setFocus("BTD_OBC_BN");
	return false;
	}
}
if(getValue("BTD_OBC_NOOC")=='' ||  getValue("BTD_OBC_NOOC")==null)
{
	alert(" Name on Other Card is Mandatory!");
	setFocus("BTD_OBC_NOOC");
	return false;
}
if(getValue("BTD_RBC_RBCN11")=='' && getValue("BTD_RBC_RBCN22")=='' && getValue("BTD_RBC_RBCN33")=='')
{
	alert(" Any one of the RAKBANK CARD NO is Mandatory!");
	setFocus("BTD_RBC_RBCN11");
	return false;
}
if(getValue("BTD_RBC_RBCN11")== getValue("BTD_RBC_RBCN22") && getValue("BTD_RBC_RBCN11")!='')
{
	alert("RAKBANK Card no.s should be Unique!");
	setFocus("BTD_RBC_RBCN22");
	return false;
}
if(getValue("BTD_RBC_RBCN11")== getValue("BTD_RBC_RBCN33") && getValue("BTD_RBC_RBCN11")!='')
{
	alert("RAKBANK Card no.s should be Unique!");
	setFocus("BTD_RBC_RBCN33");
	return false;
}

if(getValue("BTD_RBC_RBCN22")== getValue("BTD_RBC_RBCN33") && getValue("BTD_RBC_RBCN22")!='')
{
	alert("RAKBANK Card no.s should be Unique!");
	setFocus("BTD_RBC_RBCN33");
	return false;
}

if(getValue("BTD_RBC_RBCN11")!='')
{
	if(getValue("BTD_RBC_BTA1")=='')
	{
		alert("Cheque Amount AED is Mandatory!");
		setFocus("BTD_RBC_BTA1");
		return false;
	}
	if(getValue("BTD_RBC_AppC1")=='' || getValue("BTD_RBC_AppC1")==null)
	{
		alert("Approval Code is Mandatory!");
		setFocus("BTD_RBC_AppC1");
		return false;
	}
	if(getValue("BTD_RBC_AppC1").length!=6)
	{
		alert("Approval Code should be of 6 digits!");
		setFocus("BTD_RBC_AppC1");
		return false;
	}
	
}
if(getValue("BTD_RBC_RBCN22")!='')
{
	if(getValue("BTD_RBC_BTA2")=='')
	{
		alert("Cheque Amount AED is Mandatory!");
		setFocus("BTD_RBC_BTA2");
		return false;
	}
	if(getValue("BTD_RBC_AppC2")=='' || getValue("BTD_RBC_AppC2")==null)
	{
		alert("Approval Code is Mandatory!");
		setFocus("BTD_RBC_AppC2");
		return false;
	}
	if(getValue("BTD_RBC_AppC2").length!=6)
	{
		alert("Approval Code should be of 6 digits!");
		setFocus("BTD_RBC_AppC2");
		return false;
	}
	
}
if(getValue("BTD_RBC_RBCN33")!='')
{
	if(getValue("BTD_RBC_BTA3")=='')
	{
		alert("Cheque Amount AED is Mandatory!");
		setFocus("BTD_RBC_BTA3");
		return false;
	}
	if(getValue("BTD_RBC_AppC3")=='' || getValue("BTD_RBC_AppC3")==null)
	{
		alert("Approval Code is Mandatory!");
		setFocus("BTD_RBC_AppC3");
		return false;
	}
	if(getValue("BTD_RBC_AppC3").length!=6)
	{
		alert("Approval Code should be of 6 digits!");
		setFocus("BTD_RBC_AppC3");
		return false;
	}
	
}
if(getValue("BTD_RBC_RR").length>500)
{
	alert("Remarks/Reasons can't be greater than 500 Characters");
	setFocus("BTD_RBC_RR");
	return false;
}

if(ActivityName=='Branch_Approver')
{
	if(getValue("BA_Decision")=='')
	{
		alert("Decision is Mandatory");
		setFocus("BA_Decision");
		return false;
	}
}
if(ActivityName=='CARDS')
{
	if(getValue("Cards_Decision")=='')
	{
		alert("Decision is Mandatory");
		setFocus("Cards_Decision");
		return false;
	}
}
	if(ActivityName=='Pending')
{
	if(getValue("Pending_Decision")=='')
	{
		alert("Decision is Mandatory");
		setFocus("Pending_Decision");
		return false;
	}
}

if(getValue("BTD_RBC_BTA1")!='' && getValue("BTD_RBC_BTA2")!='' && getValue("BTD_RBC_BTA3")!='')
{
	var sum1 = parseInt(getValue("BTD_RBC_BTA1")); 
	var sum2 = parseInt(getValue("BTD_RBC_BTA2")); 
	var sum3 = parseInt(getValue("BTD_RBC_BTA3")); 
	
	/* alert("sum1 ::" +sum1);
	alert("sum2 ::" +sum2);
	alert("sum3 ::" +sum3); */
	var total = sum1 + sum2 + sum3 ;
	//alert("total ::" +total);
	if(total <1000)
	{
		alert("Sum Cheque Amount AED should be equal to or greater than 1000" );
		setFocus("BTD_RBC_BTA1");
		return false;
	}
	
	return true;
}

if(getValue("BTD_RBC_BTA1")!='' && getValue("BTD_RBC_BTA2")!='' )
{

	var sum1 = parseInt(getValue("BTD_RBC_BTA1")); 
	var sum2 = parseInt(getValue("BTD_RBC_BTA2"));  
	
	/* alert("sum1 ::" +sum1);
	alert("sum2 ::" +sum2); */

	var total = sum1 + sum2;
	//alert("total ::" +total);
	if(total <1000)
	{
		alert("Sum Cheque Amount AED should be equal to or greater than 1000" );
		setFocus("BTD_RBC_BTA1");
		return false;
	}
	
	return true;
}

if(getValue("BTD_RBC_BTA2")!='' && getValue("BTD_RBC_BTA3")!='' )
{

	/* var sum2 = parseInt(getValue("BTD_RBC_BTA2")); 
	var sum3 = parseInt(getValue("BTD_RBC_BTA3"));  */ 
	
	//alert("sum2 ::" +sum3);
	//alert("sum3 ::" +sum2);

	var total = sum2 + sum3;
	//alert("total ::" +total);
	if(total <1000)
	{
		alert("Sum Cheque Amount AED should be equal to or greater than 1000" );
		setFocus("BTD_RBC_BTA2");
			return false;
	}
	

	return true;
}
if(getValue("BTD_RBC_BTA1")!='' && getValue("BTD_RBC_BTA3")!='' )
{

	/* var sum1 = parseInt(getValue("BTD_RBC_BTA1")); 
	var sum3 = parseInt(getValue("BTD_RBC_BTA3")); */  
	
	//alert("sum1 ::" +sum1);
	
	//alert("sum3 ::" +sum3);
	var total = sum1 + sum3;
	//alert("total ::" +total);
	if(total <1000)
	{
		alert("Sum Cheque Amount AED should be equal to or greater than 1000" );
		setFocus("BTD_RBC_BTA1");
		return false;
	}
	return true;
}

if(getValue("BTD_RBC_BTA1")!='' )
{

	var sum1 = parseInt(getValue("BTD_RBC_BTA1")); 
	//alert("sum1::"+sum1);
	if(sum1 <1000)
	{
		alert("Sum Cheque Amount AED should be equal to or greater than 1000");
		setFocus("BTD_RBC_BTA1");
		return false;
	}
	
	
	return true;
}
/* if(getValue("BTD_RBC_RBCN1")!='' || getValue("BTD_RBC_RBCN1")!=null)
{
	var  RBCN1 = getValue(BTD_RBC_RBCN1).replace(/-/gi, '');
	setControlValue("BTD_RBC_RBCN1",RBCN1);
	return true;
	
}
if(getValue("BTD_RBC_RBCN2")!='' || getValue("BTD_RBC_RBCN2")!=null)
{
	var  RBCN2 = getValue(BTD_RBC_RBCN2).replace(/-/gi, '');
	setControlValue("BTD_RBC_RBCN2",RBCN2);
	return true;
	
}
if(getValue("BTD_RBC_RBCN3")!='' || getValue("BTD_RBC_RBCN3")!=null)
{
	var  RBCN3 = getValue(BTD_RBC_RBCN3).replace(/-/gi, '');
	setControlValue("BTD_RBC_RBCN3",RBCN3);
	return true;
	
} */

return true;
}


/*function insertIntoHistoryTable()
{
	var rejectReasonsGridlength=getGridRowCount('REJECT_REASON_GRID');
	var historyTableInsert=executeServerEvent("InsertIntoHistory","INTRODUCEDONE",rejectReasonsGridlength,true);
}

function enableDisableRejectReasons()
{
	if((getValue("DECISION").indexOf("Reject")!=-1) || (getValue("DECISION").indexOf("Reject to Initiator")!=-1))
	{
		setStyle("REJECT_REASON_GRID","visible","true");
		
	}
	else
	{
		setStyle("REJECT_REASON_GRID","visible","false");
		clearTable("REJECT_REASON_GRID",true);
	}
	
}

/*function setArchivalPath(ActivityName)
{
		if(ActivityName=="Introduction")
		{
			setValues({"ARCHIVALPATHSUCCESS":"Omnidocs\\CentralOperations\\&<CIF_ID>&\\DAC\\&<WI_NAME>&"},true);
			setValues({"ARCHIVALPATHREJECT":"Omnidocs\\CentralOperations\\&<CIF_ID>&\\Rejected\\DAC\\&<WI_NAME>&"},true);
		}
	
}*/
//}