<!----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation          
//File Name					 : Print.jsp
//Author                     : Manish K. Agrawal
// Date written (DD/MM/YYYY) : 16-Oct-2006
//Description                : Code to print the request.
//------------------------------------------------------------------------------------------------------------------------------------>

<%@ page import="java.io.*,java.util.*"%>
<!--File contains function for reading dateformat from webdesktop.ini-->
<%@ include file="/CustomForms/RAKBANK/CommonJsp.jsp"%>


<link href='/webdesktop/webtop/css/docstyle.css' rel='stylesheet' type='text/css'>

<script language="javascript" src="/webdesktop/webtop/en_us/scripts/RBCommon.js"></script>
<script>

var strDateFormat="<%=DateFormat%>";

//----------------------------------------------------------------------------------------------------
//Function Name                    : Load()
//Date Written (DD/MM/YYYY)        : 17-Oct-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : NA
//Output Parameters                : NA
//Return Values                    : NA
//Description                      : Prits the request.
//----------------------------------------------------------------------------------------------------



function Load()
{
	try
	{
		var objTbl=document.getElementById("tbl");
		var dataForm=window.opener.document.forms.dataform;
		var cnt=0;
		for(var i=0;i<dataForm.elements.length;i++)
		{
			if(dataForm.elements[i].type=='text' )
			{
				if(dataForm.elements[i].name == 'Header' )
				{
					var objRow=objTbl.insertRow();					
					var objCell=objRow.insertCell();
					objCell.innerHTML="<BR>";
					
					var objRow=objTbl.insertRow();					
					var objCell=objRow.insertCell();
					objCell.className='RBPrint';
					var objCell=objRow.insertCell();
					objCell.innerHTML =dataForm.elements[i].value;
					objCell.colSpan=2;
					objCell.className='RBPrint';
					var objCell=objRow.insertCell();
					objCell.className='RBPrint';
				
					var objRow=objTbl.insertRow();					
					var objCell=objRow.insertCell();
					objCell.innerHTML="<BR>";
					cnt=0;

				}
			}
			
			if(2==cnt)
			{
				cnt=0;
			}
			if(0==cnt)
			{
			  var objRow=objTbl.insertRow();
			}
			
			if(dataForm.elements[i].type=='text' )
			{	
				if(dataForm.elements[i].name != 'ProcessCode' && dataForm.elements[i].name != 'Branch' && dataForm.elements[i].name != 'BRANCHDATETIME' && dataForm.elements[i].name != 'BranchUSERNAME' && dataForm.elements[i].name != 'Q_AGREEMENT_NO' && dataForm.elements[i].name != 'Q_EQUATION_LOAN_NO' && dataForm.elements[i].name != 'Q_CUSTOMER_NAME' && dataForm.elements[i].name != 'Q_BRANCH' && dataForm.elements[i].name != 'Q_SERVICE_REQUEST' && dataForm.elements[i].name != 'Q_PREVIOUS_WORKSTEP' && dataForm.elements[i].name != 'CSM_MAIL_ID' && dataForm.elements[i].name != 'BM_MAIL_ID' && dataForm.elements[i].name != 'Header' && dataForm.elements[i].name != '' && dataForm.elements[i].name != undefined && dataForm.elements[i].style.display!='none')
				{
						var objCell=objRow.insertCell();
						objCell.width='180';
						objCell.innerHTML =  window.opener.document.getElementById(dataForm.elements[i].name).innerHTML + " : "; 
						objCell.style.fontWeight = "bold"; 
						var objCell=objRow.insertCell();
						objCell.width='190';
						objCell.innerHTML =  dataForm.elements[i].value;
						//objCell.align='left';
						objCell.className='RBPrint2';
						if (dataForm.elements[i].name =='ServiceTypeName'){
							objCell.colSpan=4;
							cnt++;
						}
						cnt++;
				}
			}

			if(dataForm.elements[i].type=='select-one')
			{
				if(dataForm.elements[i].name != '' && dataForm.elements[i].name != undefined && dataForm.elements[i].style.display!='none')
				{
						var objCell=objRow.insertCell();
						objCell.width='180';
						objCell.innerHTML =  window.opener.document.getElementById(dataForm.elements[i].name).innerHTML + " : "; 
								//				objCell.className='EWSubHeader';	
						objCell.style.fontWeight = "bold"; 

						var objCell=objRow.insertCell();
						objCell.width='190';
						objCell.innerHTML =  dataForm.elements[i][dataForm.elements[i].selectedIndex].value;
						objCell.className='RBPrint2';
						cnt++;

				}
			}

		}
	
		var objRow=objTbl.insertRow();					

		var objCell=objRow.insertCell();
		objCell.innerHTML="<BR><BR><BR>";
		var objRow=objTbl.insertRow();					

		var objCell=objRow.insertCell();
		objCell.innerHTML =  "Branch User: " + dataForm.elements['BranchUSERNAME'].value; 

		var dDate= new Date();
		var objCell=objRow.insertCell();
		

		//objCell.innerHTML = replaceAll(LocalToDB(replaceAll(dataForm.elements['BRANCHDATETIME'].value.substring(0,10),"-","/"),"DD/MM/YYYY"),"-","/").substring(0,10);
		objCell.innerHTML = DBToLocal(dataForm.elements['BRANCHDATETIME'].value, strDateFormat).substring(0,10);

		var objCell=objRow.insertCell();
		
		var objCell=objRow.insertCell();
		objCell.innerHTML =  "(Signature)";
		
		window.print();
	}
	catch(e)
	{
		alert(e.message);
	}
}
</script>
<body onload="Load()">
<table id=tbl width=740 cellpadding=0 cellspacing=0>
	<tr>
		<td colspan=3 align=right width=400 >
			&nbsp;
		</td>
		<td align=left width=340 >
			<img src='\webdesktop\webtop\images\rak-logo.gif'>
		</td>
	</tr>
</table>
</body>