<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank Trade License
//Module                     : Fetch Previous year TL 
//File Name					 : GetPreviousYrTL.jsp
//Author                     : Ankit Arya
// Date written (DD/MM/YYYY) : 12-02-2016
//Description                : Getting previous yr trade license from omnidocs.
//---------------------------------------------------------------------------------------------------->
<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>

<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="java.math.*"%>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@ page import="com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!---<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>--->
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<%!

	public String getNGOGetIDFromName_InputXML(String dataClass,String engineName,String sessionId){
		String xml="<?xml version=\"1.0\"?\n>"+
			"<NGOGetIDFromName_Input>\n"+
			"<Option>NGOGetIDFromName</Option>\n"+
			"<UserDBId>"+sessionId+"</UserDBId>\n"+
			"<CabinetName>"+engineName+"</CabinetName>\n"+
			"<ObjectType>X</ObjectType>\n"+
			"<ObjectName>"+dataClass+"</ObjectName>\n"+
			"<MainGroupIndex>0</MainGroupIndex>\n"+
			"</NGOGetIDFromName_Input>";
	
			return xml;
	}
	
	public String getNGOGetDataDefProperty_InputXML(String DataDefIndex,String engineName,String sessionId )
	{
		String xml="<?xml version=\"1.0\"?\n>"+
			"<NGOGetDataDefProperty_Input>\n"+
			"<Option>NGOGetDataDefProperty</Option>\n"+
			"<UserDBId>"+sessionId+"</UserDBId>\n"+
			"<CabinetName>"+engineName+"</CabinetName>\n"+
			"<DataDefIndex>"+DataDefIndex+"</DataDefIndex>\n"+
			"</NGOGetDataDefProperty_Input>";
			return xml;	

	}
	public String getNGOSearchFolder_InputXML(String strLookInFolderIndex,String strCIFID,String engineName,String sessionId )
	{
		String xml="<?xml version=\"1.0\"?>\n"+
			"<NGOSearchFolder_Input>\n"+
			"<Option>NGOSearchFolder</Option>\n"+
			"<CabinetName>"+engineName+"</CabinetName>\n"+
			"<UserDBId>"+sessionId+"</UserDBId>\n"+
			"<LookInFolder>"+strLookInFolderIndex+"</LookInFolder>\n"+
			"<IncludeSubFolder>N</IncludeSubFolder>\n"+
			"<Name>ManBusiness"+strCIFID+"</Name>\n"+
			"<Owner></Owner>\n"+
			"<CreationDateRange></CreationDateRange>\n"+
			"<ExpiryDateRange></ExpiryDateRange>\n"+
			"<AccessDateRange></AccessDateRange>\n"+
			"<RevisedDateRange></RevisedDateRange>\n"+
			"<DataDefinitions>\n"+
			"<DataDefIndex></DataDefIndex>\n"+
			"</DataDefinitions>\n"+
			"<SearchScope>0</SearchScope>\n"+
			"<PrevFolderList></PrevFolderList>\n"+
			"<ReferenceFlag>O</ReferenceFlag>\n"+
			"<StartFrom>1</StartFrom>\n"+
			"<NoOfRecordsToFetch>10</NoOfRecordsToFetch>\n"+
			"<OrderBy>2</OrderBy>\n"+
			"<SortOrder>A</SortOrder>\n"+
			"<MaximumHitCountFlag>Y</MaximumHitCountFlag>\n"+
			"<FolderType>G</FolderType>\n"+
			"<IncludeTrashFlag>N</IncludeTrashFlag>\n"+
			"<ReportFlag>N</ReportFlag>\n"+
			"<ShowPath>Y</ShowPath>\n"+
			"</NGOSearchFolder_Input>";
		return xml;	
	}
	public String getNGOSearchDocumentExt_InputXMLforCIF(String DataDefIndex , String IndexId , String IndexValue,String engineName,String sessionId){
		String xml="<?xml version=\"1.0\"?\n>"+
			"<NGOSearchDocumentExt_Input>\n"+
			"<Option>NGOSearchDocumentExt</Option>\n"+
			"<UserDBId>"+sessionId+"</UserDBId>\n"+
			"<CabinetName>"+engineName+"</CabinetName>\n"+
			"<SearchText></SearchText>\n"+
			"<Rank>Y</Rank>\n"+
			"<SearchOnPreviousVersions>N</SearchOnPreviousVersions>\n"+
			"<LookInFolder>0</LookInFolder>\n"+
			"<IncludeSubFolder>Y</IncludeSubFolder>\n"+
			"<DataDefCriterion>\n"+
			"<DataDefCriteria>\n"+
			"<DataDefIndex>"+DataDefIndex+"</DataDefIndex>\n"+
			"<IndexId>"+IndexId+"</IndexId>\n"+
			"<Operator>=</Operator>\n"+
			"<IndexValue>"+IndexValue+"</IndexValue>\n"+
			"<JoinCondition></JoinCondition>\n"+
			"</DataDefCriteria>\n"+
			"</DataDefCriterion>\n"+
			"<SearchScope>0</SearchScope>\n"+
			"<SearchOnAlias>N</SearchOnAlias>\n"+
			"<ReferenceFlag>B</ReferenceFlag>\n"+
			"<SortOrder>D</SortOrder>\n"+
			"<GroupIndex>0</GroupIndex>\n"+
			"<StartFrom>1</StartFrom>\n"+
			"<NoOfRecordsToFetch>100</NoOfRecordsToFetch>\n"+
			"<OrderBy>5</OrderBy>\n"+
			"<MaximumHitCountFlag>Y</MaximumHitCountFlag>\n"+
			"<CheckOutByUser></CheckOutByUser>\n"+
			"<ObjectTypes>\n"+
			"<ObjectType>1</ObjectType>\n"+
			"<ObjectType>2</ObjectType>\n"+
			"<ObjectType>8</ObjectType>\n"+
			"<ObjectType>11</ObjectType>\n"+
			"<ObjectType>13</ObjectType>\n"+
			"<ObjectType>14</ObjectType>\n"+
			"<ObjectType>15</ObjectType>\n"+
			"<ObjectType>16</ObjectType>\n"+
			"<ObjectType>17</ObjectType>\n"+
			"</ObjectTypes>\n"+
			"<DataAlsoFlag>Y</DataAlsoFlag>\n"+
			"<CreatedByAppName></CreatedByAppName>\n"+
			"<AnnotationFlag>Y</AnnotationFlag>\n"+
			"<LinkDocFlag>Y</LinkDocFlag>\n"+
			"<PrevDocIndex>0</PrevDocIndex>\n"+
			"<IncludeSystemFolder>NN</IncludeSystemFolder>\n"+
			"<ReportFlag>N</ReportFlag>\n"+
			"<ThesaurusFlag>N</ThesaurusFlag>\n"+
			"</NGOSearchDocumentExt_Input>";
			
			return xml;
	}
	
	public String getNGOSearchDocumentExt_InputXML(String lookInFolderIndex ,String engineName,String sessionId){
		String xml="<?xml version=\"1.0\"?>\n"+
			"<NGOSearchDocumentExt_Input>\n"+
			"<Option>NGOSearchDocumentExt</Option>\n"+
			"<UserDBId>"+sessionId+"</UserDBId>\n"+
			"<CabinetName>"+engineName+"</CabinetName>\n"+
			"<SearchText></SearchText>\n"+
			"<Rank>Y</Rank>\n"+
			"<SearchOnPreviousVersions>N</SearchOnPreviousVersions>\n"+
			"<LookInFolder>"+lookInFolderIndex+"</LookInFolder>\n"+
			"<IncludeSubFolder>Y</IncludeSubFolder>\n"+
			"<DataDefCriterion>\n"+			
			"</DataDefCriterion>\n"+
			"<SearchScope>0</SearchScope>\n"+
			"<SearchOnAlias>N</SearchOnAlias>\n"+
			"<ReferenceFlag>B</ReferenceFlag>\n"+
			"<SortOrder>D</SortOrder>\n"+
			"<GroupIndex>0</GroupIndex>\n"+
			"<StartFrom>1</StartFrom>\n"+
			"<NoOfRecordsToFetch>100</NoOfRecordsToFetch>\n"+
			"<OrderBy>5</OrderBy>\n"+
			"<MaximumHitCountFlag>Y</MaximumHitCountFlag>\n"+
			"<CheckOutByUser></CheckOutByUser>\n"+
			"<ObjectTypes>\n"+
			"<ObjectType>1</ObjectType>\n"+
			"<ObjectType>2</ObjectType>\n"+
			"<ObjectType>8</ObjectType>\n"+
			"<ObjectType>11</ObjectType>\n"+
			"<ObjectType>13</ObjectType>\n"+
			"<ObjectType>14</ObjectType>\n"+
			"<ObjectType>15</ObjectType>\n"+
			"<ObjectType>16</ObjectType>\n"+
			"<ObjectType>17</ObjectType>\n"+
			"</ObjectTypes>\n"+
			"<DataAlsoFlag>Y</DataAlsoFlag>\n"+
			"<CreatedByAppName></CreatedByAppName>\n"+
			"<AnnotationFlag>Y</AnnotationFlag>\n"+
			"<LinkDocFlag>Y</LinkDocFlag>\n"+
			"<PrevDocIndex>0</PrevDocIndex>\n"+
			"<IncludeSystemFolder>NN</IncludeSystemFolder>\n"+
			"<ReportFlag>N</ReportFlag>\n"+
			"<ThesaurusFlag>N</ThesaurusFlag>\n"+
			"</NGOSearchDocumentExt_Input>";
			
			return xml;
	}
	
	public String getAPSelectWithColumnNames_InputXML(String tableName, String workitemname,String engineName,String sessionId){
		String Query="SELECT ItemIndex FROM "+tableName+" WHERE WI_NAME = '"+workitemname+"'";
		//WriteLog("AP_Select Query = " + Query);
		String xml= "<?xml version=\"1.0\"?\n>"+
			"<APSelectWithColumnNames_Input>\n"+
			"<Option>APSelectWithColumnNames</Option>\n"+
			"<Query>"+Query+"</Query>\n"+
			"<EngineName>"+engineName+"</EngineName>\n"+
			"<SessionId>"+sessionId+"</SessionId>\n"+
			"</APSelectWithColumnNames_Input>";
		
		return xml;
		
	}
	public String getNGOCopyDocumentExt_InputXML(String DestFolderIndex,String ParentFolderIndex,String DocumentIndex,String engineName,String sessionId){
		String xml= "<?xml version=\"1.0\"?\n>"+
			"<NGOCopyDocumentExt_Input>\n"+
			"<Option>NGOCopyDocumentExt</Option>\n"+
			"<UserDBId>"+sessionId+"</UserDBId>\n"+
			"<CabinetName>"+engineName+"</CabinetName>\n"+
			"<DestFolderIndex>"+DestFolderIndex+"</DestFolderIndex>\n"+//<!-->Workitem Folder index/itemindex<-->
			"<DataAlsoFlag>N</DataAlsoFlag>\n"+
			"<DuplicateName>Y</DuplicateName>\n"+
			"<VersionAlso>Y</VersionAlso>\n"+
			"<Documents>\n"+
			"<Document>\n"+      
			"<DocumentIndex>"+DocumentIndex+"</DocumentIndex>\n"+//<!-->From above call response<-->
			"<ParentFolderIndex>"+ParentFolderIndex+"</ParentFolderIndex>\n"+ //<!-->From above call response<-->
			"</Document>\n"+
			"</Documents>\n"+     
			"</NGOCopyDocumentExt_Input>";
			
			return xml;
	}

	public String getNGOChangeDocumentProperty_InputXML(String documentIndex,String engineName,String sessionId){
		String documentName = "Previous_Years_Trade_License";
		String xml= "<?xml version=\"1.0\"?\n>"+
			"<NGOChangeDocumentProperty_Input>\n"+
			"<Option>NGOChangeDocumentProperty</Option>\n"+
			"<UserDBId>"+sessionId+"</UserDBId>\n"+
			"<CabinetName>"+engineName+"</CabinetName>\n"+
			"<GroupIndex>0</GroupIndex>\n"+
			"<Document>\n"+
			"<DocumentIndex>"+documentIndex+"</DocumentIndex>\n"+
			"<DocumentName>"+documentName+"</DocumentName>\n"+
			"<VersionFlag>N</VersionFlag>\n"+
			"<Comment></Comment>\n"+
			"<Keywords>\n"+
			"<KeywordProperty>\n"+
			"<Keyword></Keyword>\n"+
			"</KeywordProperty>\n"+
			"</Keywords>\n"+
			"</Document>\n"+
			"</NGOChangeDocumentProperty_Input>";
			
			return xml;
	}
	public String getTagValues(String sXML, String sTagName) 
	{
		String sTagValues = "";
		String sStartTag = "<" + sTagName + ">";
		String sEndTag = "</" + sTagName + ">";
		String tempXML = sXML;
		try {
			for (int i = 0; i < sXML.split(sEndTag).length - 1; i++) {
				if (tempXML.indexOf(sStartTag) != -1) {
					sTagValues += tempXML.substring(tempXML.indexOf(sStartTag)
							+ sStartTag.length(), tempXML.indexOf(sEndTag));
					tempXML = tempXML.substring(tempXML.indexOf(sEndTag)
							+ sEndTag.length(), tempXML.length());
				}
				if (tempXML.indexOf(sStartTag) != -1) {
					sTagValues += ",";
				}
			}
		} catch (Exception e) {
			//WriteLog("Exception: " + e.getMessage());
		}
		return sTagValues;
	}

%>



<%	

String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("cif_num"), 1000, true) );
			String cif_num_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("cif_num Request.getparameter---> "+request.getParameter("cif_num"));
			WriteLog("cif_num Esapi---> "+cif_num_Esapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
			String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("WINAME Request.getparameter---> "+request.getParameter("WINAME"));
			WriteLog("WINAME Esapi---> "+WINAME_Esapi);
			
			
	String TLCifFoundStatus = "";
	String CIFID = cif_num_Esapi;
	try{
			String sJtsIp = null;
			int iJtsPort = 0;
			XMLParser xmlParser=new XMLParser();
			String status="-1";
			
			String workitemname = WINAME_Esapi;
			WriteLog("workitemname = "+workitemname);
			//sJtsIp = wfsession.getJtsIp();
			sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
			//iJtsPort = wfsession.getJtsPort();
			iJtsPort = Integer.parseInt(wDSession.getM_objCabinetInfo().getM_strServerPort());
		//	String NGOGetIDFromName_InputXML = getNGOGetIDFromName_InputXML("ManBusiness",wfsession.getEngineName(),wfsession.getSessionId());
			String NGOGetIDFromName_InputXML = getNGOGetIDFromName_InputXML("ManBusiness",wDSession.getM_objCabinetInfo().getM_strCabinetName(),wDSession.getM_objUserInfo().getM_strSessionId());
			WriteLog("NGOGetIDFromName_InputXML = "+NGOGetIDFromName_InputXML);
			
			//String NGOGetIDFromName_OutputXML = WFCallBroker.execute(NGOGetIDFromName_InputXML,sJtsIp,iJtsPort,1);
			String NGOGetIDFromName_OutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), NGOGetIDFromName_InputXML);
			WriteLog("NGOGetIDFromName_OutputXML = "+NGOGetIDFromName_OutputXML);
			
			xmlParser.setInputXML(NGOGetIDFromName_OutputXML);
			if(xmlParser.getValueOf("Status").equalsIgnoreCase("0"))
			{
				String objectIndex=xmlParser.getValueOf("ObjectIndex");
				//String NGOGetDataDefProperty_InputXML = getNGOGetDataDefProperty_InputXML(objectIndex,wfsession.getEngineName(),wfsession.getSessionId());
				String NGOGetDataDefProperty_InputXML = getNGOGetDataDefProperty_InputXML(objectIndex,wDSession.getM_objCabinetInfo().getM_strCabinetName(),wDSession.getM_objUserInfo().getM_strSessionId());
				//String NGOGetDataDefProperty_OutputXML = WFCallBroker.execute(NGOGetDataDefProperty_InputXML,sJtsIp,iJtsPort,1);
				String NGOGetDataDefProperty_OutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), NGOGetDataDefProperty_InputXML);
				status="1";
				xmlParser.setInputXML(NGOGetDataDefProperty_OutputXML);
				if(xmlParser.getValueOf("Status").equalsIgnoreCase("0"))
				{
					String []indexValues=getTagValues(NGOGetDataDefProperty_OutputXML, "IndexName").split(",");
					String []indexIds=getTagValues(NGOGetDataDefProperty_OutputXML, "IndexId").split(",");
					String indexId = "";
					String indexValue=CIFID;
					status="2";
					for(int i=0;i<indexValues.length;i++)
					{
						if(indexValues[i].equalsIgnoreCase("CIFID"))
						{
							indexId = indexIds[i];
							break;
						}
					}
					
					//String NGOSearchDocumentExt_InputXML = getNGOSearchDocumentExt_InputXMLforCIF(objectIndex,indexId,indexValue,wfsession.getEngineName(),wfsession.getSessionId());
					String NGOSearchDocumentExt_InputXML = getNGOSearchDocumentExt_InputXMLforCIF(objectIndex,indexId,indexValue,wDSession.getM_objCabinetInfo().getM_strCabinetName(),wDSession.getM_objUserInfo().getM_strSessionId());
					WriteLog("NGOSearchDocumentExt_InputXML:::::::: "+NGOSearchDocumentExt_InputXML);
					
				//	String NGOSearchDocumentExt_OutputXML = WFCallBroker.execute(NGOSearchDocumentExt_InputXML,sJtsIp,iJtsPort,1);
					String NGOSearchDocumentExt_OutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), NGOSearchDocumentExt_InputXML);
					WriteLog("NGOSearchDocumentExt_OutputXML:::::::: "+NGOSearchDocumentExt_OutputXML);
					
					xmlParser.setInputXML(NGOSearchDocumentExt_OutputXML);
					if(xmlParser.getValueOf("Status").equalsIgnoreCase("0"))
					{	
						status="3";
						if(!(xmlParser.getValueOf("TotalNoOfRecords").equalsIgnoreCase("0")))
						{
							String parentFolderIndex = xmlParser.getValueOf("ParentFolderIndex");
							String documentIndex = xmlParser.getValueOf("DocumentIndex");
							String itemIndex = "";
							String extTableName = "RB_TL_EXTTABLE";
							//String APSelectWithColumnNames_InputXML = getAPSelectWithColumnNames_InputXML(extTableName, workitemname,wfsession.getEngineName(),wfsession.getSessionId());
							String APSelectWithColumnNames_InputXML = getAPSelectWithColumnNames_InputXML(extTableName, workitemname,wDSession.getM_objCabinetInfo().getM_strCabinetName(),wDSession.getM_objUserInfo().getM_strSessionId());
							
							WriteLog("APSelectWithColumnNames_InputXML:::::::: "+APSelectWithColumnNames_InputXML);
							//String APSelectWithColumnNames_OutputXML = WFCallBroker.execute(APSelectWithColumnNames_InputXML,sJtsIp, iJtsPort,1);
							String APSelectWithColumnNames_OutputXML =NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), APSelectWithColumnNames_InputXML);
							WriteLog("APSelectWithColumnNames_OutputXML:::::::: "+APSelectWithColumnNames_OutputXML);
							
							xmlParser.setInputXML(APSelectWithColumnNames_OutputXML);
							if(xmlParser.getValueOf("MainCode").equalsIgnoreCase("0"))
							{
								itemIndex= xmlParser.getValueOf("ItemIndex");
								status="4";
								String NGOCopyDocumentExt_InputXML =  getNGOCopyDocumentExt_InputXML(itemIndex,parentFolderIndex,documentIndex,wDSession.getM_objCabinetInfo().getM_strCabinetName(),wDSession.getM_objUserInfo().getM_strSessionId());
								
								WriteLog("NGOCopyDocumentExt_InputXML:::::::: "+ NGOCopyDocumentExt_InputXML);
								
								//String NGOCopyDocumentExt_OutputXML = WFCallBroker.execute(NGOCopyDocumentExt_InputXML,sJtsIp,iJtsPort,1);
								String NGOCopyDocumentExt_OutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), NGOCopyDocumentExt_InputXML);
								
								WriteLog("NGOCopyDocumentExt_OutputXML:::::::: "+ NGOCopyDocumentExt_OutputXML);

								xmlParser.setInputXML(NGOCopyDocumentExt_OutputXML);
								if(xmlParser.getValueOf("Status").equalsIgnoreCase("0"))
								{
									status="5";
									WriteLog("Document Successfully copied");
									String destDocIndex = xmlParser.getValueOf("DocumentIndex");
								//	String NGOChangeDocumentProperty_InputXML =  getNGOChangeDocumentProperty_InputXML(destDocIndex,wfsession.getEngineName(),wfsession.getSessionId());
									String NGOChangeDocumentProperty_InputXML =  getNGOChangeDocumentProperty_InputXML(destDocIndex,wDSession.getM_objCabinetInfo().getM_strCabinetName(),wDSession.getM_objUserInfo().getM_strSessionId());
									
									WriteLog("NGOChangeDocumentProperty_InputXML:::::::: "+ NGOChangeDocumentProperty_InputXML);
									
									//String NGOChangeDocumentProperty_OutputXML = WFCallBroker.execute(NGOChangeDocumentProperty_InputXML,sJtsIp,iJtsPort,1);
									String NGOChangeDocumentProperty_OutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), NGOChangeDocumentProperty_InputXML);
									
									WriteLog("NGOChangeDocumentProperty_OutputXML:::::::: "+ NGOChangeDocumentProperty_OutputXML);
									out.println();
									xmlParser.setInputXML(NGOChangeDocumentProperty_OutputXML);
									if(xmlParser.getValueOf("Status").equalsIgnoreCase("0"))
									{
										WriteLog("Document Name Successfully changed");
										status="0";
										out.clear();
										out.println(status+"~"+NGOChangeDocumentProperty_OutputXML);
									}
									else{
										//Change Document Property Status code not 0
										WriteLog("error in NGOChangeDocumentProperty");
										TLCifFoundStatus = "CIFNOTFOUND";
									}
								}
								else{
									//Copy Document Status code not 0
									WriteLog("error in NGOCopyDocumentExt");
									TLCifFoundStatus = "CIFNOTFOUND";
								}
							}
							else{
								//APSelect Main code not 0
								WriteLog("APSelect Main code not 0");
								TLCifFoundStatus = "CIFNOTFOUND";
							}
						}
						else{
							//Search Document Total Records not 0
							WriteLog(" No  records found for CIFID : " + CIFID);
							TLCifFoundStatus = "CIFNOTFOUND";
						}
					}
					else{
						//Search Document Status not 0
						WriteLog("Search Document Status not 0");
						TLCifFoundStatus = "CIFNOTFOUND";
					}
				}
				else{
					//Trade License Dataclass property Status not 0
					WriteLog("Trade License Dataclass property Status not 0");
					TLCifFoundStatus = "CIFNOTFOUND";
				}
			}
			else{
				//Trade License Dataclass getdatadefid Status not 0
				WriteLog("Trade License Dataclass getdatadefid Status not 0");
				TLCifFoundStatus = "CIFNOTFOUND";
			}			
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		//*************************************************************************************
		// This Block will execute when Previous Year TL will not found based on CIFID
		WriteLog("TLCifFoundStatus: "+TLCifFoundStatus);
		if (TLCifFoundStatus == "CIFNOTFOUND"){
			String status="-1";
			if (CIFID != "" && !CIFID.equalsIgnoreCase(""))
			{
				try{
					String sJtsIp = null;
					int iJtsPort = 0;
					XMLParser xmlParser=new XMLParser();
									
					String workitemname = WINAME_Esapi;
					WriteLog("workitemname = "+workitemname);
					//sJtsIp = wfsession.getJtsIp();
					sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
					//iJtsPort = wfsession.getJtsPort();
					iJtsPort = Integer.parseInt(wDSession.getM_objCabinetInfo().getM_strServerPort());
					
					Properties properties = new Properties();
					properties.load(new FileInputStream(System.getProperty("user.dir")+ System.getProperty("file.separator")+ "RakBankConfig.properties"));
					
					String strTLParentFolderIndex=properties.getProperty("FolderIndexTLHierarchy");
					WriteLog("FolderIndexTLHierarchy::::::::"+strTLParentFolderIndex);
									
					String NGOSearchFolder_InputXML = getNGOSearchFolder_InputXML(strTLParentFolderIndex,CIFID,wDSession.getM_objCabinetInfo().getM_strCabinetName(), wDSession.getM_objUserInfo().getM_strSessionId());
					WriteLog("NGOSearchFolder_InputXML:::::::: \n"+NGOSearchFolder_InputXML);
					//String NGOSearchFolder_OutputXML = WFCallBroker.execute(NGOSearchFolder_InputXML,sJtsIp,iJtsPort,1);
					String NGOSearchFolder_OutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), NGOSearchFolder_InputXML);
					WriteLog("NGOSearchFolder_OutputXML:::::::: \n"+NGOSearchFolder_OutputXML);
					status="1";
					xmlParser.setInputXML(NGOSearchFolder_OutputXML);
					
					if(xmlParser.getValueOf("Status").equalsIgnoreCase("0"))
					{
						if(!(xmlParser.getValueOf("TotalNoOfRecords").equalsIgnoreCase("0")) && !(xmlParser.getValueOf("Error").equalsIgnoreCase("No data found.")))
						{
												
							String objectIndex=xmlParser.getValueOf("FolderIndex");
							
							String NGOSearchDocumentExt_InputXML = getNGOSearchDocumentExt_InputXML(objectIndex,wDSession.getM_objCabinetInfo().getM_strCabinetName(), wDSession.getM_objUserInfo().getM_strSessionId());
							WriteLog("NGOSearchDocumentExt_InputXML:::::::: \n"+NGOSearchDocumentExt_InputXML);
							
							//String NGOSearchDocumentExt_OutputXML = WFCallBroker.execute(NGOSearchDocumentExt_InputXML,sJtsIp,iJtsPort,1);
							String NGOSearchDocumentExt_OutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), NGOSearchDocumentExt_InputXML);
							WriteLog("NGOSearchDocumentExt_OutputXML:::::::: "+NGOSearchDocumentExt_OutputXML);
							
							xmlParser.setInputXML(NGOSearchDocumentExt_OutputXML);
							if(xmlParser.getValueOf("Status").equalsIgnoreCase("0"))
							{	
								status="3";
								if(!(xmlParser.getValueOf("TotalNoOfRecords").equalsIgnoreCase("0")))
								{
									String documentIndex = "";
									while(NGOSearchDocumentExt_OutputXML.indexOf("<Document>")>0){
										
										String strDocumentString=NGOSearchDocumentExt_OutputXML.substring(NGOSearchDocumentExt_OutputXML.indexOf("<Document>")+"<Document>".length(),NGOSearchDocumentExt_OutputXML.indexOf("</Document>"));
										
										String strDocumentName=strDocumentString.substring(strDocumentString.indexOf("<DocumentName>")+"<DocumentName>".length(),strDocumentString.indexOf("</DocumentName>"));
										if(strDocumentName.equalsIgnoreCase("Trade License") || strDocumentName.equalsIgnoreCase("TradeLicense")|| strDocumentName.equalsIgnoreCase("Trade_License")){
											
											documentIndex=strDocumentString.substring(strDocumentString.indexOf("<DocumentIndex>")+"<DocumentIndex>".length(),strDocumentString.indexOf("</DocumentIndex>"));
											break;
										}					
										
										NGOSearchDocumentExt_OutputXML=NGOSearchDocumentExt_OutputXML.substring(NGOSearchDocumentExt_OutputXML.indexOf("</Document>")+"</Document>".length());
									}
									
									if(!(documentIndex.equals("")))
									{
										String parentFolderIndex = xmlParser.getValueOf("ParentFolderIndex");

										//String documentIndex = xmlParser.getValueOf("DocumentIndex");
										String itemIndex = "";
										String extTableName = "RB_TL_EXTTABLE";

										String APSelectWithColumnNames_InputXML = getAPSelectWithColumnNames_InputXML(extTableName, workitemname,wDSession.getM_objCabinetInfo().getM_strCabinetName(), wDSession.getM_objUserInfo().getM_strSessionId());
										
										WriteLog("APSelectWithColumnNames_InputXML:::::::: \n"+APSelectWithColumnNames_InputXML);
										//String APSelectWithColumnNames_OutputXML = WFCallBroker.execute(APSelectWithColumnNames_InputXML,sJtsIp, iJtsPort,1);
										String APSelectWithColumnNames_OutputXML =NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), APSelectWithColumnNames_InputXML);
										WriteLog("APSelectWithColumnNames_OutputXML:::::::: \n"+APSelectWithColumnNames_OutputXML);

										xmlParser.setInputXML(APSelectWithColumnNames_OutputXML);
										if(xmlParser.getValueOf("MainCode").equalsIgnoreCase("0"))
										{
											itemIndex= xmlParser.getValueOf("ItemIndex");
											status="4";
											String NGOCopyDocumentExt_InputXML =  getNGOCopyDocumentExt_InputXML(itemIndex,parentFolderIndex,documentIndex,wDSession.getM_objCabinetInfo().getM_strCabinetName(), wDSession.getM_objUserInfo().getM_strSessionId());
											
											WriteLog("NGOCopyDocumentExt_InputXML:::::::: \n"+ NGOCopyDocumentExt_InputXML);
											
											//String NGOCopyDocumentExt_OutputXML = WFCallBroker.execute(NGOCopyDocumentExt_InputXML,sJtsIp,iJtsPort,1);
											String NGOCopyDocumentExt_OutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), NGOCopyDocumentExt_InputXML);
											
											WriteLog("NGOCopyDocumentExt_OutputXML:::::::: \n"+ NGOCopyDocumentExt_OutputXML);


											xmlParser.setInputXML(NGOCopyDocumentExt_OutputXML);
											if(xmlParser.getValueOf("Status").equalsIgnoreCase("0"))
											{
												status="5";
												WriteLog("Document Successfully copied");
												String destDocIndex = xmlParser.getValueOf("DocumentIndex");
												String NGOChangeDocumentProperty_InputXML =  getNGOChangeDocumentProperty_InputXML(destDocIndex,wDSession.getM_objCabinetInfo().getM_strCabinetName(), wDSession.getM_objUserInfo().getM_strSessionId());
												
												WriteLog("NGOChangeDocumentProperty_InputXML:::::::: \n"+ NGOChangeDocumentProperty_InputXML);
												
												//String NGOChangeDocumentProperty_OutputXML = WFCallBroker.execute(NGOChangeDocumentProperty_InputXML,sJtsIp,iJtsPort,1);
												String NGOChangeDocumentProperty_OutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), NGOChangeDocumentProperty_InputXML);
												
												WriteLog("NGOChangeDocumentProperty_OutputXML:::::::: \n"+ NGOChangeDocumentProperty_OutputXML);
												out.println();
												xmlParser.setInputXML(NGOChangeDocumentProperty_OutputXML);
												if(xmlParser.getValueOf("Status").equalsIgnoreCase("0"))
												{
													WriteLog("Document Name Successfully changed1");
													status="0";
													out.clear();
													out.println(status+"~"+NGOChangeDocumentProperty_OutputXML);
												}
												else{
													//Change Document Property Status code not 0
													WriteLog("error in NGOChangeDocumentProperty1");
												}
											}
											else{
												//Copy Document Status code not 0
												WriteLog("error in NGOCopyDocumentExt1");
											}
										}
										else{
											//APSelect Main code not 0

										}
									}
									else{
										//DocumentIndex blank, means no documents found by TradeLicense Name
										status="10";
										out.clear();
										out.println(status+"~"+"DocumentIndex blank, means no documents found by TradeLicense Name1!");

									}
								}
								else{
									//Search Document Total Records 0
									status="11";
									out.clear();
									out.println(status+"~"+"Search Document Total Records 0!  1");
								}
							}
							else{
								//Search Document Status not 0
								status="11";
								out.clear();
								out.println(status+"~"+"Search Document Total Records 0! 1");
							}
						}
						else{
							//Search Folder Total Records 0
							status="12";
							out.clear();
							out.println(status+"~"+"Search Folder Total Records 0! 1");
							
							//@Ignore-previous Comment-Trade License Dataclass property Status not 0
						}
					}
					else{
						//SearchFolder status not 0
							status="12";
							out.clear();
							out.println(status+"~"+"Search Folder Total Records 0! 1");
						//@Ignore-previous Comment- Trade License Dataclass getdatadefid Status not 0
					}			
				}
				catch(Exception e)
				{
					e.printStackTrace();
				}	
			} else{
				//when CIFNOTFOUND or CIFID is blank
				status="12";
				WriteLog("CIFNOTFOUND or CIFID is blank");
				out.clear();
				out.println(status+"~"+"CIFNOTFOUND or CIFID is blank");
			}
		}
		//*************************************************************************************
		
		
%>

	