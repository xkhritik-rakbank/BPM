<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation 
//File Name					 : s.jsp
//Author                     : Tanshu Aggarwal	
// Date written (DD/MM/YYYY) : 05-Feb-2016
//Description                : Initial Header fixed form for CIF Updates
//---------------------------------------------------------------------------------------------------->

<%@ include file="../header.process" %>

<%
	String sCabName=customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	
	String colname="";   //Columns to be updated
	String colvalues="";  //ColumnValues to be updated
	String Query="";
	String inputXML="";
	String outputXML="";
	String mainCodeValue="";
	WFCustomXmlResponse xmlParserData=null;
	WFCustomXmlList objWorkList=null;
	WFCustomXmlResponse objXmlParser=null;
	String subXML="";	
	
	Query="SELECT documents FROM usr_0_cu_doc_required WHERE fieldname='FirstName_Existing'";

	
	inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	//WriteLog("inputXML exceptions-->"+inputXML);
	outputXML = WFCustomCallBroker.execute(inputXML, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	//WriteLog("outputXML exceptions-->"+outputXML);
	
	xmlParserData=new WFCustomXmlResponse();
	xmlParserData.setXmlString((outputXML));
	mainCodeValue = xmlParserData.getVal("MainCode");
	
	//int recordcount=0;
	//recordcount=Integer.parseInt(xmlParserData.getVal("TotalRetrieved")); //commented by ankit as it was not being used and throwing numberformatexception
	String document="";
	if(mainCodeValue.equals("0"))
	{	
		objWorkList = xmlParserData.createList("Records","Record"); 
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{
			if(document.equals(""))
			{
				document=objXmlParser.getVal("documents");
			}	
			else 
			{
				//WriteLog("Unsuccessful");
			}		
		}
	}	
 %>
<script src="..\..\webtop\scripts\CU_Scripts\moment.js"></script>
<script src="..\..\webtop\scripts\CU_Scripts\jquery.min.js"></script>
<script src="..\..\webtop\scripts\CU_Scripts\bootstrap.min.js"></script>
<script src="..\..\webtop\scripts\CU_Scripts\jquery-ui.js"></script>
<script src="..\..\webtop\scripts\CU_Scripts\HandleAjaxRequest.js"></script>
<script src="..\..\webtop\scripts\CU_Scripts\tcal.js"></script>
<HTML>
	<head>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
		<link rel="stylesheet" href="..\..\webtop\scripts\CU_Scripts\bootstrap.min.css">
		<link rel="stylesheet" href="..\..\webtop\scripts\CU_Scripts\CIFUpdates.css">
		<link rel="stylesheet" href="..\..\webtop\scripts\CU_Scripts\jquery-ui.css">
		<link rel="stylesheet" href="..\..\webtop\scripts\CU_Scripts\calendar.css">
		<style>
			#emid {
				border: 1px solid black;
				width: 100%;
				border-collapse: collapse;
			}
			td {
				background-color : #FEFAEF;
				padding-top:2px;
				padding-left:2px;
				padding-right:2px;
				padding-bottom:2px;
				line-height: 22px;
			}
			th{
				padding-left:5px;
				padding-right:5px;
				padding-top:2px;
				padding-bottom:2px;
			}
			th
			{
				font:9pt Arial; font-size:14px; color:#444; background:#FEFAEF;
			}
			.accordion-heading {			
				padding:2px;
			}
			
			.accordion-heading {
				background-color: #980033;
				border : 1px	 solid gray;
			}
			.panel-title > .small, .panel-title > .small > a, .panel-title > a, .panel-title > small, .panel-title > small > a {
                color: white;
            }

		</style>
        <title>CIF Updates</title>
		<style>
			@import url("/CU/webtop/en_us/css/docstyle.css");
		</style>
		<script type="text/javascript" language="javascript" src="eida_webcomponents.js"></script>
		<script>
			function callEIDA() {
				Initialize();
				DisplayPublicDataEx();
				document.getElementById("wdesk:emirates_id").value = fetchEID();
			}
			
			function fetchSolID()
			{
				var WSNAME = 'PBO';
				var xmlDoc;
				var x;
				var username = "<%=customSession.getUserName()%>";
				
				var xLen;

				var xhr;
				if (window.XMLHttpRequest)
					xhr = new XMLHttpRequest();
				else if (window.ActiveXObject)
					xhr = new ActiveXObject("Microsoft.XMLHTTP");

				var url = "/CU/CustomForms/CU_Specific/fetchSolID.jsp";

				var param = "username=" + username+"&request_type=ACCOUNT_SUMMARY";
				xhr.open("POST", url, false);
				xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
				xhr.send(param);

				if (xhr.status == 200 && xhr.readyState == 4) {
					ajaxResult = xhr.responseText;
					ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');

					if (ajaxResult.indexOf("Exception") == 0) {
						alert("SOl Id is not Set for this user.");
						return false;
					}
					document.getElementById("wdesk:SolId").value = ajaxResult;
				} else {
					alert("Problem in getting Sol ID.");
					return false;
				}
				return true;			
			}

			function validateKeys(e, act) {

				var re = "";
				if (e.value != "") {
					//Tanshu Aggarwal, to make comparison case independent.
					act = act.toLowerCase()
					switch (act) {
						case "alphabetic":
							re = /[^a-zA-Z ]+/i;
							break;
						case "numeric":
							re = /[^0-9]+/i;
							break;
						case "float":
							re = /[^0-9.-]+/i;
							break;
						case "alpha-numeric":
							re = /[^a-z0-9 ]+/i;
							break;
						case "alpha-numeric1":
							re = /[^a-z0-9- ]+/i;
							break;
						case "alphanumeric2":
							re = /[^a-z0-9-.,+#$%@;'\/\\~^&*()-+<>_!=:? ]+/i;
							break;
						case "alpha-numeric3":
							re = /[^a-z0-9-]+/i;
							break;
						case "alpha-numeric4":
							re = /[^a-z0-9-,]+/i;
							break;
						case "alpha-numeric5":
							re = /[^0-9-, ]+/i;
							break;
						case "alphacomments":
							re = /[^a-zA-Z ]+/i;
							break;
						case "alpha-numeric":
							re = /[^a-zA-Z0-9 ]+/i;
							break;
						case "decimal":
							re = /[^0-9.]+/i;
							break;
						case "email":
							re = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
							break;
						case "pan card number":
							re = /[a-z]{3}[cphfatblj][a-z]\d{4}[a-z]/i;
							break;
						case "pincode":
							re = /^([1-9])([0-9]){5}$/i;
							break;
						case "date":
							re = /(0[1-9]|1\d|2\d|3[01])\/(0[1-9]|1[0-2])\/(19|20)\d{2}$/;
							break;
						case "mobile number":
							re = /^\d{10}$/;
							break;
					}
					if (re.test(e.value)) {
						if (act == 'alphabetic') {
							alert("This field is" + act);
							e.value = e.value.replace(re, "");
							e.focus();
							return false;
						}
						if (act == 'alpha-numeric') {
							alert("This field can only contain " + act);
							e.value = e.value.replace(re, "");
							e.focus();
							return false;
						}
						if (act == 'alpha-numeric1') {
							alert("This field can only contain " + act + " and special characters(@,_)");
							e.value = e.value.replace(re, "");
							e.focus();
							return false;
						}
						if (act == 'alphanumeric2') {
							alert("This field can only contain alpha-numeric and special characters(+#$%@;'\/\\~^&*()-+<>_!=:?)");
							e.value = e.value.replace(re, "");
							e.focus();
							return false;
						}
						if (act == 'numeric') {
							alert("This field can only contain " + act);
							e.value = e.value.replace(re, "");
							e.focus();
							return false;
						}

						if (act == 'decimal') {
							alert("This field can only contain Numeric value or .");
							e.value = e.value.replace(re, "");
							e.focus();
							return false;
						}
					} else {
						if (act == "email") {
							alert("please enter valid " + act + " id");
							e.value = '';
							e.focus();
							return false;
						}

						if (act == 'account number') {
							alert("Please enter valid " + act);
							e.value = '';
							e.focus();
							return false;
						}

						if (act == "pan card number") {

							alert("Please enter valid " + act);
							e.value = '';
							e.focus();
							return false;

						}
						if (act == 'pincode') {
							alert("Please enter valid " + act);
							e.value = '';
							e.focus();
							return false;
						}

						if (act == 'date') {
							alert("Please enter valid " + act);
							e.value = '';
							e.focus();
							return false;
						}

						if (act == 'mobile number') {
							alert("Please enter valid " + act);
							e.value = '';
							e.focus();
							return false;
						}

					}

				} else if (act == "float") {
					try {
						if (!(parseFloat(e.value) == e.value)) {
							alert("Invalid float value.");
							e.focus();
							e.select();
							return false;
						}

					} catch (e) {
						alert("Invalid float value.");
						e.focus();
						e.select();
						return false;
					}
				}
				return true;
			}

			function trim(str) {
				if (undefined == str)
					return "";
				return str.replace(/^\s+|\s+$/g, '');
			}

			function getSignature(Object) {
				var popupWindow = null;
				var sOptions;

				sOptions = 'dialogWidth:400px; dialogHeight:400px; dialogLeft:450px; dialogTop:100px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:yes; titlebar:no;';
				var url = "/CU/CustomForms/CU_Specific/OpenImage.jsp?acc_num_new=" + document.getElementById("wdesk:Acc_Number_received").value;
				popupWindow = window.open(url, "_blank", sOptions);

			}

			function changeVal(dropdown, WSNAME) {
				if (dropdown.id == 'decision'){
					document.getElementById("wdesk:Decision").value = dropdown.value;
					document.getElementById("wdesk:PBOdecision").value = dropdown.value;
				}	
				else
					document.getElementById("wdesk:" + dropdown.id).value = dropdown.value;
			}

			function validateDatepassportexpiryCheck() {
				var enteredPassportDate = document.getElementById("wdesk:passportExpDate_exis").value;
				var enteredVisaDate = document.getElementById("wdesk:visaExpDate_exis").value;
				var enteredEmiratesDate = document.getElementById("wdesk:emiratesidexp_exis").value;

				var today = new Date();

				var arrStartDate = enteredPassportDate.split("/");
				var date1 = new Date(arrStartDate[2], arrStartDate[1] - 1, arrStartDate[0]);

				var arrStartDate2 = enteredVisaDate.split("/");
				var date2 = new Date(arrStartDate2[2], arrStartDate2[1] - 1, arrStartDate2[0]);

				var arrStartDate3 = enteredEmiratesDate.split("/");
				var date3 = new Date(arrStartDate3[2], arrStartDate3[1] - 1, arrStartDate3[0]);

				var timeDiffPassport = date1.getTime() - today.getTime();
				var timeDiffVisa = date2.getTime() - today.getTime();
				var timeDiffEmirates = date3.getTime() - today.getTime();


				if (timeDiffPassport < 0) {
					alert("Passport has Expired");

					return false;
				} else if (timeDiffVisa < 0) {

					alert("Visa has Expired");

					return false;
				} else if (timeDiffEmirates < 0) {

					alert("Emirates Id has Expired");

					return false;
				}
			}

			var lastCIFval = '';

			function showDivForRadio(Object) {

				document.getElementById("radioChecked").value = "Y";
				var WSNAME = 'PBO';

				if (Object.id == "Individual") {
					lastCIFval = Object.value;
					document.getElementById("wdesk:SelectedCIF").value = lastCIFval;
					div = document.getElementById('divCheckbox2');
					div.style.display = "block";
					var main_gridVal = document.getElementById("main_grid").value;
					var main_val = "";
					var cif_id = "";
					var cif_type = "";
					main_gridVal = main_gridVal.split("~");

					for (var i = 0; i < main_gridVal.length - 1; i++) {
						main_val = main_gridVal[i].toString().split("#");
						if (main_val[0].toString() == Object.id.toString()) {
							cif_id = main_val[1].toString();
							cif_type = main_val[2].toString();
							break;
						}
					}
					if (cif_id == "")
						cif_id = lastCIFval;

					getCustDetails("Individual", cif_id, cif_type);
					
					//called to fetch Address details added by Shamily
					getCustomerDetails("Individual",cif_id)
					document.getElementById("ReadEmiratesID").disabled = true;
					
				} else if (Object.id == "Non-Individual") {
					document.getElementById("radioChecked").value = "N";
					alert("Request cannot be taken for Non-Individual CIF Type");
					$("input[value='" + lastCIFval + "']").prop('checked', 'checked');
					Object.checked = false;

					return false;
					div = document.getElementById('divCheckbox2');
					div.style.display = "none";					
				}

				document.getElementById("wdesk:Updated_CIFNumber").value = lastCIFval;
				validateDatepassportexpiryCheck();    
			}

			function getCustDetails(cif_type, cidf_id, cidf_type) {

				var xmlDoc;
				var x;
				var xLen;
				var request_type = "ENTITY_DETAILS_2";
				var xhr;
				if (window.XMLHttpRequest)
					xhr = new XMLHttpRequest();
				else if (window.ActiveXObject)
					xhr = new ActiveXObject("Microsoft.XMLHTTP");

				var account_number = document.getElementById("wdesk:account_number").value;
				var mobile_number = document.getElementById("wdesk:MobilePhone_Existing").value;
				var emirates_id = document.getElementById("wdesk:emirates_id").value;
				var user_name = "<%=customSession.getUserName()%>";
				var url = "/CU/CustomForms/CU_Specific/CUIntegration.jsp";
				var wi_name = '';
				var param = "request_type=" + request_type + "&cif_type=" + cif_type + "&wi_name=" + wi_name + "&CIF_ID=" + cidf_id + "&cidf_type=" + cidf_type + "&Account_Number=" + account_number + "&mobile_number=" + mobile_number + "&Emirates_Id=" + emirates_id + "&user_name=" + user_name;
				xhr.open("POST", url, false);
				xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
				xhr.send(param);
				
				if (xhr.status == 200 && xhr.readyState == 4) {
					ajaxResult = xhr.responseText;
					ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');

					if (ajaxResult.indexOf("Exception") == 0) {
						alert("Some problem in fetching getting Customer Details.");
						return false;
					}

					var res = ajaxResult.split("`");
					var newres = "";
					for (var i = 0; i < res.length; i++) {
						newres = res[i].split("~");
						if (newres.length > 1 && document.getElementById(newres[0])) {
							document.getElementById(newres[0]).value = newres[1];
						}
					}
				} else {
					alert("Problem in getting Customer Details.");
					return false;
				}
				return true;
			}
			
			//called to fetch Address details added by Shamily
			function getCustomerDetails(cif_type,cif_id) {

				var xmlDoc;
				var x;
				var xLen;
				var request_type = "CUSTOMER_DETAILS";
				var xhr;
				if (window.XMLHttpRequest)
					xhr = new XMLHttpRequest();
				else if (window.ActiveXObject)
					xhr = new ActiveXObject("Microsoft.XMLHTTP");
				
				//var account_number = document.getElementById("wdesk:account_number").value;
				//var mobile_number = document.getElementById("wdesk:MobilePhone_Existing").value;
				//var emirates_id = document.getElementById("wdesk:emirates_id").value;
				var user_name = '<%=customSession.getUserName()%>';
				var url = "/CU/CustomForms/CU_Specific/CustDetails_AddressFetch.jsp";
				var wi_name = '<%=WINAME%>';
				var param = "request_type=" + request_type  + "&cif_type=" + cif_type + "&wi_name=" + wi_name  + "&user_name=" + user_name+ "&CIF_ID=" + cif_id;
				xhr.open("POST", url, false);
				xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
				xhr.send(param);
				if (xhr.status == 200 && xhr.readyState == 4) {
					ajaxResult = xhr.responseText;
					ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');

					if (ajaxResult.indexOf("Exception") == 0) {
						alert("Some problem in fetching getting Customer Details.");
						return false;
					}

					var res = ajaxResult.split("`");
					var newres = "";
					for (var i = 0; i < res.length; i++) {
						newres = res[i].split("~");
						if (newres.length > 1 && document.getElementById(newres[0])) {
							document.getElementById(newres[0]).value = newres[1];
						}
					}
				} else {
					alert("Problem in getting Customer Details.");
					return false;
				}
				
				return true;
			}
			

			function showDiv() {
				document.getElementById('wdesk:rak_elite_customer').disabled = true;
				document.getElementById('wdesk:Segment').disabled = true;
				document.getElementById('wdesk:sub_segment').disabled = true;
				document.getElementById('wdesk:armName').disabled = true;
				document.getElementById('wdesk:SolId').disabled = true;
				document.getElementById('wdesk:Channel').value = "Phone Banking";
				document.getElementById('wdesk:Channel').disabled = true;    
			}

			function ClearFields() {
				
				document.getElementById("Fetch").disabled = false;				
				document.getElementById("radioChecked").value = "N";
				document.getElementById("ReadEmiratesID").disabled = false;
				document.getElementById('wdesk:rak_elite_customer').value = "";
				document.getElementById('wdesk:Segment').value = "";
				document.getElementById('wdesk:sub_segment').value = "";
				document.getElementById('wdesk:armName').value = "";								
				document.getElementById("wdesk:CIFNumber_Existing").disabled = false;
				document.getElementById("wdesk:CIFNumber_Existing").value = "";						
				document.getElementById("wdesk:account_number").disabled = false;
				document.getElementById("wdesk:loan_agreement_id").disabled = false;
				document.getElementById("wdesk:card_number").disabled = false;
				document.getElementById("wdesk:emirates_id").disabled = false;
				document.getElementById("wdesk:account_number").value = "";
				document.getElementById("wdesk:card_number").value = "";
				document.getElementById("wdesk:emirates_id").value = "";				
				document.getElementById("wdesk:loan_agreement_id").value = "";
				document.getElementById("panel20").style.display = "none";
				document.getElementById("panel3").style.display = "none";
				document.getElementById("panel22").style.display = "none";
				document.getElementById("divCheckbox2").style.display = "none";
				document.getElementById("wdesk:title_exis").value = "";
				document.getElementById("wdesk:FirstName_Existing").value = "";
				document.getElementById("wdesk:MiddleName_Existing").value = "";
				document.getElementById("wdesk:LastName_Existing").value = "";
				document.getElementById("wdesk:FullName_Existing").value = "";
				document.getElementById("wdesk:gender_exit").value = "";
				document.getElementById("wdesk:DOB_exis").value = "";
				document.getElementById("emirates_id").value = "";
				document.getElementById("wdesk:emiratesidexp_exis").value = "";
				document.getElementById("wdesk:PassportNumber_Existing").value = "";
				document.getElementById("wdesk:passportExpDate_exis").value = "";
				document.getElementById("wdesk:visa_exis").value = "";
				document.getElementById("wdesk:visaExpDate_exis").value = "";
				document.getElementById("wdesk:mother_maiden_name_exis").value = "";
				document.getElementById("wdesk:TypeOfRelation_exis").value = "";
				document.getElementById("wdesk:SignedDate_exis").value = "";
				document.getElementById("wdesk:ExpiryDate_exis").value = "";
				document.getElementById("wdesk:us_citizen_exis").value = "";
				document.getElementById("wdesk:nocnofbirth_exis").value = "";
				document.getElementById("wdesk:nonResident").value = "";
				document.getElementById("wdesk:USrelation").value = "";
				document.getElementById("wdesk:FatcaDoc").value = "";
				document.getElementById("wdesk:abcdelig_exis").value = "";
				document.getElementById("resiadd_exis").value = "";
				document.getElementById("office_add_exis").value = "";
				document.getElementById("wdesk:pref_add_exis").value = "";
				document.getElementById("wdesk:prim_email_exis").value = "";
				document.getElementById("wdesk:sec_email_exis").value = "";
				document.getElementById("wdesk:pref_email_exis").value = "";
				document.getElementById("wdesk:E_Stmnt_regstrd_exis").value = "";
				document.getElementById("wdesk:MobilePhone_Existing").value = "";
				document.getElementById("wdesk:sec_mob_phone_exis").value = "";
				document.getElementById("wdesk:homephone_exis").value = "";
				document.getElementById("wdesk:office_phn_exis").value = "";
				document.getElementById("wdesk:fax_exis").value = "";
				document.getElementById("wdesk:homecntryphone_exis").value = "";
				document.getElementById("wdesk:pref_contact_exis").value = "";
				document.getElementById("wdesk:emp_type_exis").value = "";
				document.getElementById("wdesk:designation_exis").value = "";
				document.getElementById("wdesk:comp_name_exis").value = "";
				document.getElementById("wdesk:emp_name_exis").value = "";
				document.getElementById("wdesk:department_exis").value = "";
				document.getElementById("wdesk:employee_num_exis").value = "";
				document.getElementById("wdesk:occupation_exist").value = "";
				document.getElementById("wdesk:name_of_business_exis").value = "";
				document.getElementById("wdesk:IndustrySegment_exis").value = "";
				document.getElementById("wdesk:IndustrySubSegment_exis").value = "";
				document.getElementById("wdesk:CustomerType_exis").value = "";
				document.getElementById("wdesk:DealwithCont_exis").value = "";
				document.getElementById("wdesk:total_year_of_emp_exis").value = "";
				document.getElementById("wdesk:years_of_business_exis").value = "";
				document.getElementById("wdesk:employment_status_exis").value = "";
				document.getElementById("wdesk:date_join_curr_employer_exis").value = "";
				document.getElementById("wdesk:marrital_status_exis").value = "";
				document.getElementById("wdesk:no_of_dependents_exis").value = "";
				document.getElementById("wdesk:country_of_res_exis").value = "";
				document.getElementById("wdesk:nation_exist").value = "";
				document.getElementById("wdesk:wheninuae_exis").value = "";
				document.getElementById("wdesk:prev_organ_exis").value = "";
				document.getElementById("wdesk:period_organ_exis").value = "";
			}

			function getEntityDetails() {
				var CIF_ID = document.getElementById("wdesk:CIFNumber_Existing").value;
				var account_number = document.getElementById("wdesk:account_number").value;
				var loan_agreement_id = document.getElementById("wdesk:loan_agreement_id").value;
				var card_number = document.getElementById("wdesk:card_number").value;
				var emirates_id = document.getElementById("wdesk:emirates_id").value;
			   
				if ((CIF_ID == "") && (account_number == "") && (loan_agreement_id == "") && (card_number == "") && (emirates_id == "")) {
					alert("Please enter the Emirates ID/Loan Agreement Id/Card Number/CIF Number/ A/c No. ");
					document.getElementById("wdesk:loan_agreement_id").focus();
					return false;
				} else {
					document.getElementById("Fetch").disabled = true;
					document.getElementById("wdesk:CIFNumber_Existing").disabled = true;
					document.getElementById("wdesk:account_number").disabled = true;
					document.getElementById("wdesk:loan_agreement_id").disabled = true;
					document.getElementById("wdesk:card_number").disabled = true;
					document.getElementById("wdesk:emirates_id").disabled = true;
					var xmlDoc;
					var x;
					var xLen;
					var request_type = "ENTITY_DETAILS";
					var mobile_number = "111111"; //document.getElementById("wdesk:mob_phone_exis").value;
					var account_type = "A";

					//getAccountType for Card
					if (account_number == "") {
						if (card_number != "") {
							account_number = card_number;
							//code change for CC/DC card.
							account_type = "C";
						}
						//code change for Loan Agreement ID
						else if (loan_agreement_id != "") {
							account_number = loan_agreement_id;
							account_type = "L";
						} else
							account_type = "";
					}

					var user_name = "<%=customSession.getUserName()%>";
					var xhr;
					if (window.XMLHttpRequest)
						xhr = new XMLHttpRequest();
					else if (window.ActiveXObject)
						xhr = new ActiveXObject("Microsoft.XMLHTTP");

					var url = "/CU/CustomForms/CU_Specific/CUIntegration.jsp";

					var param = "request_type=" + request_type + "&Account_Number=" + account_number + "&mobile_number=" + mobile_number + "&Emirates_Id=" + emirates_id + "&account_type=" + account_type + "&CIF_ID=" + CIF_ID + "&user_name=" + user_name;
					xhr.open("POST", url, false);
					xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
					xhr.send(param);
					if (xhr.status == 200 && xhr.readyState == 4) {
						ajaxResult = xhr.responseText;
						ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');

						if (ajaxResult.indexOf("Exception") == 0) {
							alert("Please enter an valid Emirates ID/Loan Agreement Id/Card Number/CIF Number/ A/c No.");
							document.getElementById("Fetch").disabled = false;
							document.getElementById("wdesk:CIFNumber_Existing").disabled = false;
							document.getElementById("wdesk:account_number").disabled = false;
							document.getElementById("wdesk:loan_agreement_id").disabled = false;
							document.getElementById("wdesk:card_number").disabled = false;
							document.getElementById("wdesk:emirates_id").disabled = false;

							return false;
						}

						ajaxResult = ajaxResult.split("^^^");
						document.getElementById("mainEmiratesId").innerHTML = ajaxResult[0];
						document.getElementById("wdesk:rak_elite_customer").value = ajaxResult[1];
						document.getElementById("wdesk:armName").value = ajaxResult[2];
						document.getElementById("wdesk:Segment").value = ajaxResult[3];
						document.getElementById("wdesk:sub_segment").value = ajaxResult[4];

						document.getElementById("Fetch").disabled = true;
						document.getElementById("ReadEmiratesID").disabled = true;
						document.getElementById("panel20").style.display = "block";
						document.getElementById("panel3").style.display = "block";
						
						document.getElementById("panel22").style.display = "block";
						
					} else {
						alert("Problem in getting Entity Details.");
						return false;
					}
					return true;
				}
			}

			//Account Number validation is made of 13 digits
			function validateaccountno() {
				if (document.getElementById("wdesk:account_number").value.length != 13) {
					alert("Account Number should be of 13 digits");
					document.getElementById("wdesk:account_number").value = "";
					document.getElementById("wdesk:account_number").focus();
					return false;
				}
				return true;
			}

			function validate_emiratesid(id) {
				if (document.getElementById(id).value.indexOf("784") === 0) {
					if (document.getElementById(id).value.length != 15) {
						alert("Invalid length, must be 15 characters");
						document.getElementById(id).value = "";
						document.getElementById(id).focus();
						return false;
					}
				} else if (document.getElementById(id).value.indexOf("800") === 0) {
					if (document.getElementById(id).value.length != 21) {
						alert("Emirates ID Number starting with 800 should be of 21 characters");
						document.getElementById(id).value = "";
						document.getElementById(id).focus();
						return false;
					}
				} else {
					alert("Invalid Emirates ID Number");
					document.getElementById(id).value = "";
					document.getElementById(id).focus();
					return false;
				}
				return true;
			}
		</script>
    </head>
    <BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onload = "showDiv();fetchSolID();">
		<applet name="EIDAWebComponent" id="EIDAWebComponent" CODE="emiratesid.ae.webcomponents.EIDAApplet" archive="EIDA_IDCard_Applet.jar" width="0" height="0"></applet>
		
		<form name="wdesk" id="wdesk" method="post">
			<table border='1' cellspacing='1' cellpadding='0' width=100% >
				<div class="accordion-group">
					<div class="accordion-heading">
						<h4 class="panel-title" align="center" style="text-align:center;">
							<b style="COLOR: white;">CIF Updates</b>							
						</h4>
					</div>
					<div id="panel19" class="accordion-body collapse">
						<div class="accordion-inner">
							<tr>
								<td colspan =4 width=100% height=100% align=right valign=center><img src='\CU\webtop\images\bank-logo.gif'></td></tr>
							<tr>
								<td nowrap='nowrap' width="23%" class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;<b>Logged In As</b></td>
								<td nowrap='nowrap' width="23%" class='EWNormalGreenGeneral1' height ='22' maxlength = '50' id="username"><%=customSession.getUserName()%></td>
								<td nowrap='nowrap' width="23%" class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;<b>Workstep</b></td>
								<td nowrap='nowrap' width="24%" class='EWNormalGreenGeneral1' height ='22' maxlength = '50' ><label id="Workstep">&nbsp;&nbsp;&nbsp;&nbsp;PBO</label></td>
							</tr>
							<tr>
							
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>&nbsp;&nbsp;&nbsp;&nbsp;<b>RAK Elite Customer</b></td>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<input type="text" name="wdesk:rak_elite_customer" id="wdesk:rak_elite_customer"  maxlength = '3' style='width:170px' value='' >
								&nbsp;&nbsp;&nbsp;&nbsp;</td>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' maxlength = '10'>&nbsp;&nbsp;&nbsp;&nbsp;<b>SOL Id</b></td>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="wdesk:SolId" onkeyup="validateKeys(this,'Alphabetic');" id="wdesk:SolId"  maxlength = '100' style='width:170px' value='' >&nbsp;&nbsp;&nbsp;&nbsp;</td>
							</tr>
							<tr>
								
								<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>&nbsp;&nbsp;&nbsp;&nbsp;<b>Segment</b></td>
							
								<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="wdesk:Segment" id="wdesk:Segment"  maxlength = '3' style='width:170px'value=''>&nbsp;&nbsp;&nbsp;&nbsp;
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>&nbsp;&nbsp;&nbsp;&nbsp;<b>Channel</b></td>
							</td>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="wdesk:Channel" id="wdesk:Channel" maxlength = '100' style='width:170px' value=''>&nbsp;&nbsp;&nbsp;&nbsp;</td>
							</tr>
							<tr>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>&nbsp;&nbsp;&nbsp;&nbsp;<b>Emirates ID Number</b></td>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text"  onkeyup="validateKeys(this,'Numeric');" name="wdesk:emirates_id" id="wdesk:emirates_id" value='' onchange="validate_emiratesid(this.id);" maxlength = '21' style='width:170px'>&nbsp;&nbsp;&nbsp;&nbsp;
								<input name='EmiratesID' type='button' id='ReadEmiratesID' value='Read' maxlength = '100' class='EWButtonRB' style='width:85px' onclick="callEIDA();return false;">
								</td>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>&nbsp;&nbsp;&nbsp;&nbsp;<b>Loan Agreement Id</b></td>							
								<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="wdesk:loan_agreement_id" onkeyup="validateKeys(this,'Numeric');" id="wdesk:loan_agreement_id"  maxlength = '20' style='width:170px' value=''>&nbsp;&nbsp;&nbsp;&nbsp;</td>	
							</tr>
							<tr>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>&nbsp;&nbsp;&nbsp;&nbsp;<b>Card Number</b></td>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="wdesk:card_number" id="wdesk:card_number"onkeyup="validateKeys(this,'Numeric');" value='' maxlength = '16' style='width:170px' >&nbsp;&nbsp;&nbsp;&nbsp;</td>						
								<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>&nbsp;&nbsp;&nbsp;&nbsp;<b>CIF Number</b></td>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="wdesk:CIFNumber_Existing" onkeyup="validateKeys(this,'Numeric');" id="wdesk:CIFNumber_Existing"  maxlength = '7' style='width:170px' value=''>&nbsp;&nbsp;&nbsp;&nbsp;
								</td>
							</tr>							
							<tr>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>&nbsp;&nbsp;&nbsp;&nbsp;<b>Account Number</b></td>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="wdesk:account_number" onchange="validateaccountno();" onkeyup="validateKeys(this,'Numeric');"  id="wdesk:account_number" value='' maxlength = '13' style='width:170px' >&nbsp;&nbsp;&nbsp;&nbsp;
								</td>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>&nbsp;&nbsp;&nbsp;&nbsp;<b>Sub-Segment</b></td>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="wdesk:sub_segment" onkeyup="validateKeys(this,'Numeric');"  id="wdesk:sub_segment" value='' maxlength = '13' style='width:170px' >&nbsp;&nbsp;&nbsp;&nbsp;
								</td>
							</tr>
							<tr>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>&nbsp;&nbsp;&nbsp;&nbsp;<b>ARMName</b></td>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="wdesk:armName"   id="wdesk:armName" value='' maxlength = '13' style='width:170px' >&nbsp;&nbsp;&nbsp;&nbsp;
								</td>
								<td nowrap='nowrap' colspan=2 class='EWNormalGreenGeneral1' height ='22'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
							</tr>							
							<tr>
								<td style="text-align:right;" nowrap='nowrap' colspan=2 class='EWNormalGreenGeneral1'><input name='Fetch' type='button' id='Fetch' value='Search' onclick="getEntityDetails();" class='EWButtonRB' style='width:85px'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
								<td style="text-align:left;" nowrap='nowrap' colspan=2 class='EWNormalGreenGeneral1'>&nbsp;&nbsp;&nbsp;<input name='Clear' id='Clear' type='button' value='Clear' onclick="ClearFields()" class='EWButtonRB' style='width:85px'></td>								
							</tr>
						</div>
					</div>
				</div>
			</table>
			<div id="divCheckbox">
				<div class="accordion-group">
					<div id="panel20" class="accordion-body collapse in">				  
						<div class="accordion-inner" id="mainEmiratesId">				
						</div>
					</div>
				</div>
			</div>
			<div id="divCheckbox2" style="display: none;">
				<div class="accordion-group">
					<div class="accordion-heading">
						<h4 class="panel-title">
							<b style="COLOR: white;">CIF Data Updates</b>
						</h4>
					</div>
					<div id="panel3" class="accordion-body collapse in">
						<div class="accordion-inner">				
							<table border='1' cellspacing='1' cellpadding='0' width=100% style="border-right-style: none; border-left-style: none;">
								<tr width=100% >
									<td width=25% style="padding-left: 5px;" nowrap='nowrap' class="EWNormalGreenGeneral1 "  colspan=2><b><font color="#FF4747">Personal Details</font></b></td>
									<td width=25% style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 "   colspan=2><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"><b><font color="#FF4747">Existing</font></b></td>						
								</tr>				
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Title</td>
									
									<td nowrap='nowrap' class='EWNormalGreenGeneral1'  colspan=2><input type="text" name="wdesk:title_exis" size="35" maxlength = '5' id="wdesk:title_exis"   readonly disabled=true class="sizeofbox" value = ''>
									</td>					
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>First Name</td>
									
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:FirstName_Existing" size="35" maxlength = '100' id="wdesk:FirstName_Existing"   readonly disabled=true class="sizeofbox" value = ''>
									</td>					
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>Middle Name</td>
									
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:MiddleName_Existing" size="35" maxlength = '100' id="wdesk:MiddleName_Existing"  readonly disabled=true class="sizeofbox" value = ''>
									</td>             	    
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Last Name</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:LastName_Existing" size="35" maxlength = '50' id="wdesk:LastName_Existing"  readonly disabled=true  class="sizeofbox" value = ''>
									</td>                    
								</tr>	
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Full Name</td>					
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="FullName_Existing" size="35" maxlength = '150' id="wdesk:FullName_Existing"   readonly disabled=true class="sizeofbox" value = ''>
									</td>					 
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Gender</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="" name="wdesk:gender_exit" size="35" maxlength = '11' id="wdesk:gender_exit"  readonly disabled=true class="sizeofbox" value = ''>
									</td>                    
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Date Of Birth</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:DOB_exis" size="35" maxlength = '20' id="wdesk:DOB_exis"  readonly disabled=true class="sizeofbox" value = '' >
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Emirates ID</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text"  name="emirates_id" size="35" maxlength = '100' id="emirates_id"  readonly disabled=true  class="sizeofbox" value = ''>
									</td>                    
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Emirates ID Expiry Date</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:emiratesidexp_exis" size="35" maxlength = '20' id="wdesk:emiratesidexp_exis"  readonly disabled=true class="sizeofbox" value = '' >
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Passport Number</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:PassportNumber_Existing" size="35" maxlength = '100' id="wdesk:PassportNumber_Existing"  readonly disabled=true class="sizeofbox"  value = ''>
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Passport Expiry Date</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="date" name="wdesk:passportExpDate_exis" size="35" maxlength = '20' id="wdesk:passportExpDate_exis"  readonly disabled=true class="sizeofbox"  value = ''>
									</td>                        
								</tr>				
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Visa Number</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="date" name="wdesk:visa_exis" size="35" maxlength = '100' id="wdesk:visa_exis"  readonly disabled=true class="sizeofbox" value = ''>
									</td>                    
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Visa Expiry Date</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="date"  name="wdesk:visaExpDate_exis" size="35" maxlength = '20' id="wdesk:visaExpDate_exis"  readonly disabled=true class="sizeofbox" value = ''>
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Mother's Maiden Name</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="password" name="wdesk:mother_maiden_name_exis" size="35" maxlength = '100' id="wdesk:mother_maiden_name_exis"  readonly disabled=true  class="sizeofbox"  value = ''>
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Reason / Type of relation</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>
									<input type="textarea" name="wdesk:TypeOfRelation_exis" size="35" maxlength = '4' id="wdesk:TypeOfRelation_exis" readonly disabled=true class="sizeofbox"  value = ''> 
									</td>                       
								</tr>				
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Signed Date</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="date" name="wdesk:SignedDate_exis"  size="35" maxlength = '20' id="wdesk:SignedDate_exis"  readonly disabled=true class="sizeofbox"  value = ''>
									</td>                        
								</tr>				
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Expiry Date</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="date" name="wdesk:ExpiryDate_exis" size="35" maxlength = '20' id="wdesk:ExpiryDate_exis"  readonly disabled=true class="sizeofbox"  value = ''>
									</td>                         
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>US Born?</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="date" name="wdesk:us_citizen_exis" size="35" maxlength = '5' id="wdesk:us_citizen_exis" readonly disabled=true class="sizeofbox"  value = ''>
									</td>                       
								</tr>				
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>If No,Country of Birth</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="date" name="wdesk:nocnofbirth_exis" size="35" maxlength = '100' id="wdesk:nocnofbirth_exis"  readonly disabled=true class="sizeofbox"  value = ''>
									</td>                      
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Non Resident</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:nonResident" size="35" maxlength = '5'id="wdesk:nonResident" readonly disabled=true class="sizeofbox"  value = ''>
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>US Relation</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:USrelation" size="35" maxlength = '5'id="wdesk:USrelation" readonly disabled=true class="sizeofbox"  value = ''>
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Fatca Document</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:FatcaDoc" size="35" maxlength = '5'id="wdesk:FatcaDoc" readonly disabled=true class="sizeofbox"  value = ''>
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>AECB Eligible?</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:abcdelig_exis" size="35" maxlength = '5'id="wdesk:abcdelig_exis" readonly disabled=true class="sizeofbox"  value = ''>
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2 
									id="contact_details"><b><font color="#FF4747">Contact Details</font></b></td>
									<td style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 " colspan=2><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"></td>
								</tr>				
								<tr width=100%>
									<td  nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=4 
									id="Residence_details">Residence Address</td>
								</tr>
								<tr width=100%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Flat Number</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 rowspan=11>
										<textarea style="width: 100%;" rows="11" cols="10"  id="resiadd_exis" name="resiadd_exis" readonly disabled=true "></textarea>
									</td>	
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >Building Name</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >Street Name</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >Residence Type</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >Landmark</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >Zip Code</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >PO Box</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >Emirates/City</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >State</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >Country</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >Years in Current Address</td>
								</tr>				
								<tr width=100%>
									<td  nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=4 
									id="office_details">Office Address</td>
								</tr>				
								<tr width=100%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Flat Number</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 rowspan=11>
										<textarea style="width: 100%;" rows="11" cols="10"  id="office_add_exis" name="office_add_exis" readonly disabled=true "></textarea>
									</td>	
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >Building Name</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >Street Name</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >Residence Type</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >Landmark</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >Zip Code</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >PO Box</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >Emirates/City</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >State</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >Country</td>
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2 >Years in Current Address</td>
								</tr>				
								
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>Preferred Address</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:pref_add_exis" size="35" maxlength = '100' id="wdesk:pref_add_exis"  readonly disabled=true class="sizeofbox">
									</td>
								</tr>				
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>Primary Email ID</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>
									<input type="text" name="wdesk:prim_email_exis" size="35" maxlength = '100' id="wdesk:prim_email_exis"  readonly disabled=true class="sizeofbox"  value = ''>
									</td>
								</tr>				
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>Secondary Email ID</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:sec_email_exis" size="35" maxlength = '100' id="wdesk:sec_email_exis"  readonly disabled=true class="sizeofbox"  value = ''>
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>Preferred Email ID Type</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:pref_email_exis" size="35" maxlength = '100' id="wdesk:pref_email_exis"  readonly disabled=true class="sizeofbox" value = ''>
									</td>
								</tr>
								
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>E-Statement Registered</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:E_Stmnt_regstrd_exis" size="35" maxlength = '100' id="wdesk:E_Stmnt_regstrd_exis"  readonly disabled=true class="sizeofbox"  value = ''>
									</td>
								</tr>				
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>Mobile Phone</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>
									<input type="text" name="wdesk:MobilePhone_Existing" size="35" id="wdesk:MobilePhone_Existing"  readonly disabled=true class="sizeofbox"  value = ''>
									</td>					 
								</tr>
								
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>Mobile Phone 2</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:sec_mob_phone_exis" size="35" id="wdesk:sec_mob_phone_exis"  readonly disabled=true class="sizeofbox" value = ''>
									</td>                   
								</tr>
								
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>Home Phone</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:homephone_exis" size="35" maxlength = '100' id="wdesk:homephone_exis"  readonly disabled=true class="sizeofbox"  value = ''>
									</td>
								</tr>				
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>Office Phone</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:office_phn_exis" size="35" maxlength = '100' id="wdesk:office_phn_exis"  readonly disabled=true class="sizeofbox"  value = ''>
									</td>					
								</tr>
								
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>Fax</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:fax_exis" size="35" maxlength = '100' id="wdesk:fax_exis"  readonly disabled=true class="sizeofbox"  value = ''>
									</td>
								</tr>
								
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>Home Country Phone</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:homecntryphone_exis" size="35" maxlength = '100' id="wdesk:homecntryphone_exis"  readonly disabled=true class="sizeofbox"  value = ''>
									</td>
								</tr>
								
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>Preferred Contact</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:pref_contact_exis" size="35" maxlength = '100' id="wdesk:pref_contact_exis"  readonly disabled=true class="sizeofbox" value = ''>
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2 id="employment_details"><b><font color="#FF4747">Employment Details</font></b></td>
									<td style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 " colspan=2><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"></td>					  
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>Employment Type</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:emp_type_exis" size="35" id="wdesk:emp_type_exis"  readonly disabled=true class="sizeofbox" >
									</td>                       
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>Designation</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:designation_exis" size="35" maxlength = '100' id="wdesk:designation_exis"  readonly disabled=true class="sizeofbox" >
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>Company Name</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:comp_name_exis" size="35" maxlength = '100' id="wdesk:comp_name_exis"  readonly disabled=true class="sizeofbox">
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Name of Employer</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:emp_name_exis" size="35" maxlength = '100' id="wdesk:emp_name_exis"  readonly disabled=true class="sizeofbox" >
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Department</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:department_exis" size="35" maxlength = '100' id="wdesk:department_exis"  readonly disabled=true class="sizeofbox">
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Employee Number</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:employee_num_exis" size="35" maxlength = '100' id="wdesk:employee_num_exis"  readonly disabled=true class="sizeofbox">
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Occupation</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:occupation_exist" size="35" maxlength = '100' id="wdesk:occupation_exist"  readonly disabled=true class="sizeofbox" >
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Nature of Business</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text"  
				 name="wdesk:name_of_business_exis" size="35" maxlength = '100' id="wdesk:name_of_business_exis"  readonly disabled=true class="sizeofbox" >
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Industry Segment</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:IndustrySegment_exis"  maxlength='100' size="35" id="wdesk:IndustrySegment_exis"  readonly disabled=true class="sizeofbox">
									</td>
								</tr>				
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Industry Sub-Segment</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:IndustrySubSegment_exis"  maxlength='100' size="35" id="wdesk:IndustrySubSegment_exis"  readonly disabled=true class="sizeofbox">
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Customer Type</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:CustomerType_exis"  maxlength='100' size="35" id="wdesk:CustomerType_exis"  readonly disabled=true class="sizeofbox">
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Dealing With Countries</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:DealwithCont_exis"  maxlength='100' size="35" id="wdesk:DealwithCont_exis"  readonly disabled=true class="sizeofbox">
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Total years of Employment</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:total_year_of_emp_exis" size="35" maxlength = '100' id="wdesk:total_year_of_emp_exis"  readonly disabled=true class="sizeofbox">
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Years since in Business</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:years_of_business_exis" size="35" maxlength = '100' id="wdesk:years_of_business_exis"  readonly disabled=true class="sizeofbox">
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Employment Status</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:employment_status_exis"  maxlength='100' size="35" id="wdesk:employment_status_exis"  readonly disabled=true class="sizeofbox">
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Date of Joining Current Employer</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:date_join_curr_employer_exis" size="35" maxlength = '20' id="wdesk:date_join_curr_employer_exis"  readonly disabled=true class="sizeofbox">
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Marital Status</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:marrital_status_exis" size="35" maxlength = '100' id="wdesk:marrital_status_exis"  readonly disabled=true class="sizeofbox" >
									</td>
								</tr>				
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Number of Dependents</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:no_of_dependents_exis" size="35" maxlength = '100' id="wdesk:no_of_dependents_exis"  readonly disabled=true class="sizeofbox" >
									</td>
								</tr>				
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Country of Residence</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:country_of_res_exis" size="35" maxlength = '100' id="wdesk:country_of_res_exis"  readonly disabled=true class="sizeofbox">
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Nationality</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:nation_exist" size="35" maxlength = '100' id="wdesk:nation_exist"  readonly disabled=true class="sizeofbox">
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>Since when in UAE</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:wheninuae_exis" size="35" maxlength = '100' id="wdesk:wheninuae_exis"  readonly disabled=true class="sizeofbox" >
									</td>					  
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2 id="employment_details"><b><font color="#FF4747">Previous Employment Details</font></b></td>
									<td style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 " colspan=2><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"></td>					  
								</tr>				
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>Previous Organization In UAE</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:prev_organ_exis" size="35" maxlength = '100' id="wdesk:prev_organ_exis"  readonly disabled=true class="sizeofbox" >
									</td>					 
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan=2>Period Of Employment In The Previous Organization</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2><input type="text" name="wdesk:period_organ_exis" size="35" maxlength = '100' id="wdesk:period_organ_exis"  readonly disabled=true class="sizeofbox" >
									</td>					  
								</tr>
								<tr>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=4>
										<!--<input type="button" onclick="getSignature(this);" id="viewSign" value="View Signatures"> -->
									</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
				<input type="hidden" name="radioChecked" id="radioChecked" value="N">
				<input type='hidden' name="Process_Name" id="Process_Name" value='CU' >
				<input type="hidden" name="main_grid" id="main_grid">
				<input type="hidden" name="wdesk:Updated_CIFNumber" id="wdesk:Updated_CIFNumber" value=''>
				<input type="hidden" name="wdesk:Decision" id="wdesk:Decision" value=''>
			    <input type="hidden" name="wdesk:PBOdecision" id="wdesk:PBOdecision"  value='Approve' >			
				<input type="hidden" name="wdesk:SelectedCIF" id="wdesk:SelectedCIF" value='Yes'>
				<input type="hidden" name="wdesk:isPBOCase" id="wdesk:isPBOCase" value='Yes'>
				<input type='hidden' name="wdesk:WI_NAME" id="wdesk:WI_NAME" value='' >
				<input type='hidden' name="wdesk:WS_NAME" id="wdesk:WS_NAME" value='PBO' />					
				<input type="hidden" name="wdesk:CIF_Type" id="wdesk:CIF_Type" value=''>
				<input type="hidden" name="wdesk:Acc_Number_received" id="wdesk:Acc_Number_received" value="">
				<div class="accordion-group">
					<div class="accordion-heading">
						<h4 class="panel-title">
							<b style="COLOR: white;">Decision</b>
						</h4>
					</div>
					<div id="panel22" class="accordion-body collapse in">
						<div class="accordion-inner">
							<table border='1' cellspacing='1' cellpadding='0' width=100% >
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' width="20%"><b>Decision</b></td> 
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select id="PBOdecision" name="PBOdecision" style="width: 219px;" onchange="changeVal(this,'PBO')">
											<option value="--Select--">--Select--</option>
											<option value="Approve" selected>Approve</option>
										</select>
									</td>
								</tr>
								<tr width=100%>
									<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' width="20%">Remarks</td>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<textarea class='EWNormalGreenGeneral1' style="width: 100%;" rows="3" cols="50" id="wdesk:remarks" name="wdesk:remarks"></textarea>
									</td>										
								</tr>
								<tr width=100% >
									<td colspan=4>&nbsp;</td>										
								</tr>
							</table>
						</div>
					</div>
				</div>
			</div>	
		</form>		
		<script language="JavaScript" src="/CU/webtop/scripts/calendar_SRM.js"></script>				
	</body>
</html>