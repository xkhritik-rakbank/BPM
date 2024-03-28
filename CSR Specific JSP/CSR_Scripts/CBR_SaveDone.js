


function CBR_SaveDone(chkMandatory)
{
    var objWI_Obj=window.top.wi_object;
	var objDataForm=window.parent.frames['left'].document.forms["dataform"];
/*

	Product/Project :       Rak Bank
	Module          :       Cash Back Request
	File            :       CBR_SaveDone.js
	Purpose         :       Requests in pending queue to have discard option. This should allow user to delete the request from the workflow
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/094				   29/5/2009	Saurabh Arora
*/
	if(objWI_Obj.workstep_name=="Pending")
	{
		objWI_Obj.attribute_list['Pending_Decision'].value=objDataForm.Pending_Decision.options[objDataForm.Pending_Decision.selectedIndex].value;
		objWI_Obj.attribute_list['Pending_Decision'].modified_flag=true;
	}	
	if(objWI_Obj.workstep_name=="Branch_Return")
			{
		
			
			if(chkMandatory==1&&objDataForm.BR_Decision.options[objDataForm.BR_Decision.selectedIndex].value=="")
				{
				alert("Branch Decision is Mandatory");
				objDataForm.BR_Decision.focus();
				return false;
				}
			objWI_Obj.attribute_list['BR_Decision'].value=objDataForm.BR_Decision.options[objDataForm.BR_Decision.selectedIndex].value;
			objWI_Obj.attribute_list['BR_Decision'].modified_flag=true;
			objWI_Obj.attribute_list['BR_Remarks'].value=objDataForm.BR_Remarks.value;
			objWI_Obj.attribute_list['BR_Remarks'].modified_flag=true;
			if(chkMandatory==1&&objDataForm.BR_Decision.options[objDataForm.BR_Decision.selectedIndex].value.toUpperCase()=="DISCARD"&&objDataForm.BR_Remarks.value=="")
				{
					alert("Remarks/Reason is Mandatory");
					objDataForm.BR_Remarks.focus();
					return false;
				}
		   if (objDataForm.BR_Remarks.value.length>255)
				{
				alert("Remarks/Reasons can't be greater than 255 Characters");
				objDataForm.BR_Remarks.focus();
				return false;
			   }
			
			}	 
		
		if(objWI_Obj.workstep_name=="CARDS")
			{//alert("112");
			
			if(chkMandatory==1&&objDataForm.Cards_Decision.options[objDataForm.Cards_Decision.selectedIndex].value=="")
				{
				alert("CARDS Decision is Mandatory");
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
			objWI_Obj.attribute_list['Cards_Decision'].value=objDataForm.Cards_Decision.options[objDataForm.Cards_Decision.selectedIndex].value;
			objWI_Obj.attribute_list['Cards_Decision'].modified_flag=true;
			objWI_Obj.attribute_list['Cards_Remarks'].value=objDataForm.Cards_Remarks.value;
			objWI_Obj.attribute_list['Cards_Remarks'].modified_flag=true;
			objDataForm.AMOUNT.value=replaceAll(objDataForm.AMOUNT.value,",","");
			return true;
			}	
			
		
/*		if(chkMandatory==1&&objDataForm.CCI_CName.value==""){
			alert("Customer Name is Mandatory");
			objDataForm.CCI_CName.focus();
			return false;
		}else if(!CheckDataType(objDataForm.CCI_CName.value,"character")){
			alert("Invalid Data in Customer Name Only Characters are allowed ");
			objDataForm.CCI_CName.focus();
			return false;
		}
		if(chkMandatory==1&&objDataForm.CCI_ExpD.value==""){
			alert("Expiry Date is Mandatory");
			objDataForm.CCI_ExpD.focus();
			return false;
		}else if(!CheckDataType(objDataForm.CCI_ExpD.value,"date")){
			alert("Invalid Data in Expiry Date Only MM/YY format  is allowed");
			objDataForm.CCI_ExpD.focus();
			return false;
		}
		if(chkMandatory==1&&objDataForm.CCI_CCRNNo.value==""){
			alert("Card CRN No is Mandatory");
			objDataForm.CCI_CCRNNo.focus();
			return false;
		}else if(!CheckDataType(objDataForm.CCI_CCRNNo.value,"Numeric")){
			alert("Invalid Data in Card CRN No Only Numerics are allowed");
			objDataForm.CCI_CCRNNo.focus();
			return false;
		}
		if(chkMandatory==1&&objDataForm.CCI_SC.value==""){
			alert("Source Code is Mandatory");
			objDataForm.CCI_SC.focus();
			return false;
		}else if(!CheckDataType(objDataForm.CCI_SC.value,"alphanumeric")){
			alert("Invalid Data in Source Code Only Numbers and Characters are allowed");
			objDataForm.CCI_SC.focus();
			return false;
		}
		if(chkMandatory==1&&objDataForm.CCI_ExtNo.value==""){
			alert("Ext No. is Mandatory");
			objDataForm.CCI_ExtNo.focus();
			return false;
		}else if(!CheckDataType(objDataForm.CCI_ExtNo.value,"alphanumeric")){
			alert("Invalid Data in Ext No. Only characters are allowed");
			objDataForm.CCI_ExtNo.focus();
			return false;
		}
		if(chkMandatory==1&&objDataForm.CCI_MONO.value==""){
			alert("Mobile No. is Mandatory");
			objDataForm.CCI_MONO.focus();
			return false;
		}else if(!CheckDataType(objDataForm.CCI_MONO.value,"alphanumeric")){
			alert("Invalid Data in Ext No. Only characters are allowed");
			objDataForm.CCI_ExtNo.focus();
			return false;
		}
		//**********************
		if(chkMandatory==1&&objDataForm.CCI_AccInc.value==""){
			alert("Accessed Income is Mandatory");
			objDataForm.CCI_AccInc.focus();
			return false;
		}else if(!CheckDataType(replaceAll(objDataForm.CCI_AccInc.value,",",""),"numeric82")){
			alert("Invalid Data in Accessed Income  Only Numeric 8,2 are allowed");
			objDataForm.CCI_AccInc.focus();
			return false;
		}
		if(chkMandatory==1&&objDataForm.CCI_CT.value==""){
			alert("Card Type is Mandatory");
			objDataForm.CCI_CT.focus();
			return false;
		}else if(!CheckDataType(objDataForm.CCI_CT.value,"character")){
			alert("Invalid Data in Card Type Only Character are allowed");
			objDataForm.CCI_CT.focus();
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
			if(objDataForm.VD_PassNo.checked==true) i++;
			if(objDataForm.VD_POBox.checked==true) i++;
			if(objDataForm.VD_Oth.checked==true) i++;
			if(chkMandatory==1&&i<2)
			{			
			alert("Any two out of Date of Birth,Staff Id,Passport No.,PO Box  No.,Others (Pls. Specify) are Mandatory");
			objDataForm.VD_DOB.focus();
			return false;
			}
			if(chkMandatory==1&&objDataForm.VD_Oth.checked==true&&objDataForm.VD_OthSpe.value==""){
				alert("Others (Pls. Specify) is Mandatory");
				objDataForm.VD_OthSpe.focus();
				return false;
			}else if(!CheckDataType(objDataForm.VD_Oth.value,"character")){
				alert("Invalid Data in Others (Pls. Specify) Only Character are allowed");
				objDataForm.VD_Oth.focus();
				return false;
			}
		}*/

		/*if(objDataForm.CCI_CName.value==""){
			alert("Customer Name is Mandatory");
			objDataForm.CCI_CName.focus();
			return false;
		}else if(!CheckDataType(objDataForm.CCI_CName.value,"character")){
			alert("Invalid Data in Customer Name Only Characters are allowed ");
			objDataForm.CCI_CName.focus();
			return false;
		}
		if(objDataForm.CCI_ExpD.value==""){
			alert("Expiry Date is Mandatory");
			objDataForm.CCI_ExpD.focus();
			return false;
		}else if(!CheckDataType(objDataForm.CCI_ExpD.value,"date")){
			alert("Invalid Data in Expiry Date Only MM/YY format  is allowed");
			objDataForm.CCI_ExpD.focus();
			return false;
		}*/
		if(objDataForm.CCI_ExtNo.value==""){
			alert("Ext No. is Mandatory");
			objDataForm.CCI_ExtNo.focus();
			return false;
		}else if(!CheckDataType(objDataForm.CCI_ExtNo.value,"Numeric")){
			alert("Invalid Data in Ext No. Only Numeric are allowed");
			objDataForm.CCI_ExtNo.focus();
			return false;
		}else if(objDataForm.CCI_ExtNo.value.length < 4){
			alert("Ext No. should be of 4 digits");
			objDataForm.CCI_ExtNo.focus();
			return false;
		}
		/*if(objDataForm.CCI_CCRNNo.value==""){
			alert("Card CRN No is Mandatory");
			objDataForm.CCI_CCRNNo.focus();
			return false;
		}else if(!CheckDataType(objDataForm.CCI_CCRNNo.value,"Numeric")){
			alert("Invalid Data in Card CRN No Only Numerics are allowed");
			objDataForm.CCI_CCRNNo.focus();
			return false;
			
		}else if(objDataForm.CCI_CCRNNo.value.length < 9){
			alert("Card CRN No should be of nine digits");
			objDataForm.CCI_CCRNNo.focus();
			return false;
		}
		if(processName=="CSR_BT"||processName=="CSR_CCC")
		{
			if(objDataForm.CCI_SC.value==""){
				alert("Source Code is Mandatory");
				objDataForm.CCI_SC.focus();
				return false;
			}else if(!CheckDataType(objDataForm.CCI_SC.value,"Numeric")){
				alert("Invalid Data in Source Code Only Numeric are allowed");
				objDataForm.CCI_SC.focus();
				return false;
			}else if(objDataForm.CCI_SC.value.length < 7){
				alert("Source Code should be of seven digits");
				objDataForm.CCI_SC.focus();
				return false;
			}
		}
		
		if(objDataForm.CCI_MONO.value==""){
			alert("Mobile No. is Mandatory");
			objDataForm.CCI_MONO.focus();
			return false;
		}else if(!CheckDataType(objDataForm.CCI_ExtNo.value,"Numeric")){
			alert("Invalid Data in Mobile No.  Only Numeric are allowed");
			objDataForm.CCI_ExtNo.focus();
			return false;
		}
		//**********************
		if(objDataForm.CCI_AccInc.value==""){
			alert("Accessed Income is Mandatory");
			objDataForm.CCI_AccInc.focus();
			return false;
		}else if(!CheckDataType(objDataForm.CCI_AccInc.value,"numeric82")){
			alert("Invalid Data in Accessed Income  Only Numeric (10,2) are allowed");
			objDataForm.CCI_AccInc.focus();
			return false;
		}
		if(objDataForm.CCI_CT.value==""){
			alert("Card Type is Mandatory");
			objDataForm.CCI_CT.focus();
			return false;
		}else if(!CheckDataType(objDataForm.CCI_CT.value,"character")){
			alert("Invalid Data in Card Type Only Character are allowed");
			objDataForm.CCI_CT.focus();
			return false;
		}*/

		if(chkMandatory==1&&objDataForm.VD_TINCheck.checked==false&&objDataForm.VD_MoMaidN.checked==false){
			alert("Atleast one of Verification Details is Mandatory");
			objDataForm.VD_TINCheck.focus();
			return false;
		}
		if(objDataForm.VD_MoMaidN.checked==true){
			var i=0;
			if(objDataForm.VD_DOB.checked==true) i++;
			if(objDataForm.VD_StaffId.checked==true) i++;
			if(objDataForm.VD_PassNo.checked==true) i++;
			if(objDataForm.VD_POBox.checked==true) i++;
			if(objDataForm.VD_Oth.checked==true) i++;
			if(objDataForm.VD_MRT.checked==true) i++;
			if(objDataForm.VD_NOSC.checked==true) i++;
			if(objDataForm.VD_SD.checked==true) i++;
			if(objDataForm.VD_TELNO.checked==true) i++;
			if(objDataForm.VD_EDC.checked==true) i++;
			
			if(i<4)
			{			
			alert("Please select at least 4 Ramdom questions");
			objDataForm.VD_POBox.focus();
			return false;
			}
			/*if(chkMandatory==1&&objDataForm.VD_Oth.checked==true&&objDataForm.VD_OthSpe.value==""){
				alert("Others (Pls. Specify) is Mandatory");
				objDataForm.VD_OthSpe.focus();
				return false;
			}else if(!CheckDataType(objDataForm.VD_Oth.value,"character")){
				alert("Invalid Data in Others (Pls. Specify) Only Character are allowed");
				objDataForm.VD_Oth.focus();
				return false;
			}*/
		}
		
		
		
		
		if(chkMandatory==1&&objDataForm.CASHBACK_TYPE.options[objDataForm.CASHBACK_TYPE.selectedIndex].value==""){
			alert("Type is Mandatory");
			objDataForm.CASHBACK_TYPE.focus();
			return false;
		}
		if(objDataForm.REMARKS.value==""){
					alert("Remarks/ Reason is Mandatory");
					objDataForm.REMARKS.focus();
					return false;
				}
/*

	Product/Project :       Rak Bank
	Module          :       Cash Back Request
	File            :       CSR_ProcessSpec_CBR.jsp
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/071				   Saurabh Arora
*/
		 if (objDataForm.REMARKS.value.length>500)
				{
				alert("Remarks/Reasons can't be greater than 500 Characters");
				objDataForm.REMARKS.focus();
				return false;
			   }
		if(chkMandatory==1&&objDataForm.CASHBACK_TYPE.options[objDataForm.CASHBACK_TYPE.selectedIndex].value.toUpperCase()=="REDEMPTION"){
			if(chkMandatory==1&&objDataForm.AMOUNT.value==""){
				alert("Amount is Mandatory");
				objDataForm.AMOUNT.focus();
				return false;
			}			
			if(chkMandatory==1&&objDataForm.AMOUNT.value<parseFloat("100.00"))
				{
					alert("Amount should be greater than 100");
					objDataForm.AMOUNT.focus();
					return false;
				}
		}
		if(chkMandatory==1&&objDataForm.CASHBACK_TYPE.options[objDataForm.CASHBACK_TYPE.selectedIndex].value.toUpperCase()=="UN-ENROLLMENT"){
				if(objDataForm.REMARKS.value==""){
					alert("Remarks/ Reason is Mandatory");
					objDataForm.REMARKS.focus();
					return false;
				}
		
			}      

		objWI_Obj.attribute_list['REMARKS'].value=objDataForm.elements['REMARKS'].value;
		objWI_Obj.attribute_list['REMARKS'].modified_flag=true;

       
	    objWI_Obj.attribute_list['CASHBACK_TYPE'].value=objDataForm.CASHBACK_TYPE.options[objDataForm.CASHBACK_TYPE.selectedIndex].value;
		objWI_Obj.attribute_list['CASHBACK_TYPE'].modified_flag=true;

	  
	   objDataForm.AMOUNT.value=replaceAll(objDataForm.AMOUNT.value,",","");
		//objWI_Obj.attribute_list['AMOUNT'].modified_flag=true;
       
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

		if	(objDataForm.VD_PassNo.checked)
	    {
         objWI_Obj.attribute_list['VD_PassNo'].value='Y'
         objWI_Obj.attribute_list['VD_PassNo'].modified_flag=true;
    	}
		else
	    {
		 objWI_Obj.attribute_list['VD_PassNo'].value='N'
         objWI_Obj.attribute_list['VD_PassNo'].modified_flag=true;
		}

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