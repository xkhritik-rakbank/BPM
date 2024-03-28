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
<%@ include file="../TWC_Specific/Log.process"%>

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%!
    public void deleteLocalDocument(String sFileName){
		logger.info("Delete File Path: "+sFileName);
		try{
			File file = new File(sFileName);
			if(file.delete()){
				logger.info(file.getName() + " is deleted!");
			}else{
				logger.info("\n Delete operation is failed.");
			}
		}catch(Exception e){
			logger.info("\n Exception in deleteLocalDocument:-"+e.getMessage());
		}
	}
	
	
	public String SearchExistingDoc(String pid, String FrmType, String sCabname, String sSessionId, String sJtsIp, int iJtsPort_int, String sFilepath) {
        
				String volumeid=xmlParserData.getVal("ImageVolumeIndex");
				String FolderIndex=xmlParserData.getVal("FOLDERINDEX");

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
										"<VolumeIndex>"+volumeid+"</VolumeIndex>"+
										"<FilePath>"+strDocumentPath+"</FilePath>"+
										"<ISIndex>"+ISINDEX.m_nDocIndex+"#"+ISINDEX.m_sVolumeId+"</ISIndex>" + 
										"<NoOfPages>1</NoOfPages>" + 
										"<DocumentType>N</DocumentType>" +
										"<DocumentSize>"+lstrDocFileSize+"</DocumentSize>" +
										"</NGOAddDocument_Input>";
						
						}
						logger.info("Document Addition sInputXML: "+sMappedInputXml);
						String sOutputXml = WFCustomCallBroker.execute(sMappedInputXml, sJtsIp, iJtsPort, 1);
						logger.info("Document Addition sOutputXml: "+sOutputXml);
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
		logger.info("inside ODAddDocument.jsp");
		String pid=request.getParameter("winame");
		if (pid != null) {pid=pid.replace("'","");}
		String sCabname=customSession.getEngineName();
		logger.info("sCabname"+sCabname);
		String sSessionId = customSession.getDMSSessionId();  
		logger.info("sSessionId"+sSessionId);
		String sJtsIp = customSession.getJtsIp();
		logger.info("sJtsIp"+sJtsIp);
		int iJtsPort_int =customSession.getJtsPort();
		//String volumeid="1";
		String sPath="";		
		String path = System.getProperty("user.dir");
		logger.info(" \nAbsolute Path :" + path);		
		String pdfTemplatePath = "";
		String generatedPdfPath = "";
		String pdfName = "";

		//Reading path from property file
		Properties properties = new Properties();
		properties.load(new FileInputStream(System.getProperty("user.dir")+ System.getProperty("file.separator")+ "RakBankConfig.properties"));
			
		
		String FrmType = properties.getProperty("DocumentName");
		//String volumeid = properties.getProperty("VolumeID");
		
		if(FrmType.equalsIgnoreCase("Doc_Template_Generation"))
		{
		 pdfName ="template";
		}
		
		
		String dynamicPdfName="";
		if(FrmType.equalsIgnoreCase("Doc_Template_Generation"))
			 dynamicPdfName = pid + pdfName + ".docx";
		 
			pdfTemplatePath = path + pdfTemplatePath;//Getting complete path of the pdf tempplate
			generatedPdfPath = properties.getProperty("TWC_GENERTATED_HTML_PATH");//Get the loaction of the path where generated template will be saved
			generatedPdfPath += dynamicPdfName;
			generatedPdfPath = path + generatedPdfPath;//Complete path of generated PDF
			logger.info("\nGeneratedPdfPath :" + generatedPdfPath);
		
		//if(ProcesspdfFile(generatedPdfPath, HtemData, sOutput_Dir)) {
			docxml = SearchExistingDoc(pid,FrmType,sCabname,sSessionId,sJtsIp,iJtsPort_int,generatedPdfPath);
			logger.info("Final Document Output: "+docxml);
			documentindex = getTagValue(docxml,"DocumentIndex");
			if(getTagValue(docxml,"Option").equalsIgnoreCase("NGOChangeDocumentProperty")) {
				doctype="deleteadd";
			} else {
				doctype="new";
			}
			logger.info(docxml+"~"+documentindex+"~"+doctype+"~"+dynamicPdfName);
			out.println(docxml+"~"+documentindex+"~"+doctype+"~"+dynamicPdfName);
		//}
		
		}
	 catch (Exception e) {
		logger.info("Exception: "+e);
		out.println("NG107~"+docxml);
	}
%>