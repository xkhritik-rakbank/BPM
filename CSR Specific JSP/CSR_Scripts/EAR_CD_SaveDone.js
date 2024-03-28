function EAR_SaveDone(chkMandatory)
{
    var objWI_Obj=window.top.wi_object;
	var objDataForm=window.parent.frames['left'].document.forms["dataform"];

	if(objWI_Obj.workstep_name=="Branch_Manager")
	{
		if(chkMandatory==1)
		{
			if (objDataForm.branchManager_Decision.options[objDataForm.branchManager_Decision.selectedIndex].value=="")
			{
				alert("Branch Manager Decision is Mandatory");
				objDataForm.branchManager_Decision.focus();
				return false;
			}
			else if (objDataForm.branchManager_Decision.options[objDataForm.branchManager_Decision.selectedIndex].value=="Send Back")
			{
				if (objDataForm.branchManager_Remarks.value=='')
				{
					alert("Branch Manager Remarks are Mandatory");
					objDataForm.branchManager_Remarks.focus();
					return false;
				}
			}
			objWI_Obj.attribute_list['branchManager_Decision'].value=objDataForm.branchManager_Decision.options[objDataForm.branchManager_Decision.selectedIndex].value;
			objWI_Obj.attribute_list['branchManager_Decision'].modified_flag=true;	
			objWI_Obj.attribute_list['branchManager_Remarks'].value=objDataForm.branchManager_Remarks.value;
			objWI_Obj.attribute_list['branchManager_Remarks'].modified_flag=true;
			return true;				
		}
		else if(chkMandatory==0)
		{
			objWI_Obj.attribute_list['branchManager_Decision'].value=objDataForm.branchManager_Decision.options[objDataForm.branchManager_Decision.selectedIndex].value;
			objWI_Obj.attribute_list['branchManager_Decision'].modified_flag=true;
			objWI_Obj.attribute_list['branchManager_Remarks'].value=objDataForm.branchManager_Remarks.value;
			objWI_Obj.attribute_list['branchManager_Remarks'].modified_flag=true;
			return true;			
		}
	}
	else if (objWI_Obj.workstep_name=="Branch_User")
	{
		if(chkMandatory==1)
		{
			/*
			if (objDataForm.referenceNo.value=='')
			{
				alert('Reference Number cannot be blank');
				objDataForm.referenceNo.focus();
				return false;
			}
			else if (objDataForm.referenceNo.value.length!=13)
			{
				alert('Length of Reference Number should be 13');
				objDataForm.referenceNo.focus();
				return false;
			}
			else 
			*/ if (objDataForm.accountNo.value=='')
			{
				alert('A/C No. cannot be blank');
				objDataForm.accountNo.focus();
				return false;
			}
			else if (objDataForm.accountNo.value.length!=13)
			{
				alert('Length of A/C No. should be 13');
				objDataForm.accountNo.focus();
				return false;
			}
			else if (objDataForm.name.value=='')
			{
				alert('Name cannot be blank');
				objDataForm.name.focus();
				return false;
			}
/*			else if (objDataForm.limitAED.value=='')
			{
				alert('Limit AED cannot be blank');
				objDataForm.limitAED.focus();
				return false;
			}
			else if (objDataForm.limitExpiryDate.value=='')
			{
				alert('Please select Limit Expiry Date');
				objDataForm.limitExpiryDate.focus();
				return false;
			}*/
			else if (objDataForm.previousBalance.value=='')
			{
				alert('Previous Balance cannot be blank');
				objDataForm.previousBalance.focus();
				return false;
			}
			else if (objDataForm.thisTrxAED.value=='')
			{
				alert('This Trx AED cannot be blank');
				objDataForm.thisTrxAED.focus();
				return false;
			}
			else if (objDataForm.excessCreated.value=='')
			{
				alert('Excess created cannot be blank');
				objDataForm.excessCreated.focus();
				return false;
			}
			else if (objDataForm.newBalance.value=='')
			{
				alert('New Balance cannot be blank');
				objDataForm.newBalance.focus();
				return false;
			}
			else if (objDataForm.dateACLastRegular.value=='')
			{
				alert('Please select Date A/C last regular');
				objDataForm.dateACLastRegular.focus();
				return false;
			}
			else if (!Datediff2(objDataForm.dateACLastRegular.value,'Date A/C last regular'))
			{
				return false;
			}
			else if (objDataForm.regularizationDate.value=='')
			{
				alert('Please select Reqularization Date');
				objDataForm.regularizationDate.focus();
				return false;
			}
			else
			{
				var result=Datediff(objDataForm.regularizationDate.value,'Regularization Date');
				if (!result)
				{
					return false;
				}
			}
			objWI_Obj.attribute_list['referenceNo'].value=objDataForm.referenceNo.value;
			objWI_Obj.attribute_list['referenceNo'].modified_flag=true;
			objWI_Obj.attribute_list['accountNo'].value=objDataForm.accountNo.value;
			objWI_Obj.attribute_list['accountNo'].modified_flag=true;
			objWI_Obj.attribute_list['name'].value=objDataForm.name.value;
			objWI_Obj.attribute_list['name'].modified_flag=true;
			objWI_Obj.attribute_list['limitAED'].value=replaceAll(objDataForm.limitAED.value,",","");
			objWI_Obj.attribute_list['limitAED'].modified_flag=true;
			objWI_Obj.attribute_list['limitExpiryDate'].value=objDataForm.limitExpiryDate.value;
			objWI_Obj.attribute_list['limitExpiryDate'].modified_flag=true;
			objWI_Obj.attribute_list['previousBalance'].value=replaceAll(objDataForm.previousBalance.value,",","");
			objWI_Obj.attribute_list['previousBalance'].modified_flag=true;
			objWI_Obj.attribute_list['thisTrxAED'].value=replaceAll(objDataForm.thisTrxAED.value,",","");
			objWI_Obj.attribute_list['thisTrxAED'].modified_flag=true;
			objWI_Obj.attribute_list['excessCreated'].value=replaceAll(objDataForm.excessCreated.value,",","");
			objWI_Obj.attribute_list['excessCreated'].modified_flag=true;
			objWI_Obj.attribute_list['newBalance'].value=replaceAll(objDataForm.newBalance.value,",","");
			objWI_Obj.attribute_list['newBalance'].modified_flag=true;
			objWI_Obj.attribute_list['dateACLastRegular'].value=objDataForm.dateACLastRegular.value;
			objWI_Obj.attribute_list['dateACLastRegular'].modified_flag=true;
			objWI_Obj.attribute_list['regularizationDate'].value=objDataForm.regularizationDate.value;
			objWI_Obj.attribute_list['regularizationDate'].modified_flag=true;
			objWI_Obj.attribute_list['justification'].value=objDataForm.justification.value;
			objWI_Obj.attribute_list['justification'].modified_flag=true;
			objWI_Obj.attribute_list['branchUser_Remarks'].value=objDataForm.branchUser_Remarks.value;
			objWI_Obj.attribute_list['branchUser_Remarks'].modified_flag=true;

			return true;
		}
		else if (chkMandatory==0)
		{
			/*
			if (objDataForm.referenceNo.value.length!=13)
			{
				alert('Length of Reference Number should be 13');
				objDataForm.referenceNo.focus();
				return false;
			}
			else if (objDataForm.accountNo.value.length!=13)
			{
				alert('Length of A/C No. should be 13');
				objDataForm.accountNo.focus();
				return false;
			}
			else */ if (objDataForm.dateACLastRegular.value!='')
			{
				if (!Datediff2(objDataForm.dateACLastRegular.value,'Date A/C last regular'))
				{
					return false;
				}
			}
			if (objDataForm.regularizationDate.value!='')
			{
				var result=Datediff(objDataForm.regularizationDate.value,'Regularization Date');
				if (!result)
				{
					return false;
				}
			}
			objWI_Obj.attribute_list['referenceNo'].value=objDataForm.referenceNo.value;
			objWI_Obj.attribute_list['referenceNo'].modified_flag=true;
			objWI_Obj.attribute_list['accountNo'].value=objDataForm.accountNo.value;
			objWI_Obj.attribute_list['accountNo'].modified_flag=true;
			objWI_Obj.attribute_list['name'].value=objDataForm.name.value;
			objWI_Obj.attribute_list['name'].modified_flag=true;
			objWI_Obj.attribute_list['limitAED'].value=replaceAll(objDataForm.limitAED.value,",","");
			objWI_Obj.attribute_list['limitAED'].modified_flag=true;
			objWI_Obj.attribute_list['limitExpiryDate'].value=objDataForm.limitExpiryDate.value;
			objWI_Obj.attribute_list['limitExpiryDate'].modified_flag=true;
			objWI_Obj.attribute_list['previousBalance'].value=replaceAll(objDataForm.previousBalance.value,",","");
			objWI_Obj.attribute_list['previousBalance'].modified_flag=true;
			objWI_Obj.attribute_list['thisTrxAED'].value=replaceAll(objDataForm.thisTrxAED.value,",","");
			objWI_Obj.attribute_list['thisTrxAED'].modified_flag=true;
			objWI_Obj.attribute_list['excessCreated'].value=replaceAll(objDataForm.excessCreated.value,",","");
			objWI_Obj.attribute_list['excessCreated'].modified_flag=true;
			objWI_Obj.attribute_list['newBalance'].value=replaceAll(objDataForm.newBalance.value,",","");
			objWI_Obj.attribute_list['newBalance'].modified_flag=true;
			objWI_Obj.attribute_list['dateACLastRegular'].value=objDataForm.dateACLastRegular.value;
			objWI_Obj.attribute_list['dateACLastRegular'].modified_flag=true;
			objWI_Obj.attribute_list['regularizationDate'].value=objDataForm.regularizationDate.value;
			objWI_Obj.attribute_list['regularizationDate'].modified_flag=true;
			objWI_Obj.attribute_list['justification'].value=objDataForm.justification.value;
			objWI_Obj.attribute_list['justification'].modified_flag=true;
			objWI_Obj.attribute_list['branchUser_Remarks'].value=objDataForm.branchUser_Remarks.value;
			objWI_Obj.attribute_list['branchUser_Remarks'].modified_flag=true;
			return true;
		}
	}
	else if (objWI_Obj.workstep_name=="Credit_Analyst")
	{
		if(chkMandatory==1)
		{
			if (objDataForm.expectedRegularizationDate.value=='')
			{
				if (objDataForm.creditAnalyst_Decision.options[objDataForm.creditAnalyst_Decision.selectedIndex].value!="No")
				{
					alert('Please select Expected Reqularization Date');
					objDataForm.expectedRegularizationDate.focus();
					return false;
				}
			}
			else if (objDataForm.expectedRegularizationDate.value!='')
			{
				var result=expectedRegularizationDateDiff(objDataForm.expectedRegularizationDate.value,'Expected Regularization Date');
				if (!result)
				{
					return false;
				}
			}
			if (objDataForm.creditAnalyst_Decision.options[objDataForm.creditAnalyst_Decision.selectedIndex].value=="")
			{
				alert("Credit Analyst Decision is Mandatory");
				objDataForm.creditAnalyst_Decision.focus();
				return false;
			}
			else if (objDataForm.creditAnalyst_Decision.options[objDataForm.creditAnalyst_Decision.selectedIndex].value=="No")
			{
				if (objDataForm.creditAnalyst_Remarks.value=='')
				{
					alert("Credit Analyst Remarks are Mandatory");
					objDataForm.creditAnalyst_Remarks.focus();
					return false;
				}
			}
			objWI_Obj.attribute_list['expectedRegularizationDate'].value=objDataForm.expectedRegularizationDate.value;
			objWI_Obj.attribute_list['expectedRegularizationDate'].modified_flag=true;			objWI_Obj.attribute_list['creditAnalyst_Decision'].value=objDataForm.creditAnalyst_Decision.options[objDataForm.creditAnalyst_Decision.selectedIndex].value;
			objWI_Obj.attribute_list['creditAnalyst_Decision'].modified_flag=true;	
			objWI_Obj.attribute_list['creditAnalyst_Remarks'].value=objDataForm.creditAnalyst_Remarks.value;
			objWI_Obj.attribute_list['creditAnalyst_Remarks'].modified_flag=true;
			return true;				
		}
		else if(chkMandatory==0)
		{
			if (objDataForm.expectedRegularizationDate.value!='')
			{
				var result=expectedRegularizationDateDiff(objDataForm.expectedRegularizationDate.value,'Expected Regularization Date');
				if (!result)
				{
					return false;
				}
			}	
			objWI_Obj.attribute_list['expectedRegularizationDate'].value=objDataForm.expectedRegularizationDate.value;
			objWI_Obj.attribute_list['expectedRegularizationDate'].modified_flag=true;			objWI_Obj.attribute_list['creditAnalyst_Decision'].value=objDataForm.creditAnalyst_Decision.options[objDataForm.creditAnalyst_Decision.selectedIndex].value;
			objWI_Obj.attribute_list['creditAnalyst_Decision'].modified_flag=true;
			objWI_Obj.attribute_list['creditAnalyst_Remarks'].value=objDataForm.creditAnalyst_Remarks.value;
			objWI_Obj.attribute_list['creditAnalyst_Remarks'].modified_flag=true;
			return true;			
		}
	}
	else if (objWI_Obj.workstep_name=="Credit_Manager")
	{
		if(chkMandatory==1)
		{
			if (objDataForm.expectedRegularizationDate.value=='')
			{
				if (objDataForm.creditManager_Decision.options[objDataForm.creditManager_Decision.selectedIndex].value!="No")
				{
					alert('Please select Expected Reqularization Date');
					objDataForm.expectedRegularizationDate.focus();
					return false;
				}
			}
			else if (objDataForm.expectedRegularizationDate.value!='')
			{
				var result=expectedRegularizationDateDiff(objDataForm.expectedRegularizationDate.value,'Expected Regularization Date');
				if (!result)
				{
					return false;
				}
			}
			if (objDataForm.creditManager_Decision.options[objDataForm.creditManager_Decision.selectedIndex].value=="")
			{
				alert("Credit Manager Decision is Mandatory");
				objDataForm.creditManager_Decision.focus();
				return false;
			}
			else if (objDataForm.creditManager_Decision.options[objDataForm.creditManager_Decision.selectedIndex].value=="No")
			{
				if (objDataForm.creditManager_Remarks.value=='')
				{
					alert("Credit Manager Remarks are Mandatory");
					objDataForm.creditManager_Remarks.focus();
					return false;
				}
			}
			objWI_Obj.attribute_list['expectedRegularizationDate'].value=objDataForm.expectedRegularizationDate.value;
			objWI_Obj.attribute_list['expectedRegularizationDate'].modified_flag=true;				objWI_Obj.attribute_list['creditManager_Decision'].value=objDataForm.creditManager_Decision.options[objDataForm.creditManager_Decision.selectedIndex].value;
			objWI_Obj.attribute_list['creditManager_Decision'].modified_flag=true;	
			objWI_Obj.attribute_list['creditManager_Remarks'].value=objDataForm.creditManager_Remarks.value;
			objWI_Obj.attribute_list['creditManager_Remarks'].modified_flag=true;
			return true;				
		}
		else if(chkMandatory==0)
		{
			if (objDataForm.expectedRegularizationDate.value!='')
			{
				var result=expectedRegularizationDateDiff(objDataForm.expectedRegularizationDate.value,'Expected Regularization Date');
				if (!result)
				{
					return false;
				}
			}	
			objWI_Obj.attribute_list['expectedRegularizationDate'].value=objDataForm.expectedRegularizationDate.value;
			objWI_Obj.attribute_list['expectedRegularizationDate'].modified_flag=true;	objWI_Obj.attribute_list['creditManager_Decision'].value=objDataForm.creditManager_Decision.options[objDataForm.creditManager_Decision.selectedIndex].value;
			objWI_Obj.attribute_list['creditManager_Decision'].modified_flag=true;
			objWI_Obj.attribute_list['creditManager_Remarks'].value=objDataForm.creditManager_Remarks.value;
			objWI_Obj.attribute_list['creditManager_Remarks'].modified_flag=true;
			return true;			
		}
	}
	else if (objWI_Obj.workstep_name=="Branch_Update")
	{
		if(chkMandatory==1)
		{
			if (objDataForm.branchUpdate_Decision.options[objDataForm.branchUpdate_Decision.selectedIndex].value=="")
			{
				alert("Please select if Auhorization of Debit to Customer Account has been completed");
				objDataForm.branchUpdate_Decision.focus();
				return false;
			}
			objWI_Obj.attribute_list['branchUpdate_Decision'].value=objDataForm.branchUpdate_Decision.options[objDataForm.branchUpdate_Decision.selectedIndex].value;
			objWI_Obj.attribute_list['branchUpdate_Decision'].modified_flag=true;	
			objWI_Obj.attribute_list['branchUpdate_Remarks'].value=objDataForm.branchUpdate_Remarks.value;
			objWI_Obj.attribute_list['branchUpdate_Remarks'].modified_flag=true;
			return true;				
		}
		else if(chkMandatory==0)
		{
			objWI_Obj.attribute_list['branchUpdate_Decision'].value=objDataForm.branchUpdate_Decision.options[objDataForm.branchUpdate_Decision.selectedIndex].value;
			objWI_Obj.attribute_list['branchUpdate_Decision'].modified_flag=true;
			objWI_Obj.attribute_list['branchUpdate_Remarks'].value=objDataForm.branchUpdate_Remarks.value;
			objWI_Obj.attribute_list['branchUpdate_Remarks'].modified_flag=true;
			return true;			
		}
	}
	else if (objWI_Obj.workstep_name=="ActualRegularization")
	{
		if(chkMandatory==1)
		{
			if (objDataForm.actualRegularizationDone.options[objDataForm.actualRegularizationDone.selectedIndex].value=="")
			{
				alert("Please select if Actual Regularization has been completed");
				objDataForm.actualRegularizationDone.focus();
				return false;
			}
			else if (objDataForm.actualRegularizationDone.options[objDataForm.actualRegularizationDone.selectedIndex].value=="Yes")
			{
				if (objWI_Obj.attribute_list['actualRegularizationDate'].value=="")
				{
					alert('Please select Actual Reqularization Date');
					objDataForm.actualRegularizationDate.focus();
					return false;
				}
			}

			objWI_Obj.attribute_list['actualRegularizationDone'].value=objDataForm.actualRegularizationDone.options[objDataForm.actualRegularizationDone.selectedIndex].value;
			objWI_Obj.attribute_list['actualRegularizationDone'].modified_flag=true;	
			objWI_Obj.attribute_list['actualRegularizationDate'].value=objDataForm.actualRegularizationDate.value;
			objWI_Obj.attribute_list['actualRegularizationDate'].modified_flag=true;
			objWI_Obj.attribute_list['actualReqularizationRemarks'].value=objDataForm.actualReqularizationRemarks.value;
			objWI_Obj.attribute_list['actualReqularizationRemarks'].modified_flag=true;
			return true;				
		}
		else if(chkMandatory==0)
		{
			objWI_Obj.attribute_list['actualRegularizationDone'].value=objDataForm.actualRegularizationDone.options[objDataForm.actualRegularizationDone.selectedIndex].value;
			objWI_Obj.attribute_list['actualRegularizationDone'].modified_flag=true;	
			objWI_Obj.attribute_list['actualRegularizationDate'].value=objDataForm.actualRegularizationDate.value;
			objWI_Obj.attribute_list['actualRegularizationDate'].modified_flag=true;
			objWI_Obj.attribute_list['actualReqularizationRemarks'].value=objDataForm.actualReqularizationRemarks.value;
			objWI_Obj.attribute_list['actualReqularizationRemarks'].modified_flag=true;
			return true;			
		}
	}
}
function Datediff2(DateField,DateFieldValue)
{ 
    var objWI_Obj=window.top.wi_object;
	var objDataForm=window.parent.frames['left'].document.forms["dataform"];
	var depDate=DateField;
	if(depDate=="")
	{
		return false;
	}
	var dd1=depDate.substring(0,2);
	var mm1=depDate.substring(3,5);
	var yy1=depDate.substring(6,10);
	var depDate1=yy1+'/'+mm1+'/'+dd1;
	var Cur1Date=objDataForm.sysDate.value;
	var dd2=Cur1Date.substring(0,2);
	var mm2=Cur1Date.substring(3,5);
	var yy2=Cur1Date.substring(6,10);
	var CurDate1=yy2+'/'+mm2+'/'+dd2;
	var CurDate2=new Date(CurDate1);
	var depDate2=new Date(depDate1);
	var days = ((depDate2.getTime() - CurDate2.getTime())/(1000*60*60*24));	
	if (Number(days) > 0)
	{
		alert(DateFieldValue+" cannot be greater than Current Date");
		objDataForm.dateACLastRegular.value="";
		return false;
	}
	return true;
}
function Datediff(DateField,DateFieldValue)
{ 
    var objWI_Obj=window.top.wi_object;
	var objDataForm=window.parent.frames['left'].document.forms["dataform"];
	var depDate=DateField;
	if(depDate=="")
	{
		return false;
	}
	var dd1=depDate.substring(0,2);
	var mm1=depDate.substring(3,5);
	var yy1=depDate.substring(6,10);
	var depDate1=yy1+'/'+mm1+'/'+dd1;
	var Cur1Date=objDataForm.sysDate.value;
	var dd2=Cur1Date.substring(0,2);
	var mm2=Cur1Date.substring(3,5);
	var yy2=Cur1Date.substring(6,10);
	var CurDate1=yy2+'/'+mm2+'/'+dd2;
	var CurDate2=new Date(CurDate1);
	var depDate2=new Date(depDate1);
	var days = ((depDate2.getTime() - CurDate2.getTime())/(1000*60*60*24));	
	if (Number(days) < 0)
	{
		alert(DateFieldValue+" cannot be less than Current Date");
		objDataForm.regularizationDate.value="";
		return false;
	}
	return true;
}
function expectedRegularizationDateDiff(DateField,DateFieldValue)
{ 
    var objWI_Obj=window.top.wi_object;
	var objDataForm=window.parent.frames['left'].document.forms["dataform"];
	var depDate=DateField;
	if(depDate=="")
	{
		return false;
	}
	var dd1=depDate.substring(0,2);
	var mm1=depDate.substring(3,5);
	var yy1=depDate.substring(6,10);
	var depDate1=yy1+'/'+mm1+'/'+dd1;
	var Cur1Date=objDataForm.sysDate.value;
	var dd2=Cur1Date.substring(0,2);
	var mm2=Cur1Date.substring(3,5);
	var yy2=Cur1Date.substring(6,10);
	var CurDate1=yy2+'/'+mm2+'/'+dd2;
	var CurDate2=new Date(CurDate1);
	var depDate2=new Date(depDate1);
	var days = ((depDate2.getTime() - CurDate2.getTime())/(1000*60*60*24));	
	if (Number(days) < 0)
	{
		alert(DateFieldValue+" cannot be less than Current Date");
		objDataForm.expectedRegularizationDate.value="";
		return false;
	}
	return true;
}