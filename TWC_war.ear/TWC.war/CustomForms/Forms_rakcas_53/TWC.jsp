<%@ page import="java.util.Iterator"%>
<%@ include file="../TWC_Specific/Log.process"%>
<%@ include file="../header.process" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %><%@ page import="com.newgen.custom.wfdesktop.baseclasses.*"%>
<%@ page import="com.newgen.mvcbeans.model.wfobjects.*, com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*, javax.faces.context.FacesContext"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>
<%
	createLogFile("TWC");
    logger.info("parameterMap: "+parameterMap);
    if (parameterMap != null && parameterMap.size() > 0) {
    String sCabName=customSession.getEngineName();	
    logger.info("sCabName: "+sCabName);
    String sSessionId = customSession.getDMSSessionId();
    String sJtsIp = customSession.getJtsIp();
    int iJtsPort = customSession.getJtsPort();
    String user_name = customSession.getUserName();
    //WFCustomWorkitem WFWorkitem = new WFCustomWorkitem();
	logger.info("jtsIP: "+jtsIP);
	logger.info("jtsPort: "+jtsPort);
	logger.info("sessionId: "+sessionId);
    String outputXmlFetch = "";
	
	WFCustomWorkitem WFWorkitem = new WFCustomWorkitem();
	if("N".equalsIgnoreCase(ArchivalMode)){
		outputXmlFetch = WFWorkitem.WMFetchWorkItemAttribute(jtsIP, jtsPort, debugValue, engineName, sessionId, WINAME, wid, "", "", "", "", "", "", "", activityId, routeID);
	}else if("Y".equalsIgnoreCase(ArchivalMode)){
		outputXmlFetch = WFWorkitem.WMFetchWorkItemAttribute(jtsIP, jtsPort, debugValue, engineName, sessionId, WINAME, wid, "", "", "", "", "", "", "", activityId, routeID, "Y",sCabName);
	}
	WriteLog("Output XML:"+outputXmlFetch);
	
	WFCustomXmlResponse wfXmlResponse = new WFCustomXmlResponse(outputXmlFetch);
    attributeData = "<Attributes>" + wfXmlResponse.getVal("Attributes") + "</Attributes>";
	
    CustomWiAttribHashMap structureMap = new CustomWiAttribHashMap();
    LinkedHashMap varIdMap = new LinkedHashMap();
    attributeMap = WFCustomAttribParser.fillDataStructure(attributeData, structureMap, varIdMap, dateFormat);
	
    session = request.getSession(false);
	logger.info("attributeMap: "+attributeMap);
    logger.info("WINAME..."+WINAME);
	SimpleDateFormat sdfDate = new SimpleDateFormat("dd/MM/yyyy");
	Date now = new Date();
	String strDate = sdfDate.format(now);
	
	String strROCode=((CustomWorkdeskAttribute)attributeMap.get("RO_Code")).getAttribValue().toString()==null?"NULL":((CustomWorkdeskAttribute)attributeMap.get("RO_Code")).getAttribValue().toString().trim();
	strROCode = strROCode.trim();
	logger.info("RO Code is  "+strROCode);
	
	String strFirst_Level_Business_Approver=((CustomWorkdeskAttribute)attributeMap.get("First_Level_Business_Approver")).getAttribValue().toString()==null?"NULL":((CustomWorkdeskAttribute)attributeMap.get("First_Level_Business_Approver")).getAttribValue().toString().trim();
	strFirst_Level_Business_Approver = strFirst_Level_Business_Approver.trim();
	logger.info("strFirst_Level_Business_Approver is  "+strFirst_Level_Business_Approver);
	
	String strSecond_Level_Business_Approver=((CustomWorkdeskAttribute)attributeMap.get("Second_Level_Business_Approver")).getAttribValue().toString()==null?"NULL":((CustomWorkdeskAttribute)attributeMap.get("Second_Level_Business_Approver")).getAttribValue().toString().trim();
	strSecond_Level_Business_Approver = strSecond_Level_Business_Approver.trim();
	logger.info("strSecond_Level_Business_Approver is  "+strSecond_Level_Business_Approver);
	
	String strFirst_Level_Credit_Approver=((CustomWorkdeskAttribute)attributeMap.get("First_Level_Credit_Approver")).getAttribValue().toString()==null?"NULL":((CustomWorkdeskAttribute)attributeMap.get("First_Level_Credit_Approver")).getAttribValue().toString().trim();
	strFirst_Level_Credit_Approver = strFirst_Level_Credit_Approver.trim();
	logger.info("strFirst_Level_Credit_Approver is  "+strFirst_Level_Credit_Approver);
	
	String strSecond_Level_Credit_Approver=((CustomWorkdeskAttribute)attributeMap.get("Second_Level_Credit_Approver")).getAttribValue().toString()==null?"NULL":((CustomWorkdeskAttribute)attributeMap.get("Second_Level_Credit_Approver")).getAttribValue().toString().trim();
	strSecond_Level_Credit_Approver = strSecond_Level_Credit_Approver.trim();
	logger.info("strSecond_Level_Credit_Approver is  "+strSecond_Level_Credit_Approver);
	
	logger.info("attributeMap Partner Code is  "+String.valueOf(attributeMap.get("Partner_Code")));
	
	String strPartnerCode=((CustomWorkdeskAttribute)attributeMap.get("Partner_Code")).getAttribValue().toString()==null?"NULL":((CustomWorkdeskAttribute)attributeMap.get("Partner_Code")).getAttribValue().toString().trim();
	strPartnerCode = strPartnerCode.trim();
	logger.info("Partner Code is  "+strPartnerCode);
	%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script language="javascript" src="/TWC/webtop/scripts/clientTWC.js"></script>
<script language="javascript" src="/TWC/webtop/scripts/TWC_Script/loadDropDownValues.js"></script>
<script language="javascript" src="/TWC/webtop/scripts/TWC_Script/loadFormValuesAtNextWS.js"></script>
<script language="javaScript" src="/TWC/webtop/scripts/TWC_Script/calendar_TWC.js"></script>
<script language="javascript" src="/TWC/webtop/scripts/TWC_Script/FieldValidation.js"></script>
<script language="javascript" src="/TWC/webtop/scripts/TWC_Script/TWCIntegrate.js"></script>

<!------------------------------------ for autocomplete--------------------------------------->
<script language="javascript" src="/TWC/webtop/scripts/TWC_Script/jquery-latest.js"></script>
<script language="javascript" src="/TWC/webtop/scripts/TWC_Script/jquery.autocomplete.js"></script>
<script language="javascript" src="/TWC/webtop/scripts/TWC_Script/jquery.min.js"></script>
<script language="javascript" src="/TWC/webtop/scripts/TWC_Script/bootstrap.min.js"></script>
<script language="javascript" src="/TWC/webtop/scripts/TWC_Script/jquery-ui.js"></script>
<script language="javascript" src="/TWC/webtop/scripts/TWC_Script/jspdf.min.js"></script>
<HTML>
<HEAD>
	<link rel="stylesheet" href="..\..\webtop\scripts\TWC_Script\bootstrap.min.css">
	<link rel="stylesheet" href="..\..\webtop\scripts\TWC_Script\jquery-ui.css">
	<link rel="stylesheet" href="..\..\webtop\en_us\css\jquery.autocomplete.css">
	<link rel="stylesheet" href="..\..\webtop\en_us\css\jquery-ui.css">
	<link rel="stylesheet" href="..\..\webtop\en_us\css\docstyle.css">
	<TITLE>Trade Working Capital</TITLE>
	<script>
	
		/*$("textarea").keydown(function(e) {
		if(e.keyCode === 9) { // tab was pressed
			// get caret position/selection
			var start = this.selectionStart;
			var end = this.selectionEnd;
			var $this = $(this);
			var value = $this.val();
			// set textarea value to: text before caret + tab + text after caret
			$this.val(value.substring(0, start)
						+ "\t"
						+ value.substring(end));
			// put caret at right position again (add one for the tab)
			this.selectionStart = this.selectionEnd = start + 1;
			// prevent the focus lose
			e.preventDefault();
		}
	});*/
		//Functions added by Sajan to handle TAB in textarea
		
		function setSelectionRange(input, selectionStart, selectionEnd) {
					  if (input.setSelectionRange) {
						input.focus();
						input.setSelectionRange(selectionStart, selectionEnd);
					  }
					  else if (input.createTextRange) {
						var range = input.createTextRange();
						range.collapse(true);
						range.moveEnd('character', selectionEnd);
						range.moveStart('character', selectionStart);
						range.select();
					  }
			}
		
		function enableTab(id)
		{
			var code=window.event.keyCode;
			if(code==9 && document.getElementById(id).value.indexOf('___')!=-1)
			{
				var element=document.getElementById(id);
				var pos=element.value.indexOf('___');
				setSelectionRange(element, pos, pos);
				window.event.keyCode=0;
				return;
			}	
		}
		//end here
		
		document.onkeydown = mykeyhandler;
		function mykeyhandler() 
		{
			var elementType=window.event.srcElement.type;
			var eventKeyCode=window.event.keyCode;
			var isAltKey=window.event.altKey;
			//alert('eventKeyCode '+eventKeyCode+' elementType '+elementType);
			if (eventKeyCode == 8 && elementType!='text' && elementType!='textarea' && elementType!='submit' && elementType!='password' ) {
				window.event.keyCode = 0;
				return false;
			}
		}
		
		function auto_grow(element)
		{
			element.style.height=(element.scrollHeight)+"px";
		}
		
		function setFrameSize()
		{
			var widthToSet = document.getElementById("TWC_Grid").offsetWidth;
			var controlName="TWC,TWC_Header,TWC_Grid,Facility_Details,Facility_Details_Header,Facility_Details_Grid2,General_Condition_Grid,Security_Document_Details,Security_Document_Details_Header,Security_Document_Details_Grid,Security_Document_Details_Grid2,Special_Covenants_Internal_Grid,Special_Covenants_External_Grid,Defferal_Details,Defferal_Details_Header,Defferal_Details_Grid,Tranche_Details,Tranche_Details_Header,Tranche_Details_Grid,Duplicate_Workitems,Decision,Decision_Grid,UID_Details,UID_Header,UID_Grid";
			var fieldArray = controlName.split(",");
			var loopVar=0;
			while(loopVar<fieldArray.length)
			{
			   if(document.getElementById(fieldArray[loopVar]))
				{
					document.getElementById(fieldArray[loopVar]).style["width"] = widthToSet+"px";
				}				
				loopVar++;	
			}
		}
		function getSOLIDOfLoggedInUser(currWorkstep,loggedInUser)
		{
			if(currWorkstep=='Initiation')
			{
				var xhr;
				var ajaxResult;		
				if(window.XMLHttpRequest)
					xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
					xhr=new ActiveXObject("Microsoft.XMLHTTP");
				var url = "/TWC/CustomForms/TWC_Specific/GetSOLIDofUser.jsp";
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
				document.getElementById("loggedInUserComment").innerHTML='&nbsp;'+document.getElementById("wdesk:Sol_Id").value;
			}
		}
		
		//If CIF ID is changed
		//Modified on 22/02/2019 to add more fields 
		function onChangeCIFID()
		{
			var customer_name=document.getElementById("wdesk:Customer_Name");
			var Address_Line_1=document.getElementById("wdesk:Address_Line_1");
			var Address_Line_2=document.getElementById("wdesk:Address_Line_2");
			var Address_Line_3=document.getElementById("wdesk:Address_Line_3");
			var Address_Line_4=document.getElementById("wdesk:Address_Line_4");
			var PO_Box=document.getElementById("wdesk:PO_Box");
			var Emirate=document.getElementById("wdesk:Emirate");
			var Country=document.getElementById("wdesk:Country");
			var Dec_Populate=document.getElementById("wdesk:Dec_Populate");
			
			var Landline_code=document.getElementById("wdesk:Landline_code");
			var Landline_Number=document.getElementById("wdesk:Landline_Number");
			var Mobile_Code=document.getElementById("wdesk:Mobile_Code");
			var Mobile_Number=document.getElementById("wdesk:Mobile_Number");
			var Email_ID=document.getElementById("wdesk:Email_ID");
			customer_name.disabled=false;
			customer_name.value="";
			Address_Line_1.disabled=false;
			Address_Line_1.value="";
			Address_Line_2.disabled=false;
			Address_Line_2.value="";
			Address_Line_3.disabled=false;
			Address_Line_3.value="";
			Address_Line_4.disabled=false;
			Address_Line_4.value="";
			PO_Box.disabled=false;
			PO_Box.value="";
			Emirate.disabled=false;
			Emirate.value="";
			Country.disabled=false;
			Country.value="";
			Landline_code.disabled=false;
			Landline_code.value="";
			Landline_Number.disabled=false;
			Landline_Number.value="";
			Mobile_Code.disabled=false;
			Mobile_Code.value="";
			Mobile_Number.disabled=false;
			Mobile_Number.value="";
			Email_ID.disabled=false;
			Email_ID.value="";
			Dec_Populate.value="N";
			
		}
		
		//Disable all fields in readonly mode
		function DisableFieldinReadOnlyMode()
		{
			if((parent.document.title).indexOf("(read only)")>0)
			{
				var wsname = '<%=WSNAME%>';
				
				var form = document.getElementById("wdesk");
				var elements = form.elements;
				for (var i = 0, len = elements.length; i < len; ++i) {
					if(elements[i].id!="Exception_History" && elements[i].id!="Decision_History" && elements[i].id!="ParentWI_Decision_History" && elements[i].id!="ParentWI_UID_History" ){
						elements[i].disabled = true;
						if(elements[i].type == "button"){
							elements[i].classList.remove("EWButtonRBSRM");
							elements[i].classList.add("EWButtonRBSRMRejectReason");
						}
					}
						//elements[i].disabled = true;
				}
				
				
			}
		}
		
		//Added to stop the window from refreshing for readOnly fields
		function stopFormRefreshing(e)
		{
			var kc = (e.charCode) ? e.charCode : ((e.which) ? e.which : e.keyCode);
			if(kc==8 )
			{           
				var ele = e.srcElement;
				if( ele == null )
					ele = e.target;

				if( ( ele.tagName != "INPUT" &&  ele.tagName != "TEXTAREA" ) || ele.readOnly || ele.getAttribute("disabled") == "disabled" )
					cancelBubble(e);

			}

		}

		function cancelBubble(e)
		{

			var evt = e ? e:window.event;
			if (evt.stopPropagation)
			{
				evt.stopPropagation();
				evt.preventDefault();
			}

			if (evt.cancelBubble!=null || evt.cancelBubble!=true)
			{
				evt.cancelBubble = true;
				evt.returnValue = false;
			}
		}
		function AddDealingWithCountries()	
		{
			var Val = document.getElementById('custdealingwithcountry_search').value;
				
			if (Val != '')
			{	
				var bItemAlreadyAdded=false;
				var select = document.getElementById('countryList');
				if(select.options==null)
					bItemAlreadyAdded=false;
				else
				{
					for(var i=0;i<select.options.length;i++)
					{
						if(select.options[i].value==Val)
						{
							alert("Country already selected.");
							bItemAlreadyAdded=true;
							break;
						}
					}
				}
				if(bItemAlreadyAdded)
				{	
					document.getElementById('custdealingwithcountry_search').value='';
					return false;
				}		
				if(!bItemAlreadyAdded)
				{										
					var opt = document.createElement('option');
					opt.value = Val;
					opt.innerHTML = Val;
					opt.length = Val.length;
					opt.className="EWNormalGreenGeneral1";
					select.appendChild(opt);
				}	
				document.getElementById('custdealingwithcountry_search').value='';							
				document.getElementById('wdesk:dealingWithCountries').value = document.getElementById('wdesk:dealingWithCountries').value + Val + "#";							
			}
			else
			{
				alert("Please Enter a Country");
			}	
		}

		function RemoveDealingWithCountries()
		{
			var select = document.getElementById('countryList');				
			if(select.options.length==0)
			{
				alert('No Country in the grid.');
				return;	
			}	
			var removed=false;
			for(i = select.options.length-1; i >=0; i--) {
				if (select.options[i].selected) {
					var existingCountryList = document.getElementById('wdesk:dealingWithCountries').value;
					document.getElementById('wdesk:dealingWithCountries').value = existingCountryList.split(select.options[i].value+"#").join(""); // replacing the characters
					select.remove(i);
					removed=true;
				}
			}
			if(!removed)
				alert('Select some Country(s) to remove.');
		}

		function AddProductIdentifier()	
		{
			var element=document.getElementById('ProductIdentifierdropdown');
			var a=0;
			if(element.selectedIndex == -1 && element.options.length >0 )
			{
				alert('Please Select a Product Identifier');
				return false;
			}
			for(var j=0;j<element.options.length;j++)
			{
				var finalist=document.getElementById('ProductIdentifierSeleceted');
				if(element.options[j].selected)
				{
					var name = element.options[j].text;
					var value = element.options[j].value;
					if(finalist.options.length!=0)
					{
						for(var i=0;i<finalist.options.length;i++)
						{
							//alert(finalist.options[i].value);
							if(finalist.options[i].value==value)
							{		
								alert(value+' Product is already there');
								a=1;
								break;
							}
						}
						if(a!=1)
						{
							var opt = document.createElement("option");
							opt.text = value;
							opt.value =value;
							finalist.options.add(opt);	
						}
						
					}
					else
					{
						var opt = document.createElement("option");
						opt.text = value;
						opt.value =value;
						finalist.options.add(opt);
					}
				}
			}
			enableTrancheDetails();
		}
		
		function AddTypeOfLA()	
		{
			var element=document.getElementById('TypeOfLAdropdown');
			var a=0;
			if(element.selectedIndex == -1 && element.options.length >0 )
			{
				alert('Please Select a Type of LA');
				return false;
			}
			for(var j=0;j<element.options.length;j++)
			{
				var finalist=document.getElementById('TypeOfLASeleceted');
				if(element.options[j].selected)
				{
					var name = element.options[j].text;
					var value = element.options[j].value;
					if(finalist.options.length!=0)
					{
						for(var i=0;i<finalist.options.length;i++)
						{
							//alert(finalist.options[i].value);
							if(finalist.options[i].value==value)
							{		
								alert(value+' Type of LA is already there');
								a=1;
								break;
							}
						}
						if(a!=1)
						{
							var opt = document.createElement("option");
							opt.text = value;
							opt.value =value;
							finalist.options.add(opt);	
						}
						
					}
					else
					{
						var opt = document.createElement("option");
						opt.text = value;
						opt.value =value;
						finalist.options.add(opt);
					}
				}
			}
		}
		
		function AddRequestType()	
		{
			var element=document.getElementById('RequestTypedropdown');
			var a=0;
			if(element.selectedIndex == -1 && element.options.length >0 )
			{
				alert('Please Select a Request Type');
				return false;
			}
			for(var j=0;j<element.options.length;j++)
			{
				var finalist=document.getElementById('RequestTypeSeleceted');
				if(element.options[j].selected)
				{
					var name = element.options[j].text;
					var value = element.options[j].value;
					if(finalist.options.length!=0)
					{
						for(var i=0;i<finalist.options.length;i++)
						{
							//alert(finalist.options[i].value);
							if(finalist.options[i].value==value)
							{		
								alert(value+' Request Type is already there');
								a=1;
								break;
							}
						}
						if(a!=1)
						{
							var opt = document.createElement("option");
							opt.text = value;
							opt.value =value;
							finalist.options.add(opt);	
						}
						
					}
					else
					{
						var opt = document.createElement("option");
						opt.text = value;
						opt.value =value;
						finalist.options.add(opt);
					}
				}
			}
		}

		function RemoveProductIdentifier()
		{
			var element=document.getElementById('ProductIdentifierSeleceted');

			if(element.options.length==0)
				alert('No Product Identifier to Remove');
			else if(element.selectedIndex==-1 && element.options.length!=0)
				alert('Select a Product Identifier to remove');
			else
			{
				var len=element.options.length;
				for(i=len-1;i>=0;i--)
				{
					if(element.options[i] != null && element.options[i].selected)
					{
						element.options[i]=null;
					}
				}
			}
			enableTrancheDetails();
		}
		
		function RemoveTypeOfLA()
		{
			var element=document.getElementById('TypeOfLASeleceted');

			if(element.options.length==0)
				alert('No Type of LA to Remove');
			else if(element.selectedIndex==-1 && element.options.length!=0)
				alert('Select a Type of LA to remove');
			else
			{
				var len=element.options.length;
				for(i=len-1;i>=0;i--)
				{
					if(element.options[i] != null && element.options[i].selected)
					{
						element.options[i]=null;
					}
				}
			}
		}
		
		function RemoveRequestType()
		{
			var element=document.getElementById('RequestTypeSeleceted');

			if(element.options.length==0)
				alert('No Request Type to Remove');
			else if(element.selectedIndex==-1 && element.options.length!=0)
				alert('Select a Request Type to remove');
			else
			{
				var len=element.options.length;
				for(i=len-1;i>=0;i--)
				{
					if(element.options[i] != null && element.options[i].selected)
					{
						element.options[i]=null;
					}
				}
			}
		}
		
		function NotifyAlert(value,workstepName)
		{
			if(workstepName=='Business_Approver_1st' || workstepName=='Business_Approver_2nd' || workstepName=='Sales_Hold' || workstepName=='Sales_Reject' || workstepName=='Sales_Validation' || workstepName=='CROPS_Finalization_Maker' || workstepName=='CROPS_Finalization_Checker' || workstepName=='CROPS_Hold')
			{
				confirm('Processing fee field has been modified, please take necessary approvals');
				return false;
			}
		}
		
	</script>
		
	<script>
		// below block added to apply tooltip on all static form field added on 07032018
		$(document).ready(function() {
			$("input:text,select,textarea").wrap("<div class='tooltip-wrapper' style='display:inline'></div>");
			$("div.tooltip-wrapper").mouseover(function() {
				$(this).attr('title', $(this).children().val());
			});
		});
	</script>
	
	<BODY onload="window.parent.checkIsFormLoaded();setFrameSize();getSOLIDOfLoggedInUser('<%=WSNAME%>','<%=user_name%>');loadDecisionFromMaster('<%=WSNAME%>');editablesecuritydropdown();loadDealingWithCountries();searchableNatureOfFacility();searchableInterestDesc();searchableCountry();loadGridValues('<%=WSNAME%>','<%=WINAME%>');loadROCodeFromMaster('<%=WSNAME%>','<%=strROCode%>');loadBusinessCreditApprover('<%=WSNAME%>','<%=strFirst_Level_Business_Approver%>','<%=strSecond_Level_Business_Approver%>','<%=strFirst_Level_Credit_Approver%>','<%=strSecond_Level_Credit_Approver%>');checkDuplicateWorkitemsOnLoadAtNextWorkstep();loadPriority('PRIORITY');loadChannelSubGroup('CHANNELSUBGROUP');loadTWCABF('TWCABF');loadDropDownValues();getExpiryDays();loadProductIdentifier('ProductIdentifierdropdown');selectedProductIdentifier();loadTypeOfLA('TypeOfLAdropdown');selectedTypeOfLA();loadRequestType('RequestTypedropdown');selectedRequestType();autoCalculateFields();enableDisable('<%=WSNAME%>');enableDisableUID('<%=WSNAME%>');getEntityDetailsCallAfterCifIdSaved('<%=WSNAME%>','load');DisableFieldinReadOnlyMode();loadPartnerCodeFromMaster('<%=WSNAME%>','wdesk:Partner_Code','loadPartnerCode','<%=strPartnerCode%>');" 
	onkeydown="stopFormRefreshing(event);" onkeypress="stopFormRefreshing(event);">
		<FORM name="wdesk" id="wdesk" >
			<div id="TWC" class='tooltip-wrapper' style="border-style: solid;border-width: thin;border-color: #990033;" >
				<table id = "TWC_Header" border='1' cellspacing='1' cellpadding='0' width=100% >
					<tr>
						<td align=center class='EWLabelRB2'>
							<font color="white" size="4">Trade Working Capital</font>
						</td>
					</tr>
					<tr>
						<td colspan =4 width=100% height=100% align=right valign=center>
							<img src='\TWC\webtop\images\bank-logo.gif'>
						</td>
					</tr>
				</table>
				<table border='1' id = "TWC_Grid" cellspacing='1' cellpadding='0' width=100% >
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							&nbsp;&nbsp;&nbsp;&nbsp;Logged In As
						</td>
						<td nowrap='nowrap' id = 'loggedinuser' class='EWNormalGreenGeneral1 NGReadOnlyView' height ='22' >
							&nbsp;<%=user_name%>
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							&nbsp;&nbsp;&nbsp;&nbsp;Workstep
						</td>
						<td nowrap='nowrap' id="Workstep" class='EWNormalGreenGeneral1 NGReadOnlyView' height ='22'>
							&nbsp;<%=WSNAME%>
						</td>
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;Workitem Name
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' height ='22'>
							&nbsp;<%=WINAME%>
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;SOL Id
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' id="loggedInUserComment" >
							&nbsp;
						</td>
					</tr>
					<!--Added on 18/02/2019-->
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;Initiator Code
						</td>
						
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
						<%if(WSNAME.equalsIgnoreCase("Sales_Data_Entry") || WSNAME.equalsIgnoreCase("DigiOnboard_Initial_Doc_review")){%>
						<select name='wdesk:RO_Code' id='wdesk:RO_Code' onkeyup="" style='width:155px'>
							<option value="">--Select--</option>
						</select>&nbsp;&nbsp;&nbsp;&nbsp;
						<%}else{%>
							<input type='text' name='wdesk:RO_Code' maxlength='10' id='wdesk:RO_Code' style="width:150px"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("RO_Code")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("RO_Code")).getAttribValue().toString()%>'/>
						<%}%>
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;Parent WI
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' height ='22' >
						<input type='text' name='wdesk:Parent_WI' maxlength='100' id='wdesk:Parent_WI' style="width:200px"  disabled value='<%=((CustomWorkdeskAttribute)attributeMap.get("Parent_WI")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Parent_WI")).getAttribValue().toString()%>'/>
						</td>
							<input type='hidden' name='wdesk:RM_Code' maxlength='10' id='wdesk:RM_Code' style="width:150px" value=''/>
					</tr>
					<!--Added on 18/02/2019-->
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;First Level Business Approver
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
						<%if(WSNAME.equalsIgnoreCase("Sales_Data_Entry") || WSNAME.equalsIgnoreCase("Business_Approver_1st") || WSNAME.equalsIgnoreCase("Business_Approver_2nd") || WSNAME.equalsIgnoreCase("DigiOnboard_Initial_Doc_review")){%>
						<select name='wdesk:First_Level_Business_Approver' id='wdesk:First_Level_Business_Approver' onkeyup="" style='width:155px'>
							<option value="">--Select--</option>
						</select>&nbsp;&nbsp;&nbsp;&nbsp;
						<%}else{%>
							<input type='text' name='wdesk:First_Level_Business_Approver' maxlength='10' id='wdesk:First_Level_Business_Approver' style="width:150px"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("First_Level_Business_Approver")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("First_Level_Business_Approver")).getAttribValue().toString()%>'/>
						<%}%>
						</td>
						
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;Second Level Business Approver
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
						<%if(WSNAME.equalsIgnoreCase("Sales_Data_Entry") || WSNAME.equalsIgnoreCase("Business_Approver_1st") || WSNAME.equalsIgnoreCase("Business_Approver_2nd") || WSNAME.equalsIgnoreCase("DigiOnboard_Initial_Doc_review")){%>
						<select name='wdesk:Second_Level_Business_Approver' id='wdesk:Second_Level_Business_Approver' onkeyup="" style='width:155px'>
							<option value="">--Select--</option>
						</select>&nbsp;&nbsp;&nbsp;&nbsp;
						<%}else{%>
							<input type='text' name='wdesk:Second_Level_Business_Approver' maxlength='10' id='wdesk:Second_Level_Business_Approver' style="width:150px"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Second_Level_Business_Approver")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Second_Level_Business_Approver")).getAttribValue().toString()%>'/>
						<%}%>
						</td>
						
					</tr>
					<!--Added on 22/02/2019-->
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;First Level Credit Approver
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
						<%if(WSNAME.equalsIgnoreCase("Credit_Analyst") || WSNAME.equalsIgnoreCase("Credit_Approver_1st") || WSNAME.equalsIgnoreCase("Credit_Approver_2nd")){%>
						<select name='wdesk:First_Level_Credit_Approver' id='wdesk:First_Level_Credit_Approver' onkeyup="" style='width:155px'>
							<option value="">--Select--</option>
						</select>&nbsp;&nbsp;&nbsp;&nbsp;
						<%}else{%>
							<input type='text' name='wdesk:First_Level_Credit_Approver' maxlength='10' id='wdesk:First_Level_Credit_Approver' style="width:150px"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("First_Level_Credit_Approver")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("First_Level_Credit_Approver")).getAttribValue().toString()%>'/>
						<%}%>
						</td>
						
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;Second Level Credit Approver

						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
						<%if(WSNAME.equalsIgnoreCase("Credit_Analyst") || WSNAME.equalsIgnoreCase("Credit_Approver_1st") || WSNAME.equalsIgnoreCase("Credit_Approver_2nd")){%>
						<select name='wdesk:Second_Level_Credit_Approver' id='wdesk:Second_Level_Credit_Approver' onkeyup="" style='width:155px'>
							<option value="">--Select--</option>
						</select>&nbsp;&nbsp;&nbsp;&nbsp;
						<%}else{%>
							<input type='text' name='wdesk:Second_Level_Credit_Approver' maxlength='10' id='wdesk:Second_Level_Credit_Approver' style="width:150px"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Second_Level_Credit_Approver")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Second_Level_Credit_Approver")).getAttribValue().toString()%>'/>
						<%}%>
						</td>
						
					</tr>
					<!--Added on 18/02/2019-->
					
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;Final Credit Approver Authority
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							<input type='text' disabled name='wdesk:FinalCreditApproverAuth' maxlength='100' style="width:150px" id='wdesk:FinalCreditApproverAuth' onBlur='ValidateAlphaNumeric("wdesk:FinalCreditApproverAuth")' value='<%=((CustomWorkdeskAttribute)attributeMap.get("FinalCreditApproverAuth")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("FinalCreditApproverAuth")).getAttribValue().toString()%>'/>
							
						</td>
						<!--<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' ></td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' ></td>-->
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;Source of Parent WI
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' height ='22' >
						<input type='text' name='wdesk:Source_Parent_WI' maxlength='100' id='wdesk:Source_Parent_WI' style="width:175px"  disabled value='<%=((CustomWorkdeskAttribute)attributeMap.get("Source_Parent_WI")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Source_Parent_WI")).getAttribValue().toString()%>'/>
						</td>
					</tr>
					
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;CBRB Required?
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							<select  class="NGReadOnlyView" name='CBRB_Required' id='CBRB_Required' onchange="setComboValueToTextBox(this,'wdesk:CBRB_Required');" style="width:150px">
								<option value="">--Select--</option>
								<option value="Yes">Yes</option>
								<option value="No">No</option>
							</select>
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;AECB Required?
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							<select  class="NGReadOnlyView"  name='AECB_Required' id='AECB_Required' onchange="setComboValueToTextBox(this,'wdesk:AECB_Required'); " style="width:150px">
								<option value="">--Select--</option>
								<option value="Yes">Yes</option>
								<option value="No">No</option>
							</select>
						</td>
					</tr>
					
					<!--Modified By Sajan 17-03-2019-->
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style="width:25%" >
							&nbsp;&nbsp;&nbsp;&nbsp;Product Identifier
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<select id='ProductIdentifierdropdown'  name='ProductIdentifierdropdown' multiple='multiple' style="width:150px">
							</select>

						</td>
						<td  nowrap='nowrap' height ='22' width = 25% class='EWNormalGreenGeneral1' valign="middle"> 
							<input type="button" id="addButtonProduct" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onclick="AddProductIdentifier();" 
								value="Add >>"><br />
							<input type="button" id="removeButtonProduct" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onClick="RemoveProductIdentifier();"
								value="<< Remove">
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<select id='ProductIdentifierSeleceted'  name='ProductIdentifierSeleceted' multiple='multiple' style="width:150px">
							</select>

						</td>
					</tr>
					
					<!-- Start - Added for CR Tracker Point 130 -->
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style="width:25%" >
							&nbsp;&nbsp;&nbsp;&nbsp;Type of LA
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<select id='TypeOfLAdropdown'  name='TypeOfLAdropdown' multiple='multiple' style="width:150px">
							</select>

						</td>
						<td  nowrap='nowrap' height ='22' width = 25% class='EWNormalGreenGeneral1' valign="middle"> 
							<input type="button" id="addButtonTypeOfLA" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onclick="AddTypeOfLA();" 
								value="Add >>"><br />
							<input type="button" id="removeButtonTypeOfLA" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onClick="RemoveTypeOfLA();"
								value="<< Remove">
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<select id='TypeOfLASeleceted'  name='TypeOfLASeleceted' multiple='multiple' style="width:150px">
							</select>

						</td>
					</tr>
					
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style="width:25%" >
							&nbsp;&nbsp;&nbsp;&nbsp;Request Type
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<select id='RequestTypedropdown'  name='RequestTypedropdown' multiple='multiple' style="width:150px">
							</select>

						</td>
						<td  nowrap='nowrap' height ='22' width = 25% class='EWNormalGreenGeneral1' valign="middle"> 
							<input type="button" id="addButtonRequestType" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onclick="AddRequestType();" 
								value="Add >>"><br />
							<input type="button" id="removeButtonRequestType" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onClick="RemoveRequestType();"
								value="<< Remove">
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<select id='RequestTypeSeleceted'  name='RequestTypeSeleceted' multiple='multiple' style="width:150px">
							</select>

						</td>
					</tr>
					<!-- End - Added for CR Tracker Point 130 -->
					
					<!--Changes end here-->
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;CIF Id
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							<input type='text' name='wdesk:CIF_Id' maxlength='7'  style="width:150px" id='wdesk:CIF_Id' value='<%=((CustomWorkdeskAttribute)attributeMap.get("CIF_Id")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CIF_Id")).getAttribValue().toString()%>' onKeyUp='ValidateNumeric("wdesk:CIF_Id");' onChange='onChangeCIFID();' onBlur='validateCIFID();'/>
							
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;RAK Track Number
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							<input type='text' maxlength='25' name='wdesk:RAK_Track_Number' style="width:150px" id='wdesk:RAK_Track_Number' value='<%=((CustomWorkdeskAttribute)attributeMap.get("RAK_Track_Number")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("RAK_Track_Number")).getAttribValue().toString()%>' onKeyup='ValidateAlphaNumeric("wdesk:RAK_Track_Number")'/>
						</td>
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
						</td>
						
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='30' width = 25%>
							<input type = 'button' class='EWButtonRBSRM' id = 'CIF_Id_populate' style="width:150px" value='Populate' style=' width:150px;height: 90%', onclick="getEntityDetailsCallAfterCifIdSaved('<%=WINAME%>',click);">
						
							
						</td>
						
						
					
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;Islamic/Conventional
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							<select  class="NGReadOnlyView" name='IslamicOrConventional' id='IslamicOrConventional' onchange="setComboValueToTextBox(this,'wdesk:Islamic_Or_Conventional');" style="width:150px">
								<option value="">--Select--</option>
								<option value="Islamic">Islamic</option>
								<option value="Conventional">Conventional</option>
							</select>
						</td>
						
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;Customer Name
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<input type='text' name='wdesk:Customer_Name' maxlength='100'  style="width:150px" id='wdesk:Customer_Name' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Customer_Name")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Customer_Name")).getAttribValue().toString()%>'/>
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;LAF Reference Number
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<input type='text'  maxlength='30' name='wdesk:Reference_Number' style="width:150px" id='wdesk:Reference_Number' onkeyup="SpecificFieldAndSpecialChar('wdesk:Reference_Number');" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Reference_Number")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Reference_Number")).getAttribValue().toString()%>'/>
						</td>
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;Address Line 1
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<input type='text'  name='wdesk:Address_Line_1' id='wdesk:Address_Line_1' style="width:150px" maxlength='100' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Address_Line_1")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Address_Line_1")).getAttribValue().toString()%>'/>
						</td>
						
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;Trade License Number
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<input type='text' maxlength='15' name='wdesk:TL_Number' id='wdesk:TL_Number' style="width:150px" onkeyup="SpecificFieldAndSpecialChar('wdesk:TL_Number');" value='<%=((CustomWorkdeskAttribute)attributeMap.get("TL_Number")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("TL_Number")).getAttribValue().toString()%>' maxlength='15' onkeyup='ValidateAlphaNumeric("wdesk:TL_Number");'/>
						</td>
						
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>	
							&nbsp;&nbsp;&nbsp;&nbsp;Address Line 2
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<input type='text' name='wdesk:Address_Line_2' id='wdesk:Address_Line_2' style="width:150px" maxlength='100' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Address_Line_2")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Address_Line_2")).getAttribValue().toString()%>'/>
						</td>
						
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;Mobile Number
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<input type='text' name='wdesk:Mobile_Code' id='wdesk:Mobile_Code' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Mobile_Code")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Mobile_Code")).getAttribValue().toString()%>' maxlength='15' style="width:40px"/>-<input type='text' name='wdesk:Mobile_Number' id='wdesk:Mobile_Number' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Mobile_Number")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Mobile_Number")).getAttribValue().toString()%>' maxlength='15' style="width:100px"/>
						</td>
						<tr>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
								&nbsp;&nbsp;&nbsp;&nbsp;Address Line 3
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
								<input type='text' name='wdesk:Address_Line_3' id='wdesk:Address_Line_3' style="width:150px" maxlength='100' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Address_Line_3")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Address_Line_3")).getAttribValue().toString()%>' />
							</td>
							
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
								&nbsp;&nbsp;&nbsp;&nbsp;Landline
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
								<input type='text' name='wdesk:Landline_code' id='wdesk:Landline_code' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Landline_code")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Landline_code")).getAttribValue().toString()%>' maxlength='15' style="width:40px"/>-<input type='text' name='wdesk:Landline_Number' id='wdesk:Landline_Number' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Landline_Number")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Landline_Number")).getAttribValue().toString()%>' maxlength='15' style="width:100px"/>
							</td>
						</tr>
					<tr>	
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>	
							&nbsp;&nbsp;&nbsp;&nbsp;Address Line 4
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<input type='text' name='wdesk:Address_Line_4' id='wdesk:Address_Line_4'  style="width:150px" maxlength='100' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Address_Line_4")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Address_Line_4")).getAttribValue().toString()%>'/>
						</td>
						
						<!--Added on 21/02/2019 -->
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;Email ID
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<input type='text' name='wdesk:Email_ID' id='wdesk:Email_ID' maxlength='24'  style="width:150px" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Email_ID")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Email_ID")).getAttribValue().toString()%>'/>
						</td>
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;Emirate
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25% >
							<input type='text' name='wdesk:Emirate' id='wdesk:Emirate' maxlength='100' style="width:150px" maxlength='100' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Emirate")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Emirate")).getAttribValue().toString()%>'/>
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;Master Facility Limit
						</td>
						<!--Modified on 27/03/2019. autoCalculateCleanExposure() called.-->
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<input type='text' name='wdesk:Master_Facility_Limit' style="width:150px" id='wdesk:Master_Facility_Limit' maxlength='23' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Master_Facility_Limit")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Master_Facility_Limit")).getAttribValue().toString()%>' onkeyup='ValidateNumeric("wdesk:Master_Facility_Limit");validateLengthForAmount("wdesk:Master_Facility_Limit","15")' onBlur='onBlurForAmount("wdesk:Master_Facility_Limit");autoCalculateCleanExposure();' />
							
							
						</td>
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;POBox
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<input type='text' name='wdesk:PO_Box' id='wdesk:PO_Box' maxlength='100' style="width:150px" value='<%=((CustomWorkdeskAttribute)attributeMap.get("PO_Box")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PO_Box")).getAttribValue().toString()%>' />
						</td>
						<!--Commented on 27/03/2019 as Limit Amount field has been removed from the form -->
						<!--
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;Limit Amount
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 22%>
							<input type='text' name='wdesk:Limit_Amount' id='wdesk:Limit_Amount' style="width:150px" maxlength='24' value='<//%=((CustomWorkdeskAttribute)attributeMap.get("Limit_Amount")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Limit_Amount")).getAttribValue().toString()%>' onkeyup='ValidateNumeric("wdesk:Limit_Amount"); validateLengthForAmount("wdesk:Limit_Amount","15")' onblur='onBlurForAmount("wdesk:Limit_Amount");' />
						</td>
						-->
						<!--Added 27/03/2019 as new field Clean Exposure has been added-->
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;Clean Exposure
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 22%>
							<input type='text' name='wdesk:Clean_Exposure' id='wdesk:Clean_Exposure' style="width:150px"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Clean_Exposure")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Clean_Exposure")).getAttribValue().toString()%>' readonly />
						</td>
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;Country
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<input type='text' name='wdesk:Country' id='wdesk:Country' maxlength='100' style="width:150px" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Country")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Country")).getAttribValue().toString()%>'/>
						</td>
						
						
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;Related Party Name</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<textarea maxlength="5000" class='EWNormalGreenGeneral1'  style="width:150px" name='wdesk:Related_Part_Name' id="wdesk:Related_Part_Name" onKeyup='SpecificFieldAndSpecialChar("wdesk:Related_Part_Name")' style="width:150px"><%=((CustomWorkdeskAttribute)attributeMap.get("Related_Part_Name")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Related_Part_Name")).getAttribValue().toString()%></textarea>

						</td>
						
					</tr>
					<tr>
						
						<!--Added on 21/02/2019 -->
						
						
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style="width:50" >
							&nbsp;&nbsp;&nbsp;&nbsp;Non-refundable Processing Fee<br>&nbsp;&nbsp;&nbsp;&nbsp;(AED, including VAT)
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<input type='text' name='wdesk:Non_Refundable_ProcessingFee' id='wdesk:Non_Refundable_ProcessingFee' maxlength='24' style="width:150px" onchange='NotifyAlert(this.value,"<%=WSNAME%>");' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Non_Refundable_ProcessingFee")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Non_Refundable_ProcessingFee")).getAttribValue().toString()%>' onkeyup='ValidateNumeric("wdesk:Non_Refundable_ProcessingFee"); validateLengthForAmount("wdesk:Non_Refundable_ProcessingFee","15")' onblur='onBlurForAmount("wdesk:Non_Refundable_ProcessingFee");' />
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;Account to be debited<br>&nbsp;&nbsp;&nbsp;&nbsp; for Fee
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25% >
							<input type='text' name='wdesk:FeeDebitedAccount' maxlength='13' id='wdesk:FeeDebitedAccount' onblur='validateFieldLength("wdesk:FeeDebitedAccount");' style="width:150px" value='<%=((CustomWorkdeskAttribute)attributeMap.get("FeeDebitedAccount")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("FeeDebitedAccount")).getAttribValue().toString()%>'/>
						</td>
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style="width:50" >
							&nbsp;&nbsp;&nbsp;&nbsp;Total PF of Parent WI
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' height ='22' width = 25%>
							<input type='text' name='wdesk:Total_PF_ParentWI' id='wdesk:Total_PF_ParentWI' maxlength='24' style="width:150px" disabled value='<%=((CustomWorkdeskAttribute)attributeMap.get("Total_PF_ParentWI")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Total_PF_ParentWI")).getAttribValue().toString()%>' />
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%></td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25% ></td>
					</tr>
					<!--Added on 21/02/2019-->
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;MRA Archival Date
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25% >
							<input type='text' style="vertical-align:middle" name='wdesk:MRA_Archival_Date' style="width:150px" id='wdesk:MRA_Archival_Date' value='<%=((CustomWorkdeskAttribute)attributeMap.get("MRA_Archival_Date")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MRA_Archival_Date")).getAttribValue().toString()%>' onBlur="validateDate(this.value,'wdesk:MRA_Archival_Date');"/>
							&nbsp;<img src='/TWC/webtop/images/cal.gif' id='MRA_calendar' style='width:10%;height:90%' border='0' alt='' onclick="initialize('wdesk:MRA_Archival_Date');" />
						</td>
						
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;Review Date
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25% >
							<input type='text' style="vertical-align:middle" name='wdesk:Review_Date' style="width:150px" id='wdesk:Review_Date' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Review_Date")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Review_Date")).getAttribValue().toString()%>' onBlur="validateDate(this.value,'wdesk:Review_Date');"/>
							&nbsp;<img src='/TWC/webtop/images/cal.gif' id='Review_calendar' style='width:10%;height:90%' border='0' alt='' onclick="initialize('wdesk:Review_Date');" />
						</td>
						
					</tr>
					
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Dealing with Country</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
						<input type="text" class='NGReadOnlyView' style='width:170px' maxlength='100' id="custdealingwithcountry_search" onblur = "validatecountry('custdealingwithcountry_search',document.getElementById('AutocompleteValuesCountry').value);" onkeyup =  "ValidateAlphabetAndSpecialChar('custdealingwithcountry_search');" name='custdealingwithcountry_search' value='' >
						</td>
						<!--Start-- Changed to make country dealing with multiselect -->
						<td  nowrap='nowrap' height ='22' width = 26% class='EWNormalGreenGeneral1' valign="middle"> 
							<input type="button" id="addButton" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onclick="AddDealingWithCountries();" 
								value="Add >>"><br />
							<input type="button" id="removeButton" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onClick="RemoveDealingWithCountries();"
								value="<< Remove">
						</td>
						<td  nowrap='nowrap' height ='22' width = 26% class='EWNormalGreenGeneral1'>
							<p>List of Countries</p>
							<div class="scrollable">
							<select multiple="multiple" style="width:80%;" id="countryList" size='4'></select>
							</div>
							<br />
						</td>
				</tr>
				
					
					<!--Added on 21/02/2019-->
					<tr>
					
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;Notes
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 22%>
							<textarea maxlength="1000" class='EWNormalGreenGeneral1' name='wdesk:Notes' id="wdesk:Notes" style="width:200px;white-space:pre-wrap; align:center;" rows="3" ><%=((CustomWorkdeskAttribute)attributeMap.get("Notes")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Notes")).getAttribValue().toString()%></textarea>
						</td>
						
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25% >
							<input type = 'button' id = 'bt_template' disabled style="width:150px;display:block;margin:auto" value='Template' class='EWButtonRBSRMRejectReason' style='width:150px' onclick='generate_template("<%=WINAME%>");'/>
							<input type = 'button' id = 'bt_Excel_template' disabled style="width:150px;display:block;margin:auto" value='Print' class='EWButtonRBSRMRejectReason' style='width:150px' onclick='generate_excel_template("<%=WINAME%>");'/>						
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25% >
						<input type="button" id="btnViewSign" name="btnViewSign" value="View Signature" disabled onclick="openCustomDialog('View Signature','<%=WSNAME%>');" class='EWButtonRBSRMRejectReason' style='width:150px'>
						</td>
						
					</tr>	
					
					<!--Added on 17/06/2021-->
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;Channel
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							<input type='text' name='wdesk:CHANNEL' maxlength='7'  style="width:150px" id='wdesk:CHANNEL' value='<%=((CustomWorkdeskAttribute)attributeMap.get("CHANNEL")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CHANNEL")).getAttribValue().toString()%>'/>
						</td>
						
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;Channel Sub-group
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							<select  class="NGReadOnlyView" style='width: 150px;' name="CHANNELSUBGROUP" id="CHANNELSUBGROUP" onchange="setComboValueToTextBox(this,'wdesk:CHANNELSUBGROUP');" >
								<option value="">--Select--</option>
							</select>
						</td>
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;Priority
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							<select  class="NGReadOnlyView" style='width: 150px;' name="PRIORITY" id="PRIORITY" onchange="setComboValueToTextBox(this,'wdesk:PRIORITY');" >
							<option value="">--Select--</option>
							</select>&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
						
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;TWC/ABF
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							<select  class="NGReadOnlyView" style='width: 150px;' name="TWCABF" id="TWCABF" onchange="setComboValueToTextBox(this,'wdesk:TWCABF');" >
								<option value="">--Select--</option>
							</select>
						</td>
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;Document List
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							<textarea maxlength="1000" class='EWNormalGreenGeneral1' name='wdesk:DOCUMENTLIST' id="wdesk:DOCUMENTLIST" style="width:200px;white-space:pre-wrap; align:center;" rows="5" ><%=((CustomWorkdeskAttribute)attributeMap.get("DOCUMENTLIST")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("DOCUMENTLIST")).getAttribValue().toString()%></textarea>
							
						</td>
						
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;Document List (Not Received)
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							<textarea maxlength="1000" class='EWNormalGreenGeneral1' name='wdesk:DOCLISTFORVALIDATION' id="wdesk:DOCLISTFORVALIDATION" style="width:200px;white-space:pre-wrap; align:center;" rows="5" ><%=((CustomWorkdeskAttribute)attributeMap.get("DOCLISTFORVALIDATION")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("DOCLISTFORVALIDATION")).getAttribValue().toString()%></textarea>
							
						</td>
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							&nbsp;&nbsp;&nbsp;&nbsp;BAIS WI Number
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							<input type='text' name='wdesk:BAISWINUMBER' maxlength='7'  style="width:150px" id='wdesk:BAISWINUMBER' value='<%=((CustomWorkdeskAttribute)attributeMap.get("BAISWINUMBER")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("BAISWINUMBER")).getAttribValue().toString()%>'/>
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' ></td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' ></td>
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style="width:50" >
							&nbsp;&nbsp;&nbsp;&nbsp;Campaign ID
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							<input type='text' name='wdesk:Campaign_ID' id='wdesk:Campaign_ID' maxlength='50' style="width:150px" onkeyup="SpecificFieldAndSpecialChar('wdesk:Campaign_ID');" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Campaign_ID")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Campaign_ID")).getAttribValue().toString()%>' />
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Partner Code</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25% >
							<select  class="NGReadOnlyView" style='width: 150px;' maxlength='200' name="wdesk:Partner_Code" id="wdesk:Partner_Code" onchange="setComboValueToTextBox(this,'wdesk:Partner_Code');" >
								<option value="">--Select--</option>
							</select>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					</tr>
				</table>
			</div>
			
			<!--*********Facility Details*****************-->
			<div class='tooltip-wrapper' id="Facility_Details"  style="border-style: solid;border-width: thin;border-color: #990033;">
				<table id="Facility_Details_Header" border='1' cellspacing='1' cellpadding='0' width=100%>
					<tr class='EWLabelRB2' bgcolor= "#990033">
						<td align='center' class='EWLabelRB2'>
							<font color="white" size="4">Facility Details</font>
						</td>
					</tr>
					<tr>
						<td>
							<input type = 'button' id = 'add_row_Facility_Details' value='Add Facility Details' class='EWButtonRBSRM' style='width:150px' onclick='addrow("<%=WSNAME%>",this.id,"")' />
						</td>
					</tr>
				</table>
				<div style="overflow:scroll;height:250px;border-style: solid;border-width: thin;border-color:#990033;width:100% !important;">
					<table border='1' cellspacing='1' cellpadding='1' id ='Facility_Details_Grid' style='width:100% !important; solid #000000;border-collapse:collapse;'>
						<thead>
						<tr bgcolor= "#990033">
							<td class='EWNormalGreenGeneral1' nowrap style="padding:2px;width:2%;text-align:center;position: sticky; top: -1px;">
								<font color="white">Facility<br/>(Existing)</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:3%;text-align:center;position: sticky; top: -1px;">
								<font color="white">Facility<br/>(Sought)</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:2%;text-align:center;position: sticky; top: -1px;">
								<font color="white">No.</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:4%;text-align:center;position: sticky; top: -1px;">
								<font color="white">Usage</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:6%;text-align:center;position: sticky; top: -1px;">
								<font color="white">Nature of Facility</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:6%;text-align:center;position: sticky; top: -1px;">
								<font color="white">Purpose</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:6%;text-align:center;position: sticky; top: -1px;">
								<font color="white">Tenor Value</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:6%;text-align:center;position: sticky; top: -1px;"> 
								<font color="white">Tenor<br/>Frequency</font>
							</td>
							<!--Modified on 26/03/2019-->
							<!--Only Label Name changed from Margin% to Cash Margin %. Variable and DB Column 
							as it is-->
							<td class='EWNormalGreenGeneral1' nowrap style="width:6%;text-align:center;position: sticky; top: -1px;">
								<font color="white">&nbsp;Cash<br/>Margin %</font>
							</td>
							
							<td class='EWNormalGreenGeneral1' nowrap style="width:3%;text-align:center;position: sticky; top: -1px;">
								<font color="white">Interest Type</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:6%;text-align:center;position: sticky; top: -1px;"> 
								<font color="white">Interest Description</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:5%;text-align:center;position: sticky; top: -1px;"> 
								<font color="white">Interest Margin<br/>(+)Above /<br/>(-)Below</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:6%;text-align:center;position: sticky; top: -1px;">
								<font color="white"> &nbsp;Is Interest<br/>&nbsp;Rate below<br/>&nbsp;Standard Grid</font>
							</td>
							<!--Modified on 26/03/2019-->
							<!--Only Label Name changed from Cash Margin to Interest Margin %. Variable and DB Column 
							as it is-->
							<td class='EWNormalGreenGeneral1' nowrap style="width:6%;text-align:center;position: sticky; top: -1px;">
								<font color="white">Commission</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:20%;text-align:center;position: sticky; top: -1px;">
								<font color="white">&nbsp;Product Level/ Structure <br/>&nbsp;Level Conditions</font>
								</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:6%;text-align:center;position: sticky; top: -1px;">
								<font color="white">Remarks</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:4%;text-align:center;position: sticky; top: -1px;">
								<font color="white">Delete</font>
							</td>
						</tr>
						</thead>
					</table>
				</div>
				<table border='1'cellspacing='1' cellpadding='1' width=100% id ='Facility_Details_Grid2'>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							&nbsp;&nbsp;&nbsp;&nbsp;Total Facility Existing
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							<input type='text' name='wdesk:Total_Facility_Existing' id='wdesk:Total_Facility_Existing' maxlength='15' readonly />
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >	
							&nbsp;&nbsp;&nbsp;&nbsp;Total Facility Sought
						</td>
						<td colspan='12' nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							<input type='text' name='wdesk:Total_Facility_Sought' id='wdesk:Total_Facility_Sought' maxlength='15' readonly />
						</td>
					</tr>
				</table>
				<table>
					<tr>
						<td>
							<input type = 'button' id = 'add_row_General_Condition' value='Add General Condition' class='EWButtonRBSRM' style='width:150px' onclick='addrow("<%=WSNAME%>",this.id,"")'/>
						</td>
					</tr>
				</table>
				<div style="overflow:scroll;height:150px;border-style: solid;border-width: thin;border-color:#990033;">
					<table border='1'cellspacing='1' cellpadding='0' width=100% id ='General_Condition_Grid'>
						
						<tr bgcolor= "#990033" >
							<td class='EWNormalGreenGeneral1' style='width:90%;padding:2px;'>
								<font color="white">General Conditions</font>
							</td>
							<td class='EWNormalGreenGeneral1' style='width:10%'>
								<font color="white">Delete</font>
							</td>
						</tr>
					</table>
				</div>
			</div>
			
			<!--*********Security Document Details*****************-->
			<div class='tooltip-wrapper' id="Security_Document_Details" style="border-style: solid;border-width: thin;border-color: #990033;">
				<table border='1'cellspacing='1' cellpadding='0' width=100% id ='Security_Document_Details_Header'>
					<tr width='100%' class='EWLabelRB2' bgcolor= "#990033">
						<td colspan='10' align='center' class='EWLabelRB2'>
							<font color="white" size="4">Security Document Details</font>
						</td>
					</tr>
					<tr>
						<td colspan='10'>
							<input type = 'button' id = 'add_row_Security_Document_Details' value='Add Security Documents' class='EWButtonRBSRM' style='width:150px' onclick='addrow("<%=WSNAME%>",this.id,"")'/>
						</td>
					</tr>
				</table>
				<div style="overflow:scroll;height:300px;border-style: solid;border-width: thin;border-color:#990033; width:100% !important;">
					<table border='1'cellspacing='1' cellpadding='0' width=100% id ='Security_Document_Details_Grid'>
						<tr bgcolor= "#990033">
							<td class='EWNormalGreenGeneral1' nowrap style="padding:2px;width:12%;text-align:center;">
								<font color="white">Security Document<br/> Type</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:12%;text-align:center;">
								<font color="white">Security Document<br/>Description</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:12%;text-align:center;">
								<font color="white">T/I</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:12%;text-align:center;">
								<font color="white">Value</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:12%;text-align:center;">
								<font color="white">FSV</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:12%;text-align:center;">
								<font color="white">Limit Covered</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:12%;text-align:center;">
								<font color="white">Held</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:12%;text-align:center;">
								<font color="white">Conditions</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style="width:4%;text-align:center;">
								<font color="white">Delete</font>
							</td>
						</tr>
					</table>
				</div>
				
				<table border='1'cellspacing='1' cellpadding='0 id ='Security_Document_Details_Grid2' width='100%'>
					<!--Two new columns added on 27/03/2019 -->
					<!--Start-->
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >	
							&nbsp;&nbsp;&nbsp;&nbsp;Sum of Value
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							<input type='text' disabled name='wdesk:Sum_Value' id='wdesk:Sum_Value' maxlength='15' onblur='onBlurForAmount("wdesk:Sum_Value");' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Sum_Value")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Sum_Value")).getAttribValue().toString()%>' />
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							&nbsp;&nbsp;&nbsp;&nbsp;Sum of FSV
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							<input type='text' disabled name='wdesk:Sum_FSV' id='wdesk:Sum_FSV' maxlength='15' onblur='onBlurForAmount("wdesk:Sum_FSV");autoCalculateCleanExposure();' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Sum_FSV")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Sum_FSV")).getAttribValue().toString()%>' />
						</td>
					</tr>
					<!--End -->
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							&nbsp;&nbsp;&nbsp;&nbsp;Pattern of Funding
						</td>
						<!--Modified on 27/03/2019. Colspan attribute added -->
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' colspan='4'>
							<textarea maxlength="1000" class='EWNormalGreenGeneral1' style="width:420px;" name='wdesk:Pattern_of_Funding' id="wdesk:Pattern_of_Funding"><%=((CustomWorkdeskAttribute)attributeMap.get("Pattern_of_Funding")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Pattern_of_Funding")).getAttribValue().toString().trim()%></textarea>
						</td>
					</tr>
					<!--Two new columns added on 27/03/2019 -->
					<!--Start-->
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							&nbsp;&nbsp;&nbsp;&nbsp;Dispensation Sought
						</td>
						
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' colspan='4' >
							<textarea maxlength="3000" class='EWNormalGreenGeneral1' style="width:420px;" name='wdesk:dispensationSought' id="wdesk:dispensationSought"><%=((CustomWorkdeskAttribute)attributeMap.get("dispensationSought")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("dispensationSought")).getAttribValue().toString().trim()%></textarea>
						</td>
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							&nbsp;&nbsp;&nbsp;&nbsp;Dispensation Held
						</td>
						
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'  colspan='4'>
							<textarea maxlength="3000" class='EWNormalGreenGeneral1' style="width:420px;" name='wdesk:dispensationHeld' id="wdesk:dispensationHeld"><%=((CustomWorkdeskAttribute)attributeMap.get("dispensationHeld")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("dispensationHeld")).getAttribValue().toString().trim()%></textarea>
						</td>
					</tr>
					<!--End-->
				</table>
				<table>
					<tr width='100%' class='EWLabelRB2'>
						<td>
							<input type = 'button' id = 'add_row_Special_Covenants_Internal' value='Add' class='EWButtonRBSRM' style='width:150px' onclick='addrow("<%=WSNAME%>",this.id,"")'/>
						</td>
					</tr>
				</table>
				<div style="overflow:scroll;height:150px;border-style: solid;border-width: thin;border-color:#990033;">
					<table border='1'cellspacing='1' cellpadding='0' width=100% id ='Special_Covenants_Internal_Grid'>
						<tr bgcolor= "#990033" >
							<td class='EWNormalGreenGeneral1' style='width:90%;padding:2px;'>
								<font color="white">Special Covenants/ Conditions Internal- Proposed Limits</font>
							</td>
							<td class='EWNormalGreenGeneral1' style='width:10%'>
								<font color="white">Delete</font>
							</td>
						</tr>
					</table>
				</div>	
				<table>
					<tr>
						<td colspan='15'>
							<input type = 'button' id = 'add_row_Special_Covenants_External' value='Add' class='EWButtonRBSRM' style='width:150px' onclick='addrow("<%=WSNAME%>",this.id,"")'/>
						</td>
					</tr>
				</table>
				<div style="overflow:scroll;height:150px;border-style: solid;border-width: thin;border-color:#990033;">
					<table border='1'cellspacing='1' cellpadding='0' width=100% id ='Special_Covenants_External_Grid'>
						
						<tr bgcolor= "#990033" >
							<td class='EWNormalGreenGeneral1' height ='22'style='width:90%;padding:2px;'>
								<font color="white">Special Covenants/ Conditions External- Proposed Limits</font>
							</td>
							<td class='EWNormalGreenGeneral1' height ='22'style='width:10%'>
								<font color="white">Delete</font>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<!--*********Defferal Details*****************-->
			<div  class='tooltip-wrapper' id="Defferal_Details" style="border-style: solid;border-width: thin;border-color: #990033;">
				<table border='1'cellspacing='1' cellpadding='0' width=100% id ='Defferal_Details_Header'>
					<tr width='100%' class='EWLabelRB2' bgcolor= "#990033">
						<td colspan='5' align='center' class='EWLabelRB2'>
							<font color="white" size="4">Deferral Details</font>
						</td>
					</tr>
					<tr>
						<td colspan='5'>
							<input type = 'button' id = 'add_row_Defferal_Details' value='Add Deferrals' class='EWButtonRBSRM' style='width:150px' onclick='addrow("<%=WSNAME%>",this.id,"")'/>
						</td>
					</tr>
				</table>
				<div style="overflow:scroll;height:150px;border-style: solid;border-width: thin;border-color:#990033;">
					<table border='1'cellspacing='1' cellpadding='0' width=100% id ='Defferal_Details_Grid'>
						<tr bgcolor= "#990033">
							<td class='EWNormalGreenGeneral1' nowrap style='width:5%;text-align:center;padding:2px;'>
								<font color="white">S.No.</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style='width:20%;text-align:center;'>
								<font color="white">Document Type</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style='width:20%;text-align:center;'>
								<font color="white">Approving Authority(Name)</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style='width:20%;text-align:center;'>
								<font color="white">Deferral Expiry Date</font>
							</td>
							<!--New Field Added by Sajan 17032019-->
							<td class='EWNormalGreenGeneral1' nowrap style='width:30%;text-align:center;'>
								<font color="white">Remarks</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap>
								<font color="white">Delete</font>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<!--New Grid Added on 20/02/2019-->
			<!--*********Tranche Details*****************-->
			<div  class='tooltip-wrapper' id="Tranche_Details" style="border-style: solid;border-width: thin;border-color: #990033;">
				<table border='1'cellspacing='1' cellpadding='0' width=100% id ='Tranche_Details_Header'>
					<tr width='100%' class='EWLabelRB2' bgcolor= "#990033">
						<td colspan='4' align='center' class='EWLabelRB2'>
							<font color="white" size="4">Tranche Details</font>
						</td>
					</tr>
					<tr>
						<td colspan='4'>
							<input type = 'button' disabled id = 'add_row_Tranche_Details' value='Add' class='EWButtonRBSRMRejectReason' style='width:150px' onclick='addrow("<%=WSNAME%>",this.id,"")'/>
						</td>
					</tr>
				</table>
				<!-- Grid Modified on 03/04/2019-->
				<div style="overflow:scroll;height:150px;border-style: solid;border-width: thin;border-color:#990033;">
					<table border='1'cellspacing='1' cellpadding='0' width=100% id ='Tranche_Details_Grid'>
						<tr bgcolor= "#990033">
							<td class='EWNormalGreenGeneral1' nowrap style='width:5%;text-align:center;padding:2px;'>
								<font color="white">S.No.</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style='width:12%;text-align:center;'>
								<font color="white">Tranche Amount</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style='width:12%;text-align:center;'>
								<font color="white">Status</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style='width:15%;text-align:center;'>
								<font color="white">Available Period</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style='width:15%;text-align:center;'>
								<font color="white">Disbursal Date</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style='width:20%;text-align:center;'>
								<font color="white">Remarks</font>
							</td>
							<td class='EWNormalGreenGeneral1' nowrap style='width:9%;text-align:center;'>
								<font color="white">Delete</font>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<!--*********Duplicate WorkItems Grid*****************-->
			<div class='tooltip-wrapper' id="" style="border-style: solid;border-width: thin;border-color: #990033;">  
				<div class="accordion-inner" id="Duplicate_Workitems" ></div>
			</div>
			<!--*********Decision header*****************-->
			<div class='tooltip-wrapper' id="Decision" style="border-style: solid;border-width: thin;border-color: #990033;">
				<table id="Decision_Grid" border='1' cellspacing='1' cellpadding='0' width=100%>
					<tr width='100%' class='EWLabelRB2' bgcolor= "#990033">
						<td colspan=4 align=center class='EWLabelRB2'>
							<font color="white" size="4">Decision</font>
						</td>
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;Decision 
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%>
							<select  class="NGReadOnlyView" style='width: 174px;' name="selectDecision" id="selectDecision" onchange="differenceOfDays('<%=WSNAME%>');setComboValueToTextBox(this,'wdesk:Decision');" >
								<option value="">--Select--</option>
							</select>
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;<input name='Reject_Reason' id="Reject_Reason" type='button' value='Reject Reason'  class='EWButtonRBSRMRejectReason' style='width:150px' onclick='openCustomDialog(this.id,"<%=WSNAME%>");' disabled=true>&nbsp;
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;<input name='Decision_History' id="Decision_History" type='button'value='Decision History' class='EWButtonRBSRM' style='width:150px' onclick='openCustomDialog(this.id,"<%=WSNAME%>");'>&nbsp;
						</td>
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
							&nbsp;&nbsp;&nbsp;&nbsp;Remarks
						</td>
						<td nowrap='nowrap' colspan='2' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 25%>
							<textarea maxlength="3000" class='EWNormalGreenGeneral1' style="width:420px;white-space:pre-wrap; align:center;" rows="3" cols="50" id="wdesk:Remarks" onkeyup="checkRemarks('wdesk:Remarks','3000');" onblur="checkRemarks('wdesk:Remarks','3000');"></textarea>
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = '25%'>
							&nbsp;&nbsp;<input name='Exception_History' id="Exception_History" type='button' value='Exception History' class='EWButtonRBSRM' style='width:150px' onclick='openCustomDialog(this.id,"<%=WSNAME%>");'>
						</td>
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%>
							&nbsp;&nbsp;<input name='ParentWI_Decision_History' id="ParentWI_Decision_History" type='button'value='Parent WI History' class='EWButtonRBSRMRejectReason' style='width:150px' onclick='openCustomDialog(this.id,"<%=WSNAME%>");' disabled=true>
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = '25%'>
							&nbsp;&nbsp;<input name='ParentWI_UID_History' id="ParentWI_UID_History" type='button' value='Parent WI UID History' class='EWButtonRBSRMRejectReason' style='width:150px' onclick='openCustomDialog(this.id,"<%=WSNAME%>");' disabled=true>
						</td>
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >	
							&nbsp;&nbsp;&nbsp;&nbsp;Sign Verified at <br>&nbsp;&nbsp;&nbsp;&nbsp;CROPS Disbursal Maker
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							<input type='text' disabled name='sign_matched_cropsDisbursal_maker' id='sign_matched_cropsDisbursal_maker' value='<%=((CustomWorkdeskAttribute)attributeMap.get("sign_matched_cropsDisbursal_maker")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("sign_matched_cropsDisbursal_maker")).getAttribValue().toString()%>' 
							readonly />
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							&nbsp;&nbsp;&nbsp;&nbsp;Sign Verified at <br>&nbsp;&nbsp;&nbsp;&nbsp;CROPS Disbursal Checker
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							<input type='text' disabled name='sign_matched_cropsDisbursal_checker' id='sign_matched_cropsDisbursal_checker' value='<%=((CustomWorkdeskAttribute)attributeMap.get("sign_matched_cropsDisbursal_checker")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("sign_matched_cropsDisbursal_checker")).getAttribValue().toString()%>' 
							readonly />
						</td>
					</tr>
					<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >	
							&nbsp;&nbsp;&nbsp;&nbsp;Sign Verified at <br>&nbsp;&nbsp;&nbsp;&nbsp;CROPS Deferral Maker
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >
							<input type='text' disabled name='sign_matched_cropsDeferral_maker' id='sign_matched_cropsDeferral_maker' value='<%=((CustomWorkdeskAttribute)attributeMap.get("sign_matched_cropsDeferral_maker")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("sign_matched_cropsDeferral_maker")).getAttribValue().toString()%>' 
							readonly />
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							&nbsp;&nbsp;&nbsp;&nbsp;Sign Verified at <br>&nbsp;&nbsp;&nbsp;&nbsp;CROPS Deferral Checker
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
							<input type='text' disabled name='sign_matched_cropsDeferral_checker' id='sign_matched_cropsDeferral_checker' value='<%=((CustomWorkdeskAttribute)attributeMap.get("sign_matched_cropsDeferral_checker")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("sign_matched_cropsDeferral_checker")).getAttribValue().toString()%>' 
							readonly />
						</td>
					</tr>
				</table >
			</div>
			<!--*********UID Details Grid*********-->
			<div class='tooltip-wrapper' id="UID_Details"  style="border-style: solid;border-width: thin;border-color: #990033;">
				<table border='1'cellspacing='1' cellpadding='0' width=100% id ='UID_Header'>
					<tr  width='100%' class='EWLabelRB2' bgcolor= "#990033">
						<td colspan='4' align='center' class='EWLabelRB2'>
							<font color="white" size="4">UID Details</font>
						</td>
					</tr>
					<tr>
						<td colspan='4'>
							<input type = 'button' id = 'add_row_UID' value='Add Rows' class='EWButtonRBSRMRejectReason' style='width:150px' onclick='addrow("<%=WSNAME%>",this.id,"")'/>
						</td>
					</tr>
				</table>
				<div style="overflow:scroll;height:150px;border-style: solid;border-width: thin;border-color:#990033;">
					<table border='1'cellspacing='1' cellpadding='0' width=100% id = "UID_Grid" id ='UID_Grid'>
						<tr bgcolor= "#990033" >
							<td width ='10%' class='EWNormalGreenGeneral1' nowrap style="padding:2px;text-align:center;">
								<font color="white">S.No.</font>
							</td>
							<td width ='40%'class='EWNormalGreenGeneral1' nowrap style='text-align:center;'>
								<font color="white">UID</font>
							</td>
							<td width ='40%' class='EWNormalGreenGeneral1' nowrap style='text-align:center;'>
								<font color="white">Remarks</font>
							</td>
							<td width ='10%' class='EWNormalGreenGeneral1'class='EWNormalGreenGeneral1' nowrap style='text-align:center;'>
								<font color="white">Delete</font>
							</td>
						</tr>
					</table>
				</div>
			</div>
			
			
			
			
							
			
			
			
			<!--*****************************Hidden Fields****************************************-->
			
			<input type='hidden' id='CurrentUserName' name='CurrentUserName' value='<%=user_name%>'/>
			<input type='hidden' name="wdesk:Current_WS" id="wdesk:Current_WS" value='<%=WSNAME%>'/>
			<input type="hidden" id="wdesk:WI_NAME" name="wdesk:WI_NAME" value='<%=WINAME%>'/>
		
			<input type="hidden" id="wdesk:IntoducedBy" name="wdesk:IntoducedBy" value='<%=((CustomWorkdeskAttribute)attributeMap.get("IntoducedBy")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("IntoducedBy")).getAttribValue().toString()%>'>
			
			<input type="hidden" id="wdesk:IntoducedAt" name="wdesk:IntoducedAt" value='<%=((CustomWorkdeskAttribute)attributeMap.get("IntoducedAt")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("IntoducedAt")).getAttribValue().toString()%>'>
			
			<input type="hidden" id="wdesk:Sol_Id" name="wdesk:Sol_Id" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Sol_Id")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Sol_Id")).getAttribValue().toString()%>'>
			
			<input type="hidden" id="wdesk:Dec_Populate" name="wdesk:Dec_Populate"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_Populate")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_Populate")).getAttribValue().toString()%>'>
			
			<input type="hidden" id="wdesk:Prev_WS" name="wdesk:Prev_WS" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Prev_WS")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Prev_WS")).getAttribValue().toString()%>'>
			
			<input type="hidden" id="wdesk:Pre_Pre_WS" name="wdesk:Pre_Pre_WS" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Pre_Pre_WS")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Pre_Pre_WS")).getAttribValue().toString()%>'>
			
			<!--Hidden Field Added on 19/02/2019-->
			<input type="hidden" id="wdesk:Price_Change_Approval_Reqd" name="wdesk:Price_Change_Approval_Reqd"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Price_Change_Approval_Reqd")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Price_Change_Approval_Reqd")).getAttribValue().toString()%>'>
			
			<!--Hidden Field Added on 18/02/2019 calculate difference in days-->
			<input type="hidden" id="wdesk:Dec_CBRB_Maker" name="wdesk:Dec_CBRB_Maker"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_CBRB_Maker")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_CBRB_Maker")).getAttribValue().toString()%>'>
			
			<!--Hidden Field Added on 18/02/2019 to calculate difference in days-->			
			<input type="hidden" id="wdesk:Dec_AECB" name="wdesk:Dec_AECB"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_AECB")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_AECB")).getAttribValue().toString()%>'>
			
			<!--Hidden field Added on 20/02/2019 to set value of Drop down in TextBox-->
			<input type="hidden" id="wdesk:CBRB_Required" name="wdesk:CBRB_Required"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("CBRB_Required")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CBRB_Required")).getAttribValue().toString()%>'>
			
			<input type="hidden" id="wdesk:AECB_Required" name="wdesk:AECB_Required"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("AECB_Required")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("AECB_Required")).getAttribValue().toString()%>'>
			
			<!--Modified column name on 21/02/2019-->			
			<input type="hidden" id="wdesk:Dec_CBRB_Checker" name="wdesk:Dec_CBRB_Checker"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_CBRB_Checker")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_CBRB_Checker")).getAttribValue().toString()%>'>
			
			<input type="hidden" id="wdesk:UIDGridCount" name="wdesk:UIDGridCount"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("UIDGridCount")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("UIDGridCount")).getAttribValue().toString()%>'>
			
			<!--Hidden field Added on 20/02/2019 to set value of Drop down in TextBox-->
			<input type="hidden" id="wdesk:Product_Identifier" name="wdesk:Product_Identifier"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Product_Identifier")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Product_Identifier")).getAttribValue().toString()%>'>
			
			<input type="hidden" id="wdesk:Type_Of_LA" name="wdesk:Type_Of_LA"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Type_Of_LA")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Type_Of_LA")).getAttribValue().toString()%>'>
			
			<input type="hidden" id="wdesk:Request_Type" name="wdesk:Request_Type"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Request_Type")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Request_Type")).getAttribValue().toString()%>'>
			
			<input type="hidden" id="wdesk:Dec_Crops_Finalisation_Checker" name="wdesk:Dec_Crops_Finalisation_Checker"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_Crops_Finalisation_Checker")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_Crops_Finalisation_Checker")).getAttribValue().toString()%>'>
			<!--Commented on 19/02/2019 as Credit Manager workstep has been removed-->
			<!--
			<input type="hidden" id="wdesk:Dec_Credit_Manager" name="wdesk:Dec_Credit_Manager"  value='<//%=((CustomWorkdeskAttribute)attributeMap.get("Dec_Credit_Manager")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_Credit_Manager")).getAttribValue().toString()%>'>
			-->
			<!--Hidden Field Added on 20/02/2019 for Credit Analyst Decision-->
			<input type="hidden" id="wdesk:Dec_Credit_Approver_1st" name="wdesk:Dec_Credit_Approver_1st"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_Credit_Approver_1st")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_Credit_Approver_1st")).getAttribValue().toString()%>'>
			
			<input type="hidden" id="wdesk:Dec_Credit_Analyst" name="wdesk:Dec_Credit_Analyst"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_Credit_Analyst")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_Credit_Analyst")).getAttribValue().toString()%>'>
			
			<!--Modified column name on 21/02/2019-->
			<input type="hidden" id="wdesk:Dec_Business_Approver_1st" name="wdesk:Dec_Business_Approver_1st"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_Business_Approver_1st")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_Business_Approver_1st")).getAttribValue().toString()%>'>
			
			<input type="hidden" id="wdesk:Deferral_Held" name="wdesk:Deferral_Held"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Deferral_Held")).getAttribValue().toString()==null?"No":((CustomWorkdeskAttribute)attributeMap.get("Deferral_Held")).getAttribValue().toString()%>'>	
			
			<!--Hidden Field Added on 23/02/2019-->
			<input type="hidden" id="wdesk:RB5_Checks_Expired" name="wdesk:RB5_Checks_Expired"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("RB5_Checks_Expired")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("RB5_Checks_Expired")).getAttribValue().toString()%>'>
			
			<!--Hidden Field Added on 23/02/2019-->
			<input type="hidden" id="wdesk:AECB_Checks_Expired" name="wdesk:AECB_Checks_Expired"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("AECB_Checks_Expired")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("AECB_Checks_Expired")).getAttribValue().toString()%>'>
			
			<!--Hidden Field Added on 28/02/2019-->
			<!--Commented on 04/03/2019-->
			<!--<input type="hidden" id="wdesk:EXP_BUSINESS_APP_IN_MIN" name="wdesk:EXP_BUSINESS_APP_IN_MIN"  value='<//%=((CustomWorkdeskAttribute)attributeMap.get("EXP_BUSINESS_APP_IN_MIN")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("EXP_BUSINESS_APP_IN_MIN")).getAttribValue().toString()%>'>-->
			
			<!--Hidden Field Added on 04/03/2019-->
			<input type="hidden" id="wdesk:Auto_Expiry_Business_Time" name="wdesk:Auto_Expiry_Business_Time"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Auto_Expiry_Business_Time")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Auto_Expiry_Business_Time")).getAttribValue().toString()%>'>
			
			<!--Hidden Field Added on 04/03/2019-->
			<input type="hidden" id="wdesk:Auto_Expiry_Credit_Time" name="wdesk:Auto_Expiry_Credit_Time"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Auto_Expiry_Credit_Time")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Auto_Expiry_Credit_Time")).getAttribValue().toString()%>'>
			
			<!--Hidden Field Added on 05/03/2019-->
			<input type="hidden" id="wdesk:Dec_CROPS_Admin_Checker" name="wdesk:Dec_CROPS_Admin_Checker"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_CROPS_Admin_Checker")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_CROPS_Admin_Checker")).getAttribValue().toString()%>'>
			
			
			<input type="hidden" id="rejReasonCodes" name="rejReasonCodes"/>
			<input type='hidden' name="wdesk:Decision" id="wdesk:Decision"/>
			<input type="hidden" id="H_CHECKLIST" name="H_CHECKLIST"/>
			<input type="hidden" id="H_CHECKLIST_TEMP" name="H_CHECKLIST_TEMP"/>
			<input type='hidden' name='AutocompleteValuesSecurityDocType' id='AutocompleteValuesSecurityDocType' style='visibility:hidden' value=''>
			
			<!--Added By Sajan to make Nature Of Facility as searchable drop down-->
			<input type='hidden' name='AutocompleteValuesNatureOfFacility' id='AutocompleteValuesNatureOfFacility' style='visibility:hidden' value=''>
			
			<!--Added By Sajan to add new Field dealing with countries-->
			<input type='hidden' name='AutocompleteValuesCountry' id='AutocompleteValuesCountry' style='visibility:hidden' value=''>
			
			<input type='hidden' name='AutocompleteValuesFacilityPurpose' id='AutocompleteValuesFacilityPurpose' style='visibility:hidden' value=''>

			<input type='hidden' name='wdesk:dealingWithCountries' id='wdesk:dealingWithCountries' value='<%=((CustomWorkdeskAttribute)attributeMap.get("dealingWithCountries")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("dealingWithCountries")).getAttribValue().toString()%>'>
			
			<input type='hidden' name='wdesk:CBRBMaker_Done_On' id='wdesk:CBRBMaker_Done_On' value='<%=((CustomWorkdeskAttribute)attributeMap.get("CBRBMaker_Done_On")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CBRBMaker_Done_On")).getAttribValue().toString()%>'>
			
			<input type='hidden' name='wdesk:AECB_Done_On' id='wdesk:AECB_Done_On' value='<%=((CustomWorkdeskAttribute)attributeMap.get("AECB_Done_On")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("AECB_Done_On")).getAttribValue().toString()%>'>
			
			<input type='hidden' name='performcheckdays_CBRB' id='performcheckdays_CBRB'>
			
			<input type='hidden' name='performcheckdays_AECB' id='performcheckdays_AECB'>
			
			<input type='hidden' name='AutocompleteValuesInterestDesc' id='AutocompleteValuesInterestDesc' style='visibility:hidden' value=''>
			
			<input type='hidden' name='wdesk:Islamic_Or_Conventional' id='wdesk:Islamic_Or_Conventional' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Islamic_Or_Conventional")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Islamic_Or_Conventional")).getAttribValue().toString()%>'>
			
			<input type='hidden' name='wdesk:PRIORITY' id='wdesk:PRIORITY' value='<%=((CustomWorkdeskAttribute)attributeMap.get("PRIORITY")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PRIORITY")).getAttribValue().toString()%>'>
			
			<input type='hidden' name='wdesk:TWCABF' id='wdesk:TWCABF' value='<%=((CustomWorkdeskAttribute)attributeMap.get("TWCABF")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("TWCABF")).getAttribValue().toString()%>'>

			<input type='hidden' name='wdesk:CHANNELSUBGROUP' id='wdesk:CHANNELSUBGROUP' value='<%=((CustomWorkdeskAttribute)attributeMap.get("CHANNELSUBGROUP")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CHANNELSUBGROUP")).getAttribValue().toString()%>'>
			
			<%if(WSNAME.equalsIgnoreCase("Credit_Analyst")){%>
			<input type='hidden' name='wdesk:ReferToCreditWSName' id='wdesk:ReferToCreditWSName' value='<%=((CustomWorkdeskAttribute)attributeMap.get("ReferToCreditWSName")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ReferToCreditWSName")).getAttribValue().toString()%>'>
			<%}%>
			
			<!-- Below 4 hidden flag added by Sowmya on 28July2022 to avoid auto delete issue in Grids-->
			<input type='hidden' name='generalgridflag' id='generalgridflag' >
			<input type='hidden' name='securitygridflag' id='securitygridflag'>
			<input type='hidden' name='internalcondgridflag' id='internalcondgridflag' >
			<input type='hidden' name='externalcondgridflag' id='externalcondgridflag' >
			
			
		</FORM>
	</BODY>
</HEAD>
</HTML>
<%
	   logger.info("Fee "+	((CustomWorkdeskAttribute)attributeMap.get("Non_Refundable_ProcessingFee")).getAttribValue().toString());
   }

%>
