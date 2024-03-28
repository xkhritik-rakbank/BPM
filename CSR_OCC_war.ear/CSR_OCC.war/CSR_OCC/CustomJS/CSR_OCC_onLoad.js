var Common = document.createElement('script');
Common.src = '/CSR_OCC/CSR_OCC/CustomJS/CSR_OCC_Common.js';
document.head.appendChild(Common);

function loadSolId()
{
	
	var solId = executeServerEvent("SolId","FormLoad",user,true).trim();
	setControlValue("Sol_Id",solId);
}

function lockCAPSFrm() 
{
	setStyle("CCI_CName","disable","true");
	setStyle("CCI_ExpD","disable","true");
	setStyle("CCI_CrdtCN","disable","true");
	setStyle("CCI_CCRNNo","disable","true");
	setStyle("CCI_MONO","disable","true");
	setStyle("CCI_AccInc","disable","true");
	setStyle("CCI_CT","disable","true");
	setStyle("CCI_CAPS_GENSTAT","disable","true");
	setStyle("CCI_ELITECUSTNO","disable","true");
}

function hideFrames(Reqtype,ActivityName,Event)
{
	setStyle("SSC_Section","visible","false");
	setStyle("CS_Section","visible","false");
	setStyle("CDR_Section","visible","false");
	setStyle("CCU_Section","visible","false");
	setStyle("TD_Section","visible","false");
	setStyle("CIS_Section","visible","false");
	setStyle("Button_Section","visible","false");
	setStyle("ECR_Section","visible","false");
	setStyle("CLI_Section","visible","false");
	setStyle("CR_Section","visible","false");
	setStyle("RIP_Section","visible","false");
	setStyle("Hidden_Section","visible","false");
	
	if (ActivityName.toUpperCase().indexOf("INTRODUCTION") > -1)
	{
		//this.formObject.setNGFormHeight(780);
		setStyle("Button_Section","visible","true");
		//setStyle("CR_Section","visible","true");
		//j = 517;
	}
	
	//below code added for testinng in offshore*************************************************
	//alert(" CRWORK :"+ActivityName.indexOf("CRWORK"));
	if(Event == 'OnLoad')
	{
		if (ActivityName.indexOf("CRWORK") > -1)
		{
			setStyle("CR_Section","visible","true");
			setControlValue("request_type","Card Replacement");
			setValue("request_type_label","Card Replacement");
		}
		//alert(" CDRWORK :"+ActivityName.indexOf("CDRWORK"));
		if (ActivityName.indexOf("CDRWORK") > -1)
		{
			setStyle("CDR_Section","visible","true");
			setControlValue("request_type","Card Delivery Request");
			setValue("request_type_label","Card Delivery Request");
		}
		//alert(" SSCWORK :"+ActivityName.indexOf("SSCWORK"));
		if (ActivityName.indexOf("SSCWORK") > -1)
		{
			setStyle("SSC_Section","visible","true");
			setControlValue("request_type","Setup Suppl. Card Limit");
			setValue("request_type_label","Setup Suppl. Card Limit");
		}
		//alert(" CSWORK :"+ActivityName.indexOf("CSWORK"));
		if (ActivityName.indexOf("CSWORK") > -1)
		{
			setStyle("CS_Section","visible","true");
			setControlValue("request_type","Credit Shield");
			setValue("request_type_label","Credit Shield");
		}
		//alert(" ECRWORK :"+ActivityName.indexOf("ECRWORK"));
		if (ActivityName.indexOf("ECRWORK") > -1)
		{
			setStyle("ECR_Section","visible","true");
			setControlValue("request_type","Early Card Renewal");
			setValue("request_type_label","Early Card Renewal");

		}
		//alert(" CUWORK :"+ActivityName.indexOf("CUWORK"));
		if (ActivityName.indexOf("CUWORK") > -1)
		{
			setStyle("CCU_Section","visible","true");
			setControlValue("request_type","Card Upgrade");
			setValue("request_type_label","Card Upgrade");
		}
		//alert(" TDWORK :"+ActivityName.indexOf("TDWORK"));
		if (ActivityName.indexOf("TDWORK") > -1)
		{
			setStyle("TD_Section","visible","true");
			setControlValue("request_type","Transaction Dispute");
			setValue("request_type_label","Transaction Dispute");
		}
		//alert(" CLIWORK :"+ActivityName.indexOf("CLIWORK"));
		if (ActivityName.indexOf("CLIWORK") > -1)
		{
			setStyle("CLI_Section","visible","true");
			setControlValue("request_type","Credit Limit Increase");
			setValue("request_type_label","Credit Limit Increase");
		}
		//alert(" CSIWORK :"+ActivityName.indexOf("CSIWORK"));
		if (ActivityName.indexOf("CSIWORK") > -1)
		{
			setStyle("CIS_Section","visible","true");
			setControlValue("request_type","Change in Standing Instructions");
			setValue("request_type_label","Change in Standing Instructions");
		}
		//alert(" RIPWORK :"+ActivityName.indexOf("RIPWORK"));
		if (ActivityName.indexOf("RIPWORK") > -1)
		{
			setStyle("RIP_Section","visible","true");
			setControlValue("request_type","Re-Issue of PIN");
			setValue("request_type_label","Re-Issue of PIN");
		}
	}
	//*********************************************************************
	
	if(Event == 'OnChange')
	{
		if (Reqtype == "Card Replacement")
		{
		   setStyle("CR_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Setup Suppl. Card Limit")
		{
		   setStyle("SSC_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Credit Shield")
		{
		   setStyle("CS_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Card Delivery Request")
		{
		   setStyle("CDR_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Early Card Renewal")
		{
		   setStyle("ECR_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Card Upgrade")
		{
		   setStyle("CCU_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Transaction Dispute")
		{
		   setStyle("TD_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Credit Limit Increase")
		{
		   setStyle("CLI_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Change in Standing Instructions")
		{
		   setStyle("CIS_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Re-Issue of PIN")
		{
		   setStyle("RIP_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
	}
	
	if (ActivityName.toUpperCase().indexOf("INTRODUCTION") != -1)
	{
	 setStyle("Button_Section","visible","false");
	 setStyle("Branch_Return_Details_Section","visible","false");
	}	
	
	else if (ActivityName.toUpperCase() == "PENDING")
	{
		//this.formObject.setNGControlTop("Pendingfrm", j + 4 + i);
		
		//below changes are made for JIRA PBU-5408 so that remark field is visible.
		
		if (Reqtype == "Card Replacement")
		{
		   setStyle("CR_Section","visible","true");
		   
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Setup Suppl. Card Limit")
		{
		   setStyle("SSC_Section","visible","true");
		   
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Credit Shield")
		{
		   setStyle("CS_Section","visible","true");
		   
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Card Delivery Request")
		{
		   setStyle("CDR_Section","visible","true");
		   
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Early Card Renewal")
		{
		   setStyle("ECR_Section","visible","true");
		   
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Card Upgrade")
		{
		   setStyle("CCU_Section","visible","true");
		   
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Transaction Dispute")
		{
		   setStyle("TD_Section","visible","true");
		   
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Credit Limit Increase")
		{
		   setStyle("CLI_Section","visible","true");
		   
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Re-Issue of PIN")
		{
		   setStyle("RIP_Section","visible","true");
		  
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
	}
	else if (ActivityName.toUpperCase() == "CARDS")
	{
		//this.formObject.setNGControlTop("CardsFrm", j + 4 + i);
		/*if ((getValue("BR_Decision") == null) || (getValue("BR_Decision") == ""))
		{
			//this.formObject.setNGControlTop("PrintFrm", j + 4 + i + 4 + 99);
		}
		else 
		{
			//this.formObject.setNGControlTop("BRFrm", j + 4 + i + 4 + 99);
			//this.formObject.setNGControlTop("PrintFrm", j + 4 + i + 4 + 99 + 4 + 99);
		}*/
		if (Reqtype == "Card Replacement")
		{
		   setStyle("CR_Section","visible","true");
		   setStyle("CR_Section","disable","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Setup Suppl. Card Limit")
		{
		   setStyle("SSC_Section","visible","true");
		   setStyle("SSC_Section","disable","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Credit Shield")
		{
		   setStyle("CS_Section","visible","true");
		   setStyle("CS_Section","disable","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Card Delivery Request")
		{
		   setStyle("CDR_Section","visible","true");
		   setStyle("CDR_Section","disable","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Early Card Renewal")
		{
		   setStyle("ECR_Section","visible","true");
		   setStyle("ECR_Section","disable","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Card Upgrade")
		{
		   setStyle("CCU_Section","visible","true");
		   setStyle("CCU_Section","disable","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Transaction Dispute")
		{
		   setStyle("TD_Section","visible","true");
		   setStyle("TD_Section","disable","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Credit Limit Increase")
		{
		   setStyle("CLI_Section","visible","true");
		   setStyle("CLI_Section","disable","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Change in Standing Instructions")
		{
		   setStyle("CIS_Section","visible","true");
		   setStyle("CIS_Section","disable","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Re-Issue of PIN")
		{
		   setStyle("RIP_Section","visible","true");
		   setStyle("RIP_Section","disable","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
	}
	else if (ActivityName.toUpperCase() == "BRANCH_RETURN")
	{
		//alert("A1");
		//this.formObject.setNGControlTop("CardsFrm", j + 4 + i);
		//this.formObject.setNGControlTop("BRFrm", j + 4 + i + 4 + 99);
		//alert("A2");
		if (Reqtype == "Card Replacement")
		{
		   setStyle("CR_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Setup Suppl. Card Limit")
		{
		   setStyle("SSC_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Credit Shield")
		{
		   setStyle("CS_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Card Delivery Request")
		{
		   setStyle("CDR_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Early Card Renewal")
		{
		   setStyle("ECR_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Card Upgrade")
		{
		   setStyle("CCU_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Transaction Dispute")
		{
		   setStyle("TD_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Credit Limit Increase")
		{
		   setStyle("CLI_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Change in Standing Instructions")
		{
		   setStyle("CIS_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
		else if (Reqtype == "Re-Issue of PIN")
		{
		   setStyle("RIP_Section","visible","true");
			 //this.formObject.setNGControlTop("CISFrm", j);
		}
	}
	else
	{
		//this.formObject.setNGControlTop("CardsFrm", j + 4 + i);
		if (getValue("BR_Decision") == null || getValue("BR_Decision") == "")
			setStyle("Branch_Return_Details_Section","visible","false");
		/*else
			this.formObject.setNGControlTop("BRFrm", j + 4 + i + 4 + 99);*/
	}
}

function enableDisableAfterFormLoad()
{
	if (ActivityName.toUpperCase().indexOf("INTRODUCTION") != -1)
	{
		 //setStyle("CORPORATE_CIF","disable","true");
		//setStyle("REQUEST_BY_SIGNATORY_CIF","disable","true");
	//setControlValue("Username", str1);
		
		setStyle("Pending_Section","visible","false");
		setStyle("Card_Details_Section","visible","false");
		setStyle("Branch_Return_Details_Section","visible","false");
		lockCAPSFrm();
		
		//getValue("Request_Type");
		if (getValue("CCI_CrdtCN") == "")
		{
			setStyle("baseFr2","visible","false");
			setStyle("baseFr3","visible","false");
			setStyle("Frame1","visible","false");
			setStyle("RRDFrm","visible","false");
			setStyle("ProNameFrm","visible","false");
			setStyle("Button_Section","visible","false");
		}
		else
		{
			str5 = getValue("CCI_CrdtCN");
			setControlValue("CardNo_Text", str5.substring(0, 4) + "-" + str5.substring(4, 8) + "-" + str5.substring(8, 12) + "-" + str5.substring(12));

			if (ActivityName == "CRWORK INTRODUCTION")
				setControlValue("request_type", "Card Replacement");
			else if (ActivityName == "SSCWORK INTRODUCTION")
				setControlValue("request_type", "Setup Suppl. Card Limit");
			else if (ActivityName == "CSWORK INTRODUCTION")
				setControlValue("request_type", "Credit Shield");
			else if (ActivityName == "CDRWORK INTRODUCTION")
				setControlValue("request_type", "Card Delivery Request");
			else if (ActivityName == "ECRWORK INTRODUCTION")
				setControlValue("request_type", "Early Card Renewal");
			else if (ActivityName == "CUWORK INTRODUCTION")
				setControlValue("request_type", "Card Upgrade");
			else if (ActivityName == "TDWORK INTRODUCTION")
				setControlValue("request_type", "Transaction Dispute");
			else if (ActivityName == "CLIWORK INTRODUCTION")
				setControlValue("request_type", "Credit Limit Increase");
			else if (ActivityName == "CSIWORK INTRODUCTION")
				setControlValue("request_type", "Change in Standing Instructions");
			else if (ActivityName == "RIPWORK INTRODUCTION") {
				setControlValue("request_type", "Re-Issue of PIN");
			}
			setStyle("request_type","disable","true");

			if (getValue("request_type") == "Change in Standing Instructions")
			{
				if (getValue("oth_csi_PH") == "Y")
				{
					setControlValue("oth_csi_PH_Check", "True");
					setStyle("oth_csi_TOH","disable","false");
					if (getValue("oth_csi_TOH") == "Temporary")
					{
						setStyle("oth_csi_NOM","disable","false");
					}
					else
					{
						setStyle("oth_csi_NOM","disable","true");
					}
				}
				else
				{
					setControlValue("oth_csi_PH_Check", "false");
					setControlValue("oth_csi_TOH", "");
					setStyle("oth_csi_TOH","disable","true");
					setControlValue("oth_csi_NOM", "");
					setStyle("oth_csi_NOM","disable","true");
				}

				if (getValue("oth_csi_CSIP") == "Y")
				{
					setControlValue("oth_csi_CSIP_Check", "True");
					setStyle("oth_csi_POSTMTB","disable","false");
				}
				else
				{
					setControlValue("oth_csi_CSIP_Check", "false");
					setControlValue("oth_csi_POSTMTB", "");
					setStyle("oth_csi_POSTMTB","disable","false");
				}
				if (getValue("oth_csi_CSID") == "Y")
				{
					setControlValue("oth_csi_CSID_Check", "True");
					setStyle("oth_csi_ND","disable","false");
				}
				else
				{
					setControlValue("oth_csi_CSID_Check", "false");
					setControlValue("oth_csi_ND", "");
					setStyle("oth_csi_ND","disable","true");
				}
				if (getValue("oth_csi_CDACNo") == "Y")
				{
					setControlValue("oth_csi_CDACNo_Check", "True");
					setStyle("oth_csi_ACCNO","disable","false");
				}
				else
				{
					setControlValue("oth_csi_CDACNo_Check", "false");
					setControlValue("oth_csi_ACCNO", "");
					setStyle("oth_csi_ACCNO","disable","true");
				}
			}
			else if (getValue("request_type") == "Card Replacement")
			{
				if (getValue("oth_cr_REASON") != "OTHERS")
				{
					setStyle("oth_cr_OPS","disable","true");
				}
				if (getValue("oth_cr_DC") != "BRANCH")
				{
					setStyle("CR_BRANCH","disable","true");
				}
			}
			else if (getValue("request_type") == "Early Card Renewal")
			{
				if (getValue("oth_ecr_DT") != "BRANCH")
				{
					setStyle("ECR_BRANCH","disable","true");
				}
			}
			else if (getValue("request_type") == "Credit Limit Increase")
			{
				if (getValue("oth_cli_type") != "TEMPORARY")
				{
					setStyle("oth_cli_months","disable","true");
				}
			}
			else if (getValue("request_type") == "Card Delivery Request")
			{
				if (getValue("oth_cdr_CDT") != "BANK")
				{
					setStyle("CDR_BRANCH","disable","true");
				}
			}
			else if (getValue("request_type") == "Credit Shield")
			{
				if (getValue("oth_cs_CS") != "UN-ENROLLEMENT")
				{
					setStyle("oth_cs_CSR_Check","disable","true");
					setStyle("oth_cs_Amount_Text","disable","true");
				}
				else if (getValue("oth_cs_CSR") == "Y")
				{
					setStyle("oth_cs_CSR_Check","disable","false");
					setControlValue("oth_cs_CSR_Check", "True");
					setStyle("oth_cs_Amount_Text","disable","false");
				}
				else
				{
					setStyle("oth_cs_CSR_Check","disable","false");
					setControlValue("oth_cs_CSR_Check", "False");
					setControlValue("oth_cs_Amount_Text", "");
					setStyle("oth_cs_Amount_Text","disable","true");
				}

			}
			else if (getValue("request_type") == "Re-Issue of PIN")
			{
				if (getValue("oth_rip_DC") != "BRANCH")
				{
					setStyle("RIP_BRANCH","disable","true");
				}
			}
			else if (getValue("request_type") != "Card Upgrade")
			{
				if (getValue("request_type") != "Transaction Dispute");
			}

		}
	
	     lockValidationFrm(getValue("VD_MoMaidN_Check"));
		 var response = executeServerEvent("setFormDetail","FormLoad","",true);
		 //alert("response :"+response);
		 lockCAPSFrm();
	    }
		else if (ActivityName.toUpperCase() == "PENDING")
		{
			str5 = getValue("CCI_CrdtCN");
			setControlValue("CardNo_Text", str5.substring(0, 4) + "-" + str5.substring(4, 8) + "-" + str5.substring(8, 12) + "-" + str5.substring(12));
			//setControlValue("Label1", getValue("request_type"));
			//alert("Aishwarya1::" + ActivityName + " - " + getValue("CCI_CrdtCN"));
			setStyle("CCI_CName","disable","true");
			setStyle("CCI_ExpD","disable","true");
			setStyle("CCI_ExpD","disable","true");
			//this.formObject.setNGLocked("CCI_CrdtCN", false);
			setStyle("CCI_CrdtCN","disable","true");
			setStyle("CCI_CCRNNo","disable","true");
			setStyle("CCI_ExtNo","disable","false");
			//this.formObject.setNGLocked("CCI_MONO", false);
			setStyle("CCI_MONO","disable","true");
			setStyle("CCI_AccInc","disable","true");
			setStyle("CCI_CT","disable","true");
			setStyle("CCI_CAPS_GENSTAT","disable","true");
			setStyle("CCI_ELITECUSTNO","disable","true");
			//alert("PENDING-2-");

			setStyle("baseFr1","visible","false");
			setStyle("Pending_Section","visible","true");
			setStyle("Card_Details_Section","visible","false");
			setStyle("Branch_Return_Details_Section","visible","false");
			setStyle("request_type","disable","true");
			setStyle("Pending_Decision","visible","true");

			if (getValue("request_type") == "Change in Standing Instructions")
			{
				if (getValue("oth_csi_PH") == "Y")
				{
					setControlValue("oth_csi_PH_Check", "True");
					setStyle("oth_csi_TOH","disable","false");
					if (getValue("oth_csi_TOH") == "Temporary")
					{
						setStyle("oth_csi_NOM","disable","false");
					}
					else
					{
						setStyle("oth_csi_NOM","disable","true");
					}
				}
				else
				{
					setControlValue("oth_csi_PH_Check", "N");
					setControlValue("oth_csi_TOH", "");
					setStyle("oth_csi_TOH","disable","true");
					setControlValue("oth_csi_NOM", "");
					setStyle("oth_csi_NOM","disable","true");
				}

				if (getValue("oth_csi_CSIP") == "Y")
				{
					setControlValue("oth_csi_CSIP_Check", "True");
					setStyle("oth_csi_POSTMTB","disable","false");
				}
				else
				{
					setControlValue("oth_csi_CSIP_Check", "N");
					setControlValue("oth_csi_POSTMTB", "");
					setStyle("oth_csi_POSTMTB","disable","true");
				}
				if (getValue("oth_csi_CSID") == "Y")
				{
					setControlValue("oth_csi_CSID_Check", "True");
					setStyle("oth_csi_ND","disable","false");
				}
				else
				{
					setControlValue("oth_csi_CSID", "N");
					setControlValue("oth_csi_ND", "");
					setStyle("oth_csi_ND","disable","true");
				}
				if (getValue("oth_csi_CDACNo") == "Y")
				{
					setControlValue("oth_csi_CDACNo_Check", "True");
					setStyle("oth_csi_ACCNO","disable","false");
				}
				else
				{
					setControlValue("oth_csi_CDACNo_Check", "false");
					setControlValue("oth_csi_ACCNO", "");
					setStyle("oth_csi_ACCNO","disable","true");
				}
			}
			else if (getValue("request_type") == "Card Replacement")
			{
				if (getValue("oth_cr_REASON") != "OTHERS")
				{
					setStyle("oth_cr_OPS","disable","true");
				}
				if (getValue("oth_cr_DC") != "BRANCH")
				{
					setStyle("CR_BRANCH","disable","true");
				}
			}
			else if (getValue("request_type") == "Early Card Renewal")
			{
				if (getValue("oth_ecr_DT") != "BRANCH")
				{
					setStyle("ECR_BRANCH","disable","true");
				}
			}
			else if (getValue("request_type") == "Credit Limit Increase")
			{
				if (getValue("oth_cli_type") != "TEMPORARY")
				{
					setStyle("oth_cli_months","disable","true");
				}
			}
			else if (getValue("request_type") == "Card Delivery Request")
			{
				if (getValue("oth_cdr_CDT") != "BANK")
				{
					setStyle("CDR_BRANCH","disable","true");
				}
			}
			else if (getValue("request_type") == "Credit Shield")
			{
				if (getValue("oth_cs_CS") != "UN-ENROLLEMENT")
				{
					setStyle("oth_cs_CSR_Check","disable","true");
					setStyle("oth_cs_Amount_Text","disable","true");
				}
				else if (getValue("oth_cs_CSR") == "Y")
				{
					setStyle("oth_cs_CSR_Check","disable","false");
					setControlValue("oth_cs_CSR_Check", "True");
					setStyle("oth_cs_Amount_Text","disable","false");
				}
				else
				{
					setStyle("oth_cs_CSR_Check","disable","false");
					setControlValue("oth_cs_CSR_Check", "False");
					setControlValue("oth_cs_Amount_Text", "");
					setStyle("oth_cs_Amount_Text","disable","true");
				}

			}
			else if (getValue("request_type") == "Re-Issue of PIN")
			{
				if (getValue("oth_rip_DC") != "BRANCH")
				{
					setStyle("RIP_BRANCH","disable","true");
				}
			}
			else if (getValue("request_type") != "Card Upgrade")
			{
				if (getValue("request_type") != "Transaction Dispute");
			}

			lockValidationFrm(getValue("VD_MoMaidN_Check"));
			var response = executeServerEvent("setFormDetail","FormLoad","",true);
			//alert("response :"+response);
			lockCAPSFrm();
			//setControlValue("LabelBUUserName", getValue("BU_UserName"));
			//setControlValue("LabelBUDatetime", getValue("BU_DateTime"));
			//setControlValue("LabelWiName", str3);
			//setControlValue("LabelBranch", "Branch: " + getValue("User_Branch"));
		}
		else if (ActivityName.toUpperCase() == "CARDS")
		{
			str5 = getValue("CCI_CrdtCN");
			setControlValue("CardNo_Text", str5.substring(0, 4) + "-" + str5.substring(4, 8) + "-" + str5.substring(8, 12) + "-" + str5.substring(12));
			//setControlValue("Label1", getValue("request_type"));
			//setControlValue("LabelBUUserName", getValue("BU_UserName"));
			//setControlValue("LabelBUDatetime", getValue("BU_DateTime"));
			//setControlValue("LabelWiName", str3);
			//setControlValue("LabelBranch", "Branch: " + getValue("User_Branch"));
			//setControlValue("CARD_USERNAME", str1);
			//setControlValue("CARD_DATETIME", localSimpleDateFormat.format(localDate));
			//alert("CARDS--");
			//alert("@@Cards_Decision :"+getValue("Cards_Decision"));
			/*if (getValue("Cards_Decision") == "CARDS_E")
				setControlValue("CA_Dec_Combo", "Complete");
			else if (getValue("Cards_Decision") == "CARDS_D")
				setControlValue("CA_Dec_Combo", "Discard");
			else if (getValue("Cards_Decision") == "CARDS_UP")
				setControlValue("CA_Dec_Combo", "Under Process");
			else if (getValue("Cards_Decision") == "CARDS_BR")
				setControlValue("CA_Dec_Combo", "Re-Submit to Branch");
			else 
				setControlValue("CA_Dec_Combo", "");*/
			
			setControlValue("Card_UserName",user); 
			setControlValue("Card_DateTime",getTodayDate());
			setStyle("CCI_CName","disable","true");
			setStyle("CCI_ExpD","disable","true");
			setStyle("CCI_ExpD","disable","true");
			//this.formObject.setNGLocked("CCI_CrdtCN", false);
			setStyle("CCI_CrdtCN","disable","true");
			setStyle("CCI_CCRNNo","disable","true");

			//this.formObject.setNGLocked("CCI_MONO", false);
			setStyle("CCI_MONO","disable","true");
			setStyle("CCI_AccInc","disable","true");
			setStyle("CCI_CT","disable","true");
			setStyle("CCI_CAPS_GENSTAT","disable","true");
			setStyle("CCI_ELITECUSTNO","disable","true");
			setStyle("CCI_ExtNo","disable","true");

			setStyle("VD_TIN_Check","disable","true");
			setStyle("VD_MoMaidN_Check","disable","true");
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

			setStyle("Branch_Return_Details_Section","visible","false");
			setStyle("Pending_Section","visible","false");
			//setControlValue("Branch_Return_Details", "Branch Return Details " + getValue("BR_UserName") + " " + getValue("BR_DateTime"));

			str5 = getValue("BR_Decision");
			//alert("@@BR_Decision :"+str5);
			/*if (str5 == "APPROVE")
				setControlValue("BR_Dec_Combo", "Re-Submit to CARDS");
			 else if (str5 == "DISCARD")
				setControlValue("BR_Dec_Combo", "Discard");
			 else 
			{
				setControlValue("BR_Dec_Combo", "");
				setStyle("Branch_Return_Details_Section","visible","false");
			}*/

			setStyle("BR_Decision","disable","true");
			setStyle("BR_Remarks","disable","true");
			//this.formObject.setNGLocked("BR_Remarks", false);
			//setStyle("BR_Remarks","readonly","true");

			setStyle("CASHBACK_TYPE","disable","true");
			setStyle("REMARKS","disable","true");
			setStyle("AMOUNT","disable","true");

			setStyle("baseFr1","visible","false");

			setStyle("Card_Details_Section","visible","true");
			setStyle("frmPrint","visible","true");
			//alert("@@REQUEST_TYPE :"+getValue("request_type"));
			if (getValue("request_type") == "Change in Standing Instructions")
			{
				if (getValue("oth_csi_PH") == "Y")
					setControlValue("oth_csi_PH_Check", "True");
				else
				{
					setControlValue("oth_csi_PH_Check", "false");
					setControlValue("oth_csi_TOH", "");
					setControlValue("oth_csi_NOM", "");
				}

				if (getValue("oth_csi_CSIP") == "Y")
					setControlValue("oth_csi_CSIP_Check", "True");
				else
				{
					setControlValue("oth_csi_CSIP_Check", "false");
					setControlValue("oth_csi_POSTMTB", "");
				}
				if (getValue("oth_csi_CSID") == "Y")
					setControlValue("oth_csi_CSID_Check", "True");
				
				else
				{
					setControlValue("oth_csi_CSID_Check", "false");
					setControlValue("oth_csi_ND", "");
				}
				if (getValue("oth_csi_CDACNo") == "Y")
					setControlValue("oth_csi_CDACNo_Check", "True");
				else
				{
					setControlValue("oth_csi_CDACNo_Check", "false");
					setValue("oth_csi_ACCNO", "");
				}
			}
			else if (getValue("request_type") == "Credit Shield")
			{
				if (getValue("oth_cs_CS") == "UN-ENROLLEMENT")
				{
					if (getValue("oth_cs_CSR") == "Y")
					{
						setControlValue("oth_cs_CSR_Check", "True");
						setStyle("oth_cs_Amount_Text","disable","false");
					}
					else
					{
						setControlValue("oth_cs_CSR_Check", "False");
						setControlValue("oth_cs_Amount_Text", "");
					}
				}
			}

			lockFields(getValue("request_type"));
			setStyle("request_type","disable","true");
			
			var response = executeServerEvent("setFormDetail","FormLoad","",true);
			// alert("response :"+response);
			 lockCAPSFrm();
			setStyle("oth_ssc_SCNO","disable","true");

			//setControlValue("Card_Details_Section", "Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));

			//setStyle("Card_Details_Section","disable","false");

			/*this.formObject.setNGLocked("Frame1", false);
			this.formObject.setNGLocked("RRDFrm", false);
			this.formObject.setNGLocked("SSCFrm", false);
			this.formObject.setNGLocked("CSFrm", false);
			this.formObject.setNGLocked("CDRFrm", false);
			this.formObject.setNGLocked("CCUFrm", false);
			this.formObject.setNGLocked("TDFrm", false);
			this.formObject.setNGLocked("CISFrm", false);
			this.formObject.setNGLocked("ECRFrm", false);
			this.formObject.setNGLocked("CLIFrm", false);
			this.formObject.setNGLocked("CRFrm", false);
			this.formObject.setNGLocked("RIPFrm", false);*/
			setStyle("Button_Section","visible","true");
			setStyle("Introduce_Button","visible","false");
			setStyle("Pending_Button","visible","false");
			setStyle("Clear_Button","visible","false");
			setStyle("Exit_Button","visible","false");
			setStyle("Print_Button","visible","true");
			//setValue("Cards_Decision",""); by stutee.mishra
			//setValue("Cards_Remarks",""); by stutee.mishra
		}
		else if (ActivityName == "Branch_Return")
		{
			var response = executeServerEvent("setFormDetail","FormLoad","",true);
			//alert("response :"+response);
			lockCAPSFrm();	
			//setControlValue("Label1", setControlValue("request_type"));
			//setControlValue("BR_USERNAME", str1);
			//setControlValue("BR_DATETIME", localSimpleDateFormat.format(localDate));
			/*var str5 = setControlValue("BR_Decision");
			if (str5 == "APPROVE")
				setControlValue("BR_Dec_Combo", "Re-Submit to CARDS");
			else if (str5 == "DISCARD")
				setControlValue("BR_Dec_Combo", "Discard");
			else 
				setControlValue("BR_Dec_Combo", "");*/

			//setControlValue("Card_Details_Section", "Cards Details " + setControlValue("Card_UserName") + " " + setControlValue("Card_DateTime"));

			/*if (getValue("Cards_Decision") == "CARDS_E")
				setControlValue("CA_Dec_Combo", "Complete");
			else if (getValue("Cards_Decision") == "CARDS_D")
				setControlValue("CA_Dec_Combo", "Discard");
			else if (getValue("Cards_Decision") == "CARDS_UP")
				setControlValue("CA_Dec_Combo", "Under Process");
			else if (getValue("Cards_Decision") == "CARDS_BR")
				setControlValue("CA_Dec_Combo", "Re-Submit to Branch");
			else 
				setControlValue("CA_Dec_Combo", "--select--");*/
			
			setStyle("Cards_Decision","disable","true");
			setStyle("Cards_Remarks","disable","true");
			setStyle("Pending_Section","visible","false");
			setStyle("Card_UserName","visible","true");
			setStyle("Card_DateTime","visible","true");
			//this.formObject.setNGLocked("CARDS_REMARKS", false);
			//setStyle("CARDS_REMARKS","readonly","false");

			//alert("Aishwarya1::" + ActivityName + " - " + setControlValue("CCI_CrdtCN"));
			setStyle("CCI_CName","disable","true");
			setStyle("CCI_ExpD","disable","true");
			setStyle("CCI_ExpD","disable","true");
			//this.formObject.setNGLocked("CCI_CrdtCN", false);
			setStyle("CCI_CrdtCN","disable","true");
			setStyle("CCI_CCRNNo","disable","true");

			//this.formObject.setNGLocked("CCI_MONO", false);
			setStyle("CCI_MONO","disable","true");
			setStyle("CCI_AccInc","disable","true");
			setStyle("CCI_CT","disable","true");
			setStyle("CCI_CAPS_GENSTAT","disable","true");
			setStyle("CCI_ELITECUSTNO","disable","true");

			setStyle("baseFr1","visible","false");
			setStyle("Branch_Return_Details_Section","visible","true");

			if ((getValue("Cards_Decision") == null) || (getValue("Cards_Decision") == "") || (getValue("Cards_Decision") == "--select--"))
				setStyle("Card_Details_Section","visible","false");
			else 
				setStyle("Card_Details_Section","visible","true");

			lockValidationFrm(getValue("VD_MoMaidN_Check"));

			setStyle("request_type","disable","true");

			if (getValue("request_type") == "Change in Standing Instructions")
			{
				if (getValue("oth_csi_PH") == "Y")
				{
					setControlValue("oth_csi_PH_Check", "True");
					setStyle("oth_csi_TOH","disable","true");
					if (getValue("oth_csi_TOH") == "Temporary")
					{
						setStyle("oth_csi_NOM","disable","false");
					}
					else
					{
						setStyle("oth_csi_NOM","disable","true");
					}

				}
				else
				{
					setControlValue("oth_csi_PH_Check", "false");
					setValue("oth_csi_TOH", "");
					setStyle("oth_csi_TOH","disable","true");
					setValue("oth_csi_NOM", "");
					setStyle("oth_csi_NOM","disable","true");
				}

				if (getValue("oth_csi_CSIP") == "Y")
				{
					setControlValue("oth_csi_CSIP_Check", "True");
					setStyle("oth_csi_POSTMTB","disable","false");
				}
				else
				{
					setControlValue("oth_csi_CSIP_Check", "false");
					setValue("oth_csi_POSTMTB", "");
					setStyle("oth_csi_POSTMTB","disable","true");
				}
				if (getValue("oth_csi_CSID") == "Y")
				{
					setControlValue("oth_csi_CSID_Check", "True");
					setStyle("oth_csi_ND","disable","false");
				}
				else
				{
					setControlValue("oth_csi_CSID_Check", "false");
					setValue("oth_csi_ND", "");
					setStyle("oth_csi_ND","disable","true");
				}
				if (getValue("oth_csi_CDACNo") == "Y")
				{
					setControlValue("oth_csi_CDACNo_Check", "True");
					setStyle("oth_csi_ACCNO","disable","false");
				}
				else
				{
					setControlValue("oth_csi_CDACNo_Check", "false");
					setValue("oth_csi_ACCNO", "");
					setStyle("oth_csi_ACCNO","disable","true");
				}
			}
			else if (getValue("request_type") == "Card Replacement")
			{
				if (getValue("oth_cr_REASON") != "OTHERS")
				{
					setStyle("oth_cr_OPS","disable","false");
				}
				if (getValue("oth_cr_DC") != "BRANCH")
				{
					setStyle("CR_BRANCH","disable","true");
				}
			}
			else if (getValue("request_type") == "Early Card Renewal")
			{
				if (getValue("oth_ecr_DT") != "BRANCH")
				{
					setStyle("ECR_BRANCH","disable","true");
				}
			}
			else if (getValue("request_type") == "Credit Limit Increase")
			{
				if (getValue("oth_cli_type") != "TEMPORARY")
				{
					setStyle("oth_cli_months","disable","true");
				}
			}
			else if (getValue("request_type") == "Card Delivery Request")
			{
				if (getValue("oth_cdr_CDT") != "BANK")
				{
					setStyle("CDR_BRANCH","disable","true");
				}
			}
			else if (getValue("request_type") == "Credit Shield")
			{
				if (getValue("oth_cs_CS") != "UN-ENROLLEMENT")
				{
					setStyle("oth_cs_CSR_Check","disable","true");
					setStyle("oth_cs_Amount_Text","disable","true");
				}
				else if (getValue("oth_cs_CSR") == "Y")
				{
					setStyle("oth_cs_CSR_Check","disable","false");
					setControlValue("oth_cs_CSR_Check", "True");
					setStyle("oth_cs_Amount_Text","disable","false");
				}
				else
				{
					setStyle("oth_cs_CSR_Check","disable","false");
					setControlValue("oth_cs_CSR_Check", "False");
					setControlValue("oth_cs_Amount_Text", "");
					setStyle("oth_cs_Amount_Text","disable","true");
				}

			}
			else if (getValue("request_type") == "Re-Issue of PIN")
			{
				if (getValue("oth_rip_DC") != "BRANCH")				
					setStyle("RIP_BRANCH","disable","true");				

			}

			//setControlValue("LabelBUUserName", setControlValue("BU_UserName"));
			//setControlValue("LabelBUDatetime", setControlValue("BU_DateTime"));
			//setControlValue("LabelWiName", str3);
			//setControlValue("LabelBranch", "Branch: " + setControlValue("User_Branch"));

			//this.formObject.setNGLocked("Card_Details_Section", false);

			//this.formObject.setNGLocked("Frame1", false);
			setStyle("Cards_Decision","disable","true");
			setStyle("Cards_Remarks","disable","true");
			
			setValue("BR_Decision","");
			setValue("BR_Remarks","");
		}
		else if ((ActivityName == "Work Exit1") || (ActivityName == "Discard1") || (ActivityName == "Query"))
		{
			//setControlValue("Label1", getValue("request_type"));
			//setControlValue("LabelBUUserName", getValue("BU_UserName"));
			//setControlValue("LabelBUDatetime", getValue("BU_DateTime"));
			//setControlValue("LabelWiName", str3);
			//setControlValue("LabelBranch", "Branch: " + getValue("User_Branch"));

			//setControlValue("BRFrm", "Branch Return Details " + getValue("BR_UserName") + " " + getValue("BR_DateTime"));

			/*str5 = getValue("BR_Decision");
			if (str5 == "APPROVE")
				setControlValue("BR_Dec_Combo", "Re-Submit to CARDS");
			else if (str5 == "DISCARD")
				setControlValue("BR_Dec_Combo", "Discard");
			else 
				setControlValue("BR_Dec_Combo", "");*/

			//setControlValue("Card_Details_Section", "Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));

			//alert("Aman check: " + getValue("Cards_Decision"));

			/*if (getValue("Cards_Decision") == "CARDS_E")
				setControlValue("CA_Dec_Combo", "Complete");
			else if (getValue("Cards_Decision") == "CARDS_D")
				setControlValue("CA_Dec_Combo", "Discard");
			else if (getValue("Cards_Decision") == "CARDS_UP")
				setControlValue("CA_Dec_Combo", "Under Process");
			else if (getValue("Cards_Decision") == "CARDS_BR")
				setControlValue("CA_Dec_Combo", "Re-Submit to Branch");
			else 
				setControlValue("CA_Dec_Combo", "");*/
			
			setStyle("baseFr2","visible","true");
			setStyle("baseFr3","visible","true");

			setStyle("Frame1","visible","true");
			setStyle("Card_Details_Section","visible","true");
			setStyle("Branch_Return_Details_Section","visible","true");

			setStyle("baseFrame","disable","true");
			setStyle("baseFr2","disable","true");
			setStyle("baseFr3","disable","true");

			setStyle("Frame1","disable","true");
			setStyle("Card_Details_Section","disable","true");
			setStyle("Branch_Return_Details_Section","disable","true");

			if (getValue("request_type") == "Change in Standing Instructions")
			{
				if (getValue("oth_csi_PH") == "Y")
				{
					setControlValue("oth_csi_PH_Check", "True");
				}
				else
				{
					setControlValue("oth_csi_PH_Check", "false");
					setValue("oth_csi_TOH", "");
					setValue("oth_csi_NOM", "");
				}

				if (getValue("oth_csi_CSIP") == "Y")
				{
					setControlValue("oth_csi_CSIP_Check", "True");
				}
				else
				{
					setControlValue("oth_csi_CSIP_Check", "false");
					setValue("oth_csi_POSTMTB", "");
				}
				if (getValue("oth_csi_CSID") == "Y")
				{
					setControlValue("oth_csi_CSID_Check", "True");
				}
				else
				{
					setControlValue("oth_csi_CSID_Check", "false");
					setValue("oth_csi_ND", "");
				}
				if (getValue("oth_csi_CDACNo") == "Y")
				{
					setControlValue("oth_csi_CDACNo_Check", "True");
				}
				else
				{
					setControlValue("oth_csi_CDACNo_Check", "false");
					setValue("oth_csi_ACCNO", "");
				}
			}
			else if (getValue("request_type") == "Credit Shield")
			{
				if (getValue("oth_cs_CS") == "UN-ENROLLEMENT")
				{
					if (getValue("oth_cs_CSR") == "Y")
					{
						setControlValue("oth_cs_CSR_Check", "True");
						setStyle("oth_cs_Amount_Text","disable","true");
					}
					else
					{
						setControlValue("oth_cs_CSR_Check", "False");
						setValue("oth_cs_Amount_Text", "");
					}

				}

			}

			lockFields(getValue("request_type"));
			setStyle("request_type","disable","false");
			
			var response = executeServerEvent("setFormDetail","FormLoad","",true);
			// alert("response :"+response);
			 lockCAPSFrm();
			
			setStyle("oth_ssc_SCNo_Combo","disable","false");
			setStyle("Branch_Return_Details_Section","disable","false");

			//this.formObject.setNGLocked("Card_Details_Section", false);

			/*this.formObject.setNGLocked("Frame1", false);

			this.formObject.setNGLocked("RRDFrm", false);
			this.formObject.setNGLocked("SSCFrm", false);
			this.formObject.setNGLocked("CSFrm", false);
			this.formObject.setNGLocked("CDRFrm", false);
			this.formObject.setNGLocked("CCUFrm", false);
			this.formObject.setNGLocked("TDFrm", false);
			this.formObject.setNGLocked("CISFrm", false);
			this.formObject.setNGLocked("ECRFrm", false);
			this.formObject.setNGLocked("CLIFrm", false);
			this.formObject.setNGLocked("CRFrm", false);
			this.formObject.setNGLocked("RIPFrm", false);*/
		}
}

function setAmountOnLOad(paramString1,paramString2) 
{
	var str1 = getValue(paramString1);
	var str2 = ".00";

	if (str1.length > 0)
	{
		if (str1.indexOf(".") > -1)
		{
			str2 = str1.substring(str1.indexOf("."));
			str1 = str1.substring(0, str1.indexOf("."));
		}
		if (str1.length == 4)
		{
			str1 = str1.substring(0, 1) + "," + str1.substring(1) + str2;
			setControlValue(paramString2, str1);
		}
		else if (str1.length == 5)
		{
			str1 = str1.substring(0, 2) + "," + str1.substring(2) + str2;
			setControlValue(paramString2, str1);
		}
		else if (str1.length == 6)
		{
			str1 = str1.substring(0, 3) + "," + str1.substring(3) + str2;
			setControlValue(paramString2, str1);
		}
		else if (str1.length == 7)
		{
			str1 = str1.substring(0, 1) + "," + str1.substring(1, 4) + "," + str1.substring(4) + str2;
			setControlValue(paramString2, str1);
		}
		else if (str1.length == 8)
		{
			str1 = str1.substring(0, 2) + "," + str1.substring(2, 5) + "," + str1.substring(5) + str2;
			setControlValue(paramString2, str1);
		}
		setControlValue(paramString2, str1);
	}
}

function lockValidationFrm(paramString)
{
	//alert(paramString);
	if (paramString == true)
	{
		setStyle("VD_TIN_Check","disable","false");
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
	}
	else
	{
		setStyle("VD_TIN_Check","disable","true");
		setStyle("VD_DOB_Check","disable","false");
		setStyle("VD_StaffId_Check","disable","false");
		setStyle("VD_POBox_Check","disable","false");
		setStyle("VD_PassNo_Check","disable","false");
		setStyle("VD_Oth_Check","disable","false");
		setStyle("VD_MRT_Check","disable","false");
		setStyle("VD_EDC_Check","disable","false");
		setStyle("VD_NOSC_Check","disable","false");
		setStyle("VD_TELNO_Check","disable","false");
		setStyle("VD_SD_Check","disable","false");
	}
}

function lockFields(paramString)
{
	if (paramString == "Card Replacement")
	{
		lockCRFrm();
	}
	else if (paramString == "Setup Suppl. Card Limit")
	{
		lockSSCFrm();
	}
	else if (paramString == "Credit Shield")
	{
		lockCSFrm();
	}
	else if (paramString == "Card Delivery Request")
	{
		lockCDRFrm();
	}
	else if (paramString == "Early Card Renewal")
	{
		lockECRFrm();
	}
	else if (paramString == "Card Upgrade")
	{
		lockCCUFrm();
	}
	else if (paramString == "Transaction Dispute")
	{
		lockTDFrm();
	}
	else if (paramString == "Credit Limit Increase")
	{
		lockCLIFrm();
	}
	else if (paramString == "Change in Standing Instructions")
	{
		lockCISFrm();
	}
	else if (paramString == "Re-Issue of PIN")
	{
		lockRIPFrm();
	}
}

function lockCRFrm()
{
	setStyle("oth_cr_DC","disable","true");
	setStyle("oth_cr_RR","disable","true");
	setStyle("CR_BRANCH","disable","true");
	setStyle("oth_cr_REASON","disable","true");
	setStyle("oth_cr_OPS","disable","true");
}

function lockSSCFrm()
{
	setStyle("OTH_SSC_SCNO","disable","true");
	setStyle("oth_ssc_Amount_Text","disable","true");
	setStyle("OTH_SSC_RR","disable","true");
}

function lockCSFrm() 
{
	setStyle("oth_cs_CS","disable","true");
	setStyle("oth_cs_CSR_Check","disable","true");
	setStyle("oth_cs_RR","disable","true");
	setStyle("oth_cs_Amount_Text","disable","true");
}

function lockCDRFrm()
{
	setStyle("oth_cdr_CDT","disable","true");
	setStyle("oth_cdr_RR","disable","true");
	setStyle("CDR_BRANCH","disable","true");
}

function lockECRFrm()
{
	setStyle("OTH_ECR_RB","disable","true");
	setStyle("OTH_ECR_DT","disable","true");
	setStyle("OTH_ECR_RR","disable","true");
	setStyle("ECR_BRANCH","disable","true");
}

function lockCCUFrm()
{
	setStyle("oth_cu_RR","disable","true");
}

function lockTDFrm()
{
	setStyle("oth_td_Amount_Text","disable","true");
	setStyle("oth_td_RR","disable","true");
	setStyle("oth_td_RNO","disable","true");
}

function lockCLIFrm()
{
	setStyle("oth_cli_RR","disable","true");
	setStyle("oth_cli_type","disable","true");
	setStyle("oth_cli_months","disable","true");
}

function lockCISFrm()
{
	setStyle("oth_csi_CSID_Check","disable","true");
	setStyle("oth_csi_CSIP_Check","disable","true");
	setStyle("oth_csi_PH_Check","disable","true");
	setStyle("oth_csi_CDACNo_Check","disable","true");
	setStyle("oth_csi_RR","disable","true");
	setStyle("oth_csi_ND","disable","true");
	setStyle("oth_csi_ACCNO","disable","true");
	setStyle("oth_csi_POSTMTB","disable","true");
	setStyle("oth_csi_NOM","disable","true");
	setStyle("oth_csi_TOH","disable","true");
}

function lockRIPFrm()
{
	setStyle("oth_rip_RR","disable","true");
	setStyle("oth_rip_reason","disable","true");
	setStyle("oth_rip_DC","disable","true");
	setStyle("RIP_BRANCH","disable","true");
}

function callPrintJSPCSROCC(params)
{
	
	var mobNoClearTxt = getValue('CCI_MONO');
	var cardNoClearTxt = getValue('CCI_CrdtCN');
	params = params+"&" + "mobNoClearTxt=" + mobNoClearTxt+"&" + "cardNoClearTxt=" + cardNoClearTxt;
	var strUrl="/CSR_OCC/CSR_OCC/CustomJSP/PrintOCC.jsp?"+params;
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
/*function getDropdownValues(ActivityName){
	if(ActivityName == "CARDS"){
		var REQUEST_TYPE = getValue("request_type");
		if(REQUEST_TYPE == "Card Replacement" || REQUEST_TYPE == "Credit Limit Increase" || REQUEST_TYPE == "Early Card Renewal" || REQUEST_TYPE == "Card Upgrade" || REQUEST_TYPE == "Re-Issue of PIN"){
			clearComboOptions("Cards_Reject");
			clearComboOptions("Cards_ReWorkReason");
			addItemInCombo("Cards_Reject","Documentation Criteria not met");
			addItemInCombo("Cards_Reject","Eligibility Criteria not met");
			addItemInCombo("Cards_Reject","Duplicate Request");
			addItemInCombo("Cards_Reject","Customer response awaited");
			addItemInCombo("Cards_Reject","Confidential reasons to bank");
			addItemInCombo("Cards_ReWorkReason","Documentation Criteria not met");
			addItemInCombo("Cards_ReWorkReason","Eligibility Criteria not met");
			addItemInCombo("Cards_ReWorkReason","Duplicate Request");
			addItemInCombo("Cards_ReWorkReason","Customer response awaited");
			addItemInCombo("Cards_ReWorkReason","Confidential reasons to bank");
		} 
	}
}*/