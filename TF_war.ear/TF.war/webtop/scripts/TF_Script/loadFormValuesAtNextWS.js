function loadEventGrid(currWorkstep,WINAME)
{
	var CIFID= document.getElementById("wdesk:CIF_ID").value;
	var ServiceRequestCode= document.getElementById("wdesk:ServiceRequestCode").value;
	var EventDetailsCheckGridData= document.getElementById("wdesk:EventDetailsCheckGridData").value;
	var WS_NAME= document.getElementById("wdesk:WS_NAME").value;
	var WI_NAME= document.getElementById("wdesk:WI_NAME").value;
	var Amount = document.getElementById("wdesk:Amount").value;
	var Currency = document.getElementById("wdesk:Currency").value;
	var ApplicationDate = document.getElementById("wdesk:ApplicationDate").value;
	//Clearing event detials Grid Values
	var table = document.getElementById("EventDetailsGrid");
	var rowCount = table.rows.length;
	if(rowCount!=1)
	{
		for(var i=1;i<rowCount;i++)
		{				
			table.deleteRow(1); //Just delete the row					
		}
	}
	
	if(EventDetailsCheckGridData != '' && WS_NAME != 'CSO')
	{
			if(EventDetailsCheckGridData.indexOf('|')!=-1)
			  {
				 EventDetailsCheckGridData=EventDetailsCheckGridData.split('|');
				 for(var i=0;i<EventDetailsCheckGridData.length;i++)
				 {					
					addrowEventGrid(EventDetailsCheckGridData[i],currWorkstep)
				 }
				 
				 if(EventDetailsCheckGridData.length>2)
				 {
					document.getElementById("EventGrid").style.overflowY="scroll";
					document.getElementById("EventGrid").style.height="250px";
				}								
			  }
			  else if(EventDetailsCheckGridData.indexOf('~')!=-1)
			  {
				addrowEventGrid(EventDetailsCheckGridData,currWorkstep);
			  }
				//setting the flag after 
				document.getElementById("EventDetailsFlag").value = "Yes";				  
	}
	
	else if((WS_NAME == 'CSO' || WS_NAME == "TF_Document_Approver") && CIFID!='' && ServiceRequestCode!='')
	{
		var iframe = document.getElementById("frmData");
		var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
		var SubCategoryID = iframeDocument.getElementById("SubCategoryID").value;
		var duplicateLogic=document.getElementById("DuplicateCheckLogic").value;
		var arrayDuplicateLogic=duplicateLogic.split('$');
		var TRPARAM=arrayDuplicateLogic[0];
		var EXTPARM=arrayDuplicateLogic[1];
			
		var xhr;
		var ajaxResult;		
		if(window.XMLHttpRequest)
		xhr=new XMLHttpRequest();
		else if(window.ActiveXObject)
		xhr=new ActiveXObject("Microsoft.XMLHTTP");
		
		var url ='/TF/CustomForms/TF_Specific/getDuplicateWorkitems.jsp';
		var param = "reqType="+encodeURIComponent('EventDetailsGrid')+"&CIFID="+encodeURIComponent(CIFID)+"&ServiceRequestCode="+encodeURIComponent(ServiceRequestCode)+"&WI_NAME="+encodeURIComponent(WI_NAME)+"&Amount="+encodeURIComponent(Amount)+"&Currency="+encodeURIComponent(Currency)+"&ApplicationDate="+encodeURIComponent(ApplicationDate);
		
		xhr.open("POST", url, false);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send(param);
				
		if (xhr.status == 200 && xhr.readyState == 4)
		{	
			 ajaxResult = xhr.responseText;
			 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
			 //document.getElementById("Event_Button").disabled=true;
			 if(ajaxResult=="")	
			{			 
				alert("No data found for Event Details for the given CIF & Product type");
				document.getElementById("wdesk:EventDetailsCheckGridData").value = "";
				document.getElementById("EventDetailsFlag").value = "Yes";
				document.getElementById("Event_Button").disabled=false;
			} 
			 else if(ajaxResult=="-1")	
			{			 
				alert("Problem in Loading Event Details.");	
				document.getElementById("wdesk:EventDetailsCheckGridData").value = "";
				document.getElementById("EventDetailsFlag").value = "No";
				document.getElementById("Event_Button").disabled=false;
			}			 
			 
			 if(ajaxResult.indexOf("Exception")==0)
			 {
				alert("Unknown Exception while Loading Event Details Grid with Product type ");
				document.getElementById("wdesk:EventDetailsCheckGridData").value = "";
				document.getElementById("EventDetailsFlag").value = "No";
				document.getElementById("Event_Button").disabled=false;
				return false;
			 }	 
			  
			  else if(ajaxResult.indexOf('|')!=-1)
			  {
				 document.getElementById("wdesk:EventDetailsCheckGridData").value=ajaxResult;
				 document.getElementById("EventDetailsFlag").value = "Yes";
				 ajaxResult=ajaxResult.split('|');
				 for(var i=0;i<ajaxResult.length;i++)
				 {					
					addrowEventGrid(ajaxResult[i],currWorkstep)
				 }
				 
				 if(ajaxResult.length>2)
				 {
					document.getElementById("EventGrid").style.overflowY="scroll";
					document.getElementById("EventGrid").style.height="250px";
				 }
			  }
			  else if(ajaxResult.indexOf('~')!=-1)
			  {
				document.getElementById("wdesk:EventDetailsCheckGridData").value=ajaxResult;
				document.getElementById("EventDetailsFlag").value = "Yes";
				addrowEventGrid(ajaxResult,currWorkstep);
			  }				
			
			
		}
		else 
		{
			alert("Error while Loading EventDetails.");
			return false;
		}
	}
}

function loadChecklistvalue(currWorkstep,winame,checklistname)
{
	//alert("inside loadChecklistvalue");
				deleteRowsFromGrid("checklistGrid"); //Delete the rows from table using Grid Id
				var checklist = document.getElementById(checklistname);
				var selectedChecklist = checklist.options[checklist.selectedIndex].value
				//alert(selectedChecklist);
				if(selectedChecklist!="")
				{
					var url = '';
					var xhr;
					var ajaxResult;		
					if(window.XMLHttpRequest)
					xhr=new XMLHttpRequest();
					else if(window.ActiveXObject)
					xhr=new ActiveXObject("Microsoft.XMLHTTP");
					var ApplicationFormCode=document.getElementById("wdesk:ServiceRequestCode").value;
					url = '/TF/CustomForms/TF_Specific/loadChecklistvalue.jsp';
					var param = "checklistname="+encodeURIComponent(selectedChecklist)+"&WINAME="+winame+"&ServiceRequestCode="+ApplicationFormCode;
					//param = encodeURIComponent(param);
					xhr.open("POST", url, false);
					xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
					xhr.send(param);

					if (xhr.status == 200)
					{
						 ajaxResult = xhr.responseText;
						 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
						 if(ajaxResult=='-1')
						 {
							alert("Error while loading customer data.");
							return false;
						 }
						 else if(ajaxResult=='0')//Means no record found in database
						 {
							alert("No data found for the selected checklist");
						 }
						 else
						 {
							 ajaxResult=ajaxResult.split('|');
							 for(var i=0;i<ajaxResult.length;i++)
							 {
								var ajaxResultRow=ajaxResult[i].split('~');
								addrowchecklist(ajaxResult[i],currWorkstep)
							 }	
						 }						 
					}
					else 
					{
						alert("Exception while loading checklist data.");
						return false;
					}
				}
		
}	

function deleteRowsFromGrid(GridId)
{
	var table = document.getElementById(GridId);
	var rowCount = table.rows.length;
	rowCount=rowCount-1;//After delete table chnages his row position internaly.So we are deleating from last row
	while(rowCount>=1)
	{
		document.getElementById(GridId).deleteRow(rowCount);
		rowCount--;
	}
}

function deleteRowsFromchecklistGridWithIndex()
{
	var r = confirm("Do you want to delete the row?");
	if (r == true) {
		var row = window.event.srcElement;
		row = row.parentNode.parentNode;
		var rowindex=row.rowIndex;
		var table = document.getElementById("checklistGrid");
		var rowCount = table.rows.length;
		if(rowCount==4)//means only one row added then no need to update id's.Just delete the row
		{
			table.deleteRow(rowindex);
		}
		else if((rowCount-1)==rowindex)//means last row is being deleated then no need to update id's.Just delete the row
		{
			table.deleteRow(rowindex);
		}
		else
		{
			var arrayUIDFieldsForSave=['checklistdesc','option','remarks'];
			
				for(var k=0;k<arrayUIDFieldsForSave.length;k++)
				 {
					for(var j=rowindex;j<(rowCount-1);j++)
					{
						var currentRowId=parseInt(j)+1;
						document.getElementById(arrayUIDFieldsForSave[k]+currentRowId).id = arrayUIDFieldsForSave[k] + (j);
					}
				 }
				 table.deleteRow(rowindex);
		}
	}
}	
function loadDocumentGrid(WINAME,FlagValue,currWorkstep)
{
		if(FlagValue=='Y'){
		//alert("insidee checklist"+WINAME);		
			var url = '';
			var xhr;
			var tempFlag = true;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			
			url ='/TF/CustomForms/TF_Specific/DropDownLoad.jsp';
			var param = "reqType="+encodeURIComponent('loadDocumentGrid')+"&WINAME="+encodeURIComponent(WINAME);
			//param = encodeURIComponent(param);
			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
					
			if (xhr.status == 200)
			{	
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult.indexOf("Exception")==0)
				 {
					alert("Unknown Exception while working with request type ");
					return false;
				 }	
                 //alert("ajaxResult is"+ajaxResult);
				 document.getElementById("DocumentGRid").style.display="block";				 
				  if(ajaxResult.indexOf('|')!=-1)
				  {
					 ajaxResult=ajaxResult.split('|');
					 for(var i=0;i<ajaxResult.length;i++)
					 {
						if (addrowDocumentgrid(ajaxResult[i],currWorkstep) == false)
						{
							tempFlag= false;
							break;
						}
					 }
				  }
				  else
				  {
					   	if (addrowDocumentgrid(ajaxResult,currWorkstep) == false)
						{
							tempFlag= false;
						}
				  }
				  
					//Enabling the scrollbar for DocGrid 05122018
					if(ajaxResult!='' && ajaxResult.length>4)
					{
						document.getElementById("DocGrid").style.overflowY="scroll";
						document.getElementById("DocGrid").style.height="150px";
					}
					
				if (!tempFlag)
					return tempFlag;
			}
			else 
			{
				alert("Error while Loading Drowdown for the current workstep");
				return false;
			}
		}
	return true;	
}

function loadInvoiceGridValues(FlagValue,WINAME)
{
	if(FlagValue=='Y'){
		var url = '';
		var xhr;
		var ajaxResult;		
		if(window.XMLHttpRequest)
		xhr=new XMLHttpRequest();
		else if(window.ActiveXObject)
		xhr=new ActiveXObject("Microsoft.XMLHTTP");
		
		url = '/TF/CustomForms/TF_Specific/DropDownLoad.jsp';
		var param = "reqType="+encodeURIComponent('loadInvoiceGrid')+"&WINAME="+encodeURIComponent(WINAME);
		//param = encodeURIComponent(param);
		xhr.open("POST", url, false);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send(param);		
		if (xhr.status == 200)
		{
			 ajaxResult = xhr.responseText;
			 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
			 if(ajaxResult=='-1')
			 {
				alert("Error while loading invoice data.");
				return false;
			 }
			 else if(ajaxResult=='')//Means no record found in database
			 {
				 //alert("No Data present in invoice Grid for given "+WINAME);
			 }
			 else
			 {
				 ajaxResult=ajaxResult.split('|');
				 for(var i=0;i<ajaxResult.length;i++)
				 {
					var ajaxResultRow=ajaxResult[i].split('~');
					populateInvoiceData(ajaxResultRow);
				 }	
			 }		
		}
		else 
		{
			alert("Exception while loading invoice data.");
			return false;
		}
	}		
}	
function loadDropDownElementAtNextWS(currWorkstep)
{	

	disableAllFieldsAtNextWorkstep(currWorkstep);
	//alert("inside loadDropDownElementAtNextWS ");
	
		var Channel = document.getElementById('channnel');
		//alert("channel"+document.getElementById('wdesk:CHANNEL').value);
		if(document.getElementById('wdesk:CHANNEL').value!='')
		Channel.value = document.getElementById('wdesk:CHANNEL').value;
		
		var Nationality = document.getElementById('nationality');
		//alert("nationality"+document.getElementById('wdesk:NATIONALITY').value);
		if(document.getElementById('wdesk:NATIONALITY').value!='')
		Nationality.value = document.getElementById('wdesk:NATIONALITY').value;
		
		var industysubseg = document.getElementById('industysubseg');
		//alert("industysubseg"+document.getElementById('wdesk:INDUSTYSUBSEG').value);
		if(document.getElementById('wdesk:INDUSTYSUBSEG').value!='')
		industysubseg.value = document.getElementById('wdesk:INDUSTYSUBSEG').value;
		
		var custsegment = document.getElementById('custsegment');
		//alert("custsegment"+document.getElementById('wdesk:CUSTSEGMENT').value);
		if(document.getElementById('wdesk:CUSTSEGMENT').value!='')
		custsegment.value = document.getElementById('wdesk:CUSTSEGMENT').value;
		
		var custsubsegment = document.getElementById('custsubsegment');
		//alert("custsubsegment"+document.getElementById('wdesk:CUSTSUBSEGMENT').value);
		if(document.getElementById('wdesk:CUSTSUBSEGMENT').value!='')
		custsubsegment.value = document.getElementById('wdesk:CUSTSUBSEGMENT').value;
		
		var producttype = document.getElementById('producttype');
		//alert("producttype"+document.getElementById('wdesk:PRODUCTTYPE').value);
		if(document.getElementById('wdesk:PRODUCTTYPE').value!='')
		producttype.value = document.getElementById('wdesk:PRODUCTTYPE').value;
		
		var demographic = document.getElementById('demographic');
		//alert("demographic"+document.getElementById('wdesk:DEMOGRAPHIC').value);
		if(document.getElementById('wdesk:DEMOGRAPHIC').value!='')
		demographic.value = document.getElementById('wdesk:DEMOGRAPHIC').value;
		
		
	
}

function disableUIDGridColumns()
{
	var table = document.getElementById("uidtable");
	var rowCount=(table.rows.length);
	if(rowCount>=3)//When no row added in grid
	{
		for (var i = 3; i < rowCount; i++) 
		{	
			document.getElementById('uid'+i).disabled=true;
			document.getElementById('remark'+i).disabled=true;
			document.getElementById('image'+i).disabled=true;
		}
	}
}


function enableUIDGridColumns()
{
	var table = document.getElementById("uidtable");
	var rowCount=(table.rows.length);
	if(rowCount>=3)//When no row added in grid
	{
		for (var i = 3; i < rowCount; i++) 
		{	
			document.getElementById('uid'+i).disabled=false;
			document.getElementById('remark'+i).disabled=false;
		}
	}
}
function checkRiskScoreException()
{	
	var table=document.getElementById("RMT");
	if(parseInt(document.getElementById('wdesk:RISKSCORE').value)>750)
		{
			//raise risk score exception
			var WSNAME =document.getElementById("wdesk:CURRENT_WS").value;
			var currCheckList=document.getElementById('H_CHECKLIST').value;
			var currUser='amitabh';
			if(currCheckList.indexOf('2~[Raised')==-1)//Means this exception is not raised as of now 1-means UID exception
			{
				if(currCheckList=='')
				currCheckList='2~[Raised-'+currUser+'-'+WSNAME+'-'+getDateTime()+']';
				else
				currCheckList=currCheckList+'#'+'2~[Raised-'+currUser+'-'+WSNAME+'-'+getDateTime()+']';
				document.getElementById('H_CHECKLIST').value=currCheckList;
			}
			//break;
			
		}
			
	
}

function getDateTime()
{
var today  = new Date();
return today;
}

function getNameOfData()
{
	var iframe = document.getElementById("frmData");
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	var SubCategoryID = iframeDocument.getElementById("SubCategoryID").value;
    var CategoryID = iframeDocument.getElementById("CategoryID").value;
	var NameData = "";
    var myname;
    var WS_LogicalName;
    var eleValue;
    var eleName;
    var eleName2;
    var eleName3;
    var check;
    var inputs = iframeDocument.getElementsByTagName("input");
    var textareas = iframeDocument.getElementsByTagName("textarea");
    var selects = iframeDocument.getElementsByTagName("select");
    var store = "";
    var arrGridBundle = "";
    var singleGridBundle = "";
	
	try 
	{
        for (x = 0; x < inputs.length; x++) {
            myname = inputs[x].getAttribute("id");
            if (myname == null)
                continue;
            if (!(myname.indexOf("_gridbundle_clubbed") == -1)) {
                singleGridBundle = iframeDocument.getElementById(myname).value;
                if (arrGridBundle == "")
                    arrGridBundle = singleGridBundle;
                else
                    arrGridBundle += "$$$$" + singleGridBundle;
            }

            if (myname.indexOf(SubCategoryID + "_") == 0) {
                if ((inputs[x].type == 'radio')) {
                    eleName = inputs[x].getAttribute("name");
                    //alert("eleName:"+eleName);
                    if (store != eleName) {
                        store = eleName;
                        var ele = iframeDocument.getElementsByName(eleName);
                        for (var i = 0; i < ele.length; i++) {

                            eleName2 = ele[i].id;
                            //alert("eleName2:"+eleName2);

                            eleName2 += "#radio";
                            //alert("eleName2:::"+eleName2);
                            NameData += eleName + "#" + eleName2 + "~";
                            //alert("NameData:"+NameData);
                        }
                    }
                } else if (inputs[x].type == 'checkbox') {
                    eleName3 = inputs[x].getAttribute("name");
                    eleName3 += "#checkbox";
                    NameData += myname + "#" + eleName3 + "~";
                } else if (!(inputs[x].type == 'radio')) {
                    eleName2 = inputs[x].getAttribute("name");
                    eleName2 += "#";
                    NameData += myname + "#" + eleName2 + "~";
                }

            }
            
            else if (myname.indexOf("tr_") == 0) {
                tr_table = iframeDocument.getElementById(myname).value;
            } else if (myname.indexOf("WS_LogicalName") == 0) {
                WS_LogicalName = iframeDocument.getElementById(myname).value;
            }

        }
    } 
	catch (err) 
	{
        return "exception";
    }
	
	try 
	{
        for (x = 0; x < selects.length; x++) {
            eleName2 = selects[x].getAttribute("name");
            if (eleName2 == null)
                continue;
            eleName2 += "#select";
            myname = selects[x].getAttribute("id");
            if (myname == null)
                continue;
            var e = iframeDocument.getElementById(myname);
            if (e.selectedIndex != -1) {
                var Value = e.options[e.selectedIndex].value;
                if (myname.indexOf(SubCategoryID + "_") == 0) {
                    NameData += myname + "#" + eleName2 + "~";
                }
            }

        }
    } 
	catch (err) 
	{
        return "exception";
    }
	
	try 
	{
        for (x = 0; x < textareas.length; x++) 
		{
            myname = textareas[x].getAttribute("id");
            if (myname == null)
                continue;
            if (myname.indexOf(SubCategoryID + "_") == 0) {
                eleName2 = textareas[x].getAttribute("name");
                eleName2 += "#";
                NameData += myname + "#" + eleName2 + "~";
            }

        }
    } 
	catch (err) 
	{
        return "exception";
    }
	return NameData;
}

function getgridValuesByColumn(nameForMatch)
 {
	var colValue="";
	var iframe = document.getElementById("frmData");
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	var header=iframeDocument.getElementById("Header").value;
	var gridTable=header+"_GridTable";
	var tableRowCount=iframeDocument.getElementById(gridTable).rows.length;
	var SubCategoryID=iframeDocument.getElementById("SubCategoryID").value;		
	for (var i = 0; i < tableRowCount; i++) {
		if(i==0)
		continue;
		var id='grid_'+SubCategoryID+'_'+nameForMatch+'_'+(i-1);
		if(iframeDocument.getElementById(id).value=='')
		colValue=iframeDocument.getElementById(id).value;
		else
		colValue=colValue+'@'+iframeDocument.getElementById(id).value;
	}
	return colValue;
 }
