window.document.write("<script src=\"/webdesktop/CustomForms/TL_Specific/moment.js\"></script>");
function  validateTLForm(workstepName,IsDoneClicked) { 

	var Decision=customform.document.getElementById("DecisionDropDown").value;
	var newExpDate = customform.document.getElementById("wdesk:New_Expiry_Date").value;
	//alert("test"+newExpDate);
	var rejectReason=customform.document.getElementById("wdesk:RejectReason").value;
	//newExpDate = moment(newExpDate).format('DD/MM/YYYY');
	var CIFId = customform.document.getElementById("wdesk:CIF_Num").value;
	var accountNo = customform.document.getElementById("wdesk:Acc_Num").value;
	var TLNumber = customform.document.getElementById("wdesk:TL_Num").value;
	
	var ID_Issued_Org = customform.document.getElementById('wdesk:ID_Issued_Org').value;
	ID_Issued_Org = encodeURIComponent(ID_Issued_Org);
	
		if(workstepName=="OPS_Maker") {

			if(IsDoneClicked) {

			
				//Change request done by Ankit starts
				/*var result = ajaxRequestForAgencyName(ID_Issued_Org,'getAgencyName');
				
				if(result!=false && result > 0)
				{
					var arrAvailableDocList = document.getElementById('wdesk:docCombo');
					if (arrAvailableDocList == null || arrAvailableDocList == 'null')
						arrAvailableDocList = customform.document.getElementById('wdesk:docCombo');
					var bResult = false;
					for (var iDocCounter = 0; iDocCounter < arrAvailableDocList.length; iDocCounter++) {
						if (arrAvailableDocList[iDocCounter].text.toUpperCase().indexOf("Website_Trade_License".toUpperCase()) >= 0) {
							bResult = true;
							break;
						}
					}
					if (!bResult) {
						alert("Please attach Website Trade License document to proceed further.");
						return false;
					}	
				}*/	
				//Change request done by ankit ends
				if(TLNumber==''){
					alert('Please search existing TL details and click on the radio button!');
					return false;
				}
				
				if(newExpDate=='') {
					alert('Please enter Expiry Date(New)');
					customform.document.getElementById("wdesk:New_Expiry_Date").focus();
					return false;
				}
				else{
					var currentDate = new Date();
					var splitDate = newExpDate.split("/");
					
					var newExpiryDate = new Date(splitDate[2],splitDate[1]-1,splitDate[0]);
					//newExpiryDate = new Date(newExpDate);
					
					//alert("new1"+newExpiryDate);
					//alert("current1"+currentDate);
					if(newExpiryDate<=currentDate)
					{
						alert("New Expiry Date cannot be less than or equal to today's date.");
						customform.document.getElementById("wdesk:New_Expiry_Date").focus();
						return false;
					}
				}
			}	
			if(IsDoneClicked)
			{			
				var isSearchDisabled = customform.document.getElementById("Fetch").disabled;
				//alert(isSearchDisabled);
				if((CIFId == '' && accountNo == '') /* || !isSearchDisabled*/) {
					alert("Please search existing TL details!");
					return false;
				}
							
				//var arrAvailableDocList = document.getElementById('wdesk:docCombo');
				var arrAvailableDocList = getInterfaceData("D");
				var bResult=false;
				for(var iDocCounter=0;iDocCounter<arrAvailableDocList.length;iDocCounter++){
					if(arrAvailableDocList[iDocCounter].name.toUpperCase().indexOf("Previous_Years_Trade_License".toUpperCase())>=0){

						bResult = true;
						break;
					}
				}
				if(!bResult){
					alert("Please attach Previous Year's Trade License to proceed further.");
					return false;
				}
			}			
			if((Decision=='' || Decision=='--Select--')) { 
				if(IsDoneClicked) {
					alert('Please select a Decision');
					customform.document.getElementById("DecisionDropDown").focus();
					return false; 
				}				
			}
			else {
				//if(Decision=='Reject TL') 
				if(Decision=='Front Office Reject') 
				{
					if(rejectReason=='' || rejectReason=='--Select--'){
						alert('Please select a Reject reason');
						customform.document.getElementById("rejectreason").focus();
							return false; 
					}
				}
				
			}	
		}
	 if(workstepName=="OPS_Checker") {
			var OPSMakerDecision = customform.document.getElementById("OPSMakerDecision").value;
				 
			if((Decision=='' || Decision=='--Select--')) { 
				if(IsDoneClicked) {
					alert('Please select a Decision');
					customform.document.getElementById("DecisionDropDown").focus();
					return false; 
				}				
			}
			else {
				//if(Decision=='Reject TL')
				if(Decision=='Front Office Reject')
				{
					if(rejectReason=='' || rejectReason=='--Select--') {
						alert('Please select a Reject reason');
						customform.document.getElementById("rejectreason").focus();
							return false; 
					}
				}
				
			}
		
			if(Decision=='Profile Change') {			
				if(customform.document.getElementById("wdesk:Supporting_Docs").value=='' || customform.document.getElementById("wdesk:Supporting_Docs").value==null)
				{
					alert("Please select at least one document, required for Profile change.");
					customform.document.getElementById("DecisionDropDown").focus();
					return false;
				}			
					
				if(!validateTODOList())
					return false;
			}			
		}
	 if(workstepName=="Error") {
			if((Decision=='' || Decision=='--Select--')) { 
				if(IsDoneClicked) {
					alert('Please select a Decision');
					customform.document.getElementById("DecisionDropDown").focus();
					return false; 
				}				
			}
			else {
				//if(Decision=='Reject TL') 
				if(Decision=='Front Office Reject') 
				{
					if(rejectReason=='' || rejectReason=='--Select--') {
						alert('Please select a Reject reason');
						customform.document.getElementById("rejectreason").focus();
							return false; 						
					}
				}
			}
		}
	 if(workstepName=="Rejected_TL") {	
			var OPSMakerDecision = customform.document.getElementById("OPSMakerDecision").value;
			var OPSCheckerDecision = customform.document.getElementById("OPSCheckerDecision").value;
			
			// if(OPSMakerDecision=='Reject TL' ||OPSCheckerDecision=='Reject TL') 
			if(OPSCheckerDecision=='Front Office Reject') 
			{
				
				if(!validateTODOList())
					return false;
			}
	 
			if((Decision=='' || Decision=='--Select--')) { 
				if(IsDoneClicked) {
					alert('Please select a Decision');
					customform.document.getElementById("DecisionDropDown").focus();
					return false; 
					}
			}
			else {
				//if(Decision=='Reject TL') 
				if(Decision=='Front Office Reject') 
				{

					if(rejectReason=='' || rejectReason=='--Select--') {
						alert('Please select a Reject reason');
						customform.document.getElementById("rejectreason").focus();
							return false; 						
					}
				}
				/*else if(Decision=='Resubmit') {

					customform.document.getElementById("wdesk:RejectReason").value = '--Select--';
				}*/
			}
		}
		return true;
}
	
function ajaxRequestForAgencyName(ID_Issued_Org,reqType)
{
	var url = '/webdesktop/CustomForms/TL_Specific/HandleAjaxRequest.jsp?ID_Issued_Org='+ID_Issued_Org+"&reqType="+reqType;
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
		
		return ajaxResult;
	}
	else
	{
		alert("Error while handling "+reqType+" for the current workstep");
		return false;
	}
}	
//Below function can be used to make TODO list mandatory at some special conditions.
function validateTODOList() {
	var trigResponse = getInterfaceData('T','F');

  	for(var i=0;i<trigResponse.length;i++){
	    stodolist = trigResponse[i].value;
		
			 if((stodolist=='') && (trigResponse[i].isAssociatedItem=="Y")) {
				  alert('No value specified for mandatory To Do Item.');
				  return false;
			 } 
	}
   return true;
}	