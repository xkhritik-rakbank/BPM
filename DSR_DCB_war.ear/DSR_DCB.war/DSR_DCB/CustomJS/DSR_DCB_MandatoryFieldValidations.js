var DSR_DCB_onSaveDone = document.createElement('script');
DSR_DCB_onSaveDone.src = '/DSR_DCB/DSR_DCB/CustomJS/DSR_DCB_onSaveDone.js';
document.head.appendChild(DSR_DCB_onSaveDone);

var DSR_DCB_Common = document.createElement('script');
DSR_DCB_Common.src = '/DSR_DCB/DSR_DCB/CustomJS/DSR_DCB_Common.js';
document.head.appendChild(DSR_DCB_Common);

/*function validateMandatory(ActivityName)
{
	if ((ActivityName=="Work Introduction") || (ActivityName == "Pending") || (ActivityName == "Branch_Return"))
	{
		if (ActivityName=="Work Introduction")
		{
			if (getValue("DCI_CName") == "")
			{
				showMessage("DCI_CName", "Please enter card no and click refresh button to fetch card data!");
				setFocus("DCI_DebitCN");
				return false;
			}
		 }
		if(getValue("DCI_DebitCN")!="" && getValue("DCI_DebitCN")!=null)
		  {
		  setFocus("DCI_DebitCN");
			return false;
		  }
		if((getValue("DCI_ExtNo")=="") && (getValue("DCI_ExtNo") == null) &&(getValue("DCI_ExtNo").length != 4)) 
		{
			showMessage("DCI_ExtNo", "Ext No. should be of 4 digits!","error");
			setFocus("DCI_ExtNo");
			return false;
		} 
		if ((getValue("VD_Oth_Check") == false) && (getValue("VD_TIN_Check") == false))
		{
			showMessage("VD_TIN_Check", "Atleast one of Verification Details is Mandatory!","error");
			setFocus("VD_TIN_Check");
			return false;
		}
		var i;
		if (getValue("VD_Oth_Check") == true)
		{
			i = 0;
			if (getValue("VD_DOB_Check") == true) i++;
			if (getValue("VD_StaffId_Check") == true) i++;
			if (getValue("VD_POBox_Check") == true) i++;
			if (getValue("VD_MoMaidN_Check") == true) i++;
			if (getValue("VD_MRT_Check") == true) i++;
			if (getValue("VD_EDC_Check") == true) i++;
			if (getValue("VD_TELNO_Check") == true) i++;
			if (i < 4)
			{
				showMessage("VD_Oth_Check", "Please select atleast 4 Random Questions!","error");
				setFocus("VD_Oth_Check");
				return false;
			}
		}
		if(getValue("REMARKS")=="") 
		  {
			showMessage('REMARKS','Remarks/Reasons is Mandatory!',"error");
			setFocus("REMARKS");
			return false;
		  }
		 if (getValue("REMARKS").length>500)
		 {
			alert("Remarks/Reasons can't be greater than 500 Characters");
			setFocus("REMARKS");
			return false;
		   } 
		 if(ActivityName=="Pending")
			{
			 if(getValue("Pending_Decision")=="" || getValue("Pending_Decision")=="Select")
			  {
			   showMessage('Pending_Decision','Pending Decision is Mandatory!',"error");
			   setFocus("Pending_Decision");
			   return false;
			  }
			  
			}		
		}
		if(ActivityName=="CARDS")
		{
		 if(getValue("Cards_Decision")=="" || getValue("Cards_Decision")=="Select")
		  {
		   showMessage('Cards_Decision','CARDS Decision is Mandatory!',"error");
		   setFocus("Cards_Decision");
		   return false;
		  }
		 if(getValue("Cards_Decision")=="Re-Submit to Branch")
		  {
		   if(getValue("Cards_Remarks")=="")
		   {
			   showMessage('Cards_Remarks','Remarks/Reasons is Mandatory!',"error");
			   setFocus("Cards_Remarks");
			   return false;
		   }
		  } 
		}
		return true;		 
}*/