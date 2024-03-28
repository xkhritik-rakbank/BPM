 //This functions works on dropdown to show the fields according to the selection
function validateForm(workstepname) {

}

function alreadyRaised(WorkitemName,H_Checklist) {
	var xhr;
	var ajaxResult;
	ajaxResult="";
	var reqType = "TT_ISExceptionRaised";
	H_Checklist = H_Checklist.split('#').join('[hash]');

	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");
		 
	var url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxProcedures.jsp?WorkitemName='+WorkitemName+"&reqType="+reqType+"&H_Checklist="+H_Checklist;

	 xhr.open("GET",url,false);
	 xhr.send(null);

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
function alreadyRaisedDesc(WorkitemName,H_Checklist) {
	var xhr;
	var ajaxResult;
	ajaxResult="";
	var reqType = "TT_ISExceptionRaisedDesc";
	H_Checklist = H_Checklist.split('#').join('[hash]');

	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");
		 
	var url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxProcedures.jsp?WorkitemName='+WorkitemName+"&reqType="+reqType+"&H_Checklist="+H_Checklist;

	 xhr.open("GET",url,false);
	 xhr.send(null);

	if (xhr.status == 200) {
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		ajaxResult = ajaxResult.replaceAll('~',' AND ');
	}
	else {
		alert("Error while getting exception status");
		return "";
	}
	return ajaxResult;
}

function sendEmailToCustomerOnCallbackDone(customform)
{
	var payOrderId = customform.document.getElementById("wdesk:payment_order_id").value;
	var workstepname = 'CallBack';
	var winame = customform.document.getElementById("wdesk:wi_name").value;
	var xhr;
	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	var url="/webdesktop/CustomForms/TT_Specific/SendEmailToCustomer.jsp";     

	var param="winame="+winame+"&payOrderId="+payOrderId+"&workstepname="+workstepname;
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');		
	xhr.send(param);
	
	if (xhr.status == 200 && xhr.readyState == 4)
	{
		ajaxResult=xhr.responseText;
		ajaxResult=ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult.indexOf("Exception")==0)
		{
			alert("Some problem in sending mail");
			return false;
		}
	}
	else
	{
		alert("Problem in sending mail");
		return false;
	}
}

function calculateMidRate(customform)
{
	var remitAmt = customform.document.getElementById("wdesk:remit_amt").value;
	remitAmt=remitAmt.replace(/,/g, '');
	var transAmt = customform.document.getElementById("wdesk:trans_amt").value;
	transAmt=transAmt.replace(/,/g, '');

	var transCurr = customform.document.getElementById("wdesk:transferCurr").value;
	var remitCurr= customform.document.getElementById("wdesk:remit_amt_curr").value;
	var accCurr= customform.document.getElementById("acc_Curr").value;
	
	var midRateAmount = "0.0";

	if (transCurr=='AED')
		midRateAmount = transAmt;
	else if (remitCurr=='AED')
		midRateAmount = remitAmt;
	else
	{
		var cif = customform.document.getElementById("wdesk:cif_id").value;
		var remitCurrType = customform.document.getElementById("wdesk:remit_amt_curr").value;
		var transCurrType = customform.document.getElementById("wdesk:transferCurr").value;
		var accCurrType =  "AED";
		var tranAmount = customform.document.getElementById("wdesk:trans_amt").value;
		var tranAmountWithoutComma = parseFloat(tranAmount.replace(/,/g,''));
		var debt_acc_num = customform.document.getElementById("wdesk:debt_acc_num").value;
		var isbankemployee = customform.document.getElementById("wdesk:IsBankEmployee").value;
				
		var requestType='MID_RATE_INQUIRY';
		var wi_name = customform.document.getElementById("wdesk:wi_name").value;

		var xhr;
		if(window.XMLHttpRequest)
			 xhr=new XMLHttpRequest();
		else if(window.ActiveXObject)
			 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			
		var url="/webdesktop/CustomForms/TT_Specific/TTIntegration.jsp";

		//var param="wi_name="+wi_name+"&cif="+cif+"&remitCurrType="+remitCurrType+"&debt_acc_num="+debt_acc_num+"&transCurrType="+remitCurrType+"&debitCurrType="+accCurrType+"&tranAmountWithoutComma="+transAmt+"&requestType="+requestType;
		//var param="wi_name="+wi_name+"&cif="+cif+"&remitCurrType="+remitCurrType+"&debt_acc_num="+debt_acc_num+"&transCurrType="+remitCurrType+"&debitCurrType=AED&tranAmountWithoutComma="+remitAmt+"&requestType="+requestType;
		
		var param="wi_name="+wi_name+"&cif="+cif+"&remitCurrType="+remitCurrType+"&debt_acc_num="+debt_acc_num+"&transCurrType="+remitCurrType+"&debitCurrType="+accCurrType+"&tranAmountWithoutComma="+remitAmt+"&requestType="+requestType+"&isbankemployee="+isbankemployee;
		
		xhr.open("POST",url,false);
		xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');		
		xhr.send(param);
		
		if (xhr.status == 200 && xhr.readyState == 4)
		{
			ajaxResult=xhr.responseText;
			ajaxResult=ajaxResult.replace(/^\s+|\s+$/gm,'');
			if(ajaxResult.indexOf("Exception")==0)
			{
				alert("Some problem in fetching Mid Rate.");
				return false;
			}
			//Calling the function, it will set output Amount in the outputAmountMidRate
			document.getElementById('customform').contentWindow.parseFXRate(ajaxResult,2);
			midRateAmount = customform.document.getElementById("outputAmountMidRate").value;
		}
		else
		{
			alert("Problem in getting Mid Rate.");
			return false;
		}
	}

	customform.document.getElementById("wdesk:midRate").value =  midRateAmount;
}


function mainvalidateFormOnSave(workstepname)
{
	var x;

 if(workstepname=="CSO_Initiate")
 {
	 
	 //MANTHAN 
	 var cif_Id=customform.document.getElementById("wdesk:cif_id").value;
	var url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?reqType=ForIDO_OPS&solId='+cif_Id;
	var xhr;
	var ajaxResult;
	var response;

	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	 xhr.open("GET",url,false);
	 xhr.send(null);	 

	if (xhr.status == 200)
	{
		response =  parseInt(xhr.responseText);
		if(response>0){
			customform.document.getElementById("wdesk:IsIDO").value='Y';
		}
		
	}	
	var decision_tt = customform.document.getElementById('decisionRoute').value;
	if (decision_tt!='Cancel')
	{
		//var letters = /^[A-Za-z]+$/;
		var letters = /^[a-zA-Z ]*$/; // alphabets with space
		var letters1 = /^[a-z\d\-_\s]+$/i; //alphanumeric with space
		var name = /^(\w\s{0,1})+$/;
		var numbers = /^[0-9]+$/;
		var regexp = /^[a-zA-Z0-9\-\_ ]$/;			
		var benfNameChars = /[!|]*$/;			
			
		x = customform.document.getElementById('wdesk:debt_acc_num').value;
		if(x!= '' && !(x.match(numbers))) {
			alert("Only numbers are allowed in Debit Card Number");
			setFocusOnField(customform,customform.document.getElementById("wdesk:debt_acc_num"));		
			return false;    
		}
		else if(x!= '' && !(x.length==13)) {
			alert("Debit Card Account no must have 13 digits");
			setFocusOnField(customform,customform.document.getElementById("wdesk:debt_acc_num"));
			return false;
		}

		// deal reference code
		x = customform.document.getElementById('wdesk:deal_ref_code').value ;
		if(x != null && x!= '')	{
			if(x.indexOf(" ")>-1) {
					alert("Spaces are not allowed in Deal Ref Code");
					setFocusOnField(customform,customform.document.getElementById("wdesk:deal_ref_code"));		
					return false;
				}
		}
	
		x = customform.document.getElementById('wdesk:benef_name').value;
		if(!(x.match(benfNameChars))){
			alert("! and | are not allowed in Beneficiary Name");
			setFocusOnField(customform,customform.document.getElementById("wdesk:benef_name"));		
			return false;    
		}
			
		
		x = customform.document.getElementById('wdesk:benefBankName').value;
		if(x!='' && !(x.match(letters1))) {  
			alert("Only alphabets and numbers are allowed in Beneficiary Bank Name");  
			setFocusOnField(customform,customform.document.getElementById("wdesk:benefBankName"));	
			return false;
		}
		
		x = customform.document.getElementById('wdesk:iban').value;
		if(x!='' && !(x.match(letters1))) {
			alert("Account Number/IBAN can only contain aplhabets and numbers");  
			setFocusOnField(customform,customform.document.getElementById("wdesk:iban"));	
			return false;
		}
					
	}
	return true;
 }
 else if(workstepname=="OPS_Initiate")
 {
	var decision_tt = customform.document.getElementById('decisionRoute').value;
	
	var letters = /^[a-zA-Z ]*$/; // alphabets with space
	var letters1 = /^[a-z\d\-_\s]+$/i; //alphanumeric with space
	var name = /^(\w\s{0,1})+$/;
	var numbers = /^[0-9]+$/;
	var regexp = /^[a-zA-Z0-9\-\_ ]$/;			
	var alphanum = /^[a-zA-Z0-9]*$/;			
			
	x = customform.document.getElementById('wdesk:cif_id').value;
	if(x!= '' && !(x.match(numbers))) {
		alert("Only numbers are allowed in CIF ID");
		setFocusOnField(customform,customform.document.getElementById("wdesk:cif_id"));		
		return false;    
	}
	else if(x!= '' && !(x.length==7)) {
		alert("CIF ID must have 7 digits");
		setFocusOnField(customform,customform.document.getElementById("wdesk:cif_id"));
		return false;
	}
	
	x = customform.document.getElementById('wdesk:debt_acc_num').value;
	if(x!= '' && !(x.match(numbers))) {
		alert("Only numbers are allowed in Debit Card Number");
		setFocusOnField(customform,customform.document.getElementById("wdesk:debt_acc_num"));		
		return false;    
	}
	else if(x!= '' && !(x.length==13)) {
		alert("Debit Card Account no must have 13 digits");
		setFocusOnField(customform,customform.document.getElementById("wdesk:debt_acc_num"));
		return false;
	}
	
	x = customform.document.getElementById('wdesk:payment_order_id').value;
	if(x!= '' && !(x.match(alphanum))) {
		alert("Only alphabets and numbers are allowed in Payment Order Id");
		setFocusOnField(customform,customform.document.getElementById("wdesk:payment_order_id"));		
		return false;    
	}	
	return true;
 }
 else if(workstepname=="Treasury")
 {
		
		return true;
 }
 else if(workstepname=="PostCutOff_Init")
 {
		
	return true;
 }
 else if(workstepname=="RemittanceHelpDesk_Checker" )
 {	
	return true;
 }
 else if(workstepname=="CallBack")
 {
		var numbers = /^[0-9]+$/;
		//Prospect Number
		x = customform.document.getElementById('wdesk:prospect_Num').value;
		if(!(x.match(numbers)) && x!= '') {
			alert("Only numbers are allowed in the Prospect Number");
			setFocusOnField(customform,customform.document.getElementById("wdesk:prospect_Num"));
			return false;
		}
		
		return true;
 }
 else if(workstepname=="Comp_Check")
 {
		return true;
 }
  else if(workstepname=="Ops_DataEntry")
   {	
		var benfNameChars = /[!|]*$/;	
		var name = /^(\w\s{0,1})+$/;
		var letters1 = /^[a-z\d\-_\s]+$/i; //alphanumeric with space
		
		x = customform.document.getElementById('benefBankCntryCombo').value;
		if (x == null && x == "" && x=='--Select--') {
			alert("Please select Beneficiary Bank Country");
			return false;
		}

		x = customform.document.getElementById('benefBankCntryCombo').value;
		if (x == null && x == "" && x=='--Select--') {
			alert("Please select Beneficiary Bank Country");
			return false;
		}
		
	// wdesk:benef_name
		x = customform.document.getElementById('wdesk:benef_name').value ;
		if (x == null || x == "" ) {
			alert("Please enter the Beneficiary Name");
			setFocusOnField(customform,customform.document.getElementById("wdesk:benef_name"));
			return false;    
		}
		if(!(x.match(benfNameChars))){
			alert("! and | are not allowed in Beneficiary Name");
			setFocusOnField(customform,customform.document.getElementById("wdesk:benef_name"));	
			return false;    
		}
	// wdesk:benefBankName
		x = customform.document.getElementById('wdesk:benefBankName').value ;
		if (x == null || x == "" ) {
		alert("Please enter the Beneficiary Bank Name");
		setFocusOnField(customform,customform.document.getElementById("wdesk:benefBankName"));
		return false;    
		}
		else if(!(x.match(letters1))) {
			alert("Only alphabets and numbers are allowed in Beneficiary Bank Name");  
			setFocusOnField(customform,customform.document.getElementById("wdesk:benefBankName"));	
			return false;
		}		
	return true;
 }
 else if(workstepname=="Ops_Maker" || workstepname=="Ops_Maker_DB")
 {
	
	return true;
 }
 else if(workstepname=="Ops_Checker" || workstepname=="Ops_Checker_DB")
 {
	
	return true;
 }
 return true;
}
function mainvalidateForm(workstepname)
{
	if(!mainvalidateFormOnSave(workstepname))
		return false;
	//Updating the exceptions that are raised for email purposes
	var h_checklist = customform.document.getElementById('wdesk:H_CHECKLIST').value;
	customform.document.getElementById('wdesk:exceptionsRaisedForEmail').value = alreadyRaisedDesc(customform.document.getElementById('wdesk:wi_name').value,h_checklist);
	
	//If Status is deleted then send to discard directly
	if (customform.document.getElementById("wdesk:isRejected").value=="Yes")


	{
		if (workstepname=='Ops_Maker')
			customform.document.getElementById("wdesk:dec_maker").value = 'Forward';
		if (workstepname=='Ops_Maker_DB')
			customform.document.getElementById("wdesk:dec_maker_DB").value = 'Forward';
		else if (workstepname=='Ops_Checker')
			customform.document.getElementById("wdesk:dec_checker").value = 'Forward';
		else if (workstepname=='Ops_Checker_DB')
			customform.document.getElementById("wdesk:dec_checker_DB").value = 'Forward';
		return true;
	}
	
	var x;
	var rejectReasons=customform.document.getElementById('rejReasonCodes').value;
	var rejectReasonsSelected = false;
	if(rejectReasons!='' && rejectReasons!='NO_CHANGE')
		rejectReasonsSelected=true;
	
	if(workstepname=="CSO_Initiate")
	{
		var decision_tt = customform.document.getElementById('decisionRoute').value;
		var strCode = customform.document.getElementById("wdesk:strCode").value;
		var strPrefRate = customform.document.getElementById("wdesk:pref_rate").value;
		
			if ((strCode=="EMPTY" || strCode=="911" || strCode=="2033" || strCode=="1362") && decision_tt != "Cancel")
			{
				alert("Payment Creation Timeout,please discard the case");
				return false;
			}
		
		if(strPrefRate!="" && strPrefRate!=null){
			var validateRate = /^\d{1,3}\.?\d{1,10}$/;
			var fVal = /^\d{1,3}$/;
			var sVal = /^\d{1,10}$/;
			
			var lng = strPrefRate.length;
			if(lng >0)
			{
				if(strPrefRate.indexOf(".") == -1)
				{
					if(strPrefRate.length> 14 || !strPrefRate.match(fVal))
					{
						alert("Please Enter Valid Preferential Rate. (Format: $$$.$$$$$$$$$$)");
						setFocusOnField(customform,customform.document.getElementById("wdesk:pref_rate"));
						return false;
					}
				}else{
					var firstPart = strPrefRate.substring(0,strPrefRate.indexOf("."));
					var secondPart = strPrefRate.substring(strPrefRate.indexOf(".")+1);

					if(firstPart.length> 3 || secondPart.length > 10||!secondPart.match(sVal))
					{
						alert("Please Enter Valid Preferential Rate. (Format: $$$.$$$$$$$$$$)");
						setFocusOnField(customform,customform.document.getElementById("wdesk:pref_rate"));
						return false;
					}
					if( !firstPart.match(fVal))
					{
						if(firstPart.length==0)	{
							document.getElementById("wdesk:pref_rate").value = "0"+strPrefRate;
							setFocusOnField(customform,customform.document.getElementById("wdesk:pref_rate"));
							return false;
						}
						if(firstPart.length==1 && firstPart=="0") {
							setFocusOnField(customform,customform.document.getElementById("wdesk:pref_rate"));
							return false;
						}
						alert("Please Enter Valid Preferential Rate. (Format: $$$.$$$$$$$$$$)");
						setFocusOnField(customform,customform.document.getElementById("wdesk:pref_rate"));
						return false;
					}
				}
			}
		}
			if(decision_tt != "Cancel")
			{
				//var poCreationError=customform.document.getElementById('wdesk:remarks3').value;
				var date1 = customform.document.getElementById('wdesk:requestDate').value;
				
				if (date1!=null && date1!="")
				{
					var date2 = getServerDateTime ();
					var d = new Date();
					var n = d.getDate();
					var m = d.getMonth();

					var yr1 = date1.substring(date1.lastIndexOf("/") + 1);
					var dt1 =  date1.substring(0,date1.indexOf("/"));
					if (dt1.length == 1)
						dt1 = "0"+dt1;
					var temp = date1.substring(date1.indexOf("/") + 1);
					var mon1 =  temp.substring(0,temp.indexOf("/"));

					if (mon1.length == 1)
						mon1 = "0"+mon1;
					
					var dt2  = date2.substring(8,10);
					var mon2 = date2.substring(5,7);
					var yr2  = date2.substring(0,4);
					
					if(yr1.length==2)
						yr1 = yr2.substring(0,2)+yr1;
					date1 = mon1 + "/" + dt1 + "/" + yr1;
					date2 = mon2 + "/" + dt2 + "/" + yr2;
					date1  = new Date(date1);
					date2  = new Date(date2);

					var timeDiff = Math.abs(date2.getTime() - date1.getTime());
					var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24)); 
				
					if(date1 > date2)
					{
						alert("Date cannot be a future date, please select cancel as decision");
						return false;
					}
					if( diffDays > '10' && decision_tt != "Cancel") 
					{
						if(customform.document.getElementById('FlagToCheckReqDate').value!="Y")
						{

							//alert('Difference of Requested Date and Scan cannot be more than 10 days, please select cancel as decision');
							if(confirm("Difference of requested date and scan date is more than 10 days, please verify before submitting"))
							{
								customform.document.getElementById('FlagToCheckReqDate').value="Y";
								//return true;
							}
							else {
								return false;
							}
						}
					}
				}
				
				x = customform.document.getElementById('wdesk:acc_status').value;
				if(x!="Open" && x!="Active" && x!="Credit Frozen" && x!="") {
					alert('Account status is ' +x +', please select cancel as decision');
					setFocusOnField(customform,customform.document.getElementById("decisionRoute"));
					return false;
				}
				
				//Mandatory Fields

				//Debit Account Number
				x = customform.document.getElementById('wdesk:debt_acc_num').value;
				if (x == null || x == "") {
					alert("Please enter Debit Account Number");
					setFocusOnField(customform,customform.document.getElementById("wdesk:debt_acc_num"));		
					return false;
				}

				//Application Received original
				x = customform.document.getElementById('app_received').value;
				if (x == null || x == "" || x== "--Select--") {					
					alert("Please select Application Received Original");
					setFocusOnField(customform,customform.document.getElementById("app_received"));
					return false;
				}
				//Transfer Amount Check
				x = customform.document.getElementById('wdesk:trans_amt').value;
				if (x == null || x == "") {
					alert("Please enter Transfer Amount");
					setFocusOnField(customform,customform.document.getElementById("wdesk:trans_amt"));		
					return false;
				}
				else if (x == 0) {
					alert("Transfer Amount cannot be zero");
					setFocusOnField(customform,customform.document.getElementById("wdesk:trans_amt"));		
					return false;
				}
				
				//Transfer Currency Check
				x = customform.document.getElementById("transamtcurr").value;
				if (x== null || x=="" || x=="--Select--")	{
					alert("Please select transfer currency");
					setFocusOnField(customform,customform.document.getElementById("transamtcurr"));		
					return false;
				}
								
				//Remittance Currency Check
				x = customform.document.getElementById("remitamtcurr").value;
				if (x== null || x=="" || x=="--Select--")	{					
						alert("Please select remittance currency");
						setFocusOnField(customform,customform.document.getElementById("remitamtcurr"));		
						return false;
				}
				
				
				//Fcy_rate	
				x = customform.document.getElementById('wdesk:fcy_rate').value;
				if (x== null || x=="")	{
					alert("Exchange Rate is mandatory. Please fetch exchange rate");
					setFocusOnField(customform,customform.document.getElementById("getFxRate"));		
					return false;
				}
				//Moved the insufficient remarks before checking handwritten cases
				var boolgetAccBal = document.getElementById('customform').contentWindow.accountBalanceDetails();	
				
				if (boolgetAccBal) {
					x = customform.document.getElementById('wdesk:bal_sufficient').value ;
					if (x == 'No' ) {
						var y = customform.document.getElementById('wdesk:remarks').value ;
						
						if (y == null || y == "" ) {
							alert("Balance Insufficient, please enter remarks or cancel transaction");
							setFocusOnField(customform,customform.document.getElementById("wdesk:remarks"));
							return false;
						}
					}
				}
				else
					return false;
				
				// Start - making Authorized Signatory field mandatory at CSO_Initiate
				var Auth_Sig = customform.document.getElementById('authorized_sign').value ;
				if (Auth_Sig == "--Select--") {
					alert("Please Select Authorized Signatory");
					setFocusOnField(customform,customform.document.getElementById("authorized_sign"));	
					return false;    
				}
				// End - making Authorized Signatory field mandatory at CSO_Initiate
				
				//Start - Changes done for Cross Border payment CR - 13082017
				//Transaction Type
				var TransType =  customform.document.getElementById("transtype").value;
				if(TransType =="--Select--") { //Changes done for Cross Border payment CR - 13082017 - making permanent mandatory
					alert("Please Select the Transaction Type");
					setFocusOnField(customform,customform.document.getElementById("transtype"));
					return false;
				}
				//Transaction Code
				var TransCode =  customform.document.getElementById("transcode").value;
				if(TransCode =="--Select--" || TransCode == "") { //Changes done for Cross Border payment CR - 13082017 - making permanent mandatory
					alert("Please Select the Transaction Code");
					setFocusOnField(customform,customform.document.getElementById("transcode"));
					return false;
				}
				//Transaction Type to be selected based on isRetailCust
				var isRetailCust =  customform.document.getElementById("wdesk:isRetailCust").value;
				if (isRetailCust == 'N' && TransType == 'Individual'){
					alert("Please select Transaction Type as Business since Customer is not Retail");
					setFocusOnField(customform,customform.document.getElementById("transtype"));
					return false;
				} else if (isRetailCust == 'Y' && TransType == 'Business'){
					alert("Please select Transaction Type as Individual since Customer is Retail");
					setFocusOnField(customform,customform.document.getElementById("transtype"));
					return false;
				}
				//End - Changes done for Cross Border payment CR - 13082017
				
				//Handwritten Cases
				var isHandWritten =  customform.document.getElementById('wdesk:isHandWritten').value;

				//If it not handwritten than put the default value of isHandWritten to be N
				if (isHandWritten!='Y')
					customform.document.getElementById('wdesk:isHandWritten').value = 'N';

				isHandWritten =  customform.document.getElementById('wdesk:isHandWritten').value;

				var handwrittenFlag = validateHandWrittenCases (isHandWritten);
				
				if (handwrittenFlag == false)
					return false;
				else if (handwrittenFlag == true)
					return true;


				//Purpose Of Payment
				x = customform.document.getElementById('wdesk:purp_of_payment1').value;
				
				if(x==null) 
					x="";
				
				var y = customform.document.getElementById('wdesk:purp_of_payment2').value;
				
				if(y==null) 
					y="";
				
				var z = customform.document.getElementById('wdesk:purp_of_payment3').value;
				
				if(z==null) 
					z="";
				
				if (x == "" && y == "" && z == "") {
					if (isHandWritten != 'Y')
					{
						var result = confirm("Purpose of Payment is not provided, it will considered as handwritten case,please confirm");
						if (result==true)
						{
							customform.document.getElementById('wdesk:isHandWritten').value = 'Y';
							customform.document.getElementById('decisionRoute').value = 'Submit';
							return true;
						}
						else
							customform.document.getElementById('wdesk:isHandWritten').value = 'N';
							
						setFocusOnField(customform,customform.document.getElementById("wdesk:purp_of_payment1"));
						return false;
					}
				}
					
				//Beneficiary bank Country
				x = customform.document.getElementById('benefBankCntryCombo').value ;
				if (x == null || x == "" || x=='--Select--') {
					alert("Beneficiary Bank Country is not provided, please provide the same");
					setFocusOnField(customform,customform.document.getElementById("benefBankCntryCombo"));
					return false;
				}
				
				//Check ibanValidation according to Beneficiary bank Country
				if (isHandWritten != 'Y') {
					if ((iBanValidation (workstepname,x)) == false)
						return false;
				}
				
				//Transaction Type
				/*y =  customform.document.getElementById("remitamtcurr").value;
				z =  customform.document.getElementById("transtype").value;
				//if(x =="UNITED ARAB EMIRATES" && y =="AED" && z =="--Select--") { // commented
				if(z =="--Select--") { //Changes done for Cross Border payment CR - 13082017 - making permanent mandatory
					alert("Please Select the Transaction Type");
					setFocusOnField(customform,customform.document.getElementById("transtype"));
					return false;
				}
				//Transaction Code
				y =  customform.document.getElementById("remitamtcurr").value;
				z =  customform.document.getElementById("transcode").value;
				//if(x =="UNITED ARAB EMIRATES" && y =="AED" && z =="--Select--") { // commented
				if(z =="--Select--") { //Changes done for Cross Border payment CR - 13082017 - making permanent mandatory
					alert("Please Select the Transaction Code");
					setFocusOnField(customform,customform.document.getElementById("transcode"));
					return false;
				}*/
	
				//TTChanges 17042018 start
				
				var iban = customform.document.getElementById('wdesk:iban').value;
				var benef_name = customform.document.getElementById('wdesk:benef_name').value;
				var middlebenef_name = customform.document.getElementById('wdesk:middleName').value;
				var lastbenef_name = customform.document.getElementById('wdesk:lastName').value;
				var benefBankCode = customform.document.getElementById('wdesk:benefBankCode').value;
				var benefActualCode = customform.document.getElementById('wdesk:benefActualCode').value;
				var transcode = customform.document.getElementById('transcode').value;
				var remitamtcurr = customform.document.getElementById('remitamtcurr').value;
				var lastfifteen = iban.substr(iban.length - 15);
				var benefBankCntryCombo = customform.document.getElementById('benefBankCntryCombo').value;
				
				var Fifthchar = iban.charAt(4);
				var Sixthchar = iban.charAt(5);
				var Seventhchar = iban.charAt(6);
				
				var Firstchar = iban.charAt(0);
				var Secondchar = iban.charAt(1);
				
				var completeBenefName = benef_name;
				if(middlebenef_name != '')
					completeBenefName = completeBenefName+' '+middlebenef_name;
				if(lastbenef_name != '')
					completeBenefName = completeBenefName+' '+lastbenef_name;
				var BenefResponse = BenefValidationBasedOnIBAN(Fifthchar+Sixthchar+Seventhchar);
				if (iBanValidation(workstepname,benefBankCntryCombo))
				{
					if (BenefResponse != 'NOT_REQUIRED' && BenefResponse != '')
					{
						var BenefResponse1 = BenefResponse.split(',');
						var IBAN567Char = BenefResponse1[0];
						var BenefNameFromDB = BenefResponse1[1];
						var BenefBankCodeFromDB = BenefResponse1[2];
						var BenefActualCodeFromDB = BenefResponse1[3];
						var TransCodeFromDB = BenefResponse1[4];
						var RemitAmtCurrFromDB = BenefResponse1[5];
						
						if((Fifthchar+Sixthchar+Seventhchar) == IBAN567Char && (Firstchar+Secondchar) == 'AE' && iban.length == 23)
						{	
						// this means it a GIBAN(generated iban)
							if(completeBenefName != (BenefNameFromDB+' '+lastfifteen))
							{
								alert("Beneficiary Name should be "+(BenefNameFromDB+' '+lastfifteen));
								setFocusOnField(customform,customform.document.getElementById("wdesk:benef_name"));
								return false;
							}
							
							if(benefBankCode != BenefBankCodeFromDB)
							{
								alert("Beneficiary’s Bank code should be "+BenefBankCodeFromDB);
								setFocusOnField(customform,customform.document.getElementById("dropDownBenefBankCode"));
								return false;
							}
							if(!(benefActualCode.indexOf(BenefActualCodeFromDB))==0)
							{
								alert("Beneficiary’s Bank code should be "+BenefActualCodeFromDB);
								setFocusOnField(customform,customform.document.getElementById("wdesk:benefActualCode"));
								return false;
							}
							if (transcode != TransCodeFromDB)
							{
								alert("Transaction Code should be "+TransCodeFromDB);
								setFocusOnField(customform,customform.document.getElementById("transcode"));
								return false;
							}
							if(remitamtcurr != RemitAmtCurrFromDB)
							{
								alert("Remittance currency should be "+RemitAmtCurrFromDB);
								setFocusOnField(customform,customform.document.getElementById("remitamtcurr"));
								return false;
							}
						}
					}	
				}
				if(transcode =='TAX - TAX Payment')
				{
					if(remitamtcurr!="AED")
					{
						alert("Remittance currency should be AED");
						setFocusOnField(customform,customform.document.getElementById("remitamtcurr"));
						return false;
					}
					if((iBanValidation (workstepname,benefBankCntryCombo)) == false || BenefResponse == 'NOT_REQUIRED' || BenefResponse == '' || iban.length != 23 || (Firstchar+Secondchar) != 'AE')
					{
						alert("Account No. / IBAN should be a valid GIBAN number");
						setFocusOnField(customform,customform.document.getElementById("wdesk:iban"));
						return false;
					}
					
					if(customform.document.getElementById('benefBankCntryCombo').value !='UNITED ARAB EMIRATES')
					{
						alert("Beneficiary Bank Country should be UNITED ARAB EMIRATES when transaction code is TAX - TAX Payment");
						setFocusOnField(customform,customform.document.getElementById("benefBankCntryCombo"));
						return false;
					}
					
					if(customform.document.getElementById('countryOfResCombo').value !='UNITED ARAB EMIRATES')
					{
						alert("Beneficiary Country of Residence should be UNITED ARAB EMIRATES when transaction code is TAX - TAX Payment");
						setFocusOnField(customform,customform.document.getElementById("countryOfResCombo"));
						return false;
					}
					
					if (BenefResponse != 'NOT_REQUIRED' && BenefResponse != '')
					{
						var BenefResponse1 = BenefResponse.split(',');
						var IBAN567Char = BenefResponse1[0];
						var BenefNameFromDB = BenefResponse1[1];
						var BenefBankCodeFromDB = BenefResponse1[2];
						var BenefActualCodeFromDB = BenefResponse1[3];
						var TransCodeFromDB = BenefResponse1[4];
						var RemitAmtCurrFromDB = BenefResponse1[5];
						if((Fifthchar+Sixthchar+Seventhchar) == IBAN567Char && (Firstchar+Secondchar) == 'AE' && iban.length == 23)
						{
							if(completeBenefName != (BenefNameFromDB+' '+lastfifteen))
							{
								alert("Beneficiary Name should be "+(BenefNameFromDB+' '+lastfifteen));
								setFocusOnField(customform,customform.document.getElementById("wdesk:benef_name"));
								return false;
							}
							if(benefBankCode != BenefBankCodeFromDB)
							{
								alert("Beneficiary’s Bank code should be "+BenefBankCodeFromDB);
								setFocusOnField(customform,customform.document.getElementById("dropDownBenefBankCode"));
								return false;
							}
							if(!(benefActualCode.indexOf(BenefActualCodeFromDB))==0)
							{
								alert("Beneficiary’s Bank code should be "+BenefActualCodeFromDB);
								setFocusOnField(customform,customform.document.getElementById("wdesk:benefActualCode"));
								return false;
							}
						}	
					}	
				}
				//TTChanges 17042018 end
				//Decision Route
				x = customform.document.getElementById('decisionRoute').value;
				//alert(x);
				if (x == "--Select--" ) {
					alert("Please Select Decision");
					setFocusOnField(customform,customform.document.getElementById("decisionRoute"));
					return false;
				}
				else if (x == "Submit")
				{
					x = customform.document.getElementById('benefBankCntryCombo').value ;
						y =  customform.document.getElementById("remitamtcurr").value;
						var p =  customform.document.getElementById("wdesk:interBankName").value;
						var q =  customform.document.getElementById("wdesk:interBankCntryCombo").value;
						var r =  customform.document.getElementById("wdesk:interBankBranch").value;
						var s =  customform.document.getElementById("wdesk:interCityState").value;
						var t =  customform.document.getElementById("dropDownInterBankCode").value;
						var u =  customform.document.getElementById("wdesk:interActualCode").value;
						
						//alert("case submit: benefBankCntryCombo: "+x+" remitamtcurr: "+y+" interBankName: "+p+" interBankCntryCombo: "+q+" interBankBranch: "+r+" interCityState: "+s+" dropDownInterBankCode: "+ t+ " interActualCode: "+u);
						if(x !="UNITED ARAB EMIRATES" && y =="AED")
						{
							
							if((p != null && p != "") || (q != null && q != "" && q !='--Select--') || (r != null && r != "") || (s != null && s != "") ||( t != null && t != "" && t !='--Select--') ||( u != null && u != ""))
							{
							
								if (window.confirm("Intermediary details will be deleted, press OK to delete or CANCEL") == true)
								{
									 customform.document.getElementById("wdesk:interBankName").value ='';
									 customform.document.getElementById("wdesk:interBankCntryCombo").value ='';
									 customform.document.getElementById("wdesk:interBankCntry").value ='';
									 customform.document.getElementById("wdesk:interBankBranch").value='';
									 customform.document.getElementById("wdesk:interCityState").value='';
									 customform.document.getElementById("dropDownInterBankCode").value='';
									 customform.document.getElementById("wdesk:interBankCode").value='';
									 customform.document.getElementById("wdesk:interActualCode").value='';
									// return true;
								} 
								else {
									return false;
									}
								
							}
						}
					calculateMidRate(customform);
					var dateTime = getServerDateTime ();
					customform.document.getElementById("wdesk:scanDate").value = dateTime;
					calculateCutOfftime();
					//Firing call to generate TT Ref Num when following conditins are met so that workitem will move to RemittanceHelpDesk_Checker
					//is_po_created = N,ishandwritten = N,and pref_rate!=fcy_rate
					x = customform.document.getElementById('wdesk:is_po_created').value;
					var a = customform.document.getElementById('wdesk:isHandWritten').value;
					var b = customform.document.getElementById('wdesk:pref_rate').value;
					var c = customform.document.getElementById('wdesk:fcy_rate').value;
					if (x=='N' && a=='N') {
						if (b=='' ||(b!='' && b==c)) {
							if (customform.document.getElementById("memopadFetchSuccess").value == 'N') {
								alert("Memopad call failed, please retry or Cancel the transaction");
								return false;
							}
							/*document.getElementById('customform').contentWindow.getTTRefNum();
							
							//Make user to take decision cancelled if the strCode is 911 or empty
							strCode = customform.document.getElementById("wdesk:strCode").value;
							if (strCode=="EMPTY" || strCode=="911" || strCode=="2033"|| strCode=="1362") {
								alert("Payment Creation Timeout, please discard the case");
								return false;
							}
							//When TT is not generated, stop user moving workitem from CSO_Initiate
							var TTRefNum = customform.document.getElementById("wdesk:payment_order_id").value;
							if(TTRefNum==null || TTRefNum=="")
								return false;*/
						}
					}
					
					
				}
			}
			else {
				var y = customform.document.getElementById('wdesk:remarks').value ;
				if (y == null || y == "" ) {
						alert("Please enter remarks field");
						setFocusOnField(customform,customform.document.getElementById("wdesk:remarks"));
						return false;
					}
				if (!rejectReasonsSelected) {
					alert("Please select reject reason for Cancelling the Case");
					setFocusOnField(customform,customform.document.getElementById("btnRejReason"));
					return false;
				}
			}
	}
	else if(workstepname=="OPS_Initiate")
	{
		x = customform.document.getElementById('wdesk:cif_id').value;
		if (x == null || x == "") {
			alert("Please enter CIF ID");
			setFocusOnField(customform,customform.document.getElementById("wdesk:cif_id"));		
			return false;
		}
		
		x = customform.document.getElementById('wdesk:debt_acc_num').value;
		if (x == null || x == "") {
			alert("Please enter Debit Account Number");
			setFocusOnField(customform,customform.document.getElementById("wdesk:debt_acc_num"));		
			return false;
		}
		
		x = customform.document.getElementById('wdesk:channel_id').value;
		if (x == null || x == "" || x== "--Select--") {					
			alert("Please select Channel Id");
			setFocusOnField(customform,customform.document.getElementById("wdesk:channel_id"));
			return false;
		}
		
		x = customform.document.getElementById('wdesk:payment_order_id').value;
		if (x == null || x == "") {
			alert("Please enter Payment Order Id");
			setFocusOnField(customform,customform.document.getElementById("wdesk:payment_order_id"));		
			return false;
		}
		
		//CR changes 
		var h_checklist = customform.document.getElementById('wdesk:H_CHECKLIST').value;
		var responseAlreadyRaised = alreadyRaised(customform.document.getElementById('wdesk:wi_name').value,h_checklist);
		if(responseAlreadyRaised==null || responseAlreadyRaised=="" ||responseAlreadyRaised.indexOf("~[Raised")==-1){
			alert("Please raise any exception to initiate the workitem");
			setFocusOnField(customform,customform.document.getElementById("view_raise_excep"));		
			return false;
		}
		else{
			if(	responseAlreadyRaised.indexOf('001~[Raised') != -1 ||responseAlreadyRaised.indexOf('002~[Raised') != -1 ||responseAlreadyRaised.indexOf('003~[Raised') != -1 ||responseAlreadyRaised.indexOf('005~[Raised') != -1 ||responseAlreadyRaised.indexOf('007~[Raised') != -1 ||responseAlreadyRaised.indexOf('009~[Raised') != -1 ||responseAlreadyRaised.indexOf('010~[Raised') != -1 ||responseAlreadyRaised.indexOf('011~[Raised') != -1 ||responseAlreadyRaised.indexOf('012~[Raised') != -1 ||responseAlreadyRaised.indexOf('013~[Raised') != -1 ||responseAlreadyRaised.indexOf('014~[Raised') != -1 ||responseAlreadyRaised.indexOf('015~[Raised') != -1 ||responseAlreadyRaised.indexOf('016~[Raised') != -1 ||responseAlreadyRaised.indexOf('017~[Raised') != -1 ||responseAlreadyRaised.indexOf('018~[Raised') != -1 ||responseAlreadyRaised.indexOf('019~[Raised') != -1 ||responseAlreadyRaised.indexOf('020~[Raised') != -1 ||responseAlreadyRaised.indexOf('020~[Raised') != -1 ||responseAlreadyRaised.indexOf('022~[Raised') != -1 ||responseAlreadyRaised.indexOf('023~[Raised') != -1 ||responseAlreadyRaised.indexOf('024~[Raised') != -1 ||responseAlreadyRaised.indexOf('025~[Raised') != -1 ||responseAlreadyRaised.indexOf('026~[Raised') != -1 ||responseAlreadyRaised.indexOf('027~[Raised') != -1 ||responseAlreadyRaised.indexOf('028~[Raised') != -1 ||responseAlreadyRaised.indexOf('029~[Raised') != -1 ||responseAlreadyRaised.indexOf('030~[Raised') != -1 ||responseAlreadyRaised.indexOf('031~[Raised') != -1 ||responseAlreadyRaised.indexOf('032~[Raised') != -1 ||responseAlreadyRaised.indexOf('033~[Raised') != -1 )
				customform.document.getElementById('wdesk:isBusinessExcp').value = "Y";
			else
				customform.document.getElementById('wdesk:isBusinessExcp').value = "N";
		}
		x = customform.document.getElementById('decisionRoute').value ;
		if (x == "--Select--" ) {
			alert("Please Select Decision");
			setFocusOnField(customform,customform.document.getElementById("decisionRoute"));	
			return false;    
		}
	}
	else if(workstepname=="Ops_Hold")
	{
		x = customform.document.getElementById('decisionRoute').value ;
		if (x == "--Select--" ) {
			alert("Please Select Decision");
			
			setFocusOnField(customform,customform.document.getElementById("decisionRoute"));	
			return false;
		}
	}
	
	else if(workstepname=="CSO_Exceptions")
	{
		var decision_tt = customform.document.getElementById('decisionRoute').value ;
		var channel_id = customform.document.getElementById('wdesk:channel_id').value;

		if (decision_tt == "--Select--" ) {
			alert("Please Select Decision");
			setFocusOnField(customform,customform.document.getElementById("decisionRoute"));
			return false;
		}
		else if ((channel_id=='IB' || channel_id=='MB' || channel_id=='YAP' || channel_id=='DIP') && (decision_tt=='Refer' || decision_tt=='Call Back Waiver Request')) {
			alert("Decision can only be Reject or Re-Submit");
			return false;
		}
		else if (decision_tt=='Refer')
		{
			x = customform.document.getElementById('assignToDropDown').value;
			if(x == null || x == "" || x=='--Select--') {
				alert("Please Assign someone for referring the case.");
				setFocusOnField(customform,customform.document.getElementById("assignToDropDown"));
				return false;
			}
		}	
		else if (decision_tt == "Reject")
		{
			if(!rejectReasonsSelected) {
				alert("Please select reject reasons if selecting decision as Reject");
				setFocusOnField(customform,customform.document.getElementById("btnRejReason"));
				return false;
			}
			else{
				if (customform.document.getElementById("sendBtnClicked").value == "Yes")
					return true;
				//When discarded the workitem Payment deletion call
				if (document.getElementById('customform').contentWindow.deletePaymentFromFinacle() == false) {
					customform.document.getElementById("deletePaymentDiv").style.display = "block";
					return false;
				}
				
			}
		}
		else if (decision_tt == "Re-Submit") 
		{
			var y = customform.document.getElementById('wdesk:pref_rate').value;
			var z = customform.document.getElementById('wdesk:dec_treasury').value;
			if(z=='Rate Modification Required' && (y == null || y == "" ))
			{
				alert("Please enter preferential rate");
				setFocusOnField(customform,customform.document.getElementById("wdesk:pref_rate"));
				return false;
		
			}
			if(rejectReasonsSelected){
				alert("Please remove reject reasons if selecting decision as Re-Submit");
				setFocusOnField(customform,customform.document.getElementById("btnRejReason"));
				return false;
			}
			else
			{
				if(z=='Rate Modification Required')	
				{
					document.getElementById('customform').contentWindow.accountBalanceDetails();
					x = customform.document.getElementById('wdesk:bal_sufficient').value ;
					if (x == 'No' ) {
						var y = customform.document.getElementById('wdesk:remarks').value ;
						
						if (y == null || y == "" ) {
							alert("Balance Insufficient, please enter remarks or reject transaction");
							setFocusOnField(customform,customform.document.getElementById("wdesk:remarks"));
							return false;
						}
					}
					calculateMidRate(customform);
				}
				return true;
			}
		
		}
		else if (x == "Call Back Waiver Request")
		{
			var p = customform.document.getElementById('wdesk:dec_treasury').value;			
			if(p=='Rate Modification Required')
			{
				alert("Decision cannot be Call Back Waiver Request. Please select Re-Submit or Reject decision.");
				setFocusOnField(customform,customform.document.getElementById("decisionRoute"));
				return false;
			}
			
			var y = customform.document.getElementById('wdesk:remarks').value ;
				if (y == null || y == "" ) {
				alert("Please enter remarks field");
				setFocusOnField(customform,customform.document.getElementById("wdesk:remarks"));

				return false;
			}
			
			if(rejectReasonsSelected){
				alert('Please remove reject reasons if selecting decision as "Call Back Waiver Request"');
				setFocusOnField(customform,customform.document.getElementById("btnRejReason"));
				return false;
			}
			else{
				return true;
			}
		}
		return true;
	 }
	 else if(workstepname=="Treasury")
	 {
			x = customform.document.getElementById('decisionRoute').value;
			if (x == "--Select--" ) {
				alert("Please Select Decision");
				setFocusOnField(customform,customform.document.getElementById("decisionRoute"));	
				return false;
			}
			else if (x == "Approve") 
			{
				
			}
			else if (x == "Data Entry Required") 
			{
				
			}
			else if (x == "Rate Modification Required") 
			{
				
			}
			calculateMidRate(customform);
			return true;
	 }
	 else if(workstepname=="PostCutOff_Init")
	 {
		x = customform.document.getElementById('decisionRoute').value ;
		if (x == "--Select--" ) {
		alert("Please Select Decision");
		setFocusOnField(customform,customform.document.getElementById("decisionRoute"));	
		return false;    
		}


		return true;
	 }
	 else if(workstepname=="RemittanceHelpDesk_Maker")
	 {
		var channel_id = customform.document.getElementById('wdesk:channel_id').value;
		if (customform.document.getElementById("sendBtnClicked").value == "Yes")
			return true;
		x = customform.document.getElementById('wdesk:payment_order_id').value ;
		if (x == "") {
			alert("Payment order id not generated the request cannot be submitted");
			return false;    
		}
			
		var h_checklist = customform.document.getElementById('wdesk:H_CHECKLIST').value;
		var responseAlreadyRaised = alreadyRaised(customform.document.getElementById('wdesk:wi_name').value,h_checklist);
	
		//Update in case of IB and MB on the basis of any exception raised
		if (channel_id=='IB' || channel_id=='MB' || channel_id=='YAP' || channel_id=='DIP') {
			if (responseAlreadyRaised.indexOf('~[Raised') != -1) //if raised
			{
				customform.document.getElementById('wdesk:isAnyExcepRaised').value = "Yes";
				
				if(	responseAlreadyRaised.indexOf('001~[Raised') != -1 ||responseAlreadyRaised.indexOf('002~[Raised') != -1 ||responseAlreadyRaised.indexOf('003~[Raised') != -1 ||responseAlreadyRaised.indexOf('005~[Raised') != -1 ||responseAlreadyRaised.indexOf('007~[Raised') != -1 ||responseAlreadyRaised.indexOf('009~[Raised') != -1 ||responseAlreadyRaised.indexOf('010~[Raised') != -1 ||responseAlreadyRaised.indexOf('011~[Raised') != -1 ||responseAlreadyRaised.indexOf('012~[Raised') != -1 ||responseAlreadyRaised.indexOf('013~[Raised') != -1 ||responseAlreadyRaised.indexOf('014~[Raised') != -1 ||responseAlreadyRaised.indexOf('015~[Raised') != -1 ||responseAlreadyRaised.indexOf('016~[Raised') != -1 ||responseAlreadyRaised.indexOf('017~[Raised') != -1 ||responseAlreadyRaised.indexOf('018~[Raised') != -1 ||responseAlreadyRaised.indexOf('019~[Raised') != -1 ||responseAlreadyRaised.indexOf('020~[Raised') != -1 ||responseAlreadyRaised.indexOf('020~[Raised') != -1 ||responseAlreadyRaised.indexOf('022~[Raised') != -1 ||responseAlreadyRaised.indexOf('023~[Raised') != -1 ||responseAlreadyRaised.indexOf('024~[Raised') != -1 ||responseAlreadyRaised.indexOf('025~[Raised') != -1 ||responseAlreadyRaised.indexOf('026~[Raised') != -1 ||responseAlreadyRaised.indexOf('027~[Raised') != -1 ||responseAlreadyRaised.indexOf('028~[Raised') != -1 ||responseAlreadyRaised.indexOf('029~[Raised') != -1 ||responseAlreadyRaised.indexOf('030~[Raised') != -1 ||responseAlreadyRaised.indexOf('031~[Raised') != -1 ||responseAlreadyRaised.indexOf('032~[Raised') != -1 ||responseAlreadyRaised.indexOf('033~[Raised') != -1 )
					customform.document.getElementById('wdesk:isBusinessExcp').value = "Y";	
				else
					customform.document.getElementById('wdesk:isBusinessExcp').value = "N";					
			}
			else 
			{
				customform.document.getElementById('wdesk:isAnyExcepRaised').value = "No";
				customform.document.getElementById('wdesk:isBusinessExcp').value = "N";
			}	
			
			//return true;
		}
		
		//set decision automatically
		if(responseAlreadyRaised.indexOf('~[Raised') != -1 && responseAlreadyRaised.indexOf('021~[Raised') != -1)
		{
			customform.document.getElementById('wdesk:dec_rem_helpdeskMaker').value='Restricted Nationality';
		}
		if(customform.document.getElementById('wdesk:dec_rem_helpdeskMaker').value != "Restricted Nationality")
		{
			//In case of Ruling Family and Call Back Required Yes
			x = customform.document.getElementById("wdesk:cust_type");
			var y = customform.document.getElementById("wdesk:call_back_req");
			var z = customform.document.getElementById('decisionRoute').value ;
			if (x!= null && x!="" && x.value=='Ruling Family' && y != null && y != "" && y.value=='Yes' && z== 'Submit') {
				//Check raised or not
				if (checkCallBackRaised() == true) {
					alert("Call Back Exception has to be removed for Cutomer Type - Ruling Family");
						return false;
				}
			}
			
			var isRulingFamily = customform.document.getElementById('wdesk:isRulingFamily').value;
			var y = customform.document.getElementById("callBackSuccess").value;
				
				if(isRulingFamily!= null && isRulingFamily!="" && isRulingFamily=='Yes' && y != "Yes" && y != "No")
				{
					if(customform.document.getElementById("wdesk:call_back_req").value!="No")
					{
						alert("Please select Call Back Successful");
						setFocusOnField(customform,customform.document.getElementById("callBackSuccess"));
						return false;
					}	
				}
				x = customform.document.getElementById('decisionRoute').value ;

						
					//If Business exception raised		
						if(
						responseAlreadyRaised.indexOf('~[Raised') != -1 	
							&& ( 
								responseAlreadyRaised.indexOf('001~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('002~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('003~[Raised') != -1 ||
								//responseAlreadyRaised.indexOf('004~[Raised') == -1 || 
								//responseAlreadyRaised.indexOf('005~[Raised') == -1 ||
								//responseAlreadyRaised.indexOf('006~[Raised') == -1 || 
								responseAlreadyRaised.indexOf('007~[Raised') != -1 ||
								//responseAlreadyRaised.indexOf('008~[Raised') == -1 ||
								responseAlreadyRaised.indexOf('009~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('010~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('011~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('012~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('013~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('014~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('015~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('016~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('017~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('018~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('019~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('020~[Raised') != -1 ||
								
								responseAlreadyRaised.indexOf('022~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('023~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('024~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('025~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('026~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('027~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('028~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('029~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('030~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('031~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('032~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('033~[Raised') != -1 ||
								responseAlreadyRaised.indexOf('034~[Raised') != -1 
								//034 added - Changes done for Cross Border payment CR - 13082017
							)
						)
					{
						customform.document.getElementById('wdesk:dec_rem_helpdeskMaker').value='Send to Business';
					}
					
					//Changing the call_back_req and comp_req to No, exceptions autoraised will change the status of both flags
					var call_back_req = "No";
					var comp_req = "No";
					
					
					if (responseAlreadyRaised.indexOf('001~[Raised') != -1)
					customform.document.getElementById("wdesk:isInsuffExcepRaise").value='Yes';
					else if (responseAlreadyRaised.indexOf('001~[Raised') == -1)
						customform.document.getElementById("wdesk:isInsuffExcepRaise").value='No';
					if (responseAlreadyRaised.indexOf('005~[Raised') != -1)	{ //If callback exception raised

						call_back_req='Yes';
						customform.document.getElementById("wdesk:call_back_req").value = call_back_req;
					}
					else
						customform.document.getElementById("wdesk:call_back_req").value = call_back_req;
					
					//If compliance exception raised
					if(responseAlreadyRaised.indexOf('006~[Raised') != -1 || responseAlreadyRaised.indexOf('004~[Raised') != -1 || responseAlreadyRaised.indexOf('008~[Raised') != -1)
					{
						comp_req='Yes';
						customform.document.getElementById("wdesk:comp_req").value=comp_req;
					}
					else
					customform.document.getElementById("wdesk:comp_req").value=comp_req;
					
					var dec_CSO_Exceptions = customform.document.getElementById('wdesk:dec_CSO_Exceptions').value;
					if (dec_CSO_Exceptions!= null && dec_CSO_Exceptions!="" && dec_CSO_Exceptions=='Call Back Waiver Request')
					{
						//var h_checklist = customform.document.getElementById('H_CHECKLIST').value;
						if (responseAlreadyRaised.indexOf('005~[Raised') != -1)								
							customform.document.getElementById('wdesk:isCallBackWaivedOff').value = 'No';								
						else {
							customform.document.getElementById('wdesk:isCallBackWaivedOff').value = 'Yes';
							//customform.document.getElementById('wdesk:callBackSuccess').value = 'Yes';
						}
					}
		}
		else {
		
			//commented on 12032016
			var y = "";//customform.document.getElementById('wdesk:isRestrictedFlag').value;
		
			if (responseAlreadyRaised.indexOf('021~[Raised') == -1)							
			{
				alert("Please raise the Restricted Nationality exception to take decision Restricted Nationality.");
				return false;
			}
		
			y = customform.document.getElementById('wdesk:remarks').value;
			
			if (y == null || y == "" ) {
				alert("Remarks are mandatory in case of Restricted Nationality");
				setFocusOnField(customform,customform.document.getElementById("wdesk:remarks"));
				return false;
			}
			
			//When discarded the workitem Payment deletion call
			if (document.getElementById('customform').contentWindow.deletePaymentFromFinacle() == false) {
				customform.document.getElementById("deletePaymentDiv").style.display = "block";
				return false;
			}
		}
	 }
	 else if( workstepname=="RemittanceHelpDesk_Checker")
	 {
			if (customform.document.getElementById("sendBtnClicked").value == "Yes")
				return true;
				
			x = customform.document.getElementById('wdesk:payment_order_id').value ;
			var dec_rem_helpdesk = customform.document.getElementById("wdesk:dec_rem_helpdesk").value;
			if (x == "") {
				alert("Payment order id not generated the request cannot be submitted");	
				return false;
			}
			var h_checklist = customform.document.getElementById('wdesk:H_CHECKLIST').value;
			var responseAlreadyRaised = alreadyRaised(customform.document.getElementById('wdesk:wi_name').value,h_checklist);
			
			//set decision automatically
			if(responseAlreadyRaised.indexOf('~[Raised') != -1 && responseAlreadyRaised.indexOf('021~[Raised') != -1)
				customform.document.getElementById('wdesk:dec_rem_helpdesk').value='Restricted Nationality';
			
			var issignaturematched = customform.document.getElementById('wdesk:sign_matched').value;
			if(issignaturematched==null  || issignaturematched=="" ){
						alert("Please match the signatures from Signature window");
						setFocusOnField(customform,customform.document.getElementById("view_sign"));
						return false;
					}
					else if (issignaturematched=="No") {
							
						if (responseAlreadyRaised.indexOf('003~[Raised') == -1) {
						
							alert("Please raise signature mismatch exception as signatures are not matched");									 
							setFocusOnField(customform,customform.document.getElementById("view_raise_excep"));
							return false;
						}
						else 
						
							customform.document.getElementById('wdesk:isSignatureExcepRaised').value = 'Yes';
					}
					else if(issignaturematched=="Yes" && responseAlreadyRaised.indexOf('003~[Raised') == -1) {
						
							customform.document.getElementById('wdesk:isSignatureExcepRaised').value = 'No';						
							}
			//Updating the value for checking if Restricted Nationality is raised
			dec_rem_helpdesk = customform.document.getElementById("wdesk:dec_rem_helpdesk").value;
			if(dec_rem_helpdesk != "Restricted Nationality")
			{
				//In case of Ruling Family and Call Back Required Yes
				x = customform.document.getElementById("wdesk:cust_type");
				var y = customform.document.getElementById("wdesk:call_back_req");
				var z = customform.document.getElementById('decisionRoute').value ;
				if (x!= null && x!="" && x.value=='Ruling Family' && y != null && y != "" && y.value=='Yes' && z== 'Submit') {
					//Check raised or not
					if (checkCallBackRaised() == true) {
						alert("Call Back Exception has to be removed for Cutomer Type - Ruling Family");
							return false;
					}
				}
			
				var isRulingFamily = customform.document.getElementById('wdesk:isRulingFamily').value;
				var y = customform.document.getElementById("callBackSuccess").value;
				
				if(isRulingFamily!= null && isRulingFamily!="" && isRulingFamily=='Yes' && y != "Yes" && y != "No")
				{
					if(customform.document.getElementById("wdesk:call_back_req").value!="No")
					{
						alert("Please select Call Back Successful");
						setFocusOnField(customform,customform.document.getElementById("callBackSuccess"));
						return false;
					}	
				}
					
				//If Business exception raised		
				var h_checklist = customform.document.getElementById('wdesk:H_CHECKLIST').value;	
				if(responseAlreadyRaised.indexOf('~[Raised') != -1 	
						&& ( 
							
							responseAlreadyRaised.indexOf('002~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('003~[Raised') != -1 ||
							//responseAlreadyRaised.indexOf('004~[Raised') == -1 || 
							//responseAlreadyRaised.indexOf('005~[Raised') == -1 ||
							//responseAlreadyRaised.indexOf('006~[Raised') == -1 || 
							responseAlreadyRaised.indexOf('007~[Raised') != -1 ||
							//responseAlreadyRaised.indexOf('008~[Raised') == -1 ||
							responseAlreadyRaised.indexOf('009~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('010~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('011~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('012~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('013~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('014~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('015~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('016~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('017~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('018~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('019~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('020~[Raised') != -1 ||
							
							responseAlreadyRaised.indexOf('022~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('023~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('024~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('025~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('026~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('027~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('028~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('029~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('030~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('031~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('032~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('033~[Raised') != -1 ||
							responseAlreadyRaised.indexOf('034~[Raised') != -1 
							//034 - Changes done for Cross Border payment CR - 13082017
						)
					)
				{
					customform.document.getElementById('wdesk:dec_rem_helpdesk').value='Send to Business';
					 
					var issignaturematched = customform.document.getElementById('wdesk:sign_matched').value;
					
					if(issignaturematched=="Yes" && responseAlreadyRaised.indexOf('003~[Raised') != -1) {				
						
							alert("Please remove the raised signature mismatch exception");
							setFocusOnField(customform,customform.document.getElementById("view_raise_excep"));
							return false;
						}
				}
				
				//Changing the call_back_req and comp_req to No, exceptions autoraised will change the status of both flags
				var call_back_req = "No";
				var comp_req = "No";
				if (responseAlreadyRaised.indexOf('001~[Raised') != -1)
					customform.document.getElementById("wdesk:isInsuffExcepRaise").value='Yes';
				else if (responseAlreadyRaised.indexOf('001~[Raised') == -1)
					customform.document.getElementById("wdesk:isInsuffExcepRaise").value='No';
				
				if (responseAlreadyRaised.indexOf('005~[Raised') != -1)	{ //If callback exception raised
					call_back_req='Yes';
					customform.document.getElementById("wdesk:call_back_req").value = call_back_req;
				}
				else
					customform.document.getElementById("wdesk:call_back_req").value = call_back_req;
				
				//If compliance exception raised
				if(responseAlreadyRaised.indexOf('006~[Raised') != -1 || responseAlreadyRaised.indexOf('004~[Raised') != -1 || responseAlreadyRaised.indexOf('008~[Raised') != -1)
				{
					if(comp_req!='Yes')
						comp_req='Yes';
					customform.document.getElementById("wdesk:comp_req").value=comp_req;
				}
				else
					customform.document.getElementById("wdesk:comp_req").value=comp_req;
				
				var dec_CSO_Exceptions = customform.document.getElementById('wdesk:dec_CSO_Exceptions').value;
				if (dec_CSO_Exceptions!= null && dec_CSO_Exceptions!="" && dec_CSO_Exceptions=='Call Back Waiver Request') {
					
					if (responseAlreadyRaised.indexOf('005~[Raised') != -1)								
						customform.document.getElementById('wdesk:isCallBackWaivedOff').value = 'No';								
					else {
						customform.document.getElementById('wdesk:isCallBackWaivedOff').value = 'Yes';
						//customform.document.getElementById('wdesk:callBackSuccess').value = 'Yes';
					}
				}
			}
			else{
				var y = "";//customform.document.getElementById('wdesk:isRestrictedFlag').value; //Dummy value
				y = customform.document.getElementById('wdesk:remarks').value;

				if (y == null || y == "" ) {
					alert("Remarks are mandatory in case of Restricted Nationality");
					setFocusOnField(customform,customform.document.getElementById("wdesk:remarks"));
					return false;
				}
				//When discarded the workitem Payment deletion call
				if (document.getElementById('customform').contentWindow.deletePaymentFromFinacle() == false){
					customform.document.getElementById("deletePaymentDiv").style.display = "block";
					return false;
				}
			}
			
		return true;	
	 }
	 else if(workstepname=="CallBack")
	 {
			//Prospect Number
			x = customform.document.getElementById('wdesk:prospect_Num').value ;
			if (x == null || x == "") {
				alert("Please provide the Prospect Number");
				setFocusOnField(customform,customform.document.getElementById("wdesk:prospect_Num"));
				return false;
			}
			//CallBack Success
			x = customform.document.getElementById('wdesk:callBackSuccess').value ;
			if (x == null || x == "") {
				alert("Call back Successful can not be Blank");
				
				if(customform.document.getElementById('wdesk:attempt1').value=="" || customform.document.getElementById('wdesk:attempt1').value=="--Select--" )
					setFocusOnField(customform,customform.document.getElementById("call_back_success1"));
				else if(customform.document.getElementById('wdesk:attempt2').value=="" || customform.document.getElementById('wdesk:attempt2').value=="--Select--" )
					setFocusOnField(customform,customform.document.getElementById("call_back_success2"));
				else
					setFocusOnField(customform,customform.document.getElementById("call_back_success3"));
					
				return false;
			}
			
			//Call Back Customer Verification
			x = customform.document.getElementById('dropDownCallBackCustVerf').value ;
				
			if (x == "--Select--" ) {
				alert("Please Select Call Back Customer Verification");
				setFocusOnField(customform,customform.document.getElementById("dropDownCallBackCustVerf"));
				return false;    
			}
			
			//Decision
			x = customform.document.getElementById('decisionRoute').value ;
				//alert(x);
				if (x == "--Select--" ) {
					alert("Please Select Decision");
					setFocusOnField(customform,customform.document.getElementById("decisionRoute"));
				return false;    
				}
				else if (x == "Successful") 
				{					
					//Call Back Customer is Not Verified
					x = customform.document.getElementById('dropDownCallBackCustVerf').value ;							
				
					if(x == 'Not Verified') {
						alert('Call Back Customer is Not Verified, cannot take decision to be Successful');
						setFocusOnField(customform,customform.document.getElementById("dropDownCallBackCustVerf"));
						return false;
					}
					
					//Call Back is Unsuccessful
					x = customform.document.getElementById('wdesk:callBackSuccess').value ;							
				
					if(x == 'No'){
						alert('Call Back is Unsuccessful , please select decision to be "Call Back Unsuccessful"');
						setFocusOnField(customform,customform.document.getElementById("decisionRoute"));
						return false;
					}
					
				}
				else if (x == "Call Back Unsuccessful") 
				{
					x = customform.document.getElementById('wdesk:callBackSuccess').value ;							
				
					//Call Back is Successful
					if(x == 'Yes'){
						alert('Call Back is Successful , please select decision to be Successful');
						setFocusOnField(customform,customform.document.getElementById("decisionRoute"));
						return false;
					}
				
					//Call Back failure reasons
					x = customform.document.getElementById('dropDownCallBackFailureReason').value ;							
				
					if(x == '--Select--'){
						alert('Please select failure reasons if selecting decision as "Call Back Unsuccessful"');
						setFocusOnField(customform,customform.document.getElementById("dropDownCallBackFailureReason"));
						return false;
					}
					x = customform.document.getElementById('wdesk:remarks').value;
				
					if (x == null || x == "" ) {
						alert('Remarks are mandatory if selecting decision as "Call Back Unsuccessful"');
						setFocusOnField(customform,customform.document.getElementById("wdesk:remarks"));

						return false;
					}
					// sendEmailToCustomerOnCallbackDone in case of call back unsuccessful
					sendEmailToCustomerOnCallbackDone(customform);
				}
			return true;
	 }
	 else if(workstepname=="Comp_Check")
	 {
			var decision_tt = customform.document.getElementById('decisionRoute').value ;
			var channel_id = customform.document.getElementById('wdesk:channel_id').value;			
			
			if (decision_tt == "--Select--" ) {
				alert("Please Select Decision");
				setFocusOnField(customform,customform.document.getElementById("decisionRoute"));
				return false;
			}
			else if (decision_tt=='Refer')
			{
				x = customform.document.getElementById('assignToDropDown').value;
				if(x == null || x == "") {
					alert("Please Assign someone for referring the case.");
					setFocusOnField(customform,customform.document.getElementById("assignToDropDown"));
					return false;
				}
			}
			else if(decision_tt != "Reject")
			{
				/*if ((channel_id=='IB' || channel_id=='MB') && decision_tt=='Additional Documents required') {
					var sendToGroup = customform.document.getElementById('wdesk:sendToGroup').value;
					if (sendToGroup=='' || sendToGroup=='--Select--')
					{
						alert("Please select send to value");
						setFocusOnField(customform,customform.document.getElementById("sendToDropDown"));
						return false;
					}
					
				}*/ //commented as part of CR on 15112016
				if (decision_tt == "Approve") {

					if(rejectReasonsSelected){
						alert("Please remove reject reasons if selecting decision as Submit");
						setFocusOnField(customform,customform.document.getElementById("btnRejReason"));
						return false;
					}
				}
			}
			else if (decision_tt == "Reject") {
				var y = customform.document.getElementById('wdesk:remarks').value ;
				if (y == null || y == "" ) {
					alert("Please enter remarks field");
					setFocusOnField(customform,customform.document.getElementById("wdesk:remarks"));
					return false;
				}
			
				//When discarded the workitem Payment deletion call
				if(!rejectReasonsSelected){
					alert("Please select reject reasons if selecting decision as Reject");
					setFocusOnField(customform,customform.document.getElementById("btnRejReason"));
					return false;
				}
				else {
					if (customform.document.getElementById("sendBtnClicked").value == "Yes")
						return true;
					//When discarded the workitem Payment deletion call
					if (document.getElementById('customform').contentWindow.deletePaymentFromFinacle() == false){
						customform.document.getElementById("deletePaymentDiv").style.display = "block";
						return false;
					}
				}
			}
		return true;
	 }
	  else if(workstepname=="Ops_DataEntry")
	 {
		var decision_tt = customform.document.getElementById('decisionRoute').value ;
	
		if(decision_tt == "Submit")
		{
			//Charges option
			x = customform.document.getElementById("wdesk:chargesCombo").value;
			if (x== null || x=="" || x=="--Select--")	{						
				alert("Charges not selected");
				setFocusOnField(customform,customform.document.getElementById("wdesk:chargesCombo"));
				return false;
			}
			
			//Transaction Type
			/*x = customform.document.getElementById('benefBankCntryCombo').value;
			x = x.toUpperCase();
			var y =  customform.document.getElementById("remit_amt_curr").value;
			var z =  customform.document.getElementById("transtype").value;
			//if(x =="UNITED ARAB EMIRATES" && y =="AED" && z =="--Select--") // commented
			if(z =="--Select--") //Changes done for Cross Border payment CR - 13082017 - making permanent mandatory
			{
				alert("Please Select the Transaction Type");
				setFocusOnField(customform,customform.document.getElementById("transtype"));
				return false;
			}
			//Transaction Code
			y =  customform.document.getElementById("remit_amt_curr").value;
			z =  customform.document.getElementById("transcode").value;
			//if(x =="UNITED ARAB EMIRATES" && y =="AED" && z =="--Select--") // commented
			if(z =="--Select--") //Changes done for Cross Border payment CR - 13082017 - making permanent mandatory
			{
				alert("Please Select the Transaction Code");
				setFocusOnField(customform,customform.document.getElementById("transcode"));
				return false;
			}*/ 
			
			//Start - Changes done for Cross Border payment CR - 13082017
			//Transaction Type
			var TransType =  customform.document.getElementById("transtype").value;
			if(TransType =="--Select--") { //Changes done for Cross Border payment CR - 13082017 - making permanent mandatory
				alert("Please Select the Transaction Type");
				setFocusOnField(customform,customform.document.getElementById("transtype"));
				return false;
			}
			//Transaction Code
			var TransCode =  customform.document.getElementById("transcode").value;
			if(TransCode =="--Select--" || TransCode == "") { //Changes done for Cross Border payment CR - 13082017 - making permanent mandatory
				alert("Please Select the Transaction Code");
				setFocusOnField(customform,customform.document.getElementById("transcode"));
				return false;
			}
			//Transaction Type to be selected based on isRetailCust
			var isRetailCust =  customform.document.getElementById("wdesk:isRetailCust").value;
			if (isRetailCust == 'N' && TransType == 'Individual'){
				alert("Please select Transaction Type as Business since Customer is not Retail");
				setFocusOnField(customform,customform.document.getElementById("transtype"));
				return false;
			} else if (isRetailCust == 'Y' && TransType == 'Business'){
				alert("Please select Transaction Type as Individual since Customer is Retail");
				setFocusOnField(customform,customform.document.getElementById("transtype"));
				return false;
			}
			//End - Changes done for Cross Border payment CR - 13082017

			//Purpose Of Payment
			var p =  customform.document.getElementById("wdesk:remit_amt_curr").value;
			//alert('p'+p);
			var q = customform.document.getElementById('benefBankCntryCombo').value;
			q = q.toUpperCase();
			//alert('q'+q);
			x = customform.document.getElementById('wdesk:purp_of_payment1').value;

			if(x==null) 
				x="";

			var y = customform.document.getElementById('wdesk:purp_of_payment2').value;

			if(y==null) 
				y="";

			var z = customform.document.getElementById('wdesk:purp_of_payment3').value;

			if(z==null) 
				z="";

			if (q !="UNITED ARAB EMIRATES" && p !="AED" && x == "" && y == "" && z == "") {						
				//alert('test');
				var result = alert("Purpose of Payment is not provided, please provide the same");		
				setFocusOnField(customform,customform.document.getElementById("wdesk:purp_of_payment1"));
				return false;	
			}

			// Beneficiary name
			x = customform.document.getElementById('wdesk:benef_name').value;
			if (x == null || x == "" ) {
				alert("Beneficiary Name not provided, please provide the same");
				setFocusOnField(customform,customform.document.getElementById("wdesk:benef_name"));
				return false;
			}


			//Beneficiary Account Number or iban
			x = customform.document.getElementById('wdesk:iban').value ;
			if (x == null || x == "" ) {
				alert("Beneficiary Account Number/IBAN is not provided, please provide the same");
				setFocusOnField(customform,customform.document.getElementById("wdesk:iban"));
				return false;	
			}

			//Country of Incorporation
			x = customform.document.getElementById('countryOfResCombo').value;
			if (x == null || x == "" || x=='--Select--') {	
				alert("Country of Residence/Incorporation not provided, please provide the same");
				setFocusOnField(customform,customform.document.getElementById("countryOfResCombo"));
				return false;
			}

			//Beneficiary bank Country
			x = customform.document.getElementById('benefBankCntryCombo').value ;
			if (x == null || x == "" || x=='--Select--') {
				alert("Beneficiary Bank Country is not provided, please provide the same");
				setFocusOnField(customform,customform.document.getElementById("benefBankCntryCombo"));
				return false;
			}				
			
			//Check ibanValidation according to Beneficiary bank Country
			if ((iBanValidation (workstepname,x)) == false)
				return false;
				
				
				
				x = customform.document.getElementById('benefBankCntryCombo').value ;
						y =  customform.document.getElementById("wdesk:remit_amt_curr").value;
						var p =  customform.document.getElementById("wdesk:interBankName").value;
						var q =  customform.document.getElementById("wdesk:interBankCntryCombo").value;
						var r =  customform.document.getElementById("wdesk:interBankBranch").value;
						var s =  customform.document.getElementById("wdesk:interCityState").value;
						var t =  customform.document.getElementById("dropDownInterBankCode").value;
						var u =  customform.document.getElementById("wdesk:interActualCode").value;
				if(x !="UNITED ARAB EMIRATES" && y =="AED")
					{
						if((p != null && p != "") || (q != null && q != "" && q !='--Select--') || (r != null && r != "") || (s != null && s != "") ||( t != null && t != "" && t !='--Select--') ||( u != null && u != ""))
						{
								if (window.confirm("Intermediary details will be deleted, press OK to delete or CANCEL") == true) {
								customform.document.getElementById("wdesk:interBankName").value ='';
								customform.document.getElementById("wdesk:interBankCntryCombo").value ='';
								customform.document.getElementById("wdesk:interBankCntry").value ='';
								customform.document.getElementById("wdesk:interBankBranch").value='';
								customform.document.getElementById("wdesk:interCityState").value='';
								customform.document.getElementById("dropDownInterBankCode").value='';
								customform.document.getElementById("wdesk:interBankCode").value='';
								customform.document.getElementById("wdesk:interActualCode").value='';
								
								} 
								else {
									return false;
							}
						//return true;
						}
					}

		}
		else {
			alert("Please Select Decision");
			setFocusOnField(customform,customform.document.getElementById("decisionRoute"));
			return false;
		}
		calculateMidRate(customform);
		return true;
	 }
	 
	 else if(workstepname=="Ops_Maker")
	 {
		//Check if send button is clicked
		if (customform.document.getElementById("sendBtnClicked").value == "Yes")
			return true;

		var decCompCheck = customform.document.getElementById('wdesk:decCompCheck').value;
		var decCallBack = customform.document.getElementById('wdesk:decCallBack').value;
		var flagForDecHisButton = customform.document.getElementById('flagForDecHisButton').value;
		
		if(flagForDecHisButton!='Yes' && (decCallBack=='Successful' || decCompCheck=='Approve')) {
			alert('Click the decision history table');
			setFocusOnField(customform,customform.document.getElementById("dec_history"));
			return false;
		}
		
		x = customform.document.getElementById('decisionRoute').value ;
		var h_checklist = customform.document.getElementById('wdesk:H_CHECKLIST').value;
		var responseAlreadyRaised = alreadyRaised(customform.document.getElementById('wdesk:wi_name').value,h_checklist);		
		var dec_maker = customform.document.getElementById("wdesk:dec_maker").value;
		var finacleStatusAtMaker = customform.document.getElementById("wdesk:payment_order_status").value;
		//var val = responseAlreadyRaised.substring(responseAlreadyRaised.indexOf("<Results>")+12,responseAlreadyRaised.indexOf("</Results>"));//Commented on 18-05-2017
		
		if(dec_maker=='Submit')	{
			//if(responseAlreadyRaised==null || responseAlreadyRaised=="" || responseAlreadyRaised.indexOf("~[Raised")==-1  || val != "~[Raised") //Removed val != "~[Raised" condition from if block on 18-05-2017
			
			//Added by amitbh on 6/6/2016 for write log
			var condition1=(responseAlreadyRaised==null);
			var condition2=(responseAlreadyRaised=="");
			var conditionIndexof=(responseAlreadyRaised.indexOf("~[Raised")==-1);
			var conditionStatus=condition1+" : "+condition2+" : "+conditionIndexof
			var indexofString=responseAlreadyRaised.indexOf("~[Raised");
			indexofString = indexofString + " : " + conditionStatus;
			debugForCheckExceptionIssue(indexofString,customform.document.getElementById('wdesk:wi_name').value);
			
			if(responseAlreadyRaised==null || responseAlreadyRaised=="" || responseAlreadyRaised.indexOf("~[Raised")==-1) 
			{
				if(finacleStatusAtMaker =='Deleted' || finacleStatusAtMaker =='Awaiting Authorization' || finacleStatusAtMaker =='Awaiting Deletion' || finacleStatusAtMaker =='Processed')
					customform.document.getElementById("wdesk:dec_maker").value = 'Forward';
				else if(finacleStatusAtMaker =='Not Ready' || finacleStatusAtMaker =='Ready' || finacleStatusAtMaker =='Error')
				{
					alert('Finacle Status is '+finacleStatusAtMaker+' .Work item cannot be routed to next work step.');
					return false;
				}
			}
			else		
				customform.document.getElementById("wdesk:dec_maker").value = 'Send to Remittance HD';
		}
		
		var h_checklist = customform.document.getElementById('wdesk:H_CHECKLIST').value;
		var responseAlreadyRaised = alreadyRaised(customform.document.getElementById('wdesk:wi_name').value,h_checklist);		
		if (responseAlreadyRaised.indexOf('003~[Raised') == -1)
			customform.document.getElementById('wdesk:isSignatureExcepRaised').value = 'No';								
		else
			customform.document.getElementById('wdesk:isSignatureExcepRaised').value = 'Yes';
		

		//Check first eventNotification needed
		var callBackSuccessFlag = customform.document.getElementById("wdesk:callbackFlgFinacle").value;
		var refCountrySuccessFlag = customform.document.getElementById("wdesk:referCtryFlgFinacle").value;

		if(!((refCountrySuccessFlag=="No" || refCountrySuccessFlag== "") && (callBackSuccessFlag=="No" || callBackSuccessFlag== ""))) {
		
			if (refCountrySuccessFlag=='Yes' && callBackSuccessFlag=='No')
			
				document.getElementById('customform').contentWindow.eventNotification();
			
			else {
		
				if (customform.document.getElementById('wdesk:isEventNotifySuccess').value != 'Y')
					document.getElementById('customform').contentWindow.eventNotification();
					
				//If failure then show the div
				if (customform.document.getElementById('wdesk:isEventNotifySuccess').value != 'Y')	{
					customform.document.getElementById("deletePaymentDiv").style.display = "block";
					return false;
				}
			}
		}
		return checkPostDatedRequest();
		//return true;
	 }
	 else if(workstepname=="Ops_Maker_DB")
	 {
		//Check if send button is clicked
		if (customform.document.getElementById("sendBtnClicked").value == "Yes")
			return true;

		var decCompCheck = customform.document.getElementById('wdesk:decCompCheck').value;
		var decCallBack = customform.document.getElementById('wdesk:decCallBack').value;
		var flagForDecHisButton = customform.document.getElementById('flagForDecHisButton').value;
		
		if(flagForDecHisButton!='Yes' && (decCallBack=='Successful' || decCompCheck=='Approve')) {
			alert('Click the decision history table');
			setFocusOnField(customform,customform.document.getElementById("dec_history"));
			return false;
		}
		
		x = customform.document.getElementById('decisionRoute').value ;
		var h_checklist = customform.document.getElementById('wdesk:H_CHECKLIST').value;
		var responseAlreadyRaised = alreadyRaised(customform.document.getElementById('wdesk:wi_name').value,h_checklist);		
		var dec_maker = customform.document.getElementById("wdesk:dec_maker_DB").value;
		var finacleStatusAtMaker = customform.document.getElementById("wdesk:payment_order_status").value;
		//var val = responseAlreadyRaised.substring(responseAlreadyRaised.indexOf("<Results>")+12,responseAlreadyRaised.indexOf("</Results>"));//Commented on 18-05-2017
		
		if(dec_maker=='Submit')	{
			//if(responseAlreadyRaised==null || responseAlreadyRaised=="" || responseAlreadyRaised.indexOf("~[Raised")==-1  || val != "~[Raised") //Removed val != "~[Raised" condition from if block on 18-05-2017
			
			//Added by amitbh on 6/6/2016 for write log
			var condition1=(responseAlreadyRaised==null);
			var condition2=(responseAlreadyRaised=="");
			var conditionIndexof=(responseAlreadyRaised.indexOf("~[Raised")==-1);
			var conditionStatus=condition1+" : "+condition2+" : "+conditionIndexof
			var indexofString=responseAlreadyRaised.indexOf("~[Raised");
			indexofString = indexofString + " : " + conditionStatus;
			debugForCheckExceptionIssue(indexofString,customform.document.getElementById('wdesk:wi_name').value);
			
			if(responseAlreadyRaised==null || responseAlreadyRaised=="" || responseAlreadyRaised.indexOf("~[Raised")==-1) 
			{
				if(finacleStatusAtMaker =='Deleted' || finacleStatusAtMaker =='Awaiting Authorization' || finacleStatusAtMaker =='Awaiting Deletion' || finacleStatusAtMaker =='Processed')
					customform.document.getElementById("wdesk:dec_maker_DB").value = 'Forward';
				else if(finacleStatusAtMaker =='Not Ready' || finacleStatusAtMaker =='Ready' || finacleStatusAtMaker =='Error')
				{
					alert('Finacle Status is '+finacleStatusAtMaker+' .Work item cannot be routed to next work step.');
					return false;
				}
			}
			else		
				customform.document.getElementById("wdesk:dec_maker_DB").value = 'Send to Remittance HD';
		}
		
		var h_checklist = customform.document.getElementById('wdesk:H_CHECKLIST').value;
		var responseAlreadyRaised = alreadyRaised(customform.document.getElementById('wdesk:wi_name').value,h_checklist);		
		if (responseAlreadyRaised.indexOf('003~[Raised') == -1)
			customform.document.getElementById('wdesk:isSignatureExcepRaised').value = 'No';								
		else
			customform.document.getElementById('wdesk:isSignatureExcepRaised').value = 'Yes';
		

		//Check first eventNotification needed
		var callBackSuccessFlag = customform.document.getElementById("wdesk:callbackFlgFinacle").value;
		var refCountrySuccessFlag = customform.document.getElementById("wdesk:referCtryFlgFinacle").value;

		if(!((refCountrySuccessFlag=="No" || refCountrySuccessFlag== "") && (callBackSuccessFlag=="No" || callBackSuccessFlag== ""))) {
		
			if (refCountrySuccessFlag=='Yes' && callBackSuccessFlag=='No')
			
				document.getElementById('customform').contentWindow.eventNotification();
			
			else {
		
				if (customform.document.getElementById('wdesk:isEventNotifySuccess').value != 'Y')
					document.getElementById('customform').contentWindow.eventNotification();
					
				//If failure then show the div
				if (customform.document.getElementById('wdesk:isEventNotifySuccess').value != 'Y')	{
					customform.document.getElementById("deletePaymentDiv").style.display = "block";
					return false;
				}
			}
		}
		return checkPostDatedRequest();
		//return true;
	 }
	 else if(workstepname=="Ops_Checker")
	 {
		//set the user name
		customform.document.getElementById('wdesk:opsCheckerUser').value = customform.document.getElementById('login_user').value;
		
		//Check if send button is clicked
		if (customform.document.getElementById("sendBtnClicked").value == "Yes")
			return true;
		var winame = customform.document.getElementById("wdesk:wi_name").value;
		
		x = customform.document.getElementById('decisionRoute').value;				
		var issignatureNeeded = customform.document.getElementById('signMatchNeededAtChecker').value;
		var h_checklist = customform.document.getElementById('wdesk:H_CHECKLIST').value;
		var responseAlreadyRaised = alreadyRaised(customform.document.getElementById('wdesk:wi_name').value,h_checklist);		
		var dec_checker = customform.document.getElementById("wdesk:dec_checker").value;
		
		//payment status to be called.
		if (document.getElementById('customform').contentWindow.getTTStatus() == false) {
			alert("Error in obtaining Finacle Status");
			return false;
		}		
		
		var finacleStatusAtChecker = customform.document.getElementById("wdesk:payment_order_status").value;
	
		if(dec_checker=='Submit')
		{
			if(responseAlreadyRaised==null || responseAlreadyRaised=="" || responseAlreadyRaised.indexOf("~[Raised")==-1)
			{
				if(finacleStatusAtChecker =='Deleted' || finacleStatusAtChecker =='Processed' || finacleStatusAtChecker =='Error' || finacleStatusAtChecker =='Awaiting Deletion')
					customform.document.getElementById("wdesk:dec_checker").value = 'Forward';
				
				else if(finacleStatusAtChecker =='Not Ready' || finacleStatusAtChecker =='Ready' || finacleStatusAtChecker =='Authorization Awaited')
				{
					alert('Finacle Status is '+finacleStatusAtChecker+' .Work item cannot be routed to next work step.');
					return false;
				}
			}
			else
				customform.document.getElementById("wdesk:dec_checker").value = 'Send to Remittance HD';			
		}
		if (issignatureNeeded == 'Y')
		{
			var issignaturematched = customform.document.getElementById('wdesk:sign_matchedAtChecker').value;
			if (issignaturematched==null  || issignaturematched=="")
			{
				alert("Please match the signatures from Signature window");
				setFocusOnField(customform,customform.document.getElementById("view_sign"));
				return false;
			}
			if (issignaturematched=="No") {
				if(responseAlreadyRaised.indexOf('003~[Raised') == -1) {
					alert('Sign not matched, Sign mismatch exception not raised');
					ExcepAutoraise(workstepname,winame,"SignAutoRaise");
				}
			}
		}
		
		if (responseAlreadyRaised.indexOf('003~[Raised') == -1)
			customform.document.getElementById('wdesk:isSignatureExcepRaised').value = 'No';					
		else
			customform.document.getElementById('wdesk:isSignatureExcepRaised').value = 'Yes';
			
		return checkPostDatedRequest();
		//return true;
	 }
	 else if(workstepname=="Ops_Checker_DB")
	 {
		//set the user name
		customform.document.getElementById('wdesk:opsCheckerUser').value = customform.document.getElementById('login_user').value;
		
		//Check if send button is clicked
		if (customform.document.getElementById("sendBtnClicked").value == "Yes")
			return true;
		var winame = customform.document.getElementById("wdesk:wi_name").value;
		
		x = customform.document.getElementById('decisionRoute').value;				
		var issignatureNeeded = customform.document.getElementById('signMatchNeededAtChecker').value;
		var h_checklist = customform.document.getElementById('wdesk:H_CHECKLIST').value;
		var responseAlreadyRaised = alreadyRaised(customform.document.getElementById('wdesk:wi_name').value,h_checklist);		
		var dec_checker = customform.document.getElementById("wdesk:dec_checker_DB").value;
		
		//payment status to be called.
		if (document.getElementById('customform').contentWindow.getTTStatus() == false) {
			alert("Error in obtaining Finacle Status");
			return false;
		}		
		
		var finacleStatusAtChecker = customform.document.getElementById("wdesk:payment_order_status").value;
	
		if(dec_checker=='Submit')
		{
			if(responseAlreadyRaised==null || responseAlreadyRaised=="" || responseAlreadyRaised.indexOf("~[Raised")==-1)
			{
				if(finacleStatusAtChecker =='Deleted' || finacleStatusAtChecker =='Processed' || finacleStatusAtChecker =='Error' || finacleStatusAtChecker =='Awaiting Deletion')
					customform.document.getElementById("wdesk:dec_checker_DB").value = 'Forward';
				
				else if(finacleStatusAtChecker =='Not Ready' || finacleStatusAtChecker =='Ready' || finacleStatusAtChecker =='Authorization Awaited')
				{
					alert('Finacle Status is '+finacleStatusAtChecker+' .Work item cannot be routed to next work step.');
					return false;
				}
			}
			else
				customform.document.getElementById("wdesk:dec_checker_DB").value = 'Send to Remittance HD';			
		}
		/*if (issignatureNeeded == 'Y')
		{
			var issignaturematched = customform.document.getElementById('wdesk:sign_matchedAtChecker').value;
			if (issignaturematched==null  || issignaturematched=="")
			{
				alert("Please match the signatures from Signature window");
				setFocusOnField(customform,customform.document.getElementById("view_sign"));
				return false;
			}
			if (issignaturematched=="No") {
				if(responseAlreadyRaised.indexOf('003~[Raised') == -1) {
					alert('Sign not matched, Sign mismatch exception not raised');
					ExcepAutoraise(workstepname,winame,"SignAutoRaise");
				}
			}
		}*/
		
		if (responseAlreadyRaised.indexOf('003~[Raised') == -1)
			customform.document.getElementById('wdesk:isSignatureExcepRaised').value = 'No';					
		else
			customform.document.getElementById('wdesk:isSignatureExcepRaised').value = 'Yes';
			
		return checkPostDatedRequest();
		//return true;
	 }
	 else if(workstepname=="Error")
	 {
		 var decision_tt = customform.document.getElementById('decisionRoute').value;
		 
		if (decision_tt=='--Select--') {
			alert("Please set the decision");
			setFocusOnField(customform,customform.document.getElementById("decisionRoute"));
			return false;
		}
		 var failedIntegrationCall=customform.document.getElementById('wdesk:failedIntegrationCall').value;
		 var finacleStatus = customform.document.getElementById("wdesk:payment_order_status").value;
		 var ttRefNum = customform.document.getElementById("wdesk:payment_order_id").value;
		 var prevWs = customform.document.getElementById("wdesk:prev_WS").value;
		 if(failedIntegrationCall =='PAYMENT_REQ') {
			if (ttRefNum==null || ttRefNum=="")	{
				if (decision_tt!= 'Send to Discard') {
					alert("Please take decision as Send to Discard");
					return false;
				}
			}
			else {
				if (decision_tt!= 'Retry successful') {
					alert("Please take decision as Retry successful");
					return false;
				}
			}
		 }
		 else if (failedIntegrationCall=='PAYMENT_DELETION') {
			if (customform.document.getElementById('wdesk:isPayDelFromFinacle').value == 'Y')
			{
				if (decision_tt!= 'Send to Discard') {
					alert("Please take decision as Send to Discard");
					return false;
				}
			}
		 }
		 else if (failedIntegrationCall=='PAYMENT_DETAILS') {
			if (customform.document.getElementById('wdesk:isStatusSyncUp').value == 'Y')
			{
				if (prevWs == 'Ops_Maker') {
					if (decision_tt!="Send to Ops Checker"  && decision_tt!="Send to Discard") {
						alert("Decision can only be Send to Ops Checker or Send to Discard");
						return false;
					}
				}
				else if (prevWs == 'Ops_Maker_DB') {
					if (decision_tt!="Send to Ops Checker DB"  && decision_tt!="Send to Discard") {
						alert("Decision can only be Send to Ops Checker DB or Send to Discard");
						return false;
					}
				}
				else if (prevWs == 'Ops_Checker') {
					
					if (decision_tt!="Send to Ops Maker"  && decision_tt!="Send to Discard" && decision_tt!="Retry successful") {
						alert("Decision can only be Send to Ops Maker/Send to Discard/Retry successful");
						return false;
					}
				}
				else if (prevWs == 'Ops_Checker_DB') {
					
					if (decision_tt!="Send to Ops Maker DB"  && decision_tt!="Send to Discard" && decision_tt!="Retry successful") {
						alert("Decision can only be Send to Ops Maker DB/Send to Discard/Retry successful");
						return false;
					}
				}
			}
			else {
				alert("Failed to update the payment order status")
			}			
		 }
		 else if (failedIntegrationCall=='EVENT_NOTIFICATION') {
			
			if (prevWs == 'Ops_Maker') {
				if (decision_tt!="Send to Ops Maker") {
					alert("Decision can only be Send to Ops Maker");
					customform.document.getElementById('wdesk:isEventNotifySuccess').value = 'Y';
					return false;
				}
			}
			else if (prevWs == 'Ops_Maker_DB') {
				if (decision_tt!="Send to Ops Maker DB") {
					alert("Decision can only be Send to Ops Maker DB");
					customform.document.getElementById('wdesk:isEventNotifySuccess').value = 'Y';
					return false;
				}
			}
			else {
				
				if (decision_tt!= 'Send to Discard') {
					alert("Please take decision as Send to Discard");
					return false;
				}
			}
		 }
	 }
	 return true;
}
function setFocusOnField(customform,field)
{
	field.focus();
}

function checkCallBackRaised()
{

	//Exception code for Call back Required
	//var excpCode = '005';
	var h_checklist = customform.document.getElementById('wdesk:H_CHECKLIST').value;
	var responseAlreadyRaised = alreadyRaised(customform.document.getElementById('wdesk:wi_name').value,h_checklist);
	
	if (responseAlreadyRaised.indexOf('005~[Raised') != -1)
	{
		return true;
	}
	
	return false;
}

/* Added by Anurag Anand 12-Feb-2016 and Aishwarya, to decide the next workstep for SaveHistory.jsp
Next WorkStep is decided from the criterias, those are picked up from process Modeler route */
function getNextWorkStep() {
	var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
	var WINAME=customform.document.getElementById("wdesk:wi_name").value;
	var decision = customform.document.getElementById("decisionRoute").value;
	var fcyRate = customform.document.getElementById("wdesk:fcy_rate").value;
	var prefRate = customform.document.getElementById("wdesk:pref_rate").value;
	var isHandWritten = customform.document.getElementById("wdesk:isHandWritten").value;
	var is_po_created = customform.document.getElementById("wdesk:is_po_created").value;
	var decision_CheckerDB="";
	decision = decision.trim();

	if(WSNAME=="CSO_Initiate"){
			//decision=customform.document.getElementById("dec_CSO").value;
			if(decision=="Cancel"){
				return "Archive_Discard";
			}
			if(prefRate!=null && prefRate!="" && fcyRate != prefRate)
			{
				return "Treasury";
			}
				
			if( is_po_created == 'Y')
			{
				return "PostCutOff_Init";
			}
					
				
			if(	isHandWritten == 'Y' )
			{
				return "Ops_DataEntry";
			}

			return "CreatePO";
			
			//return "RemittanceHelpDesk_Checker";				
				
		}
		
		if(WSNAME=="PostCutOff_Init"){
			
			if( isHandWritten == 'Y' )
			{
				return "Ops_DataEntry";
			}
			
				else
				{
				return "RemittanceHelpDesk_Checker";
			}
				
		}
		
		if(WSNAME=="Ops_DataEntry"){
			if( decision == "Submit" )
				{
					
				return "RemittanceHelpDesk_Checker";
			    }								
		}
		// (CLOB) Rate Modification Required,Approve,Hold,Data Entry Required
		if(WSNAME=="Treasury"){			
			
			if( decision == "Approve" && isHandWritten=='Y')
			{
				return "Ops_DataEntry";
			}
			if( decision == "Approve")
			{
				
				return "RemittanceHelpDesk_Checker";
			}				

			if( decision == "Rate Modification Required" )
			{
				return "CSO_Exceptions";
			}				
			
			if( decision == "Hold" )
			{
				return "Treasury";
			}				
		}
		
		if(WSNAME=="RemittanceHelpDesk_Checker"){
			decision=customform.document.getElementById("wdesk:dec_rem_helpdesk").value;
			var call_back_req = customform.document.getElementById("wdesk:call_back_req").value;
			var comp_req = customform.document.getElementById("wdesk:comp_req").value;
			var dec_maker = customform.document.getElementById("wdesk:dec_maker").value;
			var dec_checker = customform.document.getElementById("wdesk:dec_checker").value;
			var decCompCheck = customform.document.getElementById("wdesk:decCompCheck").value;
			var decCallBack = customform.document.getElementById("wdesk:decCallBack").value;
			var isRulingFamily = customform.document.getElementById("wdesk:isRulingFamily").value;
			var isCallBackWaivedOff = customform.document.getElementById("wdesk:isCallBackWaivedOff").value;
			var h_checklist = customform.document.getElementById('wdesk:H_CHECKLIST').value;
			var CREATE_WI_STATUS = customform.document.getElementById('wdesk:CREATE_WI_STATUS').value;
			var responseAlreadyRaised = alreadyRaised(customform.document.getElementById('wdesk:wi_name').value,h_checklist);
		//(CLOB) Submit,Signature Mismatch,Send to Business
			if(decision=='Restricted Nationality')
			{
				return "Archive_Discard";
			}	
			if(decision=='Send to Business')
			{
				return "CSO_Exceptions";
			}	
			if(decision=='Submit' && comp_req=='Yes')
			{
				if(responseAlreadyRaised.indexOf('006~[Raised') != -1 || responseAlreadyRaised.indexOf('004~[Raised') != -1 || responseAlreadyRaised.indexOf('008~[Raised') != -1)
					return "Distribute1";
			}
			if(decision=='Submit' && isRulingFamily=='No' && isCallBackWaivedOff=='No' && call_back_req=='Yes')
			{
				if(responseAlreadyRaised.indexOf('005~[Raised') != -1)
					return "Distribute1";
			}
			if(decision=='Submit' && dec_maker=='Send to Remittance HD')
			{
				return "Ops_Maker";
			}
			if(decision=='Submit' && dec_maker_DB=='Send to Remittance HD' && CREATE_WI_STATUS=='Y')
			{
				return "Ops_Maker_DB";
			}
			if(decision=='Submit' && dec_checker=='Send to Remittance HD')
			{
				return "Ops_Checker";
			}
			if(decision=='Submit' && dec_checker_DB=='Send to Remittance HD' && CREATE_WI_STATUS=='Y')
			{
				return "Ops_Checker_DB";
			}
			if(decision=='Submit' && call_back_req=='No' && comp_req=='No' && CREATE_WI_STATUS=='Y')
			{
				return "Ops_Maker_DB";
			}
			if(decision=='Submit' && call_back_req=='No' && comp_req=='No')
			{
				return "Ops_Maker";
			}
			
			if(decision=='Submit' && call_back_req=='Yes' && isRulingFamily=='Yes' && CREATE_WI_STATUS=='Y')
			{
				return "Ops_Maker_DB";
			}
			if(decision=='Submit' && call_back_req=='Yes' && isCallBackWaivedOff=='Yes' && CREATE_WI_STATUS=='Y')
			{
				return "Ops_Maker_DB";
			}
			if(decision=='Submit' && call_back_req=='Yes' && isCallBackWaivedOff=='No' && decCallBack=='Successful' && CREATE_WI_STATUS=='Y')
			{
				return "Ops_Maker_DB";
			}
			
			if(decision=='Submit' && call_back_req=='Yes' && isRulingFamily=='Yes')
			{
				return "Ops_Maker";
			}
			if(decision=='Submit' && call_back_req=='Yes' && isCallBackWaivedOff=='Yes')
			{
				return "Ops_Maker";
			}
			if(decision=='Submit' && call_back_req=='Yes' && isCallBackWaivedOff=='No' && decCallBack=='Successful')
			{
				return "Ops_Maker";
			}
			
			
			
		}
		if(WSNAME=="RemittanceHelpDesk_Maker"){
			decision=customform.document.getElementById("wdesk:dec_rem_helpdeskMaker").value;
			var call_back_req = customform.document.getElementById("wdesk:call_back_req").value;
			var comp_req = customform.document.getElementById("wdesk:comp_req").value;
			var dec_maker = customform.document.getElementById("wdesk:dec_maker").value;
			var dec_maker_DB = customform.document.getElementById("wdesk:dec_maker_DB").value;
			var dec_checker = customform.document.getElementById("wdesk:dec_checker").value;
			var dec_checker_DB = customform.document.getElementById("wdesk:dec_checker_DB").value;
			var decCompCheck = customform.document.getElementById("wdesk:decCompCheck").value;
			var decCallBack = customform.document.getElementById("wdesk:decCallBack").value;
			var isRulingFamily = customform.document.getElementById("wdesk:isRulingFamily").value;
			var isCallBackWaivedOff = customform.document.getElementById("wdesk:isCallBackWaivedOff").value;
			var h_checklist = customform.document.getElementById('wdesk:H_CHECKLIST').value;
			var responseAlreadyRaised = alreadyRaised(customform.document.getElementById('wdesk:wi_name').value,h_checklist);
			//(CLOB) Submit,Signature Mismatch,Send to Business
			if(decision=='Restricted Nationality')
			{
				return "Archive_Discard";
			}	
			if(decision=='Send to Business')
			{
				return "CSO_Exceptions";
			}
			if(decision=='Submit' && comp_req=='Yes')
			{
				if(responseAlreadyRaised.indexOf('006~[Raised') != -1 || responseAlreadyRaised.indexOf('004~[Raised') != -1 || responseAlreadyRaised.indexOf('008~[Raised') != -1)
					return "Distribute1";
			}
			if(decision=='Submit' && isRulingFamily=='No' && isCallBackWaivedOff=='No' && call_back_req=='Yes')
			{
				if(responseAlreadyRaised.indexOf('005~[Raised') != -1)
					return "Distribute1";
			}
			if(decision=='Submit' && dec_maker=='Send to Remittance HD')
			{
				return "Ops_Maker";
			}
			if(decision=='Submit' && dec_maker_DB=='Send to Remittance HD' && CREATE_WI_STATUS=='Y')
			{
				return "Ops_Maker_DB";
			}
			if(decision=='Submit' && dec_checker=='Send to Remittance HD')
			{
				return "Ops_Checker";
			}
			if(decision=='Submit' && dec_checker_DB=='Send to Remittance HD' && CREATE_WI_STATUS=='Y')
			{
				return "Ops_Checker_DB";
			}
			
			if(decision=='Submit' && call_back_req=='No' && comp_req=='No' && CREATE_WI_STATUS=='Y')
			{
				return "Ops_Maker_DB";
			}
			if(decision=='Submit' && call_back_req=='Yes' && isRulingFamily=='Yes' && CREATE_WI_STATUS=='Y')
			{
				return "Ops_Maker_DB";
			}
			if(decision=='Submit' && call_back_req=='Yes' && isCallBackWaivedOff=='Yes' && CREATE_WI_STATUS=='Y')
			{
				return "Ops_Maker_DB";
			}
			if(decision=='Submit' && call_back_req=='Yes' && isCallBackWaivedOff=='No' && decCallBack=='Successful' && CREATE_WI_STATUS=='Y')
			{
				return "Ops_Maker_DB";
			}
			
			if(decision=='Submit' && call_back_req=='No' && comp_req=='No')
			{
				return "Ops_Maker";
			}
			if(decision=='Submit' && call_back_req=='Yes' && isRulingFamily=='Yes')
			{
				return "Ops_Maker";
			}
			if(decision=='Submit' && call_back_req=='Yes' && isCallBackWaivedOff=='Yes')
			{
				return "Ops_Maker";
			}
			if(decision=='Submit' && call_back_req=='Yes' && isCallBackWaivedOff=='No' && decCallBack=='Successful')
			{
				return "Ops_Maker";
			}
			
			
		}
		
		//(CLOB) Re-Submit,Reject,Call Back Waiver Request
		if(WSNAME=="CSO_Exceptions"){
			decision=customform.document.getElementById("wdesk:dec_CSO_Exceptions").value;
			var dec_treasury = customform.document.getElementById("wdesk:dec_treasury").value;
			var dec_rem_helpdesk = customform.document.getElementById("wdesk:dec_rem_helpdesk").value;
			var dec_rem_helpdeskMaker = customform.document.getElementById("wdesk:dec_rem_helpdeskMaker").value;
					
			if( decision    == 'Reject' ){
					return "Archive_Discard";
			}
			var isSignExcepRaised=customform.document.getElementById('wdesk:isSignatureExcepRaised').value;
			if( decision    == 'Call Back Waiver Request' && isSignExcepRaised=='Yes' ){
					
				return "RemittanceHelpDesk_Checker";
			}
			else if( decision    == 'Call Back Waiver Request'  ){
					
				return "RemittanceHelpDesk_Maker";
			}
			
			if( dec_treasury    == 'Rate Modification Required' && decision=='Re-Submit'){
					return "Treasury";
			}
			
			if( dec_rem_helpdesk == 'Send to Business' && decision=='Re-Submit'  && isSignExcepRaised=='Yes'){
					
				return "RemittanceHelpDesk_Checker";
			}
			else if( dec_rem_helpdesk    == 'Send to Business' && decision=='Re-Submit'  ){
					
				return "RemittanceHelpDesk_Maker";
			}else if( dec_rem_helpdeskMaker    == 'Send to Business' && decision=='Re-Submit'  && isSignExcepRaised=='Yes'){
					
				return "RemittanceHelpDesk_Checker";
			}
			else if( dec_rem_helpdeskMaker    == 'Send to Business' && decision=='Re-Submit'  ){
					
				return "RemittanceHelpDesk_Maker";
			}
			if(decision=='Re-Submit'){
					return "Distribute1";
			}
			
		}
		
		//(CLOB) Submit,Call Back Unsuccessful
		if(WSNAME=="Collect1"){	
					
		//code to be written
		}
		
		//(CLOB) Approve,Additional Documents required,Hold,Reject
		if(WSNAME=="Comp_Check"){
					
			if(    decision    == 'Hold' ){
					return "Compliance Check";
			}
			if(decision== 'Additional Documents required'){
			return "CSO_Exceptions";
			}
			if(decision== 'Send to Remittance HD'){
			return "RemittanceHelpDesk_Maker";
			}
			var channel_id = customform.document.getElementById('wdesk:channel_id').value;
			if(    decision    == 'Approve'){
			if(channel_id =='IB' || channel_id == 'MB' || channel_id == 'YAP' || channel_id == 'DIP')
					return "RemittanceHelpDesk_Maker";
					else 
					return "Collect1";

			}
			
		}
		
		if(WSNAME=="CallBack"){
					
			if(    decision    == 'Call Back Unsuccessful' ){
					return "CSO_Exceptions";
			}
		}
		//(CLOB) Forward,Send to Remittance HD
		if(WSNAME=="Ops_Maker"){	
			decision=customform.document.getElementById("wdesk:dec_maker").value;		
			if( decision == 'Forward' ){
					return "Ops_Checker";
			}
			var isSignExcepRaised=customform.document.getElementById('wdesk:isSignatureExcepRaised').value;
			if( decision == 'Send to Remittance HD' && isSignExcepRaised=='Yes'){
					
				return "RemittanceHelpDesk_Checker";
			}
			else if( decision == 'Send to Remittance HD'){
					
				return "RemittanceHelpDesk_Maker";
			}
			
		}
		else if(WSNAME=="Ops_Maker_DB"){	
			decision=customform.document.getElementById("wdesk:dec_maker_DB").value;		
			if( decision == 'Forward' ){
					return "Ops_Checker_DB";
			}
			var isSignExcepRaised=customform.document.getElementById('wdesk:isSignatureExcepRaised').value;
			if( decision == 'Send to Remittance HD' && isSignExcepRaised=='Yes'){
					
				return "RemittanceHelpDesk_Checker";
			}
			else if( decision == 'Send to Remittance HD'){
					
				return "RemittanceHelpDesk_Maker";
			}
			
		}
		
		//(CLOB) Forward,Send to Remittance HD
		if(WSNAME=="Ops_Checker"){
			decision=customform.document.getElementById("wdesk:dec_checker").value;
			var finacleStatusAtChecker = customform.document.getElementById("wdesk:payment_order_status").value;		
			var isSignExcepRaised=customform.document.getElementById('wdesk:isSignatureExcepRaised').value;
			if( decision == 'Send to Remittance HD' && isSignExcepRaised=='Yes'){
					
				return "RemittanceHelpDesk_Checker";
			}
			else if( decision == 'Send to Remittance HD'){
					
				return "RemittanceHelpDesk_Maker";
			}			
			if( decision == 'Forward' &&  finacleStatusAtChecker=='Referred'){
					return "Ops_Maker";
			}
			if( decision == 'Forward' &&  finacleStatusAtChecker=='Processed'){
					return "Archive_Exit";
			}
			if(decision == 'Forward' &&  finacleStatusAtChecker=='Error'){
				return "Ops_Maker";
			}
			if( decision == 'Forward' &&  finacleStatusAtChecker=='Deleted'){
					return "Archive_Discard";
			}
			if(decision == 'Send To Maker'){
				return "Ops_Maker";
			}
			if(decision=='Assign to Me')
			{
				return "Ops_Checker";
			}
			
		}
		else if(WSNAME=="Ops_Checker_DB"){
			decision=customform.document.getElementById("wdesk:dec_checker_DB").value;
			var finacleStatusAtChecker = customform.document.getElementById("wdesk:payment_order_status").value;		
			var isSignExcepRaised=customform.document.getElementById('wdesk:isSignatureExcepRaised').value;
			if( decision == 'Send to Remittance HD' && isSignExcepRaised=='Yes'){
					
				return "RemittanceHelpDesk_Checker";
			}
			else if( decision == 'Send to Remittance HD'){
					
				return "RemittanceHelpDesk_Maker";
			}			
			if( decision == 'Forward' &&  finacleStatusAtChecker=='Referred'){
					return "Ops_Maker_DB";
			}
			if( decision == 'Forward' &&  finacleStatusAtChecker=='Processed'){
					return "Archive_Exit";
			}
			if(decision == 'Forward' &&  finacleStatusAtChecker=='Error'){
				return "Ops_Maker_DB";
			}
			if( decision == 'Forward' &&  finacleStatusAtChecker=='Deleted'){
					return "Archive_Discard";
			}
			if(decision == 'Send To Maker'){
				return "Ops_Maker_DB";
			}
			if(decision=='Assign to Me')
			{
				return "Ops_Checker_DB";
			}
			
		}
		return "No Next Queue Found in client.js";
}

function iBanValidation (workstepname,countryOfInc)
{
	var currCode = customform.document.getElementById('wdesk:remit_amt_curr').value;
	var url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?workstepname='+workstepname+"&reqType=ibanValidation&countryOfInc="+countryOfInc+"&currCode="+currCode;
	var xhr;
	var ajaxResult;
	var response;

	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	 xhr.open("GET",url,false);
	 xhr.send(null);	 

	if (xhr.status == 200)
	{
		response = xhr.responseText;
		response=response.replace(/^\s+|\s+$/gm,'');
		var tempResponse = response.split(",");
		var ibanLength = tempResponse[0];
		var country = tempResponse[1];
		
		if (response!= 'NOT_REQUIRED' && response != "")
		{
			var iban = customform.document.getElementById('wdesk:iban').value;

			if (iban == null || iban == "" ) 
			{
				alert("Enter Beneficiary IBAN to proceed");
				setFocusOnField(customform,customform.document.getElementById('wdesk:iban'));
				
				return false;
			}
			else
			{				
				if (iban.length != ibanLength)
				{
					alert ("Length of IBAN entered is "+iban.length+" .Length of the iban should be equal to "+ibanLength);
					setFocusOnField(customform,customform.document.getElementById('wdesk:iban'));
					return false;
				}
				if  (iban.length == ibanLength)
				{
					//In future to write code converting the char to decimal instead of below code
					var leftChar = country.charCodeAt(0);
					var rightChar = country.charCodeAt(1);
					leftChar = leftChar - 55;
					rightChar = rightChar - 55;
						
					var x = iban.substring(4);
					var y = iban.substring(2,4);
					
					var ibanTemp=x;
					x="";
					
					while(ibanTemp.length>0)
					{
						var chTemp=ibanTemp.substring(0,1);
						
						if(chTemp.charCodeAt(0)>57)
							x+=chTemp.charCodeAt(0)-55;
						else
							x+=chTemp;
							
						ibanTemp=ibanTemp.substring(1);
					}	
					
					var largeNumber = x + leftChar + rightChar + y;
					
					var remainder = document.getElementById('customform').contentWindow.bigInt(largeNumber).mod(97);

					if (remainder.value != 1)
					{			
						alert("This is not a valid IBAN.");						
						return false;
					}
				}
			}			
		}
	}
	else
	{
		alert("Problem while checking the IBAN Details from the Master");
		return false;
	}
	
	return true;
}



function validateHandWrittenCases(isHandWritten)
{
	var reqType = 'handwrittenCases';
	var workstepname = "";
	var url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?reqType='+reqType;
	var xhr;
	var ajaxResult;
	var response;
	var x ="";

	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	 xhr.open("GET",url,false);
	 xhr.send(null);	 

	if (xhr.status == 200)
	{
		response = xhr.responseText;
		response=response.replace(/^\s+|\s+$/gm,'');
		
		var splitByHash = response.split('#');
		
		for (var i = 0; i< splitByHash.length;i++)
		{
			var tempArr = splitByHash [i].split(",");
			//tempArr[0] - id, tempArr[1] - Message label, tempArr[2] - type(input,select)
		
			x = customform.document.getElementById(tempArr[0]).value;
			
			//Check type of id either select or input			
			if (x == null || x == "" || x == "--Select--") {

				if (isHandWritten != 'Y')
				{
					var result = confirm(tempArr[1]);
					if (result==true)
					{
						customform.document.getElementById('wdesk:isHandWritten').value = 'Y';
						customform.document.getElementById('decisionRoute').value = 'Submit';
						calculateMidRate(customform);
						var dateTime = getServerDateTime ();
						customform.document.getElementById("wdesk:scanDate").value = dateTime;
						calculateCutOfftime();
						return true;
					}
					else
						customform.document.getElementById('wdesk:isHandWritten').value = 'N';

					setFocusOnField(customform,customform.document.getElementById(tempArr[0]));
					return false;
				}
			}
		}		
	}
	else
	{
		alert("Unable to fetch the handwritten fields from the Master");
		return false;
	}
}

function checkPostDatedRequest()
{
	var date1 = customform.document.getElementById('wdesk:requestDate').value;
	var isOKClicked="true";
	
	if (date1!=null && date1!="")
	{
		var date2 = getServerDateTime ();
		var d = new Date();
		var n = d.getDate();
		var m = d.getMonth();

		var yr1 = date1.substring(date1.lastIndexOf("/") + 1);
		var dt1 =  date1.substring(0,date1.indexOf("/"));
		if (dt1.length == 1)
			dt1 = "0"+dt1;
		var temp = date1.substring(date1.indexOf("/") + 1);
		var mon1 =  temp.substring(0,temp.indexOf("/"));

		if (mon1.length == 1)
			mon1 = "0"+mon1;
		
		var dt2  = date2.substring(8,10);
		var mon2 = date2.substring(5,7);
		var yr2  = date2.substring(0,4);
		
		if(yr1.length==2)
			yr1 = yr2.substring(0,2)+yr1;
		date1 = mon1 + "/" + dt1 + "/" + yr1;
		date2 = mon2 + "/" + dt2 + "/" + yr2;
		date1  = new Date(date1);
		date2  = new Date(date2);

		var timeDiff = Math.abs(date2.getTime() - date1.getTime());
		var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24)); 
	
		if(diffDays > '10') 
		{	
		//alert(customform.document.getElementById('FlagToCheckReqDate').value);
			if(customform.document.getElementById('FlagToCheckReqDate').value!="Y")
			{
				//alert('Difference of Requested Date and Scan cannot be more than 10 days, please select cancel as decision');
				if(confirm("Difference of requested date and scan date is more than 10 days, please verify before submitting"))
				{
					customform.document.getElementById('FlagToCheckReqDate').value="Y";
					//return true;
				}
				else {
						isOKClicked=false;;
				}
			}
			//setFocusOnField(customform,customform.document.getElementById("decisionRoute"));
			//return false;
		}
	}
	return isOKClicked;
}
function calculateCutOfftime ()
{
	var xhr;
	var ajaxResult = "";
	
	var reqType = "GetCutOfftime";
	var remit_amt_curr = customform.document.getElementById('wdesk:remit_amt_curr').value;
	var seg = customform.document.getElementById('wdesk:sub_segment').value;
	var WorkitemName = customform.document.getElementById('wdesk:wi_name').value;
	var scanDateTime = customform.document.getElementById('wdesk:scanDate').value;
	var isElite = customform.document.getElementById('wdesk:isEliteCust').value;

	//For handling the elite customer
	if (isElite == 'Y')
		seg = 'Elite';

	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");
		 
	var url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxProcedures.jsp?&reqType='+reqType+"&remit_amt_curr="+remit_amt_curr+"&scanDateTime="+scanDateTime+"&seg="+seg+"&WorkitemName="+encodeURIComponent(WorkitemName);

	 xhr.open("GET",url,false);
	 xhr.send(null);

	if (xhr.status == 200)
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if (ajaxResult == 'Error')
			alert('No value for currency '+remit_amt_curr+' and segment '+seg+' in the master');
		else
		{
			var arrPostCut = ajaxResult.split("!");
			customform.document.getElementById('wdesk:cut_off_time').value = arrPostCut[0].substring(0,19);
			customform.document.getElementById('wdesk:is_po_created').value = arrPostCut[1];
			customform.document.getElementById('postCutOffTimetoDB').value = arrPostCut[2];
		}
	}
	else
	{
		alert("Error while getting the cutofftime");
		return "";
	}
	return ajaxResult;
}

function getServerDateTime ()
{
	var reqType = 'getServerDateTime';
	var workstepname = "";
	var url = '/webdesktop/CustomForms/TT_Specific/TTUtil.jsp?reqType='+reqType;
	var xhr;
	var ajaxResult;
	var response;
	var x ="";

	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	 xhr.open("GET",url,false);
	 xhr.send(null);	 

	if (xhr.status == 200)
	{
		response = xhr.responseText;
		response=response.replace(/^\s+|\s+$/gm,'');
		return response;
	}
	else
	{
		alert("Unable to fetch the Server Date and Time");
		return "";
	}
}
function ExcepAutoraise(workstepname,winame,reqType)
{
	//alert('SignAutoRaise');
	var url = '/webdesktop/CustomForms/TT_Specific/AjaxRequestInsert.jsp?workstepname='+workstepname+"&winame="+encodeURIComponent(winame)+"&reqType="+reqType;
	var xhr;
	var ajaxResult;			
	var values = "";
	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");
		
	 xhr.open("GET",url,false);
	 xhr.send(null);

	if (xhr.status == 200)
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
	}			
	else
	{
		alert("Error while handling "+reqType+" for the current workstep");
		return false;
	}
}
//Added by amitabh on 6/6/2017 for write log
function debugForCheckExceptionIssue(indexofString,winame) 
{
    try 
	{
        var url = '/webdesktop/CustomForms/TT_Specific/LogForCheckExceptionIssue.jsp?indexofString='+indexofString+"&winame="+winame;
        var req;
        if (window.XMLHttpRequest) {
            req = new XMLHttpRequest();
        } else if (window.ActiveXObject) {
            isIE = true;
            req = new ActiveXObject("Microsoft.XMLHTTP");
        }

        req.open("POST", url, false);
        req.send();
		
		if (req.status == 200)
		{
		} else {
			alert("error in calling LogForCheckExceptionIssue.jsp req.status "+req.status);
		}
    } 
	catch (e) 
	{
        alert("Exception in debugForCheckExceptionIssue: " + e);
    }   
}

// added to validate benef details based on IBAN added on 06122020 by Angad
function BenefValidationBasedOnIBAN(IBAN567Char)
{
	var url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxRequest.jsp?reqType=BenefValidationBasedOnIBAN&IBAN567Char='+IBAN567Char;
	var xhr;
	var ajaxResult;
	var response;

	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	 xhr.open("GET",url,false);
	 xhr.send(null);	 

	if (xhr.status == 200)
	{
		response = xhr.responseText;
		response=response.replace(/^\s+|\s+$/gm,'');
		return response;
	}
	else
	{
		alert("Problem while checking the Benef Details for IBAN from the Master");
		return false;
	}
	
	return true;
}


String.prototype.replaceAll = function(search, replacement) {
	var target = this;
	return target.replace(new RegExp(search, 'g'), replacement);
};