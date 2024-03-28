/*
client<Cabinetname>.js  for CU process
*/

if(processName=='CU')
{
	window.document.write("<script src=\"/CU/webtop/scripts/CU_Scripts/saveHistory.js\"></script>");
	window.document.write("<script src=\"/CU/webtop/scripts/CU_Scripts/moment.js\"></script>");
}

function SaveClick()
{
	if(typeof processName!="undefined" && (processName=='CU'))
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

			if(CUCIFUPDATE(false,WINAME,WSNAME,phone1,phone1CCode,phone1Number,phone1Ext,phone2,phone2CCode,phone2Number,phone2Ext,phone3,phone3CCode,phone3Number,phone3Ext,phone4,phone4CCode,phone4Number,phone4Ext,phone5,phone5CCode,phone5Number,phone5Ext,phone6,phone6CCode,phone6Number,phone6Ext,primaryemail,primaryemailvalue,secondaryemail,secondaryemailvalue,doc_emiratesid,emiratesid_new,emiratesidexp_new,doc_passport,passport_num_new,passportExpDate_new,doc_visa,visa_new,visaExpDate_new,residence_address,resi_line1,resi_line2,resi_line3,resi_line4,resi_restype,resi_pobox,resi_zipcode,resi_state,resi_city,resi_cntrycode,office_address,office_line1,office_line2,office_line3,office_line4,office_restype,office_pobox,office_zipcode,office_state,office_city,office_cntrycode))
			{   
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

function IntroduceClick()
{
	var customform='';
	var formWindow=getWindowHandler(windowList,"formGrid");
	customform=formWindow.frames['customform'];

	if(processName=='CU')
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
							 if((WSNAME == 'CSO' && customform.document.getElementById("decision").value=='Approved') || (WSNAME == 'PBO' && customform.document.getElementById("PBOdecision").value=='Approve')|| (WSNAME == 'Hold' && customform.document.getElementById("Dec_Hold").value=='Close')|| (WSNAME == 'OPS Maker_DE' && customform.document.getElementById("OPSMakerDEDecision").value=='Reject' && customform.document.getElementById("Channel").value == 'Phone banking'))
							{
								sendSMSToCustomer(customform);
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

function DoneClick()
{	
	if(typeof processName!="undefined" && (processName=='CU'))
	{	
		var customform='';
		var formWindow=getWindowHandler(windowList,"formGrid");
		customform=formWindow.frames['customform'];		
		var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
		
		if(decisionvalidation(WSNAME))
		{
			if(CUSAVEDATA(false))
				return true;
			else
				return false;
		}
		else
			return false;
    }
	else
		return true;
}