/*
client<Cabinetname>.js  for CAC process
*/
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           Function validates on click of save
//***********************************************************************************//

function SaveClick() 
{
    return true;
}

//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           Function validates conditions on click of introduce
//***********************************************************************************//
function IntroduceClick() 
{
	
	
		var flag="I";
    if (strprocessname == 'DA') 
	{
		
		return validateOnInroduceClick(flag);
		
	}	
        /* if(DASAVEDATA(false))
				return true;
			else
				return false; */	
	else
	{
				return true;
		
    } 
	
	
    return true;
  
}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           Function validates on click of done
//***********************************************************************************//
function DoneClick() {
	var flag="D";
    if (strprocessname == 'DA') 
	{
		return validateOnInroduceClick(flag);	
	}

		
		/* if(DASAVEDATA(false))
				return true;
			else
				return false; */
	else
	{
				return true;
		
    } 		

	
    return true;
}


function validateOnInroduceClick(flag) 
{
	var customform = '';
	var formWindow = getWindowHandler(windowList, "formGrid");
	customform = formWindow.frames['customform'];
	var WS_NAME = customform.document.getElementById("wdesk:Ws_name").value;
	//customform.document.getElementById("wdesk:decision").value = customform.document.getElementById("selectDecision").value;
	
	 /* if(WS_NAME=='Archival Document Initiation')
	{ */ 
	//validations
	var decision = customform.document.getElementById("selectDecision").value;
	
	var ArchivalType = customform.document.getElementById("selectArchivalType").value;
	
	//decision field validation
	
		
		//Remarks field validation
		var Remarks = customform.document.getElementById("wdesk:remarks").value;
		// Added for AutoLoan CR_03022018 - Reject condition added
		if(decision=='Reject & Partial Acknowledged' || decision=='Resubmit' || decision=='Reject' || decision.indexOf('Reject')!=-1 || decision.indexOf('Additional Information Required')!=-1)
		{
			if(Remarks==''||Remarks==null)
			{
			alert("Please enter the Remarks");
			customform.document.getElementById("wdesk:remarks").focus();
			return false;
			}
		}
		
		//Reject Reason validation
		var Rejectreason = customform.document.getElementById("rejReasonCodes").value;
		if(decision=='Reject & Partial Acknowledged')
		{
			if(Rejectreason==''||Rejectreason==null)
			{
			alert("Please Enter the Reject reason");
			customform.document.getElementById("rejReasonCodes").focus();
			return false;
			}
		}
		
		if(customform.document.getElementById("wdesk:CIFNumber").disabled == false)
		{
			var CIFID = customform.document.getElementById("wdesk:CIFNumber").value;
			if (CIFID.length > 0 && CIFID.length != 7)
			{
				alert("CIF Number should be exact 7 digit");
				customform.document.getElementById("wdesk:CIFNumber").focus();
				return false;
			}
		}
		
		if (WS_NAME == 'Archival Document Initiation')
		{
			if(ArchivalType=="" || ArchivalType=="--Select--"|| ArchivalType==null)
			
			{
				alert("Please select Archival Type");
				customform.document.getElementById("selectArchivalType").focus();
				return false;
				
			}	
			// Added for AutoLoan CR_03022018 - condition added
			if(ArchivalType=='Service Request Branch' || ArchivalType=='CIF Update' || ArchivalType=='Profile Change')
			{
				if(customform.document.getElementById("wdesk:Processed_date").value==""|| customform.document.getElementById("wdesk:Processed_date").value==null)
				{
					alert("Please select Processed Date");
					customform.document.getElementById("wdesk:Processed_date").focus();
					return false;
				}
				
				if (ArchivalType=='Profile Change')
				{
					if(customform.document.getElementById("wdesk:ProfileChangeWINumber").value==""|| customform.document.getElementById("wdesk:ProfileChangeWINumber").value==null)
					{
						alert("Please Enter Profile Change WI Number");
						customform.document.getElementById("wdesk:ProfileChangeWINumber").focus();
						return false;
					}
				}
			}			
			// Added for AutoLoan CR_03022018 - condition added			
			if(ArchivalType=='Auto Loan' ||ArchivalType=='Mortgage Loan' || ArchivalType=='Credit Card' || ArchivalType=='Personal Loan')
			{
				if(customform.document.getElementById("wdesk:CustomerName").value==""|| customform.document.getElementById("wdesk:CustomerName").value==null)
				{
					alert("Please enter Customer name");
					customform.document.getElementById("wdesk:CustomerName").focus();
					return false;
				}
				/*else if(customform.document.getElementById("wdesk:SRNumber").value==""|| customform.document.getElementById("wdesk:SRNumber").value==null)
				{
					alert("Please enter SR number");
					customform.document.getElementById("wdesk:SRNumber").focus();
					return false;
				}
				else if(customform.document.getElementById("wdesk:Description").value==""|| customform.document.getElementById("wdesk:Description").value==null)
				{
					alert("Please enter descreption");
					customform.document.getElementById("wdesk:Description").focus();
					return false;
				}*/	
			}
			
			if (ArchivalType!='Profile Change') // for profile change no document should be mandatory
			{
				var arrAvailableDocList = document.getElementById('wdesk:docCombo').value;
				if (arrAvailableDocList == null || arrAvailableDocList == 'null')
				arrAvailableDocList = customform.document.getElementById('wdesk:docCombo').value;
				if(arrAvailableDocList==null || arrAvailableDocList=="--Select--"|| arrAvailableDocList=="")
				{
						alert("Please attach Document");
						return false;
				}
			}
		}
		
		// added on 09/05/2019 for Personal Loan
		if (WS_NAME == 'Data Entry')
		{
			if (ArchivalType=='Personal Loan')
			{
				if(customform.document.getElementById("wdesk:CIFNumber").value==""|| customform.document.getElementById("wdesk:CIFNumber").value==null)
				{
					alert("Please enter CIF number");
					customform.document.getElementById("wdesk:CIFNumber").focus();
					return false;
				}
			}
		}
		
		//added by siva for Conditional Validation in Archival Document Reject WS 
		// Added for AutoLoan CR_03022018 - condition added
		if (WS_NAME == 'Archival Document Reject')
		{
			if(ArchivalType=='Service Request Branch' || ArchivalType=='CIF Update' || ArchivalType=='Profile Change')
			{
				if(customform.document.getElementById("wdesk:Processed_date").value==""|| customform.document.getElementById("wdesk:Processed_date").value==null)
				{
					alert("Please select Processed Date");
					customform.document.getElementById("wdesk:Processed_date").focus();
					return false;
				}
				
				if (ArchivalType=='Profile Change')
				{
					if(customform.document.getElementById("wdesk:ProfileChangeWINumber").value==""|| customform.document.getElementById("wdesk:ProfileChangeWINumber").value==null)
					{
						alert("Please Enter Profile Change WI Number");
						customform.document.getElementById("wdesk:ProfileChangeWINumber").focus();
						return false;
					}
				}
			}
			//Modified on 19/04/2019.
			if(ArchivalType=='Auto Loan' ||ArchivalType=='Mortgage Loan' || ArchivalType=='Credit Card' || ArchivalType=='Personal Loan')
			{
				if(customform.document.getElementById("wdesk:CustomerName").value==""|| customform.document.getElementById("wdesk:CustomerName").value==null)
				{
					alert("Please enter Customer name");
					customform.document.getElementById("wdesk:CustomerName").focus();
					return false;
				}
			}				
		}
		/*BELOW VALIDATION ADDED BY SHARAN FOR MANDATORY FIELDS IN OPS MAKER WS ON 21-01-2020*/
		
		if (WS_NAME == 'OPS Maker')
		{
			if(ArchivalType=='Court Instructions and Other Police Letters')
			{
				if(customform.document.getElementById("selectCustomer_Type").value=="--Select--" ||customform.document.getElementById("selectCustomer_Type").value=="" || customform.document.getElementById("selectCustomer_Type").value==null)
				{
					alert("Please select Customer_Type");
					customform.document.getElementById("selectCustomer_Type").focus();
					return false;
				}
				
				if(customform.document.getElementById("selectCustomer_Type").value=="Customer - Individual" || customform.document.getElementById("selectCustomer_Type").value=="Customer - Business")
				{
					if(customform.document.getElementById("wdesk:CIFNumber").value==""|| customform.document.getElementById("wdesk:CIFNumber").value==null)
					{
						alert("Please enter CIF number");
						customform.document.getElementById("wdesk:CIFNumber").focus();
						return false;
					}
				}
			}
		}
		
		if (WS_NAME == 'OPS Checker')
		{
			if(ArchivalType=='Court Instructions and Other Police Letters')
			{
				if (customform.document.getElementById("selectDecision").value != 'Additional Information Required Branch')
				{
					if(customform.document.getElementById("wdesk:Court_Order_No").value==""|| customform.document.getElementById("wdesk:Court_Order_No").value==null)
					{
						alert("Please enter Court Order No");
						customform.document.getElementById("wdesk:Court_Order_No").focus();
						return false;
					}
					if(customform.document.getElementById("wdesk:Letter_Reference").value==""|| customform.document.getElementById("wdesk:Letter_Reference").value==null)
					{
						alert("Please enter Letter Reference");
						customform.document.getElementById("wdesk:Letter_Reference").focus();
						return false;
					}
				}
			}
		}	
			
			//alert("decision"+decision);
			if(decision=='--Select--')
			{
				alert("Please select the decision");
				customform.document.getElementById("selectDecision").focus();
				return false;
			}
		
		if(flag=='S'){
            DASAVEDATA(false);
			alert("The request has been submitted successfully.");
			return true;
		}
		else{
				DASAVEDATA(true);
				//saving processed date for creating archival folder stractue in DD-MM-YYY format
				if (WS_NAME =='Archival Document Receipt' && decision=='Acknowledged')
				{
					//Setting received date in table on decision acknowledgement
					var today=new Date();
					var dd=today.getDate();
					var mm=today.getMonth()+1;
					var yyyy=today.getFullYear();
					if(dd<10){
					dd='0'+dd;
					}
					if(mm<10){
						mm='0'+mm;
					}
					var today=dd+'-'+mm+'-'+yyyy;
					customform.document.getElementById("wdesk:ReceivedDate").value=today;
					//***********************************************************/
					//Verify that value is not blank in side ReceivedDate
					if(customform.document.getElementById("wdesk:ReceivedDate").value=='')
					{
						alert("Please select Received Date.");
						return false;
					}					
				}			
			alert("The request has been submitted successfully.");
			return true;
		}
	return true;
	}

function DASAVEDATA(IsDoneClicked) {
	
	//alert("Inside DASAVEDATA");
	var WSNAME = customform.document.getElementById("wdesk:Ws_name").value;
    var WINAME = customform.document.getElementById("wdesk:wi_name").value;
	var rejectReasons = customform.document.getElementById("rejReasonCodes").value;
    var Decision = '';
	//
        Decision = customform.document.getElementById("selectDecision").value;
   /* else if (WSNAME == 'Archival Document Receipt')
        Decision = customform.document.getElementById("selectDecision").value;
    else if (WSNAME == 'Archival Document Reject')
        Decision = customform.document.getElementById("selectDecision").value;*/
	
		
    var Remarks = customform.document.getElementById("wdesk:remarks").value;
	//alert("Remarks"+Remarks);
	//for inserting decision in decision history
    var xhr;
    if (window.XMLHttpRequest)
        xhr = new XMLHttpRequest();
    else if (window.ActiveXObject)
        xhr = new ActiveXObject("Microsoft.XMLHTTP");
    var abc = Math.random;

    var url = "/DA/CustomForms/DA_Specific/SaveHistory.jsp";
    var param = "WINAME=" + WINAME + "&WSNAME=" + WSNAME + "&Decision=" + Decision + "&Remarks=" + Remarks + "&rejectReasons=" + rejectReasons + "&IsDoneClicked=" + IsDoneClicked + "&IsSaved=Y&abc=" + abc;

    xhr.open("POST", url, false);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.send(param);
	
    if (xhr.status == 200 && xhr.readyState == 4) {
        ajaxResult = Trim(xhr.responseText);

        if (ajaxResult == 'NoRecord') {
            alert("No record found.");
            return false;
        } else if (ajaxResult == 'Error') {
            alert("Some problem in creating workitem.");
            return false;
        }
    } else {
        alert("Problem in saving data");
        return false;
    }

    //Submitted Case at CSO_Initiate
    //if (WSNAME == 'CSO') {}

    return true;
}
