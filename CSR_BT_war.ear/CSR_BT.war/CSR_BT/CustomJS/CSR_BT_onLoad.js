

function setEnableDisable()
	{
		if(ActivityName=='Work Introduction')
		{
			//setControlValue("CCI_ExpD","Masked");
			setStyle("PrintFrame","visible","false");
			setStyle("BAD","visible","false");
			setStyle("CD","visible","false");
			setStyle("UserName","visible","false");
			setStyle("DateTime","visible","false");
			setStyle("wi_name","visible","false");
			setStyle("DecisionFrame","visible","false");
			setStyle("BTD_RBC_CT1","disable","true");
			setStyle("BTD_RBC_CT2","disable","true");
			setStyle("BTD_RBC_CT3","disable","true");
			setStyle("BTD_RBC_ExpD1","disable","true");
			setStyle("BTD_RBC_ExpD2","disable","true");
			setStyle("BTD_RBC_ExpD3","disable","true");
			
			if(getValue("BTD_OBC_OBN")=='Others')
			{
				setStyle("BTD_OBC_OBNO","disable","false");
			}
			else 
			{
				setStyle("BTD_OBC_OBNO","disable","true");
			}
			if(getValue("BTD_OBC_DT")=='Bank')
			{
				setStyle("BTD_OBC_BN","disable","false");
			}
			else 
			{
				setStyle("BTD_OBC_BN","disable","true");
			}
			
			
			
			/* setStyle("BTD_RBC_BTA1","disable","true");
			setStyle("BTD_RBC_BTA2","disable","true");
			setStyle("BTD_RBC_BTA3","disable","true");
			setStyle("BTD_RBC_AppC1","disable","true");
			setStyle("BTD_RBC_AppC2","disable","true");
			setStyle("BTD_RBC_AppC3","disable","true"); */
			
			
		}
		if(ActivityName=='CARDS')
		{
			setStyle("HiddenFieldsFrame","visible","false");
			setStyle("LoggedInUser","visible","false");
			setStyle("USER_BRANCH","visible","true");
			setStyle("ServiceType","visible","false");
			setStyle("CreditCardNo1","visible","false");
			setStyle("Refresh","visible","false");
			setStyle("DecisionFrame","visible","false");
			setStyle("Buttons","visible","false");
			setStyle("VD_TIN_Check","disable","true");
			setStyle("VD_MoMaidN_Check","disable","true");
			setStyle("VD_POBox_Check","disable","true");
			setStyle("VD_TELNO_Check","disable","true");
			setStyle("VD_PassNo_Check","disable","true");
			setStyle("VD_MRT_Check","disable","true");
			setStyle("VD_Oth_Check","disable","true");
			setStyle("VD_SD_Check","disable","true");
			setStyle("VD_EDC_Check","disable","true");
			setStyle("VD_StaffId_Check","disable","true");
			setStyle("VD_DOB_Check","disable","true");
			setStyle("VD_NOSC_Check","disable","true");
			setStyle("BTD_OBC_CT","disable","true");
			setStyle("BTD_OBC_OBN","disable","true");
			setStyle("BTD_OBC_OBNO","disable","true");
			setStyle("BTD_OBC_OBCNO","disable","true");
			setStyle("BTD_OBC_DT","disable","true");
			setStyle("BTD_OBC_BN","disable","true");
			setStyle("BTD_OBC_NOOC","disable","true");
			setStyle("BTD_RBC_RBCN11","disable","true");
			setStyle("BTD_RBC_RBCN22","disable","true");
			setStyle("BTD_RBC_RBCN33","disable","true");
			setStyle("BTD_RBC_CT1","disable","true");
			setStyle("BTD_RBC_CT2","disable","true");
			setStyle("BTD_RBC_CT3","disable","true");
			setStyle("BTD_RBC_ExpD1","disable","true");
			setStyle("BTD_RBC_ExpD2","disable","true");
			setStyle("BTD_RBC_ExpD3","disable","true");
			setStyle("BTD_RBC_BTA1","disable","true");
			setStyle("BTD_RBC_BTA2","disable","true");
			setStyle("BTD_RBC_BTA3","disable","true");
			setStyle("BTD_RBC_AppC1","disable","true");
			setStyle("BTD_RBC_AppC2","disable","true");
			setStyle("BTD_RBC_AppC3","disable","true");
			setStyle("BTD_RBC_RR","disable","true");
			setStyle("BA_Decision","disable","true");
			setStyle("BA_Remarks","disable","true");
			setStyle("CCI_SC","disable","true");
			setStyle("CCI_ExtNo","disable","true");
			setStyle("PrintFrame","visible","true");
			var RakBankCard = executeServerEvent("RakBankCard","FormLoad","",true);
			//alert("RakBankCard ::"+RakBankCard);
			//addItemInCombo("BTD_RBC_RBCN11",getValue("BTD_RBC_RBCN1"));
			if ((getValue("BTD_RBC_RBCN1").length==16)||(getValue("BTD_RBC_RBCN1").length==15)){
				var temp_car_value1 = getValue("BTD_RBC_RBCN1").substring(0,4)+ '-' + getValue("BTD_RBC_RBCN1").substring(4,8)+ '-' + getValue("BTD_RBC_RBCN1").substring(8,12)+ '-' + getValue("BTD_RBC_RBCN1").substring(12);
				setControlValue("BTD_RBC_RBCN11",temp_car_value1);
			}
			if ((getValue("BTD_RBC_RBCN2").length==16)||(getValue("BTD_RBC_RBCN2").length==15)){
				var temp_car_value2 = getValue("BTD_RBC_RBCN2").substring(0,4)+ '-' + getValue("BTD_RBC_RBCN2").substring(4,8)+ '-' + getValue("BTD_RBC_RBCN2").substring(8,12)+ '-' + getValue("BTD_RBC_RBCN2").substring(12);
				setControlValue("BTD_RBC_RBCN22",temp_car_value2);
			}
			if ((getValue("BTD_RBC_RBCN2").length==16)||(getValue("BTD_RBC_RBCN3").length==15)){
				var temp_car_value3 = getValue("BTD_RBC_RBCN3").substring(0,4)+ '-' + getValue("BTD_RBC_RBCN3").substring(4,8)+ '-' + getValue("BTD_RBC_RBCN3").substring(8,12)+ '-' + getValue("BTD_RBC_RBCN3").substring(12);
				setControlValue("BTD_RBC_RBCN33",temp_car_value2);
			}
			//alert("Inside Cards");
		}
		if(ActivityName=='Pending')
		{
			
			setStyle("PrintFrame","visible","false");
			setStyle("HiddenFieldsFrame","visible","false");
			setStyle("LoggedInUser","visible","false");
			setStyle("USER_BRANCH","visible","true");
			setStyle("ServiceType","visible","false");
			setStyle("CreditCardNo1","visible","false");
			setStyle("Refresh","visible","false");
			setStyle("BAD","visible","false");
			setStyle("CD","visible","false");
			setStyle("Buttons","visible","false");
			setStyle("BTD_RBC_CT1","disable","true");
			setStyle("BTD_RBC_CT2","disable","true");
			setStyle("BTD_RBC_CT3","disable","true");
			setStyle("BTD_RBC_ExpD1","disable","true");
			setStyle("BTD_RBC_ExpD2","disable","true");
			setStyle("BTD_RBC_ExpD3","disable","true");
			//setStyle("BTD_RBC_RBCN11","disable","true");
			//setStyle("BTD_RBC_RBCN22","disable","true");
			//setStyle("BTD_RBC_RBCN33","disable","true");
			var RakBankCard = executeServerEvent("RakBankCard","FormLoad","",true);
			//alert("RakBankCard ::"+RakBankCard);
			if ((getValue("BTD_RBC_RBCN1").length==16)||(getValue("BTD_RBC_RBCN1").length==15)){
				var temp_car_value1 = getValue("BTD_RBC_RBCN1").substring(0,4)+ '-' + getValue("BTD_RBC_RBCN1").substring(4,8)+ '-' + getValue("BTD_RBC_RBCN1").substring(8,12)+ '-' + getValue("BTD_RBC_RBCN1").substring(12);
				setControlValue("BTD_RBC_RBCN11",temp_car_value1);
			}
			if ((getValue("BTD_RBC_RBCN2").length==16)||(getValue("BTD_RBC_RBCN2").length==15)){
				var temp_car_value2 = getValue("BTD_RBC_RBCN2").substring(0,4)+ '-' + getValue("BTD_RBC_RBCN2").substring(4,8)+ '-' + getValue("BTD_RBC_RBCN2").substring(8,12)+ '-' + getValue("BTD_RBC_RBCN2").substring(12);
				setControlValue("BTD_RBC_RBCN22",temp_car_value2);
			}
			if ((getValue("BTD_RBC_RBCN2").length==16)||(getValue("BTD_RBC_RBCN3").length==15)){
				var temp_car_value3 = getValue("BTD_RBC_RBCN3").substring(0,4)+ '-' + getValue("BTD_RBC_RBCN3").substring(4,8)+ '-' + getValue("BTD_RBC_RBCN3").substring(8,12)+ '-' + getValue("BTD_RBC_RBCN3").substring(12);
				setControlValue("BTD_RBC_RBCN33",temp_car_value2);
			}
			if(getValue("BTD_OBC_OBN")=='Others')
			{
				setStyle("BTD_OBC_OBNO","disable","false");
			}
			else 
			{
				setStyle("BTD_OBC_OBNO","disable","true");
			}
			if(getValue("BTD_OBC_DT")=='Bank')
			{
				setStyle("BTD_OBC_BN","disable","false");
			}
			else 
			{
				setStyle("BTD_OBC_BN","disable","true");
			}
			
			
			
		}
		if(ActivityName=='Branch_Return')
		{
			
			setStyle("HiddenFieldsFrame","visible","false");
			setStyle("PrintFrame","visible","false");
			setStyle("Card_DateTime","visible","true");
			setStyle("LoggedInUser","visible","false");
			setStyle("USER_BRANCH","visible","true");
			setStyle("ServiceType","visible","false");
			setStyle("CreditCardNo1","visible","false");
			setStyle("Refresh","visible","false");
			setStyle("DecisionFrame","visible","false");
			setStyle("Buttons","visible","false");
			setStyle("BA_Decision","disable","true");
			setStyle("BA_Remarks","disable","true");
			setStyle("Cards_Decision","disable","true");
			setStyle("Cards_Remarks","disable","true");
			setStyle("BTD_RBC_CT1","disable","true");
			setStyle("BTD_RBC_CT2","disable","true");
			setStyle("BTD_RBC_CT3","disable","true");
			setStyle("BTD_RBC_ExpD1","disable","true");
			setStyle("BTD_RBC_ExpD2","disable","true");
			setStyle("BTD_RBC_ExpD3","disable","true");
			//setStyle("BTD_RBC_RBCN11","disable","true");
			//setStyle("BTD_RBC_RBCN22","disable","true");
			//setStyle("BTD_RBC_RBCN33","disable","true");
			var RakBankCard = executeServerEvent("RakBankCard","FormLoad","",true);
			//alert("RakBankCard ::"+RakBankCard);
			if ((getValue("BTD_RBC_RBCN1").length==16)||(getValue("BTD_RBC_RBCN1").length==15)){
				var temp_car_value1 = getValue("BTD_RBC_RBCN1").substring(0,4)+ '-' + getValue("BTD_RBC_RBCN1").substring(4,8)+ '-' + getValue("BTD_RBC_RBCN1").substring(8,12)+ '-' + getValue("BTD_RBC_RBCN1").substring(12);
				setControlValue("BTD_RBC_RBCN11",temp_car_value1);
			}
			if ((getValue("BTD_RBC_RBCN2").length==16)||(getValue("BTD_RBC_RBCN2").length==15)){
				var temp_car_value2 = getValue("BTD_RBC_RBCN2").substring(0,4)+ '-' + getValue("BTD_RBC_RBCN2").substring(4,8)+ '-' + getValue("BTD_RBC_RBCN2").substring(8,12)+ '-' + getValue("BTD_RBC_RBCN2").substring(12);
				setControlValue("BTD_RBC_RBCN22",temp_car_value2);
			}
			if ((getValue("BTD_RBC_RBCN2").length==16)||(getValue("BTD_RBC_RBCN3").length==15)){
				var temp_car_value3 = getValue("BTD_RBC_RBCN3").substring(0,4)+ '-' + getValue("BTD_RBC_RBCN3").substring(4,8)+ '-' + getValue("BTD_RBC_RBCN3").substring(8,12)+ '-' + getValue("BTD_RBC_RBCN3").substring(12);
				setControlValue("BTD_RBC_RBCN33",temp_car_value2);
			}
			
			if(getValue("BTD_OBC_OBN")=='Others')
			{
				setStyle("BTD_OBC_OBNO","disable","false");
			}
			else 
			{
				setStyle("BTD_OBC_OBNO","disable","true");
			}
			if(getValue("BTD_OBC_DT")=='Bank')
			{
				setStyle("BTD_OBC_BN","disable","false");
			}
			else 
			{
				setStyle("BTD_OBC_BN","disable","true");
			}
				
			
		}
		if(ActivityName=='Branch_Approver')
		{
			setStyle("PrintFrame","visible","false");
			setStyle("HiddenFieldsFrame","visible","false");
			setStyle("LoggedInUser","visible","false");
			setStyle("USER_BRANCH","visible","true");
			setStyle("ServiceType","visible","false");
			setStyle("CreditCardNo1","visible","false");
			setStyle("Refresh","visible","false");
			setStyle("CD","visible","false");
			setStyle("DecisionFrame","visible","false");
			setStyle("Buttons","visible","false")
			setStyle("VD_TIN_Check","disable","true");
			setStyle("VD_MoMaidN_Check","disable","true");
			setStyle("VD_POBox_Check","disable","true");
			setStyle("VD_TELNO_Check","disable","true");
			setStyle("VD_PassNo_Check","disable","true");
			setStyle("VD_MRT_Check","disable","true");
			setStyle("VD_Oth_Check","disable","true");
			setStyle("VD_SD_Check","disable","true");
			setStyle("VD_EDC_Check","disable","true");
			setStyle("VD_StaffId_Check","disable","true");
			setStyle("VD_DOB_Check","disable","true");
			setStyle("VD_NOSC_Check","disable","true");
			setStyle("BTD_OBC_CT","disable","true");
			setStyle("BTD_OBC_OBN","disable","true");
			setStyle("BTD_OBC_OBNO","disable","true");
			setStyle("BTD_OBC_OBCNO","disable","true");
			setStyle("BTD_OBC_DT","disable","true");
			setStyle("BTD_OBC_BN","disable","true");
			setStyle("BTD_OBC_NOOC","disable","true");
			setStyle("BTD_RBC_RBCN11","disable","true");
			setStyle("BTD_RBC_RBCN22","disable","true");
			setStyle("BTD_RBC_RBCN33","disable","true");
			setStyle("BTD_RBC_CT1","disable","true");
			setStyle("BTD_RBC_CT2","disable","true");
			setStyle("BTD_RBC_CT3","disable","true");
			setStyle("BTD_RBC_ExpD1","disable","true");
			setStyle("BTD_RBC_ExpD2","disable","true");
			setStyle("BTD_RBC_ExpD3","disable","true");
			setStyle("BTD_RBC_BTA1","disable","true");
			setStyle("BTD_RBC_BTA2","disable","true");
			setStyle("BTD_RBC_BTA3","disable","true");
			setStyle("BTD_RBC_AppC1","disable","true");
			setStyle("BTD_RBC_AppC2","disable","true");
			setStyle("BTD_RBC_AppC3","disable","true");
			setStyle("BTD_RBC_RR","disable","true");
			setStyle("BA_Decision","disable","false");
			setStyle("BA_Remarks","disable","false");
			if(getValue("BTD_OBC_OBN")=='Others')
			{
				setControlValue("BTD_OBC_OBNO","disable","false");
			}
			else 
			{
				setStyle("BTD_OBC_OBNO","disable","true");
			}
			if(getValue("BTD_OBC_DT")=='Bank')
			{
				setStyle("BTD_OBC_BN","disable","false");
			}
			else 
			{
				setStyle("BTD_OBC_BN","disable","true");
			}
		}
	}

	
function setValuesOnload(user)
{
	//alert("Inside setValuesOnload"+user);
	/* if(ActivityName=='Work Introduction')
	{
		if(getValue("CCI_CrdtCN")!='')
		{
       var creditVal=getValue("CCI_CrdtCN");
	  
	   setControlValue("CreditCardNo1","(creditVal.substring(0, 4) + "-" + creditVal.substring(4, 8) + "-" + creditVal.substring(8, 12) + "-" + creditVal.substring(12))");
	}
	} */
	if(ActivityName=='CARDS')
	{
		setControlValue("Card_UserName",user);
		setControlValue("UserName",user);
		setValue("Cards_Decision","");
		setValue("Cards_Remarks","");
		//setControlValue("LabelBranch","Branch: "+getValue("User_Branch"));
	     //setControlValue("Card_UserName","Branch: "+getValue("user"));
		 //var currentTime = new Date();
	    // setControlValue("Card_DateTime",currentTime.toLocaleString());
		//setControlValue("DateTime",currentTime.toLocaleString());
		 setControlValue("Card_DateTime",getTodayDate());
		//setControlValue("DateTime",currentTime.toLocaleDateString());
		var cardsFrmValue = ("Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));
		 setValue("Cardsfrm",cardsFrmValue);
		setStyle("Card_UserName","visible","true");
		setStyle("Card_DateTime","visible","true");
		//alert("Inside sol load");
	
	}
	
	if(ActivityName=='Branch_Approver')
	{	
		setControlValue("BA_UserName",user);
		setControlValue("UserName",user);
		//setControlValue("LabelBranch","Branch: "+getValue("User_Branch"));
	     //setControlValue("Card_UserName","Branch: "+getValue("user"));
		//var currentTime = new Date();
	    //setControlValue("BA_DateTime",currentTime.toLocaleDateString());
	// setControlValue("DateTime",currentTime.toLocaleDateString());
		setStyle("BA_UserName","visible","false");
		setStyle("BA_DateTime","visible","false");
		setValue("BA_Decision","");
		setValue("BA_Remarks","");
	
	}
	
	if(ActivityName=='Pending' || ActivityName=='Branch_Return')
	{	
	    
		setControlValue("BU_UserName",user);
		setControlValue("UserName",user);
		//setControlValue("LabelBranch","Branch: "+getValue("User_Branch"));
	     //setControlValue("Card_UserName","Branch: "+getValue("user"));
		// var currentTime = new Date();
	    //setControlValue("BA_DateTime",getTodayDate());
		// setControlValue("DateTime",currentTime.toLocaleDateString());
	   //setControlValue("LabelBranch","Branch: "+getValue("User_Branch"));
		setValue("Cardsfrm","Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));
		setStyle("BU_UserName","visible","false");
	    setStyle("BU_DateTime","visible","true");
		setStyle("Card_UserName","visible","true");
		setStyle("Card_DateTime","visible","true");
		if ((getValue("BTD_RBC_RBCN1").length==16)||(getValue("BTD_RBC_RBCN1").length==15)){
				var temp_car_value1 = getValue("BTD_RBC_RBCN1").substring(0,4)+ '-' + getValue("BTD_RBC_RBCN1").substring(4,8)+ '-' + getValue("BTD_RBC_RBCN1").substring(8,12)+ '-' + getValue("BTD_RBC_RBCN1").substring(12);
				setControlValue("BTD_RBC_RBCN11",temp_car_value1);
		}
		if ((getValue("BTD_RBC_RBCN2").length==16)||(getValue("BTD_RBC_RBCN2").length==15)){
			var temp_car_value2 = getValue("BTD_RBC_RBCN2").substring(0,4)+ '-' + getValue("BTD_RBC_RBCN2").substring(4,8)+ '-' + getValue("BTD_RBC_RBCN2").substring(8,12)+ '-' + getValue("BTD_RBC_RBCN2").substring(12);
			setControlValue("BTD_RBC_RBCN22",temp_car_value2);
		}
		if ((getValue("BTD_RBC_RBCN2").length==16)||(getValue("BTD_RBC_RBCN3").length==15)){
			var temp_car_value3 = getValue("BTD_RBC_RBCN3").substring(0,4)+ '-' + getValue("BTD_RBC_RBCN3").substring(4,8)+ '-' + getValue("BTD_RBC_RBCN3").substring(8,12)+ '-' + getValue("BTD_RBC_RBCN3").substring(12);
			setControlValue("BTD_RBC_RBCN33",temp_car_value2);
		}
	}
	 if (ActivityName=='Work Exit' || ActivityName=='Discard' || ActivityName=='Query' )
	  {
	   
		setControlValue("BU_UserName",user);
		setControlValue("UserName",user);
		//setControlValue("LabelBranch","Branch: "+getValue("User_Branch"));
	     //setControlValue("Card_UserName","Branch: "+getValue("user"));
		 var currentTime = new Date();
	     //setControlValue("BU_DateTime",currentTime.toLocaleDateString());
		 //setControlValue("DateTime",currentTime.toLocaleDateString());
	  // setControlValue("LabelBranch","Branch: "+getValue("User_Branch"));
		setValue("Cardsfrm","Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));
		 setStyle("BU_UserName","visible","true");
	    setStyle("BU_DateTime","visible","false");
	  }
}


function callPrintJSPCSRBT(params)
{
	var mobNoClearTxt = getValue('CCI_MONO');
	var cardNoClearTxt = getValue('CCI_CrdtCN');
	var othCardNoClearTxt = getValue('BTD_OBC_OBCNO');
	params = params+"&" + "mobNoClearTxt=" + mobNoClearTxt+"&" + "cardNoClearTxt=" + cardNoClearTxt+"&" + "othCardNoClearTxt=" + othCardNoClearTxt;
	var strUrl="/CSR_BT/CSR_BT/CustomJSP/PrintBT.jsp?"+params;
	//alert("params :"+params+" strUrl :"+strUrl);
	var sOptions = 'dialogWidth:1300px; dialogHeight:600px; dialogLeft:450px; dialogTop:100px; status:no; scroll:yes; scrollbar:yes; help:no; resizable:no';
	var windowParams="height=600px,width=1300px,toolbar=no,directories=no,status=no,scrollbars=yes,resizable=no,modal=yes,addressbar=no,menubar=no";
	var popupWindow="";
	if (window.showModalDialog) {
		popupWindow = window.showModalDialog(strUrl, null, sOptions);
	}else{
		popupWindow = window.open(strUrl, null, windowParams);
	}				
	//var popupWindow = window.open(strUrl, null, sOptions);
	//var popupWindow = window.showModalDialog(strUrl, null, sOptions);
}

function getTodayDate()
{
	var today = new Date();
	var dd = String("0" + (today.getDate())).slice(-2); //Fix for IE
	var mm = String("0" + (today.getMonth() +1)).slice(-2); //January is 0! //Fix for IE
	var yyyy = today.getFullYear();
	today = dd + '/' + mm + '/' + yyyy;
	return today;
}
	
/*function loadSolId()
{
	
	var solId = executeServerEvent("SolId","FormLoad",user,true).trim();
	setControlValue("Sol_Id",solId);
}

function populateDecisionDropDown()
{
	var response=executeServerEvent("DecisionDropDown","FormLoad","",true);
	
	if (ActivityName == 'OPS_Maker' || ActivityName == 'OPS_Checker')
	{
		if(getValue("WI_ORIGIN")=="Third_Party")
		{
			var x = document.getElementById("DECISION");
			for (var i = 0; i < x.options.length; i++) 
			{
				if(x.options[i].value=='Reject to Initiator')
				{
					x.options[i].disabled = true;
				}
			}
		}
		if(getValue("WI_ORIGIN")!="Third_Party")
		{
			var x = document.getElementById("DECISION");
			for (var i = 0; i < x.options.length; i++) 
			{
				if(x.options[i].value=='Reject')
				{
					x.options[i].disabled = true;
				}
			}
		}	
		
	}
}

function enableDisableAfterFormLoad()
{
	if(ActivityName!="Initiation")
	{	
	    setStyle("CORPORATE_CIF","disable","true");
		setStyle("REQUEST_BY_SIGNATORY_CIF","disable","true");
	
	}
	
	if(ActivityName=="OPS_Maker" && getValue("WI_ORIGIN")=="Third_Party")
	{		
		setStyle("REQUEST_FOR_CIF","disable","true");
		//setStyle("ACCOUNT_NUMBER","disable","true");
		//setStyle("SCHEME_TYPE","disable","true");
		//setStyle("SCHEME_CODE","disable","true");
		//setStyle("IS_RETAIL_CUSTOMER","disable","true");
		setStyle("GENDER","disable","true");
		setStyle("DATE_OF_BIRTH","disable","true");
		setStyle("TITLE","disable","true");
		setStyle("FIRST_NAME","disable","true");
		setStyle("MIDDLE_NAME","disable","true");
		setStyle("LAST_NAME","disable","true");
		setStyle("MOTHERS_MAIDEN_NAME","disable","true");
		setStyle("COUNTRY_OF_RESIDENCE","disable","true");
		setStyle("NATIONALITY","disable","true");
		setStyle("EMIRATES_ID","disable","true");
		setStyle("PASSPORT_NUMBER","disable","true");
		setStyle("VISA_UID_NUMBER","disable","true");
		setStyle("CARD_EMBOSSING_NAME","disable","true");
		setStyle("EMAIL_ID","disable","true");
		setStyle("MOB_NUMBER_COUNTRY_CODE","disable","true");
		setStyle("MOBILE_NUMBER","disable","true");	
	
	}
	
	if(ActivityName!="OPS_Maker")
	{	
			setStyle("REQUEST_FOR_CIF","disable","true");
			setStyle("ACCOUNT_NUMBER","disable","true");
			setStyle("SCHEME_TYPE","disable","true");
			setStyle("SCHEME_CODE","disable","true");
			setStyle("IS_RETAIL_CUSTOMER","disable","true");
			setStyle("GENDER","disable","true");
			setStyle("DATE_OF_BIRTH","disable","true");
			setStyle("TITLE","disable","true");
			setStyle("FIRST_NAME","disable","true");
			setStyle("MIDDLE_NAME","disable","true");
			setStyle("LAST_NAME","disable","true");
			setStyle("MOTHERS_MAIDEN_NAME","disable","true");
			setStyle("COUNTRY_OF_RESIDENCE","disable","true");
			setStyle("NATIONALITY","disable","true");
			setStyle("EMIRATES_ID","disable","true");
			setStyle("PASSPORT_NUMBER","disable","true");
			setStyle("VISA_UID_NUMBER","disable","true");
			setStyle("CARD_EMBOSSING_NAME","disable","true");
			setStyle("EMAIL_ID","disable","true");
			setStyle("MOB_NUMBER_COUNTRY_CODE","disable","true");
			setStyle("MOBILE_NUMBER","disable","true");
	}
}*/
