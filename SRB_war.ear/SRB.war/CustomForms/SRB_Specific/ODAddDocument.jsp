<%@page contentType="text/html; charset=utf-8"%>
<%@page pageEncoding="utf-8"%>

<%@page import="java.net.*"%>
<%@page import="java.lang.String.*"%>
<%@page import="java.io.*,java.util.*"%>
<%@page import="java.awt.Color"%>
<%@page import="java.text.*"%>
<%@ page import="java.math.*"%>
 
<%@page import="ISPack.ISUtil.JPISException"%>
<%@page import="ISPack.CPISDocumentTxn"%>
<%@page import="ISPack.ISUtil.JPDBRecoverDocData"%>
<%@page import="ISPack.ISUtil.JPISIsIndex"%>

<%@page import ="Jdts.DataObject.*"%>

<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../SRB_Specific/Log.process"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%!
    public void deleteLocalDocument(String sFileName){
		WriteLog("Delete File Path: "+sFileName);
		try{
			File file = new File(sFileName);
			if(file.delete()){
				WriteLog(file.getName() + " is deleted!");
			}else{
				WriteLog("\n Delete operation is failed.");
			}
		}catch(Exception e){
			WriteLog("\n Exception in deleteLocalDocument:-"+e.getMessage());
		}
	}
	
	
	public String SearchExistingDoc(String pid, String FrmType, String sCabname, String sSessionId, String sJtsIp, int iJtsPort_int, String sFilepath) {
        try {
			
			WFCustomXmlResponse xmlParserData=null;
			WFCustomXmlList objWorkList=null;
			
            short iJtsPort = (short) iJtsPort_int;
			String sInputXML = "<?xml version=\"1.0\"?>"
                    + "<APSelectWithColumnNames_Input>"
                    + "<Option>APSelectWithColumnNames</Option>"
                    + "<EngineName>" + sCabname + "</EngineName>"
                    + "<SessionId>" + sSessionId + "</SessionId>"
                    + "<Query>SELECT FOLDERINDEX,ImageVolumeIndex FROM PDBFOLDER WHERE NAME='" + pid + "'</Query>"
                    + "</APSelectWithColumnNames_Input>";
			WriteLog("Folder Index sInputXML: "+sInputXML);
			String sOutputXML_Parent = WFCustomCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
			WriteLog("Folder Index sOutputXML_Parent: "+sOutputXML_Parent);
			xmlParserData=new WFCustomXmlResponse();
				xmlParserData.setXmlString((sOutputXML_Parent));
				
            //WFXmlResponse xmlResponse_Parent = new WFXmlResponse(sOutputXML_Parent);
			if (xmlParserData.getVal("MainCode").equalsIgnoreCase("0")) {
				String volumeid=xmlParserData.getVal("ImageVolumeIndex");
				String FolderIndex=xmlParserData.getVal("FOLDERINDEX");
				sInputXML = "<?xml version=\"1.0\"?>"
						+ "<APSelectWithColumnNames_Input>"
						+ "<Option>APSelectWithColumnNames</Option>"
						+ "<EngineName>" + sCabname + "</EngineName>"
						+ "<SessionId>" + sSessionId + "</SessionId>"
						+ "<Query>SELECT a.documentindex,b.ParentFolderIndex FROM PDBDOCUMENT A WITH (NOLOCK), PDBDOCUMENTCONTENT B WITH (NOLOCK)"
						+ "WHERE A.DOCUMENTINDEX= B.DOCUMENTINDEX AND A.NAME IN ('" + FrmType + "','') AND B.PARENTFOLDERINDEX ='" + volumeid + "'</Query>"
						+ "</APSelectWithColumnNames_Input>";
				WriteLog("Duplicate document validation sInputXML: "+sInputXML);
				String sOutputXML = WFCustomCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
				WriteLog("Duplicate document validation sOutputXML: "+sOutputXML);
				xmlParserData=new WFCustomXmlResponse();
				xmlParserData.setXmlString((sOutputXML));
				
				//WFXmlResponse xmlResponse = new WFXmlResponse(sOutputXML);
				int iTotalrec = Integer.parseInt(getTagValue(sOutputXML, "TotalRetrieved"));
				WriteLog("Total retreived iTotalrec: "+iTotalrec);
				if (xmlParserData.getVal("MainCode").equalsIgnoreCase("0")) {
					try {
						String filepath = sFilepath;
						
						File newfile = new File(filepath);
						String name = newfile.getName();
						String ext = "";
						String sMappedInputXml="";
						if (name.contains(".")) {
							ext = name.substring(name.lastIndexOf("."), name.length());
						}
						JPISIsIndex ISINDEX = new JPISIsIndex();
						JPDBRecoverDocData JPISDEC = new JPDBRecoverDocData();
						String strDocumentPath = sFilepath;
						File processFile = null;
						long lLngFileSize = 0L;
						processFile = new File(strDocumentPath);
						
						lLngFileSize = processFile.length();
						String lstrDocFileSize = "";
						lstrDocFileSize = Long.toString(lLngFileSize);
						
						String createdbyappname = "";
						createdbyappname = ext.replaceFirst(".", "");
						Short volIdShort = Short.valueOf(volumeid);
						
						if (lLngFileSize != 0L)
						{
							
							CPISDocumentTxn.AddDocument_MT(null, sJtsIp, iJtsPort, sCabname, volIdShort.shortValue(), strDocumentPath, JPISDEC, "", ISINDEX);
							
						}
						if (iTotalrec > 0) 
						{  
									
							 objWorkList = xmlParserData.createList("Records", "Record");
							for (; objWorkList.hasMoreElements(true); objWorkList.skip(true)) {
								WriteLog("NGOChangeDocumentProperty_Input section");
								 sMappedInputXml = "<?xml version=\"1.0\"?>"
										+ "<NGOChangeDocumentProperty_Input>"
										+ "<Option>NGOChangeDocumentProperty</Option>"
										+ "<CabinetName>" + sCabname + "</CabinetName>"
										+ "<UserDBId>" + sSessionId + "</UserDBId><Document><DocumentIndex>" + objWorkList.getVal("documentindex") + "</DocumentIndex><NoOfPages>1</NoOfPages>"
										+ "<DocumentName>" + FrmType + "</DocumentName>"
										+ "<AccessDateTime>1999-10-2 5:51:0.0</AccessDateTime>"
										+ "<ExpiryDateTime>2099-12-12 0:0:0.0</ExpiryDateTime>"
										+ "<CreatedByAppName>" + createdbyappname + "</CreatedByAppName>"
										+ "<VersionFlag>N</VersionFlag>"
										+ "<AccessType>S</AccessType>"
										+ "<ISIndex>" + ISINDEX.m_nDocIndex + "#" + ISINDEX.m_sVolumeId + "</ISIndex><TextISIndex>0#0#</TextISIndex>"
										+ "<DocumentType>N</DocumentType>"
										+ "<DocumentSize>" + lstrDocFileSize + "</DocumentSize><Comment>" + createdbyappname + "</Comment><RetainAnnotation>N</RetainAnnotation></Document>"
										+ "</NGOChangeDocumentProperty_Input>";    
							}
						} 
						else 
						{
							
							sMappedInputXml="<?xml version=\"1.0\"?>"+
										"<NGOAddDocument_Input>"+ 
										"<Option>NGOAddDocument</Option>"+ 
										"<CabinetName>"+sCabname+"</CabinetName>"+ 
										"<UserDBId>"+sSessionId+"</UserDBId>" + 
										"<GroupIndex>0</GroupIndex>" +
										"<VersionFlag>Y</VersionFlag>" +
										"<ParentFolderIndex>"+FolderIndex+"</ParentFolderIndex>" +
										"<DocumentName>"+FrmType+"</DocumentName>"+
										"<CreatedByAppName>"+createdbyappname+"</CreatedByAppName>" +
										"<Comment>"+FrmType+"</Comment>" +
										"<VolumeIndex>1</VolumeIndex>"+
										"<FilePath>"+strDocumentPath+"</FilePath>"+
										"<ISIndex>"+ISINDEX.m_nDocIndex+"#"+ISINDEX.m_sVolumeId+"</ISIndex>" + 
										"<NoOfPages>1</NoOfPages>" + 
										"<DocumentType>N</DocumentType>" +
										"<DocumentSize>"+lstrDocFileSize+"</DocumentSize>" +
										"</NGOAddDocument_Input>";
						
						}
						WriteLog("Document Addition sInputXML: "+sMappedInputXml);
						String sOutputXml = WFCustomCallBroker.execute(sMappedInputXml, sJtsIp, iJtsPort, 1);
						WriteLog("Document Addition sOutputXml: "+sOutputXml);
						String status_D = getTagValue(sOutputXml, "Status");
						if(status_D.equalsIgnoreCase("0")){
							//deleteLocalDocument(sFilepath);
							return sOutputXml;
						} else {
							return "Error in Document Addition";
						}
					} catch (JPISException e) {
						return "Error in Document Addition at Volume";
					} catch (Exception e) {
						return "Exception Occurred in Document Addition";
					}
				} 
			}
			return "Any Error occurred in Addition of Document";
        } catch (Exception e) {
            return "Exception Occurred in SearchDocument";
        }
    }
	
    String getTagValue(String sXML, String sTagName) {
        String sTagValue = "";
        String sStartTag = "<" + sTagName + ">";
        String sEndTag = "</" + sTagName + ">";
        if (sXML.indexOf("<" + sTagName + ">") != -1) {
            sTagValue = sXML.substring(sXML.indexOf(sStartTag) + sStartTag.length(), sXML.indexOf(sEndTag));
        } else {
            if (sTagName.equals("noOfRecordsFetched")) {
                sTagValue = "0";
            }
        }
        return sTagValue;
    }
%>
<%	
	String docxml="";
	String documentindex="";
	String doctype="";
	try{
		WriteLog("inside ODAddDocument.jsp");
		String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );    
		String pid = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
		if (pid != null) {pid=pid.replace("'","''");}
		WriteLog("Proess Instance Id: "+pid);
		String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("request_type"), 1000, true) );    
		String FrmType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
		if (FrmType != null) {FrmType=FrmType.replace("'","''");}
		WriteLog("Integration call: "+FrmType);
		String sCabname=customSession.getEngineName();
		WriteLog("sCabname"+sCabname);
		String sSessionId = customSession.getDMSSessionId();  
		WriteLog("sSessionId"+sSessionId);
		String sJtsIp = customSession.getJtsIp();
		WriteLog("sJtsIp"+sJtsIp);
		int iJtsPort_int =customSession.getJtsPort();
		//String volumeid="1";
		String sPath="";		
		//WriteLog("volumeid"+volumeid);	
		String path = System.getProperty("user.dir");
		WriteLog(" \nAbsolute Path :" + path);		
		String pdfTemplatePath = "";
		String generatedPdfPath = "";
		String pdfName = "";

		//Reading path from property file
		Properties properties = new Properties();
		properties.load(new FileInputStream(System.getProperty("user.dir")+ System.getProperty("file.separator")+ "RakBankConfig.properties"));
			
		
	
		
		if(FrmType.equalsIgnoreCase("Duplicate_Check_Result"))
		{
		 pdfName ="Dedupe";
		}
		else if(FrmType.equalsIgnoreCase("Black_List_Check_Result"))
		{
		 pdfName = "BlackList";	
		}
		else if(FrmType.equalsIgnoreCase("Emirates_ID"))
		{
		 pdfName = "EmiratesID";	
		}
		else if(FrmType.equalsIgnoreCase("Risk_Score_Detail"))
		{
		 pdfName = "Risk_Score";
		//pdfName = "Risk_Score_"+ System.currentTimeMillis()/1000*60;
		
		}
		WriteLog("Template Path: "+pdfName);
		
		/*String sOutput_Dir = System.getProperty("user.dir") + "\\BM_ST\\Temp\\ApplicationForm_"+pid+".pdf";
		WriteLog("External Template Path: "+sOutput_Dir);*/
		
		//"+pid+"Dedupe.pdf"
		String dynamicPdfName="";
		if(FrmType.equalsIgnoreCase("Risk_Score_Detail"))
			 dynamicPdfName = pdfName + ".pdf";
		else
			 dynamicPdfName = pid + pdfName + ".pdf";
		 
			pdfTemplatePath = path + pdfTemplatePath;//Getting complete path of the pdf tempplate
			generatedPdfPath = properties.getProperty("SRB_GENERTATED_PDF_PATH");//Get the loaction of the path where generated template will be saved
			generatedPdfPath += dynamicPdfName;
			generatedPdfPath = path + generatedPdfPath;//Complete path of generated PDF
			WriteLog("\nGeneratedPdfPath :" + generatedPdfPath);
		
		
		
		//if(ProcesspdfFile(generatedPdfPath, HtemData, sOutput_Dir)) {
			docxml = SearchExistingDoc(pid,FrmType,sCabname,sSessionId,sJtsIp,iJtsPort_int,generatedPdfPath);
			WriteLog("Final Document Output: "+docxml);
			documentindex = getTagValue(docxml,"DocumentIndex");
			if(getTagValue(docxml,"Option").equalsIgnoreCase("NGOChangeDocumentProperty")) {
				doctype="deleteadd";
			} else {
				doctype="new";
			}
			WriteLog(docxml+"~"+documentindex+"~"+doctype+"~"+dynamicPdfName);
			out.println(docxml+"~"+documentindex+"~"+doctype+"~"+dynamicPdfName);
		//}
	} catch (Exception e) {
		WriteLog("Exception: "+e);
		out.println("NG107~"+docxml);
	}
%>