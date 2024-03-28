// Copyright (EIDA) 2004-2016 Emirates Identity Authority (EIDA)
// email: PKITeam@emiratesid.ae
// All rights reserved.

// The source code is sole property of Emirates Identity Authority, Abu Dhabi, UAE. Even after modifications it is still property of Emirates Identify Authority.
// This source has to be kept in strict confidence and must not be disclosed to any third party in any case.

var PublicDataWebComponentName = "PublicDataWebComponent";
var PublicDataWebComponent = null;

//var RemoteSM_Address = "http://192.168.38.21:8080/EIDAProxy/VGServer";
var RemoteSM_Address = "http://192.168.155.21:8080/EIDAProxy/VGServer";

function ReadPublicData(value)
{
    if (PublicDataWebComponent == null)
    {
        alert("The Webcomponent is not initialized.");
        return;
    }
	if (value == undefined || typeof value != 'boolean' ){
		value = false;
	}
    var Ret = PublicDataWebComponent.ReadPublicData(true, true, true, true,true,value,RemoteSM_Address);
    return Ret;
}

function xor_str(pPIN)
{
    var to_enc = pPIN;
l
    var xor_key = 6; //document.forms['the_form'].elements.xor_key.value
    var the_res = "";//the result will be here
    for (i = 0; i < to_enc.length; ++i)
    {
        the_res += String.fromCharCode(xor_key ^ to_enc.charCodeAt(i));
    }
    return the_res;
}

function decrypt_str(pPIN)
{
    var to_dec = pPIN;
    var the_res;
    var xor_key = 6;
    for (i = 0; i < to_dec.length; i++)
    {
        the_res += String.fromCharCode(xor_key ^ to_dec.charCodeAt(i));
    }
    return the_res;
}

function GetCardVersion() {
    return PublicDataWebComponent.GetCardVersion();
}
function GetCardSerialNumber() {
    return PublicDataWebComponent.GetCardSerialNumber();
}

function GetArabicFullName()
{
    var value = PublicDataWebComponent.GetArabicFullName();
    return RemoveCommas(value);
}

///////////////////////
function GetCardSerialNumber() {
    return PublicDataWebComponent.GetCardSerialNumber();
}

function GetPhotography_DataSigned() {
    return PublicDataWebComponent.GetPhotography_DataSigned();
}
function GetCardHolderData_SF3_DataSigned() {
    return PublicDataWebComponent.GetCardHolderData_SF3_DataSigned();
}
function GetCardHolderData_SF5_DataSigned() {
    return PublicDataWebComponent.GetCardHolderData_SF5_DataSigned();
}

// Signature used for data validation
function GetPhotography_Signature() {
    return PublicDataWebComponent.GetPhotography_Signature();
}
function GetCardHolderData_SF3_Signature() {
    return PublicDataWebComponent.GetCardHolderData_SF3_Signature();
}
function GetCardHolderData_SF5_Signature() {
    return PublicDataWebComponent.GetCardHolderData_SF5_Signature();
}

function GetEF_IDN_CN(){
	return PublicDataWebComponent.GetEF_IDN_CN();
}
function GetEF_HolderSignatureImage(){
	return PublicDataWebComponent.GetEF_HolderSignatureImage();
}
function GetEF_Photography(){
	return PublicDataWebComponent.GetEF_Photography();
}
function GetEF_ModifiableData(){
	return PublicDataWebComponent.GetEF_ModifiableData();
}
function GetEF_NonModifiableData(){
	return PublicDataWebComponent.GetEF_NonModifiableData();
}
function GetEF_RootCertificate(){
	return PublicDataWebComponent.GetEF_RootCertificate();
}
function GetEF_HomeAddress(){
	return PublicDataWebComponent.GetEF_HomeAddress();
}
function GetEF_WorkAddress(){
	return PublicDataWebComponent.GetEF_WorkAddress();
}

// Attributes of the SF 1
function GetIDNumber() {
    
    return PublicDataWebComponent.GetIDNumber();
}
function GetCardNumber() {
    return PublicDataWebComponent.GetCardNumber();
}

// Attributes of the SF 2
function GetPhotography() {
    return PublicDataWebComponent.GetPhotography();
}

// Attributes of the SF 3
function GetIDType() {
    return PublicDataWebComponent.GetIDType();
}
function GetIssueDate() {
    
    return PublicDataWebComponent.GetIssueDate();
}
function GetExpiryDate() {
    return PublicDataWebComponent.GetExpiryDate();
}
function GetArabicTitle() {
    return PublicDataWebComponent.GetArabicTitle();
}
function GetArabicFullName()
{
    var value = PublicDataWebComponent.GetArabicFullName();
    return RemoveCommas(value);
}
function GetTitle() {

    return PublicDataWebComponent.GetTitle();
}

function RemoveCommas(value)
{
    if (value == ",,")
        return "";

    var fns = value.split(",");

    value = "";
    for (j = 0; j < fns.length; j++)
    {
        if (fns[j] == "")
            continue;

        if (value != "")
            value = value + " ";

        value = value + fns[j];
    }

    return value;
}

function GetFullName()
{
    var fullname = PublicDataWebComponent.GetFullName();
	

    return RemoveCommas(fullname);
}

function GetSex()
{

    var sex = PublicDataWebComponent.GetSex();
	
    if (sex == 'M')
        return "Male";
    if (sex == 'F')
        return "Female";
    if (sex == 'X')
        return "Unknown";
}
function GetArabicNationality() {
    return PublicDataWebComponent.GetArabicNationality();
}
function GetNationality() {
	
    return PublicDataWebComponent.GetNationality();
}
function GetNationalityCode() {
    return PublicDataWebComponent.GetNationalityCode();
}
function GetDateOfBirth() {
    
    return PublicDataWebComponent.GetDateOfBirth();
}

function GetArabicPlaceOfBirth() {
    return PublicDataWebComponent.GetArabicPlaceOfBirth();
}

function GetPlaceOfBirth() {
    return PublicDataWebComponent.GetPlaceOfBirth();
}


function GetArabicMotherFirstName()
{
    var value = PublicDataWebComponent.GetArabicMotherFirstName();
    return RemoveCommas(value);
}

function GetMotherFirstName() {
    return PublicDataWebComponent.GetMotherFirstName();
}

function DisplayPhotography()
{
    if (PublicDataWebComponent == null)
    {
        alert("The Webcomponent is not initialized.");
        return;
    }

    try
    {
        disableButtons(true, "Reading Photography ...");

        var Ret = PublicDataWebComponent.ReadPublicData("true", "true", "false", "false", "false");
        if (Ret.startsWith("-"))
        {
            ProcessError(Ret);
            flag = true;
        }
        else
        if (Ret != "")
        {
            //alert(Ret);
        }

        disableButtons(false);

    }
    catch (e)
    {
        alert("Can not load photography");
    }

}
// Attributes of the SF 5
function GetOccupation()
{
    var occupation = PublicDataWebComponent.GetOccupation();
   	return occupation;
	//return GetOccupationDisplayName(parseInt(occupation));
}
function GetArabicOccupation()
{
    return PublicDataWebComponent.GetArabicOccupation();
}
function GetOccupationCode()
{
    return PublicDataWebComponent.GetOccupationCode();
}
function GetFamilyID() {
    return PublicDataWebComponent.GetFamilyID();
}
function GetArabicOccupationType() {
    return PublicDataWebComponent.GetArabicOccupationType();
}
function GetOccupationType() {
    return PublicDataWebComponent.GetOccupationType();
}
function GetOccupationFieldCode() {
    return PublicDataWebComponent.GetOccupationFieldCode();
}
function GetArabicCompanyName() {
    return PublicDataWebComponent.GetArabicCompanyName();
}
function GetCompanyName() {
    return PublicDataWebComponent.GetCompanyName();
}

function GetMaritalStatus()
{
    var MaritalStatuses = new Array("", "Single", "Married", "Divorced", "Widowed");
    var maritalStatus = PublicDataWebComponent.GetMaritalStatus();

    return MaritalStatuses[parseInt(maritalStatus)];
}
function GetHusbandIDN() {
    return PublicDataWebComponent.GetHusbandIDN();
}
function GetSponsorType()
{
    var SponsorTypes = new Array("Parent", "Spoose", "", "", "Sheikh", "UAE Citizen", "Resident", "GCC Sponsor", "Diplomatic", "Company", "Federal Government", "Local Government", "Assimilated Government", "Heritance", "", "", "", "", "Other Sponsor type");
    var sponsorType = PublicDataWebComponent.GetSponsorType();
    return SponsorTypes[parseInt(sponsorType) + 3];

}
function GetSponsorNumber()
{
    return PublicDataWebComponent.GetSponsorNumber();
}
function GetSponsorName() {
    return PublicDataWebComponent.GetSponsorName();
}
function GetResidencyType()
{
    var ResidencyTypes = new Array("", "", "Work", "Resident", "Diplomatic", "", "", "Service");
    var residencyType = PublicDataWebComponent.GetResidencyType();
    return ResidencyTypes[parseInt(residencyType)];
}
function GetResidencyNumber() {
    return PublicDataWebComponent.GetResidencyNumber();
}
function GetResidencyExpiryDate() {
    return PublicDataWebComponent.GetResidencyExpiryDate();
}

function GetPassportNumber() {
    return PublicDataWebComponent.GetPassportNumber();
}

function GetPassportTypeCode() {

    return PublicDataWebComponent.GetPassportTypeCode();
}

function GetPassportCountryCode() {
    return PublicDataWebComponent.GetPassportCountryCode();
}

function GetArabicPassportCountryDescription() {

    return PublicDataWebComponent.GetArabicPassportCountryDescription();
}

function GetPassportCountryDescription() {

    return PublicDataWebComponent.GetPassportCountryDescription();
}

function GetPassportIssueDate() {

    return PublicDataWebComponent.GetPassportIssueDate();
}

function GetPassportExpiryDate() {

    return PublicDataWebComponent.GetPassportExpiryDate();
}

function GetQualificationLevelCode() {

    return PublicDataWebComponent.GetQualificationLevelCode();
}

function GetArabicQualificationLevelDescription() {

    return PublicDataWebComponent.GetArabicQualificationLevelDescription();
}

function GetQualificationLevelDescription() {

    return PublicDataWebComponent.GetQualificationLevelDescription();
}

function GetArabicDegreeDescription() {

    return PublicDataWebComponent.GetArabicDegreeDescription();
}

function GetDegreeDescription() {

    return PublicDataWebComponent.GetDegreeDescription();
}

function GetFieldOfStudyCode() {

    return PublicDataWebComponent.GetFieldOfStudyCode();
}

function GetArabicFieldOfStudy() {

    return PublicDataWebComponent.GetArabicFieldOfStudy();
}

function GetFieldOfStudy() {

    return PublicDataWebComponent.GetFieldOfStudy();
}

function GetArabicPlaceOfStudy() {

    return PublicDataWebComponent.GetArabicPlaceOfStudy();
}

function GetPlaceOfStudy() {

    return PublicDataWebComponent.GetPlaceOfStudy();
}

function GetDateOfGraduation() {

    return PublicDataWebComponent.GetDateOfGraduation();
}


// Attributes of the SF 6
function GetMOIRootCertificate() {
    return PublicDataWebComponent.GetMOIRootCertificate();
}
////////Address Book//////////////
 function GetHomeAddressTypeCode() {
        return PublicDataWebComponent.GetHomeAddressTypeCode();
    }

    function GetHomeAddressLocationCode() {
        return PublicDataWebComponent.GetHomeAddressLocationCode();
    }

    function GetHomeAddressEmirateCode() {
        return PublicDataWebComponent.GetHomeAddressEmirateCode();
    }

    function GetArabicHomeAddressEmirateDescription() {
        return PublicDataWebComponent.GetArabicHomeAddressEmirateDescription();
    }

    function GetHomeAddressEmirateDescription() {
        return PublicDataWebComponent.GetHomeAddressEmirateDescription();
    }

    function GetHomeAddressCityCode() {
        return PublicDataWebComponent.GetHomeAddressCityCode();
    }

    function GetArabicHomeAddressCityDescription() {
      return PublicDataWebComponent.GetArabicHomeAddressCityDescription();
    }

    function GetHomeAddressCityDescription() {
        return PublicDataWebComponent.GetHomeAddressCityDescription();
    }

    function GetArabicHomeAddressStreet() {
        return PublicDataWebComponent.GetArabicHomeAddressStreet();
    }

    function GetHomeAddressStreet() {
        return PublicDataWebComponent.GetHomeAddressStreet();
    }

    function GetHomeAddressPOBox() {
        return PublicDataWebComponent.GetHomeAddressPOBox();
    }

    function GetHomeAddressAreaCode() {
        return PublicDataWebComponent.GetHomeAddressAreaCode();
    }

    function GetArabicHomeAddressAreaDescription() {
        return PublicDataWebComponent.GetArabicHomeAddressAreaDescription();
    }

    function GetHomeAddressAreaDescription() {
        return PublicDataWebComponent.GetHomeAddressAreaDescription();
    }

    function GetArabicHomeAddressBuildingName() {
        return PublicDataWebComponent.GetArabicHomeAddressBuildingName();
    }

    function GetHomeAddressBuildingName() {
        return PublicDataWebComponent.GetHomeAddressBuildingName();
    }

    function GetHomeAddressFlatNo() {
        return PublicDataWebComponent.GetHomeAddressFlatNo();
    }

    function GetHomeAddressResidentPhoneNumber() {
        return PublicDataWebComponent.GetHomeAddressResidentPhoneNumber();
    }

    function GetHomeAddressMobilePhoneNumber() {
        return PublicDataWebComponent.GetHomeAddressMobilePhoneNumber();
    }

    function GetHomeAddressEmail() {
        return PublicDataWebComponent.GetHomeAddressEmail();
    }

    // end home address
    // Work Address
    function GetWorkAddressTypeCode() {
        return PublicDataWebComponent.GetWorkAddressTypeCode();
    }

    function GetWorkAddressLocationCode() {
        return PublicDataWebComponent.GetWorkAddressLocationCode();
    }

    function GetArabicWorkAddressCompanyName() {
        return PublicDataWebComponent.GetArabicWorkAddressCompanyName();
    }

    function GetWorkAddressCompanyName() {
        return PublicDataWebComponent.GetWorkAddressCompanyName();
    }

    function GetWorkAddressEmirateCode() {
        return PublicDataWebComponent.GetWorkAddressEmirateCode();
    }

    function GetArabicWorkAddressEmirateDescription() {
        return PublicDataWebComponent.GetArabicWorkAddressEmirateDescription();
    }

    function GetWorkAddressEmirateDescription() {
        return PublicDataWebComponent.GetWorkAddressEmirateDescription();
    }

    function GetWorkAddressCityCode() {
        return PublicDataWebComponent.GetWorkAddressCityCode();
    }

    function GetArabicWorkAddressCityDescription() {
        return PublicDataWebComponent.GetArabicWorkAddressCityDescription();
    }

    function GetWorkAddressCityDescription() {
        return PublicDataWebComponent.GetWorkAddressCityDescription();
    }

    function GetArabicWorkAddressStreet() {
        return PublicDataWebComponent.GetArabicWorkAddressStreet();
    }

    function GetWorkAddressStreet() {
        return PublicDataWebComponent.GetWorkAddressStreet();
    }

    function GetWorkAddressPOBox() {
     return PublicDataWebComponent.GetWorkAddressPOBox();
	 }

    function GetWorkAddressAreaCode() {
       return PublicDataWebComponent.GetWorkAddressAreaCode();
    }

    function GetArabicWorkAddressAreaDescription() {
       return PublicDataWebComponent.GetArabicWorkAddressAreaDescription();
    }

    function GetWorkAddressAreaDescription() {
        return PublicDataWebComponent.GetWorkAddressAreaDescription();
    }

    function GetArabicWorkAddressBuildingName() {
        return PublicDataWebComponent.GetArabicWorkAddressBuildingName();
    }

    function GetWorkAddressBuildingName() {
     return PublicDataWebComponent.GetWorkAddressBuildingName();
    }

    function GetWorkAddressLandPhoneNo() {
        return PublicDataWebComponent.GetWorkAddressLandPhoneNo();
    }

    function GetWorkAddressMobilePhoneNumber() {
        return PublicDataWebComponent.GetWorkAddressMobilePhoneNumber();
    }

    function GetWorkAddressEmail() {
       return PublicDataWebComponent.GetWorkAddressEmail();
    }

//////////////////////////////////
function StrEndsWithLabel(str)
{
    if (str == null || str == undefined)
        return false;

    return (str.match("_PDLabel$")=="_PDLabel"); 
    //return (str.match(lbl + "$") == lbl);
}

function GetFunctionName(str)
{
    if (str == null || str == undefined)
        return "undefined";
    return "Get" + str.substring(0, str.length - "_PDLabel".length);
}

function Initialize()
{
    try
    {
        if (document.getElementById("divStatus")) {
            document.getElementById("divStatus").innerHTML = "------";
        }
        PublicDataWebComponent = document.getElementById(PublicDataWebComponentName);

        var Ret = PublicDataWebComponent.Initialize();

        if (Ret != "" && Ret.startsWith("-"))
        {
            ProcessError(Ret);
            return "";
        }
        else
        if (Ret != "" && Ret != "0")
        {
            //alert(Ret);
        }
        else // no errors
        {
            disableButtons(false);
            //document.getElementById("loading_data").innerHTML = "Initialized Successfully...";
            document.getElementById("loading_data").style.visibility = "visible";
        }

        return Ret;
    }
    catch (e)
    {
        disableButtons(false);
        return "Webcomponent Initialization Failed, Details: " + e;
    }
}

function PKIAuthenticate(pin) {
    try
    {
        PublicDataWebComponent = document.getElementById(PublicDataWebComponentName);
		disableButtons(true, "Processing PKI Authenticate...");
		var Ret = 0;
		if (pin == null || pin.length == 0 || pin == "" ) {
            Ret = E_NULL_ARGUMENT + "";
		} else {
            Ret = PublicDataWebComponent.PKIAuthenticate(RemoteSM_Address, pin);
		 }
        if (Ret != "" && Ret.startsWith("-"))
        {
            ProcessError(Ret);
            disableButtons(false);
            return "";
        }

        disableButtons(false);

        if (Ret == "Failed")
            return "";

        return Ret;
    }
    catch (e)
    {
        disableButtons(false);
        return "";
    }
}

function DisplayPublicData(){	
var card_result = DisplayPublicData(false);
	return card_result;
}

function DisplayPublicData(CCardStatusRequired)
{	
	if (CCardStatusRequired === undefined){
		CCardStatusRequired = false;
	}
    if (PublicDataWebComponent == null)
    {
        alert("The Web Component is not initialized.");
        return;
    }

    var flag = false;
    disableButtons(true, "Reading Public Data ...");
    var Ret = ReadPublicData(CCardStatusRequired);
    if (Ret != "" && Ret.startsWith("-"))
    {
        ProcessError(Ret);
        flag = true;
    }
    else
    if (Ret != "" && Ret != "0")
    {
        //alert(Ret);
    }

    disableButtons(false);

    if (flag)
    {
        return;
    }

    // displaying public data
	var card_result = alerts_data();
	return card_result;
    
}
function alerts_data(){
		var card_result = 'EIDA_no:'+PublicDataWebComponent.GetIDNumber()+'@%#EIDA_issue_date:'+PublicDataWebComponent.GetIssueDate()+'@%#EIDA_exp_date:'+PublicDataWebComponent.GetExpiryDate()+'@%#Title:'+PublicDataWebComponent.GetTitle()+'@%#full_name:'+PublicDataWebComponent.GetFullName()+'@%#nationality:'+PublicDataWebComponent.GetNationality()+'@%#sex:'+PublicDataWebComponent.GetSex()+'@%#DOB:'+PublicDataWebComponent.GetDateOfBirth()+'@%#ppt_no:'+PublicDataWebComponent.GetPassportNumber()+'@%#ppt_expdate:'+PublicDataWebComponent.GetPassportExpiryDate()+'@%#visa_no:'+PublicDataWebComponent.GetResidencyNumber()+'@%#visa_issue_date:'+PublicDataWebComponent.GetIssueDate()+'@%#visa_exp_date:'+PublicDataWebComponent.GetResidencyExpiryDate()+'@%#mothers_name:'+PublicDataWebComponent.GetMotherFirstName()+'@%#mobile_no:'+PublicDataWebComponent.GetWorkAddressMobilePhoneNumber()+'@%#PlaceOfBirth:'+PublicDataWebComponent.GetPlaceOfBirth()+'@%#Occupation:'+PublicDataWebComponent.GetOccupation()+'@%#CompanyName:'+PublicDataWebComponent.GetCompanyName()+'@%#MaritalStatus:'+PublicDataWebComponent.GetMaritalStatus()+'@%#PassportCountryDescription:'+PublicDataWebComponent.GetPassportCountryDescription()+'@%#HomeAddressCityDescription:'+PublicDataWebComponent.GetHomeAddressCityDescription()+'@%#HomeAddressStreet:'+PublicDataWebComponent.GetHomeAddressStreet()+'@%#HomeAddressPOBox:'+PublicDataWebComponent.GetHomeAddressPOBox()+'@%#HomeAddressBuildingName:'+PublicDataWebComponent.GetHomeAddressBuildingName()+'@%#HomeAddressFlatNo:'+PublicDataWebComponent.GetHomeAddressFlatNo()+'@%#HomeAddressMobilePhoneNumber:'+PublicDataWebComponent.GetHomeAddressMobilePhoneNumber()+'@%#HomeAddressEmail:'+PublicDataWebComponent.GetHomeAddressEmail()+'@%#cust_photo:'+GetPhotography();
		return card_result;
		// '@%#encry_data:'+CheckCardStatus()  removed - this used to get encrypted data
}
function get_nationality(code_3){
		var national_code = '{"AFG":"AF","ALB":"AL","DZA":"DZ","ASM":"AS","AND":"AD","AGO":"AO","AIA":"AI","ATA":"AQ","ATG":"AG","ARG":"AR","ARM":"AM","ABW":"AW","AUS":"AU","AUT":"AT","AZE":"AZ","BHS":"BS","BHR":"BH","BGD":"BD","BRB":"BB","BLR":"BY","BEL":"BE","BLZ":"BZ","BEN":"BJ","BMU":"BM","BTN":"BT","BOL":"BO","BES":"BQ","BIH":"BA","BWA":"BW","BVT":"BV","BRA":"BR","IOT":"IO","BRN":"BN","BGR":"BG","BFA":"BF","BDI":"BI","KHM":"KH","CMR":"CM","CAN":"CA","CPV":"CV","CYM":"KY","CAF":"CF","TCD":"TD","CHL":"CL","CHN":"CN","CXR":"CX","CCK":"CC","COL":"CO","COM":"KM","COG":"CG","COD":"CD","COK":"CK","CRI":"CR","HRV":"HR","CUB":"CU","CUW":"CW","CYP":"CY","CZE":"CZ","CIV":"CI","DNK":"DK","DJI":"DJ","DMA":"DM","DOM":"DO","ECU":"EC","EGY":"EG","SLV":"SV","GNQ":"GQ","ERI":"ER","EST":"EE","ETH":"ET","FLK":"FK","FRO":"FO","FJI":"FJ","FIN":"FI","FRA":"FR","GUF":"GF","PYF":"PF","ATF":"TF","GAB":"GA","GMB":"GM","GEO":"GE","DEU":"DE","GHA":"GH","GIB":"GI","GRC":"GR","GRL":"GL","GRD":"GD","GLP":"GP","GUM":"GU","GTM":"GT","GGY":"GG","GIN":"GN","GNB":"GW","GUY":"GY","HTI":"HT","HMD":"HM","VAT":"VA","HND":"HN","HKG":"HK","HUN":"HU","ISL":"IS","IND":"IN","IDN":"ID","IRN":"IR","IRQ":"IQ","IRL":"IE","IMN":"IM","ISR":"IL","ITA":"IT","JAM":"JM","JPN":"JP","JEY":"JE","JOR":"JO","KAZ":"KZ","KEN":"KE","KIR":"KI","PRK":"KP","KOR":"KR","KWT":"KW","KGZ":"KG","LAO":"LA","LVA":"LV","LBN":"LB","LSO":"LS","LBR":"LR","LBY":"LY","LIE":"LI","LTU":"LT","LUX":"LU","MAC":"MO","MKD":"MK","MDG":"MG","MWI":"MW","MYS":"MY","MDV":"MV","MLI":"ML","MLT":"MT","MHL":"MH","MTQ":"MQ","MRT":"MR","MUS":"MU","MYT":"YT","MEX":"MX","FSM":"FM","MDA":"MD","MCO":"MC","MNG":"MN","MNE":"ME","MSR":"MS","MAR":"MA","MOZ":"MZ","MMR":"MM","NAM":"NA","NRU":"NR","NPL":"NP","NLD":"NL","NCL":"NC","NZL":"NZ","NIC":"NI","NER":"NE","NGA":"NG","NIU":"NU","NFK":"NF","MNP":"MP","NOR":"NO","OMN":"OM","PAK":"PK","PLW":"PW","PSE":"PS","PAN":"PA","PNG":"PG","PRY":"PY","PER":"PE","PHL":"PH","PCN":"PN","POL":"PL","PRT":"PT","PRI":"PR","QAT":"QA","ROU":"RO","RUS":"RU","RWA":"RW","REU":"RE","BLM":"BL","SHN":"SH","KNA":"KN","LCA":"LC","MAF":"MF","SPM":"PM","VCT":"VC","WSM":"WS","SMR":"SM","STP":"ST","SAU":"SA","SEN":"SN","SRB":"RS","SYC":"SC","SLE":"SL","SGP":"SG","SXM":"SX","SVK":"SK","SVN":"SI","SLB":"SB","SOM":"SO","ZAF":"ZA","SGS":"GS","SSD":"SS","ESP":"ES","LKA":"LK","SDN":"SD","SUR":"SR","SJM":"SJ","SWZ":"SZ","SWE":"SE","CHE":"CH","SYR":"SY","TWN":"TW","TJK":"TJ","TZA":"TZ","THA":"TH","TLS":"TL","TGO":"TG","TKL":"TK","TON":"TO","TTO":"TT","TUN":"TN","TUR":"TR","TKM":"TM","TCA":"TC","TUV":"TV","UGA":"UG","UKR":"UA","ARE":"AE","GBR":"GB","USA":"US","UMI":"UM","URY":"UY","UZB":"UZ","VUT":"VU","VEN":"VE","VNM":"VN","VGB":"VG","VIR":"VI","WLF":"WF","ESH":"EH","YEM":"YE","ZMB":"ZM","ZWE":"ZW","ALA":"AX"}';

	var natio_code = JSON.parse(national_code);
	return natio_code[code_3];
}

function CheckBiometricInfo() {
    document.getElementById("biometric-validation").innerHTML = "";
    try
    {
        if (PublicDataWebComponent == null)
        {
            alert("The Webcomponent is not initialized.");
            return;
        }

        //disableButtons(true, "Check Biometric Information ...");
        var NumOfBits = PublicDataWebComponent.GetNumberOfAvailableFingerprints();
		if (NumOfBits > 0){
		document.getElementById("bio-info").innerHTML="";
			for (var i = 0; i < NumOfBits; i++) {
				var fingerIndex = PublicDataWebComponent.GetFingerIndex(i + 1);
				var form = document.createElement("form");
				form.setAttribute("method", "post");
				form.setAttribute("action", "Validator?caller=" + document.getElementById("callerID").value);
				form.setAttribute("fingerIndex", fingerIndex);
				form.onsubmit = function() {
					return ValidateMatchFingerprint(this.getAttribute("fingerIndex"), this);
				};

				var element = document.createElement("input");
				element.setAttribute("type", "submit");
				element.setAttribute("value", "Match " + GetFingerIndexDisplayName(fingerIndex) + " Finger");

				var element0 = document.createElement("input");
				element0.setAttribute("type", "hidden");
				element0.setAttribute("name", "ValidationType");
				element0.setAttribute("value", "VGResponse");

				var element1 = document.createElement("input");
				element1.setAttribute("type", "hidden");
				element1.setAttribute("name", "ValidationRequest");
				element1.setAttribute("id", "MatchOnServerResponse");
				element1.setAttribute("value", "");

				form.appendChild(element0);
				form.appendChild(element1);
				form.appendChild(element);

				document.getElementById("biometric-validation").appendChild(form);
			}
        disableButtons(false);
	}else{
		document.getElementById("bio-info").innerHTML = "Biometric information is not available";
		}
    }
    catch (e)
    {
        disableButtons(false);
    }
}

function MatchFingerprint(fingerIndex) {
    try
    {
        if (PublicDataWebComponent == null)
        {
            alert("The Webcomponent is not initialized.");
            return "";
        }

        disableButtons(true, "Matching Fingerprint ...");
        var Ret = PublicDataWebComponent.BiometricAuthentication(RemoteSM_Address, fingerIndex);

        if (Ret != "" && Ret.startsWith("-"))
        {
            ProcessError(Ret);
            disableButtons(false);
            return "";
        }

        disableButtons(false);
        return Ret;
    }
    catch (e)
    {
        disableButtons(false);
        return "";
    }
}

function PinReset() {
    try
    {
        if (PublicDataWebComponent == null)
        {
            alert("The Webcomponent is not initialized.");
            return;
        }

        disableButtons(true, "Processing PIN Reset ...");
		var Ret = 0;
		var newPIN = document.getElementById("txtPINReset").value;
		if (newPIN == null || newPIN.length == 0 || newPIN == "" ) {
            Ret = E_NULL_ARGUMENT + "";
		} else {
			var NumOfBits = PublicDataWebComponent.GetNumberOfAvailableFingerprints();
			if (NumOfBits <= 0){
				Ret = "No biometric information is available inside the card";
			}else{
				var fingerIndex = 0;
				var alertMessage = "Please put your ";
				for (var i = 0; i < NumOfBits; i++) {
					fingerIndex = PublicDataWebComponent.GetFingerIndex(i + 1);
					if (i != 0)
						alertMessage += " or your ";
					alertMessage += GetFingerIndexDisplayName(fingerIndex) + " finger";
				}
				alertMessage += " to capture your fingerprint.";
				alert(alertMessage);
					Ret = PublicDataWebComponent.PinReset(RemoteSM_Address, newPIN, 0);
			}
		}
        if (Ret != "" && Ret.startsWith("-"))
        {
            ProcessError(Ret);
        }
        else if (Ret == "0")
        {
            alert("PIN has been reset successfully");
        }
        else {
            //alert(Ret);
        }
        disableButtons(false);
    }
    catch (e)
    {
        alert("PIN Reset Failed, Details: " + e);
        disableButtons(false);
    }
}

function CheckCardStatus() {
    try
    {

        if (PublicDataWebComponent == null)
        {
            alert("The Webcomponent is not initialized.");
            return "";
        }

        //disableButtons(true, "Checking Card Status ...");

        var Ret = PublicDataWebComponent.CardStatus(RemoteSM_Address);

        /*if (Ret != "" && Ret.startsWith("-"))
        {
            ProcessError(Ret);
            disableButtons(false);
            return "";
        }
        disableButtons(false);*/
        return Ret;
    }
    catch (e)
    {
        //alert(e);
        disableButtons(false);
        return "";
    }
}

function SignData(pin, data) {
    try
    {
        if (PublicDataWebComponent == null)
        {
            alert("The Webcomponent is not initialized.");
            return "";
        }

        disableButtons(true, "Processing Sign Data ...");

        var Ret = 0;

        if (pin == null || pin.length == 0 || pin == "" || data == null || data.length == 0 || data == "") {
            Ret = E_NULL_ARGUMENT + "";
        }
        else {
            Ret = PublicDataWebComponent.SignData(RemoteSM_Address, pin, data);
        }

        if (Ret != "" && Ret.startsWith("-"))
        {
            ProcessError(Ret);
            disableButtons(false);
            return "";
        }

        disableButtons(false);
        return Ret;
    }
    catch (e)
    {
        alert("Signing Data Failed, Details: " + e);
        disableButtons(false);
        return "";
    }
}

function SignChallenge(pin, xData) {
    try
    {
        if (PublicDataWebComponent == null)
        {
            alert("The Webcomponent is not initialized.");
            return "";
        }

        disableButtons(true, "Processing Sign Data ...");
        if (pin == null || pin.length == 0 || pin == "" || xData == null || xData.length == 0 || xData == "") {
            Ret = E_NULL_ARGUMENT + "";
        }
        else {
            var Ret = PublicDataWebComponent.SignChallenge(RemoteSM_Address, pin, xData);
        }

        if (Ret != "" && Ret.startsWith("-"))
        {
            ProcessError(Ret);
            disableButtons(false);
            return "";
        }
        disableButtons(false);
        return Ret;
    }
    catch (e)
    {
        disableButtons(false);
        return "";
    }
}

function GetSignCertificate() {
    try
    {
        if (PublicDataWebComponent == null)
        {
            alert("The Webcomponent is not initialized.");
            return "";
        }

        var Ret = PublicDataWebComponent.GetSignCertificate();

        if (Ret != "" && Ret.startsWith("-"))
        {
            ProcessError(Ret);
            return "";
        }
        return Ret;
    }
    catch (e)
    {
        //alert(e);
        return "";
    }
}

function GetAuthCertificate() {
    try
    {
        if (PublicDataWebComponent == null)
        {
            alert("The Webcomponent is not initialized.");
            return "";
        }

        var Ret = PublicDataWebComponent.GetAuthCertificate();

        if (Ret != "" && Ret.startsWith("-"))
        {
            ProcessError(Ret);
            return "";
        }
        return Ret;
    }
    catch (e)
    {
        //alert(e);
        return "";
    }
}


function disableButtons(flag, msg)
{
    try
    {
        if (document.getElementById("btnInitialize"))
            document.getElementById("btnInitialize").disabled = flag;

        if (document.getElementById("btnReadPublicData"))
            document.getElementById("btnReadPublicData").disabled = flag;
			
		if (document.getElementById("btnReadPublicDataAfterCCS"))
            document.getElementById("btnReadPublicDataAfterCCS").disabled = flag;

        if (document.getElementById("btnCheckBiometricInfo"))
            document.getElementById("btnCheckBiometricInfo").disabled = flag;

        if (document.getElementById("btnPKIAuthenticate"))
            document.getElementById("btnPKIAuthenticate").disabled = flag;

        if (document.getElementById("btnCardStatus"))
            document.getElementById("btnCardStatus").disabled = flag;

        if (document.getElementById("btnSignData"))
            document.getElementById("btnSignData").disabled = flag;

        if (document.getElementById("btnSignChallenge"))
            document.getElementById("btnSignChallenge").disabled = flag;

        if (document.getElementById("btnPINReset"))
            document.getElementById("btnPINReset").disabled = flag;

        if (document.getElementById("btnReadFB"))
            document.getElementById("btnReadFB").disabled = flag;
    }
    catch (e)
    {
    }

    if (document.getElementById("loading_data"))
    {

        if (flag == true)
        {

            document.getElementById("loading_data").innerHTML = msg;
            document.getElementById("loading_data").style.visibility = "visible";
        }
        else
        {
            document.getElementById("loading_data").style.visibility = "hidden";
        }
    }

}

/////////////////////////////////////////////////////////
///////////////////// VALIDATOR METHODS //////////////////

function ValidateCardStatus() {
    var Ret = CheckCardStatus();
    if (Ret != "")
    {
        document.getElementById("cardStatusResponse").value = Ret;
        return true;
    }
    return false;
}

function ValidatePKIAuthentication(pin)
{
    var Ret = PKIAuthenticate(pin);
    if (Ret != "")
    {
        document.getElementById("PKIAuthenticateResponse").value = Ret;
        window.location = "indexApplet.jsp?ValidationMessage=The received response is: Valid";

    }
    else
    {
        window.location = "indexApplet.jsp?ValidationMessage=The received response is: Not Valid";
    }
}

function ValidatePKIAuthenticate(pin)
{
    var Ret = PKIAuthenticate(pin);
    if (Ret != "")
    {
        document.getElementById("PKIAuthenticateResponse").value = Ret;
        return true;
    }
    return false;
}

function ValidateMatchFingerprint(fingerIndex, form) {
    var Ret = MatchFingerprint(fingerIndex);
    if (Ret != "")
    {
        form.MatchOnServerResponse.value = Ret;
        window.location = "Validator?ValidationRequest=" + Ret + "&ValidationType=VGResponse";
        return true;
    }
    return false;
}

function ValidateSignData(pin, data) {
    var Ret = SignData(pin, data);
    if (Ret != "") {
        document.getElementById("DataSigned").value = data;
        document.getElementById("SignDataResponse").value = Ret;
        var cert = GetSignCertificate();
        if (cert == "") {
            alert("Couldn't generate certificate from the applet.");
            return false;
        }
        document.getElementById("SignCertificate").value = cert;
        return true;
    }
    return false;
}

function ValidateSignChallenge(pin, xData) {
    var Ret = SignChallenge(pin, xData);
    if (Ret != "") {
        document.getElementById("XDataSigned").value = xData;
        document.getElementById("SignChallengeResponse").value = Ret;
        var cert = GetAuthCertificate();
        if (cert == "") {
            alert("Couldn't generate certificate from the applet.");
            return false;
        }
        document.getElementById("AuthCertificate").value = cert;
        return true;
    }
    return false;
}