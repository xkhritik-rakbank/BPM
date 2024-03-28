function ajaxRequest(workstepname,reqType)
{
	//alert('handle ajax request ajaxRequest');
	var url = '';
	var xhr;
	var ajaxResult;			
	var values = "";
	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");
	//modified by Shamily to fetch tin reason. undoc reason and fatca reason from master table  
	if (reqType =='office_cntrycode' || reqType =='TypeOfRelationNew'|| reqType =='FatcaDocNew' || reqType == 'FatcaReasonNew'|| reqType =='CustomerType_new'|| reqType =='IndustrySubSegment_new'|| reqType =='IndustrySegment_new'|| reqType =='USrelation_new'|| reqType =='resi_restype'|| reqType =='emp_type_new'|| reqType =='employment_status_new'|| reqType =='marrital_status_new'|| reqType =='occupation_new'|| reqType =='OECDUndocreason_new' || reqType =='OECDtinreason_new'|| reqType =='OECDtinreason_new2'|| reqType =='OECDtinreason_new3'|| reqType =='OECDtinreason_new4'|| reqType =='OECDtinreason_new5'|| reqType =='OECDtinreason_new6')
	{
		url = '/CU/CustomForms/CU_Specific/HandleAjaxRequest.jsp?workstepname='+workstepname+"&reqType="+reqType;//workstepname not required for country drop down
	}
		
	 xhr.open("GET",url,false);
	 xhr.send(null);

	if (xhr.status == 200)
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
							
		if(ajaxResult.indexOf("Exception")==0)
		{
			alert("Unknown Exception while working with request type "+reqType);
			return false;
		}

		 if(reqType=='office_cntrycode' || reqType=='occupation_new')
			values = ajaxResult.split("~");
		 
		 else
			values = ajaxResult.split(",");
		
		if (reqType=='office_cntrycode')
		{
			var select_office;
			var select_resi;
			var select_DealwithCont_new;
			//var select_country_of_res_new;
			if (reqType=='office_cntrycode'){
				select_office = document.getElementById('office_cntrycode');
				select_resi = document.getElementById('resi_cntrycode');
				//select_country_of_res_new = document.getElementById('country_of_res_new');
				select_DealwithCont_new = document.getElementById('DealwithCont_new');
			}
			
			var codes=ajaxRequestvalues(workstepname,reqType,0);
			//Add elements to the corresponding dropdown
			for (var i=0 ; i< values.length ; i++) {
				var opt = document.createElement('option');
				opt.value = codes[i];
				opt.innerHTML = values[i];
				opt.length = values[i].length;
				opt.className="EWNormalGreenGeneral1";
				select_office.appendChild(opt);
			}	
			
			for (var i=0 ; i< values.length ; i++) {
				var opt = document.createElement('option');
				opt.value = codes[i];
				opt.innerHTML = values[i];
				opt.length = values[i].length;
				opt.className="EWNormalGreenGeneral1";
				select_resi.appendChild(opt);
			}	
			/*
			for (var i=0 ; i< values.length ; i++) {
				var opt = document.createElement('option');
				opt.value = values[i];
				opt.innerHTML = values[i];
				opt.length = values[i].length;
				opt.className="EWNormalGreenGeneral1";
				select_country_of_res_new.appendChild(opt);
			} */
			
			
			
			
			for (var i=0 ; i< values.length ; i++) {
				var opt = document.createElement('option');
				opt.value = codes[i];
				opt.innerHTML = values[i];
				opt.length = values[i].length;
				opt.className="EWNormalGreenGeneral1";
				select_DealwithCont_new.appendChild(opt);
				
				
				
			}
		}
		
		if(reqType=='resi_restype')
				{
					var select_resi_restype ;
					var select_off_restype ;
					select_resi_restype = document.getElementById('resi_restype');
				select_off_restype = document.getElementById('office_restype');
				
			var codes=ajaxRequestvalues(workstepname,reqType,0);
			
			for (var i=0 ; i< values.length ; i++) {
				var opt = document.createElement('option');
				opt.value = codes[i];
				opt.innerHTML = values[i];
				opt.length = values[i].length;
				opt.className="EWNormalGreenGeneral1";
				select_resi_restype.appendChild(opt);
			}
					
			for (var i=0 ; i< values.length ; i++) {
				var opt = document.createElement('option');
				opt.value = codes[i];
				opt.innerHTML = values[i];
				opt.length = values[i].length;
				opt.className="EWNormalGreenGeneral1";
				select_off_restype.appendChild(opt);
			}
				}
	//modified by Shamily to fetch tin reason. undoc reason and fatca reason from master table  
		if(reqType=='FatcaDocNew' || reqType == 'FatcaReasonNew' || reqType=='TypeOfRelationNew'||reqType=='IndustrySubSegment_new'||reqType=='IndustrySegment_new'||reqType=='CustomerType_new'|| reqType =='USrelation_new'|| reqType =='emp_type_new'|| reqType =='employment_status_new'|| reqType =='marrital_status_new'|| reqType =='occupation_new'|| reqType =='OECDUndocreason_new' || reqType =='OECDtinreason_new' || reqType =='OECDtinreason_new2'|| reqType =='OECDtinreason_new3'|| reqType =='OECDtinreason_new4'|| reqType =='OECDtinreason_new5'|| reqType =='OECDtinreason_new6')
		{
			    if (reqType=='FatcaDocNew')
				{
					select = document.getElementById('FatcaDocNew');
				}
				//Added by nikita to fetch fatca reason from master table  
				else if (reqType=='FatcaReasonNew')
				{
					select = document.getElementById('FatcaReasonNew');
				}
				else if (reqType=='TypeOfRelationNew')
				{
					select = document.getElementById('TypeOfRelationNew');
				}
				else if (reqType=='IndustrySubSegment_new')
				{
					select = document.getElementById('IndustrySubSegment_new');
				}	
				else if (reqType=='IndustrySegment_new')
				{
					select = document.getElementById('IndustrySegment_new');
				}
				else if (reqType=='CustomerType_new')
				{
					select = document.getElementById('CustomerType_new');
				}
				else if (reqType=='USrelation_new')
				{
					select = document.getElementById('USrelation_new');
				}
				
				else if (reqType=='emp_type_new')
				{
					select = document.getElementById('emp_type_new');
				}
				else if (reqType=='employment_status_new')
				{
					select = document.getElementById('employment_status_new');
				}
				else if (reqType=='marrital_status_new')
				{
					select = document.getElementById('marrital_status_new');
				}else if (reqType=='occupation_new')
				{
					select = document.getElementById('occupation_new');
				}
				//Added by Shamily to fetch tin reason. undoc reason from master table  
				else if (reqType=='OECDUndocreason_new')
				{
					select = document.getElementById('OECDUndocreason_new');
				}else if (reqType=='OECDtinreason_new')
				{
					select = document.getElementById('OECDtinreason_new');
				}else if (reqType=='OECDtinreason_new2')
				{
					select = document.getElementById('OECDtinreason_new2');
				}else if (reqType=='OECDtinreason_new3')
				{
					select = document.getElementById('OECDtinreason_new3');
				}else if (reqType=='OECDtinreason_new4')
				{
					select = document.getElementById('OECDtinreason_new4');
				}else if (reqType=='OECDtinreason_new5')
				{
					select = document.getElementById('OECDtinreason_new5');
				}else if (reqType=='OECDtinreason_new6')
				{
					select = document.getElementById('OECDtinreason_new6');
				}
				var codes=ajaxRequestvalues(workstepname,reqType,0);
				
				for (var i=0 ; i< values.length ; i++) {
				var opt = document.createElement('option');
				opt.value = codes[i];
				
				opt.innerHTML = values[i];
				
				opt.length = values[i].length;
				opt.className="EWNormalGreenGeneral1";
				select.appendChild(opt);
			}
		}
		
	}

	else
	{
		alert("Error while handling "+reqType+" for the current workstep");
		return false;
	}
}
function ajaxRequestvalues(workstepname,reqType,j)
{
	//alert('handle ajax request ajaxRequest');
	var url = '';
	var xhr;
	var ajaxResult;			
	var values = "";
	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	if ( reqType =='FatcaDocNew' || reqType == 'FatcaReasonNew' || reqType =='TypeOfRelationNew'||reqType=='IndustrySubSegment_new'||reqType=='IndustrySegment_new'||reqType=='CustomerType_new'|| reqType =='USrelation_new'|| reqType =='resi_restype'|| reqType =='emp_type_new'|| reqType =='employment_status_new'|| reqType =='marrital_status_new'|| reqType =='office_cntrycode'|| reqType =='occupation_new'|| reqType =='OECDUndocreason_new' || reqType =='OECDtinreason_new' || reqType =='OECDtinreason_new2'|| reqType =='OECDtinreason_new3'|| reqType =='OECDtinreason_new4'|| reqType =='OECDtinreason_new5'|| reqType =='OECDtinreason_new6')
	{
		url = '/CU/CustomForms/CU_Specific/HandleAjaxRequestvalues.jsp?workstepname='+workstepname+"&reqType="+reqType;//workstepname not required for country drop down
	}
		
	 xhr.open("GET",url,false);
	 xhr.send(null);

	if (xhr.status == 200)
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
							
		if(ajaxResult.indexOf("Exception")==0)
		{
			alert("Unknown Exception while working with request type "+reqType);
			return false;
		}
		 if(reqType=='FatcaDocNew' ||reqType=='FatcaReasonNew' || reqType =='TypeOfRelationNew'||reqType=='IndustrySubSegment_new'||reqType=='IndustrySegment_new'||reqType=='CustomerType_new' || reqType =='USrelation_new' ||reqType=='resi_restype'||reqType=='emp_type_new'|| reqType =='employment_status_new'|| reqType =='marrital_status_new'|| reqType =='office_cntrycode'|| reqType =='occupation_new'|| reqType =='OECDUndocreason_new'|| reqType =='OECDtinreason_new'|| reqType =='OECDtinreason_new2'|| reqType =='OECDtinreason_new3'|| reqType =='OECDtinreason_new4'|| reqType =='OECDtinreason_new5'|| reqType =='OECDtinreason_new6')
		 {
			values = ajaxResult.split(",");
			return values;
			/*	var k=j;
				
				var opt = values[k];
				
				return opt;		*/
		}
		
	}

	else
	{
		alert("Error while handling "+reqType+" for the current workstep");
		return false;
	}

}



