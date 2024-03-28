function EAROCD_SaveDone(chkMandatory)
{
    var objWI_Obj=window.top.wi_object;
	var objDataForm=window.parent.frames['left'].document.forms["dataform"];

	if (objWI_Obj.workstep_name=="ActualRegularization")
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
