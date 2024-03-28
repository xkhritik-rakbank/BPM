function OnDoneValidation(flag)
{
		var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
		var diffDays_CBRB='';
		var diffDays_AECB='';
		var performcheckdays_CBRB = customform.document.getElementById('performcheckdays_CBRB').value;
		var performcheckdays_AECB = customform.document.getElementById('performcheckdays_AECB').value;
		var Dec_CreditAnalyst = customform.document.getElementById("wdesk:Dec_CreditAnalyst").value;
		
		if(customform.document.getElementById("selectDecision").value=='')//Decision will always be mandatory for all workstep
		{
			alert('Decision is mandatory');
			customform.document.getElementById('selectDecision').focus(true);
			return false;
		}
		
		if(customform.document.getElementById('selectDecision').value=='Reperform Checks')
		{
			if (customform.document.getElementById('wdesk:CBRB_Required').value != 'Yes' && customform.document.getElementById('wdesk:AECB_Required').value != 'Yes')
			{
				alert("CBRB or AECB Required must be Yes when Reperform Checks decision is selected");
				customform.document.getElementById('wdesk:CBRB_Required').focus(true);
				return false;
			}
		}
		
		customform.document.getElementById("wdesk:qDecision").value = customform.document.getElementById("selectDecision").value;	
		
		if(WSNAME=="AU_Doc_Checker" || WSNAME=="AU_Analyst" || WSNAME=="Senior_Checker" || WSNAME=="AU_Officer" || WSNAME=="CBRB_Maker" || WSNAME=="Quality_Control" || WSNAME=="AU_Data_Entry" || WSNAME=="AttachAdditionalDocs" || WSNAME=="AU_Manager" || WSNAME=="Credit_Analyst" || WSNAME=="Credit_Manager" || WSNAME=="CROPS_DocsChecker")
		{
			var currCheckList=customform.document.getElementById('H_CHECKLIST').value;
			if(currCheckList.indexOf('003~[Raised')!=-1)
			{
				if(customform.document.getElementById('wdesk:Remarks').value=="")
				{
					alert('Please Enter Remarks');
					customform.document.getElementById('wdesk:Remarks').focus(true);
					return false;
				}
			}
		}
		if(WSNAME=="AU_Data_Entry")
		{
			var customerName=customform.document.getElementById("wdesk:Customer_Name").value;
			var agreementNumber=customform.document.getElementById('wdesk:Agreement_Number').value;
			var TLNumber=customform.document.getElementById("wdesk:TLNumber").value;
			var industryCode=customform.document.getElementById("wdesk:IndustryCode").value;
			var Micro=customform.document.getElementById("wdesk:Micro").value;
			var Sector=customform.document.getElementById("wdesk:Sector").value;
			var FastTrack=customform.document.getElementById("wdesk:FastTrack").value;
			var PolicyScore=customform.document.getElementById("wdesk:PolicyScore").value;
			var AECBScore=customform.document.getElementById("wdesk:AECBScore").value;
			var ChannelCode=customform.document.getElementById("wdesk:ChannelCode").value;
			
			if(customerName=="" || customerName==null)
			{
				alert('Customer Name is mandatory');
				customform.document.getElementById("wdesk:Customer_Name").focus(true);
				return false;
			}
			if(TLNumber=="" || TLNumber==null)
			{
				alert('TL Number is mandatory');
				customform.document.getElementById("wdesk:TLNumber").focus(true);
				return false;
			}
			if(agreementNumber=="" || agreementNumber==null)
			{
				alert('Agreement Number is Mandatory');
				customform.document.getElementById('wdesk:Agreement_Number').focus(true);
				return false;
			}
			if(industryCode=="" || industryCode==null || industryCode=='--Select--')
			{
				alert('Macro is mandatory');
				customform.document.getElementById("wdesk:IndustryCode").focus(true);
				return false;
			}
			if(Micro=="" || Micro==null || Micro=='--Select--')
			{
				alert('Micro is mandatory');
				customform.document.getElementById("wdesk:Micro").focus(true);
				return false;
			}
			if(Sector=="" || Sector==null || Sector=='--Select--')
			{
				alert('Sector is mandatory');
				customform.document.getElementById("wdesk:Sector").focus(true);
				return false;
			}
			if(FastTrack=="" || FastTrack==null)
			{
				alert('FastTrack is mandatory');
				customform.document.getElementById("wdesk:FastTrack").focus(true);
				return false;
			}
			if(PolicyScore=="" || PolicyScore==null)
			{
				alert('PolicyScore is mandatory');
				customform.document.getElementById("wdesk:PolicyScore").focus(true);
				return false;
			}
			if(AECBScore=="" || AECBScore==null)
			{
				alert('AECBScore is mandatory');
				customform.document.getElementById("wdesk:AECBScore").focus(true);
				return false;
			}
			if(ChannelCode=="" || ChannelCode==null)
			{
				alert('Channel Code is mandatory');
				customform.document.getElementById("wdesk:ChannelCode").focus(true);
				return false;
			}
		}
		if(WSNAME=="AU_Doc_Checker" || WSNAME=="AU_Analyst" || WSNAME=="AttachAdditionalDocs")
		{
			if(customform.document.getElementById("selectDecision").value=="Approve" || customform.document.getElementById("selectDecision").value=="Submit")
			{
				var cifID=customform.document.getElementById("wdesk:CIF_Id").value;
				var rakTrackNumber=customform.document.getElementById("wdesk:RAK_Track_Number").value;
				var amountRequested=customform.document.getElementById("wdesk:Requested_Amount").value;
				var tenorRequested=customform.document.getElementById("wdesk:Requested_Tenor").value;
				var rmcode = customform.document.getElementById("wdesk:RMCode").value;
				var ROCode = customform.document.getElementById("wdesk:ROCode").value;
				var customerName=customform.document.getElementById("wdesk:Customer_Name").value;
				if(cifID=="" || cifID==null)
				{
					alert('CIF Id is mandatory');
					customform.document.getElementById('wdesk:CIF_Id').focus(true);
					return false;
				}
				if(customerName=="" || customerName==null)
				{
					alert('Customer Name is mandatory');
					customform.document.getElementById("wdesk:Customer_Name").focus(true);
					return false;
				}
				else if(rakTrackNumber=="" || rakTrackNumber==null)
				{
					alert('Rak Track Number is mandatory');
					customform.document.getElementById('wdesk:RAK_Track_Number').focus(true);
					return false;
				}
				else if(amountRequested=="" || amountRequested==null)
				{
					alert('Amount (Requested) is mandatory');
					customform.document.getElementById('wdesk:Requested_Amount').focus(true);
					return false;
				}
				else if(tenorRequested=="" || tenorRequested==null)
				{
					alert('Tenor (Requested) is mandatory');
					customform.document.getElementById('wdesk:Requested_Tenor').focus(true);
					return false;
				}
				else if(rmcode=="" || rmcode==null)
				{
					alert('RM Code is mandatory');
					customform.document.getElementById('wdesk:RMCode').focus(true);
					return false;
				}
				else if(ROCode=="" || ROCode==null)
				{
					alert('RO Code is mandatory');
					customform.document.getElementById('wdesk:ROCode').focus(true);
					return false;
				}
				if(WSNAME=="AU_Doc_Checker" || WSNAME=="AU_Analyst")
				{
					var TLNumber=customform.document.getElementById("wdesk:TLNumber").value;
					if(TLNumber=="" || TLNumber==null)
					{
						alert('TL Number is mandatory');
						customform.document.getElementById("wdesk:TLNumber").focus(true);
						return false;
					}
				}
			}
		}
		if(WSNAME=="AttachAdditionalDocs")
		{
			var incrementAmtReq=customform.document.getElementById("wdesk:Incremented_Amt_Req").value;
			var outstandingAmount=customform.document.getElementById("wdesk:Outstanding_Amount").value;
			var visitDate=customform.document.getElementById("wdesk:Visit_Date").value;
			var BVRDate=customform.document.getElementById("wdesk:BVR_Date").value;
			if(customform.document.getElementById("selectDecision").value=='Submit')
			{
				if(incrementAmtReq=="" || incrementAmtReq==null)
				{
					alert("Incremental Amount(Requested) is Mandatory");
					customform.document.getElementById('wdesk:Incremented_Amt_Req').focus(true);
					return false;
				}
				else if(outstandingAmount=="" || outstandingAmount==null)
				{
					alert('Outstanding Amount is mandatory');
					customform.document.getElementById('wdesk:Outstanding_Amount').focus(true);
					return false;
				}
				else if(visitDate=="" || visitDate==null)
				{
					alert('Visit Date is mandatory');
					customform.document.getElementById('wdesk:Visit_Date').focus(true);
					return false;
				}
				else if(BVRDate=="" || BVRDate==null)
				{
					alert('BVR Date is mandatory');
					customform.document.getElementById('wdesk:BVR_Date').focus(true);
					return false;
				}
			}
		}
		if(WSNAME == "CBRB_Maker")
		{
			if(customform.document.getElementById("selectDecision").value=="Approve")
			{
				customform.document.getElementById("wdesk:Maker_Done_On").value=customform.document.getElementById("currentDate").value;
				if(!AttachedDocType("CBRB_Docs,CBRB_Checklist"))
					return false;
			}
			
		}		
		if(WSNAME=="Quality_Control" || WSNAME=="Junior_Checker" || WSNAME=="Senior_Checker" || WSNAME=="AU_Officer" || WSNAME=="AU_Manager" || WSNAME=="Credit_DocChecker" || WSNAME=="Credit_Analyst" || WSNAME=="Credit_Manager" || WSNAME=="Business_Rejects" || WSNAME=="AECB")
		{
			var makerDoneDate = customform.document.getElementById("wdesk:Maker_Done_On").value;
			if(makerDoneDate==null || makerDoneDate=='')
			{
			}
			else
			{
				var currentdate = new Date();
				var datetime =(currentdate.getMonth()+1)+ "/"
				+ currentdate.getDate() + "/" 
				+ currentdate.getFullYear() + " "  
				+ currentdate.getHours() + ":"  
				+ currentdate.getMinutes() + ":" 
				+ currentdate.getSeconds();
				
				//var makerDoneDate = customform.document.getElementById("wdesk:Maker_Done_On").value;
				
				var a = makerDoneDate.split(" ");
				var d = a[0].split("/");
				var t = a[1].split(":");
				var newDate=d[1]+'/'+d[0]+'/'+d[2]+' '+t[0]+':'+t[1]+':'+t[2];
				
				makerDoneDate = new Date(newDate);
				var currentdate = new Date();
				var datetime =(currentdate.getMonth()+1)+ "/"
				+ currentdate.getDate() + "/" 
				+ currentdate.getFullYear() + " "  
				+ currentdate.getHours() + ":"  
				+ currentdate.getMinutes() + ":" 
				+ currentdate.getSeconds();
				var submitDate = new Date(datetime);
				var utc1 = Date.UTC(makerDoneDate.getFullYear(), makerDoneDate.getMonth(), makerDoneDate.getDate());
				var utc2 = Date.UTC(submitDate.getFullYear(), submitDate.getMonth(), submitDate.getDate());

				var _MS_PER_DAY = 1000 * 60 * 60 * 24;
				diffDays_CBRB=Math.floor((utc2 - utc1) / _MS_PER_DAY);
			}
		}
		
		if(WSNAME=="Quality_Control" || WSNAME=="Junior_Checker" || WSNAME=="Senior_Checker" || WSNAME=="AU_Officer" || WSNAME=="AU_Manager" || WSNAME=="Credit_DocChecker" || WSNAME=="Credit_Analyst" || WSNAME=="Credit_Manager" || WSNAME=="Business_Rejects")
		{
			var AECBDoneDate = customform.document.getElementById("wdesk:AECB_Done_On").value;
			if(AECBDoneDate==null || AECBDoneDate=='')
			{
			}
			else
			{
				var currentdate = new Date();
				var datetime =(currentdate.getMonth()+1)+ "/"
				+ currentdate.getDate() + "/" 
				+ currentdate.getFullYear() + " "  
				+ currentdate.getHours() + ":"  
				+ currentdate.getMinutes() + ":" 
				+ currentdate.getSeconds();
				
				var a = AECBDoneDate.split(" ");
				var d = a[0].split("/");
				var t = a[1].split(":");
				var newDate=d[1]+'/'+d[0]+'/'+d[2]+' '+t[0]+':'+t[1]+':'+t[2];
				
				AECBDoneDate = new Date(newDate);
				var currentdate = new Date();
				var datetime =(currentdate.getMonth()+1)+ "/"
				+ currentdate.getDate() + "/" 
				+ currentdate.getFullYear() + " "  
				+ currentdate.getHours() + ":"  
				+ currentdate.getMinutes() + ":" 
				+ currentdate.getSeconds();
				var submitDate = new Date(datetime);
				var utc1 = Date.UTC(AECBDoneDate.getFullYear(), AECBDoneDate.getMonth(), AECBDoneDate.getDate());
				var utc2 = Date.UTC(submitDate.getFullYear(), submitDate.getMonth(), submitDate.getDate());

				var _MS_PER_DAY = 1000 * 60 * 60 * 24;
				diffDays_AECB=Math.floor((utc2 - utc1) / _MS_PER_DAY);
			}
		}
		
		if(WSNAME == "AU_Analyst")
		{
			customform.document.getElementById('wdesk:Dec_AU_Analyst').value=customform.document.getElementById('selectDecision').value;
		}
		
		if(WSNAME == "Quality_Control")
		{
			var currCheckList=customform.document.getElementById('H_CHECKLIST').value;
			var workitemNo = customform.document.getElementById('wdesk:WI_NAME').value;
			//currCheckList=alreadyRaised(workitemNo,currCheckList);
			if(currCheckList.indexOf('001~[Raised')==-1)
			{
				var autoUIDExp=checkForUIDException();
				currCheckList=customform.document.getElementById('H_CHECKLIST').value;
			}
			if(customform.document.getElementById("selectDecision").value == "Approve")
			{
				if (diffDays_CBRB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_CBRB) > performcheckdays_CBRB)
					{
						alert('CBRB '+performcheckdays_CBRB+' days has passed, cannot take Approve Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
				/*if (diffDays_AECB != '')
				{
					if(parseInt(diffDays_AECB) > performcheckdays_AECB)
					{
						alert('AECB '+performcheckdays_AECB+' days has passed, cannot take Approve Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}*/
				if(currCheckList.indexOf('001~[Raised')!=-1)//Means this exception is raised as of now 1-means Risk exception
				{
					//alert("UID Exception had been raised");
					customform.document.getElementById('wdesk:UID_Exp_Flag').value='Y';		
				}
				else
				{
					//alert("UID Exception was never raised");
					customform.document.getElementById('wdesk:UID_Exp_Flag').value='N';
				}
				
			}
			
		}
		
		if(WSNAME == "Quality_Control_Additional")
		{
			if(customform.document.getElementById("selectDecision").value == "New UID Match Found")
			{
				var currCheckList=customform.document.getElementById('H_CHECKLIST').value;
				var workitemNo = customform.document.getElementById('wdesk:WI_NAME').value;
				if(currCheckList.indexOf('001~[Raised')==-1)
				{
					var autoUIDExp=checkForUIDException();
					currCheckList=customform.document.getElementById('H_CHECKLIST').value;
				}
				if(currCheckList.indexOf('001~[Raised')!=-1)
					customform.document.getElementById('wdesk:UID_Exp_Flag').value='Y';		
				else
					customform.document.getElementById('wdesk:UID_Exp_Flag').value='N';
			}	
		}
		
		if(WSNAME == "Junior_Checker")
		{
			if(customform.document.getElementById("selectDecision").value == "Approve")
			{
				if (diffDays_CBRB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_CBRB) > performcheckdays_CBRB)
					{
						alert('CBRB '+performcheckdays_CBRB+' days has passed, cannot take Approve Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
				if (diffDays_AECB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_AECB) > performcheckdays_AECB)
					{
						alert('AECB '+performcheckdays_AECB+' days has passed, cannot take Approve Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
				var currCheckList=customform.document.getElementById('H_CHECKLIST').value;
				var workitemNo = customform.document.getElementById('wdesk:WI_NAME').value;
				//currCheckList=alreadyRaised(workitemNo,currCheckList);
				if(currCheckList.indexOf('001~[Raised')!=-1)
				{
					alert('Please clear UID match Exception to Approve');
					return false;
				}
			}
			customform.document.getElementById('wdesk:Dec_Control_Maker').value=customform.document.getElementById('selectDecision').value;
		}
		if(WSNAME == "Senior_Checker")
		{
			if(customform.document.getElementById("selectDecision").value == "Approve")
			{
				if (diffDays_CBRB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_CBRB) > performcheckdays_CBRB)
					{
						alert('CBRB '+performcheckdays_CBRB+' days has passed, cannot take Approve Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
				if (diffDays_AECB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_AECB) > performcheckdays_AECB)
					{
						alert('AECB '+performcheckdays_AECB+' days has passed, cannot take Approve Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
				
				var currCheckList=customform.document.getElementById('H_CHECKLIST').value;
				var workitemNo = customform.document.getElementById('wdesk:WI_NAME').value;
				//currCheckList=alreadyRaised(workitemNo,currCheckList);
				if(currCheckList.indexOf('001~[Raised')!=-1)
				{
					alert('Please clear UID match Exception to Approve');
					return false;
				}
			}
			/*if(customform.document.getElementById("selectDecision").value == "Reperform Checks")
			{
				if(!(parseInt(diffDays_CBRB)>30))
				{
					alert("You cannot select this decision as it has not been more than 30 days since CBWC maker Approved");
					return false;
				}
			}*/
			customform.document.getElementById('wdesk:Dec_Control_Checker').value=customform.document.getElementById('selectDecision').value;
		}

		if(WSNAME == "AU_Officer")
		{
			// CRs 21-02-2019 By Sajan
			var customerName=customform.document.getElementById("wdesk:Customer_Name").value;
			var industryCode=customform.document.getElementById("wdesk:IndustryCode").value;
			var TLNumber=customform.document.getElementById("wdesk:TLNumber").value;
			if(customform.document.getElementById("selectDecision").value == "Approve")
			{	
				// CRs 21-02-2019 By Sajan
				if(customerName=="" || customerName==null)
				{
					alert('Customer Name is mandatory');
					customform.document.getElementById("wdesk:Customer_Name").focus(true);
					return false;
				}
				if(industryCode=="" || industryCode==null)
				{
					alert('Macro is mandatory');
					customform.document.getElementById("wdesk:IndustryCode").focus(true);
					return false;
				}
				if(TLNumber=="" || TLNumber==null)
				{
					alert('TL Number is mandatory');
					customform.document.getElementById("wdesk:TLNumber").focus(true);
					return false;
				}
				
				if(!AttachedDocType("AU_Checklist"))
					return false;
				
				if (diffDays_CBRB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_CBRB) > performcheckdays_CBRB)
					{
						alert('CBRB '+performcheckdays_CBRB+' days has passed, cannot take Approve Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
				
				if (diffDays_AECB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_AECB) > performcheckdays_AECB)
					{
						alert('AECB '+performcheckdays_AECB+' days has passed, cannot take Approve Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
				
				var currCheckList=customform.document.getElementById('H_CHECKLIST').value;
				var workitemNo = customform.document.getElementById('wdesk:WI_NAME').value;
				if(currCheckList.indexOf('001~[Raised')!=-1)
				{
					alert('Please clear UID match Exception to Approve');
					return false;
				}
				
			}
		}
		if(WSNAME == "CROPS_DocsChecker")
		{
			if(customform.document.getElementById("selectDecision").value == "Approve")
			{
				if(customform.document.getElementById("wdesk:Dec_Control_Maker").value == "Reject")
				{
					alert("You cannot select Approve decision as CBWC Maker's decision was Reject");
					customform.document.getElementById('selectDecision').focus(true);
					return false;
				}
				if(customform.document.getElementById("wdesk:Dec_Control_Checker").value == "Reject")
				{
					alert("You cannot select Approve decision as CBWC Checker's decision was Reject");
					customform.document.getElementById('selectDecision').focus(true);
					return false;
				}
			}
		}
		if(WSNAME == "AU_Manager")
		{
			var customerName=customform.document.getElementById("wdesk:Customer_Name").value;
			var TLNumber=customform.document.getElementById("wdesk:TLNumber").value;
			if(customform.document.getElementById("selectDecision").value == "Approve")
			{
				//CRs 21-02-2019 By Sajan
				if(customerName=="" || customerName==null)
				{
					alert('Customer Name is mandatory');
					customform.document.getElementById("wdesk:Customer_Name").focus(true);
					return false;
				}
				
				if(TLNumber=="" || TLNumber==null)
				{
					alert('TL Number is mandatory');
					customform.document.getElementById("wdesk:TLNumber").focus(true);
					return false;
				}		
				if (diffDays_CBRB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_CBRB) > performcheckdays_CBRB)
					{
						alert('CBRB '+performcheckdays_CBRB+' days has passed, cannot take Approve Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
				if (diffDays_AECB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_AECB) > performcheckdays_AECB)
					{
						alert('AECB '+performcheckdays_AECB+' days has passed, cannot take Approve Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
			}
		}
		if(WSNAME == "Credit_DocChecker")
		{
			if(customform.document.getElementById("selectDecision").value == "Approve")
			{
				if (diffDays_CBRB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_CBRB) > performcheckdays_CBRB)
					{
						alert('CBRB '+performcheckdays_CBRB+' days has passed, cannot take Approve Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
				if (diffDays_AECB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_AECB) > performcheckdays_AECB)
					{
						alert('AECB '+performcheckdays_AECB+' days has passed, cannot take Approve Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
			}
		}
		if(WSNAME == "Credit_Analyst")
		{
			var interestRateFinal=customform.document.getElementById("wdesk:Interest_Rate_Final").value;
			var processingFeeFinal=customform.document.getElementById("wdesk:Processing_Fee_Final").value;
			var incrementAmtApp=customform.document.getElementById("wdesk:Incremented_Amt_App").value;
			var agreementNo=customform.document.getElementById("wdesk:Agreement_Number").value;
			
			if(processingFeeFinal=="" || processingFeeFinal==null)
			{
				alert('Processing Fee(Final) is Mandatory to enter');
				customform.document.getElementById('wdesk:Processing_Fee_Final').focus(true);
				return false;
			}
			
			if(interestRateFinal=="" || interestRateFinal==null)
			{
				alert('Interest Rate(Final) is Mandatory to enter');
				customform.document.getElementById('wdesk:Interest_Rate_Final').focus(true);
				return false;
			}
			
			if(incrementAmtApp=="" || incrementAmtApp==null)
			{
				alert('Incremental Amount(Approved) is Mandatory to enter');
				customform.document.getElementById('wdesk:Incremented_Amt_App').focus(true);
				return false;
			}
			if(agreementNo=="" || agreementNo==null)
			{
				alert('Agreement Number is mandatory');
				customform.document.getElementById('wdesk:Agreement_Number').focus(true);
				return false;
			}
			
			if(customform.document.getElementById("selectDecision").value == "Approve" || customform.document.getElementById("selectDecision").value == "Approved Subject to")
			{
				if (diffDays_CBRB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_CBRB) > performcheckdays_CBRB)
					{
						alert('CBRB '+performcheckdays_CBRB+' days has passed, cannot take Approve Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
				if (diffDays_AECB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_AECB) > performcheckdays_AECB)
					{
						alert('AECB '+performcheckdays_AECB+' days has passed, cannot take Approve Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
				
				if (customform.document.getElementById("wdesk:Dec_CreditManager").value != 'Approve')
				{
					alert("Approve/Approved Subject to decision cannot be taken as its not yet approved by credit manager");
					customform.document.getElementById('selectDecision').focus(true);
					return false;
				}
				
				if (customform.document.getElementById("wdesk:CEUDone").value == '' || customform.document.getElementById("wdesk:CEUDone").value == '--Select--')
				{
					alert("Kindly select CEU Done");
					customform.document.getElementById('wdesk:CEUDone').focus(true);
					return false;
				}
				if (customform.document.getElementById("wdesk:DelegationAuthority").value == '' || customform.document.getElementById("wdesk:DelegationAuthority").value == '--Select--')
				{
					alert("Kindly select Delegation Authority");
					customform.document.getElementById('wdesk:DelegationAuthority').focus(true);
					return false;
				}
			}
			if(customform.document.getElementById("selectDecision").value == "Amendment")
			{
				if (customform.document.getElementById("wdesk:Dec_CreditManager").value != 'Approve')
				{
					alert("Amendment decision cannot be taken as its not yet approved by credit manager");
					customform.document.getElementById('selectDecision').focus(true);
					return false;
				}
			}
			if(customform.document.getElementById("selectDecision").value == "Approved Subject to")
			{
				if(customform.document.getElementById('wdesk:Remarks').value=="")
				{
					alert('Please Enter Remarks');
					customform.document.getElementById('wdesk:Remarks').focus(true);
					return false;
				}
			}
		}
		if(WSNAME == "Credit_Manager")
		{
			var interestRateFinal=customform.document.getElementById("wdesk:Interest_Rate_Final").value;
			var processingFeeFinal=customform.document.getElementById("wdesk:Processing_Fee_Final").value;
			
			if(interestRateFinal=="" || interestRateFinal==null)
			{
				alert('Interest Rate(Final) is Mandatory');
				customform.document.getElementById('wdesk:Interest_Rate_Final').focus(true);
				return false;
			}
			if(processingFeeFinal=="" || processingFeeFinal==null)
			{
				alert('Processing Fee(Final) is Mandatory');
				customform.document.getElementById('wdesk:Processing_Fee_Final').focus(true);
				return false;
			}
			if(customform.document.getElementById("selectDecision").value == "Approve")
			{
				if (diffDays_CBRB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_CBRB) > performcheckdays_CBRB)
					{
						alert('CBRB '+performcheckdays_CBRB+' days has passed, cannot take Approve Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
				if (diffDays_AECB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_AECB) > performcheckdays_AECB)
					{
						alert('AECB '+performcheckdays_AECB+' days has passed, cannot take Approve Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
			}
			customform.document.getElementById("wdesk:Dec_CreditManager").value=customform.document.getElementById("selectDecision").value;
		}
		/*if(WSNAME == "CROPS_DataEntryMaker")
		{
			if(ValidateAlphaNumeric(customform.document.getElementById("wdesk:Agreement_Number"))==false)
			{
				alert("Please enter only alphanumeric characters for Agreement_Number");
				return false;
			}
		}*/
		
		//Added for clearing Others Exception till the wi moved to Exit
		if(WSNAME == "CROPS_DataEntChecker")
		{
			if(customform.document.getElementById("selectDecision").value == "Approve")
			{
				var currCheckList=customform.document.getElementById('H_CHECKLIST').value;
				var workitemNo = customform.document.getElementById('wdesk:WI_NAME').value;
				//currCheckList=alreadyRaised(workitemNo,currCheckList);
				if(currCheckList.indexOf('003~[Raised')!=-1)
				{
					alert("Please clear Others Exception");
					return false;
				}	
			}
		}
		
		if(WSNAME == "Business_Rejects")
		{
			if(customform.document.getElementById("selectDecision").value == "Submit")
			{
				if (diffDays_CBRB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_CBRB) > performcheckdays_CBRB)
					{
						alert('CBRB '+performcheckdays_CBRB+' days has passed, cannot take Submit Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
				if (diffDays_AECB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_AECB) > performcheckdays_AECB)
					{
						alert('AECB '+performcheckdays_AECB+' days has passed, cannot take Submit Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
			}
		}
		
		if(WSNAME == "AECB")
		{
			if(customform.document.getElementById("selectDecision").value == "Approve")
			{
				if(!AttachedDocType("AECB_Docs"))
					return false;
				
				if (diffDays_CBRB != '' && Dec_CreditAnalyst != 'Approve')
				{
					if(parseInt(diffDays_CBRB) > performcheckdays_CBRB)
					{
						alert('CBRB '+performcheckdays_CBRB+' days has passed, cannot take Approve Decision');
						customform.document.getElementById('selectDecision').focus(true);
						return false;
					}
				}
				customform.document.getElementById("wdesk:AECB_Done_On").value=customform.document.getElementById("currentDate").value;
			}
		}
		
		if(WSNAME == 'Deferral_Checker')
		{
			if(customform.document.getElementById("selectDecision").value == "Approve")
			{
				var table = customform.document.getElementById("DeferralGrid");
				var ajaxResult='';
				var rowCount = table.rows.length;
				
				for (var i = 3; i < rowCount; i++) 
				{
					var gridRow = "";
					if (customform.document.getElementById('status'+i).value == 'Open' || customform.document.getElementById('status'+i).value == '' || customform.document.getElementById('status'+i).value == 'null')
					{
						alert('Kindly close the all deferrals');
						customform.document.getElementById('status'+i).focus(true);
						return false;
					}
				}
			}
		}
		
		if(customform.document.getElementById("selectDecision").value=='Reject'||customform.document.getElementById("selectDecision").value=='Reject to RO'||customform.document.getElementById("selectDecision").value=='Reject to CBWC Maker'||customform.document.getElementById("selectDecision").value=='Reject to Credit' || customform.document.getElementById("selectDecision").value=='Reject to CROPS Maker' || customform.document.getElementById("selectDecision").value=='Send to Credit Analyst' || customform.document.getElementById("selectDecision").value=='Send to Business')
		{
			if(customform.document.getElementById("wdesk:Remarks").value== "")
			{
			  alert("Please provide remarks");
			  customform.document.getElementById('wdesk:Remarks').focus(true);
			  return false;
			}
			if(customform.document.getElementById('rejReasonCodes').value=='' || customform.document.getElementById('rejReasonCodes').value=='NO_CHANGE')
			{
			  alert("Please provide reject reason.");
			  customform.document.getElementById('RejectReason').focus(true);
			  return false;
			}
		}

		//below code added as part of CR 17-10-2018
		if(customform.document.getElementById("selectDecision").value=='Reject to AU Officer' || customform.document.getElementById("selectDecision").value=='Reject to AU Analyst' || customform.document.getElementById("selectDecision").value=='Reject to AU Document Checker' || customform.document.getElementById("selectDecision").value=='Send to Attach Additional Doc')
		{
			if(customform.document.getElementById('rejReasonCodes').value=='' || customform.document.getElementById('rejReasonCodes').value=='NO_CHANGE')
			{
			  alert("Please provide reject reason.");
			  customform.document.getElementById('RejectReason').focus(true);
			  return false;
			}		
		}
		return true;	
}
function alreadyRaised(WorkitemName,H_Checklist) {
	var xhr;
	var ajaxResult;
	ajaxResult="";
	var reqType = "RBL_ISExceptionRaised";

	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");
		 
	H_Checklist=H_Checklist.replace(/#/g,'`')
	
	var url = "/RBL/CustomForms/RBL_Specific/HandleAjaxProcedures.jsp";
	var param="WorkitemName="+WorkitemName+"&reqType="+reqType+"&H_Checklist="+H_Checklist;

	 xhr.open("POST",url,false);
	 xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	 xhr.send(param);

	if (xhr.status == 200) {
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
	}
	else {
		alert("Error while getting exception status");
		return "";
	}
	return ajaxResult;
}
function getDateTimeAtDone() {
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

function checkForUIDException()
{
	var flag=true;
	var UIDTable=customform.document.getElementById("UIDGrid");
	if(UIDTable.rows.length>3) 
	{
	  //then need to raise UID Exception
	  var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
	  var currCheckList=customform.document.getElementById('H_CHECKLIST').value;
	  var currUser=customform.document.getElementById('CurrentUserName').value;
	  //alert('found '+currCheckList.indexOf('001~[Raised'));
	  if(currCheckList.indexOf('001~[Raised')==-1)//Means this exception is not raised as of now 1-means UID exception
	  {
		if(currCheckList=='')
			currCheckList='001~[Raised-'+currUser+'-'+WSNAME+'-'+getDateTimeAtDone()+']';
		else
			currCheckList=currCheckList+'#'+'001~[Raised-'+currUser+'-'+WSNAME+'-'+getDateTimeAtDone()+']';
		
		customform.document.getElementById('H_CHECKLIST').value=currCheckList;
		flag=true;
	  }
	  flag=true;
	}
	else{
	
	flag=false;
	}
	return flag;
}
function CheckDecimal(id) 
{ 
	var decimal=  /^[-+]?[0-9]+\.[0-9]+$/; 
	var numbers = /^[0-9]+$/;
	if(id.value.match(decimal)||id.value.match(numbers)) 
	{ 
		return true;
	}
	else
	{ 
		return false;
	}
}
/*function checkFields()
{
	var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
	if(WSNAME=="AU_Doc_Checker" || WSNAME=="AU_Analyst" || WSNAME=="AttachAdditionalDocs")
	{
		var cifID=customform.document.getElementById("wdesk:CIF_Id").value;
		var rakTrackNumber=customform.document.getElementById("wdesk:RAK_Track_Number").value;
		var amountRequested=customform.document.getElementById("wdesk:Requested_Amount").value;
		var tenorRequested=customform.document.getElementById("wdesk:Requested_Tenor").value;
		var rmcode = customform.document.getElementById("wdesk:RMCode").value;
		
		var number=/^[0-9]{7}$/;
		var rakTrackRegEx=/^[0-9a-zA-Z]{6}$/;
		var amountRequestedReg=/^[0-9]{1,18}(\.[0-9]{2})$/;
		var amountRequestedReg1=/^[0-9]{1,20}$/;
		var tenorRequestedReg=/^[0-9]{1,4}$/;
		var rmCodeRegex=/^[0-9a-zA-Z]{1,20}$/;
		
		if(!(cifID.match(number)))
		{
			alert('CIF Id can have 7 digits');
			return false;
		}
		if(rakTrackNumber!="" && !(rakTrackNumber.match(rakTrackRegEx)))
		{
			alert('Rak Track can only be alphanumeric');
			return false;
		}
		if(amountRequested !="" && !(amountRequested.match(amountRequestedReg)))
		{
			alert("Amount Requested can only have two digits after decimal")
			return false;
		}
		if(tenorRequested!="" && !(tenorRequested.match(tenorRequestedReg)))
		{
			alert("Tenor Requested is numeric field with max 4 digits");
			return false;
		}
		if(rmcode!="" && !(rmcode.match(rmCodeRegex)))
		{
			alert("RM Code is a mandatory alphanumeric field with max 20 characters");
			return false;
		}
	}
	if(WSNAME=="AttachAdditionalDocs")
	{
		var incrementAmtReq=customform.document.getElementById("wdesk:Incremented_Amt_Req").value;
		var outstandingAmount=customform.document.getElementById("wdesk:Outstanding_Amount").value;
		var visitDate=customform.document.getElementById("wdesk:Visit_Date").value;
		var BVRDate=customform.document.getElementById("wdesk:BVR_Date").value;
		var amountReg=/^[0-9]{1,18}(\.[0-9]{2})$/;
		if(incrementAmtReq!="" && !(incrementAmtReq.match(amountReg)))
		{
			alert("Incremented Amount can only be a number with max two digits after decimal");
			return false;
		}
		if(outstandingAmount!="" && !(outstandingAmount.match(amountReg)))
		{
			alert('Oustanding Amount can only be a number with max two digits after decimal');
			return false;
		}
		if(visitDate!="" && ValidateDate(visitDate))
		{
			alert('Visit Date Cannot be a future date');
			return false;
		}
		if(BVRDate!="" && ValidateDate(BVRDate))
		{
			alert('BVR Date cannot be future Date');
			return false;
		}
	}
	return true;
}*/
function ValidateDate(expiryDate)
{
		var arrDate_and_time = expiryDate.split('-');
		expiryDate = arrDate_and_time[0];

		if(expiryDate!='')
		{
			var now = new Date();
			var month = now.getMonth()+1;
			if(month<10)
				month = "0"+month;
			var currdate = now.getDate()+"/"+month+"/"+now.getFullYear();

			var regExp = /(\d{1,2})\/(\d{1,2})\/(\d{2,4})/;

			if(parseInt(expiryDate.replace(regExp, "$3$2$1"))<=parseInt(currdate.replace(regExp, "$3$2$1")))
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		 
}


function AttachedDocType(sDocTypeNames)
{
	//var arrAvailableDocList = window.parent.getInterfaceData("D");
	var arrAvailableDocList = document.getElementById('wdesk:docCombo');
	if (arrAvailableDocList == null || arrAvailableDocList == 'null')
		arrAvailableDocList = customform.document.getElementById('wdesk:docCombo');
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
			if (arrAvailableDocList[iDocCounter].text.toUpperCase().indexOf(arrSearchDocList[iSearchCounter].toUpperCase()) >= 0) {
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