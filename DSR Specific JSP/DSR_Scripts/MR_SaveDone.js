


function DSR_MR_SaveDone(chkMandatory)
{
	 var objWI_Obj=window.top.wi_object;
	var objDataForm=window.parent.frames['left'].document.forms["dataform"];

	if(objWI_Obj.workstep_name=="Pending")
	{
		objWI_Obj.attribute_list['Pending_Decision'].value=objDataForm.Pending_Decision.options[objDataForm.Pending_Decision.selectedIndex].value;
		objWI_Obj.attribute_list['Pending_Decision'].modified_flag=true;
	}		

		if (objWI_Obj.workstep_name=="Pending");
		{

			if (objDataForm.REMARKS.value.length>500)
				{
					alert("Remarks/Reasons can't be greater than 500 Characters");
					objDataForm.REMARKS.focus();
					return false;
				}					
		}
		if(objWI_Obj.workstep_name=="Branch_Approver")
			{
			if(chkMandatory==1&&objDataForm.BA_Decision.options[objDataForm.BA_Decision.selectedIndex].value=="")
				{
				alert("Branch Approver Decision is Mandatory");
				objDataForm.BA_Decision.focus();
				return false;
				}
			if(chkMandatory==1&&objDataForm.BA_Decision.options[objDataForm.BA_Decision.selectedIndex].value=="BA_D"&&objDataForm.BA_Remarks.value=="")
				{
				alert("Branch Approver Remarks is Mandatory.");

				objDataForm.BA_Remarks.focus();
				return false;
				}
			if (objDataForm.BA_Remarks.value.length>255)
			   {
				alert("Remarks/Reasons can't be greater than 255 Characters");
				objDataForm.BA_Remarks.focus();
				return false;
			   }

			if(chkMandatory==1&&objDataForm.BA_Decision.options[objDataForm.BA_Decision.selectedIndex].value=="BA_D"&&
					objDataForm.BA_Remarks.value!=""){
				if(!space_Check(objDataForm.BA_Remarks.value)){
					alert("Invalid Data in REMARKS. Only spaces are not allowed");
					objDataForm.BA_Remarks.focus();
					return false;
				} 
			}
			
			objWI_Obj.attribute_list['BA_Decision'].value=objDataForm.BA_Decision.options[objDataForm.BA_Decision.selectedIndex].value;
			objWI_Obj.attribute_list['BA_Decision'].modified_flag=true;
			objWI_Obj.attribute_list['BA_Remarks'].value=objDataForm.BA_Remarks.value;
			objWI_Obj.attribute_list['BA_Remarks'].modified_flag=true;
			return true;
			}
		if(objWI_Obj.workstep_name=="CARDS")
			{
			if(chkMandatory==1&&objDataForm.Cards_Decision.options[objDataForm.Cards_Decision.selectedIndex].value=="")
				{
				alert("CARDS Decision is Mandatory.");
				objDataForm.Cards_Decision.focus();
				return false;
				}
			if(chkMandatory==1&&objDataForm.Cards_Decision.options[objDataForm.Cards_Decision.selectedIndex].value=="CARDS_BR"&&objDataForm.Cards_Remarks.value=="")
				{
				alert("Remarks is Mandatory");
				objDataForm.Cards_Remarks.focus();
				return false;
				}
			if (objDataForm.Cards_Remarks.value.length>255)
			   {
				alert("Remarks/Reasons can't be greater than 255 Characters");
				objDataForm.Cards_Remarks.focus();
				return false;
			   }
			if(chkMandatory==1 && objDataForm.Cards_Remarks.value!=""){
				if(!space_Check(objDataForm.Cards_Remarks.value)){
					alert("Invalid Data in REMARKS. Only spaces are not allowed");
					objDataForm.Cards_Remarks.focus();
					return false;
				} 
			}
			
			objWI_Obj.attribute_list['Cards_Decision'].value=objDataForm.Cards_Decision.options[objDataForm.Cards_Decision.selectedIndex].value;
			objWI_Obj.attribute_list['Cards_Decision'].modified_flag=true;
			objWI_Obj.attribute_list['Cards_Remarks'].value=objDataForm.Cards_Remarks.value;
			objWI_Obj.attribute_list['Cards_Remarks'].modified_flag=true;
			}	 
		
		if(objWI_Obj.workstep_name=="Pending")
			{ 
		if(chkMandatory==1){
			if(objDataForm.DCI_ExtNo.value==""){
			alert("Ext No. is Mandatory");
			objDataForm.DCI_ExtNo.focus();
			return false;
		}else if(!CheckDataType(objDataForm.DCI_ExtNo.value,"Numeric")){
			alert("Invalid Data in Ext No. Only Numeric are allowed");
			objDataForm.DCI_ExtNo.focus();
			return false;
		}else if(objDataForm.DCI_ExtNo.value.length < 4){
			alert("Ext No. should be of 4 digits");
			objDataForm.DCI_ExtNo.focus();
			return false;
		}
		

		if(chkMandatory==1&&objDataForm.VD_TINCheck.checked==false&&objDataForm.VD_MoMaidN.checked==false){
			alert("Atleast one of Verification Details is Mandatory");
			objDataForm.VD_TINCheck.focus();
			return false;
		}
		if(objDataForm.VD_MoMaidN.checked==true){
			var i=0;
			if(objDataForm.VD_DOB.checked==true) i++;
			if(objDataForm.VD_StaffId.checked==true) i++;
			//if(objDataForm.VD_PassNo.checked==true) i++;
			if(objDataForm.VD_POBox.checked==true) i++;
			if(objDataForm.VD_Oth.checked==true) i++;
			if(objDataForm.VD_MRT.checked==true) i++;
			//if(objDataForm.VD_NOSC.checked==true) i++;
			//if(objDataForm.VD_SD.checked==true) i++;
			if(objDataForm.VD_TELNO.checked==true) i++;
			if(objDataForm.VD_EDC.checked==true) i++;
			
			if(i<4)
			{			
			alert("Please select at least 4 Ramdom questions");
			objDataForm.VD_POBox.focus();
			return false;
			}
			
		}
		if(chkMandatory==1&&objDataForm.REMARKS.value==""){
			alert("Remarks is Mandatory.");
			objDataForm.REMARKS.focus();
			return false;
		if (objDataForm.REMARKS.value.length>500)
			   {
				alert("Remarks/Reasons can't be greater than 500 Characters");
				objDataForm.REMARKS.focus();
				return false;
			   }
		} else if(!space_Check(objDataForm.REMARKS.value)){
			alert("Invalid Data in REMARKS. Only spaces are not allowed");
			objDataForm.REMARKS.focus();
			return false;
		} 
	}
		 if	(objDataForm.VD_TINCheck.checked)
	    {
         objWI_Obj.attribute_list['VD_TINCheck'].value='Y'
         objWI_Obj.attribute_list['VD_TINCheck'].modified_flag=true;
    	}
		else
	    {
		 objWI_Obj.attribute_list['VD_TINCheck'].value='N'
         objWI_Obj.attribute_list['VD_TINCheck'].modified_flag=true;
		}

		if	(objDataForm.VD_MoMaidN.checked)
	    {
         objWI_Obj.attribute_list['VD_MoMaidN'].value='Y'
         objWI_Obj.attribute_list['VD_MoMaidN'].modified_flag=true;
    	}
		else
	    {
		 objWI_Obj.attribute_list['VD_MoMaidN'].value='N'
         objWI_Obj.attribute_list['VD_MoMaidN'].modified_flag=true;
		}

		if	(objDataForm.VD_DOB.checked)
	    {
         objWI_Obj.attribute_list['VD_DOB'].value='Y'
         objWI_Obj.attribute_list['VD_DOB'].modified_flag=true;
    	}
		else
	    {
		 objWI_Obj.attribute_list['VD_DOB'].value='N'
         objWI_Obj.attribute_list['VD_DOB'].modified_flag=true;
		}

		if	(objDataForm.VD_StaffId.checked)
	    {
         objWI_Obj.attribute_list['VD_StaffId'].value='Y'
         objWI_Obj.attribute_list['VD_StaffId'].modified_flag=true;
    	}
		else
	    {
		 objWI_Obj.attribute_list['VD_StaffId'].value='N'
         objWI_Obj.attribute_list['VD_StaffId'].modified_flag=true;
		}

		/*if	(objDataForm.VD_PassNo.checked)
	    {
         objWI_Obj.attribute_list['VD_PassNo'].value='Y'
         objWI_Obj.attribute_list['VD_PassNo'].modified_flag=true;
    	}
		else
	    {
		 objWI_Obj.attribute_list['VD_PassNo'].value='N'
         objWI_Obj.attribute_list['VD_PassNo'].modified_flag=true;
		}*/

		if	(objDataForm.VD_POBox.checked)
	    {
         objWI_Obj.attribute_list['VD_POBox'].value='Y'
         objWI_Obj.attribute_list['VD_POBox'].modified_flag=true;
    	}
		else
	    {
		 objWI_Obj.attribute_list['VD_POBox'].value='N'
         objWI_Obj.attribute_list['VD_POBox'].modified_flag=true;
		}

		if	(objDataForm.VD_Oth.checked)
	    {
         objWI_Obj.attribute_list['VD_Oth'].value='Y'
         objWI_Obj.attribute_list['VD_Oth'].modified_flag=true;
    	}
		else
	    {
			
		 objWI_Obj.attribute_list['VD_Oth'].value='N'
         objWI_Obj.attribute_list['VD_Oth'].modified_flag=true;
		}
        if	(objDataForm.VD_MRT.checked)
	    {
         objWI_Obj.attribute_list['VD_MRT'].value='Y'
         objWI_Obj.attribute_list['VD_MRT'].modified_flag=true;
    	}
		else
	    {
			
		 objWI_Obj.attribute_list['VD_MRT'].value='N'
         objWI_Obj.attribute_list['VD_MRT'].modified_flag=true;
		}

		if	(objDataForm.VD_EDC.checked)
	    {
         objWI_Obj.attribute_list['VD_EDC'].value='Y'
         objWI_Obj.attribute_list['VD_EDC'].modified_flag=true;
    	}
		else
	    {
			
		 objWI_Obj.attribute_list['VD_EDC'].value='N'
         objWI_Obj.attribute_list['VD_EDC'].modified_flag=true;
		}
/*
		if	(objDataForm.VD_NOSC.checked)
	    {
         objWI_Obj.attribute_list['VD_NOSC'].value='Y'
         objWI_Obj.attribute_list['VD_NOSC'].modified_flag=true;
    	}
		else
	    {
			
		 objWI_Obj.attribute_list['VD_NOSC'].value='N'
         objWI_Obj.attribute_list['VD_NOSC'].modified_flag=true;
		}

		if	(objDataForm.VD_SD.checked)
	    {
         objWI_Obj.attribute_list['VD_SD'].value='Y'
         objWI_Obj.attribute_list['VD_SD'].modified_flag=true;
    	}
		else
	    {
			
		 objWI_Obj.attribute_list['VD_SD'].value='N'
         objWI_Obj.attribute_list['VD_SD'].modified_flag=true;
		}
*/
		if	(objDataForm.VD_TELNO.checked)
	    {
         objWI_Obj.attribute_list['VD_TELNO'].value='Y'
         objWI_Obj.attribute_list['VD_TELNO'].modified_flag=true;
    	}
		else
	    {
			
		 objWI_Obj.attribute_list['VD_TELNO'].value='N'
         objWI_Obj.attribute_list['VD_TELNO'].modified_flag=true;
		}

		objWI_Obj.attribute_list['REMARKS'].value=objDataForm.REMARKS.value;
		objWI_Obj.attribute_list['REMARKS'].modified_flag=true;
		
		return true;
	}
	
	if(objWI_Obj.workstep_name=="Branch_Return")
			{ 
		if(chkMandatory==1){
			if(objDataForm.DCI_ExtNo.value==""){
			alert("Ext No. is Mandatory");
			objDataForm.DCI_ExtNo.focus();
			return false;
		}else if(!CheckDataType(objDataForm.DCI_ExtNo.value,"Numeric")){
			alert("Invalid Data in Ext No. Only Numeric are allowed");
			objDataForm.DCI_ExtNo.focus();
			return false;
		}else if(objDataForm.DCI_ExtNo.value.length < 4){
			alert("Ext No. should be of 4 digits");
			objDataForm.DCI_ExtNo.focus();
			return false;
		}
		

		if(chkMandatory==1&&objDataForm.VD_TINCheck.checked==false&&objDataForm.VD_MoMaidN.checked==false){
			alert("Atleast one of Verification Details is Mandatory");
			objDataForm.VD_TINCheck.focus();
			return false;
		}
		if(objDataForm.VD_MoMaidN.checked==true){
			var i=0;
			if(objDataForm.VD_DOB.checked==true) i++;
			if(objDataForm.VD_StaffId.checked==true) i++;
			//if(objDataForm.VD_PassNo.checked==true) i++;
			if(objDataForm.VD_POBox.checked==true) i++;
			if(objDataForm.VD_Oth.checked==true) i++;
			if(objDataForm.VD_MRT.checked==true) i++;
			//if(objDataForm.VD_NOSC.checked==true) i++;
			//if(objDataForm.VD_SD.checked==true) i++;
			if(objDataForm.VD_TELNO.checked==true) i++;
			if(objDataForm.VD_EDC.checked==true) i++;
			
			if(i<4)
			{			
			alert("Please select at least 4 Ramdom questions");
			objDataForm.VD_POBox.focus();
			return false;
			}
			
		}
		if(chkMandatory==1&&objDataForm.REMARKS.value==""){
			alert("Remarks is Mandatory.");
			objDataForm.REMARKS.focus();
			return false;
		if (objDataForm.REMARKS.value.length>500)
			   {
				alert("Remarks/Reasons can't be greater than 500 Characters");
				objDataForm.REMARKS.focus();
				return false;
			   }
		} else if(!space_Check(objDataForm.REMARKS.value)){
			alert("Invalid Data in REMARKS. Only spaces are not allowed");
			objDataForm.REMARKS.focus();
			return false;
		} 
	}
		 if	(objDataForm.VD_TINCheck.checked)
	    {
         objWI_Obj.attribute_list['VD_TINCheck'].value='Y'
         objWI_Obj.attribute_list['VD_TINCheck'].modified_flag=true;
    	}
		else
	    {
		 objWI_Obj.attribute_list['VD_TINCheck'].value='N'
         objWI_Obj.attribute_list['VD_TINCheck'].modified_flag=true;
		}

		if	(objDataForm.VD_MoMaidN.checked)
	    {
         objWI_Obj.attribute_list['VD_MoMaidN'].value='Y'
         objWI_Obj.attribute_list['VD_MoMaidN'].modified_flag=true;
    	}
		else
	    {
		 objWI_Obj.attribute_list['VD_MoMaidN'].value='N'
         objWI_Obj.attribute_list['VD_MoMaidN'].modified_flag=true;
		}

		if	(objDataForm.VD_DOB.checked)
	    {
         objWI_Obj.attribute_list['VD_DOB'].value='Y'
         objWI_Obj.attribute_list['VD_DOB'].modified_flag=true;
    	}
		else
	    {
		 objWI_Obj.attribute_list['VD_DOB'].value='N'
         objWI_Obj.attribute_list['VD_DOB'].modified_flag=true;
		}

		if	(objDataForm.VD_StaffId.checked)
	    {
         objWI_Obj.attribute_list['VD_StaffId'].value='Y'
         objWI_Obj.attribute_list['VD_StaffId'].modified_flag=true;
    	}
		else
	    {
		 objWI_Obj.attribute_list['VD_StaffId'].value='N'
         objWI_Obj.attribute_list['VD_StaffId'].modified_flag=true;
		}

		/*if	(objDataForm.VD_PassNo.checked)
	    {
         objWI_Obj.attribute_list['VD_PassNo'].value='Y'
         objWI_Obj.attribute_list['VD_PassNo'].modified_flag=true;
    	}
		else
	    {
		 objWI_Obj.attribute_list['VD_PassNo'].value='N'
         objWI_Obj.attribute_list['VD_PassNo'].modified_flag=true;
		}
*/
		if	(objDataForm.VD_POBox.checked)
	    {
         objWI_Obj.attribute_list['VD_POBox'].value='Y'
         objWI_Obj.attribute_list['VD_POBox'].modified_flag=true;
    	}
		else
	    {
		 objWI_Obj.attribute_list['VD_POBox'].value='N'
         objWI_Obj.attribute_list['VD_POBox'].modified_flag=true;
		}

		if	(objDataForm.VD_Oth.checked)
	    {
         objWI_Obj.attribute_list['VD_Oth'].value='Y'
         objWI_Obj.attribute_list['VD_Oth'].modified_flag=true;
    	}
		else
	    {
			
		 objWI_Obj.attribute_list['VD_Oth'].value='N'
         objWI_Obj.attribute_list['VD_Oth'].modified_flag=true;
		}

		if	(objDataForm.VD_MRT.checked)
	    {
         objWI_Obj.attribute_list['VD_MRT'].value='Y'
         objWI_Obj.attribute_list['VD_MRT'].modified_flag=true;
    	}
		else
	    {
			
		 objWI_Obj.attribute_list['VD_MRT'].value='N'
         objWI_Obj.attribute_list['VD_MRT'].modified_flag=true;
		}

		if	(objDataForm.VD_EDC.checked)
	    {
         objWI_Obj.attribute_list['VD_EDC'].value='Y'
         objWI_Obj.attribute_list['VD_EDC'].modified_flag=true;
    	}
		else
	    {
			
		 objWI_Obj.attribute_list['VD_EDC'].value='N'
         objWI_Obj.attribute_list['VD_EDC'].modified_flag=true;
		}
/*
		if	(objDataForm.VD_NOSC.checked)
	    {
         objWI_Obj.attribute_list['VD_NOSC'].value='Y'
         objWI_Obj.attribute_list['VD_NOSC'].modified_flag=true;
    	}
		else
	    {
			
		 objWI_Obj.attribute_list['VD_NOSC'].value='N'
         objWI_Obj.attribute_list['VD_NOSC'].modified_flag=true;
		}

		if	(objDataForm.VD_SD.checked)
	    {
         objWI_Obj.attribute_list['VD_SD'].value='Y'
         objWI_Obj.attribute_list['VD_SD'].modified_flag=true;
    	}
		else
	    {
			
		 objWI_Obj.attribute_list['VD_SD'].value='N'
         objWI_Obj.attribute_list['VD_SD'].modified_flag=true;
		}
*/
		if	(objDataForm.VD_TELNO.checked)
	    {
         objWI_Obj.attribute_list['VD_TELNO'].value='Y'
         objWI_Obj.attribute_list['VD_TELNO'].modified_flag=true;
    	}
		else
	    {
			
		 objWI_Obj.attribute_list['VD_TELNO'].value='N'
         objWI_Obj.attribute_list['VD_TELNO'].modified_flag=true;
		}
		objWI_Obj.attribute_list['REMARKS'].value=objDataForm.REMARKS.value;
		objWI_Obj.attribute_list['REMARKS'].modified_flag=true;
		
		return true;
	}


    
		return true;
}

function CheckDataType(cntrlValue,dataType)
{
	switch(dataType){
		case "Numeric":
			regex=/^[0-9]*$/;
			break;
		case "character":
			regex=/^[a-z ]*$/i;
			break;
		case "date":
			regex=/^0[1-9]\/[0-9]{2}|1[012]\/[0-9]{2}$/;
			break;
		case "numeric82":			
			regex = /^([0-9]{0,8}\.[0-9]{1,2}|[0-9]{0,8})$/;						
			break;
        case "alphanumeric":
		    regex = /^[a-z0-9]*$/i;
			break;
		case "name":
			regex=/^[a-z,\'_. &]*$/i;
			break;
        case "amount":
			regex=/^[0-9]*$/;
			break;
		case "float":
			regex=/^[0-9,.,-]*$/;
		    break;
	}
	return regex.test(cntrlValue);
}
function space_Check(str) {
	Test = str;
	for (i=0,n=Test.length;i<n;i++) {
		if(Test.charCodeAt(i)!=32) {
			return true;
		}
	}
	return false;
}