package com.newgen.ODDD.ODDocDownload;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;

import org.apache.commons.codec.binary.Base64;

import ISPack.CImageServer;
import ISPack.ISUtil.JPISException;
import Jdts.DataObject.JPDBString;

import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;

public class DownloadDoc 
{	
	

	public static boolean DownloadDocument(String winame, int rowSequence, String cabinetName, String sessionId, String JtsIp, String JtsPort, String tempVendor_Name,String tempDataClassName,String tempDataDefId,String tempFieldIndexId,String tempSearchValue,String tempSearchType,String tempOFDataDefId,String tempOFFieldIndexId,String tempiBPSStatus,String tempOFStatus, String callingEnv) throws IOException, Exception
	{
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Inside DownloadDocument Method...");
		//System.out.println("Inside DownloadDocument Method...");
		boolean status=true;
		String msg="Error";
		String base64String = null;
		
		String c_JTSIP ="";
		String c_SMSPort="";
		String c_Cabinet="";	
		String c_Site = "";
		String whereClause1 = "";
		
		//***************************************************************************
		
		//TODO
		//SELECT QUERY TO GET ALL THE PARAMETER DETAILS
		//ON THE BASIS OF RESULTS...RUN FOR LOOP WHICH WILL PARSE DOCUMENT ONE BY ONE AND DOWNLOAD THEM
		//AFTER FOR LOOP IF ALL THE DOCS DOWNLOAD SUCCESSFULLY AND UPDATE STATUS TO Y ...ELSE N
		
		
		String Query = "SELECT DATA_CLASS_NAME,SERVER,DOC_ISINDEX,DOC_NAME,DOC_FILEPATH,STATUS FROM USR_0_ODDD_DOC_DTLS with (nolock) WHERE WINAME='"+winame+"' AND ID='"+rowSequence+"' AND SERVER = '"+callingEnv+"' AND STATUS='N' ";
		String FinalInputXML = CommonMethods.apSelectWithColumnNames(Query, cabinetName, sessionId);
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("FinalInputXML :"+FinalInputXML);

		String FinalOutputXML = CommonMethods.WFNGExecute(FinalInputXML, JtsIp, JtsPort, 1);
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("FinalOutputXML :"+FinalOutputXML);

		XMLParser xmlParserAPSelect = new XMLParser(FinalOutputXML);
		String apSelectMaincode1 = xmlParserAPSelect.getValueOf("MainCode");
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apSelectMaincode :"+apSelectMaincode1);
		int result = Integer.parseInt(xmlParserAPSelect.getValueOf("TotalRetrieved"));
		if(apSelectMaincode1.equals("0") && result>0)
		{
			boolean flag=false;
			for(int k=0; k<result; k++)
			{
				String xmlDocDetails = xmlParserAPSelect.getNextValueOf("Record");
				XMLParser xmlParserChangeRecord = new XMLParser(xmlDocDetails);
				
				String nextDataClassName = xmlParserChangeRecord.getValueOf("DATA_CLASS_NAME");
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("nextDataClassName :"+nextDataClassName);
				
				String nextServer = xmlParserChangeRecord.getValueOf("SERVER");
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("nextServer :"+nextServer);
				
				String nextDocIsIndex = xmlParserChangeRecord.getValueOf("DOC_ISINDEX");
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("nextDocIsIndex :"+nextDocIsIndex);
				
				String StrimgIndex = xmlParserChangeRecord.getValueOf("DOC_ISINDEX").substring(0, xmlParserChangeRecord.getValueOf("DOC_ISINDEX").indexOf("#"));
				
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("DOC_ISINDEX substring :"+StrimgIndex);
			
				String StrVolId = xmlParserChangeRecord.getValueOf("DOC_ISINDEX").substring(xmlParserChangeRecord.getValueOf("DOC_ISINDEX").indexOf("#")+1);
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("VolId :"+StrVolId+" imgIndex :"+StrimgIndex);
				
				String nextDocName = xmlParserChangeRecord.getValueOf("DOC_NAME");
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("nextDocName :"+nextDocName);
				
				String nextFlePath = xmlParserChangeRecord.getValueOf("DOC_FILEPATH");
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("nextFlePath :"+nextFlePath);
				
				String nextStatus = xmlParserChangeRecord.getValueOf("STATUS");
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("nextStatus :"+nextStatus);
				
				if("iBPS".equalsIgnoreCase(callingEnv))
				{
					c_JTSIP = CommonConnection.getJTSIP();
					c_SMSPort = CommonConnection.getsSMSPort();
					c_Cabinet = CommonConnection.getCabinetName();
					c_Site = CommonConnection.getsSiteID();
					whereClause1 = "WINAME = '"+winame+"' AND ID = '"+rowSequence+"' AND DOC_ISINDEX='"+nextDocIsIndex+"' AND SERVER='iBPS' AND DATA_CLASS_NAME='"+nextDataClassName+"'";
				}
				else
				{
					c_JTSIP = CommonConnection.getOFJTSIP();
					c_SMSPort = CommonConnection.getOFJTSPort(); //Clarification
					c_Cabinet = CommonConnection.getOFCabinetName();
					c_Site = "1"; //Clarification
					whereClause1 = "WINAME = '"+winame+"' AND ID = '"+rowSequence+"' AND DOC_ISINDEX='"+nextDocIsIndex+"' AND SERVER='OmniFlow' AND DATA_CLASS_NAME='"+nextDataClassName+"'";
				}
				try
				{
					CImageServer cImageServer=null;
					try 
					{
						cImageServer = new CImageServer(null, c_JTSIP, Short.parseShort(c_SMSPort));
					}
					catch (JPISException e) 
					{
						e.printStackTrace();
						msg = e.getMessage();
						status=false;
					}
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("values passed -> "+ c_JTSIP+" "+c_SMSPort+" "+c_Cabinet+" "+StrVolId+" "+c_Site+" "+StrimgIndex+" "+nextFlePath.toString());
					
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("document name and imageindex for "+winame+" -- "+nextDocName+", "+StrimgIndex);
					
					//For iBPS &Omniflow - Common 
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Fetching OD Download Code ::::::");
					int odDownloadCode=cImageServer.JPISGetDocInFile_MT(null,c_JTSIP, Short.parseShort(c_SMSPort), c_Cabinet, Short.parseShort(c_Site),Short.parseShort(StrVolId), Integer.parseInt(StrimgIndex),"",nextFlePath.toString(), new JPDBString());
					
					/*
					//iBPS
					ODDD_DocDownloadLogger.debug("Fetching OD Download Code iBPS::::::");
					int odDownloadCode=cImageServer.JPISGetDocInFile_MT(null,CommonConnection.getJTSIP(), Short.parseShort(CommonConnection.getsSMSPort()), CommonConnection.getCabinetName(), Short.parseShort(CommonConnection.getsSiteID()),Short.parseShort(VolumeId), Integer.parseInt(imageIndex),"",FilePath.toString(), new JPDBString());
					
					//Omniflow
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Fetching OD Download Code OF::::::");
					int odDownloadCode=cImageServer.JPISGetDocInFile_MT(null,CommonConnection.getOFJTSIP(), Short.parseShort(CommonConnection.getOFJTSPort()), CommonConnection.getOFCabinetName(), Short.parseShort(CommonConnection.getsSiteID()),Short.parseShort(VolumeId), Integer.parseInt(imageIndex),"",FilePath.toString(), new JPDBString());
					*/
					
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("OD Download Code :"+odDownloadCode);
					if(odDownloadCode==1)
					{
						//status="T";
						
						//Update Status in ODDD_DOC_DTLS table
						String apUpdateInputXML = CommonMethods.apUpdateInput(cabinetName, sessionId,"USR_0_ODDD_DOC_DTLS", "STATUS", "'Y'", whereClause1);
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apUpdateInputXML: "+apUpdateInputXML);
						String apUpdateOutputXML = CommonMethods.WFNGExecute(apUpdateInputXML, JtsIp, JtsPort, 1);
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apUpdateOutputXML: "+apUpdateOutputXML);
						XMLParser xmlParserAPUpdate = new XMLParser(apUpdateOutputXML);
						String apUpdateMaincode = xmlParserAPUpdate.getValueOf("MainCode");
						if (apUpdateMaincode.equalsIgnoreCase("0")) 
						{
							ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Status updated as Y");
						}
						else
						{
							ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Status update failed");
						}
					}
					else
					{
						System.out.println("Some error occured while downloading the document with odDownloadCode : "+odDownloadCode);
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Error in downloading document for :"+ winame+" docname :"+nextDocName+", imageindex :"+StrimgIndex);
						
						msg="Error occured while downloading the document :"+nextDocName;
						status=false;
						
						//Update Status in ODDD_DOC_DTLS table
						/*String apUpdateInputXML = CommonMethods.apUpdateInput(cabinetName, sessionId,"USR_0_ODDD_DOC_DTLS", "STATUS", "'N'", whereClause1);
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apUpdateInputXML: "+apUpdateInputXML);
						String apUpdateOutputXML = CommonMethods.WFNGExecute(apUpdateInputXML, JtsIp, JtsPort, 1);
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apUpdateOutputXML: "+apUpdateOutputXML);
						XMLParser xmlParserAPUpdate = new XMLParser(apUpdateOutputXML);
						String apUpdateMaincode = xmlParserAPUpdate.getValueOf("MainCode");
						if (apUpdateMaincode.equalsIgnoreCase("0")) 
						{
							ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Status updated as N");
						}
						else
						{
							ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Status update failed");
						}*/
					}
				}
				catch (Exception e) 
				{
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Exsception occured in DownloadDocument method : "+e);
					System.out.println("Some exception occured while downloading the document.");
					
					final Writer result1 = new StringWriter();
					final PrintWriter printWriter = new PrintWriter(result1);
					e.printStackTrace(printWriter);
					msg=e.getMessage();
					status=false;
				}
				//return status;
			}
		}
		else 
		{
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(": Inside else : ");
		}
		return status;
	}

	public static String convertToBase64(String filePath)
    {
		String retValue="Test";
		
		/* if(true)
			return retValue; */
			
		try
		{
			File file = new File(filePath);
			 
			FileInputStream fis = new FileInputStream(file);
			//create FileInputStream which obtains input bytes from a file in a file system
			//FileInputStream is meant for reading streams of raw bytes such as image data. For reading streams of characters, consider using FileReader.
	 
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
				// LogGEN.writeTrace("export", "Total size in export modified: "+size);
				// m_objDBServer.WriteErrorLog("Total size in export modified: "+size);
				byte[] encodedBytes = Base64.encodeBase64(bos.toByteArray());  
				String sEncodedBytes=new String(encodedBytes);
				
				retValue=sEncodedBytes;
				//retValue="xyz";
				// out.println("GIF Binary Data in export: "+sEncodedBytes);
				// m_objDBServer.WriteErrorLog("GIF Binary Data: "+sEncodedBytes);
				// LogGEN.writeTrace("export", "GIF Binary Data: "+sEncodedBytes);
			}
			catch (IOException ex)
			{  
			   // System.out.println(ex);
			   //m_objDBServer.WriteErrorLog("Inside Catch: "+ex);
			   //LogGEN.writeTrace("export", "Inside Catch: "+ex);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return retValue;
    }
	
	//***************************************************************************
		
	public static String DownloadExcel(String winame, String imageIndex, String VolumeId, String docName,StringBuffer FilePath)
	{
		String status="F";
		String msg="Error";
		try
		{
			String base64String = null;
			CImageServer cImageServer=null;
			try 
			{
				cImageServer = new CImageServer(null, CommonConnection.getJTSIP(), Short.parseShort(CommonConnection.getsSMSPort()));
			}
			 catch (JPISException e) 
			{
				e.printStackTrace();
				msg = e.getMessage();
				status="F";
			}
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("values passed -> "+ CommonConnection.getJTSIP()+" "+CommonConnection.getsSMSPort()+" "+CommonConnection.getCabinetName()+" "+VolumeId+" "+CommonConnection.getsSiteID()+" "+imageIndex+" "+FilePath.toString());
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("document name and imageindex for "+winame+" "+docName+","+imageIndex);
			
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Fetching OD Download Code iBPS::::::");
			
			int odDownloadCode=cImageServer.JPISGetDocInFile_MT(null,CommonConnection.getJTSIP(),Short.parseShort(CommonConnection.getsSMSPort()), CommonConnection.getCabinetName(),Short.parseShort(CommonConnection.getsSiteID()),Short.parseShort(VolumeId), Integer.parseInt(imageIndex),"",FilePath.toString(), new JPDBString());
			
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("OD Download Code :"+odDownloadCode);
			
			if(odDownloadCode==1)
			{
					status="T";
			}
			else
			{
				System.out.println("Some error occured while downloading the document with odDownloadCode : "+odDownloadCode);
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Error in downloading document for "+ winame+" docname "+docName+", imageindex "+imageIndex);
				
				msg="Error occured while downloading the document :"+docName;
				status="F";
			}
		}
		catch (Exception e) 
		{
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Exsception occured in DownloadDocument method : "+e);
			System.out.println("Some exception occured while downloading the document.");
			
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			msg=e.getMessage();
			status="F";
		}
		return status;
	}
}
