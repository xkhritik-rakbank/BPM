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

<%!public static String readFileFromServer(String filename)
	{	
		String xmlReturn="";
		try {
			File file = new File(filename);
			FileReader fileReader = new FileReader(file);
			BufferedReader bufferedReader = new BufferedReader(fileReader);
			StringBuffer stringBuffer = new StringBuffer();
			String line;
			while ((line = bufferedReader.readLine()) != null) {
				stringBuffer.append(line);
				stringBuffer.append("\n");
			}
			fileReader.close();
			logger.info("Contents of file:");
			xmlReturn = stringBuffer.toString();
			//logger.info("file content"+xmlReturn);
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		return xmlReturn;
	
	
	}
	
	public static String convertToTitleCaseIteratingChars(String text) {
		if (text == null || text.isEmpty()) {
			return text;
		}

		StringBuilder converted = new StringBuilder();

		boolean convertNext = true;
		for (char ch : text.toCharArray()) {
			if (Character.isSpaceChar(ch)) {
				convertNext = true;
			} else if (convertNext) {
				ch = Character.toTitleCase(ch);
				convertNext = false;
			} else {
				ch = Character.toLowerCase(ch);
			}
			converted.append(ch);
		}

		return converted.toString();
	}

	
	public static String writeFileFromServer(String filename,String oldString)
	{
		 String newString=oldString;	
		logger.info("\n Inside writeFileFromServer function");
		
		try {
			 //newString = oldString.replaceAll("<p>", " ");
			 //newString = newString.replaceAll("</p>"," ");
            //Rewriting the input text file with newString
			
            FileOutputStream out = new FileOutputStream(filename);
			out.write(newString.getBytes());
			out.close();
			
			//logger.info("after writing into file"+newString);
				
		} catch (IOException e) {
			logger.info("The Exception is "+e.getMessage());
			e.printStackTrace();
		}
			return newString;
	}	
	
	public String getServerDateTime ()
		{
		 Date date = new Date();
		 DateFormat dateFormatScanDateTime = new SimpleDateFormat("dd/MM/yyyy");		   
		 String tempScanDate = dateFormatScanDateTime.format(date);
		 
		 return tempScanDate;
		}
		
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
		
				try {
					
						short iJtsPort = (short) iJtsPort_int;
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
		
  public static String convertLessThanOneThousand(int number) {
    String soFar;
	String numNames[] = {""," One"," Two"," Three"," Four"," Five"," Six"," Seven"," Eight"," Nine"," Ten"," Eleven"," Twelve"," Thirteen"," Fourteen"," Fifteen"," Sixteen"," Seventeen"," Eighteen"," Nineteen"};
	String tensNames[] = {""," Ten"," Twenty"," Thirty"," Forty"," Fifty"," Sixty"," Seventy"," Eighty"," Ninety"};

    if (number % 100 < 20){
      soFar = numNames[number % 100];
      number /= 100;
    }
    else {
      soFar = numNames[number % 10];
      number /= 10;

      soFar = tensNames[number % 10] + soFar;
      number /= 10;
    }
    if (number == 0) return soFar;
    return numNames[number] + " Hundred" + soFar;
  }
  
  public static String convert(int number) {
	  String snumber="";
    // 0 to 999 999 999 999
    if (number == 0) { return "zero"; }
	//int numb=(int) number;
    //String snumber = Long.toString(numb);
	//logger.info("snumber--"+snumber);
	//if(snumber.indexOf(".")!=-1)
	//{
	//	logger.info("contains decimal");
	//}

    // pad with "0"
    String mask = "000000000000";
    DecimalFormat df = new DecimalFormat(mask);
    snumber = df.format(number);

    // XXXnnnnnnnnn
    int billions = Integer.parseInt(snumber.substring(0,3));
    // nnnXXXnnnnnn
    int millions  = Integer.parseInt(snumber.substring(3,6));
    // nnnnnnXXXnnn
    int hundredThousands = Integer.parseInt(snumber.substring(6,9));
    // nnnnnnnnnXXX
    int thousands = Integer.parseInt(snumber.substring(9,12));

    String tradBillions;
    switch (billions) {
    case 0:
      tradBillions = "";
      break;
    case 1 :
      tradBillions = convertLessThanOneThousand(billions)
      + " Billion ";
      break;
    default :
      tradBillions = convertLessThanOneThousand(billions)
      + " Billion ";
    }
    String result =  tradBillions;

    String tradMillions;
    switch (millions) {
    case 0:
      tradMillions = "";
      break;
    case 1 :
      tradMillions = convertLessThanOneThousand(millions)
         + " Million ";
      break;
    default :
      tradMillions = convertLessThanOneThousand(millions)
         + " Million ";
    }
    result =  result + tradMillions;

    String tradHundredThousands;
    switch (hundredThousands) {
    case 0:
      tradHundredThousands = "";
      break;
    case 1 :
      tradHundredThousands = "One Thousand ";
      break;
    default :
      tradHundredThousands = convertLessThanOneThousand(hundredThousands)
         + " Thousand ";
    }
    result =  result + tradHundredThousands;

    String tradThousand;
    tradThousand = convertLessThanOneThousand(thousands);
    result =  result + tradThousand;

    // remove extra spaces!
    return result.replaceAll("^\\s+", "").replaceAll("\\b\\s{2,}\\b", " ");
  }
  
  
  public static String converttomonthname(int monthnum)
  {
	  String monthString;
        switch (monthnum) {
            case 1:  monthString = "January";       break;
            case 2:  monthString = "February";      break;
            case 3:  monthString = "March";         break;
            case 4:  monthString = "April";         break;
            case 5:  monthString = "May";           break;
            case 6:  monthString = "June";          break;
            case 7:  monthString = "July";          break;
            case 8:  monthString = "August";        break;
            case 9:  monthString = "September";     break;
            case 10: monthString = "October";       break;
            case 11: monthString = "November";      break;
            case 12: monthString = "December";      break;
            default: monthString = "Invalid month"; break;
        }
        logger.info(monthString);
		return monthString;
  }
  
  public static String converttodescriptivedate(int day)
  {
	  String dayString;
        if(day==01||day==21||day==31) {
			dayString="st";
		}
		
		else if(day==02||day==22) {
			dayString="nd";
		}
		
		else if(day==03||day==23) {
			dayString="rd";
		}
		
		else {
			dayString="th";
		}
		
        logger.info(dayString);
		return dayString;
  }
  
   public static String capitalizeWord(String str){  
		String words[]=str.split("\\s");  
		String capitalizeWord="";  
		for(String w:words){  
			String first=w.substring(0,1);  
			String afterfirst=w.substring(1);  
			capitalizeWord+=first.toUpperCase()+afterfirst.toLowerCase()+" ";  
		}  
		return capitalizeWord.trim();  
	} 
 
	
%>
<%
	logger.info("\nInside TemplateGeneration.jsp\n");
	try
	{
		String winame = request.getParameter("winame");
		if (winame != null) {winame=winame.replace("'","");}
		String username= customSession.getUserName();
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		String sMappOutPutXML="";
		String params ="";
		String pdfTemplatePath = "";
		String ExternalTable = "";
		String Ext_ColumnName = "";
		String generateddocPath = "";
		String masterfacilitylimit="";
		String accounttobedebitedforfee = "";
		String pdfName ="template";
		String dynamicPdfName =  winame+ pdfName + ".doc";
		String mydate = getServerDateTime();
		String splitdate[] = mydate.split("/");
		String day = splitdate[0];
		logger.info("day is--"+day);
		//int lastday = Integer.parseInt(day.substring(1,day.length()));
		int lastday = Integer.parseInt(day);
		logger.info("last day is---"+lastday);
		String descdate = converttodescriptivedate(lastday);
		String finaldate = day+"<sup>"+descdate+"</sup>";
		String nummonth = splitdate[1];
		int numbermonth = Integer.parseInt(nummonth);
		String month = converttomonthname(numbermonth);
		String year = splitdate[2];
		String actual_Date = finaldate +" "+month+", "+year;
		String Product_Structure_Level_Condition="";
		String Commission="";
		String Facility_ColumnName="";
		String FacilityMasterTable="";
		String facility_details="";
		String natureoffacility="";
		String Facility_GridTable="";
		String Facility_Grid="";
		String facility_GridColName="";
		String tempRowvalues="";
		WFCustomXmlList objWorkList=null;
		WFCustomXmlResponse objWFCustomXmlResponse=null;
		String subXML="";
		String splittemp[]=null;
		String replacedString="";
		String General_Conditions_GridColName="";
		String External_Limit_ColName = "";
		String Internal_Limit_ColName = "";
		String general_details="";
		String external_details="";
		int total_record_extlimit=0;
		int total_record_intlimit=0;
		int total_record_gen=0;
		int total_record_security=0;
		int totalRecord=0;
		String Security_Doc_ColName="";
		String security_details="";
		int values1=0;
		LinkedHashMap<String,String> mapCheckfacility = new LinkedHashMap<String,String>();
		LinkedHashMap<String,String> mapfacility = new LinkedHashMap<String,String>();
		LinkedHashMap<String,String> mapgeneral = new LinkedHashMap<String,String>();
		LinkedHashMap<String,String> mapexternal = new LinkedHashMap<String,String>();
		LinkedHashMap<String,String> mapinternal = new LinkedHashMap<String,String>();
		LinkedHashMap<String,String> mapsecurity = new LinkedHashMap<String,String>();
		Map<String,String> mapCheck = new HashMap<String,String>();
		String twc_temp1="";
		String twc_temp2="";
		String twc_tempfinal="";
		String docxml="";
		String documentindex="";
		String doctype="";
		String Itemindex="";
		String OutputWriteString="";
		String NoField="";
		String novalue="";
		boolean flagchar=false;
		String pattern="";
		int pintext=1;
		String accountNoFee="";
		String facility_sought="";
		String firstvalue="";
		String FacilitySoughtOuter="";
		boolean flagno=false;
		
		//Reading path from property file
		Properties properties = new Properties();
		try
		{
		
			properties.load(new FileInputStream(System.getProperty("user.dir")+ System.getProperty("file.separator")+ "RakBankConfig.properties"));
			
			String tempDir = System.getProperty("user.dir");
			
			String FrmType = properties.getProperty("DocumentName");
			String volumeid = properties.getProperty("VolumeID");
			
			pdfTemplatePath = tempDir + properties.getProperty("TWC_TEMPLATE_HTML_PATH");
			
			ExternalTable = properties.getProperty("External_Table");
			Ext_ColumnName = properties.getProperty("Column_Name");
			String ColumnNameArray[] = Ext_ColumnName.split(",");
			
			FacilityMasterTable = properties.getProperty("Facility_Master_Table");
			Facility_ColumnName = properties.getProperty("Facility_Master_Col_Name");
			String FacilityColArray[] = Facility_ColumnName.split(",");
			
			Facility_GridTable = properties.getProperty("Facility_Grid_Table");
			facility_GridColName = properties.getProperty("Facility_Grid_Col_Name");
			String FacilityGridColumn[] = facility_GridColName.split(",");
			
			General_Conditions_GridColName = properties.getProperty("General_Conditions_Grid_Col_Name");
			String GeneralGridCol[] = General_Conditions_GridColName.split(",");
			String GeneralTable = properties.getProperty("General_Table");
			
			External_Limit_ColName = properties.getProperty("External_Limit_Col_Name");
			String ExternalGridCol[] = External_Limit_ColName.split(",");
			String ExternalGrid= properties.getProperty("External_Grid");
			
			Internal_Limit_ColName = properties.getProperty("Internal_Limit_Col_Name");
			String InternalGridCol[] = Internal_Limit_ColName.split(",");
			String InternalGrid= properties.getProperty("Internal_Grid");
			
			Security_Doc_ColName = properties.getProperty("Security_Doc_Col_Name");
			String SecurityGridCol[] = Security_Doc_ColName.split(",");
			String SecurityGrid = properties.getProperty("Security_Document_Table");
			
			generateddocPath = properties.getProperty("TWC_GENERTATED_HTML_PATH");//Get the loaction of the path where generated template will be saved
			generateddocPath += dynamicPdfName;
			generateddocPath = tempDir + generateddocPath;//Complete path of generated document
			logger.info("\nTemplate Doc generateddocPath :" + generateddocPath);
			
			sMappOutPutXML = readFileFromServer(pdfTemplatePath);
			//logger.info("replaced string nikita"+sMappOutPutXML);
			replacedString = sMappOutPutXML.replaceAll("&lt;","<");
			replacedString = replacedString.replaceAll("&gt;",">");
			replacedString = replacedString.replaceAll("â€œ","");  
			replacedString = replacedString.replaceAll("â€?"," "); 
			replacedString = replacedString.replaceAll("&amp;","&");   
			replacedString = replacedString.replaceAll("â€™","'"); 
			
			//logger.info("\nOutput XML Customer Integration Call by Nikita:\n"+sMappOutPutXML);		
			String queryExtTable = "select" +" "+ Ext_ColumnName +" "+"from" +" "+ExternalTable+" "+ "with (nolock) where wi_name=:WI_NAME";
			logger.info("\nqueryExtTable:\n"+queryExtTable);
			params = "WI_NAME=="+winame;
			
			String inputXML4 = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + queryExtTable + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
			
			 logger.info("\n InputXML to get Customer Name-->"+inputXML4);
			String outputXML4 = WFCustomCallBroker.execute(inputXML4, sJtsIp, iJtsPort, 1).replaceAll("AMPNDCHAR","&").replaceAll("CCCOMMAAA",",").replaceAll("PPPERCCCENTT","%");
			 logger.info("\n outputXML to get Customer Name-->"+outputXML4);
			
			WFCustomXmlResponse xmlParserData4=new WFCustomXmlResponse();
			xmlParserData4.setXmlString((outputXML4));
			String mainCodeValue4 = xmlParserData4.getVal("MainCode");
			
			WFCustomXmlResponse objXmlParser4=null;
			
			if(mainCodeValue4.equals("0"))
			{
			    Itemindex = xmlParserData4.getVal(ColumnNameArray[0]);
				logger.info("Item Index is"+Itemindex);
				for(int j = 0; j < ColumnNameArray.length; ++j)
				{	
					mapCheck.put(ColumnNameArray[j],xmlParserData4.getVal(ColumnNameArray[j]));	
				}
				logger.info("Fetching Keys and corresponding [Multiple] Values");
				for (Map.Entry<String,String> entry : mapCheck.entrySet()) 
				{
					String key = entry.getKey();
					String values = entry.getValue();
					logger.info("Ext Column Key = " + key);
					logger.info("Ext Column values"+values);
					// capitalize first letter of each word
					if (key.equalsIgnoreCase("Emirate") && !values.trim().equalsIgnoreCase("")) {
						if (values.contains(" "))
							values = capitalizeWord(values);
						else	
							values = values.substring(0, 1).toUpperCase() + values.substring(1, values.length()).toLowerCase(); 
					}
					//*********************************
					// changing date seperator with . dot in review date
					if (key.equalsIgnoreCase("Review_Date") && !values.trim().equalsIgnoreCase("")) {
						values = values.replace("/",".");
					}
					//*********************************
					replacedString = replacedString.replaceAll("<&"+key+"&>",values);
					
					if(key.equals("FeeDebitedAccount"))
					{
						logger.info("account no is--"+values);
						accountNoFee = values;
						if(accountNoFee.equals("") || accountNoFee==null)
						{
							logger.info("replaced string before--"+replacedString);
							replacedString=replacedString.replaceAll("<&Account No.: FeeDebitedAccount&>","");
							replacedString=replacedString.replaceAll("<&COLON&>",":");
							logger.info("replaced string after--"+replacedString);
						}
						else
						{
							replacedString=replacedString.replaceAll("<&Account No.: FeeDebitedAccount&>","Account No.: "+values);
							replacedString=replacedString.replaceAll("<&COLON&>","");
						}	
					}
				}
			}
			
			else
			{
				out.clear();
				//out.print("-4");
				out.print("ERROR - Error while fetching the data from security document table");
				return;
			}
			
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
			total_record_gen = Integer.parseInt(xmlParserData1.getVal("TotalRetrieved"));
			logger.info("total_record_gen---"+total_record_gen);
			
			WFCustomXmlResponse objXmlParser1=null;
			
			if(mainCodeValue1.equals("0") && total_record_gen>0)
			{
				objWorkList = xmlParserData1.createList("Records","Record"); 
				int p=1;
				general_details +="<b><ul style='list-style-type:disc;list-style-position:outside;margin-left:0.25in;tab-stops:list 0.25in;'>\n";
				for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{
					//general_details +="<ul style=list-style:none;list-style-image:none;list-style-type:none;>";
					subXML = objWorkList.getVal("Record");
					objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);	
					for(int j = 0; j < GeneralGridCol.length; ++j)
					{		
						mapgeneral.put(GeneralGridCol[j],objWFCustomXmlResponse.getVal(GeneralGridCol[j]));	
					}
						
					for (Map.Entry<String,String> entry : mapgeneral.entrySet()) 
					{
						String key = entry.getKey();
						String values = entry.getValue();
						logger.info("key for general--------->"+key);
						logger.info("values for general------->"+values);
						if(!(values==null || values.equals("")))
						{
								
							if(p>=1)
							{
								//general_details += "<b>"+p+"."+values+"</b><br>";
								general_details += "<li style='margin-top:0.10in;text-align:justify;text-indent:-0.20in;'><b>"+values+"</b></li>";
								//general_details +="<br />";
								p++;
								break;
							}
								
								
						}
					}
				}
				general_details +="</ul></b>";
				logger.info("general_details--"+general_details);
				
				
			}
			
			else if(mainCodeValue1.equals("0") && total_record_gen==0)
			{
				general_details="";
			}
			
			else
			{
				out.clear();
				out.print("ERROR - Error while fetching the data from general conditions table");
				return;
			}
			
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
			total_record_intlimit = Integer.parseInt(xmlParserData3.getVal("TotalRetrieved"));
			
			WFCustomXmlResponse objXmlParser3=null;
			
			external_details +="<ol style='list-style-position:outside;margin-left:0.25in;tab-stops:list 0.25in;'>";	
			if(mainCodeValue3.equals("0") && total_record_intlimit>0)
			{
				objWorkList = xmlParserData3.createList("Records","Record"); 
				for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{
					//external_details +="<body>";	
					subXML = objWorkList.getVal("Record");
					objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);	
					for(int j = 0; j < InternalGridCol.length; ++j)
					{		
						mapinternal.put(InternalGridCol[j],objWFCustomXmlResponse.getVal(InternalGridCol[j]));	
					}
						
					for (Map.Entry<String,String> entry : mapinternal.entrySet()) 
					{
						String key = entry.getKey();
						String values = entry.getValue();
						logger.info("key for internal--------->"+key);
						logger.info("values for internal------->"+values);
						if(!(values.trim().equals("")))
						{
							if(pintext>=1)
							{
								//external_details += pintext+"."+values+"<br>";
								external_details += "<li style='margin-top:0.10in;text-align:justify'>"+values+"</li>";
								//external_details +="<br/>";
								pintext++;
								break;
							}
						}
					}
				}
				
				
			}
			
			
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
			total_record_extlimit = Integer.parseInt(xmlParserData2.getVal("TotalRetrieved"));
			
			WFCustomXmlResponse objXmlParser2=null;
			
			if(mainCodeValue2.equals("0") && total_record_extlimit>0)
			{
				objWorkList = xmlParserData2.createList("Records","Record"); 
				for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{
					//external_details +="<body>";	
					subXML = objWorkList.getVal("Record");
					objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);	
					for(int j = 0; j < ExternalGridCol.length; ++j)
					{		
						mapexternal.put(ExternalGridCol[j],objWFCustomXmlResponse.getVal(ExternalGridCol[j]));	
					}
						
					for (Map.Entry<String,String> entry : mapexternal.entrySet()) 
					{
						String key = entry.getKey();
						String values = entry.getValue();
						logger.info("key for external--------->"+key);
						logger.info("values for external------->"+values);
						if(!(values.trim().equals("")))
						{
							if(pintext>=1)
							{
								external_details += "<li style='margin-top:0.10in;text-align:justify'>"+values+"</li>";
								//external_details +="<br/>";
								pintext++;
								break;
							}
						}
					}
				}
			}
			else if(mainCodeValue2.equals("0") && total_record_extlimit==0)
			{
				//external_details="";
			}
			else
			{
				out.clear();
				out.print("ERROR - Error while fetching the data from external limit table");
				return;
			}
			
			external_details += "<li style='margin-top:0.10in;text-align:justify'>Immediately inform the Bank of any proposed change of its authorised signatories or amendment to its Memorandum or Articles of Association or any other constitutional documents; and (ii) provide copies of board/member/shareholder resolutions or other corporate authorizations as required wherever appropriate on decisions which impact the Facilities.</li>";
			
			pintext++;
			
			external_details += "<li style='margin-top:0.10in;text-align:justify'>So long as any money is owing under the Agreement, it shall not without the prior written consent of the Bank undertake or permit any merger, bifurcation or re-organisation affecting the legal character of the Customer or the ownership or control over the management of the Customer. The Customer shall ensure that none of the shareholders of the Customer as at date of the Offer Letter transfers or sells their shares without prior written consent of the Bank.</li></ol>";
			
			String querySecurityDocTable = "select " +" "+ Security_Doc_ColName +" "+"from"+" " +SecurityGrid +" "+"with (nolock) where WINAME=:WI_NAME order by Security_Sr_No";
			logger.info("\nquerySecurityDocTable:\n"+querySecurityDocTable);
			params = "WI_NAME=="+winame;
			
			String inputXMLSecurity = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + querySecurityDocTable + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
			
			 logger.info("\n InputXML to get security conditions-->"+inputXMLSecurity);
			String outputXMLsecurity = WFCustomCallBroker.execute(inputXMLSecurity, sJtsIp, iJtsPort, 1).replaceAll("AMPNDCHAR","&").replaceAll("CCCOMMAAA",",").replaceAll("PPPERCCCENTT","%");
			 logger.info("\n outputXML to get security conditions-->"+outputXMLsecurity);
			
			
			
			
			WFCustomXmlResponse xmlParserData7=new WFCustomXmlResponse();
			xmlParserData7.setXmlString((outputXMLsecurity));
			String mainCodeValue7 = xmlParserData7.getVal("MainCode");
			total_record_security = Integer.parseInt(xmlParserData7.getVal("TotalRetrieved"));
			
			WFCustomXmlResponse objXmlParser7=null;
			
			if(mainCodeValue7.equals("0") && total_record_security>0)
			{
				objWorkList = xmlParserData7.createList("Records","Record"); 
				int p=1;
				security_details +="<ol style='list-style-position:outside;margin-left:0.25in;tab-stops:list 0.25in;'>";	
				for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{
					//security_details +="<body>";	
					subXML = objWorkList.getVal("Record");
					objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);	
					for(int j = 0; j < SecurityGridCol.length; ++j)
					{		
						mapsecurity.put(SecurityGridCol[j],objWFCustomXmlResponse.getVal(SecurityGridCol[j]));	
					}
						
					for (Map.Entry<String,String> entry : mapsecurity.entrySet()) 
					{
						String key = entry.getKey();
						String values = entry.getValue();
						logger.info("key for security--------->"+key);
						logger.info("values for security------->"+values);
						values = values.replaceAll("AMPNDCHAR","&");
						values = values.replaceAll("CCCOMMAAA",",");
						values = values.replaceAll("PPPERCCCENTT","%");
						if(!(values==null || values.equals("")))
						{
							if(p>=1)
							{
							
								//security_details += p+"."+values+"<br>";
								security_details += "<li style='margin-top:0.10in;text-align:justify;'>"+values+"</li>";
								//security_details +="<br />";
								p++;
								break;
							}
						}
					}
				}
				security_details +="</ol>";		
			}
			
			else if(mainCodeValue7.equals("0") && total_record_security==0)
			{
				security_details="";
			}
			
			else
			{
				out.clear();
				//out.print("-6");
				out.print("ERROR - Error while fetching the data from security document table");
				return;
			}
			

			String queryFacilityGrid = "select" +" "+ facility_GridColName +" "+"from" +" "+Facility_GridTable+" "+ "with (nolock) where WINAME=:WI_NAME Order by cast(LEFT(SUBSTRING(NO, PATINDEX('%[0-9.-]%', NO), 8000),   PATINDEX('%[^0-9.-]%', SUBSTRING(NO, PATINDEX('%[0-9.-]%', NO), 8000) + 'X') -1) as int),NO";
			logger.info("\nqueryFacilityGrid:\n"+queryFacilityGrid);
			params = "WI_NAME=="+winame;
			
			String inputXML6 = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + queryFacilityGrid + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
			
			 logger.info("\n InputXML to get facility type from facility grid-->"+inputXML6);
			String outputXML6 = WFCustomCallBroker.execute(inputXML6, sJtsIp, iJtsPort, 1).replaceAll("AMPNDCHAR","&").replaceAll("CCCOMMAAA",",").replaceAll("PPPERCCCENTT","%");
			 logger.info("\n outputXML to get facility type from facility grid-->"+outputXML6);
			
			WFCustomXmlResponse xmlParserData6=new WFCustomXmlResponse();
			xmlParserData6.setXmlString((outputXML6));
			String mainCodeValue6 = xmlParserData6.getVal("MainCode");
			totalRecord=Integer.parseInt(xmlParserData6.getVal("TotalRetrieved"));
			
			WFCustomXmlResponse objXmlParser6=null;
			int b=1;
			

			 if(mainCodeValue6.equals("0") && totalRecord>0)
			{
				objWorkList = xmlParserData6.createList("Records","Record"); 
				//logger.info("objWorkList"+objWorkList);
				for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{
					flagchar=false;
					subXML = objWorkList.getVal("Record");
					objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);
					for(int j = 0; j < FacilityGridColumn.length; ++j)
					{
						//mapCheckfacility.clear();	
						
						String facColValue = objWFCustomXmlResponse.getVal(FacilityGridColumn[j]);
						if(FacilityGridColumn[j].equalsIgnoreCase("PRODUCT_LEVEL_CONDITIONS"))
						{
							/*facColValue = "<b>"+facColValue.replaceAll((char)(13)+"", "</b><li><b>");
							facColValue=facColValue+"</b></li>";
							
							facColValue=facColValue.replaceAll("<li><b>NEWTAB", "&nbsp;&nbsp;&nbsp;&nbsp;<li><b>");
							*/

							logger.info("facColValue ak 1 = " + facColValue);
							String newLineSepArr[] = facColValue.split(""+(char)13);
							facColValue= "<ul style='list-style-type:disc;list-style-position:outside;margin-left:0.25in;tab-stops:list 0.25in;'>\n";
							for(int x=0;x<newLineSepArr.length;x++)
							{
								String tabSepArr[] = newLineSepArr[x].split("NEWTAB");
							
								if(tabSepArr.length>1)
								{
									facColValue= facColValue+"<ul style='list-style-type:none;list-style-position:outside;margin-left:0.25in;tab-stops:list 0.25in;'>";
									for(int y=0;y<tabSepArr.length;y++)
									{
										if(!(tabSepArr[y]==null || tabSepArr[y].trim().equalsIgnoreCase("")))
										{
											facColValue= facColValue+"<li style='margin-top:0in;margin-bottom:0in;text-align:justify;text-indent:-0.20in;'><b>"+tabSepArr[y]+"</b></li>\n";
										}
									}
									facColValue= facColValue+"</ul>";
								}
								else
								{
									if(!(newLineSepArr[x]==null || newLineSepArr[x].trim().equalsIgnoreCase("")))
									{
										facColValue= facColValue+"<li style='margin-top:0in;margin-bottom:0in;text-align:justify;text-indent:-0.20in;'><b>"+newLineSepArr[x]+"</b></li>\n";
									}	
								}
							}
							facColValue =facColValue+ "</ul>";	
							logger.info("facColValue ak 2 = " + facColValue);
							
						}
						if(FacilityGridColumn[j].equalsIgnoreCase("COMMISSION"))
						{
							//facColValue = facColValue.replaceAll((char)(13)+"", "<li>");
							//facColValue=facColValue+"</li>";
							
							String newLineSepArr[] = facColValue.split(""+(char)13);
							facColValue= "<ul style='list-style-type:disc;list-style-position:outside;margin-left:0.25in;tab-stops:list 0.25in;'>\n";
							for(int x=0;x<newLineSepArr.length;x++)
							{
								String tabSepArr[] = newLineSepArr[x].split("NEWTAB");
							
								if(tabSepArr.length>1)
								{
									facColValue= facColValue+"<ul style='list-style-type:none;list-style-position:outside;margin-left:0.25in;tab-stops:list 0.25in;'>";
									for(int y=0;y<tabSepArr.length;y++)
									{
										if(!(tabSepArr[y]==null || tabSepArr[y].trim().equalsIgnoreCase("")))
										{
											facColValue= facColValue+"<li style='margin-top:0in;margin-bottom:0in;text-align:justify;text-indent:-0.20in;'>"+tabSepArr[y]+"</li>\n";
										}
									}
									facColValue= facColValue+"</ul>";
								}
								else
								{
									if(!(newLineSepArr[x]==null || newLineSepArr[x].trim().equalsIgnoreCase("")))
									{
										facColValue= facColValue+"<li style='margin-top:0in;margin-bottom:0in;text-align:justify;text-indent:-0.20in;'>"+newLineSepArr[x]+"</li>\n";
									}	
								}
							}
							facColValue =facColValue+ "</ul>";	
						}
						mapCheckfacility.put(FacilityGridColumn[j],facColValue);
						
					}
					logger.info("mapCheckfacility size x--"+mapCheckfacility.size());
						for (Map.Entry<String,String> entry : mapCheckfacility.entrySet()) {
						String key = entry.getKey();
						String values = entry.getValue();
						logger.info("Key = " + key);
						logger.info("facility master Values = " + values);
						
						if(key.equals("NO"))
						{
							NoField=values;
							logger.info("no field in facility grid--"+NoField);
							if (!NoField.trim().equalsIgnoreCase(""))
							{
								pattern = ".*[a-zA-Z]+.*";
								 final String REG = pattern;
								 Pattern p = Pattern.compile(REG);//. represents single character  
								 Matcher m = p.matcher(NoField);
								 flagchar = m.matches();
								
								  if(firstvalue==null || firstvalue=="" || firstvalue.equalsIgnoreCase(""))
								  {
									  firstvalue = values;
									  FacilitySoughtOuter=facility_sought;
								  }
								 
								  else 
								  {
									  String outerSeq = "";
									  if(firstvalue.contains(","))
									  {
										  String [] tempOutSeq = firstvalue.split(",");
										  outerSeq = tempOutSeq[0];
									  } else
										  outerSeq = firstvalue;
										  
									  //if(values.charAt(0)!=firstvalue.charAt(0))
									  if(!values.contains(outerSeq))
									  {
										  firstvalue = values;
										  FacilitySoughtOuter=facility_sought;
									  }
									  else
									  {
										 firstvalue=firstvalue+","+values;
									  }
									  
								  }
							 }
							  
							  logger.info("flagchar is--"+flagchar);
						}
						
						if(key.equals("FACILITY_SOUGHT") && flagchar==false)
						{
							facility_sought=values;
							logger.info("facility sought is--"+facility_sought);
						}
						
					}
					
					
					String queryFacilityMaster = "select" +" "+ Facility_ColumnName +" "+"from" +" "+FacilityMasterTable+" "+ "with (nolock) where FACILITY_TYPE=:FACILITY_TYPE";
					logger.info("\nqueryFacilityMaster:\n"+queryFacilityMaster);
					logger.info("Nature of facility is "+mapCheckfacility.get("NATURE_OF_FACILITY"));
					if(mapCheckfacility.get("NATURE_OF_FACILITY")==null || mapCheckfacility.get("NATURE_OF_FACILITY").equals(""))
					{
						logger.info("In if Sajan");
						continue;
					}
					params = "FACILITY_TYPE=="+mapCheckfacility.get("NATURE_OF_FACILITY");
					logger.info("nature of facility is"+mapCheckfacility.get("NATURE_OF_FACILITY"));
					
					String inputXML5 = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + queryFacilityMaster + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
					
					 logger.info("\n InputXML to get Facility Values from master-->"+inputXML5);
					String outputXML5 = WFCustomCallBroker.execute(inputXML5, sJtsIp, iJtsPort, 1).replaceAll("AMPNDCHAR","&").replaceAll("CCCOMMAAA",",").replaceAll("PPPERCCCENTT","%");
					 logger.info("\n outputXML to get Facility Values from master-->"+outputXML5);
					
					WFCustomXmlResponse xmlParserData5=new WFCustomXmlResponse();
					xmlParserData5.setXmlString((outputXML5));
					String mainCodeValue5 = xmlParserData5.getVal("MainCode");
					
					WFCustomXmlResponse objXmlParser5=null;
					
					if(mainCodeValue5.equals("0"))
					{
						 for(int j = 0; j < FacilityColArray.length; ++j)
						{	
							//mapfacility.clear();
							mapfacility.put(FacilityColArray[j],xmlParserData5.getVal(FacilityColArray[j]));
								
						}
						logger.info("Fetching Keys and corresponding [Multiple] Values");
						for (Map.Entry<String,String> entry : mapfacility.entrySet()) 
						{
							String key = entry.getKey();
						
							String values = entry.getValue();
							logger.info("Key = " + key);
							logger.info("facility grid Values = " + values);						
						}						
					}  
					
					else
					{
						out.clear();
						//out.print("-2");
						out.print("ERROR - Error while fetching the data from facility master");
						return;
					}
							
					facility_details += "<table border="+0+">";
					facility_details += "<tr><td rowspan=20 valign=top style='width:5%'><h4><b>"+NoField+"</b>.</h4></td><td valign=top style='width:18%'><b>Facility Type</b></td><td valign=top style='width:2%'><b>:</b></td><td valign=top style='width:75%'><b>"+mapCheckfacility.get("NATURE_OF_FACILITY")+"</b></td></tr>";
					//b++;
					for (Map.Entry<String,String> entry : mapfacility.entrySet()) 
					{
						String key = entry.getKey();
						String values = entry.getValue();
						
						if(key.equals("LIMIT") && flagchar==true)
						{
							key=key.replace("LIMIT","SUB-LIMIT"); 
							String SequenceOuterFacility = "";
							if(firstvalue.indexOf(",")>0)
							{
								SequenceOuterFacility = firstvalue.substring(0, firstvalue.indexOf(","));
							}
							values = values+" (Sub-Limit to Facility Limit set out for Facility "+SequenceOuterFacility+" above).";
						}
						
						if(key.equals("PRODUCT_STRUCTURE_LEVEL_CONDITION") && flagchar==true)
						{
							logger.info("Adbg 1 : "+values + " , firstvalue "+firstvalue + " ,  facility_sought "+FacilitySoughtOuter  );
							String subFacilitiesList = firstvalue;
							if(subFacilitiesList.indexOf(",")>0)
							{
								
								subFacilitiesList = subFacilitiesList.substring(0, subFacilitiesList.lastIndexOf(",")) + " and " + subFacilitiesList.substring(subFacilitiesList.lastIndexOf(",")+1,subFacilitiesList.length());
								
							}
								
							values=values+"<ul style='list-style-type:disc;list-style-position:outside;margin-left:0.25in;tab-stops:list 0.25in;'><li style='margin-top:0in;margin-bottom:0in;text-align:justify;text-indent:-0.20in;'><b>Total outstanding under Facilities "+subFacilitiesList+" should not exceed AED "+FacilitySoughtOuter+" at any point of time.</b></li></ul>";
							
							
						}
						if(key.equals("COMMISSION")){
						   values = values.replaceAll((char)(13)+"", "<br>");
						}
							
					
						if(key.equals("REPAYMENT")){
						   values = values.replaceAll((char)(13)+"", "<br>");	
						}
						
						if(key.equals("FEES_AND_CHARGES")){
						   values = values.replaceAll((char)(13)+"", "<br>");	
						}
						
						
						key=convertToTitleCaseIteratingChars(key.replace("_"," "));
						
						logger.info("Point 1 "+key);
						logger.info("Point 2 "+values);
						
						if(!(values==null || values.trim().equals("")))
						{
							logger.info("Point 3");
							if(!values.endsWith("."))
							{
								//values = values +"."; // not required, will be updated in master
							}
							facility_details += "<tr><td valign=top><b>"+key+" </b></td><td valign=top><b>:</b></td><td valign=top>"+values+"</td></tr>";
						}
						else
						{
							logger.info("Point 4");
						}
						
					}
					facility_details += "</table>";
					facility_details += "<br/>";
					logger.info("Facility details as checked by Nikita--"+facility_details);
					
					
					for (Map.Entry<String,String> entry : mapCheckfacility.entrySet()) 
					{
						String key = entry.getKey();
						String values = entry.getValue();
						
						//logger.info("facility detail html before replacing placeholder"+facility_details);
						
						if(facility_details.indexOf("Product Structure Level Condition")!=-1)
						{
							facility_details=facility_details.replaceAll("Product Structure Level Condition","Notes"); 
							
						}
						
						//logger.info("this time facility detail before--"+facility_details);
						facility_details = facility_details.replaceAll("<&"+key+"&>",values);
						//logger.info("this time facility detail after--"+facility_details);
						if(facility_details.indexOf("<&FACILITY_SOUGHT_IN_WORDS&>") != -1)
						{
							if(key.equals("FACILITY_SOUGHT"))
							{
								if (!values.equalsIgnoreCase(""))
								{
									//double d=Double.parseDouble(values.replace(",",""));
									String snumber = values.replace(",","");
									//String snumber = Double.toString(d);
									//values1=(int) d;
									//twc_temp = convert(values1); 
									
									if(snumber.indexOf(".") != -1)
									{
										// nothing to do
									}
									else
									{
										snumber = snumber+".00";
									}	
									
									String spplitnum[] =snumber.split("\\."); 
									int beforedecimal = Integer.parseInt(spplitnum[0]);
									int afterdecimal = Integer.parseInt(spplitnum[1]);
									twc_temp1 = convert(beforedecimal);
									logger.info("before decimal in words--"+twc_temp1);
									logger.info("afterdecimal decimal in words--"+afterdecimal);
									twc_temp2 = convert(afterdecimal);
									logger.info("after decimal in words--"+twc_temp2);
									if(afterdecimal==00 || afterdecimal==0)
										twc_tempfinal=twc_temp1;
									else
										twc_tempfinal=twc_temp1+" and Fils "+twc_temp2;
								}
								logger.info("facility_details decimal in words--"+twc_tempfinal);
								facility_details = facility_details.replaceAll("<&FACILITY_SOUGHT_IN_WORDS&>",twc_tempfinal);
								logger.info("facility_details facility_details in facility_details--"+facility_details);
								 
							}
							
						}
						
						facility_details = facility_details.replaceAll((char)(13)+"", "<br>");
						logger.info("facility_detail final --->"+facility_details);
					}
					//facility_details+="<br/>";
				}
				
			}

			else if(mainCodeValue6.equals("0")&&totalRecord==0)
			{
				facility_details="";
			}	
			
			else
			{
				out.clear();
				//out.print("-3");
				out.print("ERROR - Error while fetching the data from facility grid");
				return;
				
			}
			logger.info("actual_Date HTML String: "+actual_Date);		
			replacedString=replacedString.replaceAll("<&Letter Generation Date &>",actual_Date);
			logger.info("facility_details HTML String: "+facility_details);	
			replacedString=replacedString.replaceAll("<&FACILITY_DETAILS&>",facility_details);	
			logger.info("general_details HTML String: "+general_details);	
			replacedString=replacedString.replaceAll("<&General Conditions - Table data to be populated&>",general_details.replaceAll((char)(13)+"", "<br>"));  
			logger.info("replacedString HTML String: "+replacedString);	
			logger.info("external_details HTML String: "+external_details);
			replacedString=replacedString.replaceAll("<&Special Covenants / Conditions External - Proposed Limits - Table data to be populated&>",Matcher.quoteReplacement(external_details).replaceAll((char)(13)+"", "<br>"));  

			replacedString=replacedString.replaceAll("<&Security Document Description from Security Document table will be displayed&>",Matcher.quoteReplacement(security_details).replaceAll((char)(13)+"", "<br>"));
			
			OutputWriteString = writeFileFromServer(generateddocPath,replacedString);
			docxml = SearchExistingDoc(winame,FrmType,sCabName,sSessionId,sJtsIp,iJtsPort,generateddocPath,volumeid,Itemindex);
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
			logger.info("Exception: "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			
			logger.info("Exception Stack Trace : "+ result);
			
			e.printStackTrace();
			
			out.println("NG110~"+docxml);
			out.println("ERROR : Problem in attaching document");
		}	
		
	}
	catch(Exception e)
	{
		e.printStackTrace();
		//sMappOutPutXML="Exception"+e;
		logger.info("in template generation.jsp final catch block");
		//logger.info(sMappOutPutXML);
	}
%>

