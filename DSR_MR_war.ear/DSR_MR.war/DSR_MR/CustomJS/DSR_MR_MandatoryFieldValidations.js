var DSR_MR_Common = document.createElement('script');
DSR_MR_Common.src = '/DSR_MR/DSR_MR/CustomJS/DSR_MR_Common.js';
document.head.appendChild(DSR_MR_Common);

var DSR_MR_onSaveDone = document.createElement('script');
DSR_MR_onSaveDone.src = '/DSR_MR/DSR_MR/CustomJS/DSR_MR_onSaveDone.js';
document.head.appendChild(DSR_MR_onSaveDone);

/*function validateMandatory()
{
	if ((ActivityName=='Work Introduction') || (ActivityName == 'Pending') || (ActivityName == 'Branch_Return'))
	{
		if (ActivityName=='Work Introduction')
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
		if(getValue("DCI_ExtNo")=="")
		{
			showMessage('DCI_ExtNo','Ext No. is Mandatory!',"error");
			setFocus("DCI_ExtNo");
			return false;
		} 
		if ((getValue("VD_MoMaidN") == false) && (getValue("VD_TINCHECK") == false))
		{
			showMessage("VD_TINCHECK", "Atleast one of Verification Details is Mandatory!","error");
			setFocus("VD_TINCHECK");
			return false;
		}
		var i;
		if (getValue("VD_MoMaidN") == true)
		{
			i = 0;
			if (getValue("VD_DOB") == true) i++;
			if (getValue("VD_StaffId") == true) i++;
			if (getValue("VD_POBox") == true) i++;
			if (getValue("VD_Oth") == true) i++;
			if (getValue("VD_MRT") == true) i++;
			if (getValue("VD_EDC") == true) i++;
			if (getValue("VD_NOSC") == true) i++;
			if (getValue("VD_TELNO") == true) i++;
			if (getValue("VD_SD") == true) i++;
			if (i < 4)
			{
				showMessage("VD_MoMaidN", "Please select atleast 4 Random Questions!","error");
				setFocus("VD_MoMaidN");
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
			showMessage("Remarks/Reasons can't be greater than 500 Characters");
			setFocus("REMARKS");
			return false;
		} 
		if(ActivityName=='Pending')
		{
			if(getValue("Pending_Decision")=="" || getValue("Pending_Decision")=="Select")
			{
				showMessage('Pending_Decision','Pending Decision is Mandatory!',"error");
				setFocus("Pending_Decision");
				return false;
			}
		}		
	}
	if(ActivityName=='CARDS')
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
}			
*/