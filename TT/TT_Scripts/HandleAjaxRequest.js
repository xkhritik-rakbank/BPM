function ajaxRequest(workstepname,reqType)
{
	var url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?workstepname='+workstepname+"&reqType="+reqType;
	var xhr;
	var ajaxResult;			
	var values = "";
	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	if (reqType =='CallBackAutoRaiseCheck' || reqType =='ComplainceAutoRaiseCheck' || reqType =='getCallBackRemarks')
	{
		var winame = document.getElementById("wdesk:wi_name").value;
		url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?workstepname='+workstepname+"&winame="+encodeURIComponent(winame)+"&reqType="+reqType;
	}
	else if (reqType =='EnterRemarks')
	{
		var remarksOnForm=document.getElementById("wdesk:remarks").value;
		var winame = document.getElementById("wdesk:wi_name").value;
		url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?workstepname='+workstepname+"&winame="+encodeURIComponent(winame)+"&reqType="+reqType+"&remarksOnForm="+remarksOnForm;
	}
	else if (reqType =='isViewSignClicked')
	{
		var isViewSignClicked='Yes';
		var winame = document.getElementById("wdesk:wi_name").value;
		url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?workstepname='+workstepname+"&winame="+encodeURIComponent(winame)+"&reqType="+reqType+"&isViewSignClicked="+isViewSignClicked;
	}
	else if (reqType =='SelectEnterRemarks')
	{
		var winame = document.getElementById("wdesk:wi_name").value;
		url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?workstepname='+workstepname+"&winame="+encodeURIComponent(winame)+"&reqType="+reqType;
	}
	else if (reqType =='SelectViewSignClicked')
	{
		var winame = document.getElementById("wdesk:wi_name").value;
		url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?workstepname='+workstepname+"&winame="+encodeURIComponent(winame)+"&reqType="+reqType;
	}
	else if (reqType =='frontOfficeMail')
	{
		var solId=document.getElementById("wdesk:sol_id").value;
		
		url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?workstepname='+workstepname+"&solId="+solId+"&reqType="+reqType;
	}
	else if (reqType =='PSLSMEEmailForCompliance' || reqType =='PSLSMEEmailForNonCompliance')
	{
		var solId=document.getElementById("wdesk:sol_id").value;
		var subSeg = document.getElementById("wdesk:sub_segment").value;
		
		url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?workstepname='+workstepname+"&solId="+solId+"&reqType="+reqType+"&subSeg="+subSeg;
	}
	else if (reqType =='rejectReasons')
	{
		var rejReasonCodes=document.getElementById("rejReasonCodes").value;
		rejReasonCodes="'"+rejReasonCodes.replaceAll("#","','")+"'";
		url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?workstepname='+workstepname+"&rejReasonCodes="+rejReasonCodes+"&reqType="+reqType;
	}
	else if (reqType =='segmentComplianceMail' ||reqType =='segmentNonComplianceMail' ||reqType =='IBMBNonComplianceMail' ||reqType =='IBMBComplianceMail' ||reqType =='YAPSPOCMail' )
	{
		var subSeg = document.getElementById("wdesk:sub_segment").value;
		
		url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?workstepname='+workstepname+"&subSeg="+subSeg+"&reqType="+reqType;
	}			
	else if (reqType =='dropDwnTranscode')
	{
		var ele = document.getElementById("transtype");
		var transType = ele.options[ele.selectedIndex].value;
		
		url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?workstepname='+workstepname+"&transType="+transType+"&reqType="+reqType;
	}
	else if (reqType =='changeTransCodeToRem')
	{
		var transType = document.getElementById("wdesk:trans_type").value;
		
		url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?workstepname='+workstepname+"&transType="+transType+"&reqType="+reqType;
	}
	else if (reqType =='getCountryCode' || reqType =='getCountryCodeBenfCntry' || reqType =='getCountryCodeInterCntry')
	{
		var countryName = "";
		if (reqType =='getCountryCode')
			countryName = document.getElementById("wdesk:benefBankCntry").value;
		else if (reqType =='getCountryCodeInterCntry')
			countryName = document.getElementById("wdesk:interBankCntry").value;
		else
			countryName = document.getElementById("wdesk:countryOfRes").value;

		url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?workstepname='+workstepname+"&countryName="+countryName+"&reqType="+reqType;
	}			
	else if (reqType=='assignToBusiness')
	{
		var isElite = document.getElementById("wdesk:isEliteCust").value;
		var subSeg = document.getElementById("wdesk:sub_segment").value;
		var winame = document.getElementById("wdesk:wi_name").value;
		var sol_id = document.getElementById("wdesk:sol_id").value;
		var prevWs = document.getElementById("wdesk:prev_WS").value;
		url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?isElite='+isElite+"&subSeg="+subSeg+"&prevWs="+prevWs+"&sol_id="+sol_id+"&winame="+encodeURIComponent(winame)+"&reqType="+reqType;
	}
	else if (reqType=='ENTITY_DETAILS' || reqType=='EXCHANGE_RATE_DETAILS' || reqType=='ACCOUNT_DETAILS' || reqType=='MEMOPAD_DETAILS' || reqType=='PAYMENT_DELETION'|| reqType=='PAYMENT_DETAILS'|| reqType=='EVENT_NOTIFICATION'|| reqType=='PAYMENT_REQ' || reqType=='getCustomerType') {
		var strSplit = workstepname.split("#");
		var strCode = strSplit[1];
		url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?strCode='+strCode+"&reqType="+reqType;
	}
	else if (reqType=='decimalPoint') {
		var currCode = document.getElementById('wdesk:transferCurr').value;
		url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?currCode='+currCode+"&reqType="+reqType;
	}
	
	 xhr.open("GET",url,false);
	 xhr.send(null);

	if (xhr.status == 200)
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		
		if (reqType =='SelectEnterRemarks')
		{
		    console.log("Return the ajaxrslt for select rmrks:"+ ajaxResult)
			return ajaxResult;
		}
		if (reqType =='SelectViewSignClicked')
		{
		    console.log("Return the ajaxrslt for select SelectViewSignClicked:"+ ajaxResult)
			return ajaxResult;
		}
		
		if(ajaxResult.indexOf("Exception")==0)
		{
			alert("Unknown Exception while working with request type "+reqType);
			return false;
		}

		 if(reqType=='CountryDropDown')
			values = ajaxResult.split("~");
		 else
			values = ajaxResult.split(",");
		// Added (changeTransCodeToRem) - Changes done for Cross Border payment CR - 13082017
		if (reqType=='DecisionDropDown' || reqType=='LangaugesDropDown' || reqType=='CountryDropDown'  || reqType=='CurrencyDropDown' || reqType=='dropDownCallBackCustVerf' 	||	reqType=='dropDownCallBackFailureReason' ||	reqType=='dropDownBenefBankCode' || reqType=='dropDownTranstype' ||  reqType=='dropDwnTranscode' || reqType=='assignToCompliance' || reqType=='assignToBusiness'|| reqType=='changeTransCodeToRem') 
		{
			var select;
			
			if (reqType=='DecisionDropDown')
				select = document.getElementById('decisionRoute');				
			else if (reqType=='LangaugesDropDown')
				select = document.getElementById('custLanguage');
			else if (reqType=='CountryDropDown')
				select = document.getElementById('benefBankCntryCombo');
			else if (reqType=='CurrencyDropDown')
				select = document.getElementById('transamtcurr');
			else if (reqType=='dropDownCallBackCustVerf')
				select = document.getElementById('dropDownCallBackCustVerf');
			else if (reqType=='dropDownCallBackFailureReason')
				select = document.getElementById('dropDownCallBackFailureReason');
			else if (reqType=='dropDownBenefBankCode')
				select = document.getElementById('dropDownBenefBankCode');
			else if (reqType=='dropDownTranstype')
				select = document.getElementById('transtype');
			else if (reqType=='dropDwnTranscode' || reqType=='changeTransCodeToRem') // Added (changeTransCodeToRem) - Changes done for Cross Border payment CR - 13082017
				select = document.getElementById('transcode');
			else if (reqType=='assignToCompliance')
				select = document.getElementById('assignToDropDown');
			else if (reqType=='assignToBusiness')
				select = document.getElementById('assignToDropDown');
			
			// Start - Changes done for Cross Border payment CR - 13082017
			if(reqType=='dropDwnTranscode' || reqType=='changeTransCodeToRem')
			{
				var opt = document.createElement('option');
				opt.value = '--Select--';
				opt.innerHTML = '--Select--';
				opt.length = 10;
				opt.className="EWNormalGreenGeneral1";
				select.appendChild(opt);
				
				for (var i=0 ; i< values.length ; i++) {
				var opt = document.createElement('option');
				opt.value = values[i].trim();
				opt.title = values[i].trim();//Changes done for Cross Border payment CR - 13082017
				opt.innerHTML = values[i].trim();
				opt.length = values[i].length;
				opt.className="EWNormalGreenGeneral1";
				select.appendChild(opt);
				jqueryFunctionForTransCode(); //Changes done for Cross Border payment CR - 13082017 
				
				}
			}
			
			
			//Add elements to the corresponding dropdown
			else
			{
				for (var i=0 ; i< values.length ; i++) {
					var opt = document.createElement('option');
					opt.value = values[i].trim();
					opt.innerHTML = values[i].trim();
					opt.length = values[i].length;
					opt.className="EWNormalGreenGeneral1";
					select.appendChild(opt);
					
					
				}
			}
			// End - Changes done for Cross Border payment CR - 13082017
			//Same fields have to be populated for Intermediary Bank Details
			if (reqType=='CountryDropDown')
			{
				select = document.getElementById('wdesk:interBankCntryCombo');
				for (var i=0 ; i< values.length ; i++) {
					var opt = document.createElement('option');
					opt.value = values[i].trim();
					opt.innerHTML = values[i].trim();
					opt.length = values[i].length;
					opt.className="EWNormalGreenGeneral1";
					select.appendChild(opt);
				}
				select = document.getElementById('countryOfResCombo');
				for (var i=0 ; i< values.length ; i++) {
					var opt = document.createElement('option');
					opt.value = values[i].trim();
					opt.innerHTML = values[i].trim();
					opt.length = values[i].length;
					opt.className="EWNormalGreenGeneral1";
					select.appendChild(opt);
				}						
			}
			else if (reqType=='CurrencyDropDown')
			{
				select = document.getElementById('remitamtcurr');
				for (var i=0 ; i< values.length ; i++) {
					var opt = document.createElement('option');
					opt.value = values[i].trim();
					opt.innerHTML = values[i].trim();
					opt.length = values[i].length;
					opt.className="EWNormalGreenGeneral1";
					select.appendChild(opt);
				}
			}
			else if (reqType=='dropDownBenefBankCode')
			{
				select = document.getElementById('dropDownInterBankCode');
				for (var i=0 ; i< values.length ; i++) {
					var opt = document.createElement('option');
					opt.value = values[i].trim();
					opt.innerHTML = values[i].trim();
					opt.length = values[i].length;
					opt.className="EWNormalGreenGeneral1";
					select.appendChild(opt);
				}
			}
		}
		else if (reqType =='CallBackAutoRaiseCheck' || reqType =='ComplainceAutoRaiseCheck' || reqType =='rejectReasons' || reqType =='PSLSMEEmailForNonCompliance' ||reqType =='PSLSMEEmailForCompliance' ||reqType =='frontOfficeMail' || reqType =='eliteMailComp' || reqType =='eliteMailOthers' || reqType =='segmentComplianceMail' ||reqType =='segmentNonComplianceMail' || reqType =='eliteMail' || reqType =='getCountryCode' || reqType =='getCountryCodeBenfCntry'|| reqType =='getCountryCodeInterCntry' || reqType =='ENTITY_DETAILS' || reqType=='EXCHANGE_RATE_DETAILS' || reqType=='ACCOUNT_DETAILS'|| reqType=='MEMOPAD_DETAILS'|| reqType=='PAYMENT_DELETION'|| reqType=='PAYMENT_DETAILS' || reqType=='EVENT_NOTIFICATION'|| reqType=='PAYMENT_REQ'|| reqType=='getCustomerType' || reqType=='decimalPoint' || reqType =='getCallBackRemarks'|| reqType =='IBMBNonComplianceMail' || reqType =='IBMBComplianceMail' || reqType =='YAPSPOCMail')
		{
			if (reqType =='CallBackAutoRaiseCheck' || reqType =='ComplainceAutoRaiseCheck')
			{
				if (values == 'Raised')
					return false;
				else
					return true;
			}
			else if (reqType =='rejectReasons' ||reqType =='PSLSMEEmailForNonCompliance' ||reqType =='PSLSMEEmailForCompliance'||reqType =='frontOfficeMail' || reqType =='eliteMailComp' || reqType =='eliteMailOthers' || reqType =='segmentComplianceMail' ||reqType =='segmentNonComplianceMail' ||reqType =='eliteMail' || reqType =='getCountryCode' || reqType =='getCountryCodeBenfCntry' || reqType =='getCountryCodeInterCntry' || reqType =='ENTITY_DETAILS' || reqType=='EXCHANGE_RATE_DETAILS' || reqType=='ACCOUNT_DETAILS'|| reqType=='MEMOPAD_DETAILS'|| reqType=='PAYMENT_DELETION'|| reqType=='PAYMENT_DETAILS' || reqType=='EVENT_NOTIFICATION'|| reqType=='PAYMENT_REQ'|| reqType=='getCustomerType' 
			|| reqType=='decimalPoint' ||reqType =='getCallBackRemarks'  ||reqType =='IBMBNonComplianceMail' ||reqType =='IBMBComplianceMail' ||reqType =='YAPSPOCMail')
				return values;
		}
		
		
	}
	else
	{
		alert("Error while handling "+reqType+" for the current workstep");
		return false;
	}
}