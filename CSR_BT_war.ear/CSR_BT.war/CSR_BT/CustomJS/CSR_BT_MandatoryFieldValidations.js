var DAC_Common = document.createElement('script');
DAC_Common.src = '/DAC/DAC/CustomJS/DAC_Common.js';
document.head.appendChild(DAC_Common);


function mandatoryFieldValidation()
{
	if(ActivityName=="Initiation")
	{		
		if(getValue('CORPORATE_CIF')=="" || getValue('CORPORATE_CIF')=='' || getValue('CORPORATE_CIF')==null)
		{			
			showMessage('CORPORATE_CIF','Please mention Corporate CIF',"error");
			return false;
		}
		
		if(getValue('REQUEST_BY_SIGNATORY_CIF')=="" || getValue('REQUEST_BY_SIGNATORY_CIF')=='' || getValue('REQUEST_BY_SIGNATORY_CIF')==null)
		{			
			showMessage('REQUEST_BY_SIGNATORY_CIF','Please mention Request By (Signatory): CIF',"error");
			return false;
		}				
	}
	
	if(ActivityName=="OPS_Maker")
	{	
		if(getValue('REQUEST_FOR_CIF')=="" || getValue('REQUEST_FOR_CIF')=='' || getValue('REQUEST_FOR_CIF')==null)
		{	
			showMessage('REQUEST_FOR_CIF','Please mention Request For CIF',"error");
			return false;
		}
		
		if(getValue('ACCOUNT_NUMBER')=="" || getValue('ACCOUNT_NUMBER')=='' || getValue('ACCOUNT_NUMBER')==null)
		{		
			showMessage('ACCOUNT_NUMBER','Please mention Account No',"error");
			return false;
		}
		if(getValue('SCHEME_TYPE')=="" || getValue('SCHEME_TYPE')=='' || getValue('SCHEME_TYPE')==null)
		{	
			showMessage('SCHEME_TYPE','Please mention Scheme type',"error");
			return false;
		}
		if(getValue('SCHEME_CODE')=="" || getValue('SCHEME_CODE')=='' || getValue('SCHEME_CODE')==null)
		{	
			showMessage('SCHEME_CODE','Please mention Scheme code',"error");
			return false;
		}
		if(getValue('IS_RETAIL_CUSTOMER')=="" || getValue('IS_RETAIL_CUSTOMER')=='' || getValue('IS_RETAIL_CUSTOMER')==null)
		{	
			showMessage('IS_RETAIL_CUSTOMER','Please mention is Retail Customer',"error");
			return false;
		}
		if(getValue('TITLE')=="" || getValue('TITLE')=='' || getValue('TITLE')==null)
		{	
			showMessage('TITLE','Please mention Title',"error");
			return false;
		}
		if(getValue('GENDER')=="" || getValue('GENDER')=='' || getValue('GENDER')==null)
		{	
			showMessage('GENDER','Please mention Gender',"error");
			return false;
		}
		if(getValue('DATE_OF_BIRTH')=="" || getValue('DATE_OF_BIRTH')=='' || getValue('DATE_OF_BIRTH')==null)
		{	
			showMessage('DATE_OF_BIRTH','Please mention Date Of Birth',"error");
			return false;
		}
		if(getValue('FIRST_NAME')=="" || getValue('FIRST_NAME')=='' || getValue('FIRST_NAME')==null)
		{	
			showMessage('FIRST_NAME','Please mention First Name',"error");
			return false;
		}
		if(getValue('MIDDLE_NAME')=="" || getValue('MIDDLE_NAME')=='' || getValue('FIRST_NAME')==null)
		{
			showMessage('MIDDLE_NAME','Please mention Middle Name',"error");
			return false;
		}
		if(getValue('LAST_NAME')=="" || getValue('LAST_NAME')=='' || getValue('LAST_NAME')==null)
		{	
			showMessage('LAST_NAME','Please mention Last Name',"error");
			return false;
		}
		if(getValue('MOTHERS_MAIDEN_NAME')=="" || getValue('MOTHERS_MAIDEN_NAME')=='' || getValue('MOTHERS_MAIDEN_NAME')==null)
		{	
			showMessage('MOTHERS_MAIDEN_NAME','Please mention Mothers Maiden Name',"error");
			return false;
		}
		if(getValue('COUNTRY_OF_RESIDENCE')=="" || getValue('COUNTRY_OF_RESIDENCE')=='' || getValue('COUNTRY_OF_RESIDENCE')==null)
		{	
			showMessage('COUNTRY_OF_RESIDENCE','Please mention Country of Residence',"error");
			return false;
		}
		if(getValue('NATIONALITY')=="" || getValue('NATIONALITY')=='' || getValue('NATIONALITY')==null)
		{	
			showMessage('NATIONALITY','Please mention Nationality',"error");
			return false;
		}
		if(getValue('EMIRATES_ID')=="" || getValue('EMIRATES_ID')=='' || getValue('EMIRATES_ID')==null)
		{	
			showMessage('EMIRATES_ID','Please mention Emirates ID',"error");
			return false;
		}
		if(getValue('PASSPORT_NUMBER')=="" || getValue('PASSPORT_NUMBER')=='' || getValue('PASSPORT_NUMBER')==null)
		{	
			showMessage('PASSPORT_NUMBER','Please mention Passport Number',"error");
			return false;
		}
		if(getValue('VISA_UID_NUMBER')=="" || getValue('VISA_UID_NUMBER')=='' || getValue('VISA_UID_NUMBER')==null)
		{	
			showMessage('VISA_UID_NUMBER','Please mention Visa UID Number',"error");
			return false;
		}
		if(getValue('CARD_EMBOSSING_NAME')=="" || getValue('CARD_EMBOSSING_NAME')=='' || getValue('CARD_EMBOSSING_NAME')==null)
		{	
			showMessage('CARD_EMBOSSING_NAME','Please mention Card Embossing Name',"error");
			return false;
		}
		if(getValue('MOB_NUMBER_COUNTRY_CODE')=="" || getValue('MOB_NUMBER_COUNTRY_CODE')=='' || getValue('MOB_NUMBER_COUNTRY_CODE')==null)
		{	
			showMessage('MOB_NUMBER_COUNTRY_CODE','Please mention mobile number country code',"error");
			return false;
		}
		if(getValue('MOBILE_NUMBER')=="" || getValue('MOBILE_NUMBER')=='' || getValue('MOBILE_NUMBER')==null)
		{	
			showMessage('MOBILE_NUMBER','Please mention Mobile Number',"error");
			return false;
		}
		if(getValue('EMAIL_ID')=="" || getValue('EMAIL_ID')=='' || getValue('EMAIL_ID')==null)
		{	
			showMessage('EMAIL_ID','Please mention Email ID',"error");
			return false;
		}
		
	}
	if(ActivityName!=="OPS_CHECKER")
	{
		if(getValue("DECISION")=="Reject")	
		{
			if(getValue('REMARKS')=="" || getValue('REMARKS')=='' || getValue('REMARKS')==null)
			{
				showMessage('REMARKS','Please mention Remarks',"error");
				return false;
			}
		}
	}
	if(getValue('DECISION')=="" || getValue('DECISION')=='')
	{
		showMessage('DECISION','Selecting a Decision is Mandatory to proceed further',"error");
		return false;
	}
	
    if(getValue("DECISION").indexOf("Reject")!=-1)
	{	

		var rejectReasonsGridLength=getGridRowCount('REJECT_REASON_GRID');
		if(rejectReasonsGridLength == 0)
		{
			showMessage('REJECT_REASON_GRID','Please enter atleast one reject reason',"error");
			return false;
		}
		if(rejectReasonsGridLength>0)
		{
			for(var i=0;i<rejectReasonsGridLength;i++)
			{
				var cellVal1 = getValueFromTableCell("REJECT_REASON_GRID",i,0);
				if(cellVal1=="Select")
				{
				  showMessage('REJECT_REASON_GRID','Select cannot be selected as a reject reason',"error");
				  return false;
				
				}
			}
		}
	}	
}