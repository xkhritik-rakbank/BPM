package com.newgen.DormancyChanges;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;

import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
//import com.newgen.omni.wf.util.app.NGEjbClient;
//import com.newgen.wfdesktop.xmlapi.WFCallBroker;

public class InsertIntoDB {
	//private static NGEjbClient ngEjbClientDormancyChanges;
	static String insertToDB(List<String>CIFs,String FileName,String DateTime,String cabinetName, String sessionId, String JtsIp, String JtsPort,String tableName,String status) {
		String res="FAIL";
		String res1="FAIL";
		try
		{
			List<ArrayList<String>> masterDataClass = new ArrayList<>();
			masterDataClass=SearchOnMasterData(cabinetName,sessionId,JtsIp,JtsPort,status);
			String columnNames = "FILE_NAME,FILE_CREATION_DATATIME,INSERTIONDATETIME,SEARCH_FIELD,FINAL_STATUS,iBPS_STATUS,OF_STATUS";
			for(int i=0;i<CIFs.size();i++)
			{
				String columnValues ="'"+FileName+"','"+DateTime+"',getdate(),'"+CIFs.get(i)+"','N','N','N'";
				DormancyChangesLog.DormancyChangeLogger.debug("value for columns are :"+columnValues);
				res=insertIntoDataBase(cabinetName, sessionId, JtsIp, JtsPort ,columnNames, columnValues,tableName);
				if(res.equalsIgnoreCase("FAIL"))
					return res;
				String columnNames1="FILE_NAME,FILE_CREATION_DATETIME,INSERTIONDATETIME,SEARCH_FIELD,DATACLASS_NAME,INDEX_FIELDNAME,iBPS_DATADEF_INDEX,"
						+ "iBPS_INDEX_ID,OF_DATADEF_INDEX,OF_INDEX_ID,DATACLASS_TYPE,iBPS_STATUS,OF_STATUS";
				for(int k=0;k<masterDataClass.size();k++) //constant time loop 
				{
					String columnValues1="'"+FileName+"','"+DateTime+"',getdate(),'"+CIFs.get(i)+"','"+masterDataClass.get(k).get(0)+"','"+masterDataClass.get(k).get(1)+"',"
							+ "'"+masterDataClass.get(k).get(2)+"','"+masterDataClass.get(k).get(3)+"','"+masterDataClass.get(k).get(4)+"','"+masterDataClass.get(k).get(5)+"','"+masterDataClass.get(k).get(6)+"','N','N'";
					DormancyChangesLog.DormancyChangeLogger.debug("value for columns are :"+columnValues);
					res1=insertIntoDataBase(cabinetName, sessionId, JtsIp, JtsPort ,columnNames1, columnValues1,"USR_0_Dorm_SearchFieldDataClassMapping");
					if(res1.equalsIgnoreCase("FAIL"))
						return res1;
				}
			}
			return res;
		}
		catch(Exception e)
		{
			e.printStackTrace();
			DormancyChangesLog.DormancyChangeLogger.error("Exception Occurred in inserting in DB: "+e.getMessage());
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			DormancyChangesLog.DormancyChangeLogger.error("Exception Occurred in inserting in DB: "+result);
			return "FAIL";
		}	
	}
	static String insertIntoDataBase(String cabinetName, String sessionId, String JtsIp, String JtsPort,String columnNames,String columnValues,String tableName)//tablename, columnsname, columnsvalue
	{
		try
		{
			String apInsertInputXML = CommonMethods.apInsert(cabinetName, sessionId, columnNames, columnValues,tableName);
			DormancyChangesLog.DormancyChangeLogger.debug(apInsertInputXML);
			String apInsertOutputXML = CommonMethods.WFNGExecute(apInsertInputXML, JtsIp, JtsPort, 1);
			DormancyChangesLog.DormancyChangeLogger.debug(apInsertOutputXML);
			XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
			String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
			if (apInsertMaincode.equalsIgnoreCase("0")) 
			{
				DormancyChangesLog.DormancyChangeLogger.debug("apinsert successfully "+apInsertMaincode);
			} 
			else 
			{
				DormancyChangesLog.DormancyChangeLogger.error("apinsert Failed"+apInsertMaincode);
				return "FAIL";
			}
		}
		catch(Exception e)
		{
			DormancyChangesLog.DormancyChangeLogger.error("Exception Occurred in inserting in DB: "+e.getMessage());
			return "FAIL";
		}
		return "Pass";
	}
	static String ErrorDetailsInsertion(String cabinetName, String sessionId, String JtsIp, String JtsPort,String columnValues)
	{
			String ErrroTableColumns="DORM_TO_ACTIVE,FOLDER_INDEX,SEARCH_FIELD,IBPS_OR_OF_STATUS,ACT_DATETIME,ERROR_MSG";
			String ErrorRes=insertIntoDataBase(cabinetName, sessionId, JtsIp, JtsPort ,ErrroTableColumns, columnValues,"USR_0_Dorm_ErrorDetails");
			return ErrorRes;
	}
	static String mailQueueInsertion(String cabinetName, String sessionId, String JtsIp, String JtsPort,String columnValues)
	{
		String mailColumnName="mailFrom,mailTo,mailSubject,mailMessage,mailContentType,mailPriority,mailStatus,insertedBy,mailActionType,insertedTime,noOfTrials";
		String mailRes=insertIntoDataBase(cabinetName, sessionId, JtsIp, JtsPort ,mailColumnName, columnValues,"WFMAILQUEUETABLE");
		return mailRes;
	}
	static List<ArrayList<String>>SearchOnMasterData(String cabinetName,String sessionId,String JtsIp,String JtsPort,String status) throws IOException, Exception
	{ 
		List<ArrayList<String>> masterDataClass = new ArrayList<>();
		String Query = "SELECT DATACLASS_NAME,INDEX_FIELDNAME,iBPS_DATADEF_INDEX,iBPS_INDEX_ID,OF_DATADEF_INDEX,OF_INDEX_ID FROM USR_0_Dorm_DataClassMapping with (nolock) WHERE STATUS='"+status+"'";
		String dataClassInputXML =CommonMethods.apSelectWithColumnNames(Query, cabinetName, sessionId);
		DormancyChangesLog.DormancyChangeLogger.debug("DataClass details APSelect InputXML: "+dataClassInputXML);

		String  dataClassOutputXML=CommonMethods.WFNGExecute(dataClassInputXML,JtsIp,JtsPort,1);
		DormancyChangesLog.DormancyChangeLogger.debug("DataClass Details APSelect OutputXML: "+dataClassOutputXML);

		XMLParser xmlParserdataClassDetails= new XMLParser(dataClassOutputXML);
		String dataClassDetailsMainCode = xmlParserdataClassDetails.getValueOf("MainCode");
		DormancyChangesLog.DormancyChangeLogger.debug("MainCode: "+dataClassDetailsMainCode);

		int dataClassTotalRecords = Integer.parseInt(xmlParserdataClassDetails.getValueOf("TotalRetrieved"));
		DormancyChangesLog.DormancyChangeLogger.debug("dataClassTotalRecords: "+dataClassTotalRecords);

		if(dataClassDetailsMainCode.equalsIgnoreCase("0")&& dataClassTotalRecords>0)
		{
			for(int j=0;j<dataClassTotalRecords;j++)
			{
				try
				{
					ArrayList<String> dataClassDetails = new ArrayList<String>();
					String xmlDataClassDetails=xmlParserdataClassDetails.getNextValueOf("Record");
					XMLParser xmlParserdataClassDetailsRecord = new XMLParser(xmlDataClassDetails);
					
					String dataClassName=xmlParserdataClassDetailsRecord.getValueOf("DATACLASS_NAME");
					DormancyChangesLog.DormancyChangeLogger.debug("DataClass Name: "+dataClassName);
					dataClassDetails.add(dataClassName);
					
					String indexFieldName=xmlParserdataClassDetailsRecord.getValueOf("INDEX_FIELDNAME");
					DormancyChangesLog.DormancyChangeLogger.debug("DataClass Name: "+indexFieldName);
					dataClassDetails.add(indexFieldName);
					
					DormancyChangesLog.DormancyChangeLogger.debug("iBPS info:");
					String iBPS_dataDefIndex=xmlParserdataClassDetailsRecord.getValueOf("iBPS_DATADEF_INDEX");
					DormancyChangesLog.DormancyChangeLogger.debug("Data Def Id: "+iBPS_dataDefIndex);
					dataClassDetails.add(iBPS_dataDefIndex);
					

					String iBPS_indexId=xmlParserdataClassDetailsRecord.getValueOf("iBPS_INDEX_ID");
					DormancyChangesLog.DormancyChangeLogger.debug("indexId details " +iBPS_indexId);
					dataClassDetails.add(iBPS_indexId);

					DormancyChangesLog.DormancyChangeLogger.debug("Omniflow info:");
					String oF_dataDefIndex=xmlParserdataClassDetailsRecord.getValueOf("OF_DATADEF_INDEX");
					DormancyChangesLog.DormancyChangeLogger.debug("Data Def Id: "+oF_dataDefIndex);
					dataClassDetails.add(oF_dataDefIndex);
					

					String oF_indexId=xmlParserdataClassDetailsRecord.getValueOf("OF_INDEX_ID");
					DormancyChangesLog.DormancyChangeLogger.debug("indexId details " +oF_indexId);
					dataClassDetails.add(oF_indexId);
					
					DormancyChangesLog.DormancyChangeLogger.debug("Status " +status);
					dataClassDetails.add(status);
					
					masterDataClass.add(dataClassDetails);
				}
				catch(Exception e)
				{
					DormancyChangesLog.DormancyChangeLogger.debug("Exception occured in Dormanacy DataClass Mapping Data fetching:"+e.getMessage());
				}
			}
		}
		else
		{
			DormancyChangesLog.DormancyChangeLogger.debug("Error in fetching DataClass Details Record"+dataClassDetailsMainCode);
			return null;
		}
		DormancyChangesLog.DormancyChangeLogger.debug("Master dataClass Record:"+masterDataClass);
		return masterDataClass;
	}
	/*protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort, int flag)
	{
		DormancyChangesLog.DormancyChangeLogger.debug("In WF NG Execute : " + serverPort);
		try 
		{
			if (serverPort.startsWith("33"))
				return WFCallBroker.execute(ipXML, jtsServerIP, Integer.parseInt(serverPort), 1);
			else
				return ngEjbClientDormancyChanges.makeCall(jtsServerIP, serverPort, "WebSphere", ipXML);
		}
		catch (Exception e)
		{
			DormancyChangesLog.DormancyChangeLogger.debug("Exception Occured in WF NG Execute : " + e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}*/
}