/*------------------------------------------------------------------------------------------------------
                                                NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group                                       									: Application -Projects
Project/Product                                               					: RAKBANK- AO
Module                                                            				: Populate and save custom values  
File Name                                                       				: Validation_AO.js		 	
Author                                                             				: Amandeep
Date (DD/MM/YYYY)                         										: 2-Feb-2015
Description                                                      				: Validate Methods to be called from client.js
																			  -------------------------------------------------------------------------------------------------------
CHANGE HISTORY
-------------------------------------------------------------------------------------------------------
Problem No/CR No   Change Date   Changed By    Change Description
------------------------------------------------------------------------------------------------------*/

function Validate(NameData,iframeDocument,IsDoneClicked)
{
//alert("inside validate");
	if(IsDoneClicked)
	{
		NameData=NameData.substring(0,(NameData.lastIndexOf("~")));
		//alert("NameData :"+NameData);
		var arr=NameData.split('~');
		for(var i = 0; i < arr.length; i++)
		{
			var temp=arr[i].split('#');
			var id=temp[0];
			var pattern=temp[1];
			var isMandatory=temp[2];
			var labelName=temp[3];
			labelName=labelName.replace('*','');
			
			var isRepeatable=temp[5];
			var type=temp[6];
			if(isRepeatable!='Y') //changed on 30june14
			{
				if(labelName=='FINACLE SR. No.')
				{
				    var customform=''; 
					var formWindow=getWindowHandler(windowList,"formGrid"); 
					customform=formWindow.frames['customform']; 
					
					var srNo=iframeDocument.getElementById(id).value;
					var srCheck=srNo.substring(0,2);
					if(customform.document.getElementById("wdesk:WS_NAME").value=='CSM' && srCheck!='SR')
					{
					alert("Finacle SR no. should start with SR");
					return false;
					}
					
					//alert(customform.document.getElementById("wdesk:WS_NAME").value);
					if(customform.document.getElementById("wdesk:WS_NAME").value=='CSM' && (iframeDocument.getElementById("1_Decision").value=='Hold' || iframeDocument.getElementById("1_Decision").value=='Rejected'))
					{
						isMandatory='N';
						//alert('setting is mandatory as N');
					}
				
				}
				if(isMandatory=='Y')
				{	
				    
					if(!ValidateMandatory(id,labelName,iframeDocument,type))
					return false;
				}
				
				if(labelName=="CIF Id")
				{ 
				   
					var cifId=iframeDocument.getElementById(id).value;
					var cifIdLength=cifId.length;
					
					if(cifId!='' && !ValidateNumeric(id,labelName,iframeDocument))
						return false;
					
					if(cifIdLength!=0 && cifIdLength<7)
					{
						alert("CIFID should be 7 digits numeric value");
						return false;
					}					
				}
					
				//Custom Validations
				var OPSMakerUserDecision=iframeDocument.getElementById("1_Decision").value;
				var validateMandatoryFields=true;
				if(OPSMakerUserDecision=='Rejected' ||OPSMakerUserDecision=='Hold' )
					validateMandatoryFields=false;
				if(labelName.indexOf("Customer Name")==0 && validateMandatoryFields)
				{
					var customform='';
					var formWindow=getWindowHandler(windowList,"formGrid");
					customform=formWindow.frames['customform'];
					var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
					var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;

					 if(WSNAME=='OPS_Maker')
					{
						var arrAvailableDocList = document.getElementById('wdesk:docCombo');
						var isDocAttached=false;	
						var isValuePresent=false;	
						if(labelName=='Customer Name 1')
						{
							for(var iDocCounter=0;iDocCounter<arrAvailableDocList.length;iDocCounter++){
								if(arrAvailableDocList[iDocCounter].text.toUpperCase().indexOf('SIGNATURE_1')>-1)
								{
									isDocAttached=true;
									break;
								}	
							}
							var value=iframeDocument.getElementById(id).value.replace(/^\s+|\s+$/g, '');
							if(value!="")
							{
								isValuePresent=true;								
							}
						}
						else if(labelName=='Customer Name 2')
						{
							for(var iDocCounter=0;iDocCounter<arrAvailableDocList.length;iDocCounter++){
								if(arrAvailableDocList[iDocCounter].text.toUpperCase().indexOf('SIGNATURE_2')>-1)
								{
									isDocAttached=true;
									break;
								}	
							}
							var value=iframeDocument.getElementById(id).value.replace(/^\s+|\s+$/g, '');
							if(value!="")
							{
								isValuePresent=true;								
							}
						}else if(labelName=='Customer Name 3')
						{
							for(var iDocCounter=0;iDocCounter<arrAvailableDocList.length;iDocCounter++){
								if(arrAvailableDocList[iDocCounter].text.toUpperCase().indexOf('SIGNATURE_3')>-1)
								{
									isDocAttached=true;
									break;
								}	
							}
							var value=iframeDocument.getElementById(id).value.replace(/^\s+|\s+$/g, '');
							if(value!="")
							{
								isValuePresent=true;								
							}
						}else if(labelName=='Customer Name 4')
						{
							for(var iDocCounter=0;iDocCounter<arrAvailableDocList.length;iDocCounter++){
								if(arrAvailableDocList[iDocCounter].text.toUpperCase().indexOf('SIGNATURE_4')>-1)
								{
									isDocAttached=true;
									break;
								}	
							}
							var value=iframeDocument.getElementById(id).value.replace(/^\s+|\s+$/g, '');
							if(value!="")
							{
								isValuePresent=true;								
							}
						}
						if(isDocAttached && !isValuePresent)
						{
							alert("Number of Signatures do not match with Number of Customer Names. Please crop the signatures or enter Customer Name.");
							iframeDocument.getElementById(id).focus();
							return false;	
						}
						else if(!isDocAttached && isValuePresent)
						{
							alert("Number of Signatures do not match with Number of Customer Names. Please crop the signatures or enter Customer Name.");
							iframeDocument.getElementById(id).focus();
							return false;	
						}						
					}					
				}
				
				//Account No validations
				
				if(labelName=='Add Account No')
				{
					if(WSNAME=='OPS_Checker')
					{
						
						var H_RejectReasons=customform.document.getElementById("H_RejectReasons").value;
						var rejectReasonsSelected = false;
						if(H_RejectReasons!='')
							rejectReasonsSelected=true;//val4
							
						var OPSMakerDecision = customform.document.getElementById("OPSMakerDecision").value;	
							
						var currUserDecision=iframeDocument.getElementById("1_Decision").value;
						var fetchAccounts=true;
						if(currUserDecision=='Reject to OPS Maker' || currUserDecision=='Reject to CSO' || currUserDecision=='Hold' || OPSMakerDecision=='CIF Edit Done' || currUserDecision=='High Risk')
							fetchAccounts=false;

						//added by ankit 17102017 for CQRN- 
							if(currUserDecision=='Account Opened' && OPSMakerDecision=='CIF Edit Done') 
							{
							  
							  alert("Please Select Appropriate Decision");
							  iframeDocument.getElementById("1_Decision").focus();
							  return false;
							
							}
						//added by ankit 17102017 for CQRN- 	
							
						//added by Badri 07062018 
						var rvcImdChecked = iframeDocument.getElementById("1_RVC_IMD_Req").checked;
						if(rvcImdChecked && rejectReasonsSelected && currUserDecision=='Account Opened' )
							{
							  
							  alert("Please select decision either Rejected or Hold as Reject Reasons are selected.");
							  iframeDocument.getElementById("1_Decision").focus();
							  return false;
							
							}
						//added by Badri 07062018 
						
						if(!rejectReasonsSelected && fetchAccounts)
						{
							if(!iframeDocument.getElementsByName("Fetch")[0].disabled && currUserDecision=='Account Opened')
							{
								alert("Please Fetch Accounts");
								iframeDocument.getElementsByName("Fetch")[0].focus();
								return false;


							}	
														
							else if(currUserDecision=='RVC/IMD Approved' && OPSMakerDecision!='RVC/IMD Done') 
							{
							  
							  alert("Please Select Appropriate Decision");
							  iframeDocument.getElementById("1_Decision").focus();
							  return false;
							
							}
							
							var element = iframeDocument.getElementById("1_Account_No_2");		
							var addedAccounts = element.options.length;
							var requiredAccounts = iframeDocument.getElementById("1_No_of_Accounts").value;
							if(addedAccounts>=0 && addedAccounts<requiredAccounts)
							{
								alert("Total accounts added are less than the required no of accounts.");
								iframeDocument.getElementById(id).disabled=false;
								iframeDocument.getElementById(id).focus();
								return false;


							}	
							if(addedAccounts>=0 && addedAccounts>requiredAccounts)
							{
								alert("No of accounts should be equal to the total no of accounts fetched.");
								iframeDocument.getElementById("1_No_of_Accounts").focus();
								return false;
							}	
						}
					}
				}
				
				//Validate Decision based on Reject Reasons
				if(labelName=='Decision')
				{	
					var customform='';
					var formWindow=getWindowHandler(windowList,"formGrid");
					customform=formWindow.frames['customform'];
					
					var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
					var rejectReasonField="H_RejectReasons";
					if(WSNAME=='WM_Controls')
					{
						rejectReasonField="WMCtrlRejectReasons";
						if(iframeDocument.getElementById(id).value=='Recommended')
						{
							var H_RejectReasons=customform.document.getElementById(rejectReasonField).value;
							if(H_RejectReasons!='')
							{
								alert("Reject Reasons are selected, cannot recommend the case");
								iframeDocument.getElementById(id).focus();
								return false;
							}	
						}
					}
					else if(WSNAME=='SME_Controls')
					{
						rejectReasonField="SMECtrlRejectReasons";
						if(iframeDocument.getElementById(id).value=='Recommended')
						{
							var H_RejectReasons=customform.document.getElementById(rejectReasonField).value;
							if(H_RejectReasons!='')
							{
								alert("Reject Reasons are selected, cannot recommend the case");
								iframeDocument.getElementById(id).focus();
								return false;
							}	
						}
					}
					else if(WSNAME=='Branch_Controls')
					{
						rejectReasonField="BranchCtrlRejectReasons";
						if(iframeDocument.getElementById(id).value=='Recommended')
						{
							var H_RejectReasons=customform.document.getElementById(rejectReasonField).value;
							if(H_RejectReasons!='')
							{
								alert("Reject Reasons are selected, cannot recommend the case");
								iframeDocument.getElementById(id).focus();
								return false;
							}	
						}
					}
					else if(WSNAME=='Controls')
					{
						rejectReasonField="H_RejectReasons";
						if(iframeDocument.getElementById(id).value=='Recommended' || iframeDocument.getElementById(id).value=='Approve')
						{
							var H_RejectReasons=customform.document.getElementById(rejectReasonField).value;
							if(H_RejectReasons!='')
							{
								alert("Reject Reasons are selected, cannot Recommend/Approve the case");
								iframeDocument.getElementById(id).focus();
								return false;
							}	
						}
					}
					else if(WSNAME=='PB_Credit')
					{
						rejectReasonField="PBCreditRejectReasons";						
					}
					//----------------------------------OPS MAKER -----------------------------------
					else if(WSNAME=='OPS_Maker')
					{					
						var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
						var OPSCheckerDecision = customform.document.getElementById("OPSCheckerDecision").value;
						if(OPSCheckerDecision==null||OPSCheckerDecision=='null')
							OPSCheckerDecision='';
						var accountsFetched =false;
						if(iframeDocument.getElementById("1_Account_No_2")!=null)
						{
							var accountNumbers = iframeDocument.getElementById("1_Account_No_2").options.length;
							if(accountNumbers!=0)
								accountsFetched=true; //val1
								
						}
						
						var rvcImdChecked = iframeDocument.getElementById("1_RVC_IMD_Req").checked;//val3
						var rvc_package = iframeDocument.getElementById("1_rvc_package").value;
						
						var H_RejectReasons=customform.document.getElementById("H_RejectReasons").value;
						var rejectReasonsSelected = false;
						if(H_RejectReasons!='')
							rejectReasonsSelected=true;//val4
						
						// Setting Primary Customer Name added on 28072019
						customform.document.getElementById("wdesk:qPrimaryCustomerName").value=iframeDocument.getElementById("1_customer_name1").value;
						// Setting Purpose of Account added on 28072019
						customform.document.getElementById("wdesk:qPurposeOfAccount").value=iframeDocument.getElementById("1_PurposeOfAccount").value;
						
						var decisionTaken=iframeDocument.getElementById(id).value;//val5
						
						if(OPSCheckerDecision=='CIF Edit Approved' ) 
						{
							if(accountsFetched)//accounts fetched
							{
								//Maker-1,Maker-2,Maker-3,Maker-4,Maker-5,Maker-6,Maker-7,Maker-8
								alert("Wrong case, Accounts have been fetched and OPS Checker decision is CIF Edit Approved.");
								return false;
							}
							else
							{
								if(rejectReasonsSelected)
								{
									if(rvcImdChecked && (rvc_package=='' || rvc_package==null || rvc_package=='null' || rvc_package=='--Select--'))
									{
										//Maker-13
										alert("Please Select RVC Package");
										return false;
									}
									else if(!rvcImdChecked && !(rvc_package=='' || rvc_package==null || rvc_package=='null' || rvc_package=='--Select--'))
									{
										alert("RVC/IMD Requested should be checked if RVC Package has been selected");
										return false;											
									}
									else
									{
										if(!(decisionTaken=='Rejected' || decisionTaken=='Hold' || decisionTaken=='Reject to OPS Maker' || decisionTaken=='Reject to CSO'))
										{
											//Maker-14
											alert("Please select decision either Rejected or Hold as Reject Reasons are selected.");
											return false;
										}
									}
								}
								else
								{
									if(rvcImdChecked && (rvc_package=='' || rvc_package==null || rvc_package=='null' || rvc_package=='--Select--'))
									{
										//Maker-15
										alert("Please Select RVC Package");
										return false;
									}
									else if(!rvcImdChecked && !(rvc_package=='' || rvc_package==null || rvc_package=='null' || rvc_package=='--Select--'))
									{
										alert("RVC/IMD Requested should be checked if RVC Package has been selected");
										return false;											
									}
									else
									{
										if(decisionTaken!='Data Entry Done'  && decisionTaken!='Hold')
										{
											//Maker-16
											alert("Please select decision either Data Entry Done or Hold.");
											return false;
										}
									}
								}
															
							}
						}
						else if(OPSCheckerDecision=='Reject to OPS Maker' ||  OPSCheckerDecision=='Reject to CSO') 
						{
							if(accountsFetched)//accounts fetched
							{
								if(rejectReasonsSelected)
								{
									if(rvcImdChecked && (rvc_package=='' || rvc_package==null || rvc_package=='null' || rvc_package=='--Select--'))
									{
										//Maker-21
										//alert("Please clear Reject Reasons as account has been opened.");
										alert("Please select RVC Package");
										return false;
									}
									else
									{
										//Maker-22
										alert("RVC/IMD Requested should be checked if RVC Package has been selected");
										return false;
									}
								}
								else
								{
									if(rvcImdChecked)
									{
										if(decisionTaken!='Hold')
										{
											//Maker-23
											//alert("Please select decision RVC/IMD Done or Hold.");
											alert("Please select decision as Hold.");
											//alert("Once Account is opened, OPS MAKER can only update decision as \"RVC/IMD DONE or HOLD\".");

											return false;
										}
									}
									else if(rvcImdChecked && (rvc_package=='' || rvc_package==null || rvc_package=='null' || rvc_package=='--Select--'))
									{

										//Maker-24
										alert("RVC/IMD Requested should be checked if RVC Package has been selected");
										return false;

									}
								}
								
							}
							else
							{
								if(rejectReasonsSelected)
								{
									if(rvcImdChecked && (rvc_package=='' || rvc_package==null || rvc_package=='null' || rvc_package=='--Select--'))
									{
										//Maker-29
										alert("Please select RVC Package");
										return false;
									}
									else if(!rvcImdChecked && !(rvc_package=='' || rvc_package==null || rvc_package=='null' || rvc_package=='--Select--'))
									{
										alert("RVC/IMD Requested should be checked if RVC Package has been selected");
										return false;											
									}
									else
									{
										if(!(decisionTaken=='Rejected' || decisionTaken=='Hold' || decisionTaken=='Reject to OPS Maker' || decisionTaken=='Reject to CSO'))//18
										{
											//Maker-30
											alert("Please select decision either Rejected or Hold as Reject Reasons are selected.");
											return false;
										}
									}
								}
								else
								{
									if(rvcImdChecked && (rvc_package=='' || rvc_package==null || rvc_package=='null' || rvc_package=='--Select--'))
									{
										//Maker-31
										alert("Please select RVC Package");
										return false;
									}
									else if(!rvcImdChecked && !(rvc_package=='' || rvc_package==null || rvc_package=='null' || rvc_package=='--Select--'))
									{
										alert("RVC/IMD Requested should be checked if RVC Package has been selected");
										return false;											
									}
									else
									{
										if(decisionTaken!='CIF Edit Done' && decisionTaken!='Data Entry Done' && decisionTaken!='Hold' && decisionTaken!='High Risk')
										{
										
											if(decisionTaken=='Rejected' || decisionTaken=='Reject to OPS Maker' || decisionTaken=='Reject to CSO')
											{
												 alert("Please select Reject Reasons to reject the case.");
												 return false;
											}
											else{
												alert("Please select decision either CIF Edit Done or Data Entry Done or Hold or High Risk.");
												return false;
											}
										}
									}
								}
															
							}
						}
						else if(OPSCheckerDecision=='Account Opened' ) 
						{
							if(accountsFetched)//accounts fetched
							{
								if(rejectReasonsSelected)
								{
									if(rvcImdChecked && (rvc_package=='' || rvc_package==null || rvc_package=='null' || rvc_package=='--Select--'))
									{
										//Maker-37
										//alert("Please clear Reject Reasons as account has been opened.");
										alert("Please select RVC Package");
										return false;
									}
									else if(!rvcImdChecked && !(rvc_package=='' || rvc_package==null || rvc_package=='null' || rvc_package=='--Select--'))
									{
										//Maker-38

										alert("RVC/IMD Requested should be checked if RVC Package has been selected");
										return false;
									}
								}
								else
								{
									if(rvcImdChecked)
									{
										if(decisionTaken!='Hold')
										{
											//Maker-39
											alert("Please select decision as Hold.");
											return false;
										}
									}
									else if(!rvcImdChecked && !(rvc_package=='' || rvc_package==null || rvc_package=='null' || rvc_package=='--Select--'))
									{
										//Maker-40

										alert("RVC/IMD Requested should be checked if RVC Package has been selected");
										return false;
									}
								}
								
							}
							else
							{
								//Maker-41,Maker-42,Maker-43,Maker-44,Maker-45,Maker-46,Maker-47,Maker-48
								alert("Wrong Case, accounts are not fetched but OPS checker decision was Account opened.");
								return false;						
							}
						}
						else if(OPSCheckerDecision=='' ) 
						{
							if(accountsFetched)//accounts fetched
							{
								//Maker-49,Maker-50,Maker-51,Maker-52,Maker-53,Maker-54,Maker-55,Maker-56
								alert("Wrong case, Accounts have been fetched and OPS Checker decision is blank.");
								return false;
							}
							else
							{
								if(rejectReasonsSelected)
								{
									if(rvcImdChecked && (rvc_package=='' || rvc_package==null || rvc_package=='null' || rvc_package=='--Select--'))
									{
										//Maker-61
										alert("Please select RVC Package");
										return false;
									}
									else if(!rvcImdChecked && !(rvc_package=='' || rvc_package==null || rvc_package=='null' || rvc_package=='--Select--'))
									{
										alert("RVC/IMD Requested should be checked if RVC Package has been selected");
										return false;											
									}
									else
									{
										if(!(decisionTaken=='Rejected' || decisionTaken=='Hold' || decisionTaken=='Reject to OPS Maker' || decisionTaken=='Reject to CSO'))
										{
											//Maker-62
											alert("Please select decision either Rejected or Hold as Reject Reasons are selected.");
											return false;
										}
									}	
								}
								else
								{
									
									if(rvcImdChecked && (rvc_package=='' || rvc_package==null || rvc_package=='null' || rvc_package=='--Select--'))
									{
										//Maker-63
										alert("Please select RVC Package");
										return false;
									}
									else if(!rvcImdChecked && !(rvc_package=='' || rvc_package==null || rvc_package=='null' || rvc_package=='--Select--'))
									{
										alert("RVC/IMD Requested should be checked if RVC Package has been selected");
										return false;											
									}
									else
									{
										if(decisionTaken!='CIF Edit Done' && decisionTaken!='Data Entry Done' && decisionTaken!='Hold' && decisionTaken!='High Risk')
										{
										
											 if(decisionTaken=='Rejected')
											 {
												  alert("Please select Reject Reasons to reject the case");
												  return false;
											 }
											 //Maker-64
											 else{
												alert("Please select decision either CIF Edit Done or Data Entry Done or Hold or High Risk.");
												return false;
											 }
										}
									}										
								}
								
							}		
						}
						//code added to return false if Signature_1 is not present

						var Sign1Attached=false;
						var arrAvailableDocList = document.getElementById('wdesk:docCombo');
						for(var iDocCounter1=0;iDocCounter1<arrAvailableDocList.length;iDocCounter1++)
						{ 					    
							if(arrAvailableDocList[iDocCounter1].text.toUpperCase().indexOf('SIGNATURE_1')>-1)
							{
								Sign1Attached=true;
								break;
							}
						} 
						if(!Sign1Attached && !(decisionTaken=='Rejected' || decisionTaken=='Hold' ))
						{
							alert("Signature is mandatory. Please crop the signatures manually.");
							return false;
						}
						
						// Start - block added to make AECB document attachment mandatory added on 11042019
						if (decisionTaken=='Data Entry Done' || decisionTaken=='CIF Edit Done' || decisionTaken=='RVC/IMD Done')
						{
							 var CustomerType=iframeDocument.getElementById("1_Customer_Type").value;
							 if (CustomerType=='New to UAE' || CustomerType=='New to RAKBANK')
							 {
								 var AECB_Result=iframeDocument.getElementById("1_AECB_Result").value;
								 if (AECB_Result == '' || AECB_Result == '--Select--')
								 {
									 alert("Kindly select AECB Result.");
									 iframeDocument.getElementById("1_AECB_Result").focus(true);
									 return false;
								 }
								 
								 var arrAddedDocList=document.getElementById('wdesk:docCombo');
								 var isAECBAttached=false;
								 
								 for(var ixDoc=0;ixDoc<arrAddedDocList.length;ixDoc++)
								 {
									if(arrAddedDocList[ixDoc].text.toUpperCase().indexOf('AECB')>-1)
									{
										 isAECBAttached=true;
										 break;
									}
								 }
								 if(!isAECBAttached)
								 {
									 alert("Kindly attach AECB Document.");
									 return false;
								 }
							 }
							 
							 var CIFType=iframeDocument.getElementById("1_CIFTYPE").value;
							 if (CIFType == '' || CIFType == '--Select--')
							 {
								 alert("Kindly select CIF Type.");
								 iframeDocument.getElementById("1_CIFTYPE").focus(true);
								 return false;
							 }
						}
						// End - block added to make AECB document attachment mandatory added on 11042019

						//Start - Making Risk Score Details Dcoument atrachment mandatory added on 11062019
						if (decisionTaken=='High Risk')
						{
							 var arrAddedDocList1=document.getElementById('wdesk:docCombo');
							 var isRiskAttached=false;
							 for(var ixDoc=0;ixDoc<arrAddedDocList1.length;ixDoc++)
							 {
								if(arrAddedDocList1[ixDoc].text.toUpperCase().indexOf('RISK_SCORE_DETAIL')>-1)
								{
									 isRiskAttached=true;
									 break;
								}
							 }
							 if(!isRiskAttached)
							 {
								 alert("Kindly attach Risk Score Detail Document.");
								 return false;
							 }
							 
							// Start - Mandating Purpose of Account when high risk decision is taken added on 28072019
							if(iframeDocument.getElementById("1_PurposeOfAccount").value == '' || iframeDocument.getElementById("1_PurposeOfAccount").value == '--Select--')
							{
								alert("Kindly select Purpose of Account.");
								iframeDocument.getElementById("1_PurposeOfAccount").focus(true);
								return false;
							}
							// End - Mandating Purpose of Account when high risk decision is taken added on 28072019
						} 
 					   //End - Making Risk Score Details Dcoument atrachment mandatory added on 11062019
						//code added to set the value of IsSignatureCropped flag
						var count=0;
						 var arrAvailableDocList = document.getElementById('wdesk:docCombo');
                         for(var iDocCounter=0;iDocCounter<arrAvailableDocList.length;iDocCounter++){
								if(arrAvailableDocList[iDocCounter].text.toUpperCase().indexOf('SIGNATURE_')>-1)
								{
									count++;
								}	
							}						 

						if(customform.document.getElementById("NoOfSignatures").value!=count)
                        {
						   customform.document.getElementById("IsSignatureCropped").value='Y';
                        }
					}
					else if(WSNAME=='CB-WC Maker')
					{
						var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
						var email_pattern=/^(("".+?"")|([0-9a-zA-Z](((\.(?!\.))|([-!#\$%&'\*\+/=\?\^`\{\}\|~\w]))*[0-9a-zA-Z])*))@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9}$/;
						var x = customform.document.getElementById('wdesk:eMail').value;
						var decisionTaken=iframeDocument.getElementById(id).value;
						
						if(customform.document.getElementById("wdesk:Mobile_Number").value=="")
						{
							alert("Mobile Number is mandatory");
							customform.document.getElementById("wdesk:Mobile_Number").focus();
							return false;
						}if(customform.document.getElementById("wdesk:Mobile_Country_Code").value=="")
						{
							alert("Mobile Country code is mandatory");
							customform.document.getElementById("wdesk:Mobile_Country_Code").focus();
							return false;
						}if(!(x.match(email_pattern))){
							alert("Please Enter Valid Email ID");
							setFocusOnField(customform,customform.document.getElementById("wdesk:eMail"));		
							return false;    
						}if(customform.document.getElementById("wdesk:eMail").value=="")
						{
							alert("Email Id is mandatory");
							customform.document.getElementById("wdesk:eMail").focus();
							return false;
						}if(customform.document.getElementById("wdesk:Retail_or_Corporate").value=="")
						{
							alert("Retail/Corporate is mandatory to select");
							customform.document.getElementById("wdesk:Retail_or_Corporate").focus();
							return false;
						} 
					
						// Start - block added to make AECD document attachment mandatory added on 25032019
						if (decisionTaken=='Submit')
						{
							 var CustomerType=iframeDocument.getElementById("1_Customer_Type").value;
							 if (CustomerType=='New to UAE' || CustomerType=='New to RAKBANK')
							 {
								 var AECB_Result=iframeDocument.getElementById("1_AECB_Result").value;
								 if (AECB_Result == '' || AECB_Result == '--Select--')
								 {
									 alert("Kindly select AECB Result.");
									 iframeDocument.getElementById("1_AECB_Result").focus(true);
									 return false;
								 }
								 
								 var arrAddedDocList=document.getElementById('wdesk:docCombo');
								 var isAECBAttached=false;
								 
								 for(var ixDoc=0;ixDoc<arrAddedDocList.length;ixDoc++)
								 {
									if(arrAddedDocList[ixDoc].text.toUpperCase().indexOf('AECB')>-1)
									{
										 isAECBAttached=true;
										 break;
									}
								 }
								 if(!isAECBAttached)
								 {
									 alert("Kindly attach AECB Document.");
									 return false;
								 }
							 }
						}
						// End - block added to make AECD document attachment mandatory added on 25032019
					}
					
					else if(WSNAME=='CB-WC Checker')
					{
						
						var email_pattern=/^(("".+?"")|([0-9a-zA-Z](((\.(?!\.))|([-!#\$%&'\*\+/=\?\^`\{\}\|~\w]))*[0-9a-zA-Z])*))@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9}$/;
						var y = customform.document.getElementById('wdesk:eMail').value;
						if(customform.document.getElementById("wdesk:Mobile_Number").value=="")
						{
							alert("Mobile Number is mandatory");
							customform.document.getElementById("wdesk:Mobile_Number").focus();
							return false;
						}if(customform.document.getElementById("wdesk:Mobile_Country_Code").value=="")
						{
							alert("Mobile Country code is mandatory");
							customform.document.getElementById("wdesk:Mobile_Country_Code").focus();
							return false;
						}if(!(y.match(email_pattern))){
							alert("Please Enter Valid Email ID");
							setFocusOnField(customform,customform.document.getElementById("wdesk:eMail"));		
							return false;    
						}if(customform.document.getElementById("wdesk:eMail").value=="")
						{
							alert("Email Id is mandatory");
							customform.document.getElementById("wdesk:eMail").focus();
							return false;
						}if(customform.document.getElementById("wdesk:Retail_or_Corporate").value=="")
						{
							alert("Retail/Corporate is mandatory to select");
							customform.document.getElementById("wdesk:Retail_or_Corporate").focus();
							return false;
						} 
						
		
						var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
						var decisionTaken=iframeDocument.getElementById(id).value;
						var H_RejectReasons=customform.document.getElementById("H_RejectReasons").value;
						
						var rejectReasonsSelected = false;
						if(H_RejectReasons!='')
							rejectReasonsSelected=true;

							
						if(decisionTaken=='Approved')
						{
						  if(rejectReasonsSelected==true )
						  {

						   alert("Please clear Reject Reasons if you are selecting decision \"Approved\".");
							return false;
						  }
						}
						
						// Start - block added to make AECD document attachment mandatory added on 11042019
						if (decisionTaken=='Approved' || decisionTaken=='No Additional UID Found')
						{
							 var CustomerType=iframeDocument.getElementById("1_Customer_Type").value;
							 if (CustomerType=='New to UAE' || CustomerType=='New to RAKBANK')
							 {
								 var AECB_Result=iframeDocument.getElementById("1_AECB_Result").value;
								 if (AECB_Result == '' || AECB_Result == '--Select--')
								 {
									 alert("Kindly select AECB Result.");
									 iframeDocument.getElementById("1_AECB_Result").focus(true);
									 return false;
								 }
								 
								 var arrAddedDocList=document.getElementById('wdesk:docCombo');
								 var isAECBAttached=false;
								 
								 for(var ixDoc=0;ixDoc<arrAddedDocList.length;ixDoc++)
								 {
									if(arrAddedDocList[ixDoc].text.toUpperCase().indexOf('AECB')>-1)
									{
										 isAECBAttached=true;
										 break;
									}
								 }
								 if(!isAECBAttached)
								 {
									 alert("Kindly attach AECB Document.");
									 return false;
								 }
							 }
						}
						// End - block added to make AECD document attachment mandatory added on 11042019
					}
					//----------------------------------OPS CHECKER -----------------------------------
					else if(WSNAME=='OPS_Checker')
					{					
						var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
						
						var OPSMakerDecision = customform.document.getElementById("OPSMakerDecision").value;
						var email_pattern=/^(("".+?"")|([0-9a-zA-Z](((\.(?!\.))|([-!#\$%&'\*\+/=\?\^`\{\}\|~\w]))*[0-9a-zA-Z])*))@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9}$/;
						var x = customform.document.getElementById('wdesk:eMail').value;
						if(customform.document.getElementById("wdesk:Mobile_Number").value=="")
						{
							alert("Mobile Number is mandatory");
							customform.document.getElementById("wdesk:Mobile_Number").focus();
							return false;
						}if(customform.document.getElementById("wdesk:Mobile_Country_Code").value=="")
						{
							alert("Mobile Country code is mandatory");
							customform.document.getElementById("wdesk:Mobile_Country_Code").focus();
							return false;
						}if(!(x.match(email_pattern))){
							alert("Please Enter Valid Email ID");
							setFocusOnField(customform,customform.document.getElementById("wdesk:eMail"));		
							return false;    
						}if(customform.document.getElementById("wdesk:eMail").value=="")
						{
							alert("Email Id is mandatory");
							customform.document.getElementById("wdesk:eMail").focus();
							return false;
						}if(customform.document.getElementById("wdesk:Retail_or_Corporate").value=="")
						{
							alert("Retail/Corporate is mandatory to select");
							customform.document.getElementById("wdesk:Retail_or_Corporate").focus();
							return false;
						} 
						
						var accountNumbers = iframeDocument.getElementById("1_Account_No_2").options.length;
						var accountsFetched =false;
						if(accountNumbers!=0)
							accountsFetched=true; //val1
						
						
						var rvcImdChecked = iframeDocument.getElementById("1_RVC_IMD_Req").checked;//val3
						
						var H_RejectReasons=customform.document.getElementById("H_RejectReasons").value;
						var rejectReasonsSelected = false;
						if(H_RejectReasons!='')
							rejectReasonsSelected=true;//val4
						
						// Setting Purpose of Account added on 28072019
						customform.document.getElementById("wdesk:qPurposeOfAccount").value=iframeDocument.getElementById("1_PurposeOfAccount").value;
						
						var decisionTaken=iframeDocument.getElementById(id).value;//val5
						
						if(OPSMakerDecision=='Data Entry Done' ) 
						{
							if(accountsFetched)//accounts fetched
							{
								if(rejectReasonsSelected)
								{
									if(rvcImdChecked)
									{
										//Checker-5
											alert("Please clear Reject Reasons as accounts have been fetched.");
											return false;
									}
									else
									{
										//Checker-6
											alert("Please clear Reject Reasons as accounts have been fetched.");
											return false;
									
									}
								}
								else
								{
									if(rvcImdChecked)
									{
										if(decisionTaken!='Account Opened' && decisionTaken!='Hold')
										{
											//Checker-7
											alert("Please select decision either Account Opened or Hold.");
											return false;
										}
									}
									else
									{
										if(decisionTaken!='Account Opened' && decisionTaken!='Hold')
										{
											//Checker-8
											alert("Please select decision either Account Opened or Hold.");
											return false;
										}
									}
								}
								
							}
							else
							{
								if(rejectReasonsSelected)
								{
									if(rvcImdChecked)
									{
										//Checker-13
										//alert("Wrong case RVC/IMD should be disabled.");
										//return false;
									}
									else
									{
										if(!(decisionTaken=='Rejected' || decisionTaken=='Hold' || decisionTaken=='Reject to OPS Maker' || decisionTaken=='Reject to CSO'))
										{
											//Checker-14
											alert("Please select decision either Rejected or Hold as Reject Reasons are selected.");
											return false;
										}
									}
								}
								else
								{
									if(rvcImdChecked)
									{
										//Checker-15
										//alert("Wrong case RVC/IMD should be disabled.");
										//return false;
									}
									else
									{
										//Checker-16
										if(decisionTaken!='Reject to OPS Maker' && decisionTaken!='Reject to CSO' && decisionTaken!='Hold' && decisionTaken!='High Risk')
										{
											alert("Please select either Rejected or Hold");
											return false;
										}	
									}
								}
															
							}
						}
						else if(OPSMakerDecision=='CIF Edit Done' ) 
						{
							if(accountsFetched)//accounts fetched
							{
								//Checker-17,Checker-18,Checker-19,Checker-20,Checker-21,Checker-22,Checker-23,Checker-24
								alert("Wrong case accounts have been fetched, CIF Edit Done Decision by OPS Maker.");
								return false;
							}
							else
							{
								if(rejectReasonsSelected)
								{
									if(rvcImdChecked)
									{
										//Checker-29
										//alert("Wrong case RVC IMD checked, Accounts have not been fetched.");
										//return false;
									}
									else
									{
										if(!(decisionTaken=='Rejected' || decisionTaken=='Hold' || decisionTaken=='Reject to OPS Maker' || decisionTaken=='Reject to CSO'))
										{
											//Checker-30
											alert("Please select decision either Rejected or Hold as Reject Reasons are selected.");
											return false;
										}	
									}
								}
								else
								{
									if(rvcImdChecked)
									{
										//Checker-31
										//alert("Wrong case RVC IMD checked, Accounts have not been fetched.");
										//return false;
									}
									else
									{
										if(decisionTaken!='CIF Edit Approved' && decisionTaken!='Rejected' && decisionTaken!='Hold' && decisionTaken!='High Risk')
										{
											//Checker-32
											alert("Please select decision either CIF Edit Approved or Rejected or Hold or High Risk.");
											return false;
										}
									}
								}
															
							}
						}
						else if(OPSMakerDecision=='Exception Found' ) 
						{
							if(accountsFetched)//accounts fetched
							{
								if(rejectReasonsSelected)
								{
									if(rvcImdChecked)
									{
										//Checker-37
										alert("Please clear  Reject Reasons as accounts have been fetched.");
										return false;
									}
									else
									{
										//Checker-38
										alert("Please clear Reject Reasons as accounts have been fetched.");
										return false;
									}
								}
								else
								{
									if(rvcImdChecked)
									{
										if(decisionTaken!='Account Opened' && decisionTaken!='Hold')
										{
											//Checker-39
											alert("Please select decision either Account Opened or Hold.");
											return false;
										}
									}
									else
									{
										if(decisionTaken!='Account Opened' && decisionTaken!='Hold')
										{
											//Checker-40
											alert("Please select decision either Account Opened or Hold.");
											return false;
										}
									}
								}
								
							}
							else
							{
								if(rejectReasonsSelected)
								{
									if(rvcImdChecked)
									{
										//Checker-45
										alert("Wrong Case Exception Found not possible from OPS Maker after account has been opened.");
										return false;
									}
									else
									{
										
										if(!(decisionTaken=='Rejected' || decisionTaken=='Hold' || decisionTaken=='Reject to OPS Maker' || decisionTaken=='Reject to CSO'))
										{
											//Checker-46
											alert("Please select decision either Rejected or Hold as Reject Reasons are selected.");
											return false;
										}
									}
								}
								else
								{
									if(rvcImdChecked)
									{
										//Checker-47
										alert("Wrong Case Exception Found not possible from OPS Maker after account has been opened.");
										return false;
									}
									else
									{
										//Checker-48
										if(decisionTaken!='Rejected' && decisionTaken!='Hold')
										{
											alert("Please fetch Accounts or select decision as rejected or hold.");
											return false;
										}	
									}
								}
															
							}
						}
						else if(OPSMakerDecision=='RVC/IMD Done') 
						{
							if(accountsFetched)//accounts fetched
							{
								if(rejectReasonsSelected)
								{
									if(rvcImdChecked)
									{
										if(!(decisionTaken=='Rejected' || decisionTaken=='Hold' || decisionTaken=='Reject to OPS Maker' || decisionTaken=='Reject to CSO'))
										{
											//Checker-53
											alert("Please select decision either Rejected or Hold as Reject Reasons are selected.");
											return false;
										}
									}
									else
									{
										//Checker-54
										alert("Wrong Case RVC IMD Done not possible if RVC IMD unchecked not fetched.");
										return false;
									}
								}
								else
								{
									if(rvcImdChecked)
									{
										if(decisionTaken!='RVC/IMD Approved' && decisionTaken!='Hold')
										{
											//Checker-55
											alert("Please select decision either RVC/IMD Approved or Hold.");
											return false;
										}
									}
									else
									{
										//Checker-56
										alert("Wrong Case RVC IMD Done not possible if RVC IMD unchecked not fetched.");
										return false;											
									}
								}
								
							}
							else
							{
								//Checker-57,Checker-58,Checker-59,Checker-60,Checker-61,Checker-62,Checker-63,Checker-64
								alert("Wrong Case RVC IMD Done not possible if Accounts not fetched.");
								return false;
							}
						}
						
						// Start - block added to make AECB document attachment mandatory added on 11042019
						if (decisionTaken=='Account Opened' || decisionTaken=='CIF Edit Approved' || decisionTaken=='RVC/IMD Approved')
						{
							 var CustomerType=iframeDocument.getElementById("1_Customer_Type").value;
							 if (CustomerType=='New to UAE' || CustomerType=='New to RAKBANK')
							 {
								 var AECB_Result=iframeDocument.getElementById("1_AECB_Result").value;
								 if (AECB_Result == '' || AECB_Result == '--Select--')
								 {
									 alert("Kindly select AECB Result.");
									 iframeDocument.getElementById("1_AECB_Result").focus(true);
									 return false;
								 }
								 
								 var arrAddedDocList=document.getElementById('wdesk:docCombo');
								 var isAECBAttached=false;
								 
								 for(var ixDoc=0;ixDoc<arrAddedDocList.length;ixDoc++)
								 {
									if(arrAddedDocList[ixDoc].text.toUpperCase().indexOf('AECB')>-1)
									{
										 isAECBAttached=true;
										 break;
									}
								 }
								 if(!isAECBAttached)
								 {
									 alert("Kindly attach AECB Document.");
									 return false;
								 }
							 }
							 
							 var CIFType=iframeDocument.getElementById("1_CIFTYPE").value;
							 if (CIFType == '' || CIFType == '--Select--')
							 {
								 alert("Kindly select CIF Type.");
								 iframeDocument.getElementById("1_CIFTYPE").focus(true);
								 return false;
							 }
						}
						// End - block added to make AECB document attachment mandatory added on 11042019
						
						// Start - Mandating Purpose of Account when high risk decision is taken added on 28072019
						if (decisionTaken=='High Risk')
						{
							if(iframeDocument.getElementById("1_PurposeOfAccount").value == '' || iframeDocument.getElementById("1_PurposeOfAccount").value == '--Select--')
							{
								alert("Kindly select Purpose of Account.");
								iframeDocument.getElementById("1_PurposeOfAccount").focus(true);
								return false;
							}
						}
						// End - Mandating Purpose of Account when high risk decision is taken added on 28072019
					}
					
					// Start - Making Reject Reason mandatory at AML_Compliance added on 02012019
					else if(WSNAME=='AML_Compliance')
					{
						if(iframeDocument.getElementById(id).value=='Rejected' && customform.document.getElementById('wdesk:Previous_Step').value != 'Approval Units')
						{
							alert("Cannot take Rejected decision, Please take Reject to CSO/OPS decision");
							return false;
						}
						var remarks=iframeDocument.getElementById('1_Remarks').value;
						var remarksLength=remarks.length;
						if(remarksLength == 0){
							alert("Please enter Remarks");
							return false;
						}
						if(iframeDocument.getElementById(id).value=='Reject to OPS')
						{
							if(customform.document.getElementById('wdesk:Previous_Step').value == 'Approval Units')
							{
								alert("Reject to OPS Decision cannot be selected as the workitem was submitted by Controls");
								return false;
							}
							var H_RejectReasons=customform.document.getElementById(rejectReasonField).value;
							if(H_RejectReasons=='')
							{
								alert("Please select Reject Reasons to reject the case");
								return false;
							}	
						}					
					}
					// End - Making Reject Reason mandatory at AML_Compliance added on 02012019
					
					// Start - Making Reject Reason mandatory at Compliance added on 11042019
					else if(WSNAME=='Compliance')
					{
						if(iframeDocument.getElementById(id).value=='Approved' || iframeDocument.getElementById(id).value=='Hold' || iframeDocument.getElementById(id).value=='Reject to OPS' || iframeDocument.getElementById(id).value=='Reject to CSO')
						{
							var remarks=iframeDocument.getElementById('1_Remarks').value;
							var remarksLength=remarks.length;
							if(remarksLength == 0){
								alert("Please enter Remarks");
								return false;
							}
						}
						if(iframeDocument.getElementById(id).value=='Reject to OPS' || iframeDocument.getElementById(id).value=='Reject to CSO')
						{
							var H_RejectReasons=customform.document.getElementById(rejectReasonField).value;
							if(H_RejectReasons=='')
							{
								alert("Please select Reject Reasons to reject the case");
								return false;
							}	
						}					
					}
					// End - Making Reject Reason mandatory at Compliance added on 11042019
					
					else if(WSNAME=='CSO_Rejects')
					{
						var email_pattern=/^(("".+?"")|([0-9a-zA-Z](((\.(?!\.))|([-!#\$%&'\*\+/=\?\^`\{\}\|~\w]))*[0-9a-zA-Z])*))@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9}$/;
						var x = customform.document.getElementById('wdesk:eMail').value;
						if(customform.document.getElementById("wdesk:Mobile_Number").value=="")
						{
							alert("Mobile Number is mandatory");
							customform.document.getElementById("wdesk:Mobile_Number").focus();
							return false;
						}if(customform.document.getElementById("wdesk:Mobile_Country_Code").value=="")
						{
							alert("Mobile Country code is mandatory");
							customform.document.getElementById("wdesk:Mobile_Country_Code").focus();
							return false;
						}if(!(x.match(email_pattern))){
							alert("Please Enter Valid Email ID");
							setFocusOnField(customform,customform.document.getElementById("wdesk:eMail"));		
							return false;    
						}if(customform.document.getElementById("wdesk:eMail").value=="")
						{
							alert("Email Id is mandatory");
							customform.document.getElementById("wdesk:eMail").focus();
							return false;
						}if(customform.document.getElementById("wdesk:Retail_or_Corporate").value=="")
						{
							alert("Retail/Corporate is mandatory to select");
							customform.document.getElementById("wdesk:Retail_or_Corporate").focus();
							return false;
						} 
					}
					/*else if(WSNAME=='CSM')
					{
					 var arrAddedDocList=document.getElementById('wdesk:docCombo');
					 var isSignAttached=false;
					 
					 for(var ixDoc=0;ixDoc<arrAddedDocList.length;ixDoc++)
					 {
					    if(arrAddedDocList[ixDoc].text.toUpperCase().indexOf('SIGNATURE_')>-1)
						{
						     isSignAttached=true;
							 break;
						}
					 }
					 var currUserDecision=iframeDocument.getElementById("1_Decision").value;
					 if(!isSignAttached && currUserDecision!='Rejected')
					 {
					 alert("No signatures attached with the case, please crop signature(s) manually.");
					 return false;
					 }
					}*/
					
					//return false;	
					if(iframeDocument.getElementById(id).value=='Rejected' || iframeDocument.getElementById(id).value=='Reject to OPS Maker' || iframeDocument.getElementById(id).value=='Reject to CSO' || iframeDocument.getElementById(id).value=='Reject to CB-WC Maker')
					{
						if(WSNAME=='CSO_Rejects')
						{

							var ArchivalTeamDecision = customform.document.getElementById("ArchivalTeamDecision").value;
							if(ArchivalTeamDecision==null||ArchivalTeamDecision=='null')
								ArchivalTeamDecision='';
								
							if(ArchivalTeamDecision=='Rejected')
							{
								alert("Cannot reject the case as accounts have been fetched");
								return false;
							}	
						}
						var H_RejectReasons=customform.document.getElementById(rejectReasonField).value;						
						if(H_RejectReasons=='')
						{
							alert("Please select Reject Reasons to reject the case");
							return false;
						}							
					}
					else if(iframeDocument.getElementById(id).value=='Resubmit')
					{      
					      var alertDisplayed=customform.document.getElementById("alertDisplayed").value;
					      if(WSNAME=='CSO_Rejects' && alertDisplayed=='')
					      {
							 alert("Please see the Reject Reasons");
							 //customform.document.getElementById("alertDisplayed").value="done";
							 return false;
						  }
					}
					else if(iframeDocument.getElementById(id).value=='Approved')
					{
						var H_RejectReasons=customform.document.getElementById(rejectReasonField).value;						
						if(H_RejectReasons!='' && WSNAME!='Error')
						{
							alert("Reject Reasons are selected, cannot approve the case");
							iframeDocument.getElementById(id).focus();
							return false;
						}	
						//Check for Controls if final approval unit
						
						if(WSNAME=='WM_Controls' || WSNAME=='SME_Controls' || WSNAME=='Branch_Controls')
						{
							var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
							var FinalApprovalUnit = IsFinalApprovalUnit(WSNAME,WINAME);
							var ControlsFinalApproval=false;
							if(FinalApprovalUnit=='0')
								ControlsFinalApproval=true;
								
							if(!ControlsFinalApproval)	
							{
								alert("Please select decision as Recommended");
								iframeDocument.getElementById(id).focus();
								return false;
							}	
						}
					}else if(iframeDocument.getElementById(id).value=='Recommended')
					{
						var H_RejectReasons=customform.document.getElementById(rejectReasonField).value;						
						if(H_RejectReasons!='')
						{
							alert("Reject Reasons are selected, cannot recommend the case");
							iframeDocument.getElementById(id).focus();
							return false;
						}	
						//Check for Controls if final approval unit
						
						if(WSNAME=='WM_Controls' || WSNAME=='SME_Controls' ||WSNAME=='Branch_Controls')
						{
							var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
							var FinalApprovalUnit = IsFinalApprovalUnit(WSNAME,WINAME);
							var ControlsFinalApproval=false;
							if(FinalApprovalUnit=='0')
								ControlsFinalApproval=true;
								
							if(ControlsFinalApproval)	
							{
								alert("Please select decision as Approved");
								iframeDocument.getElementById(id).focus();
								return false;
							}	
						}
					}
				}	
				

				if(labelName=="Remarks (Word Limit: 3000 Chars)")
				{
					var customform='';
					var formWindow=getWindowHandler(windowList,"formGrid");
					customform=formWindow.frames['customform'];
					var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
					
					
					
					if(WSNAME=='CSO_Rejects')
					{
						var remarks=iframeDocument.getElementById(id).value;
						var remarksLength=remarks.length;
						if(remarksLength == 0){
							alert("Please enter Remarks");
							return false;
						}
					}
					
					else if(WSNAME=='WM_Controls' || WSNAME=='SME_Controls' || WSNAME=='Branch_Controls' || WSNAME=='Controls')
					{

					  var Item_Code = CheckIfOthersSelected(WSNAME);
					  var H_RejectReasons=customform.document.getElementById(rejectReasonField).value;
					  var n=H_RejectReasons.indexOf(Item_Code);
					  var remarks=iframeDocument.getElementById(id).value;
					  var remarksLength=remarks.length;
					  if(remarksLength == 0)
					 {
					  if(n>-1)
					  {
					    alert("Remarks are mandatory");
						iframeDocument.getElementById(id).focus();
						return false;
					  }
					  else
					  {
					  
					  }
					}
				   }
				   
				   else if(WSNAME=='CSM')
				   {
				      var Item_Code = CheckIfOthersSelected(WSNAME);
					  var H_RejectReasons=customform.document.getElementById(rejectReasonField).value;
					  var n=H_RejectReasons.indexOf(Item_Code);
					  var H_Checklist=customform.document.getElementById("H_Checklist").value;
					  var m=H_Checklist.indexOf("Unraised");  
					  var remarks=iframeDocument.getElementById(id).value;
					  var remarksLength=remarks.length;
					  if(remarksLength == 0)
					  {
					   if(n>-1)
					   {
					    alert("Remarks are mandatory");
						iframeDocument.getElementById(id).focus();
						return false;
					   }
					    
					 }
					 else
					 {
					 
					 }
					 
				   }
			
				   else if(WSNAME=='OPS_Maker' || WSNAME=='OPS_Checker')
				   {
				     var Item_Code = CheckIfOthersSelected('OPS'); 
				     var H_RejectReasons=customform.document.getElementById("H_RejectReasons").value;
					 var n=H_RejectReasons.indexOf(Item_Code+":");
					 var remarks=iframeDocument.getElementById(id).value;
					 var remarksLength=remarks.length;
					 if(remarksLength == 0)
					 {
					 if(n>-1)
					  {
					    alert("Remarks are mandatory");
						iframeDocument.getElementById(id).focus();
						return false;
					  }
					  else
					  {
					  
					  }
					}
				   }
			    }
				
				if(pattern=='Numeric' || pattern=='nonzeronumeric')
				{
					if(!ValidateNumeric(id,labelName,iframeDocument))
					return false;
					
					if(labelName='No. of Accounts')
					{
						//
					}
				}
				
			}
		}
	}
	return true;
	
}

function IsExceptionRaised(WSNAME,workitemName)
{
	var ajaxReq;
	if (window.XMLHttpRequest) {
		ajaxReq= new XMLHttpRequest();
	} else if (window.ActiveXObject) {
		ajaxReq= new ActiveXObject("Microsoft.XMLHTTP");
	}
		var customform='';
		var formWindow=getWindowHandler(windowList,"formGrid");
		customform=formWindow.frames['customform'];
		var H_Checklist=customform.document.getElementById("H_Checklist").value;
		
	var url = sContextPath+"/CustomForms/AO_Specific/CheckIfExceptionRaised.jsp?CheckFor="+WSNAME+"&WorkitemName="+workitemName+"&H_Checklist="+H_Checklist;

	ajaxReq.open("POST",url,false); 
	ajaxReq.setRequestHeader('Content-Type','application/x-www-form-urlencoded');	
	ajaxReq.send(null);
	if (ajaxReq.status == 200 && ajaxReq.readyState == 4) 
	{
		var result=ajaxReq.responseText.split("~");
		return  result[0];
	}
	else
	{
		alert("some error occured while fetching exception status");
		return -1;
	}
}

function IsFinalApprovalUnit(WSNAME,workitemName)
{
	var ajaxReq;
	if (window.XMLHttpRequest) {
		ajaxReq= new XMLHttpRequest();
	} else if (window.ActiveXObject) {
		ajaxReq= new ActiveXObject("Microsoft.XMLHTTP");
	}
		//var customform='';
		//var formWindow=getWindowHandler(windowList,"formGrid");
		//customform=formWindow.frames['customform'];
		//var H_Checklist=customform.document.getElementById("H_Checklist").value;
		
	var url = sContextPath+"/CustomForms/AO_Specific/IsFinalApprovalUnit.jsp?WorkstepName="+WSNAME+"&WorkitemName="+workitemName;//"&H_Checklist="+H_Checklist;

	ajaxReq.open("POST",url,false); 
	ajaxReq.setRequestHeader('Content-Type','application/x-www-form-urlencoded');	
	ajaxReq.send(null);
	if (ajaxReq.status == 200 && ajaxReq.readyState == 4) 
	{
		var result=ajaxReq.responseText.split("~");
		return  result[0];
	}
	else
	{
		alert("some error occured while fetching exception status");
		return -1;
	}
	
	
}

function CheckIfOthersSelected(WSNAME)
{
	var ajaxReq;
	if (window.XMLHttpRequest) {
		ajaxReq= new XMLHttpRequest();
	} else if (window.ActiveXObject) {
		ajaxReq= new ActiveXObject("Microsoft.XMLHTTP");
	}
		//var customform='';
		//var formWindow=getWindowHandler(windowList,"formGrid");
		//customform=formWindow.frames['customform'];
		//var H_Checklist=customform.document.getElementById("H_Checklist").value;
		
	var url = sContextPath+"/CustomForms/AO_Specific/CheckIfOthersSelected.jsp?WorkstepName="+WSNAME;

	ajaxReq.open("POST",url,false); 
	ajaxReq.setRequestHeader('Content-Type','application/x-www-form-urlencoded');	
	ajaxReq.send(null);
	if (ajaxReq.status == 200 && ajaxReq.readyState == 4) 
	{
		var result=ajaxReq.responseText.split("~");
		return  result[0];
	}
	else
	{
		alert("some error occured while fetching Others code");
		return -1;
	}
	
	
}

function TrimValue(val){
    var character = ' ';

	val = new String(val);
	var len = val.length;
    if(len != 0)
	{
		while(1)
		{
			if(val.charAt(0) != character)
			{
				break;
			}
			else
			{
				val = val.substr(1);
			}
		}
	}

	len = val.length;
	if(len != 0)
	{
		while(1)
		{
			if(val.charAt(len - 1) != character)
			{
				return val;
			}
			else
			{
				len -= 1;
				val = val.substr(0,len);
			}
		}
	}
     return val;
}

function ValidateMandatory(id,labelName,iframeDocument,type){
	 
	 var labelName=labelName.replace('*','');
	 if(typeof(type)=="undefined" || type=='')
	{	
		var value=iframeDocument.getElementById(id).value;
		value=TrimValue(value);
		if(value=="")
		{
			alert("Please enter "+labelName);
			//alert("Validating from here");
			iframeDocument.getElementById(id).value="";
			iframeDocument.getElementById(id).focus();
			return false;
		}
		else 
			return true;
	}
	else if(type=="select")
	{	
		var element = iframeDocument.getElementById(id);
		
		var selectedValue = element.options[element.selectedIndex].value;
		
		if(selectedValue=='--Select--')
		{
			alert("Please select "+labelName);
			iframeDocument.getElementById(id).focus();
			return false;
		}
		else 
			return true;
		
	}
	else if(type=='radio')
	{
		//alert("in radio");
		var ele = iframeDocument.getElementsByName(id);
		var eleID;
		var flag=0;
		for(var i = 0; i < ele.length; i++)
		{	
			if(ele[i].checked)
			{	
				flag=1;
			}
		}
		if(flag==0)
		{
			alert("Please select "+id.substring(2).replace('_',' ')+".");
			return false;
		}
		else
		 return true;
	
	}
	else if(type=='checkbox')
	{
		if (!iframeDocument.getElementById(id).checked)
		{
			alert("Please select "+labelName+" checkbox."); //final by Manish Grover
			iframeDocument.getElementById(id).focus();
			return false;
		}
		else
		 return true;
	}
	else
	{
		alert(type);
		alert("No match.");
		return false;
	}
}

function ValidateNumeric(id,labelName,iframeDocument){
    var labelName=labelName.replace('*','');
	var inputtxt=iframeDocument.getElementById(id);
	var numbers = /^[0-9]+$/; 
	if(inputtxt.value.match(numbers)) 
	return true; 
	else 
	{ 
		alert('Please input numeric characters only in '+labelName+".");
		iframeDocument.getElementById(id).value="";
		iframeDocument.getElementById(id).focus();
		return false; 
	} 

}
