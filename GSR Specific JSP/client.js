

if( typeof strprocessname === "undefined" )
{
	var closedFromCloseButton='';
	processName="SRM";
	var counthash = 0;
	var exception = false;
	var exceptionstring = '';
	var decisionsaved = 'Y';
	window.document.write("<script src=\"/webdesktop/webtop/scripts/SRM_Scripts/Validation_SRM.js\"></script>");
	window.document.write("<script src=\"/webdesktop/webtop/scripts/SRM_Scripts/Custom_Validation.js?13\"></script>");
	window.document.write("<script src=\"/webdesktop/webtop/scripts/SRM_Scripts/aes.js\"></script>");
	window.document.write("<script src=\"/webdesktop/webtop/scripts/SRM_Scripts/json3.min.js?123\"></script>");
	window.document.write("<script src=\"/webdesktop/webtop/scripts/SRM_Scripts/populateCustomValue.js\"></script>");
}
else if( strprocessname=='SRM' || strprocessname=='SRB')
{

	var closedFromCloseButton='';
	
	//window.document.write("<script src=\"/webdesktop/webtop/scripts/"+processName+".js\"></script>");
	var counthash = 0;
	var exception = false;
	var exceptionstring = '';
	var decisionsaved = 'Y';
	window.document.write("<script src=\"/webdesktop/webtop/scripts/SRM_Scripts/Validation_SRM.js\"></script>");
	window.document.write("<script src=\"/webdesktop/webtop/scripts/SRM_Scripts/Custom_Validation.js?13\"></script>");
	window.document.write("<script src=\"/webdesktop/webtop/scripts/SRM_Scripts/aes.js\"></script>");
	window.document.write("<script src=\"/webdesktop/webtop/scripts/SRM_Scripts/json3.min.js?123\"></script>");
	window.document.write("<script src=\"/webdesktop/webtop/scripts/SRM_Scripts/populateCustomValue.js\"></script>");
	
	
	
}
else if( strprocessname=='AO')
{


	var closedFromCloseButton='';
	 window.document.write("<script src=\"/webdesktop/webtop/scripts/AO_Scripts/aes.js\"></script>");
	window.document.write("<script src=\"/webdesktop/webtop/scripts/AO_Scripts/json2.min.js?123\"></script>");
	window.document.write("<script src=\"/webdesktop/webtop/scripts/AO_Scripts/json3.min.js?123\"></script>");
	window.document.write("<script src=\"/webdesktop/webtop/scripts/AO_Scripts/populateCustomValue.js\"></script>");
	window.document.write("<script src=\"/webdesktop/webtop/scripts/AO_Scripts/formLoad_AO.js\"></script>");
	window.document.write("<script src=\"/webdesktop/webtop/scripts/AO_Scripts/keyPressValidation.js\"></script>");
	window.document.write("<script src=\"/webdesktop/webtop/scripts/AO_Scripts/AO_constants.js\"></script>");
	window.document.write("<script src=\"/webdesktop/webtop/scripts/AO_Scripts/Validation_AO.js\"></script>");
	window.document.write("<script src=\"/webdesktop/webtop/scripts/AO_Scripts/Custom_Validation.js\"></script>");
	
	
	
}
else if(strprocessname=='TT')
{
	window.document.write("<script src=\"/webdesktop/webtop/scripts/TT_Scripts/TTvalidate.js\"></script>");
}        
else if(processName=='TL')
{
	window.document.write("<script src=\"/webdesktop/CustomForms/TL_Specific/Validation_TL.js\"></script>");
		
}    
	
//latinChars should be comma separated e.g. â,bē
var latinChars=["â"];//Bug 66390
var DOCRLOS;

function AOSAVEDATA(IsDoneClicked)
{   var processName= strprocessname;

	if(processName!='AO')
		return false;
	var customform='';
	var formWindow=getWindowHandler(windowList,"formGrid");
	customform=formWindow.frames['customform'];
	var SubCategoryID="1";
	var CategoryID="5";	
	var Category="Account Opening";
	var SubCategory="Account Opening Request";
	var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
	var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
	var H_Checklist=customform.document.getElementById("H_Checklist").value;
	var H_RejectReasons=customform.document.getElementById("H_RejectReasons").value;
	if(WSNAME=='Branch_Controls')
		H_RejectReasons=customform.document.getElementById("BranchCtrlRejectReasons").value;
	else if(WSNAME=='WM_Controls')
		H_RejectReasons=customform.document.getElementById("WMCtrlRejectReasons").value;
	else if(WSNAME=='SME_Controls')
		H_RejectReasons=customform.document.getElementById("SMECtrlRejectReasons").value;
	else if(WSNAME=='PB_Credit')
		H_RejectReasons=customform.document.getElementById("PBCreditRejectReasons").value;
	
	//var H_DocumentList=customform.document.getElementById("H_DocumentList").value;
	/*if(WSNAME=='Branch_Controls')
		H_DocumentList=customform.document.getElementById("BranchCtrlDocumentsList").value;
	else if(WSNAME=='WM_Controls')
		H_DocumentList=customform.document.getElementById("WMCtrlDocumentsList").value;
	else if(WSNAME=='SME_Controls')
		H_DocumentList=customform.document.getElementById("BranchCtrlDocumentsList").value;
	else if(WSNAME=='PB_Credit')
		H_DocumentList=customform.document.getElementById("PBCreditDocumentsList").value;*/
	
	var iframe = customform.document.getElementById("frmData");
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	var WIDATA="";
	var NameData="";
	var myname;
	var tr_table;
	var WS_LogicalName;
	var eleName;
	var eleName2;
	var inputs = iframeDocument.getElementsByTagName("input");
	var textareas = iframeDocument.getElementsByTagName("textarea");
	var selects = iframeDocument.getElementsByTagName("select");
	var store="";
	for (x=0;x<inputs.length;x++)
	{	
		myname = inputs[x].getAttribute("id");
		if(myname== null || myname=='null'){
			continue;
		}
		if(myname.indexOf(SubCategoryID+"_")==0)
		{
			if((inputs[x].type=='radio')) 
			{	
				eleName = inputs[x].getAttribute("name");
				if(store!=eleName)
				{
					store=eleName;
					var ele = iframeDocument.getElementsByName(eleName);
					for(var i = 0; i < ele.length; i++)
					{	eleName2=ele[i].id;
						eleName2+="#radio";
						NameData+=eleName+"#"+eleName2+"~";
					}	
				}
			}
			else if(!(inputs[x].type=='radio'))
			{	
				eleName2 = inputs[x].getAttribute("name");
				eleName2+="#";
				NameData+=myname+"#"+eleName2+"~";		
			}
		
		}
		else if(myname.indexOf("tr_")==0)
		{
			tr_table = iframeDocument.getElementById(myname).value;			
		}
		else if(myname.indexOf("WS_LogicalName")==0)
		{
			WS_LogicalName = iframeDocument.getElementById(myname).value;
		}
	
    }

	for (x=0;x<selects.length;x++)
	{
		eleName2 = selects[x].getAttribute("name");
		eleName2+="#select";
		myname = selects[x].getAttribute("id");
		var e = iframeDocument.getElementById(myname);
		if(e.selectedIndex!=-1)
		{
			var Value = e.options[e.selectedIndex].value;
			if(myname.indexOf(SubCategoryID+"_")==0)
			{
				NameData+=myname+"#"+eleName2+"~";
			}
		}
	
    }
	for (x=0;x<textareas.length;x++)
	{
		myname = textareas[x].getAttribute("id");
		if(myname.indexOf(SubCategoryID+"_")==0)
		{
			eleName2 = textareas[x].getAttribute("name");
			eleName2+="#";
			NameData+=myname+"#"+eleName2+"~";	
		}
    }
	
	if(Custom_Validation('AO',NameData,iframeDocument,customform,CategoryID,SubCategoryID,IsDoneClicked) && Validate(NameData,iframeDocument,IsDoneClicked))
	{	
		//if block added for CBWC UID check
		//if(WSNAME=='CB-WC Maker' || WSNAME=='CB-WC Checker' || WSNAME=='Branch_Controls' )
		if(WSNAME=='CB-WC Checker' || WSNAME=='Branch_Controls' || WSNAME=='Controls' )
		{
			var col1="";
			var col2="";
			var table = iframeDocument.getElementById("myTable");
			
			var nosofrows=table.rows.length;
			var i,j;
			for (i = 2; i < nosofrows; i++)
			{ 
				var currentrow = table.rows[i]; 
				for(j=1;j<=2;j++)
				{ 
					if(j==1)
					{
						if(col1=="")
						{
							col1=currentrow.cells[j].childNodes[0].value+"#";
						}	
						else
						{		 
							if(currentrow.cells[j].childNodes[0].value=="") 
							{
								currentrow.cells[j].childNodes[0].value=" ";
								col1+=currentrow.cells[j].childNodes[0].value+"#";
							}
							else
							{			
								col1+=currentrow.cells[j].childNodes[0].value+"#";
							}
						}		
					}				
				
					if(j==2)
					{
						if(col2=="")
						{
							col2=currentrow.cells[j].childNodes[0].value+"#";
						}	
						else
						{
							if(currentrow.cells[j].childNodes[0].value=="") 
							{
								currentrow.cells[j].childNodes[0].value=" ";
								col2+=currentrow.cells[j].childNodes[0].value+"#";
							}
							else
							{			
								col2+=currentrow.cells[j].childNodes[0].value+"#";
							}
						}		
					}
				}
			}	
		}
		WIDATA=computeWIDATA_AO(iframe,SubCategoryID,WSNAME);
		
		var OLD_CIF_ID = iframeDocument.getElementById("1_CIF_Id").value;
		if(WSNAME=='OPS_Maker')
		{
			var rvc_package = iframeDocument.getElementById("1_rvc_package").value;
			var IsSignatureCropped = customform.document.getElementById("IsSignatureCropped").value; //Code added by vidushi to get the value of hidden field 
		}
		var xhr;
		if(window.XMLHttpRequest)
			 xhr=new XMLHttpRequest();
		else if(window.ActiveXObject)
			 xhr=new ActiveXObject("Microsoft.XMLHTTP");

		var abc=Math.random
		//Value of IsSignatureCropped  added to the list of parameters
		var url="/webdesktop/CustomForms/AO_Specific/AO.jsp";
		var param="WIDATA="+WIDATA+"&WINAME="+WINAME+"&TEMPWINAME=&tr_table="+tr_table+"&WSNAME="+WSNAME+"&WS_LogicalName="+WS_LogicalName+"&CategoryID="+CategoryID+"&SubCategoryID="+SubCategoryID+"&IsDoneClicked="+IsDoneClicked+"&IsSaved=Y&abc="+abc+"&H_Checklist="+encodeURIComponent(H_Checklist)+"|"+encodeURIComponent(H_RejectReasons)+"&OLD_CIF_ID="+OLD_CIF_ID+"&UIDDetails="+col1+"&RemarksDetails="+col2+"&rvc_package="+rvc_package+"&IsSignatureCropped="+IsSignatureCropped;
			
		url=replaceUrlChars(url);
		
		xhr.open("POST",url,false);
		xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');		
		xhr.send(param);
		if (xhr.status == 200 && xhr.readyState == 4)
		{
			ajaxResult=Trim(xhr.responseText);
	
			if(ajaxResult == 'NoRecord')
			{
				alert("No record found.");
				return false;
			}
			else if(ajaxResult == 'Error')
			{
				alert("Some problem in creating workitem.");
				return false;
			}			
		}
		else
		{
			
			alert("Problem in saving data AO.jsp.");
			return false;
		}		
		return true;
	}
	return false;
	
}

function computeWIDATA_AO(iframe, SubCategoryID,WSNAME,IsDoneClicked,CategoryID,fobj)
{	
	
	var customform='';
	customform=fobj;	
			
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	var WIDATA="";
	var myname;
	var tr_table;
	var eleValue;
	var eleName;
	var eleName2;
	var check;
	var inputs = iframeDocument.getElementsByTagName("input");
	var textareas = iframeDocument.getElementsByTagName("textarea");
	var selects = iframeDocument.getElementsByTagName("select");
	
	var WSNAME = iframeDocument.getElementById("WS_NAME").value;
	var store="";
	try{
		for (x=0;x<inputs.length;x++)
		{
			
			if(!(inputs[x].type=='radio')) 
			{
				eleName2 = inputs[x].getAttribute("name");
				
				if(eleName2==null)
					continue;
				eleName2+="#";
				var temp=eleName2.split('#');
				var IsRepeatable=temp[4];
				myname = inputs[x].getAttribute("id");
			}
			else
			{
				eleName2 = inputs[x].getAttribute("id");
				
				if(eleName2==null)
					continue;
				eleName2+="#";
				var temp=eleName2.split('#');
				var IsRepeatable=temp[4];
				myname = inputs[x].getAttribute("name");
			}
			
			
			
			if(myname==null)
				continue;
			if(myname.indexOf(SubCategoryID+"_")!=0)
			{
				if((inputs[x].type=='hidden'))
				{
					continue;
				}
			}
			
			if(IsRepeatable!='Y')
			{
				if(myname.indexOf(SubCategoryID+"_")==0)
				{
					if((inputs[x].type=='radio')) 
					{	
						eleName = inputs[x].getAttribute("name");
						if(store!=eleName)
						{
							store=eleName;
							var ele = iframeDocument.getElementsByName(eleName);
							for(var i = 0; i < ele.length; i++)
							{	
								eleName2=ele[i].id;
								eleName2+="#radio";
								if(ele[i].checked)
								{
									eleValue = encodeURIComponent(ele[i].value);
									WIDATA+=eleName.substring(2)+"#"+eleValue+"~";
									counthash++;
								}
								
							}	
						}
						
					}
					else if((inputs[x].type=='checkbox'))
					{	

						eleName2 = inputs[x].getAttribute("name");
						eleName2+="#";
						var temp=eleName2.split('#');
						var is_workstep_req=temp[3];
						var IsRepeatable=temp[4];
						if(iframeDocument.getElementById(myname).value=='')
						{	WIDATA+=myname.substring(2)+"#NULL"+"~";
							
						}
						else
						{	if (iframeDocument.getElementById(myname).checked)
							{
								if(is_workstep_req=='Y')
									WIDATA+=myname.substring(2)+"#"+WSNAME+"$"+"true"+"~";
								else
									WIDATA+=myname.substring(2)+"#"+"true"+"~";
							} else {
								if(is_workstep_req=='Y')
									WIDATA+=myname.substring(2)+"#"+WSNAME+"$"+"false"+"~";
								else
									WIDATA+=myname.substring(2)+"#"+"false"+"~";
							}
						}
						
					}
					else if(!(inputs[x].type=='radio'))
					{	
						eleName2 = inputs[x].getAttribute("name");
						eleName2+="#";
						var temp=eleName2.split('#');
						var is_workstep_req=temp[3];
						var IsRepeatable=temp[4];
						if(iframeDocument.getElementById(myname).value=='')
						{	
							WIDATA+=myname.substring(2)+"#NULL"+"~";
							counthash++;
						}
						else
						{	
							if(is_workstep_req=='Y')
							{
								{
									WIDATA+=myname.substring(2)+"#"+WSNAME+"$"+encodeURIComponent(iframeDocument.getElementById(myname).value)+"~";
									counthash++;
								}
							}	
							else
							{
								WIDATA+=myname.substring(2)+"#"+encodeURIComponent(iframeDocument.getElementById(myname).value)+"~";
								counthash++;
							}	
						}						
					}				
				}				
			}
			//Added by Aishwarya 14thApril2014
			else if(myname.indexOf("tr_")==0)
			{
				tr_table = iframeDocument.getElementById(myname).value;
			}			
		}		
	}catch(err){
		exception=true; 
		exceptionstring=exceptionstring+"textboxexception:"; 
		return;
	}
	try{
	for (x=0;x<textareas.length;x++)
	{
		eleName2 = textareas[x].getAttribute("name");
		if(eleName2==null)
			continue;
		eleName2+="#";
		var temp=eleName2.split('#');
		var IsRepeatable=temp[4];
		myname = textareas[x].getAttribute("id");
		if(myname==null)
			continue;
		if(IsRepeatable!='Y'){
			if(myname.indexOf(SubCategoryID+"_")==0)
			{
				eleName2 = textareas[x].getAttribute("name");
				var temp=eleName2.split('#');
				var is_workstep_req=temp[3];
				var IsRepeatable=temp[4];
				if(iframeDocument.getElementById(myname).value=='')
				WIDATA+=myname.substring(2)+"#NULL"+"~";
				else
				{
					if(is_workstep_req=='Y')
					{
						WIDATA+=myname.substring(2)+"#"+WSNAME+"$"+encodeURIComponent(iframeDocument.getElementById(myname).value)+"~";
					}
					else
					{
						WIDATA+=myname.substring(2)+"#"+encodeURIComponent(iframeDocument.getElementById(myname).value)+"~";
					}
				}
			}
		}
    }
	}catch(err){exception=true; exceptionstring+= "textareaexception:"; return;}
	try{
	for (x=0;x<selects.length;x++)
	{	
		eleName2 = selects[x].getAttribute("name");
		if(eleName2==null)
			continue;
		eleName2+="#select";
		myname = selects[x].getAttribute("id");
		if(myname==null)
			continue;
		var temp=eleName2.split('#');
		var is_workstep_req=temp[3];
		var IsRepeatable=temp[4];
		var e = iframeDocument.getElementById(myname);
		if(myname=='1_Account_No_2')
		{
			var Value="";
			for (var opts=0;opts<e.options.length;opts++)
			{
				if(Value =='')
					Value=e.options[opts].value;
				else
					Value+="|"+e.options[opts].value;
			}
			if(Value=='')
				Value='NULL';
			WIDATA+=myname.substring(2)+"#"+encodeURIComponent(Value)+"~";
		}
		else if(IsRepeatable!='Y')
		{
		
			if(e.selectedIndex!=-1)
			{
				var Value = e.options[e.selectedIndex].value;
				if(myname.indexOf(SubCategoryID+"_")==0)
				{
					if(Value=='--Select--')
					{	
						WIDATA+=myname.substring(2)+"#NULL"+"~";
						
					}	
					else
					{
						if(is_workstep_req=='Y')
						{
							WIDATA+=myname.substring(2)+"#"+WSNAME+"$"+encodeURIComponent(Value)+"~";
						}	
						else
						{
							WIDATA+=myname.substring(2)+"#"+encodeURIComponent(Value)+"~";
						}
						
					}
				}
			}	
		}
    }
	}catch(err){exception=true; exceptionstring+= "selectexception:";return;}		
	
	return WIDATA;	
}
function executeActionClick(actionName)
{
	return true;
}


function OpenCustomUrl(url,name)
{//todo security
    url = url.replace('\\','\\\\');    
    var src = url;
    customChildCount++;
    
    url = getActionUrlFromURL(src);
    url = appendUrlSession(url);
    
    var wFeatures = 'resizable=yes,scrollbars=1,status=yes,width='+window1W+',height=320,left='+window1Y+',top='+window1X;
    
    var listParam=new Array();
    listParam = getInputParamListFromURL(src);
	// Custom Change Start
	if(decodeURIComponent(name) == 'UploadMultipleDocument') 
	{
        listParam.push(new Array('ProcessInstanceId', pid));
        listParam.push(new Array('WorkitemId', wid));
        listParam.push(new Array('ProcessName', strprocessname));
        listParam.push(new Array('ActivityName', stractivityName));
    }	
	// Custom Change End
    customChild[customChildCount] = openNewWindow(url,name,wFeatures, true,"Ext1","Ext2","Ext3","Ext4",listParam);
    
   // url = appendUrlSession(url);
  //  customChild[customChildCount] = window.open(url,name,'resizable=yes,scrollbars=auto,width='+window1W+',height=320,left='+window1Y+',top='+window1X);        
}


function CustomFormReload(loc)
{
	//Just uncomment below line if value to be set is in the form
//	eval(loc).reload();
}

function MoreActionsClick()
{
	return true;
}


function ToolsClick()
{
	return true;
}


function PreferenceClick()
{
	return true;
}


function ReassignClick(wiInfo,from)
{
    /*
      wiInfo              : Selected workitem information 
      from                : WDESK or WLIST or REASSIGN_LINK_CLICK_FROM_WLIST or REASSIGN_LINK_CLICK_FROM_WDESK
      from is 'WDESK'     : when reffered by opening the workitem i,e from workdesk
      from is 'WLIST'     : when reffered without opening workitem i,e from workitem list
      
      ReassignComments    : This tag contain Reassign  Comment 
      ReassignTo          : This tag contain User  to which workitem is going to reassign
      ReassignToUserIndex : This tag contain UserIndex of user to which workitem is going to reassign
      ReassignBY          : This tag contain User who is going to reassign the workitem
      ReassignByUserIndex : This tag contain UserIndex of user who is going to reassign the workitem 
    */
	return true;
}


function LinkedWiClick()
{
	return true;
}


function QueryClick()
{
	return true;
}


function SearchDocClick()
{
	return true;
}


function SearchFolderClick()
{
	return true;
}


function AddConversationClick()
{       
        
	return true;
}


function AddDocClick()
{
	return true;
}


function ImportDocClick()
{
	return true;
}


function ScanDocClick()
{
	return true;
}


function SaveClick()
{
	
	 if(strprocessname=='SRM')
	{	
		var result=SRMSAVEDATA(false);
		if(result)
		{

			return true;
		}
		else
		{	
			if(result=="exception")
			{
				alert("There is some problem in saving data. Please contact administrator.");
				return false;
			}
			else
			{
				return false;
			}
		}
	}
	else if(strprocessname=='AO')
	{	
		if(AOSAVEDATA(false))
		{
			return true;
		}
		else
		{	
			return false;
		}
	}
	else if (strprocessname=='TT')
	{
		var customform='';
		var formWindow=getWindowHandler(windowList,"formGrid");
		customform=formWindow.frames['customform'];
		var workstepName=customform.document.getElementById("wdesk:WS_NAME").value;
		var a = mainvalidateFormOnSave(workstepName);
		if(workstepName=="CallBack" || workstepName=="CSO_Exceptions")
		{
			if(TTSAVEDATA(false))
			{
				return true;
			}
			else
			{	
				return false;
			}
		}
		return a;
	}
	else if (processName=='TL')
	{	
	//alert('IN SAVE CLICK');
		if(TLSAVEDATA(false))
		{
			
			return true;
			
		}
		else
		{	
			return false;
		}
	}
			
			return true;
}

function saveClickedTL()
{
			var svalue="", parser, xmlDoc;
			var xhr;
			var ajaxResult;
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			svalue = customform.document.getElementById("mainGridDataForTable").value;
			var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
			
			var url="/webdesktop/CustomForms/TL_Specific/GridDataOnSave.jsp";
			var param="svalue="+svalue+"&WINAME="+WINAME;
			
			//alert(param);
			xhr.open("POST",url,false);
			xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');		
			xhr.send(param);
			
			if (xhr.status == 200 && xhr.readyState == 4)
			{
				ajaxResult=xhr.responseText;
				ajaxResult=ajaxResult.replace(/^\s+|\s+$/gm,'');
				if(ajaxResult == 'NoRecord')
				{
					alert("No record found.");
					return false;
				}
				else if(ajaxResult == 'Error')
				{
					alert("Some problem in fetch Details.");
					return false;
				}
				else
				{
					//alert(ajaxResult);

					
				}				
			}
			else {
				alert("Problem in mainGridDetails.jsp");
				return false;
			}	

			
			return true;
		
		
	}

function IntroduceClick()
{ var processName= strprocessname;

	if(processName=='AO')

	{	
		closedFromCloseButton = 'true';

		
		if(AOSAVEDATA(true))
		{	


			return true;
		}
		else
			return false;
    }
	else if(processName=='TT'){

		
		return DoneClick();		
	}
	
	
	else
		return true;
}


function RejectClick()
{
	return true;
}


function AcceptClick()
{
	return true;
}


function DoneClick()
{ var processName= strprocessname;
	
	if (typeof processName!="undefined" &&(processName=='SRM'))
	{	
		closedFromCloseButton = 'true';
		
		if(validateOnDoneClick())
		{
			if(SRMSAVEDATA(true))
			{	

				return true;
			}
			else
				return false;
		}
		else
			return false;
    }
	else if(typeof processName!="undefined" && (processName=='AO'))
	{	
		closedFromCloseButton = 'true';

		
		if(AOSAVEDATA(true))
		{	


			return true;
		}
		else
		return false;
    }
	else if(typeof processName!="undefined" && (processName=='TT'))
	{
		var customform='';
		var formWindow=getWindowHandler(windowList,"formGrid");
		customform=formWindow.frames['customform'];
		
		var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
		//alert("WSNAME"+WSNAME);
		if(mainvalidateForm(WSNAME))
		{
			if(TTSAVEDATA(true))
			{
				return true;
			}
			else
			{

				return false;
			}
		}
		else
			return false;
	}
	else if(typeof processName!="undefined" && (processName=='TL'))
	{
		if(TLSAVEDATA(true))
		{	
		
			return true;

		}
		else
		{
		return false;
		}
	
    }
	
		
	else
		return true;
}

function ValidateDocumentName(documentName,documentType){
 
    return true;
}

function RevokeClick()
{
	return true;
}


function PrevClick()
{
	return true;
}


function NextClick()
{
    return true;
}


function ExceptionClick()
{
	return true;
}


function FormViewClick()
{
	return true;
}


function ToDoListClick()
{
	return true;
}


function DocumentClick()
{
	return true;
}


function ClientInterfaceClick(url)
{
	return true;
}


function NewClick(processDefId, queueId, queueType, queueName) {
	//To provide Pre-Hook to create new workitem
	var flag = true;
	if(queueName == "CSR_BT_Work Introduction" || queueName == "BAIS_Introduction"){
		alert("Please use the Initiate button to create the request");
		flag = false;
	}
	return flag;
}

function WIPropertiesClick()
{
    //  var left=parseInt(ScreenWidth/2)-parseInt(600/2);
  //   var top=parseInt(ScreenHeight/2)-parseInt(410/2);
//	var wFeatures = 'height='+550+',width='+600+',resizable=0,status=1,scrollbars=auto,top='+top+',left='+left;
 //    var url ="https://www.goibibo.com";   // url      
 //    var name = "CustomWin"; // name
 //  openNewWindow(url,name,wFeatures, true,"Ext1","Ext2","Ext3","Ext4","");
    
	return true;
}


function PriorityClick()
{
	return true;
}


function ReminderClick()
{
	return true;
}





function saveFormData()
{
	return true;
}


function NGGeneral(sEventName,sXML)
{
	switch(sEventName)
	{
		case 'ImportDoc' :
			window.parent.parent.frames["wiview_top"].importDoc('S');
			break;
	}
}


function preHook(opType)
{
	return true;
}

function CommentWiClick(){
              return true;
}

function getUploadMaxLength(strprocessname, stractivityName, docType)
{
    /*
         strprocessname :   Name of the Current Process
         stractivityName:   Name of the Current Activity
    */
   /*Bug 42111
         strprocessname :   Name of the Current Process
         stractivityName:   Name of the Current Activity
	 docType	:	DocumentType
    if(strprocessname == 'AttachTest' && stractivityName == 'Work Introduction1' && docType == 'attachmentfree')
    {
        return 5;
    }
    else if(strprocessname == 'AttachTest' && stractivityName == 'Work Introduction1' && docType == 'selfattach')
    {
        alert("In else if ");
        return 15;
    }
    else
    {
        alert("In else");
        return 10;
    }
*/
	return 10;
}

function WFGeneralData(){
       
}
function CustomShow(){
              return true;
}

function setFormFocus(){
 
}

function commitException(){
    return true;
}

function validateUploadDocType(docExt,DocTypeName)// WCL_8.0_081
{ 
	///check doc extension and return false from the function in case of undesired file extension 
	//alert("Inside Extension"+docExt+DocTypeName);
	//Added for RAKSIGN Process - Start
	if(strprocessname=='RAKSIGN'){
	if((docExt.toLowerCase().indexOf('pdf') !=0 ) && (DocTypeName.indexOf("PAR")== 0 || DocTypeName.indexOf("SCR")== 0)){
	  alert("Only PDF files are allowed for SCR/PAR document type");
	  return false;
	 }
	}
	//Added for RAKSIGN Process - End
	return true;
}

function validateUploadDocTypeName(DocTypeName)// WCL_8.0_081
{
        //make custom check for the Document Type Name 
 	var win_workdesk = window.opener;
        var winList=win_workdesk.windowList;
        var formWindow=getWindowHandler(winList,"formGrid");
        var formFrame; 
        if(formWindow){
            if(win_workdesk.wiproperty.formType=="NGFORM"){
		formFrame = formWindow; 
                // Write custom code here for ngform   
            }
            else if(win_workdesk.wiproperty.formType=="HTMLFORM"){
                formFrame = formWindow;
                //Write custom code here for HTMLForm
            }
           else if(win_workdesk.wiproperty.formType=="CUSTOMFORM"){
                formFrame = formWindow.frames['customform'];
                //Write custom code here for customform
            }
        }

	return true;
}
function ToggleFocus(interfaceFlag)
{
    if(interfaceFlag == "F")
    {
          /*if(typeof  interFace0!='undefined'){
                if(interFace0=="doc" && interFace2!=""){
                     toggleIntFace("doc",interFace2);
                }
                else if(interFace1=="doc" && interFace3!=""){
                     toggleIntFace("doc",interFace3);
                }
                else if(interFace2=="doc" && interFace0!=""){
                     toggleIntFace("doc",interFace0);
                }
                else if(interFace3=="doc" && interFace1!=""){
                    toggleIntFace("doc",interFace1);
                }
          }
           if(document.IVApplet)
            {
               try{
                    document.IVApplet.setIVFocus();
                }catch(ex){
                  }
        }*/
        
        if((wiproperty.formType == "NGFORM") && (ngformproperty.type == "applet") && !bDefaultNGForm){
            var ngformIframe = document.getElementById("ngformIframe");	
            if(ngformIframe != null){
                if(bAllDeviceForm){                          
                    try{
                        ngformIframe.contentWindow.eval("com.newgen.iforms.focus()");	
                    } catch(e){                        
                    }
                } else {
                    ngformIframe.contentWindow.eval("com.newgen.omniforms.formviewer.focus()");	
                }
            }
         } else if((typeof document.wdgc!='undefined') && document.wdgc){
            document.wdgc.NGFocus();
         } else {
                var htmlFormPanel = window.document.getElementById("wdesk:htmlFormPanel")
                if(htmlFormPanel!=null){           
                   try{               
                        htmlFormPanel.rows[0].cells[1].firstChild.focus();
                    } catch(e){}
                }
         }
    }
    else if(interfaceFlag == "D")
     {

           /*if(typeof  interFace0!='undefined'){
                if(interFace0=="form" && interFace2!=""){
                     toggleIntFace("form",interFace2);
                }
                else if(interFace1=="form" && interFace3!=""){
                     toggleIntFace("form",interFace3);
                }
                else if(interFace2=="form" && interFace0!=""){
                     toggleIntFace("form",interFace0);
                }
                else if(interFace3=="form" && interFace1!=""){
                    toggleIntFace("form",interFace1);
                }
          }
          
             try{
                 if((wiproperty.formType == "NGFORM") && (ngformproperty.type == "applet") && !bDefaultNGForm){
                    var ngformIframe = document.getElementById("ngformIframe");	
                    if(ngformIframe != null){
                        ngformIframe.contentWindow.eval("com.newgen.omniforms.formviewer.focus()");	
                    }
                 } else {
                     if((typeof document.wdgc!='undefined') && document.wdgc){
                        document.wdgc.NGFocus();
                     }
                 }
            }catch(ex){
              }*/
        
        try{               
               window.document.getElementById("wdesk:docCombo").focus();
        } catch(e){}        
          
    }else if(interfaceFlag=="W"){
       window.focus();
   } else if(interfaceFlag == "E"){
        if(window.document.getElementById("wdesk:expList")!=null){
            try{
                window.document.getElementById("wdesk:expList").focus();
            } catch(e){}
        }
   } else if(interfaceFlag == "T"){
        var todoListTableRef = window.document.getElementById("wdesk:todoListTable")
        if(todoListTableRef!=null){           
           try{               
                todoListTableRef.rows[0].cells[1].firstChild.focus();
            } catch(e){}
        }
   }
}
function getTempletPref(){ 

    var strTemplatePrefXml=''; 

    return strTemplatePrefXml; 
}
function showPriority(){
        var priorityArray =new Array();
        priorityArray[0]=1;  //Low (replace 1 by 0 for removing it from priority combo)
        priorityArray[1]=1;  //Medium
        priorityArray[2]=1;  //High
        priorityArray[3]=1; //Very High
        return priorityArray;
}
function customValidation(opt){
	//Custom Change Start
	//Modified by Reddy on 15-02-2022 for custom JSP processes
	var ret = true;
	var ngformIframeRef = window.frames["ngformIframe"];
	if(typeof ngformIframeRef != 'undefined' && ngformIframeRef != null) 
	{
		try
		{
			ret = ngformIframeRef.contentWindow.customValidation(opt);  //For Chrome
		}
		catch(ex)
	{
			ret = ngformIframeRef.customValidation(opt);       //// For IE
		} 
	}	
	return ret;
	// Custom Change End
    //In case of Save opt="S" and for Done and Introduce opt="D"   
    //return true;

}
function enableWLNew(queueName,UserName){    

  return true;
}
function validateCropDocTypeName(DocTypeName){ 
  return true;
}

function hideWdeskMenuitems(){
    var wdeskMenu=""; 
    //wdeskMenu=LABEL_SAVE_WDESK+","+LABEL_INTRODUCE_WDESK;
	// Custom Change Start
	
	// Custom Interface should not be available when workitem is opened in read only mode
	if((parent.document.title).indexOf("(read only)")>0)
	{
		wdeskMenu="Custom Interfaces";
		return wdeskMenu;
	}
	//******************************************************
	
	// Custom Interface should not be available for CAS processes
	if(strprocessname == "PersonalLoanS" || strprocessname == "CreditCard" || strprocessname == "RLOS" || strprocessname == "DigitalOnBoarding")
	{
		wdeskMenu="Custom Interfaces";
	}
	//******************************************************
	
    if(strprocessname == "PC" || strprocessname == "CMS" || strprocessname == "RAOP" || strprocessname == "CMP" || strprocessname == "ML" || strprocessname == "CBP" || strprocessname == "ACP" || strprocessname == "DAC" || strprocessname == "TT" || strprocessname == "OECD" ||strprocessname == "CSR_CCC" || strprocessname == "CSR_MR" || strprocessname == "CSR_OCC" || strprocessname == "CSR_BT" || strprocessname == "DSR_ODC" || strprocessname == "DSR_DCB" || strprocessname == "DSR_MR" || strprocessname == "CSR_CBR" || strprocessname == "CSR_CCB" || strprocessname == "CSR_RR" || strprocessname == "DSR_CBR" || strprocessname == "PL_ES" || strprocessname == "PL_IPDR" || strprocessname == "PL_PS" || strprocessname == "PL_PD" || strprocessname == "GSR_LCOL" || strprocessname == "GSR_EmpAdd" || strprocessname == "ExcessAuthReq" || strprocessname == "RMT" || strprocessname == "TWC" || strprocessname == "RBL" || strprocessname == "iRBL" || strprocessname == "ODDD" || strprocessname == "DA" || strprocessname == "AO" || strprocessname == "FPU" || strprocessname == "SAR" || strprocessname == "SRB" || strprocessname == "EPP" ||  strprocessname == "TF" ||  strprocessname == "BAIS" ||  strprocessname == "SRM" || strprocessname == "TL" || strprocessname == "CU" )
    {
		wdeskMenu=LABEL_HOLD_WDESK; 
	}
	// Custom Change End
    return wdeskMenu;
}

function hideWdeskSubMenuitems(){
   var wdeskSubMenu="";
   //wdeskSubMenu=LABEL_ADD_DOCUMENT_WDESK+","+LABEL_SCAN_DOCUMENT_WDESK; 
   return wdeskSubMenu;
}

function setAttributeData()
{
    closeFrm = 'ok';
    var inputObject,i;
    var inputObjectValue;
    var inputObjectType;
   // var attributeData = '';
    var tmpObj = document.forms["dataForm"];
   // var status = htmlFormOk(window,"dataForm");
   // alert(document.forms["dataForm"].elements.length);
    for ( i=0; i < document.forms["dataForm"].elements.length ; i++) {		
        if (document.forms["dataForm"].elements[i].type == "text" || document.forms["dataForm"].elements[i].type == "textarea" ||  document.forms["dataForm"].elements[i].type == "select-one" || document.forms["dataForm"].elements[i].type == "textarea") {
            inputObject = document.forms["dataForm"].elements[i].name;
            inputObjectValue = document.forms["dataForm"].elements[i].value;
            if(document.forms["dataForm"].elements[i].type == "text"){
                inputObjectType = document.forms["dataForm"].elements[i].alt;
            } else {
                inputObjectType = "";
            }

          //  attributeData +=inputObject.substring((inputObject.indexOf(SYMBOL_3) + 1))+SEPERATOR2+inputObjectValue+SEPERATOR2+inputObjectType+SEPERATOR1;
            attributeData +="<"+inputObject.substring((inputObject.indexOf(":")+1))+">"+inputObjectValue+"</"+inputObject.substring((inputObject.indexOf(":")+1))+">";
        }
    }
            
    if(typeof window.opener != 'undefined' && typeof window.opener.customDoneCallBack != 'undefined'){
        window.opener.customDoneCallBack(attributeData,attributeXmlTmp,queueName);
    }
    
    /*
     if(typeof window.opener != 'undefined' && typeof window.opener.customInitiateCallBack != 'undefined'){
        window.opener.customInitiateCallBack(attributeData,attributeXmlTmp,queueName);
     }
    */
    
    window.close();
    return false;
}

function WIWindowName(pidWid,processName,activityName){
    
 return pidWid;
}
function UnassignClick(){

 return true;   
}
function LockForMePreHook(){

 return true;   
}
function setQueueData(queueId,selectedWICount)
{
     var dataXMl="";
    //TODO set your queue variable or external variable return the dataXML in given format--
    // <VaribaleName>variableValue</VaribaleName>
     return dataXMl;
}

function enableCustomButton(strSelQueueName,strFrom){  
     return true;
}
function CustomButtonClick(selectedWIInfo){  
    //Uncomment refresh() for refreshing workitem list.
   //refresh();
   return true;
}

function enableReassignHook(strSelQueueName,strFrom){   

    /*
         strSelQueueName: selected QueueName (in case of search it is blank) 
         strFrom        : W or F or S
         W              : Workitem list form any queue
         F              : Workitem list form Filter
         S              : Workitem list form Search
    */

     return   true;
}

function enableReferHook(strSelQueueName,strFrom){  
   
    /*
         strSelQueueName: selected QueueName (in case of search it is blank)
         strFrom        : W or F or S
         W              : Workitem list form any queue
         F              : Workitem list form Filter
         S              : Workitem list form Search
    */

   return   true;
}
function enableLockForMe(strSelQueueName,strFrom){  
   
    /*
         strSelQueueName: selected QueueName (in case of search it is blank) 
         strFrom        : W or F or S
         W              : Workitem list form any queue
         F              : Workitem list form Filter
         S              : Workitem list form Search
    */

   return   true;
}
function enableRelease(strSelQueueName,strFrom){  
   
    /*
         strSelQueueName: selected QueueName (in case of search it is blank)
         strFrom        : W or F or S
         W              : Workitem list form any queue
         F              : Workitem list form Filter
         S              : Workitem list form Search
    */

   return   true;
}
/*
function enableDelete(strSelQueueName,strFrom){  
   
    
         strSelQueueName: selected QueueName (in case of search it is blank)
         strFrom        : W or F or S
         W              : Workitem list form any queue
         F              : Workitem list form Filter
         S              : Workitem list form Search
    

   return   true;
}*/
function customFieldForCropping(){ 
  // return the name of string type array variable for displaying combo for it on crop document page.
 return ""; 
}

function customDataDefName(strProcessname, strActivityname, strUsername, strDocType){
 
    /*
         strProcessname :   Name of the Current Process
         strActivityname:   Name of the Current Activity    
         strUsername    :   Current Logged in Username
         strDocType     :   Document type to be associated with Dataclass
         return         :   DataDefinition Output XML string.
    */

     return ("");
}
function OkConversationClick() {

}
function customClick(linkName){
    return true;
  }
function docAndFormAppletHeight(strprocessname,stractivityName){
  var strDocAndFormHeight="";                     // 180 need to be subtracted from screen height for MenuBar.
  // strDocAndFormHeight="<DocHeight>"+strDocHeight+"</DocHeight><FormHeight>"+strFormHeight+"</FormHeight>";
  return strDocAndFormHeight;
}
function enableDone(strSelQueueName,strFromSearch,bDone,strFrom)
{
    /*
         strSelQueueName: selected QueueName (in case of search it is blank) 
         strFrom        : W or F or S
         W              : Workitem list form any queue
         F              : Workitem list form Filter
         S              : Workitem list form Search
    */
/*    if(strFromSearch=='true'){
        var arrSeleQueueName=strSelQueueName.split(",");
        for(var i=0;i<arrSeleQueueName.length;i++){
          if selected workitem is assigned to someone else, it will give value of queue name as ''
          if selected workitem is assigned to you, it will give value of queue name as My Queue
          if selected workitem is unassigned, it will give the original queue name 
            if(arrSeleQueueName[i]==''){
                return false;
            }
        }
    } else{
          if strFromSearch is false, strSelQueueName will return a single queue name as before           
    }*/
    return false;
}

function enableInitiate(strSelQueueName,strFromSearch,bInitiate,strFrom){
    /*
         strSelQueueName: selected QueueName (in case of search it is blank) 
         strFrom        : W or F or S
         W              : Workitem list form any queue
         F              : Workitem list form Filter
         S              : Workitem list form Search
    */
/*     if(strFromSearch=='true'){
        var arrSeleQueueName=strSelQueueName.split(",");
        for(var i=0;i<arrSeleQueueName.length;i++){
          if selected workitem is assigned to someone else, it will give value of queue name as ''
          if selected workitem is assigned to you, it will give value of queue name as My Queue
          if selected workitem is unassigned, it will give the original queue name 
            if(arrSeleQueueName[i]==''){
                return false;
            }
        }
    } else{
          if strFromSearch is false, strSelQueueName will return a single queue name as before           
    }*/
    return false;

}

function isSaveOnClose(strProcessName,strActivityName) {
return true;
}

function isAlertOnWorkitemClose(strProcessName,strActivityName) {
return true;
}

function LinkedWiClick()
{
	return true;
}

function worklistHandler(from,wiInfo){
    /*
       from             : reassign
       wiInfo           : Selected workitem information
    */
  return true;
}
function validateCropDocTypeName(DocTypeName){
  return true;
}
function UploadDocClick(){
     return true;
}
function isShowGRTActionStatus(strCallbackResponse) {
    return true;
}
function isEnableDownloadFlag(strprocessname,stractivityName)
{
return true;
}
function isEnableEditDocFlag(strProcessname,strActivityname )
{
return true;
}
function workitemOperation(opt,ext){
    if(wiproperty.locked != 'Y') {
        if(opt=="S"){
            mainSave();
        }else if(opt=="D"){
            if(wiproperty.operationOption== 'done')
                done();
            else if(wiproperty.operationOption== 'introduction')
                introduceWI();
        }
    }
    if(opt=="C"){
        closeWorkdesk();
    }
}

function getSelectedDocumentDetails()
{
    var dataXMl="";
    var objCombo=document.getElementById('wdesk:docCombo');
    var strDocIndex=objCombo.value;
    var strDocName=objCombo[objCombo.selectedIndex].text;
    dataXMl += '<Document><DocumentIndex>'+strDocIndex+ '</DocumentIndex><DocumentName>'+strDocName+'</DocumentName></Document>';
    return dataXMl;

}

function chkForRaisedExcp(selindx, seltxt)
{

/*   var retExp = getInterfaceData('E');
   for(var i=0;i< retExp.length;i++){
        var exceptionName = retExp[i].name;
        var seqid = retExp[i].seqid;
        var RaiseComment=retExp[i]. RaiseComment;
   }
*/
return true;
}

function ReferClick(commentsRfer,referTo,referBY,from)
{
  /*  commentsRfer    : Refer Comment
      referTo         : User  to which workitem is reffered
      referBY         : User who refer the workitem
      from            : WDESK or WLIST
      from is 'WDESK' : when reffered by opening the workitem i,e from workdesk
      from is 'WLIST' : when reffered without opening workitem i,e from workitem list
  */
   return true;
}

function ReassignClick()
{
	return true;
}

function getDoneInformation(){
    /*   user name can be found in variable : username
                 e.g. alert(username);  */

    /* following loop will get processincstanceid activityName and processName of the selected done workitems */
     var ctrlTable=document.getElementById("wlf:pnlResult");
    var checkboxId="wlf:cb_";
    var rowCount = ctrlTable.tBodies[0].rows.length;
    if(rowCount>0) {
        for(var iCount = 0; iCount < rowCount-1;iCount++)
        {
            var wiClicked=document.getElementById(checkboxId+iCount);
            if(wiClicked.checked){
                    
                var jsonOutput=document.getElementById("wlf:hjn"+(iCount+1)).innerHTML;
                //jsonOutput= eval("("+jsonOutput+")");
                jsonOutput = jsonOutput.split(SEPERATOR1+SEPERATOR4);
                var arrobjJsonOutput= jsonOutput;
                //for(var i=0;i<arrobjJsonOutput.length;i++){
                   // var outputJson=arrobjJsonOutput[i];
                    //var objJson=outputJson.Output;
                    var activityName,processName,processInstanceId,queueId,queueName;
                   // if(objJson.Name=='ActivityName'){
                        //listParam.push(new Array(objJson.Name,encode_ParamValue(objJson.Value)));
                        activityName=+arrobjJsonOutput[7];
                   // }
                   // if(objJson.Name=='RouteName'){
                        //  listParam.push(new Array(objJson.Name,encode_ParamValue(objJson.Value)));
                        processName=arrobjJsonOutput[6];
                   // }
                   // if(objJson.Name=='ProcessInstanceID'){
                        //  listParam.push(new Array(objJson.Name,encode_ParamValue(objJson.Value)));
                        processInstanceId=arrobjJsonOutput[3];
                    //}
                       queueId=arrobjJsonOutput[12];
                       queueName=arrobjJsonOutput[11];
               // }
            }
        }
    }
}

function wiOptDoneClick(){//Bug 68258
    /* following loop will get processincstanceid activityName and processName of the selected done workitems
    var ctrlTable=document.getElementById("wlf:pnlResult");
    var checkboxId="wlf:cb_";
    var rowCount = ctrlTable.rows.length;
    if(rowCount>0) {
        for(var iCount = 0; iCount < rowCount-2;iCount++)
        {
            var wiClicked=document.getElementById(checkboxId+iCount);
            if(wiClicked.checked){
                    
                var jsonOutput=document.getElementById("wlf:hjn"+(iCount+1)).innerHTML;
                //jsonOutput= eval("("+jsonOutput+")");
                jsonOutput = jsonOutput.split(SEPERATOR1);
                var arrobjJsonOutput= jsonOutput;
               // for(var i=0;i<arrobjJsonOutput.length;i++){
                   // var outputJson=arrobjJsonOutput[i];
                  //  var objJson=outputJson.Output;
                    var activityName,processName,processInstanceId,queueId,queueName;
                   // if(objJson.Name=='ActivityName'){
                        //listParam.push(new Array(objJson.Name,encode_ParamValue(objJson.Value)));
                        activityName=+arrobjJsonOutput[7];
                   // }
                   // if(objJson.Name=='RouteName'){
                        //  listParam.push(new Array(objJson.Name,encode_ParamValue(objJson.Value)));
                        processName=arrobjJsonOutput[6];
                   // }
                   // if(objJson.Name=='ProcessInstanceID'){
                        //  listParam.push(new Array(objJson.Name,encode_ParamValue(objJson.Value)));
                        processInstanceId=arrobjJsonOutput[3];
                   // }
                  //queueId=arrobjJsonOutput[12];
                  //  queueName=arrobjJsonOutput[11];
               // }
            }
        }
    }*/
    return false;
}

function isDefaultDocument(processName,activityName){
          return true;
} 

function customDone(opt)
{
    //opt=1 for  done and bring next workitem
    //opt=2 for only done
    if(isFormLoaded==false)
        return;
    showProcessing();
    if(!form_cutomValidation("D")){
        hideProcessing();
        return false;
    }
    if(!saveFormdata('formDataTodo','done')){
        hideProcessing();
        return false;
    }

    handleDoneWI(opt);
	alert('The request has been submitted successfully.');
}
function customIntroduce(opt)
{
    //opt=1 for  done and bring next workitem
    //opt=2 for only done
    if(isFormLoaded==false)
        return;
    showProcessing();
    if(!form_cutomValidation("D")){
        hideProcessing();
        return false;
    }
    var batchflag=document.getElementById('wdesk:batchflag').value;
    if(!saveFormdata('formDataTodo','introduce')){
        hideProcessing();
        return false;
    }
    handleIntroduceWI(opt);

}

function noClickAfterDone(){

}
function customUserList(strUname){

    /*
         strqueueId       :   Name of the queue selected
         strUname         :   Current Logged in Username
         userPersonalName :   User's personal name (to whom workitems to be reassigned)
         userName         :   User's name (to whom workitems to be reassigned) 
         userIndex        :   User's index (to whom workitems to be reassigned)
         return           :   false
    */  
//         Usage:

//        var queueId = document.getElementById("reassignworkitem:hidQueueId").value;
//        document.getElementById('reassignworkitem:bp:UserName').value=userName;
//        document.getElementById('reassignworkitem:hidUserIndex').value=userIndex;
//        document.getElementById('reassignworkitem:hidUserName').value=userName;
//              
//        return false; 
		   
    return true;
}

function customUserListForSetDiversion(strUname){

    /*
         strqueueId       :   Name of the queue selected
         strUname         :   Current Logged in Username
         userPersonalName :   User's personal name (to whom workitems to be reassigned)
         userName         :   User's name (to whom workitems to be reassigned) 
         userIndex        :   User's index (to whom workitems to be reassigned)
         return           :   false
    */  
//         Usage:

//        document.getElementById('setdiversion:assignedName').value=userName;
//        document.getElementById('setdiversion:hidAssignedToIndex').value=userIndex;
//        document.getElementById('setdiversion:hidAssignedToName').value=userName;
//              
//        return false; 
		   
    return true;
}
function referBtnClick(referTo){
//alert(referTo); 
 return true;
}

function validateUploadFormFieldRestriction(fileName){
    var win_workdesk = window.opener;
    var formBuffer;
    var winList=win_workdesk.windowList;
    var formWindow=getWindowHandler(winList,"formGrid");
    if(typeof formWindow!='undefined'){
        if(win_workdesk.wiproperty.formType=="NGFORM")
        {
            if(!(win_workdesk.ngformproperty.type=="applet"))
                formBuffer = new String(formWindow.document.wdgc.FieldValueBag);
            else if(win_workdesk.ngformproperty.type=="applet")
            {
                if(win_workdesk.bDefaultNGForm){
                    formBuffer=formWindow.document.wdgc.getFieldValueBagEx();
                }
                formBuffer=formBuffer+"";
            }
        }
    }
     // Write custom code here for ngform. Parse formBuffer and use if/else logic to return false if filename and field value doesn't match else return true;
    return true;
}
function excphook(strRaiseComnt ,strRaiseExp, strRaiseExpName ){
    raiseComnt = strRaiseComnt;
    raiseExp   = strRaiseExp;
    raiseExpName = strRaiseExpName;
    raiseExcep_open('Y');
}


function customRaiseExp(){
    return false;
}

function setCustomExpVar()
{
   document.getElementById("raise:comnt").value = window.parent.raiseComnt;
   document.getElementById("raise:Exp").value = window.parent.raiseExp;
   document.getElementById("raise:expName").value = window.parent.raiseExpName;
}

function setColorForDocumentList(pid,wid){
  /*if(pid=="WF-00000000000000006-gen7" && wid=="1"){
        var objCombo = document.getElementById('wdesk:docCombo');
        var arr=["red","blue"];
        for(var index2=0;index2<objCombo.length;index2++){
            
            var docType=objCombo.options[index2].text;
            if ((docType.indexOf("(") != -1))
                docType = docType.substring(0,docType.indexOf("("));
            if(docType =="doc1"){
                objCombo.options[index2].style.color=arr[0];
            }else if(docType =="doc2"){
                objCombo.options[index2].style.color=arr[1];
            }
        }
    }*/
    return true;
}


function ChangeColorOnComboSelect(docindex){
    try{
        var objCombo = document.getElementById('wdesk:docCombo');     
      objCombo.style.color = objCombo.options[docindex].style.color;
    }catch(e){ }
}
function StartSessionActiveTimer()
{
    var interval = 30;   //interval in seconds

    StartCheckIsAdminTimer(interval);
}

function StopSessionActiveTimer()
{
    StopCheckIsAdminTimer();
}
function isZoningRequired()
{
   
 /*
   var objCombo = document.getElementById('wdesk:docCombo');
   var strDocName=objCombo[objCombo.selectedIndex].text;

   activityName : Activity Name
   strDocName   : selected doc name (contains doc type)
   return : false for the Doc types for which no zoning is required
*/
   return true;

}

function customHighlightZone()
{
    /*
     drawExtractZone (int zoneType, int x1, int y1, int x2, int y2, int zoneColor, int thickness, boolean isMutable)
    
Where 
	 zoneType Type of Extract Zone � Permissible values are the following defined constants:
     EXT_ZONE_SOLID_RECT = 1 (draws hollow rectangle)
     EXT_ZONE_HIGHLIGHT = 2 (draws highlighted rectangle)
     x1 x-coordinate of top-left corner of the zone
     y1 y-coordinate of top-left corner of the zone
     x2 x-coordinate of bottom-right corner of the zone
     y2 y-coordinate of bottom-right corner of the zone
     zoneColor Color of extract zone (for e.g., dvBlue = 170, dvYellow = 16776960, dvBlack = 0, dvLightGray = 8421504)
     thickness thickness of the extract zone. Permissible values are integer values between 1 and 5 pixels
     isMutable Specifying whether the extract zone is mutable i.e. it can be selected, moved or resized or not.

For example
	 
     if(document.IVApplet)
        document.IVApplet.drawExtractZone(2, 150, 150, 580, 580, 16776960 , 5,true);
		
    */
    
}

function enableOverwriteInImportDoc(strprocessname,stractivityName ,docType){
    /*

      strprocessname    : Process Name
      stractivityName   : Activity Name
      docType           : Document Type
      return false for the docType  for which overwrite to be disabled , Note that this hook will work only if no modify right on that docType
    */
return true;
}

function  RefreshClientComp(){
    try{
     /*var ref = window.parent.getComponentRef(sourceInsId).contentWindow;
	 ref.reloadPage(pid);  /*implemented by the calling page*/
         }catch(e){}
}
function eventDispatched(pId,pEvent){
	switch(pEvent.type)
    {           
        case 'click':
        {
            switch(pId)
            {
				case 'opt1':alert('');
				break;
			}
		}	
	}
}

function getExtParam(processName, activityName)
{
  var retXML =  "";
   /*
     This function will return the  process variables and these values to be saved in workitem while Save / Done / Introduce operation.
   */
 // retXML =  "<Attributes><Attribute><Name>qname</Name><Value>dssD</Value></Attribute><Attribute><Name>qage</Name><Value>65</Value></Attribute></Attributes>";
  return retXML;
}

/*
 *sample code for field validation (Global Method associated with process variant field)
function validateAccNo(ref){
	var strPrefix = "wdesk";
	var field = ref;
	var bError = false;
	var msg = "";
	var dtime;//time to display the message
	var rem = "true";//to remove the message after specified time or not
	var fieldLength = field.value.length;
	var fieldValue = field.value;
	if(fieldLength>15){
		bError = true;
        msg = "Length of account number should be less than 15";
    }
	if(!bError){
		var i=0;
	    if(fieldValue=='-'){
			bError = true;
			msg = "Invalid Number Entered";
		}
		if(!bError && fieldValue.charAt(0)=='-')
			i=1;

		for (; i < fieldValue.length; i++)
		{   
			var c = fieldValue.charAt(i);
			if (!((c >= "0") && (c <= "9"))){ 
				bError = true;
				msg = "Invalid Number Entered";
				break;
			}
		}

	}
	
	if(bError){
                var workdeskView = (typeof wdView == "undefined")? '': wdView;
		if((isEmbd == 'Y') && (workdeskView == "em") && document.getElementById("wdesk:indicatorPG"))
			document.getElementById("wdesk:indicatorPG").style.display = "inline";

		var messageDiv=document.getElementById("wdesk:messagediv");
        if(messageDiv){
            var messagePG = document.getElementById("wdesk:messagedivPG");
            if(messagePG){                
                var isSafari = navigator.userAgent.toLowerCase().indexOf('safari/') > -1; 
                if(isSafari){
                    messagePG.style.width = "auto";
                    messagePG.style.display = "inline-block";
                } else {
                    messagePG.style.display = "inline-table";
                }
                messageDiv.innerHTML= msg; 
				messagePG.style.display = "inline-table";
            }
        }
		
		if(!dtime) {
			dtime=3000;
		}
		if(rem) {
			if(rem=="true") {
				setTimeout("removemessageFromDiv()",dtime);
			}
		}
	}
}
*/

function yesBringNextWI(strprocessname,stractivityName)
{
/* strprocessname : Process Name
 * stractivityName : Activity Name
 * return false will not open Bring Next Workitem in dialog box
 * will work only when there is entry YesBringNextWI=N in webdesktop.ini
*/
 //return true;
 return false;
}
function disableConfirmDone(strprocessname,stractivityName)
{
/* strprocessname : Process Name
 * stractivityName : Activity Name
 * return false will  open confirm done window
 * will work only when there is entry ConfirmDone=N in webdesktop.ini
*/
	// Custom Change Start
	if(strprocessname == "PC" || strprocessname == "RAOP" || strprocessname == "CMS" || strprocessname == "CMP" || strprocessname == "CBP" || strprocessname == "ML" || strprocessname == "ACP" || strprocessname == "DAC" || strprocessname == "TT" || strprocessname == "OECD" ||  strprocessname == "CSR_CCC" || strprocessname == "CSR_MR" || strprocessname == "CSR_OCC" || strprocessname == "CSR_BT" || strprocessname == "DSR_ODC" || strprocessname == "DSR_DCB" || strprocessname == "DSR_ODC" || strprocessname == "CSR_CBR" || strprocessname == "CSR_CCB" || strprocessname == "CSR_RR" || strprocessname == "DSR_CBR" || strprocessname == "PL_ES" || strprocessname == "PL_IPDR" || strprocessname == "PL_PS" || strprocessname == "PL_PD" || strprocessname == "GSR_LCOL" || strprocessname == "GSR_EmpAdd" || strprocessname == "ExcessAuthReq" || strprocessname == "RMT" || strprocessname == "TWC" || strprocessname == "RBL" || strprocessname == "iRBL" || strprocessname == "ODDD"|| strprocessname == "BSR" || strprocessname == "RAKPOC" || strprocessname == "RAKSIGN" || strprocessname == "DA" || strprocessname == "AO" || strprocessname == "FPU" || strprocessname == "SAR" || strprocessname == "SRB" ||  strprocessname == "EPP" ||  strprocessname == "TF" ||  strprocessname == "BAIS" ||  strprocessname == "SRM" || strprocessname == "SRM" || strprocessname == "CU")
		return true;
	else
		return false;
	// Custom Change End
 //return true;
}

function nameUploadDocument(strDocName,frm,processname, activityname,username)
{

/*
    alert(strDocName);
    alert(frm);
    alert(processname);
    alert(activityname);
    alert(username);
    alert(strDocName); 
*/	
return strDocName;
}

function mandatoryCommentsBeforeReassign(strprocessname,stractivityName)
{
/*  if(document.wdgc != undefined)
    {
    if( document.wdgc.getNGValue("formcontrolname") == "" ) {   
    alert(ENTER_YOUR_MSG_HERE);
    return false;   
    }
    else
    return true;
    }    
*/
    
/*
     *formcontrolname : name of form control on which you want apply validation
     *return true:will open reassign window
     *return false :will not open reassign window
*/
    return true;
}

function isCustomValidException(selectedExcpName)
{
    // if it returns false , the exception will not be raised
    return true;
}

function postHookGenerateResponse(docIndex, docName, responseDescription)
{
 /*
         docIndex: Document Index of the added Document
		 docName: Document Type of the added Document
 */

}

function cropDocTypeList(strprocessname,stractivityName,strPageNo,docName)
{
    /*  strprocessname : Process Name
        stractivityName : Activity Name
     *  strPageNo       : Page No from which image is cropped
     *  docName         : Document Type & Name from which image is cropped
     *  
     *  return the doc types as Comma separated e.g.- "doc1,doc2"
     *  Doc types returned are CASE SENSITIVE. 
     */
    return  "";
}

function importDocumentPrehook(docTypeName)
{
   /* Sample custom code to retrieve Document typon executeActies added in import Document Window combo list as well in workitem window's added documents and
    * Will not upload the documents if this Hook returns false
    *
   var objCombo = window.opener.document.getElementById('wdesk:docCombo');
    if(typeof objCombo != 'undefined')
      {
        for(var index2=0;index2<objCombo.length;index2++){

            var importedDocType=objCombo.options[index2].text;
            if(importedDocType.indexOf(docTypeName)== 0)
             {
                alert("Document Already Added");
                return false;
             }

        }
      }
   */
   //Added for RAKSIGN Process Import Document Prehook Validation - Start
	if(strprocessname=='RAKSIGN')
	{			
		if(stractivityName=='Initiator')
		{
		var objCombo = window.opener.document.getElementById('wdesk:docCombo');
		if(typeof objCombo != 'undefined')
		{
			for(var index2=0;index2<objCombo.length;index2++){
            var importedDocType=objCombo.options[index2].text;
            if((importedDocType.indexOf("PAR")== 0 || importedDocType.indexOf("SCR")== 0 || importedDocType.indexOf("Memo")== 0)
			&& (docTypeName.indexOf("PAR")== 0 || docTypeName.indexOf("SCR")== 0 || docTypeName.indexOf("Memo")== 0))
            {
				if(importedDocType.indexOf("PAR") == 0)
				{
					alert("PAR Document Already Added, Kindly delete and add the Document Again");
				}
				if(importedDocType.indexOf("SCR") == 0)
				{
					alert("SCR Document Already Added, Kindly delete and add the Document Again");
				}
			return false;
			}
        }
      }
	  }
	}
	//Added for RAKSIGN Process Import Document Prehook Validation - End
    return true;
}
function isDebug(strprocessname,stractivityName)
{
/*    if(strprocessname=='TestGen' && stractivityName=='Work Introduction1')
        {
            return true;
        }
*/
    return false;
}

function templateData(strProcessName, strActivityName, actionIndex, optAddMode) {
    /**
     * #Add custom comment while adding document through Generate Response
     * #Different comment for different DocType
     * var commentObj = '{"Doc1":"Doc1 by badmin", "Doc2":"Doc2 by user"}';
     * return '&<TemplateDocComment>&' + commentObj + '@10';
     * #Same comment for all DocType
     * var commentObj = 'Doc Added by badmin';
     * return '&<TemplateDocComment>&' + commentObj + '@10';
     */
    return "";
}

function isDisablePrintScreen(strProcessname, strActivityname)
{
    // return true to disable print screen
    return false;
}

function isNewVersionDoc(processName, activityName){ 
    
    return true;
}
function isOverWriteDoc(processName, activityName){
    
     return true;
}

function deleteDocFromComboList(docIndex)
{
    var objCombo = window.document.getElementById('wdesk:docCombo');
    var isFound= false;
     for(var i=0;i<objCombo.options.length;i++)
       {
        if(objCombo.options[i].value == docIndex)
         {
         objCombo.options[i]=null;
         isFound = true;
         break;
         }
       }
       
       if(isFound == false) {
           alert(NO_MATCHING_DOCUMENT);
       }
}
function isEnableDownloadPrint(strProcessname, strActivityname, strUsername)
{
    // If returned true will allow print and download option even to thos doc types which have no modified rights
    // By default do not display toolbar by making entry in ShowDefaulToolbarFlag=N
    return false;
}

function DocName(docname1){
	DOCRLOS=docname1;
}
function getdocTypeListExt(docListObj)
{
	//below function by saurabh for incoming doc new	
   var docWindowObj="";
   if(window.parent.strprocessname!=''){
	docWindowObj=window.parent;
	}
	else{
		docWindowObj=window.opener.parent;
	}
   //ended
	var pname=docWindowObj.strprocessname;
var docTypeList = new Array();
var count = -1;
	if (pname != 'PC' && pname != 'RAOP' && pname != 'CMS' && pname != 'CMP' && pname != 'CBP' && pname != 'ML' && pname != 'ACP' && pname != 'DAC' && pname != 'TF' && pname != 'DA')
	{
		// How to Capture Existing Doc List
		docTypeList[0]=window.opener.DOCRLOS;
   /* var tmpDocTypeList = docListObj;
    for(var i=0 ; i<tmpDocTypeList.length; i++)
    {
     alert("Doc Type = "+tmpDocTypeList.options[i].value);
    }
*/

// Return custom Doc List Array as below , It must be from existing above
	}
  /* docTypeList[++count] = "tabc";
   docTypeList[++count] = "txyz";
*/

return docTypeList;
}
function getdocTypeDefIndex(docListObj) {
    var index = -1;//default value of index --  for select option in the beginning
    /* Code snippet to iterate the list and compare with required value
    var tmpDocTypeList = docListObj;
        for(var i=0 ; i<tmpDocTypeList.length; i++)
        {
            if(tmpDocTypeList[i] == "tabc"){
                index=i;
                break;
            }
        }
    */
    return index;
}
function CustomCrop(strprocessname,stractivityName)
{
/* strprocessname : Process Name
 * stractivityName : Activity Name
 * return false will not open custom Crop Document Window
*/
return true;
}
function croppedByField(strprocessname,stractivityName){
    // return the name of variable
    return "";
}

function isDocOrgName(strprocessname, stractivityName)
{
/* strprocessname : Process Name
 * stractivityName : Activity Name
 * return false will not display 
   document's original name (document file's name) but the
   Doc Type only even if it is cofigured through webdesktop.ini to display its
   original name by entry (DocOrgName=Y)
*/  
 return true;
}

function isAnnotationToolbar(strProcessname,strActivityname )
{
   // if(strProcessname == 'AParentForm' && strActivityname == 'Standard Workdesk1')
   //     return false;
   // else
        return true;
}
function currentSelPageInImage(strPageInImage){
    
    //strPageInImage: contains current page no. of a Multi-page Tiff
    
}
function extractZoneModified(zoneType, x1, y1, x2, y2, createModifyFlag, zoneID, partitionInfo)
{
 /*
  *This method gets called when zone gets drawn or selected or modified
  */   
}

function customDownloadedDocName(docName, docOrgName, DocExt, pid, strProcessName, strActivityName) {
    var downloadedDocName="";
    /**
     * Return non-empty String to modify downloaded file name.
     * Note: Add the document extension after the document name with '.'
     * e.g: downloadedDocName = docName + "_" + pid + "." + DocExt;
     * 
     * docName -> Document type
     * docOrgName -> disk name of the document
     * DocExt -> document extension
     * pid -> processinstanceid
     * strProcessName -> Process Name
     * strActivityName -> Activity Name
     */

    return downloadedDocName;
}

function reloadNewAddedDoc(strprocessname,stractivityName)
{
   /*return
    *true  : it will reload the applet to show newly added doc
    *false : it will not reload the applet to show newly added doc
    **/
   return true;
}

function isUploadedDocType(filepath,docTypeName){
    /*var docJsonList=window.opener.getInterfaceData("D");
    var returnFlag=true;
    for(var i=0;i<docJsonList.length;i++){
        if(docJsonList[i].name.indexOf(docTypeName)>-1 && filepath.indexOf(docJsonList[i].DiskName)>-1){
            returnFlag=false;
            break;
        } 
    } 
    if(returnFlag==false){
        alert("document is already attached");
        return returnFlag;
    }*/
    
    //alert("docJsonList.name"+docJsonList[i].name);
    //alert("docJsonList.DiskName"+docJsonList[i].DiskName);

   return true; 
}

function modifyDocComment(processname,activityname,username,docTypeName){
    return "";
}
function wiLockForMeClick(){
     return true;
}
function wiReleaseClick(){
     return true;
}


function isDocumentAttached(){
    var docAttached = false;
    var objCombo = docWindow.document.getElementById('wdesk:docCombo');
    
    if(objCombo != null){
        if(objCombo.length > 0){
            if(objCombo.length == 1){
                if(objCombo.options[0].value == "-1"){
                    docAttached = false;
                } else {
                    docAttached = true;
                }
            } else {
                docAttached = true;
            }
        }
    }
    
    return docAttached;
}
function getWiFormValues()
{
    //Function returns attributes xml composing of queue variables values present in Custom Introduce form 
    var str = "";
    var valueArr = null;
    var val = "";
    var cmd = "";
    var fobj = frames['NewWIFRAME'].document.forms['wdesk']
    if(typeof fobj == 'undefined')
        return "";
    
    var formid=fobj.id;
    
    var strAttribXML="<Attributes>";
    if(formid=='wdesk'){
        for(var i = 0;i < fobj.elements.length;i++)
        {
            switch(fobj.elements[i].type)
            {
                case "textarea":
                case "text":
                    strAttribXML=strAttribXML+"<"+fobj.elements[i].name+">"+fobj.elements[i].value+"</"+fobj.elements[i].name+">";
                    break;
               /* case "select-one":
                    if(fobj.elements[i].selectedIndex!=-1)
                        strAttribXML=strAttribXML+"<"+fobj.elements[i].name+">"+fobj.elements[i].options[fobj.elements[i].selectedIndex].value+"</"+fobj.elements[i].name+">";
                    break; 
                case "checkbox":
                    if(fobj.elements[i].checked)
                    {
                        strAttribXML=strAttribXML+"<"+fobj.elements[i].name+">"+fobj.elements[i].value+"</"+fobj.elements[i].name+">";
                    
                    }
                    break;
                case "hidden": 
                      strAttribXML=strAttribXML+"<"+fobj.elements[i].name+">"+fobj.elements[i].value+"</"+fobj.elements[i].name+">";
                     break; */
            }
        }
    }
    strAttribXML=strAttribXML+"</Attributes>";
    return strAttribXML;
}

function customCloseMessage()
{
    //ALERT_CLOSE_SAVE_CONFIRM="Do you want to save the workitem before closiung the window?";
    return ALERT_CLOSE_SAVE_CONFIRM; 
}

function handleExcp(excpHandlerJson)
{
excpHandlerJson = customEventHandler(excpHandlerJson);
document.getElementById("excpJson").value = JSON.stringify(excpHandlerJson);
document.getElementById("btnEventHandler").click();   // For executing any custom code in java
} 
// this method is called when you call ValidatorException from java..u will get the parameters specified from java code in this js method.. 
function customEventHandler(excpHandlerJson)
{
    excpHandlerJson=JSON.parse(excpHandlerJson);
    var eventHandlerName = decode_utf8(excpHandlerJson.EventHandler); // 3rd parameter in from Customexceptionhandler constructor
    var params = JSON.parse(excpHandlerJson.Parameters) // 4th parameters which is hashmap in form of JSON 
    var firstParam = decode_utf8(excpHandlerJson.Summary); //1st parameter 
    var secondParam = decode_utf8(excpHandlerJson.Detail); //2nd parameter 
    var jsonParam = {};
    for( var key in params )
    {
        jsonParam[decode_utf8(key)] = decode_utf8(params[key]);
    }
    params = jsonParam;

// custom coding goes here 
	//	Bugzilla – Bug 64080 
    excpHandlerJson.EventHandler = eventHandlerName;
    excpHandlerJson.Summary = firstParam;
    excpHandlerJson.Detail = secondParam;
    excpHandlerJson.Parameters = params; 

return excpHandlerJson;
}
function deleteDocument(processName,activityName,userName,docIndex,docName){      //Bug 67762
    
    /* processName is name of the process
       activityName is name of the activity
       return false for disable the delete document
       userName is name of logged in user
       docIndex document index document(To be deleted)
       docName document name document(To be deleted)	   
       return false for disable the delete document
    */
    
    return true;
}

function CustomQuickSearchPrefix(prefix,selectedVar){//Bug 66126
    /*if(selectedVar != '0'){
    prefix="*"+prefix+"*";
    }*/
    return prefix;
}

function isDefaultDocumentType(processName,activityName){
    
    return "";
}


function modifyCropDocComment(strprocessname,stractivityName,strDocName,X1,Y1,X2,Y2,currentPageNo){
    /* 
     * This funcion is used to send the text for Comments in Crop Document Window..
     *
     * strprocessname  - Contains the Process  Name
     * stractivityName - Contains the Activity Name
     * strDocName      - conatins the Name of  currently selected Document in Workitem Window
     * X1: start x coordinate of selected dynamic zone(cropped Image). Coordinate will be according to image dimension.
     * Y1: start y coordinate of selected dynamic zone(cropped Image). Coordinate will be according to image dimension.
     * X2: End x coordinate of selected dynamic zone(cropped Image). Coordinate will be according to image dimension.
     * Y2: End y coordinate of selected dynamic zone(cropped Image). Coordinate will be according to image dimension.
     * currentPageNo: Current Page Number of document  
     *   */  
    return "";
}
function getCropDocTypeListExt(docListObj)
{
var docTypeList = new Array();
//var count = -1;

// How to Capture Existing Doc List

    /*var tmpDocTypeList = docListObj;
    for(i=0 ; i<tmpDocTypeList.length; i++)
    {
     alert("Doc Type = "+tmpDocTypeList.options[i].value);
    }
*/

// Return custom Doc List Array as below , It must be from existing above

//   docTypeList[++count] = "tabc";
//   docTypeList[++count] = "txyz";


return docTypeList;
}

function setTodoListValueHook(todoName,todoValue){
    /*
     *This functions is set the value in picklist TodoList.
     *todoName  - Name of Todo
     *todoValue - Value of todoList to be compared against.
     *
     *
     **/
    var window_workdesk="";
    if(windowProperty.winloc=="M")
        window_workdesk=window;
    else
        window_workdesk=window.opener;

    var winList=window_workdesk.windowList;
    var todoWindow = getWindowHandler(winList,"todoGrid");
    var todoId = 'wdesk:'+ todoName
    
    if(winList){
      var objCombo= todoWindow.document.getElementById(todoId);

      if(objCombo){
            for(var count=0;count<objCombo.length;count++)
            {
                if(objCombo[count].value == todoValue)
                {  
                    objCombo.selectedIndex = count; 
                    break;
                }
            }
      }
                
    }   
}
function disableNewBtnIfDocPresent(){
    /*
        return true : disable New Radio button if Document of this docType is present 
        return false: donot disable New Radio button if Document of this docType is present 
    */       
     return false;
    
}


function saveSubFormData(){
    document.getElementById("updateAttrXml").click();
}

function refreshNGFormFromSubForm(){
    window.opener.document.getElementById("cmdFormRefreshFromSub").click();
}

function updateParentForm(data){
    if( data.status == "success"){
        window.opener.document.getElementById("subformdata").value = document.getElementById("subformdata").value;
        window.close();
        refreshNGFormFromSubForm();
    }
}


function CreateIndicator(indicatorFrameId){
    var ParentDocWidth = document.body.clientWidth;
    var ParentDocHeight = document.body.clientHeight;
    if( ParentDocHeight == 0 ){
        if(document.getElementById("ngform")!= null){
             ParentDocHeight = document.getElementById("ngform").clientHeight
        }
    }
    var top = 0;
    var isSafari = navigator.userAgent.toLowerCase().indexOf('safari/') > -1;
    if(typeof window.chrome != 'undefined') {
        top = 0;
    } else if(isSafari){
        top = window.document.body.scrollTop;
    }
    
    var ImgTop=ParentDocHeight/2-10 + window.document.documentElement.scrollTop + top;
    var ImgLeft=ParentDocWidth/2-25;
 
    try {
        
        img = document.createElement("IMG");
        img.setAttribute("src", "/webdesktop/resources/images/progressimg.gif");//Bug 66459
        img.setAttribute("name", indicatorFrameId);
        img.setAttribute("id", indicatorFrameId);
        img.style.left = ImgLeft+"px";
        img.style.top = ImgTop+"px";
        img.style.width = "54px";//Bug 66459
        img.style.height = "55px";//Bug 66459
        img.style.position="absolute";
        img.style.zIndex = "9999";
        img.style.visibility="visible";
        //initPopUp();setPopupMask();
        document.body.appendChild(img);
    }
    catch(ex) {}
    document.body.style.cursor='wait';
}
 
function RemoveIndicator(indicatorFrameId){
    try {
        var img = document.getElementById(indicatorFrameId);
        document.body.removeChild(img);
       // hidePopupMask();
    }
    catch(ex) {
        //hidePopupMask();
    }
    document.body.style.cursor='auto';
}

function removeMasking(){
    try{
        setTimeout( function(){
            RemoveIndicator("temp");
            if(document.getElementById("fade")){
                document.getElementById("fade").style.display="none";
            }
        }
        , 10);    
    }catch(e){}
}
 

function documentPostHook(docIndex, eventType, docName, errorMessage)
{
    //eventType == 'checkin' || eventType == 'getdocument' || eventType == 'new' || eventType == 'newversion' || eventType == 'scan'
    //Here if docIndex>0, it means document has been imported successfully else failure has occured.
    //If success then docName consists of name of imported document and errorMessage will be blank.
    //If failure then errorMessage contains the error message and docIndex will be blank.
    //Bug 66587 - Kindly provide Post Hook For Scan and Import Document.
    var contentDiv = document.getElementById("contentDiv");	
    if(contentDiv != null){       
        initCustomEvents(contentDiv);        
    }     
	   
    var docviewer = document.getElementById("docviewer");	
    if(docviewer != null){
        $(docviewer.contentWindow.document).ready(function() {
            docviewer = document.getElementById("docviewer");
            initCustomEvents(docviewer.contentWindow);        
        });         
    }     
	   
    var docDiv = document.getElementById("docDiv");	
    if(docDiv != null){
        initCustomEvents(docDiv);        
    }
	
	//below function by saurabh for incoming doc new	
	   var docWindowObj="";
	   if(window.parent.strprocessname!=''){
		docWindowObj=window.parent;
		}
		else{
			docWindowObj=window.opener.parent;
		}
	   //ended
        var pname=docWindowObj.strprocessname;
    if(pname=='RLOS')
    {
        // ++ below code already present - 09-10-2017 for document index
        if(eventType=='new' || eventType=='scan')
        {
			//var rowNumber=docWindowObj.document.getElementById('ngformIframe').contentWindow.document.getElementById('RowNum').value;
            var docIndex_Id="IncomingDocNew_Docindex";
            var docName_Id="IncomingDocNew_DocName";
            var docStatus_Id="IncomingDocNew_Status";
            if(docIndex_Id!=''){
               docWindowObj.document.getElementById("ngformIframe").contentWindow.document.getElementById(docStatus_Id).value="Received";
            }    
            var docName=docWindowObj.document.getElementById("ngformIframe").contentWindow.document.getElementById(docName_Id).value;
            if(docName=='AECBconsentform')
            {
				docWindowObj.document.getElementById("ngformIframe").contentWindow.setNGValue('cmplx_Liability_New_AECBconsentAvail',true);
				docWindowObj.document.getElementById("ngformIframe").contentWindow.setEnabled('Liability_New_fetchLiabilities',true);
            }    
            docWindowObj.document.getElementById("ngformIframe").contentWindow.document.getElementById(docIndex_Id).value=docIndex;
        }        
    }
    //for pl process docindex setting 
     if(pname=='PersonalLoanS')
    {
        if(eventType=='new' || eventType=='scan')
        {
            /* var rowNum=docWindowObj.document.getElementById('ngformIframe').contentWindow.document.getElementById('Rownum').value;
            var doc_docIndex="IncomingDoc_Frame2_Reprow"+rowNum+"_Repcolumn11";
           
            docWindowObj.document.getElementById("ngformIframe").contentWindow.document.getElementById(doc_docIndex).value=docIndex;
			var docStatus_Id="IncomingDoc_Frame2_Reprow"+rowNum+"_Repcolumn3";
            if(docIndex!=''){
               docWindowObj.document.getElementById("ngformIframe").contentWindow.document.getElementById(docStatus_Id).value="Received";
            }  */
			
			//var rowNumber=docWindowObj.document.getElementById('ngformIframe').contentWindow.document.getElementById('RowNum').value;
            var docIndex_Id="IncomingDocNew_Docindex";
            var docName_Id="IncomingDocNew_DocName";
            var docStatus_Id="IncomingDocNew_Status";
            if(docIndex_Id!=''){
               docWindowObj.document.getElementById("ngformIframe").contentWindow.document.getElementById(docStatus_Id).value="Received";
            }    
            var docName=docWindowObj.document.getElementById("ngformIframe").contentWindow.document.getElementById(docName_Id).value;
            if(docName=='AECBconsentform')
            {
				docWindowObj.document.getElementById("ngformIframe").contentWindow.setNGValue('cmplx_Liability_New_AECBconsentAvail',true);
				docWindowObj.document.getElementById("ngformIframe").contentWindow.setEnabled('Liability_New_fetchLiabilities',true);
            }    
            docWindowObj.document.getElementById("ngformIframe").contentWindow.document.getElementById(docIndex_Id).value=docIndex;
           
        }            
    }
    if(pname=='CreditCard' || pname=='DigitalOnBoarding')
    {
        if(eventType=='new' || eventType=='scan')
        {
            /* var rowNum=docWindowObj.document.getElementById('ngformIframe').contentWindow.document.getElementById('Rownum').value;
            var doc_docIndex="IncomingDocument_Frame_Reprow"+rowNum+"_Repcolumn11";
			var docName_Id="IncomingDocument_Frame_Reprow"+rowNum+"_Repcolumn0";
            var docStatus_Id="IncomingDocument_Frame_Reprow"+rowNum+"_Repcolumn3";
            if(docIndex!=''){
               docWindowObj.document.getElementById("ngformIframe").contentWindow.document.getElementById(docStatus_Id).value="Received";
            }    
            document.getElementById("ngformIframe").contentWindow.document.getElementById(doc_docIndex).value=docIndex; */
			
			//var rowNumber=docWindowObj.document.getElementById('ngformIframe').contentWindow.document.getElementById('RowNum').value;
            var docIndex_Id="IncomingDocNew_Docindex";
            var docName_Id="IncomingDocNew_DocName";
            var docStatus_Id="IncomingDocNew_Status";
            if(docIndex_Id!=''){
               docWindowObj.document.getElementById("ngformIframe").contentWindow.document.getElementById(docStatus_Id).value="Received";
            }    
            var docName=docWindowObj.document.getElementById("ngformIframe").contentWindow.document.getElementById(docName_Id).value;
            if(docName=='AECBconsentform')
            {
				docWindowObj.document.getElementById("ngformIframe").contentWindow.setNGValue('cmplx_Liability_New_AECBconsentAvail',true);
				docWindowObj.document.getElementById("ngformIframe").contentWindow.setEnabled('Liability_New_fetchLiabilities',true);
            }    
            docWindowObj.document.getElementById("ngformIframe").contentWindow.document.getElementById(docIndex_Id).value=docIndex;
        }            
    }
    //for cc process docindex setting 
    return true;
}

function isOpenWI(strSelQueueName,strFrom,processName,activityName, workitemId, InstanceName){
  
    /*
         strSelQueueName: selected QueueName (in case of search it is blank)
         strFrom        : W or F or S
         W              : Workitem list form any queue
         F              : Workitem list form Filter
         S              : Workitem list form Search
         processName    : Process Name
         activityName   : Activity name
         workitemId     : Workitem ID
         InstanceName   : Registration No 
    */
    return   true;
}


function LaunchAppOnWIClick(pid,wid,activityName){
	
    /*if(activityName=='Verification')
    {
	  
        var divBView = document.getElementById('BView');
        if(divBView == null){
            divBView = document.createElement("div");
            divBView.style.display = "none";
            divBView.id = "BView";
            divBView.name = "BView";
            document.getElementById("mainbody").appendChild(divBView);    
        }    
    
        // Name of application to be launched.
        // var appName = "C:\\Program Files\\OmniExtract 6.1\\OmniExtract Common\\DataVerify.exe";
        // Arguments to be passed to the application.
        var appArgs = pid+"~"+sessionId+"~"+strUserName;
	
        //var serverRef = window.top.location.href;   
        //var serverPath = serverRef.substring(0, serverRef.indexOf(sContextPath));    
    
        try{	
            StartSessionActiveTimer();	
            document.getElementById('BView').innerHTML = '<OBJECT ID="AppLauncherProject.AppLauncher" WIDTH="1" name="AppLauncher" HEIGHT="1"  CLASSID="CLSID:A40626AB-E946-49B6-8E21-4D3B8DC71765"></object>';   
            document.AppLauncher.LaunchApplication(decode_utf8(appArgs));
            return true;
        }
        catch(e)
        {
            return false;
        }
    }*/
    return false;
}

function customSearchValidation(value){
    var returnFlag=true;
    /* var invalidChar=['-','>','<','\'','"'];    
    for(var i=0;i<invalidChar.length;i++){
        if(value.indexOf(invalidChar[i])>-1){
            returnFlag= false;
            break;
        }
    }*/
    return returnFlag;
}

function refreshDMSSearch(processName,activityName){
    // Call the fuction which is getting called after document import
}

function modifyDocName(processname,strDocName,from,activityname,username){
    var customName="";
    if(from == 'crop_document' && typeof nameUploadDocument != 'undefined') {
        return nameUploadDocument(strDocName,from,processname, activityname,username);
    }

    /*Assign value in custmName variable here*/

    if(customName != "")
        return customName;
    else
        return strDocName;
}

function raiseClick(){
    /*
        Custom function to enable exception raising conditionally.
    */       
     return true;
}

function getWaterMarkText(strprocessname,stractivityName,pid,userName){
    var strWaterMarkText="";
    /* 
     * This funcion is used to send the text for WaterMark printing that will be  displayed in the downloaded document.
     * 
     * 
     * strprocessname  - Contains the Process  Name
     * stractivityName - Contains the Activity Name
     * pid             - conatins the currently opened Workitem Number
     * 
     * If returned "" - it will not display any waterMark text on the downloaded document
     * else
     * (for example)return "Mytext" : then "Mytext" will be displayed as waterMark text on the downloaded document
     * 
     * TextSettings for WaterMarkText can be set  using "WaterMarkTextSettings" flag in webdesktop.ini
     * */
    if(typeof docCreationDateTime != "undefined") 
    strWaterMarkText =  docCreationDateTime;  
        
    return strWaterMarkText;
}


function checkOutDocHook(docIndex,docName){//Bug 66696
    return true;
}


function checkInDocHook(docIndex,docName){//Bug 66696
    return true;
}

function linkWiPreHook(linkWiDataXml) {     //Bug 62856
    return true;
}

function delinkWiPreHook(linkWiDataXml) {    //Bug 62856
    return true;
}
//Bug 68022 starts
function disableCaseDone(){
    return false;
}
function disableCaseReassign(){
    return false;
}
function disableCasePriority(){
    return false;
}
function disableCaseSetReminder(){
    return false;
}
function disableTaskDone(){
    return false;
}
function disableTaskPriority(){
    return false;
}
function disableTaskSetReminder(){
    return false;
}
 //Bug 68022 ends
 function  saveExcpPostHook(calledFrom){ //Bug 68117
    //alert(" calledFrom "+calledFrom)
    //if(calledFrom=='Raise' || calledFrom=='Modify' || calledFrom=='Reject'|| calledFrom=='Respond'|| calledFrom=='Undo'|| calledFrom=='Commit'|| calledFrom=='Clear'){
     //do something   
    //}
  return true;  
}
//Bug 67103 starts
function isTiffConversionRequired(strProcessName, strActivityName, selDocType) {
    /**
      *Return true from this function for the document types for which tiff conversion is required while cropping.
      *Returning true from this function will convert the cropped image in tiff && BW that will reduce the cropped image size.
      *Otherwise the cropped image format will be jpg and the image quality will remain unchanged.
      *Return true is recommended only for images that contains text(e.g: signature)
     **/
    return false;
}

function initKeyEvent(){
    /*if (typeof window.event != 'undefined'){ 
        // IE        
        document.onkeydown = function(event) {
            var t=event.srcElement.type;
            var kc=event.keyCode;      
          
            if(event.keyCode==68 && event.ctrlKey){                    
                // Ctr+D
                openDocList();
            }        
        }
    } else {        
        // FireFox/Others
        document.onkeypress = function(e) {     
            var t = e.target.type;
            var kc = e.keyCode;      
            
            if(e.which==100 && e.ctrlKey) {
                // Ctr+D
                openDocList();
            } else {
                if(e.stopPropogation){
                    e.stopPropogation(true);
                }
                if(e.preventDefault){
                    e.preventDefault(true);
                }
                e.cancelBubble = true;
                return false;
            }     
        }
    }*/
    initCustomEvents(document);	
}

//Bug 68517
function wordeskWindowTitle(strprocessname, stractivityName, strQueueName, WDeskWinTitle) {
    // return the wdeskWinTitleCustom to replace the Queue name instead of Activity Name
//    var wdeskWinTitleCustom = "";
//	var t1 = WDeskWinTitle.substring(WDeskWinTitle.indexOf(":")+2,WDeskWinTitle.length);
//    if (strQueueName == '' || strQueueName == "undefined" )
//		{
//		wdeskWinTitleCustom = WDeskWinTitle; 
//		}
//	
//	else
//	{
//    wdeskWinTitleCustom = t1 + " : " + strQueueName ;
//	}
//    return wdeskWinTitleCustom;
        return "";
}
 //Bug 68517
 
 function IsCompleteWorkItem(queueName){
    return true;
}

function enableZonePartition(strprocessname, stractivityName){
    //opall_toolkit.setFormExtractionMode(true);
    return true;
}
function customFormValidation(){
    return true;
}
function customLinkWIHeader() {
    //sample code to receive ProcessInstanceId of selected workitem
    /*
    var ctrlTableId="wlf:pnlResult";
    var checkboxId="wlf:cb_";
    var ctrlTable=document.getElementById(ctrlTableId);
    var pid="";
    var strSelectedIndex="";
    if(ctrlTable!=null)
    {

        var rowCount = ctrlTable.tBodies[0].rows.length;
        if(rowCount>0) {
            for(var iCount = 0; iCount < rowCount-1;iCount++)
            {
            
                var wiClicked=document.getElementById(checkboxId+iCount);
                if(wiClicked.checked){
                    if(strSelectedIndex.length==0){
                        strSelectedIndex=strSelectedIndex+iCount;
                    }else{
                        strSelectedIndex=strSelectedIndex+","+iCount;
                    }
                    var jsonOutput=document.getElementById("wlf:hjn"+(iCount+1)).innerHTML;
                    //jsonOutput= eval("("+jsonOutput+")");
                    jsonOutput = jsonOutput.split(SEPERATOR1);
                    var arrobjJsonOutput= jsonOutput;
                    //for(var i=0;i<arrobjJsonOutput.length;i++){
                      //  var outputJson=arrobjJsonOutput[i];
                      //  var objJson=outputJson.Output;
                        //if(objJson.Name=='ProcessInstanceID'){
                            pid =encode_utf8(arrobjJsonOutput[3]);
                        //}
                    //}
                }
            }
        }
    }*/
    return true;
}
function getdocTypeDefIndex(docListObj) {
    var index = -1;//default value of index --  for select option in the beginning
    /* Code snippet to iterate the list and compare with required value
    var tmpDocTypeList = docListObj;
        for(var i=0 ; i<tmpDocTypeList.length; i++)
        {
            if(tmpDocTypeList[i] == "tabc"){
                index=i;
                break;
            }
        }
    */
    return index;
}
function interfacePostHook(interfaceType) {
    /* interfaceType doc for "Document", interfaceType form for "form", interfaceType exp for "exception", interfaceType todo for "Todo" 
       strProcessname :   Name of the Current Process
       strActivityname:   Name of the Current Activity
    */
  
    if(interfaceType == "doc") {
        //code snippet to hide or show addDoc as per workstep (activity Id)
        /*
        if(stractivityId=='6') {
            document.getElementById('wdesk:addDoc').style.display = "none";
            document.getElementById('wdesk:addDoc_nodoc').style.display = "none";
        }*/
        initCustomEvents(document);
		
        var contentDiv = document.getElementById("contentDiv");	
        if(contentDiv != null){       
            initCustomEvents(contentDiv);        
        }           
		   
        var docviewer = document.getElementById("docviewer");	
        if(docviewer != null){                                
            $(docviewer.contentWindow.document).ready(function() {
                docviewer = document.getElementById("docviewer");
                initCustomEvents(docviewer.contentWindow);        
            }); 
        }
		   
        var docDiv = document.getElementById("docDiv");	
        if(docDiv != null){
            initCustomEvents(docDiv);        
        }  
    } else if(interfaceType == "form") {        
        var ngformIframe = document.getElementById("ngformIframe");	       	   
        if(ngformIframe != null){
            $(ngformIframe.contentWindow.document).ready(function() {
                initCustomEvents(ngformIframe.contentWindow); 
            });                                     
        }
    } else if(interfaceType == "exp") {
        initCustomEvents(document); 
    } else if(interfaceType == "todo") {
        initCustomEvents(document); 
    }
}

function deleteDocPostHandler(docIndex,strprocessname,stractivityName,docName) {
    //This is the handler called after deleting a document, here docIndex is being passed where docIndex= -1 represents Error.
}

function DualMonitorWidth() {
    //In this function you need to specify the width of workitem window when it is opened. If it is required to open in half following can be used.
    winWidth = "";
    /*
     winWidth = 2*(window.screen.availWidth-10.01);
    */ 
    return winWidth;
} 

function setDefaultProcessonQuickSearch(){
    // set the proocess name which to make default 
    var processName = "";
    
    return processName;
}

function showPickList(textBoxId, selVarName, selVarType, selProcessName, selActivityName, selQueueName, selProcessId, selActivityId, selQueueId) {
    /*
     * Write custom code in this function to show picklist for data fields on advance search window.
     * This function is called on click of the picklist button provided next to each data field.
     * By default picklist button is not displayed, to display picklist button next to each data field make/update the entry ShowPickListButton=Y in webdesktop.ini
     * 
     * textBoxId -> Id of the text box in which selected value of the picklist to be set
     * selVarName -> Name of the data field
     * selVarType -> Type of the data field
     * selProcessName -> Selected process name
     * selActivityName -> Selected workstep name
     * selQueueName -> Selected queue name
     * selProcessId -> Selected process id
     * selActivityId -> Selected workstep id
     * selQueueId -> Selected queue id
     */
    
    /* Getting textbox value    ->  document.getElementById(textBoxId).value
       Getting variable Name    ->  document.getElementById(selVarName).innerHTML
       Getting variable type    ->  document.getElementById(selVarType).value   
    */
}
function postSaveFormHook(status,statusCode, response) {
    // This function will get called after save form on workitem 
    // status: success or failure
    // status code :200 - success, :598,599 : failure
    
    //alert("status:" +status +" statusCode: "+statusCode)
    
    
} 
function preHandleOptionsHook(queueId,queueName,processDefId,oper)
{
// In this function , you can enable disable options like New, Done before loading workitemlist
// parameters queueId, queueName
//oper =1 - on queueclick, 2- set filter, 3- Advanced search, 4- on quick search, 
   // console.log("queueId"+queueId+"queueName"+queueName+"processDefId"+processDefId+"processName"+processName+"oper"+oper)
    
    // sample code snippet for New, Similarly for Done id= wlf:disNewDone,wlf:NewDone
     /* if(queueId=='188'){
        if(document.getElementById("wlf:disNewShow")){
            document.getElementById("wlf:disNewShow").style.display="none";
            document.getElementById("wlf:disNewShow").parentNode.nextElementSibling.children[0].style.display="none";
        }
         if(document.getElementById("wlf:NewShow")){
            document.getElementById("wlf:NewShow").style.display="none";
            document.getElementById("wlf:disNewShow").parentNode.nextElementSibling.children[0].style.display="none";
        }
    }*/ 
   // Custom Change Start
  /*  if(queueName=='TT_CSO_initiate' || queueName=='TT_Outward TT Initiation')
	{
        if(document.getElementById("wlf:disNewShow"))
		{
            document.getElementById("wlf:disNewShow").style.display="none";
            document.getElementById("wlf:disNewShow").parentNode.nextElementSibling.children[0].style.display="none";
        }
        if(document.getElementById("wlf:NewShow"))
		{
            document.getElementById("wlf:NewShow").style.display="none";
            document.getElementById("wlf:disNewShow").parentNode.nextElementSibling.children[0].style.display="none";
        }
    }   */
	// Custom Change End	
}

function DeleteWIClick()
{
    return true;
}

function isPdftoolbarenable(strprocessname, stractivityName) {
    /*
     strprocessname    : Process Name
     stractivityName   : Activity Name
     
     return true if you want to enable toolbar on non image pdf document
     */

    return false;
}

function isAllowPrint(strprocessname, stractivityName, selDocType) {
    return true;
}

function isAllowDownload(strprocessname, stractivityName, selDocType) {
    return true;
}
function disableTaskDecline(){
    return false;
}
function disableTaskReassign(){
    return false;
}
function conversationPostHook(flag){    
    //alert(flag)
}
function introduceNDonePostHook(event,option){   
    /*
     * 
     strprocessname    : Process Name
     stractivityName   : Activity Name
     pid               : Process Instance Id
     wid               : Workitem Id
    */
    /* 
        var alertMsg="Workitem "+pid+" has been completed";
        if(event=='closeWI' && (option=='INTRODUCE' || option=='DONE')){
            alert(alertMsg);
        }    
    */
}
function hideConversation(docRef){  
    /*
        if(strprocessname=='appletform'){     
            docRef.getElementById('textForm:LblAddAsNew').style.display='none';
            docRef.getElementById('textForm:ChkAddAsNew').style.display='none';
          return true;
        } 
    */
    return false;
}

//Script to disable drag and drop on workitem window
window.addEventListener("dragover",function(e){
    e = e || event;
    e.preventDefault();
},false);

window.addEventListener("drop",function(e){
    e = e || event;
    e.preventDefault();
},false);
function isChromeOfficeViewer() {
    return false;
}

//function to disable drag and drop on workitem window
function initCustomEvents(element){
    element = (typeof element == "undefined")? null: element;
	   
    if(element == null) {
        element = document;
    }
	   
    element.addEventListener("dragover",function(e){
        e = e || event;
        cancelBubble(e);
    },false);
	 
    element.addEventListener("drop",function(e){
        e = e || event;
        cancelBubble(e); 
    },false);
}

function refreshParentFormData(data){
    if(data.status == "success"){
        if(window.subFormCloseHook){
            subFormCloseHook();
        }
    }
    
}
function documentListWinHook(strprocessname,stractivityName,strqueuename,strqueueID) {
    return true;
}

function hideAnnotationForWorkstep(strprocessname,stractivityName,strQueueName){
    return true;
}
function openSingleWorkitem(pdefId){
    
    //please return true to restrict opening of  same process WI in new window if WI of that process is already opened
    
    return false;
}

function WDReassignClick(){
    return true;
}

function versionListWinHook(processInstanceId,DocumentId,DocumentType) {
    return true;
}

function isCustomWorkitem(PrcDefId, queueId, queueType, queueName){
    var customNewWI = false;
	//change for SRM by stutee.mishra strat
	if(queueName == 'SRM_PBO' || queueName == 'EPP_PBO_Introduction')
	{
		customNewWI = true;
	}
	//change for SRM by stutee.mishra end
    return customNewWI;
}

//change for SRM by stutee.mishra strat
function showCustomClose() {
    return true;
}
function showCustomIntroduce() {
     return true;
}
//change for SRM by stutee.mishra end

function getFormType(PrcDefId,queueId,queueType){//queueId = 406
    // 1 CustomForm
   //  2 IForm
     return "2";
}

function customReassign(wiInfo,strprocessname,stractivityName) {
    return false;
}

function validateOnInroduceClick()
{
	var customform='';
	var formWindow=getWindowHandler(windowList,"formGrid");
	customform=formWindow.frames['customform'];
	var iframe = customform.document.getElementById("frmData");
	
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	var SubCategoryID=iframeDocument.getElementById("SubCategoryID").value;
	var CategoryID=iframeDocument.getElementById("CategoryID").value;
	
	if(CategoryID=='1' && (SubCategoryID=='3' || SubCategoryID=='2' || SubCategoryID=='4' || SubCategoryID=='5'))
	{
		var ProcessInstanceId=customform.document.getElementById("wdesk:WI_NAME").value;
		var isIntegrationCallSuccess = FireIntegrationCall(true,"custom",customform,ProcessInstanceId);
	
		if(isIntegrationCallSuccess=="false")
			return false;
						
		isIntegrationCallSuccess = isIntegrationCallSuccess.split("$$");
		
		if(isIntegrationCallSuccess.length==2)
		{
			
			if(isIntegrationCallSuccess[0]=="false" && isIntegrationCallSuccess[1]=="false") 
			{
				return false;
			}
						
			var isSaveSuccess = saveSRMData(true,"custom",customform);
			
			if(!isSaveSuccess)
			{
				return false;
			}
							
			alert(isIntegrationCallSuccess[1]);
			
			hideProcessingCustom();
			return true;			
		}
		else
		{
			alert("Some error occured while introducing the case.");
			hideProcessingCustom();
			return false;
		}
	}
	else
		return true;
}

function saveSRMData(IsDoneClicked,donefrm,fobj)
{
	var processName = "SRM"
	var customform='';
	var IsError='N';
	var WS_LogicalName;
	var tr_table;
	
	if(donefrm=='custom')
	{	
		customform=fobj;	
	}
	else
	{
		var formWindow=getWindowHandler(windowList,"formGrid");
		customform=formWindow.frames['customform'];
	}
	
	var iframe = customform.document.getElementById("frmData");
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	var CategoryID=customform.document.getElementById("CategoryID").value;
	var SubCategoryID=customform.document.getElementById("SubCategoryID").value;
	var IsSaved = customform.document.getElementById("savedFlagFromDB").value;
	var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
	var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
	var TEMPWINAME=customform.document.getElementById("wdesk:TEMP_WI_NAME").value;
	var PANno=iframeDocument.getElementById("PANno").value;
	
	WIDATA=computeWIDATA(iframe,SubCategoryID,WSNAME,IsDoneClicked,CategoryID,fobj);


	if(!(CategoryID=='1' && SubCategoryID=='1') && customform.document.getElementById("wdesk:IntegrationStatus").value!='false')//changed by Amandeep
	{
		WINAME="";
	}
	var inputs = iframeDocument.getElementsByTagName("input");
	
		for (x=0;x<inputs.length;x++)
		{	
			myname = inputs[x].getAttribute("id");
			if(myname==null)
				continue;
					
			if(myname.indexOf("tr_")==0)
			{
				tr_table = iframeDocument.getElementById(myname).value;
			}
			else if(myname.indexOf("WS_LogicalName")==0)
			{
				WS_LogicalName = iframeDocument.getElementById(myname).value;
			}
			
		}
				
	var xhr;
	
	if(window.XMLHttpRequest)
		xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	IsError=iframeDocument.getElementById(SubCategoryID+"_IsError").value;	 

	if(IsDoneClicked)
	{
		var getMandatoryDocs = iframeDocument.getElementById("mandatoryDocs").value;
		if(getMandatoryDocs!="")
			if(!DocTypeAttached(getMandatoryDocs,true))
				return false;
	}

	var url="";
	var param="";
	if(processName=='SRM'||processName=='New_SRM')
	{
		if(CategoryID=="1" && ( WSNAME!="PBO" ||( WSNAME=="PBO" && IsSaved=="Y" )))
		{
			//
		}
		var abc=Math.random
		
		url ="/webdesktop/CustomForms/SRM_Specific/SRM.jsp";
		
		var Category=customform.document.getElementById("Category").value;
		var SubCategory=customform.document.getElementById("SubCategory").value;
		param="WINAME="+WINAME+"&tr_table="+tr_table+"&WSNAME="+WSNAME+"&WS_LogicalName="+WS_LogicalName+"&CategoryID="+CategoryID+"&SubCategoryID="+SubCategoryID+"&IsDoneClicked="+IsDoneClicked+"&IsError="+IsError+"&IsSaved="+IsSaved+"&WIDATA="+WIDATA+"&PANno="+PANno+"&abc="+abc+"&TEMPWINAME="+TEMPWINAME+"&decisionsaved="+decisionsaved+"&exceptionstring="+exceptionstring+"&Category="+Category+"&SubCategory="+SubCategory;
	
	} 	

	
	url=replaceUrlChars(url);
	param=replaceUrlChars(param);
	//alert(param);
	xhr.open("POST",url,false); 
	xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200 && xhr.readyState == 4)
	{
		//ajaxResult=Trim(xhr.responseText);
		ajaxResult=myTrim(xhr.responseText);
		arrAjaxResult = ajaxResult.split("~");
		ajaxResultFinal= arrAjaxResult[0];

		if(ajaxResultFinal == '15')
		{
			alert("There is some error at database end.");
			return false;
		}
		else if(ajaxResultFinal == '11')
		{
			alert("User session expired. Please re-login.");
			return false;
		}
		else if(ajaxResultFinal != '0')
		{
			//alert(ajaxResultFinal+"hello");
			alert("There is some problem at server end with error code as "+ajaxResultFinal+". Please contact administrator!");
			return false;
		}
	}
	else
	{
		alert("Problem in saving data.");
		return false;
	}
	return true;
}

function SRMSAVEDATA(IsDoneClicked,donefrm,fobj)
{
	var customform='';
	if(donefrm=='custom'){	
		customform=fobj;
	}
	else{
	var formWindow=getWindowHandler(windowList,"formGrid");
	customform=formWindow.frames['customform'];
	}
	var tr_table;
	var WIDATA="";
	var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
	var TEMPWINAME=customform.document.getElementById("wdesk:TEMP_WI_NAME").value;
	
	if(customform.document.getElementById("wdesk:IsRejected")!=null && typeof customform.document.getElementById("wdesk:IsRejected")!="undefined" && customform.document.getElementById("wdesk:IsRejected").value!=null && customform.document.getElementById("wdesk:IsRejected").value=="Y")
	{
		if(IsDoneClicked )//need to check this function location
		{
			var rejectionUrl="/webdesktop/CustomForms/SRM_Specific/SRM.jsp?WIDATA=&PANno=&WINAME="+WINAME+"&TEMPWINAME="+TEMPWINAME+"&tr_table=USR_0_SRM_DiscardedWI&WSNAME=PBO&WS_LogicalName=PBO&CategoryID=0&SubCategoryID=0&IsDoneClicked=Y&IsError=Y&IsSaved=Y";
				
				rejectionUrl=replaceUrlChars(rejectionUrl);
				
				var xhr;
				if(window.XMLHttpRequest)
					 xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
					xhr=new ActiveXObject("Microsoft.XMLHTTP");
				
				 xhr.open("GET",rejectionUrl,false); 
				 xhr.send(null);
				if (xhr.status == 200 && xhr.readyState == 4)
				{
					
					ajaxResult=Trim(xhr.responseText);
					arrAjaxResult = ajaxResult.split("~");
					ajaxResultFinal = arrAjaxResult[0];
					
					if(ajaxResultFinal == '15')
					{
						alert("There is some error at database end.");
						return false;
					}
					else if(ajaxResultFinal == '11')
					{
						alert("User session expired. Please re-login.");

						return false;
					}
					else if(ajaxResultFinal != '0')
					{
						alert("There is some problem at server end. Please contact administrator.");

						return false;
					}
					
				}
				else
				{
					alert("Problem in discarding workitem.");
					return false;
				}
				return true;
			
		}
	}
	var SubCategoryID=customform.document.getElementById("SubCategoryID").value;
	var CategoryID=customform.document.getElementById("CategoryID").value;
	var d_PANno=customform.document.getElementById("d_PANno").value;
	var IsError="N";
	var Category=customform.document.getElementById("Category").value;
	var SubCategory=customform.document.getElementById("SubCategory").value;
	var Channel=customform.document.getElementById("Channel").value;
	customform.document.getElementById("wdesk:Category").value=customform.document.getElementById("Category").value;
	customform.document.getElementById("wdesk:SubCategory").value=customform.document.getElementById("SubCategory").value;
	customform.document.getElementById("wdesk:Channel").value=customform.document.getElementById("Channel").value;
	if(Category=='--Select--')
	{
		alert("Please select Category.");
		customform.document.getElementById("Category").focus();
		return false;
	}
	if(SubCategory=='--Select--')
	{
		alert("Please select Sub Category.");
		customform.document.getElementById("SubCategory").focus();
		return false;
	}
	if(Channel=='--Select--')
	{
		alert("Please select Channel.");
		customform.document.getElementById("Channel").focus();
		return false;
	}
	if(d_PANno=='')
	{
		alert("Please enter Card No.");//Changed by Amandeep
		customform.document.getElementById("d_PANno").focus();
		return false;
	}
	var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
	var IsSaved = customform.document.getElementById("savedFlagFromDB").value;
	var iframe = customform.document.getElementById("frmData");
	var saveNreject=false;
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	if(iframeDocument.getElementById("PANno")==null)
	{
		alert("Please fetch data.");
		return false;
	}
	var PANno=iframeDocument.getElementById("PANno").value;
	var NameData="";
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
	var store="";
	var arrGridBundle="";
	var singleGridBundle="";
	try{
		for (x=0;x<inputs.length;x++)
		{	
			myname = inputs[x].getAttribute("id");
			if(myname==null)
				continue;
			if(!(myname.indexOf("_gridbundle_clubbed")==-1))
			{
					singleGridBundle = iframeDocument.getElementById(myname).value;
					if(arrGridBundle=="")
					arrGridBundle=singleGridBundle;
					else
					arrGridBundle+= "$$$$"+singleGridBundle;			
			}
			
			if(myname.indexOf(SubCategoryID+"_")==0)
			{
				if((inputs[x].type=='radio')) 
				{	
					eleName = inputs[x].getAttribute("name");
					//alert("eleName:"+eleName);
					if(store!=eleName)
					{
						store=eleName;
						var ele = iframeDocument.getElementsByName(eleName);
						for(var i = 0; i < ele.length; i++)
						{
							
							eleName2=ele[i].id;
							//alert("eleName2:"+eleName2);
							
							eleName2+="#radio";
							//alert("eleName2:::"+eleName2);
							NameData+=eleName+"#"+eleName2+"~";
							//alert("NameData:"+NameData);
						}	
					}
				}
				else if(inputs[x].type=='checkbox')
				{	
					eleName3 = inputs[x].getAttribute("name");
					eleName3+="#checkbox";
					NameData+=myname+"#"+eleName3+"~";		
				}
				else if(!(inputs[x].type=='radio'))
				{	
					eleName2 = inputs[x].getAttribute("name");
					eleName2+="#";
					NameData+=myname+"#"+eleName2+"~";		
				}
			
			}
			//Added by Aishwarya 14thApril2014
			else if(myname.indexOf("tr_")==0)
			{
				tr_table = iframeDocument.getElementById(myname).value;
			}
			else if(myname.indexOf("WS_LogicalName")==0)
			{
				WS_LogicalName = iframeDocument.getElementById(myname).value;
			}
		
		}
	}catch(err){return "exception";}
	try
	{
		for (x=0;x<selects.length;x++)
		{
			eleName2 = selects[x].getAttribute("name");
			if(eleName2==null)
				continue;
			eleName2+="#select";
			myname = selects[x].getAttribute("id");
			if(myname==null)
				continue;
			var e = iframeDocument.getElementById(myname);
			if(e.selectedIndex!=-1)
			{
				var Value = e.options[e.selectedIndex].value;
				if(myname.indexOf(SubCategoryID+"_")==0)
				{
					NameData+=myname+"#"+eleName2+"~";
				}
			}
		
		}
	}catch(err){return "exception";}
	try
	{
		for (x=0;x<textareas.length;x++)
		{
			myname = textareas[x].getAttribute("id");
			if(myname==null)
				continue;
			if(myname.indexOf(SubCategoryID+"_")==0)
			{
				eleName2 = textareas[x].getAttribute("name");
				eleName2+="#";
				NameData+=myname+"#"+eleName2+"~";	
			}
		
		}
	}catch(err){return "exception";}
	
	if(SubCategoryID=='3'&&CategoryID=='1') //for BOC
	{		
		
		if(WSNAME=='Introduction' || WSNAME=='PBO') 
		{
			
			var strJson = iframeDocument.getElementById('Card Blocking Details_3_gridbundleJSON_WIDATA').value;

			var obj = JSON.parse(strJson);
			var tempBlockRequested='false';
			for(var key in obj)
			{
				var attrName = key;
				var attrValue = obj[key];
				
				if(attrName=="type_of_block")
				{
					if(attrValue.indexOf("Temporary")!=-1)
					{
						tempBlockRequested='true';
					}
				}
			}	
		}
	}
		
	{	
		var valid = true;
		
		
		if(arrGridBundle!='')
		{
			 valid= ValidateGrid(iframeDocument,arrGridBundle,IsDoneClicked) ;//check this function location
		}
		if(valid)
		{
				
			if(CategoryID==1  && WSNAME=="PBO" && customform.document.getElementById("wdesk:IntegrationStatus").value!='false')
			{
				iframeDocument.getElementById(SubCategoryID+"_Cardno_Masked").value=iframeDocument.getElementById("CardNo_Masked").value;
			}
			
			if(CategoryID==1 && SubCategoryID==2)
			{
				if(IsDoneClicked && WSNAME=="PBO" )
				{
					var selJSONGridWIData = iframeDocument.getElementById("BALANCE TRANSFER DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
					

					
					var obj = JSON.parse(selJSONGridWIData);
					var CardNumber = "";
					CardNumber = obj['rakbank_eligible_card_no'];
					if(CardNumber=='' || CardNumber==' '){
						CardNumber = "";
					}else{
						CardNumber = CardNumber.replace("@"," @ ");
					}
					var arrCardNumber = CardNumber.split("@");	
					
					var Remarks = obj["remarks"];
					Remarks  = Remarks.replace("@"," @ ");
					var arrRemarks = Remarks.split("@");
										
					var noOfElements = arrCardNumber.length;
					if(CardNumber=='$-$'){
						alert("No card selected. Please select a card to process!"); // PG012
						return false;
					}
				}	
			}			
				
			if(CategoryID==1 && SubCategoryID==4)
			{
				if(IsDoneClicked && WSNAME=="PBO" )
				{
					var selJSONGridWIData = iframeDocument.getElementById("CREDIT CARD CHEQUE DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
					var obj = JSON.parse(selJSONGridWIData);
					var CardNumber = "";
					CardNumber = obj['rakbank_eligible_card_no'];
					if(CardNumber=='' || CardNumber==' '){
						CardNumber = "";
					}else{
						CardNumber = CardNumber.replace("@"," @ ");
					}
					var arrCardNumber = CardNumber.split("@");		
					
					var Remarks = obj["remarks"];
					Remarks  = Remarks.replace("@"," @ ");
					var arrRemarks = Remarks.split("@");

					var noOfElements = arrCardNumber.length;
					
					if(CardNumber=='$-$'){
						alert("No card selected. Please select a card to process."); // PG012
						return false;
					}
				}
			}
			
			if(CategoryID==1 && SubCategoryID==5)
			{
				if(IsDoneClicked && WSNAME=="PBO" )
				{
					var selJSONGridWIData = iframeDocument.getElementById("SMART CASH DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
					var obj = JSON.parse(selJSONGridWIData);
					var CardNumber = "";
					CardNumber = obj['rakbank_eligible_card_no'];
					if(CardNumber=='' || CardNumber==' '){
						CardNumber = "";
					}else{
						CardNumber = CardNumber.replace("@"," @ ");
					}
					var arrCardNumber = CardNumber.split("@");		
					
					var Remarks = obj["remarks"];
					Remarks  = Remarks.replace("@"," @ ");
					var arrRemarks = Remarks.split("@");

					var noOfElements = arrCardNumber.length;
					
					if(CardNumber=='$-$'){
						alert("No card selected. Please select a card to process."); // PG012
						return false;
					}
				}
			}
					
				
			if(CategoryID==1 && SubCategoryID==1)
			{
				if(Validate(NameData,iframeDocument,IsDoneClicked) && Custom_Validation(NameData,iframeDocument,customform,CategoryID,SubCategoryID,IsDoneClicked,fobj))
				{
				
					if(IsDoneClicked && IsError=='Y')
					{
						if(!confirm('Case will be rejected. Do you want to continue?')) 
						{
							if(confirm('Do you want to save data?'))
							{
								IsDoneClicked=false;
								saveNreject=true;
							}
							else
							return false;
						}
					}
					if(IsDoneClicked &&  WSNAME=="PBO")
					{
						if(iframeDocument.getElementById("1_IsSTP").value=='Y' )
						{
							customform.document.getElementById("wdesk:IsSTP").value='Y';
						}	
						else 
						{
							customform.document.getElementById("wdesk:IsSTP").value='N';
						}
						if(iframeDocument.getElementById("1_IsError").value=='Y' )
						{
							customform.document.getElementById("wdesk:IsError").value='Y';
						}	
						else 
						{
							customform.document.getElementById("wdesk:IsError").value='N';
							customform.document.getElementById("wdesk:CCI_CName").value=iframeDocument.getElementById("1_CCI_CName").value;
						}	
					}	
					else if(IsDoneClicked && WSNAME=='Q1')
					{
						if(iframeDocument.getElementById("1_Decision").value.indexOf("Approve")>-1)
							alert("Your request has been submitted successfully.");
						else if(iframeDocument.getElementById("1_Decision").value.indexOf("Reject")>-1)
						{	
							if(!confirm('Case will be rejected. Do you want to continue?'))
								return false;
						}
						else
							alert("Your request has been submitted for review.");
					}
					else if(IsDoneClicked && (WSNAME=='Q2' || WSNAME=='Q3'))
					{
						alert("Your request has been submitted for review.");
					}
				}
				else //PG004 else part added by prateek to allow user to modify in case of false return
				{
					return false;
				}
			}
			else if(!(Validate(NameData,iframeDocument,IsDoneClicked) && Custom_Validation(NameData,iframeDocument,customform,CategoryID,SubCategoryID,IsDoneClicked,fobj)))
			{
				return false;
			}
			
			counthash=0;
			exception=false;
			//change done to restrict db call to single call in case of CBR
			
			// giving alert on done of Q6
			if (WSNAME=='Q6' && IsDoneClicked)
				alert("Your request has been submitted successfully.");
			
			if(CategoryID==1 && SubCategoryID==1 && WSNAME=='PBO')
			{
				//no save call
			}
			else
			{
				var isSaveSuccess = saveSRMData(IsDoneClicked,donefrm,fobj);
				if(!isSaveSuccess)
					return false;
			}
			
			
			if(saveNreject)
			{
				return false;
			}
			customform.document.getElementById("IsSavedFlag").value='Y';
			if(IsDoneClicked && WSNAME == 'PBO')
				customform.document.getElementById("wdesk:Current_Workstep").value='PBO';
			
			//end vivek
			return true;
		}
	return false;
	}
	return false;
	
}

function hideProcessingCustom()
{
	//alert("hiding");
	var divy=document.getElementById("msgdiv");
	if(divy)
		document.body.removeChild(divy);
	else
	{
		divy=parent.document.getElementById("msgdiv");
		if(divy)
		{
			parent.document.body.removeChild(divy);
		}
	}	
}

function CustomIntroduceClick(fobj,process_Name)
{	
	//alert('in CustomIntroduceClick');
		  closedFromCloseButton = 'true';

	if (process_Name == 'SRM' || process_Name == 'New_SRM')
	{	
		if (SRMSAVEDATA(true, 'custom', fobj)) {
			hideProcessingCustom();
			return true;			
		} else {
			hideProcessingCustom();
			return false;
		}		
    }
	else if (process_Name == 'CU')
	{	
		if (validateCUOnPBO(fobj)) {
			hideProcessingCustom();
			return true;
		} else {
			hideProcessingCustom();
			return false;
		}	
    }

    return true;
}

function setCustomDocComment() {
    /*if(filesList!=null) {
        for(var i=0;i < filesList.length;i++){
            if(document.getElementById("importForm:fileListDataTable:"+i+":dtTxtDocComment") != null){
                document.getElementById("importForm:fileListDataTable:"+i+":dtTxtDocComment").value = "abc";
            }
        }    
    }*/
    return true;
}
function cancelSaveEditLayoutHook(fromOp)
{
   // if fromOp='S' then it comes when click on save button of the edit layout, if fromOp='X' then then it comes 
   // when click on cancel button of the edit layout  
    return true;
}

function forcedReassign(enableStatus,strdata){
    //This hook will enable the reassign option in workitemlist if it is getting disabled by the product conditions
    //enableStatus will be false if the Reassign link is getting disabled
    //strdata will return the data that was passed during SearchWorkitem call  
    //return true in case you want to enable the Reassign link
    return false;
}
function isEmbedddedNextWI(strprocessname, stractivityName) {
        return true;
}
function closeWIEMPostHooK(strprocessname, stractivityName) {
        return true;
}
function isFormExtractionMode(processName,activityName,selDocType){
	return false;	
}
function isReadOnlyCrop(strprocessname, stractivityName, strUsername, docName, strPageNo, strReadOnly) {
    return false;
}
function getDefaultGenResAddDoc(strprocessName, stractivityName){
    /**
	* processName is name of the process
    * activityName is name of the activity
	* return 0 for set by default "New Document"
	* return 1 for "Overwrite existing Document"
	* return 2 for "New Version"	
	*/
    return 0;
}
function isEmbedddedNextWI(strprocessname, stractivityName) {
	return true;
}
function closeWIEMPostHooK(strprocessname, stractivityName) {
	return true;
}
function multiDocumentInfoHooK(strprocessname,stractivityName,docName,docIndex)
{   
var arrDocIndex;
//alert("DocIndex" +docIndex);
  //  alert("DocName" + docName);
	/*if(typeof docIndex!="undefined"){
            arrDocIndex=docIndex.split(",");
            alert("Number of Documents uploaded:" +arrDocIndex.length)
      }   */  
	return true;
}
 
function getCustomLayoutWidth(strprocessname,stractivityName){
    return "";
}

function isShowInterfaceHeader(strprocessname, stractivityName) {
    return true;
}
function enableDocDownloadFromVersion(strprocessname,stractivityName,userName) {
    return true;
}
function disableDeleteForOldVersion(strprocessname,stractivityName,userName) {
    return false;
}
function closeWIPostHooK(){
	return true;
}
function beforeWorkitemOpen(pid,wid,pDefId,activityId,qDefId,activityType,queueType,processName,activityName){
    //alert(pid+"::"+wid+"::"+pDefId+"::"+activityId+"::"+qDefId+"::"+activityType+"::"+queueType+"::"+processName+"::"+activityName)
    /*var insObj = window.parent.getViewJsonInstanceByName("CaseWorkitem");
    var iframeWinRef = window.parent.document.getElementById("iframe_"+insObj.TempId).contentWindow;
    iframeWinRef.location = iframeWinRef.location.href;*/
}
function wiOperationPostHook(operation, status, errorMsg) {
    /*
     * -----------------------------------------
     * operation:
     * INTRODUCE - Introduce
     * DONE - Done
     * REFERSAVE - Refer
     * REASSIGNSAVE - Reassign
     * REVOKESAVE - Revoke
     * LOCKFORMESAVE - Self Assign (Lock For Me)
     * RELEASESAVE - Release
     * -----------------------------------------
     * status:
     * error - Some error occurred
     * success - Operation successfully executed
     * -----------------------------------------
     * errorMsg:
     * Blank if status is success otherwise the
     * error message for operation failure
     * -----------------------------------------
     */
}

function isShowVersionForReadOnlyDoc(processName, activityName, documentType, userName) {
    return false;
}

function onSaveValidationFailure(errorMsg) {
    return true;
}
function  IntroParamHook(){
//param="I" : Default
//Param : I or Param : D
    var param = "I";
    return param;
}
function DefaultAddMode(){
	// 0 : New , 1 : NewVersion , 2: Overwrite
	var selectedRadio = 0;
    return selectedRadio ;
}

function addDocumentPostHook(docIndex, docName, docType, pid, wid){
    return true;
}
function removeCommentOnProc(processName, activityName) {
    return true;
}

function setCropParams(strprocessname, stractivityName, username, originalDocName, cropDocName, cropZoneInfo, cropParams) {
     /** 
     * strprocessname: Process Name
     * stractivityName: Activity Name
     * originalDocName: Document type from which cropping is selected
     * cropDocName: Selected document type for crop image
     * cropZoneInfo: Object containing co-ordinates of slected zone for crop
     *      cropZoneInfo.X1 => startX
     *      cropZoneInfo.Y1 => startY
     *      cropZoneInfo.X2 => endX
     *      cropZoneInfo.Y2 => endY
     * cropParams: Object containg cropping properties
     */
    
    /**
     * Overwrite the cropparams object for setting the cropping options as below:
     * cropParams.CropImageMinQuality = 0.1;
     * cropParams.CroppedImageSize = 10;
     * cropParams.CroppedImageName = "Cropped_From_"+originalDocName;
     */

    return cropParams;
}

function getDocInfoPanelViewMode(processName, activityName, docType) {
    /**
     * return 1 (default)
     * ------------------
     * #Document Name along with owner and created/modified date will be
     *  displayed.
     * #If Document Name is large then it will be timmed. Complete Document Name
     *  will be shown in the tooltip when hovering the mouse cursor on the
     *  Document Name.
     * 
     * return 2
     * --------
     * #Only Document Name will be displayed.
     * #Owner and created/modified date will be displayed in the tooltip
     * #If Document Name is large then it will be timmed. Complete Document Name
     *  along with owner and created/modified date will be shown in the tooltip
     *  when hovering the mouse cursor on the Document Name.
     */
    return 1;
}

function SinglePageScrollMode(strprocessname,stractivityName,strQueueName,docext){
    return false;
}

function hideStamp(strprocessname,stractivityName,strQueueName){
    return true;
}

function DisplayFixedWDeskLayout(pid, wid, taskid, stractivityid, strprocessname, stractivityname){
    // return true to display fixed layout of equal ratio
    // return false to display the Layout configured in Workstep Properties from process Designer
    return true;
}
function bProcessCustomDoc(processname, activityName, QueueName){
 return true;   
}
function interFaceClickPreHook(tab1, tab2){
    return true;
} 

function ScanDocPreHook(pid, wid, taskid, docTypeName, docIndex, addMode,fromOp){
    
    return true;
}

function ScanDocPostHook(docIndex, docName, diskName, selButton, runScript, docType,delDocId,fromOp){
    //To Provide Post hook for Scan when Document interface is not associated in WI Window
    
    return true;
}

function IsEmbeddedWList(){
	return false;
}

function getCustomFeatureForWIWindow(processName, activityName, PdefId, queueId, queueType, queueName) {
    /**
     * Function to customize workitem window feature like width, height, top, left etc.
     * If workitem is window is opened after new button click, processName and activityName parameters will be blank.
     * e.g:
     * var wFeatures = 'status=yes,resizable=no,scrollbars=yes,width='+400+',height='+400+',left=0,top=0,resizable=yes,scrollbars=yes';
     */
    return '';
}

function cropDocumentPostHook(strProcessName, strActivityName, addDocXML) {
    
}

function CustomNoOfRecordsToFetch(processName,activityName){
    return "";
}

function removeCommentOnProc(processName, activityName){      //Bug 94156 
	return true;
}

function isPDFOpenInOpallViewer(strProcessName, strActivityName, pid, strDocType, strDocExt) {
// for image type documents which are supported in Opall Viewer
return true;
}

function keepDocListSideBarOpen(strProcessName, strActivityName, strPID, strWID, strTaskID, calledFrom){
    return false;
}

function getCustomWDSideBarWidth(selPanelTab){
    // selPanelTab : Documents , Exceptions , ToDoList , Info , Progress , Tasks
    /*
     //SAMPLE CODE
    if(selPanelTab == 'ToDoList')
        return 600;
    else
        return "";
    */
    return "";
}

function importDocumentPostHook(docIndex,docName)
{   //To Provide Post hook for Import Document when Document interface is not associated in WI Window
   
}
function isTextSelectableInOpall(strprocessname, stractivityName, docExt,docIndex){
    // to enable or disable the text selection option in opall viewer
    return false;
}

// Added by prateek for change in create workitem functionality PG0039
function FireIntegrationCall(IsDoneClicked,donefrm,fobj,ProcessInstanceId) 
{
	var customform='';
	if(donefrm=='custom')
	{	
		customform=fobj;
	}
	else
	{
		var formWindow=getWindowHandler(windowList,"formGrid");
		customform=formWindow.frames['customform'];
	}
		
	var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
	
	var SubCategoryID=customform.document.getElementById("SubCategoryID").value;
	var CategoryID=customform.document.getElementById("CategoryID").value;
	
	var Category=customform.document.getElementById("Category").value;
	var SubCategory=customform.document.getElementById("SubCategory").value;
	var Channel=customform.document.getElementById("Channel").value;
	customform.document.getElementById("wdesk:Category").value=customform.document.getElementById("Category").value;
	customform.document.getElementById("wdesk:SubCategory").value=customform.document.getElementById("SubCategory").value;
	customform.document.getElementById("wdesk:Channel").value=customform.document.getElementById("Channel").value;
	
	var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
	
	var iframe = customform.document.getElementById("frmData");
	
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	var PANno=iframeDocument.getElementById("PANno").value;
	

	
	var inputs = iframeDocument.getElementsByTagName("input");
	
		for (x=0;x<inputs.length;x++)
		{	
			myname = inputs[x].getAttribute("id");
			if(myname==null)
				continue;
					
			if(myname.indexOf("tr_")==0)
			{
				tr_table = iframeDocument.getElementById(myname).value;
				
			}
			
		}
		

if(SubCategoryID=='3') // for nosave
{
	if(iframeDocument.getElementById('Card Blocking Details_modifyGridBundle').value=='')
	{
		//
	}
	else
	{
		
		var Framedata = iframeDocument.getElementById("Card Blocking Details_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
		
		var gridData=Framedata;
		Framedata = Framedata.replaceAllOccurence("\":\"","~");
		Framedata =Framedata.replaceAllOccurence("\",\"","$");
		Framedata =Framedata.replaceAllOccurence("\"","");
		Framedata =Framedata.replaceAllOccurence("{","");
		Framedata =Framedata.replaceAllOccurence("}","");
		
		Framedata = Framedata.split("$");
		
		var aa="";
		var columnList="";
		for(var i=0; i< Framedata.length ; i++)
		{
			var value = Framedata[i].split("~");
			
			if(i==0)
				columnList="3_"+value[0];
			else
				columnList=columnList+","+"3_"+value[0];
				 
		}
				
		var framename='Card Blocking Details';	
				
		if(!CustomModifyGridValues(columnList,framename,SubCategoryID,donefrm,fobj))
		{
			var gridBundle=iframeDocument.getElementById(framename+'_modifyGridBundle').value;
			var id = gridBundle.substring(gridBundle.lastIndexOf("_")+1,gridBundle.length);
			
			iframeDocument.getElementById(framename+"_Radio_"+id).checked=true;
			
			return "false";
		}
		
	}
	

}



if(SubCategoryID=='2' || SubCategoryID=='4' || SubCategoryID=='5') // for nosave
{
	
// alert(iframeDocument.getElementById('AUTHORIZATION DETAILS_modifyGridBundle').value);


	if(iframeDocument.getElementById('AUTHORIZATION DETAILS_modifyGridBundle').value=='')
	{
		//code block added to check authorization code mandatory check in case of multiple click of introduce on fund block failure
		if(SubCategoryID==4 && iframeDocument.getElementById('4_auth_code').value=='' && customform.document.getElementById("wdesk:IntegrationStatus").value=='false')
		{
			alert("Please enter authorization code.");
			return false;
		}
		if(SubCategoryID==5 && iframeDocument.getElementById('5_auth_code').value=='' && customform.document.getElementById("wdesk:IntegrationStatus").value=='false')
		{
			alert("Please enter authorization code.");
			return false;
		}
		else if(SubCategoryID==2 && iframeDocument.getElementById('2_auth_code').value=='' && customform.document.getElementById("wdesk:IntegrationStatus").value=='false')
		{
			alert("Please enter authorization code.");
			return false;
		}
	}
	else
	{
		//alert("in else");
		
		
		var Framedata = iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
		
		var gridData=Framedata;
		Framedata = Framedata.replaceAllOccurence("\":\"","~");
		Framedata =Framedata.replaceAllOccurence("\",\"","$");
		Framedata =Framedata.replaceAllOccurence("\"","");
		Framedata =Framedata.replaceAllOccurence("{","");
		Framedata =Framedata.replaceAllOccurence("}","");
		
		Framedata = Framedata.split("$");
		
		var aa="";
		var columnList="";
		for(var i=0; i< Framedata.length ; i++)
		{
			var value = Framedata[i].split("~");
			
			if(i==0)
				columnList=SubCategoryID+"_"+value[0];
			else
				columnList=columnList+","+SubCategoryID+"_"+value[0];
				 
		}
				
		framename='AUTHORIZATION DETAILS';	
				
		if(!CustomModifyGridValues(columnList,framename,SubCategoryID,donefrm,fobj))
		{
			var gridBundle=iframeDocument.getElementById(framename+'_modifyGridBundle').value;
			var id = gridBundle.substring(gridBundle.lastIndexOf("_")+1,gridBundle.length);
			
			iframeDocument.getElementById(framename+"_Radio_"+id).checked=true;
			
			return "false";
		}
		
	}
	

}




		if(CategoryID==1 && SubCategoryID==1)
		{
			if(iframeDocument.getElementById("1_IsSTP").value=="Y")
			{
				integrationResultMessage='true'+'$$'+'Your request has been submitted successfully.';
			}
			else
			{
				integrationResultMessage="true"+"$$"+"Dear "+iframeDocument.getElementById("1_CCI_CName").value+", we have taken your request for cash back which will be reviewed in 3 working days.";			
			}
		}
		
		if(CategoryID==1 && SubCategoryID==3)
			{
				
				if(IsDoneClicked && WSNAME=="PBO" )
				{
				
					var selJSONGridWIData = iframeDocument.getElementById("Card Blocking Details_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
					var obj = JSON.parse(selJSONGridWIData);
		
					var BlockCard = "";
					var CardNumber = "";
					var CustId = iframeDocument.getElementById(SubCategoryID+"_cif").value;
					var ReasonCode="";
					var CardCRN="";
					var RequestStatus="";
					var RequestType  = "CARDBLOCK";
					CardNumber = obj['card_number'];
					var arrCardNumber = CardNumber.split("@");		
					RequestStatus = obj['req_status'];					
					var arrRequestStatus = RequestStatus.split("@");
					var noOfElements = arrCardNumber.length;
					ReasonCode = obj['aft_CardStatus'];					
					var arrReasonCode = ReasonCode.split("@");
					CardCRN = obj['crn'];					
					var arrCardCRN = CardCRN.split("@");
					BlockCard = obj['block_card'];					
					var arrBlockCard = BlockCard.split("@");
					
					var typeOfBlock = obj['type_of_block'];					
					var arrTypeOfBlock = typeOfBlock.split("@");
					
					ManualBlockingAction = obj['manual_blocking_action'];					
					var arrManualBlockingAction = ManualBlockingAction.split("@");
					
					var typeOfBlock = '';
					var messageBlockCard = '';
					var ajexResponse = '';
					var noOfTimesFailed=0;
					var noOfCardsToBlock=0;
					var unsuccessCount=0;					
									
					var selGridRowData = "";
					var modSelGridRowData = "";
					var arrSelGridRowData = "";
					var postIntegrationAlertFlag = false;
							
					for(var cardCounter = 0 ;  cardCounter<noOfElements; cardCounter++)
					{
						if(arrRequestStatus[cardCounter].replace(/^\s+|\s+$/gm,'')=='Not Blocked' && (arrManualBlockingAction[cardCounter].replace(/^\s+|\s+$/gm,'')=='' || arrManualBlockingAction[cardCounter].replace(/^\s+|\s+$/gm,'')=='No Action'))
						{
							postIntegrationAlertFlag=true;
							break;
						}
					}
					
					
					var cardsToBeBlocked="";
					for(var cardCounter = 0 ;  cardCounter<noOfElements; cardCounter++)
					{
						if(arrBlockCard[cardCounter].replace(/^\s+|\s+$/gm,'')=='Yes')
						{
							cardsToBeBlocked = cardsToBeBlocked+arrCardNumber[cardCounter].replace(/^\s+|\s+$/gm,'')+'\n';
						}
					}
					
					for(var cardCounter = 0 ;  cardCounter<noOfElements; cardCounter++)
					{
						if(customform.document.getElementById("wdesk:IntegrationStatus").value=='false')
							break;
							
						selGridRowData = iframeDocument.getElementById("Card Blocking Details_"+SubCategoryID+"_gridbundle_"+cardCounter).value;
						arrSelGridRowData = selGridRowData.split("3_req_status#");
						
						
						
						if(arrBlockCard[cardCounter].replace(/^\s+|\s+$/gm,'')=='Yes' && arrRequestStatus[cardCounter].replace(/^\s+|\s+$/gm,'')!='Blocked' && arrRequestStatus[cardCounter].replace(/^\s+|\s+$/gm,'')!='Not Blocked' && arrManualBlockingAction[cardCounter].replace(/^\s+|\s+$/gm,'')=='')
						{
						
							noOfCardsToBlock++;
							ajexResponse = callBlockCard(arrCardNumber[cardCounter].replace(/^\s+|\s+$/gm,''),CustId,arrReasonCode[cardCounter].replace(/^\s+|\s+$/gm,''),arrCardCRN[cardCounter].replace(/^\s+|\s+$/gm,''),ProcessInstanceId,arrRequestStatus[cardCounter].replace(/^\s+|\s+$/gm,''),RequestType,customform,tr_table);
							ResponseList = ajexResponse.split("~");
						
							var response=ResponseList[0];
							
							// if(cardCounter!=0)
								// response='1111';
							if(response=='0000')
							{
								noOfTimesFailed=0;
								arrRequestStatus[cardCounter]='Blocked';
								iframeDocument.getElementById("grid_"+SubCategoryID+"_req_status_"+cardCounter).value='Blocked';
								
								if(!(arrSelGridRowData[1].indexOf("Blocked") > -1)){
									modSelGridRowData  =  arrSelGridRowData.join("3_req_status#Blocked");
								}else{
									modSelGridRowData  =  arrSelGridRowData.join("3_req_status#");
								}
								iframeDocument.getElementById("Card Blocking Details_"+SubCategoryID+"_gridbundle_"+	cardCounter).value = modSelGridRowData;
								
								messageBlockCard +="Card No. "+arrCardNumber[cardCounter].replace(/^\s+|\s+$/gm,'')+ "- "+arrTypeOfBlock[cardCounter].replace(/^\s+|\s+$/gm,'')+" Blocked."+'\n';
							}
							else
							{
								if(noOfTimesFailed==2)
								{
									noOfTimesFailed=0;
									unsuccessCount++;
									arrRequestStatus[cardCounter]='Not Blocked';
									iframeDocument.getElementById("grid_"+SubCategoryID+"_req_status_"+cardCounter).value='Not Blocked';
									
									//iframeDocument.getElementById(SubCategoryID+"_req_status").value='Not Blocked';
									
									if(!(arrSelGridRowData[1].indexOf("Not Blocked") > -1)){
										modSelGridRowData  =  arrSelGridRowData.join("3_req_status#Not Blocked");
									}else{
										modSelGridRowData  =  arrSelGridRowData.join("3_req_status#");
									}
									
									iframeDocument.getElementById("Card Blocking Details_"+SubCategoryID+"_gridbundle_"+cardCounter).value= modSelGridRowData;
									
									messageBlockCard +="Card No. "+arrCardNumber[cardCounter].replace(/^\s+|\s+$/gm,'')+"  could not be blocked."+'\n';
								}
								else
								{
									cardCounter--;
									noOfTimesFailed++;
								}
							}
						}
					}
					customform.document.getElementById("wdesk:IntegrationStatus").value='false';
					var modRequestStatus=arrRequestStatus.join("@");
					obj["req_status"]=modRequestStatus;
					iframeDocument.getElementById("Card Blocking Details_"+SubCategoryID+"_gridbundleJSON_WIDATA").value= JSON.stringify(obj);
					var selGridBundleWIDATA = JSON.stringify(obj);
					
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/^\s+|\s+$/gm,'');
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/":"/gm,'#');
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/","/gm,'~');
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/{"/gm,'');
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/"}/gm,'');

					iframeDocument.getElementById("Card Blocking Details_"+SubCategoryID+"_gridbundle_WIDATA").value = selGridBundleWIDATA;
					
					if(postIntegrationAlertFlag)
					{
						alert("Case will be lying at PBO queue. Action to be taken for all the Not Blocked cards");
						return 'false$$false';
					}
									
					if(unsuccessCount==0)
					{
						if(iframeDocument.getElementById("3_IsTempRequested").value=='N')
						{
							integrationResultMessage=messageBlockCard+'\n'+'Request has been processed successfully.';						
						}
						else
						{
							integrationResultMessage=messageBlockCard+'\n'+'Request has been forwarded to Contact Customer Queue.';
						}
						integrationResultMessage='true'+'$$'+integrationResultMessage;
					}
					else 
					{
						integrationResultMessage=messageBlockCard+'\n'+'Please manually block the card(s).';
						integrationResultMessage='false'+'$$'+integrationResultMessage;
					}
				}
			}
			
			//vivek 08082014
			if(CategoryID==1 && SubCategoryID==2)
			{
				if(IsDoneClicked && WSNAME=="PBO" )
				{
					var selJSONGridWIData = iframeDocument.getElementById("BALANCE TRANSFER DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
					
					
					var obj = JSON.parse(selJSONGridWIData);
					var CardNumber = "";
					var CustId = iframeDocument.getElementById(SubCategoryID+"_cif").value;
					var AuthCode="";
					var AuthStatus="";
					var BTAmount="";
					var modifiedListBundle = "";
					RequestType="FUND_BLOCK_ON_CREDIT_CARD";
					
					CardNumber = obj['rakbank_eligible_card_no'];
					if(CardNumber=='' || CardNumber==' '){
						CardNumber = "";
					}else{
						CardNumber = CardNumber.replace("@"," @ ");
					}
					var arrCardNumber = CardNumber.split("@");	
					
					var Remarks = obj["remarks"];
					Remarks  = Remarks.replace("@"," @ ");
					var arrRemarks = Remarks.split("@");
					
					
					var noOfElements = arrCardNumber.length;

					if(CardNumber=='$-$'){
						alert("No card selected. Please select a card to process."); // PG012
						return false;
					}
					var selJSONGridAuthDetailsWIData = iframeDocument.getElementById("AUTHORIZATION DETAILS_2_gridbundleJSON_WIDATA").value;
					
					var objAuthDetails = JSON.parse(selJSONGridAuthDetailsWIData);
					
					AuthCode = objAuthDetails["auth_code"];
					AuthCode  = AuthCode .replace("@"," @ ");
					var arrAuthCode = AuthCode.split("@");
					
					AuthStatus = objAuthDetails["status"];
					AuthStatus  = AuthStatus .replace("@"," @ ");
					var arrAuthStatus = AuthStatus.split("@");
					
					BTAmount = objAuthDetails["bt_amount"];
					BTAmount  = BTAmount .replace("@"," @ ");
					var arrBTAmount = BTAmount.split("@");
					
					var TranReqUID = objAuthDetails["tran_req_uid"];
					TranReqUID  = TranReqUID.replace("@"," @ ");
					var arrTranReqUID= TranReqUID.split("@");

					var ApprovalCd = objAuthDetails["Approval_cd"];
					ApprovalCd  = ApprovalCd.replace("@"," @ ");
					var arrApprovalCd= ApprovalCd.split("@");					
					
					
					var CardDetailsJSON_WIDATA = iframeDocument.getElementById("CARD DETAILS_2_gridbundleJSON_WIDATA").value;
					var objCardDetails = JSON.parse(CardDetailsJSON_WIDATA);
					var cardNo = objCardDetails["rak_card_no"];
					cardNo  = cardNo.replace("@"," @ ");
					var arrCardNo = cardNo.split("@");

					var CRNNo = objCardDetails["crn_no"];
					CRNNo  = CRNNo.replace("@"," @ ");
					var arrCRNNo = CRNNo.split("@");
					var AuthCRNNo = '';

					var ExpiryDate = objCardDetails["expiry"];
					ExpiryDate  = ExpiryDate.replace("@"," @ ");
					var arrExpiryDate = ExpiryDate.split("@");
					var AuthExpiryDate = '';

					var typeOfBlock = '';
					var messageBalanceTransfer = '';
					var ajexResponse = '';
					var noOfTimesFailed=0;
					var tempFailCount=0;
					var noOfCardsToBlock=0;
					
										
					var manualBlockStatus="";
					var postIntegrationAlertFlag="";
					
					manualBlockStatus = objAuthDetails['manual_blocking_action'];
					
					var arrManualBlockStatus = manualBlockStatus.split("@");	
					
					for(var cardCounter = 0 ;  cardCounter<noOfElements; cardCounter++)
					{
						if(arrAuthStatus[cardCounter].replace(/^\s+|\s+$/gm,'')=='' && (arrManualBlockStatus[cardCounter].replace(/^\s+|\s+$/gm,'')=='' || arrManualBlockStatus[cardCounter].replace(/^\s+|\s+$/gm,'')=='No Action') && customform.document.getElementById("wdesk:IntegrationStatus").value=='false')
						{
							postIntegrationAlertFlag=true;
							break;
						}
					}
					
					for(var cardCounter = 0 ;  cardCounter<noOfElements; cardCounter++)
					{
						if(customform.document.getElementById("wdesk:IntegrationStatus").value=='false')
						break;
						if(arrAuthCode[cardCounter].replace(/^\s+|\s+$/gm,'')=='')
						{
							noOfCardsToBlock++;
							for(var i=0;i<arrCardNo.length;i++)
							{
								if(arrCardNo[i].replace(/^\s+|\s+$/gm,'')==arrCardNumber[cardCounter].replace(/^\s+|\s+$/gm,'')){
									AuthCRNNo = arrCRNNo[i];
									AuthExpiryDate = arrExpiryDate[i];
								}
							}	
							
							ajexResponse = callBlockAmt(arrCardNumber[cardCounter].replace(/^\s+|\s+$/gm,''),CustId,AuthCRNNo.replace(/^\s+|\s+$/gm,''),AuthExpiryDate.replace(/^\s+|\s+$/gm,''),ProcessInstanceId,arrRemarks[cardCounter].replace(/^\s+|\s+$/gm,''),RequestType,arrBTAmount[cardCounter].replace(/^\s+|\s+$/gm,''),"",customform,tr_table);
								
							ResponseList = ajexResponse.split("~");
						
							var response=ResponseList[0];
							var status = ResponseList[2];
							if(response=='0000')
							{
								noOfTimesFailed=0;
								tempFailCount=0;
								
								arrAuthCode[cardCounter]=ResponseList[3];
								arrAuthStatus[cardCounter]=status;
								arrTranReqUID[cardCounter]=ResponseList[4];
								arrApprovalCd[cardCounter]=ResponseList[1];
								
								iframeDocument.getElementById("grid_"+SubCategoryID+"_auth_code_"+cardCounter).value=ResponseList[3];
								iframeDocument.getElementById("grid_"+SubCategoryID+"_status_"+cardCounter).value=status;
								iframeDocument.getElementById("grid_"+SubCategoryID+"_Approval_cd_"+cardCounter).value=ResponseList[1];
								iframeDocument.getElementById("grid_"+SubCategoryID+"_tran_req_uid_"+cardCounter).value=ResponseList[4];
								
								var gridBundleValue = iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundle_"+cardCounter).value;		
								
								var arrElementData=gridBundleValue.split('~');
								var arrModElementData = "";
								for (z=0;z<arrElementData.length;z++)
								{
									var strElementName=arrElementData[z].substring(0,arrElementData[z].indexOf(":"));
									var strElementColumnValue=arrElementData[z].substring(arrElementData[z].indexOf(":")+1);
									var arrElementName=strElementName.split('#');
									
									var arrElementColumnValue=strElementColumnValue.split('#');				
									var columnName=arrElementColumnValue[0];
									var columnValue=arrElementColumnValue[1];	
									if(columnName==SubCategoryID+"_auth_code"){
										columnValue=ResponseList[3];
									} else if (columnName==SubCategoryID+"_status"){
										columnValue=status;
									}else if (columnName==SubCategoryID+"_Approval_cd"){
										columnValue=ResponseList[1];
									}else if (columnName==SubCategoryID+"_tran_req_uid"){
										columnValue=ResponseList[4];
									}
									arrElementColumnValue[0]=columnName;
									arrElementColumnValue[1]=columnValue;	
									strElementColumnValue=arrElementColumnValue.join("#");
									arrModElementData+=strElementName+":"+strElementColumnValue;
									if(z!=arrElementData.length-1)
									{
										arrModElementData+="~";
									}
								}
								iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundle_"+cardCounter).value=arrModElementData;
								messageBalanceTransfer+="Amount "+arrBTAmount[cardCounter].replace(/^\s+|\s+$/gm,'')+" for Card No "+arrCardNumber[cardCounter].replace(/^\s+|\s+$/gm,'')+" has been blocked. Auth Code is "+ ResponseList[3]+'\n';
							}
							else
							{
								
								//code added to disable the authorization grid fields till the point radio button is clicked
								
								iframeDocument.getElementById("2_sub_ref_no_auth").disabled=true;
								iframeDocument.getElementById("2_card_no").disabled=true;
								iframeDocument.getElementById("2_auth_code").disabled=true;
								iframeDocument.getElementById("2_status").disabled=true;
								iframeDocument.getElementById("2_bt_amount").disabled=true;
								
								
								arrAuthCode[cardCounter]=ResponseList[3];
								arrAuthStatus[cardCounter]=status;
								iframeDocument.getElementById("grid_"+SubCategoryID+"_auth_code_"+cardCounter).value=ResponseList[3];
								iframeDocument.getElementById("grid_"+SubCategoryID+"_status_"+cardCounter).value=status;
								iframeDocument.getElementById("grid_"+SubCategoryID+"_Approval_cd_"+cardCounter).value=ResponseList[1];
								iframeDocument.getElementById("grid_"+SubCategoryID+"_tran_req_uid_"+cardCounter).value=ResponseList[4];
								
								
								
								var gridBundleValue = iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundle_"+cardCounter).value;		
								
								var arrElementData=gridBundleValue.split('~');
								var arrModElementData = "";
								for (z=0;z<arrElementData.length;z++)
								{
									var strElementName=arrElementData[z].substring(0,arrElementData[z].indexOf(":"));
									var strElementColumnValue=arrElementData[z].substring(arrElementData[z].indexOf(":")+1);
									var arrElementName=strElementName.split('#');
									
									var arrElementColumnValue=strElementColumnValue.split('#');				
									
									var columnName=arrElementColumnValue[0];
									var columnValue=arrElementColumnValue[1];	
									if(columnName==SubCategoryID+"_auth_code"){
										columnValue=ResponseList[3];
									}else if (columnName==SubCategoryID+"_status"){
										columnValue=status;
									}else if (columnName==SubCategoryID+"_Approval_cd"){
										columnValue=ResponseList[1];
									}else if (columnName==SubCategoryID+"_tran_req_uid"){
										columnValue=ResponseList[4];
									}
									
									arrElementColumnValue[0]=columnName;
									arrElementColumnValue[1]=columnValue;	
									strElementColumnValue=arrElementColumnValue.join("#");
									arrModElementData+=strElementName+":"+strElementColumnValue;
									if(z!=arrElementData.length-1)
									{
										arrModElementData+="~";
									}
									
								}
								iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundle_"+cardCounter).value=arrModElementData;
								if(tempFailCount==2)
								{
									tempFailCount=0;
									messageBalanceTransfer+="Amount "+arrBTAmount[cardCounter].replace(/^\s+|\s+$/gm,'')+" for Card No "+arrCardNumber[cardCounter].replace(/^\s+|\s+$/gm,'')+" could not be blocked. "+'\n';
								}
								else
								{
									cardCounter--;
									tempFailCount++;
									noOfTimesFailed++;
								}
							}
						}
					}
					
					
					customform.document.getElementById("wdesk:IntegrationStatus").value='false';
					{
						if(customform.document.getElementById("wdesk:IntegrationStatus").value=='false') // prateek
						{
							iframeDocument.getElementById('2_bt_required').disabled=true;
							iframeDocument.getElementById("Check Card Eligibility").disabled=true;	
							iframeDocument.getElementById("CARD DETAILS_Modify").disabled=true;	
							iframeDocument.getElementById("CARD DETAILS_Clear").disabled=true;	
														
							iframeDocument.getElementById("2_sub_ref_no").disabled=true;
							iframeDocument.getElementById("2_rakbank_eligible_card_no").disabled=true;
							iframeDocument.getElementById("2_bt_amt_req").disabled=true;
							iframeDocument.getElementById("2_other_bank_card_type").disabled=true;
							iframeDocument.getElementById("2_name_on_card").disabled=true;
							iframeDocument.getElementById("2_other_bank_card_no").disabled=true;
							iframeDocument.getElementById("2_type_of_bt").disabled=true;
							iframeDocument.getElementById("2_other_bank_name").disabled=true;
							iframeDocument.getElementById("2_remarks").disabled=true;
							iframeDocument.getElementById("2_payment_by").disabled=true;
							iframeDocument.getElementById("2_delivery_channel").disabled=true;
							iframeDocument.getElementById("2_branch_name").disabled=true;
							iframeDocument.getElementById("2_eligibility").disabled=true;
							
							iframeDocument.getElementById("Check BT Eligibility").disabled=true;	
							iframeDocument.getElementById("BALANCE TRANSFER DETAILS_Add").disabled=true;	
							iframeDocument.getElementById("BALANCE TRANSFER DETAILS_Modify").disabled=true;	
							iframeDocument.getElementById("BALANCE TRANSFER DETAILS_Delete").disabled=true;	
							iframeDocument.getElementById("BALANCE TRANSFER DETAILS_Clear").disabled=true;	
							
							
						}
					
					}
					var modArrAuthCode=arrAuthCode.join("@");
					objAuthDetails["auth_code"]=modArrAuthCode;
					var modArrAuthStatus=arrAuthStatus.join("@");
					objAuthDetails["status"]=modArrAuthStatus;
					
					var modArrTranReqUID=arrTranReqUID.join("@");
					objAuthDetails["tran_req_uid"]=modArrTranReqUID;
					
					
					var modArrApprovalCd=arrApprovalCd.join("@");
					objAuthDetails["Approval_cd"]=modArrApprovalCd;
					
					iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value=JSON.stringify(objAuthDetails);
					
					var selGridBundleWIDATA = JSON.stringify(objAuthDetails);					
					
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/^\s+|\s+$/gm,'');
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/":"/gm,'#');
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/","/gm,'~');
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/{"/gm,'');
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/"}/gm,'');
					
					
					
					iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundle_WIDATA").value = selGridBundleWIDATA;
					
					if(postIntegrationAlertFlag)
					{
						alert("Case will be lying at PBO queue. Action to be taken for all the cards.");



						return 'false$$false';
					}
					
					if(noOfTimesFailed==0)
					{
						integrationResultMessage=messageBalanceTransfer+'\n'+'Case would be submitted.';
						integrationResultMessage='true'+'$$'+integrationResultMessage;
					}
					else
					{
						integrationResultMessage=messageBalanceTransfer+'\n'+'Case would not be submitted.\nPlease perform the Manual Blocking Action under Authorization Details';
						integrationResultMessage='false'+'$$'+integrationResultMessage;
					}
				}
			}
		
			if(CategoryID==1 && SubCategoryID==4)
			{
				if(IsDoneClicked && WSNAME=="PBO" )
				{
					var selJSONGridWIData = iframeDocument.getElementById("CREDIT CARD CHEQUE DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
					var obj = JSON.parse(selJSONGridWIData);
					
					var CardNumber = "";
					var CustId = iframeDocument.getElementById(SubCategoryID+"_cif").value;
					var AuthCode="";
					var AuthStatus="";
					var TransReqUID="";
					var ApprovalID="";
					
					var modifiedListBundle = "";
					RequestType="FUND_BLOCK_ON_CREDIT_CARD";
					
					CardNumber = obj['rakbank_eligible_card_no'];
					if(CardNumber=='' || CardNumber==' '){
						CardNumber = "";
					}else{
						CardNumber = CardNumber.replace("@"," @ ");
					}
					var arrCardNumber = CardNumber.split("@");		
					
					var Remarks = obj["remarks"];
					Remarks  = Remarks.replace("@"," @ ");
					var arrRemarks = Remarks.split("@");

					var noOfElements = arrCardNumber.length;
					
					//code added to pass Merchant code in fund block call for CCC
					var MarketingCode = obj["marketing_code"];
					var arrMerchantCode = MarketingCode.split("@");
					for(var c =0; c<noOfElements; c++)
					{
						if(arrMerchantCode[c]=='SEC' || arrMerchantCode[c]=='TPC')
							arrMerchantCode[c]='0400';
						else
							arrMerchantCode[c]='0200';
					}
					
					if(CardNumber=='$-$'){
						alert("No card selected. Please select a card to process."); // PG012
						return false;
					}else{
						//
					}
					var selJSONGridAuthDetailsWIData = iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
					var objAuthDetails = JSON.parse(selJSONGridAuthDetailsWIData);
					AuthCode = objAuthDetails["auth_code"];
					AuthCode  = AuthCode .replace("@"," @ ");
					var arrAuthCode = AuthCode.split("@");
					AuthStatus = objAuthDetails["status"];
					AuthStatus  = AuthStatus .replace("@"," @ ");
					var arrAuthStatus = AuthStatus.split("@");
					
					TransReqUID = objAuthDetails["tran_req_uid"];
					TransReqUID  = TransReqUID .replace("@"," @ ");
					var arrTransReqUID = AuthCode.split("@");
					ApprovalID = objAuthDetails["Approval_cd"];
					ApprovalID  = ApprovalID .replace("@"," @ ");
					var arrApprovalID = ApprovalID.split("@");
					
					
					
					
					BTAmount = objAuthDetails["ccc_amount"];
					BTAmount  = BTAmount .replace("@"," @ ");
					var arrBTAmount = BTAmount.split("@");

					var CardDetailsJSON_WIDATA = iframeDocument.getElementById("CARD DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
					var objCardDetails = JSON.parse(CardDetailsJSON_WIDATA);
					var cardNo = objCardDetails["card_no"];
					cardNo  = cardNo.replace("@"," @ ");
					var arrCardNo = cardNo.split("@");

					var CRNNo = objCardDetails["crn_no"];
					CRNNo  = CRNNo.replace("@"," @ ");
					var arrCRNNo = CRNNo.split("@");
					var AuthCRNNo = '';

					var ExpiryDate = objCardDetails["expiry"];
					ExpiryDate  = ExpiryDate.replace("@"," @ ");
					var arrExpiryDate = ExpiryDate.split("@");
					var AuthExpiryDate = '';


					var typeOfBlock = '';
					var messageBalanceTransfer = '';
					var ajexResponse = '';
					var noOfTimesFailed=0;
					var noOfCardsToBlock=0;
					
					
					var manualBlockStatus="";
					var postIntegrationAlertFlag="";
					
					manualBlockStatus = objAuthDetails['manual_blocking_action'];
					
					var arrManualBlockStatus = manualBlockStatus.split("@");	
					
					for(var cardCounter = 0 ;  cardCounter<noOfElements; cardCounter++)
					{

						if(arrAuthStatus[cardCounter].replace(/^\s+|\s+$/gm,'')=='' && (arrManualBlockStatus[cardCounter].replace(/^\s+|\s+$/gm,'')=='' || arrManualBlockStatus[cardCounter].replace(/^\s+|\s+$/gm,'')=='No Action') && customform.document.getElementById("wdesk:IntegrationStatus").value=='false' && arrAuthCode[cardCounter].replace(/^\s+|\s+$/gm,'')!='')
						{

							postIntegrationAlertFlag=true;

							break;
						}
					}
					
					
					
					for(var cardCounter = 0 ;  cardCounter<noOfElements; cardCounter++)
					{
						if(customform.document.getElementById("wdesk:IntegrationStatus").value=='false')
						break;
						
						if(arrAuthCode[cardCounter].replace(/^\s+|\s+$/gm,'')=='')
						{
							noOfCardsToBlock++;
							
							for(var i=0;i<arrCardNo.length;i++){
								if(arrCardNo[i].replace(/^\s+|\s+$/gm,'')==arrCardNumber[cardCounter].replace(/^\s+|\s+$/gm,'')){
									AuthCRNNo = arrCRNNo[i];
									AuthExpiryDate = arrExpiryDate[i];
								}
							}	
							
							ajexResponse = callBlockAmt(arrCardNumber[cardCounter].replace(/^\s+|\s+$/gm,''),CustId,AuthCRNNo.replace(/^\s+|\s+$/gm,''),AuthExpiryDate.replace(/^\s+|\s+$/gm,''),ProcessInstanceId,arrRemarks[cardCounter].replace(/^\s+|\s+$/gm,''),RequestType,arrBTAmount[cardCounter].replace(/^\s+|\s+$/gm,''),arrMerchantCode[cardCounter],customform,tr_table);
							
							ResponseList = ajexResponse.split("~");
						
							var response=ResponseList[0];
							var AuthCode=ResponseList[3];
							var status = ResponseList[2];
							var ApprovalID=ResponseList[1];	
							var TransReqUID=ResponseList[4];

							if(response=='0000'){
								arrAuthCode[cardCounter]=ResponseList[3];
								arrAuthStatus[cardCounter]=status;
								
								arrTransReqUID[cardCounter]=TransReqUID;
								arrApprovalID[cardCounter]=ApprovalID;
								
								iframeDocument.getElementById("grid_"+SubCategoryID+"_auth_code_"+cardCounter).value=ResponseList[3];
								iframeDocument.getElementById("grid_"+SubCategoryID+"_status_"+cardCounter).value=status;
								iframeDocument.getElementById("grid_"+SubCategoryID+"_Approval_cd_"+cardCounter).value=ApprovalID;
								iframeDocument.getElementById("grid_"+SubCategoryID+"_tran_req_uid_"+cardCounter).value=TransReqUID;

								
								var gridBundleValue = iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundle_"+cardCounter).value;		
						
								var arrElementData=gridBundleValue.split('~');
								var arrModElementData = "";
								for (z=0;z<arrElementData.length;z++)
								{
									var strElementName=arrElementData[z].substring(0,arrElementData[z].indexOf(":"));
									var strElementColumnValue=arrElementData[z].substring(arrElementData[z].indexOf(":")+1);
									var arrElementName=strElementName.split('#');
									
									var arrElementColumnValue=strElementColumnValue.split('#');				
									var columnName=arrElementColumnValue[0];
									var columnValue=arrElementColumnValue[1];	
									if(columnName==SubCategoryID+"_auth_code"){
										columnValue=ResponseList[3];
									}else if (columnName==SubCategoryID+"_status"){
										columnValue=status;
									}else if (columnName==SubCategoryID+"_Approval_cd"){
										columnValue=ApprovalID;
									}else if (columnName==SubCategoryID+"_tran_req_uid"){
										columnValue=TransReqUID;
									}									
									
									arrElementColumnValue[0]=columnName;
									arrElementColumnValue[1]=columnValue;	
									strElementColumnValue=arrElementColumnValue.join("#");
									arrModElementData+=strElementName+":"+strElementColumnValue;
									if(z!=arrElementData.length-1)
									{
										arrModElementData+="~";
									}
								}
								
								iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundle_"+cardCounter).value=arrModElementData;
								messageBalanceTransfer+="Amount "+arrBTAmount[cardCounter].replace(/^\s+|\s+$/gm,'')+" for Card No "+arrCardNumber[cardCounter].replace(/^\s+|\s+$/gm,'')+" has been blocked. Auth Code is "+ ResponseList[3]+'\n';


							}else
							{
								//code added to disable the authorization grid fields till the point radio button is clicked
								
								iframeDocument.getElementById("4_sub_ref_no_auth").disabled=true;
								iframeDocument.getElementById("4_card_no").disabled=true;
								iframeDocument.getElementById("4_auth_code").disabled=true;
								iframeDocument.getElementById("4_status").disabled=true;
								iframeDocument.getElementById("4_ccc_amount").disabled=true;
								

								arrAuthCode[cardCounter]=ResponseList[3];
								arrAuthStatus[cardCounter]=status;
								
								arrTransReqUID[cardCounter]=TransReqUID;
								arrApprovalID[cardCounter]=ApprovalID;
								
								iframeDocument.getElementById("grid_"+SubCategoryID+"_auth_code_"+cardCounter).value=ResponseList[3];
								iframeDocument.getElementById("grid_"+SubCategoryID+"_status_"+cardCounter).value=status;
								iframeDocument.getElementById("grid_"+SubCategoryID+"_Approval_cd_"+cardCounter).value=ApprovalID;
								iframeDocument.getElementById("grid_"+SubCategoryID+"_tran_req_uid_"+cardCounter).value=TransReqUID;
								
								var gridBundleValue = iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundle_"+cardCounter).value;		
							
								var arrElementData=gridBundleValue.split('~');
								var arrModElementData = "";
								for (z=0;z<arrElementData.length;z++)
								{
									var strElementName=arrElementData[z].substring(0,arrElementData[z].indexOf(":"));
									var strElementColumnValue=arrElementData[z].substring(arrElementData[z].indexOf(":")+1);
									var arrElementName=strElementName.split('#');
									
									var arrElementColumnValue=strElementColumnValue.split('#');				
									var columnName=arrElementColumnValue[0];
									var columnValue=arrElementColumnValue[1];	
									if(columnName==SubCategoryID+"_auth_code"){
										columnValue=ResponseList[3];
									}else if (columnName==SubCategoryID+"_status"){
										columnValue=status;
									}else if (columnName==SubCategoryID+"_Approval_cd"){
										columnValue=ResponseList[1];
									}else if (columnName==SubCategoryID+"_tran_req_uid"){
										columnValue=ResponseList[4];
									}
									arrElementColumnValue[0]=columnName;
									arrElementColumnValue[1]=columnValue;	
									strElementColumnValue=arrElementColumnValue.join("#");
									arrModElementData+=strElementName+":"+strElementColumnValue;
									if(z!=arrElementData.length-1)
									{
										arrModElementData+="~";
									}
								}
								
								iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundle_"+cardCounter).value=arrModElementData;
							
								messageBalanceTransfer+="Amount "+arrBTAmount[cardCounter].replace(/^\s+|\s+$/gm,'')+" for Card No "+arrCardNumber[cardCounter].replace(/^\s+|\s+$/gm,'')+" could not be blocked. "+'\n';
								noOfTimesFailed++;
							}
						}
						
					}
					
					customform.document.getElementById("wdesk:IntegrationStatus").value='false';
					{
						if(customform.document.getElementById("wdesk:IntegrationStatus").value=='false') // prateek
						{
							iframeDocument.getElementById('4_ccc_required').disabled=true;
							iframeDocument.getElementById("Check Card Eligibility").disabled=true;	
							iframeDocument.getElementById("CARD DETAILS_Modify").disabled=true;	
							iframeDocument.getElementById("CARD DETAILS_Clear").disabled=true;	

							iframeDocument.getElementById("4_sub_ref_no").disabled=true;
							iframeDocument.getElementById("4_rakbank_eligible_card_no").disabled=true;
							iframeDocument.getElementById("4_ccc_amt_req").disabled=true;
							iframeDocument.getElementById("4_beneficiary_name").disabled=true;
							iframeDocument.getElementById("4_payment_by").disabled=true;
							iframeDocument.getElementById("4_delivery_channel").disabled=true;
							iframeDocument.getElementById("4_branch_name").disabled=true;
							iframeDocument.getElementById("4_remarks").disabled=true;
							iframeDocument.getElementById("4_marketing_code").disabled=true;
							iframeDocument.getElementById("Check CCC Eligibility").disabled=true;

							iframeDocument.getElementById("CREDIT CARD CHEQUE DETAILS_Add").disabled=true;	
							iframeDocument.getElementById("CREDIT CARD CHEQUE DETAILS_Modify").disabled=true;	
							iframeDocument.getElementById("CREDIT CARD CHEQUE DETAILS_Delete").disabled=true;	
							iframeDocument.getElementById("CREDIT CARD CHEQUE DETAILS_Clear").disabled=true;		
						
						}
					
					}
					
					
					var modArrAuthCode=arrAuthCode.join("@");
					objAuthDetails["auth_code"]=modArrAuthCode;
					
					var modArrAuthStatus=arrAuthStatus.join("@");
					objAuthDetails["status"]=modArrAuthStatus;
					
					var modArrTransReqUID=arrTransReqUID.join("@");
					objAuthDetails["tran_req_uid"]=modArrTransReqUID;
					
					var modArrApprovalID=arrApprovalID.join("@");
					objAuthDetails["Approval_cd"]=modArrApprovalID;
					
					iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value=JSON.stringify(objAuthDetails);
					
					var selGridBundleWIDATA = JSON.stringify(objAuthDetails);					
					
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/^\s+|\s+$/gm,'');
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/":"/gm,'#');
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/","/gm,'~');
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/{"/gm,'');
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/"}/gm,'');
					
					iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundle_WIDATA").value = selGridBundleWIDATA;



										
					if(postIntegrationAlertFlag)
					{
						alert("Case will be lying at PBO queue. Action to be taken for all the cards.");
						return 'false$$false';
					}
					
					if(noOfTimesFailed==0)
					{
						integrationResultMessage=messageBalanceTransfer+'\n'+'Case would be submitted.';
						integrationResultMessage='true'+'$$'+integrationResultMessage;
						
					}
					else{
						integrationResultMessage=messageBalanceTransfer+'\n'+'Case would not be submitted.';
						integrationResultMessage='false'+'$$'+integrationResultMessage;
						
					}
					
				}
			}
		
		
		if(CategoryID==1 && SubCategoryID==5)
			{
				if(IsDoneClicked && WSNAME=="PBO" )
				{
					var selJSONGridWIData = iframeDocument.getElementById("SMART CASH DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
					var obj = JSON.parse(selJSONGridWIData);
					
					var CardNumber = "";
					var CustId = iframeDocument.getElementById(SubCategoryID+"_cif").value;
					var AuthCode="";
					var AuthStatus="";
					var TransReqUID="";
					var ApprovalID="";
					
					var modifiedListBundle = "";
					RequestType="FUND_BLOCK_ON_CREDIT_CARD";
					
					CardNumber = obj['rakbank_eligible_card_no'];
					if(CardNumber=='' || CardNumber==' '){
						CardNumber = "";
					}else{
						CardNumber = CardNumber.replace("@"," @ ");
					}
					var arrCardNumber = CardNumber.split("@");		
					
					var Remarks = obj["remarks"];
					Remarks  = Remarks.replace("@"," @ ");
					var arrRemarks = Remarks.split("@");

					var noOfElements = arrCardNumber.length;
					
					//code added to pass Merchant code in fund block call for CCC
					var MarketingCode = obj["marketing_code"];
					var arrMerchantCode = MarketingCode.split("@");
					for(var c =0; c<noOfElements; c++)
					{
						if(arrMerchantCode[c]=='SEC' || arrMerchantCode[c]=='TPC')
							arrMerchantCode[c]='0400';
						else
							arrMerchantCode[c]='0200';
					}
					
					if(CardNumber=='$-$'){
						alert("No card selected. Please select a card to process."); // PG012
						return false;
					}else{
						//
					}
					var selJSONGridAuthDetailsWIData = iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
					var objAuthDetails = JSON.parse(selJSONGridAuthDetailsWIData);
					AuthCode = objAuthDetails["auth_code"];
					AuthCode  = AuthCode .replace("@"," @ ");
					var arrAuthCode = AuthCode.split("@");
					AuthStatus = objAuthDetails["status"];
					AuthStatus  = AuthStatus .replace("@"," @ ");
					var arrAuthStatus = AuthStatus.split("@");
					
					TransReqUID = objAuthDetails["tran_req_uid"];
					TransReqUID  = TransReqUID .replace("@"," @ ");
					var arrTransReqUID = AuthCode.split("@");
					ApprovalID = objAuthDetails["Approval_cd"];
					ApprovalID  = ApprovalID .replace("@"," @ ");
					var arrApprovalID = ApprovalID.split("@");
					
					
					
					
					BTAmount = objAuthDetails["sc_amount"];
					BTAmount  = BTAmount .replace("@"," @ ");
					var arrBTAmount = BTAmount.split("@");

					var CardDetailsJSON_WIDATA = iframeDocument.getElementById("CARD DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
					var objCardDetails = JSON.parse(CardDetailsJSON_WIDATA);
					var cardNo = objCardDetails["card_no"];
					cardNo  = cardNo.replace("@"," @ ");
					var arrCardNo = cardNo.split("@");

					var CRNNo = objCardDetails["crn_no"];
					CRNNo  = CRNNo.replace("@"," @ ");
					var arrCRNNo = CRNNo.split("@");
					var AuthCRNNo = '';

					var ExpiryDate = objCardDetails["expiry"];
					ExpiryDate  = ExpiryDate.replace("@"," @ ");
					var arrExpiryDate = ExpiryDate.split("@");
					var AuthExpiryDate = '';


					var typeOfBlock = '';
					var messageBalanceTransfer = '';
					var ajexResponse = '';
					var noOfTimesFailed=0;
					var noOfCardsToBlock=0;
					
					
					var manualBlockStatus="";
					var postIntegrationAlertFlag="";
					
					manualBlockStatus = objAuthDetails['manual_blocking_action'];
					
					var arrManualBlockStatus = manualBlockStatus.split("@");	
					
					for(var cardCounter = 0 ;  cardCounter<noOfElements; cardCounter++)
					{

						if(arrAuthStatus[cardCounter].replace(/^\s+|\s+$/gm,'')=='' && (arrManualBlockStatus[cardCounter].replace(/^\s+|\s+$/gm,'')=='' || arrManualBlockStatus[cardCounter].replace(/^\s+|\s+$/gm,'')=='No Action') && customform.document.getElementById("wdesk:IntegrationStatus").value=='false' && arrAuthCode[cardCounter].replace(/^\s+|\s+$/gm,'')!='')
						{

							postIntegrationAlertFlag=true;

							break;
						}
					}
					
					
					
					for(var cardCounter = 0 ;  cardCounter<noOfElements; cardCounter++)
					{
						if(customform.document.getElementById("wdesk:IntegrationStatus").value=='false')
						break;
						
						if(arrAuthCode[cardCounter].replace(/^\s+|\s+$/gm,'')=='')
						{
							noOfCardsToBlock++;
							
							for(var i=0;i<arrCardNo.length;i++){
								if(arrCardNo[i].replace(/^\s+|\s+$/gm,'')==arrCardNumber[cardCounter].replace(/^\s+|\s+$/gm,'')){
									AuthCRNNo = arrCRNNo[i];
									AuthExpiryDate = arrExpiryDate[i];
								}
							}	
							
							ajexResponse = callBlockAmt(arrCardNumber[cardCounter].replace(/^\s+|\s+$/gm,''),CustId,AuthCRNNo.replace(/^\s+|\s+$/gm,''),AuthExpiryDate.replace(/^\s+|\s+$/gm,''),ProcessInstanceId,arrRemarks[cardCounter].replace(/^\s+|\s+$/gm,''),RequestType,arrBTAmount[cardCounter].replace(/^\s+|\s+$/gm,''),arrMerchantCode[cardCounter],customform,tr_table);
							
							ResponseList = ajexResponse.split("~");
						
							var response=ResponseList[0];
							var AuthCode=ResponseList[3];
							var status = ResponseList[2];
							var ApprovalID=ResponseList[1];	
							var TransReqUID=ResponseList[4];

							if(response=='0000'){
								arrAuthCode[cardCounter]=ResponseList[3];
								arrAuthStatus[cardCounter]=status;
								
								arrTransReqUID[cardCounter]=TransReqUID;
								arrApprovalID[cardCounter]=ApprovalID;
								
								iframeDocument.getElementById("grid_"+SubCategoryID+"_auth_code_"+cardCounter).value=ResponseList[3];
								iframeDocument.getElementById("grid_"+SubCategoryID+"_status_"+cardCounter).value=status;
								iframeDocument.getElementById("grid_"+SubCategoryID+"_Approval_cd_"+cardCounter).value=ApprovalID;
								iframeDocument.getElementById("grid_"+SubCategoryID+"_tran_req_uid_"+cardCounter).value=TransReqUID;

								
								var gridBundleValue = iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundle_"+cardCounter).value;		
						
								var arrElementData=gridBundleValue.split('~');
								var arrModElementData = "";
								for (z=0;z<arrElementData.length;z++)
								{
									var strElementName=arrElementData[z].substring(0,arrElementData[z].indexOf(":"));
									var strElementColumnValue=arrElementData[z].substring(arrElementData[z].indexOf(":")+1);
									var arrElementName=strElementName.split('#');
									
									var arrElementColumnValue=strElementColumnValue.split('#');				
									var columnName=arrElementColumnValue[0];
									var columnValue=arrElementColumnValue[1];	
									if(columnName==SubCategoryID+"_auth_code"){
										columnValue=ResponseList[3];
									}else if (columnName==SubCategoryID+"_status"){
										columnValue=status;
									}else if (columnName==SubCategoryID+"_Approval_cd"){
										columnValue=ApprovalID;
									}else if (columnName==SubCategoryID+"_tran_req_uid"){
										columnValue=TransReqUID;
									}									
									
									arrElementColumnValue[0]=columnName;
									arrElementColumnValue[1]=columnValue;	
									strElementColumnValue=arrElementColumnValue.join("#");
									arrModElementData+=strElementName+":"+strElementColumnValue;
									if(z!=arrElementData.length-1)
									{
										arrModElementData+="~";
									}
								}
								
								iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundle_"+cardCounter).value=arrModElementData;
								messageBalanceTransfer+="Amount "+arrBTAmount[cardCounter].replace(/^\s+|\s+$/gm,'')+" for Card No "+arrCardNumber[cardCounter].replace(/^\s+|\s+$/gm,'')+" has been blocked. Auth Code is "+ ResponseList[3]+'\n';


							}else
							{
								//code added to disable the authorization grid fields till the point radio button is clicked
								
								iframeDocument.getElementById("5_sub_ref_no_auth").disabled=true;
								iframeDocument.getElementById("5_card_no").disabled=true;
								iframeDocument.getElementById("5_auth_code").disabled=true;
								iframeDocument.getElementById("5_status").disabled=true;
								iframeDocument.getElementById("5_sc_amount").disabled=true;
								

								arrAuthCode[cardCounter]=ResponseList[3];
								arrAuthStatus[cardCounter]=status;
								
								arrTransReqUID[cardCounter]=TransReqUID;
								arrApprovalID[cardCounter]=ApprovalID;
								
								iframeDocument.getElementById("grid_"+SubCategoryID+"_auth_code_"+cardCounter).value=ResponseList[3];
								iframeDocument.getElementById("grid_"+SubCategoryID+"_status_"+cardCounter).value=status;
								iframeDocument.getElementById("grid_"+SubCategoryID+"_Approval_cd_"+cardCounter).value=ApprovalID;
								iframeDocument.getElementById("grid_"+SubCategoryID+"_tran_req_uid_"+cardCounter).value=TransReqUID;
								
								var gridBundleValue = iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundle_"+cardCounter).value;		
							
								var arrElementData=gridBundleValue.split('~');
								var arrModElementData = "";
								for (z=0;z<arrElementData.length;z++)
								{
									var strElementName=arrElementData[z].substring(0,arrElementData[z].indexOf(":"));
									var strElementColumnValue=arrElementData[z].substring(arrElementData[z].indexOf(":")+1);
									var arrElementName=strElementName.split('#');
									
									var arrElementColumnValue=strElementColumnValue.split('#');				
									var columnName=arrElementColumnValue[0];
									var columnValue=arrElementColumnValue[1];	
									if(columnName==SubCategoryID+"_auth_code"){
										columnValue=ResponseList[3];
									}else if (columnName==SubCategoryID+"_status"){
										columnValue=status;
									}else if (columnName==SubCategoryID+"_Approval_cd"){
										columnValue=ResponseList[1];
									}else if (columnName==SubCategoryID+"_tran_req_uid"){
										columnValue=ResponseList[4];
									}
									arrElementColumnValue[0]=columnName;
									arrElementColumnValue[1]=columnValue;	
									strElementColumnValue=arrElementColumnValue.join("#");
									arrModElementData+=strElementName+":"+strElementColumnValue;
									if(z!=arrElementData.length-1)
									{
										arrModElementData+="~";
									}
								}
								
								iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundle_"+cardCounter).value=arrModElementData;
							
								messageBalanceTransfer+="Amount "+arrBTAmount[cardCounter].replace(/^\s+|\s+$/gm,'')+" for Card No "+arrCardNumber[cardCounter].replace(/^\s+|\s+$/gm,'')+" could not be blocked. "+'\n';
								noOfTimesFailed++;
							}
						}
						
					}
					
					customform.document.getElementById("wdesk:IntegrationStatus").value='false';
					{
						if(customform.document.getElementById("wdesk:IntegrationStatus").value=='false') // prateek
						{
							iframeDocument.getElementById('5_sc_required').disabled=true;
							iframeDocument.getElementById("Check Card Eligibility").disabled=true;	
							iframeDocument.getElementById("CARD DETAILS_Modify").disabled=true;	
							iframeDocument.getElementById("CARD DETAILS_Clear").disabled=true;	

							iframeDocument.getElementById("5_sub_ref_no").disabled=true;
							iframeDocument.getElementById("5_rakbank_eligible_card_no").disabled=true;
							iframeDocument.getElementById("5_sc_amt_req").disabled=true;
							iframeDocument.getElementById("5_beneficiary_name").disabled=true;
							iframeDocument.getElementById("5_type_of_smc").disabled=true;
							iframeDocument.getElementById("5_payment_by").disabled=true;
							iframeDocument.getElementById("5_delivery_channel").disabled=true;
							iframeDocument.getElementById("5_branch_name").disabled=true;
							iframeDocument.getElementById("5_remarks").disabled=true;
							iframeDocument.getElementById("5_marketing_code").disabled=true;
							iframeDocument.getElementById("Check SMC Eligibility").disabled=true;
							iframeDocument.getElementById("5_RakbankAccountNO").disabled=true;
							iframeDocument.getElementById("5_other_bank_iban").disabled=true;

							iframeDocument.getElementById("SMART CASH DETAILS_Add").disabled=true;	
							iframeDocument.getElementById("SMART CASH DETAILS_Modify").disabled=true;	
							iframeDocument.getElementById("SMART CASH DETAILS_Delete").disabled=true;	
							iframeDocument.getElementById("SMART CASH DETAILS_Clear").disabled=true;		
						
						}
					
					}
					
					
					var modArrAuthCode=arrAuthCode.join("@");
					objAuthDetails["auth_code"]=modArrAuthCode;
					
					var modArrAuthStatus=arrAuthStatus.join("@");
					objAuthDetails["status"]=modArrAuthStatus;
					
					var modArrTransReqUID=arrTransReqUID.join("@");
					objAuthDetails["tran_req_uid"]=modArrTransReqUID;
					
					var modArrApprovalID=arrApprovalID.join("@");
					objAuthDetails["Approval_cd"]=modArrApprovalID;
					
					iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value=JSON.stringify(objAuthDetails);
					
					var selGridBundleWIDATA = JSON.stringify(objAuthDetails);					
					
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/^\s+|\s+$/gm,'');
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/":"/gm,'#');
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/","/gm,'~');
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/{"/gm,'');
					selGridBundleWIDATA = selGridBundleWIDATA.replace(/"}/gm,'');
					
					iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundle_WIDATA").value = selGridBundleWIDATA;



										
					if(postIntegrationAlertFlag)
					{
						alert("Case will be lying at PBO queue. Action to be taken for all the cards.");
						return 'false$$false';
					}
					
					if(noOfTimesFailed==0)
					{
						integrationResultMessage=messageBalanceTransfer+'\n'+'Case would be submitted.';
						integrationResultMessage='true'+'$$'+integrationResultMessage;
						
					}
					else{
						integrationResultMessage=messageBalanceTransfer+'\n'+'Case would not be submitted.';
						integrationResultMessage='false'+'$$'+integrationResultMessage;
						
					}
					
				}
			}
		
		return integrationResultMessage;	
}

function computeWIDATA(iframe, SubCategoryID,WSNAME,IsDoneClicked,CategoryID,fobj)
{	
	var customform='';
	customform=fobj;	
			
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	var WIDATA="";
	var myname;
	var tr_table;
	var eleValue;
	var eleName;
	var eleName2;
	var check;
	var inputs = iframeDocument.getElementsByTagName("input");
	var textareas = iframeDocument.getElementsByTagName("textarea");
	var selects = iframeDocument.getElementsByTagName("select");
	
	var WSNAME = iframeDocument.getElementById("WS_NAME").value;
	var intCallStatus = "";
	
	if(WSNAME=='PBO')
		 intCallStatus = customform.document.getElementById("wdesk:IntegrationStatus").value;
	else
		intCallStatus="false";
	
	var store="";
	try{
		for (x=0;x<inputs.length;x++)
		{
			
			if(!(inputs[x].type=='radio')) 
			{
				eleName2 = inputs[x].getAttribute("name");
				
				if(eleName2==null)
					continue;
				eleName2+="#";
				var temp=eleName2.split('#');
				var IsRepeatable=temp[4];
				myname = inputs[x].getAttribute("id");
			}
			else
			{
				eleName2 = inputs[x].getAttribute("id");
				
				if(eleName2==null)
					continue;
				eleName2+="#";
				var temp=eleName2.split('#');
				var IsRepeatable=temp[4];
				myname = inputs[x].getAttribute("name");
			}
			
			
			
			if(myname==null)
				continue;
			if(myname.indexOf(SubCategoryID+"_")!=0)
			{
				if((inputs[x].type=='hidden'))
				{
					
					if(myname.indexOf(SubCategoryID+"_gridbundle_WIDATA")>-1)
					{
						var temp = CustomEncodeURI(iframeDocument.getElementById(myname).value);
											
						if(SubCategoryID=='3')						
						{
							var cardNoOrg = temp.substring(temp.indexOf("card_number#"),temp.length);
							cardNoOrg=cardNoOrg.substring(0,cardNoOrg.indexOf("~"));
							if(intCallStatus=="false")
							{
								cardNoOrg = "~"+cardNoOrg;
								
								var maskedCardNoData = temp.substring(temp.indexOf("masked_card_no#"),temp.length);
									maskedCardNoData="~"+maskedCardNoData.substring(0,maskedCardNoData.indexOf("~"));
									temp=temp.replace(cardNoOrg, "");
									temp=temp.replace(maskedCardNoData, "");
							}
							else
							{
								var cardNoOrgData = cardNoOrg;
								var cardNoColumnName = cardNoOrgData.substring(0,cardNoOrgData.indexOf("#")+1);
								cardNoOrgData = cardNoOrgData.substring(cardNoOrgData.indexOf("#")+1, cardNoOrgData.length);
								
								
								var arrCardNoOrgData = cardNoOrgData.split("@");
								
								var CardNoOrgData="";
								var finalMaskCardNoData="";
								for(var i=0; i <arrCardNoOrgData.length ; i++)
								{
									
									if(arrCardNoOrgData.length-i==1)
									{
										if(WSNAME=='PBO')
											finalMaskCardNoData =finalMaskCardNoData+maskCardNo(arrCardNoOrgData[i]);
										
										arrCardNoOrgData[i] = Encrypt(arrCardNoOrgData[i]);
										
									}
									else
									{
										if(WSNAME=='PBO')
											finalMaskCardNoData = finalMaskCardNoData+maskCardNo(arrCardNoOrgData[i])+ "@";
										
										arrCardNoOrgData[i] = Encrypt(arrCardNoOrgData[i]) + "@";
									}
									
									CardNoOrgData = CardNoOrgData+arrCardNoOrgData[i];
								}
															
								CardNoOrgData =cardNoColumnName+ CardNoOrgData;
								temp=temp.replace(cardNoOrg, CardNoOrgData);
										
								if(WSNAME=='PBO')
								{
									var maskedCardNoData = temp.substring(temp.indexOf("masked_card_no#"),temp.length);
									maskedCardNoData=maskedCardNoData.substring(0,maskedCardNoData.indexOf("~"));
									var tst = maskedCardNoData;
									var maskCardNoColumnName = tst.substring(0,tst.indexOf("#")+1);
									var arrStr2 ;																
									finalMaskCardNoData = maskCardNoColumnName+finalMaskCardNoData;
									temp=temp.replace(maskedCardNoData, finalMaskCardNoData);
								}
							}
						}
						
						WIDATA+=temp+"~";

					}
					continue;
				}
			}
			
			if(IsRepeatable!='Y')
			{
				if(myname.indexOf(SubCategoryID+"_")==0)
				{
					if((inputs[x].type=='radio')) 
					{	
						eleName = inputs[x].getAttribute("name");
						if(store!=eleName)
						{
							store=eleName;
							var ele = iframeDocument.getElementsByName(eleName);
							for(var i = 0; i < ele.length; i++)
							{	
								eleName2=ele[i].id;
								eleName2+="#radio";
								if(ele[i].checked)
								{
									eleValue = encodeURIComponent(ele[i].value);
									WIDATA+=eleName.substring(2)+"#"+eleValue+"~";
									counthash++;
								}
								
							}	
						}
						
					}
					else if((inputs[x].type=='checkbox'))
					{	

						eleName2 = inputs[x].getAttribute("name");
						eleName2+="#";
						var temp=eleName2.split('#');
						var is_workstep_req=temp[3];
						var IsRepeatable=temp[4];
						if(iframeDocument.getElementById(myname).value=='')
						{	WIDATA+=myname.substring(2)+"#NULL"+"~";
							
						}
						else
						{	if (iframeDocument.getElementById(myname).checked)
							{
								if(is_workstep_req=='Y')
									WIDATA+=myname.substring(2)+"#"+WSNAME+"$"+"true"+"~";
								else
									WIDATA+=myname.substring(2)+"#"+"true"+"~";
							} else {
								if(is_workstep_req=='Y')
									WIDATA+=myname.substring(2)+"#"+WSNAME+"$"+"false"+"~";
								else
									WIDATA+=myname.substring(2)+"#"+"false"+"~";
							}
						}
						
					}
					else if(!(inputs[x].type=='radio'))
					{	
						eleName2 = inputs[x].getAttribute("name");
						eleName2+="#";
						var temp=eleName2.split('#');
						var is_workstep_req=temp[3];
						var IsRepeatable=temp[4];
						if(iframeDocument.getElementById(myname).value=='')
						{	
							WIDATA+=myname.substring(2)+"#NULL"+"~";
							counthash++;
						}
						else
						{	
							if(is_workstep_req=='Y')
							{
								{
									WIDATA+=myname.substring(2)+"#"+WSNAME+"$"+encodeURIComponent(iframeDocument.getElementById(myname).value)+"~";
									counthash++;
								}
							}	
							else
							{
								WIDATA+=myname.substring(2)+"#"+encodeURIComponent(iframeDocument.getElementById(myname).value)+"~";
								counthash++;
							}	
						}						
					}				
				}				
			}
			//Added by Aishwarya 14thApril2014
			else if(myname.indexOf("tr_")==0)
			{
				tr_table = iframeDocument.getElementById(myname).value;
			}			
		}		
	}catch(err){
		exception=true; 
		exceptionstring=exceptionstring+"textboxexception:"; 
		return;
	}
	try{
	for (x=0;x<textareas.length;x++)
	{
		eleName2 = textareas[x].getAttribute("name");
		if(eleName2==null)
			continue;
		eleName2+="#";
		var temp=eleName2.split('#');
		var IsRepeatable=temp[4];
		myname = textareas[x].getAttribute("id");
		if(myname==null)
			continue;
		if(IsRepeatable!='Y'){
			if(myname.indexOf(SubCategoryID+"_")==0)
			{
				eleName2 = textareas[x].getAttribute("name");
				var temp=eleName2.split('#');
				var is_workstep_req=temp[3];
				var IsRepeatable=temp[4];
				if(iframeDocument.getElementById(myname).value=='')
				WIDATA+=myname.substring(2)+"#NULL"+"~";
				else
				{
					if(is_workstep_req=='Y')
					{
						WIDATA+=myname.substring(2)+"#"+WSNAME+"$"+encodeURIComponent(iframeDocument.getElementById(myname).value)+"~";
					}
					else
					{
						WIDATA+=myname.substring(2)+"#"+encodeURIComponent(iframeDocument.getElementById(myname).value)+"~";
					}
				}
			}
		}
    }
	}catch(err){exception=true; exceptionstring+= "textareaexception:"; return;}
	try{
	for (x=0;x<selects.length;x++)
	{	
		eleName2 = selects[x].getAttribute("name");
		if(eleName2==null)
			continue;
		eleName2+="#select";
		myname = selects[x].getAttribute("id");
		if(myname==null)
			continue;
		var temp=eleName2.split('#');
		var is_workstep_req=temp[3];
		var IsRepeatable=temp[4];
		var e = iframeDocument.getElementById(myname);
		if(IsRepeatable!='Y')
		{
		
			if(e.selectedIndex!=-1)
			{
				var Value = e.options[e.selectedIndex].value;
				if(myname.indexOf(SubCategoryID+"_")==0)
				{
					if(Value=='--Select--')
					{	
						WIDATA+=myname.substring(2)+"#NULL"+"~";
						
					}	
					else
					{
						if(is_workstep_req=='Y')
						{
							WIDATA+=myname.substring(2)+"#"+WSNAME+"$"+encodeURIComponent(Value)+"~";
						}	
						else
						{
							WIDATA+=myname.substring(2)+"#"+encodeURIComponent(Value)+"~";
						}
						
					}
				}
			}	
		}
    }
	}catch(err){exception=true; exceptionstring+= "selectexception:";return;}
	if(IsDoneClicked && CategoryID=='1' && SubCategoryID=='1' && (WSNAME=='Q1' || WSNAME=='Q2' || WSNAME=='Q3') && (WIDATA.indexOf("Decision")==-1))
	{
		try{
			var declinereasonfromform="Decline_Reason#NULL";
			
			var decisionfromform = "";
			if(iframeDocument.getElementById("1_Decision")!=null && iframeDocument.getElementById("1_Decision").value!=null && iframeDocument.getElementById("1_Decision").value!='')
			{
				decisionfromform = encodeURIComponent(iframeDocument.getElementById("1_Decision").value);
				if(decisionfromform=='Reject' && (WIDATA.indexOf("Decline_Reason")==-1))
				{				
					if(iframeDocument.getElementById("1_Decline_Reason")!=null && iframeDocument.getElementById("1_Decline_Reason").value!=null && iframeDocument.getElementById("1_Decline_Reason").value!='')
					{
						declinereasonfromform = "Decline_Reason#"+WSNAME+"$"+encodeURIComponent(iframeDocument.getElementById("1_Decline_Reason").value)+"~";
					}
					else
					{
						exception=true;
						exceptionstring+= "decisionsaveexception1:";
						return;
					}
				}
				if(WIDATA.charAt(WIDATA.length-1)=='~')
					WIDATA = WIDATA + 'Decision#'+WSNAME+"$"+decisionfromform+"~"+declinereasonfromform;
				else
					WIDATA = WIDATA + '~Decision#'+WSNAME+"$"+decisionfromform+"~"+declinereasonfromform;
				counthash=counthash+2;
				decisionsaved = 'N';
			}
			else
			{
				exception=true;
				exceptionstring+= "decisionsaveexception2:";
				return;
			}
			
		}
		catch(err)
		{
			alert("Exception in saving the decision on form. Please contact administrator.");
			exception=true;
			exceptionstring+= "decisionsaveexception1:";
			return;
		}
		
	}	
	//code added for encryption and masking of card numbers in BT/CCC
	if(CategoryID==1 && SubCategoryID==4 )
	{
		if(intCallStatus=="false")
		{
			var splitWIDATA = WIDATA.split("~");
			for(var i=0; i<splitWIDATA.length; i++)
			{
				if(splitWIDATA[i].indexOf('card_number#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				else if(splitWIDATA[i].indexOf('card_no#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				else if(splitWIDATA[i].indexOf('card_no_1#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				else if(splitWIDATA[i].indexOf('rakbank_eligible_card_no#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				else if(splitWIDATA[i].indexOf('card_no_masked#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				else if(splitWIDATA[i].indexOf('card_number_masked#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				if(splitWIDATA[i].indexOf('card_no_1_masked#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				if(splitWIDATA[i].indexOf('rak_elig_card_masked#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
			}
		}
		else
		{
			var encryptedcardmap = iframeDocument.getElementById('encryptedmap').value;
			var obj = JSON.parse(encryptedcardmap);
			//alert('CCC->'+WIDATA+"hello");
			var wiDataElements=WIDATA.split("~");
			var encryptedStringToSave="";
			var maskedStringToSave="";
			var colNameValue="";
			var cardNumbers="";
			var cardNumbersForMasking="";
			var org_card_number="";
			var org_card_no="";
			var org_card_no_1="";
			var org_rak_elig_cardno="";
			//block to replace actual card numbers with masked values
			for(var counter=0; counter<wiDataElements.length; counter++)
			{
				colNameValue=wiDataElements[counter].split("#");
				if(colNameValue[0]=='card_number' || colNameValue[0]=='card_no' || colNameValue[0]=='card_no_1' || colNameValue[0]=='rakbank_eligible_card_no')
				{
					encryptedStringToSave="";
					if(colNameValue[0]=='card_number')
						org_card_number=colNameValue[1];
					else if(colNameValue[0]=='card_no')
						org_card_no=colNameValue[1];
					else if(colNameValue[0]=='card_no_1')
						org_card_no_1=colNameValue[1];
					else if(colNameValue[0]=='rakbank_eligible_card_no')
						org_rak_elig_cardno=colNameValue[1];
					
					cardNumbers=colNameValue[1].split("@");
					for(var c =0; c<cardNumbers.length; c++)
					{
						encryptedStringToSave+=obj[cardNumbers[c]]+'@';
					}
					encryptedStringToSave=encryptedStringToSave.substring(0,encryptedStringToSave.lastIndexOf('@'));
					colNameValue[1]=encryptedStringToSave;
				}
				colNameValue=colNameValue.join("#");
				wiDataElements[counter]=colNameValue;
			}
			//block to add masking values to hidden cols
			for(var counter=0; counter<wiDataElements.length; counter++)
			{
				colNameValue=wiDataElements[counter].split("#");
				if(colNameValue[0]=='card_no_masked' || colNameValue[0]=='card_number_masked' || colNameValue[0]=='card_no_1_masked' || colNameValue[0]=='rak_elig_card_masked')
				{
					maskedStringToSave="";
					
					if(colNameValue[0]=='card_no_masked')
						cardNumbersForMasking=org_card_no.split("@");
					else if(colNameValue[0]=='card_number_masked')
						cardNumbersForMasking=org_card_number.split("@");
					else if(colNameValue[0]=='card_no_1_masked')
						cardNumbersForMasking=org_card_no_1.split("@");
					else if(colNameValue[0]=='rak_elig_card_masked')
						cardNumbersForMasking=org_rak_elig_cardno.split("@");
						
					for(var c =0; c<cardNumbersForMasking.length; c++)
					{
						maskedStringToSave+=maskCardNo(cardNumbersForMasking[c])+'@';
					}
					maskedStringToSave=maskedStringToSave.substring(0,maskedStringToSave.lastIndexOf('@'));
					colNameValue[1]=maskedStringToSave;
				}
				colNameValue=colNameValue.join("#");
				wiDataElements[counter]=colNameValue;
			}
			WIDATA = wiDataElements.join("~");
		}
	}
	
	else if(CategoryID==1 && SubCategoryID==5 )
	{
	
		//alert("inside function");
		if(intCallStatus=="false")
		{	
			var splitWIDATA = WIDATA.split("~");
			for(var i=0; i<splitWIDATA.length; i++)
			{
				if(splitWIDATA[i].indexOf('card_number#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");	
				else if(splitWIDATA[i].indexOf('card_no#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				else if(splitWIDATA[i].indexOf('card_no_1#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				else if(splitWIDATA[i].indexOf('rakbank_eligible_card_no#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				else if(splitWIDATA[i].indexOf('card_no_masked#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				else if(splitWIDATA[i].indexOf('card_number_masked#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				if(splitWIDATA[i].indexOf('card_no_1_masked#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				if(splitWIDATA[i].indexOf('rak_elig_card_masked#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
			}
		}
		else
		{
			//alert("inside else");
			var encryptedcardmap = iframeDocument.getElementById('encryptedmap').value;
			var obj = JSON.parse(encryptedcardmap);
			//alert('SC->'+WIDATA+"hello");
			var wiDataElements=WIDATA.split("~");
			var encryptedStringToSave="";
			var maskedStringToSave="";
			var colNameValue="";
			var cardNumbers="";
			var cardNumbersForMasking="";
			var org_card_number="";
			var org_card_no="";
			var org_card_no_1="";
			var org_rak_elig_cardno="";
			//block to replace actual card numbers with masked values
			for(var counter=0; counter<wiDataElements.length; counter++)
			{
				colNameValue=wiDataElements[counter].split("#");
				if(colNameValue[0]=='card_number' || colNameValue[0]=='card_no' || colNameValue[0]=='card_no_1' || colNameValue[0]=='rakbank_eligible_card_no')
				{
				
				
					encryptedStringToSave="";
					if(colNameValue[0]=='card_number')
						org_card_number=colNameValue[1];
					else if(colNameValue[0]=='card_no')
						org_card_no=colNameValue[1];
					else if(colNameValue[0]=='card_no_1')
						org_card_no_1=colNameValue[1];
					else if(colNameValue[0]=='rakbank_eligible_card_no')
						org_rak_elig_cardno=colNameValue[1];
					
					cardNumbers=colNameValue[1].split("@");
					for(var c =0; c<cardNumbers.length; c++)
					{
						encryptedStringToSave+=obj[cardNumbers[c]]+'@';
					}
					encryptedStringToSave=encryptedStringToSave.substring(0,encryptedStringToSave.lastIndexOf('@'));
					colNameValue[1]=encryptedStringToSave;
				}
				colNameValue=colNameValue.join("#");
				wiDataElements[counter]=colNameValue;
			}
			//block to add masking values to hidden cols
			for(var counter=0; counter<wiDataElements.length; counter++)
			{
				colNameValue=wiDataElements[counter].split("#");
				if(colNameValue[0]=='card_no_masked' || colNameValue[0]=='card_number_masked' || colNameValue[0]=='card_no_1_masked' || colNameValue[0]=='rak_elig_card_masked')
				{
					maskedStringToSave="";
					
					if(colNameValue[0]=='card_no_masked')
						cardNumbersForMasking=org_card_no.split("@");
					else if(colNameValue[0]=='card_number_masked')
						cardNumbersForMasking=org_card_number.split("@");
					else if(colNameValue[0]=='card_no_1_masked')
						cardNumbersForMasking=org_card_no_1.split("@");
					else if(colNameValue[0]=='rak_elig_card_masked')
						cardNumbersForMasking=org_rak_elig_cardno.split("@");
						
					for(var c =0; c<cardNumbersForMasking.length; c++)
					{
						maskedStringToSave+=maskCardNo(cardNumbersForMasking[c])+'@';
					}
					maskedStringToSave=maskedStringToSave.substring(0,maskedStringToSave.lastIndexOf('@'));
					colNameValue[1]=maskedStringToSave;
				}
				colNameValue=colNameValue.join("#");
				wiDataElements[counter]=colNameValue;
			}
			WIDATA = wiDataElements.join("~");
		}
	}
	
	else if(CategoryID==1 && SubCategoryID==2)
	{
		if(intCallStatus=="false")
		{
			var splitWIDATA = WIDATA.split("~");
			for(var i=0; i<splitWIDATA.length; i++)
			{
				if(splitWIDATA[i].indexOf('rak_card_no#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				else if(splitWIDATA[i].indexOf('card_no#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				else if(splitWIDATA[i].indexOf('card_number#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				else if(splitWIDATA[i].indexOf('rakbank_eligible_card_no#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				else if(splitWIDATA[i].indexOf('rak_card_no_masked#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				else if(splitWIDATA[i].indexOf('card_no_masked#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				if(splitWIDATA[i].indexOf('card_number_masked#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
				if(splitWIDATA[i].indexOf('rak_elig_card_masked#')>-1)
					WIDATA = WIDATA.replace(splitWIDATA[i]+'~', "");
			}
		}
		else
		{
			var encryptedcardmap = iframeDocument.getElementById('encryptedmap').value;
			var obj = JSON.parse(encryptedcardmap);
			//alert('BT-->'+WIDATA+"hello");
			var wiDataElements=WIDATA.split("~");
			var encryptedStringToSave="";
			var maskedStringToSave="";
			var colNameValue="";
			var cardNumbers="";
			var cardNumbersForMasking="";
			var org_card_number=""
			var org_card_no=""
			var org_card_no_1=""
			var org_rak_elig_cardno=""
			//block to replace actual card numbers with masked values
			for(var counter=0; counter<wiDataElements.length; counter++)
			{
				colNameValue=wiDataElements[counter].split("#");
				if(colNameValue[0]=='rak_card_no' || colNameValue[0]=='card_no' || colNameValue[0]=='card_number' || colNameValue[0]=='rakbank_eligible_card_no')
				{
					encryptedStringToSave="";
					if(colNameValue[0]=='rak_card_no')
						org_card_number=colNameValue[1];
					else if(colNameValue[0]=='card_no')
						org_card_no=colNameValue[1];
					else if(colNameValue[0]=='card_number')
						org_card_no_1=colNameValue[1];
					else if(colNameValue[0]=='rakbank_eligible_card_no')
						org_rak_elig_cardno=colNameValue[1];
					
					cardNumbers=colNameValue[1].split("@");
					for(var c =0; c<cardNumbers.length; c++)
					{
						encryptedStringToSave+=obj[cardNumbers[c]]+'@';
					}
					encryptedStringToSave=encryptedStringToSave.substring(0,encryptedStringToSave.lastIndexOf('@'));
					colNameValue[1]=encryptedStringToSave;
				}
				colNameValue=colNameValue.join("#");
				wiDataElements[counter]=colNameValue;
			}
			//block to add masking values to hidden cols
			for(var counter=0; counter<wiDataElements.length; counter++)
			{
				colNameValue=wiDataElements[counter].split("#");
				if(colNameValue[0]=='rak_card_no_masked' || colNameValue[0]=='card_no_masked' || colNameValue[0]=='card_number_masked' || colNameValue[0]=='rak_elig_card_masked')
				{
					maskedStringToSave="";
					
					/*if(colNameValue[0]=='rak_card_no_masked')
						cardNumbersForMasking=org_card_no.split("@");
					else if(colNameValue[0]=='card_no_masked')
						cardNumbersForMasking=org_card_number.split("@");*/
						
					if(colNameValue[0]=='rak_card_no_masked')
						cardNumbersForMasking=org_card_number.split("@");
					else if(colNameValue[0]=='card_no_masked')
						cardNumbersForMasking=org_card_no.split("@");
					else if(colNameValue[0]=='card_number_masked')
						cardNumbersForMasking=org_card_no_1.split("@");
					else if(colNameValue[0]=='rak_elig_card_masked')
						cardNumbersForMasking=org_rak_elig_cardno.split("@");
				
					//alert("columnvalue-->"+colNameValue[0]);
					//alert('masked string-->'+maskedStringToSave);
					for(var c =0; c<cardNumbersForMasking.length; c++)
					{
						maskedStringToSave+=maskCardNo(cardNumbersForMasking[c])+'@';
					}
					maskedStringToSave=maskedStringToSave.substring(0,maskedStringToSave.lastIndexOf('@'));
					colNameValue[1]=maskedStringToSave;
				}
				colNameValue=colNameValue.join("#");
				wiDataElements[counter]=colNameValue;
			}
			WIDATA = wiDataElements.join("~");
			//alert("WIDATA :"+WIDATA);
		}
	}	
	//alert("WIDATA :"+WIDATA);
	//return false;
	return WIDATA;	
}

function maskCardNo(cardNo)
{
	cardNo=cardNo.substring(0,6)+"XXXXXX"+cardNo.substring(12,16);
	cardNo=cardNo.substring(0,4)+"-"+cardNo.substring(4,8)+"-"+cardNo.substring(8,12)+"-"+cardNo.substring(12,16);
	
	return cardNo;
}

function myTrim(x) {
    return x.replace(/^\s+|\s+$/gm,'');
}

function callBlockAmt(CardNumber,CustId,AuthCRNNo,AuthExpiryDate,WINAME,AuthRemarks,RequestType,Amount,MerchantCode,customform,tr_table)
{
	
	var SubCategoryID=customform.document.getElementById("SubCategoryID").value;
	var TEMPWINAME=customform.document.getElementById("wdesk:TEMP_WI_NAME").value; // pg0039
	
	var blockUrl="/webdesktop/CustomForms/SRM_Specific/SRMIntegration.jsp";
	var param = "&CardNumber="+CardNumber+"&CustId="+CustId+"&CardCRNNumber="+AuthCRNNo+"&Amount="+Amount+"&CardExpiryDate="+AuthExpiryDate+"&Remarks="+AuthRemarks+"&MerchantCode="+MerchantCode+"&TrnType=Posting&WSNAME=PBO&WS_LogicalName=PBO&CategoryID=1&SubCategoryID="+SubCategoryID+"&IsDoneClicked=N&IsError=N&IsSaved=N&RequestType=FUND_BLOCK_ON_CREDIT_CARD&TEMPWINAME="+TEMPWINAME+"&tr_table="+tr_table+"&WINAME="+WINAME+"";	
		blockUrl=replaceUrlChars(blockUrl);
		
		var ResponseList;	
		var xhr;
		if(window.XMLHttpRequest)
			 xhr=new XMLHttpRequest();
		else if(window.ActiveXObject)
			 xhr=new ActiveXObject("Microsoft.XMLHTTP");
		 xhr.open("POST",blockUrl,false); 
		 xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		 xhr.send(param);				
		if (xhr.status == 200 && xhr.readyState == 4)
		{				
			var ajaxResult=Trim(xhr.responseText);	
		}
		else
		{
			alert("Problem while blocking amount.");
			return false;
		}
		return ajaxResult;
}

String.prototype.replaceAllOccurence = function( token, newToken, ignoreCase ) {
    var _token;
    var str = this + "";
    var i = -1;

    if ( typeof token === "string" ) {

        if ( ignoreCase ) {

            _token = token.toLowerCase();

            while( (
                i = str.toLowerCase().indexOf(
                    token, i >= 0 ? i + newToken.length : 0
                ) ) !== -1
            ) {
                str = str.substring( 0, i ) +
                    newToken +
                    str.substring( i + token.length );
            }

        } else {
            return this.split( token ).join( newToken );
        }

    }
return str;
};

function callBlockCard(CardNumber,CustId,ReasonCode,CardCRN,WINAME,RequestStatus,RequestType,customform,tr_table)
{

	var SubCategoryID=customform.document.getElementById("SubCategoryID").value;
	var TEMPWINAME=customform.document.getElementById("wdesk:TEMP_WI_NAME").value; // pg0039
	if(RequestStatus=='Not Blocked'){
		response = 'Success';
	}else{
		response = 'failure';
	}
			var blockUrl="/webdesktop/CustomForms/SRM_Specific/SRMIntegration.jsp?CardNumber="+CardNumber+"&WINAME="+WINAME+"&CustId="+CustId+"&ReasonCode="+ReasonCode+"&CardCRN="+CardCRN+"&WSNAME=PBO&WS_LogicalName=PBO&CategoryID=1&SubCategoryID="+SubCategoryID+"&IsDoneClicked=Y&IsError=Y&IsSaved=Y"+"&RequestType="+RequestType+"&TEMPWINAME="+TEMPWINAME+"&tr_table="+tr_table+"";
				
				blockUrl=replaceUrlChars(blockUrl);
				
				var ResponseList;	
				var xhr;
				if(window.XMLHttpRequest)
					 xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
					 xhr=new ActiveXObject("Microsoft.XMLHTTP");
				 xhr.open("GET",blockUrl,false); 
				 xhr.send(null);				
				if (xhr.status == 200 && xhr.readyState == 4)
				{				
					var ajaxResult=Trim(xhr.responseText);	
				}
				else
				{
					alert("Problem while blocking cards.");
					return false;
				}
				return ajaxResult;
}

function CustomEncodeURI(data)
{
	return data.split("%").join("CHARPERCENTAGE").split("&").join("CHARAMPERSAND");
}

function validateOnDoneClick() 
{
	var activityName = stractivityName;
	var customform='';
	var formWindow=getWindowHandler(windowList,"formGrid");
	customform=formWindow.frames['customform'];
	var iframe = customform.document.getElementById("frmData");
	
	var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	var SubCategoryID=iframeDocument.getElementById("SubCategoryID").value;
	var CategoryID=iframeDocument.getElementById("CategoryID").value;
	var wiName=customform.document.getElementById("wdesk:WI_NAME").value;
	
	// returning true for Q6_Checker queue as part of OutBound Release
	if(activityName=="Q6" || activityName=="Q5")
	{
		return true;
	}
	
		if(CategoryID==1 && (SubCategoryID==2 || SubCategoryID==4|| SubCategoryID==5))
	{
		if(activityName=="Q1")
		{
			alert("Done is not allowed on this queue as this case will be processed by the utility service.\nPlease save the form and close it.");
			return false;
		}
		
		var selJSONGridAuthDetailsWIData = iframeDocument.getElementById("AUTHORIZATION DETAILS_"+SubCategoryID+"_gridbundleJSON_WIDATA").value;
		var objAuthDetails = JSON.parse(selJSONGridAuthDetailsWIData);

		//alert(objAuthDetails);
		var CardNumber = "";
		var cancelStatus="";
		var capsStatus="";
		var manualUnblockStatus="";
		var postIntegrationAlertFlag="";

		var authStatus="";
		var utilRejectCallStatus="";
		
		if(SubCategoryID==4)
			CardNumber = objAuthDetails['card_no_1'];
		else if(SubCategoryID==2)
			CardNumber = objAuthDetails['card_no'];
		else if(SubCategoryID==5)
			CardNumber = objAuthDetails['card_no_1'];
		var arrCardNumber = CardNumber.split("@");	
		var noOfElements = arrCardNumber.length;
		
		cancelStatus = objAuthDetails["cancel_status"];
		//cancelStatus  = cancelStatus .replace("@"," @ ");
		var arrCancelStatus = cancelStatus.split("@");
		
		
		manualUnblockStatus = objAuthDetails["manual_unblocking_action"];
		//manualUnblockStatus  = manualUnblockStatus .replace("@"," @ ");
		var arrManualUnblockStatus = manualUnblockStatus.split("@");

		capsStatus = objAuthDetails["caps_status"];
		//capsStatus  = capsStatus .replace("@"," @ ");
		var arrCapsStatus = capsStatus.split("@");
		
		authStatus = objAuthDetails["sub_ref_no_auth"];
		//authStatus  = authStatus .replace("@"," @ ");
		var arrAuthStatus = authStatus.split("@");
		//alert(arrAuthStatus.length);
		
		utilRejectCallStatus = objAuthDetails["req_upld_status"];
		//authStatus  = authStatus .replace("@"," @ ");
		var arrUtilRejectCallStatus = utilRejectCallStatus.split("@");
		//alert('failure'+arrUtilRejectCallStatus.length);
		
		var alertOnDoneWorkitem = "";
		var errorDecision="APPROVED";
		var rejectCounter=0;
		
		for(var cardCounter = 0 ;  cardCounter<noOfElements; cardCounter++)
		{
			//alert('rejectcallstatus from utility-->'+arrUtilRejectCallStatus[cardCounter]);
			if(arrCapsStatus[cardCounter]=='ERROR IN CAPS' || arrCapsStatus[cardCounter]=='FAILED')
			
{
				alertOnDoneWorkitem+='Please create another request for Ref No '+wiName+'-'+arrAuthStatus[cardCounter]+'.\n';
			}
			else if(arrCancelStatus[cardCounter].replace(/^\s+|\s+$/gm,'')=='' && (arrManualUnblockStatus[cardCounter].replace(/^\s+|\s+$/gm,'')=='' || arrManualUnblockStatus[cardCounter].replace(/^\s+|\s+$/gm,'')=='No Action') && (arrUtilRejectCallStatus[cardCounter]=='FAILURE' || arrCapsStatus[cardCounter]=='ERROR IN ONLINE'))
			{
				postIntegrationAlertFlag=true;
				break;
			}
			else if(arrCapsStatus[cardCounter]=='ERROR IN ONLINE' || arrCapsStatus[cardCounter]=='REJECTED')
			{
				rejectCounter=rejectCounter+1;
			}
		}


		//alert(alertOnDoneWorkitem);
		if(rejectCounter==noOfElements)
			errorDecision='REJECT';
		if(postIntegrationAlertFlag)
		{

			alert('Cards with CAPS status as ERROR IN ONLINE need to be cancelled before submitting workitem.');
			return false;
		}
		else


		
{
			if(alertOnDoneWorkitem!='')
				alert(alertOnDoneWorkitem);
			//alert('ErrorDecision-->'+errorDecision);
			
			var updateURL="/webdesktop/CustomForms/SRM_Specific/SRMCustomUpdate.jsp?UpdateFor=UpdateErrorDecision&Decision="+errorDecision+"&WINAME="+wiName+"&CategoryID="+CategoryID+"&SubCategoryID="+SubCategoryID;
			
			updateURL=replaceUrlChars(updateURL);			
			var ResponseList;	
			var xhr;
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			 xhr.open("GET",updateURL,false); 
			 xhr.send(null);
					
			if (xhr.status == 200 && xhr.readyState == 4)
			{
				var ajaxResult=Trim1(xhr.responseText);
				ResponseList = ajaxResult.split("~");
				var responseMainCode=ResponseList[0];

				if(responseMainCode=='0'){
					return true;
				}
				else
				{
					alert("Error in Updating Error Decision");
					return false;
				}
			}
			else
			{
				alert("Problem in Updating Error Decision");
				return false;
			}
			
		}
		
	}
	
	return true;
}

function TLSAVEDATA(IsDoneClicked)
		{
		if(processName!='TL')
		return false;
		var WIDATA="";
		var NameData="";
		var myname;
		var tr_table;
		var WS_LogicalName;
		var eleName;
		var eleName2;
		//var inputs = iframeDocument.getElementsByTagName("input");
		//var textareas = iframeDocument.getElementsByTagName("textarea");
		//var selects = iframeDocument.getElementsByTagName("select");
		var store="";
		
		//var iframe = customform.document.getElementById("frmData");
		//var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
		var customform='';
		var formWindow=getWindowHandler(windowList,"formGrid");
		customform=formWindow.frames['customform'];
		var SubCategoryID="1";
		var CategoryID="5";	
		var Category="Trade License";
		var SubCategory="Trade License Request";
		var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
		var WINAME=customform.document.getElementById("wdesk:WI_NAME").value;
		var decision = customform.document.getElementById("wdesk:Decision").value;
		var remarks = customform.document.getElementById("wdesk:Remarks").value;
		var rejectReason = customform.document.getElementById("wdesk:RejectReason").value;
		
		

		

		/*var NewScript=document.createElement('script')
		NewScript.src="/webdesktop/webtop/scripts/TL_Scripts/Validation_TL.js"
		document.body.appendChild(NewScript);*/
		var x=validateTLForm(WSNAME, IsDoneClicked);
		
		
		if(x==false)
		return false;

		var H_Checklist="Yes" ;//customform.document.getElementById("H_Checklist").value;
		var H_RejectReasons="Yes";//customform.document.getElementById("H_RejectReasons").value;
		
		WIDATA="WIDATA";//computeWIDATA_TT(iframe,SubCategoryID,WSNAME);
		
		if(IsDoneClicked) {
				var xhr;
				if(window.XMLHttpRequest)
					 xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
					 xhr=new ActiveXObject("Microsoft.XMLHTTP");
				var abc=Math.random ;

				var url="/webdesktop/CustomForms/TL_Specific/SaveHistory.jsp";     
				url=replaceUrlChars(url);
				var param="WINAME="+WINAME+"&WSNAME="+WSNAME+"&IsDoneClicked="+IsDoneClicked+"&IsSaved=Y&abc="+abc+"&decision="+encodeURIComponent(decision)+"&remarks="+encodeURIComponent(remarks)+"&rejectReason="+encodeURIComponent(rejectReason);
				//var param="WINAME="+WINAME+"&WSNAME="+WSNAME;
				
				xhr.open("POST",url,false);
				xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');		
				xhr.send(param);

				if (xhr.status == 200 && xhr.readyState == 4)
				{
					ajaxResult=Trim(xhr.responseText);
			
					if(ajaxResult == 'NoRecord')
					{
						alert("No record found.");
						return false;
					}
					else if(ajaxResult == 'Error')
					{
						alert("Some problem in creating workitem.");
						return false;
					}
				}
				else
				{
					alert("Problem in saving data savehistory.jsp");
					return false;
				}	
		}
		if(saveClickedTL())		
			return true;
		else
			return false;
}

function TTSAVEDATA(IsDoneClicked)
{
		var processName= strprocessname;
		if(processName!='TT')
			return false;
		var customform='';
		var formWindow=getWindowHandler(windowList,"formGrid");
		customform=formWindow.frames['customform'];
		var SubCategoryID="1";
		var NameData="";
		var WSNAME=customform.document.getElementById("wdesk:WS_NAME").value;
		var WINAME=customform.document.getElementById("wdesk:wi_name").value;
		var workitemId=customform.document.getElementById("workitemId").value;
		var checklistData=customform.document.getElementById("H_CHECKLIST").value;
		var rejectReasons=customform.document.getElementById("rejReasonCodes").value;
		
		var inputs = customform.document.getElementsByTagName("input");
		var textareas = customform.document.getElementsByTagName("textarea");
		var selects = customform.document.getElementsByTagName("select");
		var store="";
		
		
		var H_Checklist="Yes" ;//customform.document.getElementById("H_Checklist").value;
		var H_RejectReasons="Yes";//customform.document.getElementById("H_RejectReasons").value;
		
		for (x=0;x<inputs.length;x++)
		{	
			myname = inputs[x].getAttribute("id");
			if(myname!= "")
			{
				if(!(inputs[x].type=='radio'))
				{	
					eleName2 = inputs[x].getAttribute("name");
					eleName2+="#";
					NameData+=myname+"#"+eleName2+"~";		
				}
			
			}			
		}	

		WIDATA = computeWIDATA_TT(customform.document,SubCategoryID,WSNAME);

		var xhr;
		if(window.XMLHttpRequest)
			 xhr=new XMLHttpRequest();
		else if(window.ActiveXObject)
			 xhr=new ActiveXObject("Microsoft.XMLHTTP");
		var abc=Math.random;

		/* Added by anurag anand 12-Feb-2016 */
		//getNextWorkStep () is in TTvalidate.js
		var nextWS = "";
		if(WSNAME=="OPS_Initiate")
			nextWS="Comp_Check";
		else
			nextWS=getNextWorkStep();
		var url="/webdesktop/CustomForms/TT_Specific/SaveHistory.jsp";
		
		// var param="WINAME="+WINAME+"&WSNAME="+WSNAME+"&WIDATA="+WIDATA+"&checklistData="+checklistData+"&rejectReasons="+rejectReasons+"&IsDoneClicked="+IsDoneClicked+"&IsSaved=Y&abc="+abc;
		
		/* Added by anurag anand 12-Feb-2016 
		   An extra param added to send Next workstep 
		*/
		var param="WINAME="+WINAME+"&WSNAME="+WSNAME+"&WIDATA="+WIDATA+"&checklistData="+checklistData+"&rejectReasons="+rejectReasons+"&IsDoneClicked="+IsDoneClicked+"&workitemId="+workitemId+"&nextWS="+nextWS+"&IsSaved=Y&abc="+abc;
		//alert("TT param alert: "+param);
		//url=replaceUrlChars(url);
		xhr.open("POST",url,false);
		xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');		
		xhr.send(param);
		//alert("Client .js "+xhr.status);
		if (xhr.status == 200 && xhr.readyState == 4)
		{
			ajaxResult=Trim(xhr.responseText);
	
			if(ajaxResult == 'NoRecord')
			{
				alert("No record found.");
				return false;
			}
			else if(ajaxResult == 'Error')
			{
				alert("Some problem in creating workitem.");
				return false;
			}
		}
		else
		{
			alert("Problem in saving data TTDone.jsp");
			return false;
		}
		
		
		//Submitted Case at CSO_Initiate
		if (WSNAME=='CSO_Initiate' || WSNAME=='OPS_Initiate')
			alert("Case has been submitted successfully.");
		
		
		
		return true;	

}
function computeWIDATA_TT(iframe, SubCategoryID,WSNAME,IsDoneClicked,CategoryID,fobj)
{
	var customform='';
	customform=fobj;	
			
	var iframeDocument = iframe;//(iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	var WIDATA="";
	var myname;
	var tr_table;
	var eleValue;
	var eleName;
	var eleName2;
	var check;
	var inputs = iframeDocument.getElementsByTagName("input");
	var textareas = iframeDocument.getElementsByTagName("textarea");
	var selects = iframeDocument.getElementsByTagName("select");
	
	//var WSNAME = iframeDocument.getElementById("WS_NAME").value;
	var store="";
	try{
		
		
		for (x=0;x<inputs.length;x++)
		{
		
			
			if((inputs[x].type=='hidden'))
			{
				var hidEleId=inputs[x].getAttribute("id");
				if(typeof hidEleId !=undefined && hidEleId!=null && hidEleId!='')
				{
					if(hidEleId=='wdesk:dec_rem_helpdesk' || hidEleId=='wdesk:dec_rem_helpdeskMaker' || hidEleId=='wdesk:dec_maker' || hidEleId=='wdesk:dec_checker'|| hidEleId=='wdesk:dec_CSO_Exceptions' || hidEleId=='wdesk:decCallBack'|| hidEleId=='wdesk:dec_maker_DB'|| hidEleId=='wdesk:dec_checker_DB' )
					{
						WIDATA+=hidEleId.substring(0)+"#"+encodeURIComponent(iframeDocument.getElementById(hidEleId).value)+"~";
						counthash++;
						continue;
					}
					else
						continue;
				}
				else
					continue;
			}
			if(!(inputs[x].type=='radio')) 
			{
				eleName2 = inputs[x].getAttribute("name");
				
				if(eleName2==null)
					continue;
				eleName2+="#";
				var temp=eleName2.split('#');
				var IsRepeatable=temp[4];
				myname = inputs[x].getAttribute("id");
			}		
			
			
			if(typeof myname == 'undefined'|| myname==null || myname=="")
				continue;
			
				
			if(!(inputs[x].type=='radio'))
			{
				eleName2 = inputs[x].getAttribute("name");
				eleName2+="#";
				var temp=eleName2.split('#');
				var is_workstep_req=temp[3];
				var IsRepeatable=temp[4];
				if(iframeDocument.getElementById(myname).value=='')
				{	
					WIDATA+=myname.substring(0)+"#NULL"+"~";
					counthash++;
				}
				else
				{	
					if(is_workstep_req=='Y')
					{
						{
							WIDATA+=myname.substring(0)+"#"+WSNAME+"$"+encodeURIComponent(iframeDocument.getElementById(myname).value)+"~";
							counthash++;
						}
					}	
					else
					{
						WIDATA+=myname.substring(0)+"#"+encodeURIComponent(iframeDocument.getElementById(myname).value)+"~";
						counthash++;
					}	
				}						
			}						
		}
		
	}catch(err){
		exception=true; 
		exceptionstring=exceptionstring+"textboxexception:"; 
		return;
	}
	try{
	for (x=0;x<textareas.length;x++)
	{
		eleName2 = textareas[x].getAttribute("name");
	
		if(typeof eleName2 == 'undefined'|| eleName2==null || eleName2=="")
			continue;
			
			
		eleName2+="#";
		var temp=eleName2.split('#');
		var IsRepeatable=temp[4];
		myname = textareas[x].getAttribute("id");
		if(myname==null)
			continue;
		if(typeof myname == 'undefined'|| myname==null || eleName2=="")
			continue;	
			
		if(IsRepeatable!='Y'){
			if(true)//myname.indexOf(SubCategoryID+"_")==0
			{
				eleName2 = textareas[x].getAttribute("name");
				var temp=eleName2.split('#');
				var is_workstep_req=temp[3];
				var IsRepeatable=temp[4];
				if(iframeDocument.getElementById(myname).value=='')
				WIDATA+=myname.substring(0)+"#NULL"+"~";
				else
				{
					if(is_workstep_req=='Y')
					{
						WIDATA+=myname.substring(0)+"#"+WSNAME+"$"+encodeURIComponent(iframeDocument.getElementById(myname).value)+"~";
					}
					else
					{
						WIDATA+=myname.substring(0)+"#"+encodeURIComponent(iframeDocument.getElementById(myname).value)+"~";
					}
				}
			}
		}
    }
	}catch(err){exception=true; exceptionstring+= "textareaexception:"; return;}
	try{
	for (x=0;x<selects.length;x++)
	{	
		eleName2 = selects[x].getAttribute("name");
		if(eleName2==null)
			continue;
		eleName2+="#select";
		myname = selects[x].getAttribute("id");
		if(myname==null)
			continue;
		var temp=eleName2.split('#');
		var is_workstep_req=temp[3];
		var IsRepeatable=temp[4];
		var e = iframeDocument.getElementById(myname);
		if(true)
		{
			var Value="";
			for (var opts=0;opts<e.options.length;opts++)
			{
				if(Value =='')
					Value=e.options[opts].value;
				else
					Value+="|"+e.options[opts].value;
			}
			if(Value=='')
				Value='NULL';
			//Added by anurag anand to remove extra space from Value
				Value = Value.trim();
			WIDATA+=myname.substring(0)+"#"+encodeURIComponent(Value)+"~";
		}
		//if(IsRepeatable!='Y')
		//{
		
			if(e.selectedIndex!=-1)
			{
				var Value = e.options[e.selectedIndex].value;	
				//Added by anurag anand to remove extra space from Value
				Value = Value.trim();				
				if(true)//myname.indexOf(SubCategoryID+"_")==0
				{
					if(Value=='--Select--')
					{	
						WIDATA+=myname.substring(0)+"#NULL"+"~";
					}	
					else
					{
						if(is_workstep_req=='Y')
						{
							WIDATA+=myname.substring(0)+"#"+WSNAME+"$"+encodeURIComponent(Value)+"~";
						}	
						else
						{
							WIDATA+=myname.substring(0)+"#"+encodeURIComponent(Value)+"~";
						}
						
					}
				}
			}		
    }
	}catch(err){exception=true; exceptionstring+= "selectexception:";return;}		
	//alert("WIDATA"+WIDATA);
	return WIDATA;	
}