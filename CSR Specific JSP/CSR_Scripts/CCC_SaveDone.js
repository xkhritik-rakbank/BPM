


function CCC_SaveDone(chkMandatory)
{

	//alert(chkMandatory);
    var objWI_Obj=window.top.wi_object;
	var objDataForm=window.parent.frames['left'].document.forms["dataform"];
/*

	Product/Project :       Rak Bank
	Module          :       Credit Card Cheque Request
	File            :       CCC_SaveDone.js
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
		if (objWI_Obj.workstep_name=="Branch_Return");
		{
/*

	Product/Project :       Rak Bank
	Module          :       Credit Card Cheque
	File            :       CCC_SaveDone.js
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/069				   Saurabh Arora
*/
			if (objDataForm.REMARKS.value.length>500)
				{
					alert("Remarks/Reasons can't be greater than 500 Characters");
					objDataForm.REMARKS.focus();
					return false;
				}					
		}
		
	//WriteLog("abcdefgh"+chkMandatory);
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
				
				alert("Branch Approver Remarks is Mandatory");
				objDataForm.BA_Remarks.focus();
				return false;
				}
			  //alert("lalit");	
			if (objDataForm.BA_Remarks.value.length>255)
				{
					alert("Remarks/Reasons can't be greater than 255 Characters");
					objDataForm.BA_Remarks.focus();
					return false;
				}
			objWI_Obj.attribute_list['BA_Decision'].value=objDataForm.BA_Decision.options[objDataForm.BA_Decision.selectedIndex].value;
			objWI_Obj.attribute_list['BA_Decision'].modified_flag=true;
			objWI_Obj.attribute_list['BA_Remarks'].value=objDataForm.BA_Remarks.value;
			objWI_Obj.attribute_list['BA_Remarks'].modified_flag=true;
		objDataForm.CHQ_AMOUNT1.value=replaceAll(objDataForm.CHQ_AMOUNT1.value,",","");
		 objDataForm.CHQ_AMOUNT2.value=replaceAll(objDataForm.CHQ_AMOUNT2.value,",","");
		 objDataForm.CHQ_AMOUNT3.value=replaceAll(objDataForm.CHQ_AMOUNT3.value,",","");
			return true;
			}
		if(objWI_Obj.workstep_name=="CARDS")
			{
						//alert("112");
						//alert(chkMandatory);

			if(chkMandatory==1&&objDataForm.Cards_Decision.options[objDataForm.Cards_Decision.selectedIndex].value=="")
				{
				//alert(objDataForm.Cards_Remarks.value);
				//alert(objDataForm.Cards_Remarks.value.length);

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
				//alert(objDataForm.Cards_Remarks.value);
			
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
			objDataForm.CHQ_AMOUNT1.value=replaceAll(objDataForm.CHQ_AMOUNT1.value,",","");
		 objDataForm.CHQ_AMOUNT2.value=replaceAll(objDataForm.CHQ_AMOUNT2.value,",","");
		 objDataForm.CHQ_AMOUNT3.value=replaceAll(objDataForm.CHQ_AMOUNT3.value,",","");
			return true;
			}	 
		
	/*	if(chkMandatory==1&&objDataForm.CCI_CName.value==""){
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
		}*/
		
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
		if(chkMandatory==1&&objDataForm.BANEFICIARY_NAME.value==""){
			alert("Beneficiary Name is Mandatory");
			objDataForm.BANEFICIARY_NAME.focus();
			return false;
		}else if(!CheckDataType(objDataForm.BANEFICIARY_NAME.value,"name")){
			alert("Invalid Data in Beneficiary Name Only Alphabets,._and & are allowed");
			objDataForm.BANEFICIARY_NAME.focus();
			return false;
		}
		if(chkMandatory==1&&objDataForm.DELIVERTO.options[objDataForm.DELIVERTO.selectedIndex].value==""){
			alert("Deliver To is Mandatory");
			objDataForm.DELIVERTO.focus();
			return false;
		}
		if(chkMandatory==1&&objDataForm.DELIVERTO.options[objDataForm.DELIVERTO.selectedIndex].value.toUpperCase()=="BANK"){
			if(chkMandatory==1&&objDataForm.BRANCHCODE.options[objDataForm.BRANCHCODE.selectedIndex].value.toUpperCase()==""){
			
			//if(objDataForm.BTD_OBC_BN.value==""){
				alert("Branch Name is Mandatory");
				objDataForm.BRANCHCODE.focus();
				return false;
			//}else if(!CheckDataType(objDataForm.BTD_OBC_BN.value,"character")){
			//	alert("Invalid Data in Branch Name Only Characters are allowed");
			//	objDataForm.BTD_OBC_BN.focus();
			//	return false;
			}
		}
		/*if((chkMandatory==1&&objDataForm.CARDNO1.options[objDataForm.CARDNO1.selectedIndex].value==""&&objDataForm.CARDNO2.options[objDataForm.CARDNO2.selectedIndex].value=="")||(objDataForm.CARDNO2.options[objDataForm.CARDNO2.selectedIndex].value==""&&objDataForm.CARDNO3.options[objDataForm.CARDNO3.selectedIndex].value=="")||(objDataForm.CARDNO3.options[objDataForm.CARDNO3.selectedIndex].value==""&&objDataForm.CARDNO1.options[objDataForm.CARDNO1.selectedIndex].value=="")){
			alert("Any two of the RAKBANK card no.'s is Mandatory");			
			return false;
		}
		//BTD_RBC_RBCN1 any two are mandatory

         if((objDataForm.CARDNO1.options[objDataForm.CARDNO1.selectedIndex].value==objDataForm.CARDNO2.options[objDataForm.CARDNO2.selectedIndex].value)||(objDataForm.CARDNO2.options[objDataForm.CARDNO2.selectedIndex].value==objDataForm.CARDNO3.options[objDataForm.CARDNO3.selectedIndex].value)||(objDataForm.CARDNO3.options[objDataForm.CARDNO3.selectedIndex].value==objDataForm.CARDNO1.options[objDataForm.CARDNO1.selectedIndex].value)){
				alert("RAKBANK card no.'s Should be unique");			
				return false;
			}*/
		
		if(chkMandatory==1&&objDataForm.CARDNO1.options[objDataForm.CARDNO1.selectedIndex].value==""&&objDataForm.CARDNO2.options[objDataForm.CARDNO2.selectedIndex].value==""&&objDataForm.CARDNO3.options[objDataForm.CARDNO3.selectedIndex].value==""){
				alert("Any one of the RAKBANK card no.'s is Mandatory");
				objDataForm.CARDNO1.focus();
				return false;
			}

		var rakbankcardno1Value=objDataForm.CARDNO1.options[objDataForm.CARDNO1.selectedIndex].value;	
		var rakbankcardno2Value=objDataForm.CARDNO2.options[objDataForm.CARDNO2.selectedIndex].value;	
		var rakbankcardno3Value=objDataForm.CARDNO3.options[objDataForm.CARDNO3.selectedIndex].value;	
		if((rakbankcardno1Value!=""&&rakbankcardno2Value!=""&&rakbankcardno1Value==rakbankcardno2Value)||(rakbankcardno2Value!=""&&rakbankcardno3Value!=""&&rakbankcardno2Value==rakbankcardno3Value)||(rakbankcardno3Value!=""&&rakbankcardno1Value!=""&&rakbankcardno3Value==rakbankcardno1Value)){
			alert("RAKBANK card no.'s Should be unique");	
			objDataForm.CARDNO1.focus();
			return false;
		}

		if(chkMandatory==1&&objDataForm.CARDNO1.options[objDataForm.CARDNO1.selectedIndex].value!="")
		{
			if(chkMandatory==1&&objDataForm.CARDTYPE1.value==""){
				alert("Card Type is Mandatory");
				objDataForm.CARDTYPE1.focus();
				return false;
			}
			else if(!CheckDataType(objDataForm.CARDTYPE1.value,"character")){
				alert("Invalid Data in Card Type Only characters are allowed");
				objDataForm.CARDTYPE1.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.CARDEXPIRY_DATE1.value==""){
				alert("Expiry Date is Mandatory");
				objDataForm.CARDEXPIRY_DATE1.focus();
				return false;
			}else if(!CheckDataType(objDataForm.CARDEXPIRY_DATE1.value,"date")){
				alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
				objDataForm.CARDEXPIRY_DATE1.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.CHQ_AMOUNT1.value==""){
				alert("Cheque Amount(AED) is Mandatory");
				objDataForm.CHQ_AMOUNT1.focus();
				return false;
			}else if(!CheckDataType(replaceAll(objDataForm.CHQ_AMOUNT1.value,",",""),"numeric82")){
				alert("Invalid Data in Cheque Amount(AED) Only Numerics are allowed");
				objDataForm.CHQ_AMOUNT1.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.ApprovalCode1.value==""){
				alert("Approval Code is Mandatory");
				objDataForm.ApprovalCode1.focus();
				return false;
			}else if(!CheckDataType(objDataForm.ApprovalCode1.value,"Numeric")){
				alert("Invalid Data in Approval Code Only Numerics are allowed");
				objDataForm.ApprovalCode1.focus();
				return false;
			}
		}
		if(chkMandatory==1&&objDataForm.CARDNO2.options[objDataForm.CARDNO2.selectedIndex].value!="")
		{
			if(chkMandatory==1&&objDataForm.CARDTYPE2.value==""){
				alert("Card Type is Mandatory");
				objDataForm.CARDTYPE2.focus();
				return false;
			}
			else if(!CheckDataType(objDataForm.CARDTYPE2.value,"character")){
				alert("Invalid Data in Card Type Only characters are allowed");
				objDataForm.CARDTYPE2.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.CARDEXPIRY_DATE2.value==""){
				alert("Expiry Date is Mandatory");
				objDataForm.CARDEXPIRY_DATE2.focus();
				return false;
			}else if(!CheckDataType(objDataForm.CARDEXPIRY_DATE2.value,"date")){
				alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
				objDataForm.CARDEXPIRY_DATE2.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.CHQ_AMOUNT2.value==""){
				alert("Cheque Amount(AED) is Mandatory");
				objDataForm.CHQ_AMOUNT2.focus();
				return false;
			}else if(!CheckDataType(replaceAll(objDataForm.CHQ_AMOUNT2.value,",",""),"numeric82")){
				alert("Invalid Data in Cheque Amount(AED) Only Numerics are allowed");
				objDataForm.CHQ_AMOUNT2.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.ApprovalCode2.value==""){
				alert("Approval Code is Mandatory");
				objDataForm.ApprovalCode2.focus();
				return false;
			}else if(!CheckDataType(objDataForm.ApprovalCode2.value,"Numeric")){
				alert("Invalid Data in Approval Code Only Numerics are allowed");
				objDataForm.ApprovalCode2.focus();
				return false;
			}
		}
		if(chkMandatory==1&&objDataForm.CARDNO3.options[objDataForm.CARDNO3.selectedIndex].value!="")
		{
			if(chkMandatory==1&&objDataForm.CARDTYPE3.value==""){
				alert("Card Type is Mandatory");
				objDataForm.CARDTYPE3.focus();
				return false;
			}
			else if(!CheckDataType(objDataForm.CARDTYPE3.value,"character")){
				alert("Invalid Data in Card Type Only characters are allowed");
				objDataForm.CARDTYPE3.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.CARDEXPIRY_DATE3.value==""){
				alert("Expiry Date is Mandatory");
				objDataForm.CARDEXPIRY_DATE3.focus();
				return false;
			}else if(!CheckDataType(objDataForm.CARDEXPIRY_DATE3.value,"date")){
				alert("Invalid Data in Expiry Date Only date in MM/YY format is allowed");
				objDataForm.CARDEXPIRY_DATE3.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.CHQ_AMOUNT3.value==""){
				alert("Cheque Amount(AED) is Mandatory");
				objDataForm.CHQ_AMOUNT3.focus();
				return false;
			}else if(!CheckDataType(replaceAll(objDataForm.CHQ_AMOUNT3.value,",",""),"numeric82")){
				alert("Invalid Data in Cheque Amount(AED) Only Numerics are allowed");
				objDataForm.CHQ_AMOUNT3.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.ApprovalCode3.value==""){
				alert("Approval Code is Mandatory");
				objDataForm.ApprovalCode3.focus();
				return false;
			}else if(!CheckDataType(objDataForm.ApprovalCode3.value,"Numeric")){
				alert("Invalid Data in Approval Code Only Numerics are allowed");
				objDataForm.ApprovalCode3.focus();
				return false;
			}
		}
	
/*
	Product/Project :       Rak Bank
	Module          :       Credit Card Cheque
	File            :       CCC_SaveDone.js
	Purpose         :       Approval code should be mandated to 6 digits. It is currently accepting 5 digits
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/006					02/09/2008	 

*/

			if (chkMandatory==1&&objDataForm.ApprovalCode1.value=="")
			{
			}
			else if (chkMandatory==1&&objDataForm.ApprovalCode1.value.length!=6)
			{
				alert("Approval Code should be of 6 digits");
				objDataForm.ApprovalCode1.focus();
				return false;
			}
			if (chkMandatory==1&&objDataForm.ApprovalCode2.value=="")
			{
			}
			else if (chkMandatory==1&&objDataForm.ApprovalCode2.value.length!=6)
			{
				alert("Approval Code should be of 6 digits");
				objDataForm.ApprovalCode2.focus();
				return false;
			}
			if (chkMandatory==1&&objDataForm.ApprovalCode3.value=="")
			{
			}
			else if (chkMandatory==1&&objDataForm.ApprovalCode3.value.length!=6)
			{
				alert("Approval Code should be of 6 digits");
				objDataForm.ApprovalCode3.focus();
				return false;
			}	

            var sumvar="0";
			if(objDataForm.CHQ_AMOUNT1.value!="")	
				sumvar=parseFloat(sumvar)+parseFloat(replaceAll(objDataForm.CHQ_AMOUNT1.value,",",""));	
			if(objDataForm.CHQ_AMOUNT2.value!="")	
				sumvar=parseFloat(sumvar)+parseFloat(replaceAll(objDataForm.CHQ_AMOUNT2.value,",",""));	
			if(objDataForm.CHQ_AMOUNT3.value!="")	
				sumvar=parseFloat(sumvar)+parseFloat(replaceAll(objDataForm.CHQ_AMOUNT3.value,",",""));	
			
			if(chkMandatory==1&&sumvar<parseFloat("1000.00"))
			{
				alert("Sum Of Cheque Amount(AED)'s should be greater than or equal to 1000");
               // CHQ_AMOUNT1.focus();
				return false;
			}	
			
			if(objDataForm.DELIVERTO.options[objDataForm.DELIVERTO.selectedIndex].value.toUpperCase()=="OTHERS"){
				if(objDataForm.REMARKS.value==""){
					alert("Remarks/ Reason is Mandatory");
					objDataForm.REMARKS.focus();
					return false;
				}
/*

	Product/Project :       Rak Bank
	Module          :       Credit Card Cheque
	File            :       CCC_SaveDone.js
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/069				   Saurabh Arora
*/
				if (objDataForm.REMARKS.value.length>500)
			   {
				alert("Remarks/Reasons can't be greater than 500 Characters");
				objDataForm.REMARKS.focus();
				return false;
			   }
			}	

      

	     objDataForm.CHQ_AMOUNT1.value=replaceAll(objDataForm.CHQ_AMOUNT1.value,",","");
		 objDataForm.CHQ_AMOUNT2.value=replaceAll(objDataForm.CHQ_AMOUNT2.value,",","");
		 objDataForm.CHQ_AMOUNT3.value=replaceAll(objDataForm.CHQ_AMOUNT3.value,",","");

		//objWI_Obj.attribute_list['CHQ_AMOUNT1'].modified_flag=true;
		//objWI_Obj.attribute_list['CHQ_AMOUNT2'].value=replaceAll(objDataForm.CHQ_AMOUNT2.value,",","");
		//objWI_Obj.attribute_list['CHQ_AMOUNT2'].modified_flag=true;
		//objWI_Obj.attribute_list['CHQ_AMOUNT3'].value=replaceAll(objDataForm.CHQ_AMOUNT3.value,",","");
		//objWI_Obj.attribute_list['CHQ_AMOUNT3'].modified_flag=true;

		objWI_Obj.attribute_list['REMARKS'].value=objDataForm.elements['REMARKS'].value;
		objWI_Obj.attribute_list['REMARKS'].modified_flag=true;

        objWI_Obj.attribute_list['CARDNO1'].value=objDataForm.CARDNO1.options[objDataForm.CARDNO1.selectedIndex].value;
		objWI_Obj.attribute_list['CARDNO1'].modified_flag=true;

        objWI_Obj.attribute_list['CARDNO2'].value=objDataForm.CARDNO2.options[objDataForm.CARDNO2.selectedIndex].value;
		objWI_Obj.attribute_list['CARDNO2'].modified_flag=true;
       
	    objWI_Obj.attribute_list['CARDNO3'].value=objDataForm.CARDNO3.options[objDataForm.CARDNO3.selectedIndex].value;
		objWI_Obj.attribute_list['CARDNO3'].modified_flag=true;
		 
	    objWI_Obj.attribute_list['DELIVERTO'].value=objDataForm.DELIVERTO.options[objDataForm.DELIVERTO.selectedIndex].value;
		objWI_Obj.attribute_list['DELIVERTO'].modified_flag=true;

	    objWI_Obj.attribute_list['BRANCHCODE'].value=objDataForm.BRANCHCODE.options[objDataForm.BRANCHCODE.selectedIndex].value;
		objWI_Obj.attribute_list['BRANCHCODE'].modified_flag=true;
       
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