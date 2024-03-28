


function CCB_SaveDone(chkMandatory)
{
	
    var objWI_Obj=window.top.wi_object;
	var objDataForm=window.parent.frames['left'].document.forms["dataform"];
/*

	Product/Project :       Rak Bank
	Module          :       Credit Card Block Request
	File            :       CCB_SaveDone.js
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
				alert("CARDS Decision is Mandatory");
				objDataForm.Cards_Decision.focus();
				return false;
				}
			if(chkMandatory==1 && objDataForm.Cards_Remarks.value!=""){
				if(!space_Check(objDataForm.Cards_Remarks.value)){
					alert("Invalid Data in REMARKS. Only spaces are not allowed");
					objDataForm.Cards_Remarks.focus();
					return false;
				} 
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
			}	 
		
		if(objWI_Obj.workstep_name=="Pending")
		{ 
			if(chkMandatory==0){
/*

	Product/Project :       Rak Bank
	Module          :       Credit Card Blocking Request
	File            :       CCB_SaveDone.js
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/070				   Saurabh Arora
*/
				if (objDataForm.REMARKS.value.length>500)
				{
					alert("Remarks/Reasons can't be greater than 500 Characters");
					objDataForm.REMARKS.focus();
					return false;
				}

			}
		if(chkMandatory==1){

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
			}
			if(objDataForm.VD_Oth.checked==true&&objDataForm.VD_OthSpe.value!="" && !space_Check(objDataForm.VD_OthSpe.value)){
				alert("Invalid Data in Others (Pls. Specify). Only spaces are not allowed");
				objDataForm.VD_OthSpe.focus();
				return false;
			} */
		}
		
		
		if(chkMandatory==1&&objDataForm.REASON_HOTLIST.value==""){
				alert("Reson for hot listing is Mandatory.");
				objDataForm.REASON_HOTLIST.focus();
				return false;
			}
			
			
			if(chkMandatory==1&&(objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value=="Others")&& (objDataForm.HOST_OTHER.value=="")){
				alert("Others(pls) specify is mandatory");
				objDataForm.HOST_OTHER.focus();
				return false;
			}
			if((objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value=="Others")&& 
				(objDataForm.HOST_OTHER.value!="") && (!space_Check(objDataForm.HOST_OTHER.value))){
				alert("Invalid Data in Others (Pls. Specify). Only spaces are not allowed");
				objDataForm.HOST_OTHER.focus();
				return false;
			} 
		
	
	if((objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value=="Lost")||
		(objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value=="Stolen")||
		(objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value=="Captured")||
		(objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value=="Blocked"))
		{
				if(chkMandatory==1&&objDataForm.CB_DateTime.value==""){
					alert("Date and Time  is mandatory");
					objDataForm.CB_DateTime.focus();
					return false;
				}
				else if(!validateDateTime(objDataForm.CB_DateTime.value,objDataForm.sysDate_CCB.value)){
					 objDataForm.CB_DateTime.focus();
					 return false;
		         }
				if(chkMandatory==1&&objDataForm.PLACE.value==""){
					alert("Place  is mandatory");
					objDataForm.PLACE.focus();
					return false;
				}
								
			} 
			if(objDataForm.CB_DateTime.value!=""){
				if(!validateDateTime(objDataForm.CB_DateTime.value,objDataForm.sysDate_CCB.value)){
					 objDataForm.CB_DateTime.focus();
					 return false;
		         }
			}
			if((objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value=="Email From")&& (objDataForm.EMAIL_FROM.value=="")){
				alert("Email from  is  mandatory");
				objDataForm.EMAIL_FROM.focus();
				return false;
			}
			if(objDataForm.EMAIL_FROM.value!=""){
				if(!validateEmail(objDataForm.EMAIL_FROM.value)){
					 alert("Please enter valid email address");
					 objDataForm.EMAIL_FROM.focus();
					 return false;
		         }
			}
			if((objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value=="Wrong Embossing Name")&& (objDataForm.EMBOSING_NAME.value=="")){
				alert("Embossing Name is  mandatory");
				objDataForm.EMBOSING_NAME.focus();
				return false;
			}
			if(objDataForm.EMBOSING_NAME.value!="" && (!CheckDataType(objDataForm.EMBOSING_NAME.value,"character"))){
				alert("Invalid Embossing Name is entered. Only Characters are allowed");
				objDataForm.EMBOSING_NAME.focus();
				return false;
			}
			
			if(chkMandatory==1&&objDataForm.AVAILABLE_BALANCE.value==""){
				alert("Available balance is mandatory");
				objDataForm.AVAILABLE_BALANCE.focus();
				return false;
			}

			else if(!CheckDataType(replaceAll(replaceAll(objDataForm.AVAILABLE_BALANCE.value,",",""),"-",""),"numeric82")){
					alert("Invalid Data in Available balance Only Numerics(10,2) are allowed");
					objDataForm.AVAILABLE_BALANCE.focus();
					return false;
				}
			
			if(chkMandatory==1&&objDataForm.C_STATUS_B_BLOCK.value==""){
				alert("Card status before block is Mandatory");
				objDataForm.C_STATUS_B_BLOCK.focus();
				return false;
			}
			else if(!CheckDataType(objDataForm.C_STATUS_B_BLOCK.value,"Numeric")){
					alert("Invalid Data in Card status before block. Only Numeric are allowed");
					objDataForm.C_STATUS_B_BLOCK.focus();
					return false;
			}
			

			if(objDataForm.C_STATUS_A_BLOCK.value==""){
				alert("Card status after block is Mandatory");
				objDataForm.C_STATUS_A_BLOCK.focus();
				return false;
			}
			else if(!CheckDataType(objDataForm.C_STATUS_A_BLOCK.value,"Numeric")){
					alert("Invalid Data in Card sstatus after block. Only Numeric are allowed");
					objDataForm.C_STATUS_A_BLOCK.focus();
					return false;
			}

			if(objDataForm.ACTION_TAKEN.value==""){
					alert("Action Taken  is  mandatory");
					objDataForm.ACTION_TAKEN.focus();
					return false;
			}
			if((objDataForm.ACTION_TAKEN.options[objDataForm.ACTION_TAKEN.selectedIndex].value=="Issue Replacement")&& (objDataForm.DELIVER_TO.value=="")){
				alert("Deliver to  is  mandatory");
				objDataForm.DELIVER_TO.focus();
				return false;
			}
			if(chkMandatory==1&&(objDataForm.ACTION_TAKEN.options[objDataForm.ACTION_TAKEN.selectedIndex].value=="Others")&& (objDataForm.ACTION_OTHER.value=="")){
				alert("Others (Pls specify) is mandatory");
				objDataForm.ACTION_OTHER.focus();
				return false;
			}
			if((objDataForm.ACTION_TAKEN.options[objDataForm.ACTION_TAKEN.selectedIndex].value=="Others")&& (objDataForm.ACTION_OTHER.value!="") && (!space_Check(objDataForm.ACTION_OTHER.value))){
				alert("Invalid Data in Others (Pls. Specify). Only spaces are not allowed");
				objDataForm.ACTION_OTHER.focus();
				return false;
			}

			if(chkMandatory==1&&(objDataForm.DELIVER_TO.options[objDataForm.DELIVER_TO.selectedIndex].value=="International Address")&& (objDataForm.REMARKS.value=="")){
				alert("Remarks/Reason is mandatory");
				objDataForm.REMARKS.focus();
				return false;
			}
/*

	Product/Project :       Rak Bank
	Module          :       Credit Card Blocking Request
	File            :       CCB_SaveDone.js
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/070				   Saurabh Arora
*/
			if (objDataForm.REMARKS.value.length>500)
			{
				alert("Remarks/Reasons can't be greater than 500 Characters");
				objDataForm.REMARKS.focus();
				return false;
			}
			
			if(objDataForm.DELIVER_TO.options[objDataForm.DELIVER_TO.selectedIndex].value=="Bank")
				{
				if(chkMandatory==1&&objDataForm.BRANCH_NAME.value=="")
					{
				
				//objDataForm.BRANCH_NAME.disabled=false;
				alert("Branch Name is mandatory");
				objDataForm.BRANCH_NAME.focus();
				return false;
				}
			}
			if((objDataForm.REMARKS.value!="") && (!space_Check(objDataForm.REMARKS.value))){
				alert("Invalid Data in REMARKS. Only spaces are not allowed");
				objDataForm.REMARKS.focus();
				return false;
			}
/*

	Product/Project :       Rak Bank
	Module          :       Credit Card Blocking Request
	File            :       CCB_SaveDone.js
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/070				   Saurabh Arora
*/
			if (objDataForm.REMARKS.value.length>500)
			   {
				alert("Remarks/Reasons can't be greater than 500 Characters");
				objDataForm.REMARKS.focus();
				return false;
			   }
		}//
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
		var amount =  objDataForm.AVAILABLE_BALANCE.value;
		objDataForm.AVAILABLE_BALANCE.value = replaceAll(amount,",","")
		objWI_Obj.attribute_list['REASON_HOTLIST'].value=objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value;
		objWI_Obj.attribute_list['REASON_HOTLIST'].modified_flag=true;
		objWI_Obj.attribute_list['ACTION_TAKEN'].value=objDataForm.ACTION_TAKEN.options[objDataForm.ACTION_TAKEN.selectedIndex].value;
		objWI_Obj.attribute_list['ACTION_TAKEN'].modified_flag=true;
		objWI_Obj.attribute_list['DELIVER_TO'].value=objDataForm.DELIVER_TO.options[objDataForm.DELIVER_TO.selectedIndex].value;
		objWI_Obj.attribute_list['DELIVER_TO'].modified_flag=true;
		objWI_Obj.attribute_list['BRANCH_NAME'].value=objDataForm.BRANCH_NAME.options[objDataForm.BRANCH_NAME.selectedIndex].value;
		objWI_Obj.attribute_list['BRANCH_NAME'].modified_flag=true;
		objWI_Obj.attribute_list['REMARKS'].value=objDataForm.REMARKS.value;
		objWI_Obj.attribute_list['REMARKS'].modified_flag=true;
		
		return true;
	}
	if(objWI_Obj.workstep_name=="Branch_Return")
			{ 
			if(chkMandatory==0){
/*

	Product/Project :       Rak Bank
	Module          :       Credit Card Blocking Request
	File            :       CCB_SaveDone.js
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/070				   Saurabh Arora
*/
				if (objDataForm.REMARKS.value.length>500)
					{
						alert("Remarks/Reasons can't be greater than 500 Characters");
						objDataForm.REMARKS.focus();
						return false;
					}

			}
	if(chkMandatory==1){
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
		}
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
			}
			if(objDataForm.VD_Oth.checked==true&&objDataForm.VD_OthSpe.value!="" && !space_Check(objDataForm.VD_OthSpe.value)){
				alert("Invalid Data in Others (Pls. Specify). Only spaces are not allowed");
				objDataForm.VD_OthSpe.focus();
				return false;
			}*/
		}
		
		 
		if(chkMandatory==1&&objDataForm.REASON_HOTLIST.value==""){
				alert("Reson for hot listing is Mandatory.");
				objDataForm.REASON_HOTLIST.focus();
				return false;
			}
			
			
			if(chkMandatory==1&&(objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value=="Others")&& (objDataForm.HOST_OTHER.value=="")){
				alert("Others(pls) specify is mandatory");
				objDataForm.HOST_OTHER.focus();
				return false;
			}
		
			if((objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value=="Others")&& 				(objDataForm.HOST_OTHER.value!="") && (!space_Check(objDataForm.HOST_OTHER.value))){
				alert("Invalid Data in Others (Pls. Specify). Only spaces are not allowed");
				objDataForm.HOST_OTHER.focus();
				return false;
			} 
	if((objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value=="Lost")||
		(objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value=="Stolen")||
		(objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value=="Captured")||
		(objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value=="Blocked"))
		{
				if(chkMandatory==1&&objDataForm.CB_DateTime.value==""){
					alert("Date and Time  is mandatory");
					objDataForm.CB_DateTime.focus();
					return false;
				}
				else if(!validateDateTime(objDataForm.CB_DateTime.value,objDataForm.sysDate_CCB.value)){
					 objDataForm.CB_DateTime.focus();
					 return false;
		         }
				if(chkMandatory==1&&objDataForm.PLACE.value==""){
					alert("Place  is mandatory");
					objDataForm.PLACE.focus();
					return false;
				}
								
			} 
			if(objDataForm.CB_DateTime.value!=""){
				if(!validateDateTime(objDataForm.CB_DateTime.value,objDataForm.sysDate_CCB.value)){
					 objDataForm.CB_DateTime.focus();
					 return false;
		         }
			}
			if((objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value=="Email From")&& (objDataForm.EMAIL_FROM.value=="")){
				alert("Email from  is  mandatory");
				objDataForm.EMAIL_FROM.focus();
				return false;
			}
			if(objDataForm.EMAIL_FROM.value!=""){
				if(!validateEmail(objDataForm.EMAIL_FROM.value)){
					 alert("Please enter valid email address");
					 objDataForm.EMAIL_FROM.focus();
					 return false;
		         }
			}
			if((objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value=="Wrong Embossing Name")&& (objDataForm.EMBOSING_NAME.value=="")){
				alert("Embossing Name is  mandatory");
				objDataForm.EMBOSING_NAME.focus();
				return false;
			}
			if(objDataForm.EMBOSING_NAME.value!="" && (!CheckDataType(objDataForm.EMBOSING_NAME.value,"character"))){
				alert("Invalid Embossing Name is entered. Only Characters are allowed");
				objDataForm.EMBOSING_NAME.focus();
				return false;
			}
			if(chkMandatory==1&&objDataForm.AVAILABLE_BALANCE.value==""){
				alert("Available balance is mandatory....");
				objDataForm.AVAILABLE_BALANCE.focus();
				return false;
			}

			else if(!CheckDataType(replaceAll(replaceAll(objDataForm.AVAILABLE_BALANCE.value,",",""),"-",""),"numeric82")){
					alert("Invalid Data in Available balance Only Numerics(10,2) are allowed");
					objDataForm.AVAILABLE_BALANCE.focus();
					return false;
				}
			
			if(objDataForm.C_STATUS_B_BLOCK.value==""){
				alert("Card status before block is Mandatory");
				objDataForm.C_STATUS_B_BLOCK.focus();
				return false;
			}
			else if(!CheckDataType(objDataForm.C_STATUS_B_BLOCK.value,"Numeric")){
					alert("Invalid Data in Card status before block. Only Numeric are allowed");
					objDataForm.C_STATUS_B_BLOCK.focus();
					return false;
			}
			

			if(objDataForm.C_STATUS_A_BLOCK.value==""){
				alert("Card status after block is Mandatory");
				objDataForm.C_STATUS_A_BLOCK.focus();
				return false;
			}
			else if(!CheckDataType(objDataForm.C_STATUS_A_BLOCK.value,"Numeric")){
					alert("Invalid Data in Card status after block. Only Numeric are allowed");
					objDataForm.C_STATUS_A_BLOCK.focus();
					return false;
			}
			
/*
	Product/Project :       Rak Bank
	Module          :       Credit Card Blocking Request
	File            :       CCB_SaveDone.js
	Purpose         :       Approval code should be mandated to 6 digits. It is currently accepting 5 digits
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/008					03/09/2008	 Saurabh Arora
*/

			if(chkMandatory==1)
			{
				if (objDataForm.C_STATUS_A_BLOCK.value==objDataForm.C_STATUS_B_BLOCK.value)
				{
					alert("Card status before block and Card status after block cannot be same");
					objDataForm.C_STATUS_B_BLOCK.focus();
					return false;
				}
				if (objDataForm.C_STATUS_A_BLOCK.value=="00")
				{
					alert("Card status After Block cannot be 00");
					objDataForm.C_STATUS_A_BLOCK.focus();
					return false;
				}
			}				
			
			
			if(objDataForm.ACTION_TAKEN.value==""){
					alert("Action Taken  is  mandatory");
					objDataForm.ACTION_TAKEN.focus();
					return false;
			}
			if((objDataForm.ACTION_TAKEN.options[objDataForm.ACTION_TAKEN.selectedIndex].value=="Issue Replacement")&& (objDataForm.DELIVER_TO.value=="")){
				alert("Deliver to  is  mandatory");
				objDataForm.DELIVER_TO.focus();
				return false;
			}
			if(chkMandatory==1&&(objDataForm.ACTION_TAKEN.options[objDataForm.ACTION_TAKEN.selectedIndex].value=="Others")&& (objDataForm.ACTION_OTHER.value=="")){
				alert("Others (Pls specify) is mandatory");
				objDataForm.ACTION_OTHER.focus();
				return false;
			}
			if((objDataForm.ACTION_TAKEN.options[objDataForm.ACTION_TAKEN.selectedIndex].value=="Others")&& (objDataForm.ACTION_OTHER.value!="") && (!space_Check(objDataForm.ACTION_OTHER.value))){
				alert("Invalid Data in Others (Pls. Specify). Only spaces are not allowed");
				objDataForm.ACTION_OTHER.focus();
				return false;
			}

			if((objDataForm.DELIVER_TO.options[objDataForm.DELIVER_TO.selectedIndex].value=="International Address")&& (objDataForm.REMARKS.value=="")){
				alert("Remarks/Reason is  mandatory.");
				objDataForm.REMARKS.focus();
				return false;
			}
/*

	Product/Project :       Rak Bank
	Module          :       Credit Card Blocking Request
	File            :       CCB_SaveDone.js
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/070				   Saurabh Arora
*/
			if (objDataForm.REMARKS.value.length>500)
			   {
				alert("Remarks/Reasons can't be greater than 500 Characters");
				objDataForm.REMARKS.focus();
				return false;
			   }
			if(objDataForm.DELIVER_TO.options[objDataForm.DELIVER_TO.selectedIndex].value=="Bank")
				{
				if(objDataForm.BRANCH_NAME.value=="")
					{
				
				//objDataForm.BRANCH_NAME.disabled=false;
				alert("Branch Name is  mandatory");
				objDataForm.BRANCH_NAME.focus();
				return false;
				}
			}
			if((objDataForm.REMARKS.value!="") && (!space_Check(objDataForm.REMARKS.value))){
				alert("Invalid Data in REMARKS. Only spaces are not allowed");
				objDataForm.REMARKS.focus();
				return false;
			}
/*

	Product/Project :       Rak Bank
	Module          :       Credit Card Blocking Request
	File            :       CCB_SaveDone.js
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/070				   Saurabh Arora
*/
			if (objDataForm.REMARKS.value.length>500)
			   {
				alert("Remarks/Reasons can't be greater than 500 Characters");
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
		var amount =  objDataForm.AVAILABLE_BALANCE.value;
		objDataForm.AVAILABLE_BALANCE.value = replaceAll(amount,",","")
		objWI_Obj.attribute_list['REASON_HOTLIST'].value=objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value;
		objWI_Obj.attribute_list['REASON_HOTLIST'].modified_flag=true;
		objWI_Obj.attribute_list['ACTION_TAKEN'].value=objDataForm.ACTION_TAKEN.options[objDataForm.ACTION_TAKEN.selectedIndex].value;
		objWI_Obj.attribute_list['ACTION_TAKEN'].modified_flag=true;
		objWI_Obj.attribute_list['DELIVER_TO'].value=objDataForm.DELIVER_TO.options[objDataForm.DELIVER_TO.selectedIndex].value;
		objWI_Obj.attribute_list['DELIVER_TO'].modified_flag=true;
		objWI_Obj.attribute_list['BRANCH_NAME'].value=objDataForm.BRANCH_NAME.options[objDataForm.BRANCH_NAME.selectedIndex].value;
		objWI_Obj.attribute_list['BRANCH_NAME'].modified_flag=true;
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
		case "name":
			regex=/^[a-z,\'_. &]*$/i;
			break;
	}
	return regex.test(cntrlValue);
}

function validateEmail(str) {
		var at="@"
		var dot="."
		var lat=str.indexOf(at)
		var lstr=str.length
		var ldot=str.indexOf(dot)
		if (str.indexOf(at)==-1){
		    return false
		}
		for(i=0;i<lstr-1;i++){
			if(str.charAt(i)=='.' && str.charAt(i+1)=='.' ){
				return false;
			}
			if(str.charAt(i)=='@' && str.charAt(i+1)=='@' ){
				return false;
			}
		}
		if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr){
		  return false
		}

		if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr || str.lastIndexOf(dot)==lstr-1){
		  return false
		}

		 if (str.indexOf(at,(lat+1))!=-1){
		   return false
		 }

		 if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
		    return false
		 }

		 if (str.indexOf(dot,(lat+2))==-1){
		   return false
		 }
		
		 if (str.indexOf(" ")!=-1){
		   return false
		 }

 		 return true					
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

function validateDateTime(datetime,sysDate)
{
	
var objWI_Obj=window.top.wi_object;

var enteredDateTime = datetime;
SpaceAt = enteredDateTime.indexOf(" ");
colunAt = enteredDateTime.indexOf(":");
var userDate=enteredDateTime.substring(0,enteredDateTime.indexOf(" "));
var enteredTime=enteredDateTime.substring(enteredDateTime.indexOf(" ")+1,enteredDateTime.length);
if(!RAKisDate(userDate,"Date & Time of L/S/C")){
	return false;
} else if(SpaceAt!="10" || eval(enteredDateTime.indexOf(" "))!=eval(enteredDateTime.lastIndexOf(" "))){
	alert("Invalid date time entered in Date & Time of L/S/C. format should be DD/MM/YYYY hh:mm(24 Hour)");
	return false;
} else if(colunAt!="13" || enteredDateTime.indexOf(":")!=enteredDateTime.lastIndexOf(":")){
	alert("Invalid date time entered in Date & Time of L/S/C. format should be DD/MM/YYYY hh:mm(24 Hour)");
	return false;
} 
var enteredHH=enteredTime.substring(0,enteredTime.indexOf(":"));
var enteredMM = enteredTime.substring(enteredTime.indexOf(":")+1,enteredTime.length);
if(eval(enteredHH)>23){  
	alert("Invalid value of Hour in Date & Time of L/S/C. Hours can not be more than 23");
	return false;
} else if(eval(enteredMM)>59){
	alert("Invalid value of minute in Date & Time of L/S/C. minutes can not be more than 59");
	return false;
}
var enteredDate = userDate.substring(0,2);
var enteredMonth = userDate.substring(3,5);
var enteredYear = userDate.substring(6,userDate.length);
var todayDate = new Date(sysDate);
var dd = todayDate.getDate();
var mm = todayDate.getMonth()+1;
var yy =todayDate.getYear();
var currentHours = todayDate.getHours();
var currentMinutes = todayDate.getMinutes();

if(eval(enteredYear)>eval(yy))
{
	alert("Date in Date & Time of L/S/C field can not be a future date");
	return false;
}
else if(eval(enteredYear)==eval(yy))
{
	if (eval(enteredMonth)>eval(mm))
	{
		alert("Date in Date & Time of L/S/C field can not be a future date");
		return false;
	}
	else if (eval(enteredMonth)==eval(mm))
	{
		if(eval(enteredDate)>eval(dd))
		{
			alert("Date in Date & Time of L/S/C field can not be a future date");
			return false;
		}
		else if (eval(enteredDate)==eval(dd))
		{
			if (eval(enteredHH)>eval(currentHours))
			{
				alert("Date in Date & Time of L/S/C field can not be a future date");
				return false;
			}
			else if (eval(enteredHH)==eval(currentHours))
			{
				if (eval(enteredMM)>eval(currentMinutes))
				{
					alert("Date in Date & Time of L/S/C field can not be a future date");
					return false;				
				}
			}
		}
	}
}

return true;
}
