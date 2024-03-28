package com.newgen.DormancyChanges;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;

public class SocketServices {
	private static NGEjbClient ngEjbClientDormancyChanges;
	static String SearchNGOFolder(String cabinetName,String sessionId,String dataDefId,String indexId,String indexValue,
			String JtsIp,String JtsPort,String status,String s_cabinet,String s_session,String s_jtsIP,String s_jtsPort,String tableName, String iBPS_or_OF, Map<String, String> DormancyChangesConfigParamMap) {
		boolean isFailed = false;
		try
		{
			/*Search for the DataClass*/
			ngEjbClientDormancyChanges = NGEjbClient.getSharedInstance();
			String NGOFolderInputXML = CommonMethods.apNGOSearchFolder(s_cabinet,s_session,dataDefId, indexId, indexValue);
			DormancyChangesLog.DormancyChangeLogger.debug("Input XML created successfully:" + NGOFolderInputXML);
			
			String NGOFolderOutputXML = CommonMethods.WFNGExecute(NGOFolderInputXML, s_jtsIP,s_jtsPort, 1);
			DormancyChangesLog.DormancyChangeLogger.debug("Output XML created successfully:" +NGOFolderOutputXML);
			
			XMLParser xmlParserNGOFolderList = new XMLParser(NGOFolderOutputXML);
			String xmlOutputStatus= xmlParserNGOFolderList.getValueOf("Status");
			int folderListCount = 0;
			try {
				folderListCount=Integer.parseInt(xmlParserNGOFolderList.getValueOf("noOfRecordsFetched"));	
			}
			catch(Exception e){
				String errorMsg=xmlParserNGOFolderList.getValueOf("Error");
				if(errorMsg.equalsIgnoreCase("No data found."))
					folderListCount=0;
				else
				{
					DormancyChangesLog.DormancyChangeLogger.debug("Error Msg:" +folderListCount);	
					return "Failed";
				}		
			}
			DormancyChangesLog.DormancyChangeLogger.debug("Record fetch successfully:" +folderListCount);
			if (xmlOutputStatus.equalsIgnoreCase("0")) 
			{				
				if(folderListCount>0)
				{
					String columnNames=" INSERTIONDATETIME,SEARCH_FIELD,SEARCH_FIELD_TYPE,PREV_DATACLASS_NAME,PREV_DATA_DEF_ID,PREV_FOLDER_PATH,"
							+ "PREV_FOLDER_INDEX,PREV_PARENTFOLDER_INDEX,PREV_FOLDER_NAME,PREV_INDEX_ID,iBPS_OR_OF,IS_ACT_TO_DORM_DONE,DELETE_STATUS";
					String res="FAIL";
					//String iBPS_or_OF=(s_cabinet.equalsIgnoreCase("rak_bpm"))?"iBPS":"OF";
					for(int i=0;i<folderListCount;i++)
					{
						try
						{
							String ParserNGOFolderList=xmlParserNGOFolderList.getNextValueOf("Folder");
							XMLParser xmlParserNGOFolder=  new XMLParser(ParserNGOFolderList);
							String folderIndex=xmlParserNGOFolder.getValueOf("FolderIndex");
							String prevDataClass=xmlParserNGOFolder.getValueOf("DataDefName");
							String prevFolderPath=xmlParserNGOFolder.getValueOf("FolderPath");
							String prevParentFolderIndex=xmlParserNGOFolder.getValueOf("ParentFolderIndex");
							String prevParentFolderName=xmlParserNGOFolder.getValueOf("FolderName");
							 
							DormancyChangesLog.DormancyChangeLogger.debug("Folder Index fetch successfully:" +folderIndex);
							if(status.equalsIgnoreCase("A"))
							{
								String columnValues ="getdate(),'"+indexValue+"','CIF','"+prevDataClass+"','"+dataDefId+"','"+prevFolderPath+"','"+folderIndex+"',"
										+ "'"+prevParentFolderIndex+"','"+prevParentFolderName+"','"+indexId+"','"+iBPS_or_OF+"','N','N'";
								DormancyChangesLog.DormancyChangeLogger.debug("value for columns are :"+columnValues);
								
								/*Inserting the previous DataClass in the Database */
								
								res=InsertIntoDB.insertIntoDataBase(cabinetName, sessionId, JtsIp, JtsPort ,columnNames, columnValues,
										"USR_0_Dorm_ActiveToDormantDataDetails");
								if(res.equalsIgnoreCase("FAIL"))
								{
									DormancyChangesLog.DormancyChangeLogger.debug("Insertion in DB Failed:"+res);
									return "Error";
								}
								else
								{
									String getFolderPropertyXML=CommonMethods.apNGOGetFolderProperty(s_cabinet,s_session,folderIndex);
									DormancyChangesLog.DormancyChangeLogger.debug("Input XML created successfully:" + getFolderPropertyXML);
									String getFolderPropertyOutputXML = CommonMethods.WFNGExecute(getFolderPropertyXML, s_jtsIP,s_jtsPort, 1);
									DormancyChangesLog.DormancyChangeLogger.debug("Output XML created successfully:" +getFolderPropertyOutputXML);
									XMLParser xmlParserNGOFolderGet = new XMLParser(getFolderPropertyOutputXML);
									String xmlFolderGetStatus= xmlParserNGOFolderGet.getValueOf("Status");
									if(xmlFolderGetStatus.equalsIgnoreCase("0"))
									{
										String get_columnName="INSERTIONDATETIME,FOLDER_INDEX,CAB_TYPE,INDEX_ID,INDEX_VALUE,DELETE_STATUS";
										int count = xmlParserNGOFolderGet.getNoOfFields("Field");
										DormancyChangesLog.DormancyChangeLogger.debug("No of field:" +count);
										for(int field_count=0;field_count<count;field_count++)
										{
											String xmlGetDetails=xmlParserNGOFolderGet.getNextValueOf("Field");
											XMLParser xmlParserGetRecord = new XMLParser(xmlGetDetails);
											DormancyChangesLog.DormancyChangeLogger.debug("fields:" +folderIndex+s_cabinet+xmlParserGetRecord.getValueOf("IndexId"));
											if(!"".equalsIgnoreCase(xmlParserGetRecord.getValueOf("IndexValue").trim()) && !"null".equalsIgnoreCase(xmlParserGetRecord.getValueOf("IndexValue").trim()))
											{
												String get_columnValues="getdate(),'"+folderIndex+"','"+s_cabinet+"','"+xmlParserGetRecord.getValueOf("IndexId")+"','"+xmlParserGetRecord.getValueOf("IndexValue")+"',"
														+ "'N'";
												String get_res=InsertIntoDB.insertIntoDataBase(cabinetName,sessionId,JtsIp, JtsPort,get_columnName,get_columnValues,"USR_0_Dorm_BKP_DataClass");
												if(get_res.equalsIgnoreCase("FAIL"))
												{
													DormancyChangesLog.DormancyChangeLogger.debug("Insertion in DB Failed:"+get_res);
													return "Failed";
												}
											}
										}
									}
									/***Associating with DataClass***/
									String dataClassQuery="SELECT iBPS_DATADEF_INDEX,iBPS_INDEX_ID,OF_INDEX_ID,OF_DATADEF_INDEX FROM USR_0_Dorm_DataClassMapping WHERE STATUS='D'";
									String dataClassInputXML =CommonMethods.apSelectWithColumnNames(dataClassQuery, cabinetName, sessionId);
									DormancyChangesLog.DormancyChangeLogger.debug("Details APSelect InputXML: "+dataClassInputXML);
		
									String dataClassOutputXML=CommonMethods.WFNGExecute(dataClassInputXML,JtsIp,JtsPort,1);
									DormancyChangesLog.DormancyChangeLogger.debug("Details APSelect OutputXML: "+dataClassOutputXML);
		
									XMLParser xmlParserDataClass= new XMLParser(dataClassOutputXML);
									String dataClassMainCode = xmlParserDataClass.getValueOf("MainCode");
									DormancyChangesLog.DormancyChangeLogger.debug("MainCode: "+dataClassMainCode);
		
									int dataClassRecords = Integer.parseInt(xmlParserDataClass.getValueOf("TotalRetrieved"));
									DormancyChangesLog.DormancyChangeLogger.debug("Records: "+dataClassRecords);
		
									if(dataClassMainCode.equalsIgnoreCase("0")&& dataClassRecords>0)
									{
										for(int k=0;k<dataClassRecords;k++)
										{
											String dataClassDetails=xmlParserDataClass.getNextValueOf("Record");
											XMLParser xmlParserChangeRecord = new XMLParser(dataClassDetails);
											String iBPSdefIndexID=xmlParserChangeRecord.getValueOf("iBPS_DATADEF_INDEX");
											String iBPSIndexID=xmlParserChangeRecord.getValueOf("iBPS_INDEX_ID");
											String oFdefIndexID=xmlParserChangeRecord.getValueOf("OF_DATADEF_INDEX");
											String oFindexID=xmlParserChangeRecord.getValueOf("OF_INDEX_ID");
											String changeFolderPropertyXML="";
											if(iBPS_or_OF.equalsIgnoreCase("OF"))
											{
												List<String> indexIdList = new ArrayList<>();
												List<String> indexValueList = new ArrayList<>();
												indexIdList.add(oFindexID);
												indexValueList.add(indexValue);
												changeFolderPropertyXML=CommonMethods.apNGOChangeFolderProperty(s_cabinet,s_session,folderIndex,oFdefIndexID,indexIdList,
														indexValueList);
											}
											else
											{
												List<String> indexIdList = new ArrayList<>();
												List<String> indexValueList = new ArrayList<>();
												indexIdList.add(iBPSIndexID);
												indexValueList.add(indexValue);
												changeFolderPropertyXML=CommonMethods.apNGOChangeFolderProperty(s_cabinet,s_session,folderIndex,iBPSdefIndexID,indexIdList,
														indexValueList);
											}
											DormancyChangesLog.DormancyChangeLogger.debug("Input XML created successfully:" + changeFolderPropertyXML);
											String changeFolderPropertyOutputXML = CommonMethods.WFNGExecute(changeFolderPropertyXML, s_jtsIP,s_jtsPort, 1);
											DormancyChangesLog.DormancyChangeLogger.debug("Output XML created successfully:" +changeFolderPropertyOutputXML);
											XMLParser xmlParserNGOFolderChange = new XMLParser(changeFolderPropertyOutputXML);
											String xmlFolderChangeStatus= xmlParserNGOFolderChange.getValueOf("Status");
											if(xmlFolderChangeStatus.equalsIgnoreCase("0"))
											{
												DormancyChangesLog.DormancyChangeLogger.debug("apNGOChange success"+xmlFolderChangeStatus);
												/* Status Updating in the table*/
												
												String updateTableInputXML=CommonMethods.apUpdateInput(cabinetName,sessionId,"USR_0_Dorm_ActiveToDormantDataDetails",
														"IS_ACT_TO_DORM_DONE","'Y'","IS_ACT_TO_DORM_DONE='N' AND DELETE_STATUS='N' AND "
														+ "PREV_FOLDER_INDEX='"+folderIndex+"' AND iBPS_OR_OF='"+iBPS_or_OF+"' AND PREV_DATACLASS_NAME='"+prevDataClass+"'");
												DormancyChangesLog.DormancyChangeLogger.debug("Input XML created successfully:" + updateTableInputXML);
												String updateTableOutputXML = CommonMethods.WFNGExecute(updateTableInputXML, JtsIp, JtsPort, 1);
												DormancyChangesLog.DormancyChangeLogger.debug("Output XML created successfully:" +updateTableOutputXML);
												XMLParser xmlParserUpdateTable = new XMLParser(updateTableOutputXML);
												String UpdateStatus= xmlParserUpdateTable.getValueOf("MainCode");
												if(UpdateStatus.equalsIgnoreCase("0"))
												{
													DormancyChangesLog.DormancyChangeLogger.debug("Status Updated:" + UpdateStatus);
												}
												else
												{
													DormancyChangesLog.DormancyChangeLogger.debug("Status Update failed:" + UpdateStatus);
												}
											  }
											  else
											  {
												  	//ERROR DETAILS TABLE
												  	String ColumnValue3="'"+tableName+"','"+folderIndex+"','"+indexValue+"','"+iBPS_or_OF+"',getdate(),'Not able to Change the DataClass'";
												  	String errorRes3=InsertIntoDB.ErrorDetailsInsertion(cabinetName, sessionId, JtsIp, JtsPort,ColumnValue3);
													if(errorRes3.equalsIgnoreCase("Pass"))
													{
														DormancyChangesLog.DormancyChangeLogger.info("error table updated");
													}
													else
													{
														DormancyChangesLog.DormancyChangeLogger.info("failed to update error table");
													}
													// mail trigger
													String mailColumnValue3="'"+DormancyChangesConfigParamMap.get("FromMailId")+"','"+DormancyChangesConfigParamMap.get("ToMailId")+"','Dormancy Chnage Utility has failed',"
															+ "'Dear Team: We are facing issue as data class not changeable for folder index: "+folderIndex+" and CIFID: "+indexValue+"','text/html;charset=UTF-8','1','N','CUSTOM','TRIGGER',getdate(),'5'";
													String mailerrorRes3=InsertIntoDB.mailQueueInsertion(cabinetName, sessionId, JtsIp, JtsPort,mailColumnValue3);
													if(mailerrorRes3.equalsIgnoreCase("Pass"))
													{
														DormancyChangesLog.DormancyChangeLogger.info("Mail Inserted in the table");
													}
													else
													{
														DormancyChangesLog.DormancyChangeLogger.info("failed to update mail queue table");
													}
													DormancyChangesLog.DormancyChangeLogger.debug("apNGOChange failed"+xmlFolderChangeStatus);
													isFailed = true;
											  	}
											}
											
										}		
									}
								}
							else if(status.equalsIgnoreCase("D"))
							{
								/***Associating with DataClass***/
								List<String> changePropIndexIdList = new ArrayList<>();
								List <String> indexValueList = new ArrayList<>();
								String propertyChangeQuery ="SELECT PREV_DATA_DEF_ID,PREV_INDEX_ID FROM USR_0_Dorm_ActiveToDormantDataDetails "
										+ "with (nolock) WHERE SEARCH_FIELD='"+indexValue+"' AND PREV_FOLDER_INDEX='"+folderIndex+"'AND "
												+ "DELETE_STATUS='N' AND iBPS_OR_OF='"+iBPS_or_OF+"'";
				
								String propertyChangeInputXML =CommonMethods.apSelectWithColumnNames(propertyChangeQuery, cabinetName, sessionId);
								DormancyChangesLog.DormancyChangeLogger.debug("Details APSelect InputXML: "+propertyChangeInputXML);
	
								String propertyChangeOutputXML=CommonMethods.WFNGExecute(propertyChangeInputXML,JtsIp,JtsPort,1);
								DormancyChangesLog.DormancyChangeLogger.debug("Details APSelect OutputXML: "+propertyChangeOutputXML);
	
								XMLParser xmlParserPropertyChange= new XMLParser(propertyChangeOutputXML);
								String propertyChangeMainCode = xmlParserPropertyChange.getValueOf("MainCode");
								DormancyChangesLog.DormancyChangeLogger.debug("MainCode: "+propertyChangeMainCode);
	
								int propertyChangeRecords = Integer.parseInt(xmlParserPropertyChange.getValueOf("TotalRetrieved"));
								DormancyChangesLog.DormancyChangeLogger.debug("Records: "+propertyChangeRecords);
	
								if(propertyChangeMainCode.equalsIgnoreCase("0")&& propertyChangeRecords>0)
								{
									for(int k=0;k<propertyChangeRecords;k++)
									{
										
										String xmlChangeDetails=xmlParserPropertyChange.getNextValueOf("Record");
										XMLParser xmlParserChangeRecord = new XMLParser(xmlChangeDetails);
										String changePropDefID=xmlParserChangeRecord.getValueOf("PREV_DATA_DEF_ID");
										DormancyChangesLog.DormancyChangeLogger.debug("CIF: "+changePropDefID);
										String changePropIndexId=xmlParserChangeRecord.getValueOf("PREV_INDEX_ID");
										DormancyChangesLog.DormancyChangeLogger.debug("CIF: "+changePropIndexId);
										//TODO other fields data
										String bkp_tableQuery="SELECT INDEX_ID,INDEX_VALUE FROM USR_0_Dorm_BKP_DataClass WHERE FOLDER_INDEX='"+folderIndex+"'"
												+ " AND CAB_TYPE='"+s_cabinet+"' AND DELETE_STATUS='N'";
										String bkp_tableInputXML =CommonMethods.apSelectWithColumnNames(bkp_tableQuery, cabinetName, sessionId);
										DormancyChangesLog.DormancyChangeLogger.debug("bkp_tableQuery details APSelect InputXML: "+bkp_tableInputXML);
	
										String bkp_tableOutputXML=CommonMethods.WFNGExecute(bkp_tableInputXML,JtsIp,JtsPort,1);
										DormancyChangesLog.DormancyChangeLogger.debug("bkp_tableQuery Details APSelect OutputXML: "+bkp_tableOutputXML);
	
										XMLParser xmlParserbkp_table= new XMLParser(bkp_tableOutputXML);
										String bkp_tableStatus = xmlParserbkp_table.getValueOf("MainCode");
										DormancyChangesLog.DormancyChangeLogger.debug("MainCode: "+bkp_tableStatus);
	
										int bkp_tableRecords = Integer.parseInt(xmlParserbkp_table.getValueOf("TotalRetrieved"));
										if(bkp_tableStatus.equalsIgnoreCase("0") && bkp_tableRecords>0)
										{
											for(int bkp_count=0;bkp_count<bkp_tableRecords;bkp_count++)
											{
												String xmlBKPdetails=xmlParserbkp_table.getNextValueOf("Record");
												XMLParser xmlParserbkp_tableRecord = new XMLParser(xmlBKPdetails);
												String bkpIndexID=xmlParserbkp_tableRecord.getValueOf("INDEX_ID");
												DormancyChangesLog.DormancyChangeLogger.debug("index id: "+bkpIndexID);
												changePropIndexIdList.add(bkpIndexID);
												String bkpIndexValue=xmlParserbkp_tableRecord.getValueOf("INDEX_VALUE");
												DormancyChangesLog.DormancyChangeLogger.debug("index value: "+bkpIndexValue);
												indexValueList.add(bkpIndexValue);
											}
										}
										DormancyChangesLog.DormancyChangeLogger.debug("Fetching data class Details.");
										String changeFolderPropertyXML=CommonMethods.apNGOChangeFolderProperty(s_cabinet,s_session,folderIndex,
												changePropDefID,changePropIndexIdList,indexValueList);
										DormancyChangesLog.DormancyChangeLogger.debug("Input XML created successfully:" + changeFolderPropertyXML);
										String changeFolderPropertyOutputXML = CommonMethods.WFNGExecute(changeFolderPropertyXML, s_jtsIP,s_jtsPort, 1);
										DormancyChangesLog.DormancyChangeLogger.debug("Output XML created successfully:" +changeFolderPropertyOutputXML);
										XMLParser xmlParserNGOFolderChange = new XMLParser(changeFolderPropertyOutputXML);
										String xmlFolderChangeStatus= xmlParserNGOFolderChange.getValueOf("Status");
										if(xmlFolderChangeStatus.equalsIgnoreCase("0"))
										{
											DormancyChangesLog.DormancyChangeLogger.debug("apNGOChange success"+xmlFolderChangeStatus);
											/* Status Updating in the table*/
											String updateBkpTableInputXML=CommonMethods.apUpdateInput(cabinetName,sessionId,"USR_0_Dorm_BKP_DataClass",
													"DELETE_STATUS","'Y'","FOLDER_INDEX='"+folderIndex+"'AND CAB_TYPE='"+s_cabinet+"'");
											DormancyChangesLog.DormancyChangeLogger.debug("Input XML created successfully:" + updateBkpTableInputXML);
											String updateBkpTableOutputXML = CommonMethods.WFNGExecute(updateBkpTableInputXML, JtsIp, JtsPort, 1);
											DormancyChangesLog.DormancyChangeLogger.debug("Output XML created successfully:" +updateBkpTableOutputXML);
											XMLParser xmlParserBkpUpdateTable = new XMLParser(updateBkpTableOutputXML);
											String bkpUpdateStatus= xmlParserBkpUpdateTable.getValueOf("MainCode");
											if(bkpUpdateStatus.equalsIgnoreCase("0"))
											{
												DormancyChangesLog.DormancyChangeLogger.debug("Status Updated:" + bkpUpdateStatus);
											}
											else
											{
												DormancyChangesLog.DormancyChangeLogger.debug("Status Update failed:" + bkpUpdateStatus);
											}
											String updateTableInputXML=CommonMethods.apUpdateInput(cabinetName,sessionId,"USR_0_Dorm_ActiveToDormantDataDetails",
													"DELETE_STATUS","'Y'","IS_ACT_TO_DORM_DONE='Y' AND DELETE_STATUS='N' AND "
													+ "PREV_FOLDER_INDEX='"+folderIndex+"' AND iBPS_OR_OF='"+iBPS_or_OF+"'");
											DormancyChangesLog.DormancyChangeLogger.debug("Input XML created successfully:" + updateTableInputXML);
											String updateTableOutputXML = CommonMethods.WFNGExecute(updateTableInputXML, JtsIp, JtsPort, 1);
											DormancyChangesLog.DormancyChangeLogger.debug("Output XML created successfully:" +updateTableOutputXML);
											XMLParser xmlParserUpdateTable = new XMLParser(updateTableOutputXML);
											String UpdateStatus3= xmlParserUpdateTable.getValueOf("MainCode");
											if(UpdateStatus3.equalsIgnoreCase("0"))
											{
												DormancyChangesLog.DormancyChangeLogger.debug("Status Updated:" + UpdateStatus3);
											}
											else
											{
												DormancyChangesLog.DormancyChangeLogger.debug("Status Update failed:" + UpdateStatus3);
											}
										}
										else
										{
											//ERROR DETAILS TABLE
											String columnValues4="'"+tableName+"','"+folderIndex+"','"+indexValue+"','"+iBPS_or_OF+"',getdate(),'Not able to Change the DataClass'";
											String errorRes4=InsertIntoDB.ErrorDetailsInsertion(cabinetName, sessionId, JtsIp, JtsPort,columnValues4);
											if(errorRes4.equalsIgnoreCase("Pass"))
											{
												DormancyChangesLog.DormancyChangeLogger.info("error table updated");
											}
											else
											{
												DormancyChangesLog.DormancyChangeLogger.info("failed to update error table");
											}
											// mail trigger
											String mailColumnValue4="'"+DormancyChangesConfigParamMap.get("FromMailId")+"','"+DormancyChangesConfigParamMap.get("ToMailId")+"','Dormancy Chnage Utility has failed',"
													+ "'Dear Team: We are facing issue as data class not changeable for folder index: "+folderIndex+" and CIFID: "+indexValue+"','text/html;charset=UTF-8','1','N','CUSTOM','TRIGGER',getdate(),'5'";
											String mailerrorRes4=InsertIntoDB.mailQueueInsertion(cabinetName, sessionId, JtsIp, JtsPort,mailColumnValue4);
											if(mailerrorRes4.equalsIgnoreCase("Pass"))
											{
												DormancyChangesLog.DormancyChangeLogger.info("Mail Inserted in the table");
											}
											else
											{
												DormancyChangesLog.DormancyChangeLogger.info("failed to update mail queue table");
											}
											DormancyChangesLog.DormancyChangeLogger.debug("apNGOChange failed"+xmlFolderChangeStatus);
											isFailed = true;
										}
									}
								}
						   }
						}
				catch(Exception e)
				{
					DormancyChangesLog.DormancyChangeLogger.error("Exception Occurred in Dormancy Changes: "+e.getMessage());
					e.printStackTrace();
				}
			}
		}
			else 
			{
				DormancyChangesLog.DormancyChangeLogger.error("No folder Found"+xmlOutputStatus);
				return "Success";
			}
				
		}
		else 
		{
			DormancyChangesLog.DormancyChangeLogger.error("apNGOSearchFolder failed"+xmlOutputStatus);
			System.out.println(NGOFolderInputXML);
			return "Failed";
		}
		if (isFailed)
			return "E";//Success
		else
			return "Success";//Success
		}
		catch(Exception e)
		{
			DormancyChangesLog.DormancyChangeLogger.error("Exception Occurred in Dormancy Changes: "+e.getMessage());
			e.printStackTrace();
			return "Failed";
		}
	}

	protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,int flag)
	{
		DormancyChangesLog.DormancyChangeLogger.debug("In WF NG Execute : " + serverPort);
		try
		{
			if (serverPort.startsWith("33"))
				return WFCallBroker.execute(ipXML, jtsServerIP,Integer.parseInt(serverPort), 1);
			else
				return ngEjbClientDormancyChanges.makeCall(jtsServerIP, serverPort,"WebSphere", ipXML);
		}
		catch (Exception e)
		{
			DormancyChangesLog.DormancyChangeLogger.debug("Exception Occured in WF NG Execute : "+ e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}
}
