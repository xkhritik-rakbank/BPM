//generates the PDF onclick of Generate_Acknowledgement by mapping form fields
function generatePDF(option) 
{
	var WorkStep=document.getElementById("wdesk:WS_NAME").value;
	//alert("inside generatePDF"+WorkStep);
	if(WorkStep=='Print_and_Dispatch')//Q6 is Print and Dispatch WS
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
			var SubCategory = document.getElementById('wdesk:Product_Type').value;
			var DateTime = date+"  "+time;
			var Customername = document.getElementById('wdesk:Name').value;
			var Branch = document.getElementById('wdesk:DocumentCollectionBranch').value;
			var Cif_ID = document.getElementById('wdesk:CIF_ID').value;			
			var remarks =  document.getElementById('remarks').value; 
			var ReferenceNumber= document.getElementById('wdesk:ReferenceNumber').value;
			var EIDANum = document.getElementById('wdesk:EmiratesIDHeader').value;
			var EIDAHolderName = document.getElementById('wdesk:Name').value;
			var EIDAExpDate = document.getElementById('wdesk:EmiratesIdExpDate').value;	
			var typeOfId="";			
			
			if(option == 'Generate_Acknowledgement')
			{					
				//Add all fields for which it will populate in single pdf form field 		
				sparam= '&branchname=' + Branch +'&datetime='+DateTime + '&custname='+Customername+'&cifid='+Cif_ID+'&workitemname='+Winame+'&loannumber='+ReferenceNumber+'&requesttype='+SubCategory+'&remarks='+remarks+'&idtype='+typeOfId+'&idnumber='+EIDANum+'&idholdername='+EIDAHolderName+'&idexpirydate='+EIDAExpDate;				
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
				retval = trim_TF(req.responseText);
				pdfName = retval;
			}
			if (retval != '-1') 
			{
				var PDFurl = "../../PDFTemplates/generated/" + trim_TF(pdfName);		
				window.open(PDFurl);
				

				//Setting the generated flag value= Y if document generated sucessfully	
				
				/*if(option=='Generate_Acknowledgement')
				{
					document.getElementById('wdesk:PDF_GENFLAG_APP_FORM_CONVENTIONAL').value='Y';
					document.getElementById('wdesk:PDF_VALUES_APP_FORM_CONVENTIONAL').value=sparam;
				}*/
				
				// start - function called to delete template from server after generating
						deleteTemplateFromServer(trim_TF(pdfName));					
					// end - function called to delete template from server after generating
			}
		return url;
}
function trim_TF(str) 
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
//alert("inside priny window"+WorkStep);
if(WorkStep=='Print_and_Dispatch' || WorkStep=='Del_Retention_Expire' )
	{
				//Fetching the values of TFHeader Table
				var StaticRowLength=document.getElementById("TAB_TF").rows.length;
				var TF_Header=document.getElementById("TF_Header").innerText.replace(/\s/g,'');
				//alert("TF_Header--"+TF_Header);
				var StaticLabelNames = new Array((StaticRowLength-2)*2);
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
				StaticLabelNames[15] =document.getElementById("MobileNoHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[15]--"+StaticLabelNames[15]);
				StaticLabelNames[16] =document.getElementById("PrefAddressHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[15]--"+StaticLabelNames[15]);
				StaticLabelNames[17] =document.getElementById("LodgementDateHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[15]--"+StaticLabelNames[15]);
				StaticLabelNames[18] =document.getElementById("ApplicationDateHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[15]--"+StaticLabelNames[15]);
				StaticLabelNames[19] =document.getElementById("IslamicOrConventionalHeader").innerText.replace(/\s/g,'');
				//alert("StaticLabelNames[15]--"+StaticLabelNames[15]);
				
				var StaticLabelValues = new Array((StaticRowLength-1)*2);
				//alert("StaticLabelValues--length"+StaticLabelValues.length);
				StaticLabelValues[0] =document.getElementById("loggedinuser").innerText.replace(/\s/g,'');
				//alert("StaticLabelValues[0]--"+StaticLabelValues[0]);
				
				StaticLabelValues[1]=document.getElementById("wdesk:WI_NAME").value;
				StaticLabelValues[2]=document.getElementById("wdesk:WS_NAME").value;
				StaticLabelValues[3] =document.getElementById("Sol_id").innerText.replace(/\s/g,'');
				//alert("StaticLabelValues[3]--"+StaticLabelValues[3]);				
				StaticLabelValues[4] =document.getElementById("wdesk:CIF_ID").value;
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
				StaticLabelValues[11] =document.getElementById("wdesk:EmiratesIDExpDate").value;
				//alert("StaticLabelValues[11]--"+StaticLabelValues[11]);
				StaticLabelValues[12] =document.getElementById("wdesk:TLIDHeader").value;
				//alert("StaticLabelValues[12]--"+StaticLabelValues[12]);
				StaticLabelValues[13] =document.getElementById("wdesk:TLIDExpDate").value;
				//alert("StaticLabelValues[13]--"+StaticLabelValues[13]);
				StaticLabelValues[14] =document.getElementById("wdesk:PrimaryEmailId").value;
				//alert("StaticLabelValues[14]--"+StaticLabelValues[14]);
				StaticLabelValues[15] =document.getElementById("wdesk:MobileNo").value;
				//alert("StaticLabelValues[15]--"+StaticLabelValues[15]);
				StaticLabelValues[16] =document.getElementById("PrefAddress").value;
				//alert("StaticLabelValues[16]--"+StaticLabelValues[16]);
				StaticLabelValues[17] =document.getElementById("LodgementDate").value;
				//alert("StaticLabelValues[17]--"+StaticLabelValues[17]);
				StaticLabelValues[18] =document.getElementById("wdesk:ApplicationDate").value;
				//alert("StaticLabelValues[18]--"+StaticLabelValues[18]);
				StaticLabelValues[19] =document.getElementById("IslamicOrconventions").value;
				//alert("StaticLabelValues[19]--"+StaticLabelValues[19]);
				
				//Fetching the values of ServiceRequest Table
				var DynamicRowLength=window.parent.frames['customform'].frmData.document.getElementById("accountdet11").rows.length;
				//alert("--DynamicRowLength--"+DynamicRowLength);
				var category = document.getElementById("Product_Category").value;
				var WI_NAME=document.getElementById("wdesk:WI_NAME").value;
				//alert("WI_NAME--"+WI_NAME);
				var subCategory  = document.getElementById("Product_Type").value;
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
				var url = "/TF/CustomForms/TF_Specific/PrintWindow.jsp";
				
				var param = "Ws_Name="+encodeURIComponent(WSNAME)+"&subCategory="+encodeURIComponent(subCategory)+"&subCategoryCode="+encodeURIComponent(subCategoryCode)+"&reqType="+encodeURIComponent(reqType);
			//param = encodeURIComponent(param);
				xhr.open("POST", url, false);
				xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
				xhr.send(param);
	
	
				
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
				var url = "/TF/CustomForms/TF_Specific/PrintWindow.jsp";
				//alert(url);
				var param = "Ws_Name="+encodeURIComponent(WSNAME)+"&CatIndex="+encodeURIComponent(ParentCatIndex)+"&SubCatIndex="+encodeURIComponent(SubCategoryIndex)+"&reqType="+encodeURIComponent(reqType);
				//param = encodeURIComponent(param);
				xhr.open("POST", url, false);
				xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
				xhr.send(param);
	
	
				
					if (xhr1.status == 200 && xhr1.readyState == 4) 
					{
						ajaxResult = xhr1.responseText;
						ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');				
						if (ajaxResult.indexOf("Exception") == 0) 
						{
							alert("Problem in getting Print document.");
							return false;
						}				
										
						var sOutput = ajaxResult.split("~");
						//alert("||sOutput.length"+sOutput.length-1);
						var DynamicTableLength=sOutput.length-1;
						var IsRepeatable=sOutput[2];
						//alert("DynamicTableLength--"+DynamicTableLength);
						//alert("DynamicTableLength /2--"+DynamicTableLength / 2);						
						var LabelNames = new Array(DynamicTableLength / 3);
						var ColumnNames = new Array(DynamicTableLength / 3);
						//alert("LabelNames++"+LabelNames.length+"  ||Columns++"+ColumnNames.length);
						var x=0;
						var y=0;
						for(var l=0;l<DynamicTableLength;l++)
						{
							//alert("mod--"+l % 2);
									if(l % 3==0)
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
									}							
						}
						
						var DynamicValues = new Array(ColumnNames.length);
						var ServiceRequest="";
						var id=0;
						for(var j=0;j<ColumnNames.length;j++)
						{	
							if(ColumnNames[j]=="NULL")
							{
								id=j;
								//Setting the header of service reqType
								ServiceRequest=LabelNames[j];
							}
							else
							{
								if(ColumnNames[j]!="")
									DynamicValues[j]=SubCategoryIndex+"_"+ColumnNames[j];
									//alert("DynamicValues before"+DynamicValues[j]);
									
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
						//alert("StaticLabelNames.length--"+StaticLabelNames.length);					
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
								
								if(DynamicValues[k]!=null)//To Ignore the Empty columns from Dynamic Grid
								{
								if(tempValues=='')
								tempValues=window.parent.frames['customform'].frmData.document.getElementById(DynamicValues[k]).value;
								else
								tempValues=tempValues+"~"+window.parent.frames['customform'].frmData.document.getElementById(DynamicValues[k]).value;	
								}
								else
								{
								if(tempValues=='')
									tempValues="";
								else
									tempValues=tempValues+"~"+"";
								}
									
							}
						}
						alert("tempLabels--"+tempLabels+"  ||tempValues--"+tempValues);
						var tempLabelsreg = tempLabels.replace(/&/g, "`");
						alert("newStr--"+tempLabelsreg);
						
						//Dispatch Details Grid
						var DispatchValues="";
						if(document.getElementById("wdesk:Document_Dispatch_Required").value=='Y')
						{
							var DispatchRowLength=document.getElementById("dispatchHeader").rows.length;
							var DispatchColumnLength=document.getElementById("dispatchHeader").rows[1].cells.length;
	
							DispatchValues=DispatchValues+document.getElementById("modeofdelivery").value;
							DispatchValues=DispatchValues+"~"+document.getElementById("doccollectionbranch").value;
							DispatchValues=DispatchValues+"~"+document.getElementById("branchDeliveryMethod").value;
							DispatchValues=DispatchValues+"~"+document.getElementById("wdesk:CourierAWBNumber").value;
							DispatchValues=DispatchValues+"~"+document.getElementById("wdesk:CourierCompName").value;
							DispatchValues=DispatchValues+"~"+document.getElementById("wdesk:BranchAWBNumber").value;
											
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
						var url = "/TF/CustomForms/TF_Specific/GeneratePDF.jsp";
						//alert(url);
						
						var param = "WINAME="+encodeURIComponent(WI_NAME)+"&ServiceRequestName="+encodeURIComponent(ServiceRequest)+"&ColumnNames="+encodeURIComponent(tempLabelsreg)+"&ColumnValues="+encodeURIComponent(tempValues)+"&DynamicRowLength="+encodeURIComponent(DynamicRowLength)+"&tempStaticLabels="+encodeURIComponent(tempStaticLabels)+"&tempStaticValues="+encodeURIComponent(tempStaticValues)+"&TFFormHeader="+encodeURIComponent(TF_Header)+"&StaticRowLength="+encodeURIComponent(StaticRowLength)+"&GridTableLength="+encodeURIComponent(GridTableLength)+"&CategoryName="+encodeURIComponent(category)+"&SubCategoryName="+encodeURIComponent(subCategory)+"&DecisionValues="+encodeURIComponent(DecisionValues)+"&RemarksValues="+encodeURIComponent(Remarksvalues)+"&DispatchValues="+encodeURIComponent(DispatchValues);
						//param = encodeURIComponent(param);
						xhr2.open("POST", url, false);
						xhr2.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
						xhr2.send(param);
	
	
						
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
									alert("pdfName--"+b);
									
									var PDFurl = "../../PDFTemplates/generated/" + b;		
									window.open(PDFurl);
									
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
							alert("Error in reading the GeneratePDF");
						}
						
						
					}
					else
					{
						alert("Problem in reading Parameters for PrintWindow.jsp.");
					}
				}
				else
				{
					alert("Problem in reading Parameters for PrintWindow.jsp.");
				}
			//window.parent.frames['customform'].frmData.document.getElementById("134_AgreementNumber").value
			 /*alert("jquery1--"+$("td").val());
			 alert("jquery2--"+$("td:nth-child(2)").val());
			 alert("jquery3--"+$("td:nth-child(3)").val());*/
			 
		
			}
}

		
function deleteTemplateFromServer (pdfname)
		{
			var url = '../../CustomForms/TF_Specific/DeleteGeneratedTemplate.jsp?pdfname='+pdfname;
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
