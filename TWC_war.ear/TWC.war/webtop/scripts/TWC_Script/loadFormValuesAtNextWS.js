//Load Value of all the Grids
function loadGridValues(currWorkstep,WINAME)
{	
	//Modified on 22/02/2019 for Tranche Details Grid
	var gridArray=['Facility_Details_Grid','General_Condition_Grid','Security_Document_Details_Grid','Special_Covenants_Internal_Grid','Special_Covenants_External_Grid','Defferal_Details_Grid','Tranche_Details_Grid','UID_Grid'];
	
	//Modified on 22/02/2019 for Tranche Details Grid
	var idArray=['add_row_Facility_Details','add_row_General_Condition','add_row_Security_Document_Details','add_row_Special_Covenants_Internal','add_row_Special_Covenants_External','add_row_Defferal_Details','add_row_Tranche_Details','add_row_UID'];
	
	var disableFlag ='N';
	for(var grid=0;grid<gridArray.length;grid++)
	{
		var table_name=gridArray[grid];
		var col_Names='';
		var id_name=idArray[grid];
		var url='';
		if(table_name=='Facility_Details_Grid')
			url = "/TWC/CustomForms/TWC_Specific/LoadFacilityGridDetails.jsp";
			
		else if(table_name=='General_Condition_Grid')
			url = "/TWC/CustomForms/TWC_Specific/LoadGeneralGridDetails.jsp";
		
		else if(table_name=='Security_Document_Details_Grid')
			url = "/TWC/CustomForms/TWC_Specific/LoadSecurityGridDetails.jsp";
		
		else if(table_name=='Special_Covenants_Internal_Grid')
			url = "/TWC/CustomForms/TWC_Specific/LoadInternalGridDetails.jsp";
		
		else if(table_name=='Special_Covenants_External_Grid')
			url = "/TWC/CustomForms/TWC_Specific/LoadExternalGridDetails.jsp";
		
		else if(table_name=='Defferal_Details_Grid')
			url = "/TWC/CustomForms/TWC_Specific/LoadDeferralGridDetails.jsp";

		//Added on 22/02/2019 for Tranche Details Grid
		else if(table_name=='Tranche_Details_Grid')
			url = "/TWC/CustomForms/TWC_Specific/LoadTrancheGridDetails.jsp";
		
		else if(table_name=='UID_Grid')
			url = "/TWC/CustomForms/TWC_Specific/LoadUIDGridDetails.jsp";
		else 
			alert("Error in getting URL"+url);
		 
		var xhr;
		var ajaxResult="";		
		if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
		else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
		
		var param="&WI_NAME="+WINAME;
		xhr.open("POST",url,false);
		xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
		xhr.send(param);
		//alert("status"+xhr.status);
		if (xhr.status == 200)
		{
			//alert("status"+xhr.status);
			ajaxResult = xhr.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
			if(ajaxResult=="-1")
			{
				alert("Error while loading "+table_name+" details ");
				return false;
			}
			else if(ajaxResult=='0')//Means no record found in database
			{
				
			}
			else
			{
				ajaxResult=ajaxResult.split('|');
				
				for(var i=0;i<ajaxResult.length;i++)
				{
					/*if(table_name=='UID_Grid' && (dec_CBWCChecker!="" || dec_CBWCChecker!=null))
						disableFlag='Y';
					else 
						disableFlag='N';*/
					
					//addrow(currWorkstep,id_name,ajaxResult[i],disableFlag);
					addrow(currWorkstep,id_name,ajaxResult[i]);
				}							
			}		
		}
		else 
		{
			alert("Error while Loading "+table_name+" Grid Data.");
			return false;
		}
	}
		
}

//Disable Enable fields
//Modified on 22/02/2019 to add new fields
function enableDisable(workstepName)
{
	var decCropsFinalChecker=document.getElementById("wdesk:Dec_Crops_Finalisation_Checker");
	var decPopulate =document.getElementById("wdesk:Dec_Populate");
	
	var cifIdDisable=document.getElementById("wdesk:CIF_Id");
	var populateButtonDisable=document.getElementById("CIF_Id_populate");
	var rakTrackNumberDisable=document.getElementById("wdesk:RAK_Track_Number");
	var customerNameDisable=document.getElementById("wdesk:Customer_Name");
	var referencNumberDisable=document.getElementById("wdesk:Reference_Number");
	var addressLine1Disable=document.getElementById("wdesk:Address_Line_1");
	var addressLine2Disable=document.getElementById("wdesk:Address_Line_2");
	var addressLine3Disable=document.getElementById("wdesk:Address_Line_3");
	var addressLine4Disable=document.getElementById("wdesk:Address_Line_4");
	var poBoxDisable=document.getElementById("wdesk:PO_Box");
	var emirateDisable=document.getElementById("wdesk:Emirate");
	var countryDisable=document.getElementById("wdesk:Country");
	var tradeLicenseNumberDisable=document.getElementById("wdesk:TL_Number");
	var masterFacilityLimitDisable=document.getElementById("wdesk:Master_Facility_Limit");
	var processingFeeDisable=document.getElementById("wdesk:Non_Refundable_ProcessingFee");
	var reviewDateDisable=document.getElementById("wdesk:Review_Date");
	var relatedPartNameDisable=document.getElementById("wdesk:Related_Part_Name");
	var accountDisable=document.getElementById("wdesk:FeeDebitedAccount");
	var notesDisable=document.getElementById("wdesk:Notes");
	var facilityButtonDisable=document.getElementById("add_row_Facility_Details");
	var totalFacilityExistingDisable=document.getElementById("wdesk:Total_Facility_Existing");
	var totalFacilitySoughtDisable=document.getElementById("wdesk:Total_Facility_Sought");
	var generalButtonDisable=document.getElementById("add_row_General_Condition");
	var securityButtonDisable=document.getElementById("add_row_Security_Document_Details");
	var patternOfFundingDisable=document.getElementById("wdesk:Pattern_of_Funding");
	var internalButtonDisable=document.getElementById("add_row_Special_Covenants_Internal");
	var externalButtonDisable=document.getElementById("add_row_Special_Covenants_External");
	var deferralButtonDisable=document.getElementById("add_row_Defferal_Details");
	var uidButtonDisable=document.getElementById("add_row_UID");
	var ROCode=document.getElementById("wdesk:RO_Code");
	var AECBRequired=document.getElementById("AECB_Required");
	var CBRBRequired=document.getElementById("CBRB_Required");
	uidButtonDisable.disabled=true;
	uidButtonDisable.classList.remove("EWButtonRBSRM");
	uidButtonDisable.classList.add("EWButtonRBSRMRejectReason");
	
	//Added on 22/02/2019 
	var mobileCodeDisable=document.getElementById("wdesk:Mobile_Code");
	var mobileNumberDisable=document.getElementById("wdesk:Mobile_Number");
	var landlineCodeDisable=document.getElementById("wdesk:Landline_code");
	var landlineNumberDisable=document.getElementById("wdesk:Landline_Number");
	var emailIDDisable=document.getElementById("wdesk:Email_ID");
	var mraArchivalDateDisable=document.getElementById("wdesk:MRA_Archival_Date");
	var productIdentifierDisable=document.getElementById("ProductIdentifierdropdown");
	var productIdentifierSelectedDisable=document.getElementById("ProductIdentifierSeleceted");
	var productIdentifierAdd=document.getElementById("addButtonProduct");
	var productIdentifierRemove=document.getElementById("removeButtonProduct");
	productIdentifierAdd.disabled=true;
	productIdentifierAdd.classList.remove("EWButtonRB");
    productIdentifierAdd.classList.add("EWButtonRBSRMRejectReason");
	productIdentifierRemove.disabled=true;
	productIdentifierRemove.classList.remove("EWButtonRB");
    productIdentifierRemove.classList.add("EWButtonRBSRMRejectReason");
	productIdentifierDisable.disabled=true;
	productIdentifierSelectedDisable.disabled=true;
	
	var TypeOfLADisable=document.getElementById("TypeOfLAdropdown");
	var TypeOfLASelectedDisable=document.getElementById("TypeOfLASeleceted");
	var TypeOfLAAdd=document.getElementById("addButtonTypeOfLA");
	var TypeOfLARemove=document.getElementById("removeButtonTypeOfLA");
	TypeOfLAAdd.disabled=true;
	TypeOfLAAdd.classList.remove("EWButtonRB");
    TypeOfLAAdd.classList.add("EWButtonRBSRMRejectReason");
	TypeOfLARemove.disabled=true;
	TypeOfLARemove.classList.remove("EWButtonRB");
    TypeOfLARemove.classList.add("EWButtonRBSRMRejectReason");
	TypeOfLADisable.disabled=true;
	TypeOfLASelectedDisable.disabled=true;
	
	var RequestTypeDisable=document.getElementById("RequestTypedropdown");
	var RequestTypeSelectedDisable=document.getElementById("RequestTypeSeleceted");
	var RequestTypeAdd=document.getElementById("addButtonRequestType");
	var RequestTypeRemove=document.getElementById("removeButtonRequestType");
	RequestTypeAdd.disabled=true;
	RequestTypeAdd.classList.remove("EWButtonRB");
    RequestTypeAdd.classList.add("EWButtonRBSRMRejectReason");
	RequestTypeRemove.disabled=true;
	RequestTypeRemove.classList.remove("EWButtonRB");
    RequestTypeRemove.classList.add("EWButtonRBSRMRejectReason");
	RequestTypeDisable.disabled=true;
	RequestTypeSelectedDisable.disabled=true;
	
	var dealCountrySearch=document.getElementById("custdealingwithcountry_search");
	var dealCountrySelectedList=document.getElementById("countryList");
	var dealCountryAddButton=document.getElementById("addButton");
	var dealCountryRemoveButton=document.getElementById("removeButton");
	
	//Commented on 28/03/2019 as Limit Amount field has been removed.
	//var limitAmountDisable=document.getElementById("wdesk:Limit_Amount");
	var firstLevelCreditApproverDisable=document.getElementById("wdesk:First_Level_Credit_Approver");
	var secondLevelCreditApproverDisable=document.getElementById("wdesk:Second_Level_Credit_Approver");
	var firstLevelBusinessApproverDisable=document.getElementById("wdesk:First_Level_Business_Approver");
	var secondLevelBusinessApproverDisable=document.getElementById("wdesk:Second_Level_Business_Approver");
	var FinalCreditApproverAuthDisable=document.getElementById("wdesk:FinalCreditApproverAuth");
	var templatebutton = document.getElementById("bt_template");
	var exceltemplatebutton= document.getElementById("bt_Excel_template");
	
	//Added on 28/02/2019
	var MRACalenderDisable=document.getElementById("MRA_calendar");
	var reviewCalenderDisable=document.getElementById("Review_calendar");
	
	//Added on 01/03/2019
	var trancheButtonDisable=document.getElementById("add_row_Tranche_Details");
	
	var btnViewSignDisable=document.getElementById("btnViewSign");
	
	var Sum_Value=document.getElementById("wdesk:Sum_Value");
	var Sum_FSV=document.getElementById("wdesk:Sum_FSV");
	var Clean_Exposure=document.getElementById("wdesk:Clean_Exposure");
	
	
	//Added on 17/06/2021
	var Channel=document.getElementById("wdesk:CHANNEL");
	var ChannelSubGroup=document.getElementById("CHANNELSUBGROUP");
	var BAISWiNumber=document.getElementById("wdesk:BAISWINUMBER");
	var Priority=document.getElementById("PRIORITY");
	var TwcABF=document.getElementById("TWCABF");
	var DocumentList=document.getElementById("wdesk:DOCUMENTLIST");
	var DocListForValidation=document.getElementById("wdesk:DOCLISTFORVALIDATION");
	Channel.disabled=true;
	ChannelSubGroup.disabled=true;
	BAISWiNumber.disabled=true;
	Priority.disabled=true;
	TwcABF.disabled=true;
	DocumentList.disabled=true;
	DocListForValidation.disabled=true;
	
	DocumentList.value=DocumentList.value.split('|').join(',\n');
	
	//Added by Sajan on 13/03/2019
	firstLevelBusinessApproverDisable.disabled=true;
	secondLevelBusinessApproverDisable.disabled=true;
	ROCode.disabled=true;
	AECBRequired.disabled=true;
	CBRBRequired.disabled=true;
	
	//added by Sowmya as per the Copy Profile Changes on 07/June/2023
	var ParentWI=document.getElementById("wdesk:Parent_WI");
	var SourceParentWI=document.getElementById("wdesk:Source_Parent_WI");
	var TotalPFParentWI=document.getElementById("wdesk:Total_PF_ParentWI");
	var CampaignID=document.getElementById("wdesk:Campaign_ID");
	var PartnerCode=document.getElementById("wdesk:Partner_Code");
		/*ParentWI.disabled=true;
		SourceParentWI.disabled=true;*/
		TotalPFParentWI.disabled=true;
		CampaignID.disabled=true;
		PartnerCode.disabled=true;
	//Disable fields if decision at CROPS Finalization Checker is Approve
	if(decCropsFinalChecker.value=='Approve')
	{
		cifIdDisable.disabled=true;
		populateButtonDisable.disabled=true;
		populateButtonDisable.classList.remove("EWButtonRBSRM");
        populateButtonDisable.classList.add("EWButtonRBSRMRejectReason");
		rakTrackNumberDisable.disabled=true;
		customerNameDisable.disabled=true;
		referencNumberDisable.disabled=true;
		addressLine1Disable.disabled=true;
		addressLine2Disable.disabled=true;
		addressLine3Disable.disabled=true;
		addressLine4Disable.disabled=true;
		poBoxDisable.disabled=true;
		emirateDisable.disabled=true;
		countryDisable.disabled=true;	
		tradeLicenseNumberDisable.disabled=true;
		masterFacilityLimitDisable.disabled=true;
		processingFeeDisable.disabled=true;
		TotalPFParentWI.disabled=true;   //Added by Sowmya 
		reviewDateDisable.disabled=true;
		relatedPartNameDisable.disabled=true;
		accountDisable.disabled=true;
		notesDisable.disabled=true;
		facilityButtonDisable.disabled=true;
		facilityButtonDisable.classList.remove("EWButtonRBSRM");
        facilityButtonDisable.classList.add("EWButtonRBSRMRejectReason");
		totalFacilityExistingDisable.disabled=true;
		totalFacilitySoughtDisable.disabled=true;
		generalButtonDisable.disabled=true;
		generalButtonDisable.classList.remove("EWButtonRBSRM");
        generalButtonDisable.classList.add("EWButtonRBSRMRejectReason");
		securityButtonDisable.disabled=true;
		securityButtonDisable.classList.remove("EWButtonRBSRM");
        securityButtonDisable.classList.add("EWButtonRBSRMRejectReason");
		securityButtonDisable.style.backgroundColor 
		patternOfFundingDisable.disabled=true;
		internalButtonDisable.disabled=true;
		internalButtonDisable.classList.remove("EWButtonRBSRM");
        internalButtonDisable.classList.add("EWButtonRBSRMRejectReason");
		externalButtonDisable.disabled=true;
		externalButtonDisable.classList.remove("EWButtonRBSRM");
        externalButtonDisable.classList.add("EWButtonRBSRMRejectReason");
		//Added on 22/02/2019 
		mobileCodeDisable.disabled=true;
		mobileNumberDisable.disabled=true;
		landlineCodeDisable.disabled=true;
		landlineNumberDisable.disabled=true;
		emailIDDisable.disabled=true;
		mraArchivalDateDisable.disabled=true;
		productIdentifierDisable.disabled=true;
		//Commented on 28/03/2019 as Limit Amount Field has been removed
		//limitAmountDisable.disabled=true;
		
		//Added on 28/02/2019
		MRACalenderDisable.disabled=true;
		reviewCalenderDisable.disabled=true;
		
		dealCountrySearch.disabled=true;
		dealCountrySelectedList.disabled=true;
		dealCountryAddButton.disabled=true;
		dealCountryAddButton.classList.remove("EWButtonRB");
        dealCountryAddButton.classList.add("EWButtonRBSRMRejectReason");
		dealCountryRemoveButton.disabled=true;
		dealCountryRemoveButton.classList.remove("EWButtonRB");
        dealCountryRemoveButton.classList.add("EWButtonRBSRMRejectReason");
		
		Sum_Value.disabled=true;
		Sum_FSV.disabled=true;
		Clean_Exposure.disabled=true;
	}
	else
	{
		//Disable fields onLoad if values are populated.
		if(decPopulate.value=='Y')
		{
			customerNameDisable.disabled=true;
			addressLine1Disable.disabled=true;
			addressLine2Disable.disabled=true;
			addressLine3Disable.disabled=true;
			addressLine4Disable.disabled=true;
			poBoxDisable.disabled=true;
			emirateDisable.disabled=true;
			countryDisable.disabled=true;
			//Added on 22/02/2019 
			mobileCodeDisable.disabled=true;
			mobileNumberDisable.disabled=true;
			landlineCodeDisable.disabled=true;
			landlineNumberDisable.disabled=true;
			emailIDDisable.disabled=true;
		}
	}
	if(workstepName=='CBRB_Maker' || workstepName=='Quality_Control' || workstepName=='AECB' || workstepName=='Credit_Hold')
	{
		var form = document.getElementById("wdesk");
		var elements = form.elements;
		for (var i = 0, len = elements.length; i < len; ++i) {
			if(elements[i].id!="wdesk:Remarks" && elements[i].id!="Exception_History" && elements[i].id!="Decision_History" && elements[i].id!="Reject_Reason" && elements[i].id!="selectDecision" && elements[i].id!="ParentWI_Decision_History" && elements[i].id!="ParentWI_UID_History"){
				elements[i].disabled = true;
				if(elements[i].type == "button"){
					elements[i].classList.remove("EWButtonRBSRM");
		            elements[i].classList.add("EWButtonRBSRMRejectReason");
				}
			}
				//elements[i].disabled = true;
		}
	}
	if(workstepName=='AU_Officer' || workstepName=='Sales_Validation')
	{
		var form = document.getElementById("wdesk");
		var elements = form.elements;
		for (var i = 0, len = elements.length; i < len; ++i) {
			if(elements[i].id!="wdesk:Remarks" && elements[i].id!="Exception_History" && elements[i].id!="Decision_History" && elements[i].id!="Reject_Reason" && elements[i].id!="selectDecision"){
				elements[i].disabled = true;
				if(elements[i].type == "button"){
					elements[i].classList.remove("EWButtonRBSRM");
		            elements[i].classList.add("EWButtonRBSRMRejectReason");
				}
			}
				//elements[i].disabled = true;
		}
	}
	if(workstepName=='Sales_Data_Entry' || workstepName=='Business_Approver_1st' || workstepName=='Business_Approver_2nd')
	{
		firstLevelBusinessApproverDisable.disabled=false;
		secondLevelBusinessApproverDisable.disabled=false;
		
		cifIdDisable.disabled=false;
		populateButtonDisable.disabled=false;
		populateButtonDisable.classList.remove("EWButtonRBSRMRejectReason");
        populateButtonDisable.classList.add("EWButtonRBSRM");
		
		rakTrackNumberDisable.disabled=false;
		masterFacilityLimitDisable.disabled=false;
		processingFeeDisable.disabled=false;
		tradeLicenseNumberDisable.disabled=false;
		reviewDateDisable.disabled=false;
		referencNumberDisable.disabled=false;
		productIdentifierDisable.disabled=false;
		productIdentifierSelectedDisable.disabled=false;
		productIdentifierAdd.disabled=false;
		productIdentifierAdd.classList.remove("EWButtonRBSRMRejectReason");
        productIdentifierAdd.classList.add("EWButtonRB");
		productIdentifierRemove.disabled=false;
		productIdentifierRemove.classList.remove("EWButtonRBSRMRejectReason");
        productIdentifierRemove.classList.add("EWButtonRB");
		accountDisable.disabled=false;
		relatedPartNameDisable.disabled=false;
		Sum_Value.disabled=false;
		Sum_FSV.disabled=false;
		TypeOfLAAdd.disabled=false;
		TypeOfLAAdd.classList.remove("EWButtonRBSRMRejectReason");
        TypeOfLAAdd.classList.add("EWButtonRB");
		TypeOfLARemove.disabled=false;
		TypeOfLARemove.classList.remove("EWButtonRBSRMRejectReason");
        TypeOfLARemove.classList.add("EWButtonRB");
		TypeOfLADisable.disabled=false;
		TypeOfLASelectedDisable.disabled=false;
		RequestTypeAdd.disabled=false;
		RequestTypeAdd.classList.remove("EWButtonRBSRMRejectReason");
        RequestTypeAdd.classList.add("EWButtonRB");
		RequestTypeRemove.disabled=false;
		RequestTypeRemove.classList.remove("EWButtonRBSRMRejectReason");
        RequestTypeRemove.classList.add("EWButtonRB");
		RequestTypeDisable.disabled=false;
		RequestTypeSelectedDisable.disabled=false;
		
	} else // cif id field will be disabled at all queues except above as per jira - PTWC-50
	{
		cifIdDisable.disabled=true;
		populateButtonDisable.disabled=true;
		populateButtonDisable.classList.remove("EWButtonRBSRM");
        populateButtonDisable.classList.add("EWButtonRBSRMRejectReason");
	}
	
	//Making sum of value and fsv editable at sales reject queue added on 09122019
	if(workstepName=='Sales_Reject')
	{
		Sum_Value.disabled=false;
		Sum_FSV.disabled=false;
	}
	
	//Enable UID Grid only at CBRB Checker
	//Workstep name Modified on 21/02/2019
	if(workstepName=='Quality_Control'){
		uidButtonDisable.disabled=false;
		uidButtonDisable.classList.remove("EWButtonRBSRMRejectReason");
		uidButtonDisable.classList.add("EWButtonRBSRM");
	}
		
	
	if(workstepName=='CROPS_Finalization_Maker' || workstepName=='CROPS_Finalization_Checker' || workstepName=='CROPS_Disbursal_Maker' || workstepName=='CROPS_Disbursal_Checker' || workstepName=='CROPS_Hold' || workstepName=='CROPS_Archival' || workstepName=="CROPS_Admin_Maker" || workstepName=='CROPS_Admin_Checker' || workstepName=="CROPS_Deferral_Maker" || workstepName=="CROPS_Deferral_Checker")
	{
		var form = document.getElementById("wdesk");
		var elements = form.elements;
		for (var i = 0, len = elements.length; i < len; ++i) {
			if(elements[i].id!="wdesk:Remarks" && elements[i].id!="Exception_History" && elements[i].id!="Decision_History" && elements[i].id!="Reject_Reason" && elements[i].id!="selectDecision"){
				elements[i].disabled = true;
				if(elements[i].type == "button"){
					elements[i].classList.remove("EWButtonRBSRM");
		            elements[i].classList.add("EWButtonRBSRMRejectReason");
				}
			}
				
		}
	}
	
	if(workstepName=='CROPS_Finalization_Maker' || workstepName=='CROPS_Finalization_Checker' || workstepName=='CROPS_Disbursal_Maker' || workstepName=='CROPS_Disbursal_Checker')
	{
		templatebutton.disabled=false;
		templatebutton.classList.remove("EWButtonRBSRMRejectReason");
        templatebutton.classList.add("EWButtonRBSRM");
		processingFeeDisable.disabled=false;
		//exceltemplatebutton.disabled=false;
		enableFacilityColumns(workstepName);
	}
	
	if(workstepName=='CROPS_Disbursal_Maker' || workstepName=='CROPS_Disbursal_Checker' || workstepName=="CROPS_Deferral_Maker" || workstepName=="CROPS_Deferral_Checker")
	{
			deferralButtonDisable.disabled=false;
			deferralButtonDisable.classList.remove("EWButtonRBSRMRejectReason");
            deferralButtonDisable.classList.add("EWButtonRBSRM");
	}
	//Condition Added on 22/02/2019 
	if(workstepName=="Credit_Analyst" || workstepName=="Credit_Approver_1st" || workstepName=="Credit_Approver_2nd")
	{
		firstLevelCreditApproverDisable.disabled=false;
		secondLevelCreditApproverDisable.disabled=false;
		//Commented on 28/03/2019 as Limit Amount Field has been removed.
		/*if(workstepName=="Credit_Analyst")
			limitAmountDisable.disabled=false;
		*/
	}
	else
	{
		firstLevelCreditApproverDisable.disabled=true;
		secondLevelCreditApproverDisable.disabled=true;
	}
	
	//Condition Added on 01/03/2019
	//Condition Modified on 03/04/2019
	if(workstepName=="CROPS_Admin_Maker" || workstepName=='CROPS_Admin_Checker'|| workstepName=='CROPS_Disbursal_Maker' || workstepName=='CROPS_Disbursal_Checker'||workstepName=='Sales_Data_Entry')
	{
		enableTrancheDetails();
	}
	
	//Condition added on 01/04/2019
	if(workstepName=="Sales_Data_Entry")
	{
		mraArchivalDateDisable.disabled=true;
		MRACalenderDisable.disabled=true;
		
		// Enabled as part of jira POLP-10572
		mobileCodeDisable.disabled=false;
		mobileNumberDisable.disabled=false;
		landlineCodeDisable.disabled=false;
		landlineNumberDisable.disabled=false;
		emailIDDisable.disabled=false;
		//******************************
	}
	if(workstepName=="Credit_Analyst")
	{
		MRACalenderDisable.disabled=false;
		FinalCreditApproverAuthDisable.disabled=false;
	}
	
	//Condition added on 02/04/2019. Enable Disable fields on Credit queues.
	if(workstepName.indexOf("Credit")!=-1)
	{
		tradeLicenseNumberDisable.disabled=true;
		relatedPartNameDisable.disabled=false;
		reviewDateDisable.disabled=false;
		productIdentifierDisable.disabled=false;
		productIdentifierSelectedDisable.disabled=false;
		facilityButtonDisable.disabled=false;
		facilityButtonDisable.classList.remove("EWButtonRBSRMRejectReason");
        facilityButtonDisable.classList.add("EWButtonRBSRM");
		totalFacilityExistingDisable.disabled=false;
		totalFacilitySoughtDisable.disabled=false;
		productIdentifierAdd.disabled=false;
		productIdentifierAdd.classList.remove("EWButtonRBSRMRejectReason");
        productIdentifierAdd.classList.add("EWButtonRB");
		productIdentifierRemove.disabled=false;
		productIdentifierRemove.classList.remove("EWButtonRBSRMRejectReason");
        productIdentifierRemove.classList.add("EWButtonRB");
		deferralButtonDisable.disabled=true;
		deferralButtonDisable.classList.remove("EWButtonRBSRM");
        deferralButtonDisable.classList.add("EWButtonRBSRMRejectReason");
		mraArchivalDateDisable.disabled=true;
		patternOfFundingDisable.disabled=true;
		dealCountrySearch.disabled=true;
		dealCountryAddButton.disabled=true;
		dealCountryAddButton.classList.remove("EWButtonRB");
        dealCountryAddButton.classList.add("EWButtonRBSRMRejectReason");
		dealCountryRemoveButton.disabled=true;
		dealCountryRemoveButton.classList.remove("EWButtonRB");
        dealCountryRemoveButton.classList.add("EWButtonRBSRMRejectReason");
		dealCountrySelectedList.disabled=true;
		Sum_Value.disabled=false;
		Sum_FSV.disabled=false;
		TypeOfLAAdd.disabled=false;
		TypeOfLAAdd.classList.remove("EWButtonRBSRMRejectReason");
        TypeOfLAAdd.classList.add("EWButtonRB");
		TypeOfLARemove.disabled=false;
		TypeOfLARemove.classList.remove("EWButtonRBSRMRejectReason");
        TypeOfLARemove.classList.add("EWButtonRB");
		TypeOfLADisable.disabled=false;
		TypeOfLASelectedDisable.disabled=false;
		RequestTypeAdd.disabled=false;
		RequestTypeAdd.classList.remove("EWButtonRBSRMRejectReason");
        RequestTypeAdd.classList.add("EWButtonRB");
		RequestTypeRemove.disabled=false;
		RequestTypeRemove.classList.remove("EWButtonRBSRMRejectReason");
        RequestTypeRemove.classList.add("EWButtonRB");
		RequestTypeDisable.disabled=false;
		RequestTypeSelectedDisable.disabled=false;
		exceltemplatebutton.disabled=false;
		exceltemplatebutton.classList.remove("EWButtonRBSRMRejectReason");
        exceltemplatebutton.classList.add("EWButtonRBSRM");
		
	}
	
	if(workstepName=="CROPS_Disbursal_Maker" || workstepName=="CROPS_Disbursal_Checker" || workstepName=="CROPS_Deferral_Maker" || workstepName=="CROPS_Deferral_Checker"){
		btnViewSignDisable.disabled=false;
		btnViewSignDisable.classList.remove("EWButtonRBSRMRejectReason");
        btnViewSignDisable.classList.add("EWButtonRBSRM");
	}else{
		btnViewSignDisable.disabled=true;
		btnViewSignDisable.classList.remove("EWButtonRBSRM");
        btnViewSignDisable.classList.add("EWButtonRBSRMRejectReason");
	}	
		
	
	//##CR Point 27052019## Editable at Sales Queues************************************
	var IslamicOrConventional=document.getElementById("IslamicOrConventional");
	if(workstepName == 'Sales_Data_Entry' || workstepName == 'Sales_Deferral_Maker' || workstepName == 'Sales_Reject' || workstepName == 'Sales_Hold' || workstepName == 'Sales_Attach_Doc' || workstepName == 'Sales_Approver')
		IslamicOrConventional.disabled=false;
	else
		IslamicOrConventional.disabled=true;
	//************************************************************************************
	
	
	//##CR Point 27052019## Restrict the decision value on CROPS Hold Queue*******
	var Prev_WS=document.getElementById("wdesk:Prev_WS").value;
	var decision_Length = document.getElementById("selectDecision").options.length;	
	if(workstepName == 'CROPS_Hold')
	{	
		if(Prev_WS == 'Attach_Final_Document')
		{
			for(var i=0;i<decision_Length;i++)
			{
				if(document.getElementById("selectDecision").options[i].value =='Submit')
					document.getElementById("selectDecision").options[i].disabled = true;
			}
		}
		else if(Prev_WS == 'CROPS_Admin_Checker' || Prev_WS == 'CROPS_Finalization_Checker' || Prev_WS == 'CROPS_Disbursal_Checker' || Prev_WS == 'CROPS_Deferral_Checker')
		{
			for(var i=0;i<decision_Length;i++)
			{
				if(document.getElementById("selectDecision").options[i].value =='Original Document Received')
					document.getElementById("selectDecision").options[i].disabled = true;
			}
		}				
	}
	//************************************************************************	
	
	// making Respond to CROPS decision disabled at Credit Analyst
	if(workstepName == 'Credit_Analyst')
	{	
		var ReferToCreditWSName = document.getElementById("wdesk:ReferToCreditWSName").value;
		if(ReferToCreditWSName == 'NULL' || ReferToCreditWSName == '' || ReferToCreditWSName == null)
		{
			for(var i=0;i<decision_Length;i++)
			{
				if(document.getElementById("selectDecision").options[i].value =='Respond to CROPS')
					document.getElementById("selectDecision").options[i].disabled = true;
			}
		}
	}
	//******************************************************
	//Condition added on 17/06/2021
	if(workstepName=='DigiOnboard_Initial_Doc_review' || workstepName=='DigiOnboard_Error_Handling' || workstepName=='DigiOnboard_Doc_Hold')
	{
		var form = document.getElementById("wdesk");
		var elements = form.elements;
		for (var i = 0, len = elements.length; i < len; ++i) 
		{
			if(elements[i].id!="wdesk:Remarks" && elements[i].id!="Exception_History" && elements[i].id!="Decision_History" && elements[i].id!="Reject_Reason" && elements[i].id!="selectDecision"){
				elements[i].disabled = true;
				if(elements[i].type == "button"){
					elements[i].classList.remove("EWButtonRBSRM");
		            elements[i].classList.add("EWButtonRBSRMRejectReason");
				}
			}
				//elements[i].disabled = true;
		}
		if(workstepName=='DigiOnboard_Initial_Doc_review')
		{
			AECBRequired.disabled=false;
			CBRBRequired.disabled=false;
			ChannelSubGroup.disabled=false;
			Priority.disabled=false;
			TwcABF.disabled=false;
			rakTrackNumberDisable.disabled=false;
			emailIDDisable.disabled=false;
			mobileCodeDisable.disabled=false;
			mobileNumberDisable.disabled=false;
			firstLevelBusinessApproverDisable.disabled=false;
			secondLevelBusinessApproverDisable.disabled=false;
			
			// POLP-10565
			ROCode.disabled=false;
			productIdentifierDisable.disabled=false;
			productIdentifierSelectedDisable.disabled=false;
			productIdentifierAdd.disabled=false;
			productIdentifierAdd.classList.remove("EWButtonRBSRMRejectReason");
            productIdentifierAdd.classList.add("EWButtonRB");
			productIdentifierRemove.disabled=false;
			productIdentifierRemove.classList.remove("EWButtonRBSRMRejectReason");
            productIdentifierRemove.classList.add("EWButtonRB");
			TypeOfLAAdd.disabled=false;
			TypeOfLAAdd.classList.remove("EWButtonRBSRMRejectReason");
            TypeOfLAAdd.classList.add("EWButtonRB");
			TypeOfLARemove.disabled=false;
			TypeOfLARemove.classList.remove("EWButtonRBSRMRejectReason");
            TypeOfLARemove.classList.add("EWButtonRB");
			TypeOfLADisable.disabled=false;
			TypeOfLASelectedDisable.disabled=false;
			RequestTypeAdd.disabled=false;
			RequestTypeAdd.classList.remove("EWButtonRBSRMRejectReason");
            RequestTypeAdd.classList.add("EWButtonRB");
			RequestTypeRemove.disabled=false;
			RequestTypeRemove.classList.remove("EWButtonRBSRMRejectReason");
            RequestTypeRemove.classList.add("EWButtonRB");
			RequestTypeDisable.disabled=false;
			RequestTypeSelectedDisable.disabled=false;
			IslamicOrConventional.disabled=false;
			dealCountrySearch.disabled=false;
			dealCountryAddButton.disabled=false;
			dealCountryAddButton.classList.remove("EWButtonRBSRMRejectReason");
            dealCountryAddButton.classList.add("EWButtonRB");
			dealCountryRemoveButton.disabled=false;
			dealCountryRemoveButton.classList.remove("EWButtonRBSRMRejectReason");
            dealCountryRemoveButton.classList.add("EWButtonRB");
			dealCountrySelectedList.disabled=false;
			tradeLicenseNumberDisable.disabled=false;
			referencNumberDisable.disabled=false;
			landlineCodeDisable.disabled=false;
			landlineNumberDisable.disabled=false;
			//POLP-9011
			masterFacilityLimitDisable.disabled=false;
			processingFeeDisable.disabled=false;
			reviewDateDisable.disabled=false;
			relatedPartNameDisable.disabled=false;
			accountDisable.disabled=false;
		}
	}
	//Added by Sowmya as per the Copy Profile Changes on 07/June/2023
	if(workstepName=='Sales_Data_Entry' || workstepName=='Business_Approver_1st' || workstepName=='Business_Approver_2nd' || workstepName=='Business_Approver_3rd' || workstepName=='Sales_Reject')
	{
		CampaignID.disabled=false;
		PartnerCode.disabled=false;
		
		if(workstepName=='Sales_Data_Entry')
		{
			if(ParentWI.value != '' && ParentWI.value != 'NULL' && ParentWI.value != 'undefined' && ParentWI.value != 'null')
				ROCode.disabled=false;
		}
	}
	
	exceltemplatebutton.disabled=false; // print button enabled at all queues as part of iRBL changes
	exceltemplatebutton.classList.remove("EWButtonRBSRMRejectReason");
    exceltemplatebutton.classList.add("EWButtonRBSRM");
	if(ParentWI.value != '' && ParentWI.value != 'NULL' && ParentWI.value != 'undefined' && ParentWI.value != 'null')
	{
		var parentDecisionHistButton = document.getElementById("ParentWI_Decision_History");
		var ParentUIDBtton= document.getElementById("ParentWI_UID_History");
		parentDecisionHistButton.disabled = false;
		parentDecisionHistButton.classList.remove("EWButtonRBSRMRejectReason");
		parentDecisionHistButton.classList.add("EWButtonRBSRM");
		
		ParentUIDBtton.disabled = false;
		ParentUIDBtton.classList.remove("EWButtonRBSRMRejectReason");
		ParentUIDBtton.classList.add("EWButtonRBSRM");
	}
}

//Modified on 22/02/2019 to change the Column name to CBRB Checker
//Modified on 27/02/2019 to change add UID remarks condition
function enableDisableUID(workstepName)
{
	var rowCount=document.getElementById("wdesk:UIDGridCount").value;
	var dec_CBRBChecker= document.getElementById("wdesk:Dec_CBRB_Checker").value;
	//Disable delete at CBWC Checker for already added row when workitem is submitted by CBRB Checker previously.
	if(workstepName=='Quality_Control')
	{
		var rowCount=document.getElementById("wdesk:UIDGridCount").value;
		var dec_CBRBChecker= document.getElementById("wdesk:Dec_CBRB_Checker").value;
		if(rowCount!='' || rowCount!=null)
		{
			if(parseInt(rowCount, 10)>1 && dec_CBRBChecker!='')
			{
				for (var i=1; i < rowCount; i++) 
					document.getElementById("UIDImage"+i).disabled=true;
			}
		}
	}
	//Enable Remarks on worksteps other than Business_Approver_1st and Business_Approver_2nd  .
	else if(workstepName=='Business_Approver_1st' || workstepName=='Business_Approver_2nd')
	{
		if(rowCount!='' || rowCount!=null)
		{
			if(parseInt(rowCount, 10)>1 && dec_CBRBChecker!='')
			{
				for (var i=1; i < rowCount; i++) 
					document.getElementById("Remarks"+i).disabled=false;
			}
			
		}
		
	}
	
}
//Modified on 27/03/2019 to get sum of only those value for which usage is Outer.
function autoCalculateFields()
{
	var totalFacilityExistingId=document.getElementById("wdesk:Total_Facility_Existing");
	var totalFacilitySoughtId=document.getElementById("wdesk:Total_Facility_Sought");
	var table = document.getElementById("Facility_Details_Grid");
	var table_len=table.rows.length;
	if(table_len>0)
	{
		var totalFacilityExistingValue=0;
		var totalFacilitySoughtValue=0;
		for(var i=1;i<table_len;i++)
		{
			var usage=document.getElementById("Usage"+i).value;
			if(usage=="Outer")
			{
				var facility_Existing_id=document.getElementById("Facility_Existing"+i).value;
				facility_Existing_id=facility_Existing_id.split(',').join('');
				var facility_Sought_id=document.getElementById("Faciltiy_Sought"+i).value;
				facility_Sought_id=facility_Sought_id.split(',').join('');
				if(facility_Existing_id==""||facility_Existing_id==null)
					facility_Existing_id="0";
				if(facility_Sought_id==""||facility_Sought_id==null)
					facility_Sought_id="0";
					
				totalFacilityExistingValue=totalFacilityExistingValue+parseFloat(facility_Existing_id, 10);
				totalFacilitySoughtValue=totalFacilitySoughtValue+parseFloat(facility_Sought_id, 10);
			
			}
		}
		if((totalFacilityExistingValue.toString()).indexOf('.')==-1)
			totalFacilityExistingValue=totalFacilityExistingValue+'.00';
		else 
			totalFacilityExistingValue=Math.round(totalFacilityExistingValue * 100) / 100;
		
		if((totalFacilitySoughtValue.toString()).indexOf('.')==-1)
			totalFacilitySoughtValue=totalFacilitySoughtValue+'.00';
		else 
			totalFacilitySoughtValue=Math.round(totalFacilitySoughtValue * 100) / 100;
			
		totalFacilityExistingId.value=totalFacilityExistingValue.toString();
		totalFacilitySoughtId.value=totalFacilitySoughtValue.toString();
		
		onBlurForAmount('wdesk:Total_Facility_Existing');
		onBlurForAmount('wdesk:Total_Facility_Sought');
	}	
}
//Check if master facility and total facility are equal
//Modified on 27/02/2019
function checkMasterFacilityValue()
{
	var master_facility_value=document.getElementById("wdesk:Master_Facility_Limit").value.split(',').join('');
	var totalFacilitySought=document.getElementById("wdesk:Total_Facility_Sought").value.split(',').join('');
	if(master_facility_value==""||master_facility_value==null)
		master_facility_value="0";
	if(totalFacilitySought==""||totalFacilitySought==null)
		totalFacilitySought="0";
	
	master_facility_value=parseFloat(master_facility_value, 10);
	totalFacilitySought=parseFloat(totalFacilitySought, 10)
	if(master_facility_value!=totalFacilitySought){
		alert("Warning: Total Facility Sought & Master Facility Limit are not equal.");
		return false;
		}
		
	else{
		return true;
	}
}


//Load Duplicate Workitems on Next Workstep
function checkDuplicateWorkitemsOnLoadAtNextWorkstep()
{	
	var ajaxResult;
	var ProcessInstanceId =document.getElementById("wdesk:WI_NAME").value;
	var TLNumber = document.getElementById("wdesk:TL_Number").value;
	var WSNAME =document.getElementById("wdesk:Current_WS").value;
	//Commented on 21/02/2019 as Sales_Attach_Doc is removed
	//var Dec_SalesAttachDoc=document.getElementById("wdesk:Dec_Sales_Attach_Doc").value;
	var Dec_CreditAnalyst=document.getElementById("wdesk:Dec_Credit_Analyst").value;
	var xhr;
	//Modified on 22/02/2019 as Sales_Attach_Doc is removed
	//if(Dec_SalesAttachDoc!=''||Dec_CreditAnalyst!='')
	if(Dec_CreditAnalyst!='')
	{
		if (window.XMLHttpRequest)
			xhr = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr = new ActiveXObject("Microsoft.XMLHTTP");

		var url = "/TWC/CustomForms/TWC_Specific/GetDuplicateWorkitems.jsp";
		//Modified on 21/02/2019 as Sales_Attach_Doc is removed
		//var param = "WI_NAME=" + ProcessInstanceId+"&WSNAME="+WSNAME+"&Dec_SalesAttachDoc="+Dec_SalesAttachDoc+"&Dec_CreditAnalyst="+Dec_CreditAnalyst+"&TLNumber="+TLNumber;
		var param = "WI_NAME=" + ProcessInstanceId+"&WSNAME="+WSNAME+"&Dec_CreditAnalyst="+Dec_CreditAnalyst+"&TLNumber="+TLNumber;

		xhr.open("POST", url, false);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send(param);
		if (xhr.status == 200 && xhr.readyState == 4) 
		{
			ajaxResult = xhr.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
			if(ajaxResult=="-1")
			{
				alert("Problem in getting duplicate workitems list."+ajaxResult);
				return false;
			}
			else if(ajaxResult=="")//Blank means not found any result
			{
				return true;
			}
			
			var duplicate = document.getElementById('Duplicate_Workitems');
			var t = document.createElement('div');
			t.innerHTML = ajaxResult;
			duplicate.appendChild(t);
			//document.getElementById("duplicateWorkitemsId").innerHTML=ajaxResult;
			alert("Duplicates are identified for this request");
			return true;
			
		} 
		else 
		{
			alert("Problem in getting duplicate workitems list."+xhr.status);
			return false;
		}	
	}
}
//Added on 27/02/2019 to show selected values of Field Product Identifier
function selectedProductIdentifier()
{
	var productIdentifierDropdown=document.getElementById('ProductIdentifierSeleceted');
	var selectedValues= document.getElementById('wdesk:Product_Identifier').value;
	if(selectedValues != '')
	{
		var arrayVal=selectedValues.split('|');
		var opt=[];
		for(var i=0;i<arrayVal.length;i++)
		{
			var opt = document.createElement("option");
			opt.text = arrayVal[i];
			opt.value =arrayVal[i];
			if(opt.value!="")
				productIdentifierDropdown.options.add(opt);
		}
	}
}

//Added on 27/08/2019 to show selected values of Field Product Identifier
function selectedTypeOfLA()
{
	var TypeOfLADropdown=document.getElementById('TypeOfLASeleceted');
	var selectedValues=document.getElementById('wdesk:Type_Of_LA').value;
	if(selectedValues != '')
	{
		var arrayVal=selectedValues.split('|');
		var opt=[];
		for(var i=0;i<arrayVal.length;i++)
		{
			var opt = document.createElement("option");
			opt.text = arrayVal[i];
			opt.value =arrayVal[i];
			if(opt.value!="")
				TypeOfLADropdown.options.add(opt);
		}
	}
}

//Added on 27/08/2019 to show selected values of Field Product Identifier
function selectedRequestType()
{
	var RequestTypeDropdown=document.getElementById('RequestTypeSeleceted');
	var selectedValues=document.getElementById('wdesk:Request_Type').value;
	if(selectedValues != '')
	{
		var arrayVal=selectedValues.split('|');
		var opt=[];
		for(var i=0;i<arrayVal.length;i++)
		{
			var opt = document.createElement("option");
			opt.text = arrayVal[i];
			opt.value =arrayVal[i];
			if(opt.value!="")
				RequestTypeDropdown.options.add(opt);
		}
	}
}

//Added on 27/03/2019 to auto calculate sum of Security Grid Fields.
/*function autoCalculateSecurityFields()
{
	var sumFSVId=document.getElementById("wdesk:Sum_FSV");
	var sumValueId=document.getElementById("wdesk:Sum_Value");
	var table = document.getElementById("Security_Document_Details_Grid");
	var table_len=table.rows.length;
	if(table_len>0)
	{
		var totalFSVValue=0;
		var totalValue=0;
		for(var i=1;i<table_len;i++)
		{
			var TI=document.getElementById("TI"+i).value;
			
				var FSV_id=document.getElementById("FSV"+i).value;
				if (FSV_id != '')
				{
					FSV_id=FSV_id.split(',').join('');
					var numbers = /^[0-9\.,]+$/;
					if (!(FSV_id.match(numbers)))
						FSV_id = "0";
					else
						onBlurForAmount("FSV"+i);
				}	
				var value_id=document.getElementById("value"+i).value;
				if (value_id != '')
				{
					value_id=value_id.split(',').join('');
					var numbers = /^[0-9\.,]+$/;
					if (!(value_id.match(numbers)))
						value_id = "0";
					else
						onBlurForAmount("value"+i);	
				}	
				if(FSV_id==""||FSV_id==null)
					FSV_id="0";
				if(value_id==""||value_id==null)
					value_id="0";
					
				totalFSVValue=totalFSVValue+parseFloat(FSV_id, 10);
				totalValue=totalValue+parseFloat(value_id, 10);
			
			
		}
		if((totalFSVValue.toString()).indexOf('.')==-1)
			totalFSVValue=totalFSVValue+'.00';
		else 
			totalFSVValue=Math.round(totalFSVValue * 100) / 100;
		
		if((totalValue.toString()).indexOf('.')==-1)
			totalValue=totalValue+'.00';
		else 
			totalValue=Math.round(totalValue * 100) / 100;
			
		sumFSVId.value=totalFSVValue.toString();
		sumValueId.value=totalValue.toString();
		//Calculate Clean Exposure after Sum of Value is calculated
		autoCalculateCleanExposure();
	}	
}*/

//Added on 27/03/2019 to calculate Clean Exposure.
function autoCalculateCleanExposure()
{
	var masterFacilityLimit=document.getElementById("wdesk:Master_Facility_Limit").value;
	var sumFSV=document.getElementById("wdesk:Sum_FSV").value;
	var cleanExposureID=document.getElementById("wdesk:Clean_Exposure");
	
	masterFacilityLimit=masterFacilityLimit.split(',').join('');
	sumFSV=sumFSV.split(',').join('');
	if(masterFacilityLimit==""||masterFacilityLimit==null)
		masterFacilityLimit="0";
	if(sumFSV==""||sumFSV==null)
		sumFSV="0";
	
	var cleanExposure=parseFloat(masterFacilityLimit, 10)-parseFloat(sumFSV, 10);
	if((cleanExposure.toString()).indexOf('.')==-1)
			cleanExposure=cleanExposure+'.00';
	else 
		cleanExposure=Math.round(cleanExposure * 100) / 100;
	cleanExposureID.value=cleanExposure.toString();
	
	//onBlurForAmount('wdesk:Sum_Value');
	//onBlurForAmount('wdesk:Sum_FSV');
	onBlurForAmount('wdesk:Clean_Exposure');
}

//Added to enable tranche based on Product Identifier ot selected facility type
function enableTrancheDetails()
{
	var workstepName=document.getElementById("wdesk:Current_WS").value;
	if(workstepName=="CROPS_Admin_Maker" || workstepName=='CROPS_Admin_Checker'|| workstepName=='CROPS_Disbursal_Maker' || workstepName=='CROPS_Disbursal_Checker'||workstepName=='Sales_Data_Entry')
	{
		var productIdentifierDropdown = document.getElementById("ProductIdentifierSeleceted");
		var isProductIdentifierABF= false;
		var opt=[] ,tempStr="";
		var len=productIdentifierDropdown.options.length;
		for(var i=0;i<len; i++)
		{
			opt = productIdentifierDropdown.options[i];
			if (opt.value == 'ABF')
			{
				isProductIdentifierABF = true;
				break;
			}
		}
		
		var trancheButtonDisable=document.getElementById("add_row_Tranche_Details");
		// enabling when product identifier select as ABF
		if (isProductIdentifierABF){
			trancheButtonDisable.disabled = false;
			trancheButtonDisable.classList.remove("EWButtonRBSRMRejectReason");
            trancheButtonDisable.classList.add("EWButtonRBSRM");
		}else{
			trancheButtonDisable.disabled = true;
			trancheButtonDisable.classList.remove("EWButtonRBSRM");
            trancheButtonDisable.classList.add("EWButtonRBSRMRejectReason");
		}
			
		//*********************************************

		if (trancheButtonDisable.disabled == true)
		{
			var table = document.getElementById("Facility_Details_Grid");
			var table_len=table.rows.length;
			if(table_len>0)
			{
				var AllFacilityTypes = '';
				for(var i=1;i<table_len;i++)
				{
					var facilityType=document.getElementById("Nature_of_Facility"+i).value;
					if (facilityType != '')
						AllFacilityTypes = AllFacilityTypes+facilityType+',';
				}
				if (AllFacilityTypes != '')
				{
					AllFacilityTypes = AllFacilityTypes.substring(0,AllFacilityTypes.length-1);
					var tancheEnabledCount = getTrancheEnabledCount(AllFacilityTypes);
					if (tancheEnabledCount != '' && tancheEnabledCount > 0){
						trancheButtonDisable.disabled = false;
						trancheButtonDisable.classList.remove("EWButtonRBSRMRejectReason");
                        trancheButtonDisable.classList.add("EWButtonRBSRM");
					}else{
						trancheButtonDisable.disabled = true;
						trancheButtonDisable.classList.remove("EWButtonRBSRM");
                        trancheButtonDisable.classList.add("EWButtonRBSRMRejectReason");
					}
						
				}
			}
		}
		
		if (trancheButtonDisable.disabled == false)
		{
			var table = document.getElementById("Tranche_Details_Grid");
			var table_len=table.rows.length;
			if(table_len>0)
			{
				for(var i=1;i<table_len;i++)
				{
					document.getElementById("tranche_amount"+i).disabled = false;
					document.getElementById("tranche_status"+i).disabled = false;
					document.getElementById("tranche_available_period"+i).disabled = false;
					document.getElementById("tranche_calender_1"+i).disabled = false;
					document.getElementById("tranche_disbursal_date"+i).disabled = false;
					document.getElementById("tranche_calender_2"+i).disabled = false;
					document.getElementById("tranche_remarks"+i).disabled = false;
					document.getElementById("trancheImage"+i).disabled = false;
					if (workstepName=='Sales_Data_Entry')
					{
						document.getElementById("tranche_available_period"+i).disabled = true;
						document.getElementById("tranche_calender_1"+i).disabled = true;
						document.getElementById("tranche_disbursal_date"+i).disabled = true;
						document.getElementById("tranche_calender_2"+i).disabled = true;
					}
				}
			}
		} 
		else
		{
			var table = document.getElementById("Tranche_Details_Grid");
			var table_len=table.rows.length;
			if(table_len>0)
			{
				for(var i=1;i<table_len;i++)
				{
					document.getElementById("tranche_amount"+i).disabled = true;
					document.getElementById("tranche_status"+i).disabled = true;
					document.getElementById("tranche_available_period"+i).disabled = true;
					document.getElementById("tranche_calender_1"+i).disabled = true;
					document.getElementById("tranche_disbursal_date"+i).disabled = true;
					document.getElementById("tranche_calender_2"+i).disabled = true;
					document.getElementById("tranche_remarks"+i).disabled = true;
					document.getElementById("trancheImage"+i).disabled = true;
				}
			}
		}
	}
}

function getTrancheEnabledCount(natureOfFacilities)
{
	var url = '';
	var xhr;
	var ajaxResult;
	var param="&reqType=getTrancheEnabledCount&natureOfFacilities="+natureOfFacilities;
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	url = '/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp';
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{	
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult.indexOf("Exception")==0)
		{
			//alert("Unknown Exception while working with request type Commission");
			return false;
		}

		if(ajaxResult==-1)
		{
			return false;
		}	
		
		if (ajaxResult!='')
			return ajaxResult;
	}
	else 
	{
		return false;
	}
}

function loadBusinessCreditApprover(workstepName,FirstBussApprValue,SecondBussApprValue,FirstCreditApprValue,SecondCreditApprValue)  
{
	var dropwDownId=['wdesk:First_Level_Business_Approver','wdesk:Second_Level_Business_Approver','wdesk:First_Level_Credit_Approver','wdesk:Second_Level_Credit_Approver'];
	var url = '';
	var xhr;
	var ajaxResult;		
	var ifValueActive=false; 
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	var selectedValue = "";
	
	for(var i=0;i<dropwDownId.length;i++)
	{
		if (dropwDownId[i] == 'wdesk:First_Level_Business_Approver' || dropwDownId[i] == 'wdesk:Second_Level_Business_Approver')
		{
			if(workstepName != 'Sales_Data_Entry' && workstepName != 'Business_Approver_1st' && workstepName != 'Business_Approver_2nd' && workstepName != 'DigiOnboard_Initial_Doc_review')
				continue;
		}
		
		if (dropwDownId[i] == 'wdesk:First_Level_Credit_Approver' || dropwDownId[i] == 'wdesk:Second_Level_Credit_Approver')
		{
			if(workstepName != "Credit_Analyst" && workstepName != "Credit_Approver_1st" && workstepName != "Credit_Approver_2nd")
				continue;
		}
		
		if (dropwDownId[i] == 'wdesk:First_Level_Business_Approver')
			selectedValue = FirstBussApprValue;
		if (dropwDownId[i] == 'wdesk:Second_Level_Business_Approver')
			selectedValue = SecondBussApprValue;
		if (dropwDownId[i] == 'wdesk:First_Level_Credit_Approver')
			selectedValue = FirstCreditApprValue;
		if (dropwDownId[i] == 'wdesk:Second_Level_Credit_Approver')
			selectedValue = SecondCreditApprValue;
		
		url = '/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp';
		var param="&reqType="+dropwDownId[i];
		xhr.open("POST",url,false);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send(param);
		
		if (xhr.status == 200)
		{
			 ajaxResult = xhr.responseText;
			 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
			 if(ajaxResult=='-1')
			 {
				alert("Error while loading dropdown values for "+dropwDownId[i]);
				return false;
			 }				 
			 values = ajaxResult.split("~");
			 for(var j=0;j<values.length;j++)
			 {
				var opt = document.createElement("option");
				opt.text = values[j];
				opt.value =values[j];
				if(values[j]==selectedValue)
				{
					opt.selected='selected';
					ifValueActive=true;
				}
				document.getElementById(dropwDownId[i]).options.add(opt);
			 }
		 if(selectedValue !='')
		 {
			 if(ifValueActive==false)
			 {
				var opt = document.createElement("option");
				opt.text=selectedValue;
				opt.value=selectedValue;
				opt.selected='selected';
				document.getElementById(dropwDownId[i]).options.add(opt);
			 }
		 }
		}
		else 
		{
			alert("Error while Loading Drowdown "+dropwDownId[i]);
			return false;
		}
	}
}

function enableFacilityColumns(workstepName)
{
	var table = document.getElementById("Facility_Details_Grid");
	var table_len=table.rows.length;
	if(table_len>0)
	{
		for(var i=1;i<table_len;i++)
		{
			document.getElementById("InterestType"+i).disabled = false;
			document.getElementById("Interest"+i).disabled = false;
			if(workstepName=='CROPS_Finalization_Maker' || workstepName=='CROPS_Finalization_Checker')
				document.getElementById("remark"+i).disabled = false;
		}
	}
}
//added by Sowmya as per the Copy Profile Changes on 07/June/2023
function autoCalculateSecurityFields()
{
	var sumFSVId=document.getElementById("wdesk:Sum_FSV");
	var sumValueId=document.getElementById("wdesk:Sum_Value");
	var table = document.getElementById("Security_Document_Details_Grid");
	var table_len=table.rows.length;
	if(table_len>0)
	{
		var totalFSVValue=0;
		var totalValue=0;
		for(var i=1;i<table_len;i++)
		{
			var TI=document.getElementById("TI"+i).value;
			//alert("Testing123333: "+document.getElementById("TI"+i).value);	
				var FSV_id=document.getElementById("FSV"+i).value;
				if(TI=="T")
				{
					//alert("Testing123: "+document.getElementById("TI"+i).value);	
					if (FSV_id != '')
					{
						FSV_id=FSV_id.split(',').join('');
						var numbers = /^[0-9\.,]+$/;
						if (!(FSV_id.match(numbers)))
							FSV_id = "0";
						else
							onBlurForAmount("FSV"+i);
					}	
					var value_id=document.getElementById("value"+i).value;
					if (value_id != '')
					{
						value_id=value_id.split(',').join('');
						var numbers = /^[0-9\.,]+$/;
						if (!(value_id.match(numbers)))
							value_id = "0";
						else
							onBlurForAmount("value"+i);	
					}	
					if(FSV_id==""||FSV_id==null)
						FSV_id="0";
					if(value_id==""||value_id==null)
						value_id="0";
					totalFSVValue=totalFSVValue+parseFloat(FSV_id, 10);
					totalValue=totalValue+parseFloat(value_id, 10);
				}
		}
		if((totalFSVValue.toString()).indexOf('.')==-1)
			totalFSVValue=totalFSVValue+'.00';
		else 
			totalFSVValue=Math.round(totalFSVValue * 100) / 100;
		if((totalValue.toString()).indexOf('.')==-1)
			totalValue=totalValue+'.00';
		else 
			totalValue=Math.round(totalValue * 100) / 100;
		sumFSVId.value=totalFSVValue.toString();
		sumValueId.value=totalValue.toString();
		//Calculate Clean Exposure after Sum of Value is calculated
		//autoCalculateCleanExposure();
	}	
}
