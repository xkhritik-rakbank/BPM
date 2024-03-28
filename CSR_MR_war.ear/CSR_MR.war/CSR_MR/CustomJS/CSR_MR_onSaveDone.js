
function setCustomControlsValue()
{
   if(ActivityName=="Work Introduction" || ActivityName=="Pending" || ActivityName=="Branch_Return")
	{
	    if(ActivityName=="Work Introduction")
	    {
			if(getValue("CCI_CName")=='' || getValue("CCI_CName")==null)
			{
				showMessage('CCI_CName','Please enter card no and click refresh button to fetch card data!',"error");
				setFocus("CCI_CrdtCN");
				return false;
			}
		    if(getValue("CCI_CrdtCN")=='' || getValue("CCI_CrdtCN")==null)
			{
				alert("Please enter card no and click refresh button to fetch card data!");
				setFocus("CCI_CrdtCN");
				return false;
			}
	    }
	    if (!CheckValueForField("CCI_ExtNo", getValue("CCI_ExtNo"), "Ext. No.", "digits"))
			return false;
	  
	    if(getValue("CCI_ExtNo")=="")
	    {
			showMessage('CCI_ExtNo','Ext No. is Mandatory!',"error");
			setFocus("CCI_ExtNo");
			return false;
	    }
		if(getValue("CCI_ExtNo").length != 4)
	    {
			showMessage('CCI_ExtNo','Ext No. should be 4 digits!',"error");
			setFocus("CCI_ExtNo");
			return false;
	    }
		//commented for production issue 
		/*if(getValue("CCI_CT") == "L")
		{
			showMessage("CCI_CT", "Current Card Type is not allowed for this request!","error");
			setFocus("CCI_CT");
			return false;
		}*/
	  
	    if(getValue("VD_MoMaidN_Check")==false && getValue("VD_TIN_Check")==false) 
	    {
			//alert("VD_TIN_Check"+VD_TIN_Check);
			showMessage('VD_TIN_Check','Atleast one of Verification Details is Mandatory!',"error");
			setFocus("VD_TIN_Check");
			return false;
	    }
	  
	    if(getValue("VD_MoMaidN_Check")==true)
		{
			var i=0;
			if(getValue("VD_DOB_Check")==true) i++;
			if(getValue("VD_StaffId_Check")==true) i++;
			if(getValue("VD_POBox_Check")==true) i++;
			if(getValue("VD_PassNo_Check")==true) i++;
			if(getValue("VD_Oth_Check")==true) i++;
			if(getValue("VD_MRT_Check")==true) i++;
			if(getValue("VD_EDC_Check")==true) i++;
			if(getValue("VD_NOSC_Check")==true) i++;
			if(getValue("VD_TELNO_Check")==true) i++;
			if(getValue("VD_SD_Check")==true) i++;
			if (i < 4)
				{
				  //alert( "Please select atleast 4 Random Questions!");
				  showMessage('VD_MoMaidN_Check',"Please select atleast 4 Random Questions!","error");
				  setFocus("VD_MoMaidN_Check");
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
			showMessage('REMARKS','Remarks/Reasons is Mandatory!',"error");
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
		   showMessage('Cards_Remarks',' Cards Remarks/Reasons is Mandatory!',"error");
		   setFocus("Cards_Remarks");
		   return false;
		   }
		}   
		if(getValue("Cards_Decision")=="CARDS_BR")
		{
		   if(getValue("Cards_Remarks")=="")
		   {
		   showMessage('Cards_Remarks',' Cards Remarks/Reasons is Mandatory!',"error");
		   setFocus("Cards_Remarks");
		   return false;
		   }
		} 
	}

return true;
}  

function CheckValueForField(paramString1,paramString2,paramString3,paramString4)    
{
	//alert("inside  CheckValueForField ...new 1: " + paramString1);
	var str1 = paramString2;
	var bool = false;
	var str2 = "";
	if (paramString2 == "")
	{
		return true;
	}
	if ((paramString4 == "") || (paramString4 == "date"))
	{
		return true;
	}
	if (paramString4 == "name")
		//str2 = "[a-zA-Z-9 \t]*";
		//str2 = /[A-Za-z ]$/;
		str2 = /^[A-Za-z]+$/;
	else if (paramString4 == "digits_alphabets")
		//str2 = "[0-9A-Za-z- \t]*";
		//str2 = /[0-9A-Za-z ]$/;
		str2 = /^[0-9A-Za-z ]+$/;
	else if (paramString4 == "digits_space")
		//str2 = "[0-9- \t]*";
		//str2 = /[0-9 ]$/;
		str2 = /^[0-9 ]+$/;
	else if (paramString4 == "digits")
		str2 = /^[0-9]+$/;
		//str2 = "[0-9-\t]*";
		//str2 = /[0-9]$/;
	else if (paramString4 == "decimal")
		//str2 = "[0-9.0-9-\t]*";
		//str2 = /[0-9.0-9]$/;
		str2 = /^[0-9.0-9]+$/;
	else if (paramString4 == "alpha")
		//str2 = "[a-zA-Z-9 \t]*";
		//str2 = /[a-zA-Z ]$/;
		str2 = /^[a-zA-Z ]+$/;
	else if (paramString4 == "address")
		//str2 = "[0-9A-Za-z- \t(){},.:;/]*";
		str2 = /^[0-9A-Za-z- \t(){},.:;/]+$/;
	else if (paramString4 == "all")
		//str2 = "[0-9a-zA-Z -!@#$%^&*'<>?(){},.:;\t/-]*";
		str2 = /^[0-9a-zA-Z -!@#$%^&*'<>?(){},.:;\t/-]+$/;
	else if (paramString4 == "alphabets")
		//str2 = "[a-zA-Z-9\t]*";
		//str2 = /[a-zA-Z]$/;
		str2 = /^[a-zA-Z]+$/;
	else if (paramString4 == "CCI_CrdtCN")
		//str2 = "^([0-9]{0,4}|[0-9]{4}-|[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{0,4})$";
		//str2 = /([0-9]{0,4}|[0-9]{4}-|[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{0,4})$/;
		str2 = /^([0-9]{0,4}|[0-9]{4}-|[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{0,4})+$/;
	
	//bool = str2.match(str1);
	if (!str1.match(str2))
	{
		if ((paramString4 == "name") || (paramString4 == "digits_alphabets") || (paramString4 == "digits_space") || (paramString4 == "digits") || (paramString4 == "decimal") || (paramString4 == "address") || (paramString4 == "alpha") || (paramString4 == "all") || (paramString4 == "alphabets"))
		{
			if (paramString4 == "alphanumeric")
			{
				showMessage(paramString1, "Only alphabets,numbers and spaces are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "digits")
			{
				showMessage(paramString1, "Only numbers are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "digits_space")
			{
				showMessage(paramString1, "Only numbers are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "decimal")
			{
				showMessage(paramString1, "Only decimal numbers are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "digits_alphabets")
			{
				showMessage(paramString1, "Only numbers and alphabets spaces are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "account_no")
			{
				showMessage(paramString1, "Only numbers and alphabets are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "alpha")
			{
				showMessage(paramString1, "Only alphabets are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "name")
			{
				showMessage(paramString1, "Only alphabets and spaces are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "alphabets")
			{
				showMessage(paramString1, "Only alphabets are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "pan_no")
			{
				showMessage(paramString1, "Only numbers and alphabets are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "all")
			{
				showMessage(paramString1, "Only numbers and alphabets spaces ,dot,comma !@#$%^&*'<>?(){},.:; and - are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "address")
			{
				showMessage(paramString1, "Only numbers and alphabets spaces ,dot,comma (){},.:; and - are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "email")
			{
				showMessage(paramString1, "Enter valid email id in " + paramString3 + ".","error");
			}

			setFocus(paramString1);
			setControlValue(paramString1, "");
			return false;
		}

		return false;
	}

	return true;
}





