function getDecodedValue(str)
{
	var retValue="";
	var salary = '5000';
	switch(str)
	{
		case "001" : retValue = "INVALID CARD NUMBER"; break;
		case "002" : retValue = "CRN NOT FOUND"; break;
		case "003" : retValue = "INVALID CARD STATUS"; break;
		case "004" : retValue = "CARD EXPIRED"; break;
		case "005" : retValue = "SUPPLEMENTARY CARD"; break;
		case "006" : retValue = "BLACKLISTED CUSTOMER"; break;
		case "007" : retValue = "N BUCKET CUSTOMER"; break;
		case "008" : retValue = "OVERDUE CUSTOMER"; break;
		case "009" : retValue = "SALARY LESS THAN "+salary; break;
		case "010" : retValue = "BT NOT ALLOWED FOR CARD TYPE"; break;
		case "011" : retValue = "CCC NOT ALLOWED FOR CARD TYPE"; break;
		case "012" : retValue = "AVAILABLE BALANCE LESS THEN 0"; break;
		case "013" : retValue = "INVALID REQUEST AMOUNT"; break;
		case "014" : retValue = "INVALID OTHER BANK BIN NO"; break;
		case "015" : retValue = "DEDUPE CHECK FAILURE"; break;
		case "016" : retValue = "INVALID OTHER BANK CARD NO"; break;
		case "017" : retValue = "BT NOT ALLOWED FOR MARKETING CODE"; break;
		case "018" : retValue = "INVALID REQUEST AMOUNT FOR CCC"; break;
		case "019" : retValue = "CCC NOT ALLOWED FOR CORPORATE CARDS"; break;
		case "020" : retValue = "INVALID PAYMENT TYPE"; break;
		case "Payment of school fees / college fees" : retValue = "PSC"; break;
		case "Payment of Rent - in favor of Real Estate Companies only" : retValue = "PRC"; break;
		case "Payment of Insurance Premiums - in favor of Insurance Providers or Agents" : retValue = "PIP"; break;
		case "Payment to known Property Developers in Dubai & Abu Dhabi" : retValue = "PDA"; break;
		case "Payment to any Government Departments / Entities" : retValue = "PGE"; break;
		case "Payment to Utility Companies" : retValue = "PUC"; break;
		case "Payment to Auto Dealers" : retValue = "PAD"; break;
		case "If issued in the name of Cardholder (self)" : retValue = "SLF"; break;
		case "Payment to any third party other than those mentioned above" : retValue = "THP"; break;		
		default : retValue = str;
	}
	return retValue;
}
