function pausecomp(millis)
{
	var date = new Date();
	var curDate = null;
	do { curDate = new Date(); }
	while(curDate-date < millis);
}

//generates the PDF onclick of Generate_Acknowledgement by mapping form fields
function generatePDF(option) 
{
	var WorkStep=document.getElementById("wdesk:WS_NAME").value;
	//alert("inside generatePDF"+WorkStep);
	if(WorkStep=='Q6')//Q6 is Print and Dispatch WS
	{
		var url = getURL(option);
		if (url == 'undefined' || url == '') 
				{
					return;
				}
	}				
}

function getURL(option) 
{
			var sparam = '';
			var pdfName = "";
			var url = "";
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
			//alert("date--"+date);
			
			var hh = today.getHours();
			var min = today.getMinutes();
			var ss = today.getSeconds(); 
			
			if (hh < 10) {
				hh = '0' + hh
			}
			if (min < 10) {
				min = '0' + min
			}
			if (ss < 10) {
				ss = '0' + ss
			}
			var time = hh + ':' + min + ':' + ss;
			//alert("time--"+time);						
			var Winame = document.getElementById('wdesk:WI_NAME').value;
			//var wi_name = wi.split('-');			
			var SubCategory = document.getElementById('SubCategory').value;
			var DateTime = date+"  "+time;
			var Customername = document.getElementById('wdesk:Name').value;
			var Branch = document.getElementById('wdesk:DocumentCollectionBranch').value;
			var Cif_ID = document.getElementById('wdesk:CifId').value;
			var loan_agreementNo =  document.getElementById('loanaggno').value;
			var card_no =  document.getElementById('cardno').value;
			var Account_No =  document.getElementById('accountNo').value;
			var remarks =  document.getElementById('remarks').value; 
			var dynamicNumber="";
			
			/*var iframe = document.getElementById("frmData");
			var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
			var NameData='';
			var selects = iframeDocument.getElementsByTagName("select");
			var inputs = iframeDocument.getElementsByTagName("input");
			try 
			{
				for (x = 0; x < selects.length; x++) 
				{
					eleName2 = selects[x].getAttribute("name");
					if (eleName2 == null)
						continue;
					eleName2 += "#select";
					myname = selects[x].getAttribute("id");
					if (myname == null)
						continue;
					else if(myname.indexOf("AccountNumber")!=-1 || myname.indexOf("DebitAccountNumber")!=-1 || myname.indexOf("CreditAccountNumber")!=-1 || myname.indexOf("FDAccountNumber")!=-1 || myname.indexOf("RDAccountNumber")!=-1 || myname.indexOf("Loanaccountnumber")!=-1)
					{
						dynamicNumber = iframeDocument.getElementById(myname).value;
						if (dynamicNumber !="")
							break;
					}
					else if(myname.indexOf("AgreementNumber")!=-1 || myname.indexOf("AutoLoanAgreementNumber")!=-1)
					{
						dynamicNumber = iframeDocument.getElementById(myname).value;
						if (dynamicNumber !="")
							break;
					}	
					else if(myname.indexOf("CardNumber")!=-1 || myname.indexOf("CreditCardNumber")!=-1)
					{
						dynamicNumber = iframeDocument.getElementById(myname).value;
						if (dynamicNumber !="")
							break;
					}							
				}
			} 
			catch (err) 
			{
				return "exception";
			}*/		
			
			if(option == 'Generate_Acknowledgement')
			{			
				dynamicNumber = getDataFromTRTable();
				var typeOfId = document.getElementById('wdesk:type_of_id').value;
				var EIDANum = '';
				var EIDAHolderName = '';
				var EIDAExpDate = '';
				if (typeOfId == 'Emirates ID')
				{
					EIDANum = document.getElementById("EmiratesIDHidden").value;
					EIDAHolderName = document.getElementById("EmiratesIDHolderNameHidden").value;
					EIDAExpDate = document.getElementById("EmiratesIDExpDateHidden").value;
				}
				//Add all fields for which it will populate in single pdf form field 		
				sparam= '&branchname=' + Branch +'&datetime='+DateTime + '&custname='+Customername+'&cifid='+Cif_ID+'&workitemname='+Winame+'&loannumber='+dynamicNumber+'&requesttype='+SubCategory+'&remarks='+remarks+'&idtype='+typeOfId+'&idnumber='+EIDANum+'&idholdername='+EIDAHolderName+'&idexpirydate='+EIDAExpDate;				
			}	
	
			try 
			{
					//document.getElementById('wdesk:Generatedata').value = sparam;
					sparam = sparam.replace('%','`~`');		
			} 
			catch (err) 
			{
				alert("Exception err.message "+err.message);
			}
			url = 'createPDF.jsp?option=' + option;
			var retval = "-1";
			var req = getACTObj();
			if (req == null) return;

			req.onreadystatechange = processRequest;
			req.open("POST", url, false);
			req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			req.send(sparam);			
			function processRequest() 
			{
				if (req.readyState == 4) 
				{
					if (req.status == 200)
						parseMessages();
					else
						retval = '-1';
				}
			}
			function parseMessages() {
				retval = trim_SRB(req.responseText);
				pdfName = retval;
			}
			if (retval != '-1') 
			{
				var PDFurl = "../../PDFTemplates/generated/" + trim_SRB(pdfName);		
				window.open(PDFurl);
				pausecomp(2000);

				//Setting the generated flag value= Y if document generated sucessfully	
				
				/*if(option=='Generate_Acknowledgement')
				{
					document.getElementById('wdesk:PDF_GENFLAG_APP_FORM_CONVENTIONAL').value='Y';
					document.getElementById('wdesk:PDF_VALUES_APP_FORM_CONVENTIONAL').value=sparam;
				}*/
				
				// start - function called to delete template from server after generating
						deleteTemplateFromServer(trim_SRB(pdfName));					
					// end - function called to delete template from server after generating
			}
		return url;
}
function trim_SRB(str) 
{
	if (undefined == str)
		return "";
	return str.replace(/^\s+|\s+$/g, '');
}
function getACTObj() {
	if (window.XMLHttpRequest)
		return new XMLHttpRequest
	var
		a = ["Microsoft.XMLHTTP", "MSXML2.XMLHTTP.6.0", "MSXML2.XMLHTTP.5.0", "MSXML2.XMLHTTP.4.0", "MSXML2.XMLHTTP.3.0", "MSXML2.XMLHTTP"];
	for (var c = 0; c < a.length; c++) {
		try {
			return new ActiveXObject(a[c])
		} catch (b) {
	
		}
	}
	return null;
}
//Printing the service request table in pdf and adding with the Workitem
function PrintWindow()
{	
var WorkStep=document.getElementById("wdesk:WS_NAME").value;
//alert("inside priny window");
if(WorkStep=='Q6')//Q6 is Print and Dispatch WS
	{
				//Fetching the values of SRBHeader Table
				var StaticRowLength=document.getElementById("TAB_SRB").rows.length;
				var SRB_Header=document.getElementById("SRB_Header").innerText.replace(/\s/g,'');
				//alert("SRB_Header--"+SRB_Header);
				var StaticLabelNames = new Array((StaticRowLength-1)*2);
				//alert("StaticLabelNames--length"+StaticLabelNames.length);
				
				StaticLabelNames[0] =document.getElementById("loggedinuserHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[0]--"+StaticLabelNames[0]);
				
				StaticLabelNames[1]=document.getElementById("WorkstepHeader").innerText.replace(/\s/g,'');
				StaticLabelNames[2]=document.getElementById("WinameHeader").innerText.replace(/\s/g,'');
				StaticLabelNames[3] =document.getElementById("SolIDHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[3]--"+StaticLabelNames[3]);				
				StaticLabelNames[4] =document.getElementById("CifIdHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[4]--"+StaticLabelNames[4]);				
				StaticLabelNames[5] =document.getElementById("CustnameHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[5]--"+StaticLabelNames[5]);
				StaticLabelNames[6] =document.getElementById("SubSegmentHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[6]--"+StaticLabelNames[6]);
				StaticLabelNames[7] =document.getElementById("ARMCodeHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[7]--"+StaticLabelNames[7]);
				StaticLabelNames[8] =document.getElementById("RAKEliteHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[8]--"+StaticLabelNames[8]);
				StaticLabelNames[9] =document.getElementById("ChannelHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[9]--"+StaticLabelNames[9]);
				StaticLabelNames[10] =document.getElementById("EIDHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[10]--"+StaticLabelNames[10]);
				StaticLabelNames[11] =document.getElementById("EIDExpiryDtHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[11]--"+StaticLabelNames[11]);
				StaticLabelNames[12] =document.getElementById("TradeLicenseHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[12]--"+StaticLabelNames[12]);
				StaticLabelNames[13] =document.getElementById("TradeLicenseExpDtHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[13]--"+StaticLabelNames[13]);
				StaticLabelNames[14] =document.getElementById("PrimaryEmailIdHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[14]--"+StaticLabelNames[14]);
				StaticLabelNames[15] =document.getElementById("ApplicationDateHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[15]--"+StaticLabelNames[15]);
				
				var StaticLabelValues = new Array((StaticRowLength-1)*2);
				//alert("StaticLabelValues--length"+StaticLabelValues.length);
				StaticLabelValues[0] =document.getElementById("loggedinuser").innerText.replace(/\s/g,'');
				//alert("StaticLabelValues[0]--"+StaticLabelValues[0]);
				
				StaticLabelValues[1]=document.getElementById("wdesk:WI_NAME").value;
				StaticLabelValues[2]=document.getElementById("wdesk:WS_NAME").value;
				StaticLabelValues[3] =document.getElementById("Sol_id").innerText.replace(/\s/g,'');
				//alert("StaticLabelValues[3]--"+StaticLabelValues[3]);				
				StaticLabelValues[4] =document.getElementById("wdesk:CifId").value;
				//alert("StaticLabelValues[4]--"+StaticLabelValues[4]);				
				StaticLabelValues[5] =document.getElementById("wdesk:Name").value;
				//alert("StaticLabelValues[5]--"+StaticLabelValues[5]);
				StaticLabelValues[6] =document.getElementById("wdesk:SubSegment").value;
				//alert("StaticLabelValues[6]--"+StaticLabelValues[6]);
				StaticLabelValues[7] =document.getElementById("wdesk:ARMCode").value;
				//alert("StaticLabelValues[7]--"+StaticLabelValues[7]);
				StaticLabelValues[8] =document.getElementById("wdesk:RAKElite").value;
				//alert("StaticLabelValues[8]--"+StaticLabelValues[8]);
				StaticLabelValues[9] =document.getElementById("Channel").value;
				//alert("StaticLabelValues[9]--"+StaticLabelValues[9]);
				StaticLabelValues[10] =document.getElementById("wdesk:EmiratesIDHeader").value;
				//alert("StaticLabelValues[10]--"+StaticLabelValues[10]);
				StaticLabelValues[11] =document.getElementById("wdesk:EmratesIDExpDate").value;
				//alert("StaticLabelValues[11]--"+StaticLabelValues[11]);
				StaticLabelValues[12] =document.getElementById("wdesk:TLIDHeader").value;
				//alert("StaticLabelValues[12]--"+StaticLabelValues[12]);
				StaticLabelValues[13] =document.getElementById("wdesk:TLIDExpDate").value;
				//alert("StaticLabelValues[13]--"+StaticLabelValues[13]);
				StaticLabelValues[14] =document.getElementById("wdesk:PrimaryEmailId").value;
				//alert("StaticLabelValues[14]--"+StaticLabelValues[14]);
				StaticLabelValues[15] =document.getElementById("wdesk:ApplicationDate").value;
				//alert("StaticLabelValues[15]--"+StaticLabelValues[15]);
				
				//Fetching the values of ServiceRequest Table
				var DynamicRowLength=window.parent.frames['customform'].frmData.document.getElementById("accountdet11").rows.length;
				//alert("--DynamicRowLength--"+DynamicRowLength);
				var category = document.getElementById("wdesk:Category").value;
				var WI_NAME=document.getElementById("wdesk:WI_NAME").value;
				//alert("WI_NAME--"+WI_NAME);
				var subCategory  = document.getElementById("wdesk:SubCategory").value;
				//alert("subCategory--"+subCategory);
				var subCategoryCode  = document.getElementById("wdesk:ServiceRequestCode").value;
				//alert("subCategoryCode--"+subCategoryCode);
				var WSNAME =document.getElementById("wdesk:WS_NAME").value;
				//alert("Current_Workstep--"+WSNAME);
								
				//Loading SubCategory table for CatIndex and SubCatIndex value
				var reqType="Load_SubCategory_Table";
			
				var xhr;
				if (window.XMLHttpRequest)
					xhr = new XMLHttpRequest();
				else if (window.ActiveXObject)
					xhr = new ActiveXObject("Microsoft.XMLHTTP");
				var url = "/SRB/CustomForms/SRB_Specific/PrintWindow.jsp?Ws_Name=" + WSNAME + "&subCategory=" +subCategory + "&subCategoryCode=" +subCategoryCode + "&reqType=" +reqType;
				//alert(url);
			
				xhr.open("POST", url, false);
				xhr.send();
				
				if (xhr.status == 200 && xhr.readyState == 4) 
				{
					ajaxResult = xhr.responseText;
					ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');				
					if (ajaxResult.indexOf("Exception") == 0) 
					{
						alert("Problem in getting Print document.");
						return false;
					}													
				
					var Output = ajaxResult.split("~");
					var ParentCatIndex=Output[0];
					var SubCategoryIndex=Output[1];
					//alert("ParentCatIndex++---"+ParentCatIndex);
					//alert("SubCategoryIndex++---"+SubCategoryIndex);
				
				//Loading FormLayout table for ColumnNames and LabelNames						
				var reqType="Load_FormLayout_Table";
			
				var xhr1;
				if (window.XMLHttpRequest)
					xhr1 = new XMLHttpRequest();
				else if (window.ActiveXObject)
					xhr1 = new ActiveXObject("Microsoft.XMLHTTP");
				var url = "/SRB/CustomForms/SRB_Specific/PrintWindow.jsp?Ws_Name=" + WSNAME + "&CatIndex=" +ParentCatIndex+ "&SubCatIndex=" +SubCategoryIndex+ "&reqType=" +reqType;
				//alert(url);
			
				xhr1.open("POST", url, false);
				xhr1.send();
				
					if (xhr1.status == 200 && xhr1.readyState == 4) 
					{
						ajaxResult = xhr1.responseText;
						ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');				
						if (ajaxResult.indexOf("Exception") == 0) 
						{
							alert("Problem in getting Print document.");
							return false;
						}				
						//ajaxResult = ajaxResult.length-1;				
						var sOutput = ajaxResult.split('`');
						//alert("||sOutput.length"+sOutput.length-1);
						var DynamicTableLength=sOutput.length-1;
						var IsRepeatable='N';
						//alert("DynamicTableLength--"+DynamicTableLength);
						//alert("DynamicTableLength /2--"+DynamicTableLength / 2);						
						var LabelNames = new Array(DynamicTableLength);
						var ColumnNames = new Array(DynamicTableLength);
						//alert("LabelNames++"+LabelNames.length+"  ||Columns++"+ColumnNames.length);
						var x=0;
						var y=0;
						for(var l=0;l<DynamicTableLength;l++)
						{
							var rowdata = sOutput[l].split('~');
							
							LabelNames[x]=rowdata[0];
							x++;
							ColumnNames[y]=rowdata[1];
							y++;
							if (rowdata[2] == 'Y')
								IsRepeatable = 'Y';
							//alert("mod--"+l % 2);
									/*if(l % 2==0)
									{
									//alert("y--even"+y);
									if(sOutput[l]!=IsRepeatable)//Ignoring 3rd IsRepeatable Column
										{
										LabelNames[x]=sOutput[l];
										//alert("sOutput[l]++ even"+sOutput[l]);
										x++;
										}
									}
									else
									{									
									//alert("y--odd"+y);
									if(sOutput[l]!=IsRepeatable)//Ignoring 3rd IsRepeatable Column
										{
										ColumnNames[y]=sOutput[l].replace(/\s/g, '');
										//alert("sOutput[l]++ odd"+sOutput[l]);
										y++;
										}
									}*/							
						}
						
						var DynamicValues = new Array(ColumnNames.length);
						var ServiceRequest="";
						var id=0;
						for(var j=0;j<ColumnNames.length;j++)
						{	
							if(ColumnNames[j]!="NULL" && ColumnNames[j]!="")
							{
									DynamicValues[j]=SubCategoryIndex+"_"+ColumnNames[j];
									//alert("DynamicValues before"+DynamicValues[j]);
									
							}
							else
							{
								id=j;
								//Setting the header of service reqType
								ServiceRequest=LabelNames[j];
							}						
						}
						
						var GridTableLength;
						//Check whether Dynamic service request grid present or not
						if(IsRepeatable=="Y")
						{
						//Getting values from dynamic table grid
							GridTableLength=window.parent.frames['customform'].frmData.document.getElementById(ServiceRequest+"_GridTable").rows.length;
							if(GridTableLength>1)
							{							
								var headers=new Array(GridTableLength);
								var GridValues=new Array(GridTableLength);
								
									//Column Length
									var GridColumnLength=window.parent.frames['customform'].frmData.document.getElementById(ServiceRequest+"_GridTable").rows[0].cells.length;
									//alert("ServiceRequest+GridColumnLength--"+window.parent.frames['customform'].frmData.document.getElementById(ServiceRequest+"_GridTable").rows[0].cells.length);
									for(var y=0;y<GridTableLength;y++)
									{			
										GridValues[y]=new Array(GridColumnLength);
										headers[y]=new Array(GridColumnLength);										
										for(var e=0;e<GridColumnLength;e++)
										{
											//Header Tags
											if(y==0)
											{
											headers[y][e]=window.parent.frames['customform'].frmData.document.getElementById(ServiceRequest+"_GridTable").rows[y].cells[e].innerText;
											//alert("e--"+e);
											//alert("headers--"+headers[y][e]);										
											}
											else
											{
												GridValues[y][e]=window.parent.frames['customform'].frmData.document.getElementById(ServiceRequest+"_GridTable").rows[y].cells[e].firstChild.value;
												//alert("e--"+e);
												//alert("GridValues--"+GridValues[y][e]);											
											}
										}
									}
										
								
							}
						//alert("tempColumns--"+tempColumns+"  ||tempValues--"+tempValues+"  ||ServiceRequest--"+ServiceRequest);
						
						}
							
						else
						{
							GridTableLength=0;
							//alert("GridTableLength--"+GridTableLength);
						}
						
						//Splitting the values of Static Table		
						var tempStaticValues="";			
						var tempStaticLabels="";							
						for(var q=0;q<StaticLabelNames.length;q++)
						{							
							//Labels=LabelNames[k];
							if(tempStaticLabels=='')
							tempStaticLabels=StaticLabelNames[q];
							else
							tempStaticLabels=tempStaticLabels+"~"+StaticLabelNames[q];
						
							//STValues = window.parent.frames['customform'].frmData.document.getElementById(DynamicValues[k]).value;
							if(tempStaticValues=='')
							tempStaticValues=StaticLabelValues[q];
							else
							tempStaticValues=tempStaticValues+"~"+StaticLabelValues[q];							
						}						
						
						//Splitting the values of Dynamic ServiceRequest Table based on Grid Table Exists
						//var Values="";			
						var tempValues="";		
						//var Labels="";			
						var tempLabels="";
						//alert("GridTableLength+++++++++----"+GridTableLength);
						if(GridTableLength>1)
						{
							for(var w=1;w<LabelNames.length;w++)
							{
								if(tempLabels=='')
								tempLabels=LabelNames[w];
								else
								tempLabels=tempLabels+"~"+LabelNames[w];
							
								for(var k=1;k<GridTableLength;k++)
								{	
									//alert("GridValues--"+GridValues[k][w]);
									if(tempValues=='')
										tempValues=GridValues[k][w];
									else
										tempValues=tempValues+"~"+GridValues[k][w];
								}
							}
						}
						
						else
						{	
							for(var k=1;k<LabelNames.length;k++)
							{							
								//Labels=LabelNames[k];
								if(tempLabels=='')
								tempLabels=LabelNames[k];
								else
								tempLabels=tempLabels+"~"+LabelNames[k];
								
								if(DynamicValues[k].indexOf("OpenWI")==-1)//To Ignore the OpenWI button control
								{
									if(tempValues=='')
									{
										tempValues=window.parent.frames['customform'].frmData.document.getElementById(DynamicValues[k]).value;
										if (tempValues == '' || tempValues == ' ')
											tempValues = '-';
									}
									else
									{
										var colValue=window.parent.frames['customform'].frmData.document.getElementById(DynamicValues[k]).value;
										if (colValue == '' || colValue == ' ')
											colValue = '-';
										tempValues=tempValues+"~"+colValue;	
									}
								}
							}
						}
						//alert("tempLabels--"+tempLabels+"  ||tempValues--"+tempValues);
						
						//Dispatch Details Grid
						var DispatchValues="";
						if(document.getElementById("wdesk:printDispatchRequired").value=='Y')
						{
							var DispatchRowLength=document.getElementById("dispatchHeader").rows.length;
							var DispatchColumnLength=document.getElementById("dispatchHeader").rows[1].cells.length;
	
							DispatchValues=document.getElementById("dispatchHeader").rows[1].cells[1].firstChild.value;
							DispatchValues=DispatchValues+"~"+document.getElementById("dispatchHeader").rows[1].cells[3].firstChild.value;
							DispatchValues=DispatchValues+"~"+document.getElementById("dispatchHeader").rows[2].cells[1].firstChild.value;
							DispatchValues=DispatchValues+"~"+document.getElementById("dispatchHeader").rows[2].cells[3].firstChild.title;
							DispatchValues=DispatchValues+"~"+document.getElementById("dispatchHeader").rows[3].cells[1].firstChild.title;
							DispatchValues=DispatchValues+"~"+document.getElementById("dispatchHeader").rows[3].cells[3].firstChild.title;				
							//alert("DispatchValues-++-"+DispatchValues);
						}
						else
							DispatchValues="";
						
						//Decision Grid				
							DecisionValues=document.getElementById("selectDecision").value;
						
							Remarksvalues=document.getElementById("remarks").value;
						
						//alert("Remarksvalues-3--"+Remarksvalues+"  ||DecisionValues--"+DecisionValues);
						
												
						var xhr2;
						if (window.XMLHttpRequest)
							xhr2 = new XMLHttpRequest();
						else if (window.ActiveXObject)
							xhr2 = new ActiveXObject("Microsoft.XMLHTTP");
						var url = "/SRB/CustomForms/SRB_Specific/GeneratePDF.jsp?WINAME=" + WI_NAME + "&ServiceRequestName=" +ServiceRequest + "&ColumnNames=" +tempLabels + "&ColumnValues=" +tempValues+ "&DynamicRowLength=" +DynamicRowLength+ "&tempStaticLabels=" +tempStaticLabels + "&tempStaticValues=" +tempStaticValues+ "&SRBFormHeader=" +SRB_Header+ "&StaticRowLength=" +StaticRowLength + "&GridTableLength=" +GridTableLength + "&CategoryName=" +category+ "&SubCategoryName=" +subCategory+ "&DecisionValues=" +DecisionValues+ "&RemarksValues=" +Remarksvalues+ "&DispatchValues="+DispatchValues;
						//alert(url);
					
						xhr2.open("POST", url, false);
						xhr2.send();
						
						if (xhr2.status == 200 && xhr2.readyState == 4) 
						{
							ajaxResult = xhr2.responseText;
							ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');				
							if (ajaxResult.indexOf("Exception") == 0) 
							{
								alert("Problem in getting Print document.");
								return false;
							}													
						
							var sOutput1 = ajaxResult.split("~");
							//alert("sOutput1"+sOutput1);
						if(sOutput1[0].indexOf("NG200")!=-1)
						{					
							//pdf generate
								pdfName = sOutput1[1];
								//alert("pdfName"+pdfName);
								var a=pdfName.indexOf("<");
								//alert(a);
								var b=pdfName.substr(0,a);
								//alert("pdfName--"+b);
								
								var PDFurl = "../../PDFTemplates/generated/" + b;		
								window.open(PDFurl);
								pausecomp(2000);
								// start - function called to delete template from server after generating
								window.onunload(deleteTemplateFromServer(b));
								// end - function called to delete template from server after generating
										//alert("Document Printed successfully");
						}
						else
						{
							alert("Error in generating the PDF");
						}
					}
						else
						{
							alert("Error in Adding the Document");
						}
						
						
					}
					else
					{
						alert("Problem in reading Parameters for PrintWindow.jsp.");
					}
				}
			//window.parent.frames['customform'].frmData.document.getElementById("134_AgreementNumber").value
			 /*alert("jquery1--"+$("td").val());
			 alert("jquery2--"+$("td:nth-child(2)").val());
			 alert("jquery3--"+$("td:nth-child(3)").val());*/
			 
		
			}
}

		
function deleteTemplateFromServer (pdfname)
		{
			var url = '../../CustomForms/SRB_Specific/DeleteGeneratedTemplate.jsp?pdfname='+pdfname;
			var xhr;
			var ajaxResult;	
			
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");

			 xhr.open("GET",url,false); 
			 xhr.send(null);

			// alert(xhr.status);
			 
			if (xhr.status == 200) { //Do nothing
			
			//window.parent.close();
			}
			else
			{
				alert("Error while deleting generated template from server");
				return false;
			}
		}
		
		
function generateEMIDAsPDF(cust_photo,EIDA_no,DOB,sex,full_name,EIDA_exp_date,nationality,WINAME)
{
	if (cust_photo.length > 0) {
			
			//spaces are removed in Hexadecimal value of cust_photo
			var image="";
			//alert(cust_photo.length - cust_photo.replace(/\s+/g, '').length);
			/*for(var i=0;i<cust_photo.length - cust_photo.replace(/\s+/g, '').length;i++)
			{
				//alert("cust_photo:  "+cust_photo);
				if(image=="")
				image = cust_photo.replace(" ", "");
				
				else
				image = image.replace(" ", "");
				
				//alert("res:  "+res);
			}*/
			image = cust_photo.split(" ").join("");
			//Generating Emirates ID PDF
			var request_type= 'Emirates_ID';
			var xhr;
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");
			var url = "/SRB/CustomForms/SRB_Specific/EIDGeneratePDF.jsp?EIDA_no=" + EIDA_no + "&DOB=" + DOB + "&sex=" + sex + "&full_name=" + full_name + "&EIDA_exp_date=" + EIDA_exp_date + "&EID_Nationality=" + nationality + "&photoDataBase64=" + image + "&WINAME=" + WINAME;
		
			xhr.open("POST", url, false);
			xhr.send();
			var flagDocGenStatus = "";
			if (xhr.status == 200 && xhr.readyState == 4) 
			{
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');				
				if (ajaxResult.indexOf("Exception") == 0) 
				{
					alert("Problem in output of EIDGeneratePDF.jsp");
					return false;
				}				
				flagDocGenStatus = true;
				//alert("EIDGeneratePDF generated successfully");
			}
			else
			{
				alert("Problem in reading EIDGeneratePDF jsp.");
				return false;
			}
	
	//*****************************
	//****Adding document to WI
		if (flagDocGenStatus == true)
		{
			var xhr1;
			if (window.XMLHttpRequest)
				xhr1 = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr1 = new ActiveXObject("Microsoft.XMLHTTP");
			var url1 = "/SRB/CustomForms/SRB_Specific/ODAddDocument.jsp?WINAME=" + WINAME + "&request_type=" + request_type;
			
			xhr1.open("POST", url1, false);
			xhr1.send();
			if (xhr1.status == 200 && xhr1.readyState == 4) 
			{
				ajaxResult = xhr1.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');				
				if (ajaxResult.indexOf("Exception") == 0) 
				{
					alert("Problem in getting add document.");
					return false;
				}				
								
				var Output = ajaxResult.split("~");
				pdfName = Output[3];
				window.parent.customAddDoc(Output[0],Output[1],Output[2]);
				//window.parent.customAddDoc(Output[0],Output[1],Output[2]);
				deleteTemplateFromServer(pdfName);
				//alert("EMID Document Added successfully");
			}
			else
			{
				alert("Problem in Adding EMID Document.");
				return false;
			}
		} else {
			alert("error in EIDA PDF Generation")
			return false;
		}
	//****************************
	}
}
		
function newValidateduplicateAccountNo(in_tbl_name,arrColumnList)
{
		var refTab = document.getElementById(in_tbl_name);
		var flag=true;
		if(refTab.rows.length==1)
		return true;
		for (var i = 0; i < refTab.rows.length; i++) {
			if(i==0)
			continue;			
			  for(var j=0;j<arrColumnList.length;j++)
			  {
					var valueInGrid=document.getElementById('grid_'+arrColumnList[j]+'_'+(i-1)).value;
					var valueGoingToAdd=document.getElementById(arrColumnList[j]).value;
					if(valueInGrid==valueGoingToAdd)
						flag=false;
					else
					{
						flag=true;//if any not match found in any for any column then break the loop because then it is not duplicate
						break;
					}
					if(valueInGrid !='')
					{
					valueInGrid = valueInGrid  + '#' ;
					//alert("valueInGrid"+valueInGrid);
					}
			  }
			  if(!flag)
			  {
					alert("Duplicate Row is not allowed in grid.");
					return false;
			  }
		}
		return true;
}


function getDataFromTRTable()
	{
			var SRCode = document.getElementById("wdesk:ServiceRequestCode").value;
			var WI_NAME = document.getElementById("wdesk:WI_NAME").value;
			var xhr1;
			var ajaxResult;
			ajaxResult = "";
			var reqType = "getDataFromTransactionTable";

			if (window.XMLHttpRequest)
				xhr1 = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr1 = new ActiveXObject("Microsoft.XMLHTTP");

			var url = "/SRB/CustomForms/SRB_Specific/PrintWindow.jsp";
			//alert("url"+url);
			var param = "&SRCode="+SRCode+"&reqType="+reqType+"&WI_NAME="+WI_NAME;
			xhr1.open("POST", url, false);
			xhr1.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr1.send(param);

			if (xhr1.status == 200) {
				ajaxResult = xhr1.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
				//alert("ajaxResult---"+ajaxResult);

				if (ajaxResult.indexOf("Exception") == 0) {
					alert("Some problem in getting data from tr table");
					return false;
				}
				return ajaxResult;
			} else {
				alert("Error while Loading Mode Of Delivery Values");
				//return "";
			}
	}
		
