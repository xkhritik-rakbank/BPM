/*----------------------------------------------------------------------------------------------------------------------------------------

NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group                         :           Application –Projects
Project/Product         	  :           RAKBank eForms Phase-I
Application                   : 
Module                        :           Request-Submission 
File Name                     : 		  clientCU.js
Author                        :           Shamily
Date (dd/mm/yyyy)             :           06-Sept-2016 
Description                   :           
---------------------------------------------------------------------------------------------------------------------------------------

CHANGE HISTORY

---------------------------------------------------------------------------------------------------------------------------------------
Problem No/CR No              Change Date            Changed By             Change Description
--------------------------------------------------------------------------------------------------------------------------------------*/


/*
client<ProcessName>.js  for CU process
*/

window.document.write("<script src=\"/CU/webtop/scripts/CU_Scripts/moment.js\"></script>");
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Tanshu
//Description                 :           To validate form on the click of save

//***********************************************************************************//	
function SaveClick()
{
	if(typeof strprocessname!="undefined" && (strprocessname=='CU'))
	{
		var customform='';
		var formWindow = getWindowHandler(windowList,"formGrid");
		customform = formWindow.frames['customform'];
		
		if(customform.document.getElementById("wdesk:CIFReq_Type").value.indexOf("Personal Name Change") > 0   ||   customform.document.getElementById("wdesk:CIFReq_Type").value.indexOf("Nationality Change") > 0)
		{
			customform.document.getElementById("wdesk:world_check_req").value = "Yes";
		}
		var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
		var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
		var signature_update=customform.document.getElementById("signature_update").value;
		var dormancy_activation=customform.document.getElementById("dormancy_activation").value;
		var sole_to_joint=customform.document.getElementById("sole_to_joint").value;
		var joint_to_sole=customform.document.getElementById("joint_to_sole").value;
		
		var phone1=customform.document.getElementById("phone1").value;
		if(WSNAME!='PBO')
		{
			var phone1CCode=customform.document.getElementById("wdesk:MobilePhone_New1").value;
			var phone1Number=customform.document.getElementById("wdesk:MobilePhone_New").value;
			var phone1Ext=customform.document.getElementById("wdesk:MobilePhone_New2").value;
			var phone2=customform.document.getElementById("phone2").value;
			var phone2CCode=customform.document.getElementById("wdesk:sec_mob_phone_newC").value;
			var phone2Number=customform.document.getElementById("wdesk:sec_mob_phone_newN").value;
			var phone2Ext=customform.document.getElementById("wdesk:sec_mob_phone_newE").value;
			var phone3=customform.document.getElementById("HomePhone").value;
			var phone3CCode=customform.document.getElementById("wdesk:homephone_newC").value;
			var phone3Number=customform.document.getElementById("wdesk:homephone_newN").value;
			var phone3Ext=customform.document.getElementById("wdesk:homephone_newE").value;
			var phone4=customform.document.getElementById("OfficePhone").value;
			var phone4CCode=customform.document.getElementById("wdesk:office_phn_newC").value;
			var phone4Number=customform.document.getElementById("wdesk:office_phn_new").value;
			var phone4Ext=customform.document.getElementById("wdesk:office_phn_newE").value;
			var phone5=customform.document.getElementById("HomeCountryPhone").value;
			var phone5CCode=customform.document.getElementById("wdesk:homecntryphone_newC").value;
			var phone5Number=customform.document.getElementById("wdesk:homecntryphone_newN").value;
			var phone5Ext=customform.document.getElementById("wdesk:homecntryphone_newE").value;
			var phone6=customform.document.getElementById("Fax").value;
			var phone6CCode=customform.document.getElementById("wdesk:fax_newC").value;
			var phone6Number=customform.document.getElementById("wdesk:fax_new").value;
			var phone6Ext=customform.document.getElementById("wdesk:fax_newE").value;
			var primaryemail=customform.document.getElementById("primaryemail").value;
			var primaryemailvalue=customform.document.getElementById("wdesk:primary_emailid_new").value;
			var secondaryemail=customform.document.getElementById("secondaryemail").value;
			var secondaryemailvalue=customform.document.getElementById("wdesk:sec_email_new").value;
			var doc_emiratesid=customform.document.getElementById("doc_emiratesid").value;
			var emiratesid_new=customform.document.getElementById("wdesk:emiratesid_new").value;
			var emiratesidexp_new=customform.document.getElementById("wdesk:emiratesidexp_new").value;
			var doc_passport=customform.document.getElementById("doc_passport").value;
			var passport_num_new=customform.document.getElementById("wdesk:PassportNumber_New").value;
			var passportExpDate_new=customform.document.getElementById("wdesk:passportExpDate_new").value;
			var doc_visa=customform.document.getElementById("doc_visa").value;
			var visa_new=customform.document.getElementById("wdesk:visa_new").value;
			var visaExpDate_new=customform.document.getElementById("wdesk:visaExpDate_new").value;
			var reqtype=customform.document.getElementById("wdesk:Request_Type_Master").value;
			var requesttype=customform.document.getElementById("wdesk:CIFReq_Type").value;
			var residence_address=customform.document.getElementById("residence_address").value;
			var resi_line1=customform.document.getElementById("wdesk:resi_line1").value;
			var resi_line2=customform.document.getElementById("wdesk:resi_line2").value;
			var resi_line3=customform.document.getElementById("wdesk:resi_line3").value;
			var resi_line4=customform.document.getElementById("wdesk:resi_line4").value;
			var resi_restype=customform.document.getElementById("wdesk:resi_restype").value;
			var resi_pobox=customform.document.getElementById("wdesk:resi_pobox").value;
			var resi_zipcode=customform.document.getElementById("wdesk:resi_zipcode").value;
			var resi_state=customform.document.getElementById("wdesk:resi_state").value;
			var resi_city=customform.document.getElementById("wdesk:resi_city").value;
			var resi_cntrycode=customform.document.getElementById("wdesk:resi_cntrycode").value;
			var office_address=customform.document.getElementById("office_address").value;
			var office_line1=customform.document.getElementById("wdesk:office_line1").value;
			var office_line2=customform.document.getElementById("wdesk:office_line2").value;
			var office_line3=customform.document.getElementById("wdesk:office_line3").value;
			var office_line4=customform.document.getElementById("wdesk:office_line4").value;
			var office_restype=customform.document.getElementById("wdesk:office_restype").value;
			var office_pobox=customform.document.getElementById("wdesk:office_pobox").value;
			var office_zipcode=customform.document.getElementById("wdesk:office_zipcode").value;
			var office_state=customform.document.getElementById("wdesk:office_state").value;
			var office_city=customform.document.getElementById("wdesk:office_city").value;
			var office_cntrycode=customform.document.getElementById("wdesk:office_cntrycode").value;
		}
					 
		if(CUSAVEGRID(false,WINAME,WSNAME,signature_update,dormancy_activation,sole_to_joint,joint_to_sole))
		{
			if (WSNAME == "CSO" || WSNAME == "CSO_Rejects")
			{   
				var temp = "";
				var str = "";
				temp = phone1.indexOf("<PhnCountryCode>") + "<PhnCountryCode>".length;
				str = phone1.substring(temp, phone1.indexOf("</PhnCountryCode>"));
				if (str == "")
					phone1 = insert(phone1, temp, phone1CCode);
				temp = phone1.indexOf("<PhoneNo>") + "<PhoneNo>".length;
				str = phone1.substring(temp, phone1.indexOf("</PhoneNo>"));
				if (str == "")
					phone1 = insert(phone1, temp, phone1Number);
				temp = phone1.indexOf("<PhnExtn>") + "<PhnExtn>".length;
				str = phone1.substring(temp, phone1.indexOf("</PhnExtn>"));
				if (str == "")
					phone1 = insert(phone1, temp, phone1Ext);

				customform.document.getElementById("phone1").value = phone1;

				temp = phone2.indexOf("<PhnCountryCode>") + "<PhnCountryCode>".length;
				str = phone2.substring(temp, phone2.indexOf("</PhnCountryCode>"));
				if (str == "")
					phone2 = insert(phone2, temp, phone2CCode);
				temp = phone2.indexOf("<PhoneNo>") + "<PhoneNo>".length;
				str = phone2.substring(temp, phone2.indexOf("</PhoneNo>"));
				if (str == "")
					phone2 = insert(phone2, temp, phone2Number);
				temp = phone2.indexOf("<PhnExtn>") + "<PhnExtn>".length;
				str = phone2.substring(temp, phone2.indexOf("</PhnExtn>"));
				if (str == "")
					phone2 = insert(phone2, temp, phone2Ext);

				customform.document.getElementById("phone2").value = phone2;

				temp = phone3.indexOf("<PhnCountryCode>") + "<PhnCountryCode>".length;
				str = phone3.substring(temp, phone3.indexOf("</PhnCountryCode>"));
				if (str == "")
					phone3 = insert(phone3, temp, phone3CCode);
				temp = phone3.indexOf("<PhoneNo>") + "<PhoneNo>".length;
				str = phone3.substring(temp, phone3.indexOf("</PhoneNo>"));
				if (str == "")
					phone3 = insert(phone3, temp, phone3Number);
				temp = phone3.indexOf("<PhnExtn>") + "<PhnExtn>".length;
				str = phone3.substring(temp, phone3.indexOf("</PhnExtn>"));
				if (str == "")
					phone3 = insert(phone3, temp, phone3Ext);

				customform.document.getElementById("HomePhone").value = phone3;

				temp = phone4.indexOf("<PhnCountryCode>") + "<PhnCountryCode>".length;
				str = phone4.substring(temp, phone4.indexOf("</PhnCountryCode>"));
				if (str == "")
					phone4 = insert(phone4, temp, phone4CCode);
				temp = phone4.indexOf("<PhoneNo>") + "<PhoneNo>".length;
				str = phone4.substring(temp, phone4.indexOf("</PhoneNo>"));
				if (str == "")
					phone4 = insert(phone4, temp, phone4Number);
				temp = phone4.indexOf("<PhnExtn>") + "<PhnExtn>".length;
				str = phone4.substring(temp, phone4.indexOf("</PhnExtn>"));
				if (str == "")
					phone4 = insert(phone4, temp, phone4Ext);

				customform.document.getElementById("OfficePhone").value = phone4;

				temp = phone5.indexOf("<PhnCountryCode>") + "<PhnCountryCode>".length;
				str = phone5.substring(temp, phone5.indexOf("</PhnCountryCode>"));
				if (str == "")
					phone5 = insert(phone5, temp, phone5CCode);
				temp = phone5.indexOf("<PhoneNo>") + "<PhoneNo>".length;
				str = phone5.substring(temp, phone5.indexOf("</PhoneNo>"));
				if (str == "")
					phone5 = insert(phone5, temp, phone5Number);
				temp = phone5.indexOf("<PhnExtn>") + "<PhnExtn>".length;
				str = phone5.substring(temp, phone5.indexOf("</PhnExtn>"));
				if (str == "")
					phone5 = insert(phone5, temp, phone5Ext);

				customform.document.getElementById("HomeCountryPhone").value = phone5;

				temp = phone6.indexOf("<PhnCountryCode>") + "<PhnCountryCode>".length;
				str = phone6.substring(temp, phone6.indexOf("</PhnCountryCode>"));
				if (str == "")
					phone6 = insert(phone6, temp, phone6CCode);
				temp = phone6.indexOf("<PhoneNo>") + "<PhoneNo>".length;
				str = phone6.substring(temp, phone6.indexOf("</PhoneNo>"));
				if (str == "")
					phone6 = insert(phone6, temp, phone6Number);
				temp = phone6.indexOf("<PhnExtn>") + "<PhnExtn>".length;
				str = phone6.substring(temp, phone6.indexOf("</PhnExtn>"));
				if (str == "")
					phone6 = insert(phone6, temp, phone6Ext);

				customform.document.getElementById("Fax").value = phone6;


				// Email ------------------------------------------------------------------

				temp = primaryemail.indexOf("<EmailID>") + "<EmailID>".length;
				str = primaryemail.substring(temp, primaryemail.indexOf("</EmailID>"));
				if (str == "")
					primaryemail = insert(primaryemail, temp, primaryemailvalue);

				customform.document.getElementById("primaryemail").value = primaryemail;

				temp = secondaryemail.indexOf("<EmailID>") + "<EmailID>".length;
				str = secondaryemail.substring(temp, secondaryemail.indexOf("</EmailID>"));
				if (str == "")
					secondaryemail = insert(secondaryemail, temp, secondaryemailvalue);

				customform.document.getElementById("secondaryemail").value = secondaryemail;

				temp = doc_emiratesid.indexOf("<DocId>") + "<DocId>".length;
				str = doc_emiratesid.substring(temp, doc_emiratesid.indexOf("</DocId>"));
				if (str == "")
					doc_emiratesid = insert(doc_emiratesid, temp, emiratesid_new);

				temp = doc_emiratesid.indexOf("<DocExpDt>") + "<DocExpDt>".length;
				str = doc_emiratesid.substring(temp, doc_emiratesid.indexOf("</DocExpDt>"));
				if (str == "")
					doc_emiratesid = insert(doc_emiratesid, temp, emiratesidexp_new);

				customform.document.getElementById("doc_emiratesid").value = doc_emiratesid;

				temp = doc_passport.indexOf("<DocId>") + "<DocId>".length;
				str = doc_passport.substring(temp, doc_passport.indexOf("</DocId>"));
				if (str == "")
					doc_passport = insert(doc_passport, temp, passport_num_new);

				temp = doc_passport.indexOf("<DocExpDt>") + "<DocExpDt>".length;
				str = doc_passport.substring(temp, doc_passport.indexOf("</DocExpDt>"));
				if (str == "")
					doc_passport = insert(doc_passport, temp, passportExpDate_new);

				customform.document.getElementById("doc_passport").value = doc_passport;

				temp = doc_visa.indexOf("<DocId>") + "<DocId>".length;
				str = doc_visa.substring(temp, doc_visa.indexOf("</DocId>"));
				if (str == "")
					doc_visa = insert(doc_visa, temp, visa_new);

				temp = doc_visa.indexOf("<DocExpDt>") + "<DocExpDt>".length;
				str = doc_visa.substring(temp, doc_visa.indexOf("</DocExpDt>"));
				if (str == "")
					doc_visa = insert(doc_visa, temp, visaExpDate_new);

				customform.document.getElementById("doc_visa").value = doc_visa;

				temp = residence_address.indexOf("<AddrLine1>") + "<AddrLine1>".length;
				str = residence_address.substring(temp, residence_address.indexOf("</AddrLine1>"));
				if (str == "")
					residence_address = insert(residence_address, temp, resi_line1);

				temp = residence_address.indexOf("<AddrLine2>") + "<AddrLine2>".length;
				str = residence_address.substring(temp, residence_address.indexOf("</AddrLine2>"));
				if (str == "")
					residence_address = insert(residence_address, temp, resi_line2);

				temp = residence_address.indexOf("<AddrLine3>") + "<AddrLine3>".length;
				str = residence_address.substring(temp, residence_address.indexOf("</AddrLine3>"));
				if (str == "")
					residence_address = insert(residence_address, temp, resi_line3);

				temp = residence_address.indexOf("<AddrLine4>") + "<AddrLine4>".length;
				str = residence_address.substring(temp, residence_address.indexOf("</AddrLine4>"));
				if (str == "")
					residence_address = insert(residence_address, temp, resi_line4);
			   
				temp = residence_address.indexOf("<ResType>") + "<ResType>".length;
				str = residence_address.substring(temp, residence_address.indexOf("</ResType>"));
				if (str == "")
					residence_address = insert(residence_address, temp, resi_restype);

				temp = residence_address.indexOf("<POBox>") + "<POBox>".length;
				str = residence_address.substring(temp, residence_address.indexOf("</POBox>"));
				if (str == "")
					residence_address = insert(residence_address, temp, resi_pobox);

				temp = residence_address.indexOf("<ZipCode>") + "<ZipCode>".length;
				str = residence_address.substring(temp, residence_address.indexOf("</ZipCode>"));
				if (str == "")
					residence_address = insert(residence_address, temp, resi_zipcode);

				temp = residence_address.indexOf("<State>") + "<State>".length;
				str = residence_address.substring(temp, residence_address.indexOf("</State>"));
				if (str == "")
					residence_address = insert(residence_address, temp, resi_state);

				temp = residence_address.indexOf("<City>") + "<City>".length;
				str = residence_address.substring(temp, residence_address.indexOf("</City>"));
				if (str == "")
					residence_address = insert(residence_address, temp, resi_city);

				temp = residence_address.indexOf("<CountryCode>") + "<CountryCode>".length;
				str = residence_address.substring(temp, residence_address.indexOf("</CountryCode>"));
				if (str == "")
					residence_address = insert(residence_address, temp, resi_cntrycode);

				customform.document.getElementById("residence_address").value = residence_address;

				temp = office_address.indexOf("<AddrLine1>") + "<AddrLine1>".length;
				str = office_address.substring(temp, office_address.indexOf("</AddrLine1>"));
				if (str == "")
					office_address = insert(office_address, temp, office_line1);

				temp = office_address.indexOf("<AddrLine2>") + "<AddrLine2>".length;
				str = office_address.substring(temp, office_address.indexOf("</AddrLine2>"));
				if (str == "")
					office_address = insert(office_address, temp, office_line2);

				temp = office_address.indexOf("<AddrLine3>") + "<AddrLine3>".length;
				str = office_address.substring(temp, office_address.indexOf("</AddrLine3>"));
				if (str == "")
					office_address = insert(office_address, temp, office_line3);

				temp = office_address.indexOf("<AddrLine4>") + "<AddrLine4>".length;
				str = office_address.substring(temp, office_address.indexOf("</AddrLine4>"));
				if (str == "")
					office_address = insert(office_address, temp, office_line4);
			   
				temp = office_address.indexOf("<ResType>") + "<ResType>".length;
				str = office_address.substring(temp, office_address.indexOf("</ResType>"));
				if (str == "")
					office_address = insert(office_address, temp, office_restype);

				temp = office_address.indexOf("<POBox>") + "<POBox>".length;
				str = office_address.substring(temp, office_address.indexOf("</POBox>"));
				if (str == "")
					office_address = insert(office_address, temp, office_pobox);

				temp = office_address.indexOf("<ZipCode>") + "<ZipCode>".length;
				str = office_address.substring(temp, office_address.indexOf("</ZipCode>"));
				if (str == "")
					office_address = insert(office_address, temp, office_zipcode);

				temp = office_address.indexOf("<State>") + "<State>".length;
				str = office_address.substring(temp, office_address.indexOf("</State>"));
				if (str == "")
					office_address = insert(office_address, temp, office_state);

				temp = office_address.indexOf("<City>") + "<City>".length;
				str = office_address.substring(temp, office_address.indexOf("</City>"));
				if (str == "")
					office_address = insert(office_address, temp, office_city);

				temp = office_address.indexOf("<CountryCode>") + "<CountryCode>".length;
				str = office_address.substring(temp, office_address.indexOf("</CountryCode>"));
				if (str == "")
					office_address = insert(office_address, temp, office_cntrycode);

				customform.document.getElementById("office_address").value = office_address;				
				
				return true;					 
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}

    }	
}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Tanshu
//Description                 :           To validate form on the click of introduce

//***********************************************************************************//	
function IntroduceClick()
{
	var customform='';
	var formWindow=getWindowHandler(windowList,"formGrid");
	customform=formWindow.frames['customform'];

	if(strprocessname=='CU')
	{    
		var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
        if (validateDatepassportexpiryCheck(WSNAME))
        {
            if(mainValidation(WSNAME))
            { 
                 if(WSNAME =="CSO" && (customform.document.getElementById("decision").value=="Reject"||customform.document.getElementById("decision").value=="Follow-Up"))
                 {
					if((WSNAME == 'CSO' && customform.document.getElementById("decision").value=='Reject'))
					{
						sendSMSToCustomer(customform);
					}
					alert("The request has been submitted successfully.");
					return true;
                 }else{
                    if(CUDONEWI(WSNAME))
                    {
                        if(CUSAVEDATA(false))
                        {
							 if((WSNAME == 'CSO' && customform.document.getElementById("decision").value=='Approved') || (WSNAME == 'PBO' && customform.document.getElementById("PBOdecision").value=='Approve')|| (WSNAME == 'Hold' && customform.document.getElementById("Dec_Hold").value=='Close')|| (WSNAME == 'OPS%20Maker_DE' && (customform.document.getElementById("OPSMakerDEDecision").value=='Reject' || customform.document.getElementById("wdesk:OPSMakerDEDecision").value=='Reject') && customform.document.getElementById("wdesk:Channel").value == 'Phone banking'))
							{
								sendSMSToCustomer(customform);
							}
							
							if(customform.document.getElementById("wdesk:prefOfLanguage").value=='--Select--'){
								
								alert("Kindly select any value for Preference of Language.");
								return false;
								
							}
							
                            alert("The request has been submitted successfully.");
							return true;
                        }
                        else
                        {
                            return false;
                        }                    
                    }
                    else
                    {   
                        return false;
                    }
                }
            }
            else
            {    
                return false;
            }
        }
        else
        {    
            return false;
        }
		
		return true;
	}
}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Tanshu
//Description                 :           To validate form on the click of DONE

//***********************************************************************************//	
function DoneClick()
{	
	if(typeof strprocessname!="undefined" && (strprocessname=='CU'))
	{	
		var customform='';
		var formWindow=getWindowHandler(windowList,"formGrid");
		customform=formWindow.frames['customform'];		
		var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
		
		if(CUDONEWI(WSNAME))
		{
			if(decisionvalidation(WSNAME))
			{
				if(CUSAVEDATA(false))
				{
					if((WSNAME == 'Hold' && customform.document.getElementById("Dec_Hold").value=='Close')|| (WSNAME == 'OPS%20Maker_DE' && (customform.document.getElementById("OPSMakerDEDecision").value=='Reject' || customform.document.getElementById("wdesk:OPSMakerDEDecision").value=='Reject') && customform.document.getElementById("wdesk:Channel").value == 'Phone banking'))
					{
						sendSMSToCustomer(customform);
					}
					
					// added below for Mail Schedule report added on 11062018 by Angad
					if (WSNAME == 'OPS_Checker_Review')
					{
						var d = new Date();
						var today = formatDate(d,5);
						customform.document.getElementById("wdesk:ProcessedDateAtChecker").value = today;						
					} 
			
					return true;
				
				}	
				else
					return false;
			}
			else
				return false;
		}
		else
			return false;
    }
	else
		return true;
}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Tanshu
//Description                 :           To validate form for OPS%20Maker_DE and CSO workstep.

//***********************************************************************************//	
function CUDONEWI(WSNAME) {

    if ((WSNAME == "CSO" && customform.document.getElementById('wdesk:Channel').value == "Customer Initiated") || (WSNAME == "OPS%20Maker_DE") || (WSNAME == "CSO_Rejects" && customform.document.getElementById('wdesk:Channel').value == "Customer Initiated")) {
	
		if (WSNAME == "OPS%20Maker_DE") {
			if (customform.document.getElementById("OPSMakerDEDecision").value != "Reject") {
				if (customform.document.getElementById("wdesk:CIFReq_Type").value == "")
				{
					alert("Please amend the CIF details or select any Request Type");
					customform.document.getElementById("wdesk:FirstName_New").focus();
					return false;
				}
			} else {
				return true;
			}
		} else if (WSNAME == "CSO") {
	
			if (customform.document.getElementById("wdesk:CIFReq_Type").value == "")
			{
				alert("Please amend the CIF details or select any Request Type");
				customform.document.getElementById("wdesk:FirstName_New").focus();
				return false;
			}
		}
		
		else if (WSNAME == "CSO_Rejects") {
	
			if (customform.document.getElementById("wdesk:CIFReq_Type").value == "")
			{
				alert("Please amend the CIF details or select any Request Type");
				customform.document.getElementById("wdesk:FirstName_New").focus();
				return false;
			}
		}
		//Badri Address field Special Character
		var Addressline1 = customform.document.getElementById("wdesk:resi_line1").value;
		var Addressline2 = customform.document.getElementById("wdesk:resi_line2").value;
		var Addressline3 = customform.document.getElementById("wdesk:resi_line3").value;
		var Addressline4 = customform.document.getElementById("wdesk:resi_line4").value;
		var Zipcode = customform.document.getElementById("wdesk:resi_zipcode").value;
		var PoBox = customform.document.getElementById("wdesk:resi_pobox").value;
		var Addressline_off = customform.document.getElementById("wdesk:office_line1").value;
		var Addressline2_off = customform.document.getElementById("wdesk:office_line2").value;
		var Addressline3_off = customform.document.getElementById("wdesk:office_line3").value;
		var Addressline4_off = customform.document.getElementById("wdesk:office_line4").value;
		var Zipcode_off = customform.document.getElementById("wdesk:office_zipcode").value;
		var PoBox_off = customform.document.getElementById("wdesk:office_pobox").value;
		
			if(Addressline1 != null)
			{
				if (validateKeys(Addressline1,'alphanumeric_address')== false ){
					customform.document.getElementById("wdesk:resi_line1").focus();
					return false;
				}
			}
			if(Addressline2 != null)
			{
				if (validateKeys(Addressline2,'alphanumeric_address')== false ){
					customform.document.getElementById("wdesk:resi_line2").focus();
					return false;
				}
			}	
			if(Addressline3 != null)
			{
				if (validateKeys(Addressline3,'alphanumeric_address')== false ){
					customform.document.getElementById("wdesk:resi_line3").focus();
					return false;
				}
			}	
			if(Addressline4 != null)
			{
				if (validateKeys(Addressline4,'alphanumeric_address')== false ){
					customform.document.getElementById("wdesk:resi_line4").focus();
					return false;
				}
			}	
			if(Zipcode != null)
			{
				if (validateKeys(Zipcode,'alphanumeric_address')== false ){
					customform.document.getElementById("wdesk:resi_zipcode").focus();
					return false;
				}
			}	
			if(PoBox != null)
			{
				if (validateKeys(PoBox,'alphanumeric_address')== false ){
					customform.document.getElementById("wdesk:resi_pobox").focus();
					return false;
				}
			}	
			
			if(Addressline_off != null)
			{
				if (validateKeys(Addressline_off,'alphanumeric_address')== false ){
					customform.document.getElementById("wdesk:office_line1").focus();
					return false;
				}
			}
		
			if(Addressline2_off != null)
			{
				if (validateKeys(Addressline2_off,'alphanumeric_address')== false ){
					customform.document.getElementById("wdesk:office_line2").focus();
					return false;
				}
			}	
			if(Addressline3_off != null)
			{
				if (validateKeys(Addressline3_off,'alphanumeric_address')== false ){
					customform.document.getElementById("wdesk:office_line3").focus();
					return false;
				}
			}	
			if(Addressline4_off != null)
			{
				if (validateKeys(Addressline4_off,'alphanumeric_address')== false ){
					customform.document.getElementById("wdesk:office_line4").focus();
					return false;
				}
			}	
			if(Zipcode_off != null)
			{
				if (validateKeys(Zipcode_off,'alphanumeric_address')== false ){
					customform.document.getElementById("wdesk:office_zipcode").focus();
					return false;
				}
			}	
			if(PoBox_off != null)
			{
				if (validateKeys(PoBox_off,'alphanumeric_address')== false ){
					customform.document.getElementById("wdesk:office_pobox").focus();
					return false;
				}
			}	
			//-------------End----------------Badri Address field Special Character	
		
		//nikita Portport CR 11/8/16
		var passportNumber=customform.document.getElementById("wdesk:PassportNumber_New").value;
		var passportExpDate = customform.document.getElementById("wdesk:passportExpDate_new").value;
		if (passportNumber != null && passportNumber != "" ) 
		{
			if(passportExpDate==null || passportExpDate=="" )
			{
				alert("Please Enter the Passport Expiry date.");
				
				customform.document.getElementById("wdesk:passportExpDate_new").focus();
				return false;
			}
			else
			{
				var today = new Date();
				var arrStartDate3 = passportExpDate.split("/");
				var date3 = new Date(arrStartDate3[2], arrStartDate3[1] - 1, arrStartDate3[0]);
				var timeDiffPassport = date3.getTime() - today.getTime();
				if (timeDiffPassport < 0) {
					alert("Passport date has Expired WorkItem cannot be initiated.");
					return false;
				}
			}	
		}
		
		if(passportExpDate != '' && passportExpDate != null && (passportNumber == '' || passportNumber == null))
		{
			alert("Please enter new passport number");
			customform.document.getElementById("wdesk:PassportNumber_New").focus();
			return false;
		}
		
		// added below condition as when AECB existing is No then AECB new will be mandatory as part of JIRA SCRCIF-108, Earlier it was always mandatory
        if (customform.document.getElementById("wdesk:abcdelig_exis").value == "No") {
			if (customform.document.getElementById("abcdelig_new").value == "--Select--") {
				alert("Please select the AECB Eligible field");
				customform.document.getElementById("abcdelig_new").focus();
				return false;
			}
		}
		
		if (customform.document.getElementById("wdesk:nation_exist").value != "AE") {
			if ((customform.document.getElementById("wdesk:comp_name_new").value != "" && customform.document.getElementById("wdesk:comp_name_new").value != null) || (customform.document.getElementById("wdesk:emp_name_new").value != "" && customform.document.getElementById("wdesk:emp_name_new").value != null) || (customform.document.getElementById("occupation_new").value != "--Select--" && customform.document.getElementById("occupation_new").value != null && customform.document.getElementById("occupation_new").value != "") || (customform.document.getElementById("wdesk:naturebusiness_new").value != "" && customform.document.getElementById("wdesk:naturebusiness_new").value != null)) 
			{
				if (customform.document.getElementById("wdesk:visa_new").value == "") {
					alert("Visa is mandatory");
					customform.document.getElementById("wdesk:visa_new").focus();
					return false;
				}
				if (customform.document.getElementById("wdesk:visaExpDate_new").value == "") {
					alert("Visa Expiry Date is mandatory");
					customform.document.getElementById("wdesk:visaExpDate_new").focus();
					return false;
				}
				if (customform.document.getElementById("wdesk:visa_new").value != "" && customform.document.getElementById("wdesk:visaExpDate_new").value != "")
				{
					//alert("fields filled");
				} else {
					alert("Visa Number and Visa Expiry Date is mandatory to be filled");
					customform.document.getElementById("wdesk:visa_new").focus();
					return false;
				}
			}
		}	
		// JIRA SCRCIF-119
		if (customform.document.getElementById("wdesk:visaExpDate_new").value != "" && customform.document.getElementById("wdesk:visa_new").value =="" ) 
		{
                alert("Visa Number is mandatory if Visa Expiry Date is entered");
                customform.document.getElementById("wdesk:visa_new").focus();
                return false;
		}
			
        if (customform.document.getElementById("pref_email_new").value != "--Select--") 
		{
            if (customform.document.getElementById("pref_email_new").value == "Primary Email ID" && (customform.document.getElementById("wdesk:prim_email_exis").value == "" || customform.document.getElementById("wdesk:prim_email_exis").value == "")) {
                if (customform.document.getElementById("wdesk:primary_emailid_new").value == "") {
                    alert("Primary Email Id is mandatory to fill.");
                    customform.document.getElementById("wdesk:primary_emailid_new").focus();
                    return false;
                }
            }
            if (customform.document.getElementById("pref_email_new").value == "Secondary Email ID" && (customform.document.getElementById("wdesk:sec_email_exis").value == "" || customform.document.getElementById("wdesk:sec_email_exis").value == "")) {
                if (customform.document.getElementById("wdesk:sec_email_new").value == "") {
                    alert("Secondary Email Id is mandatory to fill.");
                    customform.document.getElementById("wdesk:sec_email_new").focus();
                    return false;
                }
            }
        }

        //for preferred address
		//modified by Shamily to make PO Box mandatory only for country_of_res_exis as "UAE"
        if (customform.document.getElementById("pref_add_new").value != "") {
            if (customform.document.getElementById("pref_add_new").value == "Office") {
			
			if(customform.document.getElementById("wdesk:country_of_res_exis").value == "AE" && customform.document.getElementById("wdesk:office_pobox").value == "")
			{
                if ( customform.document.getElementById("wdesk:office_city").value == "" && customform.document.getElementById("office_cntrycode").value == "" || customform.document.getElementById("office_cntrycode").value == "--Select--" || customform.document.getElementById("office_cntrycode").value == null) {
                     
                        alert("Office PO Box field,City and Country are mandatory to fill");
                        customform.document.getElementById("wdesk:office_pobox").focus();
                        return false;
                    }
					else if(customform.document.getElementById("wdesk:office_city").value == ""){
						alert("Office PO Box field,City field is mandatory to fill");
                        customform.document.getElementById("wdesk:office_city").focus();
                        return false;
					}else if(customform.document.getElementById("office_cntrycode").value == "" || customform.document.getElementById("office_cntrycode").value == "--Select--" || customform.document.getElementById("office_cntrycode").value == null){
						alert("Office Country field is mandatory to fill");
                        customform.document.getElementById("office_cntrycode").focus();
                        return false;
					}
					else{
						
						alert("Office PO Box field is mandatory to fill");
                        customform.document.getElementById("wdesk:office_pobox").focus();
                        return false;
					}
                }
				
				 if (customform.document.getElementById("wdesk:office_city").value == "") {
                    if (customform.document.getElementById("office_cntrycode").value == "" || customform.document.getElementById("office_cntrycode").value == "--Select--" || customform.document.getElementById("office_cntrycode").value == null) {
                        alert("Office City field and Country are mandatory to fill");
                        customform.document.getElementById("wdesk:office_city").focus();
                        return false;
                    }
					else{
						alert("Office City field is mandatory to fill");
                        customform.document.getElementById("wdesk:office_city").focus();
                        return false;
					}
                }else if (customform.document.getElementById("office_cntrycode").value == "" || customform.document.getElementById("office_cntrycode").value == "--Select--" || customform.document.getElementById("office_cntrycode").value == null) {
                    alert("Office Country field is mandatory to fill");
                    customform.document.getElementById("office_cntrycode").focus();
                    return false;
                }
            }
			//modified by Shamily to unselect resi_cntrycode when all other residence  fields are not entered
            if (customform.document.getElementById("pref_add_new").value == "Home") {
			
			/*if((customform.document.getElementById("wdesk:resi_line2").value == "" || customform.document.getElementById("wdesk:resi_line2").value == null) && (customform.document.getElementById("wdesk:resi_line1").value == "" || customform.document.getElementById("wdesk:resi_line1").value == null) && (customform.document.getElementById("wdesk:resi_line3").value == "" || customform.document.getElementById("wdesk:resi_line3").value == null) && (customform.document.getElementById("resi_restype").value == "" || customform.document.getElementById("resi_restype").value == "--Select--" || customform.document.getElementById("resi_restype").value == null) && (customform.document.getElementById("wdesk:resi_line4").value == "" || customform.document.getElementById("wdesk:resi_line4").value == null) && (customform.document.getElementById("wdesk:resi_zipcode").value == "" || customform.document.getElementById("wdesk:resi_zipcode").value == null) && (customform.document.getElementById("wdesk:resi_pobox").value == "" || customform.document.getElementById("wdesk:resi_pobox").value == null) || (customform.document.getElementById("resi_city").value == "" || customform.document.getElementById("resi_city").value == null) && (customform.document.getElementById("resi_state").value == "" || customform.document.getElementById("resi_state").value == null) && (customform.document.getElementById("resi_cntrycode").value != "" && customform.document.getElementById("resi_cntrycode").value != "--Select--" && customform.document.getElementById("resi_cntrycode").value != null))
			{
				customform.document.getElementById("resi_cntrycode").value = '--Select--';
				customform.document.getElementById("wdesk:resi_cntrycode").value = '';
			
			}*/
				//modified by Shamily to make PO Box mandatory only for country_of_res_exis as "UAE"
				if(customform.document.getElementById("wdesk:country_of_res_exis").value == "AE" && customform.document.getElementById("wdesk:resi_pobox").value == "" )
				{
					if ( customform.document.getElementById("wdesk:resi_city").value == "") {
                   
                        alert("Residence PO Box field and City are mandatory to fill");
                        customform.document.getElementById("wdesk:resi_pobox").focus();
                        return false;
                  
					}
					else{
						alert("Residence PO Box field and City are mandatory to fill");
                        customform.document.getElementById("wdesk:resi_pobox").focus();
                        return false;
					}
				  }			 
				  if (customform.document.getElementById("wdesk:resi_city").value == "") {
                    alert("Residence City field is mandatory to fill");
                    customform.document.getElementById("wdesk:resi_city").focus();
                    return false;
                }
				
            }
        }

        if ((customform.document.getElementById("wdesk:resi_line2").value != "" && customform.document.getElementById("wdesk:resi_line2").value != null) || (customform.document.getElementById("wdesk:resi_line1").value != "" && customform.document.getElementById("wdesk:resi_line1").value != null) || (customform.document.getElementById("wdesk:resi_line3").value != "" && customform.document.getElementById("wdesk:resi_line3").value != null) || (customform.document.getElementById("resi_restype").value != "" && customform.document.getElementById("resi_restype").value != "--Select--" && customform.document.getElementById("resi_restype").value != null) || (customform.document.getElementById("wdesk:resi_line4").value != "" && customform.document.getElementById("wdesk:resi_line4").value != null) || (customform.document.getElementById("wdesk:resi_zipcode").value != "" && customform.document.getElementById("wdesk:resi_zipcode").value != null) || (customform.document.getElementById("wdesk:resi_pobox").value != "" && customform.document.getElementById("wdesk:resi_pobox").value != null) || (customform.document.getElementById("wdesk:resi_city").value != "" && customform.document.getElementById("wdesk:resi_city").value != null) || (customform.document.getElementById("wdesk:resi_state").value != "" && customform.document.getElementById("wdesk:resi_state").value != null)) // resedence country check is removed as part of JIRA SCRCIF-121
		{
            if (customform.document.getElementById("wdesk:resi_line1").value == "") {
                alert('Please enter Residence Flat Number');
                customform.document.getElementById("wdesk:resi_line1").focus();
                return false;
            }
            if (customform.document.getElementById("wdesk:resi_city").value == "") {
                alert('Please enter Residence City');
                customform.document.getElementById("wdesk:resi_city").focus();
                return false;
            }
			/*if(customform.document.getElementById("resi_cntrycode").value == '--Select--' || customform.document.getElementById("resi_cntrycode").value == '')
			{
				customform.document.getElementById('resi_cntrycode').options[customform.document.getElementById('resi_cntrycode').selectedIndex].text=customform.document.getElementById("wdesk:resi_countryexis").value;
				document.getElementById('customform').contentWindow.showlabel('resi_country')
					//return false;
			}	*/
			//commented by Shamily to remove mandatory condition at resi_cntrycode
			//Uncommented as part of JIRA- BU-353
           if (customform.document.getElementById("wdesk:resi_countryexis").value == "--Select--"||customform.document.getElementById("wdesk:resi_countryexis").value == "") 
			{
				if(customform.document.getElementById("resi_cntrycode").value == "" || customform.document.getElementById("resi_cntrycode").value == "--Select--")
				{
                alert('Please enter Residence Country');
                customform.document.getElementById("resi_cntrycode").focus();
				customform.document.getElementById("resi_cntrycode").disabled = false;
                return false;
				}
            } 
        }
		
        if ((customform.document.getElementById("wdesk:office_line2").value != "" && customform.document.getElementById("wdesk:office_line2").value != null) || (customform.document.getElementById("wdesk:office_line1").value != "" && customform.document.getElementById("wdesk:office_line1").value != null) || (customform.document.getElementById("wdesk:office_line3").value != "" && customform.document.getElementById("wdesk:office_line3").value != null) || (customform.document.getElementById("office_restype").value != "" && customform.document.getElementById("office_restype").value != "--Select--" && customform.document.getElementById("office_restype").value != null) || (customform.document.getElementById("wdesk:office_line4").value != "" && customform.document.getElementById("wdesk:office_line4").value != null) || (customform.document.getElementById("wdesk:office_zipcode").value != "" && customform.document.getElementById("wdesk:office_zipcode").value != null) || (customform.document.getElementById("wdesk:office_pobox").value != "" && customform.document.getElementById("wdesk:office_pobox").value != null) || (customform.document.getElementById("wdesk:office_city").value != "" && customform.document.getElementById("wdesk:office_city").value != null) || (customform.document.getElementById("wdesk:office_state").value != "" && customform.document.getElementById("wdesk:office_state").value != null))  // office country check is removed as part of JIRA SCRCIF-121
		{
            if (customform.document.getElementById("wdesk:office_line1").value == "") {
                alert('Please enter Office Flat No./Designation');
                customform.document.getElementById("wdesk:office_line1").focus();
                return false;
            }
            if (customform.document.getElementById("wdesk:office_city").value == "") {
                alert('Please enter Office City');
                customform.document.getElementById("wdesk:office_city").focus();
                return false;
            }
            if (customform.document.getElementById("office_cntrycode").value == "--Select--" || customform.document.getElementById("office_cntrycode").value == "") {
                alert('Please enter Office Country');
                customform.document.getElementById("office_cntrycode").focus();
                return false;
            }
        }
		
			
		//Expiry date year check CR added by Shamily
		var VisaExpirydate = customform.document.getElementById("wdesk:visaExpDate_exis").value;
		var Visaexpyear = VisaExpirydate.split("/");
		
		if((customform.document.getElementById("wdesk:visaExpDate_new").value == "" || customform.document.getElementById("wdesk:visaExpDate_new").value == null ) && Visaexpyear[2]=='2099')
		{
			 alert("Please enter new Visa expiry date as existing Visa expiry date year is 2099");
			 customform.document.getElementById("wdesk:visaExpDate_new").focus();
              return false;
		}
		
		// as part of JIRA SCRCIF-175
		var EmidExpirydate = customform.document.getElementById("wdesk:emiratesidexp_exis").value;
		var Emidexpyear = EmidExpirydate.split("/");
		
		if (customform.document.getElementById("wdesk:nation_exist").value != "AE") {
			if((customform.document.getElementById("wdesk:emiratesidexp_new").value == "" || customform.document.getElementById("wdesk:emiratesidexp_new").value == null ) && Emidexpyear[2]=='2099')
			{
				 alert("Please enter new Emirates ID Expiry date as existing Emirates ID Expiry date of year is 2099");
				 customform.document.getElementById("wdesk:emiratesidexp_new").focus();
				 return false;
			}
		} else if (customform.document.getElementById("wdesk:nation_exist").value == "AE") {
			if((customform.document.getElementById("wdesk:emiratesidexp_new").value == "" || customform.document.getElementById("wdesk:emiratesidexp_new").value == null ) && Emidexpyear[2]=='2099')
			{
				var r = confirm("Emirates ID Expiry date of year is 2099, Press OK to update / Press Cancel to Proceed");
				if (r == true) 
				{
					customform.document.getElementById("wdesk:emiratesidexp_new").focus();
					return false;
				} 
			}
		}

		//emirates expiry date should be equal to visa expiry date cr
		/*var visaExpDate_new = customform.document.getElementById("wdesk:visaExpDate_new").value;
		var emiratesidexp_new = customform.document.getElementById("wdesk:emiratesidexp_new").value;
		var visaExpDate_exis = customform.document.getElementById("wdesk:visaExpDate_exis").value;
		var emiratesidexp_exis = customform.document.getElementById("wdesk:emiratesidexp_exis").value;
		
		if(emiratesidexp_new != "" && emiratesidexp_new != null)
		{
			if ((visaExpDate_new == "" || visaExpDate_new == null) && (visaExpDate_exis == "" || visaExpDate_exis == null))
			{
				alert(" New Emirates Expiry date should be equal to New Visa expiry date");
				customform.document.getElementById("wdesk:visaExpDate_new").focus();
				return false;
			}
		
			else if(visaExpDate_new != "" && visaExpDate_new != null && visaExpDate_new != emiratesidexp_new)
			{
				alert(" New Emirates Expiry date should be equal to New Visa expiry date");
				customform.document.getElementById("wdesk:emiratesidexp_new").focus();
				return false;
			}
			else if ((visaExpDate_new == "" || visaExpDate_new == null ) && visaExpDate_exis != "" && visaExpDate_exis != null && visaExpDate_exis != emiratesidexp_new)
			{
				alert(" New Emirates Expiry date should be equal to Existing Visa expiry date");
				customform.document.getElementById("wdesk:emiratesidexp_new").focus();
				return false;
			}
		}
		
		if(visaExpDate_new != "" && visaExpDate_new != null)
		{
			if ((emiratesidexp_new == "" || emiratesidexp_new == null ) && (emiratesidexp_exis == "" || emiratesidexp_exis == null ))
			{
				alert(" New Visa Expiry date should be equal to New Emirates expiry date");
				customform.document.getElementById("wdesk:visaExpDate_new").focus();
				return false;
			}
				
			if ((emiratesidexp_new == "" || emiratesidexp_new == null ) && (emiratesidexp_exis == "" || emiratesidexp_exis == null ))
			{
				alert(" New Visa Expiry date should be equal to New Emirates expiry date");
				customform.document.getElementById("wdesk:emiratesidexp_new").focus();
				return false;
			}
		
			else if(emiratesidexp_new != "" && emiratesidexp_new != null && visaExpDate_new != emiratesidexp_new)
			{
				alert(" New Visa Expiry date should be equal to New Emirates expiry date");
				customform.document.getElementById("wdesk:visaExpDate_new").focus();
				return false;
			}
			else if ((emiratesidexp_new == "" || emiratesidexp_new == null ) && emiratesidexp_exis != "" && emiratesidexp_exis != null && emiratesidexp_exis != emiratesidexp_new)
			{
				alert(" New Visa Expiry date should be equal to Existing Emirates expiry date");
				customform.document.getElementById("wdesk:visaExpDate_new").focus();
				return false;
			}
		}
		*/
		if(!document.getElementById('customform').contentWindow.emidexpdatevaliation("Emirates expiry date"))
			return false;
		
		// home phone should not be equal to mob phn 1 and 2 validation cr
		
		var MobilePhone_Existing =  customform.document.getElementById("wdesk:MobilePhone_Existing").value;
		MobilePhone_Existing =  MobilePhone_Existing.replace('+','');
		MobilePhone_Existing = MobilePhone_Existing.replace('(','');
		MobilePhone_Existing = MobilePhone_Existing.replace(')','');
		
		var sec_mob_phone_exis =customform.document.getElementById("wdesk:sec_mob_phone_exis").value;
		sec_mob_phone_exis = sec_mob_phone_exis.replace('+','');
		sec_mob_phone_exis = sec_mob_phone_exis.replace('(','');
		sec_mob_phone_exis = sec_mob_phone_exis.replace(')','');
		var homephone_newC =  customform.document.getElementById("wdesk:homephone_newC").value;
		var homephone_newN = customform.document.getElementById("wdesk:homephone_newN").value;
		var homephone_newE = customform.document.getElementById("wdesk:homephone_newE").value;
		var HomePhn = homephone_newC +homephone_newN+homephone_newE;
		
		HomePhn = HomePhn.replace(null,'');
		var MobilePhone_New1 = customform.document.getElementById("wdesk:MobilePhone_New1").value;
		var MobilePhone_New = customform.document.getElementById("wdesk:MobilePhone_New").value;
		var MobilePhone_New2 = customform.document.getElementById("wdesk:MobilePhone_New2").value;
		var MobilePhn1 = MobilePhone_New1+MobilePhone_New+MobilePhone_New2;
		MobilePhn1 = MobilePhn1.replace(null,'');
		
		var sec_mob_phone_newC = customform.document.getElementById("wdesk:sec_mob_phone_newC").value;
		var sec_mob_phone_newN = customform.document.getElementById("wdesk:sec_mob_phone_newN").value;
		var sec_mob_phone_newE = customform.document.getElementById("wdesk:sec_mob_phone_newE").value;
		var mobilePhn2 = sec_mob_phone_newC+sec_mob_phone_newN+sec_mob_phone_newE;
		mobilePhn2 = mobilePhn2.replace(null,'');
		if(HomePhn != "" && HomePhn != null)
		{
			if(MobilePhn1 != "" & MobilePhn1 != null && HomePhn == MobilePhn1)
			{
				alert("Home Phone should not be equal to mobile phone 1");
				customform.document.getElementById("wdesk:homephone_newE").focus();
				return false;
			}
			else if ((MobilePhn1 == "" || MobilePhn1 == null) && MobilePhone_Existing != "" && MobilePhone_Existing != null && MobilePhone_Existing == HomePhn)
			{
				alert("Home Phone should not be equal to mobile phone 1");
				customform.document.getElementById("wdesk:homephone_newE").focus();
				return false;
			}
		
			if(mobilePhn2 != "" & mobilePhn2 != null && HomePhn == mobilePhn2)
			{
				alert("Home Phone should not be equal to mobile phone 2");
				customform.document.getElementById("wdesk:homephone_newE").focus();
				return false;
			}
			else if ((mobilePhn2 == "" || mobilePhn2 == null) && sec_mob_phone_exis != "" && sec_mob_phone_exis != null && sec_mob_phone_exis == HomePhn)
			{
				alert("Home Phone should not be equal to mobile phone 2");
				customform.document.getElementById("wdesk:homephone_newE").focus();
				return false;
			}
		
		}	
		
		//Added below by Amandeep on 18 11 2016
		if(!document.getElementById('customform').contentWindow.hmphnstart("home phone"))
			return false;
		if(!document.getElementById('customform').contentWindow.hmphnstart("Office phone"))
			return false;
		if(!document.getElementById('customform').contentWindow.hmphnstart("Fax"))
			return false;
			
			//added by shamily for self employed emplyment types validation CR
		if(!document.getElementById('customform').contentWindow.validateemptype())
		{
			if(customform.document.getElementById("emp_type_new").value == "Self employed")
			{
				//isreturntrue = "no";
				if(customform.document.getElementById('IndustrySegment_new').value == "" || customform.document.getElementById('IndustrySegment_new').value == null || customform.document.getElementById('IndustrySegment_new').value =="--Select--")
				{
					alert("Please select Industry Segment ");
					customform.document.getElementById("IndustrySegment_new").focus();
					return false;
				}
				if(customform.document.getElementById('IndustrySubSegment_new').value == "" || customform.document.getElementById('IndustrySubSegment_new').value == null || customform.document.getElementById('IndustrySubSegment_new').value =="--Select--")
				{
					alert("Please select Industry Sub Segment ");
					customform.document.getElementById("IndustrySubSegment_new").focus();
					return false;
				}
				/*if(customform.document.getElementById('DealwithCont_new').value == "" || customform.document.getElementById('DealwithCont_new').value == null || customform.document.getElementById('DealwithCont_new').value =="--Select--")
				{
					alert("Please select Dealing with Countries ");
					customform.document.getElementById("DealwithCont_new").focus();
					return false;
				}*/
			}
			
		}
			
		//modified by Shamily for email mandatory for estatement value 9 jan 2017
		if(customform.document.getElementById("E_Stmnt_regstrd_new").value=="Yes" && (customform.document.getElementById("wdesk:E_Stmnt_regstrd_newload").value=="--Select--" || customform.document.getElementById("wdesk:E_Stmnt_regstrd_newload").value==""|| customform.document.getElementById("wdesk:E_Stmnt_regstrd_newload").value==null ||  customform.document.getElementById("wdesk:E_Stmnt_regstrd_newload").value=="No"))
		{
			if(customform.document.getElementById("wdesk:primary_emailid_new").value=="")
			{
				alert("Primary Email ID is mandatory when E-Statement Registered is Yes.");
				customform.document.getElementById("wdesk:primary_emailid_new").focus();
				return false;
			}
			
		}
		var nationality = "";
		if(customform.document.getElementById("nation_new").value != '--Select--' && customform.document.getElementById("nation_new").value!= null && customform.document.getElementById("nation_new").value!= "")
		{
			 nationality = customform.document.getElementById("nation_new").value;
		}
		else
		{
			nationality = customform.document.getElementById('wdesk:nation_exist').value;
		}
		if(nationality == "US")
		{
			if((customform.document.getElementById("FatcaDocNew").value == "" || customform.document.getElementById("FatcaDocNew").value == null)  && (customform.document.getElementById("wdesk:FatcaDoc").value == "" || customform.document.getElementById("wdesk:FatcaDoc").value == null))
			{
				alert("For US Nationality Fatca Document is mandatory");
				return false;
			}
		}
		// added by shamily for OECD city of birth validation
		
		if(customform.document.getElementById("wdesk:Oecdcity_new").value == "" || customform.document.getElementById("wdesk:Oecdcity_new").value == null)
		{
			 if(!Oecdfieldvalidation("wdesk:Oecdcity_new"))
			 {
				return false;
			 }
		}
		// added by shamily for OECD country of birth validation
		var Oecdcountry = customform.document.getElementById('wdesk:Oecdcountry').value;
		var Oecdcountry_new = customform.document.getElementById('wdesk:Oecdcountry_new').value;
		if((Oecdcountry_new == "" || Oecdcountry_new == null || Oecdcountry_new == "--Select--") && (Oecdcountry == "" || Oecdcountry == null))
		{
			alert('Please select OECD Country of birth');
			customform.document.getElementById("wdesk:Oecdcountry_new").focus();
			return false;
		}
		var OECDUndoc_Flag_new = customform.document.getElementById('OECDUndoc_Flag_new').value;
		if(OECDUndoc_Flag_new =='--Select--' || OECDUndoc_Flag_new =='' || OECDUndoc_Flag_new ==null)
		{
			if(!Oecdfieldvalidation("OECDUndoc_Flag_new"))
			 {
				return false;
			 }
			
		}
		if(OECDUndoc_Flag_new == 'Yes' &&( customform.document.getElementById('OECDUndocreason_new').value == '--Select--' ||  customform.document.getElementById('OECDUndocreason_new').value == '' ||  customform.document.getElementById('OECDUndocreason_new').value == null))
		{
			alert('Please select CRS Undocumented Flag Reason');
			customform.document.getElementById("OECDUndocreason_new").focus();
			return false;
		}
		if(OECDUndoc_Flag_new == 'No')
		{
			if(customform.document.getElementById('wdesk:Oecdcountrytax_new').value == '--Select--' || customform.document.getElementById('wdesk:Oecdcountrytax_new').value == "" || customform.document.getElementById('wdesk:Oecdcountrytax_new').value == null)
			{
				if(!Oecdfieldvalidation("wdesk:Oecdcountrytax_new"))
				{
					return false;
				}
				 
			}
			if((customform.document.getElementById('wdesk:OecdTin_new').value == '' || customform.document.getElementById('wdesk:OecdTin_new').value == null) && (customform.document.getElementById('OECDtinreason_new').value == null || customform.document.getElementById('OECDtinreason_new').value == ''|| customform.document.getElementById('OECDtinreason_new').value == '--Select--'))
			{
				 if(!Oecdfieldvalidation("OecdTin_new"))
				 {
					return false;
				 }
		
			}
			
		} 
		var Oecdcountrytax_new2 = customform.document.getElementById('wdesk:Oecdcountrytax_new2').value;
		var Oecdcountrytax_new3 = customform.document.getElementById('wdesk:Oecdcountrytax_new3').value;
		var Oecdcountrytax_new4 = customform.document.getElementById('wdesk:Oecdcountrytax_new4').value;
		var Oecdcountrytax_new5 = customform.document.getElementById('wdesk:Oecdcountrytax_new5').value;
		var Oecdcountrytax_new6 = customform.document.getElementById('wdesk:Oecdcountrytax_new6').value;
		if((Oecdcountrytax_new2 != "" && Oecdcountrytax_new2 != null) && ((customform.document.getElementById('wdesk:OecdTin_new2').value == '' || customform.document.getElementById('wdesk:OecdTin_new2').value == null) && (customform.document.getElementById('OECDtinreason_new2').value == null || customform.document.getElementById('OECDtinreason_new2').value == ''|| customform.document.getElementById('OECDtinreason_new2').value == '--Select--')))
		{
			alert("Please enter 'Tax Payer Identification Number 2' or  'No TIN Reason 2");
			customform.document.getElementById("wdesk:OecdTin_new2").focus();
			return false;
		}
		if((Oecdcountrytax_new3 != "" && Oecdcountrytax_new3 != null) && ((customform.document.getElementById('wdesk:OecdTin_new3').value == '' || customform.document.getElementById('wdesk:OecdTin_new3').value == null) && (customform.document.getElementById('OECDtinreason_new3').value == null || customform.document.getElementById('OECDtinreason_new3').value == ''|| customform.document.getElementById('OECDtinreason_new3').value == '--Select--')))
		{
			alert("Please enter 'Tax Payer Identification Number 3' or  'No TIN Reason 3");
			customform.document.getElementById("wdesk:OecdTin_new3").focus();
			return false;
		}
		if((Oecdcountrytax_new4 != "" && Oecdcountrytax_new4 != null) && ((customform.document.getElementById('wdesk:OecdTin_new4').value == '' || customform.document.getElementById('wdesk:OecdTin_new4').value == null) && (customform.document.getElementById('OECDtinreason_new4').value == null || customform.document.getElementById('OECDtinreason_new4').value == ''|| customform.document.getElementById('OECDtinreason_new4').value == '--Select--')))
		{
			alert("Please enter 'Tax Payer Identification Number 4' or  'No TIN Reason 4");
			customform.document.getElementById("wdesk:OecdTin_new4").focus();
			return false;
		}
		if((Oecdcountrytax_new5 != "" && Oecdcountrytax_new5 != null) && ((customform.document.getElementById('wdesk:OecdTin_new5').value == '' || customform.document.getElementById('wdesk:OecdTin_new5').value == null) && (customform.document.getElementById('OECDtinreason_new5').value == null || customform.document.getElementById('OECDtinreason_new5').value == ''|| customform.document.getElementById('OECDtinreason_new5').value == '--Select--')))
		{
			alert("Please enter 'Tax Payer Identification Number 5' or  'No TIN Reason 5");
			customform.document.getElementById("wdesk:OecdTin_new5").focus();
			return false;
		}
		if((Oecdcountrytax_new6 != "" && Oecdcountrytax_new6 != null) && ((customform.document.getElementById('wdesk:OecdTin_new6').value == '' || customform.document.getElementById('wdesk:OecdTin_new6').value == null) && (customform.document.getElementById('OECDtinreason_new6').value == null || customform.document.getElementById('OECDtinreason_new6').value == ''|| customform.document.getElementById('OECDtinreason_new6').value == '--Select--')))
		{
			alert("Please enter 'Tax Payer Identification Number 6' or  'No TIN Reason 6");
			customform.document.getElementById("wdesk:OecdTin_new6").focus();
			return false;
		}
		
		
		// start - making mobile phone, mobile phone 2 and office phone mandatory if existing value is not available and selected as preferred address as part of JIRA SCRCIF-127 added on 25/05/2017
		if (customform.document.getElementById('pref_contact_new').value == 'Mobile Phone')
		{
			//if (customform.document.getElementById('wdesk:MobilePhone_Existing').value == '')
			//{
				if (customform.document.getElementById('wdesk:MobilePhone_New1').value == '')
				{
					alert("Please enter Mobile Phone Country Code");
					customform.document.getElementById("wdesk:MobilePhone_New1").focus();
					return false;
				}
				else if (customform.document.getElementById('wdesk:MobilePhone_New2').value == '')
				{
					alert("Please enter Mobile Phone Number");
					customform.document.getElementById("wdesk:MobilePhone_New2").focus();
					return false;
				}
			//}
		}
		else if (customform.document.getElementById('pref_contact_new').value == 'Mobile Phone 2')
		{
			//if (customform.document.getElementById('wdesk:sec_mob_phone_exis').value == '')
			//{
				if (customform.document.getElementById('wdesk:sec_mob_phone_newC').value == '')
				{
					alert("Please enter Mobile Phone 2 Country Code");
					customform.document.getElementById("wdesk:sec_mob_phone_newC").focus();
					return false;
				}
				else if (customform.document.getElementById('wdesk:sec_mob_phone_newE').value == '')
				{
					alert("Please enter Mobile Phone 2 Number");
					customform.document.getElementById("wdesk:sec_mob_phone_newE").focus();
					return false;
				}
			//}
		}
		else if (customform.document.getElementById('pref_contact_new').value == 'Office Phone')
		{
			//if (customform.document.getElementById('wdesk:office_phn_exis').value == '')
			//{
				if (customform.document.getElementById('wdesk:office_phn_newC').value == '')
				{
					alert("Please enter Office Phone Country Code");
					customform.document.getElementById("wdesk:office_phn_newC").focus();
					return false;
				}
				else if (customform.document.getElementById('wdesk:office_phn_newE').value == '')
				{
					alert("Please enter Office Phone Number");
					customform.document.getElementById("wdesk:office_phn_newE").focus();
					return false;
				}
			//}
		}
		
		// End - making mobile phone, mobile phone 2 and office phone mandatory if existing value is not available and selected as preferred address as part of JIRA SCRCIF-127 added on 25/05/2017
		
		// Start - Validation for countrycode and phonenumber to make it mandatory if anyone of filled added on 23082017
		if (customform.document.getElementById('wdesk:MobilePhone_New1').value != '' || customform.document.getElementById('wdesk:MobilePhone_New2').value != '' )
		{
			if (customform.document.getElementById('wdesk:MobilePhone_New1').value == '')
			{
				alert("Mobile Phone Country Code cannot be blank if Mobile Phone Number is filled");
				customform.document.getElementById("wdesk:MobilePhone_New1").focus();
				return false;
			} else if (customform.document.getElementById('wdesk:MobilePhone_New2').value == '')
			{
				alert("Mobile Phone Number cannot be blank if Mobile Phone Country Code is filled");
				customform.document.getElementById("wdesk:MobilePhone_New2").focus();
				return false;
			}
		} 
		if (customform.document.getElementById('wdesk:sec_mob_phone_newC').value != '' || customform.document.getElementById('wdesk:sec_mob_phone_newE').value != '' )
		{
			if (customform.document.getElementById('wdesk:sec_mob_phone_newC').value == '')
			{
				alert("Mobile Phone 2 Country Code cannot be blank if Mobile Phone Number 2 is filled");
				customform.document.getElementById("wdesk:sec_mob_phone_newC").focus();
				return false;
			} else if (customform.document.getElementById('wdesk:sec_mob_phone_newE').value == '')
			{
				alert("Mobile Phone Number 2 cannot be blank if Mobile Phone 2 Country Code is filled");
				customform.document.getElementById("wdesk:sec_mob_phone_newE").focus();
				return false;
			}
		} 
		if (customform.document.getElementById('wdesk:homephone_newC').value != '' || customform.document.getElementById('wdesk:homephone_newE').value != '' )
		{
			if (customform.document.getElementById('wdesk:homephone_newC').value == '')
			{
				alert("Home Phone Country Code cannot be blank if Home Phone Number is filled");
				customform.document.getElementById("wdesk:homephone_newC").focus();
				return false;
			} else if (customform.document.getElementById('wdesk:homephone_newE').value == '')
			{
				alert("Home Phone Number cannot be blank if Home Phone Country Code is filled");
				customform.document.getElementById("wdesk:homephone_newE").focus();
				return false;
			}
		} 
		if (customform.document.getElementById('wdesk:office_phn_newC').value != '' || customform.document.getElementById('wdesk:office_phn_newE').value != '' )
		{
			if (customform.document.getElementById('wdesk:office_phn_newC').value == '')
			{
				alert("Office Phone Country Code cannot be blank if Office Phone Number is filled");
				customform.document.getElementById("wdesk:office_phn_newC").focus();
				return false;
			} else if (customform.document.getElementById('wdesk:office_phn_newE').value == '')
			{
				alert("Office Phone Number cannot be blank if Office Phone Country Code is filled");
				customform.document.getElementById("wdesk:office_phn_newE").focus();
				return false;
			}
		} 
		if (customform.document.getElementById('wdesk:fax_newC').value != '' || customform.document.getElementById('wdesk:fax_newE').value != '' )
		{
			if (customform.document.getElementById('wdesk:fax_newC').value == '')
			{
				alert("Fax Country Code cannot be blank if Fax Number is filled");
				customform.document.getElementById("wdesk:fax_newC").focus();
				return false;
			} else if (customform.document.getElementById('wdesk:fax_newE').value == '')
			{
				alert("Fax Number cannot be blank if Fax Country Code is filled");
				customform.document.getElementById("wdesk:fax_newE").focus();
				return false;
			}
		} 
		if (customform.document.getElementById('wdesk:homecntryphone_newC').value != '' || customform.document.getElementById('wdesk:homecntryphone_newE').value != '' )
		{
			if (customform.document.getElementById('wdesk:homecntryphone_newC').value == '')
			{
				alert("Home Country Phone Country Code cannot be blank if Home Country Phone Number is filled");
				customform.document.getElementById("wdesk:homecntryphone_newC").focus();
				return false;
			} else if (customform.document.getElementById('wdesk:homecntryphone_newE').value == '')
			{
				alert("Home Country Phone Number cannot be blank if Home Country Phone Country Code is filled");
				customform.document.getElementById("wdesk:homecntryphone_newE").focus();
				return false;
			}
		}
		// End - Validation for countrycode and phonenumber to make it mandatory if anyone of filled added on 23082017
		
		
		// checking field level validation on Mobile Number Field		
		if(customform.document.getElementById("wdesk:country_of_res_exis").value =="AE" )
		{
			if (MobileNumberValidation('wdesk:MobilePhone_New1','wdesk:MobilePhone_New2','Mobile Phone 1') == false)
				return false;
			if (MobileNumberValidation('wdesk:sec_mob_phone_newC','wdesk:sec_mob_phone_newE','Mobile Phone 2') == false)
				return false;
		}
		
		// Start - Validation for City and State when Country selected as UAE added on 23082017
		var rescountrycode = customform.document.getElementById('resi_cntrycode').value;
		var rescity = customform.document.getElementById('wdesk:resi_city').value;
		var resstate = customform.document.getElementById('wdesk:resi_state').value;
		if (rescountrycode == 'AE')
		{
			if (rescity != '' && rescity != 'DUBAI' && rescity != 'ABU DHABI' && rescity != 'RAS AL KHAIMAH' && rescity != 'SHARJAH' && rescity != 'AL AIN' && rescity != 'UMM AL QUWAIN' && rescity != 'FUJAIRAH' && rescity != 'AL-FUJAIRAH' && rescity != 'AJMAN' && rescity != '(SUWAIHAN) ABU DHABI' && rescity != 'KHORFAKKAN-SHARJAH' && rescity != 'KHORFAKKHAN-SHARJAH' && rescity != 'KHORFAKKAN' && rescity != '')
			{
				alert("Residence City Cannot be selected as "+rescity+" when Residence Country is UAE");
				customform.document.getElementById("wdesk:resi_city").focus();
				return false;
			} else if (resstate != '' && resstate != 'DUBAI' && resstate != 'ABU DHABI' && resstate != 'RAS AL KHAIMAH' && resstate != 'SHARJAH' && resstate != 'AL AIN' && resstate != 'UMM AL QUWAIN' && resstate != 'FUJAIRAH' && resstate != 'AL-FUJAIRAH' && resstate != 'AJMAN' && resstate != '(SUWAIHAN) ABU DHABI' && resstate != 'KHORFAKKAN-SHARJAH' && resstate != 'KHORFAKKHAN-SHARJAH' && resstate != 'KHORFAKKAN' && resstate != '')
			{
				alert("Residence State Cannot be selected as "+resstate+" when Residence Country is UAE");
				customform.document.getElementById("wdesk:resi_state").focus();
				return false;
			}
		}
		var offcountrycode = customform.document.getElementById('office_cntrycode').value;
		var offcity = customform.document.getElementById('wdesk:office_city').value;
		var offstate = customform.document.getElementById('wdesk:office_state').value;
		if (offcountrycode == 'AE')
		{
			if (offcity != 'DUBAI' && offcity != 'ABU DHABI' && offcity != 'RAS AL KHAIMAH' && offcity != 'SHARJAH' && offcity != 'AL AIN' && offcity != 'UMM AL QUWAIN' && offcity != 'FUJAIRAH' && offcity != 'AL-FUJAIRAH' && offcity != 'AJMAN' && offcity != '(SUWAIHAN) ABU DHABI' && offcity != 'KHORFAKKAN-SHARJAH' && offcity != 'KHORFAKKHAN-SHARJAH' && offcity != 'KHORFAKKAN' && offcity != '')
			{
				alert("Office City Cannot be selected as "+offcity+" when Office Country is UAE");
				customform.document.getElementById("wdesk:office_city").focus();
				return false;
			} else if (offstate != 'DUBAI' && offstate != 'ABU DHABI' && offstate != 'RAS AL KHAIMAH' && offstate != 'SHARJAH' && offstate != 'AL AIN' && offstate != 'UMM AL QUWAIN' && offstate != 'FUJAIRAH' && offstate != 'AL-FUJAIRAH' && offstate != 'AJMAN' && offstate != '(SUWAIHAN) ABU DHABI' && offstate != 'KHORFAKKAN-SHARJAH' && offstate != 'KHORFAKKHAN-SHARJAH' && offstate != 'KHORFAKKAN' && offstate != '')
			{
				alert("Office State Cannot be selected as "+offstate+" when Office Country is UAE");
				customform.document.getElementById("wdesk:office_state").focus();
				return false;
			}
		}
		// End - Validation for City and State when Country selected as UAE added on 23082017
		
	// Start - Making OECD_Form mandatory to attach if any OECD Details are filled added on 29052017 as part of JIRA SCRCIF-120
	if(customform.document.getElementById('wdesk:Oecdcountry_new').value != "" || customform.document.getElementById('wdesk:Oecdcity_new').value != "" || customform.document.getElementById('wdesk:Oecdcountrytax_new').value != "")
	{		
		var arrAvailableDocList = getInterfaceData("D");
		//var arrAvailableDocList = document.getElementById('wdesk:docCombo');
		//if (arrAvailableDocList == null || arrAvailableDocList == 'null')
			//arrAvailableDocList = customform.document.getElementById('wdesk:docCombo');
		var arrSearchDocList = "OECD_Form";
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
				if (arrAvailableDocList[iDocCounter].name.toUpperCase().indexOf("OECD_Form".toUpperCase()) >= 0) {
					bResult = true;
					break;
				}
			}
			if(!bResult){
			alert("Please attach OECD_Form to proceed further.");
			return false;
			}
		}        
	}	
    // End - Making OECD_Form mandatory to attach if any OECD Details are filled added on 29052017 as part of JIRA SCRCIF-120
				
			
		var title_exis = customform.document.getElementById('wdesk:title_exis').value;
		var firstname_exis = customform.document.getElementById('wdesk:FirstName_Existing').value;
		var middlename_exis = customform.document.getElementById('wdesk:MiddleName_Existing').value;
		var lastname_exis = customform.document.getElementById('wdesk:LastName_Existing').value;
		var fullname_exis = customform.document.getElementById('wdesk:FullName_Existing').value;
		//var shortname_exis =  customform.document.getElementById('wdesk:ShortName_Existing').value; 
		var emiratesid_exis = customform.document.getElementById('wdesk:emirates_id').value;
		var emiratesex_exis = customform.document.getElementById('wdesk:emiratesidexp_exis').value;
		var passportnum_exis = customform.document.getElementById('wdesk:PassportNumber_Existing').value;
		var passportexp_exis = customform.document.getElementById('wdesk:passportExpDate_exis').value;
		var visa_exis = customform.document.getElementById('wdesk:visa_exis').value;
		var visaexp_exis = customform.document.getElementById('wdesk:visaExpDate_exis').value;
		var mother_exis =  "Data On File";
        //added by stutee.mishra for POD/PL changes on RI Form.
		var langOfPref_exis = customform.document.getElementById('wdesk:prefOfLanguage_exis').value;
		var peopleOfDet_exis = customform.document.getElementById('wdesk:peopleOfDeterm_exis').value;
		var podOptions_exis = customform.document.getElementById('wdesk:PODOptions_exis').value;
		var podRemarks_exis = customform.document.getElementById('wdesk:PODRemarks_exis').value.substring(0,134);
		
		//var mother_exis = customform.document.getElementById('wdesk:mother_maiden_name_exis').value;
		//var usnation_exis =  customform.document.getElementById('wdesk:usnatholder_exis').value; 
		//var usresi_exis =  customform.document.getElementById('wdesk:usresi_exis').value; 
		// var usgreen_exis =  customform.document.getElementById('wdesk:usgreencardhol_exis').value; 
		// var ustax_exis =  customform.document.getElementById('wdesk:us_tax_payer_exis').value; 
		//  var uscitizen_exis =  customform.document.getElementById('wdesk:us_citizen_exis').value;                          
		//   var cntrybirth_exis =  customform.document.getElementById('wdesk:nocnofbirth_exis').value; 
		var abcde_exis = customform.document.getElementById('wdesk:abcdelig_exis').value;
		var resiadd_exis = customform.document.getElementById('resiadd_exis').value;
		var officeadd_exis = customform.document.getElementById('office_add_exis').value;
		var prefadd_exis = customform.document.getElementById('wdesk:pref_add_exis').value;
		var primid_exis = customform.document.getElementById('wdesk:prim_email_exis').value;
		var secid_exis = customform.document.getElementById('wdesk:sec_email_exis').value;
		var estate_exis = customform.document.getElementById('wdesk:E_Stmnt_regstrd_exis').value;
		var mobile1_exis = customform.document.getElementById('wdesk:MobilePhone_Existing').value;
		var mobile2_exis = customform.document.getElementById('wdesk:sec_mob_phone_exis').value;
		var hmephn_exis = customform.document.getElementById('wdesk:homephone_exis').value;
		var offcphn_exis = customform.document.getElementById('wdesk:office_phn_exis').value;
		var hmecntryphn_exis = customform.document.getElementById('wdesk:homecntryphone_exis').value;
		var prefcontact_exis = customform.document.getElementById('wdesk:pref_contact_exis').value;
		var emptype_exis = customform.document.getElementById('wdesk:emp_type_exis').value;
		var designation_exis = customform.document.getElementById('wdesk:designation_exis').value;
		var compname_exis = customform.document.getElementById('wdesk:comp_name_exis').value;
		var empname_exis = customform.document.getElementById('wdesk:emp_name_exis').value;
		var department_exis = customform.document.getElementById('wdesk:department_exis').value;
		var empnum_exis = customform.document.getElementById('wdesk:employee_num_exis').value;
		var occupation_exis = customform.document.getElementById('wdesk:occupation_exist').value;
		var nameofbusi_exis = customform.document.getElementById('wdesk:name_of_business_exis').value;
		var totalyrsemp_exis = customform.document.getElementById('wdesk:total_year_of_emp_exis').value;
		var yrsbusi_exis = customform.document.getElementById('wdesk:years_of_business_exis').value;
		var empstatus_exis = customform.document.getElementById('wdesk:employment_status_exis').value;
		var datejoining_exis = customform.document.getElementById('wdesk:date_join_curr_employer_exis').value;
		var marital_exis = customform.document.getElementById('wdesk:marrital_status_exis').value;
		var dependents_exis = customform.document.getElementById('wdesk:no_of_dependents_exis').value;
		//var cntryresi_exis =  customform.document.getElementById('wdesk:country_of_res_exis').value; 
		var nationality_exis = customform.document.getElementById('wdesk:nation_exist').value;
		var wheninuae_exis = customform.document.getElementById('wdesk:wheninuae_exis').value;
		var prevorgan_exis = customform.document.getElementById('wdesk:prev_organ_exis').value;
		var periodorgan_exis = customform.document.getElementById('wdesk:period_organ_exis').value;
		var fax_exis = customform.document.getElementById('wdesk:fax_exis').value;
		//ended here for the existing fields
		
		var Full_Name = customform.document.getElementById('wdesk:FirstName_New').value;
		var Emirates_Id = customform.document.getElementById('wdesk:emiratesid_new').value;
		var Contact = customform.document.getElementById('contact_details').value;
		var title = customform.document.getElementById('title_new').value;
		var MiddleName = customform.document.getElementById('wdesk:MiddleName_New').value;
		var LastName = customform.document.getElementById('wdesk:LastName_New').value;
		var FullName = customform.document.getElementById('wdesk:FullName_New').value;
		//var ShortName =  customform.document.getElementById('wdesk:ShortName_New').value; 
		var Gender = customform.document.getElementById('gender_new').value;
		var passportNum = customform.document.getElementById('wdesk:PassportNumber_New').value;
		var EmiratesidExp = customform.document.getElementById('wdesk:emiratesidexp_new').value;
		var PassExpdate = customform.document.getElementById('wdesk:passportExpDate_new').value;
		var Visa = customform.document.getElementById('wdesk:visa_new').value;
		var VisaExpDate = customform.document.getElementById('wdesk:visaExpDate_new').value;
		var Mother = customform.document.getElementById('wdesk:mother_maiden_name_new').value;
		//added by stutee.mishra for POD/PL changes on RI Form.
		var langOfPref_new = customform.document.getElementById('prefOfLanguage').value;
		if(langOfPref_new == "--Select--")
				langOfPref_new = "";
		var peopleOfDet_new = customform.document.getElementById('peopleOfDeterm').value;
		if(peopleOfDet_new == "--Select--")
				peopleOfDet_new = "";
		var podOptionsCurr_new = customform.document.getElementById('wdesk:PODOptions').value;
		var optionsArr = podOptionsCurr_new.split("|");
		var podOptions_new = "";
		for(var j=0;j<optionsArr.length;j++)
			{
				if(optionsArr[j] == 'HEAR'){
					podOptions_new = podOptions_new+'Hearing'+',';
				}else if(optionsArr[j] == 'COGN'){
					podOptions_new = podOptions_new+'Cognitive'+',';
				}else if(optionsArr[j] == ("NEUR")){
					podOptions_new = podOptions_new+'Neurological'+',';
				}else if(optionsArr[j] == 'PHYS'){
					podOptions_new = podOptions_new+'Physical'+',';
				}else if(optionsArr[j] == 'SPCH'){
					podOptions_new = podOptions_new+'Speech'+',';
				}else if(optionsArr[j] == 'VISL'){
					podOptions_new = podOptions_new+'Visual'+',';
				}else if(optionsArr[j] == 'OTHR'){
					podOptions_new = podOptions_new+'Others'+',';
				}
			}
		podOptions_new = podOptions_new.substring(0,(podOptions_new.length)-1);	
		var podRemarks_new = customform.document.getElementById('wdesk:PODRemarks').value.substring(0,134);
		podRemarks_new = podRemarks_new.replace('&','and');
		//var nation =  customform.document.getElementById('usnatholder_new').value; 
		//var usresi =  customform.document.getElementById('usresi_new').value; 
		//var greencard =  customform.document.getElementById('usgreencardhol_new').value; 
		//var tax =  customform.document.getElementById('us_tax_payer_new').value; 
		//var citizen =  customform.document.getElementById('us_citizen_new').value; 
		//var birth =  customform.document.getElementById('wdesk:nocnofbirth_new').value; 

		var Aecb = customform.document.getElementById('abcdelig_new').value;
		var resi1 = customform.document.getElementById('wdesk:resi_line1').value;
		var resi2 = customform.document.getElementById('wdesk:resi_line2').value;
		var resi3 = customform.document.getElementById('wdesk:resi_line3').value;
		var resi4 = customform.document.getElementById('wdesk:resi_line4').value;
		var resi_type = customform.document.getElementById('resi_restype').options[customform.document.getElementById('resi_restype').selectedIndex].text;
		var resi_po = customform.document.getElementById('wdesk:resi_pobox').value;
		var resi_zip = customform.document.getElementById('wdesk:resi_zipcode').value;
		var resi_country =   customform.document.getElementById('resi_cntrycode').options[customform.document.getElementById('resi_cntrycode').selectedIndex].text;
		var resi_state = customform.document.getElementById('wdesk:resi_state').value;
		var resi_city = customform.document.getElementById('wdesk:resi_city').value;
		var offc1 = customform.document.getElementById('wdesk:office_line1').value;
		var offc2 = customform.document.getElementById('wdesk:office_line2').value;
		var offc3 = customform.document.getElementById('wdesk:office_line3').value;
		var offc4 = customform.document.getElementById('wdesk:office_line4').value;
		var offc_type = customform.document.getElementById('office_restype').options[customform.document.getElementById('office_restype').selectedIndex].text;
		var offc_po = customform.document.getElementById('wdesk:office_pobox').value;
		var offc_zip = customform.document.getElementById('wdesk:office_zipcode').value;
		var offc_country = customform.document.getElementById('office_cntrycode').options[customform.document.getElementById('office_cntrycode').selectedIndex].text;
		var offc_state = customform.document.getElementById('wdesk:office_state').value;
		var offc_city = customform.document.getElementById('wdesk:office_city').value;
		var pref_add = customform.document.getElementById('pref_add_new').value;
		var prim_id = customform.document.getElementById('wdesk:primary_emailid_new').value;
		var sec_id = customform.document.getElementById('wdesk:sec_email_new').value;
		var e_state = customform.document.getElementById('E_Stmnt_regstrd_new').value;
		var mob1 = customform.document.getElementById('wdesk:MobilePhone_New1').value;
		var mob2 = customform.document.getElementById('wdesk:MobilePhone_New').value;
		var mob3 = customform.document.getElementById('wdesk:MobilePhone_New2').value;
		var mob21 = customform.document.getElementById('wdesk:sec_mob_phone_newC').value;
		var mob22 = customform.document.getElementById('wdesk:sec_mob_phone_newN').value;
		var mob23 = customform.document.getElementById('wdesk:sec_mob_phone_newE').value;
		var homephone1 = customform.document.getElementById('wdesk:homephone_newC').value;
		var homephone2 = customform.document.getElementById('wdesk:homephone_newN').value;
		var homephone3 = customform.document.getElementById('wdesk:homephone_newE').value;
		var offc_phn1 = customform.document.getElementById('wdesk:office_phn_newC').value;
		var offc_phn2 = customform.document.getElementById('wdesk:office_phn_new').value;
		var offc_phn3 = customform.document.getElementById('wdesk:office_phn_newE').value;
		var fax1 = customform.document.getElementById('wdesk:fax_newC').value;
		var fax2 = customform.document.getElementById('wdesk:fax_new').value;
		var fax3 = customform.document.getElementById('wdesk:fax_newE').value;
		var home_cntry_phn1 = customform.document.getElementById('wdesk:homecntryphone_newC').value;
		var home_cntry_phn2 = customform.document.getElementById('wdesk:homecntryphone_newN').value;
		var home_cntry_phn3 = customform.document.getElementById('wdesk:homecntryphone_newE').value;
		var pref_contact = customform.document.getElementById('pref_contact_new').value;
		var emp_type = customform.document.getElementById('emp_type_new').options[customform.document.getElementById('emp_type_new').selectedIndex].text;
		var designation = customform.document.getElementById('wdesk:designation_new').value;
		var comp_name = customform.document.getElementById('wdesk:comp_name_new').value;
		var emp_new_name = customform.document.getElementById('wdesk:emp_name_new').value;
		var department = customform.document.getElementById('wdesk:department_new').value;
		var emp_num = customform.document.getElementById('wdesk:employee_num_new').value;
		var occupation =  customform.document.getElementById('occupation_new').options[customform.document.getElementById('occupation_new').selectedIndex].text; 
		var nature_of_busi = customform.document.getElementById('wdesk:naturebusiness_new').value;
		var years_of_emp = customform.document.getElementById('wdesk:total_year_of_emp_new').value;
		var years_of_business = customform.document.getElementById('wdesk:years_of_business_new').value;
		var emp_status = customform.document.getElementById('employment_status_new').options[customform.document.getElementById('employment_status_new').selectedIndex].text;
		var date_joining = customform.document.getElementById('wdesk:date_join_curr_employer_new').value;
		//var marrital =  customform.document.getElementById('wdesk:marrital_status_new').value;  
		var marrital =  customform.document.getElementById('marrital_status_new').options[customform.document.getElementById('marrital_status_new').selectedIndex].text;  
		var dependents = customform.document.getElementById('wdesk:no_of_dependents_new').value;
		//var cntry_res =  customform.document.getElementById('country_of_res_new').value; 
		var nationality = customform.document.getElementById('nation_new').value;
		var uae = customform.document.getElementById('wdesk:wheninuae_new').value;
		var period_prev = customform.document.getElementById('wdesk:period_organ_new').value;
		var prev_organ = customform.document.getElementById('wdesk:prev_organ_new').value;
		var winame = customform.document.getElementById('wdesk:WI_NAME').value;
		var exis_prefemail = customform.document.getElementById('wdesk:pref_email_exis').value;
		var new_prefemail = customform.document.getElementById('pref_email_new').value;
		var cifno = customform.document.getElementById('wdesk:SelectedCIF').value;
		
		// Start - EMREG and Marsoom Details are added in form as part of JIRA SCRCIF-135 added on 04/06/2017
		//var EMREG_exis = customform.document.getElementById('wdesk:EMREG_exis').value;
		//var EMREG_new = customform.document.getElementById('wdesk:EMREG_new').value;
		//var EMREGExpirydate_exis = customform.document.getElementById('wdesk:EMREGExpirydate_exis').value;
		//var EMREGExpirydate_new = customform.document.getElementById('wdesk:EMREGExpirydate_new').value;
		var Marsoon_exis = customform.document.getElementById('wdesk:Marsoon_exis').value;
		var Marsoon_new = customform.document.getElementById('wdesk:Marsoon_new').value;
		//var marsoonExpDate_exis = customform.document.getElementById('wdesk:marsoonExpDate_exis').value;
		//var marsoonExpDate_new = customform.document.getElementById('wdesk:marsoonExpDate_new').value;
		// End - EMREG and Marsoom Details are added in form as part of JIRA SCRCIF-135 added on 04/06/2017
		
		var option = 'CIF_Update_form';
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1; //January is 0!

		var yyyy = today.getFullYear();
		if (dd < 10) {
			dd = '0' + dd
		}
		if (mm < 10) {
			mm = '0' + mm
		}
		var date = dd + '/' + mm + '/' + yyyy;
			
			
		if (title == "--Select--") title = "";
		if (Aecb == "--Select--") Aecb = "";					
		if (occupation=="--Select--") occupation="";
		if (resi_country == "--Select--" || resi_country == "Country") resi_country = "";
		if (offc_type == "Residence Type" || offc_type == "--Select--") offc_type = "";
		if (offc_country == "Country" || offc_country == "--Select--") offc_country = "";
		if (e_state == "--Select--")  e_state = "";
		if (pref_contact == "--Select--")  pref_contact = "";
		if (emp_type == "--Select--") emp_type = "";
		if (emp_status == "--Select--") emp_status = "";
		if (marrital == "--Select--") marrital = "";
		if (nationality == "--Select--") nationality = "";
		if (pref_add == "--Select--") pref_add = "";
		if (new_prefemail == "--Select--") new_prefemail = "";
		if (resi_type == "--Select--") resi_type = "";
		
		var sparam = 'First_Name=' + Full_Name + '&Emirates_Id=' + Emirates_Id + '&Passport_Num=' + passportNum + '&wi_name=' + winame +
		'&Pref_Contact=' + pref_contact + '&title=' + title + '&middle_name=' + MiddleName + '&last_name=' + LastName + '&full_name=' + FullName
		+'&resi_flat_no=' + resi1 + '&resi_building=' + resi2 + '&resi_street=' + resi3 + '&resi_type=' + resi_type +
		'&landmark=' + resi4 + '&resi_zip_code=' + resi_zip + '&resi_po_box=' + resi_po + '&resi_city=' + resi_city + '&resi_state=' + resi_state + '&resi_country=' + resi_country + '&offc_flat_no=' + offc1 + '&offc_building_name=' + offc2 + '&offc_street=' + offc3 + '&offc_resi_type=' + offc_type + '&offc_landmark=' + offc4 +
		'&offc_zip_code=' + offc_zip + '&offc_po_box=' + offc_po + '&offc_city=' + offc_city + '&offc_state=' + offc_state + '&offc_country=' + offc_country +
		'&MP1=' + mob1 + '&MP12=' + mob2 + '&MP13=' + mob3 + '&MP2=' + mob21 + '&MP22=' + mob22 + '&MP23=' + mob23 + '&HP1=' + homephone1 +
		'&HP2=' + homephone2 + '&HP3=' + homephone3 + '&offc_phn1=' + offc_phn1 + '&offc_phn2=' + offc_phn2 + '&offc_phn3=' + offc_phn3 +
		'&fax1=' + fax1 + '&fax2=' + fax2 + '&fax3=' + fax3 + '&home_cntry_phn1=' + home_cntry_phn1 + '&home_cntry_phn2=' + home_cntry_phn2 +
		'&home_cntry_phn3=' + home_cntry_phn3 + '&occupation=' + occupation + '&prev_organ=' + prev_organ + '&period_previous_organization=' + period_prev +
		'&nationality=' + nationality + '&Emirates_Id_Expiry=' + EmiratesidExp + '&Passport_Exp_Date=' + PassExpdate + '&Visa=' + Visa + '&Visa_Exp_Date=' + VisaExpDate + '&exis_marsoom=' + Marsoon_exis + '&marsoom=' + Marsoon_new +
		'&Mother_maid=' + Mother + '&AECB=' + Aecb + '&Pref_Add=' + pref_add + '&Prim_Email=' + prim_id + '&Sec_Email=' + sec_id +
		'&E-Statement=' + e_state + '&Emp_Type=' + emp_type + '&Designation=' + designation + '&Comp_Name=' + comp_name + '&Name_of_Emp=' + emp_new_name +
		'&Department=' + department + '&Emp_Num=' + emp_num + '&Nature_of_Busi=' + nature_of_busi + '&Total_Yrs_Emp=' + years_of_emp +
		'&Yrs_In_Busi=' + years_of_business + '&Emp_Status=' + emp_status + '&Date_Of_Join=' + date_joining + '&Marital_Satus=' + marrital +
		'&No_Dependents=' + dependents + '&Since_UAE=' + uae + '&Date1=' + date + '&option=' + option + '&exis_title=' + title_exis +
		'&exis_firstname=' + firstname_exis + '&exis_middlename=' + middlename_exis + '&exis_lastname=' + lastname_exis + '&exis_fullname=' + fullname_exis +
		'&exis_emiratesid=' + emiratesid_exis + '&exis_emiratesexp=' + emiratesex_exis + '&exis_passportnum=' + passportnum_exis +
		'&exis_passportexpiry=' + passportexp_exis + '&exis_visa=' + visa_exis + '&exis_visaexpiry=' + visaexp_exis + '&exis_mother=' + mother_exis +
		'&exis_aecb=' + abcde_exis + '&exis_residenceaddress=' + resiadd_exis + '&exis_offcaddress=' + officeadd_exis + '&exis_prefadd=' + prefadd_exis + '&exis_primid=' + primid_exis + '&exis_secid=' + secid_exis +
		'&exis_estatement=' + estate_exis + '&exis_mobile1=' + mobile1_exis + '&exis_mobile2=' + mobile2_exis + '&exis_homephn=' + hmephn_exis + '&exis_offcphn=' + offcphn_exis + '&exis_fax=' + fax_exis + '&exis_homecntryphn=' + hmecntryphn_exis +
		'&exis_prefcontact=' + prefcontact_exis + '&exis_emptype=' + emptype_exis + '&exis_designation=' + designation_exis + '&exis_compname=' + compname_exis + '&exis_nameofemp=' + empname_exis + '&exis_department=' + department_exis + '&exis_empnum=' + empnum_exis + '&exis_occupation=' + occupation_exis + '&exis_naturebusi=' + nameofbusi_exis + '&exis_totalyrsemp=' + totalyrsemp_exis + '&exis_yrsinbusi=' + yrsbusi_exis + '&exis_empstatus=' + empstatus_exis + '&exis_datejoin=' + datejoining_exis + '&exis_previousorgan=' + prevorgan_exis + '&exis_periodorgan=' + periodorgan_exis +
		'&exis_maritalstatus=' + marital_exis + '&exis_dependents=' + dependents_exis + '&exis_nationality=' + nationality_exis + '&exis_inuae=' + wheninuae_exis + '&exis_prefemail=' + exis_prefemail + '&pref_emailid=' + new_prefemail+ '&CifNo=' + cifno+'&prefOfLang_exis=' + langOfPref_exis+ '&peopleOfDetrm_exis=' + peopleOfDet_exis+ '&podOptions_exis=' + podOptions_exis+ '&podRemarks_exis=' + podRemarks_exis +'&prefOfLang=' + langOfPref_new+ '&peopleOfDetrm=' + peopleOfDet_new+ '&podOptions=' + podOptions_new+ '&podRemarks=' + podRemarks_new;
        
		if (WSNAME != "PBO" && WSNAME != "OPS%20Maker_DE") {
            if (customform.document.getElementById("wdesk:FatcaReason_new").value != "" || customform.document.getElementById("wdesk:FatcaDoc_new").value != "" || customform.document.getElementById("USrelation_new").value != "--Select--") {
                if (customform.document.getElementById("wdesk:validationFatca").value != "Y") {
                    alert("Please Generate the Fatca Form Template");
                    customform.document.getElementById("Generate1").focus();
                    return false;
                }
            } 
			
			
			if(WSNAME == "CSO")
			{
				if (customform.document.getElementById("wdesk:validation").value == "Y") {
					if(sparam != customform.document.getElementById('wdesk:Generated_Data').value)
					{
					 alert("Please Generate the CIF Update Form Template");
						customform.document.getElementById("Generate").focus();
						return false;
					}
					else
					{
						return true;
					}		
				} else {
					alert("Please Generate the CIF Update Form Template");
					customform.document.getElementById("Generate").focus();
					return false;
				}
			
			}
			
			if(WSNAME == "CSO_Rejects")
			{
				if(sparam != customform.document.getElementById('wdesk:Generated_Data').value)
				{
					alert("Please Generate the CIF Update Form Template");
					customform.document.getElementById("Generate").focus();
					return false;
				}
				
				else
				{
					return true;
				}
			
			}
            
        }
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
//Description                 :           to validate type of fields

//***********************************************************************************//	


function validateKeys(value, act)
{
    var re = "";
    var isvalid = "";
    if (value != "") {
	
	
 
        act = act.toLowerCase()
        switch (act) {
		
		case "alphanumeric_address":
			re = /[^a-z0-9-.,+;'\/\\~()-+<>_=:? ]+/i;
		break;
		
        }
        if (re.test(value)) {
		
		if (act == 'alphanumeric_address') {
					alert("This field can only contain alpha-numeric and special characters(+;'\/\\~()-+<>_=:?)");
					value = value.replace(re, "");
					return false;
			}
			return true;
        }
		return true;
    }
	
	return true;
}


function Oecdfieldvalidation(reqtype)
{
	
	var MobilePhone_New1 = customform.document.getElementById('wdesk:MobilePhone_New1').value;
	var sec_mob_phone_newC = customform.document.getElementById('wdesk:sec_mob_phone_newC').value;
	var homephone_newC = customform.document.getElementById('wdesk:homephone_newC').value;
	var office_phn_newC = customform.document.getElementById('wdesk:office_phn_newC').value;
	var homecntryphone_newC = customform.document.getElementById('wdesk:homecntryphone_newC').value;
	var Oecdcity_new = customform.document.getElementById('wdesk:Oecdcity_new').value;
	var offcCountry1 = customform.document.getElementById('offcCountry1').value;
	var office_cntrycode = customform.document.getElementById('office_cntrycode').value;
	
	if((MobilePhone_New1 !="" && MobilePhone_New1 !=null && MobilePhone_New1 != customform.document.getElementById('Phone1CountryCode').value) || (sec_mob_phone_newC !="" && sec_mob_phone_newC !=null && sec_mob_phone_newC != customform.document.getElementById('Phone2CountryCode').value) || (homephone_newC !="" && homephone_newC !=null && homephone_newC != customform.document.getElementById('HomePhoneCountryCode').value) || (office_phn_newC !="" && office_phn_newC !=null && office_phn_newC != customform.document.getElementById('OfficePhoneCountryCode').value)|| (homecntryphone_newC !="" && homecntryphone_newC !=null && homecntryphone_newC != customform.document.getElementById('HomeCountryPhoneCountryCode').value)|| (office_cntrycode != null && office_cntrycode != "" && office_cntrycode != "--Select--" && office_cntrycode != offcCountry1))
	
	{
		
		if(reqtype == 'Oecdcity_new')
		{
			alert('Please select OECD City of birth');
			customform.document.getElementById("wdesk:Oecdcity_new").focus();
			return false;	
		}
		else if(reqtype == 'OECDUndoc_Flag_new')
		{
			alert('Please select CRS Undocumented Flag');
			customform.document.getElementById("OECDUndoc_Flag_new").focus();
			return false;	
		}
		else if(reqtype == 'Oecdcountrytax_new')
		{
			alert('Please select Country Of Tax Residence');
			customform.document.getElementById("wdesk:Oecdcountrytax_new").focus();
			return false;	
		}
		else if(reqtype == 'OecdTin_new')
		{
			alert('Please enter Tax Payer Identification Number 1  or  No TIN Reason 1');
			customform.document.getElementById("wdesk:OecdTin_new").focus();
			return false;	
		}		
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
//Description                 :           to validate emirates,visa and passport expiry date on done

//***********************************************************************************//	

function validateDatepassportexpiryCheck(WSNAME) {

    if (( (WSNAME == "CSO" || WSNAME == "CSO_Rejects") && (customform.document.getElementById('wdesk:isWMSMECase').value == null || customform.document.getElementById('wdesk:isWMSMECase').value == "")) || WSNAME == "OPS%20Maker_DE") {
        var enteredPassportDate = customform.document.getElementById("wdesk:passportExpDate_exis").value;
        var newPassportDate = customform.document.getElementById("wdesk:passportExpDate_new").value;
        if (newPassportDate != "")
            enteredPassportDate = newPassportDate;

        var enteredVisaDate = customform.document.getElementById("wdesk:visaExpDate_exis").value;
        var newVisaDate = customform.document.getElementById("wdesk:visaExpDate_new").value;
        if (newVisaDate != "")
            enteredVisaDate = newVisaDate;

        var enteredEmiratesDate = customform.document.getElementById("wdesk:emiratesidexp_exis").value;
        var newEmiratesDate = customform.document.getElementById("wdesk:emiratesidexp_new").value;
        if (newEmiratesDate != "")
            enteredEmiratesDate = newEmiratesDate;

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
            alert("Passport has Expired.Case cannot be initiated.");
            return false;
        } else if (timeDiffVisa < 0) {
            alert("Visa has Expired.Case cannot be initiated.");
            return false;
        } else if (timeDiffEmirates < 0) {
            alert("Emirates ID has Expired.Case cannot be initiated.");
            return false;
        }
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
//Description                 :           to validate form on done with respect to the workstepname

//***********************************************************************************//	

function decisionvalidation(WSNAME) {
    if (WSNAME == "CSO_Doc_Scan") {
        if (customform.document.getElementById("wdesk:Doc_Scan_Dec").value == "" || customform.document.getElementById("wdesk:Doc_Scan_Dec").value == "--Select--") {
            alert("Please select the Decision");
            customform.document.getElementById("Doc_Scan_Dec").focus();
            return false;
        } else
            return true;

    }else if (WSNAME == "OPS_Checker_Review") {

        if (customform.document.getElementById("Dec_OPS_Checker").value == "--Select--" || customform.document.getElementById("Dec_OPS_Checker").value == "") {
            alert("Please select the Decision");
            customform.document.getElementById("Dec_OPS_Checker").focus();
            return false;
        }

		// Start - If maker has rejected the workitem then checker should not be able to approve it added on 03052020 by Angad
		if (customform.document.getElementById("wdesk:OPSMakerDEDecision").value == "Reject" && customform.document.getElementById("Dec_OPS_Checker").value == "Approved") {
			alert("Approve Decision cannot be selected since Maker has rejected the workitem.");
            customform.document.getElementById("Dec_OPS_Checker").focus();
            return false;
		}
		// End - If maker has rejected the workitem then checker should not be able to approve it added on 03052020 by Angad
		
        if (customform.document.getElementById("Dec_OPS_Checker").value == "Reject To CSO" || customform.document.getElementById("Dec_OPS_Checker").value == "Reject To Maker") {
            if (customform.document.getElementById("rejReasonCodes").value == "" || customform.document.getElementById("rejReasonCodes").value == "NO_CHANGE") {
                alert("Please select the reject reason");
                customform.document.getElementById("btnRejReason").focus();
                return false;
            }
        } 
		// Start - Employer Code field added as part of CR JIRA SCRCIF-78 and mailsubject Employer Code changes added on 06062017
		else {
			if (customform.document.getElementById("wdesk:EmployerCode_new").value == "")
			{
				if (customform.document.getElementById("wdesk:emp_name_new").value != ""){ //If Condition modified as a part of JIRA- BU-353
				
					 alert("Please Enter Employer Code");
					customform.document.getElementById("wdesk:EmployerCode_new").focus();
					return false;
					
				}
			}
		}
		//End - Employer Code field added as part of CR JIRA SCRCIF-78 and mailsubject Employer Code changes added on 06062017
		
		//***View Sign Validation is added on Decision Field for CR Point added by siva on 12092018 ******************************
		if (customform.document.getElementById("wdesk:sign_matched_checker").value == "" && customform.document.getElementById("Dec_OPS_Checker").value == "Approved"){
			alert("The decision cannot be taken as Approved if Signature is not viewed");
			customform.document.getElementById("viewSign").focus();
			return false;
		}
		else if(customform.document.getElementById("wdesk:sign_matched_checker").value != "Yes" && customform.document.getElementById("Dec_OPS_Checker").value == "Approved")
		{
			alert("The decision cannot be Approved if Signature doesn't match");
			customform.document.getElementById("Dec_OPS_Checker").focus();
			return false;			
		}
		//************************************************************************************************************************
		
    } else if (WSNAME == "OPS%20Maker_DE" || (WSNAME == "CSO_Rejects" && customform.document.getElementById('wdesk:Channel').value == "Customer Initiated")) {
	
		if(WSNAME == "OPS%20Maker_DE")
		{
			if (customform.document.getElementById("OPSMakerDEDecision").value == "--Select--" || customform.document.getElementById("OPSMakerDEDecision").value == "") {
				alert("Please select the Decision");
			   
				customform.document.getElementById("OPSMakerDEDecision").focus();
				return false;
			}
			
			if (customform.document.getElementById("wdesk:OPSMakerDEDecision").value == "Reject") {
				if (customform.document.getElementById("rejReasonCodes").value == "" || customform.document.getElementById("rejReasonCodes").value == "NO_CHANGE") {
					alert("Please select the reject reason");
					customform.document.getElementById("btnRejReason").focus();
					return false;
				} else {
					return true;
				}
			}
			if (customform.document.getElementById("wdesk:OPSMakerDEDecision").value != "Reject") {
				if (customform.document.getElementById("wdesk:CIFReq_Type").value == "")
				{
					alert("Please amend the CIF details or select any Request Type");
					customform.document.getElementById("wdesk:FirstName_New").focus();
					return false;
				}
			}
		}
	
		if(WSNAME == "CSO_Rejects")
		{
			 if (customform.document.getElementById("Dec_CSO_Rejects").value == "--Select--" || customform.document.getElementById("Dec_CSO_Rejects").value == "") {
            alert("Please select the Decision");
            customform.document.getElementById("Dec_CSO_Rejects").focus();
            return false;
			}
		
		}
	
        
		// added below condition as when AECB existing is No then AECB new will be mandatory as part of JIRA SCRCIF-108, Earlier it was always mandatory
        if (customform.document.getElementById("wdesk:abcdelig_exis").value == "No") {
			if (customform.document.getElementById("abcdelig_new").value == "--Select--") {
				alert("Please select the AECB Eligible field");
				customform.document.getElementById("abcdelig_new").focus();
				return false;
			}
		}

		if (customform.document.getElementById("wdesk:nation_exist").value != "AE") {	
			if ((customform.document.getElementById("wdesk:comp_name_new").value != "" && customform.document.getElementById("wdesk:comp_name_new").value != null) || (customform.document.getElementById("wdesk:emp_name_new").value != "" && customform.document.getElementById("wdesk:emp_name_new").value != null) || (customform.document.getElementById("occupation_new").value != "--Select--" && customform.document.getElementById("occupation_new").value != null && customform.document.getElementById("occupation_new").value != "") || (customform.document.getElementById("wdesk:naturebusiness_new").value != "" && customform.document.getElementById("wdesk:naturebusiness_new").value != null)) {
				if (customform.document.getElementById("wdesk:visa_new").value == "") {

					alert("Visa Number is mandatory");
					customform.document.getElementById("wdesk:visa_new").focus();
					return false;
				}
				if (customform.document.getElementById("wdesk:visaExpDate_new").value == "") {
					alert("Visa Expiry Date is mandatory");
					customform.document.getElementById("wdesk:visaExpDate_new").focus();
					return false;
				}
				if (customform.document.getElementById("wdesk:visa_new").value != "" && customform.document.getElementById("wdesk:visaExpDate_new").value != "")
				{
					//alert("fields filled");
				} else {
					alert("Visa Number and Visa Expiry Date is mandatory to be filled");
					customform.document.getElementById("wdesk:visa_new").focus();
					return false;
				}
			}
		}
		
		// JIRA SCRCIF-142
		if (customform.document.getElementById("wdesk:visaExpDate_new").value != "" && customform.document.getElementById("wdesk:visa_new").value =="" ) 
		{
                alert("Visa Number is mandatory if Visa Expiry Date is entered");
                customform.document.getElementById("wdesk:visa_new").focus();
                return false;
		}
		
		//nikita - passport CR 11/8/16
		if ((customform.document.getElementById("wdesk:PassportNumber_New").value != "" && customform.document.getElementById("wdesk:PassportNumber_New").value != null)) 
		{
            if ((customform.document.getElementById("wdesk:passportExpDate_new").value == "" || customform.document.getElementById("wdesk:passportExpDate_new").value == null)) 
			{
                alert("Please Enter the Passport Expiry date");
				
                customform.document.getElementById("wdesk:passportExpDate_new").focus();
                return false;
            }
			else  
			{ 
                var enteredPassportDate = customform.document.getElementById("wdesk:passportExpDate_new").value;
				var today = new Date();

				var arrStartDate3 = enteredPassportDate.split("/");
				var date3 = new Date(arrStartDate3[2], arrStartDate3[1] - 1, arrStartDate3[0]);
				var timeDiffPassport = date3.getTime() - today.getTime();
				if (timeDiffPassport < 0) {
					alert("Passport date has Expired WorkItem cannot be initiated.");
					return false;
				}
			}
		}	
		var passportNumber = customform.document.getElementById("wdesk:PassportNumber_New").value;
		var passportExpDate = customform.document.getElementById("wdesk:passportExpDate_new").value;
		if(passportExpDate != '' && passportExpDate != null && (passportNumber == '' || passportNumber == null))
		{
			alert("Please enter new passport number");
			customform.document.getElementById("wdesk:PassportNumber_New").focus();
			return false;
		}
		//Expiry date year check CR added by Shamily
		var PassportExpdate = customform.document.getElementById("wdesk:passportExpDate_exis").value;
		var Passportexpyear = PassportExpdate.split("/");
		
		if((customform.document.getElementById("wdesk:passportExpDate_new").value == "" || customform.document.getElementById("wdesk:passportExpDate_new").value == null ) && Passportexpyear[2]=='2099')
		{
			 alert("Please enter new Passport expiry date as existing Passport date year is 2099");
			 customform.document.getElementById("wdesk:passportExpDate_new").focus();
              return false;
		}
        if (customform.document.getElementById("pref_email_new").value != "--Select--") {
            if (customform.document.getElementById("pref_email_new").value == "Primary Email ID") {
                if (customform.document.getElementById("wdesk:primary_emailid_new").value == "") {
                    alert("Primary Email Id is mandatory to fill.");
                    customform.document.getElementById("wdesk:primary_emailid_new").focus();
                    return false;
                }
            }
            if (customform.document.getElementById("pref_email_new").value == "Secondary Email ID") {
                if (customform.document.getElementById("wdesk:sec_email_new").value == "") {
                    alert("Secondary Email Id is mandatory to fill.");
                    customform.document.getElementById("wdesk:sec_email_new").focus();
                    return false;
                }
            }
        }

        //modified by Shamily to make PO Box mandatory only for country_of_res_exis as "UAE"
        if (customform.document.getElementById("pref_add_new").value != "") {
            if (customform.document.getElementById("pref_add_new").value == "Office") {
			
			if(customform.document.getElementById("wdesk:country_of_res_exis").value == "AE" && customform.document.getElementById("wdesk:office_pobox").value == "")
			{
                if ( customform.document.getElementById("wdesk:office_city").value == "" && customform.document.getElementById("office_cntrycode").value == "" || customform.document.getElementById("office_cntrycode").value == "--Select--" || customform.document.getElementById("office_cntrycode").value == null) {
                     
                        alert("Office PO Box field,City and Country are mandatory to fill");
                        customform.document.getElementById("wdesk:office_pobox").focus();
                        return false;
                    }
					else if(customform.document.getElementById("wdesk:office_city").value == ""){
						alert("Office PO Box field,City field is mandatory to fill");
                        customform.document.getElementById("wdesk:office_city").focus();
                        return false;
					}else if(customform.document.getElementById("office_cntrycode").value == "" || customform.document.getElementById("office_cntrycode").value == "--Select--" || customform.document.getElementById("office_cntrycode").value == null){
						alert("Office Country field is mandatory to fill");
                        customform.document.getElementById("office_cntrycode").focus();
                        return false;
					}
					else{
						
						alert("Office PO Box field is mandatory to fill");
                        customform.document.getElementById("wdesk:office_pobox").focus();
                        return false;
					}
                }
				
				 if (customform.document.getElementById("wdesk:office_city").value == "") {
                    if (customform.document.getElementById("office_cntrycode").value == "" || customform.document.getElementById("office_cntrycode").value == "--Select--" || customform.document.getElementById("office_cntrycode").value == null) {
                        alert("Office City field and Country are mandatory to fill");
                        customform.document.getElementById("wdesk:office_city").focus();
                        return false;
                    }
					else{
						alert("Office City field is mandatory to fill");
                        customform.document.getElementById("wdesk:office_city").focus();
                        return false;
					}
                }else if (customform.document.getElementById("office_cntrycode").value == "" || customform.document.getElementById("office_cntrycode").value == "--Select--" || customform.document.getElementById("office_cntrycode").value == null) {
                    alert("Office Country field is mandatory to fill");
                    customform.document.getElementById("office_cntrycode").focus();
                    return false;
                }
            }
			//modified by Shamily to unselect resi_cntrycode when all other residence  fields are not entered
            if (customform.document.getElementById("pref_add_new").value == "Home") {
				/*if((customform.document.getElementById("wdesk:resi_line2").value == "" || customform.document.getElementById("wdesk:resi_line2").value == null) && (customform.document.getElementById("wdesk:resi_line1").value == "" || customform.document.getElementById("wdesk:resi_line1").value == null) && (customform.document.getElementById("wdesk:resi_line3").value == "" || customform.document.getElementById("wdesk:resi_line3").value == null) && (customform.document.getElementById("resi_restype").value == "" || customform.document.getElementById("resi_restype").value == "--Select--" || customform.document.getElementById("resi_restype").value == null) && (customform.document.getElementById("wdesk:resi_line4").value == "" || customform.document.getElementById("wdesk:resi_line4").value == null) && (customform.document.getElementById("wdesk:resi_zipcode").value == "" || customform.document.getElementById("wdesk:resi_zipcode").value == null) && (customform.document.getElementById("wdesk:resi_pobox").value == "" || customform.document.getElementById("wdesk:resi_pobox").value == null) || (customform.document.getElementById("resi_city").value == "" || customform.document.getElementById("resi_city").value == null) && (customform.document.getElementById("resi_state").value == "" || customform.document.getElementById("resi_state").value == null) && (customform.document.getElementById("resi_cntrycode").value != "" && customform.document.getElementById("resi_cntrycode").value != "--Select--" && customform.document.getElementById("resi_cntrycode").value != null))
				{
					customform.document.getElementById("resi_cntrycode").value = '--Select--';
					customform.document.getElementById("wdesk:resi_cntrycode").value = '';
			
				}*/
				//modified by Shamily to make PO Box mandatory only for country_of_res_exis as "UAE"
				if(customform.document.getElementById("wdesk:country_of_res_exis").value == "AE" && customform.document.getElementById("wdesk:resi_pobox").value == "" )
				{
					if ( customform.document.getElementById("wdesk:resi_city").value == "") {
                   
                        alert("Residence PO Box field and City are mandatory to fill");
                        customform.document.getElementById("wdesk:resi_pobox").focus();
                        return false;
                  
					}
					else{
						alert("Residence PO Box field and City are mandatory to fill");
                        customform.document.getElementById("wdesk:resi_pobox").focus();
                        return false;
					}
				  }
				  if (customform.document.getElementById("wdesk:resi_city").value == "") {
                    alert("Residence City field is mandatory to fill");
                    customform.document.getElementById("wdesk:resi_city").focus();
                    return false;
                }
				
            }
        }

        if ((customform.document.getElementById("wdesk:resi_line2").value != "" && customform.document.getElementById("wdesk:resi_line2").value != null) || (customform.document.getElementById("wdesk:resi_line1").value != "" && customform.document.getElementById("wdesk:resi_line1").value != null) || (customform.document.getElementById("wdesk:resi_line3").value != "" && customform.document.getElementById("wdesk:resi_line3").value != null) || (customform.document.getElementById("resi_restype").value != "" && customform.document.getElementById("resi_restype").value != "--Select--" && customform.document.getElementById("resi_restype").value != null) || (customform.document.getElementById("wdesk:resi_line4").value != "" && customform.document.getElementById("wdesk:resi_line4").value != null) || (customform.document.getElementById("wdesk:resi_zipcode").value != "" && customform.document.getElementById("wdesk:resi_zipcode").value != null) || (customform.document.getElementById("wdesk:resi_pobox").value != "" && customform.document.getElementById("wdesk:resi_pobox").value != null) || (customform.document.getElementById("wdesk:resi_city").value != "" && customform.document.getElementById("wdesk:resi_city").value != null) || (customform.document.getElementById("wdesk:resi_state").value != "" && customform.document.getElementById("wdesk:resi_state").value != null)) // resedence country check is removed as part of JIRA SCRCIF-121
		{
            if (customform.document.getElementById("wdesk:resi_line1").value == "") {
                alert('Please enter Residence Flat Number');
                customform.document.getElementById("wdesk:resi_line1").focus();
                return false;
            }
            if (customform.document.getElementById("wdesk:resi_city").value == "") {
                alert('Please enter Residence City');
                customform.document.getElementById("wdesk:resi_city").focus();
                return false;
            }
		/*if(customform.document.getElementById("resi_cntrycode").value == '--Select--' || customform.document.getElementById("resi_cntrycode").value == '')
			{
				customform.document.getElementById('resi_cntrycode').options[customform.document.getElementById('resi_cntrycode').selectedIndex].text=customform.document.getElementById("wdesk:resi_countryexis").value;
				document.getElementById('customform').contentWindow.showlabel('resi_country')
					//return false;
			} */
			//commented by Shamily to remove mandatory condition at resi_cntrycode
         /*   if (customform.document.getElementById("resi_cntrycode").value == "--Select--" || customform.document.getElementById("resi_cntrycode").value == "") {
                alert('Please enter Residence Country');
                customform.document.getElementById("resi_cntrycode").focus();
                return false;
            } */
        }

        if ((customform.document.getElementById("wdesk:office_line2").value != "" && customform.document.getElementById("wdesk:office_line2").value != null) || (customform.document.getElementById("wdesk:office_line1").value != "" && customform.document.getElementById("wdesk:office_line1").value != null) || (customform.document.getElementById("wdesk:office_line3").value != "" && customform.document.getElementById("wdesk:office_line3").value != null) || (customform.document.getElementById("office_restype").value != "" && customform.document.getElementById("office_restype").value != "--Select--" && customform.document.getElementById("office_restype").value != null) || (customform.document.getElementById("wdesk:office_line4").value != "" && customform.document.getElementById("wdesk:office_line4").value != null) || (customform.document.getElementById("wdesk:office_zipcode").value != "" && customform.document.getElementById("wdesk:office_zipcode").value != null) || (customform.document.getElementById("wdesk:office_pobox").value != "" && customform.document.getElementById("wdesk:office_pobox").value != null) || (customform.document.getElementById("wdesk:office_city").value != "" && customform.document.getElementById("wdesk:office_city").value != null) || (customform.document.getElementById("wdesk:office_state").value != "" && customform.document.getElementById("wdesk:office_state").value != null)) // office country check is removed as part of JIRA SCRCIF-121
		{
            if (customform.document.getElementById("wdesk:office_line1").value == "") {
                alert('Please enter Office Flat No./Designation');
                customform.document.getElementById("wdesk:office_line1").focus();
                return false;
            }
            if (customform.document.getElementById("wdesk:office_city").value == "") {
                alert('Please enter Office City');
                customform.document.getElementById("wdesk:office_city").focus();
                return false;
            }
            if (customform.document.getElementById("office_cntrycode").value == "--Select--" || customform.document.getElementById("office_cntrycode").value == "") {
                alert('Please enter Office Country');
                customform.document.getElementById("office_cntrycode").focus();
                return false;
            }
        }

			
		//modified for changing nonResident to country_of_res_exis and making fields mandatory
		var country_of_res_exis = customform.document.getElementById("wdesk:country_of_res_exis").value;
		
      /*  if (nonResident == "" || nonResident == "--Select--" || nonResident == null) {
            nonResident = customform.document.getElementById("wdesk:nonResident").value;
        } */
		
        if (country_of_res_exis == "AE" ) {
            if  (customform.document.getElementById("wdesk:emiratesid_new").value == "" && customform.document.getElementById("wdesk:emirates_id").value == "" && (customform.document.getElementById("wdesk:Marsoon_new").value == "" || customform.document.getElementById("wdesk:Marsoon_new").value == null) &&(customform.document.getElementById("wdesk:Marsoon_exis").value== "" || customform.document.getElementById("wdesk:Marsoon_exis").value == null) ) {
                alert("Please enter Emirates ID or Marsoon Id Number");
                customform.document.getElementById("wdesk:emiratesid_new").focus();
                return false;
            } else if(customform.document.getElementById("wdesk:emiratesid_new").value != "" || customform.document.getElementById("wdesk:emirates_id").value != "") {
				if(customform.document.getElementById("wdesk:emiratesidexp_exis").value == "" && customform.document.getElementById("wdesk:emiratesidexp_new").value == "")
				{
					alert("Please enter Emirates ID Expiry date");
					customform.document.getElementById("wdesk:emiratesidexp_new").focus();
					return false;
				}
               else  if (customform.document.getElementById("wdesk:emiratesid_new").value != "") {
                    var enteredEmiratesDate = customform.document.getElementById("wdesk:emiratesidexp_new").value;
                    if (customform.document.getElementById("wdesk:emiratesidexp_new").value != "") {
                        enteredEmiratesDate = customform.document.getElementById("wdesk:emiratesidexp_new").value;
                    }
                    var today = new Date();

                    var arrStartDate3 = enteredEmiratesDate.split("/");
                    var date3 = new Date(arrStartDate3[2], arrStartDate3[1] - 1, arrStartDate3[0]);
                    var timeDiffEmirates = date3.getTime() - today.getTime();
                    if (timeDiffEmirates < 0) {
                        alert("Emirates ID has Expired WorkItem cannot be initiated.");
                        return false;
                    }
                } else {
                    var enteredEmiratesDate = customform.document.getElementById("wdesk:emiratesidexp_new").value;
                    if (customform.document.getElementById("wdesk:emiratesidexp_exis").value != "" && customform.document.getElementById("wdesk:emiratesidexp_exis").value != null) {
                        enteredEmiratesDate = customform.document.getElementById("wdesk:emiratesidexp_exis").value;
                    }
                    var today = new Date();

                    var arrStartDate3 = enteredEmiratesDate.split("/");
                    var date3 = new Date(arrStartDate3[2], arrStartDate3[1] - 1, arrStartDate3[0]);
                    var timeDiffEmirates = date3.getTime() - today.getTime();
                    if (timeDiffEmirates < 0) {
                        alert("Emirates ID has Expired WorkItem cannot be initiated.");
                        return false;
                    }
                }
            }
			
        }
		
        var FatcaDocNew = customform.document.getElementById("wdesk:FatcaDoc_new").value;

        if (customform.document.getElementById("USrelation_new").value == "R" && FatcaDocNew.indexOf("W9") == -1) {
            alert("W9 form is mandatory as US Relation is Yes- Reportable");
            customform.document.getElementById("FatcaDocNew").focus();
            return false;
        } else if (customform.document.getElementById("USrelation_new").value == "N" && FatcaDocNew.indexOf("W8") == -1) {
            alert("W8 form is mandatory as US Relation is Yes-Not Reportable");
            customform.document.getElementById("FatcaDocNew").focus();
            return false;
        }
        var today1 = new Date();
		//added by shamily to make signed date mandatory
        var enteredSignedDate = customform.document.getElementById("wdesk:SignedDate_new").value;
        var arrStartDate4 = enteredSignedDate.split("/");
        var date4 = new Date(arrStartDate4[2], arrStartDate4[1] - 1, arrStartDate4[0]);
        var timeDiffSigned = date4.getTime() - today1.getTime();

        if (FatcaDocNew.indexOf("W8") != -1) {
            if ((customform.document.getElementById("wdesk:SignedDate_new").value == "" || customform.document.getElementById("wdesk:SignedDate_new").value == null) && (customform.document.getElementById("wdesk:SignedDate_exis").value == "" || customform.document.getElementById("wdesk:SignedDate_exis").value == null)) {
                alert("Signed date is mandatory for fatca document W8 form");
                customform.document.getElementById("wdesk:SignedDate_new").focus();
                return false;
            } else if (timeDiffSigned > 0) {
                alert("Signed date should be less then or equal to Current date");
                customform.document.getElementById("wdesk:SignedDate_new").focus();
                return false;
            }
        }
	
		    if(customform.document.getElementById("country_of_res_new").value =="UAE"  && customform.document.getElementById("wdesk:MobilePhone_New1").value !="00971")
			{
				alert("Mobile Phone 1 Country code for UAE Country of residence should be 00971");
				customform.document.getElementById("wdesk:MobilePhone_New1").focus();
				return false;
			}		
			else if ((customform.document.getElementById("country_of_res_new").value =="--Select--" || customform.document.getElementById("country_of_res_new").value ==null || customform.document.getElementById("country_of_res_new").value =="" )&& customform.document.getElementById("wdesk:country_of_res_exis").value =="UAE")
			{
				alert("Mobile Phone 1 Country code for UAE Country of residence should be 00971");
				customform.document.getElementById("wdesk:MobilePhone_New1").focus();
				return false;
			}
			
			
		//visa and emirates expiry date same cr
		
		if(!document.getElementById('customform').contentWindow.emidexpdatevaliation("Emirates expiry date"))
			return false;	
		
		
		// home phone should not be equal to mob phn 1 and 2 validation cr
		
		var MobilePhone_Existing =  customform.document.getElementById("wdesk:MobilePhone_Existing").value;
		MobilePhone_Existing =  MobilePhone_Existing.replace('+','');
		MobilePhone_Existing = MobilePhone_Existing.replace('(','');
		MobilePhone_Existing = MobilePhone_Existing.replace(')','');
		
		var sec_mob_phone_exis =customform.document.getElementById("wdesk:sec_mob_phone_exis").value;
		sec_mob_phone_exis = sec_mob_phone_exis.replace('+','');
		sec_mob_phone_exis = sec_mob_phone_exis.replace('(','');
		sec_mob_phone_exis = sec_mob_phone_exis.replace(')','');
		var homephone_newC =  customform.document.getElementById("wdesk:homephone_newC").value;
		var homephone_newN = customform.document.getElementById("wdesk:homephone_newN").value;
		var homephone_newE = customform.document.getElementById("wdesk:homephone_newE").value;
		var HomePhn = homephone_newC +homephone_newN+homephone_newE;
		
		HomePhn = HomePhn.replace(null,'');
		var MobilePhone_New1 = customform.document.getElementById("wdesk:MobilePhone_New1").value;
		var MobilePhone_New = customform.document.getElementById("wdesk:MobilePhone_New").value;
		var MobilePhone_New2 = customform.document.getElementById("wdesk:MobilePhone_New2").value;
		var MobilePhn1 = MobilePhone_New1+MobilePhone_New+MobilePhone_New2;
		MobilePhn1 = MobilePhn1.replace(null,'');
		
		var sec_mob_phone_newC = customform.document.getElementById("wdesk:sec_mob_phone_newC").value;
		var sec_mob_phone_newN = customform.document.getElementById("wdesk:sec_mob_phone_newN").value;
		var sec_mob_phone_newE = customform.document.getElementById("wdesk:sec_mob_phone_newE").value;
		var mobilePhn2 = sec_mob_phone_newC+sec_mob_phone_newN+sec_mob_phone_newE;
		mobilePhn2 = mobilePhn2.replace(null,'');
		if(HomePhn != "" && HomePhn != null)
		{
			if(MobilePhn1 != "" & MobilePhn1 != null && HomePhn == MobilePhn1)
			{
				alert("Home Phone should not be equal to mobile phone 1");
				customform.document.getElementById("wdesk:homephone_newE").focus();
				return false;
			}
			else if ((MobilePhn1 == "" || MobilePhn1 == null) && MobilePhone_Existing != "" && MobilePhone_Existing != null && MobilePhone_Existing == HomePhn)
			{
				alert("Home Phone should not be equal to mobile phone 1");
				customform.document.getElementById("wdesk:homephone_newE").focus();
				return false;
			}
		
			if(mobilePhn2 != "" & mobilePhn2 != null && HomePhn == mobilePhn2)
			{
				alert("Home Phone should not be equal to mobile phone 2");
				customform.document.getElementById("wdesk:homephone_newE").focus();
				return false;
			}
			else if ((mobilePhn2 == "" || mobilePhn2 == null) && sec_mob_phone_exis != "" && sec_mob_phone_exis != null && sec_mob_phone_exis == HomePhn)
			{
				alert("Home Phone should not be equal to mobile phone 2");
				customform.document.getElementById("wdesk:homephone_newE").focus();
				return false;
			}
		
		}	
	
		//Commented below by Amandeep on 18 11 2016		
		
		// start digit home,office phone and fax validation 
		/*var homephone_newE = customform.document.getElementById("wdesk:homephone_newE").value;
		var hphn = homephone_newE;
		homephone_newE = homephone_newE.substring(0,1);
		var office_phn_newE = customform.document.getElementById("wdesk:office_phn_newE").value;
		var ophn = office_phn_newE;
		office_phn_newE = office_phn_newE.substring(0,1);
		var fax_newE =customform.document.getElementById("wdesk:fax_newE").value;
		var fphn = fax_newE;
		fax_newE = fax_newE.substring(0,1);
		
		if(customform.document.getElementById("wdesk:homephone_newE").value != '' && customform.document.getElementById("wdesk:homephone_newE").value != null)
		{
			if(hphn.length <8)
			{
				alert('Length of Home Phone number should be 8');
				return false;
			}
			if(homephone_newE == '0' || homephone_newE == '1' || homephone_newE == '8')
			{
				alert("Home Phone should start from 2,3,4,5,6,7 or 9");
				customform.document.getElementById("wdesk:homephone_newE").focus();
				return false;
			}
		}
		if(customform.document.getElementById("wdesk:office_phn_newE").value != '' && customform.document.getElementById("wdesk:office_phn_newE").value != null)
		{
			if(ophn.length <8)
			{
				alert('Length of Office Phone number should be 8');
				return false;
			}
			if(office_phn_newE == '0' || office_phn_newE == '1' || office_phn_newE == '8')
			{
				alert("Office Phone should start from 2,3,4,5,6,7 or 9");
				customform.document.getElementById("wdesk:office_phn_newE").focus();
				return false;
			}
		}	
		if(customform.document.getElementById("wdesk:fax_newE").value != '' && customform.document.getElementById("wdesk:fax_newE").value != null)
		{
			if(fphn.length <8)
			{
				alert('Length of Fax  number should be 8');
				return false;
			}
			if(fax_newE == '0' || fax_newE == '1' || fax_newE == '8')
			{
				alert("Fax should start from 2,3,4,5,6,7 or 9");
				customform.document.getElementById("wdesk:fax_newE").focus();
				return false;
			}
		}
		*/
		//Added below by Amandeep on 18 11 2016
		if(!document.getElementById('customform').contentWindow.hmphnstart("home phone"))
			return false;
		if(!document.getElementById('customform').contentWindow.hmphnstart("Office phone"))
			return false;
		if(!document.getElementById('customform').contentWindow.hmphnstart("Fax"))
			return false;
		//added by shamily for self employed emplyment types validation CR
		if(!document.getElementById('customform').contentWindow.validateemptype())
		{
			if(customform.document.getElementById("emp_type_new").value == "Self employed")
			{
			

				if(customform.document.getElementById('IndustrySegment_new').value == "" || customform.document.getElementById('IndustrySegment_new').value == null || customform.document.getElementById('IndustrySegment_new').value =="--Select--")
				{
					alert("Please select Industry Segment ");
					customform.document.getElementById("IndustrySegment_new").focus();
					return false;
				}
				if(customform.document.getElementById('IndustrySubSegment_new').value == "" || customform.document.getElementById('IndustrySubSegment_new').value == null || customform.document.getElementById('IndustrySubSegment_new').value =="--Select--")
				{
					alert("Please select Industry Sub Segment ");
					customform.document.getElementById("IndustrySubSegment_new").focus();
					return false;
				}
				/*if(customform.document.getElementById('DealwithCont_new').value == "" || customform.document.getElementById('DealwithCont_new').value == null || customform.document.getElementById('DealwithCont_new').value =="--Select--")
				{
					alert("Please select Dealing with Countries ");
					customform.document.getElementById("DealwithCont_new").focus();
					return false;
				}*/
			}
			
		}
		//modified by Shamily for email mandatory for estatement value 9 jan 2017
		if(customform.document.getElementById("E_Stmnt_regstrd_new").value=="Yes" && (customform.document.getElementById("wdesk:E_Stmnt_regstrd_newload").value=="--Select--" || customform.document.getElementById("wdesk:E_Stmnt_regstrd_newload").value==""|| customform.document.getElementById("wdesk:E_Stmnt_regstrd_newload").value==null ||  customform.document.getElementById("wdesk:E_Stmnt_regstrd_newload").value=="No"))
		{
			if(customform.document.getElementById("wdesk:primary_emailid_new").value=="")
			{
				alert("Primary Email ID is mandatory when E-Statement Registered is Yes.");
				customform.document.getElementById("wdesk:primary_emailid_new").focus();
				return false;
			}
			
		}
        var enteredPassportDate = customform.document.getElementById("wdesk:passportExpDate_exis").value;
        if (customform.document.getElementById("wdesk:passportExpDate_new").value != "") {
            enteredPassportDate = customform.document.getElementById("wdesk:passportExpDate_new").value;
        }
        var enteredVisaDate = customform.document.getElementById("wdesk:visaExpDate_exis").value;
        if (customform.document.getElementById("wdesk:visaExpDate_new").value != "") {
            enteredVisaDate = customform.document.getElementById("wdesk:visaExpDate_new").value;
        }
        var enteredEmiratesDate = customform.document.getElementById("wdesk:emiratesidexp_exis").value;
        if (customform.document.getElementById("wdesk:emiratesidexp_new").value != "") {
            enteredEmiratesDate = customform.document.getElementById("wdesk:emiratesidexp_new").value;
        }
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
            alert("Passport Expiry Date has Expired.WorkItem cannot be instantiated.");
            return false;
        } else if (timeDiffVisa < 0) {
            alert("Visa Expiry Date has Expired.WorkItem cannot be instantiated.");
            return false;
        } else if (timeDiffEmirates < 0) {
            alert("Emirates Expiry Date has Expired.WorkItem cannot be instantiated.");
            return false;
        }
		//Expiry date year check CR added by Shamily
		var VisaExpirydate = customform.document.getElementById("wdesk:visaExpDate_exis").value;
		var Visaexpyear = VisaExpirydate.split("/");
		
		if((customform.document.getElementById("wdesk:visaExpDate_new").value == "" || customform.document.getElementById("wdesk:visaExpDate_new").value == null ) && Visaexpyear[2]=='2099')
		{
			 alert("Please enter new Visa expiry date as existing Visa date year is 2099");
              customform.document.getElementById("wdesk:visaExpDate_new").focus();
			  return false;
		}
		
		if(customform.document.getElementById("wdesk:primary_emailid_new").value=="" && customform.document.getElementById("E_Stmnt_regstrd_new").value=="Yes")
		{
			alert("Primary Email ID is mandatory when E-Statement Registered is Yes.");
			customform.document.getElementById("wdesk:primary_emailid_new").focus();
            return false;
		}
		var nationality = "";
		if(customform.document.getElementById("nation_new").value != '--Select--' && customform.document.getElementById("nation_new").value!= null&& customform.document.getElementById("nation_new").value!= "")
		{
			nationality = customform.document.getElementById("nation_new").value;
		}
		else
		{
			nationality = customform.document.getElementById('wdesk:nation_exist').value;
		}
		if(nationality == "US")
		{
			if((customform.document.getElementById("FatcaDocNew").value == "" || customform.document.getElementById("FatcaDocNew").value == null)  && (customform.document.getElementById("wdesk:FatcaDoc").value == "" || customform.document.getElementById("wdesk:FatcaDoc").value == null))
			{
				alert("For US Nationality Fatca Document is mandatory");
				return false;
			}
		}
		// added by shamily for OECD city of birth validation
	
			if(customform.document.getElementById("wdesk:Oecdcity_new").value == "" || customform.document.getElementById("wdesk:Oecdcity_new").value == null)
			{
				if(!Oecdfieldvalidation("wdesk:Oecdcity_new"))
				{
					return false;
				}
			}
		// added by shamily for OECD country of birth validation
		var Oecdcountry = customform.document.getElementById('wdesk:Oecdcountry').value;
		var Oecdcountry_new = customform.document.getElementById('wdesk:Oecdcountry_new').value;
		if((Oecdcountry_new == "" || Oecdcountry_new == null || Oecdcountry_new == "--Select--") && (Oecdcountry == "" || Oecdcountry == null))
		{
			alert('Please select OECD Country of birth');
			customform.document.getElementById("wdesk:Oecdcountry_new").focus();
			return false;
		} 
		var OECDUndoc_Flag_new = customform.document.getElementById('OECDUndoc_Flag_new').value;
		if(OECDUndoc_Flag_new =='--Select--' || OECDUndoc_Flag_new =='' || OECDUndoc_Flag_new ==null)
		{
			if(!Oecdfieldvalidation("OECDUndoc_Flag_new"))
			{
				return false;
			}
		}
		if(OECDUndoc_Flag_new == 'Yes' &&( customform.document.getElementById('OECDUndocreason_new').value == '--Select--' ||  customform.document.getElementById('OECDUndocreason_new').value == '' ||  customform.document.getElementById('OECDUndocreason_new').value == null))
		{
			alert('Please select CRS Undocumented Flag Reason');
			customform.document.getElementById("OECDUndocreason_new").focus();
			return false;
		}
		if(OECDUndoc_Flag_new == 'No')
		{
			if((customform.document.getElementById('wdesk:Oecdcountrytax_new').value == '--Select--' || customform.document.getElementById('wdesk:Oecdcountrytax_new').value == '' || customform.document.getElementById('wdesk:Oecdcountrytax_new').value == null))
			{
				if(!Oecdfieldvalidation("wdesk:Oecdcountrytax_new"))
				{
					return false;
				}
			}
			if((customform.document.getElementById('wdesk:OecdTin_new').value == '' || customform.document.getElementById('wdesk:OecdTin_new').value == null) && (customform.document.getElementById('OECDtinreason_new').value == null || customform.document.getElementById('OECDtinreason_new').value == ''|| customform.document.getElementById('OECDtinreason_new').value == '--Select--'))
			{
				if(!Oecdfieldvalidation("OecdTin_new"))
				{
					return false;
				}
		
			}
			
		}
		
		var Oecdcountrytax_new2 = customform.document.getElementById('wdesk:Oecdcountrytax_new2').value;
		var Oecdcountrytax_new3 = customform.document.getElementById('wdesk:Oecdcountrytax_new3').value;
		var Oecdcountrytax_new4 = customform.document.getElementById('wdesk:Oecdcountrytax_new4').value;
		var Oecdcountrytax_new5 = customform.document.getElementById('wdesk:Oecdcountrytax_new5').value;
		var Oecdcountrytax_new6 = customform.document.getElementById('wdesk:Oecdcountrytax_new6').value;
		if((Oecdcountrytax_new2 != "" && Oecdcountrytax_new2 != null) && ((customform.document.getElementById('wdesk:OecdTin_new2').value == '' || customform.document.getElementById('wdesk:OecdTin_new2').value == null) && (customform.document.getElementById('OECDtinreason_new2').value == null || customform.document.getElementById('OECDtinreason_new2').value == ''|| customform.document.getElementById('OECDtinreason_new2').value == '--Select--')))
		{
			alert("Please enter 'Tax Payer Identification Number 2' or  'No TIN Reason 2");
			customform.document.getElementById("wdesk:OecdTin_new2").focus();
			return false;
		}
		if((Oecdcountrytax_new3 != "" && Oecdcountrytax_new3 != null) && ((customform.document.getElementById('wdesk:OecdTin_new3').value == '' || customform.document.getElementById('wdesk:OecdTin_new3').value == null) && (customform.document.getElementById('OECDtinreason_new3').value == null || customform.document.getElementById('OECDtinreason_new3').value == ''|| customform.document.getElementById('OECDtinreason_new3').value == '--Select--')))
		{
			alert("Please enter 'Tax Payer Identification Number 3' or  'No TIN Reason 3");
			customform.document.getElementById("wdesk:OecdTin_new3").focus();
			return false;
		}
		if((Oecdcountrytax_new4 != "" && Oecdcountrytax_new4 != null) && ((customform.document.getElementById('wdesk:OecdTin_new4').value == '' || customform.document.getElementById('wdesk:OecdTin_new4').value == null) && (customform.document.getElementById('OECDtinreason_new4').value == null || customform.document.getElementById('OECDtinreason_new4').value == ''|| customform.document.getElementById('OECDtinreason_new4').value == '--Select--')))
		{
			alert("Please enter 'Tax Payer Identification Number 4' or  'No TIN Reason 4");
			customform.document.getElementById("wdesk:OecdTin_new4").focus();
			return false;
		}
		if((Oecdcountrytax_new5 != "" && Oecdcountrytax_new5 != null) && ((customform.document.getElementById('wdesk:OecdTin_new5').value == '' || customform.document.getElementById('wdesk:OecdTin_new5').value == null) && (customform.document.getElementById('OECDtinreason_new5').value == null || customform.document.getElementById('OECDtinreason_new5').value == ''|| customform.document.getElementById('OECDtinreason_new5').value == '--Select--')))
		{
			alert("Please enter 'Tax Payer Identification Number 5' or  'No TIN Reason 5");
			customform.document.getElementById("wdesk:OecdTin_new5").focus();
			return false;
		}
		if((Oecdcountrytax_new6 != "" && Oecdcountrytax_new6 != null) && ((customform.document.getElementById('wdesk:OecdTin_new6').value == '' || customform.document.getElementById('wdesk:OecdTin_new6').value == null) && (customform.document.getElementById('OECDtinreason_new6').value == null || customform.document.getElementById('OECDtinreason_new6').value == ''|| customform.document.getElementById('OECDtinreason_new6').value == '--Select--')))
		{
			alert("Please enter 'Tax Payer Identification Number 6' or  'No TIN Reason 6");
			customform.document.getElementById("wdesk:OecdTin_new6").focus();
			return false;
		}
		
		// start - making mobile phone, mobile phone 2 and office phone mandatory if existing value is not available and selected as preferred address as part of JIRA SCRCIF-127 added on 25/05/2017
		if (customform.document.getElementById('pref_contact_new').value == 'Mobile Phone')
		{
			//if (customform.document.getElementById('wdesk:MobilePhone_Existing').value == '')
			//{
				if (customform.document.getElementById('wdesk:MobilePhone_New1').value == '')
				{
					alert("Please enter Mobile Phone Country Code");
					customform.document.getElementById("wdesk:MobilePhone_New1").focus();
					return false;
				}
				else if (customform.document.getElementById('wdesk:MobilePhone_New2').value == '')
				{
					alert("Please enter Mobile Phone Number");
					customform.document.getElementById("wdesk:MobilePhone_New2").focus();
					return false;
				}
			//}
		}
		else if (customform.document.getElementById('pref_contact_new').value == 'Mobile Phone 2')
		{
			//if (customform.document.getElementById('wdesk:sec_mob_phone_exis').value == '')
			//{
				if (customform.document.getElementById('wdesk:sec_mob_phone_newC').value == '')
				{
					alert("Please enter Mobile Phone 2 Country Code");
					customform.document.getElementById("wdesk:sec_mob_phone_newC").focus();
					return false;
				}
				else if (customform.document.getElementById('wdesk:sec_mob_phone_newE').value == '')
				{
					alert("Please enter Mobile Phone 2 Number");
					customform.document.getElementById("wdesk:sec_mob_phone_newE").focus();
					return false;
				}
			//}
		}
		else if (customform.document.getElementById('pref_contact_new').value == 'Office Phone')
		{
			//if (customform.document.getElementById('wdesk:office_phn_exis').value == '')
			//{
				if (customform.document.getElementById('wdesk:office_phn_newC').value == '')
				{
					alert("Please enter Office Phone Country Code");
					customform.document.getElementById("wdesk:office_phn_newC").focus();
					return false;
				}
				else if (customform.document.getElementById('wdesk:office_phn_newE').value == '')
				{
					alert("Please enter Office Phone Number");
					customform.document.getElementById("wdesk:office_phn_newE").focus();
					return false;
				}
			//}
		}
		
		// End - making mobile phone, mobile phone 2 and office phone mandatory if existing value is not available and selected as preferred address as part of JIRA SCRCIF-127 added on 25/05/2017
		
		// Start - Making OECD_Form mandatory to attach if any OECD Details are filled added on 29052017 as part of JIRA SCRCIF-120
		if(customform.document.getElementById('wdesk:Oecdcountry_new').value != "" || customform.document.getElementById('wdesk:Oecdcity_new').value != "" || customform.document.getElementById('wdesk:Oecdcountrytax_new').value != "")
		{
			var arrAvailableDocList = getInterfaceData("D");
			//var arrAvailableDocList = document.getElementById('wdesk:docCombo');
			//if (arrAvailableDocList == null || arrAvailableDocList == 'null')
				//arrAvailableDocList = customform.document.getElementById('wdesk:docCombo');
			var bResult = false;
			for (var iDocCounter = 0; iDocCounter < arrAvailableDocList.length; iDocCounter++) {
				if (arrAvailableDocList[iDocCounter].name.toUpperCase().indexOf("OECD_Form".toUpperCase()) >= 0) {
					bResult = true;
					break;
				}
			}
			if (!bResult) {
				alert("Please attach OECD_Form document to proceed further.");
				return false;
			}
		}
		// End - Making OECD_Form mandatory to attach if any OECD Details are filled added on 29052017 as part of JIRA SCRCIF-120
			
    } else if (WSNAME == "Archival_Activity") {
        if (customform.document.getElementById("wdesk:ArchivalActivityDecision").value == "--Select--" || customform.document.getElementById("wdesk:ArchivalActivityDecision").value == "") {
            alert("Please select the Decision");
            customform.document.getElementById("wdesk:ArchivalActivityDecision").focus();
            return false;
        }

        if (customform.document.getElementById("wdesk:ArchivalActivityDecision").value == "Reject") {
            if (customform.document.getElementById("rejReasonCodes").value == "" || customform.document.getElementById("rejReasonCodes").value == "NO_CHANGE") {
                alert("Please select the reject reason");
                customform.document.getElementById("btnRejReason").focus();
                return false;
            }
        }
    } else if (WSNAME == "Error") {
        if (customform.document.getElementById("ErrorDecision").value == "--Select--" || customform.document.getElementById("ErrorDecision").value == "") {
            alert("Please select the Decision");
            customform.document.getElementById("ErrorDecision").focus();
            return false;
        }

    } else if (WSNAME == "Archival_Rejects") {
        if (customform.document.getElementById("ArchivalRejectsDecision").value == "--Select--" || customform.document.getElementById("ArchivalRejectsDecision").value == "") {
            alert("Please select the Decision");
            customform.document.getElementById("ArchivalRejectsDecision").focus();
            return false;
        }

    } else if (WSNAME == "PBO_Rejects") {
        if (customform.document.getElementById("PBORejectDecision").value == "--Select--" || customform.document.getElementById("PBORejectDecision").value == "") {
            alert("Please select the Decision");
            customform.document.getElementById("PBORejectDecision").focus();
            return false;
        }

        if (customform.document.getElementById("wdesk:PBORejectDecision").value == "Reject") {
            if (customform.document.getElementById("rejReasonCodes").value == "" || customform.document.getElementById("rejReasonCodes").value == "NO_CHANGE") {
                alert("Please select the reject reason");
                customform.document.getElementById("btnRejReason").focus();
                return false;
            }
        }
    } else if (WSNAME == "CSO_Rejects") {
        if (customform.document.getElementById("Dec_CSO_Rejects").value == "--Select--" || customform.document.getElementById("Dec_CSO_Rejects").value == "") {
            alert("Please select the Decision");
            customform.document.getElementById("Dec_CSO_Rejects").focus();
            return false;
        }
    } else if (WSNAME == "Hold") {
        if (customform.document.getElementById("Dec_Hold").value == "--Select--" || customform.document.getElementById("Dec_Hold").value == "") {
            alert("Please select the Decision");
            customform.document.getElementById("Dec_Hold").focus();
            return false;
        }
    }
	else if (WSNAME == "CSM_Review") {
        if (customform.document.getElementById("Dec_CSM_Review").value == "--Select--" || customform.document.getElementById("Dec_CSM_Review").value == "") {
            alert("Please select the Decision");
            customform.document.getElementById("Dec_CSM_Review").focus();
            return false;
        }
    }

    return true;
}

function checkids1(WSNAME) {
    if (WSNAME == "CSO" || WSNAME == "CSO_Rejects") {
        if (
            customform.document.getElementById('totally_month_credits_amount').value == "" &&
            customform.document.getElementById('cash_amount').value == "" &&
            customform.document.getElementById('total_in').value == "" &&
            customform.document.getElementById('cash_in').value == "" &&
            customform.document.getElementById('non_cash_amount').value == "" &&
            customform.document.getElementById('total_amount').value == "" &&
            customform.document.getElementById('non_cash_in').value == "" &&
            customform.document.getElementById('total_in2').value == "" &&
            customform.document.getElementById('wdesk:politically_exposed').value == "--Select--"
        ) {
            customform.document.getElementById('wdesk:Request_Type_Master').value = "";
            return false;
        }

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
//Description                 :           to get value of decision of every workstep and insert data in history table

//***********************************************************************************//	

function CUSAVEDATA(IsDoneClicked) {

    var customform = '';
    var formWindow = getWindowHandler(windowList, "formGrid");
    customform = formWindow.frames['customform'];
    var SubCategoryID = "1";
    var NameData = "";
    var WSNAME = customform.document.getElementById("wdesk:WS_NAME").value;
    var WINAME = customform.document.getElementById("wdesk:wi_name").value;
    var checklistData = customform.document.getElementById("H_CHECKLIST").value;
    var rejectReasons = customform.document.getElementById("rejReasonCodes").value;
    var Decision = '';
    if (WSNAME == 'CSO')
        Decision = customform.document.getElementById("wdesk:Decision").value;
    else if (WSNAME == 'CSO_Doc_Scan')
        Decision = customform.document.getElementById("Doc_Scan_Dec").value;
    else if (WSNAME == 'OPS_Checker_Review')
        Decision = customform.document.getElementById("Dec_OPS_Checker").value;
    else if (WSNAME == 'CSO_Rejects')
        Decision = customform.document.getElementById("Dec_CSO_Rejects").value;

    else if (WSNAME == 'Archival_Activity')
        Decision = customform.document.getElementById("ArchivalActivityDecision").value;
    else if (WSNAME == 'OPS%20Maker_DE')
        Decision = customform.document.getElementById("OPSMakerDEDecision").value;
    else if (WSNAME == 'PBO')
        Decision = customform.document.getElementById("PBOdecision").value;
    else if (WSNAME == 'PBO_Rejects')
        Decision = customform.document.getElementById("PBORejectDecision").value;
    else if (WSNAME == 'Archival_Rejects')
        Decision = customform.document.getElementById("ArchivalRejectsDecision").value;
    else if (WSNAME == 'Hold')
        Decision = customform.document.getElementById("Dec_Hold").value;
    else if (WSNAME == 'OPS%20Maker_DE')
        Decision = customform.document.getElementById("OPSMakerDEDecision").value;
    else if (WSNAME == 'Error')
        Decision = customform.document.getElementById("ErrorDecision").value;
	else if (WSNAME == 'CSM_Review')
        Decision = customform.document.getElementById("Dec_CSM_Review").value;	

    var Remarks = customform.document.getElementById("wdesk:remarks").value;

    var inputs = customform.document.getElementsByTagName("input");
    var textareas = customform.document.getElementsByTagName("textarea");
    var selects = customform.document.getElementsByTagName("select");
    var store = "";
    var isElite = "";


    var H_Checklist = "Yes"; //customform.document.getElementById("H_Checklist").value;
    var H_RejectReasons = "Yes"; //customform.document.getElementById("H_RejectReasons").value;

    for (x = 0; x < inputs.length; x++) {
        myname = inputs[x].getAttribute("id");
        if (myname != "") {
            if ((inputs[x].type == 'radio')) {
                eleName = inputs[x].getAttribute("name");
                if (store != eleName) {
                    store = eleName;
                    var ele = customform.document.getElementsByName(eleName);
                    for (var i = 0; i < ele.length; i++) {
                        eleName2 = ele[i].id;
                        eleName2 += "#radio";
                        NameData += eleName + "#" + eleName2 + "~";
                    }
                }
            } else if (!(inputs[x].type == 'radio')) {
                eleName2 = inputs[x].getAttribute("name");
                eleName2 += "#";
                NameData += myname + "#" + eleName2 + "~";
            }

        } else if (myname.indexOf("tr_") == 0) {
            tr_table = customform.document.getElementById(myname).value;
        } else if (myname.indexOf("WS_LogicalName") == 0) {
            WS_LogicalName = customform.document.getElementById(myname).value;
        }
    }

    //For GenerateCutOfftime
    if (WSNAME == 'CSO' || WSNAME == "CSO_Rejects")
        isElite = customform.document.getElementById("wdesk:rak_elite_customer").value;


    //for inserting decision in decision history
    var xhr;
    if (window.XMLHttpRequest)
        xhr = new XMLHttpRequest();
    else if (window.ActiveXObject)
        xhr = new ActiveXObject("Microsoft.XMLHTTP");
    var abc = Math.random;

    var url = "/CU/CustomForms/CU_Specific/SaveHistory.jsp";
    var param = "WINAME=" + WINAME + "&WSNAME=" + WSNAME + "&Decision=" + Decision + "&Remarks=" + Remarks + "&checklistData=" + checklistData + "&rejectReasons=" + rejectReasons + "&IsDoneClicked=" + IsDoneClicked + "&IsSaved=Y&abc=" + abc + "&isElite=" + isElite;

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
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to validate form on introduce for CSO and PBO workstep

//***********************************************************************************//	

function mainValidation(WSNAME) {

    if (WSNAME == "CSO") {
        if (customform.document.getElementById("wdesk:CIFNumber_Existing").value == "" && customform.document.getElementById("wdesk:account_number").value == "" &&
            customform.document.getElementById("wdesk:loan_agreement_id").value == "" && customform.document.getElementById("wdesk:card_number").value == "" && customform.document.getElementById("wdesk:emirates_id").value == "") {
            alert("Please click on Search button");
            return false;
        }

        if (customform.document.getElementById("radiaoCheck").value == "N" || !customform.document.getElementById("decision")) {
           
            alert("Please click on the radio button");
            return false;
        }

        if (customform.document.getElementById("decision").value == "--Select--") {
            alert("Please select the Decision");
            customform.document.getElementById("decision").focus();
            return false;
        }

        if (customform.document.getElementById("decision").value == "Reject") {
            if (customform.document.getElementById("rejReasonCodes").value == "" || customform.document.getElementById("rejReasonCodes").value == "NO_CHANGE") {
                alert("Please select the reject reason");
                customform.document.getElementById("btnRejReason").focus();
                return false;
            }
        }
		//modified for changing nonResident to country_of_res_exis and making fields mandatory
     var country_of_res_exis = customform.document.getElementById("wdesk:country_of_res_exis").value;

      /*  if (nonResident == "" || nonResident == "--Select--" || nonResident == null) {
            nonResident = customform.document.getElementById("wdesk:nonResident").value;
        }*/
        if (country_of_res_exis == "AE" && customform.document.getElementById("wdesk:Channel").value != "RM Initiated" && customform.document.getElementById("decision").value != "Reject") {
            if (customform.document.getElementById("wdesk:emiratesid_new").value == "" && customform.document.getElementById("wdesk:emirates_id").value == "" && (customform.document.getElementById("wdesk:Marsoon_new").value == "" || customform.document.getElementById("wdesk:Marsoon_new").value == null) &&( customform.document.getElementById("wdesk:Marsoon_exis").value== "" || customform.document.getElementById("wdesk:Marsoon_exis").value == null) ){
                alert("Please enter Emirates ID or Marsoon Id number.");
                customform.document.getElementById("wdesk:emiratesid_new").focus();
                return false;
            } else if(customform.document.getElementById("wdesk:emiratesid_new").value != "" || customform.document.getElementById("wdesk:emirates_id").value != ""){
				if(customform.document.getElementById("wdesk:emiratesidexp_exis").value == "" && customform.document.getElementById("wdesk:emiratesidexp_new").value == "")
				{
					alert("Please enter Emirates ID Expiry date");
					customform.document.getElementById("wdesk:emiratesidexp_new").focus();
					return false;
				}
				else if (customform.document.getElementById("wdesk:emiratesidexp_new").value != "") {
                    var enteredEmiratesDate = customform.document.getElementById("wdesk:emiratesidexp_new").value;
                    if (customform.document.getElementById("wdesk:emiratesidexp_new").value != "") {
                        enteredEmiratesDate = customform.document.getElementById("wdesk:emiratesidexp_new").value;
                    }
                    var today = new Date();
                    var arrStartDate3 = enteredEmiratesDate.split("/");
                    var date3 = new Date(arrStartDate3[2], arrStartDate3[1] - 1, arrStartDate3[0]);
                    var timeDiffEmirates = date3.getTime() - today.getTime();
                    if (timeDiffEmirates < 0) {
                        alert("Emirates ID has Expired WorkItem cannot be initiated.");
                        return false;
                    }
                } else {
                    var enteredEmiratesDate = customform.document.getElementById("wdesk:emiratesidexp_new").value;
                   // alert(enteredEmiratesDate);
					if (customform.document.getElementById("wdesk:emiratesidexp_exis").value != "" && customform.document.getElementById("wdesk:emiratesidexp_exis").value != null) {
                        enteredEmiratesDate = customform.document.getElementById("wdesk:emiratesidexp_exis").value;
                    }
                    var today = new Date();

                    var arrStartDate3 = enteredEmiratesDate.split("/");
                    var date3 = new Date(arrStartDate3[2], arrStartDate3[1] - 1, arrStartDate3[0]);
                    var timeDiffEmirates = date3.getTime() - today.getTime();
                    if (timeDiffEmirates < 0) {
                        alert("Emirates ID has Expired WorkItem cannot be initiated.");
                        return false;
                    }
                }
            }
			
        }
       /* if ((customform.document.getElementById("wdesk:PassportNumber_New").value == "" || customform.document.getElementById("wdesk:PassportNumber_New").value == null) && (customform.document.getElementById("wdesk:PassportNumber_Existing").value == "" || customform.document.getElementById("wdesk:PassportNumber_Existing").value == null)) {
            alert("Passport Number is mandatory to fill");
            customform.document.getElementById("wdesk:PassportNumber_New").focus();
            return false;
        } else {
				if ((customform.document.getElementById("wdesk:passportExpDate_new").value == "" || customform.document.getElementById("wdesk:passportExpDate_new").value == null) && (customform.document.getElementById("wdesk:passportExpDate_exis").value == "" || customform.document.getElementById("wdesk:passportExpDate_exis").value == null)) {
			
                alert("Please Enter the Passport Expiry date");
				
                customform.document.getElementById("wdesk:passportExpDate_new").focus();
                return false;
            }
        } */
		//Expiry date year check CR added by Shamily
		if (customform.document.getElementById("wdesk:Channel").value != "RM Initiated" && customform.document.getElementById("decision").value != "Reject") {
			var PassportExpdate = customform.document.getElementById("wdesk:passportExpDate_exis").value;
			var Passportexpyear = PassportExpdate.split("/");
			
			if((customform.document.getElementById("wdesk:passportExpDate_new").value == "" || customform.document.getElementById("wdesk:passportExpDate_new").value == null ) && Passportexpyear[2]=='2099')
			{
				 alert("Please enter new Passport expiry date as existing Passport date year is 2099");
				 customform.document.getElementById("wdesk:passportExpDate_new").focus();
				  return false;
			}
		}

        var FatcaDocNew = customform.document.getElementById("wdesk:FatcaDoc_new").value;

        if (customform.document.getElementById("USrelation_new").value == "R" && FatcaDocNew.indexOf("W9") == -1) {
            alert("W9 form is mandatory as US Relation is Yes- Reportable");
            customform.document.getElementById("FatcaDocNew").focus();
            return false;
        } else if (customform.document.getElementById("USrelation_new").value == "N" && FatcaDocNew.indexOf("W8") == -1) {
            alert("W8 form is mandatory as US Relation is Yes-Not Reportable");
            customform.document.getElementById("FatcaDocNew").focus();
            return false;
        }
        var today1 = new Date();
		//added by shamily to make signed date mandatory
        var enteredSignedDate = customform.document.getElementById("wdesk:SignedDate_new").value;
        var arrStartDate4 = enteredSignedDate.split("/");
        var date4 = new Date(arrStartDate4[2], arrStartDate4[1] - 1, arrStartDate4[0]);
        var timeDiffSigned = date4.getTime() - today1.getTime();

        if (FatcaDocNew.indexOf("W8") != -1) {
            if ((customform.document.getElementById("wdesk:SignedDate_new").value == "" || customform.document.getElementById("wdesk:SignedDate_new").value == null) && (customform.document.getElementById("wdesk:SignedDate_exis").value == "" || customform.document.getElementById("wdesk:SignedDate_exis").value == null)) {
                alert("Signed date is mandatory for fatca document W8 form");
                customform.document.getElementById("wdesk:SignedDate_new").focus();
                return false;
            } else if (timeDiffSigned > 0) {
                alert("Signed date should be less then or equal to Current date");
                customform.document.getElementById("wdesk:SignedDate_new").focus();
                return false;
            }
        }

        var xhr;
        if (window.XMLHttpRequest)
            xhr = new XMLHttpRequest();
        else if (window.ActiveXObject)
            xhr = new ActiveXObject("Microsoft.XMLHTTP");
        var reqtype = "validateSegment";
        var customer_type = customform.document.getElementById("CustomerType_new").value;

        var url = "/CU/CustomForms/CU_Specific/fetchSegment.jsp";

        var param = "customer_type=" + customer_type;
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

            customform.document.getElementById("wdesk:SegmentValidFlag").value = ajaxResult;
            if (customform.document.getElementById("wdesk:SegmentValidFlag").value == "Y" && customform.document.getElementById("IndustrySegment_new").value == "--Select--") {
                alert("Industry Segment is mandatory to select");
                customform.document.getElementById("IndustrySegment_new").focus();
                return false;
            } else if (customform.document.getElementById("wdesk:SegmentValidFlag").value == "Y" && customform.document.getElementById("IndustrySubSegment_new").value == "--Select--") {
                alert("Industry Sub Segment is mandatory to select");
                customform.document.getElementById("IndustrySubSegment_new").focus();
                return false;
            }
        } else {
            alert("Problem in getting SegmentValidFlag.");
            return false;
        }
    }
    if (WSNAME == "PBO") {
        if (customform.document.getElementById("wdesk:CIFNumber_Existing").value == "" && customform.document.getElementById("wdesk:account_number").value == "" &&
            customform.document.getElementById("wdesk:loan_agreement_id").value == "" && customform.document.getElementById("wdesk:card_number").value == "" && customform.document.getElementById("wdesk:emirates_id").value == "") {
            alert("Please click on Search button");
            return false;
        }

        if (customform.document.getElementById("radiaoCheck").value == "N") {
            alert("Please select a radio to load custom details.");
            return false;
        }

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
//Author                      :           Shamily
//Description                 :           To send sms to customer on done

//***********************************************************************************//	

function sendSMSToCustomer(customform) {
    var workstepname = customform.document.getElementById("wdesk:WS_NAME").value;
	var SelectedCIF = customform.document.getElementById("wdesk:SelectedCIF").value;
	var csodecision="";
	if(workstepname == "CSO")
	{
		 csodecision = customform.document.getElementById("decision").value;
	}	
    var winame = customform.document.getElementById("wdesk:wi_name").value;
    var xhr;
    if (window.XMLHttpRequest)
        xhr = new XMLHttpRequest();
    else if (window.ActiveXObject)
        xhr = new ActiveXObject("Microsoft.XMLHTTP");

    var url = "/CU/CustomForms/CU_Specific/SendSMSToCustomer.jsp";

    var param="winame="+winame+"&workstepname="+workstepname+"&SelectedCIF="+SelectedCIF+"&csodecision="+csodecision;
    xhr.open("POST", url, false);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.send(param);
	
    if (xhr.status == 200 && xhr.readyState == 4) {
        ajaxResult = xhr.responseText;
    
	    ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');

        if (ajaxResult.indexOf("Exception") == 0) {
            alert("Some problem in sending mail");
            return false;
        }
    } else {
        alert("Problem in sending mail");
        return false;
    }
}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to insert grid data in table on done

//***********************************************************************************//	

function CUSAVEGRID(IsDoneClicked, WINAME, WSNAME, signature_update, dormancy_activation, sole_to_joint, joint_to_sole) {

    if (WSNAME == "CSO" || WSNAME == "CSO_Rejects") {
        var url = '/CU/CustomForms/CU_Specific/insertGridData.jsp';
        var param = "WINAME=" + WINAME + "&signature_update=" + signature_update + "&dormancy_activation=" + dormancy_activation + "&sole_to_joint=" + sole_to_joint + "&joint_to_sole=" + joint_to_sole;

        var xhr;
        var ajaxResult;
        if (window.XMLHttpRequest)
            xhr = new XMLHttpRequest();
        else if (window.ActiveXObject)
            xhr = new ActiveXObject("Microsoft.XMLHTTP");

        xhr.open("POST", url, false);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.send(param);
    
		if (xhr.status == 200)
            return true; //document.getElementById(doc_field).value = xhr.responseText;

        else {
            alert("Error while fetching accounts");
            return false;
        }
    } else {
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
//Description                 :           to get data from repective tag received in the integration call

//***********************************************************************************//	

function insert(str, index, value) {
    return str.substr(0, index) + value + str.substr(index);
}

function MobileNumberValidation(CountryCode,PhoneNumber,PhoneType)
{
	var CountryCode1 = customform.document.getElementById(CountryCode).value;
	var PhoneNumber1 = customform.document.getElementById(PhoneNumber).value;
	
	if((CountryCode1 != null && CountryCode1 != "" && CountryCode1 != "00971") && (PhoneNumber1.substring(0,1) != 5 && PhoneNumber1.substring(0,1) != "" && PhoneNumber1.substring(0,1) != null ))
	{
		alert(PhoneType+" Country code for UAE Country of residence should be 00971 and number should start with 5");
		customform.document.getElementById(CountryCode).focus();
		return false;
	}
	
	else if((CountryCode1 != null && CountryCode1 != "" && CountryCode1 != "00971")&&(PhoneNumber1.substring(0,1) == 5))
	{
		alert(PhoneType+" Country code for UAE Country of residence should be 00971");
		customform.document.getElementById(CountryCode).focus();
		return false;
	}
	
	else if((CountryCode1 == "00971" || CountryCode1 == null || CountryCode1 == "" ) && (PhoneNumber1.substring(0,1) != 5 && PhoneNumber1.substring(0,1) != "" && PhoneNumber1.substring(0,1) != null ))
	{
		alert(PhoneType+" number for UAE Country of residence should start from 5");
		customform.document.getElementById(PhoneNumber).focus();
		return false;
	}
	else if(PhoneNumber1.length !=0 && PhoneNumber1.length <9)
	{
		alert("Length of "+PhoneType+" number should be 9");
		customform.document.getElementById(PhoneNumber).focus();
		return false;
	}
	return true;
}


function formatDate(dateObj,format)
{
    var curr_date = dateObj.getDate();
    var curr_month = dateObj.getMonth();
    curr_month = curr_month + 1;
    var curr_year = dateObj.getFullYear();
    var curr_min = dateObj.getMinutes();
    var curr_hr= dateObj.getHours();
    var curr_sc= dateObj.getSeconds();
    if(curr_month.toString().length == 1)
    curr_month = '0' + curr_month;      
    if(curr_date.toString().length == 1)
    curr_date = '0' + curr_date;
    if(curr_hr.toString().length == 1)
    curr_hr = '0' + curr_hr;
    if(curr_min.toString().length == 1)
    curr_min = '0' + curr_min;
	if(curr_sc.toString().length == 1)
    curr_sc = '0' + curr_sc;
    if(format ==1)//dd-mm-yyyy
    {
        return curr_date + "-"+curr_month+ "-"+curr_year;       
    }
    else if(format ==2)//yyyy-mm-dd
    {
        return curr_year + "-"+curr_month+ "-"+curr_date;       
	}
    else if(format ==3)//dd/mm/yyyy
    {
        return curr_date + "/"+curr_month+ "/"+curr_year;       
    }
    else if(format ==4)// MM/dd/yyyy HH:mm:ss
    {
        return curr_month+"/"+curr_date +"/"+curr_year+ " "+curr_hr+":"+curr_min+":"+curr_sc;       
    }
	else if(format ==5)// dd/MM/yyyy HH:mm:ss
    {
        return curr_date+"/"+curr_month +"/"+curr_year+ " "+curr_hr+":"+curr_min+":"+curr_sc;       
    }
}
