window.document.write("<script src=\"/webdesktop/webtop/scripts/SRM_Scripts/SRM_constants.js\"></script>");
function getDocHeight(doc) {
    doc = doc || document;
    var body = doc.body, html = doc.documentElement;
    var height = Math.max(body.scrollHeight,body.offsetHeight,html.clientHeight,html.scrollHeight,html.offsetHeight);
    return height;
}

function populateCustomValue(columnList,frameName,selGridModifyBundleID,CategoryID,SubCategoryID,sMode)
{
	//In this function Write Custom Validation and code	on select of grid radio button
	
	var modifyGridBundleId = document.getElementById(frameName+'_modifyGridBundle').value;
	var tempElementName = frameName+"_"+SubCategoryID+"_gridbundle_";
	var gridRowNum = modifyGridBundleId.substring(tempElementName.length);
	if(CategoryID=='1' && SubCategoryID=='3')
	{
	
		if(sMode=="R" )
		{
			document.getElementById('3_block_card').disabled=true;
			return false;
		}		
		
		
		var myradio = document.getElementsByName('3_verification_details');
		var x = 0;
		var veriDetailChecked = false;
		var veriDetailCheckedValue = '';
		for(x = 0; x < myradio.length; x++)
		{
			if(myradio[x].checked==true){
					veriDetailChecked=true;
					veriDetailCheckedValue=myradio[x].value;
			}
		}
		
		if(veriDetailCheckedValue=='TIN' || veriDetailCheckedValue=='Manual')
		{
				document.getElementById("3_third_party_name").value=''; 
				document.getElementById("3_third_party_name").readonly=true; 
				document.getElementById("3_third_party_contact_number").value=''; 
				document.getElementById("3_third_party_contact_number").readonly=true; 
		}
	
		document.getElementById('3_block_card').disabled=false;
		document.getElementById('3_type_of_block').disabled=false;
		document.getElementById('3_reason_for_block').disabled=false;
		document.getElementById('3_replacement_required').disabled=false;
		document.getElementById("3_date_and_time").disabled=false;	
		document.getElementById("3_ATM_Loc").disabled=false;
		document.getElementById("3_branch_collect").disabled=false;		
			
		if((document.getElementById('3_req_status').value).replace(/^\s+|\s+$/gm,'')=='Not Blocked')
		{
			document.getElementsByTagName("table")[2].rows[7].style.display ="";
			document.getElementsByTagName("table")[2].rows[8].style.display ="";
			document.getElementById('3_remarks_action').disabled=false;
			
			var myradio = document.getElementsByName('3_manual_blocking_action');
			veriDetailChecked = false;
			for(var x = 0; x < myradio.length; x++)
			{	
				myradio[x].disabled = false;
			
				if(myradio[x].checked==true)
				{
					veriDetailChecked=true;
				}
			}
			if(!veriDetailChecked)
			{
				myradio[0].checked=true;
			}
			var iframe = parent.document.getElementById("frmData");	
			var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
			parent.document.getElementById("frmData").style.height=getDocHeight(iframeDocument)+ 4 + "px";
		}
		else 
		{
			document.getElementsByTagName("table")[2].rows[7].style.display ="none";
			document.getElementsByTagName("table")[2].rows[8].style.display ="none";
			document.getElementById('3_remarks_action').disabled=true;
			var myradio = document.getElementsByName('3_manual_blocking_action');
			for(var x = 0; x < myradio.length; x++)
			{	
				myradio[x].disabled = true;					
			}
		}
	
		if(document.getElementById('3_block_card').checked==false)
		{
			document.getElementById('3_block_card').checked=false;
		}
		
		if(document.getElementById('3_block_card').checked==false)
		{
			document.getElementById('3_type_of_block').value='--Select--';
			document.getElementById('3_type_of_block').disabled=true;
		}
		else if(document.getElementById('3_block_card').checked==true)
		{
				document.getElementById('3_type_of_block').disabled=false;
		}
		
		if(document.getElementById('3_type_of_block').value=='--Select--')
		{
			document.getElementById('3_reason_for_block').value='--Select--';
			document.getElementById('3_reason_for_block').disabled=true;
			document.getElementById('3_replacement_required').value='--Select--';
			document.getElementById('3_replacement_required').disabled=true;
			
		}
		else if(document.getElementById('3_type_of_block').value=='Temporary')
		{
			document.getElementById('3_reason_for_block').disabled=false;
			document.getElementById('3_replacement_required').value='No';
			document.getElementById('3_replacement_required').disabled=true;
		}
		else if(document.getElementById('3_type_of_block').value=='Permanent')
		{
			document.getElementById('3_reason_for_block').disabled=false;
		
			if(veriDetailCheckedValue=='Non - Customer')
			{
				document.getElementById("3_replacement_required").value='No';
				document.getElementById("3_replacement_required").disabled=true; 
			}
			else
			{
				document.getElementById("3_replacement_required").disabled=false; 
			}
			
		}
		
		if(((document.getElementById("3_reason_for_block").value=='Lost') 
			||(document.getElementById("3_reason_for_block").value=='Stolen')
			||document.getElementById("3_reason_for_block").value=='Captured at Rak bank ATM'
			||document.getElementById("3_reason_for_block").value=='Captured in non-Rak bank ATM'
			||(document.getElementById("3_reason_for_block").value=='Misuse')
		))
		{
			document.getElementById("3_date_and_time").disabled=false;
		}
		else
		{
			document.getElementById("3_date_and_time").disabled=true;
		}
		
		if((document.getElementById("3_reason_for_block").value=='Captured at Rak bank ATM'
			||document.getElementById("3_reason_for_block").value=='Captured in non-Rak bank ATM'
		))
		{
			document.getElementById("3_ATM_Loc").disabled=false;
			document.getElementById("3_branch_collect").disabled=false;		
		}else{
			document.getElementById("3_ATM_Loc").disabled=true;
			document.getElementById("3_branch_collect").disabled=true;		
		}
		
		if(document.getElementById("3_available_balance").value=='' || document.getElementById("3_available_balance").value==' ')
		{
			var blockUrl="/webdesktop/CustomForms/SRM_Specific/SRMIntegration.jsp?CardNumber="+document.getElementById('3_card_number').value+"&CustId="+document.getElementById('3_cif').value+"&WSNAME=PBO&WS_LogicalName=PBO&CategoryID=1&SubCategoryID=3&IsDoneClicked=N&IsError=N&IsSaved=N&RequestType=CARD_BALENQ";
			//window.open(blockUrl);
			blockUrl=replaceUrlChars(blockUrl);			
			var ResponseList;	
			var xhr;
			var ajaxResult;
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			 xhr.open("GET",blockUrl,false); 
			 xhr.send(null);
			if (xhr.status == 200 && xhr.readyState == 4)
			{
				ajaxResult=Trim(xhr.responseText);
			}
			else
			{
				alert("Problem in Blocking Cards");
				return false;
			}
			ResponseList = ajaxResult.split("~");
			var responseMainCode=ResponseList[0];
			var responseAvailableBalance=ResponseList[1];
			
			if(responseMainCode=='0000')
			{
				document.getElementById('3_available_balance').value=responseAvailableBalance;
			}
		}
		
		if(document.getElementById('WS_NAME').value!='PBO')
		{	
			document.getElementById('3_block_card').disabled=true;
			document.getElementById('3_type_of_block').disabled=true;
			document.getElementById('3_reason_for_block').disabled=true;
			document.getElementById('3_replacement_required').disabled=true;
			document.getElementById("3_date_and_time").disabled=true;	
			document.getElementById("3_ATM_Loc").disabled=true;
			document.getElementById("3_branch_collect").disabled=true;	
			document.getElementById('3_remarks_action').disabled=true;
			var myradio = document.getElementsByName('3_manual_blocking_action');
			for(var x = 0; x < myradio.length; x++)
			{	
				myradio[x].disabled = true;					
			}			
		}
		else if(document.getElementById('WS_NAME').value=='PBO')
		{
			window.document.getElementById("3_block_card").focus();
		}
		
					
		if((document.getElementById('3_req_status').value).replace(/^\s+|\s+$/gm,'')=='Not Blocked' || parent.document.getElementById("wdesk:IntegrationStatus").value=='false')
		{
			document.getElementById('3_block_card').disabled=true;
			document.getElementById('3_type_of_block').disabled=true;
			document.getElementById('3_reason_for_block').disabled=true;
			document.getElementById('3_replacement_required').disabled=true;
			document.getElementById("3_date_and_time").disabled=true;	
			document.getElementById("3_ATM_Loc").disabled=true;
			document.getElementById("3_branch_collect").disabled=true;
			document.getElementById("3_block_card").disabled = true;
		}
		
	}
	else if(CategoryID=='1' && SubCategoryID=='2')
	{
		
		if(sMode=="R")
		{
			document.getElementById('2_bt_required').disabled=true;
			if(document.getElementById('WS_NAME').value=='Reject')
			{
				if(document.getElementById("2_caps_status").value=='' && frameName=='AUTHORIZATION DETAILS')
				{
					document.getElementById("2_req_upld_status").value='Not Uploaded in CAPS';
					var gridrowcount = document.getElementById("AUTHORIZATION DETAILS_2_gridrowCount").value;
					/*for(var i =0; i<gridrowcount; i++)
						document.getElementById("grid_2_req_upld_status_"+(i)).value='Not Uploaded in CAPS';	*/
					if(gridRowNum=='')
						document.getElementById("grid_2_req_upld_status_0").value='Not Uploaded in CAPS';
					else
						document.getElementById("grid_2_req_upld_status_"+(gridRowNum-1)).value='Not Uploaded in CAPS';
				}
			}
			return false;
		}	
		var veriDetailChecked = false;
			
		if(document.getElementById("2_status").value!='Success' && document.getElementById("2_sub_ref_no_auth").value!='' && parent.document.getElementById("wdesk:IntegrationStatus").value=='false')// prateek
		{
			
			document.getElementById("2_auth_code").disabled=false;
			
			document.getElementsByTagName("table")[9].rows[3].style.display ="";
			document.getElementsByTagName("table")[9].rows[4].style.display ="";
			if(document.getElementById('WS_NAME').value!='PBO')
			{
				document.getElementsByTagName("table")[9].rows[5].style.display ="";
				document.getElementsByTagName("table")[9].rows[7].style.display ="";
				
				var unBlockradio = document.getElementsByName('2_manual_unblocking_action');
				var isChecked = false;
				for(var x = 0; x < unBlockradio.length; x++)
				{	
					unBlockradio[x].disabled = false;
				
					if(unBlockradio[x].checked==true)
					{
						isChecked=true;
					}
				}
				if(!isChecked)
				{
					unBlockradio[0].checked=true;
				}
			}
			
			var myradio = document.getElementsByName('2_manual_blocking_action');
			veriDetailChecked = false;
			for(var x = 0; x < myradio.length; x++)
			{	
				myradio[x].disabled = false;
			
				if(myradio[x].checked==true)
				{
					veriDetailChecked=true;
				}
			}
			if(!veriDetailChecked)
			{
				myradio[0].checked=true;
			}
			var iframe = parent.document.getElementById("frmData");	
			var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
			parent.document.getElementById("frmData").style.height=getDocHeight(iframeDocument)+ 4 + "px";
		}
		else
		{
		
			document.getElementById("2_auth_code").disabled=true;
			
			document.getElementsByTagName("table")[9].rows[3].style.display ="none";
			document.getElementsByTagName("table")[9].rows[4].style.display ="none";
			document.getElementsByTagName("table")[9].rows[5].style.display ="none";
			
			if(document.getElementById('WS_NAME').value!='PBO')
			{
				document.getElementsByTagName("table")[9].rows[5].style.display ="none";
				document.getElementsByTagName("table")[9].rows[7].style.display ="none";
			}
		}			
				
		document.getElementById("2_bt_required").disabled=false;
		if(document.getElementById("2_bt_required").checked==true)
		{
			document.getElementById("Check Card Eligibility").disabled=false;
		}
		else
		{
			document.getElementById("Check Card Eligibility").disabled=true;
		}
		
		if(document.getElementById('WS_NAME').value=='Q4')
		{
			if(document.getElementById("2_caps_status").value=='ERROR IN ONLINE')
			{
				document.getElementById("Cancel").disabled=false;	
				document.getElementById("2_cancellation_remarks").disabled=false;
			}
			else
			{
				document.getElementById("Cancel").disabled=true;	
				document.getElementById("2_cancellation_remarks").disabled=true;
			}
			
		}

		if(document.getElementById("2_available_balance").value=='' || document.getElementById("2_available_balance").value==' ')
		{
			
			var blockUrl="/webdesktop/CustomForms/SRM_Specific/SRMIntegration.jsp?CardNumber="+document.getElementById('2_rak_card_no').value+"&CustId="+document.getElementById('2_cif').value+"&WSNAME=PBO&WS_LogicalName=PBO&CategoryID=1&SubCategoryID=2&IsDoneClicked=N&IsError=N&IsSaved=N&RequestType=CARD_BALENQ";
			
			blockUrl=replaceUrlChars(blockUrl);			
			var ResponseList;	
			var xhr;
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			 xhr.open("GET",blockUrl,false); 
			 xhr.send(null);
							
			if (xhr.status == 200 && xhr.readyState == 4)
			{
							
				var ajaxResult=Trim(xhr.responseText);
				
			}
			else
			{
				alert("Problem in Getting available balance");
				return false;
			}
			ResponseList = ajaxResult.split("~");
			var responseMainCode=ResponseList[0];
			var responseAvailableBalance=ResponseList[1];
			var responseAvailableCashBalance = ResponseList[2];
			if(responseMainCode=='0000')
			{
				document.getElementById('2_available_balance').value=responseAvailableBalance;
				document.getElementById('2_available_balance_cash').value=responseAvailableCashBalance;
			}
		}
		
		if(parent.document.getElementById("wdesk:IntegrationStatus").value=='false') // prateek
		{
			
			document.getElementById('2_bt_required').disabled=true;
			document.getElementById("Check Card Eligibility").disabled=true;	
			document.getElementById("CARD DETAILS_Modify").disabled=true;	
			document.getElementById("CARD DETAILS_Clear").disabled=true;	
					
			
			document.getElementById("2_sub_ref_no").disabled=true;
			document.getElementById("2_rakbank_eligible_card_no").disabled=true;
			document.getElementById("2_bt_amt_req").disabled=true;
			document.getElementById("2_other_bank_card_type").disabled=true;
			document.getElementById("2_name_on_card").disabled=true;
			document.getElementById("2_other_bank_card_no").disabled=true;
			document.getElementById("2_type_of_bt").disabled=true;
			document.getElementById("2_other_bank_name").disabled=true;
			document.getElementById("2_remarks").disabled=true;
			document.getElementById("2_payment_by").disabled=true;
			document.getElementById("2_delivery_channel").disabled=true;
			document.getElementById("2_branch_name").disabled=true;
			document.getElementById("2_eligibility").disabled=true;
			document.getElementById("Check BT Eligibility").disabled=true;	
			document.getElementById("BALANCE TRANSFER DETAILS_Add").disabled=true;	
			document.getElementById("BALANCE TRANSFER DETAILS_Modify").disabled=true;	
			document.getElementById("BALANCE TRANSFER DETAILS_Delete").disabled=true;	
			document.getElementById("BALANCE TRANSFER DETAILS_Clear").disabled=true;	
		}
		else
		{
			if(document.getElementById("2_payment_by").value=='FTS')
			{
				document.getElementById("2_delivery_channel").disabled=true;
				document.getElementById("2_branch_name").disabled=true;
			}
			else if(document.getElementById("2_payment_by").value=='MCQ')
			{
				document.getElementById("2_delivery_channel").disabled=false;
				document.getElementById("2_branch_name").disabled=false;
			}
			
			if(document.getElementById("2_delivery_channel").value=='Courier')
			{
				document.getElementById("2_branch_name").disabled=true;
				document.getElementById("2_delivery_channel").disabled=false;
				
			}
			else if(document.getElementById("2_delivery_channel").value=='Branch')
			{
				document.getElementById("2_delivery_channel").disabled=false;
				document.getElementById("2_branch_name").disabled=false;
			}
			
			
			
		}
		if(frameName == 'AUTHORIZATION DETAILS')
		{
			if (parent.document.getElementById("wdesk:IntegrationStatus").value!='false')
			{
				document.getElementById("2_auth_code").disabled=true;
			}
			else if((document.getElementById("2_sub_ref_no_auth").value).replace(/^\s+|\s+$/gm,'')!='' && document.getElementById("2_status").value!='Success' )// prateek
			{
				document.getElementById("2_sub_ref_no_auth").disabled=true;
				document.getElementById("2_card_no").disabled=true;
				if(document.getElementById('WS_NAME').value=='PBO' && parent.document.getElementById("wdesk:IntegrationStatus").value=='false')
				{
					document.getElementById("2_auth_code").disabled=true;
				}
				else if(document.getElementById('WS_NAME').value=='PBO' && parent.document.getElementById("wdesk:IntegrationStatus").value!='false')
				{
					document.getElementById("2_auth_code").disabled=false;
				}
				else	
					document.getElementById("2_auth_code").disabled=true;
					
				//document.getElementById("2_auth_code").disabled=true;
				document.getElementById("2_status").disabled=true;
				document.getElementById("2_bt_amount").disabled=true;
				document.getElementById("2_tran_req_uid").disabled=true;
				document.getElementById("2_Approval_cd").disabled=true;
				document.getElementById("2_remarks_action").disabled=false;
				document.getElementById("AUTHORIZATION DETAILS_Modify").disabled=false;
			}
			else
			{
				document.getElementById("2_sub_ref_no_auth").disabled=true;
				document.getElementById("2_card_no").disabled=true;
				document.getElementById("2_auth_code").disabled=true;
				document.getElementById("2_status").disabled=true;
				document.getElementById("2_bt_amount").disabled=true;
				document.getElementById("2_tran_req_uid").disabled=true;
				document.getElementById("2_Approval_cd").disabled=true;
								
			}
			
			if(document.getElementById('WS_NAME').value!='PBO' && document.getElementById('WS_NAME').value!='Q1' && document.getElementById('WS_NAME').value!='Q2' && document.getElementById('WS_NAME').value!='Q6') // condition && document.getElementById('WS_NAME').value!='Q6' added for Checker queue as part of Outbound CR_24052017
			{
				if(document.getElementById("2_caps_status").value=='FAILED')
					document.getElementById("2_caps_status").value='ERROR IN CAPS';
				else if(document.getElementById("2_caps_status").value=='REJECTED' && document.getElementById("2_req_upld_status").value=='FAILURE')
					document.getElementById("2_caps_status").value='ERROR IN ONLINE';	
				document.getElementById("2_caps_status").disabled=true;
			}
			
		}
		//end vivek 08082014
		
		if(document.getElementById('WS_NAME').value!='PBO')
		{
			
			var myradio = document.getElementsByName('2_manual_blocking_action');
			veriDetailChecked = false;
			for(var x = 0; x < myradio.length; x++)
			{	
				myradio[x].disabled = true;
			}
			
			document.getElementById("2_remarks_action").disabled=true;
		}
		else
		{
			if(frameName=='CARD DETAILS')
				window.document.getElementById("2_bt_required").focus();
		}
		
	}
	else if(CategoryID=='1' && SubCategoryID=='4')
	{
	
		if(sMode=="R")
		{
			document.getElementById('4_ccc_required').disabled=true;
			if(document.getElementById('WS_NAME').value=='Reject')
			{
				
				if(document.getElementById("4_caps_status").value=='' && frameName=='AUTHORIZATION DETAILS')
				{
					document.getElementById("4_req_upld_status").value='Not Uploaded in CAPS';
					var gridrowcount = document.getElementById("AUTHORIZATION DETAILS_4_gridrowCount").value;
					/*for(var i =0; i<gridrowcount; i++)
						document.getElementById("grid_4_req_upld_status_"+(i)).value='Not Uploaded in CAPS';	*/
						
					
					//alert("debug"+gridRowNum+"!"+selGridModifyBundleID);
					if(gridRowNum=='')
						document.getElementById("grid_4_req_upld_status_0").value='Not Uploaded in CAPS';
					else
						document.getElementById("grid_4_req_upld_status_"+(gridRowNum-1)).value='Not Uploaded in CAPS';
				}	
			}
			return false;
		}	
		
		if(document.getElementById("4_status").value!='Success' && document.getElementById("4_sub_ref_no_auth").value!='' && parent.document.getElementById("wdesk:IntegrationStatus").value=='false')// prateek
		{
			document.getElementById("4_auth_code").disabled=false;
			
			
		
			document.getElementsByTagName("table")[9].rows[3].style.display ="";
			document.getElementsByTagName("table")[9].rows[4].style.display ="";
			if(document.getElementById('WS_NAME').value!='PBO')
			{
				document.getElementsByTagName("table")[9].rows[5].style.display ="";
				document.getElementsByTagName("table")[9].rows[7].style.display ="";
				
				var unBlockradio = document.getElementsByName('4_manual_unblocking_action');
				var isChecked = false;
				for(var x = 0; x < unBlockradio.length; x++)
				{	
					unBlockradio[x].disabled = false;
				
					if(unBlockradio[x].checked==true)
					{
						isChecked=true;
					}
				}
				if(!isChecked)
				{
					unBlockradio[0].checked=true;
				}
			}
			
			var myradio = document.getElementsByName('4_manual_blocking_action');
			veriDetailChecked = false;
			for(var x = 0; x < myradio.length; x++)
			{	
				myradio[x].disabled = false;
			
				if(myradio[x].checked==true)
				{
					veriDetailChecked=true;
				}
			}
			if(!veriDetailChecked)
			{
				myradio[0].checked=true;
			}
			var iframe = parent.document.getElementById("frmData");	
			var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
			parent.document.getElementById("frmData").style.height=getDocHeight(iframeDocument)+ 4 + "px";
		}
		else
		{
			document.getElementById("4_auth_code").disabled=true;
			
			document.getElementsByTagName("table")[9].rows[3].style.display ="none";
			document.getElementsByTagName("table")[9].rows[4].style.display ="none";
			document.getElementsByTagName("table")[9].rows[5].style.display ="none";
			if(document.getElementById('WS_NAME').value!='PBO')
			{
				document.getElementsByTagName("table")[9].rows[5].style.display ="none";
				document.getElementsByTagName("table")[9].rows[7].style.display ="none";
			}
		}
			
		var WSNAME = document.getElementById('WS_NAME').value;
		if(WSNAME=='PBO')
		{
			document.getElementById("4_ccc_required").disabled=false;
		
			if(document.getElementById("4_ccc_required").checked==true)
			{
				document.getElementById("Check Card Eligibility").disabled=false;
				document.getElementById("4_Purpose").disabled=false;
			}
			else
			{
				document.getElementById("Check Card Eligibility").disabled=true;
				document.getElementById("4_Purpose").disabled=true;
			}
		}
		else
		{
				document.getElementById("Check Card Eligibility").disabled=true;
				document.getElementById("4_Purpose").disabled=true;
				document.getElementById("4_ccc_required").disabled=true;
				if(WSNAME=='Q1')
				{
					//
				}
		}
		
		if(document.getElementById('WS_NAME').value=='Q4')
		{
			if(document.getElementById("4_caps_status").value=='ERROR IN ONLINE' )
			{
				document.getElementById("Cancel").disabled=false;	
				document.getElementById("4_cancellation_remarks").disabled=false;
			}
			else
			{
				document.getElementById("Cancel").disabled=true;	
				document.getElementById("4_cancellation_remarks").disabled=true;
			}
			
		}
		
		//vivek 08082014, starts
		document.getElementById('4_available_balance').value ='';
		if(document.getElementById("4_available_balance").value=='' || document.getElementById("4_available_balance").value==' ')
		{
		
			var blockUrl="/webdesktop/CustomForms/SRM_Specific/SRMIntegration.jsp?CardNumber="+document.getElementById('4_card_no').value+"&CustId="+document.getElementById('4_cif').value+"&WSNAME=PBO&WS_LogicalName=PBO&CategoryID=1&SubCategoryID=4&IsDoneClicked=N&IsError=N&IsSaved=N&RequestType=CARD_BALENQ";
			
			blockUrl=replaceUrlChars(blockUrl);			
			var ResponseList;	
			var xhr;
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			 xhr.open("GET",blockUrl,false); 
			 xhr.send(null);
					
			if (xhr.status == 200 && xhr.readyState == 4)
			{
							
				var ajaxResult=Trim1(xhr.responseText);
				
			}
			else
			{
				alert("Problem in Getting Available Balance");
				return false;
			}
			ResponseList = ajaxResult.split("~");
			var responseMainCode=ResponseList[0];
			var responseAvailableBalance=ResponseList[1];
			var responseAvailableCashBalance = ResponseList[2];
			if(responseMainCode=='0000'){
				document.getElementById('4_available_balance').value=responseAvailableBalance;
				document.getElementById('4_available_balance_cash').value=responseAvailableCashBalance;
				//document.getElementById('4_available_balance').disabled=true;
			}
		}
		//end vivek 08082014
		
		if(parent.document.getElementById("wdesk:IntegrationStatus").value=='false') // prateek
		{
			
			document.getElementById('4_ccc_required').disabled=true;
			document.getElementById("Check Card Eligibility").disabled=true;	
			document.getElementById("CARD DETAILS_Modify").disabled=true;	
			document.getElementById("CARD DETAILS_Clear").disabled=true;	
			document.getElementById("4_sub_ref_no").disabled=true;
			document.getElementById("4_rakbank_eligible_card_no").disabled=true;
			document.getElementById("4_ccc_amt_req").disabled=true;
			document.getElementById("4_beneficiary_name").disabled=true;
			document.getElementById("4_payment_by").disabled=true;
			document.getElementById("4_delivery_channel").disabled=true;
			document.getElementById("4_branch_name").disabled=true;
			document.getElementById("4_remarks").disabled=true;
			document.getElementById("4_marketing_code").disabled=true;
			document.getElementById("Check CCC Eligibility").disabled=true;
		
			document.getElementById("CREDIT CARD CHEQUE DETAILS_Add").disabled=true;	
			document.getElementById("CREDIT CARD CHEQUE DETAILS_Modify").disabled=true;	
			document.getElementById("CREDIT CARD CHEQUE DETAILS_Delete").disabled=true;	
			document.getElementById("CREDIT CARD CHEQUE DETAILS_Clear").disabled=true;	
		}
		else
		{
			if(document.getElementById("4_delivery_channel").value=='Courier')
			{
				document.getElementById("4_delivery_channel").disabled=false;
				document.getElementById("4_branch_name").disabled=true;
			}
			else
			{
				document.getElementById("4_delivery_channel").disabled=false;
				document.getElementById("4_branch_name").disabled=false;
			}
		}
		if (parent.document.getElementById("wdesk:IntegrationStatus").value!='false')
			{
				//alert('here');
				document.getElementById("4_auth_code").disabled=true;
			}
		else if((document.getElementById("4_sub_ref_no_auth").value).replace(/^\s+|\s+$/gm,'')!='' && document.getElementById("4_status").value!='Success' )// prateek
		{
			
			document.getElementById("4_sub_ref_no_auth").disabled=true;
			document.getElementById("4_card_no").disabled=true;
			if(document.getElementById('WS_NAME').value=='PBO' && parent.document.getElementById("wdesk:IntegrationStatus").value=='false')
			{
				document.getElementById("4_auth_code").disabled=true;
			}
			else if(document.getElementById('WS_NAME').value=='PBO' && parent.document.getElementById("wdesk:IntegrationStatus").value!='false')
			{
				document.getElementById("4_auth_code").disabled=false;
			}
			else	
				document.getElementById("4_auth_code").disabled=true;
			
			document.getElementById("4_status").disabled=true;
			document.getElementById("4_ccc_amount").disabled=true;
			document.getElementById("4_tran_req_uid").disabled=true;
			document.getElementById("4_Approval_cd").disabled=true;
			document.getElementById("4_remarks_action").disabled=false;
			document.getElementById("AUTHORIZATION DETAILS_Modify").disabled=false;
		
		}
		else
		{
		
			document.getElementById("4_sub_ref_no_auth").disabled=true;
			document.getElementById("4_card_no").disabled=true;
			document.getElementById("4_auth_code").disabled=true;
			document.getElementById("4_status").disabled=true;
			document.getElementById("4_ccc_amount").disabled=true;
			document.getElementById("4_tran_req_uid").disabled=true;
			document.getElementById("4_Approval_cd").disabled=true;			
			
		}
		if(document.getElementById('WS_NAME').value!='PBO' && document.getElementById('WS_NAME').value!='Q1' && document.getElementById('WS_NAME').value!='Q2' && document.getElementById('WS_NAME').value!='Q6') // condition && document.getElementById('WS_NAME').value!='Q6' added for Checker queue as part of Outbound CR_24052017
		{
			if(document.getElementById("4_caps_status").value=='FAILED')
				document.getElementById("4_caps_status").value='ERROR IN CAPS';
			else if(document.getElementById("4_caps_status").value=='REJECTED' && document.getElementById("4_req_upld_status").value=='FAILURE')
					document.getElementById("4_caps_status").value='ERROR IN ONLINE';	
				document.getElementById("4_caps_status").disabled=true;
			document.getElementById("4_caps_status").disabled=true;
		}
		if(document.getElementById('WS_NAME').value!='PBO')
		{
			
			var myradio = document.getElementsByName('4_manual_blocking_action');
			veriDetailChecked = false;
			for(var x = 0; x < myradio.length; x++)
			{	
				myradio[x].disabled = true;
			}
			
			document.getElementById("4_remarks_action").disabled=true;
		}
		else
		{
			if(frameName=='CARD DETAILS')
				window.document.getElementById("4_ccc_required").focus();
		}
	}
	else if(CategoryID=='1' && SubCategoryID=='5')
	{
	
		if(sMode=="R")
		{
			document.getElementById('5_sc_required').disabled=true;
			if(document.getElementById('WS_NAME').value=='Reject')
			{
				
				if(document.getElementById("5_caps_status").value=='' && frameName=='AUTHORIZATION DETAILS')
				{
					document.getElementById("5_req_upld_status").value='Not Uploaded in CAPS';
					var gridrowcount = document.getElementById("AUTHORIZATION DETAILS_5_gridrowCount").value;
					/*for(var i =0; i<gridrowcount; i++)
						document.getElementById("grid_5_req_upld_status_"+(i)).value='Not Uploaded in CAPS';	*/
						
					
					//alert("debug"+gridRowNum+"!"+selGridModifyBundleID);
					if(gridRowNum=='')
						document.getElementById("grid_5_req_upld_status_0").value='Not Uploaded in CAPS';
					else
						document.getElementById("grid_5_req_upld_status_"+(gridRowNum-1)).value='Not Uploaded in CAPS';
				}	
			}
			return false;
		}	
		
		if(document.getElementById("5_status").value!='Success' && document.getElementById("5_sub_ref_no_auth").value!='' && parent.document.getElementById("wdesk:IntegrationStatus").value=='false')// prateek
		{
			document.getElementById("5_auth_code").disabled=false;
			
			
		
			document.getElementsByTagName("table")[9].rows[3].style.display ="";
			document.getElementsByTagName("table")[9].rows[4].style.display ="";
			if(document.getElementById('WS_NAME').value!='PBO')
			{
				document.getElementsByTagName("table")[9].rows[5].style.display ="";
				document.getElementsByTagName("table")[9].rows[7].style.display ="";
				
				var unBlockradio = document.getElementsByName('5_manual_unblocking_action');
				var isChecked = false;
				for(var x = 0; x < unBlockradio.length; x++)
				{	
					unBlockradio[x].disabled = false;
				
					if(unBlockradio[x].checked==true)
					{
						isChecked=true;
					}
				}
				if(!isChecked)
				{
					unBlockradio[0].checked=true;
				}
			}
			
			var myradio = document.getElementsByName('5_manual_blocking_action');
			veriDetailChecked = false;
			for(var x = 0; x < myradio.length; x++)
			{	
				myradio[x].disabled = false;
			
				if(myradio[x].checked==true)
				{
					veriDetailChecked=true;
				}
			}
			if(!veriDetailChecked)
			{
				myradio[0].checked=true;
			}
			var iframe = parent.document.getElementById("frmData");	
			var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
			parent.document.getElementById("frmData").style.height=getDocHeight(iframeDocument)+ 4 + "px";
		}
		else
		{
			document.getElementById("5_auth_code").disabled=true;
			
			document.getElementsByTagName("table")[9].rows[3].style.display ="none";
			document.getElementsByTagName("table")[9].rows[4].style.display ="none";
			document.getElementsByTagName("table")[9].rows[5].style.display ="none";
			if(document.getElementById('WS_NAME').value!='PBO')
			{
				document.getElementsByTagName("table")[9].rows[5].style.display ="none";
				document.getElementsByTagName("table")[9].rows[7].style.display ="none";
			}
		}
			
		var WSNAME = document.getElementById('WS_NAME').value;
		if(WSNAME=='PBO')
		{
			document.getElementById("5_sc_required").disabled=false;
		
			if(document.getElementById("5_sc_required").checked==true)
			{
				document.getElementById("Check Card Eligibility").disabled=false;
				//document.getElementById("5_Purpose").disabled=false;
			}
			else
			{
				document.getElementById("Check Card Eligibility").disabled=true;
				//document.getElementById("5_Purpose").disabled=true;
			}
		}
		else
		{
				document.getElementById("Check Card Eligibility").disabled=true;
				//document.getElementById("5_Purpose").disabled=true;
				document.getElementById("5_sc_required").disabled=true;
				if(WSNAME=='Q1')
				{
					//
				}
		}
		
		if(document.getElementById('WS_NAME').value=='Q4')
		{
			if(document.getElementById("5_caps_status").value=='ERROR IN ONLINE' )
			{
				document.getElementById("Cancel").disabled=false;	
				document.getElementById("5_cancellation_remarks").disabled=false;
			}
			else
			{
				document.getElementById("Cancel").disabled=true;	
				document.getElementById("5_cancellation_remarks").disabled=true;
			}
			
		}
		
		//vivek 08082014, starts
		document.getElementById('5_available_balance').value ='';
		if(document.getElementById("5_available_balance").value=='' || document.getElementById("5_available_balance").value==' ')
		{
		
			var blockUrl="/webdesktop/CustomForms/SRM_Specific/SRMIntegration.jsp";
			var param = "&CardNumber="+document.getElementById('5_card_no').value+"&CustId="+document.getElementById('5_cif').value+"&WSNAME=PBO&WS_LogicalName=PBO&CategoryID=1&SubCategoryID=5&IsDoneClicked=N&IsError=N&IsSaved=N&RequestType=CARD_BALENQ";
			blockUrl=replaceUrlChars(blockUrl);			
			var ResponseList;	
			var xhr;
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			 xhr.open("POST",blockUrl,false); 
			 xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			 xhr.send(param);
					
			if (xhr.status == 200 && xhr.readyState == 4)
			{
							
				var ajaxResult=Trim1(xhr.responseText);
				
			}
			else
			{
				alert("Problem in Getting Available Balance");
				return false;
			}
			ResponseList = ajaxResult.split("~");
			var responseMainCode=ResponseList[0];
			var responseAvailableBalance=ResponseList[1];
			var responseAvailableCashBalance = ResponseList[2];
			if(responseMainCode=='0000'){
				document.getElementById('5_available_balance').value=responseAvailableBalance;
				document.getElementById('5_available_balance_cash').value=responseAvailableCashBalance;
				//document.getElementById('5_available_balance').disabled=true;
			}
		}
		//end vivek 08082014
		
		if(parent.document.getElementById("wdesk:IntegrationStatus").value=='false') // prateek
		{
			
			document.getElementById('5_sc_required').disabled=true;
			document.getElementById("Check Card Eligibility").disabled=true;	
			document.getElementById("CARD DETAILS_Modify").disabled=true;	
			document.getElementById("CARD DETAILS_Clear").disabled=true;	
			document.getElementById("5_sub_ref_no").disabled=true;
			document.getElementById("5_rakbank_eligible_card_no").disabled=true;
			document.getElementById("5_sc_amt_req").disabled=true;
			document.getElementById("5_beneficiary_name").disabled=true;
			document.getElementById("5_type_of_smc").disabled=true;
			document.getElementById("5_payment_by").disabled=true;
			document.getElementById("5_other_bank_name").disabled=true;
			document.getElementById("5_delivery_channel").disabled=true;
			document.getElementById("5_branch_name").disabled=true;
			document.getElementById("5_remarks").disabled=true;
			document.getElementById("5_marketing_code").disabled=true;
			document.getElementById("Check SMC Eligibility").disabled=true;
			document.getElementById("5_RakbankAccountNO").disabled=true;
			document.getElementById("5_other_bank_iban").disabled=true;
		
			document.getElementById("SMART CASH DETAILS_Add").disabled=true;	
			document.getElementById("SMART CASH DETAILS_Modify").disabled=true;	
			document.getElementById("SMART CASH DETAILS_Delete").disabled=true;	
			document.getElementById("SMART CASH DETAILS_Clear").disabled=true;	
		}
		else
		{
			if(document.getElementById("5_delivery_channel").value=='Courier')
			{
				document.getElementById("5_delivery_channel").disabled=false;
				document.getElementById("5_branch_name").disabled=true;
			}
			else
			{
				document.getElementById("5_delivery_channel").disabled=false;
				document.getElementById("5_branch_name").disabled=false;
			}
		}
		if (parent.document.getElementById("wdesk:IntegrationStatus").value!='false')
			{
				//alert('here');
				document.getElementById("5_auth_code").disabled=true;
			}
		else if((document.getElementById("5_sub_ref_no_auth").value).replace(/^\s+|\s+$/gm,'')!='' && document.getElementById("5_status").value!='Success' )// prateek
		{
			
			document.getElementById("5_sub_ref_no_auth").disabled=true;
			document.getElementById("5_card_no").disabled=true;
			if(document.getElementById('WS_NAME').value=='PBO' && parent.document.getElementById("wdesk:IntegrationStatus").value=='false')
			{
				document.getElementById("5_auth_code").disabled=true;
			}
			else if(document.getElementById('WS_NAME').value=='PBO' && parent.document.getElementById("wdesk:IntegrationStatus").value!='false')
			{
				document.getElementById("5_auth_code").disabled=false;
			}
			else	
				document.getElementById("5_auth_code").disabled=true;
			
			document.getElementById("5_status").disabled=true;
			document.getElementById("5_sc_amount").disabled=true;
			document.getElementById("5_tran_req_uid").disabled=true;
			document.getElementById("5_Approval_cd").disabled=true;
			document.getElementById("5_remarks_action").disabled=false;
			document.getElementById("AUTHORIZATION DETAILS_Modify").disabled=false;
		
		}
		else
		{
		
			document.getElementById("5_sub_ref_no_auth").disabled=true;
			document.getElementById("5_card_no").disabled=true;
			document.getElementById("5_auth_code").disabled=true;
			document.getElementById("5_status").disabled=true;
			document.getElementById("5_sc_amount").disabled=true;
			document.getElementById("5_tran_req_uid").disabled=true;
			document.getElementById("5_Approval_cd").disabled=true;			
			
		}
		if(document.getElementById('WS_NAME').value!='PBO' && document.getElementById('WS_NAME').value!='Q1' && document.getElementById('WS_NAME').value!='Q2' && document.getElementById('WS_NAME').value!='Q6') // condition && document.getElementById('WS_NAME').value!='Q6' added for Checker queue as part of Outbound CR_24052017
		{
			if(document.getElementById("5_caps_status").value=='FAILED')
				document.getElementById("5_caps_status").value='ERROR IN CAPS';
			else if(document.getElementById("5_caps_status").value=='REJECTED' && document.getElementById("5_req_upld_status").value=='FAILURE')
					document.getElementById("5_caps_status").value='ERROR IN ONLINE';	
				document.getElementById("5_caps_status").disabled=true;
			document.getElementById("5_caps_status").disabled=true;
		}
		if(document.getElementById('WS_NAME').value!='PBO')
		{
			
			var myradio = document.getElementsByName('5_manual_blocking_action');
			veriDetailChecked = false;
			for(var x = 0; x < myradio.length; x++)
			{	
				myradio[x].disabled = true;
			}
			
			document.getElementById("5_remarks_action").disabled=true;
		}
		else
		{
			if(frameName=='CARD DETAILS')
				window.document.getElementById("5_sc_required").focus();
		}
	}
}
function customValidationOnSave(columnList,frameName,CategoryID,SubCategoryID)
{
	//In this function Write Custom Validation and code	on change of grid data.
	
	var WSNAME = document.getElementById('WS_NAME').value;
	var integrationStatus=parent.document.getElementById("wdesk:IntegrationStatus").value;
	
	if(CategoryID=='1' && SubCategoryID=='3')
	{
	
		var frameName = "Card Blocking Details";
	
		var myradio = document.getElementsByName('3_verification_details');
		var x = 0;
		var veriDetailChecked = false;
		var veriDetailCheckedValue = '';
		for(x = 0; x < myradio.length; x++){
			if(myradio[x].checked){
			veriDetailChecked=true;
			veriDetailCheckedValue=myradio[x].value;
			}
		}
		
		var myradio1 = document.getElementsByName('3_manual_blocking_action');
		var y = 0;
		var ManualBlockingActionChecked = false;
		var ManualBlockingActionValue = '';
		for(y = 0; y < myradio1.length; y++)
		{
			if(myradio1[y].checked)
			{
				ManualBlockingActionChecked=true;
				ManualBlockingActionValue=myradio1[y].value;
			}
		}
			
	
		if(document.getElementById('3_block_card').checked==true)
		{
		
				if(document.getElementById('3_type_of_block').value=='--Select--')
				{
					alert('Please select Type of Block');
					document.getElementById('3_type_of_block').focus();
					return false;
				}
				else if (document.getElementById('3_type_of_block').value=='Permanent')
				{
					
					
					if(veriDetailCheckedValue=='Non - Customer')
					{
						alert("Non-Customer is not allowed to block the card permanently.\nKindly select 'Temporary' Type of Block.");
						window.document.getElementById("3_type_of_block").focus();
						return false;
					}
					if(!veriDetailChecked)
					{
						alert("Please select Verification details first");
						return false;
					}
					else
					{					
						if(veriDetailCheckedValue=='Non - Customer')
						{
							document.getElementById('3_replacement_required').value='';
							document.getElementById('3_replacement_required').disabled=true;
						}
						else
						{
							document.getElementById('3_replacement_required').disabled=false;
						}
						
						if(document.getElementById('3_reason_for_block').value=='--Select--')
						{
							alert('Please select Reason for Block');
							document.getElementById('3_reason_for_block').focus();
							return false;
						}
						else if(((document.getElementById("3_reason_for_block").value=='Lost') 
							||(document.getElementById("3_reason_for_block").value=='Stolen')
							||document.getElementById("3_reason_for_block").value=='Captured at Rak bank ATM'
							||document.getElementById("3_reason_for_block").value=='Captured in non-Rak bank ATM'
							||(document.getElementById("3_reason_for_block").value=='Misuse')
							))			
						{
							if(document.getElementById("3_date_and_time").value=='')
							{
								alert('Please select Date and Time');
								document.getElementById('3_date_and_time').focus();
								return false;
							}
							else
							{
								var valDate =  ValidateDate();
								if(!valDate)
								return valDate;
							}
						}
						
							
						
						
						if(document.getElementById("3_reason_for_block").value=='Captured at Rak bank ATM'||document.getElementById("3_reason_for_block").value=='Captured in non-Rak bank ATM') {
							if(document.getElementById("3_ATM_Loc").value=='')
							{
								alert('Please enter ATM Location');
								document.getElementById('3_ATM_Loc').focus();
								return false;
							}								
							if(document.getElementById("3_branch_collect").value=='--Select--')
							{
								alert('Please select Branch for Collection');
								document.getElementById('3_branch_collect').focus();
								return false;
							}
					}
						
					}
				
				}else 
				{
					if(document.getElementById('3_reason_for_block').value=='--Select--'){
						alert('Please select Reason for Block');
						document.getElementById('3_reason_for_block').focus();
						return false;
					}else if(((document.getElementById("3_reason_for_block").value=='Lost') 
							||(document.getElementById("3_reason_for_block").value=='Stolen')
							||document.getElementById("3_reason_for_block").value=='Captured at Rak bank ATM'
							||document.getElementById("3_reason_for_block").value=='Captured in non-Rak bank ATM'
							||(document.getElementById("3_reason_for_block").value=='Misuse')
						))			
					{
						if(document.getElementById("3_date_and_time").value==''){
							alert('Please select Date and Time');
							document.getElementById('3_date_and_time').focus();
							return false;
						}else{
								var valDate =  ValidateDate();
								if(!valDate)
								return valDate;
						}
					}
					
					if(document.getElementById("3_reason_for_block").value=='Captured at Rak bank ATM'||document.getElementById("3_reason_for_block").value=='Captured in non-Rak bank ATM') {
						
						if(document.getElementById("3_ATM_Loc").value==''){
							alert('Please enter ATM Location');
							document.getElementById('3_ATM_Loc').focus();
							return false;
						}						
						if(document.getElementById("3_branch_collect").value=='--Select--'){
							alert('Please select Branch for Collection');
							document.getElementById('3_branch_collect').focus();
							return false;
						}
					}
				}
				
			
				
				if(ManualBlockingActionChecked && ManualBlockingActionValue=='Manual Blocking Not Done' && (document.getElementById("3_remarks_action").value).replace(/^\s+|\s+$/gm,'') == ''){
					alert("Please enter Remarks for Manual Blocking Not Done");
					document.getElementById('3_remarks_action').focus();
					return false;
				}
		}
		
		if((document.getElementById(SubCategoryID+'_sub_ref_no').value).replace(/^\s+|\s+$/gm,'')=='' && document.getElementById("3_block_card").checked)
		{
			
			generateSubRefNoOnSave(frameName,SubCategoryID);
		}
		
	} 
	else if(CategoryID=='1' && SubCategoryID=='2')
	{
		if(frameName=='CARD DETAILS')
		{
			
			if(WSNAME!='PBO')
				return true;
				
			if(document.getElementById('2_bt_required').checked==true && document.getElementById('2_card_eligibility').value==''){
				alert("Please click Check Card Eligibility Button");
				return false;	
			}else 
			{
				var selGridWIData = document.getElementById("CARD DETAILS_"+SubCategoryID+'_gridbundleJSON_WIDATA').value
				var obj = JSON.parse(selGridWIData);
				
				var valCardEligiblity= obj['card_eligibility'];
				var arrValCardEligiblity = valCardEligiblity.split("@");
				var valueRAKCardNo = obj['rak_card_no'];
				var ArrValueRAKCardNo = valueRAKCardNo.split("@");
				var selbox = document.getElementById("2_rakbank_eligible_card_no");
				selbox.options.length = 1;
				for(var i = 0; i< ArrValueRAKCardNo.length; i++)
				{
					if(ArrValueRAKCardNo[i]==document.getElementById("2_rak_card_no").value)
					{
						if(document.getElementById('2_card_eligibility').value=='Yes'){
							selbox.options[selbox.options.length] = new
							Option(document.getElementById("2_rak_card_no").value,document.getElementById("2_rak_card_no").value);
						}
					}else{
						if(arrValCardEligiblity[i]=='Yes'){	
							selbox.options[selbox.options.length] = new
							Option(ArrValueRAKCardNo[i],ArrValueRAKCardNo[i]);
						}	
					}
				}					
			}
			
		}
		
		if(frameName=='BALANCE TRANSFER DETAILS')
		{
			if(WSNAME!='PBO')
				return true;
			if(document.getElementById("2_rakbank_eligible_card_no").value=='' || document.getElementById("2_rakbank_eligible_card_no").value=='--Select--')
			{
				alert("Please select Rakbank Eligible Card No.");
				document.getElementById('2_rakbank_eligible_card_no').focus();
				return false;
			}
			if(document.getElementById('2_sub_ref_no').value=='' || document.getElementById('2_sub_ref_no').value==' ')
			{
				alert("Please enter Sub Ref No. field");
				document.getElementById('2_sub_ref_no').focus();
				return false;	
			}
			if(document.getElementById('2_bt_amt_req').value=='' || document.getElementById('2_bt_amt_req').value==' ')
			{
				alert("Please enter BT Amt Requested field");
				document.getElementById('2_bt_amt_req').focus();
				return false;	
			}
			/*if(document.getElementById('2_bt_amt_req').value<=1000)
			{
				alert("BT cannot be availed if the requested amount is less than or equal to AED 1000");
				document.getElementById('2_bt_amt_req').focus();
				return false;	
			}*/
			if(document.getElementById('2_other_bank_card_type').value=='' || document.getElementById('2_other_bank_card_type').value==' ')
			{
				alert("Please enter Other Bank Card Type field");
				document.getElementById('2_other_bank_card_type').focus();
				return false;	
			}
			if(document.getElementById('2_name_on_card').value=='' || document.getElementById('2_name_on_card').value==' ')
			{
				alert("Please enter Name on Card field");
				document.getElementById('2_name_on_card').focus();
				return false;	
			}
			if(document.getElementById('2_other_bank_card_no').value=='' || document.getElementById('2_other_bank_card_no').value==' ')
			{
				alert("Please enter Other Bank Card no. field");
				document.getElementById('2_other_bank_card_no').focus();
				return false;	
			}else if(!mod10(document.getElementById('2_other_bank_card_no').value))
			{
					alert("Invalid Other Bank Card No.");
					document.getElementById('2_other_bank_card_no').value="";
					document.getElementById('2_other_bank_card_no').focus();
					return false;
				
			}
			if(document.getElementById('2_type_of_bt').value=='' || document.getElementById('2_type_of_bt').value==' ')
			{
				alert("Please enter Type of BT field");
				document.getElementById('2_type_of_bt').focus();
				return false;	
			}
			if(document.getElementById('2_other_bank_name').value=='' || document.getElementById('2_other_bank_name').value==' ')
			{
				alert("Please enter Other Bank Name field");
				document.getElementById('2_other_bank_name').focus();
				return false;	
			}
			
			if((document.getElementById('2_branch_name').value=='' || document.getElementById('2_branch_name').value==' ') && (!document.getElementById('2_rakbank_eligible_card_no').disabled))
			{
				alert("Please select Branch Name");
				document.getElementById('2_branch_name').focus();
				return false;	
			}
			if(document.getElementById('2_payment_by').value=='' || document.getElementById('2_payment_by').value==' ' || document.getElementById('2_payment_by').value=='--Select--')
			{
				alert("Please select Payment By");
				document.getElementById('2_payment_by').focus();
				return false;	
			}
			if(document.getElementById('2_delivery_channel').value=='' || document.getElementById('2_delivery_channel').value==' ')
			{
				alert("Please select Delivery Channel");
				document.getElementById('2_delivery_channel').focus();
				return false;	
			}
			if(document.getElementById('2_eligibility').value=='' || document.getElementById('2_eligibility').value==' ')
			{
				alert("Please Click 'Check BT Eligibilty' button");
				return false;	
			}
			
			var selGridWIData = document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value
			var obj = JSON.parse(selGridWIData);
			var valueRakBankECard = obj['rakbank_eligible_card_no'];
			var arrValueRakBankECard = valueRakBankECard.split("@");
			
			var valOtherBankCardNo = obj['other_bank_card_no'];
			var arrValOtherBankCardNo = valOtherBankCardNo.split("@");			
			var rakCardAndOthCardGrid = '';
			var rakCardAndOthCardForm = document.getElementById(SubCategoryID+'_rakbank_eligible_card_no').value+"-"+document.getElementById(SubCategoryID+'_other_bank_card_no').value;
			
			for(var i=0;i<arrValueRakBankECard.length;i++)
			{
				rakCardAndOthCardGrid=arrValueRakBankECard[i]+"-"+arrValOtherBankCardNo[i];
				if(rakCardAndOthCardForm==rakCardAndOthCardGrid)
				{
					//
				}
			}	

			var strJsonCardDetail = document.getElementById('CARD DETAILS_2_gridbundleJSON_WIDATA').value;
			var objCardDetail = JSON.parse(strJsonCardDetail);
			var cardNo = objCardDetail["rak_card_no"];
			var arrCardNo = cardNo.split("@");
			var eligibleAmt = objCardDetail["eligible_amount"];
			var arrEligibleAmt = eligibleAmt.split("@");
			var bTRequired = objCardDetail["bt_required"];
			var arrBTRequired = bTRequired.split("@");
				
			
			var strJsonBT = document.getElementById('BALANCE TRANSFER DETAILS_2_gridbundleJSON_WIDATA').value;		
			var objBT = JSON.parse(strJsonBT);
			var eligibleCardNo = objBT["rakbank_eligible_card_no"];
			var arrEligibleCardNo = eligibleCardNo.split("@");
			var btAmtReq = objBT["bt_amt_req"];
			var arrBTAmtReq = btAmtReq.split("@");
			
			var btSubRefNo = objBT["sub_ref_no"];
			var arrBTSubRefNo = btSubRefNo.split("@");
			
			var otherBankCardNo = objBT["other_bank_card_no"];
			var arrotherBankCardNo = otherBankCardNo.split("@");
			var amtToBeModified=0;
			
			var totalBTAmtReq = 0;
			var totalReqAmount=0;
			
			var modifyGridBundleId = document.getElementById(frameName+'_modifyGridBundle').value;
			var tempElementName = frameName+"_"+SubCategoryID+"_gridbundle_";
			var gridRowNum = modifyGridBundleId.substring(tempElementName.length);
			
			for(var i=0;i<arrCardNo.length;i++)
			{
				
				if(arrBTRequired[i]=='Yes')
				{
				
					for(var k=0;k<arrEligibleCardNo.length;k++)
					{
						/*if(document.getElementById('2_other_bank_card_no').value==arrotherBankCardNo[k] && document.getElementById('2_rakbank_eligible_card_no').value!=arrEligibleCardNo[k])
						{
							alert("This card is already linked to other RAK eligible card. Please enter different Other Card No.");
							return false;
						}*/
						//code to check same card combination already added in BT details grid
						for(var c=0; c<arrotherBankCardNo.length;c++)
						{
							// if(document.getElementById('2_other_bank_card_no').value==arrotherBankCardNo[k] && document.getElementById('2_rakbank_eligible_card_no').value==arrEligibleCardNo[k] && (c==k) && (c!=(document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value)-1 && (document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value)!=0))
							// {
								// alert("This other bank card is already linked to other same RAK eligible card. Please modify the existing one.");
							// return false;
							// }
							
							if(document.getElementById('2_other_bank_card_no').value==arrotherBankCardNo[k] && document.getElementById('2_rakbank_eligible_card_no').value==arrEligibleCardNo[k] && (c==k) && (c!=gridRowNum && (document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value)!=0))
							{
								alert("This other bank card is already linked to other same RAK eligible card. Please modify the existing one.");
							return false;
							}
						}
					}
					/*
					if(document.getElementById('2_rakbank_eligible_card_no').value==arrCardNo[i])
					{
						
						for(var j=0;j<arrEligibleCardNo.length;j++)
						{
							
							if(document.getElementById('2_sub_ref_no').value==arrBTSubRefNo[j])
							{
								amtToBeModified=parseFloat(arrBTAmtReq[j].split(',').join(''));
							}
							
							if(document.getElementById('2_rakbank_eligible_card_no').value==arrEligibleCardNo[j])
							{
								totalReqAmount+=parseFloat(arrBTAmtReq[j].split(',').join(''));
							}
						
						}
						
						var eligAmmt =parseFloat(arrEligibleAmt[i].split(',').join(''));
						var reqAmmt =parseFloat(document.getElementById('2_bt_amt_req').value.split(',').join(''));
						totalReqAmount+=reqAmmt-amtToBeModified;
						
						if(eligAmmt<totalReqAmount)
						{
							alert("Sum of BT requested amount should not exceed the BT eligible amount for card no. " + arrCardNo[i]+".");
							document.getElementById('2_bt_amt_req').focus();
							return false;
						}
					}*/
				}
			}
			
		}
		if(frameName=='AUTHORIZATION DETAILS')
		{
			var myradio1 = document.getElementsByName('2_manual_blocking_action');
			var y = 0;
			var ManualBlockingActionChecked = false;
			var ManualBlockingActionValue = '';
			for(y = 0; y < myradio1.length; y++)
			{
				if(myradio1[y].checked)
				{
					ManualBlockingActionChecked=true;
					ManualBlockingActionValue=myradio1[y].value;
				}
			}
				
			if(ManualBlockingActionChecked && ManualBlockingActionValue=='Manual Blocking Not Done' && (document.getElementById("2_remarks_action").value).replace(/^\s+|\s+$/gm,'') == '')
			{
				alert("Please enter Remarks for Manual Blocking Not Done");
				document.getElementById('2_remarks_action').focus();
				return false;
			}
		
			if((document.getElementById('2_auth_code').value).replace(/^\s+|\s+$/gm,'') == '' && integrationStatus=='false' && ManualBlockingActionChecked && ManualBlockingActionValue=='Manual Blocking Done')
			{
				alert("Please enter Authorization code.");
				document.getElementById('2_auth_code').focus();
				return false;	
			}
			
			/*if((document.getElementById("2_auth_code").value).replace(/^\s+|\s+$/gm,'') != ''){
				if((document.getElementById("2_auth_code").value).length!=6)
				{
					alert("Length of Authorization Code should be exactly 6 digits.");
					document.getElementById("2_auth_code").focus();
					return false;
				}
			}*/
	
			/*if(WSNAME=="Q1")
			{
				if(document.getElementById("2_cancellation_remarks").value=='' || document.getElementById("2_cancellation_remarks").value==' ')
				{
					alert("Please enter Cancellation Remarks");
					document.getElementById('2_cancellation_remarks').focus();
					return false;
				}
				
			}	*/		
		}
		return true;
	} 
	else if(CategoryID=='1' && SubCategoryID=='4')
	{
		if(frameName=='CARD DETAILS')
		{
			if(WSNAME!='PBO')
				return true;
				
			if(document.getElementById('4_ccc_required').checked==true && (document.getElementById('4_card_eligibility').value=='' || document.getElementById('4_card_eligibility').value==' ')){
				alert("Please click Check Card Eligibility Button");
				return false;	
			}else 
			{
				var selGridWIData = document.getElementById("CARD DETAILS_"+SubCategoryID+'_gridbundleJSON_WIDATA').value
				var obj = JSON.parse(selGridWIData);
				
				var valCardEligiblity= obj['card_eligibility'];
				var arrValCardEligiblity = valCardEligiblity.split("@");
				var valueRAKCardNo = obj['card_no'];
				var ArrValueRAKCardNo = valueRAKCardNo.split("@");
				var selbox = document.getElementById("4_rakbank_eligible_card_no");
					selbox.options.length = 1;
				for(var i = 0; i< ArrValueRAKCardNo.length; i++)
				{
					if(ArrValueRAKCardNo[i]==document.getElementById("4_card_no").value)
					{
						if(document.getElementById('4_card_eligibility').value=='Yes'){
							selbox.options[selbox.options.length] = new
							Option(document.getElementById("4_card_no").value,document.getElementById("4_card_no").value);
						}
					}else{
						if(arrValCardEligiblity[i]=='Yes'){	
							selbox.options[selbox.options.length] = new
							Option(ArrValueRAKCardNo[i],ArrValueRAKCardNo[i]);
						}	
					}
				}					
			}
			
		
		} 
		else if(frameName=='CREDIT CARD CHEQUE DETAILS')
		{		
			if(WSNAME!='PBO')
				return true;
			
			if(document.getElementById("4_rakbank_eligible_card_no").value=='' || document.getElementById("4_rakbank_eligible_card_no").value=='--Select--')
			{
				alert("Please select RAK Eligible Card Number");
				document.getElementById('4_rakbank_eligible_card_no').focus();
				return false;
			}
		
			if(document.getElementById('4_ccc_amt_req').value=='' || document.getElementById('4_ccc_amt_req').value==' ')
			{
				alert("Please enter CCC Amt Requested field");
				document.getElementById('4_ccc_amt_req').focus();
				return false;	
			}
			if(document.getElementById('4_beneficiary_name').value=='' || document.getElementById('4_beneficiary_name').value==' ')
			{
				alert("Please enter Beneficiary Name field");
				document.getElementById('4_beneficiary_name').focus();
				return false;	
			}
			if(document.getElementById("4_payment_by").value=='' || document.getElementById("4_payment_by").value=='--Select--')
			{
				alert("Please select Payment By");
				document.getElementById('4_payment_by').focus();
				return false;
			}
			if(document.getElementById('4_payment_by').value=='MCQ')
			{
			
				if(document.getElementById('4_delivery_channel').value=='' || document.getElementById('4_delivery_channel').value==' ' || document.getElementById('4_delivery_channel').value=='--Select--')
				{
					alert("Please select Delivery Channel");
					document.getElementById('4_delivery_channel').focus();
					return false;	
				}
				else if(document.getElementById('4_delivery_channel').value=='Branch')
				{
					if(document.getElementById('4_branch_name').value=='' || document.getElementById('4_branch_name').value==' ' || document.getElementById('4_branch_name').value=='--Select--')
					{
						alert("Please select Branch Name");
						document.getElementById('4_branch_name').focus();
						return false;	
					}
				}
			}
			if(document.getElementById('4_payment_by').value=='MCQ' || document.getElementById('4_payment_by').value=='FTS') // Condition added as SmartCash BT/CCC CR - Angad/Amithabh
			{
				if(document.getElementById('4_other_bank_name').value=='' || document.getElementById('4_other_bank_name').value==' ')
				{
					alert("Please enter Other Bank Name field");
					document.getElementById('4_other_bank_name').focus();
					return false;	
				}
			}
			if(document.getElementById('4_eligibility').value=='' || document.getElementById('4_eligibility').value==' ')
			{
				alert("Please click 'Check CCC Eligibility' button");
				return false;	
			}
			
			//code added to check the add/modify of same cards in the grid
			var selGridWIData = document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value
			var obj = JSON.parse(selGridWIData);
			var valueRakBankECardGird = obj['rakbank_eligible_card_no'];
			var arrValueRakBankECardGrid = valueRakBankECardGird.split("@");
						
			var valueRakBankECardGirdForm = document.getElementById(SubCategoryID+'_rakbank_eligible_card_no').value;
			var modifyGridBundleId = document.getElementById(frameName+'_modifyGridBundle').value;
			var tempElementName = frameName+"_"+SubCategoryID+"_gridbundle_";
			var gridRowNum = modifyGridBundleId.substring(tempElementName.length);
			for(var i=0;i<arrValueRakBankECardGrid.length;i++)
			{
				
				if(arrValueRakBankECardGrid[i]==valueRakBankECardGirdForm && (i!=gridRowNum && (document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value)!=0))
				{
					alert("Credit Card Cheque request for selected 'Rakbank Eligible Card No.' has already been added.");
					return false;
				}
			}
			/*
			var strJsonCardDetail = document.getElementById('CARD DETAILS_4_gridbundleJSON_WIDATA').value;
			var objCardDetail = JSON.parse(strJsonCardDetail);
			var cardNo = objCardDetail["card_no"];
			var arrCardNo = cardNo.split("@");
			var eligibleAmt = objCardDetail["eligible_amount"];
			var arrEligibleAmt = eligibleAmt.split("@");
			var CCCRequired = objCardDetail["ccc_required"];
			var arrCCCRequired = CCCRequired.split("@");
			
			
			var strJsonCCC = document.getElementById('CREDIT CARD CHEQUE DETAILS_4_gridbundleJSON_WIDATA').value;	
			var objCCC = JSON.parse(strJsonCCC);
			var eligibleCardNo = objCCC["rakbank_eligible_card_no"];
			var arrEligibleCardNo = eligibleCardNo.split("@");
			var CCCAmtReq = objCCC["ccc_amt_req"];
			var arrCCCAmtReq = CCCAmtReq.split("@");
			var CCCSubRefNo = objCCC["sub_ref_no"];
			var arrCCCSubRefNo = CCCSubRefNo.split("@");
						
			var totalCCCAmtReq = 0;
			var totalReqAmount=0;			
			for(var i=0;i<arrCardNo.length;i++)
			{
				
				if(arrCCCRequired[i]=='Yes')
				{
						
					if(document.getElementById('4_rakbank_eligible_card_no').value==arrCardNo[i])
					{
						
						for(var j=0;j<arrEligibleCardNo.length;j++)
						{
							if(document.getElementById('4_sub_ref_no').value==arrCCCSubRefNo[j])
							{
								amtToBeModified=parseFloat(arrCCCAmtReq[j].split(',').join(''));
							}
							
							if(document.getElementById('4_rakbank_eligible_card_no').value==arrEligibleCardNo[j])
							{
								totalReqAmount+=parseFloat(arrCCCAmtReq[j].split(',').join(''));
							}
						
						}
						
						var eligAmmt =parseFloat(arrEligibleAmt[i].split(',').join(''));
						var reqAmmt =parseFloat(document.getElementById('4_ccc_amt_req').value.split(',').join(''));
						totalReqAmount+=reqAmmt-amtToBeModified;
						
						if(eligAmmt<totalReqAmount)
						{
							alert("Sum of CCC requested amount should not exceed the CCC eligible amount for card no. " + arrCardNo[i]+".");
							document.getElementById('4_ccc_amt_req').focus();
							return false;
						}
					}
				}
			}*/
		}
		
		
		
		if(frameName=='AUTHORIZATION DETAILS')
		{
		
			var myradio1 = document.getElementsByName('4_manual_blocking_action');
			var y = 0;
			var ManualBlockingActionChecked = false;
			var ManualBlockingActionValue = '';
			for(y = 0; y < myradio1.length; y++)
			{
				if(myradio1[y].checked)
				{
					ManualBlockingActionChecked=true;
					ManualBlockingActionValue=myradio1[y].value;
				}
			}
				
			if(ManualBlockingActionChecked && ManualBlockingActionValue=='Manual Blocking Not Done' && (document.getElementById("4_remarks_action").value).replace(/^\s+|\s+$/gm,'') == '')
			{
				alert("Please enter Remarks for Manual Blocking Not Done");
				document.getElementById('4_remarks_action').focus();
				return false;
			}
			
			if((document.getElementById('4_auth_code').value).replace(/^\s+|\s+$/gm,'') == '' && integrationStatus=='false' && ManualBlockingActionChecked && ManualBlockingActionValue=='Manual Blocking Done')
			{
				alert("Please enter Authorization code.");
				document.getElementById('4_auth_code').focus();
				return false;	
			}
			
			/*if((document.getElementById("4_auth_code").value).length!=6)
			{
				alert("Length of Authorization Code should be exactly 6 digits.");
				document.getElementById("4_auth_code").focus();
				return false;
			}*/
			/*if(WSNAME=="Q1")
			{
				if(document.getElementById("4_cancellation_remarks").value=='' || document.getElementById("4_cancellation_remarks").value==' ')
				{
					alert("Please enter Cancellation Remarks");
					document.getElementById('4_cancellation_remarks').focus();
					return false;
				}
				if(document.getElementById("2_cancel_status").value!='Cancelled' && document.getElementById("2_manual_unblock").checked==false)
				{
					alert("Please check Manual Unblocking")
					return false;
				}
			}*/	
		}
		return true;
	}
	
	else if(CategoryID=='1' && SubCategoryID=='5')
	{
		if(frameName=='CARD DETAILS')
		{
			if(WSNAME!='PBO')
				return true;
				
			if(document.getElementById('5_sc_required').checked==true && (document.getElementById('5_card_eligibility').value=='' || document.getElementById('5_card_eligibility').value==' ')){
				alert("Please click Check Card Eligibility Button");
				return false;	
			}else 
			{
				var selGridWIData = document.getElementById("CARD DETAILS_"+SubCategoryID+'_gridbundleJSON_WIDATA').value
				var obj = JSON.parse(selGridWIData);
				
				var valCardEligiblity= obj['card_eligibility'];
				var arrValCardEligiblity = valCardEligiblity.split("@");
				var valueRAKCardNo = obj['card_no'];
				var ArrValueRAKCardNo = valueRAKCardNo.split("@");
				var selbox = document.getElementById("5_rakbank_eligible_card_no");
					selbox.options.length = 1;
				for(var i = 0; i< ArrValueRAKCardNo.length; i++)
				{
					if(ArrValueRAKCardNo[i]==document.getElementById("5_card_no").value)
					{
						if(document.getElementById('5_card_eligibility').value=='Yes'){
							selbox.options[selbox.options.length] = new
							Option(document.getElementById("5_card_no").value,document.getElementById("5_card_no").value);
						}
					}else{
						if(arrValCardEligiblity[i]=='Yes'){	
							selbox.options[selbox.options.length] = new
							Option(ArrValueRAKCardNo[i],ArrValueRAKCardNo[i]);
						}	
					}
				}					
			}
			
		
		} 
		else if(frameName=='SMART CASH DETAILS')
		{		
			if(WSNAME!='PBO')
				return true;
			
			if(document.getElementById("5_rakbank_eligible_card_no").value=='' || document.getElementById("5_rakbank_eligible_card_no").value=='--Select--')
			{
				alert("Please select RAK Eligible Card Number");
				document.getElementById('5_rakbank_eligible_card_no').focus();
				return false;
			}
		
			if(document.getElementById('5_sc_amt_req').value=='' || document.getElementById('5_sc_amt_req').value==' ')
			{
				alert("Please enter SC Amt Requested field");
				document.getElementById('5_sc_amt_req').focus();
				return false;	
			}
			if(document.getElementById('5_beneficiary_name').value=='' || document.getElementById('5_beneficiary_name').value==' ')
			{
				alert("Please enter Beneficiary Name field");
				document.getElementById('5_beneficiary_name').focus();
				return false;	
			}
			if(document.getElementById('5_type_of_smc').value=='' || document.getElementById('5_type_of_smc').value==' ')
			{
				alert("Please enter Type of SMC field");
				document.getElementById('5_type_of_smc').focus();
				return false;	
			}
			if(document.getElementById("5_payment_by").value=='' || document.getElementById("5_payment_by").value=='--Select--')
			{
				alert("Please select Payment By");
				document.getElementById('5_payment_by').focus();
				return false;
			}
			
			if(document.getElementById('5_payment_by').value=='MCQ')
			{
			
				if(document.getElementById('5_delivery_channel').value=='' || document.getElementById('5_delivery_channel').value==' ' || document.getElementById('5_delivery_channel').value=='--Select--')
				{
					alert("Please select Delivery Channel");
					document.getElementById('5_delivery_channel').focus();
					return false;	
				}
				else if(document.getElementById('5_delivery_channel').value=='Branch')
				{
					if(document.getElementById('5_branch_name').value=='' || document.getElementById('5_branch_name').value==' ' || document.getElementById('5_branch_name').value=='--Select--')
					{
						alert("Please select Branch Name");
						document.getElementById('5_branch_name').focus();
						return false;	
					}
				}
			}
			if(document.getElementById('5_payment_by').value=='MCQ' || document.getElementById('5_payment_by').value=='FTS')
			{
				if(document.getElementById('5_other_bank_name').value=='' || document.getElementById('5_other_bank_name').value==' ')
				{
					alert("Please enter Other Bank Name field");
					document.getElementById('5_other_bank_name').focus();
					return false;	
				}
			}
			if(document.getElementById('5_eligibility').value=='' || document.getElementById('5_eligibility').value==' ')
			{
				alert("Please click 'Check SMC Eligibility' button");
				return false;	
			}
			
			//code added to check the add/modify of same cards in the grid
			var selGridWIData = document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value
			var obj = JSON.parse(selGridWIData);
			var valueRakBankECardGird = obj['rakbank_eligible_card_no'];
			var arrValueRakBankECardGrid = valueRakBankECardGird.split("@");
						
			var valueRakBankECardGirdForm = document.getElementById(SubCategoryID+'_rakbank_eligible_card_no').value;
			var modifyGridBundleId = document.getElementById(frameName+'_modifyGridBundle').value;
			var tempElementName = frameName+"_"+SubCategoryID+"_gridbundle_";
			var gridRowNum = modifyGridBundleId.substring(tempElementName.length);
			for(var i=0;i<arrValueRakBankECardGrid.length;i++)
			{
				
				if(arrValueRakBankECardGrid[i]==valueRakBankECardGirdForm && (i!=gridRowNum && (document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value)!=0))
				{
					alert("Smart Cash request for selected 'Rakbank Eligible Card No.' has already been added.");
					return false;
				}
			}
			/*
			var strJsonCardDetail = document.getElementById('CARD DETAILS_5_gridbundleJSON_WIDATA').value;
			var objCardDetail = JSON.parse(strJsonCardDetail);
			var cardNo = objCardDetail["card_no"];
			var arrCardNo = cardNo.split("@");
			var eligibleAmt = objCardDetail["eligible_amount"];
			var arrEligibleAmt = eligibleAmt.split("@");
			var SCRequired = objCardDetail["sc_required"];
			var arrSCRequired = SCRequired.split("@");
			
			

			var objSC = JSON.parse(strJsonSC);
			
			var arrEligibleCardNo = eligibleCardNo.split("@");
			var SCAmtReq = objSC["sc_amt_req"];
			var arrSCAmtReq = SCAmtReq.split("@");
			var SCSubRefNo = objSC["sub_ref_no"];
			var arrSCSubRefNo = SCSubRefNo.split("@");
						
			var totalSCAmtReq = 0;
			var totalReqAmount=0;			
			for(var i=0;i<arrCardNo.length;i++)
			{
				
				if(arrSCRequired[i]=='Yes')
				{
						
					if(document.getElementById('5_rakbank_eligible_card_no').value==arrCardNo[i])
					{
						
						for(var j=0;j<arrEligibleCardNo.length;j++)
						{
							if(document.getElementById('5_sub_ref_no').value==arrSCSubRefNo[j])
							{
								amtToBeModified=parseFloat(arrSCAmtReq[j].split(',').join(''));
							}
							
							if(document.getElementById('5_rakbank_eligible_card_no').value==arrEligibleCardNo[j])
							{
								totalReqAmount+=parseFloat(arrSCAmtReq[j].split(',').join(''));
							}
						
						}
						
						var eligAmmt =parseFloat(arrEligibleAmt[i].split(',').join(''));
						var reqAmmt =parseFloat(document.getElementById('5_sc_amt_req').value.split(',').join(''));
						totalReqAmount+=reqAmmt-amtToBeModified;
						
						if(eligAmmt<totalReqAmount)
						{
							alert("Sum of SC requested amount should not exceed the SC eligible amount for card no. " + arrCardNo[i]+".");
							document.getElementById('5_sc_amt_req').focus();
							return false;
						}
					}
				}
			}*/
		}
		
		
		
		if(frameName=='AUTHORIZATION DETAILS')
		{
		
			var myradio1 = document.getElementsByName('5_manual_blocking_action');
			var y = 0;
			var ManualBlockingActionChecked = false;
			var ManualBlockingActionValue = '';
			for(y = 0; y < myradio1.length; y++)
			{
				if(myradio1[y].checked)
				{
					ManualBlockingActionChecked=true;
					ManualBlockingActionValue=myradio1[y].value;
				}
			}
				
			if(ManualBlockingActionChecked && ManualBlockingActionValue=='Manual Blocking Not Done' && (document.getElementById("5_remarks_action").value).replace(/^\s+|\s+$/gm,'') == '')
			{
				alert("Please enter Remarks for Manual Blocking Not Done");
				document.getElementById('5_remarks_action').focus();
				return false;
			}
			
			if((document.getElementById('5_auth_code').value).replace(/^\s+|\s+$/gm,'') == '' && integrationStatus=='false' && ManualBlockingActionChecked && ManualBlockingActionValue=='Manual Blocking Done')
			{
				alert("Please enter Authorization code.");
				document.getElementById('5_auth_code').focus();
				return false;	
			}
			
			/*if((document.getElementById("5_auth_code").value).length!=6)
			{
				alert("Length of Authorization Code should be exactly 6 digits.");
				document.getElementById("5_auth_code").focus();
				return false;
			}*/
			/*if(WSNAME=="Q1")
			{
				if(document.getElementById("5_cancellation_remarks").value=='' || document.getElementById("5_cancellation_remarks").value==' ')
				{
					alert("Please enter Cancellation Remarks");
					document.getElementById('5_cancellation_remarks').focus();
					return false;
				}
				if(document.getElementById("2_cancel_status").value!='Cancelled' && document.getElementById("2_manual_unblock").checked==false)
				{
					alert("Please check Manual Unblocking")
					return false;
				}
			}*/	
		}
		return true;
	}
	
	return true;
}

function customValidationOnAdd(columnList,frameName,CategoryID,SubCategoryID)
{
	//In this function Write Custom Validation and code	on Add of grid row.
	
	if(CategoryID=='1' && SubCategoryID=='2')
	{
		if(frameName=='BALANCE TRANSFER DETAILS')
		{	
			if(document.getElementById("2_rakbank_eligible_card_no").value=='' || document.getElementById("2_rakbank_eligible_card_no").value=='--Select--')
			{
				alert("Please select RAK Eligible Card Number");
				document.getElementById('2_rakbank_eligible_card_no').focus();
				return false;
			}
			
			if(document.getElementById('2_bt_amt_req').value=='' || document.getElementById('2_bt_amt_req').value==' ')
			{
				alert("Please enter BT Amt Requested field");
				document.getElementById('2_bt_amt_req').focus();
				return false;	
			}
			/*if(document.getElementById('2_bt_amt_req').value<=1000)
			{
				alert("BT cannot be availed if the requested amount is less than or equal to AED 1000");
				document.getElementById('2_bt_amt_req').focus();
				return false;	
			}*/
			if(document.getElementById('2_other_bank_card_type').value=='' || document.getElementById('2_other_bank_card_type').value==' ' || document.getElementById('2_other_bank_card_type').value=='--Select--')
			{
				alert("Please enter Other Bank Card Type field");
				document.getElementById('2_other_bank_card_type').focus();
				return false;	
			}
			if(document.getElementById('2_name_on_card').value=='' || document.getElementById('2_name_on_card').value==' ')
			{
				alert("Please enter Name on Card field");
				document.getElementById('2_name_on_card').focus();
				return false;	
			}
			if(document.getElementById('2_other_bank_card_no').value=='' || document.getElementById('2_other_bank_card_no').value==' ')
			{
				alert("Please enter Other Bank Card no. field");
				document.getElementById('2_other_bank_card_no').focus();
				return false;	
			}else if(!mod10(document.getElementById('2_other_bank_card_no').value))
			{
					alert("Invalid Other Bank Card No.");
					document.getElementById('2_other_bank_card_no').value="";
					document.getElementById('2_other_bank_card_no').focus();
					return false;
				
			}
			if(document.getElementById('2_type_of_bt').value=='' || document.getElementById('2_type_of_bt').value==' ' || document.getElementById('2_type_of_bt').value=='--Select--')
			{
				alert("Please enter Type of BT field");
				document.getElementById('2_type_of_bt').focus();
				return false;	
			}
			if(document.getElementById('2_other_bank_name').value=='' || document.getElementById('2_other_bank_name').value==' ' || document.getElementById('2_other_bank_name').value=='--Select--')
			{
				alert("Please enter Other Bank Name field");
				document.getElementById('2_other_bank_name').focus();
				return false;	
			}
			
			if(document.getElementById('2_payment_by').value=='' || document.getElementById('2_payment_by').value==' ' || document.getElementById('2_payment_by').value=='--Select--')
			{
				alert("Please select Payment By");
				document.getElementById('2_payment_by').focus();
				return false;	
			}
			if(document.getElementById('2_payment_by').value=='MCQ')
			{
			
				if(document.getElementById('2_delivery_channel').value=='' || document.getElementById('2_delivery_channel').value==' ' || document.getElementById('2_delivery_channel').value=='--Select--')
				{
					alert("Please select Delivery Channel");
					document.getElementById('2_delivery_channel').focus();
					return false;	
				}
				else if(document.getElementById('2_delivery_channel').value=='Branch')
				{
					if(document.getElementById('2_branch_name').value=='' || document.getElementById('2_branch_name').value==' ' || document.getElementById('2_branch_name').value=='--Select--')
					{
						alert("Please select Branch Name");
						document.getElementById('2_branch_name').focus();
						return false;	
					}
				}
			}
			
			if(document.getElementById('2_eligibility').value=='' || document.getElementById('2_eligibility').value==' ')
			{
				alert("Please Click 'Check BT Eligibilty' button");
				return false;	
			}
			if(document.getElementById('2_eligibility').value=='No' || document.getElementById('2_eligibility').value=='N')
			{
				alert("BT cannot be availed for this card.");
				return false;	
			}
			
			var selGridWIData = document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value
			var obj = JSON.parse(selGridWIData);
		
			var valueRakBankECard = obj['rakbank_eligible_card_no'];
			var arrValueRakBankECard = valueRakBankECard.split("@");
			
			var valOtherBankCardNo = obj['other_bank_card_no'];
			var arrValOtherBankCardNo = valOtherBankCardNo.split("@");			
			var rakCardAndOthCardGrid = '';
			var rakCardAndOthCardForm = document.getElementById(SubCategoryID+'_rakbank_eligible_card_no').value+"-"+document.getElementById(SubCategoryID+'_other_bank_card_no').value;
			
			for(var i=0;i<arrValueRakBankECard.length;i++)
			{
				rakCardAndOthCardGrid=arrValueRakBankECard[i]+"-"+arrValOtherBankCardNo[i];
				if(rakCardAndOthCardForm==rakCardAndOthCardGrid)
				{
					//
				}
			}
			
			var strJsonCardDetail = document.getElementById('CARD DETAILS_2_gridbundleJSON_WIDATA').value;
			var objCardDetail = JSON.parse(strJsonCardDetail);
			var cardNo = objCardDetail["rak_card_no"];
			var arrCardNo = cardNo.split("@");
			var eligibleAmt = objCardDetail["eligible_amount"];
			var arrEligibleAmt = eligibleAmt.split("@");
			var bTRequired = objCardDetail["bt_required"];
			var arrBTRequired = bTRequired.split("@");
				
			
			var strJsonBT = document.getElementById('BALANCE TRANSFER DETAILS_2_gridbundleJSON_WIDATA').value;		
			var objBT = JSON.parse(strJsonBT);
			var eligibleCardNo = objBT["rakbank_eligible_card_no"];
			var arrEligibleCardNo = eligibleCardNo.split("@");
			var btAmtReq = objBT["bt_amt_req"];
			var arrBTAmtReq = btAmtReq.split("@");
			
			var otherBankCardNo = objBT["other_bank_card_no"];
			var arrotherBankCardNo = otherBankCardNo.split("@");
			
			var totalBTAmtReq = 0;
			var totalReqAmount=0;			
			for(var i=0;i<arrCardNo.length;i++)
			{
				if(arrBTRequired[i]=='Yes')
				{
				
					for(var k=0;k<arrEligibleCardNo.length;k++)
					{
						/*if(document.getElementById('2_other_bank_card_no').value==arrotherBankCardNo[k] && document.getElementById('2_rakbank_eligible_card_no').value!=arrEligibleCardNo[k])
						{
							alert("This card is already linked to other RAK eligible card. Please enter different Other Card No.");
							return false;
						}*/
						//code to check same card combination already added in BT details grid
						for(var c=0; c<arrotherBankCardNo.length;c++)
						{
							if(document.getElementById('2_other_bank_card_no').value==arrotherBankCardNo[k] && document.getElementById('2_rakbank_eligible_card_no').value==arrEligibleCardNo[k] && (c==k))
							{
								alert("This other bank card is already linked to other same RAK eligible card. Please modify the existing one.");
							return false;
							}
						}
					}
			
					/*if(document.getElementById('2_rakbank_eligible_card_no').value==arrCardNo[i])
					{
						
						for(var j=0;j<arrEligibleCardNo.length;j++)
						{
							
							if(document.getElementById('2_rakbank_eligible_card_no').value==arrEligibleCardNo[j])
							{
								totalReqAmount+=parseFloat(arrBTAmtReq[j].split(',').join(''));
							}
						
						}
						
						var eligAmmt =parseFloat(arrEligibleAmt[i].split(',').join(''));
						var reqAmmt =parseFloat(document.getElementById('2_bt_amt_req').value.split(',').join(''));
						totalReqAmount+=reqAmmt;
						
						if(eligAmmt<totalReqAmount)
						{
							alert("Sum of BT requested amount should not exceed the BT eligible amount for card no. " + arrCardNo[i]+".");
							document.getElementById('2_bt_amt_req').focus();
							return false;
						}
					}*/
				}
			}
			
		}
		generateSubRefNo(frameName,SubCategoryID);
	} 
	else if(CategoryID=='1' && SubCategoryID=='4')
	{	
		if(frameName=='CREDIT CARD CHEQUE DETAILS')
		{	
			if(document.getElementById("4_rakbank_eligible_card_no").value=='' || document.getElementById("4_rakbank_eligible_card_no").value=='--Select--')
			{
				alert("Please select RAK Eligible Card Number");
				document.getElementById('4_rakbank_eligible_card_no').focus();
				return false;
			}
		
			if(document.getElementById('4_ccc_amt_req').value=='' || document.getElementById('4_ccc_amt_req').value==' ')
			{
				alert("Please enter CCC Amt Requested field");
				document.getElementById('4_ccc_amt_req').focus();
				return false;	
			}
			if(document.getElementById('4_beneficiary_name').value=='' || document.getElementById('4_beneficiary_name').value==' ')
			{
				alert("Please enter Beneficiary Name field");
				document.getElementById('4_beneficiary_name').focus();
				return false;	
			}
			if(document.getElementById("4_payment_by").value=='' || document.getElementById("4_payment_by").value=='--Select--')
			{
				alert("Please select Payment By");
				document.getElementById('4_payment_by').focus();
				return false;
			}
			if(document.getElementById('4_payment_by').value=='MCQ')
			{
			
				if(document.getElementById('4_delivery_channel').value=='' || document.getElementById('4_delivery_channel').value==' ' || document.getElementById('4_delivery_channel').value=='--Select--')
				{
					alert("Please select Delivery Channel");
					document.getElementById('4_delivery_channel').focus();
					return false;	
				}
				else if(document.getElementById('4_delivery_channel').value=='Branch')
				{
					if(document.getElementById('4_branch_name').value=='' || document.getElementById('4_branch_name').value==' ' || document.getElementById('4_branch_name').value=='--Select--')
					{
						alert("Please select Branch Name");
						document.getElementById('4_branch_name').focus();
						return false;	
					}
				}
			}
			if(document.getElementById('4_payment_by').value=='MCQ' || document.getElementById('4_payment_by').value=='FTS') // Condition added as SmartCash BT/CCC CR - Angad/Amithabh
			{
				if(document.getElementById('4_other_bank_name').value=='' || document.getElementById('4_other_bank_name').value==' ')
				{
					alert("Please enter Other Bank Name field");
					document.getElementById('4_other_bank_name').focus();
					return false;	
				}
			}
			if(document.getElementById('4_eligibility').value=='' || document.getElementById('4_eligibility').value==' ')
			{
				alert("Please click 'Check CCC Eligibility' button");
				return false;	
			}
			if(document.getElementById('4_eligibility').value=='No' || document.getElementById('4_eligibility').value=='N')
			{
				alert("CCC cannot be availed for this card.");
				return false;	
			}
		
			var selGridWIData = document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value
			var obj = JSON.parse(selGridWIData);
			var valueRakBankECardGird = obj['rakbank_eligible_card_no'];
			var arrValueRakBankECardGrid = valueRakBankECardGird.split("@");
						
			var valueRakBankECardGirdForm = document.getElementById(SubCategoryID+'_rakbank_eligible_card_no').value;
			
			for(var i=0;i<arrValueRakBankECardGrid.length;i++)
			{
				
				if(arrValueRakBankECardGrid[i]==valueRakBankECardGirdForm)
				{
					alert("Credit Card Cheque request for selected 'Rakbank Eligible Card No.' has already been added.");
					return false;
				}
			}
			
			/*
			var strJsonCardDetail = document.getElementById('CARD DETAILS_4_gridbundleJSON_WIDATA').value;
			var objCardDetail = JSON.parse(strJsonCardDetail);
			var cardNo = objCardDetail["card_no"];
			var arrCardNo = cardNo.split("@");
			var eligibleAmt = objCardDetail["eligible_amount"];
			var arrEligibleAmt = eligibleAmt.split("@");
			var CCCRequired = objCardDetail["ccc_required"];
			var arrCCCRequired = CCCRequired.split("@");
				
			
			var strJsonCCC = document.getElementById('CREDIT CARD CHEQUE DETAILS_4_gridbundleJSON_WIDATA').value;	
			var objCCC = JSON.parse(strJsonCCC);
			var eligibleCardNo = objCCC["rakbank_eligible_card_no"];
			var arrEligibleCardNo = eligibleCardNo.split("@");
			var CCCAmtReq = objCCC["ccc_amt_req"];
			var arrCCCAmtReq = CCCAmtReq.split("@");
			
						
			var totalCCCAmtReq = 0;
			var totalReqAmount=0;			
			for(var i=0;i<arrCardNo.length;i++)
			{
				if(arrCCCRequired[i]=='Yes')
				{
						
					if(document.getElementById('4_rakbank_eligible_card_no').value==arrCardNo[i])
					{
						
						for(var j=0;j<arrEligibleCardNo.length;j++)
						{
							
							if(document.getElementById('4_rakbank_eligible_card_no').value==arrEligibleCardNo[j])
							{
								totalReqAmount+=parseFloat(arrCCCAmtReq[j].split(',').join(''));
							}
						
						}
						
						var eligAmmt =parseFloat(arrEligibleAmt[i].split(',').join(''));
						var reqAmmt =parseFloat(document.getElementById('4_ccc_amt_req').value.split(',').join(''));
						totalReqAmount+=reqAmmt;
						
						if(eligAmmt<totalReqAmount)
						{
							alert("Sum of CCC requested amount should not exceed the CCC eligible amount for card no. " + arrCardNo[i]+".");
							document.getElementById('4_ccc_amt_req').focus();
							return false;
						}
					}
				}
			}*/
		}
		generateSubRefNo(frameName,SubCategoryID);
	}
	else if(CategoryID=='1' && SubCategoryID=='5')
	{	
		if(frameName=='SMART CASH DETAILS')
		{	
			if(document.getElementById("5_rakbank_eligible_card_no").value=='' || document.getElementById("5_rakbank_eligible_card_no").value=='--Select--')
			{
				alert("Please select RAK Eligible Card Number");
				document.getElementById('5_rakbank_eligible_card_no').focus();
				return false;
			}
		
			if(document.getElementById('5_sc_amt_req').value=='' || document.getElementById('5_sc_amt_req').value==' ')
			{
				alert("Please enter SC Amt Requested field");
				document.getElementById('5_sc_amt_req').focus();
				return false;	
			}
			if(document.getElementById('5_beneficiary_name').value=='' || document.getElementById('5_beneficiary_name').value==' ')
			{
				alert("Please enter Beneficiary Name field");
				document.getElementById('5_beneficiary_name').focus();
				return false;	
			}
			if(document.getElementById('5_type_of_smc').value=='' || document.getElementById('5_type_of_smc').value==' ' || document.getElementById('5_type_of_smc').value=='--Select--')
			{
				alert("Please enter Type of SMC field");
				document.getElementById('5_type_of_smc').focus();
				return false;	
			}
			if(document.getElementById("5_payment_by").value=='' || document.getElementById("5_payment_by").value=='--Select--')
			{
				alert("Please select Payment By");
				document.getElementById('5_payment_by').focus();
				return false;
			}
			if(document.getElementById('5_payment_by').value=='MCQ')
			{
			
				if(document.getElementById('5_delivery_channel').value=='' || document.getElementById('5_delivery_channel').value==' ' || document.getElementById('5_delivery_channel').value=='--Select--')
				{
					alert("Please select Delivery Channel");
					document.getElementById('5_delivery_channel').focus();
					return false;	
				}
				else if(document.getElementById('5_delivery_channel').value=='Branch')
				{
					if(document.getElementById('5_branch_name').value=='' || document.getElementById('5_branch_name').value==' ' || document.getElementById('5_branch_name').value=='--Select--')
					{
						alert("Please select Branch Name");
						document.getElementById('5_branch_name').focus();
						return false;	
					}
				}
			}
			if(document.getElementById('5_payment_by').value=='MCQ' || document.getElementById('5_payment_by').value=='FTS')
			{
				if(document.getElementById('5_other_bank_name').value=='' || document.getElementById('5_other_bank_name').value==' ' || document.getElementById('5_other_bank_name').value=='--Select--')
				{
					alert("Please enter Other Bank Name field");
					document.getElementById('5_other_bank_name').focus();
					return false;	
				}
			}
			if(document.getElementById('5_eligibility').value=='' || document.getElementById('5_eligibility').value==' ')
			{
				alert("Please click 'Check SMC Eligibility' button");
				return false;	
			}
			if(document.getElementById('5_eligibility').value=='No' || document.getElementById('5_eligibility').value=='N')
			{
				alert("SC cannot be availed for this card.");
				return false;	
			}
		
			var selGridWIData = document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value
			var obj = JSON.parse(selGridWIData);
			var valueRakBankECardGird = obj['rakbank_eligible_card_no'];
			var arrValueRakBankECardGrid = valueRakBankECardGird.split("@");
						
			var valueRakBankECardGirdForm = document.getElementById(SubCategoryID+'_rakbank_eligible_card_no').value;
			
			for(var i=0;i<arrValueRakBankECardGrid.length;i++)
			{
				
				if(arrValueRakBankECardGrid[i]==valueRakBankECardGirdForm)
				{
					alert("Credit Smart Cash request for selected 'Rakbank Eligible Card No.' has already been added.");
					return false;
				}
			}
			
			/*
			var strJsonCardDetail = document.getElementById('CARD DETAILS_5_gridbundleJSON_WIDATA').value;
			var objCardDetail = JSON.parse(strJsonCardDetail);
			var cardNo = objCardDetail["card_no"];
			var arrCardNo = cardNo.split("@");
			var eligibleAmt = objCardDetail["eligible_amount"];
			var arrEligibleAmt = eligibleAmt.split("@");
			var SCRequired = objCardDetail["sc_required"];
			var arrSCRequired = SCRequired.split("@");
				
			
			var strJsonSC = document.getElementById('CREDIT CARD CHEQUE DETAILS_5_gridbundleJSON_WIDATA').value;	
			var objSC = JSON.parse(strJsonSC);
			var eligibleCardNo = objSC["rakbank_eligible_card_no"];
			var arrEligibleCardNo = eligibleCardNo.split("@");
			var SCAmtReq = objSC["sc_amt_req"];
			var arrSCAmtReq = SCAmtReq.split("@");
			
						
			var totalSCAmtReq = 0;
			var totalReqAmount=0;			
			for(var i=0;i<arrCardNo.length;i++)
			{
				if(arrSCRequired[i]=='Yes')
				{
						
					if(document.getElementById('5_rakbank_eligible_card_no').value==arrCardNo[i])
					{
						
						for(var j=0;j<arrEligibleCardNo.length;j++)
						{
							
							if(document.getElementById('5_rakbank_eligible_card_no').value==arrEligibleCardNo[j])
							{
								totalReqAmount+=parseFloat(arrSCAmtReq[j].split(',').join(''));
							}
						
						}
						
						var eligAmmt =parseFloat(arrEligibleAmt[i].split(',').join(''));
						var reqAmmt =parseFloat(document.getElementById('5_sc_amt_req').value.split(',').join(''));
						totalReqAmount+=reqAmmt;
						
						if(eligAmmt<totalReqAmount)
						{
							alert("Sum of SC requested amount should not exceed the SC eligible amount for card no. " + arrCardNo[i]+".");
							document.getElementById('5_sc_amt_req').focus();
							return false;
						}
					}
				}
			}*/
		}
		generateSubRefNo(frameName,SubCategoryID);
	}
	return true;
}



function customClearGridFields(columnList,framename)
{
	var CategoryID = document.getElementById("CategoryID").value;
	var SubCategoryID = document.getElementById("SubCategoryID").value;
	
	
	if(CategoryID=='1' && SubCategoryID=='2')
	{
		if(framename=='BALANCE TRANSFER DETAILS')
		{
			document.getElementById("2_sub_ref_no").disabled=true;
			document.getElementById("2_eligibility").disabled=true;
			document.getElementById("2_delivery_channel").disabled=true;
			document.getElementById("2_branch_name").disabled=true;
			document.getElementById("2_v_non_eligibility_reasons").disabled=true;

		}
		
		if(framename=='AUTHORIZATION DETAILS')
		{		
			document.getElementById("2_sub_ref_no_auth").disabled=true;
			document.getElementById("2_card_no").disabled=true;
			document.getElementById("2_auth_code").disabled=true;
			document.getElementById("2_status").disabled=true;
			document.getElementById("2_bt_amount").disabled=true;
			document.getElementById("2_tran_req_uid").disabled=true;
			document.getElementById("2_Approval_cd").disabled=true;
		}
	}
	if(CategoryID=='1' && SubCategoryID=='4')
	{
		if(framename=='CREDIT CARD CHEQUE DETAILS')
		{
			document.getElementById("4_sub_ref_no").disabled=true;
			document.getElementById("4_eligibility").disabled=true;
			document.getElementById("4_delivery_channel").disabled=true;
			document.getElementById("4_branch_name").disabled=true;
			document.getElementById("4_marketing_code").disabled=true;
			document.getElementById("4_v_non_eligibility_reasons").disabled=true;
		}
		
		if(framename=='AUTHORIZATION DETAILS')
		{		
			document.getElementById("4_sub_ref_no_auth").disabled=true;
			document.getElementById("4_card_no_1").disabled=true;
			document.getElementById("4_auth_code").disabled=true;
			document.getElementById("4_status").disabled=true;
			document.getElementById("4_ccc_amount").disabled=true;
			document.getElementById("4_tran_req_uid").disabled=true;
			document.getElementById("4_Approval_cd").disabled=true;
		}
	}
	if(CategoryID=='1' && SubCategoryID=='5')
	{
		if(framename=='SMART CASH DETAILS')
		{
			document.getElementById("5_sub_ref_no").disabled=true;
			document.getElementById("5_eligibility").disabled=true;
			document.getElementById("5_delivery_channel").disabled=true;
			document.getElementById("5_branch_name").disabled=true;
			document.getElementById("5_marketing_code").disabled=true;
			document.getElementById("5_v_non_eligibility_reasons").disabled=true;
		}
		
		if(framename=='AUTHORIZATION DETAILS')
		{		
			document.getElementById("5_sub_ref_no_auth").disabled=true;
			document.getElementById("5_card_no_1").disabled=true;
			document.getElementById("5_auth_code").disabled=true;
			document.getElementById("5_status").disabled=true;
			document.getElementById("5_sc_amount").disabled=true;
			document.getElementById("5_tran_req_uid").disabled=true;
			document.getElementById("5_Approval_cd").disabled=true;
		}
	}
}

function customOnLoad()
{
	//In this function Write Custom Validation and code	on load.
	
	var CategoryID = document.getElementById("CategoryID").value;
	var SubCategoryID = document.getElementById("SubCategoryID").value;
	var WSNAME = document.getElementById('WS_NAME').value;
	var viewMode=document.getElementById("sMode").value;
	
	if(CategoryID=='1' && SubCategoryID=='3')
	{	
		document.getElementById('3_block_card').disabled=true;
		document.getElementById('3_type_of_block').disabled=true;
		document.getElementById('3_reason_for_block').disabled=true;
		document.getElementById('3_replacement_required').disabled=true;
		document.getElementById("3_date_and_time").disabled=true;
		document.getElementById("3_ATM_Loc").disabled=true;
		document.getElementById("3_branch_collect").disabled=true;	
		
		if(WSNAME=='PBO')
		{
			document.getElementsByTagName("table")[2].rows[9].style.display ="none";
		}	
			
		if((document.getElementById('3_req_status').value).replace(/^\s+|\s+$/gm,'')=='Not Blocked')
		{
			document.getElementsByTagName("table")[2].rows[7].style.display ="";
			document.getElementsByTagName("table")[2].rows[8].style.display ="";
		}
		else
		{
			document.getElementsByTagName("table")[2].rows[7].style.display ="none";
			document.getElementsByTagName("table")[2].rows[8].style.display ="none";
		}
		
	} 
	else if(CategoryID=='1' && SubCategoryID=='2')
	{	
		
		
		document.getElementsByTagName("table")[2].rows[6].style.display ="none";
		
								
		document.getElementsByTagName("table")[9].rows[3].style.display ="none";
		document.getElementsByTagName("table")[9].rows[4].style.display ="none";
		document.getElementsByTagName("table")[9].rows[5].style.display ="none";
	
		if((document.getElementById('WS_NAME').value!='PBO'))
		{
			document.getElementsByTagName("table")[9].rows[5].style.display ="none";
			document.getElementsByTagName("table")[9].rows[7].style.display ="none";
			document.getElementsByTagName("table")[9].rows[8].style.display ="none";
		}
		if((document.getElementById('WS_NAME').value=='Q4'))
		{
			document.getElementsByTagName("table")[9].rows[9].style.display ="none";
			document.getElementsByTagName("table")[9].rows[8].style.display ="";
		}

			
		document.getElementById("2_bt_required").disabled=true;
		document.getElementById("Check Card Eligibility").disabled=true;
		
		//decrypting card number in customer details frame
		if(document.getElementById('WS_NAME').value!='PBO')
		{
			if(viewMode!='R')
			document.getElementById("2_card_number").value=Decrypt(document.getElementById("2_card_number").value);
			else 
			document.getElementById("2_card_number").value=maskCardNo(Decrypt(document.getElementById("2_card_number").value));
		}
		else if(document.getElementById('WS_NAME').value=='PBO' && parent.document.getElementById("wdesk:IntegrationStatus").value=='false')
		{
			document.getElementById("2_card_number").value=Decrypt(document.getElementById("2_card_number").value);
		}
		
		if(document.getElementById('2_payment_by').value=='MCQ')
		{
		
			if(document.getElementById('2_delivery_channel').value=='' || document.getElementById('2_delivery_channel').value==' ' || document.getElementById('2_delivery_channel').value=='--Select--')
			{
				alert("Please select Delivery Channel");
				document.getElementById('2_delivery_channel').focus();
				return false;	
			}
			else if(document.getElementById('2_delivery_channel').value=='To RakBank Branch')
			{
				if(document.getElementById('2_branch_name').value=='' || document.getElementById('2_branch_name').value==' ' || document.getElementById('2_branch_name').value=='--Select--')
				{
					alert("Please select Branch Name");
					document.getElementById('2_branch_name').focus();
					return false;	
				}
			}
		}else{
		
			document.getElementById('2_delivery_channel').disabled=true;
			document.getElementById('2_branch_name').disabled=true;
		}
		
		
		if(WSNAME=="PBO")
		{
			var selGridWIData = document.getElementById("CARD DETAILS_"+SubCategoryID+'_gridbundleJSON_WIDATA').value
			var obj = JSON.parse(selGridWIData);
			
			var valCardEligiblity= obj['card_eligibility'];
			var arrValCardEligiblity = valCardEligiblity.split("@");
			var valueRAKCardNo = obj['rak_card_no'];
			var ArrValueRAKCardNo = valueRAKCardNo.split("@");
			var selbox = document.getElementById("2_rakbank_eligible_card_no");
			var noOfSelOption = selbox.options.length;
			
			for(var i = 0; i< ArrValueRAKCardNo.length; i++)
			{
				if(arrValCardEligiblity[i]=='Yes'){
					selbox.options[selbox.options.length] = new
					Option(ArrValueRAKCardNo[i],ArrValueRAKCardNo[i]);
				}
			}
			
			//code added to set sales agent id default to agent network id
			var salesAgentId = document.getElementById('2_sales_agent_id');
			
			for (var i = 0; i < salesAgentId.options.length; i++) {
				if (salesAgentId.options[i].text== document.getElementById('2_agent_network_id').value) {
					salesAgentId.options[i].selected = true;
				}
			}
			document.getElementById("2_Source").value=document.getElementById('2_sales_agent_id').value;
		}
		
		if(parent.document.getElementById("wdesk:IntegrationStatus").value=='false') // prateek
		{
			document.getElementById('2_bt_required').disabled=true;
			document.getElementById("Check Card Eligibility").disabled=true;	
			document.getElementById("CARD DETAILS_Modify").disabled=true;	
			document.getElementById("CARD DETAILS_Clear").disabled=true;	
			document.getElementById("2_sub_ref_no").disabled=true;
			document.getElementById("2_rakbank_eligible_card_no").disabled=true;
			document.getElementById("2_bt_amt_req").disabled=true;
			document.getElementById("2_other_bank_card_type").disabled=true;
			document.getElementById("2_name_on_card").disabled=true;
			document.getElementById("2_other_bank_card_no").disabled=true;
			document.getElementById("2_type_of_bt").disabled=true;
			document.getElementById("2_other_bank_name").disabled=true;
			document.getElementById("2_remarks").disabled=true;
			document.getElementById("2_payment_by").disabled=true;
			document.getElementById("2_delivery_channel").disabled=true;
			document.getElementById("2_branch_name").disabled=true;
			document.getElementById("2_eligibility").disabled=true;
			document.getElementById("Check BT Eligibility").disabled=true;	
			document.getElementById("BALANCE TRANSFER DETAILS_Add").disabled=true;	
			document.getElementById("BALANCE TRANSFER DETAILS_Modify").disabled=true;	
			document.getElementById("BALANCE TRANSFER DETAILS_Delete").disabled=true;	
			document.getElementById("BALANCE TRANSFER DETAILS_Clear").disabled=true;	
		}	
	} 
	else if(CategoryID=='1' && SubCategoryID=='4')
	{
	
		document.getElementsByTagName("table")[2].rows[6].style.display ="none";
		
		
		
		document.getElementsByTagName("table")[9].rows[3].style.display ="none";
		document.getElementsByTagName("table")[9].rows[4].style.display ="none";
		document.getElementsByTagName("table")[9].rows[5].style.display ="none";
		
		if((document.getElementById('WS_NAME').value!='PBO'))
		{
			document.getElementsByTagName("table")[9].rows[5].style.display ="none";
			document.getElementsByTagName("table")[9].rows[7].style.display ="none";
			document.getElementsByTagName("table")[9].rows[8].style.display ="none";
		}
		if((document.getElementById('WS_NAME').value=='Q4'))
		{
			document.getElementsByTagName("table")[9].rows[9].style.display ="none";
			document.getElementsByTagName("table")[9].rows[8].style.display ="";
		}

	
		document.getElementById("4_ccc_required").disabled=true;
		document.getElementById("Check Card Eligibility").disabled=true;
		document.getElementById("4_Purpose").disabled=true;
		
		//decrypting card number in customer details frame
		if(document.getElementById('WS_NAME').value!='PBO')
		{
			if(viewMode!='R')
			document.getElementById("4_card_number").value=Decrypt(document.getElementById("4_card_number").value);
			else 
			document.getElementById("4_card_number").value=maskCardNo(Decrypt(document.getElementById("4_card_number").value));
		}
		else if(document.getElementById('WS_NAME').value=='PBO' && parent.document.getElementById("wdesk:IntegrationStatus").value=='false')
		{
			document.getElementById("4_card_number").value=Decrypt(document.getElementById("4_card_number").value);
		}

		if(document.getElementById('4_payment_by').value=='MCQ')
		{
			if(document.getElementById('4_delivery_channel').value=='' || document.getElementById('4_delivery_channel').value==' ' || document.getElementById('4_delivery_channel').value=='--Select--')
			{
				alert("Please select Delivery Channel");
				document.getElementById('4_delivery_channel').focus();
				return false;	
			}
			else if(document.getElementById('4_delivery_channel').value=='To RakBank Branch')
			{
				if(document.getElementById('4_branch_name').value=='' || document.getElementById('4_branch_name').value==' ' || document.getElementById('4_branch_name').value=='--Select--')
				{
					alert("Please select Branch Name");
					document.getElementById('4_branch_name').focus();
					return false;	
				}
			}
		}else
		{
			document.getElementById('4_delivery_channel').disabled=true;
			document.getElementById('4_branch_name').disabled=true;
		}
		
		var WSNAME = document.getElementById('WS_NAME').value;
		if(WSNAME=="PBO")
		{
			var selGridWIData = document.getElementById('CARD DETAILS_4_gridbundleJSON_WIDATA').value
			var obj = JSON.parse(selGridWIData);
			
			var valCardEligiblity= obj['card_eligibility'];
			var arrValCardEligiblity = valCardEligiblity.split("@");
			
			var valueRAKCardNo = obj['card_no'];
			var ArrValueRAKCardNo = valueRAKCardNo.split("@");
			var selbox = document.getElementById("4_rakbank_eligible_card_no");
			
			var noOfSelOption = selbox.options.length;	
			for(var i = 0; i< ArrValueRAKCardNo.length; i++)
			{
				if(arrValCardEligiblity[i]=='Yes')
				{
					
					selbox.options[selbox.options.length] = new
					Option(ArrValueRAKCardNo[i],ArrValueRAKCardNo[i]);
				}
			}
			
			//code added to set sales agent id default to agent network id
			var salesAgentId = document.getElementById('4_sales_agent_id');
			
			for (var i = 0; i < salesAgentId.options.length; i++) {
				if (salesAgentId.options[i].text== document.getElementById('4_agent_network_id').value) {
					salesAgentId.options[i].selected = true;
				}
			}
			document.getElementById("4_source_code").value=document.getElementById('4_sales_agent_id').value;
		}
		
		if(parent.document.getElementById("wdesk:IntegrationStatus").value=='false') // prateek
		{
		
			document.getElementById('4_ccc_required').disabled=true;
			document.getElementById("Check Card Eligibility").disabled=true;	
			document.getElementById("CARD DETAILS_Modify").disabled=true;	
			document.getElementById("CARD DETAILS_Clear").disabled=true;	
					
			
			document.getElementById("4_sub_ref_no").disabled=true;
			document.getElementById("4_rakbank_eligible_card_no").disabled=true;
			document.getElementById("4_ccc_amt_req").disabled=true;
			document.getElementById("4_beneficiary_name").disabled=true;
			document.getElementById("4_payment_by").disabled=true;
			document.getElementById("4_delivery_channel").disabled=true;
			document.getElementById("4_branch_name").disabled=true;
			document.getElementById("4_remarks").disabled=true;
			document.getElementById("4_marketing_code").disabled=true;
			document.getElementById("Check CCC Eligibility").disabled=true;
		
			document.getElementById("CREDIT CARD CHEQUE DETAILS_Add").disabled=true;	
			document.getElementById("CREDIT CARD CHEQUE DETAILS_Modify").disabled=true;	
			document.getElementById("CREDIT CARD CHEQUE DETAILS_Delete").disabled=true;	
			document.getElementById("CREDIT CARD CHEQUE DETAILS_Clear").disabled=true;	
		}
	}
	else if(CategoryID=='1' && SubCategoryID=='5')
	{
	
		/*document.getElementsByTagName("table")[2].rows[6].style.display ="none";
		
		
		
		document.getElementsByTagName("table")[9].rows[3].style.display ="none";
		document.getElementsByTagName("table")[9].rows[4].style.display ="none";
		document.getElementsByTagName("table")[9].rows[5].style.display ="none";*/
		
		if((document.getElementById('WS_NAME').value!='PBO'))
		{
			document.getElementsByTagName("table")[9].rows[5].style.display ="none";
			document.getElementsByTagName("table")[9].rows[7].style.display ="none";
			document.getElementsByTagName("table")[9].rows[8].style.display ="none";
		}
		if((document.getElementById('WS_NAME').value=='Q4'))
		{
			document.getElementsByTagName("table")[9].rows[9].style.display ="none";
			document.getElementsByTagName("table")[9].rows[8].style.display ="";
		}

	
		document.getElementById("5_sc_required").disabled=true;
		document.getElementById("Check Card Eligibility").disabled=true;
		//document.getElementById("5_Purpose").disabled=true;
		
		//decrypting card number in customer details frame
		if(document.getElementById('WS_NAME').value!='PBO')
		{
			if(viewMode!='R')
			document.getElementById("5_card_number").value=Decrypt(document.getElementById("5_card_number").value);
			else 
			document.getElementById("5_card_number").value=maskCardNo(Decrypt(document.getElementById("5_card_number").value));
		}
		else if(document.getElementById('WS_NAME').value=='PBO' && parent.document.getElementById("wdesk:IntegrationStatus").value=='false')
		{
			document.getElementById("5_card_number").value=Decrypt(document.getElementById("5_card_number").value);
		}

		if(document.getElementById('5_payment_by').value=='MCQ')
		{
			if(document.getElementById('5_delivery_channel').value=='' || document.getElementById('5_delivery_channel').value==' ' || document.getElementById('5_delivery_channel').value=='--Select--')
			{
				alert("Please select Delivery Channel");
				document.getElementById('5_delivery_channel').focus();
				return false;	
			}
			else if(document.getElementById('5_delivery_channel').value=='To RakBank Branch')
			{
				if(document.getElementById('5_branch_name').value=='' || document.getElementById('5_branch_name').value==' ' || document.getElementById('5_branch_name').value=='--Select--')
				{
					alert("Please select Branch Name");
					document.getElementById('5_branch_name').focus();
					return false;	
				}
			}
		}else
		{
			document.getElementById('5_delivery_channel').disabled=true;
			document.getElementById('5_branch_name').disabled=true;
		}
		
		var WSNAME = document.getElementById('WS_NAME').value;
		if(WSNAME=="PBO")
		{
			var selGridWIData = document.getElementById('CARD DETAILS_5_gridbundleJSON_WIDATA').value
			var obj = JSON.parse(selGridWIData);
			
			var valCardEligiblity= obj['card_eligibility'];
			var arrValCardEligiblity = valCardEligiblity.split("@");
			
			var valueRAKCardNo = obj['card_no'];
			var ArrValueRAKCardNo = valueRAKCardNo.split("@");
			var selbox = document.getElementById("5_rakbank_eligible_card_no");
			
			var noOfSelOption = selbox.options.length;	
			for(var i = 0; i< ArrValueRAKCardNo.length; i++)
			{
				if(arrValCardEligiblity[i]=='Yes')
				{
					
					selbox.options[selbox.options.length] = new
					Option(ArrValueRAKCardNo[i],ArrValueRAKCardNo[i]);
				}
			}
			
			//code added to set sales agent id default to agent network id
			var salesAgentId = document.getElementById('5_sales_agent_id');
			
			for (var i = 0; i < salesAgentId.options.length; i++) {
				if (salesAgentId.options[i].text== document.getElementById('5_agent_network_id').value) {
					salesAgentId.options[i].selected = true;
				}
			}
			document.getElementById("5_source_code").value=document.getElementById('5_sales_agent_id').value;
		}
		
		if(parent.document.getElementById("wdesk:IntegrationStatus").value=='false') // prateek
		{
		
			document.getElementById('5_sc_required').disabled=true;
			document.getElementById("Check Card Eligibility").disabled=true;	
			document.getElementById("CARD DETAILS_Modify").disabled=true;	
			document.getElementById("CARD DETAILS_Clear").disabled=true;	
					
			
			document.getElementById("5_sub_ref_no").disabled=true;
			document.getElementById("5_rakbank_eligible_card_no").disabled=true;
			document.getElementById("5_sc_amt_req").disabled=true;
			document.getElementById("5_beneficiary_name").disabled=true;
			document.getElementById("5_type_of_smc").disabled=true;
			document.getElementById("5_payment_by").disabled=true;
			document.getElementById("5_delivery_channel").disabled=true;
			document.getElementById("5_branch_name").disabled=true;
			document.getElementById("5_remarks").disabled=true;
			document.getElementById("5_marketing_code").disabled=true;
			document.getElementById("Check SMC Eligibility").disabled=true;
			document.getElementById("5_other_bank_name").disabled=true;
			document.getElementById("5_RakbankAccountNO").disabled=true;
			document.getElementById("5_other_bank_iban").disabled=true;
			document.getElementById("SMART CASH DETAILS_Add").disabled=true;	
			document.getElementById("SMART CASH DETAILS_Modify").disabled=true;	
			document.getElementById("SMART CASH DETAILS_Delete").disabled=true;	
			document.getElementById("SMART CASH DETAILS_Clear").disabled=true;	
		}
	}
}

function ValidateDate()
{
	
	var CategoryID = document.getElementById("CategoryID").value;
	var SubCategoryID = document.getElementById("SubCategoryID").value;
	if(CategoryID=='1' && SubCategoryID=='3')
	{
		var date_and_time= document.getElementById("3_date_and_time").value;
		date_and_time = date_and_time.substring(0,10);
		
		if(date_and_time!='')
		{
			var now = new Date();
			var month = now.getMonth()+1;
			if(month<10)
			month = "0"+month;
			
			var date = now.getDate();
			if(date<10)
			date = "0"+date;
			
			var currdate = date+"/"+month+"/"+now.getFullYear();
			var regExp = /(\d{1,2})\/(\d{1,2})\/(\d{2,4})/;
			if(parseInt(date_and_time.replace(regExp, "$3$2$1"))>parseInt(currdate.replace(regExp, "$3$2$1")))
			{

				alert("Date and Time field should not have future date");
				document.getElementById('3_date_and_time').value="";
				document.getElementById('3_date_and_time').focus();
				return false;
			}
			else
			{
				return true;
			}
		}
	}
	if(CategoryID=='1' && (SubCategoryID=='2' || SubCategoryID=='4'|| SubCategoryID=='5'))
	{
		
		var date_and_time= document.getElementById(SubCategoryID+"_expiry").value;
		
		var arrDate_and_time = date_and_time.split('-');
			date_and_time = arrDate_and_time[2]+"/"+arrDate_and_time[1]+"/"+arrDate_and_time[0];
			
		if(date_and_time!='')
		{
			var now = new Date();
			var month = now.getMonth()+1;
			if(month<10)
			month = "0"+month;
			var currdate = now.getDate()+"/"+month+"/"+now.getFullYear();
			
			var regExp = /(\d{1,2})\/(\d{1,2})\/(\d{2,4})/;

			if(parseInt(date_and_time.replace(regExp, "$3$2$1"))<parseInt(currdate.replace(regExp, "$3$2$1")))
			{
				return false;
			}
			else
			{
				return true;
			}
		}
	}	
}

function checkCardEligibility()
{
	
	var CategoryID = document.getElementById("CategoryID").value;
	var SubCategoryID = document.getElementById("SubCategoryID").value;
	if(CategoryID==1 && SubCategoryID==2){
	
			/*if(document.getElementById("2_cardholder_type").value=="Supplementary")
			{
				alert("Card holder is supplementary - BT can be availed by Primary cardholder only");
				document.getElementById("2_bt_required").checked = false;
				document.getElementById("Check Card Eligibility").disabled = true;
				return false;	
			}*/
	
			
			/*if(document.getElementById("2_card_status").value=="NORI" || document.getElementById("2_card_status").value=="NEWR")
			{
				alert("Card status is "+document.getElementById("2_card_status").value+"- Card Activation is required - cannot proceed with BT request");
				document.getElementById("2_bt_required").checked = false;
				document.getElementById("Check Card Eligibility").disabled = true;
				return false;	
			}
			if(document.getElementById("2_card_status").value!="NORM" && document.getElementById("2_card_status").value!="NORR")
			{
				alert("Card status is "+document.getElementById("2_card_status").value+"-cannot proceed with BT request");
				document.getElementById("2_bt_required").checked = false;
				document.getElementById("Check Card Eligibility").disabled = true;
				return false;	
			}*/			
			/*if(document.getElementById("2_expiry").value==''){
				alert("Card is expired - BT cannot be availed on this card");
			}else{
				var valid = true;
				valid = ValidateDate();
				
				if(!valid){
					alert("Card is expired - BT cannot be availed on this card");
					document.getElementById("2_bt_required").checked = false;
					document.getElementById("Check Card Eligibility").disabled = true;
					return false;
				}
				
			}	*/
			if(document.getElementById('2_mobile_number').value=='')
			{
				alert("Customer mobile number is mandatory.");
				return false;
			}
		
			var blockUrl="/webdesktop/CustomForms/SRM_Specific/SRMIntegration.jsp?CardNumber="+document.getElementById('2_rak_card_no').value+"&CustId="+document.getElementById('2_cif').value+"&CardStatus="+document.getElementById('2_card_status').value+"&AvailableBalance="+document.getElementById('2_available_balance').value+"&AvailableCashBalance="+document.getElementById('2_available_balance_cash').value+"&OverdueAmount="+document.getElementById('2_overdue_amt').value+"&WSNAME=PBO&WS_LogicalName=PBO&CategoryID=1&SubCategoryID=2&IsDoneClicked=N&IsError=N&IsSaved=N&RequestType=CardEligibility";
			
			blockUrl=replaceUrlChars(blockUrl);			
			var ResponseList;	
			var xhr;
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			 xhr.open("GET",blockUrl,false); 
			 xhr.send(null);
			if (xhr.status == 200 && xhr.readyState == 4)
			{					
				var ajaxResult=Trim1(xhr.responseText);
			}
			else
			{
				alert("Problem in Card Eligibility");
				return false;
			}
			ResponseList = ajaxResult.split("~");
			var responseMainCode=ResponseList[0];
			var cardEligibility=ResponseList[1];
			if(cardEligibility=='Y')
			{
				cardEligibility="Yes";
				document.getElementById('2_non_eligibility_reasons').value="";
			}
			else
				cardEligibility="No";
			var eligibleAmount=ResponseList[2];
			var salary=ResponseList[3];
			var nonEligibilityReasons=ResponseList[4];
			if(responseMainCode=='0000'){
				document.getElementById('2_card_eligibility').value=cardEligibility;
				document.getElementById('2_eligible_amount').value=eligibleAmount;
				document.getElementById('2_salary').value=salary;
				//document.getElementById('2_non_eligibility_reasons').value=getDecodedValue(nonEligibilityReasons);
				if(cardEligibility=='No')
				{
					var noneligreasons = nonEligibilityReasons.split("-");
					var decodedNonEligReason="";
					var nonEligReasonResp = "";
					var response ="";
								
					var tempnoneligibilityreason="";
					for (i = 0; i < noneligreasons.length; i++) 
					{
						nonEligReasonResp = getSelectResponseAjax('usr_0_srm_btccc_noneligrsn',noneligreasons[i]);
						response = nonEligReasonResp.split("~");
						if(response[0]=='0')
						{
							decodedNonEligReason = response[1];
							tempnoneligibilityreason+=decodedNonEligReason+", ";
						}
						else
						{
							alert("Error in getting non eligibility reason for "+noneligreasons[i]);
							return false;
						}
						
					}
					document.getElementById('2_non_eligibility_reasons').value = tempnoneligibilityreason.substring(0,tempnoneligibilityreason.lastIndexOf(','));
				}
				
				// change for save on this button click
				var colList=document.getElementById('CARD DETAILS_ColumnList').value;
				colList = colList.replace('[','');
				colList = colList.replace(']','');
				var frName="CARD DETAILS";
				if(!ModifyGridValuesOnButtonClick(colList,frName,SubCategoryID))
				{
					return false;
				}
			}
	}
}

function checkBTEligibility(){

	var CategoryID = document.getElementById("CategoryID").value;
	var SubCategoryID = document.getElementById("SubCategoryID").value;
	
	
	if(CategoryID==1 && SubCategoryID==2){
	
		if(document.getElementById("2_rakbank_eligible_card_no").value=='' ||document.getElementById("2_rakbank_eligible_card_no").value=='--Select--' ){
			alert("Please select Rakbank Eligible Card Number.");
			document.getElementById("2_rakbank_eligible_card_no").focus();
			return false;
		}	

		if(document.getElementById('2_bt_amt_req').value=='' || document.getElementById('2_bt_amt_req').value==' ')
		{
			alert("Please enter BT Amt Requested.");
			document.getElementById('2_bt_amt_req').focus();
			return false;	
		}
		
		/*if(document.getElementById('2_bt_amt_req').value<=1000)
		{
			alert("BT cannot be availed if the requested amount is less than or equal to AED 1000.");
			document.getElementById('2_bt_amt_req').focus();
			return false;	
		}*/
		if(document.getElementById("2_other_bank_card_no").value=='' ||document.getElementById("2_other_bank_card_no").value==' ' ){
			alert("Please enter Other Bank Card number.");
			return false;
		}
		if(!mod10(document.getElementById('2_other_bank_card_no').value))
		{
			alert("Invalid Other Bank Card No.");
			document.getElementById('2_other_bank_card_no').value="";
			document.getElementById('2_other_bank_card_no').focus();
			return false;
				
		}		
		if(document.getElementById("2_type_of_bt").value=='' ||document.getElementById("2_type_of_bt").value=='--Select--' ){
			alert("Please select Type of BT.");
			return false;
		}
		
			var paramMarketingCode = '';
		
			var marketingcoderesp = getSelectResponseAjax('usr_0_srm_bt_marketingcodes',document.getElementById("2_type_of_bt").value.split("%").join("CHARPERCENTAGE"));
			var response = marketingcoderesp.split("~");
			if(response[0]=='0')
			{
				paramMarketingCode = response[1];
			}
			else
			{
				alert("Error in getting marketing code");
				return false;
			}
		
			// Added as part of Smart Cash Changes - PaymentMode is mandatory in Eligibility Check call
			var PaymentMode = document.getElementById("2_payment_by").value;
			if(PaymentMode == '' || PaymentMode ==' ' || PaymentMode == '--Select--'){
				alert("Please enter Payment By");
				document.getElementById('2_payment_by').focus();
				return false;
			}
			if (PaymentMode == 'FTS')
			{
				if ((document.getElementById("2_name_on_card").value).length > 35)
				{
					alert("Name on Card field length should not be more than 35 character.");
					document.getElementById('2_name_on_card').focus();
					return false;
				}
			}
			//***********************************
			
			//var blockUrl="/webdesktop/CustomForms/SRM_Specific/SRMIntegration.jsp?OtherBankCardNumber="+document.getElementById('2_other_bank_card_no').value+"&WSNAME=PBO&WS_LogicalName=PBO&CategoryID=1&SubCategoryID=2&IsDoneClicked=N&IsError=N&IsSaved=N&RequestType=BTEligibility";
			
			var blockUrl="/webdesktop/CustomForms/SRM_Specific/SRMIntegration.jsp?CustId="+document.getElementById('2_cif').value+
			"&CardNumber="+document.getElementById('2_rakbank_eligible_card_no').value+"&RequestAmount="+document.getElementById('2_bt_amt_req').value+"&BeneficiaryName="+document.getElementById('2_name_on_card').value+"&MarketingCode="+paramMarketingCode+"&OtherBankCardNumber="+document.getElementById('2_other_bank_card_no').value+"&WSNAME=PBO&WS_LogicalName=PBO&CategoryID=1&SubCategoryID=2&IsDoneClicked=N&IsError=N&IsSaved=N&RequestType=BTEligibility&PaymentMode="+PaymentMode;
			
			blockUrl=replaceUrlChars(blockUrl);			
		
			var ResponseList;	
			var xhr;
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			 xhr.open("GET",blockUrl,false); 
			 xhr.send(null);
			if (xhr.status == 200 && xhr.readyState == 4)
			{					
				var ajaxResult=Trim1(xhr.responseText);
			}
			else
			{
				alert("Problem in checkBTEligibility");
				return false;
			}
			ResponseList = ajaxResult.split("~");
			var responseMainCode=ResponseList[0];
			var cardEligibility=ResponseList[1];
			var nonEligibilityReasons = ResponseList[2];
			if(cardEligibility=='Y')
			{
				cardEligibility="Yes";
				document.getElementById('2_v_non_eligibility_reasons').value='';
			}
			else
				cardEligibility="No";
			if(responseMainCode=='0000'){
				document.getElementById('2_eligibility').value=cardEligibility;
				if(cardEligibility=='No')
				{
					var noneligreasons = nonEligibilityReasons.split("-");
					//alert(noneligreasons.length);
					
					var decodedNonEligReason="";
					var nonEligReasonResp = "";
					var response ="";
								
					var tempnoneligibilityreason="";
					for (i = 0; i < noneligreasons.length; i++) 
					{
						nonEligReasonResp = getSelectResponseAjax('usr_0_srm_btccc_noneligrsn',noneligreasons[i]);
						response = nonEligReasonResp.split("~");
						if(response[0]=='0')
						{
							decodedNonEligReason = response[1];
							tempnoneligibilityreason+=decodedNonEligReason+", ";
						}
						else
						{
							alert("Error in getting non eligibility reason for "+noneligreasons[i]);
							return false;
						}
						
					}
					document.getElementById('2_v_non_eligibility_reasons').value = tempnoneligibilityreason.substring(0,tempnoneligibilityreason.lastIndexOf(','));
				}
			}
	}
}

function checkCCCCardEligibility(event,labelname)
{
	
	var CategoryID = document.getElementById("CategoryID").value;
	var SubCategoryID = document.getElementById("SubCategoryID").value;
	
	
	
	if(CategoryID==1 && SubCategoryID==4){
	
	
			/*if(document.getElementById("4_card_status").value=="NORM" && document.getElementById("4_overdue_amt").value>100)
			{
				alert("CCC cannot be availed on overdue card");
				document.getElementById("4_ccc_required").checked = false;
				document.getElementById("4_Purpose").value=='--Select--';
				document.getElementById("4_Purpose").disabled = true;
				document.getElementById("Check Card Eligibility").disabled = true;
				return false;	
			}*/
			/*if(document.getElementById("4_card_status").value=="NORI" || document.getElementById("4_card_status").value=="NEWR")
			{
				alert("Card status is "+document.getElementById("4_card_status").value+"- Card Activation is required - cannot proceed with CCC request");
				document.getElementById("4_ccc_required").checked = false;
				document.getElementById("4_Purpose").value=='--Select--';
				document.getElementById("4_Purpose").disabled = true;
				document.getElementById("Check Card Eligibility").disabled = true;
				return false;	
			}
			if(document.getElementById("4_card_status").value!="NORM" && document.getElementById("4_card_status").value!="NORR")
			{
				alert("Card status is "+document.getElementById("4_card_status").value+"-cannot proceed with CCC request");
				document.getElementById("4_ccc_required").checked = false;
				document.getElementById("4_Purpose").value=='--Select--';
				document.getElementById("4_Purpose").disabled = true;
				document.getElementById("Check Card Eligibility").disabled = true;
				return false;	
			}*/			
			/*if(document.getElementById("4_expiry").value==''){
				alert("Card is expired - CCC cannot be availed on this card");
			}else{
				var valid = true;
				valid = ValidateDate();
				
				if(!valid){
					alert("Card is expired - CCC cannot be availed on this card");
					document.getElementById("4_ccc_required").checked = false;
					document.getElementById("4_Purpose").value=='--Select--';
					document.getElementById("4_Purpose").disabled = true;
					document.getElementById("Check Card Eligibility").disabled = true;
					return false;
				}
				
			}*/
			if(document.getElementById('4_mobile_number').value=='')
			{
				alert("Customer mobile number is mandatory.");
				return false;
			}
			var Purpose = document.getElementById("4_Purpose").value;
			//var PaymentType = getDecodedValue(Purpose);
			
			
				var PaymentType="";
				var paymentresp = getSelectResponseAjax('usr_0_srm_ccc_purpose_master',document.getElementById("4_Purpose").value.split('%').join('CHARPERCENTAGE').split("&").join("CHARAMPERSAND"));
				var response = paymentresp.split("~");
				if(response[0]=='0')
				{
					PaymentType = response[1];
				}
				else
				{
					alert("Error in getting payment type code");
					return false;
				}
			/*if(Purpose=="Payment of school fees / college fees"){
				PaymentType="PSC";
			}else if(Purpose=="Payment of Rent - in favor of Real Estate Companies only"){
				PaymentType="PRC";
			}else if(Purpose=="Payment of Insurance Premiums - in favor of Insurance Providers or Agents"){
				PaymentType="PIP";		
			}else if(Purpose=="Payment to known Property Developers in Dubai & Abu Dhabi"){
				PaymentType="PDA";		
			}else if(Purpose=="Payment to any Government Departments / Entities"){
				PaymentType="PGE";		
			}else if(Purpose=="Payment to Utility Companies"){
				PaymentType="PUC";		
			}else if(Purpose=="Payment to Auto Dealers"){
				PaymentType="PAD";		
			}else if(Purpose=="If issued in the name of Cardholder (self)"){
				PaymentType="SLF";		
			}else if(Purpose=="Payment to any third party other than those mentioned above"){
				PaymentType="THP";		
			}else{
				PaymentType=Purpose;		
			}*/
			if(document.getElementById("4_Purpose").value=='' 
				||document.getElementById("4_Purpose").value==' ' 
				||document.getElementById("4_Purpose").value=='--Select--')
			{
				alert("Please select Purpose first");
				document.getElementById('4_Purpose').focus();
				return false;
			}			
			
			var blockUrl="/webdesktop/CustomForms/SRM_Specific/SRMIntegration.jsp?CardNumber="+document.getElementById('4_card_no').value+"&CustId="+document.getElementById('4_cif').value+"&CardStatus="+document.getElementById('4_card_status').value+"&AvailableBalance="+document.getElementById('4_available_balance').value+"&AvailableCashBalance="+document.getElementById('4_available_balance_cash').value+"&OverdueAmount="+document.getElementById('4_overdue_amt').value+"&PaymentType="+PaymentType+"&WSNAME=PBO&WS_LogicalName=PBO&CategoryID=1&SubCategoryID=4&IsDoneClicked=N&IsError=N&IsSaved=N&RequestType=CCCCardEligibility";
			
			blockUrl=replaceUrlChars(blockUrl);			
			var ResponseList;	
			var xhr;
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			 xhr.open("GET",blockUrl,false); 
			 xhr.send(null);
			if (xhr.status == 200 && xhr.readyState == 4)
			{					
				var ajaxResult=Trim1(xhr.responseText);
			}
			else
			{
				alert("Problem in Card Eligibility");
				return false;
			}
			ResponseList = ajaxResult.split("~");
			var responseMainCode=ResponseList[0];
			var cardEligibility=ResponseList[1];
			if(cardEligibility=='Y')
			{
				cardEligibility="Yes";
				document.getElementById('4_non_eligibility_reasons').value="";
			}
			else
				cardEligibility="No";
			var eligibleAmount=ResponseList[2];
			var salary=ResponseList[3];
			var nonEligibilityReasons=ResponseList[4];
			if(responseMainCode=='0000'){
				document.getElementById('4_card_eligibility').value=cardEligibility;
				document.getElementById('4_eligible_amount').value=eligibleAmount;
				document.getElementById('4_salary').value=salary;
				//document.getElementById('4_non_eligibility_reasons').value=getDecodedValue(nonEligibilityReasons);
				if(cardEligibility=='No')
				{
					var noneligreasons = nonEligibilityReasons.split("-");
					var decodedNonEligReason="";
					var nonEligReasonResp = "";
					var response ="";
								
					var tempnoneligibilityreason="";
					for (i = 0; i < noneligreasons.length; i++) 
					{
						nonEligReasonResp = getSelectResponseAjax('usr_0_srm_btccc_noneligrsn',noneligreasons[i]);
						response = nonEligReasonResp.split("~");
						if(response[0]=='0')
						{
							decodedNonEligReason = response[1];
							tempnoneligibilityreason+=decodedNonEligReason+", ";
						}
						else
						{
							alert("Error in getting non eligibility reason for "+noneligreasons[i]);
							return false;
						}
						
					}
					document.getElementById('4_non_eligibility_reasons').value = tempnoneligibilityreason.substring(0,tempnoneligibilityreason.lastIndexOf(','));
				}
				
				// change for save on this button click
				var colList=document.getElementById('CARD DETAILS_ColumnList').value;
				colList = colList.replace('[','');
				colList = colList.replace(']','');
				var frName="CARD DETAILS";
				if(!ModifyGridValuesOnButtonClick(colList,frName,SubCategoryID))
				{
					return false;
				}
			}
	}
}


function checkSCCardEligibility(event,labelname)
{
	
	var CategoryID = document.getElementById("CategoryID").value;
	var SubCategoryID = document.getElementById("SubCategoryID").value;
	
	
	
	if(CategoryID==1 && SubCategoryID==5){
	
	
	
			/*if(document.getElementById('5_mobile_number').value=='')
			{
				alert("Customer mobile number is mandatory.");
				return false;
			}*/
			//var Purpose = document.getElementById("5_Purpose").value;
			//var PaymentType = getDecodedValue(Purpose);
			
			
				var PaymentType="";
				/*var paymentresp = getSelectResponseAjax('usr_0_srm_sc_purpose_master',document.getElementById("5_Purpose").value.split('%').join('CHARPERCENTAGE').split("&").join("CHARAMPERSAND"));
				var response = paymentresp.split("~");
				if(response[0]=='0')
				{
					PaymentType = response[1];
					//alert("PaymentType : "+PaymentType);
				}
				else
				{
					alert("Error in getting payment type code");
					return false;
				}*/
			
			/*if(document.getElementById("5_Purpose").value=='' 
				||document.getElementById("5_Purpose").value==' ' 
				||document.getElementById("5_Purpose").value=='--Select--')
			{
				alert("Please select Purpose first");
				document.getElementById('5_Purpose').focus();
				return false;
			}*/			
			
			var blockUrl="/webdesktop/CustomForms/SRM_Specific/SRMIntegration.jsp";
			var param = "&CardNumber="+document.getElementById('5_card_no').value+"&CustId="+document.getElementById('5_cif').value+"&CardStatus="+document.getElementById('5_card_status').value+"&AvailableBalance="+document.getElementById('5_available_balance').value+"&AvailableCashBalance="+document.getElementById('5_available_balance_cash').value+"&OverdueAmount="+document.getElementById('5_overdue_amt').value+"&PaymentType="+PaymentType+"&WSNAME=PBO&WS_LogicalName=PBO&CategoryID=1&SubCategoryID=5&IsDoneClicked=N&IsError=N&IsSaved=N&RequestType=SCCardEligibility";
			blockUrl=replaceUrlChars(blockUrl);			
			var ResponseList;	
			var xhr;
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			 xhr.open("POST",blockUrl,false); 
			 xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			 xhr.send(param);
			if (xhr.status == 200 && xhr.readyState == 4)
			{					
				var ajaxResult=Trim1(xhr.responseText);
			}
			else
			{
				alert("Problem in Card Eligibility");
				return false;
			}
			ResponseList = ajaxResult.split("~");
			var responseMainCode=ResponseList[0];
			var cardEligibility=ResponseList[1];
			//alert("cardEligibility : "+cardEligibility);
			if(cardEligibility=='Y')
			{
				cardEligibility="Yes";
				document.getElementById('5_non_eligibility_reasons').value="";
			}
			else
				cardEligibility="No";
			var eligibleAmount=ResponseList[2];
			var salary=ResponseList[3];
			var nonEligibilityReasons=ResponseList[4];
			if(responseMainCode=='0000'){
				document.getElementById('5_card_eligibility').value=cardEligibility;
				document.getElementById('5_eligible_amount').value=eligibleAmount;
				document.getElementById('5_salary').value=salary;
				//document.getElementById('5_non_eligibility_reasons').value=getDecodedValue(nonEligibilityReasons);
				if(cardEligibility=='No')
				{
					var noneligreasons = nonEligibilityReasons.split("-");
					var decodedNonEligReason="";
					var nonEligReasonResp = "";
					var response ="";
								
					var tempnoneligibilityreason="";
					for (i = 0; i < noneligreasons.length; i++) 
					{
						nonEligReasonResp = getSelectResponseAjax('usr_0_srm_btccc_noneligrsn',noneligreasons[i]);
						response = nonEligReasonResp.split("~");
						if(response[0]=='0')
						{
							decodedNonEligReason = response[1];
							tempnoneligibilityreason+=decodedNonEligReason+", ";
						}
						else
						{
							alert("Error in getting non eligibility reason for "+noneligreasons[i]);
							return false;
						}
						
					}
					document.getElementById('5_non_eligibility_reasons').value = tempnoneligibilityreason.substring(0,tempnoneligibilityreason.lastIndexOf(','));
				}
				
				// change for save on this button click
				var colList=document.getElementById('CARD DETAILS_ColumnList').value;
				colList = colList.replace('[','');
				colList = colList.replace(']','');
				var frName="CARD DETAILS";
				if(!ModifyGridValuesOnButtonClick(colList,frName,SubCategoryID))
				{
					return false;
				}
			}
	}
}

function ModifyGridValuesOnButtonClick(columnList,frameName,SubCategoryID)
{
	//alert('ModifyGridValuesOnButtonClick');
	var modifyGridBundleId = document.getElementById(frameName+'_modifyGridBundle').value;
	var tempElementName = frameName+"_"+SubCategoryID+"_gridbundle_";
	var gridRowNum = modifyGridBundleId.substring(tempElementName.length);
	var selGridWIData = document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value;
	
	if(modifyGridBundleId==null || modifyGridBundleId=="")
	{
		alert("Please select a card.");
		return false;
	}
	if(SubCategoryID==3)
	{
		if(!document.getElementById("3_block_card").checked)
		{
		//return true;
		}
	}
	//In this function Write Custom Validation and code	on change of data of grid, populateCustomValue.js
	var CategoryID=document.getElementById("CategoryID").value;
	var valid = customValidationOnSave(columnList,frameName,CategoryID,SubCategoryID);
	if(!valid)
	{
		return valid;
	}
	
	//End In this function Write Custom Validation and code	on change of data of grid, populateCustomValue.js;
	
	var obj = JSON.parse(selGridWIData);
	
	//alert(columnList);
	columnList = columnList.replace(/\s/g, '');
	//alert("after replace "+columnList);
	var arrColumnList = columnList.split(",");
	var len = arrColumnList.length;
	var modifiedListBundle = "";
	var selWIElementData = "";
	var arrSelWIElementData = "";
	var modWIElementData = "";
	var modifiedWIData = "";
	var columnListName = "";
	var columnListValue = "";
	var currGridAttrValue ="";
	var radioButtonSet ="";
	
	
	for (var i = 0; i < len; i++)
	{		
		 modWIElementData = "";
		//alert(arrColumnList[i]); 
		columnListName = document.getElementById(arrColumnList[i]).name;
		columnListValue = document.getElementById(arrColumnList[i]).value;
		
		if(document.getElementById(arrColumnList[i]).type=='checkbox')
		{
			if(document.getElementById(arrColumnList[i]).checked==true)
			{
				columnListValue='Yes';
			}
			else
			{
				columnListValue='No';
			}
		}		
		if(document.getElementById(arrColumnList[i]).type=='select-one')
		{
			if(document.getElementById(arrColumnList[i]).value=='--Select--')
			{
				columnListValue='';
			}
		}
		
		if(document.getElementById(arrColumnList[i]).type=='text')
		{
			if(columnListValue=='')
			{
				columnListValue='';
			}
		}
		
		if(document.getElementById(arrColumnList[i]).type=='radio')
		{
			if(radioButtonSet==columnListName+"_Y")
			{
				continue;
			}
			var myradio = document.getElementsByName(arrColumnList[i]);
			var x = 0;
			var radioButtonChecked = false;
			var radioButtonCheckedValue = '';
			for(x = 0; x < myradio.length; x++)
			{
				if(myradio[x].checked)
				{
					
					radioButtonChecked=true;
					radioButtonCheckedValue=myradio[x].value;
					columnListValue = radioButtonCheckedValue;
					radioButtonSet = columnListName+"_Y";
				}
			}
			if(radioButtonSet!=columnListName+"_Y")
			{
				columnListValue='';
			}
		}
		
		document.getElementById("grid_"+arrColumnList[i]+"_"+gridRowNum).value=columnListValue;
		selWIElementData = obj[arrColumnList[i].replace(SubCategoryID+"_","")];
		arrSelWIElementData = selWIElementData.split("@");
		arrSelWIElementData[gridRowNum]=columnListValue;
		modWIElementData=arrSelWIElementData.join("@");
		obj[arrColumnList[i].replace(SubCategoryID+"_","")]=modWIElementData;
		modifiedListBundle=modifiedListBundle+columnListName+":"+arrColumnList[i]+"#"+columnListValue;
		
		if (i<len-1){
		modifiedListBundle = modifiedListBundle +"~";
		}
		arrSelWIElementData="";
	}
	

	
	var modifiedStrJson = '';
	for(var key in obj){
		var attrName = key;
		var attrValue = obj[key];
		modifiedStrJson += attrName+"#"+attrValue+"~";
	}	
	
	var strJson = JSON.stringify(obj);
	
	modifiedStrJson=modifiedStrJson.substring(0,(modifiedStrJson.lastIndexOf("~")));
	 
	//alert(modifyGridBundleId);
	document.getElementById(modifyGridBundleId).value=modifiedListBundle;
	document.getElementById(frameName+"_"+SubCategoryID+'_gridbundle_WIDATA').value=modifiedStrJson;
	document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value=strJson;
	
	
	if(SubCategoryID=='2' && frameName=='BALANCE TRANSFER DETAILS')
	{
		var OtherGridsColumnList = '2_card_no,2_sub_ref_no_auth,2_auth_code,2_status,2_bt_amount';
		var primaryGridColumnList = '2_rakbank_eligible_card_no,2_sub_ref_no,2_auth_code,2_status,2_bt_amt_req';
		var targetFrame = 'AUTHORIZATION DETAILS';
		ModifyGridValuesInOtherGrid(primaryGridColumnList,OtherGridsColumnList,targetFrame,SubCategoryID,gridRowNum)
	}
	
	if(SubCategoryID=='4' && frameName=='CREDIT CARD CHEQUE DETAILS')
	{
		var OtherGridsColumnList = '4_card_no_1,4_sub_ref_no_auth,4_auth_code,4_status,4_ccc_amount';
		var primaryGridColumnList = '4_rakbank_eligible_card_no,4_sub_ref_no,4_auth_code,4_status,4_ccc_amt_req';
		var targetFrame = 'AUTHORIZATION DETAILS';
		ModifyGridValuesInOtherGrid(primaryGridColumnList,OtherGridsColumnList,targetFrame,SubCategoryID,gridRowNum)
	}
	
	if(SubCategoryID=='5' && frameName=='SMART CASH DETAILS')
	{
		var OtherGridsColumnList = '5_card_no_1,5_sub_ref_no_auth,5_auth_code,5_status,5_sc_amount';
		var primaryGridColumnList = '5_rakbank_eligible_card_no,5_sub_ref_no,5_auth_code,5_status,5_sc_amt_req';
		var targetFrame = 'AUTHORIZATION DETAILS';
		ModifyGridValuesInOtherGrid(primaryGridColumnList,OtherGridsColumnList,targetFrame,SubCategoryID,gridRowNum)
	}
	
		//ClearGridFields(columnList,frameName);
	
	
	return true;
}
function checkSCEligibility(event,labelname)
{
	
	var CategoryID = document.getElementById("CategoryID").value;
	var SubCategoryID = document.getElementById("SubCategoryID").value;
	if(CategoryID==1 && SubCategoryID==5){
		
		if(document.getElementById("5_rakbank_eligible_card_no").value=='' ||document.getElementById("5_rakbank_eligible_card_no").value=='--Select--' ){
			alert("Please enter RAK Eligible Card Number");
			document.getElementById('5_rakbank_eligible_card_no').focus();
			return false;
		}
		if(document.getElementById("5_sc_amt_req").value=='' ||document.getElementById("5_sc_amt_req").value==' ' ){
			alert("Please enter SC Amt Requested");
			document.getElementById('5_sc_amt_req').focus();
			return false;
		}
		/*if(document.getElementById('5_sc_amt_req').value<=1000)
		{
			alert("CCC amount to be greater than AED 1000");
			document.getElementById('5_sc_amt_req').focus();
			return false;	
		}*/		
		if(document.getElementById("5_beneficiary_name").value=='' ||document.getElementById("5_beneficiary_name").value==' ' ){
			alert("Please enter Beneficiary Name");
			document.getElementById('5_beneficiary_name').focus();
			return false;
		}		
		
		if(document.getElementById("5_type_of_smc").value=='' ||document.getElementById("5_type_of_smc").value=='--Select--' ){
			alert("Please select Type of SMC.");
			return false;
		}
		
		if(document.getElementById("5_marketing_code").value=='' 
				||document.getElementById("5_marketing_code").value==' ' 
				||document.getElementById("5_marketing_code").value=='--Select--')
			{
				alert("Please select Marketing Code");
				document.getElementById('5_marketing_code').focus();
				return false;
			}		
		var PaymentMode = document.getElementById("5_payment_by").value;
		var RakBankAccNumber = document.getElementById("5_RakbankAccountNO").value;
		if(PaymentMode == '' || PaymentMode ==' ' || PaymentMode == '--Select--'){
			alert("Please enter Payment By");
			document.getElementById('5_payment_by').focus();
			return false;
		}
		if (PaymentMode == 'Account Transfer')
		{
			if(RakBankAccNumber == '' || RakBankAccNumber ==' ')
			{
				alert("Please enter Rak Bank A/c Number");
				document.getElementById('5_RakbankAccountNO').focus();
				return false;
			}
		}
		if (PaymentMode == 'FTS')
		{
			if ((document.getElementById("5_beneficiary_name").value).length > 35)
			{
				alert("Beneficiary Name field length should not be more than 35 character.");
				document.getElementById('5_beneficiary_name').focus();
				return false;
			}
			if(document.getElementById("5_other_bank_name").value == '' || document.getElementById("5_other_bank_name").value ==' ' || document.getElementById("5_other_bank_name").value =='--Select--')
			{
				alert("Please enter Other Bank Name");
				document.getElementById('5_other_bank_name').focus();
				return false;
			}
			if(document.getElementById("5_other_bank_iban").value == '' || document.getElementById("5_other_bank_iban").value ==' ')
			{
				alert("Please enter IBAN Number");
				document.getElementById('5_other_bank_iban').focus();
				return false;
			}
			if (iBanValidation("5_other_bank_iban") == false)
				return false;
				
			var accNoFromIBAN = document.getElementById("5_other_bank_iban").value; 
			accNoFromIBAN = accNoFromIBAN.substring(10,23);  // AE220400000372057730001
			document.getElementById("5_RakbankAccountNO").value = accNoFromIBAN;
		}		
		
		var PaymentType = '';
		
		var CustId = document.getElementById("5_cif").value;
		var ACCNumber = '';
		var CardCRNNumber = document.getElementById("5_crn_no").value;
		var CardStatus = document.getElementById("5_card_status").value;
		var AvailableBalance = document.getElementById("5_available_balance").value;
		var AvailableCashBalance ='';
		var RequestAmount = document.getElementById("5_sc_amt_req").value;
		var OverdueAmount = document.getElementById("5_overdue_amt").value;
		
		var BeneficiaryName = document.getElementById("5_beneficiary_name").value;
		var MarketingCode = document.getElementById("5_marketing_code").value;
		var paramMarketingCode = '';
		
			var blockUrl="/webdesktop/CustomForms/SRM_Specific/SRMIntegration.jsp";
			var param = "&CustId="+CustId+
			"&CardNumber="+document.getElementById('5_rakbank_eligible_card_no').value+"&RequestAmount="+RequestAmount+"&PaymentType="+PaymentType+"&BeneficiaryName="+BeneficiaryName+"&MarketingCode="+MarketingCode+"&WSNAME=PBO&WS_LogicalName=PBO&CategoryID=1&SubCategoryID=5&IsDoneClicked=N&IsError=N&IsSaved=N&RequestType=SCEligibility&PaymentMode="+PaymentMode+"&RakBankAccNumber="+RakBankAccNumber;
			blockUrl=replaceUrlChars(blockUrl);			
			var ResponseList;	
			var xhr;
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			 xhr.open("POST",blockUrl,false); 
			 xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			 xhr.send(param);
			if (xhr.status == 200 && xhr.readyState == 4)
				{					
					var ajaxResult=Trim1(xhr.responseText);
				}
			else
				{
					alert("Problem in Card Eligibility");
					return false;
				}
			ResponseList = ajaxResult.split("~");
			var responseMainCode=ResponseList[0];
			var cardEligibility=ResponseList[1];
			
			var nonEligibilityReasons=ResponseList[2];
			if(cardEligibility=='Y')
			{
				cardEligibility="Yes";
				document.getElementById('5_v_non_eligibility_reasons').value='';
			}
			else
				cardEligibility="No";
			if(responseMainCode=='0000'){
				document.getElementById('5_eligibility').value=cardEligibility;
				if(cardEligibility=='No')
				{
					var noneligreasons = nonEligibilityReasons.split("-");
					//alert(noneligreasons.length);
					
					var decodedNonEligReason="";
					var nonEligReasonResp = "";
					var response ="";
								
					var tempnoneligibilityreason="";
					for (i = 0; i < noneligreasons.length; i++) 
					{
						nonEligReasonResp = getSelectResponseAjax('usr_0_srm_btccc_noneligrsn',noneligreasons[i]);
						response = nonEligReasonResp.split("~");
						if(response[0]=='0')
						{
							decodedNonEligReason = response[1];
							tempnoneligibilityreason+=decodedNonEligReason+", ";
						}
						else
						{
							alert("Error in getting non eligibility reason for "+noneligreasons[i]);
							return false;
						}
						
					}
					document.getElementById('5_v_non_eligibility_reasons').value = tempnoneligibilityreason.substring(0,tempnoneligibilityreason.lastIndexOf(','));
				}
			}
	}
}

// below function added to validate IBAN Number for CCC and SC
function iBanValidation(fieldname)
{
	var ibanLength = 23;
	var country = 'AE';
	var iban = document.getElementById(fieldname).value;

	if (iban == null || iban == "" ) 
	{
		alert("Enter Beneficiary IBAN to proceed");
		document.getElementById(fieldname).focus();
		return false;
	}
	else
	{				
		if (iban.length != ibanLength)
		{
			alert ("Length of IBAN entered is "+iban.length+" .Length of the iban should be equal to "+ibanLength);
			document.getElementById(fieldname).focus();
			return false;
		}
		if  (iban.length == ibanLength)
		{
			var ibanStatus = isValidIBANNumber(iban);
			if (ibanStatus == false || ibanStatus == 'false')
			{
				alert('This is not a valid IBAN Length/Number.');
				document.getElementById(fieldname).focus();
				return false;
			}
			if (ibanStatus != 1)
			{
				alert('This is not a valid IBAN Number.');
				document.getElementById(fieldname).focus();
				return false;
			}
			if (ibanStatus == 1)
			{
				return true;
			}
		}
	}			
	return true;
}


/*
 * Returns 1 if the IBAN is valid 
 * Returns FALSE if the IBAN's length is not as should be (for CY the IBAN Should be 28 chars long starting with CY )
 * Returns any other number (checksum) when the IBAN is invalid (check digits do not match)
 */
function isValidIBANNumber(input) {
    /*var CODE_LENGTHS = {
        AD: 24, AE: 23, AT: 20, AZ: 28, BA: 20, BE: 16, BG: 22, BH: 22, BR: 29,
        CH: 21, CR: 21, CY: 28, CZ: 24, DE: 22, DK: 18, DO: 28, EE: 20, ES: 24,
        FI: 18, FO: 18, FR: 27, GB: 22, GI: 23, GL: 18, GR: 27, GT: 28, HR: 21,
        HU: 28, IE: 22, IL: 23, IS: 26, IT: 27, JO: 30, KW: 30, KZ: 20, LB: 28,
        LI: 21, LT: 20, LU: 20, LV: 21, MC: 27, MD: 24, ME: 22, MK: 19, MR: 27,
        MT: 31, MU: 30, NL: 18, NO: 15, PK: 24, PL: 28, PS: 29, PT: 25, QA: 29,
        RO: 24, RS: 22, SA: 24, SE: 24, SI: 19, SK: 24, SM: 27, TN: 24, TR: 26
    };*/
	// Checked only for AE Country
	var CODE_LENGTHS = {
        AE: 23
    };
    var iban = String(input).toUpperCase().replace(/[^A-Z0-9]/g, ''), // keep only alphanumeric characters
            code = iban.match(/^([A-Z]{2})(\d{2})([A-Z\d]+)$/), // match and capture (1) the country code, (2) the check digits, and (3) the rest
            digits;
    // check syntax and length
    if (!code || iban.length !== CODE_LENGTHS[code[1]]) {
        return false;
    }
    // rearrange country code and check digits, and convert chars to ints
    digits = (code[3] + code[1] + code[2]).replace(/[A-Z]/g, function (letter) {
        return letter.charCodeAt(0) - 55;
    });
    // final check
    return mod97(digits);
}
function mod97(string) {
    var checksum = string.slice(0, 2), fragment;
    for (var offset = 2; offset < string.length; offset += 7) {
        fragment = String(checksum) + string.substring(offset, offset + 7);
        checksum = parseInt(fragment, 10) % 97;
    }
    return checksum;
}

function checkCCCEligibility(event,labelname)
{
	
	var CategoryID = document.getElementById("CategoryID").value;
	var SubCategoryID = document.getElementById("SubCategoryID").value;
	if(CategoryID==1 && SubCategoryID==4){
		
		if(document.getElementById("4_rakbank_eligible_card_no").value=='' ||document.getElementById("4_rakbank_eligible_card_no").value=='--Select--' ){
			alert("Please enter RAK Eligible Card Number");
			document.getElementById('4_rakbank_eligible_card_no').focus();
			return false;
		}
		if(document.getElementById("4_ccc_amt_req").value=='' ||document.getElementById("4_ccc_amt_req").value==' ' ){
			alert("Please enter CCC Amt Requested");
			document.getElementById('4_ccc_amt_req').focus();
			return false;
		}
		/*if(document.getElementById('4_ccc_amt_req').value<=1000)
		{
			alert("CCC amount to be greater than AED 1000");
			document.getElementById('4_ccc_amt_req').focus();
			return false;	
		}*/		
		if(document.getElementById("4_beneficiary_name").value=='' ||document.getElementById("4_beneficiary_name").value==' ' ){
			alert("Please enter Beneficiary Name");
			document.getElementById('4_beneficiary_name').focus();
			return false;
		}		
		if(document.getElementById("4_marketing_code").value=='' 
				||document.getElementById("4_marketing_code").value==' ' 
				||document.getElementById("4_marketing_code").value=='--Select--')
			{
				alert("Please select Marketing Code");
				document.getElementById('4_marketing_code').focus();
				return false;
			}		

		// Added as part of Smart Cash Changes - PaymentMode is mandatory in Eligibility Check call
		var PaymentMode = document.getElementById("4_payment_by").value;
		var RakBankAccNumber = document.getElementById("4_RakbankAccountNO").value;
		if(PaymentMode == '' || PaymentMode ==' ' || PaymentMode == '--Select--'){
			alert("Please enter Payment By");
			document.getElementById('4_payment_by').focus();
			return false;
		}
		if (PaymentMode == 'Account Transfer')
		{
			if(RakBankAccNumber == '' || RakBankAccNumber ==' ')
			{
				alert("Please enter Rak Bank A/c Number");
				document.getElementById('4_RakbankAccountNO').focus();
				return false;
			}
		}
		
		if(PaymentMode == 'FTS')//CRCCC- OutBound CR-Angad - 02072018
		{
			if(document.getElementById("4_other_bank_name").value=='--Select--' || document.getElementById("4_other_bank_name").value=='')
			{
				alert("Please select other bank name.");
				document.getElementById("4_other_bank_name").focus();
				return false;
			}					
			if(document.getElementById("4_other_bank_iban").value=='')
			{
				alert("Please enter IBAN Number.");
				document.getElementById("4_other_bank_iban").focus();
				return false;
			}
			if (iBanValidation("4_other_bank_iban") == false)
				return false;
			
			var accNoFromIBAN = document.getElementById("4_other_bank_iban").value; 
			accNoFromIBAN = accNoFromIBAN.substring(10,23);  // AE220400000372057730001
			document.getElementById("4_RakbankAccountNO").value = accNoFromIBAN;	
				
			if ((document.getElementById("4_beneficiary_name").value).length > 35)
			{
				alert("Beneficiary Name field length should not be more than 35 character.");
				document.getElementById('4_beneficiary_name').focus();
				return false;
			}	
		}
		//***********************************
		
		/*var Purpose = document.getElementById("4_Purpose").value;*/
		var PaymentType = '';
		/*
		if(Purpose=="Payment of school fees / college fees"){
			PaymentType="PSC";
		}else if(Purpose=="Payment of Rent - in favor of Real Estate Companies only"){
			PaymentType="PRC";
		}else if(Purpose=="Payment of Insurance Premiums - in favor of Insurance Providers or Agents"){
			PaymentType="PIP";		
		}else if(Purpose=="Payment to known Property Developers in Dubai & Abu Dhabi"){
			PaymentType="PDA";		
		}else if(Purpose=="Payment to any Government Departments / Entities"){
			PaymentType="PGE";		
		}else if(Purpose=="Payment to Utility Companies"){
			PaymentType="PUC";		
		}else if(Purpose=="Payment to Auto Dealers"){
			PaymentType="PAD";		
		}else if(Purpose=="If issued in the name of Cardholder (self)"){
			PaymentType="SLF";		
		}else if(Purpose=="Payment to any third party other than those mentioned above"){
			PaymentType="THP";		
		}else{
			PaymentType=Purpose;		
		}*/
		var CustId = document.getElementById("4_cif").value;
		var ACCNumber = '';
		var CardCRNNumber = document.getElementById("4_crn_no").value;
		var CardStatus = document.getElementById("4_card_status").value;
		var AvailableBalance = document.getElementById("4_available_balance").value;
		var AvailableCashBalance ='';
		var RequestAmount = document.getElementById("4_ccc_amt_req").value;
		var OverdueAmount = document.getElementById("4_overdue_amt").value;
		
		var BeneficiaryName = document.getElementById("4_beneficiary_name").value;
		var MarketingCode = document.getElementById("4_marketing_code").value;
		var paramMarketingCode = '';
		
		/*if(MarketingCode=="Islamic - BTE"){
			paramMarketingCode='BTE'
		}else if(MarketingCode=="Conv0% - BTZ"){
			paramMarketingCode='BTZ'
		}else if(MarketingCode=="Conv1.5% - BTE"){
			paramMarketingCode='BTE'
		}else{
			paramMarketingCode=MarketingCode;
		}*/

			var blockUrl="/webdesktop/CustomForms/SRM_Specific/SRMIntegration.jsp?CustId="+CustId+
			"&CardNumber="+document.getElementById('4_rakbank_eligible_card_no').value+"&RequestAmount="+RequestAmount+"&PaymentType="+PaymentType+"&BeneficiaryName="+BeneficiaryName+"&MarketingCode="+MarketingCode+"&WSNAME=PBO&WS_LogicalName=PBO&CategoryID=1&SubCategoryID=4&IsDoneClicked=N&IsError=N&IsSaved=N&RequestType=CCCEligibility&PaymentMode="+PaymentMode+"&RakBankAccNumber="+RakBankAccNumber;
			
			blockUrl=replaceUrlChars(blockUrl);			
			var ResponseList;	
			var xhr;
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			 xhr.open("GET",blockUrl,false); 
			 xhr.send(null);
			if (xhr.status == 200 && xhr.readyState == 4)
			{					
				var ajaxResult=Trim1(xhr.responseText);
			}
			else
			{
				alert("Problem in Card Eligibility");
				return false;
			}
			ResponseList = ajaxResult.split("~");
			var responseMainCode=ResponseList[0];
			var cardEligibility=ResponseList[1];
			var nonEligibilityReasons=ResponseList[2];
			if(cardEligibility=='Y')
			{
				cardEligibility="Yes";
				document.getElementById('4_v_non_eligibility_reasons').value='';
			}
			else
				cardEligibility="No";
			if(responseMainCode=='0000'){
				document.getElementById('4_eligibility').value=cardEligibility;
				if(cardEligibility=='No')
				{
					var noneligreasons = nonEligibilityReasons.split("-");
					//alert(noneligreasons.length);
					
					var decodedNonEligReason="";
					var nonEligReasonResp = "";
					var response ="";
								
					var tempnoneligibilityreason="";
					for (i = 0; i < noneligreasons.length; i++) 
					{
						nonEligReasonResp = getSelectResponseAjax('usr_0_srm_btccc_noneligrsn',noneligreasons[i]);
						response = nonEligReasonResp.split("~");
						if(response[0]=='0')
						{
							decodedNonEligReason = response[1];
							tempnoneligibilityreason+=decodedNonEligReason+", ";
						}
						else
						{
							alert("Error in getting non eligibility reason for "+noneligreasons[i]);
							return false;
						}
						
					}
					document.getElementById('4_v_non_eligibility_reasons').value = tempnoneligibilityreason.substring(0,tempnoneligibilityreason.lastIndexOf(','));
				}
			}
	}
}
function CancelSC(event,labelname)
{
	var rowindex = document.getElementById("AUTHORIZATION DETAILS_5_gridselrowindex").value;
	var myradio1 = document.getElementsByName('5_manual_blocking_action');
	var y = 0;
	var ManualBlockingActionChecked = false;
	var ManualBlockingActionValue = '';
	for(y = 0; y < myradio1.length; y++)
	{
		if(myradio1[y].checked)
		{
			ManualBlockingActionChecked=true;
			ManualBlockingActionValue=myradio1[y].value;
		}
	}
	if(rowindex==null || rowindex==""){
		alert("Please select a grid for a card to Cancel");
		return false;
	}	
	
	if(document.getElementById("5_status").value!='Successful' && document.getElementById("5_sub_ref_no_auth").value!='')// prateek
	{
		if(ManualBlockingActionValue=='Manual Blocking Not Done')
		{
			alert("The case cannot be cancelled as manual blocking was not done.");
			return false;
		}
		else
		{
			alert("This card was blocked manually. It can be unblocked manually only.");
			return false;
		}
	}
	if(document.getElementById("5_cancel_status").value=='Cancelled')// prateek
	{
		alert("Cancellation has already done for this card.");
		return false;
	}
	
	var CategoryID = document.getElementById("CategoryID").value;
	var SubCategoryID = document.getElementById("SubCategoryID").value;
		if(CategoryID==1 && SubCategoryID==5){
		
		if(!confirm('Case with '+document.getElementById("5_sub_ref_no_auth").value+' would be cancelled. Do you want to continue?')) 
			{
				return false;
			}
		if(document.getElementById("5_cancellation_remarks").value=='' || document.getElementById("5_cancellation_remarks").value==' ')
		{
			alert("Please enter Cancellation Remarks");
			document.getElementById('5_cancellation_remarks').focus();
			return false;
		}
		
			var TrnRqUID = document.getElementById("5_tran_req_uid").value;
			var ApprovalId = document.getElementById("5_Approval_cd").value;
			var DebitAuthId = document.getElementById("5_auth_code").value;
			
			var CardDetailsJSON_WIDATA = document.getElementById("CARD DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
			var objCardDetails = JSON.parse(CardDetailsJSON_WIDATA);
			var cardNo = objCardDetails["card_no"];
			cardNo  = cardNo.replace("@"," @ ");
			var arrCardNo = cardNo.split("@");
			
			var CRNNo = objCardDetails["crn_no"];
			CRNNo  = CRNNo.replace("@"," @ ");
			var arrCRNNo = CRNNo.split("@");
			var AuthCRNNo = '';
			
			var ExpiryDate = objCardDetails["expiry"];
			ExpiryDate  = ExpiryDate.replace("@"," @ ");
			var arrExpiryDate = ExpiryDate.split("@");
			var AuthExpiryDate = '';
			
			//code added to pass merchant code and processing code in cancelcall 
			//var purpose = objCardDetails["type_of_smc"];
			//var arrPurpose = purpose.split("@");
			//var AuthPurpose = '';
			var MerchantCode= '';
			
			
			
			rowindex=rowindex-1;
			var AuthRemarks = document.getElementById('grid_5_remarks_'+rowindex).value;
			
			for(var i=0;i<arrCardNo.length;i++){
				if(arrCardNo[i].replace(/^\s+|\s+$/gm,'')==document.getElementById('5_card_no_1').value){
					AuthCRNNo = arrCRNNo[i];
					AuthExpiryDate = arrExpiryDate[i];
					//AuthPurpose = arrPurpose[i];
				}
			}
			/*if(AuthPurpose=='If issued in the name of Cardholder (self)' || AuthPurpose=='Payment to any third party other than those mentioned above')
				MerchantCode='0400';
			else
				MerchantCode='0200';*/
			
			var blockUrl="/webdesktop/CustomForms/SRM_Specific/SRMIntegration.jsp"
			var param = "&CardNumber="+document.getElementById('5_card_no_1').value+"&CustId="+document.getElementById('5_cif').value+"&CardCRNNumber="+AuthCRNNo.replace(/^\s+|\s+$/gm,'')+"&Amount="+document.getElementById('5_sc_amount').value+"&CardExpiryDate="+AuthExpiryDate.replace(/^\s+|\s+$/gm,'')+"&Remarks="+AuthRemarks.replace(/^\s+|\s+$/gm,'')+"&TrnRqUID="+TrnRqUID+"&ApprovalId="+DebitAuthId+"&DebitAuthId="+ApprovalId+"&TrnType=Reversal&WSNAME=Q1&WS_LogicalName=Interim Queue&CategoryID=1&SubCategoryID=5&IsDoneClicked=N&IsError=N&IsSaved=N&RequestType=FUND_BLOCK_ON_CREDIT_CARD&MerchantCode="+MerchantCode;
			blockUrl=replaceUrlChars(blockUrl);			
			var ResponseList;	
			var xhr;
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			 xhr.open("POST",blockUrl,false); 
			 xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			 xhr.send(param);
			if (xhr.status == 200 && xhr.readyState == 4)
			{					
				var ajaxResult=Trim1(xhr.responseText);
			}
			else
			{
				alert("Problem in Amount Block Cancellation");
				return false;
			}
			ResponseList = ajaxResult.split("~");
			var responseMainCode=ResponseList[0];
			var AuthCode=ResponseList[3];
			var AuthStatus=ResponseList[2];
			var TransReqUID=ResponseList[1];
			var ApprovalID=ResponseList[4];
			var CancelStatus="";
			
			if(responseMainCode=='0000')
			{
				alert("Fund Unblock in Online Successful.");
				CancelStatus="Cancelled";				
				var updateForSMS="/webdesktop/CustomForms/SRM_Specific/SRMCustomUpdate.jsp?WINAME="+document.getElementById('WINAME').value+"&UpdateFor=CancelRequestSMS";
			
			
				updateForSMS=replaceUrlChars(updateForSMS);			
				var ResponseList;	
				var xhr;
				if(window.XMLHttpRequest)
					 xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
					 xhr=new ActiveXObject("Microsoft.XMLHTTP");
				 xhr.open("GET",updateForSMS,false); 
				 xhr.send(null);
				if (xhr.status == 200 && xhr.readyState == 4)
				{					
					var ajaxResult=Trim1(xhr.responseText);
				}
				else
				{
					alert("Problem in Sending SMS for Cancellation");
					return false;
				}
			}
			else
			{
				alert("Fund Unblock in Online Unsuccessful. Please unblock the funds manually.");
				CancelStatus="Not Cancelled";				
			}			
			document.getElementById('5_auth_code').value=AuthCode;
			document.getElementById('5_status').value=AuthStatus;
			document.getElementById('5_tran_req_uid').value=TransReqUID;
			document.getElementById('5_approval_cd').value=ApprovalID;
			document.getElementById('5_cancel_status').value=CancelStatus;
			if(document.getElementById("5_status").value!='Successful' && document.getElementById("5_status").value!='' && document.getElementById("5_status").value!=' ')
			{
				document.getElementById("5_auth_code").disabled=false;
			}else{
				document.getElementById("5_auth_code").disabled=true;
			}			
			
		ModifyGridValues('5_sub_ref_no_auth, 5_card_no_1, 5_auth_code, 5_status, 5_sc_amount, 5_cancel_status, 5_cancellation_remarks, 5_req_upld_status, 5_tran_req_uid, 5_Approval_cd','AUTHORIZATION DETAILS','5');	
			
	}	
}
function CancelCCC(event,labelname)
{
	var rowindex = document.getElementById("AUTHORIZATION DETAILS_4_gridselrowindex").value;
	var myradio1 = document.getElementsByName('4_manual_blocking_action');
	var y = 0;
	var ManualBlockingActionChecked = false;
	var ManualBlockingActionValue = '';
	for(y = 0; y < myradio1.length; y++)
	{
		if(myradio1[y].checked)
		{
			ManualBlockingActionChecked=true;
			ManualBlockingActionValue=myradio1[y].value;
		}
	}
	if(rowindex==null || rowindex==""){
		alert("Please select a grid for a card to Cancel");
		return false;
	}	
	
	if(document.getElementById("4_status").value!='Successful' && document.getElementById("4_sub_ref_no_auth").value!='')// prateek
	{
		if(ManualBlockingActionValue=='Manual Blocking Not Done')
		{
			alert("The case cannot be cancelled as manual blocking was not done.");
			return false;
		}
		else
		{
			alert("This card was blocked manually. It can be unblocked manually only.");
			return false;
		}
	}
	if(document.getElementById("4_cancel_status").value=='Cancelled')// prateek
	{
		alert("Cancellation has already done for this card.");
		return false;
	}
	
	var CategoryID = document.getElementById("CategoryID").value;
	var SubCategoryID = document.getElementById("SubCategoryID").value;
		if(CategoryID==1 && SubCategoryID==4){
		
		if(!confirm('Case with '+document.getElementById("4_sub_ref_no_auth").value+' would be cancelled. Do you want to continue?')) 
			{
				return false;
			}
		if(document.getElementById("4_cancellation_remarks").value=='' || document.getElementById("4_cancellation_remarks").value==' ')
		{
			alert("Please enter Cancellation Remarks");
			document.getElementById('4_cancellation_remarks').focus();
			return false;
		}
		
			var TrnRqUID = document.getElementById("4_tran_req_uid").value;
			var ApprovalId = document.getElementById("4_Approval_cd").value;
			var DebitAuthId = document.getElementById("4_auth_code").value;
			
			var CardDetailsJSON_WIDATA = document.getElementById("CARD DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
			var objCardDetails = JSON.parse(CardDetailsJSON_WIDATA);
			var cardNo = objCardDetails["card_no"];
			cardNo  = cardNo.replace("@"," @ ");
			var arrCardNo = cardNo.split("@");
			
			var CRNNo = objCardDetails["crn_no"];
			CRNNo  = CRNNo.replace("@"," @ ");
			var arrCRNNo = CRNNo.split("@");
			var AuthCRNNo = '';
			
			var ExpiryDate = objCardDetails["expiry"];
			ExpiryDate  = ExpiryDate.replace("@"," @ ");
			var arrExpiryDate = ExpiryDate.split("@");
			var AuthExpiryDate = '';
			
			//code added to pass merchant code and processing code in cancelcall 
			var purpose = objCardDetails["Purpose"];
			var arrPurpose = purpose.split("@");
			var AuthPurpose = '';
			var MerchantCode= '';
			
			
			
			rowindex=rowindex-1;
			var AuthRemarks = document.getElementById('grid_4_remarks_'+rowindex).value;
			
			for(var i=0;i<arrCardNo.length;i++){
				if(arrCardNo[i].replace(/^\s+|\s+$/gm,'')==document.getElementById('4_card_no_1').value){
					AuthCRNNo = arrCRNNo[i];
					AuthExpiryDate = arrExpiryDate[i];
					AuthPurpose = arrPurpose[i];
				}
			}
			if(AuthPurpose=='If issued in the name of Cardholder (self)' || AuthPurpose=='Payment to any third party other than those mentioned above')
				MerchantCode='0400';
			else
				MerchantCode='0200';
			
			var blockUrl="/webdesktop/CustomForms/SRM_Specific/SRMIntegration.jsp?CardNumber="+document.getElementById('4_card_no_1').value+"&CustId="+document.getElementById('4_cif').value+"&CardCRNNumber="+AuthCRNNo.replace(/^\s+|\s+$/gm,'')+"&Amount="+document.getElementById('4_ccc_amount').value+"&CardExpiryDate="+AuthExpiryDate.replace(/^\s+|\s+$/gm,'')+"&Remarks="+AuthRemarks.replace(/^\s+|\s+$/gm,'')+"&TrnRqUID="+TrnRqUID+"&ApprovalId="+DebitAuthId+"&DebitAuthId="+ApprovalId+"&TrnType=Reversal&WSNAME=Q1&WS_LogicalName=Interim Queue&CategoryID=1&SubCategoryID=4&IsDoneClicked=N&IsError=N&IsSaved=N&RequestType=FUND_BLOCK_ON_CREDIT_CARD&MerchantCode="+MerchantCode;
		
			blockUrl=replaceUrlChars(blockUrl);			
			var ResponseList;	
			var xhr;
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			 xhr.open("GET",blockUrl,false); 
			 xhr.send(null);
			if (xhr.status == 200 && xhr.readyState == 4)
			{					
				var ajaxResult=Trim1(xhr.responseText);
			}
			else
			{
				alert("Problem in Amount Block Cancellation");
				return false;
			}
			ResponseList = ajaxResult.split("~");
			var responseMainCode=ResponseList[0];
			var AuthCode=ResponseList[3];
			var AuthStatus=ResponseList[2];
			var TransReqUID=ResponseList[1];
			var ApprovalID=ResponseList[4];
			var CancelStatus="";
			
			if(responseMainCode=='0000')
			{
				alert("Fund Unblock in Online Successful.");
				CancelStatus="Cancelled";				
				var updateForSMS="/webdesktop/CustomForms/SRM_Specific/SRMCustomUpdate.jsp?WINAME="+document.getElementById('WINAME').value+"&UpdateFor=CancelRequestSMS";
			
			
				updateForSMS=replaceUrlChars(updateForSMS);			
				var ResponseList;	
				var xhr;
				if(window.XMLHttpRequest)
					 xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
					 xhr=new ActiveXObject("Microsoft.XMLHTTP");
				 xhr.open("GET",updateForSMS,false); 
				 xhr.send(null);
				if (xhr.status == 200 && xhr.readyState == 4)
				{					
					var ajaxResult=Trim1(xhr.responseText);
				}
				else
				{
					alert("Problem in Sending SMS for Cancellation");
					return false;
				}
			}
			else
			{
				alert("Fund Unblock in Online Unsuccessful. Please unblock the funds manually.");
				CancelStatus="Not Cancelled";				
			}			
			document.getElementById('4_auth_code').value=AuthCode;
			document.getElementById('4_status').value=AuthStatus;
			document.getElementById('4_tran_req_uid').value=TransReqUID;
			document.getElementById('4_Approval_cd').value=ApprovalID;
			document.getElementById('4_cancel_status').value=CancelStatus;
			if(document.getElementById("4_status").value!='Successful' && document.getElementById("4_status").value!='' && document.getElementById("4_status").value!=' ')
			{
				document.getElementById("4_auth_code").disabled=false;
			}else{
				document.getElementById("4_auth_code").disabled=true;
			}			
			
		ModifyGridValues('4_sub_ref_no_auth, 4_card_no_1, 4_auth_code, 4_status, 4_ccc_amount, 4_cancel_status, 4_cancellation_remarks, 4_req_upld_status, 4_tran_req_uid, 4_Approval_cd','AUTHORIZATION DETAILS','4');	
			
	}	
}


function CancelBT(event,labelname)
{
	var rowindex = document.getElementById("AUTHORIZATION DETAILS_2_gridselrowindex").value;
	var myradio1 = document.getElementsByName('2_manual_blocking_action');
	var y = 0;
	var ManualBlockingActionChecked = false;
	var ManualBlockingActionValue = '';
	for(y = 0; y < myradio1.length; y++)
	{
		if(myradio1[y].checked)
		{
			ManualBlockingActionChecked=true;
			ManualBlockingActionValue=myradio1[y].value;
		}
	}
	
	if(rowindex==null || rowindex==""){
		alert("Please select a grid for a card to Cancel");
		return false;
	}
	if(document.getElementById("2_status").value!='Successful' && document.getElementById("2_sub_ref_no_auth").value!='')// prateek
	{
		if(ManualBlockingActionValue=='Manual Blocking Not Done')
		{
			alert("The case cannot be cancelled as manual blocking was not done.");
			return false;
		}
		else
		{
			alert("This card was blocked manually. It can be unblocked manually only.");
			return false;
		}
	}
	if(document.getElementById("2_cancel_status").value=='Cancelled')// prateek
	{
		alert("Cancellation has already done for this card.");
		return false;
	}
	
	var CategoryID = document.getElementById("CategoryID").value;
	var SubCategoryID = document.getElementById("SubCategoryID").value;
		if(CategoryID==1 && SubCategoryID==2){
			
			if(!confirm('Case with '+document.getElementById("2_sub_ref_no_auth").value+' would be cancelled. Do you want to continue?')) 
			{
				return false;
			}
			if(document.getElementById("2_cancellation_remarks").value=='' || document.getElementById("2_cancellation_remarks").value==' ')
			{
				alert("Please enter Cancellation Remarks");
				document.getElementById('2_cancellation_remarks').focus();
				return false;
			}
			var TrnRqUID = document.getElementById("2_tran_req_uid").value;
			var ApprovalId = document.getElementById("2_Approval_cd").value;
			var DebitAuthId = document.getElementById("2_auth_code").value;
			var CardDetailsJSON_WIDATA = document.getElementById("CARD DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
			var objCardDetails = JSON.parse(CardDetailsJSON_WIDATA);
			var cardNo = objCardDetails["rak_card_no"];
			cardNo  = cardNo.replace("@"," @ ");
			var arrCardNo = cardNo.split("@");
			
			var CRNNo = objCardDetails["crn_no"];
			CRNNo  = CRNNo.replace("@"," @ ");
			var arrCRNNo = CRNNo.split("@");
			var AuthCRNNo = '';
			
			var ExpiryDate = objCardDetails["expiry"];
			ExpiryDate  = ExpiryDate.replace("@"," @ ");
			var arrExpiryDate = ExpiryDate.split("@");
			var AuthExpiryDate = '';
			
			
			rowindex=rowindex-1;
			var AuthRemarks = document.getElementById('grid_2_remarks_'+rowindex).value;
			for(var i=0;i<arrCardNo.length;i++){
				if(arrCardNo[i].replace(/^\s+|\s+$/gm,'')==document.getElementById('2_card_no').value){
					AuthCRNNo = arrCRNNo[i];
					AuthExpiryDate = arrExpiryDate[i];
					
				}
			}
			
			
			var blockUrl="/webdesktop/CustomForms/SRM_Specific/SRMIntegration.jsp?CardNumber="+document.getElementById('2_card_no').value+"&CustId="+document.getElementById('2_cif').value+"&CardCRNNumber="+AuthCRNNo.replace(/^\s+|\s+$/gm,'')+"&Amount="+document.getElementById('2_bt_amount').value+"&CardExpiryDate="+AuthExpiryDate.replace(/^\s+|\s+$/gm,'')+"&Remarks="+AuthRemarks.replace(/^\s+|\s+$/gm,'')+"&TrnRqUID="+TrnRqUID+"&ApprovalId="+DebitAuthId+"&DebitAuthId="+ApprovalId+"&TrnType=Reversal&WSNAME=Q1&WS_LogicalName=Interim Queue&CategoryID=1&SubCategoryID=2&IsDoneClicked=N&IsError=N&IsSaved=N&RequestType=FUND_BLOCK_ON_CREDIT_CARD";
			
			
			blockUrl=replaceUrlChars(blockUrl);			
			var ResponseList;	
			var xhr;
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			 xhr.open("GET",blockUrl,false); 
			 xhr.send(null);
			if (xhr.status == 200 && xhr.readyState == 4)
			{					
				var ajaxResult=Trim1(xhr.responseText);
			}
			else
			{
				alert("Problem in Amount Block Cancellation");
				return false;
			}
			ResponseList = ajaxResult.split("~");
			var responseMainCode=ResponseList[0];
			var AuthCode=ResponseList[3];
			var AuthStatus=ResponseList[2];
			var ApprovalID=ResponseList[1];
			var TransReqUID=ResponseList[4];
			
			var CancelStatus="";
			
			if(responseMainCode=='0000')
			{
				alert("Fund Unblock in Online Successful.");
				CancelStatus="Cancelled";
			
			}
			else
			{
				alert("Fund Unblock in Online Unsuccessful. Please unblock the funds manually.");
				CancelStatus="Not Cancelled";
				
			}
			
			document.getElementById('2_auth_code').value=AuthCode;
			document.getElementById('2_status').value=AuthStatus;
			document.getElementById('2_tran_req_uid').value=TransReqUID;
			document.getElementById('2_approval_cd').value=ApprovalID;
			document.getElementById('2_cancel_status').value=CancelStatus;
			
			if((document.getElementById("2_sub_ref_no_auth").value).replace(/^\s+|\s+$/gm,'')!='' && document.getElementById("2_status").value=='Successful' )// prateek
			{
				document.getElementById("2_auth_code").disabled=false;
			}
			else
			{
				document.getElementById("2_auth_code").disabled=true;
			}			
			
		ModifyGridValues('2_sub_ref_no_auth, 2_card_no, 2_auth_code, 2_status, 2_bt_amount, 2_cancel_status, 2_cancellation_remarks,  2_req_upld_status, 2_tran_req_uid, 2_Approval_cd','AUTHORIZATION DETAILS','2');
	}	
}

function generateSubRefNo(frameName,SubCategoryID){
	var selGridWIData = document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value;
	var obj = JSON.parse(selGridWIData);
	var valueSubRefNo = obj['sub_ref_no'];
	var arrValueSubRefNo = valueSubRefNo.split("@");
	var arrValueSubRefNoLength = arrValueSubRefNo.length;
	var runningNo = '';
	var runNo = '';
	if(arrValueSubRefNo[arrValueSubRefNoLength-1]!='$-$')
	{	
		runningNo = "1"+arrValueSubRefNo[arrValueSubRefNoLength-1];
		runningNo=parseInt(runningNo)+1;
		runNo=runningNo +'';
		runningNo=runNo.substring(1,5);
		document.getElementById(SubCategoryID+'_sub_ref_no').value=runningNo;
	}else
	{
		document.getElementById(SubCategoryID+'_sub_ref_no').value="0001";
	}
}

function generateSubRefNoOnSave(frameName,SubCategoryID)
{
	var selGridWIData = document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value;
	var obj = JSON.parse(selGridWIData);
	var valueSubRefNo = obj['sub_ref_no'];
	var arrValueSubRefNo = valueSubRefNo.split("@");
	var runningNo;
	len = arrValueSubRefNo.length;
	var maxSubRefNo = "";
	
	for (var i = 0; i < len; i++)
		{	 
			if(i==0){
				if(arrValueSubRefNo[i].replace(/^\s+|\s+$/gm,'')!=''){
					maxSubRefNo =  arrValueSubRefNo[i].replace(/^\s+|\s+$/gm,'');
				}
			}else{
				if(arrValueSubRefNo[i].replace(/^\s+|\s+$/gm,'')!='' && maxSubRefNo <  arrValueSubRefNo[i]){
					maxSubRefNo =  arrValueSubRefNo[i].replace(/^\s+|\s+$/gm,'');
				}
			}
		}
	if(maxSubRefNo==""){
		runningNo = '0001';
		if((document.getElementById(SubCategoryID+'_sub_ref_no').value).replace(/^\s+|\s+$/gm,'')=='')
		{
			document.getElementById(SubCategoryID+'_sub_ref_no').value=runningNo;
		}
	}else{
		runningNo = "1"+maxSubRefNo;
		runningNo=parseInt(runningNo)+1;
		runNo=runningNo +'';
		runningNo=runNo.substring(1,5);
		if((document.getElementById(SubCategoryID+'_sub_ref_no').value).replace(/^\s+|\s+$/gm,'')=='')
		{
			document.getElementById(SubCategoryID+'_sub_ref_no').value=runningNo;
		}
	}
}

function mod10( cardNumber ) 
	{ 	
           var clen = new Array( cardNumber.length ); 
           var n = 0,sum = 0; 
           for( n = 0; n < cardNumber.length; ++n ) 
		      { 
                      clen [n] = parseInt ( cardNumber.charAt(n) ); 
			  } 
          for( n = clen.length -2; n >= 0; n-=2 ) 
				{
					  clen [n] *= 2; 	
			          if( clen [n] > 9 ) 
				          clen [n]-=9; 
				}
 
	     for( n = 0; n < clen.length; ++n ) 
		        { 
					  sum += clen [n]; 
		        } 
		 return(((sum%10)==0)?true : false);
	}
	
	function replaceUrlChars(sUrl)
	{	
		return sUrl.split("+").join("ENCODEDPLUS");
	}

function checkCBREligibility(fobj)
{
	//alert("calling check eligibility cbr function");
	var CardNo_Masked = document.getElementById("CardNo_Masked").value;
	
	var Keyid = document.getElementById("PANno").value.split("+").join("ENCODEDPLUS");
	var Card_Status = fobj.getElementById("1_CCI_CStatus").value;
	var Card_SubType = fobj.getElementById("1_CCI_CST").value;
	var Requested_Cash_Back_Amount=parseInt(fobj.getElementById("1_Requested_Cash_Back_Amount").value);
	//alert("Requested_Cash_Back_Amount"+Requested_Cash_Back_Amount);
	var Cash_Back_Eligible_Amount=parseInt(fobj.getElementById("1_Cash_Back_Eligible_Amount").value);
	var Tr_Table = fobj.getElementById("tr_table").value;	
	var CBLimiAamount="";
	var EligibilityCheck;
	var Temp_WI_NAME=document.getElementById("TEMPWINAME").value;
	var IsError= true;
	
	var xhr;

	if(window.XMLHttpRequest)  xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)  xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	var url="/webdesktop/CustomForms/SRM_Specific/Custom_Validation_CBR.jsp?PANno="+Keyid+"&WINAME="+Temp_WI_NAME+"&tr_table="+Tr_Table+"&cardsubtype="+Card_SubType+"&cardstatus="+Card_Status+"&WSNAME=PBO&IsDoneClicked=false&amount="+Requested_Cash_Back_Amount;

	
	xhr.open("GET",url,false); 
	xhr.send(null);
	if (xhr.status == 200 && xhr.readyState == 4)
	{
		ajaxResult=myTrim1(xhr.responseText);
		//alert(ajaxResult);
		EligibilityCheck = ajaxResult.split("~");
		if(parseInt(EligibilityCheck[2])!=0)
		{
			fobj.getElementById("1_Non_Eligibility_Reason").value="Card Status - "+Card_Status+" - Customer is not eligible for Cash Back Redemption";
			fobj.getElementById("1_Requested_Cash_Back_Amount").value='';
			fobj.getElementById("1_Approved_Cash_Back_Amount").value='';
			fobj.getElementById("1_IsError").value='Y';
			fobj.getElementById("1_Cash_Back_Eligibility").value="N";
		}
		//checking subtype
		else if(parseInt(EligibilityCheck[3])!=0)
		{
			fobj.getElementById("1_Non_Eligibility_Reason").value="Card Sub Type - "+Card_SubType+" - Customer is not eligible for Cash Back Redemption";
			fobj.getElementById("1_Requested_Cash_Back_Amount").value='';
			fobj.getElementById("1_Approved_Cash_Back_Amount").value='';
			fobj.getElementById("1_IsError").value='Y';
			fobj.getElementById("1_Cash_Back_Eligibility").value="N";
		}					
		fobj.getElementById("1_Is_Prime_Up").value=EligibilityCheck[4];
		fobj.getElementById("1_Cardno_Masked").value=CardNo_Masked;
		fobj.getElementById("1_IsPrimeUpdated").value="N";
		
		if(fobj.getElementById("1_IsError").value==''||fobj.getElementById("1_IsError").value=='N'||fobj.getElementById("1_IsError").value=='NULL')
		{
			if(parseInt(fobj.getElementById("1_Cash_Back_Eligible_Amount").value)<=0)
			{
				fobj.getElementById("1_Requested_Cash_Back_Amount").value='';
				fobj.getElementById("1_Approved_Cash_Back_Amount").value='';
				fobj.getElementById("1_Non_Eligibility_Reason").value="Available Redemption Amount is either less than or equal to Zero.";
				fobj.getElementById("1_Cash_Back_Eligibility").value="N";
				IsError=false;
			}
			else if(parseInt(fobj.getElementById("1_Cash_Back_Eligible_Amount").value)<parseInt(fobj.getElementById("CashBackLimit").value))
			{	
				fobj.getElementById("1_Requested_Cash_Back_Amount").value='';
				fobj.getElementById("1_Approved_Cash_Back_Amount").value='';
				fobj.getElementById("1_Non_Eligibility_Reason").value="Cash Back Eligibile Amount is less than "+fobj.getElementById("CashBackLimit").value+".";
				fobj.getElementById("1_Cash_Back_Eligibility").value="N";
				IsError=false;
			}
			else if(fobj.getElementById("1_Account_Category").value=='Secondary' && fobj.getElementById("1_CCI_CT").value=='Credit Card')
			{
				fobj.getElementById("1_Requested_Cash_Back_Amount").value='';
				fobj.getElementById("1_Approved_Cash_Back_Amount").value='';
				fobj.getElementById("1_Non_Eligibility_Reason").value="Not a Primary Card Customer - Customer is not eligible for Cash Back Redemption.";
				fobj.getElementById("1_Cash_Back_Eligibility").value="N";
				IsError=false;
			}
		}
		CBLimiAamount=parseInt(EligibilityCheck[5]);
		if(parseInt(fobj.getElementById("1_Approved_Cash_Back_Amount").value)<=CBLimiAamount && (fobj.getElementById("1_IsError").value==''||fobj.getElementById("1_IsError").value=='N'||fobj.getElementById("1_IsError").value=='NULL') && fobj.getElementById("1_Cash_Back_Forfeited").value=='N' && fobj.getElementById("1_Disputed_Transaction").value=='N')
		{
			fobj.getElementById("1_IsSTP").value="Y";
		}
		else 
			fobj.getElementById("1_IsSTP").value="N";
		if(!IsError)
		{
			if(parseInt(fobj.getElementById("1_Requested_Cash_Back_Amount").value)>parseInt(fobj.getElementById("1_Cash_Back_Eligible_Amount").value))
			{	
				if(parseInt(fobj.getElementById("1_Cash_Back_Eligible_Amount").value)>parseInt(fobj.getElementById("CashBackLimit").value))
				{	
					//alert("Here");
					alert("Requested Cash Back Amount cannot be greater than "+fobj.getElementById("1_Cash_Back_Eligible_Amount").value);
					fobj.getElementById("1_Requested_Cash_Back_Amount").value=fobj.getElementById("1_Cash_Back_Eligible_Amount").value;
					fobj.getElementById("1_Approved_Cash_Back_Amount").value=fobj.getElementById("1_Cash_Back_Eligible_Amount").value;
					fobj.getElementById("1_Requested_Cash_Back_Amount").focus();
					return false;
				}
			}
			else				
			{	
				if(parseInt(fobj.getElementById("1_Requested_Cash_Back_Amount").value)<parseInt(fobj.getElementById("CashBackLimit").value))
				{	
					alert("Requested Cash Back Amount cannot be less than "+fobj.getElementById("CashBackLimit").value); 
					fobj.getElementById("1_Requested_Cash_Back_Amount").focus();
					fobj.getElementById("1_Requested_Cash_Back_Amount").value=fobj.getElementById("1_Cash_Back_Eligible_Amount").value;
					fobj.getElementById("1_Approved_Cash_Back_Amount").value=fobj.getElementById("1_Cash_Back_Eligible_Amount").value;
					return false;
				}
				else
					fobj.getElementById("1_Approved_Cash_Back_Amount").value=fobj.getElementById("1_Requested_Cash_Back_Amount").value;
			}
			alert("Customer is not eligible for Cash Back Redemption");
			fobj.getElementById("1_IsError").value="Y";
			return false;
		}
		else
		{
			if(parseInt(fobj.getElementById("1_Requested_Cash_Back_Amount").value)>parseInt(fobj.getElementById("1_Cash_Back_Eligible_Amount").value))
			{	
				//alert("from populatecustomvalue");
				alert("Requested Cash Back Amount cannot be greater than "+fobj.getElementById("1_Cash_Back_Eligible_Amount").value);
				fobj.getElementById("1_Requested_Cash_Back_Amount").value=fobj.getElementById("1_Cash_Back_Eligible_Amount").value;
				fobj.getElementById("1_Approved_Cash_Back_Amount").value=fobj.getElementById("1_Cash_Back_Eligible_Amount").value;
				fobj.getElementById("1_Requested_Cash_Back_Amount").focus();
				return false;
			}
			else				
			{	
				if(parseInt(fobj.getElementById("1_Requested_Cash_Back_Amount").value)<parseInt(fobj.getElementById("CashBackLimit").value))
				{	
					alert("Requested Cash Back Amount cannot be less than "+fobj.getElementById("CashBackLimit").value);
					fobj.getElementById("1_Requested_Cash_Back_Amount").focus();
					fobj.getElementById("1_Requested_Cash_Back_Amount").value=fobj.getElementById("1_Cash_Back_Eligible_Amount").value;
					fobj.getElementById("1_Approved_Cash_Back_Amount").value=fobj.getElementById("1_Cash_Back_Eligible_Amount").value;
					return false;
				}
				else 
					fobj.getElementById("1_Approved_Cash_Back_Amount").value=fobj.getElementById("1_Requested_Cash_Back_Amount").value;
			}
			
			if(fobj.getElementById("1_IsError").value!='Y')
			{	
				fobj.getElementById("1_IsError").value="N";
				fobj.getElementById("1_Cash_Back_Eligibility").value="Y";
			}
			else
			{
				alert("Customer is not eligible for Cash Back Redemption");
				return false;
			}
		}
	}
	else
	{
		alert("Error in Eligibility check validation.");
		return false;
	}
	
}

function CustomModifyGridValues(columnList,frameName,SubCategoryID,donefrm,fobj)
	{
		var customform='';
		if(donefrm=='custom')
		{	
			customform=fobj;
		}
		else
		{
			var formWindow=getWindowHandler(windowList,"formGrid");
			customform=formWindow.frames['customform'];
		}
		var iframe = customform.document.getElementById("frmData");
	
		var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
		var modifyGridBundleId = iframeDocument.getElementById(frameName+'_modifyGridBundle').value;
		var tempElementName = frameName+"_"+SubCategoryID+"_gridbundle_";
		var gridRowNum = modifyGridBundleId.substring(tempElementName.length);
		var selGridWIData = iframeDocument.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value;
		
		if(modifyGridBundleId==null || modifyGridBundleId=="")
		{
			alert("Please select a card.");
			return false;
		}
		
		if(SubCategoryID =='3' && !iframeDocument.getElementById("3_block_card").checked)
		{
			return true;
		}
		//In this function Write Custom Validation and code	on change of data of grid, populateCustomValue.js
		
		var CategoryID=iframeDocument.getElementById("CategoryID").value;
			var valid = customValidationOnIntroduce(columnList,frameName,CategoryID,SubCategoryID,donefrm,fobj);
			if(!valid)
			{
				return valid;
			}
		
		//End In this function Write Custom Validation and code	on change of data of grid, populateCustomValue.js;
		
		var obj = JSON.parse(selGridWIData);
		
		
		columnList = columnList.replace(/\s/g, '');
		var arrColumnList = columnList.split(",");
		var len = arrColumnList.length;
		var modifiedListBundle = "";
		var selWIElementData = "";
		var arrSelWIElementData = "";
		var modWIElementData = "";
		var modifiedWIData = "";
		var columnListName = "";
		var columnListValue = "";
		var currGridAttrValue ="";
		var radioButtonSet ="";
		
		
		for (var i = 0; i < len; i++)
		{		
			 modWIElementData = "";
			
            if(arrColumnList[i].indexOf('manual_blocking_action') == -1){
			 			
				columnListName = iframeDocument.getElementById(arrColumnList[i]).name;
				columnListValue = iframeDocument.getElementById(arrColumnList[i]).value;
				
				if(iframeDocument.getElementById(arrColumnList[i]).type=='checkbox')
				{
					if(iframeDocument.getElementById(arrColumnList[i]).checked==true)
					{
						columnListValue='Yes';
					}
					else
					{
						columnListValue='No';
					}
				}		
				if(iframeDocument.getElementById(arrColumnList[i]).type=='select-one')
				{
					if(iframeDocument.getElementById(arrColumnList[i]).value=='--Select--')
					{
						columnListValue='';
					}
				}
				
				if(iframeDocument.getElementById(arrColumnList[i]).type=='text')
				{
					if(columnListValue=='')
					{
						columnListValue='';
					}
				}
			
			
		}else{
			if(iframeDocument.getElementsByName(arrColumnList[i])[0].type=='radio')
			{
				if(radioButtonSet==columnListName+"_Y")
				{
					continue;
				}
				var myradio = iframeDocument.getElementsByName(arrColumnList[i]);
				var x = 0;
				var radioButtonChecked = false;
				var radioButtonCheckedValue = '';
				for(x = 0; x < myradio.length; x++)
				{
					if(myradio[x].checked)
					{
						
						radioButtonChecked=true;
						radioButtonCheckedValue=myradio[x].value;
						columnListValue = radioButtonCheckedValue;
						radioButtonSet = columnListName+"_Y";
					}
				}
				if(radioButtonSet!=columnListName+"_Y")
				{
					columnListValue='';
				}
			}
		}
			
			iframeDocument.getElementById("grid_"+arrColumnList[i]+"_"+gridRowNum).value=columnListValue;
			selWIElementData = obj[arrColumnList[i].replace(SubCategoryID+"_","")];
			arrSelWIElementData = selWIElementData.split("@");
			arrSelWIElementData[gridRowNum]=columnListValue;
			modWIElementData=arrSelWIElementData.join("@");
			obj[arrColumnList[i].replace(SubCategoryID+"_","")]=modWIElementData;
			modifiedListBundle=modifiedListBundle+columnListName+":"+arrColumnList[i]+"#"+columnListValue;
			
			if (i<len-1){
			modifiedListBundle = modifiedListBundle +"~";
			}
			arrSelWIElementData="";
		}
		

		
		var modifiedStrJson = '';
		for(var key in obj){
			var attrName = key;
			var attrValue = obj[key];
			modifiedStrJson += attrName+"#"+attrValue+"~";
		}	
		
		var strJson = JSON.stringify(obj);
		
		modifiedStrJson=modifiedStrJson.substring(0,(modifiedStrJson.lastIndexOf("~")));
		 
		iframeDocument.getElementById(modifyGridBundleId).value=modifiedListBundle;
		iframeDocument.getElementById(frameName+"_"+SubCategoryID+'_gridbundle_WIDATA').value=modifiedStrJson;
		iframeDocument.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value=strJson;
		
		
		if(SubCategoryID=='2' && frameName=='BALANCE TRANSFER DETAILS')
		{
			var OtherGridsColumnList = '2_card_no,2_sub_ref_no_auth,2_auth_code,2_status,2_bt_amount';
			var primaryGridColumnList = '2_rakbank_eligible_card_no,2_sub_ref_no,2_auth_code,2_status,2_bt_amt_req';
			var targetFrame = 'AUTHORIZATION DETAILS';
			ModifyGridValuesInOtherGrid(primaryGridColumnList,OtherGridsColumnList,targetFrame,SubCategoryID,gridRowNum)
		}
		
		if(SubCategoryID=='4' && frameName=='CREDIT CARD CHEQUE DETAILS')
		{
			var OtherGridsColumnList = '4_card_no_1,4_sub_ref_no_auth,4_auth_code,4_status,4_ccc_amount';
			var primaryGridColumnList = '4_rakbank_eligible_card_no,4_sub_ref_no,4_auth_code,4_status,4_ccc_amt_req';
			var targetFrame = 'AUTHORIZATION DETAILS';
			ModifyGridValuesInOtherGrid(primaryGridColumnList,OtherGridsColumnList,targetFrame,SubCategoryID,gridRowNum)
		}
		
		if(SubCategoryID=='5' && frameName=='SMART CASH DETAILS')
		{
			var OtherGridsColumnList = '5_card_no_1,5_sub_ref_no_auth,5_auth_code,5_status,5_sc_amount';
			var primaryGridColumnList = '5_rakbank_eligible_card_no,5_sub_ref_no,5_auth_code,5_status,5_sc_amt_req';
			var targetFrame = 'AUTHORIZATION DETAILS';
			ModifyGridValuesInOtherGrid(primaryGridColumnList,OtherGridsColumnList,targetFrame,SubCategoryID,gridRowNum)
		}
		
		ClearGridFieldsOnIntroduce(columnList,frameName,donefrm,fobj);
		
		return true;
	}
function ClearGridFieldsOnIntroduce(columnList,framename,donefrm,fobj)
	{
		var customform='';
		if(donefrm=='custom')
		{	
			customform=fobj;
		}
		else
		{
			var formWindow=getWindowHandler(windowList,"formGrid");
			customform=formWindow.frames['customform'];
		}
		
		var iframe = customform.document.getElementById("frmData");
		var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;

	
		var CategoryID=iframeDocument.getElementById("CategoryID").value;
		var SubCategoryID=iframeDocument.getElementById("SubCategoryID").value;
		columnList = columnList.replace(/\s/g, '');
		var arrColumnList = columnList.split(",");
		iframeDocument.getElementById(framename+"_"+SubCategoryID+'_gridselrowindex').value='';
		var len = arrColumnList.length;
		for (var i = 0; i < len; i++)
		{			
			if(!arrColumnList[i].includes('manual_blocking_action')){
				if(iframeDocument.getElementById(arrColumnList[i]).type=='text')
				{
					iframeDocument.getElementById(arrColumnList[i]).value = "";
					}
				if(iframeDocument.getElementById(arrColumnList[i]).type=='select-one')
				{
					iframeDocument.getElementById(arrColumnList[i]).value='--Select--';
				}
				if(iframeDocument.getElementById(arrColumnList[i]).type=='checkbox')
				{
					iframeDocument.getElementById(arrColumnList[i]).checked=false;
			
				}		
				if(iframeDocument.getElementById(arrColumnList[i]).type=='radio')
				{
					var myradio1 = iframeDocument.getElementsByName(arrColumnList[i]);
					for(x = 0; x < myradio1.length; x++)
					{
						myradio1[x].checked=false;
						myradio1[x].disabled=true;
					}
				}		
				if(iframeDocument.getElementById(arrColumnList[i]).type=='textarea')
				{
					iframeDocument.getElementById(arrColumnList[i]).value='';
				
				}		


				if(iframeDocument.getElementById(arrColumnList[i]).type!='radio')
				{
					var fieldName = iframeDocument.getElementById(arrColumnList[i]).name;
					var fieldNameArr = fieldName.split("#");
					var arrLen=fieldNameArr.length;
					if(fieldNameArr[6]=='Y')
						iframeDocument.getElementById(arrColumnList[i]).disabled = false;
					else
						iframeDocument.getElementById(arrColumnList[i]).disabled = true;
				}
			}	
		}
		
		iframeDocument.getElementById(framename+'_modifyGridBundle').value='';
		
				
			var myradio = iframeDocument.getElementsByName(framename+'_Radio');
			var x = 0;
			for(x = 0; x < myradio.length; x++)
			{
				myradio[x].checked=false;
			}
	}	
function customValidationOnIntroduce(columnList,frameName,CategoryID,SubCategoryID,donefrm,fobj)
{
	//alert("Debug inside custom validation on introduce");
	var customform='';
	if(donefrm=='custom')
	{	
		customform=fobj;
	}
	else
	{
		var formWindow=getWindowHandler(windowList,"formGrid");
		customform=formWindow.frames['customform'];
	}
	var iframe = customform.document.getElementById("frmData");
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	
	var WSNAME = iframeDocument.getElementById('WS_NAME').value;
	var integrationStatus=fobj.document.getElementById("wdesk:IntegrationStatus").value;
	
	if(CategoryID=='1' && SubCategoryID=='3')
	{
		var frameName = "Card Blocking Details";
	
		var myradio = iframeDocument.getElementsByName('3_verification_details');
		var x = 0;
		var veriDetailChecked = false;
		var veriDetailCheckedValue = '';
		for(x = 0; x < myradio.length; x++)
		{
			if(myradio[x].checked){
			veriDetailChecked=true;
			veriDetailCheckedValue=myradio[x].value;
			}
		}
		
		var myradio1 = iframeDocument.getElementsByName('3_manual_blocking_action');
		var y = 0;
		var ManualBlockingActionChecked = false;
		var ManualBlockingActionValue = '';
		for(y = 0; y < myradio1.length; y++)
		{
			if(myradio1[y].checked)
			{
				ManualBlockingActionChecked=true;
				ManualBlockingActionValue=myradio1[y].value;
			}
		}
			
	
		if(iframeDocument.getElementById('3_block_card').checked==true)
		{
		
				if(iframeDocument.getElementById('3_type_of_block').value=='--Select--')
				{
					alert('Please select Type of Block');
					iframeDocument.getElementById('3_type_of_block').focus();
					return false;
				}
				else if (iframeDocument.getElementById('3_type_of_block').value=='Permanent')
				{
					
					
					if(veriDetailCheckedValue=='Non - Customer')
					{
						alert("Non-Customer is not allowed to block the card permanently.\nKindly select 'Temporary' Type of Block.");
						iframeDocument.getElementById("3_type_of_block").focus();
						return false;
					}
					if(!veriDetailChecked)
					{
						alert("Please select Verification details first");
						return false;
					}
					else
					{					
						if(veriDetailCheckedValue=='Non - Customer')
						{
							iframeDocument.getElementById('3_replacement_required').value='';
							iframeDocument.getElementById('3_replacement_required').disabled=true;
						}
						else
						{
							iframeDocument.getElementById('3_replacement_required').disabled=false;
						}
						
						if(iframeDocument.getElementById('3_reason_for_block').value=='--Select--')
						{
							alert('Please select Reason for Block');
							iframeDocument.getElementById('3_reason_for_block').focus();
							return false;
						}
						else if(((iframeDocument.getElementById("3_reason_for_block").value=='Lost') 
							||(iframeDocument.getElementById("3_reason_for_block").value=='Stolen')
							||iframeDocument.getElementById("3_reason_for_block").value=='Captured at Rak bank ATM'
							||iframeDocument.getElementById("3_reason_for_block").value=='Captured in non-Rak bank ATM'
							||(iframeDocument.getElementById("3_reason_for_block").value=='Misuse')
							))			
						{
							if(iframeDocument.getElementById("3_date_and_time").value=='')
							{
								alert('Please select Date and Time');
								iframeDocument.getElementById('3_date_and_time').focus();
								return false;
							}
							else
							{
								var valDate =  ValidateDateOnIntroduce(donefrm,fobj);
								if(!valDate)
								return valDate;
							}
						}
						
						if(iframeDocument.getElementById("3_reason_for_block").value=='Captured at Rak bank ATM'||iframeDocument.getElementById("3_reason_for_block").value=='Captured in non-Rak bank ATM') 
						{
							if(iframeDocument.getElementById("3_ATM_Loc").value=='')
							{
								alert('Please enter ATM Location');
								iframeDocument.getElementById('3_ATM_Loc').focus();
								return false;
							}								
							if(iframeDocument.getElementById("3_branch_collect").value=='--Select--')
							{
								alert('Please select Branch for Collection');
								iframeDocument.getElementById('3_branch_collect').focus();
								return false;
							}
						}
						
					}
				
				}
				else 
				{
					if(iframeDocument.getElementById('3_reason_for_block').value=='--Select--'){
						alert('Please select Reason for Block');
						iframeDocument.getElementById('3_reason_for_block').focus();
						return false;
					}else if(((iframeDocument.getElementById("3_reason_for_block").value=='Lost') 
							||(iframeDocument.getElementById("3_reason_for_block").value=='Stolen')
							||iframeDocument.getElementById("3_reason_for_block").value=='Captured at Rak bank ATM'
							||iframeDocument.getElementById("3_reason_for_block").value=='Captured in non-Rak bank ATM'
							||(iframeDocument.getElementById("3_reason_for_block").value=='Misuse')
						))			
					{
						if(iframeDocument.getElementById("3_date_and_time").value==''){
							alert('Please select Date and Time');
							iframeDocument.getElementById('3_date_and_time').focus();
							return false;
						}else{
								var valDate =  ValidateDateOnIntroduce(donefrm,fobj);
								if(!valDate)
								return valDate;
						}
					}
					
					if(iframeDocument.getElementById("3_reason_for_block").value=='Captured at Rak bank ATM'||iframeDocument.getElementById("3_reason_for_block").value=='Captured in non-Rak bank ATM') 
					{
							if(iframeDocument.getElementById("3_ATM_Loc").value==''){
							alert('Please enter ATM Location');
							iframeDocument.getElementById('3_ATM_Loc').focus();
							return false;
						}						
						if(iframeDocument.getElementById("3_branch_collect").value=='--Select--'){
							alert('Please select Branch for Collection');
							iframeDocument.getElementById('3_branch_collect').focus();
							return false;
						}
					}
				}
				
					
				if(ManualBlockingActionChecked && ManualBlockingActionValue=='Manual Blocking Not Done' && (iframeDocument.getElementById("3_remarks_action").value).replace(/^\s+|\s+$/gm,'') == '')
				{
					alert("Please enter Remarks for Manual Blocking Not Done");
					iframeDocument.getElementById('3_remarks_action').focus();
					return false;
				}
		}
		
		if((iframeDocument.getElementById(SubCategoryID+'_sub_ref_no').value).replace(/^\s+|\s+$/gm,'')=='' && iframeDocument.getElementById("3_block_card").checked)
		{
			
			generateSubRefNoOnIntroduce(frameName,SubCategoryID,donefrm,fobj);
		}
		
	}
else if(CategoryID=='1' && SubCategoryID=='2')
	{
		if(frameName=='AUTHORIZATION DETAILS')
		{
			var myradio1 = iframeDocument.getElementsByName('2_manual_blocking_action');
			var y = 0;
			var ManualBlockingActionChecked = false;
			var ManualBlockingActionValue = '';
			for(y = 0; y < myradio1.length; y++)
			{
				if(myradio1[y].checked)
				{
					ManualBlockingActionChecked=true;
					ManualBlockingActionValue=myradio1[y].value;
				}
			}
				
			if(ManualBlockingActionChecked && ManualBlockingActionValue=='Manual Blocking Not Done' && (iframeDocument.getElementById("2_remarks_action").value).replace(/^\s+|\s+$/gm,'') == '')
			{
				alert("Please enter Remarks for Manual Blocking Not Done");
				iframeDocument.getElementById('2_remarks_action').focus();
				return false;
			}
		
			if((iframeDocument.getElementById('2_auth_code').value).replace(/^\s+|\s+$/gm,'') == '' && integrationStatus=='false' && ManualBlockingActionChecked && (ManualBlockingActionValue=='Manual Blocking Done' || ManualBlockingActionValue=='No Action'))
			{

				alert("Please enter Authorization code. Select Manual Blocking Done to enter");
				iframeDocument.getElementById('2_auth_code').focus();
				return false;	
			}
			
			/*if(WSNAME=="Q1")
			{
				if(iframeDocument.getElementById("2_cancellation_remarks").value=='' || iframeDocument.getElementById("2_cancellation_remarks").value==' ')
				{
					alert("Please enter Cancellation Remarks");
					iframeDocument.getElementById('2_cancellation_remarks').focus();
					return false;
				}
				
			}*/			
		}
		return true;
	} 
	else if(CategoryID=='1' && SubCategoryID=='4')
	{
		
		if(frameName=='AUTHORIZATION DETAILS')
		{
		
			var myradio1 = iframeDocument.getElementsByName('4_manual_blocking_action');
			var y = 0;
			var ManualBlockingActionChecked = false;
			var ManualBlockingActionValue = '';
			for(y = 0; y < myradio1.length; y++)
			{
				if(myradio1[y].checked)
				{
					ManualBlockingActionChecked=true;
					ManualBlockingActionValue=myradio1[y].value;
				}
			}
			//alert("value is "+iframeDocument.getElementById('4_auth_code').value);
			if(ManualBlockingActionChecked && ManualBlockingActionValue=='Manual Blocking Not Done' && (iframeDocument.getElementById("4_remarks_action").value).replace(/^\s+|\s+$/gm,'') == '')
			{
				alert("Please enter Remarks for Manual Blocking Not Done");
				iframeDocument.getElementById('4_remarks_action').focus();
				return false;
			}			
			else if((iframeDocument.getElementById('4_auth_code').value).replace(/^\s+|\s+$/gm,'') == '' && integrationStatus=='false' && ManualBlockingActionChecked && (ManualBlockingActionValue=='Manual Blocking Done' || ManualBlockingActionValue=='No Action'))
			{
				
				alert("Please enter Authorization code. Select Manual Blocking Done to enter");
				iframeDocument.getElementById('4_auth_code').focus();
				return false;	
			}
			else if ((iframeDocument.getElementById('4_auth_code').value).replace(/^\s+|\s+$/gm,'') == '' && integrationStatus=='false')
			{
				alert("Please enter Authorization code.");
				iframeDocument.getElementById('4_auth_code').focus();
				return false;
			}
			/*if(WSNAME=="Q1")
			{
				if(iframeDocument.getElementById("4_cancellation_remarks").value=='' || iframeDocument.getElementById("4_cancellation_remarks").value==' ')
				{
					alert("Please enter Cancellation Remarks");
					iframeDocument.getElementById('4_cancellation_remarks').focus();
					return false;
				}
				/*if(iframeDocument.getElementById("2_cancel_status").value!='Cancelled' && iframeDocument.getElementById("2_manual_unblock").checked==false)
				{
					alert("Please check Manual Unblocking")
					return false;
				}
			}*/	
		}
		return true;
	}
	else if(CategoryID=='1' && SubCategoryID=='5')
	{
		
		if(frameName=='AUTHORIZATION DETAILS')
		{
		
			var myradio1 = iframeDocument.getElementsByName('5_manual_blocking_action');
			var y = 0;
			var ManualBlockingActionChecked = false;
			var ManualBlockingActionValue = '';
			for(y = 0; y < myradio1.length; y++)
			{
				if(myradio1[y].checked)
				{
					ManualBlockingActionChecked=true;
					ManualBlockingActionValue=myradio1[y].value;
				}
			}
			//alert("value is "+iframeDocument.getElementById('5_auth_code').value);
			if(ManualBlockingActionChecked && ManualBlockingActionValue=='Manual Blocking Not Done' && (iframeDocument.getElementById("5_remarks_action").value).replace(/^\s+|\s+$/gm,'') == '')
			{
				alert("Please enter Remarks for Manual Blocking Not Done");
				iframeDocument.getElementById('5_remarks_action').focus();
				return false;
			}			
			else if((iframeDocument.getElementById('5_auth_code').value).replace(/^\s+|\s+$/gm,'') == '' && integrationStatus=='false' && ManualBlockingActionChecked && (ManualBlockingActionValue=='Manual Blocking Done' || ManualBlockingActionValue=='No Action'))
			{
				
				alert("Please enter Authorization code. Select Manual Blocking Done to enter");
				iframeDocument.getElementById('5_auth_code').focus();
				return false;	
			}
			else if ((iframeDocument.getElementById('5_auth_code').value).replace(/^\s+|\s+$/gm,'') == '' && integrationStatus=='false')
			{
				alert("Please enter Authorization code.");
				iframeDocument.getElementById('5_auth_code').focus();
				return false;
			}
			/*if(WSNAME=="Q1")
			{
				if(iframeDocument.getElementById("5_cancellation_remarks").value=='' || iframeDocument.getElementById("5_cancellation_remarks").value==' ')
				{
					alert("Please enter Cancellation Remarks");
					iframeDocument.getElementById('5_cancellation_remarks').focus();
					return false;
				}
				/*if(iframeDocument.getElementById("2_cancel_status").value!='Cancelled' && iframeDocument.getElementById("2_manual_unblock").checked==false)
				{
					alert("Please check Manual Unblocking")
					return false;
				}
			}*/	
		}
		return true;
	}
	return true;
}


function generateSubRefNoOnIntroduce(frameName,SubCategoryID,donefrm,fobj)
{
	var customform='';
	if(donefrm=='custom')
	{	
		customform=fobj;
	}
	else
	{
		var formWindow=getWindowHandler(windowList,"formGrid");
		customform=formWindow.frames['customform'];
	}
	var iframe = customform.document.getElementById("frmData");
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;

	var selGridWIData = iframeDocument.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value;
	var obj = JSON.parse(selGridWIData);
	var valueSubRefNo = obj['sub_ref_no'];
	var arrValueSubRefNo = valueSubRefNo.split("@");
	var runningNo;
	len = arrValueSubRefNo.length;
	var maxSubRefNo = "";
	
	for (var i = 0; i < len; i++)
		{	 
			if(i==0){
				if(arrValueSubRefNo[i].replace(/^\s+|\s+$/gm,'')!=''){
					maxSubRefNo =  arrValueSubRefNo[i].replace(/^\s+|\s+$/gm,'');
				}
			}else{
				if(arrValueSubRefNo[i].replace(/^\s+|\s+$/gm,'')!='' && maxSubRefNo <  arrValueSubRefNo[i]){
					maxSubRefNo =  arrValueSubRefNo[i].replace(/^\s+|\s+$/gm,'');
				}
			}
		}
	if(maxSubRefNo==""){
		runningNo = '0001';
		if((iframeDocument.getElementById(SubCategoryID+'_sub_ref_no').value).replace(/^\s+|\s+$/gm,'')=='')
		{
			iframeDocument.getElementById(SubCategoryID+'_sub_ref_no').value=runningNo;
		}
	}else{
		runningNo = "1"+maxSubRefNo;
		runningNo=parseInt(runningNo)+1;
		runNo=runningNo +'';
		runningNo=runNo.substring(1,5);
		if((iframeDocument.getElementById(SubCategoryID+'_sub_ref_no').value).replace(/^\s+|\s+$/gm,'')=='')
		{
			iframeDocument.getElementById(SubCategoryID+'_sub_ref_no').value=runningNo;
		}
	}
}
function ValidateDateOnIntroduce(donefrm,fobj)
{
	var customform='';
	if(donefrm=='custom')
	{	
		customform=fobj;
	}
	else
	{
		var formWindow=getWindowHandler(windowList,"formGrid");
		customform=formWindow.frames['customform'];
	}
	var iframe = customform.document.getElementById("frmData");
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	
	var CategoryID = iframeDocument.getElementById("CategoryID").value;
	var SubCategoryID = iframeDocument.getElementById("SubCategoryID").value;
	if(CategoryID=='1' && SubCategoryID=='3')
	{
		var date_and_time= iframeDocument.getElementById("3_date_and_time").value;
		date_and_time = date_and_time.substring(0,10);
		
		if(date_and_time!='')
		{
			var now = new Date();
			var month = now.getMonth()+1;
			if(month<10)
			month = "0"+month;
			
			var date = now.getDate();
			if(date<10)
			date = "0"+date;
			
			var currdate = date+"/"+month+"/"+now.getFullYear();
			var regExp = /(\d{1,2})\/(\d{1,2})\/(\d{2,4})/;
			if(parseInt(date_and_time.replace(regExp, "$3$2$1"))>parseInt(currdate.replace(regExp, "$3$2$1")))
			{

				alert("Date and Time field should not have future date");
				iframeDocument.getElementById('3_date_and_time').value="";
				iframeDocument.getElementById('3_date_and_time').focus();
				return false;
			}
			else
			{
				return true;
			}
		}
	}
}

function myTrim1(x) {
    return x.replace(/^\s+|\s+$/gm,'');
}
function Trim1(x) {
    return x.replace(/^\s+|\s+$/gm,'');
}