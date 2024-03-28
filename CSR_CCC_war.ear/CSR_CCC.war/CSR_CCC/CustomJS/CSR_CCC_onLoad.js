var CSR_CCC_Common = document.createElement('script');
CSR_CCC_Common.src = '/CSR_CCC/CSR_CCC/CustomJS/CSR_CCC_Common.js';
document.head.appendChild(CSR_CCC_Common);

function loadSolId()
{
	var solId = executeServerEvent("SolId","FormLoad",user,true).trim();
	setControlValue("Sol_Id",solId);
}


function lockCAPSFrm() 
{
	setStyle("CCI_CName","disable","false");
	setStyle("CCI_ExpD","disable","false");
	setStyle("CCI_CrdtCN","disable","false");
	setStyle("CCI_CCRNNo","disable","false");
	setStyle("CCI_MONO","disable","false");
	setStyle("CCI_AccInc","disable","false");
	setStyle("CCI_CT","disable","false");
	setStyle("CCI_CAPS_GENSTAT","disable","false");
	setStyle("CCI_ELITECUSTNO","disable","false");
	
}

function clrCAPSFrm()
{
	setValue("CCI_CName", "");
	setValue("CCI_ExpD", "");
	setValue("CCI_ExpD", "");
	setValue("CCI_CrdtCN", "");
	setValue("CCI_CCRNNo", "");
	setValue("CCI_MONO", "");
	setValue("CCI_AccInc", "");
	setValue("CCI_CT", "");
	setValue("CCI_CAPS_GENSTAT", "");
	setValue("CCI_ELITECUSTNO", "");
	setValue("CCI_SC", "");
	setValue("BANEFICIARY_NAME", "");
	setValue("REMARKS", "");
	setValue("DELIVERTO", "");
	setValue("BRANCH", "");
	setValue("BRANCHCODE", "");
}

function clrValidationFrm()
{
   setValue("VD_DOB","N");
   setValue("VD_StaffId","N");
   setValue("VD_POBox","N");
   setValue("VD_PassNo","N");
   setValue("VD_Oth","N");
   setValue("VD_MRT","N");
   setValue("VD_EDC","N");
   setValue("VD_NOSC","N");
   setValue("VD_TELNO","N");
   setValue("VD_SD","N");
   setValue("VD_MoMaidN","N");
   
   
   setControlValue("VD_DOB_Check", "false");
	setControlValue("VD_StaffId_Check", "false");
	setControlValue("VD_POBox_Check", "false");
	setControlValue("VD_PassNo_Check", "false");
	setControlValue("VD_Oth_Check", "false");
	setControlValue("VD_MRT_Check", "false");
	setControlValue("VD_EDC_Check", "false");
	setControlValue("VD_NOSC_Check", "false");
	setControlValue("VD_TELNO_Check", "false");
	setControlValue("VD_SD_Check", "false");
	setControlValue("VD_MoMaidn_Check", "false");
}
function lockValidationFrm(paramString)
{
  if (paramString == true)
	{
		setStyle("VD_TIN_Check","disable","true");
		setStyle("VD_DOB_Check","disable","false");
		setStyle("VD_StaffId_Check","disable","false");
		setStyle("VD_POBox_Check","disable","false");
		setStyle("VD_PassNo_Check","disable","false");
		setStyle("VD_MoMaidN_Check","disable","false");
		setStyle("VD_MRT_Check","disable","false");
		setStyle("VD_EDC_Check","disable","false");
		setStyle("VD_NOSC_Check","disable","false");
		setStyle("VD_TELNO_Check","disable","false");
		setStyle("VD_SD_Check","disable","false");
	}
	else
	{
		setStyle("VD_TIN_Check","disable","false");
		setStyle("VD_DOB_Check","disable","true");
		setStyle("VD_StaffId_Check","disable","true");
		setStyle("VD_POBox_Check","disable","true");
		setStyle("VD_PassNo_Check","disable","true");
		setStyle("VD_MoMaidN_Check","disable","true");
		setStyle("VD_MRT_Check","disable","true");
		setStyle("VD_EDC_Check","disable","true");
		setStyle("VD_NOSC_Check","disable","true");
		setStyle("VD_TELNO_Check","disable","true");
		setStyle("VD_SD_Check","disable","true");
	}
}

function lockOnLoadCCCDetailsFrm()
{
	if(getValue("DELIVERTO")!=null && getValue("DELIVERTO")=='Bank')
	{
		setStyle("BRANCH","disable","false");
	}
	else 
	{
		setStyle("BRANCH","disable","true");
	}

	setStyle("CARDTYPE1","disable","true");
	setStyle("CARDTYPE2","disable","true");
	setStyle("CARDTYPE3","disable","true");
	setStyle("CARDEXPIRY_DATE1","disable","true");
	setStyle("CARDEXPIRY_DATE2","disable","true");
	setStyle("CARDEXPIRY_DATE3","disable","true");
	
	
	if(getValue("CARD1")!=null && getValue("CARD1")!="")
	{
		setStyle("CHQ_AMOUNT1","disable","false");
		setStyle("ApprovalCode1","disable","false");
	}
	else
	{
		setStyle("CHQ_AMOUNT1","disable","true");
		setStyle("ApprovalCode1","disable","true");
	}

	if(getValue("CARD2")!=null && getValue("CARD2")!="")
	{
		setStyle("CHQ_AMOUNT2","disable","false");
		setStyle("ApprovalCode2","disable","false");
	}
	else
	{
		setStyle("CHQ_AMOUNT2","disable","true");
		setStyle("ApprovalCode2","disable","true");
	}
	
    if(getValue("CARD3")!=null && getValue("CARD3")!="")
	{
		setStyle("CHQ_AMOUNT3","disable","false");
		setStyle("ApprovalCode3","disable","false");
	}
	else
	{
		setStyle("CHQ_AMOUNT3","disable","true");
		setStyle("ApprovalCode3","disable","true"); 
	}
}


function enableDisableAfterFormLoad()
{
	if(ActivityName=="Work Introduction")
	{	
		setStyle("hiddenSection","visible","false");
		setStyle("printSection","visible","false");
		setStyle("Cards_Details","visible","false");
		setStyle("BA_Details","visible","false");
		setStyle("Pending_Section","visible","false");
		
		if(getValue("CCI_CrdtCN")=="")
		{
			setStyle("frame3","visible","false"); //credit caps
			setStyle("frame19","visible","false");// verification details
			setStyle("frame23","visible","false"); // decision
			setStyle("frame21","visible","false"); // branch approver
			setStyle("frame22","visible","false"); // card details
		}
		else
		{
			var str5 = getValue("CCI_CrdtCN");
			//setControlValue("CardNo", str5.substring(0, 4) + "-" + str5.substring(4, 8) + "-" + str5.substring(8, 12) + "-" + str5.substring(12));	 // credit card number intialize
		}
	}
	if (ActivityName=="Pending")
	{	 
		setStyle("CCI_CName","disable","true");
		setStyle("CCI_ExpD","disable","true");
		setStyle("CCI_CrdtCN","disable","false");
		setStyle("CCI_ExtNo","disable","false");
		setStyle("CCI_CT","disable","true");
		setStyle("CCI_MONO","disable","true");
		setStyle("CCI_SC","disable","false");
		setStyle("CCI_CAPS_GENSTAT","disable","true");
		setStyle("CCI_ELITECUSTNO","disable","true");
		setStyle("CCI_CCRNNo","disable","true");
		setStyle("CCI_AccInc","disable","true");
		
		setStyle("CARDTYPE1","disable","true");
		setStyle("CARDTYPE2","disable","true");
		setStyle("CARDTYPE3","disable","true");
		setStyle("CARDEXPIRY_DATE1","disable","true");
		setStyle("CARDEXPIRY_DATE2","disable","true");
		setStyle("CARDEXPIRY_DATE3","disable","true");
		setStyle("REMARKS","disable","false");
		
		//setStyle("frame3","visible","false"); 
		setStyle("Pending_Section","visible","true");
		setStyle("BA_Details","visible","false");
		setStyle("Cards_Details","visible","false");
		setStyle("printSection","visible","false");
		//setStyle("CardsFrm","visible","false"); 
		
		if(getValue("CARDNO1")!="")
			setStyle("CARD1","disable","false");
		else
			setStyle("CARD1","disable","true");
		
		if(getValue("CARDNO2")!="")
			setStyle("CARD2","disable","false");
		else
			setStyle("CARD2","disable","true");
		
		if(getValue("CARDNO3")!="")
			setStyle("CARD3","disable","false");
		else
			setStyle("CARD3","disable","true");
		
		var RakBankCard = executeServerEvent("RakBankCard","FormLoad","",true);
		//setValue("CARD1",getValue("CARDNO1"));
		//setValue("CARD2",getValue("CARDNO2"));
		//setValue("CARD3",getValue("CARDNO3"));	
		setStyle("frame23","disable","true"); // DECISION
		setStyle("frame21","disable","true");  // BRANCH APPROVER
		setStyle("frame22","disable","true");  // CARD DETAILS
		setStyle("buttonsSection","visible","false"); // BUTTONS SECTION
	}
	if (ActivityName=="Branch_Approver")
	{	
		//set values 
		/*this.formObject.setNGValue("CSR_CCC_BA_USERNAME", str1);
          this.formObject.setNGValue("CSR_CCC_BA_DATETIME", localSimpleDateFormat.format(localDate));*/
		setControlValue("BA_UserName",user);
		//var currentTime = new Date();
	    setControlValue("BA_DateTime", getTodayDate());		
		setStyle("frame3","visible","false"); 
		setStyle("BA_Details","visible","true");
		setStyle("Cards_Details","visible","false");
		setStyle("Pending_Section","visible","false");
		setStyle("printSection","visible","false");
		setStyle("buttonsSection","visible","false");
		setStyle("Credit_Section","disable","true");
		
		// writeToConsole("Aishwarya1::" + str2 + " - " + this.formObject.getNGValue("CSR_CCC_CCI_CrdtCN"));
		
		setStyle("CCI_CName","disable","true");
		setStyle("CCI_ExpD","disable","true");
		setStyle("CCI_CrdtCN","disable","true");
		setStyle("CCI_CCRNNo","disable","true");
		
		setStyle("CCI_CT","disable","true");
		setStyle("CCI_MONO","disable","true");
		setStyle("CCI_SC","disable","true");
		setStyle("CCI_CAPS_GENSTAT","disable","true");
		setStyle("CCI_ELITECUSTNO","disable","true");
		setStyle("CCI_CCRNNo","disable","true");
		setStyle("CCI_AccInc","disable","true");
		setStyle("CCI_ExtNo","disable","true");
		
		setStyle("BANEFICIARY_NAME","disable","true");
		setStyle("DELIVERTO","disable","true");
		setStyle("BRANCHCODE","disable","true");
		//setStyle("CARD1","disable","true");
		//setStyle("CARD2","disable","true");
		//setStyle("CARD3","disable","true");
		setStyle("CARDTYPE1","disable","true");
		setStyle("CARDTYPE2","disable","true");
		setStyle("CARDTYPE3","disable","true");
		setStyle("CARDEXPIRY_DATE1","disable","true");
		setStyle("CARDEXPIRY_DATE2","disable","true");
		setStyle("CARDEXPIRY_DATE3","disable","true");
		setStyle("CHQ_AMOUNT1","disable","true");
		setStyle("CHQ_AMOUNT2","disable","true");
		setStyle("CHQ_AMOUNT3","disable","true");
		setStyle("ApprovalCode1","disable","true");
		setStyle("ApprovalCode2","disable","true");
		setStyle("ApprovalCode3","disable","true");
		setStyle("REMARKS","disable","true");
		//setValue("BA_Remarks","");
		//setValue("BA_Decision","");
		
		//setStyle("VD_TINCHECK","disable","true");
		//setStyle("VD_MoMaidN","disable","true");
		//setStyle("VD_StaffId","disable","true");
		//setStyle("VD_DOB","disable","true");
		//setStyle("VD_POBox","disable","true");
		//setStyle("VD_PassNo","disable","true");
		//setStyle("VD_Oth","disable","true");
		//setStyle("VD_MRT","disable","true");
		//setStyle("VD_EDC","disable","true");
		//setStyle("VD_NOSC","disable","true");
		//setStyle("VD_TELNO","disable","true");
		//setStyle("VD_SD","disable","true");
		
		setStyle("VD_TIN_Check","disable","true");
		setStyle("VD_DOB_Check","disable","true");
		setStyle("VD_StaffId_Check","disable","true");
		setStyle("VD_POBox_Check","disable","true");
		setStyle("VD_PassNo_Check","disable","true");
		setStyle("VD_Oth_Check","disable","true");
		setStyle("VD_MRT_Check","disable","true");
		setStyle("VD_EDC_Check","disable","true");
		setStyle("VD_NOSC_Check","disable","true");
		setStyle("VD_TELNO_Check","disable","true");
		setStyle("VD_SD_Check","disable","true");
		setStyle("VD_MoMaidN_Check","disable","true");
		
		lockOnLoadCCCDetailsFrm();
		var RakBankCard = executeServerEvent("RakBankCard","FormLoad","",true);
		setStyle("CARD1","disable","true");
		setStyle("CARD2","disable","true");
		setStyle("CARD3","disable","true");
		//setValue("CARD1",getValue("CARDNO1"));
		//setValue("CARD2",getValue("CARDNO2"));
		//setValue("CARD3",getValue("CARDNO3"));	
		
		/*if(getValue("CARDNO1")!="")
			setStyle("CARD1","disable","false");
		else
			setStyle("CARD1","disable","true");
		
		if(getValue("CARDNO2")!="")
			setStyle("CARD2","disable","false");
		else
			setStyle("CARD2","disable","true");
		
		if(getValue("CARDNO3")!="")
			setStyle("CARD3","disable","false");
		else
			setStyle("CARD3","disable","true");*/
		
		//alert("Cards:"+getValue("CARDNO1")+getValue("CARDNO2")+getValue("CARDNO3"));
    }
    if (ActivityName=="CARDS")
	{
		//set value condition
		setControlValue("Card_UserName",user);
		//var currentTime = new Date();
		setControlValue("Card_DateTime", getTodayDate());
		setStyle("BA_Details","visible","true");
		setStyle("BA_DateTime","visible","true");
		setStyle("Card_UserName","visible","true");
		setStyle("Card_DateTime","visible","true");
		setStyle("CCI_CName","disable","true");
		setStyle("CCI_ExpD","disable","true");
		setStyle("CCI_CrdtCN","disable","true");
		setStyle("CCI_CCRNNo","disable","true");
		
		setStyle("CCI_CT","disable","true");
		setStyle("CCI_MONO","disable","true");
		setStyle("CCI_SC","disable","true");
		setStyle("CCI_CAPS_GENSTAT","disable","true");
		setStyle("CCI_ELITECUSTNO","disable","true");
		setStyle("CCI_AccInc","disable","true");
		setStyle("CCI_ExtNo","disable","true");
		
		setStyle("BANEFICIARY_NAME","disable","true");
		setStyle("DELIVERTO","disable","true");
		setStyle("BRANCH","disable","true");
		//setStyle("CARD1","disable","true");
		//setStyle("CARD2","disable","true");
		//setStyle("CARD3","disable","true");
		setStyle("CARDTYPE1","disable","true");
		setStyle("CARDTYPE2","disable","true");
		setStyle("CARDTYPE3","disable","true");
		setStyle("CARDEXPIRY_DATE1","disable","true");
		setStyle("CARDEXPIRY_DATE2","disable","true");
		setStyle("CARDEXPIRY_DATE3","disable","true");
		setStyle("CHQ_AMOUNT1","disable","true");
		setStyle("CHQ_AMOUNT2","disable","true");
		setStyle("CHQ_AMOUNT3","disable","true");
		setStyle("ApprovalCode1","disable","true");
		setStyle("ApprovalCode2","disable","true");
		setStyle("ApprovalCode3","disable","true");
		setStyle("REMARKS","disable","true");
		
		setStyle("VD_TIN_Check","disable","true");
		setStyle("VD_DOB_Check","disable","true");
		setStyle("VD_StaffId_Check","disable","true");
		setStyle("VD_POBox_Check","disable","true");
		setStyle("VD_PassNo_Check","disable","true");
		setStyle("VD_Oth_Check","disable","true");
		setStyle("VD_MRT_Check","disable","true");
		setStyle("VD_EDC_Check","disable","true");
		setStyle("VD_NOSC_Check","disable","true");
		setStyle("VD_TELNO_Check","disable","true");
		setStyle("VD_SD_Check","disable","true");
		setStyle("VD_MoMaidN_Check","disable","true");
		
		//some condition added
		var RakBankCard = executeServerEvent("RakBankCard","FormLoad","",true);
		setStyle("CARD1","disable","true");
		setStyle("CARD2","disable","true");
		setStyle("CARD3","disable","true");
		//setValue("CARD1",getValue("CARDNO1"));
		//setValue("CARD2",getValue("CARDNO2"));
		//setValue("CARD3",getValue("CARDNO3"));	
		setStyle("BA_Remarks","disable","true");
		//setValue("Cards_Remarks","");
		//setValue("Cards_Decision","");
		
		lockOnLoadCCCDetailsFrm();
		
		setStyle("CCI_AccInc","disable","true");
		
		setStyle("BA_Details","visible","true");
		setStyle("BA_Details","disable","true");
		setStyle("Cards_Details","visible","true");
		setStyle("Pending_Section","visible","false");
		setStyle("printSection","visible","true");
		setStyle("buttonsSection","visible","false");
		setStyle("Credit_Section","disable","true");
		
		/*if(getValue("CARDNO1")!="")
			setStyle("CARD1","disable","false");
		else
			setStyle("CARD1","disable","true");
		
		if(getValue("CARDNO2")!="")
			setStyle("CARD2","disable","false");
		else
			setStyle("CARD2","disable","true");
		
		if(getValue("CARDNO3")!="")
			setStyle("CARD3","disable","false");
		else
			setStyle("CARD3","disable","true");*/
	}
	if (ActivityName=="Branch_Return")
	{
		setStyle("BA_Details","visible","true");
		setStyle("BA_Details","disable","true");
		setStyle("Cards_Details","disable","true");
		setStyle("Cards_Details","visible","true");
		setStyle("Pending_Section","visible","false");
		setStyle("printSection","visible","false");
		setStyle("buttonsSection","visible","false");
		
        //writeToConsole("Aishwarya1::" + str2 + " - " + this.formObject.getNGValue("CSR_CCC_CCI_CrdtCN"));
		setStyle("CCI_CName","disable","true");
		setStyle("CCI_ExpD","disable","true");
		setStyle("CCI_CrdtCN","disable","true");
		setStyle("CCI_CCRNNo","disable","true");
		
		setStyle("CCI_MONO","disable","true");
		setStyle("CCI_AccInc","disable","true");
		setStyle("CCI_CT","disable","true");
		setStyle("CCI_CAPS_GENSTAT","disable","true");
		setStyle("CCI_ELITECUSTNO","disable","true");
		
		var RakBankCard = executeServerEvent("RakBankCard","FormLoad","",true);
		setStyle("CARD1","disable","true");
		setStyle("CARD2","disable","true");
		setStyle("CARD3","disable","true");
		//setValue("CARD1",getValue("CARDNO1"));
		//setValue("CARD2",getValue("CARDNO2"));
		//setValue("CARD3",getValue("CARDNO3"));	
		
		/*if(getValue("CARDNO1")!="")
			setStyle("CARD1","disable","false");
		else
			setStyle("CARD1","disable","true");
		
		if(getValue("CARDNO2")!="")
			setStyle("CARD2","disable","false");
		else
			setStyle("CARD2","disable","true");
		
		if(getValue("CARDNO3")!="")
			setStyle("CARD3","disable","false");
		else
			setStyle("CARD3","disable","true");*/
		
		if(getValue("DELIVERTO")!=null && getValue("DELIVERTO")=='Bank')
		{
			setStyle("BRANCH","disable","false");
		}
		else 
		{
			setStyle("BRANCH","disable","true");
		}	
		
		if(getValue("CARDNO1")!=null && getValue("CARDNO1")!="")
		{
			setStyle("CHQ_AMOUNT1","disable","false");
			setStyle("ApprovalCode1","disable","false");
		}
		else
		{
			setStyle("CHQ_AMOUNT1","disable","true");
			setStyle("ApprovalCode1","disable","true");
		}

		if(getValue("CARDNO2")!=null && getValue("CARDNO2")!="")
		{
			setStyle("CHQ_AMOUNT2","disable","false");
			setStyle("ApprovalCode2","disable","false");
		}
		else
		{
			setStyle("CHQ_AMOUNT2","disable","true");
			setStyle("ApprovalCode2","disable","true");
		}
		if(getValue("CARDNO3")!=null && getValue("CARDNO3")!="")
		{
			setStyle("CHQ_AMOUNT3","disable","false");
			setStyle("ApprovalCode3","disable","false");
		}
		else
		{
			setStyle("CHQ_AMOUNT3","disable","true");
			setStyle("ApprovalCode3","disable","true"); // cCCCC
		}
	}		
	if((ActivityName == "Work Exit1") || (ActivityName == "Discard") || (ActivityName == "Query"))
	{
		setStyle("BA_Details","disable","true");
		setStyle("Cards_Details","disable","true");
		setStyle("Credit_Section","disable","true");
		setStyle("CCC_Details","disable","true");
		setStyle("Verification_Details","disable","true");
		setStyle("Pending_Section","disable","true");
		setStyle("buttonsSection","disable","true");
		setStyle("printSection","disable","true");
		setStyle("hiddenSection","disable","true");
		
		setStyle("VD_TIN_Check","disable","true");
		setStyle("VD_DOB_Check","disable","true");
		setStyle("VD_StaffId_Check","disable","true");
		setStyle("VD_POBox_Check","disable","true");
		setStyle("VD_PassNo_Check","disable","true");
		setStyle("VD_Oth_Check","disable","true");
		setStyle("VD_MRT_Check","disable","true");
		setStyle("VD_EDC_Check","disable","true");
		setStyle("VD_NOSC_Check","disable","true");
		setStyle("VD_TELNO_Check","disable","true");
		setStyle("VD_SD_Check","disable","true");
		setStyle("VD_MoMaidN_Check","disable","true");
		
		var RakBankCard = executeServerEvent("RakBankCard","FormLoad","",true);
		setStyle("CARD1","disable","true");
		setStyle("CARD2","disable","true");
		setStyle("CARD3","disable","true");
		//setValue("CARD1",getValue("CARDNO1"));
		//setValue("CARD2",getValue("CARDNO2"));
		//setValue("CARD3",getValue("CARDNO3"));

		/*if(getValue("CARDNO1")!="")
			setStyle("CARD1","disable","false");
		else
			setStyle("CARD1","disable","true");
		
		if(getValue("CARDNO2")!="")
			setStyle("CARD2","disable","false");
		else
			setStyle("CARD2","disable","true");
		
		if(getValue("CARDNO3")!="")
			setStyle("CARD3","disable","false");
		else
			setStyle("CARD3","disable","true");	*/	
		
	}
}


function callPrintJSPCSRCCC(params)
{
	
	var mobNoClearTxt = getValue('CCI_MONO');
	var cardNoClearTxt = getValue('CCI_CrdtCN');
	var IntroducedByFrm = getValue('IntroducedBy');
	var ApproveDateTimeFrm = getValue('BA_DateTime');
	params = params+"&" + "mobNoClearTxt=" + mobNoClearTxt+"&" + "cardNoClearTxt=" + cardNoClearTxt + "&" + "IntroducedByFrm=" + IntroducedByFrm + "&" + "ApproveDateTimeFrm=" + ApproveDateTimeFrm;
	
	var strUrl="/CSR_CCC/CSR_CCC/CustomJSP/PrintCCC.jsp?"+params;
	//alert("params :"+params+" strUrl :"+strUrl);
	//window.open(strUrl);
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

function getTodayDate(){
	var today = new Date();
	var dd = String("0" + (today.getDate())).slice(-2); //Fix for IE
	var mm = String("0" + (today.getMonth() +1)).slice(-2); //January is 0! //Fix for IE
	var yyyy = today.getFullYear();
	today = dd + '/' + mm + '/' + yyyy;
	return today;
}








