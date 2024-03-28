<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../TWC_Specific/Log.process"%>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.text.Format" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="ISPack.ISUtil.JPISException"%>
<%@page import="ISPack.CPISDocumentTxn"%>
<%@page import="ISPack.ISUtil.JPDBRecoverDocData"%>
<%@page import="ISPack.ISUtil.JPISIsIndex"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.util.regex.*"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="org.apache.poi.*"%>
<%@page import="org.apache.poi.ss.usermodel.*"%>
<%@page import="org.apache.poi.ss.util.*"%>
<%@page import="org.apache.poi.xssf.usermodel.*"%>
<%@page import="org.apache.poi.openxml4j.exceptions.*"%>
<%@page import="org.apache.poi.EncryptedDocumentException"%>
<%@page import="org.apache.poi.openxml4j.exceptions.InvalidFormatException"%>
<%@page import="org.apache.poi.ss.usermodel.Cell"%>
<%@page import="org.apache.poi.ss.usermodel.CellStyle"%>
<%@page import="org.apache.poi.ss.usermodel.CellCopyPolicy"%>
<%@page import="org.apache.poi.ss.usermodel.FormulaEvaluator"%>
<%@page import="org.apache.poi.ss.usermodel.Row"%>
<%@page import="org.apache.poi.ss.usermodel.Sheet"%>
<%@page import="org.apache.poi.ss.usermodel.Workbook"%>
<%@page import="org.apache.poi.ss.usermodel.WorkbookFactory"%>
<%@page import="org.apache.poi.ss.util.CellAddress"%>
<%@page import="org.apache.poi.ss.util.CellReference"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCellStyle"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>


<%!
	 public void deleteLocalDocument(String sFileName)
	 {
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

String getTagValue(String sXML, String sTagName) 
	{
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
		
	
	
	public String SearchExistingDoc(String pid, String FrmType, String sCabname, String sSessionId, String sJtsIp, int iJtsPort_int, String sFilepath,String volumeid,String FolderIndex) {
		
		logger.info("\nInside SearchExistingDoc function");
				try {
						logger.info("\nInside try block");
						short iJtsPort = (short) iJtsPort_int;
						String filepath = sFilepath;
						logger.info("filepath--"+filepath);
						File newfile = new File(filepath);
						String name = newfile.getName();
						String ext = "";
						String sMappedInputXml="";
						if (name.contains(".")) {
							ext = name.substring(name.lastIndexOf("."), name.length());
							logger.info("\next--"+ext);
						}
						JPISIsIndex ISINDEX = new JPISIsIndex();
						JPDBRecoverDocData JPISDEC = new JPDBRecoverDocData();
						String strDocumentPath = sFilepath;
						logger.info("strDocumentPath--"+strDocumentPath);
						File processFile = null;
						long lLngFileSize = 0L;
						processFile = new File(strDocumentPath);
						
						lLngFileSize = processFile.length();
						String lstrDocFileSize = "";
						lstrDocFileSize = Long.toString(lLngFileSize);
						logger.info("lstrDocFileSize--"+lstrDocFileSize);
						
						String createdbyappname = "";
						createdbyappname = ext.replaceFirst(".", "");
						logger.info("\nvolIdShort before--"+volumeid);
						Short volIdShort = Short.valueOf(volumeid);
						logger.info("\nvolIdShort  after--"+volIdShort);
						
						if (lLngFileSize != 0L)
						{
							CPISDocumentTxn.AddDocument_MT(null, sJtsIp, iJtsPort, sCabname, volIdShort.shortValue(), strDocumentPath, JPISDEC, "", ISINDEX);
							
						}  
								
																
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
										
										
						
						
						logger.info("Document Addition sInputXML: "+sMappedInputXml);
						String sOutputXml = WFCustomCallBroker.execute(sMappedInputXml, sJtsIp, iJtsPort, 1);
						logger.info("Document Addition sOutputXml: "+sOutputXml);
						String status_D = getTagValue(sOutputXml, "Status");
						if(status_D.equalsIgnoreCase("0")){
							deleteLocalDocument(sFilepath);
							return sOutputXml;
						} else {
							return "Error in Document Addition";
						}
					} catch (JPISException e) {
								logger.info("\nInside catch block JPISException");
						return "Error in Document Addition at Volume";
					} catch (Exception e) {
						logger.info("\nInside catch block Exception ");
						return "Exception Occurred in Document Addition";
					}
		}
		
		public static String[] splitAlphaNumeric(String str) 
		{
			String rowColumSplitArr[] = str
					.split("(?i)((?<=[A-Z])(?=\\d))|((?<=\\d)(?=[A-Z]))");

			String columnName = rowColumSplitArr[0];
			int rowNum = Integer.parseInt(rowColumSplitArr[1]) - 1;

			rowColumSplitArr = (columnName + "~" + rowNum).split("~");

			return rowColumSplitArr;
		
		}
		
		private int getLineCount(String cellValueData, int maxCharPerLine) 
		{
			int rowCnt=0;
			logger.info("getLineCount cellValueData: "+cellValueData);
			
			String[] splitData = cellValueData.split("\n");
			
			for(int i=0;i<splitData.length;i++)
			{
				logger.info("getLineCount splitData[i]: "+splitData[i]);
				if (splitData[i].length() != 0)
					rowCnt = rowCnt + splitData[i].length()/maxCharPerLine;
				rowCnt = rowCnt +1;
			}		
			logger.info("getLineCount rowCnt: "+rowCnt);
			return  rowCnt;
		}
		
		private int getLineCountFacilityGrid(String cellValueData, int maxCharPerLine) 
		{
			int rowCnt=0;
			logger.info("getLineCount cellValueData: "+cellValueData);
			
			String[] splitData = cellValueData.split("\\r");
			
			for(int i=0;i<splitData.length;i++)
			{
				logger.info("getLineCount splitData[i]: "+splitData[i]);
				if (splitData[i].length() != 0)
					rowCnt = rowCnt + splitData[i].length()/maxCharPerLine;
				rowCnt = rowCnt +1;
			}		
			logger.info("getLineCount rowCnt: "+rowCnt);
			return  rowCnt;
		}
		
		private String getSplittedValueFacilityGrid(String cellValueData) 
		{
			logger.info("getLineCount cellValueData: "+cellValueData);
			String st = "";
			String[] splitData = cellValueData.split("\\r");
			for(int i=0;i<splitData.length;i++)
			{
				logger.info("getLineCount splitData[i]: "+splitData[i]);
				if (splitData[i].length() != 0)
					st = st + splitData[i] +"\n";
			}
			return  st;
		}
		
%>
<%
		logger.info("\nInside Nikita ExcelTemplateGeneration.jsp \n");
		try
		{
			String winame = request.getParameter("winame");
			if (winame != null) {winame=winame.replace("'","");}
			Properties properties = new Properties();
			String sCabName=customSession.getEngineName();	
		    String sSessionId = customSession.getDMSSessionId();
			String sJtsIp = customSession.getJtsIp();
		    int iJtsPort = customSession.getJtsPort();
			String generateddocPath = "";
			String pdfName ="template";
			String dynamicPdfName =  winame + pdfName + ".xlsx";
			String OutputWriteString="";
			String docxml="";
			String Itemindex="";
			String documentindex="";
			String sMappOutPutXML="";
			String doctype="";
			String params="";
			String inputRawTemplateFilePath;
			String ouputRawTemplatePath;		
			String staticAmountFieldList;
			String staticSecurityFieldList;
			String staticfieldmapping;
			List<String> staticAmountFieldArrayList;
			List<String> staticSecurityArrayList;
			Map <String,String> directCellAddressMap;
			Map <String,String> directCellValuesMap;
			String Static_Ext_ColumnName="";
			String ExternalTable="";
			FileInputStream inputStream=null;
			Workbook workbook = null;
			Sheet sheet =null;
			Cell cell=null;
			String cellInfo[] = null;
			String cellInfo_total[] = null;
			String cellInfo_totalFSV[] = null;
			int rowShifted;
			DateFormat excelDateFormat = new SimpleDateFormat("dd-MMM-yyyy");
			XSSFCell cell_total=null;
			XSSFCell cell_total_fsv=null;
			
			Map <String,String> facilityGridExcelColumnMap;
			ArrayList<Map<String, String>> completeFacilityDataArrList ;
			Map <String,String> individualFacilityCellValueMap;
			int facilityDataRowStartNo;
			int currentFacilityRow;
			String facilitygridcolmapping="";
			String facilitygridcol="";
			int totalFacilityRecord=0;
			String Facility_GridTable="";
			String facility_GridColName="";
			WFCustomXmlList objWorkList=null;
			WFCustomXmlResponse objWFCustomXmlResponse=null;
			String subXML="";
			
			Map <String,String> genConditionsGridExcelColumnMap;
			ArrayList<Map<String, String>> completeGenConditionsDataArrList ;
			int totalGenConditionsRecord;
			Map <String,String> individualGenConditionCellValueMap;
			int genConditionDataRowStartNo;
			int currentGenConditionRow;
			String generalgridcolmapping="";
			String General_Conditions_GridColName="";
			
			Map <String,String> intConditionsGridExcelColumnMap;
			ArrayList<Map<String, String>> completeIntConditionsDataArrList ;
			int totalIntConditionsRecord;
			Map <String,String> individualIntConditionCellValueMap;
			int intConditionDataRowStartNo;
			int currentIntConditionRow;
			String internalgridcolmapping="";
			String Internal_Limit_ColName="";
			
			Map <String,String> extConditionsGridExcelColumnMap;
			ArrayList<Map<String, String>> completeExtConditionsDataArrList ;
			int totalExtConditionsRecord;
			Map <String,String> individualExtConditionCellValueMap;
			int extConditionDataRowStartNo;
			int currentExtConditionRow;
			String externalgridcolmapping="";
			String External_Limit_ColName="";
			
			Map <String,String> securityGridExcelColumnMap;
			ArrayList<Map<String, String>> completeSecurityDataArrList ;
			Map <String,String> individualSecurityCellValueMap;
			int securityDataRowStartNo;
			int currentSecurityRow;
			String securitygridcolmapping="";
			String securitygridcol="";
			int totalSecurityRecord=0;
			String Security_GridTable="";
			String security_GridColName="";
			String securityvaluecell_current="";
			String securityvaluecell_final="";
			String securityfsvcell_current="";
			String securityfsvcell_final="";
			String valuekey="";
			String fsvkey="";
			
			try
			{
			properties.load(new FileInputStream(System.getProperty("user.dir")+ System.getProperty("file.separator")+ "RakBankConfig.properties"));
			
			String tempDir = System.getProperty("user.dir");
			String FrmType = properties.getProperty("ExcelName");
			String volumeid = properties.getProperty("VolumeID");
			
			ExternalTable = properties.getProperty("External_Table");
			Static_Ext_ColumnName = properties.getProperty("TWC_EXCEL_Static_Text_Field");
			String StaticColumnNameArray[] = Static_Ext_ColumnName.split(",");
	
			inputRawTemplateFilePath = tempDir + properties.getProperty("TWC_EXCEL_TEMPLATE_HTML_PATH");
			ouputRawTemplatePath = tempDir + properties.getProperty("TWC_EXCEL_GENERTATED_HTML_PATH");
			ouputRawTemplatePath += dynamicPdfName;
			logger.info("\nTemplate Doc ouputRawTemplatePath :" + ouputRawTemplatePath);
			staticAmountFieldList=properties.getProperty("TWC_Excel_Static_Amount_Field");
			staticfieldmapping=properties.getProperty("TWC_Excel_Static_Field_Mapping");
			
			
			Facility_GridTable = properties.getProperty("Facility_Grid_Table");
			facility_GridColName = properties.getProperty("TWC_Excel_Facility_Col");
			String FacilityGridColumn[] = facility_GridColName.split(",");
			facilityDataRowStartNo = Integer.parseInt(properties.getProperty("TWC_Excel_FacilityDataRowStartNo")); 
			facilitygridcolmapping=properties.getProperty("TWC_Excel_Facility_Grid_Col_Mapping");
			
			genConditionDataRowStartNo = Integer.parseInt(properties.getProperty("TWC_Excel_genConditionDataRowStartNo"));
			generalgridcolmapping = properties.getProperty("TWC_Excel_General_Condition_Mapping");
			General_Conditions_GridColName = properties.getProperty("General_Conditions_Grid_Col_Name");
			String GeneralGridCol[] = General_Conditions_GridColName.split(",");
			String GeneralTable = properties.getProperty("General_Table");
			
			extConditionDataRowStartNo = Integer.parseInt(properties.getProperty("TWC_ExternalConditionDataRowStartNo")); 
			externalgridcolmapping = properties.getProperty("TWC_Excel_External_Condition_Mapping");
			External_Limit_ColName = properties.getProperty("External_Limit_Col_Name");
			String ExternalGridCol[] = External_Limit_ColName.split(",");
			String ExternalGrid= properties.getProperty("External_Grid");
			
			intConditionDataRowStartNo = Integer.parseInt(properties.getProperty("TWC_InternalConditionDataRowStartNo"));
			internalgridcolmapping = properties.getProperty("TWC_Excel_Internal_Condition_Mapping");
			Internal_Limit_ColName = properties.getProperty("Internal_Limit_Col_Name");
			String InternalGridCol[] = Internal_Limit_ColName.split(",");
			String InternalGrid= properties.getProperty("Internal_Grid");
			
			securityDataRowStartNo = Integer.parseInt(properties.getProperty("TWC_Excel_SecurityDataRowStartNo"));
			security_GridColName=properties.getProperty("TWC_Excel_Security_Col");
			securitygridcolmapping = properties.getProperty("TWC_Excel_Security_Grid_Col_Mapping");
			String SecurityGridCol[] = security_GridColName.split(",");
			String SecurityGrid = properties.getProperty("Security_Document_Table");
			staticSecurityFieldList = properties.getProperty("TWC_Excel_Static_Security_Amount_Field");
			
			directCellAddressMap = new HashMap<String, String>();
			
			staticAmountFieldArrayList = Arrays.asList(staticAmountFieldList.split(","));
			String staticfieldmapcell[] = staticfieldmapping.split(";");
			String staticfieldcellno="";
			String staticfielcellname="";
			
			for(int i=0;i<staticfieldmapcell.length;i++)
			{
				staticfielcellname = staticfieldmapcell[i].split("~")[0];
				staticfieldcellno=staticfieldmapcell[i].split("~")[1];
				directCellAddressMap.put(staticfielcellname,staticfieldcellno);
			}
			
			
			for (Map.Entry<String,String> entry : directCellAddressMap.entrySet()) {
			  String key = entry.getKey();
			  String value = entry.getValue();
			  logger.info("\nkey for cell address is :" + key);
			  logger.info("\nvalue for cell address is :" + value);
			}
			
			staticSecurityArrayList = Arrays.asList(staticSecurityFieldList.split(","));
			
			
			String queryExtTable = "select" +" "+"ITEMINDEX,"+Static_Ext_ColumnName +" "+"from" +" "+ExternalTable+" "+ "with (nolock) where wi_name=:WI_NAME";
			logger.info("\nqueryExtTable:\n"+queryExtTable);
			params = "WI_NAME=="+winame;
			
			String inputXML4 = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + queryExtTable + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
			
			 logger.info("\n InputXML to get Customer Name-->"+inputXML4);
			String outputXML4 = WFCustomCallBroker.execute(inputXML4, sJtsIp, iJtsPort, 1);
			 logger.info("\n outputXML to get Customer Name-->"+outputXML4);
			
			WFCustomXmlResponse xmlParserData4=new WFCustomXmlResponse();
			xmlParserData4.setXmlString((outputXML4));
			String mainCodeValue4 = xmlParserData4.getVal("MainCode");
			
			WFCustomXmlResponse objXmlParser4=null;
			directCellValuesMap = new HashMap<String, String>();
			
			if(mainCodeValue4.equals("0"))
			{
			    Itemindex = xmlParserData4.getVal("ITEMINDEX");
				for(int j = 0; j < StaticColumnNameArray.length; ++j)
				{	
					directCellValuesMap.put(StaticColumnNameArray[j],xmlParserData4.getVal(StaticColumnNameArray[j]));
					
				}
				directCellValuesMap.put("Current_Date", excelDateFormat.format(new Date()));
				
			}
			logger.info("Final Document Itemindex: "+Itemindex);
			
			for (Map.Entry<String,String> entry : directCellValuesMap.entrySet()) {
			  String key = entry.getKey();
			  String value = entry.getValue();
			  logger.info("\nkey for cell value is :" + key);
			  logger.info("\nvalue for cell value is :" + value);
			}
			
			
			try
			{
				inputStream = new FileInputStream(new File(inputRawTemplateFilePath));
				workbook =  new XSSFWorkbook(inputStream);
				sheet = workbook.getSheetAt(0);
			}
			
			catch(Exception e)
			{
				logger.info("Exception #############: "+e);
			}
			
			for (Map.Entry<String,String> entry : directCellAddressMap.entrySet())  
			{
	            String fieldName = entry.getKey();
	            String cellAddress = entry.getValue();

	            cellInfo = null;
				cellInfo = splitAlphaNumeric(cellAddress);
				
				cell=null;
				cell = sheet.getRow(Integer.parseInt(cellInfo[1])).getCell(CellReference.convertColStringToIndex(cellInfo[0]));
				if(staticAmountFieldArrayList.contains(fieldName))
				{
					try
					{
						cell.setCellValue(Double.parseDouble(directCellValuesMap.get(fieldName)));
					}
					catch (Exception parseExcep)
					{
						cell.setCellValue(directCellValuesMap.get(fieldName));
					}
				}
				else
				{
					cell.setCellValue(directCellValuesMap.get(fieldName));
				}				
			}
			
			
			
			
			//Dynamic Row Addition Code for Facility Grid starts
			rowShifted=0;
			
			facilityGridExcelColumnMap = new HashMap<String, String>();
			String dynamic_facility_griddmapping[] = facilitygridcolmapping.split(";");
			String dynamic_facility_fieldcellno="";
			String dynamic_facility_fielcellname="";
			
			for(int i=0;i<dynamic_facility_griddmapping.length;i++)
			{
				dynamic_facility_fielcellname = dynamic_facility_griddmapping[i].split("~")[0];
				dynamic_facility_fieldcellno=dynamic_facility_griddmapping[i].split("~")[1];
				facilityGridExcelColumnMap.put(dynamic_facility_fieldcellno,dynamic_facility_fielcellname);
			}
			
			facilityDataRowStartNo = facilityDataRowStartNo + rowShifted;	
			currentFacilityRow = facilityDataRowStartNo-1;
			
			
			
			String queryFacilityGrid = "select" +" "+ facility_GridColName +" "+"from" +" "+Facility_GridTable+" "+ "with (nolock) where WINAME=:WI_NAME order by cast(LEFT(SUBSTRING(NO, PATINDEX('%[0-9.-]%', NO), 8000),   PATINDEX('%[^0-9.-]%', SUBSTRING(NO, PATINDEX('%[0-9.-]%', NO), 8000) + 'X') -1) as int),NO";
			logger.info("\nqueryFacilityGrid:\n"+queryFacilityGrid);
			params = "WI_NAME=="+winame;
			
			String inputXML6 = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + queryFacilityGrid + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
			
			 logger.info("\n InputXML to get facility type from facility grid-->"+inputXML6);
			String outputXML6 = WFCustomCallBroker.execute(inputXML6, sJtsIp, iJtsPort, 1).replaceAll("AMPNDCHAR","&").replaceAll("CCCOMMAAA",",").replaceAll("PPPERCCCENTT","%");
			 logger.info("\n outputXML to get facility type from facility grid-->"+outputXML6);
			
			WFCustomXmlResponse xmlParserData6=new WFCustomXmlResponse();
			xmlParserData6.setXmlString((outputXML6));
			String mainCodeValue6 = xmlParserData6.getVal("MainCode");
			totalFacilityRecord=Integer.parseInt(xmlParserData6.getVal("TotalRetrieved"));
			logger.info("total records in facility grid---"+totalFacilityRecord);
			
			completeFacilityDataArrList = new ArrayList<Map<String, String> >(totalFacilityRecord);
			String cash_margin ="";
			
			if(mainCodeValue6.equals("0") && totalFacilityRecord>0)
			{
				objWorkList = xmlParserData6.createList("Records","Record"); 
				for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{
					subXML = objWorkList.getVal("Record");
					objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);	
					individualFacilityCellValueMap=null;
					individualFacilityCellValueMap = new HashMap<String, String>();
					for(int j=0;j<FacilityGridColumn.length;j++)
					{
						cash_margin = objWFCustomXmlResponse.getVal("CASH_MARGIN");
						
						individualFacilityCellValueMap.put(FacilityGridColumn[j],objWFCustomXmlResponse.getVal(FacilityGridColumn[j]).replace("<&CASH_MARGIN&>",cash_margin));
						
					}
					completeFacilityDataArrList.add(individualFacilityCellValueMap);
				}	
				
			
			}
			
			/*for (Map.Entry<String,String> entry : individualFacilityCellValueMap.entrySet()) {
			  String key = entry.getKey();
			  String value = entry.getValue();
			  logger.info("\nkey for Facility cell number is :" + key);
			  logger.info("\nvalue for Facility cell value is :" + value);
			}*/
			
			XSSFRow sourceFacilityRow = (XSSFRow)sheet.getRow(facilityDataRowStartNo-1);
			
			for(int i=0; i<completeFacilityDataArrList.size(); i++ )
			{
				XSSFRow newFacilityRow;
				
				if(i!=0)
				{
					sheet.shiftRows(currentFacilityRow, sheet.getLastRowNum(), 1);								
					sheet.createRow(currentFacilityRow);
					
					newFacilityRow = (XSSFRow)sheet.getRow(currentFacilityRow);
					newFacilityRow.copyRowFrom(sourceFacilityRow, new CellCopyPolicy());					
					rowShifted++;					
				}
				else
				{
					newFacilityRow = (XSSFRow)sheet.getRow(currentFacilityRow);
				}
				
				
				Iterator<Cell> cellIterator = sourceFacilityRow.cellIterator();
				
				int facilityrowCount = 1;
				while (cellIterator.hasNext()) 
				{	
					Cell iCell = cellIterator.next();
					//newRow.createCell(iCell.getColumnIndex()).setCellStyle(iCell.getCellStyle());
					Cell c = newFacilityRow.getCell(iCell.getColumnIndex());
					
					String columnName = CellReference.convertNumToColString(iCell.getColumnIndex()); 
					
					if(facilityGridExcelColumnMap.get(columnName)!=null)
					{	
						if(facilityGridExcelColumnMap.get(columnName).equalsIgnoreCase("PURPOSE"))
						{
							int cellLineCount = getLineCount(completeFacilityDataArrList.get(i).get(facilityGridExcelColumnMap.get(columnName)),14);
							if(cellLineCount>facilityrowCount)
							{
								facilityrowCount=cellLineCount;
							}
						}
						
						if(facilityGridExcelColumnMap.get(columnName).equalsIgnoreCase("PRODUCT_LEVEL_CONDITIONS"))
						{
							int cellLineCount1 = getLineCountFacilityGrid(completeFacilityDataArrList.get(i).get(facilityGridExcelColumnMap.get(columnName)),88);
							logger.info("\ncellLineCount1 stutee check 1 :" + cellLineCount1);
							if(cellLineCount1>facilityrowCount)
							{
								facilityrowCount=cellLineCount1;
							}
							c.setCellValue(getSplittedValueFacilityGrid(completeFacilityDataArrList.get(i).get(facilityGridExcelColumnMap.get(columnName))));
						}
						if(!facilityGridExcelColumnMap.get(columnName).equalsIgnoreCase("PRODUCT_LEVEL_CONDITIONS"))
						{
						    c.setCellValue(completeFacilityDataArrList.get(i).get(facilityGridExcelColumnMap.get(columnName)));
						}
						
						
						logger.info("\nstutee check 1 :" + completeFacilityDataArrList.get(i).get(facilityGridExcelColumnMap.get(columnName)));
					}
					else
					{
						continue;
					}
				}
				newFacilityRow.setHeight((short)(facilityrowCount*255*1.15));
				logger.info("\nfacilityrowCount height :" + facilityrowCount*255*1.15);
				currentFacilityRow++;
				
			}
			
			//Dynamic populating the General Conditions
			
			genConditionsGridExcelColumnMap = new HashMap<String, String>();
			
			String gencondarray[] = generalgridcolmapping.split("~");
			String GenCondCellname = gencondarray[0];
			String GenCondCellNo = gencondarray[1];
			genConditionsGridExcelColumnMap.put(GenCondCellNo,GenCondCellname);
			
			genConditionDataRowStartNo = genConditionDataRowStartNo + rowShifted;
			currentGenConditionRow = genConditionDataRowStartNo-1;
			
			String queryGeneralTable = "select " +" "+ General_Conditions_GridColName +" "+"from"+" " +GeneralTable +" "+"with (nolock) where WINAME=:WI_NAME order by GENERAL_SR_NO";
			logger.info("\nqueryGeneralTable:\n"+queryGeneralTable);
			params = "WI_NAME=="+winame;
			
			String inputXML1 = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + queryGeneralTable + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
			
			 logger.info("\n InputXML to get general conditions-->"+inputXML1);
			String outputXML1 = WFCustomCallBroker.execute(inputXML1, sJtsIp, iJtsPort, 1).replaceAll("AMPNDCHAR","&").replaceAll("CCCOMMAAA",",").replaceAll("PPPERCCCENTT","%");
			 logger.info("\n outputXML to get general conditions-->"+outputXML1);
			
			WFCustomXmlResponse xmlParserData1=new WFCustomXmlResponse();
			xmlParserData1.setXmlString((outputXML1));
			String mainCodeValue1 = xmlParserData1.getVal("MainCode");
			logger.info("mainCodeValue1--"+mainCodeValue1);
			totalGenConditionsRecord = Integer.parseInt(xmlParserData1.getVal("TotalRetrieved"));
			logger.info("totalGenConditionsRecord---"+totalGenConditionsRecord);
			
			completeGenConditionsDataArrList = new ArrayList<Map<String, String> >(totalGenConditionsRecord);
			
			if(mainCodeValue1.equals("0") && totalGenConditionsRecord>0)
			{
				objWorkList = xmlParserData1.createList("Records","Record"); 
				for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{
					subXML = objWorkList.getVal("Record");
					objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);
					individualGenConditionCellValueMap=null;
					individualGenConditionCellValueMap = new HashMap<String, String>();
					for(int j = 0; j < GeneralGridCol.length; ++j)
					{		
						individualGenConditionCellValueMap.put(GeneralGridCol[j],objWFCustomXmlResponse.getVal(GeneralGridCol[j]));	
					}
					completeGenConditionsDataArrList.add(individualGenConditionCellValueMap);
				}
			}
			
			XSSFRow sourceGenConditionRow = (XSSFRow)sheet.getRow(genConditionDataRowStartNo-1);
			
			for(int i=0; i<completeGenConditionsDataArrList.size(); i++ )
			{
				XSSFRow newGenConditionRow;
				
				if(i!=0)
				{
					sheet.shiftRows(currentGenConditionRow, sheet.getLastRowNum(), 1);								
					sheet.createRow(currentGenConditionRow);
					
					newGenConditionRow = (XSSFRow)sheet.getRow(currentGenConditionRow);
					newGenConditionRow.copyRowFrom(sourceGenConditionRow, new CellCopyPolicy());					
					rowShifted++;					
				}
				else
				{
					newGenConditionRow = (XSSFRow)sheet.getRow(currentGenConditionRow);
				}
				
				
				Iterator<Cell> cellIterator = sourceGenConditionRow.cellIterator();
				
				int generalrowCount = 1;
				while (cellIterator.hasNext()) 
				{	
					Cell iCell = cellIterator.next();
					//newRow.createCell(iCell.getColumnIndex()).setCellStyle(iCell.getCellStyle());
					Cell c = newGenConditionRow.getCell(iCell.getColumnIndex());
					
					String columnName = CellReference.convertNumToColString(iCell.getColumnIndex()); 
					
					if(genConditionsGridExcelColumnMap.get(columnName)!=null)
					{
						
						int cellLineCount = getLineCount(completeGenConditionsDataArrList.get(i).get(genConditionsGridExcelColumnMap.get(columnName)),220);
						if(cellLineCount>generalrowCount)
						{
							generalrowCount=cellLineCount;
						}
						
						c.setCellValue(completeGenConditionsDataArrList.get(i).get(genConditionsGridExcelColumnMap.get(columnName)));
					}
					else
					{
						continue;
					}
				}
				
				newGenConditionRow.setHeight((short)(generalrowCount*255*1.15));
				
				currentGenConditionRow++;
				
			}
			
			//Dynamic row populating for security Grid
			securityGridExcelColumnMap = new HashMap<String, String>();
			String dynamic_security_griddmapping[] = securitygridcolmapping.split(";");
			String dynamic_security_fieldcellno="";
			String dynamic_security_fielcellname="";
			
			for(int i=0;i<dynamic_security_griddmapping.length;i++)
			{
				dynamic_security_fielcellname = dynamic_security_griddmapping[i].split("~")[0];
				dynamic_security_fieldcellno=dynamic_security_griddmapping[i].split("~")[1];
				securityGridExcelColumnMap.put(dynamic_security_fieldcellno,dynamic_security_fielcellname);
			}
			
			
			securityDataRowStartNo = securityDataRowStartNo + rowShifted;	
			currentSecurityRow = securityDataRowStartNo-1;
			int currentsecurityRowTotal = currentSecurityRow;
			
			String querySecurityGrid = "select" +" "+ security_GridColName +" "+"from" +" "+SecurityGrid+" "+ "with (nolock) where WINAME=:WI_NAME order by Security_Sr_No asc";
			logger.info("\nquerySecurityGrid:\n"+querySecurityGrid);
			params = "WI_NAME=="+winame;
			
			String inputXML5 = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + querySecurityGrid + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
			
			 logger.info("\n InputXML for security grid-->"+inputXML5);
			String outputXML5 = WFCustomCallBroker.execute(inputXML5, sJtsIp, iJtsPort, 1).replaceAll("AMPNDCHAR","&").replaceAll("CCCOMMAAA",",").replaceAll("PPPERCCCENTT","%");
			 logger.info("\n OutXML for security grid-->"+outputXML5);
			
			WFCustomXmlResponse xmlParserData5=new WFCustomXmlResponse();
			xmlParserData5.setXmlString((outputXML5));
			String mainCodeValue5 = xmlParserData5.getVal("MainCode");
			totalSecurityRecord=Integer.parseInt(xmlParserData5.getVal("TotalRetrieved"));
			logger.info("total records in security grid---"+totalSecurityRecord);
			
			completeSecurityDataArrList = new ArrayList<Map<String, String> >(totalSecurityRecord);
			
			if(mainCodeValue5.equals("0") && totalSecurityRecord>0)
			{
				objWorkList = xmlParserData5.createList("Records","Record"); 
				for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{
					subXML = objWorkList.getVal("Record");
					objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);	
					individualSecurityCellValueMap=null;
					individualSecurityCellValueMap = new HashMap<String, String>();
					for(int j=0;j<SecurityGridCol.length;j++)
					{	
						individualSecurityCellValueMap.put(SecurityGridCol[j],objWFCustomXmlResponse.getVal(SecurityGridCol[j]));
						
					}
					completeSecurityDataArrList.add(individualSecurityCellValueMap);
				}	
			}
			
			XSSFRow sourceSecurityRow = (XSSFRow)sheet.getRow(securityDataRowStartNo-1);
			
			for(int i=0; i<completeSecurityDataArrList.size(); i++ )
			{
				XSSFRow newSecurityRow;
				
				if(i!=0)
				{
					sheet.shiftRows(currentSecurityRow, sheet.getLastRowNum(), 1);								
					sheet.createRow(currentSecurityRow);
					
					newSecurityRow = (XSSFRow)sheet.getRow(currentSecurityRow);
					newSecurityRow.copyRowFrom(sourceSecurityRow, new CellCopyPolicy());					
					rowShifted++;					
				}
				else
				{
					newSecurityRow = (XSSFRow)sheet.getRow(currentSecurityRow);
				}
				
				
				Iterator<Cell> cellIterator = sourceSecurityRow.cellIterator();
				
				int securityrowCount=1;
				while (cellIterator.hasNext()) 
				{	
					Cell iCell = cellIterator.next();
					//newRow.createCell(iCell.getColumnIndex()).setCellStyle(iCell.getCellStyle());
					Cell c = newSecurityRow.getCell(iCell.getColumnIndex());
					
					String columnName = CellReference.convertNumToColString(iCell.getColumnIndex()); 
					if(securityGridExcelColumnMap.get(columnName)!=null)
					{
						if(securityGridExcelColumnMap.get(columnName).equalsIgnoreCase("Security_Document_Desc"))
						{
							int cellLineCount = getLineCount(completeSecurityDataArrList.get(i).get(securityGridExcelColumnMap.get(columnName)),50);
							if(cellLineCount>securityrowCount)
							{
								securityrowCount=cellLineCount;
							}
						}
						
						if(securityGridExcelColumnMap.get(columnName).equalsIgnoreCase("Conditions"))
						{
							int cellLineCount1 = getLineCount(completeSecurityDataArrList.get(i).get(securityGridExcelColumnMap.get(columnName)),94);
							if(cellLineCount1>securityrowCount)
							{
								securityrowCount=cellLineCount1;
							}
						}
						if(staticSecurityArrayList.contains(securityGridExcelColumnMap.get(columnName)))
						{
							try
							{
								c.setCellValue(Double.parseDouble(completeSecurityDataArrList.get(i).get(securityGridExcelColumnMap.get(columnName))));
							}
							catch (Exception parseExcep)
							{
								c.setCellValue(completeSecurityDataArrList.get(i).get(securityGridExcelColumnMap.get(columnName)));
							}
						}
						else
						{	
							c.setCellValue(completeSecurityDataArrList.get(i).get(securityGridExcelColumnMap.get(columnName)));
						}
					}
					else
					{	
						continue;
					}
				}
				
				newSecurityRow.setHeight((short)(securityrowCount*255*1.15));
				currentSecurityRow++;
				
			}
			
			int securityvaluecellcurrent = currentsecurityRowTotal +1;
			int securityvaluecellfinal = currentsecurityRowTotal+totalSecurityRecord;
			
			/*for (Map.Entry<String,String> entry : securityGridExcelColumnMap.entrySet()) {
            if (entry.getValue().equals("Value")) {
				valuekey= entry.getKey();
                logger.info("key for the value is.."+entry.getKey());
            }
			if (entry.getValue().equals("FSV")) {
				fsvkey= entry.getKey();
                logger.info("key for the fsv is.."+entry.getKey());
            }
			
			}
			
			//For formula in total tangible security field
			cellInfo_total=null;
			String cellAddress1=properties.getProperty("TWC_Excel_Total_Security");
			cellInfo_total = splitAlphaNumeric(cellAddress1);
			
			int cell_no_total = Integer.parseInt(cellInfo_total[1])+rowShifted;
			cell_total= (XSSFCell)sheet.getRow(cell_no_total).getCell(CellReference.convertColStringToIndex(cellInfo_total[0]));
			
			securityvaluecell_current=valuekey+securityvaluecellcurrent;
			securityvaluecell_final=valuekey+securityvaluecellfinal;
			String formula= "SUM("+securityvaluecell_current+":"+securityvaluecell_final+")";
			logger.info("\nformula:\n"+formula);
			cell_total.setCellFormula(formula);
			cell_total.setCellType(XSSFCell.CELL_TYPE_FORMULA);
			
			//For formula in total FSV in security Grid
			cellInfo_totalFSV=null;
			String cellAddress2=properties.getProperty("TWC_Excel_Total_FSV");
			cellInfo_totalFSV = splitAlphaNumeric(cellAddress2);
			
			int cell_no_total_fsv = Integer.parseInt(cellInfo_totalFSV[1])+rowShifted;
			cell_total_fsv= (XSSFCell)sheet.getRow(cell_no_total_fsv).getCell(CellReference.convertColStringToIndex(cellInfo_totalFSV[0]));
			
			securityfsvcell_current=fsvkey+securityvaluecellcurrent;
			securityfsvcell_final=fsvkey+securityvaluecellfinal;
			String formula_fsv= "SUM("+securityfsvcell_current+":"+securityfsvcell_final+")";
			logger.info("\nFSV formula:\n"+formula_fsv);
			cell_total_fsv.setCellFormula(formula_fsv);
			cell_total_fsv.setCellType(XSSFCell.CELL_TYPE_FORMULA);*/
			
			
			//Dynamic populating the Internal Conditions
			
			intConditionsGridExcelColumnMap = new HashMap<String, String>();
			
			String intcondarray[] = internalgridcolmapping.split("~");
			String IntCondCellname = intcondarray[0];
			String IntCondCellNo = intcondarray[1];
			intConditionsGridExcelColumnMap.put(IntCondCellNo,IntCondCellname);
			
			intConditionDataRowStartNo = intConditionDataRowStartNo + rowShifted;
			currentIntConditionRow = intConditionDataRowStartNo-1;
			
			String queryInternalLimitTable = "select " +" "+ Internal_Limit_ColName +" "+"from"+" " +InternalGrid +" "+"with (nolock) where WINAME=:WI_NAME order by Internal_Sr_No";
			logger.info("\nqueryInternalLimitTable:\n"+queryInternalLimitTable);
			params = "WI_NAME=="+winame;
			
			String inputXML3 = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + queryInternalLimitTable + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
			
			 logger.info("\n InputXML to get internal conditions-->"+inputXML3);
			 String outputXML3 = WFCustomCallBroker.execute(inputXML3, sJtsIp, iJtsPort, 1).replaceAll("AMPNDCHAR","&").replaceAll("CCCOMMAAA",",").replaceAll("PPPERCCCENTT","%");
			 logger.info("\n outputXML to get internal conditions-->"+outputXML3);
			
			WFCustomXmlResponse xmlParserData3=new WFCustomXmlResponse();
			xmlParserData3.setXmlString((outputXML3));
			String mainCodeValue3 = xmlParserData3.getVal("MainCode");
			totalIntConditionsRecord = Integer.parseInt(xmlParserData3.getVal("TotalRetrieved"));
			
			completeIntConditionsDataArrList = new ArrayList<Map<String, String> >(totalIntConditionsRecord);
			
			if(mainCodeValue3.equals("0") && totalIntConditionsRecord>0)
			{
				objWorkList = xmlParserData3.createList("Records","Record"); 
				for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{
					subXML = objWorkList.getVal("Record");
					objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);
					individualIntConditionCellValueMap=null;
					individualIntConditionCellValueMap = new HashMap<String, String>();
					for(int j = 0; j < InternalGridCol.length; ++j)
					{		
						individualIntConditionCellValueMap.put(InternalGridCol[j],objWFCustomXmlResponse.getVal(InternalGridCol[j]));	
					}
					completeIntConditionsDataArrList.add(individualIntConditionCellValueMap);
				}
			}	
				
			
			XSSFRow sourceIntConditionRow = (XSSFRow)sheet.getRow(intConditionDataRowStartNo-1);
			
			for(int i=0; i<completeIntConditionsDataArrList.size(); i++ )
			{
				XSSFRow newIntConditionRow;
				
				if(i!=0)
				{
					sheet.shiftRows(currentIntConditionRow, sheet.getLastRowNum(), 1);								
					sheet.createRow(currentIntConditionRow);
					
					newIntConditionRow = (XSSFRow)sheet.getRow(currentIntConditionRow);
					newIntConditionRow.copyRowFrom(sourceIntConditionRow, new CellCopyPolicy());					
					rowShifted++;					
				}
				else
				{
					newIntConditionRow = (XSSFRow)sheet.getRow(currentIntConditionRow);
				}
				
				
				Iterator<Cell> cellIterator = sourceIntConditionRow.cellIterator();
				
				int internalrowCount=1;
				while (cellIterator.hasNext()) 
				{	
					Cell iCell = cellIterator.next();
					//newRow.createCell(iCell.getColumnIndex()).setCellStyle(iCell.getCellStyle());
					Cell c = newIntConditionRow.getCell(iCell.getColumnIndex());
					
					String columnName = CellReference.convertNumToColString(iCell.getColumnIndex()); 
					
					if(intConditionsGridExcelColumnMap.get(columnName)!=null)
					{
						int cellLineCount = getLineCountFacilityGrid(completeIntConditionsDataArrList.get(i).get(intConditionsGridExcelColumnMap.get(columnName)),220);
						if(cellLineCount>internalrowCount)
						{
							internalrowCount=cellLineCount;
						}
						//c.setCellValue(completeIntConditionsDataArrList.get(i).get(intConditionsGridExcelColumnMap.get(columnName)));
						c.setCellValue(getSplittedValueFacilityGrid(completeIntConditionsDataArrList.get(i).get(intConditionsGridExcelColumnMap.get(columnName))));
					}
					else
					{
						continue;
					}
				}
				newIntConditionRow.setHeight((short)(internalrowCount*255*1.15));
				currentIntConditionRow++;
				
			}
			
			
			//Dynamic populating the External Conditions
			
			extConditionsGridExcelColumnMap = new HashMap<String, String>();
			
			String extcondarray[] = externalgridcolmapping.split("~");
			String ExtCondCellname = extcondarray[0];
			String ExtCondCellNo = extcondarray[1];
			extConditionsGridExcelColumnMap.put(ExtCondCellNo,ExtCondCellname);
			
			extConditionDataRowStartNo = extConditionDataRowStartNo + rowShifted;
			currentExtConditionRow = extConditionDataRowStartNo-1;
			
			String queryExternalLimitTable = "select " +" "+ External_Limit_ColName +" "+"from"+" " +ExternalGrid +" "+"with (nolock) where WINAME=:WI_NAME order by EXTERNAL_SR_NO";
			logger.info("\nqueryExternalLimitTable:\n"+queryExternalLimitTable);
			params = "WI_NAME=="+winame;
			
			String inputXML2 = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + queryExternalLimitTable + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
			
			 logger.info("\n InputXML to get external conditions-->"+inputXML2);
			String outputXML2 = WFCustomCallBroker.execute(inputXML2, sJtsIp, iJtsPort, 1).replaceAll("AMPNDCHAR","&").replaceAll("CCCOMMAAA",",").replaceAll("PPPERCCCENTT","%");
			 logger.info("\n outputXML to get external conditions-->"+outputXML2);
			
			WFCustomXmlResponse xmlParserData2=new WFCustomXmlResponse();
			xmlParserData2.setXmlString((outputXML2));
			String mainCodeValue2 = xmlParserData2.getVal("MainCode");
			totalExtConditionsRecord = Integer.parseInt(xmlParserData2.getVal("TotalRetrieved"));
			
			completeExtConditionsDataArrList = new ArrayList<Map<String, String> >(totalExtConditionsRecord);
			logger.info("check 1");
			if(mainCodeValue2.equals("0") && totalExtConditionsRecord>0)
			{
				objWorkList = xmlParserData2.createList("Records","Record"); 
				for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{
					logger.info("check 11");
					subXML = objWorkList.getVal("Record");
					objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);
					individualExtConditionCellValueMap=null;
					individualExtConditionCellValueMap = new HashMap<String, String>();
					for(int j = 0; j < ExternalGridCol.length; ++j)
					{		
						logger.info("check 111:"+j);
						individualExtConditionCellValueMap.put(ExternalGridCol[j],objWFCustomXmlResponse.getVal(ExternalGridCol[j]));	
					}
					completeExtConditionsDataArrList.add(individualExtConditionCellValueMap);
				}
			}	
				
			
			XSSFRow sourceExtConditionRow = (XSSFRow)sheet.getRow(extConditionDataRowStartNo-1);
			
			for(int i=0; i<completeExtConditionsDataArrList.size(); i++ )
			{
				XSSFRow newExtConditionRow;
				
				if(i!=0)
				{
					sheet.shiftRows(currentExtConditionRow, sheet.getLastRowNum(), 1);								
					sheet.createRow(currentExtConditionRow);
					
					newExtConditionRow = (XSSFRow)sheet.getRow(currentExtConditionRow);
					newExtConditionRow.copyRowFrom(sourceExtConditionRow, new CellCopyPolicy());					
					rowShifted++;					
				}
				else
				{
					newExtConditionRow = (XSSFRow)sheet.getRow(currentExtConditionRow);
				}
				
				
				Iterator<Cell> cellIterator = sourceExtConditionRow.cellIterator();
				
				int externalrowCount=1;
				while (cellIterator.hasNext()) 
				{	
					Cell iCell = cellIterator.next();
					//newRow.createCell(iCell.getColumnIndex()).setCellStyle(iCell.getCellStyle());
					Cell c = newExtConditionRow.getCell(iCell.getColumnIndex());
					
					String columnName = CellReference.convertNumToColString(iCell.getColumnIndex()); 
					
					if(extConditionsGridExcelColumnMap.get(columnName)!=null)
					{
						int cellLineCount = getLineCountFacilityGrid(completeExtConditionsDataArrList.get(i).get(extConditionsGridExcelColumnMap.get(columnName)),220);
						if(cellLineCount>externalrowCount)
						{
							externalrowCount=cellLineCount;
						}
						//c.setCellValue(completeExtConditionsDataArrList.get(i).get(extConditionsGridExcelColumnMap.get(columnName)));
						c.setCellValue(getSplittedValueFacilityGrid(completeExtConditionsDataArrList.get(i).get(extConditionsGridExcelColumnMap.get(columnName))));
					}
					else
					{
						continue;
					}
					
				}
				newExtConditionRow.setHeight((short)(externalrowCount*255*1.15));
				currentExtConditionRow++;
				
			}
			
			//For evaluating all the formulas in sheet
			FormulaEvaluator formulaEvaluator = workbook.getCreationHelper().createFormulaEvaluator();
			formulaEvaluator.evaluateAll();
					
			
			inputStream.close();
		    FileOutputStream outputStream = new FileOutputStream(ouputRawTemplatePath);
            workbook.write(outputStream);
            workbook.close();
            outputStream.close();
			
			docxml = SearchExistingDoc(winame,FrmType,sCabName,sSessionId,sJtsIp,iJtsPort,ouputRawTemplatePath,volumeid,Itemindex);
			logger.info("Final Document Output: "+docxml);
			documentindex = getTagValue(docxml,"DocumentIndex");
			doctype="new";
			logger.info(docxml+"~"+documentindex+"~"+doctype+"~"+dynamicPdfName);
			out.println(docxml+"~"+documentindex+"~"+doctype+"~"+dynamicPdfName);
			}
			catch (IOException e) 
			{
				e.printStackTrace();
			}
			
			catch (Exception e) 
			{		
				logger.info("Exception **********: "+e);
				final Writer result = new StringWriter();
				final PrintWriter printWriter = new PrintWriter(result);
				e.printStackTrace(printWriter);
				
				logger.info("Exception Stack Trace : "+ result);
				
				e.printStackTrace();
				
				out.println("NG110~"+docxml);
				out.println("ERROR : Problem in attaching document");
			}
			
			finally
			{
				try
				{				
					if(workbook!=null)
					{
						workbook.close();
						workbook=null;
					}
				}
				catch(Exception finE)
				{		
				}	
				try
				{
					if(inputStream!=null)
					{
						inputStream.close();
						inputStream=null;
					}				
				}
				catch(Exception finE)
				{
				}
				staticAmountFieldList=null;
				staticAmountFieldArrayList=null;
				directCellValuesMap=null;
				directCellAddressMap=null;
				staticSecurityFieldList=null;
				staticSecurityArrayList=null;
				sheet=null;
				cell=null;
				cellInfo=null;
				staticfieldmapping=null;
				inputRawTemplateFilePath=null;
				ouputRawTemplatePath=null;
				Static_Ext_ColumnName=null;
				ExternalTable=null;
				cellInfo_total=null;
				cell_total=null;
				cell_total_fsv=null;
				
				facilityGridExcelColumnMap=null;
				completeFacilityDataArrList=null;
				individualFacilityCellValueMap=null;
				facilitygridcolmapping=null;
				facilitygridcol=null;
				Facility_GridTable=null;
				facility_GridColName=null;
				objWorkList=null;
				objWFCustomXmlResponse=null;
				subXML=null;
				
				genConditionsGridExcelColumnMap=null;
				completeGenConditionsDataArrList =null;
				individualGenConditionCellValueMap=null;
				generalgridcolmapping=null;
				General_Conditions_GridColName=null;
			
				intConditionsGridExcelColumnMap=null;
				completeIntConditionsDataArrList =null;
				individualIntConditionCellValueMap=null;
				internalgridcolmapping=null;
				Internal_Limit_ColName=null;
			
				extConditionsGridExcelColumnMap=null;
				completeExtConditionsDataArrList =null;
				individualExtConditionCellValueMap=null;
				externalgridcolmapping=null;
				External_Limit_ColName=null;
			
				securityGridExcelColumnMap=null;
				completeSecurityDataArrList=null ;
				individualSecurityCellValueMap=null;
				securitygridcolmapping=null;
				securitygridcol=null;
				Security_GridTable=null;
				security_GridColName=null;
				securityvaluecell_current=null;
				securityvaluecell_final=null;
				valuekey="";
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			logger.info("in template generation.jsp final catch block");
		}
			

%>