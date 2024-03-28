function loadDropDownValues(currWorkstep,loggedInUser)
	{
		//alert("inside loaddropdown");
		//if(currWorkstep=='Introduction')
		//{
			var dropwDownId=['nationality','demographic','industysubseg','custsegment','custsubsegment','producttype'];
			
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			
			for(var i=0;i<dropwDownId.length;i++)
			{	
				url = '/RBL/CustomForms/RBL_Specific/DropDownLoad.jsp';
				var param="&reqType=selectDecision&WSNAME="+currWorkstep;
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
						document.getElementById(dropwDownId[i]).options.add(opt);
					 }				 
				}
				else 
				{
					alert("Error while Loading Drowdown "+dropwDownId[i]+" for the current workstep");
					return false;
				}
			}
		//}
		
		loadDecisionFromMaster(currWorkstep);
		getSOLIDOfLoggedInUser(currWorkstep,loggedInUser);
    }
	
	
function loadDecisionFromMaster(currWorkstep)
{
	if(currWorkstep == 'Exit' || currWorkstep == 'Reject')
	{
		return true;
	}
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
		
			url = '/RBL/CustomForms/RBL_Specific/DropDownLoad.jsp?reqType=selectDecision&WSNAME='+currWorkstep;
			xhr.open("GET",url,false);
			xhr.send(null);
			if (xhr.status == 200)
			{
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult=='-1')
				 {
					alert("Error while loading dropdown values for decision");
					return false;
				 }				 
				 values = ajaxResult.split("~");
				 for(var j=0;j<values.length;j++)
				 {
					var opt = document.createElement("option");
					opt.text = values[j];
					opt.value =values[j];
					document.getElementById('selectDecision').options.add(opt);
				 }				 
			}
			else 
			{
				alert("Error while Loading Drowdown decision.");
				return false;
			}
			
			loadperformcheckFromMaster("performcheckdays_CBRB");
			loadperformcheckFromMaster("performcheckdays_AECB");
			
			var Visit_Date = document.getElementById('wdesk:Visit_Date').value;
			if (Visit_Date != '')
			{
				Visit_Date = Visit_Date.substring(0,10);
				document.getElementById('wdesk:Visit_Date').value = Visit_Date;
			}
			var BVR_Date = document.getElementById('wdesk:BVR_Date').value;
			if (BVR_Date != '')
			{
				BVR_Date = BVR_Date.substring(0,10);
				document.getElementById('wdesk:BVR_Date').value = BVR_Date;
			}
			
			if(currWorkstep == 'AU_Doc_Checker')
			{
				FormatAmountFieldWithComma("wdesk:Requested_Amount");
				FormatAmountFieldWithComma("wdesk:Processing_fee");
				FormatAmountFieldWithComma("wdesk:Interest_rate");
			}
			
			disabledecision(currWorkstep);
}	
function loadLoanTypeFromMaster(currWorkstep,loanTypeSelected)
{
	var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
		
			url = '/RBL/CustomForms/RBL_Specific/DropDownLoad.jsp?reqType=LoanType&WSNAME='+currWorkstep;
			xhr.open("GET",url,false);
			xhr.send(null);
			if (xhr.status == 200)
			{
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult=='-1')
				 {
					alert("Error while loading dropdown values for Loan Type");
					return false;
				 }				 
				 values = ajaxResult.split("~");
				 for(var j=0;j<values.length;j++)
				 {
					var opt = document.createElement("option");
					opt.text = values[j];
					opt.value =values[j];
					if(values[j]==loanTypeSelected)
						opt.selected='selected';
					document.getElementById('wdesk:Loan_type').options.add(opt);
				 }				 
			}
			else 
			{
				alert("Error while Loading Drowdown Loan Type.");
				return false;
			}
}
function loadRMCodeFromMaster(currWorkstep,RMCodeSelected)
{
	var url='';
	var xhr;
	var ajaxResult;
	var ifRMActive=false; // Changed by Sajan for RM that is not active 03/03/2019
	if(window.XMLHttpRequest)
		xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		xhr=new ActiveXObject("Microsoft.XMLHTTP");
	url = '/RBL/CustomForms/RBL_Specific/DropDownLoad.jsp?reqType=RMCode&WSNAME='+currWorkstep;
	xhr.open("GET",url,false);
	xhr.send(null);
	if (xhr.status == 200)
	{
		 ajaxResult = xhr.responseText;
		 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		 if(ajaxResult=='-1')
		 {
			alert("Error while loading dropdown values for RMCode");
			return false;
		 }				 
		 values = ajaxResult.split("~");
		 
		 for(var j=0;j<values.length;j++)
		 {
			var opt = document.createElement("option");
			opt.text = values[j];
			opt.value =values[j];
			if(values[j]==RMCodeSelected)
			{
				opt.selected='selected';
				ifRMActive=true;  // Changed by Sajan for RM that is not active 03/03/2019
			}
			document.getElementById('wdesk:RMCode').options.add(opt);
		 }
		 //If condition added by Sajan for RM that is not active 03/03/2019
		 if(RMCodeSelected !='')
		 {
			 if(ifRMActive==false)
			 {
				var opt = document.createElement("option");
				opt.text=RMCodeSelected;
				opt.value=RMCodeSelected;
				opt.selected='selected';
				document.getElementById('wdesk:RMCode').options.add(opt);
			 }
		 }
		 // Changes end here 03/03/2019
	}
	else 
	{
		alert("Error while Loading Drop down RMCode.");
		return false;
	}
	
}
function loadROCodeFromMaster(currWorkstep,ROCodeSelected)
{
	var url='';
	var xhr;
	var ajaxResult;
	var ifROActive=false; // Changed by Sajan for RO that is not active 03/03/2019
	if(window.XMLHttpRequest)
		xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		xhr=new ActiveXObject("Microsoft.XMLHTTP");
	url = '/RBL/CustomForms/RBL_Specific/DropDownLoad.jsp?reqType=ROCode&WSNAME='+currWorkstep;
	xhr.open("GET",url,false);
	xhr.send(null);
	if (xhr.status == 200)
	{
		 ajaxResult = xhr.responseText;
		 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		 if(ajaxResult=='-1')
		 {
			alert("Error while loading dropdown values for ROCode");
			return false;
		 }				 
		 values = ajaxResult.split("~");
		 for(var j=0;j<values.length;j++)
		 {
			var opt = document.createElement("option");
			opt.text = values[j];
			opt.value =values[j];
			if(values[j]==ROCodeSelected)
			{
				opt.selected='selected';
				ifROActive=true;
			}
			document.getElementById('wdesk:ROCode').options.add(opt);
		 }
		//If condition added by Sajan for RM that is not active 03/03/2019
		 if(ROCodeSelected !='')
		 {
			 if(ifROActive==false)
			 {
				var opt = document.createElement("option");
				opt.text=ROCodeSelected;
				opt.value=ROCodeSelected;
				opt.selected='selected';
				document.getElementById('wdesk:ROCode').options.add(opt);
			 }
		 }
		 // Changes end here 03/03/2019		 
	}
	else 
	{
		alert("Error while Loading Drop down ROCode.");
		return false;
	}
	
}
function getSOLIDOfLoggedInUser(currWorkstep,loggedInUser)
{
	if(currWorkstep=='Introduction')
	{
			
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			
			
			var url = "/RBL/CustomForms/RBL_Specific/getSOLIDOfUser.jsp"
			var param ="userName="+loggedInUser;
			xhr.open("POST",url,false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
			if (xhr.status == 200)
			{	
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult=='-1')
				 {
					alert("Error while loading comment for users.");
					return false;
				 }
				 else	
				 {
					document.getElementById("wdesk:Sol_Id").value=ajaxResult;	
					document.getElementById("loggedInUserComment").innerHTML='&nbsp;'+ajaxResult;
				 }
			}
			else 
			{
				alert("Exception while Loading comment for users");
				return false;
			}
	}
	else
	{
			document.getElementById("loggedInUserComment").innerHTML='&nbsp;'+document.getElementById("wdesk:Sol_Id").value;
	}
	
		var currCheckList=document.getElementById('H_CHECKLIST').value;
		var workitemNo = document.getElementById('wdesk:WI_NAME').value;
		currCheckList = alreadyRaised(workitemNo,currCheckList);
		if(currCheckList != "null" && currCheckList != "Error")
		{
			document.getElementById('H_CHECKLIST').value = currCheckList;
			document.getElementById('H_CHECKLIST_TEMP').value = currCheckList;
		}
}

function loadperformcheckFromMaster(reqType)
{
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");

	url = "/RBL/CustomForms/RBL_Specific/DropDownLoad.jsp";
	var param="&reqType="+reqType;
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{
		 ajaxResult = xhr.responseText;
		 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		 if(ajaxResult=='-1')
		 {
			alert("Error while loading dropdown values for perform check for days");
			return false;
		 }				 
		 
		 document.getElementById(reqType).value = ajaxResult;
		 return true;
					 
	}
	else 
	{
		alert("Error while Loading for perform check for days.");
		return false;
	}
			
}

function FormatAmountFieldWithComma(id) 
{
	var inputtxt = document.getElementById(id).value;
	if (inputtxt == '') return;
	inputtxt=inputtxt.split(",").join("");
	if (inputtxt == '') return;
	
	if (inputtxt.indexOf('.') == -1)
	{
		inputtxt = inputtxt+'.00';
		document.getElementById(id).value = inputtxt;
	}
	var numbers = /^([0-9]{0,18})\.([0-9]{1,2})$/;
	if(inputtxt.match(numbers))
	{
		var CommaSeparated = Number(parseFloat(inputtxt).toFixed(2)).toLocaleString('en', {
		minimumFractionDigits: 2});
		document.getElementById(id).value=CommaSeparated;
		return true;	
	}
		
}

function loadIndustryCode(selectedValue)  // industry code changed as Macro on 19052019
{
	var dropwDownId=['wdesk:IndustryCode'];
	var url = '';
	var xhr;
	var ajaxResult;		
	var ifIndustryCodeActive=false; // Changed by Sajan for RO that is not active 03/03/2019
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	for(var i=0;i<dropwDownId.length;i++)
	{	
		url = '/RBL/CustomForms/RBL_Specific/DropDownLoad.jsp';
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
					ifIndustryCodeActive=true;
				}
				document.getElementById(dropwDownId[i]).options.add(opt);
			 }
		//If condition added by Sajan for Industry that is not active 05/03/2019
		 if(selectedValue !='')
		 {
			 if(ifIndustryCodeActive==false)
			 {
				var opt = document.createElement("option");
				opt.text=selectedValue;
				opt.value=selectedValue;
				opt.selected='selected';
				document.getElementById('wdesk:IndustryCode').options.add(opt);
			 }
		 }
		 // Changes end here 05/03/2019			 
		}
		else 
		{
			alert("Error while Loading Drowdown "+dropwDownId[i]);
			return false;
		}
	}
}

function loadMicroValues(selectedValue)
{
	var dropwDownId=['wdesk:Micro'];
	var url = '';
	var xhr;
	var ajaxResult;		
	var ifMicroCodeActive=false; // Changed by Sajan for RO that is not active 03/03/2019
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	for(var i=0;i<dropwDownId.length;i++)
	{	
		url = '/RBL/CustomForms/RBL_Specific/DropDownLoad.jsp';
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
					ifMicroCodeActive=true;
				}
				document.getElementById(dropwDownId[i]).options.add(opt);
			 }
		//If condition added by Sajan for Industry that is not active 05/03/2019
		 if(selectedValue !='')
		 {
			 if(ifMicroCodeActive==false)
			 {
				var opt = document.createElement("option");
				opt.text=selectedValue;
				opt.value=selectedValue;
				opt.selected='selected';
				document.getElementById('wdesk:Micro').options.add(opt);
			 }
		 }
		 // Changes end here 05/03/2019			 
		}
		else 
		{
			alert("Error while Loading Drowdown "+dropwDownId[i]);
			return false;
		}
	}
}

function loadValuesInDropDown(id,selectedValue)
{
	var dropwDownId=[id];
	var url = '';
	var xhr;
	var ajaxResult;		
	var ifSectorCodeActive=false; // Changed by Sajan for RO that is not active 03/03/2019
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	for(var i=0;i<dropwDownId.length;i++)
	{	
		url = '/RBL/CustomForms/RBL_Specific/DropDownLoad.jsp';
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
					ifSectorCodeActive=true;
				}
				document.getElementById(dropwDownId[i]).options.add(opt);
			 }
		//If condition added by Sajan for Industry that is not active 05/03/2019
		 if(selectedValue !='')
		 {
			 if(ifSectorCodeActive==false)
			 {
				var opt = document.createElement("option");
				opt.text=selectedValue;
				opt.value=selectedValue;
				opt.selected='selected';
				document.getElementById(dropwDownId[i]).options.add(opt);
			 }
		 }
		 // Changes end here 05/03/2019			 
		}
		else 
		{
			alert("Error while Loading Drowdown "+dropwDownId[i]);
			return false;
		}
	}
}

function disabledecision(wsname)
{
	var x = document.getElementById("selectDecision");
	if(wsname=='AU_Officer')
	{
		if(document.getElementById("wdesk:q_IsDistributed").value=='Yes')
		{
			for (var i = 0; i < x.options.length; i++) 
			{
				if(x.options[i].value=='Approve')
				{
					x.options[i].disabled = true;
				}
			}
		}
	}
}