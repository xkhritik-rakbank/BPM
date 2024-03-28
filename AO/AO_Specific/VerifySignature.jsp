<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>

<%@ page import="java.io.ByteArrayOutputStream,java.io.File,java.io.FileInputStream,java.io.IOException,java.net.HttpURLConnection,java.net.URL,java.net.URLConnection" %>
<%@ page import="com.newgen.custom.*,ISPack.ISUtil.JPISException,org.apache.commons.codec.binary.Base64,Jdts.DataObject.JPDBString,ISPack.CImageServer" %>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

<!--<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>-->

<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CustomerName"), 1000, true) );
			String CustomerName_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: CustomerName_Esapi: "+CustomerName_Esapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Mandates"), 1000, true) );
			String Mandates_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("Integration jsp: Mandates_Esapi: "+Mandates_Esapi);
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("AccountNo"), 1000, true) );
			String AccountNo_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("Integration jsp: AccountNo_Esapi: "+AccountNo_Esapi);
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CifId"), 1000, true) );
			String CifId_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			WriteLog("Integration jsp: CifId_Esapi: "+CifId_Esapi);
			
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WIName"), 1000, true) );
			String WIName_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			WriteLog("Integration jsp: WIName_Esapi "+WIName_Esapi);
			
			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ItemIndex"), 1000, true) );
			String ItemIndex_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			WriteLog("Integration jsp: ItemIndex_Esapi "+ItemIndex_Esapi);
			
			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CustSeqNo"), 1000, true) );
			String CustSeqNo_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
			WriteLog("Integration jsp: CustSeqNo_Esapi "+CustSeqNo_Esapi);

String CustomerName = CustomerName_Esapi;
String Mandates = Mandates_Esapi;
String AccountNo = AccountNo_Esapi;
String CifId = CifId_Esapi;
String WIName =WIName_Esapi;
String SessionId=wDSession.getM_objUserInfo().getM_strSessionId();
String VolumeId="1";
String EngineName=wDSession.getM_objCabinetInfo().getM_strCabinetName();
Integer SiteId=wDSession.getM_iSiteId();
String ItemIndex=ItemIndex_Esapi;
String CustSeqNo=CustSeqNo_Esapi;
String JtsIP=wDSession.getM_objCabinetInfo().getM_strServerIP();
Integer JtsPort=Integer.parseInt(wDSession.getM_objCabinetInfo().getM_strServerPort());


%>
<%! 
String strSignatureStatusTable = "AO_signature_status";
String fileDownloadLoc="SigUpload";
String downloadStatus="";
String uploadDocStatus="";
String subXML;
XMLParser subXMLParser = null;
String trDate = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss.SSS").format(new Date());
%>

<% 
String msg=processWI(ItemIndex,SessionId,EngineName,WIName,AccountNo,CifId,CustomerName,Mandates,CustSeqNo,JtsIP,JtsPort,VolumeId,SiteId) ;
out.println(msg);
%>

<%!
public String processWI(String ItemIndex,String SessionId,String CabinetName,String WIName,String AccountNo,String CifId,String CustomerName,String Mandates,String CustSeqNo,String JtsIP,Integer JtsPort,String VolumeId,Integer SiteId) 
{
	String WIProcessedStatus ="";
	
	try
	{	
		//WriteLog("Inside ProcessWI... for CustSeqNo "+CustSeqNo);
		XMLParser xmlParser = new XMLParser();
		String docListXML =GetDocumentsList(ItemIndex, SessionId, CabinetName,JtsIP,JtsPort );
		//WriteLog("After DocList Call docListXML..."+docListXML);
		if(docListXML=="F")
		{
			String colName="SIGUPLOAD_STATUS,PROCESSING_REMARKS";
			String values="'F','Error occured in getting document list.'";
			String where = "WI_NAME='"+WIName+"'";
			String sigUploadStatus = updateSigUploadStatus(strSignatureStatusTable,colName,values,where,CabinetName,SessionId,JtsIP,JtsPort);						
		}
		//WriteLog("After SigUpload Status");		
		String lockStatus = LockRecordBeforeProcessing(WIName,AccountNo,CifId,CustomerName,CustSeqNo,CabinetName,SessionId,JtsIP,JtsPort);
		if(lockStatus=="F")		
			//WriteLog("After LockRecordBeforeProcessing lockStatus..." +lockStatus);	
		
		xmlParser.setInputXML(docListXML);		
		int noOfDocs = xmlParser.getNoOfFields("Document");
		//WriteLog("No. of Docs " +noOfDocs);
		for(int j=1;j<=noOfDocs; )
		{
			subXML = xmlParser.getNextValueOf("Document");
			subXMLParser = new XMLParser(subXML);
			String docName = subXMLParser.getValueOf("DocumentName");
			//WriteLog("Doc Name: " +docName);	
			if(docName.equalsIgnoreCase("Signature_"+CustSeqNo))
			{
				if(CustSeqNo!=null)					
				{
				  downloadStatus = DownloadDocument(subXMLParser,WIName,docName,strSignatureStatusTable,AccountNo,CustomerName,CustSeqNo,CabinetName,SessionId,JtsIP,JtsPort,VolumeId,String.valueOf(SiteId));
					//WriteLog("download status..: " +downloadStatus);
				}
				else
				{
					//
				}
															
				if(downloadStatus!="F")
				 {
					//WriteLog("downloadStatus is !=F "); 
					
					 //if(CustSeqNo==null)
						// map.put(customer_seq_no, downloadStatus);
					 
				 uploadDocStatus=uploadSinaturesinFinacle(downloadStatus,WIName, AccountNo,CifId, trDate, CustomerName, Mandates ,CabinetName,SessionId,JtsIP,JtsPort);
				 //WriteLog("uploadDocStatus is... " +uploadDocStatus); 
					 
					  break;
				 }
				else // In case of any error/exception while downloading/converting the document 
				 {
					break;

				 } 
			}		
			j++;
			
			if(j>noOfDocs) // When Document not found in the list for this customer
			{
				String colName="SIGUPLOAD_STATUS,PROCESSING_REMARKS";
				String values="'F','Signature document not attached for Customer"+CustSeqNo+"'";
				String where = "WI_NAME='"+WIName+"' and account_no ='"+AccountNo+"' and  customer_name1='"+CustomerName+"'";
				String sigUploadStatus = updateSigUploadStatus(strSignatureStatusTable,colName,values,where,CabinetName,SessionId,JtsIP,JtsPort);
				//WriteLog("sigUploadStatus is" +sigUploadStatus); 
				
				if(sigUploadStatus.equals("Y"))
				{
					//											
				}
			}
		}
		//String sQuery = "select count(*) as countValue from AO_signature_status with(nolock) WHERE WI_NAME='"+WIName+"' and coalesce(sigupload_status,'F')!='S'";
		//String inputXML = ExecuteQuery_APSelectWithColumnNames(sQuery,CabinetName,SessionId);	
		
		String sQuery = "select count(*) as countValue from AO_signature_status with(nolock) WHERE WI_NAME=:WINAME and coalesce(sigupload_status,'F')!='S'";
		String inputXML = ExecuteQuery_APSelectWithNamedParams(sQuery,CabinetName,SessionId,"WI_NAME=="+WIName);	
		
		
		//String outputXML = WFCallBroker.execute(inputXML, JtsIP, JtsPort, 1);
		//String outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
		
		String outputXML = NGEjbClient.getSharedInstance().makeCall(JtsIP, String.valueOf(JtsPort),"WebSphere" , inputXML);
		
		xmlParser = new XMLParser();
		xmlParser.setInputXML(outputXML);
		String mainCode = xmlParser.getValueOf("MainCode");
	
		if(mainCode.equals("0"))
		{
			int countValue = Integer.parseInt(xmlParser.getValueOf("countValue"));
			String colName="SigUploadStatus";
			String where = "WI_NAME='"+WIName+"'";
			String values="";
			if(countValue>0)
				 values="'F'";
			else
				 values="'S'";
											
			inputXML=ExecuteQuery_APUpdate("RB_AO_EXTTABLE",colName,values,where,CabinetName,SessionId);	
			//outputXML = WFCallBroker.execute(inputXML,JtsIP,JtsPort, 1);	
			//outputXML =NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
			
			outputXML = NGEjbClient.getSharedInstance().makeCall(JtsIP, String.valueOf(JtsPort),"WebSphere" , inputXML);
			xmlParser.setInputXML(outputXML);		
			mainCode = xmlParser.getValueOf("MainCode");		
			if(mainCode.equals("0"))
			{
				//
			}
			else
			{
				//
			}
		}
		
		WIProcessedStatus = UpdateWIProcessedStatus(WIName,CabinetName,SessionId,JtsIP,JtsPort);
		//WriteLog("WIProcessedStatus is....... " +WIProcessedStatus);
		
	}
	catch (Exception e) 
	{
		//WriteLog("Exception occured: " +e.getMessage());	
	}
	return WIProcessedStatus;	
}

public String GetDocumentsList(String itemindex , String sessionId,String cabinetName,String JtsIP,Integer JtsPort)
{
	//WriteLog("Inside GetDocumentsList Method ...");	
	XMLParser xmlParser = new XMLParser();
	xmlParser = new XMLParser();
	String mainCode="";
	String response="F";
	String outputXML ="";
	try
	{
		String inputXML = "<?xml version=\"1.0\"?><NGOGetDocumentListExt_Input>" +
			"<Option>NGOGetDocumentListExt</Option>" +
			"<CabinetName>"+cabinetName+"</CabinetName>" +
			"<UserDBId>"+sessionId+"</UserDBId>" +
			"<CurrentDateTime></CurrentDateTime>" +
			"<FolderIndex>"+itemindex+"</FolderIndex>" +
			"<DocumentIndex></DocumentIndex>" +
			"<PreviousIndex>0</PreviousIndex>" +
			"<LastSortField></LastSortField>" +
			"<StartPos>0</StartPos>" +
			"<NoOfRecordsToFetch>30</NoOfRecordsToFetch>" +
			"<OrderBy>2</OrderBy><SortOrder>A</SortOrder><DataAlsoFlag>N</DataAlsoFlag>" +
			"<AnnotationFlag>Y</AnnotationFlag><LinkDocFlag>Y</LinkDocFlag>" +
			"<PreviousRefIndex>0</PreviousRefIndex><LastRefField></LastRefField>" +
			"<RefOrderBy>2</RefOrderBy><RefSortOrder>A</RefSortOrder>" +
			"<NoOfReferenceToFetch>10</NoOfReferenceToFetch>" +
			"<DocumentType>B</DocumentType>" +
			"<RecursiveFlag>N</RecursiveFlag><ThumbnailAlsoFlag>N</ThumbnailAlsoFlag>" +
			"</NGOGetDocumentListExt_Input>";
		
		//WriteLog("Inside GetDocumentsList Method inputXML..."+ inputXML);				
		//WriteLog("Inside GetDocumentsList Method JtsIP..."+ JtsIP);
		//WriteLog("Inside GetDocumentsList Method JtsPort..."+ JtsPort);
		//outputXML = WFCallBroker.execute(inputXML, JtsIP, JtsPort, 1);
		//outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
		outputXML = NGEjbClient.getSharedInstance().makeCall(JtsIP, String.valueOf(JtsPort),"WebSphere" , inputXML);
		//WriteLog("Inside GetDocumentsList Method outputXML..."+ outputXML);
		xmlParser.setInputXML(outputXML);
		mainCode = xmlParser.getValueOf("Status");	
		
		if(mainCode.equals("0"))
		{
			response=outputXML;
		}		
	}
	catch (Exception e) 
	{
		response ="F";
		//WriteLog("EXCEPTION: "+e.getMessage());
	}
	return response;
}

public String updateSigUploadStatus(String strSignatureStatusTable,String colName,String values,String where,String cabinetName,String sessionId,String JtsIP,Integer JtsPort)
{ 
	//WriteLog("Inside updateSigUploadStatus Method ...");
	String sigUploadStatus="N";
	try
	{
		XMLParser xmlParser = new XMLParser();
		String inputXML=ExecuteQuery_APUpdate(strSignatureStatusTable,colName,values,where,cabinetName,sessionId);
		//WriteLog("Inside updateSigUploadStatus Method inputXML..."+inputXML);
		//String outPutXML = WFCallBroker.execute(inputXML, JtsIP, JtsPort, 1);
		String outPutXML = NGEjbClient.getSharedInstance().makeCall(JtsIP, String.valueOf(JtsPort),"WebSphere" , inputXML);
		//WriteLog("Inside updateSigUploadStatus Method outPutXML..."+outPutXML);
		
		xmlParser.setInputXML(outPutXML);		
		String mainCode = xmlParser.getValueOf("MainCode");
		
		if(mainCode.equals("0"))
		{
			sigUploadStatus="Y";
		}
		else
		{
			//
		}
	}
	catch (Exception e) 
	{
		//WriteLog("Exception caught:"+e.getMessage());
	}
	return sigUploadStatus;
}

public String ExecuteQuery_APUpdate(String tableName,String columnName,String strValues,String sWhere,String cabinetName,String sessionId)
{
	
	System.out.println("inside ExecuteQuery_APUpdate");
	WFInputXml wfInputXml = new WFInputXml();
	if(strValues==null)
	{
		strValues = "''";
	}
	wfInputXml.appendStartCallName("APUpdate", "Input");
	wfInputXml.appendTagAndValue("TableName",tableName);
	wfInputXml.appendTagAndValue("ColName",columnName);
	wfInputXml.appendTagAndValue("Values",strValues);
	wfInputXml.appendTagAndValue("WhereClause",sWhere);
	wfInputXml.appendTagAndValue("EngineName",cabinetName);
	wfInputXml.appendTagAndValue("SessionId",sessionId);
	wfInputXml.appendEndCallName("APUpdate","Input");
	System.out.println("wfInputXml.toString()-------"+wfInputXml.toString());
	return wfInputXml.toString();
}

public String LockRecordBeforeProcessing(String winame, String account_no, String cif_id, String customer_name1, String customer_seq_no,String CabinetName,String SessionId,String JtsIP,Integer JtsPort)
{
	try
	{
		//WriteLog("Inside LockRecordBeforeProcessing method...");
		XMLParser xmlParser = new XMLParser();
		String strSignatureStatusTable="AO_signature_status";
		String colName="SIGUPLOAD_STATUS";
		String values="'L'";
		String where = "WI_NAME='"+winame+"' and account_no='"+account_no+"' and "
				+ "cif_id='"+cif_id+"' and customer_name1='"+customer_name1+"' and customer_seq_no='"+customer_seq_no+"'";
			
		String inputXML=ExecuteQuery_APUpdate(strSignatureStatusTable,colName,values,where,CabinetName,SessionId);
		//WriteLog("Inside LockRecordBeforeProcessing method inputXML..." +inputXML);
		//String outPutXML = WFCallBroker.execute(inputXML, JtsIP, JtsPort, 1);
		String outPutXML = NGEjbClient.getSharedInstance().makeCall(JtsIP, String.valueOf(JtsPort),"WebSphere" , inputXML);
		//WriteLog("Inside LockRecordBeforeProcessing method outPutXML..." +outPutXML);
		
		xmlParser.setInputXML(outPutXML);		
		String mainCode = xmlParser.getValueOf("MainCode");
		
		if(mainCode.equals("0"))
		{
			return "S";
		}	
		else
		{
			return "F";
		}
	}
	catch (Exception e) {
		//WriteLog("Exception ::"+e.getMessage());		
	}
	return "F";	
}

public String uploadSinaturesinFinacle(String downloadStatus,String winame,String account_no,String cif_id,String trDate,String customer_name1,String remarks,String cabinetName,String sessionId,String JtsIP,Integer JtsPort )
{
	//WriteLog("Inside uploadSinaturesinFinacle---");
	String update_Status="";
	//prod url
	//String ServletUrl="https://corebanking.rakbank.co.ae:8082/FISERVLET/fihttp";
	
	//uat url
	String ServletUrl="https://dsisbfinuatwebs01.rakbank.co.ae:8082/FISERVLET/fihttp";
	String values="";
	try
	{
		XMLParser xmlParser = new XMLParser();
		
		String inputXML = getSignatureUploadXML(downloadStatus, account_no,cif_id, trDate, customer_name1,remarks );
		String outPutXML="";
		//WriteLog("Servelet URL->" +ServletUrl);
		//WriteLog("uploadSinaturesinFinacle inputXML---" +inputXML);
		/*String outPutXML="<FIXML><Header><ResponseHeader><RequestMessageKey><RequestUUID></RequestUUID><ServiceRequestId></ServiceRequestId>"
		+ "<ServiceRequestVersion></ServiceRequestVersion><ChannelId></ChannelId></RequestMessageKey><ResponseMessageInfo><BankId>"
		+ "</BankId><TimeZone></TimeZone><MessageDateTime></MessageDateTime></ResponseMessageInfo><UBUSTransaction><Id></Id>"
		+ "<Status></Status></UBUSTransaction><HostTransaction><Id></Id><Status></Status></HostTransaction><HostParentTransaction>"
		+ "<Id></Id><Status></Status></HostParentTransaction><CustomInfo><Table><Key><Value></Table></CustomInfo></ResponseHeader>"
		+ "</Header><Body><SignatureAddResponse><SignatureAddRs> <AcctId></AcctId><AcctCode></AcctCode><CustId></CustId>"
		+ "<EmployeeIdent></EmployeeIdent><BankCode></BankCode><SigPowerNum></SigPowerNum><SigAddStatusCode>true</SigAddStatusCode>"
		+ "<ErrorCode>0000</ErrorCode></SignatureAddRs><SignatureAdd_CustomData>"
		+ "</SignatureAdd_CustomData> </SignatureAddResponse></Body></FIXML>";*/
		
		try
		{
			URL url = new URL(ServletUrl);
			URLConnection urlConnection = url.openConnection();
			if (urlConnection instanceof HttpURLConnection){
				((HttpURLConnection)urlConnection).setRequestMethod("POST");
			}
			else{
				throw new Exception("this connection is NOT an HttpUrlConnection connection");
			}
			//urlConnection.setUseCaches(false);
			//urlConnection.setDefaultUseCaches(false);
			urlConnection.setDoInput(true);
			urlConnection.setDoOutput(true);
			urlConnection.setRequestProperty("Content-Type", "application/octet-stream");
			urlConnection.connect();
			//----------------------------------------------------------------------
			// send data to servlet
			//----------------------------------------------------------------------
			BufferedWriter os = new BufferedWriter(new OutputStreamWriter(urlConnection.getOutputStream(),"UTF-8") );
			os.write(inputXML, 0, inputXML.length());
			os.close();
			os = null;
			//----------------------------------------------------------------------
			// read any response data, and store in a ByteArrayOutputStream
			//----------------------------------------------------------------------
			ByteArrayOutputStream baos = null;
			InputStream is = null;
			if ((is = urlConnection.getInputStream())!=null)
			{
				baos = new ByteArrayOutputStream();
				byte ba [] = new byte[1];
 
				while ((is.read(ba,0,1)) != (-1))
					baos.write(ba,0,1);
 
				baos.flush();
				is.close();
				outPutXML =  new String(baos.toByteArray(), "UTF-8");
				//WriteLog("outPutXML responsefromfinacle----" +outPutXML);
			}
		}
		catch (Exception e){
			e.printStackTrace();
		}
		xmlParser.setInputXML(outPutXML);
		String statusCode =  xmlParser.getValueOf("Status");
		
		inputXML=inputXML.replaceAll("'","''");
		outPutXML=outPutXML.replaceAll("'","''");

		
		if(statusCode.equalsIgnoreCase("SUCCESS"))
		{
			 values="'S','success','"+inputXML+"','"+outPutXML+"'";
		}
		else
		{
			values="'F','failure','"+inputXML+"','"+outPutXML+"'";
		}
	
		String strSignatureStatusTable="AO_signature_status";
		String colName="SIGUPLOAD_STATUS,PROCESSING_REMARKS,INPUTXML,OUTPUTXML";
		
		String where = "WI_NAME='"+winame+"' and account_no ='"+account_no+"' and  customer_name1='"+customer_name1+"'";
		
		String sigUploadStatus = updateSigUploadStatus(strSignatureStatusTable,colName,values,where,cabinetName,sessionId,JtsIP,JtsPort);
		
		if(sigUploadStatus.equals("Y"))
		{
			update_Status = "S";
		}	
		else
		{
			update_Status = "F";
		}
	}
	catch (Exception e) {
				
		//WriteLog("Exception  ::"+e.getMessage());
	}
	
	return update_Status;
}
public static String getSignatureUploadXML(String base64String,String ACCNO,String CIFID,String DATE,String CustomerNameWithSingleQ,String RemarksWithSingleQ)
{	
	double n = Math.random();
	long Lrandom = Math.round(Math.random()*1000000000);
	String RequestUID="MB"+Lrandom+"";
	String integrationXML = "" +
		"<FIXML>" +
			"<Header>" +
		  "<RequestHeader>" +
			 "<MessageKey>" +
				"<RequestUUID>"+RequestUID+"</RequestUUID>" + 
				"<ServiceRequestId>SignatureAdd</ServiceRequestId>" +
				"<ServiceRequestVersion>10.2</ServiceRequestVersion>" +
				"<ChannelId>BPM</ChannelId>" + 
			 "</MessageKey>" +
			 "<RequestMessageInfo>" +
				"<BankId>RAK</BankId>" +
				"<TimeZone/>" +
				"<EntityId/>" +
				"<EntityType/>" +
				"<ArmCorrelationId/>" +
				"<MessageDateTime>2015-04-02T13:28:43.180</MessageDateTime>" + 
			 "</RequestMessageInfo>" +
			 "<Security>" +
				"<Token/>" +
				"<FICertToken/>" +
				"<RealUserLoginSessionId/>" +
				"<RealUser/>" +
				"<RealUserPwd/>" +
				"<SSOTransferToken/>" +
			 "</Security>" +
			 "<CustomInfo>" +
				"<table>" +
				   "<key/>" +
				   "<value/>" +
				"</table>" +
			 "</CustomInfo>" +
		  "</RequestHeader>" +
	   "</Header>" +
			"<Body>" +
				"<SignatureAddRequest>" +
					"<SignatureAddRq>" +
						"<AcctId>"+ACCNO+"</AcctId>" +
						"<AcctCode>N</AcctCode>" +
						"<CustId>"+CIFID+"</CustId>" +
						"<EmployeeIdent></EmployeeIdent>" +
						"<BankCode></BankCode>" +
						"<SigPowerNum></SigPowerNum>" +
						"<BankId>RAK</BankId>" +
						"<ImageAccessCode>1</ImageAccessCode>" +
						"<SigExpDt>2112-03-06T23:59:59.000</SigExpDt>" +
						"<SigEffDt>"+DATE+"</SigEffDt>" +
						"<SigFile>"+base64String+"</SigFile>" +
						"<PictureExpDt>1970-01-01T00:00:00.000</PictureExpDt>" +
						"<PictureEffDt>1970-01-01T00:00:00.000</PictureEffDt>" +
						"<PictureFile></PictureFile>" +
						"<SigGrpId>SVSB11</SigGrpId>" +
					"</SignatureAddRq>" +
					"<SignatureAdd_CustomData>" +
						"<CustomerName>"+CustomerNameWithSingleQ+"</CustomerName>" +
						"<Remarks>"+RemarksWithSingleQ+"</Remarks>" +
					"</SignatureAdd_CustomData>" +
				"</SignatureAddRequest>" +
			"</Body>" +
			"</FIXML>";
		
		
		return integrationXML;
}
public String DownloadDocument(XMLParser xmlParser,String winame,String docName,String strSignatureStatusTable,String account_no,String customer_name1,String customer_seq_no,String cabinetName,String sessionId,String JtsIP,Integer JtsPort, String VolumeId,String SiteId )
{
	//JtsIP="10.15.11.176";
	//JtsPort=3333;
	//WriteLog("inside DownloadDocument");
	String status="F";
	String msg="Error";
	String JtsP= String.valueOf(JtsPort);
	StringBuffer strFilePath = new StringBuffer();
	try
	{
		String base64String = null;
		String imageIndex = xmlParser.getValueOf("ISIndex").substring(0, xmlParser.getValueOf("ISIndex").indexOf("#"));
		
		strFilePath.append(System.getProperty("user.dir"));
		strFilePath.append(File.separator);
		strFilePath.append(fileDownloadLoc);
		strFilePath.append(File.separatorChar);
		strFilePath.append(winame);
		strFilePath.append("_");
		strFilePath.append(docName);
		strFilePath.append(".");
		strFilePath.append("TIF");

		CImageServer cImageServer=null;
		try 
		{
			cImageServer = new CImageServer(null, JtsIP, Short.parseShort(JtsP));			
		}
		catch (JPISException e) 
		{
			//WriteLog("Error Downloading signature:"+e.getMessage());
			msg = e.getMessage();
			status="F";
		}
		//WriteLog("Checking");
		//WriteLog("Checking"+JtsIP);
		//WriteLog("Checking"+JtsP);
		//WriteLog("Checking"+cabinetName);
		//WriteLog("Checking"+SiteId);
		//WriteLog("Checking"+VolumeId);
		//WriteLog("Checking"+imageIndex);
		//WriteLog("Checking"+strFilePath);
		int odDownloadCode=cImageServer.JPISGetDocInFile_MT(null,JtsIP, Short.parseShort(JtsP), cabinetName,Short.parseShort(SiteId), Short.parseShort(VolumeId), Integer.parseInt(imageIndex),"",strFilePath.toString(), new JPDBString());
		//int odDownloadCode=1;

		
		//WriteLog("odDownloadCode:...."+String.valueOf(odDownloadCode));
		
		if(odDownloadCode==1)
		{
			try
			{
				base64String=convertToBase64(strFilePath.toString());
				status=base64String;
				File fForDeletion= new File(strFilePath.toString());
				fForDeletion.delete();	
			}
			catch(Exception e)
			{
				msg=e.getMessage();
				status="F";
			}
		}
		else
		{
			msg="Error occured while downloading the document :"+docName;
			status="F";
		}
	}
	catch (Exception e) 
	{
		//WriteLog("Error Downloading file:"+e.getMessage());
		msg=e.getMessage();
		status="F";
	}
		
	if(status.equals("F"))
	{
		String colName="SIGUPLOAD_STATUS,PROCESSING_REMARKS";
		String values="'F','"+msg+"'";
		String where = "WI_NAME='"+winame+"' and account_no ='"+account_no+"' and  customer_name1='"+customer_name1+"' and customer_seq_no='"+customer_seq_no+"'";
		String sigUploadStatus = updateSigUploadStatus(strSignatureStatusTable,colName,values,where,cabinetName,sessionId,JtsIP,JtsPort);
	}
	
	return status;	
}
public static String convertToBase64(String filePath)
{
	String retValue="";
	
	try
	{
		//WriteLog("inside convertToBase64 method");
		File file = new File(filePath);
		 
		FileInputStream fis = new FileInputStream(file);
		//create FileInputStream which obtains input bytes from a file in a file system. FileInputStream is meant for reading streams of raw bytes such as image data. For reading streams of characters, consider using FileReader.
 
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		byte[] buf = new byte[1024];
		long size=0;
		
		try
		{
			for (int readNum; (readNum = fis.read(buf)) != -1;)
			{
				//Writes to this byte array output stream
				bos.write(buf, 0, readNum); 
				// out.println("read " + readNum + " bytes,");
				size=size+readNum;
			}
			
			byte[] encodedBytes = Base64.encodeBase64(bos.toByteArray());  
			String sEncodedBytes=new String(encodedBytes);
			
			retValue=sEncodedBytes;	
			//WriteLog("Base64 string..:" +retValue);
		}
		catch (IOException ex)
		{  
		  //WriteLog("Error converting to Base64:"+ex.getMessage());
		}
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
	return retValue;
}
public String ExecuteQuery_APSelectWithColumnNames(String sQuery,String sEngineName,String sSessionId)
{
	WFInputXml wfInputXml = new WFInputXml();

	wfInputXml.appendStartCallName("APSelectWithColumnNames", "Input");
	wfInputXml.appendTagAndValue("Query",sQuery);
	wfInputXml.appendTagAndValue("EngineName",sEngineName);
	wfInputXml.appendTagAndValue("SessionId",sSessionId);
	wfInputXml.appendEndCallName("APSelectWithColumnNames","Input");
	return wfInputXml.toString();
}
public String ExecuteQuery_APSelectWithNamedParams(String sQuery,String sEngineName,String sSessionId,String params)
{
	WFInputXml wfInputXml = new WFInputXml();

	wfInputXml.appendStartCallName("APSelectWithNamedParam", "Input");
	wfInputXml.appendTagAndValue("Query",sQuery);
	wfInputXml.appendTagAndValue("EngineName",sEngineName);
	wfInputXml.appendTagAndValue("SessionId",sSessionId);
	wfInputXml.appendTagAndValue("Params",params);
	wfInputXml.appendEndCallName("APSelectWithNamedParam","Input");
	return wfInputXml.toString();
}
public String UpdateWIProcessedStatus(String winame,String cabinetName, String sessionId,String JtsIP,Integer JtsPort)
{
	String UpdateWIStatus="";
	try
	{
		XMLParser xmlParser = new XMLParser();
		String strSignatureStatusTable="AO_signature_status";
		String colName="IsWIProcessed";
		String values="'Y'";
		String where = "WI_NAME='"+winame+"'";
			
		String inputXML=ExecuteQuery_APUpdate(strSignatureStatusTable,colName,values,where,cabinetName,sessionId);
		//WriteLog("inputXML for UpdateWIProcessedStatus" +inputXML);	
		//String outPutXML =WFCallBroker.execute(inputXML,JtsIP, JtsPort, 1);
		//WriteLog("outPutXML for UpdateWIProcessedStatus" +outPutXML);
		String outPutXML = NGEjbClient.getSharedInstance().makeCall(JtsIP, String.valueOf(JtsPort),"WebSphere" , inputXML);
		
		xmlParser.setInputXML(outPutXML);		
		String mainCode = xmlParser.getValueOf("MainCode");
		
		if(mainCode.equals("0"))
		{
			UpdateWIStatus="Success";
		}	
		else
		{
			UpdateWIStatus="Failure";
		}
	}
	catch (Exception e) {
		//WriteLog("Error updatig status:"+e.getMessage());
	}
	return UpdateWIStatus;
}

%>
