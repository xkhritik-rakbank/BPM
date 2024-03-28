/*------------------------------------------------------------------------------------------------------
                                                NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group                                       									: Application -Projects
Project/Product                                               					: RAKBANK- SRM
Application                                                      				: Service Request Module 
Module                                                            				: Custom Validations 
File Name                                                       				: Custom_Validations.js		 	
Author                                                             				: Deepti Sharma, Aishwarya Gupta	 
Date (DD/MM/YYYY)                         										: 29-Apr-2014
Description                                                      				: This file contains all custom functions
																				  required for every service request
-------------------------------------------------------------------------------------------------------
CHANGE HISTORY
-------------------------------------------------------------------------------------------------------

Problem No/CR No   Change Date   Changed By    Change Description
------------------------------------------------------------------------------------------------------*/

window.document.write("<script src=\"/webdesktop/webtop/scripts/SRM_Scripts/SRM_constants.js\"></script>");
var donesuccess=false;
function Custom_Validation(NameData,iframeDocument,customform,CategoryID,SubCategoryID,IsDoneClicked,fobj)
{	

if(SubCategoryID=='1'&&CategoryID=='1')
		{
			
			var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
			var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
			var CardNo=customform.document.getElementById("d_PANno").value;
			var WS_LogicalName=iframeDocument.getElementById("WS_LogicalName").value; //d
			var PANno=iframeDocument.getElementById("PANno").value;
			PANno=PANno.split("+").join("ENCODEDPLUS");
			var encryptedkeyid = customform.document.getElementById("wdesk:encryptedkeyid").value.split("+").join("ENCODEDPLUS");
			var tr_table = iframeDocument.getElementById("tr_table").value;	
			var cblimitamount="";
			var duplicateReq;
			if(WSNAME!='Introduction' && WSNAME!='PBO' )
			{	
				var decision = iframeDocument.getElementById("1_Decision").value;
				customform.document.getElementById("wdesk:Decision").value=decision;
				
			}
			NameData=NameData.substring(0,(NameData.lastIndexOf("~")));
			var arr=NameData.split('~');
			var IsError= true;
			if(WSNAME=='Introduction' || WSNAME=='PBO') //d
			{	
				var Requested_Cash_Back_Amount=parseInt(iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value);
				var Cash_Back_Eligible_Amount=parseInt(iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value);
				//Code changes to compare the masters for card sub type and card status by Aishwarya
				var Card_Status = iframeDocument.getElementById("1_CCI_CStatus").value;
				var Card_SubType = iframeDocument.getElementById("1_CCI_CST").value;
				var xhr;

				if(window.XMLHttpRequest)  xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)  xhr=new ActiveXObject("Microsoft.XMLHTTP");
				if(WSNAME=='PBO')
				{
					var url="/webdesktop/CustomForms/SRM_Specific/Custom_Validation_CBR.jsp?PANno="+encryptedkeyid+"&WINAME="+WINAME+"&tr_table="+tr_table+"&cardsubtype="+Card_SubType+"&cardstatus="+Card_Status+"&WSNAME="+WSNAME+"&IsDoneClicked="+IsDoneClicked+"&amount="+Requested_Cash_Back_Amount;
				}
				xhr.open("GET",url,false); 
				xhr.send(null);
				if (xhr.status == 200 && xhr.readyState == 4)
				{
					ajaxResult=myTrim(xhr.responseText);
					duplicateReq = ajaxResult.split("~");
				}
				else
				{
					alert("Error in Duplicate workitem validation");
					return false;
				}

				//checking status
				if(parseInt(duplicateReq[2])!=0)
				{
					iframeDocument.getElementById("1_Non_Eligibility_Reason").value="Card Status - "+Card_Status+" - Customer is not eligible for Cash Back Redemption";
					iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value='';
					iframeDocument.getElementById("1_Approved_Cash_Back_Amount").value='';
					iframeDocument.getElementById("1_IsError").value='Y';
					iframeDocument.getElementById("1_Cash_Back_Eligibility").value="N";
				}
				//checking subtype
				else if(parseInt(duplicateReq[3])!=0)
				{
					iframeDocument.getElementById("1_Non_Eligibility_Reason").value="Card Sub Type - "+Card_SubType+" - Customer is not eligible for Cash Back Redemption";
					iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value='';
					iframeDocument.getElementById("1_Approved_Cash_Back_Amount").value='';
					iframeDocument.getElementById("1_IsError").value='Y';
					iframeDocument.getElementById("1_Cash_Back_Eligibility").value="N";
				}					
				iframeDocument.getElementById("1_Is_Prime_Up").value=duplicateReq[4];
				iframeDocument.getElementById("1_Cardno_Masked").value=CardNo;
				iframeDocument.getElementById("1_IsPrimeUpdated").value="N";
				var t=0;
				for(var i = 0; i < arr.length; i++)
				{
					var temp=arr[i].split('#');
					var id=temp[0];
					var pattern=temp[1];
					var isMandatory=temp[2];
					var labelName=temp[3];
					var type=temp[4];  
					if(iframeDocument.getElementById("1_IsError").value==''||iframeDocument.getElementById("1_IsError").value=='N'||iframeDocument.getElementById("1_IsError").value=='NULL')
					{
						if(labelName=='Cash Back Eligibile Amount' && parseInt(iframeDocument.getElementById(id).value)<=0)
						{
							
							iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value='';
							iframeDocument.getElementById("1_Approved_Cash_Back_Amount").value='';
							t+=1;
							iframeDocument.getElementById("1_Non_Eligibility_Reason").value+=(t)+". "+"Available Redemption Amount is either less than or equal to Zero. ";
							iframeDocument.getElementById("1_Cash_Back_Eligibility").value="N";
							IsError=false;
						}
						if(labelName=='Cash Back Eligibile Amount'&& parseInt(iframeDocument.getElementById(id).value)<parseInt(iframeDocument.getElementById("CashBackLimit").value))
						{	
							iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value='';
							iframeDocument.getElementById("1_Approved_Cash_Back_Amount").value='';
							t+=1;
							iframeDocument.getElementById("1_Non_Eligibility_Reason").value+=(t)+". "+"Cash Back Eligibile Amount is less than "+iframeDocument.getElementById("CashBackLimit").value+". ";
							iframeDocument.getElementById("1_Cash_Back_Eligibility").value="N";
							
							IsError=false;
						}
						if(labelName=='Card Holder Type' && iframeDocument.getElementById(id).value=='Secondary' && iframeDocument.getElementById("1_CCI_CT").value=='Credit Card')
						{
							iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value='';
							iframeDocument.getElementById("1_Approved_Cash_Back_Amount").value='';
							t+=1;
							iframeDocument.getElementById("1_Non_Eligibility_Reason").value+=t+". "+"Not a Primary Card Customer - Customer is not eligible for Cash Back Redemption. ";
							iframeDocument.getElementById("1_Cash_Back_Eligibility").value="N";
							IsError=false;
						}
					}
				}
				cblimitamount=parseInt(duplicateReq[5]);
				if(parseInt(iframeDocument.getElementById("1_Approved_Cash_Back_Amount").value)<=cblimitamount && (iframeDocument.getElementById("1_IsError").value==''||iframeDocument.getElementById("1_IsError").value=='N'||iframeDocument.getElementById("1_IsError").value=='NULL') && iframeDocument.getElementById("1_Cash_Back_Forfeited").value=='N' && iframeDocument.getElementById("1_Disputed_Transaction").value=='N')
				{
					iframeDocument.getElementById("1_IsSTP").value="Y";
				}
				else 
				{
					iframeDocument.getElementById("1_IsSTP").value="N";
				}	
				
				if(!IsError)
				{
					if(parseInt(iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value)>parseInt(iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value))
					{	
						if(parseInt(iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value)>parseInt(iframeDocument.getElementById("CashBackLimit").value))
						{	
							//alert("hello");
							alert("Requested Cash Back Amount cannot be greater than "+iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value+".");
							iframeDocument.getElementById("1_Requested_Cash_Back_Amount").focus();
							
							return false;
						}
					}
					else				
					{	
						if(parseInt(iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value)<parseInt(iframeDocument.getElementById("CashBackLimit").value))
						{	alert("Requested Cash Back Amount cannot be less than " + iframeDocument.getElementById("CashBackLimit").value+".");
							iframeDocument.getElementById("1_Requested_Cash_Back_Amount").focus();
							iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value=iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value;
							iframeDocument.getElementById("1_Approved_Cash_Back_Amount").value=iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value;
							return false;
						}
						else
							iframeDocument.getElementById("1_Approved_Cash_Back_Amount").value=iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value;
					}
					
					if(!IsDoneClicked)
					{
						alert("Customer is not eligible for Cash Back Redemption.");
					}
					
					iframeDocument.getElementById("1_IsError").value="Y";
					return false;
				}
				else
				{
					if(parseInt(iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value)>parseInt(iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value))
					{	
						//alert("from custom valdiation");
						alert("Requested Cash Back Amount cannot be greater than "+iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value+".");
						iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value=iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value;
						iframeDocument.getElementById("1_Approved_Cash_Back_Amount").value=iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value;
						iframeDocument.getElementById("1_Requested_Cash_Back_Amount").focus();
						return false;
					}
					else				
					{	
						if(parseInt(iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value)<parseInt(iframeDocument.getElementById("CashBackLimit").value))
						{	alert("Requested Cash Back Amount cannot be less than " + iframeDocument.getElementById("CashBackLimit").value+".");
							iframeDocument.getElementById("1_Requested_Cash_Back_Amount").focus();
							iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value=iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value;
							iframeDocument.getElementById("1_Approved_Cash_Back_Amount").value=iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value;
							
							return false;
						}
						else 
							iframeDocument.getElementById("1_Approved_Cash_Back_Amount").value=iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value;
					}
					
					if(iframeDocument.getElementById("1_IsError").value!='Y')
					{	
						iframeDocument.getElementById("1_IsError").value="N";
						iframeDocument.getElementById("1_Cash_Back_Eligibility").value="Y";
					}
					else
					{
						if(!IsDoneClicked)
						{
							alert("Customer is not eligible for Cash Back Redemption.");
						}
					}
				}
				if(IsDoneClicked && iframeDocument.getElementById("1_IsError").value=='N')	
				{
					if(iframeDocument.getElementById("1_Cash_Back_Eligibility").value=="Y")
					{
						if(iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value=="")
						{
							alert("Requested Cash Back Amount cannot be blank.")
							return false;
						}
					}
					if(duplicateReq[0]=='RequestInvalid')
					{
						alert("Cash Back request no. "+duplicateReq[1].substring(0,15)+" for amount "+Requested_Cash_Back_Amount+"  is under process. Please initiate  request for a different cash back amount if customer is eligible for the same.");
						return false;
					}
					else if(duplicateReq[0]=='Error')
					{
						alert("There is problem in duplicate check error. Please contact administrator.");
						return false;
					}
					else if(parseInt(duplicateReq[0])!=0)
					{
						if((Cash_Back_Eligible_Amount-parseInt(duplicateReq[1]))<Requested_Cash_Back_Amount)
						{	
							alert("Duplicate Request - "+duplicateReq[0]+" open cash back redemption request(s) totalling to "+duplicateReq[1]+" points is already in process.");
							iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value='';
							iframeDocument.getElementById("1_Approved_Cash_Back_Amount").value='';
							return false;
						}
					}
					iframeDocument.getElementById("1_Amount_History").value="PBO:"+iframeDocument.getElementById("1_Approved_Cash_Back_Amount").value+" /";
					if(confirm('Dear '+iframeDocument.getElementById("1_CCI_CName").value+', this is to confirm that you are requesting to redeem '+iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value+' points to your card, correct?')) 
					{
						return true;
					}
					else
						return false;
				}		

			}
			else if(WSNAME == 'Q1' )
			{
				if(customform.document.getElementById("IsCSURefreshClicked").value=="")
				{
					alert("Please click on Refresh and check the eligibility.");
						return false;
				
				}
				//alert(iframeDocument.getElementById("1_Cardno_Masked").value.substring(0,7).replace('-',''));
				//alert("Debug");
				if(window.XMLHttpRequest)  xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)  xhr=new ActiveXObject("Microsoft.XMLHTTP");
				var Card_Status = iframeDocument.getElementById("1_CCI_CStatus").value;
				//change done to pass first six digits of card to get minimum cash back limit
				var url="/webdesktop/CustomForms/SRM_Specific/Custom_Validation_CBR.jsp?PANno="+PANno+"&WINAME="+WINAME+"&tr_table="+tr_table+"&cardsubtype="+Card_SubType+"&cardstatus="+Card_Status+"&WSNAME="+WSNAME+"&CardBin="+iframeDocument.getElementById("1_Cardno_Masked").value.substring(0,7).replace('-','');
				
				xhr.open("GET",url,false); 
				xhr.send(null);
				if (xhr.status == 200 && xhr.readyState == 4)
				{
					ajaxResult=Trim(xhr.responseText);
					var responseCSUEligibilty = ajaxResult.split("~");
					var status = responseCSUEligibilty[0];
					var cashBackLimit = responseCSUEligibilty[1];
					if(status!=0)
					{
						iframeDocument.getElementById("1_Non_Eligibility_Reason").value="Card Status - "+Card_Status+" - Customer is not eligible for Cash Back Redemption";
						iframeDocument.getElementById("1_Cash_Back_Eligibility").value="N";
					}
					else if (status==0)
					{
						iframeDocument.getElementById("1_Non_Eligibility_Reason").value="";
						iframeDocument.getElementById("1_Cash_Back_Eligibility").value="Y";
						if(parseInt(iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value)<parseInt(cashBackLimit))
						{
							iframeDocument.getElementById("1_Non_Eligibility_Reason").value="Cash Back Eligible Amount is less than " +cashBackLimit+" - Customer is not eligible for Cash Back";
							iframeDocument.getElementById("1_Cash_Back_Eligibility").value="N";
						}
					}
					
				}
				else
				{
					alert("Error in CSU Fetch validation.");
					return false;
				}
				if(IsDoneClicked)
				{
					if((parseInt(iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value)> parseInt(iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value)) &&  iframeDocument.getElementById("1_Decision").value!='Reject' && parseInt(iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value)>=parseInt(cashBackLimit))
					{
						alert("Cash Back Eligible Points have been changed post submission of the request. Please reject the case.");
						iframeDocument.getElementById("1_Decision").value="--Select--";
						return false;
					
					}
					else if(iframeDocument.getElementById("1_Cash_Back_Eligibility").value=="N" && iframeDocument.getElementById("1_Decision").value!='Reject')
					{
						alert("Customer is not eligible for Cash Back. Please reject the case.");
						iframeDocument.getElementById("1_Decision").value="--Select--";
						return false;
					
					}
					
				}
				for(var i = 0; i < arr.length; i++)
				{
					var temp=arr[i].split('#');
					var id=temp[0];
					var pattern=temp[1];
					var isMandatory=temp[2];
					var labelName=temp[3];
					var type=temp[4];
					if(labelName=='Approved Cash Back Amount')
					{	
						if(parseInt(iframeDocument.getElementById(id).value)>parseInt(iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value)||parseInt(iframeDocument.getElementById(id).value)>parseInt(iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value))
						{	
							alert("Amount to be approved is more than eligible or requested cash back.");
							iframeDocument.getElementById(id).focus();
							return false;
						}
					}
					
					if(labelName=='Decision')
					{
						var decisionElement = iframeDocument.getElementById(id);
						var selectedValue = decisionElement.options[decisionElement.selectedIndex].value;

						if(selectedValue=='Reject')
						{
							var declineRElement = iframeDocument.getElementById("1_Decline_Reason");
							var selectedRValue = declineRElement.options[declineRElement.selectedIndex].value;
							if(selectedRValue=='--Select--')
							{
								alert("Decline Reason is mandatory.");
								iframeDocument.getElementById("1_Decline_Reason").focus();
								return false;
							}
						}
					}
				}
				
			}
			else
			{
				for(var i = 0; i < arr.length; i++)
				{
					var temp=arr[i].split('#');
					var id=temp[0];
					var pattern=temp[1];
					var isMandatory=temp[2];
					var labelName=temp[3];
					
					if(labelName=='Approved Cash Back Amount')
					{	
						if(parseInt(iframeDocument.getElementById(id).value)>parseInt(iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value)||parseInt(iframeDocument.getElementById(id).value)>parseInt(iframeDocument.getElementById("1_Requested_Cash_Back_Amount").value))
						{	
							alert("Amount to be approved is more than eligible or requested cash back.");
							iframeDocument.getElementById(id).focus();
							return false;
						}
					}
					
					if(labelName=='Decision')
					{
						var decisionElement = iframeDocument.getElementById(id);
						var selectedValue = decisionElement.options[decisionElement.selectedIndex].value;
						if(selectedValue=='Reject')
						{
							var declineRElement = iframeDocument.getElementById("1_Decline_Reason");
							var selectedRValue = declineRElement.options[declineRElement.selectedIndex].value;
							if(selectedRValue=='--Select--')
							{
								alert("Decline Reason is mandatory.");
								iframeDocument.getElementById("1_Decline_Reason").focus();
								return false;
							}
						}
					}
				}
			}
			if(IsDoneClicked)
			{
				iframeDocument.getElementById("1_Amount_History").value=iframeDocument.getElementById("1_Amount_History").value+iframeDocument.getElementById("WS_LogicalName").value+":"+iframeDocument.getElementById("1_Approved_Cash_Back_Amount").value+" /";
				if(iframeDocument.getElementById("1_Cash_Back_Eligibility").value=='N' && WSNAME == 'PBO')
				{	
					alert("Customer is not eligible for Cash Back Redemption. Please discard or close the request.");
					return false;
				}
			}
			return true;
		}
	
	if(IsDoneClicked)
	{
		
		if(SubCategoryID=='3'&&CategoryID=='1') //for BOC
		{		
			var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
			var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
			var IntegrationStatus=customform.document.getElementById("wdesk:IntegrationStatus").value;
			iframeDocument.getElementById("3_IsError").value='N';
			
			if(WSNAME=='Introduction' || WSNAME=='PBO') //d
			{
				var blockRequested='false';
				var tempBlockRequested='false';
				var card_number="";
				var block_card="";
				var finalBlockMsg="Following Card Number(s) will be blocked:";
				var ele = iframeDocument.getElementsByName("3_verification_details");
				for(var i = 0; i < ele.length; i++)
				{	
					if(ele[i].checked)
					{
						var eleValue = ele[i].value;
					}
					
				}
				if(eleValue=='Non - Customer')
				{
					if(iframeDocument.getElementById("3_third_party_name").value=='' && iframeDocument.getElementById("3_third_party_contact_number").value=='')
					{
						alert("Please enter Third Party Name and Third Party Contact Number.");
						iframeDocument.getElementById("3_third_party_name").focus();
						return false;
					}
					else if(iframeDocument.getElementById("3_third_party_name").value=='' )
					{
						alert("Please enter Third Party Name.");
						iframeDocument.getElementById("3_third_party_name").focus();
						return false;
					}
					else if(iframeDocument.getElementById("3_third_party_contact_number").value=='')
					{
						alert("Please enter Third Party Contact Number.");
						iframeDocument.getElementById("3_third_party_contact_number").focus();
						return false;
					}
				}
			
					//Code checks fields custom mandatory.
			
				var strJson = iframeDocument.getElementById('CARD BLOCKING DETAILS_3_gridbundleJSON_WIDATA').value;
				
				var obj = JSON.parse(strJson);
				for(var key in obj)
				{
					var attrName = key;
					var attrValue = obj[key];
				
					
					if(attrName=="type_of_block")
					{
						if(attrValue.indexOf("Temporary")!=-1)
						{
							tempBlockRequested='true';
							
						}
					}
				
					if(attrName=="block_card")
					{
						if(attrValue.indexOf("Yes")==-1&&IsDoneClicked && iframeDocument.getElementById('3_block_card').checked==false)
						{
							alert("No card has been saved for blocking.");
							return false;
							
						}
						block_card=attrValue.split("@");
					}
					if(attrName=="card_number")
					{		
						card_number=attrValue.split("@");
					}
							
				}			
				
				if(iframeDocument.getElementById('Card Blocking Details_modifyGridBundle').value=='')
				{
					//
				}
				else
				{
					
					var Framedata = iframeDocument.getElementById("CARD BLOCKING DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
					
					var gridData=Framedata;
						
					Framedata = Framedata.replaceAllOccurence("\":\"","~");
					Framedata =Framedata.replaceAllOccurence("\",\"","$");
					Framedata =Framedata.replaceAllOccurence("\"","");
					Framedata =Framedata.replaceAllOccurence("{","");
					Framedata =Framedata.replaceAllOccurence("}","");
					
					Framedata = Framedata.split("$");
					
					var aa="";
					var columnList="";
					for(var i=0; i< Framedata.length ; i++)
					{
						var value = Framedata[i].split("~");
						
						if(i==0)
							columnList="3_"+value[0];
						else
							columnList=columnList+","+"3_"+value[0];
							 
					}
							
					var framename='Card Blocking Details';	
					
					var valid = customValidationOnIntroduce(columnList,framename,CategoryID,SubCategoryID,"custom",fobj);
					if(!valid)
					{
						return valid;
					}
					
				}
				
					var gridData = iframeDocument.getElementById("CARD BLOCKING DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
	
					var obj = JSON.parse(gridData);

					var BlockCard = "";
					var CardNumber = "";
					var typeOfBlock = "";
					var tempBlockRequested = false;
					CardNumber = obj['card_number'];
					var arrCardNumber = CardNumber.split("@");		
					var noOfElements = arrCardNumber.length;
					BlockCard = obj['block_card'];					
					var arrBlockCard = BlockCard.split("@");
					
					typeOfBlock = obj['type_of_block'];					
					var arrTypeOfBlock = typeOfBlock.split("@");

					var cardsToBeBlocked="";
					for(var cardCounter = 0 ;  cardCounter<noOfElements; cardCounter++)
					{
						if(arrBlockCard[cardCounter].replace(/^\s+|\s+$/gm,'')=='Yes')
						{
							cardsToBeBlocked = cardsToBeBlocked+arrCardNumber[cardCounter].replace(/^\s+|\s+$/gm,'')+'\n';
							
							if(arrTypeOfBlock[cardCounter].replace(/^\s+|\s+$/gm,'')=='Temporary')
							{
								tempBlockRequested=true;
							}
						}
					}
					
					var cardNoOnForm= iframeDocument.getElementById('3_card_number').value;
					
					var blockcardNoOnForm= iframeDocument.getElementById('3_block_card').checked;
					var blockType= iframeDocument.getElementById('3_type_of_block').value;
					
					
					if(cardNoOnForm!='' && blockcardNoOnForm==true)
					{
						if(blockType=='Temporary')
							tempBlockRequested=true;
							
						if(cardsToBeBlocked.indexOf(cardNoOnForm)<0)
							cardsToBeBlocked = cardsToBeBlocked + cardNoOnForm;
					}
					
					if(tempBlockRequested)
					{
						iframeDocument.getElementById("3_IsTempRequested").value='Y';
					}
					else
					{	
						iframeDocument.getElementById("3_IsTempRequested").value='N';
					}
					
						
					if(customform.document.getElementById("wdesk:IntegrationStatus").value!='false')
					{
						if(!confirm("Following Card Number(s) will be blocked: \n"+cardsToBeBlocked+"\n Do you want to continue?"))
						{
							return false;
						}
					}
			}
			else if(WSNAME=='Q1') //d
			{
				if(!donesuccess)
				{
					var finalBlockMsg = "Request has been processed succesfully.";
					if(IsDoneClicked)
					{
						alert(finalBlockMsg);
					}
					donesuccess=true;
				}
			}
			
			return true;	
			
		}
		if(SubCategoryID=='2'&&CategoryID=='1') //for BT
			{	
				var eleValue = '';
				var ele = iframeDocument.getElementsByName("2_verification_details");
					for(var i = 0; i < ele.length; i++)
					{	
						if(ele[i].checked)
						{
							var eleValue = ele[i].value;
						}
						
					}
				
				if(eleValue=='') //d
				{	alert("Please select Verification Details.");
					iframeDocument.getElementById("2_verification_details").focus();
					return false;
				}	
				if(iframeDocument.getElementById('2_sales_agent_id').value=='--Select--') //d
				{	alert("Please select Sales Agent ID.");
					iframeDocument.getElementById("2_sales_agent_id").focus();
					return false;
				}
				if(iframeDocument.getElementById('2_bt_required_confirm').checked==false) //d
				{	alert("Please check Confirm with the Customer.");
					iframeDocument.getElementById("2_bt_required_confirm").focus();
					return false;
				}
				
			}
			if(SubCategoryID=='4'&&CategoryID=='1') //for CCC
			{	
				var eleValue = '';
				var ele = iframeDocument.getElementsByName("4_verification_details");
					for(var i = 0; i < ele.length; i++)
					{	
						if(ele[i].checked)
						{
							var eleValue = ele[i].value;
						}
						
					}
				
				if(eleValue=='') //d
				{	alert("Please select Verification Details.");
					iframeDocument.getElementById("4_verification_details").focus();
					return false;
				}	
				if(iframeDocument.getElementById('4_sales_agent_id').value=='--Select--') //d
				{	alert("Please select Sales Agent ID.");
					iframeDocument.getElementById("4_sales_agent_id").focus();
					return false;
				}
				if(iframeDocument.getElementById('4_confirm_with_customer').checked==false) //d
				{	alert("Please check Confirm with the Customer.");
					iframeDocument.getElementById("4_confirm_with_customer").focus();
					return false;
				}	
			}	
			
			if(SubCategoryID=='1'&&( CategoryID=='8' || CategoryID=='7')) //for Change Management
			{
				//alert("Inside SubCategory & Category Block"); 
		
				var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
				if(WSNAME=='Q1')
				{
				//	alert("Work Step Name =  "+WSNAME); 
					var Decision=iframeDocument.getElementById("1_decision").value;
					var remarks=iframeDocument.getElementById("1_remarks").value;
				//	alert("Decision =  "+Decision); 
					if(Decision=='Cancel')
					{
				//		alert("Decision =  "+Decision); 
						iframeDocument.getElementById("1_remarks").setAttribute("disabled", false);
						var remarks=iframeDocument.getElementById("1_remarks").value;
						if(remarks=='')
						{
							alert("Please fill the remarks");
							iframeDocument.getElementById("1_remarks").focus();
							return false;
						}
						
					}
					
				}
			}
	}
	return true;
}