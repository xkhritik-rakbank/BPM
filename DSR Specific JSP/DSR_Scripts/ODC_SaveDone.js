function ODC_SaveDone(chkMandatory)
{
	 var objWI_Obj=window.top.wi_object;
	 var objDataForm=window.parent.frames['left'].document.forms["dataform"];

		if(objWI_Obj.workstep_name=="Pending")
		{
			objWI_Obj.attribute_list['Pending_Decision'].value=objDataForm.Pending_Decision.options[objDataForm.Pending_Decision.selectedIndex].value;
			objWI_Obj.attribute_list['Pending_Decision'].modified_flag=true;
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
/*
		if	(objDataForm.VD_PassNo.checked)
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
		if(objWI_Obj.workstep_name=="CARDS")
			{

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
			return true;
			}	 
		if(objWI_Obj.workstep_name.toUpperCase()=="BRANCH_RETURN")
			{	
			//alert("1 ")
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
		
			if(chkMandatory==1&&objDataForm.BR_Decision.options[objDataForm.BR_Decision.selectedIndex].value=="")
				{
				alert("Branch Return Decision is Mandatory");
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
		
		
		
		if(chkMandatory==1&&objDataForm.DCI_ExtNo.value==""){
			alert("Ext No. is Mandatory");
			objDataForm.DCI_ExtNo.focus();
			return false;
		}else if(!CheckDataType(objDataForm.DCI_ExtNo.value,"Numeric")){
			alert("Invalid Data in Ext No. Only Numeric are allowed");
			objDataForm.DCI_ExtNo.focus();
			return false;
		}else if(chkMandatory==1&&objDataForm.DCI_ExtNo.value.length < 4){
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
			alert("Please select at least 4 Random questions");
			objDataForm.VD_POBox.focus();
			
			return false;
			}
			
		}

		
		
		var srequest_type=objDataForm.request_type.value;
				
			if(srequest_type=="")
			{
			alert("Process Name is Mandatory");
			objDataForm.request_type.focus();
			return false;
			}
			if(srequest_type=="Re-Issue of PIN")
			{	
				if(chkMandatory==1&&objDataForm.oth_rip_reason.options[objDataForm.oth_rip_reason.selectedIndex].value=="")
				{					
					alert("Reason is Mandatory");
					objDataForm.oth_rip_reason.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.oth_rip_DC.options[objDataForm.oth_rip_DC.selectedIndex].value=="")
				{					
					alert("Delivery Channel is Mandatory");
					objDataForm.oth_rip_DC.focus();
					return false;
				}				if(chkMandatory==1&&objDataForm.oth_rip_DC.options[objDataForm.oth_rip_DC.selectedIndex].value.toUpperCase()=="BRANCH"&&objDataForm.oth_rip_BN.options[objDataForm.oth_rip_BN.selectedIndex].value=="")
				{					
					alert("Branch Name is Mandatory");
					objDataForm.oth_rip_BN.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.oth_rip_BN.options[objDataForm.oth_rip_BN.selectedIndex].text.toUpperCase()=="OTHERS"&&objDataForm.oth_rip_RR.value=="")
				{					
					alert("Remarks/Reasons is Mandatory");
					objDataForm.oth_rip_RR.focus();
					return false;
				}

				if(objDataForm.oth_rip_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					objDataForm.oth_rip_RR.focus();
					return false;
				}
			}
			if(srequest_type=="Card Replacement")
			{	
				if(chkMandatory==1&&objDataForm.oth_cr_reason.options[objDataForm.oth_cr_reason.selectedIndex].value=="")
				{					
					alert("Reason is Mandatory");
					objDataForm.oth_cr_reason.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.oth_cr_reason.options[objDataForm.oth_cr_reason.selectedIndex].text.toUpperCase()=="OTHERS"&&objDataForm.oth_cr_OPS.value=="")
				{					
					alert("Others Pls Specify is Mandatory");
					objDataForm.oth_cr_OPS.focus();
					return false;
				}	
				if(chkMandatory==1&&objDataForm.oth_cr_DC.options[objDataForm.oth_cr_DC.selectedIndex].value.toUpperCase()=="")
				{					
					alert("Delivery Channel is Mandatory");
					objDataForm.oth_cr_DC.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.oth_cr_DC.options[objDataForm.oth_cr_DC.selectedIndex].value.toUpperCase()=="BRANCH"&&objDataForm.oth_cr_BN.options[objDataForm.oth_cr_BN.selectedIndex].value=="")
				{					
					alert("Branch Name is Mandatory");
					objDataForm.oth_cr_BN.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.oth_cr_BN.options[objDataForm.oth_cr_BN.selectedIndex].text.toUpperCase()=="OTHERS"&&objDataForm.oth_cr_RR.value=="")
				{					
					alert("Remarks/Reasons is Mandatory");
					objDataForm.oth_cr_RR.focus();
					return false;
				}


/*	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       ODC_SaveDone.jsp
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/073				   Saurabh Arora
*/
				if(objDataForm.oth_cr_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					objDataForm.oth_cr_RR.focus();
					return false;
				}
			}
			/*if(srequest_type=="Credit Limit Increase")
			{	
				if(chkMandatory==1&&objDataForm.oth_cli_type.options[objDataForm.oth_cli_type.selectedIndex].value=="")
				{					
					alert("Type is Mandatory");
					objDataForm.oth_cli_type.focus();
					return false;
				}	if(chkMandatory==1&&objDataForm.oth_cli_type.options[objDataForm.oth_cli_type.selectedIndex].value.toUpperCase()=="TEMPORARY"&&objDataForm.oth_cli_months.value=="")
				{					
					alert("Months is Mandatory");
					objDataForm.oth_cli_months.focus();
					return false;
				}
				if(objDataForm.oth_cli_months.value!=""&&!CheckDataType(objDataForm.oth_cli_months.value,"month"))
				{					
					alert("Invalid data in Months Only 0,1,2,3 are allowed. ");
					objDataForm.oth_cli_months.focus();
					return false;
				}	
				
				if(objDataForm.oth_cli_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					objDataForm.oth_cli_RR.focus();
					return false;
				}
			}*/
			if(srequest_type=="Early Card Renewal")
			{	
				

				if(chkMandatory==1&&objDataForm.oth_ecr_RB.value=="")
				{					
					alert("Required by is Mandatory");
					objDataForm.oth_ecr_RB.focus();
					return false;
				}	
				
				if(objDataForm.oth_ecr_RB.value!="")
				{
					var month1=objDataForm.DCI_ExpD.value.substring(0,2);
					var year1=objDataForm.DCI_ExpD.value.substring(3,5);

					var month2=objDataForm.oth_ecr_RB.value.substring(0,2);
					var year2=objDataForm.oth_ecr_RB.value.substring(3,5);

					var dt1=new Date("20"+year1,parseInt(month1)-1);
					var dt2=new Date("20"+year2,parseInt(month2)-1);
					if(dt2>dt1)
					{
						alert("Required By can't be greater than expiry date");
						objDataForm.oth_ecr_RB.focus();
						return false;
					}
				}
				
				if(objDataForm.oth_ecr_RB.value!=""&&!checkMonthDiff())
				{					
					alert("Required by can't be greater than Expiry Date By 3 Months ");
					objDataForm.oth_ecr_RB.focus();
					return false;
				}

				if(chkMandatory==1&&objDataForm.oth_ecr_dt.value=="")
				{
					alert("Deliver To is mandatory");
					objDataForm.oth_ecr_dt.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.oth_ecr_dt.value=="Bank")
				{
					if(objDataForm.oth_ecr_bn.value=="")
					{
						alert("Branch Name is mandatory");
						objDataForm.oth_ecr_bn.focus();
						return false;				
					}
				}
				if(chkMandatory==1&&objDataForm.oth_ecr_RR.value.length=="")
				{					
					alert("Remarks/Reasons is Mandatory");
					objDataForm.oth_ecr_RR.focus();
					return false;
				}

				if(objDataForm.oth_ecr_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					objDataForm.oth_ecr_RR.focus();
					return false;
				}
			}
			/*if(srequest_type=="Change in Standing Instructions")
			{	

				
				if(chkMandatory==1 && objDataForm.oth_csi_PH.checked==false && objDataForm.oth_csi_CSIP.checked==false && objDataForm.oth_csi_CSID.checked==false && objDataForm.oth_csi_CDACNo.checked==false)
				{
					alert("At least one Instruction should be checked/selected.");
					return false;
				}
				if(chkMandatory==1&&objDataForm.oth_csi_PH.checked==true&&objDataForm.oth_csi_TOH.value=="")
				{					
					alert("Type of Hold is Mandatory");
					objDataForm.oth_csi_TOH.focus();
					return false;
				}	
			if(chkMandatory==1&&objDataForm.oth_csi_TOH.value.toUpperCase()=="TEMPORARY"&&objDataForm.oth_csi_NOM.value=="")
				{					
					alert("Months is Mandatory");
					objDataForm.oth_csi_NOM.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.oth_csi_CSIP.checked==true&&objDataForm.oth_csi_POSTMTB.value=="")
				{					
					alert("% Of STMT Balance is Mandatory.");
					objDataForm.oth_csi_POSTMTB.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.oth_csi_CSIP.checked==true&&!(parseInt(objDataForm.oth_csi_POSTMTB.value)>2&&parseInt(objDataForm.oth_csi_POSTMTB.value)<101))
				{					
					alert("% Of STMT Balance should be between 3 and 100 both inclusive.");
					objDataForm.oth_csi_POSTMTB.focus();
					return false;
				}
				
				if(chkMandatory==1&&objDataForm.oth_csi_CSID.checked==true&&objDataForm.oth_csi_ND.value=="")
				{					
					alert("New date is Mandatory.");
					objDataForm.oth_csi_ND.focus();
					return false;
				}
				if(objDataForm.oth_csi_CSID.checked==true&&!CheckDataType(objDataForm.oth_csi_ND.value,"Numeric"))
				{					
					alert("New date Should be Numeric"); 
					objDataForm.oth_csi_ND.focus();
					return false;
				}
				
				if(objDataForm.oth_csi_CSID.checked==true&&parseInt(objDataForm.oth_csi_ND.value)>31)
				{					
					alert("New date can't be greater than 31"); 
					objDataForm.oth_csi_ND.focus();
					return false;
				}
				if(objDataForm.oth_csi_CSID.checked==true&&parseInt(objDataForm.oth_csi_ND.value)==0)
				{					
					alert("New date can't be zero"); 
					objDataForm.oth_csi_ND.focus();
					return false;
				}
				
				
				if(chkMandatory==1&&objDataForm.oth_csi_CDACNo.checked==true&&objDataForm.oth_csi_AccNo.value=="")
				{					
					alert("Account No. is Mandatory");
					objDataForm.oth_csi_AccNo.focus();
					return false;
				}
				if(objDataForm.oth_csi_CDACNo.checked==true&&!CheckDataType(objDataForm.oth_csi_AccNo.value,"Numeric"))
				{					
					alert("Only Numerics are allowed in Account No.");
					objDataForm.oth_csi_AccNo.focus();
					return false;
				}	
				if(chkMandatory==1&&objDataForm.oth_csi_CDACNo.checked==true&&objDataForm.oth_csi_AccNo.value.length<13)
				{					
					alert("Account No. Should be of length 13");
					objDataForm.oth_csi_AccNo.focus();
					return false;
				}
				if(objDataForm.oth_csi_CDACNo.checked==true&&parseInt(objDataForm.oth_csi_AccNo.value)==0)
				{					
					alert("Account No. can't be Zero");
					objDataForm.oth_csi_AccNo.value="";
					objDataForm.oth_csi_AccNo.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.oth_csi_TOH.value.toUpperCase()=="TEMPORARY"&&objDataForm.oth_csi_RR.value.length=="")
				{					
					alert("Remarks/Reasons is Mandatory");
					objDataForm.oth_csi_RR.focus();
					return false;
				}

				if(objDataForm.oth_csi_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					objDataForm.oth_csi_RR.focus();
					return false;
				}
			}*/
			if(srequest_type=="Transaction Dispute")
			{	
				if(chkMandatory==1&&objDataForm.oth_td_RNO.value=="")
				{					
					alert("Reference No. is Mandatory");
					objDataForm.oth_td_RNO.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.oth_td_RNO.value.length<10)
				{					
					alert("Reference No. Should of length 10");
					objDataForm.oth_td_RNO.focus();
					return false;
				}
				if(!CheckDataType(objDataForm.oth_td_RNO.value,"Numeric"))
				{					
					alert("Only Numerics are allowed in Reference No.");
					objDataForm.oth_td_RNO.focus();
					return false;
				}				
				if(chkMandatory==1&&objDataForm.oth_td_Amount.value=="")
				{					
					alert("Amount is Mandatory");
					objDataForm.oth_td_Amount.focus();
					return false;
				}	
				if(!CheckDataType(replaceAll(objDataForm.oth_td_Amount.value,",",""),"numeric82"))
				{					
					alert("Only Numerics(10,2) are allowed in Amount");
					objDataForm.oth_td_Amount.focus();
					return false;
				}					

				if(objDataForm.oth_td_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					objDataForm.oth_td_RR.focus();
					return false;
				}
			}
			/*if(srequest_type=="Card Upgrade")
			{					
				if(chkMandatory==1&&objDataForm.oth_cu_RR.value.length=="")
				{					
					alert("Remarks/Reasons is Mandatory");
					objDataForm.oth_cu_RR.focus();
					return false;
				}

				if(objDataForm.oth_cu_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					objDataForm.oth_cu_RR.focus();
					return false;
				}
			}*/
			/*if(srequest_type=="Setup Suppl. Card Limit")
			{	
				if(chkMandatory==1&&objDataForm.oth_ssc_Amount.value.length=="")
				{					
					alert("Amount is Mandatory");
					objDataForm.oth_ssc_Amount.focus();
					return false;
				}
				if(!CheckDataType(replaceAll(objDataForm.oth_ssc_Amount.value,",",""),"numeric82"))
				{					
					alert("Only Numerics(10,2) are allowed in Amount");
					objDataForm.oth_ssc_Amount.focus();
					return false;
				}

				if (chkMandatory==1&&objDataForm.oth_ssc_Amount.value<500)
				{
					alert("Value in amount field cannot be less than 500");
					objDataForm.oth_ssc_Amount.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.oth_ssc_SCNo.options[objDataForm.oth_ssc_SCNo.selectedIndex].value=="")
				{					
					alert("Suplementary Card No. is Mandatory");
					objDataForm.oth_ssc_SCNo.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.oth_ssc_RR.value.length=="")
				{					
					alert("Remarks/Reasons is Mandatory");
					objDataForm.oth_ssc_RR.focus();
					return false;
				}

				if(objDataForm.oth_ssc_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					objDataForm.oth_ssc_RR.focus();
					return false;
				}
			}*/
			if(srequest_type=="Card Delivery Request")
			{	
				if(chkMandatory==1&&objDataForm.oth_cdr_CDT.options[objDataForm.oth_cdr_CDT.selectedIndex].value=="")
				{					
					alert("Card Delivery To is Mandatory");
					objDataForm.oth_cdr_CDT.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.oth_cdr_CDT.options[objDataForm.oth_cdr_CDT.selectedIndex].value.toUpperCase()=="BANK"&&objDataForm.oth_cdr_BN.options[objDataForm.oth_cdr_BN.selectedIndex].value=="")
				{					
					alert("Branch Name is Mandatory");
					objDataForm.oth_cdr_BN.focus();
					return false;
				}
				
				if(chkMandatory==1&&objDataForm.oth_cdr_RR.value.length==""&&objDataForm.oth_cdr_BN.options[objDataForm.oth_cdr_BN.selectedIndex].text.toUpperCase()=="OTHERS PLS. SPECIFY")
				{					
					alert("Remarks/Reasons is Mandatory");
					objDataForm.oth_cdr_RR.focus();
					return false;
				}

				if(objDataForm.oth_cdr_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					objDataForm.oth_cdr_RR.focus();
					return false;
				}
			}
			/*if(srequest_type=="Credit Shield")
			{	
				if(chkMandatory==1&&objDataForm.oth_cs_CS.options[objDataForm.oth_cs_CS.selectedIndex].value=="")
				{					
					alert("Credit Shield is Mandatory");
					objDataForm.oth_cs_CS.focus();
					return false;
				}
				if(chkMandatory==1&&objDataForm.oth_cs_CSR.checked==true&&objDataForm.oth_cs_Amount.value=="")
				{					
					alert("Amount is Mandatory");
					objDataForm.oth_cs_Amount.focus();
					return false;
				}

				if(objDataForm.oth_cs_CSR.checked==true&&!CheckDataType(replaceAll(objDataForm.oth_cs_Amount.value,",",""),"numeric82"))
				{					
					alert("Only Numerics(10,2) are allowed in Amount");
					objDataForm.oth_cs_Amount.focus();
					return false;
				}					
				if(chkMandatory==1&&objDataForm.oth_cs_RR.value.length==""&&objDataForm.oth_cs_CS.options[objDataForm.oth_cs_CS.selectedIndex].value.toUpperCase()=="UN-ENROLLEMENT")
				{					
					alert("Remarks/Reasons is Mandatory");
					objDataForm.oth_cs_RR.focus();
					return false;
				}

				if(objDataForm.oth_cs_RR.value.length>500)
				{					
					alert("Remarks/Reasons can't be greater than 500 Characters");
					objDataForm.oth_cs_RR.focus();
					return false;
				}
			}*/
	
		
			
		if(objDataForm.request_type.value=="Re-Issue of PIN")
		{
			objWI_Obj.attribute_list['oth_rip_DC'].value=objDataForm.oth_rip_DC.options[objDataForm.oth_rip_DC.selectedIndex].value;
			objWI_Obj.attribute_list['oth_rip_DC'].modified_flag=true;
			objWI_Obj.attribute_list['oth_rip_BN'].value=objDataForm.oth_rip_BN.options[objDataForm.oth_rip_BN.selectedIndex].value;
			objWI_Obj.attribute_list['oth_rip_BN'].modified_flag=true;
			objWI_Obj.attribute_list['oth_rip_RR'].value=objDataForm.oth_rip_RR.value;
			objWI_Obj.attribute_list['oth_rip_RR'].modified_flag=true;
		}
		/*else if(objDataForm.request_type.value=="Credit Limit Increase")
		{
			objWI_Obj.attribute_list['oth_cli_type'].value=objDataForm.oth_cli_type.options[objDataForm.oth_cli_type.selectedIndex].value;
			objWI_Obj.attribute_list['oth_cli_type'].modified_flag=true;
			objWI_Obj.attribute_list['oth_cli_RR'].value=objDataForm.oth_cli_RR.value;
			objWI_Obj.attribute_list['oth_cli_RR'].modified_flag=true;
		}*/
		/*else if(objDataForm.request_type.value=="Change in Standing Instructions")
		{
			if(objDataForm.oth_csi_PH.checked==true)
			{
				objWI_Obj.attribute_list['oth_csi_PH'].value="Y";
				objWI_Obj.attribute_list['oth_csi_PH'].modified_flag=true;
			}
			else
			{
				objWI_Obj.attribute_list['oth_csi_PH'].value="N";
				objWI_Obj.attribute_list['oth_csi_PH'].modified_flag=true;
			}
			objWI_Obj.attribute_list['oth_csi_TOH'].value=objDataForm.oth_csi_TOH.options[objDataForm.oth_csi_TOH.selectedIndex].value;
			objWI_Obj.attribute_list['oth_csi_TOH'].modified_flag=true;
			objWI_Obj.attribute_list['oth_csi_NOM'].value=objDataForm.oth_csi_NOM.options[objDataForm.oth_csi_NOM.selectedIndex].value;
			objWI_Obj.attribute_list['oth_csi_NOM'].modified_flag=true;
			if(objDataForm.oth_csi_CSIP.checked==true)
			{
				objWI_Obj.attribute_list['oth_csi_CSIP'].value="Y";
				objWI_Obj.attribute_list['oth_csi_CSIP'].modified_flag=true;
			}
			else
			{
				
				objWI_Obj.attribute_list['oth_csi_CSIP'].value="N";
				objWI_Obj.attribute_list['oth_csi_CSIP'].modified_flag=true;
			}
			if(objDataForm.oth_csi_CSID.checked==true)
			{
				objWI_Obj.attribute_list['oth_csi_CSID'].value="Y";
				objWI_Obj.attribute_list['oth_csi_CSID'].modified_flag=true;
			}
			else
			{
				objWI_Obj.attribute_list['oth_csi_CSID'].value="N";
				objWI_Obj.attribute_list['oth_csi_CSID'].modified_flag=true;
			}
			if(objDataForm.oth_csi_CDACNo.checked==true)
			{
				objWI_Obj.attribute_list['oth_csi_CDACNo'].value="Y";
				objWI_Obj.attribute_list['oth_csi_CDACNo'].modified_flag=true;
			}
			else
			{
				objWI_Obj.attribute_list['oth_csi_CDACNo'].value="N";
				objWI_Obj.attribute_list['oth_csi_CDACNo'].modified_flag=true;
			}

			objWI_Obj.attribute_list['oth_csi_RR'].value=objDataForm.oth_csi_RR.value;
			objWI_Obj.attribute_list['oth_csi_RR'].modified_flag=true;
		}*/
		else if(objDataForm.request_type.value=="Card Delivery Request")
		{			
			objWI_Obj.attribute_list['oth_cdr_CDT'].value=objDataForm.oth_cdr_CDT.options[objDataForm.oth_cdr_CDT.selectedIndex].value;
			objWI_Obj.attribute_list['oth_cdr_CDT'].modified_flag=true;
			objWI_Obj.attribute_list['oth_cdr_BN'].value=objDataForm.oth_cdr_BN.options[objDataForm.oth_cdr_BN.selectedIndex].value;
			objWI_Obj.attribute_list['oth_cdr_BN'].modified_flag=true;
			objWI_Obj.attribute_list['oth_cdr_RR'].value=objDataForm.oth_cdr_RR.value;
			objWI_Obj.attribute_list['oth_cdr_RR'].modified_flag=true;
		}
		/*else if(objDataForm.request_type.value=="Credit Shield")
		{
			objWI_Obj.attribute_list['oth_cs_CS'].value=objDataForm.oth_cs_CS.options[objDataForm.oth_cs_CS.selectedIndex].value;
			objWI_Obj.attribute_list['oth_cs_CS'].modified_flag=true;			
			if(objDataForm.oth_cs_CSR.checked==true)
			{
				objWI_Obj.attribute_list['oth_cs_CSR'].value="Y";
				objWI_Obj.attribute_list['oth_cs_CSR'].modified_flag=true;
			}
			else 
			{
				objWI_Obj.attribute_list['oth_cs_CSR'].value="N";
				objWI_Obj.attribute_list['oth_cs_CSR'].modified_flag=true;
			}
			objWI_Obj.attribute_list['oth_cs_RR'].value=objDataForm.oth_cs_RR.value;
			objWI_Obj.attribute_list['oth_cs_RR'].modified_flag=true;
		}*/
		/*else if(objDataForm.request_type.value=="Setup Suppl. Card Limit")
		{
			
			objWI_Obj.attribute_list['oth_ssc_RR'].value=objDataForm.oth_ssc_RR.value;
			objWI_Obj.attribute_list['oth_ssc_RR'].modified_flag=true;
			objWI_Obj.attribute_list['oth_ssc_SCNo'].value=objDataForm.oth_ssc_SCNo.options[objDataForm.oth_ssc_SCNo.selectedIndex].value;
			objWI_Obj.attribute_list['oth_ssc_SCNo'].modified_flag=true;		
		}*/		
		else if(objDataForm.request_type.value=="Transaction Dispute")
		{
			objWI_Obj.attribute_list['oth_td_RR'].value=objDataForm.oth_td_RR.value;
			objWI_Obj.attribute_list['oth_td_RR'].modified_flag=true;		
		}
		/*else if(objDataForm.request_type.value=="Card Upgrade")
		{
			objWI_Obj.attribute_list['oth_cu_RR'].value=objDataForm.oth_cu_RR.value;
			objWI_Obj.attribute_list['oth_cu_RR'].modified_flag=true;				
		}*/
		else if(objDataForm.request_type.value=="Card Replacement")
		{
			objWI_Obj.attribute_list['oth_cr_reason'].value=objDataForm.oth_cr_reason.options[objDataForm.oth_cr_reason.selectedIndex].value;
			objWI_Obj.attribute_list['oth_cr_reason'].modified_flag=true;
			objWI_Obj.attribute_list['oth_cr_DC'].value=objDataForm.oth_cr_DC.options[objDataForm.oth_cr_DC.selectedIndex].value;
			objWI_Obj.attribute_list['oth_cr_DC'].modified_flag=true;
			objWI_Obj.attribute_list['oth_cr_RR'].value=objDataForm.oth_cr_RR.value;
			objWI_Obj.attribute_list['oth_cr_RR'].modified_flag=true;	
			objWI_Obj.attribute_list['oth_cr_BN'].value=objDataForm.oth_cr_BN.options[objDataForm.oth_cr_BN.selectedIndex].value;
			objWI_Obj.attribute_list['oth_cr_BN'].modified_flag=true;
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
/*
		if	(objDataForm.VD_PassNo.checked)
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
		return true;
}

function CheckDataType(cntrlValue,dataType)
{
	if(cntrlValue=="")
		return true;
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
        case "amount" :
			regex=/^[0-9,.]*$/;
		    break;
		 case "float":
			regex=/^[0-9,.,-]*$/;
		    break;
        case "name":
			regex=/^[a-z,\'_. &]*$/i;
			break;
		case "alphanumeric":
		    regex = /^[a-z0-9 ]*$/i;
			break;
		case "month":
			regex=/^[0123]*$/i;
			break;
	}	
	return regex.test(cntrlValue);
}

function checkForPastDate(cntrl)
{
	if(cntrl.value=="")
		return true;
	var objWI_Obj=window.top.wi_object;
	var objDataForm=window.parent.frames['left'].document.forms["dataform"];
	var sDate=objDataForm.sDate.value;
	var serverdate=sDate.substring(0,2);
	var serverMonth=sDate.substring(3,5);
	var serverYear=sDate.substring(6,10);
	var dt1=new Date(serverYear,serverMonth-1,serverdate);

	var dataToCheck=cntrl.value;
	var dataToCheckdate=dataToCheck.substring(0,2);
	var dataToCheckMonth=dataToCheck.substring(3,5);
	var dataToCheckYear=dataToCheck.substring(6,10);
	var dt2=new Date(dataToCheckYear,dataToCheckMonth-1,dataToCheckdate);

	return dt2>dt1||(dt2.getDate()==dt1.getDate()&&dt2.getMonth()==dt1.getMonth()&&dt2.getFullYear()==dt1.getFullYear());
}

function checkMonthDiff()
{
	
	var objWI_Obj=window.top.wi_object;
	var objDataForm=window.parent.frames['left'].document.forms["dataform"];
	if(objDataForm.DCI_ExpD.value==""||objDataForm.oth_ecr_RB.value=="")
		return true;
	var month1=objDataForm.DCI_ExpD.value.substring(0,2);
	var year1=objDataForm.DCI_ExpD.value.substring(3,5);

	var month2=objDataForm.oth_ecr_RB.value.substring(0,2);
	var year2=objDataForm.oth_ecr_RB.value.substring(3,5);
	var dt1=new Date("20"+year1,parseInt(month1)-1);
	var dt2=new Date("20"+year2,parseInt(month2)-1);

	if(parseInt(month2)+3>12)
	{
		var year=dt2.getYear();
		dt2.setFullYear(parseInt(year)+1);
		dt2.setMonth(parseInt(month2)+2-12);
	}
	else
	{
		dt2.setMonth(parseInt(month2)+2);
	}

	
	return dt2>dt1||dt1==dt2;
}