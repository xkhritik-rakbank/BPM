<!----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Cards         
//File Name					 : Print.jsp
//Author                     : Sachin
// Date written (DD/MM/YYYY) : 19-Oct-2007
//Description                : Code to print the request.
//------------------------------------------------------------------------------------------------------------------------------------>

<%@ page import="java.io.*,java.util.*"%>
<!--File contains function for reading dateformat from webdesktop.ini-->
<%@ include file="/CustomForms/RAKBANK/CommonJsp.jsp"%>


<link href='/webdesktop/webtop/css/docstyle.css' rel='stylesheet' type='text/css'>
<head>
		<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>;
</head>
<script language="javascript" src="/webdesktop/webtop/en_us/scripts/RBCommon.js"></script>
<script>

var strDateFormat="<%=DateFormat%>";



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
					objCell.className='EWLabelRB2';
					var objCell=objRow.insertCell();
					objCell.innerHTML =dataForm.elements[i].value;
					objCell.colSpan=6;
					objCell.className='EWLabelRB2';
					var objCell=objRow.insertCell();
					objCell.className='RBPrint';
				
					var objRow=objTbl.insertRow();					
					var objCell=objRow.insertCell();
					objCell.innerHTML="<BR>";
					cnt=0;

				}
			}
			
			if(3==cnt)
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
						objCell.width='150';
						objCell.innerHTML =  window.opener.document.getElementById(dataForm.elements[i].name).innerHTML + " : "; 
						//objCell.style.fontWeight = "bold"; 
						var objCell=objRow.insertCell();
						objCell.width='100';
						objCell.innerHTML =  dataForm.elements[i].value;
						//objCell.align='left';
						objCell.className='RBPrint2';
						if (dataForm.elements[i].name =='ServiceTypeName'){
							alert('123');
							objCell.colSpan=4;
							cnt++;
						}
						cnt++;
				}
			}

			if(dataForm.elements[i].type=='select-one')
			{
				if(dataForm.elements[i].name != '' && dataForm.elements[i].name != undefined && dataForm.elements[i].style.display!='none' && dataForm.elements[i].name != 'Cards_Decision')
				{
						var objCell=objRow.insertCell();
						objCell.width='220';
						
						var Cname="C_" + dataForm.elements[i].name 
					   
						objCell.innerHTML = eval("window.opener.document.getElementById(\"" + Cname + "\").innerHTML") + " : "; 
								
						//objCell.style.fontWeight = "bold"; 

						var objCell=objRow.insertCell();
						objCell.width='100';
						objCell.innerHTML =  dataForm.elements[i][dataForm.elements[i].selectedIndex].value;
						objCell.className='RBPrint2';
						cnt++;
						if(dataForm.elements[i+1].name.indexOf("1")!=-1)
					{
							cnt=0;
					}

				}
			}
			if(dataForm.elements[i].type=='checkbox' )
			{	
				if(dataForm.elements[i].name != '' && dataForm.elements[i].name != undefined && dataForm.elements[i].style.display!='none')
				{
						var objCell=objRow.insertCell();
						objCell.width='200';
						//objCell.noWrap=true;
						var Cname="C_" + dataForm.elements[i].name 
						objCell.innerHTML =eval("window.opener.document.getElementById(\"" + Cname + "\").innerHTML"); 
						//objCell.style.fontWeight = "bold"; 
						var objCell=objRow.insertCell();	
						objCell.width='100';
						//objCell.innerHTML =  dataForm.elements[i].value;
						//objCell.align='left';
						objCell.className='RBPrint2';
						
						cnt++;
				}
			}

				if(dataForm.elements[i].type=='textarea' )
			{	
					
				if(dataForm.elements[i].name != '' && dataForm.elements[i].name != undefined && dataForm.elements[i].style.display!='none' && dataForm.elements[i].name != 'BA_Remarks' && dataForm.elements[i].name != 'Cards_Remarks')
				{
					
						var objCell=objRow.insertCell();
						objCell.width='200';
						
						objCell.innerHTML = window.opener.document.getElementById(dataForm.elements[i].name).innerHTML+ " : ";  
						
						//objCell.style.fontWeight = "bold"; 
                        var objCell=objRow.insertCell();
						objCell.width='100';						
						objCell.innerHTML =  dataForm.elements[i].value;
						objCell.align='left';
						objCell.className='RBPrint2';
						
						cnt++;
				}
			}

		}
	
		var objRow=objTbl.insertRow();	
		objCell=objRow.insertCell();
		objCell.innerHTML="<BR><BR><BR>";

		var objRow=objTbl.insertRow();			
		var objCell=objRow.insertCell();
		var objCell=objRow.insertCell();
		var objCell=objRow.insertCell();
		var objCell=objRow.insertCell();
		var objCell=objRow.insertCell();
		var objCell=objRow.insertCell();
		objCell.innerHTML =  "(Signature)";

		var objRow=objTbl.insertRow();
		var objCell=objRow.insertCell();
		var objCell=objRow.insertCell();
		var objCell=objRow.insertCell();
		var objCell=objRow.insertCell();
		var objCell=objRow.insertCell();
	//	objCell.innerHTML="<BR><BR><BR>";
		var dDate= new Date();
		var month=dDate.getMonth()+1;

		var objCell=objRow.insertCell();
		objCell.innerHTML = "Date:"+dDate.getDate()+"/" + month + "/" + dDate.getFullYear();
		
		window.print();
	}
	catch(e)
	{
		alert(e.message);
	}
}
</script>
<body onload="Load()" class='EWGeneralRB'>
<table id=tbl width="100%"   cellpadding=0 cellspacing=0>
	<tr width="100%">
		<td colspan=5 align=right width="90%" >
			&nbsp;
		</td>
		<td colspan=1 align=left width="10%" >
			<img src='\webdesktop\webtop\images\rak-logo.gif'>
		</td>
	</tr>
</table>
</body>