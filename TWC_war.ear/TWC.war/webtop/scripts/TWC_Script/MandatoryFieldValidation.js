
function OnDoneValidation(flag)
{
	//Decision will always be mandatory for all workstep
	var WSNAME = customform.document.getElementById("wdesk:Current_WS").value; 
	var table=customform.document.getElementById("Defferal_Details_Grid");
	var rowCount = table.rows.length;
	var selDecision = customform.document.getElementById("selectDecision").value;
	customform.document.getElementById("wdesk:Decision").value = selDecision;
	
	if(customform.document.getElementById("selectDecision").value=='')
	{
		alert('Please Select the Decision.');
		customform.document.getElementById('selectDecision').focus(true);
		return false;
	}
	//Deferral Held or not
	if(rowCount>1)
		customform.document.getElementById("wdesk:Deferral_Held").value="Yes";
	else 
		customform.document.getElementById("wdesk:Deferral_Held").value="No";
	
	//Remarks in Decision is Mandatory if Decision selected is Reject 
	if(selDecision.indexOf("Reject") != -1)
	{
		if(customform.document.getElementById("wdesk:Remarks").value.trim()=='')
		{
			alert("Please provide remarks");
			customform.document.getElementById('wdesk:Remarks').focus(true);
			return false;
		}
		if(customform.document.getElementById('rejReasonCodes').value=='' || customform.document.getElementById('rejReasonCodes').value=='NO_CHANGE')
		{
			alert("Please provide reject reason.");
			customform.document.getElementById('Reject_Reason').focus(true);
			return false;
		}
	
	}
	//Added on 21/02/2019 to mandate CBRB_Required and AECB_Required 
	
	
	if(customform.document.getElementById('selectDecision').value=='Reperform Checks')
	{
		if(customform.document.getElementById("wdesk:CBRB_Required").value=="")
		{
			alert("CBRB Required is Mandatory.");
			customform.document.getElementById("CBRB_Required").focus(true);
			return false;
		}
		if(customform.document.getElementById("wdesk:AECB_Required").value=="")
		{
			alert("AECB Required is Mandatory.");
			customform.document.getElementById("AECB_Required").focus(true);
			return false;
		}
		if (customform.document.getElementById('wdesk:CBRB_Required').value != 'Yes' && customform.document.getElementById('wdesk:AECB_Required').value != 'Yes')
		{
			alert("CBRB or AECB Required must be Yes when Reperform Checks decision is selected");
			customform.document.getElementById('CBRB_Required').focus(true);
			return false;
		}
	}
	
	if(WSNAME=="Initiation")
	{
		/*var currentdate = new Date();
		var datetime =formatAMPM(currentdate);
		customform.document.getElementById("wdesk:IntoducedAt").value=datetime;
		customform.document.getElementById("wdesk:IntoducedBy").value=customform.document.getElementById("CurrentUserName").value;*/
		
		//Added on 19/02/2019 to set default value of Price_Change_Approval_Reqd as 'No'
		if(customform.document.getElementById("wdesk:Price_Change_Approval_Reqd").value=="")
		{
			customform.document.getElementById("wdesk:Price_Change_Approval_Reqd").value=="No";
		}
		
	}
	//Added on 18/02/2019 to save datetime of decision Approve on CBRB Maker
	if(WSNAME=="CBRB_Maker")
	{
		if(customform.document.getElementById("selectDecision").value=='Approve')
		{
			if(!AttachedDocType("CBRB_Checklist,CBRB_Checks"))
				return false;
			var currentdate = new Date();
			var datetime =formatAMPM(currentdate);
			customform.document.getElementById("wdesk:CBRBMaker_Done_On").value=datetime;
		}
	}
	//Added on 18/02/2019 to save datetime of decision Approve on AECB
	if(WSNAME=="AECB")
	{
		if(customform.document.getElementById("selectDecision").value=='Approve')
		{
			if(!AttachedDocType("AECB_Report"))
				return false;
			var currentdate = new Date();
			var datetime =formatAMPM(currentdate);
			customform.document.getElementById("wdesk:AECB_Done_On").value=datetime;
		}
	}
	//Workstep name modified on 18/02/2019
	if(WSNAME=="Quality_Control")
	{
		
		customform.document.getElementById("wdesk:Dec_CBRB_Checker").value =customform.document.getElementById("selectDecision").value;
		var tableUID = customform.document.getElementById("UID_Grid");
		var rowCountUID=tableUID.rows.length;
		customform.document.getElementById("wdesk:UIDGridCount").value=rowCountUID;
		checkForUIDException();
	}
	//Condition Added on 22/02/2019
	if(WSNAME == "Sales_Data_Entry")
	{
		if(customform.document.getElementById("selectDecision").value=="Submit")
		{
			if(customform.document.getElementById("wdesk:CIF_Id").value =="")
			{
				alert("Please enter CIF Number");
				customform.document.getElementById("wdesk:CIF_Id").focus(true);
				return false;
			}
			if(customform.document.getElementById("wdesk:RAK_Track_Number").value =="")
			{
				alert("Please enter RAK Track number");
				customform.document.getElementById("wdesk:RAK_Track_Number").focus(true);
				return false;
			}
			if(customform.document.getElementById("wdesk:Master_Facility_Limit").value =="")
			{
				alert("Please enter Master Facility Limit");
				customform.document.getElementById("wdesk:Master_Facility_Limit").focus(true);
				return false;
			}
			if(customform.document.getElementById("wdesk:Non_Refundable_ProcessingFee").value =="")
			{
				alert("Please enter Processing Fee");
				customform.document.getElementById("wdesk:Non_Refundable_ProcessingFee").focus(true);
				return false;
			}
			
			if(customform.document.getElementById("wdesk:TL_Number").value =="")
			{
				alert("Please enter Trade Licence number");
				customform.document.getElementById("wdesk:TL_Number").focus(true);
				return false;
			}
			if(customform.document.getElementById("wdesk:Review_Date").value =="")
			{
				alert("Please enter Review Date");
				customform.document.getElementById("wdesk:Review_Date").focus(true);
				return false;
			}
			if(customform.document.getElementById("wdesk:Reference_Number").value =="")
			{
				alert("Please enter LAF Reference Number");
				customform.document.getElementById("wdesk:Reference_Number").focus(true);
				return false;
			}
			if(customform.document.getElementById("ProductIdentifierSeleceted").options.length ==0)
			{
				alert("Please select atleast one Product Identifier");
				return false;
			}
			if(customform.document.getElementById("countryList").options.length ==0)
			{
				alert("Please select atleast one Dealing with country(ies)");
				customform.document.getElementById("custdealingwithcountry_search").focus(true);
				return false;
			}
			if(customform.document.getElementById("wdesk:FeeDebitedAccount").value !='' && customform.document.getElementById("wdesk:FeeDebitedAccount").value.length != 13)
			{
				alert("Account to be debited for fee should be exact 13 digits");
				customform.document.getElementById("wdesk:FeeDebitedAccount").focus(true);
				return false;
			}
			//##CR Point 27052019## Mandatory to select Islamic_Or_Conventional at Sales_Data_Entry WS ************
			if(customform.document.getElementById("IslamicOrConventional").value =='')
			{
				alert("Please select Islamic/Conventional");
				customform.document.getElementById("IslamicOrConventional").focus(true);
				return false;
			}
			//************************************************************************************************
		}
	}
	//Condition Added on 22/02/2019
	if(WSNAME == "Business_Approver_1st")
	{
		if(customform.document.getElementById("selectDecision").value=="Forward for Manager Review")
		{
			if(customform.document.getElementById("wdesk:First_Level_Business_Approver").value =="")
			{
				alert("Please enter First Level Business Approver");
				customform.document.getElementById("wdesk:First_Level_Business_Approver").focus(true);
				return false;
			}
			if(customform.document.getElementById("wdesk:Second_Level_Business_Approver").value =="")
			{
				alert("Please enter Second Level Business Approver");
				customform.document.getElementById("wdesk:Second_Level_Business_Approver").focus(true);
				return false;
			}
		}
		if(customform.document.getElementById("selectDecision").value=="Approve")
		{
			if(customform.document.getElementById("wdesk:FeeDebitedAccount").value !='' && customform.document.getElementById("wdesk:FeeDebitedAccount").value.length != 13)
			{
				alert("Account to be debited for fee should be exact 13 digits");
				customform.document.getElementById("wdesk:FeeDebitedAccount").focus(true);
				return false;
			}
		}
	}
	if(WSNAME == "Business_Approver_2nd")
	{
		if(customform.document.getElementById("selectDecision").value=="Approve")
		{
			if(customform.document.getElementById("wdesk:FeeDebitedAccount").value !='' && customform.document.getElementById("wdesk:FeeDebitedAccount").value.length != 13)
			{
				alert("Account to be debited for fee should be exact 13 digits");
				customform.document.getElementById("wdesk:FeeDebitedAccount").focus(true);
				return false;
			}
		}
	}
	if(WSNAME == "CROPS_Finalization_Checker")
	{
		customform.document.getElementById("wdesk:Dec_Crops_Finalisation_Checker").value =customform.document.getElementById("selectDecision").value;
	}
	if(WSNAME == "CROPS_Hold")
	{
		var previousQueue=customform.document.getElementById("wdesk:Prev_WS").value;
		if(selDecision=='Submit' && previousQueue=='Attach_Final_Document')
		{
			alert("Please Select Decision other than Submit");
			customform.document.getElementById("selectDecision").value="";
			customform.document.getElementById('selectDecision').focus(true);
			return false;
		}
	}
	//Condition added on 23/03/2019
	if(WSNAME=="Attach_Final_Document")
	{
		if(selDecision=='Pricing Change Required')
			customform.document.getElementById("wdesk:Price_Change_Approval_Reqd").value="Required";
		else
			customform.document.getElementById("wdesk:Price_Change_Approval_Reqd").value="No";
	}
	
	//Commented on 19/02/2019 as CreditManager workstep has been removed
	/*if(WSNAME == "Credit_Manager")
	{
		customform.document.getElementById("wdesk:Dec_Credit_Manager").value =customform.document.getElementById("selectDecision").value;
	}*/
	//Added on 20/02/2019 as to save decision on Credit_Approver_1st workstep 
	if(WSNAME == "Credit_Approver_1st")
	{
		customform.document.getElementById("wdesk:Dec_Credit_Approver_1st").value =customform.document.getElementById("selectDecision").value;
	}
	
	if(WSNAME == "Credit_Approver_2nd")
	{
		customform.document.getElementById("wdesk:Dec_Credit_Approver_1st").value =customform.document.getElementById("selectDecision").value;
	}
	
	if(WSNAME == "Credit_Analyst")
	{
		//Commented on 19/02/2019 as CreditManager workstep has been removed
		/*var Dec_CreditManager=customform.document.getElementById("wdesk:Dec_Credit_Manager").value;
		var Dec_CreditAnalyst=customform.document.getElementById("selectDecision").value;
		if(Dec_CreditManager!="Approve")
		{
			if(Dec_CreditAnalyst=="Approve")
			{
				alert("Please Select Decision other than Approve as Credit Manager has not approved");
				return false;
			}
		}*/
		
		//Added on 20/02/2019 to check Decision on Credit Analyst workstep based on Credit Approver 1st Decision.
		var Dec_Credit_Approver_1st=customform.document.getElementById("wdesk:Dec_Credit_Approver_1st").value;
		var Dec_CreditAnalyst=customform.document.getElementById("selectDecision").value;
		if(Dec_Credit_Approver_1st!="Approve")
		{
			if(Dec_CreditAnalyst=="Approve")
			{
				alert("Credit Approver 1st/2nd has not taken Approve Decision. Please Select Decision other than Approve.");
				return false;
			}
		}
		
		if(Dec_CreditAnalyst=="Approve")
		{
			if (customform.document.getElementById("wdesk:FinalCreditApproverAuth").value == '')
			{
				alert("Please Enter Final Credit Approver Authority.");
				customform.document.getElementById("wdesk:FinalCreditApproverAuth").focus(true);
				return false;
			}
		}
		
		if(Dec_CreditAnalyst=="Reject to Business")
		{
			//customform.document.getElementById("wdesk:Dec_Credit_Analyst").value='Y'; // don't change it, used it for colour coding(blue colour), added in route
		}
		//Condition added on 22/02/2019
		if(Dec_CreditAnalyst=="Forward for First Level Credit Approver")
		{
			if(customform.document.getElementById("wdesk:First_Level_Credit_Approver").value.trim()=="")
			{
				alert("Please Enter value of First Level Credit Approver.");
				customform.document.getElementById("wdesk:First_Level_Credit_Approver").focus(true);
				return false;
			}
			
		}
		//Condition added on 22/02/2019
		if(Dec_CreditAnalyst=="Forward for Second Level Credit Approver")
		{
			if(customform.document.getElementById("wdesk:Second_Level_Credit_Approver").value.trim()=="")
			{
				alert("Please Enter value of Second Level Credit Approver.");
				customform.document.getElementById("wdesk:Second_Level_Credit_Approver").focus(true);
				return false;
			}
			
		}
		
		//Commented on 28/03/2019 as Limit Amount field has been removed.
		//Condition Added 28/02/2019 to make limit amount mandatory on Credit Analyst.
		/*if(customform.document.getElementById("wdesk:Limit_Amount").value=="" || customform.document.getElementById("wdesk:Limit_Amount").value=="NULL"  || customform.document.getElementById("wdesk:Limit_Amount").value=="null")
		{
			alert("Please Enter value of Limit Amount.");
			customform.document.getElementById("wdesk:Limit_Amount").focus(true);
			return false;
			
		}*/
		
		//Added on 26/02/2019 to set default value of Price_Change_Approval_Reqd as 'No'
		//alert("Before:---"+customform.document.getElementById("wdesk:Price_Change_Approval_Reqd").value);
		if(customform.document.getElementById("wdesk:Price_Change_Approval_Reqd").value=="" || customform.document.getElementById("wdesk:Price_Change_Approval_Reqd").value=="NULL"  || customform.document.getElementById("wdesk:Price_Change_Approval_Reqd").value=="null")
			customform.document.getElementById("wdesk:Price_Change_Approval_Reqd").value="No";
		//alert("After:--"+customform.document.getElementById("wdesk:Price_Change_Approval_Reqd").value);	
			
		//Added on 01/04/2019 to make MRA Archival Date Mandatory on Credit Analyst if decision is Approve
		/*if(Dec_CreditAnalyst=="Approve" && customform.document.getElementById("wdesk:MRA_Archival_Date").value.trim()=="")
		{
			alert("Please Enter MRA Archival Date." );
			customform.document.getElementById("wdesk:MRA_Archival_Date").focus(true);
			return false;
		}*/	
		
	}
	
	if(WSNAME == "CROPS_Disbursal_Maker")
	{
		if(selDecision=='Approve')
		{
			if (customform.document.getElementById('sign_matched_cropsDisbursal_maker').value != 'Yes')
			{
				alert("Signatures should be matched before selecting 'Approve' as decision");
				customform.document.getElementById("btnViewSign").focus(true);
				return false;
			}
			
			var statustemp = confirm('Please ensure HLNM tab is updated in Finacle.');
			if(statustemp == false)
				return false;
		}
	}
	
	if(WSNAME == "CROPS_Disbursal_Checker")
	{	
		if(selDecision=='Approve')
		{
			if (customform.document.getElementById('sign_matched_cropsDisbursal_checker').value != 'Yes')
			{
				alert("Signatures should be matched before selecting 'Approve' as decision");
				customform.document.getElementById("btnViewSign").focus(true);
				return false;
			}
			var currCheckList=customform.document.getElementById('H_CHECKLIST').value;
			if(currCheckList.indexOf('~[Raised')!=-1) // means some exception are raised
			{
				alert("Exceptions are raised, Kindly clear all exceptions"); 
				customform.document.getElementById("Exception_History").focus(true);
				return false;
			}
			
			var statustemp = confirm('Please ensure HLNM tab is updated in Finacle.');
			if(statustemp == false)
				return false;
		}
				
	}
	//##CR point 27052019## Facility_OuterLimitValidation**************		
	var facilityButtonDisable=customform.document.getElementById("add_row_Facility_Details");
	if(facilityButtonDisable.disabled == false)
		{	
			var tableFacility=customform.document.getElementById("Facility_Details_Grid");
			var rowCountFacility = tableFacility.rows.length;
			var Total_Faciltiy_Sought = "";
			var Parent_No = '';
			var flag="false";
			var Outer_Faciltiy_Sought = 0;
			if(rowCountFacility>1)
			{
				for(var i=1;i<rowCountFacility;i++)
				{
					var No=customform.document.getElementById("No"+i).value;	
					var Usage=customform.document.getElementById("Usage"+i).value;	
					var No_index;
					if (No != '')
					{
						if (Usage == 'Outer')
							No_index=No;	
						if (Usage == 'Inner')
							No_index=No.substring(0,No.length-1);	
					}						
					if(i == 1 || Parent_No != No_index)
					{
						if (Total_Faciltiy_Sought != '')
						{
							Total_Faciltiy_Sought=Total_Faciltiy_Sought.substring(0,Total_Faciltiy_Sought.length-1);
							if (Total_Faciltiy_Sought.indexOf(',') != -1)
							{
								Total_Faciltiy_Sought = Total_Faciltiy_Sought.split(',');
								for(var j=0;j<Total_Faciltiy_Sought.length;j++)
								{
									if (parseFloat(Total_Faciltiy_Sought[j]) > Outer_Faciltiy_Sought)
									{
										flag="true";
										break;
									}
									else
										flag="";
								}
								if(flag == 'true')
									break;
							}
							else if (parseFloat(Total_Faciltiy_Sought) > Outer_Faciltiy_Sought)
							{
								flag="true";
								break;
							}
							else
								flag="";
							
							Parent_No=No_index;	
							Outer_Faciltiy_Sought=0;
							Total_Faciltiy_Sought='';
							flag="false";							
						}
						else
						{						
							Parent_No=No_index;	
							Outer_Faciltiy_Sought=0;
							Total_Faciltiy_Sought='';
							flag="false";
						}					
					}				
					var Faciltiy_Sought=customform.document.getElementById("Faciltiy_Sought"+i).value;	
					//var alphabets = /^[a-z]+$/;
						
					if (Usage == 'Inner' && No.indexOf(No_index) != -1 )
					{					
						if (Faciltiy_Sought != '') {
							Faciltiy_Sought = Faciltiy_Sought.split(",").join("");
							Total_Faciltiy_Sought=Total_Faciltiy_Sought+Faciltiy_Sought+',';	
						}											
					}	
						
					if (Usage == 'Outer')
					{
						var outerFacTemp = customform.document.getElementById("Faciltiy_Sought"+i).value;
						if (outerFacTemp != '') {
							outerFacTemp = outerFacTemp.split(",").join("");
							Outer_Faciltiy_Sought=parseFloat(outerFacTemp);
						} else
							Outer_Faciltiy_Sought = 0;
					}	
				
				}
				
				if(flag == "false") // will be executed when one type of inner and outer are added
				{
					if (Total_Faciltiy_Sought != '')
					{
						Total_Faciltiy_Sought=Total_Faciltiy_Sought.substring(0,Total_Faciltiy_Sought.length-1);
						if (Total_Faciltiy_Sought.indexOf(',') != -1)
						{
							Total_Faciltiy_Sought = Total_Faciltiy_Sought.split(',');
							for(var j=0;j<Total_Faciltiy_Sought.length;j++)
							{
								if (parseFloat(Total_Faciltiy_Sought[j]) > Outer_Faciltiy_Sought)
								{
									flag="true";
									break;
								}
							}
						}
						else if (parseFloat(Total_Faciltiy_Sought) > Outer_Faciltiy_Sought)
						{
							flag="true";
						}
					}
				}
				
				if(flag == 'true')
				{			
					alert('Facility limit for inner to be less than or equal to outer limit of '+Parent_No);
					customform.document.getElementById("Facility_Details_Grid").focus();
					return false;
				}	
			}			
		}
		
		//*********************************************************************
	
	//Commented on 28/03/2019 as Limit Amount Field has been removed.
	//Condition Added on 01/03/2019
	//Workstepname modified on 04/03/2019
	/*if(WSNAME=="CROPS_Admin_Maker")
	{
		var tableTranche=customform.document.getElementById("Tranche_Details_Grid");
		var rowCountTranche = tableTranche.rows.length;
		var sumTrancheAmount=0;
		var limitAmount=customform.document.getElementById('wdesk:Limit_Amount').value.split(',').join('');
		for(var i=1;i<rowCountTranche;i++)
		{
			var trancheAmount=customform.document.getElementById('tranche_amount'+i).value.split(',').join('');
			if(trancheAmount =='')
				trancheAmount='0';
			sumTrancheAmount=sumTrancheAmount+parseFloat(trancheAmount, 10);
		}
		if(limitAmount=='')
			limitAmount='0';
		limitAmount=parseFloat(limitAmount, 10);
		
		if(limitAmount!=sumTrancheAmount)
		{
			alert('The sum of all Tranche Amounts in the grid should be equal to Limit Amount.');
			return false;
		}
	}*/
	//Condition Added on 04/03/2019
	var tableTranche=customform.document.getElementById("Tranche_Details_Grid");
	var rowCountTranche = tableTranche.rows.length;
	if(WSNAME=="CROPS_Admin_Checker")
	{
		if(customform.document.getElementById("wdesk:Deferral_Held").value=="")
			customform.document.getElementById("wdesk:Deferral_Held").value="No";
		
		
		//Added on 03/04/2019. New Validation added.
		var trancheButtonDisable=customform.document.getElementById("add_row_Tranche_Details");
		if(rowCountTranche>1 && trancheButtonDisable.disabled == false)
		{
			var countApproved=0;
			for(var i=1;i<rowCountTranche;i++)
			{
				var status=customform.document.getElementById("tranche_status"+i).value;
				if(status=='Approve')
					countApproved++;
				else 
					break;
			}
			if(selDecision=='Approve')
			{
				if(rowCountTranche>1 && countApproved !=(rowCountTranche-1))
				{
					alert("Please select some other Decision as all Tranche status are not Approved.");
					return false;
				
				}
			}
		}
		
		customform.document.getElementById("wdesk:Dec_CROPS_Admin_Checker").value=selDecision;
		
	}
	
	//Added on 05/04/2019
	//##CR Point 27052019## to remove CROPS_Disbursal_Maker,CROPS_Disbursal_Checker Worksteps from below mandatory condition
	if(WSNAME=="CROPS_Admin_Maker" || WSNAME=='CROPS_Admin_Checker')
	{
		var trancheButtonDisable=customform.document.getElementById("add_row_Tranche_Details");
		if(rowCountTranche>1 && trancheButtonDisable.disabled == false)
		{
			for(var i=1;i<rowCountTranche;i++)
			{
				var tranchedisbursaldate=customform.document.getElementById("tranche_disbursal_date"+i).value;
				var trancheavailableperiod=customform.document.getElementById("tranche_available_period"+i).value;
				if(tranchedisbursaldate!=""&&trancheavailableperiod!="")
				{
					//do nothing
					continue;
					
				}
				else
				{
					alert("Please provide Available Period, Disbursal Date in Tranche Details Grid.")
					return false;
				}
			}
		}
		
	}
	//****************************************************************************************************************************
	return true;
}

//Added by Sajan to check mandatory doc types
function AttachedDocType(sDocTypeNames)
{
	var arrAvailableDocList = getInterfaceData("D");
	//var arrAvailableDocList = document.getElementById('wdesk:docCombo');
	//if (arrAvailableDocList == null || arrAvailableDocList == 'null')
		//arrAvailableDocList = customform.document.getElementById('wdesk:docCombo');
	var arrSearchDocList = sDocTypeNames.split(",");
	//alert("arrSearchDocList"+arrSearchDocList);
	var bResult=false;
	// condition added for not to check mandatory when decision is reject on 05092017

	for(var iSearchCounter=0;iSearchCounter<arrSearchDocList.length;iSearchCounter++)
	{
		bResult=false;
		for(var iDocCounter=0;iDocCounter<arrAvailableDocList.length;iDocCounter++)
		{
			//alert("arrSearchDocList---"+arrSearchDocList[iSearchCounter]);
			//alert("arrAvailableDocList---"+arrAvailableDocList[iDocCounter].name);
			//if(arrAvailableDocList[iDocCounter].name == arrSearchDocList[iSearchCounter]){
			if (arrAvailableDocList[iDocCounter].name.toUpperCase().indexOf(arrSearchDocList[iSearchCounter].toUpperCase()) >= 0) {
				bResult = true;
				break;
			}
		}
		if(!bResult){
		alert("Please attach " + arrSearchDocList[iSearchCounter]+" to proceed further.");
		return false;
		}
	}            
		
	return true;
}
//Convert date in mm/dd/yyyy hh:mm:ss ampm format
function formatAMPM(date) 
{

	var month=date.getMonth()+1;
	var currdate =date.getDate();
	var year =date.getFullYear();
	var hours = date.getHours();
	var minutes = date.getMinutes();
	var seconds=date.getSeconds();
	//var ampm = hours >= 12 ? 'PM' : 'AM';
	//hours = hours % 12;
	//hours = hours ? hours : 12; // the hour '0' should be '12'
	minutes = minutes < 10 ? '0'+minutes : minutes;
	seconds=seconds<10?'0'+seconds:seconds;
	var strTime = currdate+"/" +month +"/"+year+" "+hours+":"+ minutes +":"+seconds;
	return strTime;
}
function checkMasterFacilityValueonDone()
{
	var master_facility_value=customform.document.getElementById("wdesk:Master_Facility_Limit").value.split(',').join('');
	var totalFacilitySought=customform.document.getElementById("wdesk:Total_Facility_Sought").value.split(',').join('');
	if(master_facility_value==""||master_facility_value==null)
		master_facility_value="0";
	if(totalFacilitySought==""||totalFacilitySought==null)
		totalFacilitySought="0";
	
	master_facility_value=parseFloat(master_facility_value, 10);
	totalFacilitySought=parseFloat(totalFacilitySought, 10)
	if(master_facility_value!=totalFacilitySought){
		var ifProceed=confirm('Warning: Total Facility Sought & Master Facility Limit are not equal. Do you want to proceed');
		if(!ifProceed)
		{
			return false;
		}
		else{
		return true;
		
		}
	}
	return true;
}

function checkForUIDException()
{
	var flag=true;
	var UIDTable=customform.document.getElementById("UID_Grid");
	if(UIDTable.rows.length>1) 
	{
	  //then need to raise UID Exception
	  var WSNAME =customform.document.getElementById("wdesk:Current_WS").value;
	  var currCheckList=customform.document.getElementById('H_CHECKLIST').value;
	  var currUser=customform.document.getElementById('wdesk:IntoducedBy').value;
	  
	  //alert('found '+currCheckList.indexOf('001~[Raised'));
	  if(currCheckList.indexOf('001~[Raised')==-1)//Means this exception is not raised as of now 1-means UID exception
	  {
		if(currCheckList=='')
			currCheckList='001~[Raised-'+currUser+'-'+WSNAME+'-'+getDateTime()+']';
		else
			currCheckList=currCheckList+'#'+'001~[Raised-'+currUser+'-'+WSNAME+'-'+getDateTime()+']';
		
		customform.document.getElementById('H_CHECKLIST').value=currCheckList;
		flag=true;
	  }
	  flag=true;
	}
	else
	flag=false;
	
	return flag;
}
function getDateTime()
{
	var monthNames = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
	now = new Date();
	year = "" + now.getFullYear();
	month = "" + monthNames[now.getMonth()];
	day = "" + now.getDate(); if (day.length == 1) { day = "0" + day; }
	hour = "" + now.getHours(); if (hour.length == 1) { hour = "0" + hour; }
	minute = "" + now.getMinutes(); if (minute.length == 1) { minute = "0" + minute; }
	second = "" + now.getSeconds(); if (second.length == 1) { second = "0" + second; }
	return day + "/" + month + "/" + year + "  " + hour + ":" + minute + ":" + second;
}