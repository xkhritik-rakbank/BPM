function BT_SaveDone(chkMandatory)
{
    var objWI_Obj=window.top.wi_object;
	var objDataForm=window.parent.frames['left'].document.forms["dataform"];
/*

	Product/Project :       Rak Bank
	Module          :       Balance Transfer Request
	File            :       BT_SaveDone.js
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
		if(objWI_Obj.workstep_name=="Branch_Approver")//Decision Remarks Mandatory
			{
			if(chkMandatory==1&&objDataForm.BA_Decision.options[objDataForm.BA_Decision.selectedIndex].value=="")
				{
				alert("Branch Approver Decision is Mandatory");
				objDataForm.BA_Decision.focus();
				return false;
				}
			if(chkMandatory==1&&objDataForm.BA_Decision.options[objDataForm.BA_Decision.selectedIndex].value=="BA_D"&&objDataForm.BA_Remarks.value=="")
				{
				alert("Branch Approver Remarks is Mandatory");
				objDataForm.BA_Remarks.focus();
				return false;
				}
			if (objDataForm.BA_Remarks.value.length>255)//Remarks can't be more than 255 chars
				{
					alert("Remarks/Reasons can't be greater than 255 Characters");
					objDataForm.BA_Remarks.focus();
					return false;
				}
			objWI_Obj.attribute_list['BA_Decision'].value=objDataForm.BA_Decision.options[objDataForm.BA_Decision.selectedIndex].value;
			objWI_Obj.attribute_list['BA_Decision'].modified_flag=true;
			objWI_Obj.attribute_list['BA_Remarks'].value=objDataForm.BA_Remarks.value;
			objWI_Obj.attribute_list['BA_Remarks'].modified_flag=true;
			return true;
			}
		if(objWI_Obj.workstep_name=="CARDS")//Decision Remarks Mandatory
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
			if (objDataForm.Cards_Remarks.value.length>255)//Remarks max length 255
			   {
				alert("Remarks/Reasons can't be greater than 255 Characters");
				objDataForm.Cards_Remarks.focus();
				return false;
			   }
			objWI_Obj.attribute_list['Cards_Decision'].value=objDataForm.Cards_Decision.options[objDataForm.Cards_Decision.selectedIndex].value;
			objWI_Obj.attribute_list['Cards_Decision'].modified_flag=true;
			objWI_Obj.attribute_list['Cards_Remarks'].value=objDataForm.Cards_Remarks.value;
			objWI_Obj.attribute_list['Cards_Remarks'].modified_flag=true;
			return true;
			}	 
		
		/*if(chkMandatory==1&&objDataForm.CCI_CName.value==""){
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
		}
		
		if(chkMandatory==1&&objDataForm.BTD_OBC_CT.options[objDataForm.BTD_OBC_CT.selectedIndex].value==""){
			alert("Card Type is Mandatory");
			objDataForm.BTD_OBC_CT.focus();
			return false;
		}
		if(objDataForm.BTD_OBC_CT.options[objDataForm.BTD_OBC_CT.selectedIndex].value.toUpperCase()=="OTHERS"){				
				if(chkMandatory==1&&objDataForm.BTD_OBC_OBN.options[objDataForm.BTD_OBC_OBN.selectedIndex].value==""){
					alert("Other Bank Name is Mandatory");
					objDataForm.BTD_OBC_OBN.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.BTD_OBC_OBNO.value==""){
					alert("Others (Pls. Specify) is Mandatory");
					objDataForm.BTD_OBC_OBNO.focus();
					return false;
				}else if(!CheckDataType(objDataForm.BTD_OBC_OBNO.value,"Numeric")){
					alert("Invalid Data in Others (Pls. Specify) Only Numerics are allowed");
					objDataForm.BTD_OBC_OBNO.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.BTD_OBC_OBCNO.value==""){
					alert("Other Bank Card No. is Mandatory");
					objDataForm.BTD_OBC_OBCNO.focus();
					return false;
				}else if(!CheckDataType(objDataForm.BTD_OBC_OBCNO.value,"Numeric")){
					alert("Invalid Data in Other Bank Card No. Only Numerics are allowed");
					objDataForm.BTD_OBC_OBCNO.focus();
					return false;
				}			
		}
		if(chkMandatory==1&&objDataForm.BTD_OBC_NOOC.value==""){
			alert("Name on Other Card is Mandatory");
			objDataForm.BTD_OBC_NOOC.focus();
			return false;
		}else if(!CheckDataType(objDataForm.BTD_OBC_NOOC.value,"name")){
			alert("Invalid Data in Name on Other Card Only Alphabets,._and & are allowed");
			objDataForm.BTD_OBC_NOOC.focus();
			return false;
		}
		if(chkMandatory==1&&objDataForm.BTD_OBC_DT.options[objDataForm.BTD_OBC_DT.selectedIndex].value==""){
			alert("Deliver To is Mandatory");
			objDataForm.BTD_OBC_DT.focus();
			return false;
		}
		if(chkMandatory==1&&objDataForm.BTD_OBC_DT.options[objDataForm.BTD_OBC_DT.selectedIndex].value.toUpperCase()=="BANK"){
			if(chkMandatory==1&&objDataForm.BTD_OBC_BN.options[objDataForm.BTD_OBC_BN.selectedIndex].value.toUpperCase()==""){
			
			//if(objDataForm.BTD_OBC_BN.value==""){
				alert("Branch Name is Mandatory");
				objDataForm.BTD_OBC_BN.focus();
				return false;
			//}else if(!CheckDataType(objDataForm.BTD_OBC_BN.value,"character")){
			//	alert("Invalid Data in Branch Name Only Characters are allowed");
			//	objDataForm.BTD_OBC_BN.focus();
			//	return false;
			}
		}
		if((chkMandatory==1&&objDataForm.BTD_RBC_RBCN1.options[objDataForm.BTD_RBC_RBCN1.selectedIndex].value==""&&objDataForm.BTD_RBC_RBCN1.options[objDataForm.BTD_RBC_RBCN1.selectedIndex].value=="")||(objDataForm.BTD_RBC_RBCN2.options[objDataForm.BTD_RBC_RBCN2.selectedIndex].value==""&&objDataForm.BTD_RBC_RBCN3.options[objDataForm.BTD_RBC_RBCN3.selectedIndex].value=="")||(objDataForm.BTD_RBC_RBCN3.options[objDataForm.BTD_RBC_RBCN3.selectedIndex].value==""&&objDataForm.BTD_RBC_RBCN1.options[objDataForm.BTD_RBC_RBCN1.selectedIndex].value=="")){
			alert("Any two of the RAKBANK card no.'s is Mandatory");			
			return false;
		}

		//BTD_RBC_RBCN1 any two are mandatory
		if(chkMandatory==1&&objDataForm.BTD_RBC_RBCN1.options[objDataForm.BTD_RBC_RBCN1.selectedIndex].value!="")
		{
			if(objDataForm.BTD_RBC_CT1.value==""){
				alert("Card Type is Mandatory");
				objDataForm.BTD_RBC_CT1.focus();
				return false;
			}
			else if(!CheckDataType(objDataForm.BTD_RBC_CT1.value,"character")){
				alert("Invalid Data in Card Type Only characters are allowed");
				objDataForm.BTD_RBC_CT1.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.BTD_RBC_ExpD1.value==""){
				alert("Expiry Date is Mandatory");
				objDataForm.BTD_RBC_ExpD1.focus();
				return false;
			}else if(!CheckDataType(objDataForm.BTD_RBC_ExpD1.value,"date")){
				alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
				objDataForm.BTD_RBC_ExpD1.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.BTD_RBC_BTA1.value==""){
				alert("BT Amount(AED) is Mandatory");
				objDataForm.BTD_RBC_BTA1.focus();
				return false;
			}else if(!CheckDataType(replaceAll(objDataForm.BTD_RBC_BTA1.value,",",""),"numeric82")){
				alert("Invalid Data in BT Amount(AED) Only Numerics are allowed");
				objDataForm.BTD_RBC_BTA1.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.BTD_RBC_AppC1.value==""){
				alert("Approval Code is Mandatory");
				objDataForm.BTD_RBC_AppC1.focus();
				return false;
			}else if(!CheckDataType(objDataForm.BTD_RBC_AppC1.value,"Numeric")){
				alert("Invalid Data in Approval Code Only Numerics are allowed");
				objDataForm.BTD_RBC_AppC1.focus();
				return false;
			}
		}
		if(objDataForm.BTD_RBC_RBCN2.options[objDataForm.BTD_RBC_RBCN2.selectedIndex].value!="")
		{
			if(chkMandatory==1&&objDataForm.BTD_RBC_CT2.value==""){
				alert("Card Type is Mandatory");
				objDataForm.BTD_RBC_CT2.focus();
				return false;
			}else if(!CheckDataType(objDataForm.BTD_RBC_CT2.value,"character")){
				alert("Invalid Data in Card Type Only characters are allowed");
				objDataForm.BTD_RBC_CT2.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.BTD_RBC_ExpD2.value==""){
				alert("Expiry Date is Mandatory");
				objDataForm.BTD_RBC_ExpD2.focus();
				return false;
			}else if(!CheckDataType(objDataForm.BTD_RBC_ExpD2.value,"date")){
				alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
				objDataForm.BTD_RBC_ExpD2.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.BTD_RBC_BTA2.value==""){
				alert("BT Amount(AED) is Mandatory");
				objDataForm.BTD_RBC_BTA2.focus();
				return false;
			}else if(!CheckDataType(replaceAll(objDataForm.BTD_RBC_BTA2.value,",",""),"numeric82")){
				alert("Invalid Data in BT Amount(AED) Only Numerics are allowed");
				objDataForm.BTD_RBC_BTA2.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.BTD_RBC_AppC2.value==""){
				alert("Approval Code is Mandatory");
				objDataForm.BTD_RBC_AppC2.focus();
				return false;
			}else if(!CheckDataType(objDataForm.BTD_RBC_AppC2.value,"Numeric")){
				alert("Invalid Data in Approval Code Only Numerics are allowed");
				objDataForm.BTD_RBC_AppC2.focus();
				return false;
			}
		}
		if(objDataForm.BTD_RBC_RBCN3.options[objDataForm.BTD_RBC_RBCN3.selectedIndex].value!="")
		{
			if(chkMandatory==1&&objDataForm.BTD_RBC_CT3.value==""){
				alert("Card Type is Mandatory");
				objDataForm.BTD_RBC_CT3.focus();
				return false;
			}else if(!CheckDataType(objDataForm.BTD_RBC_CT3.value,"character")){
				alert("Invalid Data in Card Type Only characters are allowed");
				objDataForm.BTD_RBC_CT3.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.BTD_RBC_ExpD3.value==""){
				alert("Expiry Date is Mandatory");
				objDataForm.BTD_RBC_ExpD3.focus();
				return false;
			}else if(!CheckDataType(objDataForm.BTD_RBC_ExpD3.value,"date")){
				alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
				objDataForm.BTD_RBC_ExpD3.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.BTD_RBC_BTA3.value==""){
				alert("BT Amount(AED) is Mandatory");
				objDataForm.BTD_RBC_BTA3.focus();
				return false;
			}else if(!CheckDataType(replaceAll(objDataForm.BTD_RBC_BTA3.value,",",""),"numeric82")){
				alert("Invalid Data in BT Amount(AED) Only Numerics are allowed");
				objDataForm.BTD_RBC_BTA3.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.BTD_RBC_AppC3.value==""){
				alert("Approval Code is Mandatory");
				objDataForm.BTD_RBC_AppC3.focus();
				return false;
			}else if(!CheckDataType(objDataForm.BTD_RBC_AppC3.value,"Numeric")){
				alert("Invalid Data in Approval Code Only Numerics are allowed");
				objDataForm.BTD_RBC_AppC3.focus();
				return false;
			}
		}
	
*/
		

		//####################################################################################################
		
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
		if(chkMandatory==1&&objDataForm.CCI_ExtNo.value==""){
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
		}	*/	


		if(chkMandatory==1&&objDataForm.CCI_SC.value==""){
			alert("Source Code is Mandatory");
			objDataForm.CCI_SC.focus();
			return false;
		}else if(!CheckDataType(objDataForm.CCI_SC.value,"alphanumeric")){
			alert("Invalid Data in Source Code Only Alphanumeric are allowed");
			objDataForm.CCI_SC.focus();
			return false;
		}else if(objDataForm.CCI_SC.value.length < 6){
			alert("Source Code should be of six or seven digits");
			objDataForm.CCI_SC.focus();
			return false;
		}
		
		
		/*if(objDataForm.CCI_MONO.value==""){
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
	
			if(chkMandatory==1&&objDataForm.BTD_OBC_CT.options[objDataForm.BTD_OBC_CT.selectedIndex].value==""){
				alert("Card Type is Mandatory");
				objDataForm.BTD_OBC_CT.focus();
				return false;
			}
			/*if(objDataForm.BTD_OBC_CT.options[objDataForm.BTD_OBC_CT.selectedIndex].value.toUpperCase()=="OTHERS"){				
					if(chkMandatory==1&&objDataForm.BTD_OBC_OBN.options[objDataForm.BTD_OBC_OBN.selectedIndex].value==""){
						alert("Other Bank Name is Mandatory");
						objDataForm.BTD_OBC_OBN.focus();
						return false;
					}
					if(chkMandatory==1&&objDataForm.BTD_OBC_OBNO.value==""){
						alert("Others (Pls. Specify) is Mandatory");
						objDataForm.BTD_OBC_OBNO.focus();
						return false;
					}else if(!CheckDataType(replaceAll(objDataForm.BTD_OBC_OBNO.value,"-",""),"Numeric")){
						alert("Invalid Data in Others (Pls. Specify) Only Numerics are allowed");
						objDataForm.BTD_OBC_OBNO.focus();
						return false;
					}
					if(chkMandatory==1&&objDataForm.BTD_OBC_OBCNO.value==""){
						alert("Other Bank Card No. is Mandatory");
						objDataForm.BTD_OBC_OBCNO.focus();
						return false;
					}else if(!CheckDataType(replaceAll(objDataForm.BTD_OBC_OBCNO.value,"-",""),"Numeric")){
						alert("Invalid Data in Other Bank Card No. Only Numerics are allowed");
						objDataForm.BTD_OBC_OBCNO.focus();
						return false;
					}			
			}*/
			
			if(chkMandatory==1&&objDataForm.BTD_OBC_OBN.options[objDataForm.BTD_OBC_OBN.selectedIndex].value==""){
				alert("Other Bank Name is Mandatory");
				objDataForm.BTD_OBC_OBN.focus();
				return false;
			}
			
			if(objDataForm.BTD_OBC_CT.options[objDataForm.BTD_OBC_CT.selectedIndex].value.toUpperCase()=="OTHERS"||objDataForm.BTD_OBC_OBN.options[objDataForm.BTD_OBC_OBN.selectedIndex].value.toUpperCase()=="OTHERS"){									
					if(chkMandatory==1&&objDataForm.BTD_OBC_OBNO.value==""){
						alert("Others (Pls. Specify) is Mandatory");
						objDataForm.BTD_OBC_OBNO.disabled=false;
						objDataForm.BTD_OBC_OBNO.focus();
						return false;
					}else if(!CheckDataType(replaceAll(objDataForm.BTD_OBC_OBNO.value,"-",""),"character")){
						alert("Invalid Data in Others (Pls. Specify) Only character are allowed");
						objDataForm.BTD_OBC_OBNO.focus();
						return false;
					}						
			}
			if(chkMandatory==1&&objDataForm.BTD_OBC_OBCNO.value==""){
						alert("Other Bank Card No. is Mandatory");
						objDataForm.BTD_OBC_OBCNO.focus();
						return false;
			}else if(!CheckDataType(replaceAll(objDataForm.BTD_OBC_OBCNO.value,"-",""),"Numeric")){
						alert("Invalid Data in Other Bank Card No. Only Numerics are allowed");
						objDataForm.BTD_OBC_OBCNO.focus();
						return false;
			}
			if(chkMandatory==1&&objDataForm.BTD_OBC_NOOC.value==""){
				alert("Name on Other Card is Mandatory");
				objDataForm.BTD_OBC_NOOC.focus();
				return false;
			}else if(!CheckDataType(objDataForm.BTD_OBC_NOOC.value,"name")){
				alert("Invalid Data in Name on Other Card Only characters , .,& , _ and ' are allowed");
				objDataForm.BTD_OBC_NOOC.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.BTD_OBC_DT.options[objDataForm.BTD_OBC_DT.selectedIndex].value==""){
				alert("Deliver To is Mandatory");
				objDataForm.BTD_OBC_DT.focus();
				return false;
			}
			if(objDataForm.BTD_OBC_DT.options[objDataForm.BTD_OBC_DT.selectedIndex].value.toUpperCase()=="BANK"){
				if(chkMandatory==1&&objDataForm.BTD_OBC_BN.value==""){
					alert("Branch Name is Mandatory");
					objDataForm.BTD_OBC_BN.focus();
					return false;
				}
			}
		/*	if((objDataForm.BTD_RBC_RBCN1.options[objDataForm.BTD_RBC_RBCN1.selectedIndex].value==""&&objDataForm.BTD_RBC_RBCN2.options[objDataForm.BTD_RBC_RBCN2.selectedIndex].value=="")||(objDataForm.BTD_RBC_RBCN2.options[objDataForm.BTD_RBC_RBCN2.selectedIndex].value==""&&objDataForm.BTD_RBC_RBCN3.options[objDataForm.BTD_RBC_RBCN3.selectedIndex].value=="")||(objDataForm.BTD_RBC_RBCN3.options[objDataForm.BTD_RBC_RBCN3.selectedIndex].value==""&&objDataForm.BTD_RBC_RBCN1.options[objDataForm.BTD_RBC_RBCN1.selectedIndex].value=="")){
				alert("Any two of the RAKBANK card no.'s is Mandatory");			
				return false;
			}

			if((objDataForm.BTD_RBC_RBCN1.options[objDataForm.BTD_RBC_RBCN1.selectedIndex].value==objDataForm.BTD_RBC_RBCN2.options[objDataForm.BTD_RBC_RBCN2.selectedIndex].value)||(objDataForm.BTD_RBC_RBCN2.options[objDataForm.BTD_RBC_RBCN2.selectedIndex].value==objDataForm.BTD_RBC_RBCN3.options[objDataForm.BTD_RBC_RBCN3.selectedIndex].value)||(objDataForm.BTD_RBC_RBCN3.options[objDataForm.BTD_RBC_RBCN3.selectedIndex].value==objDataForm.BTD_RBC_RBCN1.options[objDataForm.BTD_RBC_RBCN1.selectedIndex].value)){
				alert("RAKBANK card no.'s Should be unique");			
				return false;
			}*/

			if(chkMandatory==1&&objDataForm.BTD_RBC_RBCN1.options[objDataForm.BTD_RBC_RBCN1.selectedIndex].value==""&&objDataForm.BTD_RBC_RBCN2.options[objDataForm.BTD_RBC_RBCN2.selectedIndex].value==""&&objDataForm.BTD_RBC_RBCN3.options[objDataForm.BTD_RBC_RBCN3.selectedIndex].value==""){
				alert("Any one of the RAKBANK card no.'s is Mandatory");
				objDataForm.BTD_RBC_RBCN1.focus();
				return false;
			}

			var rakbankcardno1Value=objDataForm.BTD_RBC_RBCN1.options[objDataForm.BTD_RBC_RBCN1.selectedIndex].value;	
			var rakbankcardno2Value=objDataForm.BTD_RBC_RBCN2.options[objDataForm.BTD_RBC_RBCN2.selectedIndex].value;	
			var rakbankcardno3Value=objDataForm.BTD_RBC_RBCN3.options[objDataForm.BTD_RBC_RBCN3.selectedIndex].value;	
			if((rakbankcardno1Value!=""&&rakbankcardno2Value!=""&&rakbankcardno1Value==rakbankcardno2Value)||(rakbankcardno2Value!=""&&rakbankcardno3Value!=""&&rakbankcardno2Value==rakbankcardno3Value)||(rakbankcardno3Value!=""&&rakbankcardno1Value!=""&&rakbankcardno3Value==rakbankcardno1Value)){
				alert("RAKBANK card no.'s Should be unique");	
				objDataForm.BTD_RBC_RBCN1.focus();
				return false;
			}

			//BTD_RBC_RBCN1 any two are mandatory
			if(objDataForm.BTD_RBC_RBCN1.options[objDataForm.BTD_RBC_RBCN1.selectedIndex].value!="")
			{
				if(chkMandatory==1&&objDataForm.BTD_RBC_CT1.value==""){
					alert("Card Type is Mandatory");
					objDataForm.BTD_RBC_CT1.focus();
					return false;
				}
				else if(!CheckDataType(objDataForm.BTD_RBC_CT1.value,"character")){
					alert("Invalid Data in Card Type Only characters are allowed");
					objDataForm.BTD_RBC_CT1.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.BTD_RBC_ExpD1.value==""){
					alert("Expiry Date is Mandatory");
					objDataForm.BTD_RBC_ExpD1.focus();
					return false;
				}else if(!CheckDataType(objDataForm.BTD_RBC_ExpD1.value,"date")){
					alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
					objDataForm.BTD_RBC_ExpD1.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.BTD_RBC_BTA1.value==""){
					alert("BT Amount(AED) is Mandatory");
					objDataForm.BTD_RBC_BTA1.focus();
					return false;
				}else if(!CheckDataType(replaceAll(objDataForm.BTD_RBC_BTA1.value,",",""),"numeric82")){
					alert("Invalid Data in BT Amount(AED) Only Numerics(10,2) are allowed");
					objDataForm.BTD_RBC_BTA1.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.BTD_RBC_AppC1.value==""){
					alert("Approval Code is Mandatory");
					objDataForm.BTD_RBC_AppC1.focus();
					return false;
				}else if(!CheckDataType(objDataForm.BTD_RBC_AppC1.value,"Numeric")){
					alert("Invalid Data in Approval Code Only Numeric are allowed");
					objDataForm.BTD_RBC_AppC1.focus();
					return false;
				}
			}
			if(objDataForm.BTD_RBC_RBCN2.options[objDataForm.BTD_RBC_RBCN2.selectedIndex].value!="")
			{
				if(chkMandatory==1&&objDataForm.BTD_RBC_CT2.value==""){
					alert("Card Type is Mandatory");
					objDataForm.BTD_RBC_CT2.focus();
					return false;
				}else if(!CheckDataType(objDataForm.BTD_RBC_CT2.value,"character")){
					alert("Invalid Data in Card Type Only characters are allowed");
					objDataForm.BTD_RBC_CT2.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.BTD_RBC_ExpD2.value==""){
					alert("Expiry Date is Mandatory");
					objDataForm.BTD_RBC_ExpD2.focus();
					return false;
				}else if(!CheckDataType(objDataForm.BTD_RBC_ExpD2.value,"date")){
					alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
					objDataForm.BTD_RBC_ExpD2.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.BTD_RBC_BTA2.value==""){
					alert("BT Amount(AED) is Mandatory");
					objDataForm.BTD_RBC_BTA2.focus();
					return false;
				}else if(!CheckDataType(replaceAll(objDataForm.BTD_RBC_BTA2.value,",",""),"numeric82")){
					alert("Invalid Data in BT Amount(AED) Only Numerics(10,2) are allowed");
					objDataForm.BTD_RBC_BTA2.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.BTD_RBC_AppC2.value==""){
					alert("Approval Code is Mandatory");
					objDataForm.BTD_RBC_AppC2.focus();
					return false;
				}else if(!CheckDataType(objDataForm.BTD_RBC_AppC2.value,"Numeric")){
					alert("Invalid Data in Approval Code Only Numeric are allowed");
					objDataForm.BTD_RBC_AppC2.focus();
					return false;
				}
			}
			if(objDataForm.BTD_RBC_RBCN3.options[objDataForm.BTD_RBC_RBCN3.selectedIndex].value!="")
			{
				if(chkMandatory==1&&objDataForm.BTD_RBC_CT3.value==""){
					alert("Card Type is Mandatory");
					objDataForm.BTD_RBC_CT3.focus();
					return false;
				}else if(!CheckDataType(objDataForm.BTD_RBC_CT3.value,"character")){
					alert("Invalid Data in Card Type Only characters are allowed");
					objDataForm.BTD_RBC_CT3.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.BTD_RBC_ExpD3.value==""){
					alert("Expiry Date is Mandatory");
					objDataForm.BTD_RBC_ExpD3.focus();
					return false;
				}else if(!CheckDataType(objDataForm.BTD_RBC_ExpD3.value,"date")){
					alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
					objDataForm.BTD_RBC_ExpD3.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.BTD_RBC_BTA3.value==""){
					alert("BT Amount(AED) is Mandatory");
					objDataForm.BTD_RBC_BTA3.focus();
					return false;
				}else if(!CheckDataType(replaceAll(objDataForm.BTD_RBC_BTA3.value,",",""),"numeric82")){
					alert("Invalid Data in BT Amount(AED) Only Numerics(10,2) are allowed");
					objDataForm.BTD_RBC_BTA3.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.BTD_RBC_AppC3.value==""){
					alert("Approval Code is Mandatory");
					objDataForm.BTD_RBC_AppC3.focus();
					return false;
				}else if(!CheckDataType(objDataForm.BTD_RBC_AppC3.value,"Numeric")){
					alert("Invalid Data in Approval Code Only Numeric are allowed");
					objDataForm.BTD_RBC_AppC3.focus();
					return false;
				}
			}
/*
	Product/Project :       Rak Bank
	Module          :       Balance Transfer
	File            :       BT_SaveDone.js
	Purpose         :       Approval code should be mandated to 6 digits. It is currently accepting 5 digits
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/005					02/09/2008	 

*/

			if (chkMandatory==1&&objDataForm.BTD_RBC_AppC1.value=="")
			{
			}
			else if (chkMandatory==1&&objDataForm.BTD_RBC_AppC1.value.length!=6)
			{
				alert("Approval Code should be of 6 digits");
				objDataForm.BTD_RBC_AppC1.focus();
				return false;
			}
			if (chkMandatory==1&&objDataForm.BTD_RBC_AppC2.value=="")
			{
			}
			else if (chkMandatory==1&&objDataForm.BTD_RBC_AppC2.value.length!=6)
			{
				alert("Approval Code should be of 6 digits");
				objDataForm.BTD_RBC_AppC2.focus();
				return false;
			}
			if (chkMandatory==1&&objDataForm.BTD_RBC_AppC3.value=="")
			{
			}
			else if (chkMandatory==1&&objDataForm.BTD_RBC_AppC3.value.length!=6)
			{
				alert("Approval Code should be of 6 digits");
				objDataForm.BTD_RBC_AppC3.focus();
				return false;
			}	
			
			var sumvar="0";
			if(objDataForm.BTD_RBC_BTA1.value!="")	
				sumvar=parseFloat(sumvar)+parseFloat(replaceAll(objDataForm.BTD_RBC_BTA1.value,",",""));	
			if(objDataForm.BTD_RBC_BTA2.value!="")	
				sumvar=parseFloat(sumvar)+parseFloat(replaceAll(objDataForm.BTD_RBC_BTA2.value,",",""));	
			if(objDataForm.BTD_RBC_BTA3.value!="")	
				sumvar=parseFloat(sumvar)+parseFloat(replaceAll(objDataForm.BTD_RBC_BTA3.value,",",""));	
			//alert("sumvar "+sumvar);
			//alert(objDataForm.BTD_RBC_BTA3.value);
			//alert("lalitkumar");
			//alert(objDataForm.BTD_RBC_RBCN1.value);
			//alert((parseFloat(objDataForm.BTD_RBC_BTA1.value)+parseFloat(objDataForm.BTD_RBC_BTA2.value)+parseFloat(objDataForm.BTD_RBC_BTA3.value)));
			//alert((parseFloat(objDataForm.BTD_RBC_BTA1.value)+parseFloat(objDataForm.BTD_RBC_BTA2.value)+parseFloat(objDataForm.BTD_RBC_BTA3.value))<parseFloat("1000.00"));
			if(sumvar<parseFloat("1000.00") && objDataForm.BTD_RBC_RBCN1.value != "")
			{
				alert("Sum Of BT Amount(AED)'s should be greater than or equal to 1000");
				return false;
			}
			
			if(objDataForm.BTD_OBC_DT.options[objDataForm.BTD_OBC_DT.selectedIndex].value.toUpperCase()=="OTHERS"){
				if(objDataForm.BTD_RBC_RR.value==""){
					alert("Remarks/ Reason is Mandatory");
					objDataForm.BTD_RBC_RR.focus();
					return false;
				}
			}
/*

	Product/Project :       Rak Bank
	Module          :       Balance Transfer
	File            :       BT_SaveDone.js
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/068				   Saurabh Arora
*/
			if (objDataForm.BTD_RBC_RR.value.length>500)//Remarks max length 500
			   {
				alert("Remarks/Reasons can't be greater than 500 Characters");
				objDataForm.BTD_RBC_RR.focus();
				return false;
			   }

	

		//########################################################################################################



          
		objWI_Obj.attribute_list['BTD_RBC_BTA1'].value=replaceAll(objDataForm.BTD_RBC_BTA1.value,",","");
		objWI_Obj.attribute_list['BTD_RBC_BTA1'].modified_flag=true;
		objWI_Obj.attribute_list['BTD_RBC_BTA2'].value=replaceAll(objDataForm.BTD_RBC_BTA2.value,",","");
		objWI_Obj.attribute_list['BTD_RBC_BTA2'].modified_flag=true;
		objWI_Obj.attribute_list['BTD_RBC_BTA3'].value=replaceAll(objDataForm.BTD_RBC_BTA3.value,",","");
		objWI_Obj.attribute_list['BTD_RBC_BTA3'].modified_flag=true;

		objWI_Obj.attribute_list['BTD_RBC_RR'].value=objDataForm.elements['BTD_RBC_RR'].value;
		objWI_Obj.attribute_list['BTD_RBC_RR'].modified_flag=true;

        objWI_Obj.attribute_list['BTD_RBC_RBCN1'].value=objDataForm.BTD_RBC_RBCN1.options[objDataForm.BTD_RBC_RBCN1.selectedIndex].value;
		objWI_Obj.attribute_list['BTD_RBC_RBCN1'].modified_flag=true;

        objWI_Obj.attribute_list['BTD_RBC_RBCN2'].value=objDataForm.BTD_RBC_RBCN2.options[objDataForm.BTD_RBC_RBCN2.selectedIndex].value;
		objWI_Obj.attribute_list['BTD_RBC_RBCN2'].modified_flag=true;
       
	    objWI_Obj.attribute_list['BTD_RBC_RBCN3'].value=objDataForm.BTD_RBC_RBCN3.options[objDataForm.BTD_RBC_RBCN3.selectedIndex].value;
		objWI_Obj.attribute_list['BTD_RBC_RBCN3'].modified_flag=true;

		objWI_Obj.attribute_list['BTD_OBC_CT'].value=objDataForm.BTD_OBC_CT.options[objDataForm.BTD_OBC_CT.selectedIndex].value;
		objWI_Obj.attribute_list['BTD_OBC_CT'].modified_flag=true;

        objWI_Obj.attribute_list['BTD_OBC_OBN'].value=objDataForm.BTD_OBC_OBN.options[objDataForm.BTD_OBC_OBN.selectedIndex].value;
		objWI_Obj.attribute_list['BTD_OBC_OBN'].modified_flag=true;
       
	    objWI_Obj.attribute_list['BTD_OBC_DT'].value=objDataForm.BTD_OBC_DT.options[objDataForm.BTD_OBC_DT.selectedIndex].value;
		objWI_Obj.attribute_list['BTD_OBC_DT'].modified_flag=true;

       //Checkboxes, save Y for checked, N for unchecked
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
		    regex = /^[a-z0-9 ]*$/i;
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