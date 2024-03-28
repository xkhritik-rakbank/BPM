package com.newgen.iforms.user;
import com.newgen.iforms.*;
import com.newgen.iforms.custom.IFormReference;
import com.newgen.mvcbeans.model.wfobjects.WDGeneralData;
import java.awt.print.Printable;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.Socket;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.Properties;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.File;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.parsers.ParserConfigurationException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.CharacterData;

	
	public class PCIntegration extends PCCommon 
	{
		//private Map executeXMLMapMain=new HashMap();
		LinkedHashMap<String,String> executeXMLMapMain = new LinkedHashMap<String,String>();

	public String onclickevent(IFormReference iformObj,String control,String StringData)
	{
		String MQ_response="";
		String MQ_response_Entity ="";
		String MQ_response_Account="";
		String CIFID="";
		String CustomerName="";
		String CIFType="";
		String AccountNumber ="";
		String strAccountCategory="";
		String strAccountType="";
		String strProductID="";
		String strAccountName="";
		String AccountStatus="";
		String strIsIslamic="";
		String AcctType="";
		String ARMCode="";
		String RakElite="";
		String EmiratesID="";
		String EmiratesIDExpiryDate="";
		String TradeLicense="";
		String TLExpiryDate="";
		String CifId ="";
		String Customer_Name="";
		String strIsAECBConsent="";
		String Sub_Segment = "";
		String Primaryemail = "";
		String CifType = "";
		String selectedcif="";
		String IsRetailCus="";
		String Return_Code_Sig="";
		int returnedSignatures = 0;
		String ReturnCode1="";
		String ReturnCode2="";
		String ReturnCode3="";
		String ReturnCode4="";
		String Error_Cif = "Error";
		String MainCifId="";
		String MainCustomerName="";
		String MainCifType="";
		String IsRetail="";
		String ReturnDesc = "";
		
		Map RecordFileMap;
		
			try
			{
			PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside onclickevent function");
			
			
			 if(control.equals("btn_CIF_Search"))
			{
				PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", inside onclick function for entity detail call");
				MQ_response = MQ_connection_response(iformObj,control,StringData);
				
				MQ_response=MQ_response.substring(MQ_response.indexOf("<?xml v"),MQ_response.indexOf("</MQ_RESPONSE_XML>"));
				//PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside btn_CIF_Search function "+MQ_response);	
				if(MQ_response.indexOf("<ReturnCode>")!=-1)
				{
					ReturnCode1 = MQ_response.substring(MQ_response.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,MQ_response.indexOf("</ReturnCode>"));
					
				}
				if(MQ_response.indexOf("<ReturnDesc>")!=-1)
				{
					ReturnDesc = MQ_response.substring(MQ_response.indexOf("<ReturnDesc>")+"</ReturnDesc>".length()-1,MQ_response.indexOf("</ReturnDesc>"));
					
				}
				PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Return  code for the entity detail call"+ReturnCode1);
				
				if(ReturnCode1.equals("0000"))
				{
				 
					if(MQ_response.contains("<CIFID>"))
					{
						MainCifId = MQ_response.substring(MQ_response.indexOf("<CIFID>")+"</CIFID>".length()-1,MQ_response.indexOf("</CIFID>"));
					}
					
					if(MQ_response.contains("<FullName>"))
					{
						MainCustomerName = MQ_response.substring(MQ_response.indexOf("<FullName>")+"</FullName>".length()-1,MQ_response.indexOf("</FullName>"));
						
					}
					
					if(MQ_response.contains("<IsRetailCust>"))
					{
						String IsMainRetailCust = MQ_response.substring(MQ_response.indexOf("<IsRetailCust>")+"</IsRetailCust>".length()-1,MQ_response.indexOf("</IsRetailCust>"));
						if(IsMainRetailCust.equalsIgnoreCase("N"))
							MainCifType	="Non-Individual";
						else
							MainCifType	="Individual";
					}
					
					JSONArray jsonArray1=new JSONArray();
					JSONObject obj1=new JSONObject();
					obj1.put("CIF Number", MainCifId);
					obj1.put("Name", MainCustomerName);
					obj1.put("CIF Type", MainCifType);
					jsonArray1.add(obj1);
					//PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", @@@@@@@@@@ for entity detail call 2:::"+jsonArray1.toJSONString());
					iformObj.addDataToGrid("Q_USR_0_PC_CIF_DETAILS", jsonArray1);
					
					PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Clicked search button");
					if (MQ_response.contains("<RelatedCIF>"))
					{
						Document recordDoc=MapXML.getDocument(MQ_response);
						NodeList records= MapXML.getNodeListFromDocument(recordDoc, "RelatedCIF");
						PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Total Lines returned : "+records.getLength());
						if((records.getLength()==0))
						{
							PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", No Records for entity detail call...");
							return Error_Cif;
							//continue;
						}
						if(records.getLength() > 0)
						{
							PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", many records for entity detail call..");
							//RecordFileMap=MapXML.getKeyValueMapFromNode(records.item(0),CoverColumnsName.split(","));
							
							for(int rec=0;rec<records.getLength();rec++)
							{
								JSONArray jsonArray=new JSONArray();
								 CIFID =MapXML.getTagValueFromNode(records.item(rec),"CIFID");
								 CustomerName=MapXML.getTagValueFromNode(records.item(rec),"CustomerName");
								
								 IsRetailCus = MapXML.getTagValueFromNode(records.item(rec),"IsRetailCust");
								if(IsRetailCus.equals("N")){
									CIFType="Non-Individual";
								}
								else
									CIFType="Individual";
								JSONObject obj=new JSONObject();
								obj.put("CIF Number", CIFID);
								obj.put("Name", CustomerName);
								obj.put("CIF Type", CIFType);
								jsonArray.add(obj);
								
								//PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", @@@@@@@@@@ for entity detail call:::"+jsonArray.toJSONString());
								iformObj.addDataToGrid("Q_USR_0_PC_CIF_DETAILS", jsonArray);
							}
							
							PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", @@@@@@@@@@ : after add 1");
						}
					}
					setControlValue("MAIN_CIF_SEARCH","Y");
				
				}
				
				else
					setControlValue("MAIN_CIF_SEARCH","N");
				
				
				return ReturnCode1+"~"+ReturnDesc;	
			
			}
			 
			 else if(control.equals("tblCIF"))
				{
					PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", inside onclick function for account summary call");
					
					//Entity Detail call for the cif selected from the grid
					MQ_response_Entity = MQ_connection_response(iformObj,"btn_CIF_Search2",StringData);
					MQ_response_Entity=MQ_response_Entity.substring(MQ_response_Entity.indexOf("<?xml v"),MQ_response_Entity.indexOf("</MQ_RESPONSE_XML>"));
					
					if(MQ_response_Entity.indexOf("<ReturnCode>")!=-1)
					{
						ReturnCode2 = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,MQ_response_Entity.indexOf("</ReturnCode>"));
						
					}
					
					if(ReturnCode2.equals("0000"))
					{
					
						if(MQ_response_Entity.contains("<ARMCode>"))
						{
							ARMCode = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<ARMCode>")+"</ARMCode>".length()-1,MQ_response_Entity.indexOf("</ARMCode>"));
							setControlValue("ARM_CODE", ARMCode); 
						}
						
						if(MQ_response_Entity.contains("<IsPremium>"))
						{
							RakElite = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<IsPremium>")+"</IsPremium>".length()-1,MQ_response_Entity.indexOf("</IsPremium>"));
							setControlValue("RAK_ELITE", RakElite); 
						}
						if(MQ_response_Entity.contains("<CustomerSubSeg>"))
						{
							Sub_Segment = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<CustomerSubSeg>")+"</CustomerSubSeg>".length()-1,MQ_response_Entity.indexOf("</CustomerSubSeg>"));
							setControlValue("SUB_SEGMENT", Sub_Segment); 
						}
						if(MQ_response_Entity.contains("<CIFID>"))
						{
							CifId = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<CIFID>")+"</CIFID>".length()-1,MQ_response_Entity.indexOf("</CIFID>"));
							setControlValue("CIF_ID", CifId); 
							PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Main cif id is--"+CifId);
						}
						
						//Setting color coding as 1 in case of Ruling Family
						if(MQ_response_Entity.contains("<CustomerType>"))
						{
							String custType = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<CustomerType>")+"</CustomerType>".length()-1,MQ_response_Entity.indexOf("</CustomerType>"));
							if (custType.trim().equalsIgnoreCase("EK"))
							{
								setControlValue("qColorCoding", "1"); 
							}
							else
								setControlValue("qColorCoding", "0"); 
						}
						// End----
						
						if(MQ_response_Entity.contains("<FullName>"))
						{
							Customer_Name = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<FullName>")+"</FullName>".length()-1,MQ_response_Entity.indexOf("</FullName>"));
							setControlValue("CUSTOMER_NAME", Customer_Name);
						}
						if(MQ_response_Entity.contains("<AECBConsentHeld>"))
						{
							strIsAECBConsent = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<AECBConsentHeld>")+"</AECBConsentHeld>".length()-1,MQ_response_Entity.indexOf("</AECBConsentHeld>"));
							setControlValue("IS_AECB_CONSENT_HELD", strIsAECBConsent);
						}
						if(MQ_response_Entity.contains("<IsRetailCust>"))
						{
							IsRetail = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<IsRetailCust>")+"</IsRetailCust>".length()-1,MQ_response_Entity.indexOf("</IsRetailCust>"));
							if(IsRetail.equalsIgnoreCase("N"))
								CifType="Non-Individual";
							else
								CifType="Individual";
							setControlValue("CIF_TYPE", CifType);
						}
						
						if (MQ_response_Entity.contains("<DocumentDet>"))
						{
							Document recordDoc2=MapXML.getDocument(MQ_response_Entity);
							NodeList records2= MapXML.getNodeListFromDocument(recordDoc2, "DocumentDet");
							PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Total Lines returned for document tag: "+records2.getLength());
							if(records2.getLength() > 0)
							{
								for(int rec2=0;rec2<records2.getLength();rec2++)
								{
									if(MapXML.getTagValueFromNode(records2.item(rec2),"DocType").equalsIgnoreCase("EMID"))
									{
									    EmiratesID = MapXML.getTagValueFromNode(records2.item(rec2),"DocId");
									    if(!EmiratesID.equalsIgnoreCase("") && EmiratesID.length() == 15)
									    	EmiratesID=EmiratesID.substring(0,3)+"-"+EmiratesID.substring(3,7)+"-"+EmiratesID.substring(7,14)+"-"+EmiratesID.substring(14,15);
										setControlValue("EMIRATES_ID", EmiratesID); 
										
									   EmiratesIDExpiryDate = MapXML.getTagValueFromNode(records2.item(rec2),"DocExpDt");
										EmiratesIDExpiryDate = EmiratesIDExpiryDate.substring(8,10)+"/"+EmiratesIDExpiryDate.substring(5,7)+"/"+EmiratesIDExpiryDate.substring(0,4);
										setControlValue("EMIRATES_EXPIRY", EmiratesIDExpiryDate); 
									}
									
									if(MapXML.getTagValueFromNode(records2.item(rec2),"DocType").equalsIgnoreCase("TradeLicense"))
									{
									    TradeLicense = MapXML.getTagValueFromNode(records2.item(rec2),"DocId");
										setControlValue("TRADE_LICENSE", TradeLicense); 
										
									    TLExpiryDate = MapXML.getTagValueFromNode(records2.item(rec2),"DocExpDt");
										TLExpiryDate = TLExpiryDate.substring(8,10)+"/"+TLExpiryDate.substring(5,7)+"/"+TLExpiryDate.substring(0,4);
										setControlValue("TRADE_LICENSE_EXPIRY", TLExpiryDate); 
									}
									
								}
							}
						}
						
						if (MQ_response_Entity.contains("<EmailDet>"))
						{
							Document recordDoc3=MapXML.getDocument(MQ_response_Entity);
							NodeList records3= MapXML.getNodeListFromDocument(recordDoc3, "EmailDet");
							PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Total Lines returned for document tag: "+records3.getLength());
							if(records3.getLength() > 0)
							{
								for(int rec3=0;rec3<records3.getLength();rec3++)
								{
									if(MapXML.getTagValueFromNode(records3.item(rec3),"MailPrefFlag").equalsIgnoreCase("Y"))
									{
										Primaryemail = MapXML.getTagValueFromNode(records3.item(rec3),"EmailID");
										setControlValue("PRIMARY_EMAIL", Primaryemail);
										//PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", main email id is--"+Primaryemail);
									}
								}
							}
						}
					
						if (MQ_response_Entity.contains("<RelatedCIF>"))
						{
							Document recordDoc1=MapXML.getDocument(MQ_response_Entity);
							NodeList records1= MapXML.getNodeListFromDocument(recordDoc1, "RelatedCIF");
							PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Total Lines returned for related cif: "+records1.getLength());
							if((records1.getLength() < 0))
							{
								PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", No Records in entity detail call for related cif...");
								
								//continue;
							}
							if(records1.getLength() > 0)
							{
								
								PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", many records in entity detail call for related cif..");
								for(int rec1=0;rec1<records1.getLength();rec1++)
								{
									if(selectedcif.equals(""))
									{
										selectedcif = MapXML.getTagValueFromNode(records1.item(rec1),"CIFID");
										
									}
									else
									{
										selectedcif=selectedcif+","+MapXML.getTagValueFromNode(records1.item(rec1),"CIFID");
										PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", selectedcif--"+selectedcif);
									}
									 
									PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Nikita :the selected cif id from the grid is--"+StringData);
										
										
								}
									
							}
						}
						setControlValue("SELECTED_CIF_SEARCH","Y");
					}
					
					else
						setControlValue("SELECTED_CIF_SEARCH","N");
					
					//Account summary call for the selected cif
					MQ_response = MQ_connection_response(iformObj,control,StringData);
					MQ_response=MQ_response.substring(MQ_response.indexOf("<?xml v"),MQ_response.indexOf("</MQ_RESPONSE_XML>"));
					//PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", MQ_response_AccountSummary "+MQ_response);
					//PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Nikita for account summary"+MQ_response);
					
					if(MQ_response.indexOf("<ReturnCode>")!=-1)
					{
						ReturnCode3 = MQ_response.substring(MQ_response.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,MQ_response.indexOf("</ReturnCode>"));
						
					}
					
					if(ReturnCode3.equals("0000"))
					{
						if(MQ_response.indexOf("<IsIslamic>")!=-1)
						{
							strIsIslamic=MQ_response.substring(MQ_response.indexOf("<IsIslamic>")+"</IsIslamic>".length()-1,MQ_response.indexOf("</IsIslamic>"));
						}
					
						if (MQ_response.contains("<FINAccountDetail>"))
						{
							Document recordDoc=MapXML.getDocument(MQ_response);
							PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Clicked clear button");
							NodeList records= MapXML.getNodeListFromDocument(recordDoc, "FINAccountDetail");
							PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Total Lines returned : "+records.getLength());
							if((records.getLength()== 0))
							{
								PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", No Records for account detail call...");
								
								//continue;
							}
							if(records.getLength() > 0)
							{
								PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", many records for account detail call..");
								
								for(int rec=0;rec<records.getLength();rec++)
								{
									JSONArray jsonArray=new JSONArray();
								    AccountNumber =MapXML.getTagValueFromNode(records.item(rec),"Acid");
									AccountStatus=MapXML.getTagValueFromNode(records.item(rec),"AcctStatus");
									AcctType = MapXML.getTagValueFromNode(records.item(rec),"AcctType");
									strAccountType=MapXML.getTagValueFromNode(records.item(rec),"AcctType");
									strAccountCategory=MapXML.getTagValueFromNode(records.item(rec),"AccountCategory");
									strProductID=MapXML.getTagValueFromNode(records.item(rec),"ProductId");
									strAccountName=MapXML.getTagValueFromNode(records.item(rec),"AccountName");
									
									//If condition removed by Sajan CRs 20-08-2019
									//if(!AcctType.equalsIgnoreCase("LAA") &&  !AcctType.equalsIgnoreCase("TDA") && !AcctType.equalsIgnoreCase("CCD"))
									//{
										JSONObject obj=new JSONObject();
										obj.put("Account Number", AccountNumber);
										obj.put("Account Status", AccountStatus);
										obj.put("Account Type", strAccountType);
										obj.put("Account Category", strAccountCategory);
										obj.put("Product ID", strProductID);
										obj.put("Account Name", strAccountName);
										jsonArray.add(obj);
										
										//PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", @@@@@@@@@@ for account call:::"+jsonArray.toJSONString());
										iformObj.addDataToGrid("tblAccountDetails", jsonArray);
									//}
								}				
								PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", @@@@@@@@@@ : after add 2");
							}
						}	
						
						if("I".equalsIgnoreCase(strIsIslamic) || "B".equalsIgnoreCase(strIsIslamic))
						{
							//Account Summary call for islamic customers in FlexCube
							MQ_response = MQ_connection_response(iformObj,"flexCubeCall",StringData);
							MQ_response=MQ_response.substring(MQ_response.indexOf("<?xml v"),MQ_response.indexOf("</MQ_RESPONSE_XML>"));
							
							if(MQ_response.indexOf("<ReturnCode>")!=-1)
							{
								ReturnCode4 = MQ_response.substring(MQ_response.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,MQ_response.indexOf("</ReturnCode>"));
								
							}
							if(ReturnCode4.equals("0000"))
							{
								if (MQ_response.contains("<IBSAccountDetail>"))
								{
									Document recordDoc=MapXML.getDocument(MQ_response);
									PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", fetching details for IBS Account");
									NodeList records= MapXML.getNodeListFromDocument(recordDoc, "IBSAccountDetail");
									PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Total Lines returned : "+records.getLength());
									if((records.getLength()== 0))
									{
										PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", No Records for account detail call for flexCube...");
										
										//continue;
									}
									if(records.getLength() > 0)
									{
										PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", many records for account detail call..");
										
										for(int rec=0;rec<records.getLength();rec++)
										{
											JSONArray jsonArray=new JSONArray();
										    AccountNumber =MapXML.getTagValueFromNode(records.item(rec),"Acid");
											AccountStatus=MapXML.getTagValueFromNode(records.item(rec),"AcctStatus");
											AcctType = MapXML.getTagValueFromNode(records.item(rec),"AcctType");
											strAccountType=MapXML.getTagValueFromNode(records.item(rec),"AcctType");
											strAccountCategory=MapXML.getTagValueFromNode(records.item(rec),"AccountCategory");
											strProductID=MapXML.getTagValueFromNode(records.item(rec),"ProductId");
											strAccountName=MapXML.getTagValueFromNode(records.item(rec),"AccountName");
											
											//If condition removed by Sajan CRs 20-08-2019
											//if(!AcctType.equalsIgnoreCase("LAA") &&  !AcctType.equalsIgnoreCase("TDA") && !AcctType.equalsIgnoreCase("CCD"))
											//{
												JSONObject obj=new JSONObject();
												obj.put("Account Number", AccountNumber);
												obj.put("Account Status", AccountStatus);
												obj.put("Account Type", strAccountType);
												obj.put("Account Category", strAccountCategory);
												obj.put("Product ID", strProductID);
												obj.put("Account Name", strAccountName);
												jsonArray.add(obj);
												
												//PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", @@@@@@@@@@ for account call:::"+jsonArray.toJSONString());
												iformObj.addDataToGrid("tblAccountDetails", jsonArray);
											//}
										}				
										PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", @@@@@@@@@@ : after add 2");
									}
								}
							}
						}
						
						
						
						setControlValue("SELECTED_CIF_SEARCH","Y");
					
					}
					else if(ReturnCode3.equals("CINF362"))
						setControlValue("SELECTED_CIF_SEARCH","Y");
					else
						setControlValue("SELECTED_CIF_SEARCH","N");
					
					
					return selectedcif+"@"+ReturnCode2+"@"+ReturnCode3+"@"+ReturnCode4;
						
					}
			//clearing the grid value and other field value on click of Clear button 
			 if(control.equalsIgnoreCase("btn_CIF_Clear"))
			 {
				 setControlValue("CIF_ID", "");
				 setControlValue("ARM_CODE", "");
				 setControlValue("CIF_TYPE", "");
				 setControlValue("CUSTOMER_NAME", "");
				 setControlValue("SUB_SEGMENT", "");
				 setControlValue("PRIMARY_EMAIL", "");
				 setControlValue("RAK_ELITE", "");
				 setControlValue("EMIRATES_ID", "");
				 setControlValue("EMIRATES_EXPIRY", "");
				 setControlValue("TRADE_LICENSE", "");
				 setControlValue("TRADE_LICENSE_EXPIRY", "");
				 iformObj.clearTable("Q_USR_0_PC_CIF_DETAILS");
				 iformObj.clearTable("tblAccountDetails");
				 setControlValue("CIF_NUMBER_SEARCH", "");
				 setControlValue("EMIRATES_ID_SEARCH", "");
				 setControlValue("ACCOUNT_NUMBER", "");
				 setControlValue("CARD_NUMBER", "");
				 setControlValue("LOAN_AGREEMENT_ID", "");
				 setControlValue("MAIN_CIF_SEARCH", "N");
				 setControlValue("SELECTED_CIF_SEARCH", "N");
				 
			 }
			 
			 //open signature window containing the signature associated with account no. from account summary call
			 if(control.equalsIgnoreCase("btn_View_Signature"))
			 {
					String imageArr[] = null;
					String strCode =null;
					String remarksArr[] = null;
					String signGrpNameArr[] = null;
					String customerNameArr[] = null;
					String remarks="";
					String sigGroupName="";
					String CustomerNameSig="";
				    Properties p = new Properties();
					p.load(new FileInputStream(System.getProperty("user.dir")+ System.getProperty("file.separator")+ "CustomConfig"+System.getProperty("file.separator")+"RakBankConfig.properties"));
					String filePath = p.getProperty("PC_LoadImage");
					PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", filePath from OpenImage.jsp- "+filePath);
					String signMatchNeededAtChecker = "";
				 String acc_no = StringData;
				 PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", control is view signature..");
				 MQ_response = MQ_connection_response(iformObj,control,acc_no);
				//PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside btn_View_Signature function "+MQ_response);
				MQ_response=MQ_response.substring(MQ_response.indexOf("<?xml v"),MQ_response.indexOf("</MQ_RESPONSE_XML>"));
				//PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside btn_View_Signature function "+MQ_response);	
				
				Document doc=MapXML.getDocument(MQ_response);
				NodeList returnCode = doc.getElementsByTagName("ReturnCode");
				Element elementReturnCode = (Element) returnCode.item(0);
				strCode = getCharacterDataFromElement(elementReturnCode);
				
				NodeList returnDesc = doc.getElementsByTagName("ReturnDesc");
				Element elementReturnDesc = (Element) returnDesc.item(0);
				String strDesc = getCharacterDataFromElement(elementReturnDesc);
				
				if (strCode.equals("0000"))
				{
					NodeList nodesReturnedSignature = doc.getElementsByTagName("returnedSignature");
					NodeList nodesRemarksArr = doc.getElementsByTagName("remarks");
					NodeList nodesSignGrpNameArr = doc.getElementsByTagName("SignGrpName");
					NodeList nodesCustomerNameArr = doc.getElementsByTagName("CustomerName");
					
					//First Check if call is success or not
					
					//Initializing the Image Array
					returnedSignatures = nodesReturnedSignature.getLength();
					imageArr = new String [returnedSignatures];
					remarksArr = new String [returnedSignatures];
					signGrpNameArr = new String [returnedSignatures];
					customerNameArr = new String [returnedSignatures];
					
					PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", returnedSignatures - "+returnedSignatures);
					
					// iterate the returnedSignatures and put it in an array
					for (int i = 0; i < returnedSignatures; i++) {
						Element element = (Element) nodesReturnedSignature.item(i);
						Element element1 = (Element) nodesRemarksArr.item(i);
						Element element2 = (Element) nodesSignGrpNameArr.item(i);
						Element element3 = (Element) nodesCustomerNameArr.item(i);
						try{
							imageArr [i] = getCharacterDataFromElement(element);
							//PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", image value is --"+imageArr[i]);
							remarksArr [i] = getCharacterDataFromElement(element1);
							if(remarks.equals(""))
							 remarks = remarksArr [i];
							else
								remarks = remarks+","+remarksArr [i];
							PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", remarks value is --"+remarksArr[i]);
							
							signGrpNameArr [i] = getCharacterDataFromElement(element2);	
							PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", sig grp name value is --"+signGrpNameArr[i]);
							if(sigGroupName.equals(""))
								sigGroupName = signGrpNameArr [i];
								else
									sigGroupName = sigGroupName+","+signGrpNameArr [i];
							
							customerNameArr [i] = getCharacterDataFromElement(element3);
							//PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", customer name value is --"+imageArr[i]);
							if(CustomerNameSig.equals(""))
								CustomerNameSig = signGrpNameArr [i];
								else
									CustomerNameSig = CustomerNameSig+","+customerNameArr [i];
						}catch(Exception ex){
							PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Exception 1 - "+ex);
						}
					}
				}
				
				if (strCode.equals("0000"))
				{
					 getImages(filePath,acc_no,imageArr,remarksArr);
					 return strCode+"~"+Integer.toString(returnedSignatures)+"~"+remarks+"~"+sigGroupName+"~"+CustomerNameSig;
				} else {
					
					return strCode+"~"+strDesc;
				}
				
				
			 }
		}
			
		
		catch(Exception exc)
		{
			PC.printException(exc);
			PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Exception 2 - "+exc);
		}
	
		return "";
	}
	
	public String getImages(String tempImagePath,String debt_acc_num,String[] imageArr,String[] remarksArr)
	{
		
		String strCode =null;
		StringBuilder html = new StringBuilder();
		if(imageArr==null)
			return "";
		for (int i=0;i<imageArr.length;i++)
		{
			try
			{	
				PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside Get Images 0");
				byte[] btDataFile = new sun.misc.BASE64Decoder().decodeBuffer(imageArr[i]);
				//File of = new File(filePath+debt_acc_num+"imageCreatedN"+i+".jpg");
				String imagePath = System.getProperty("user.dir")+ tempImagePath+System.getProperty("file.separator")+debt_acc_num+"imageCreatedN"+i+".jpg";
				PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", imagePath"+imagePath);
				File of = new File(imagePath);
				
				FileOutputStream osf = new FileOutputStream(of);
				osf.write(btDataFile);
				osf.flush();
				osf.close();
			}
			catch (Exception e)
			{
				PC.mLogger.debug( e.getMessage());
				e.printStackTrace();
				PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Not able to get the image imageCreated"+e);
			}
		}
		//WriteLog( html.toString());
		return "";
	}
	
	public static String getCharacterDataFromElement(Element e) {
		Node child = e.getFirstChild();
		if (child instanceof CharacterData) {
		   CharacterData cd = (CharacterData) child;
		   return cd.getData();
		}
		return "NO_DATA";
	}
	
	
	public String MQ_connection_response(IFormReference iformObj,String control,String Data) 
	{
		
	PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside MQ_connection_response function");
	PC.mLogger.debug("Check 12345");
	final IFormReference iFormOBJECT;
	final WDGeneralData wdgeneralObj;	
	Socket socket = null;
	OutputStream out = null;
	InputStream socketInputStream = null;
	DataOutputStream dout = null;
	DataInputStream din = null;
	String mqOutputResponse = null;
	String mqOutputResponse_Entity = null;
	String mqOutputResponse_Account = null;
	String mqInputRequest = null;
	String cabinetName = getCabinetName();
	String wi_name = getWorkitemName();
	String ws_name = getActivityName();
	String sessionID = getSessionId();
	String userName = getUserName();
	String socketServerIP;
	int socketServerPort;
	wdgeneralObj = iformObj.getObjGeneralData();
	sessionID = wdgeneralObj.getM_strDMSSessionId();
	String CIFNumber="";
	String EmiratesID ="";
	String AccountNumber="";
	String CardNumber="";
	String LoanAgreementID="";
	String Nikita="";

	
	if(control.equals("tblCIF"))
	{
		String selectedCIFNumber = Data;
	PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", $$selectedCIFNumber: "+selectedCIFNumber);
	StringBuilder finalXml = new StringBuilder("<EE_EAI_MESSAGE>\n"+
			"<EE_EAI_HEADER>\n"+
			"<MsgFormat>ACCOUNT_SUMMARY</MsgFormat>\n"+
			"<MsgVersion>0000</MsgVersion>\n"+
			"<RequestorChannelId>BPM</RequestorChannelId>\n"+
			"<RequestorUserId>RAKUSER</RequestorUserId>\n"+
			"<RequestorLanguage>E</RequestorLanguage>\n"+
			"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
			"<ReturnCode>911</ReturnCode>\n"+
			"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n"+
			"<MessageId>143282709427399867</MessageId>\n"+
			"<Extra1>REQ||RAK_TEMP_USER_3394.RAK_TEMP_USER_3394</Extra1>\n"+
			"<Extra2>2015-05-28T21:01:34.273+05:30</Extra2>\n"+
			"</EE_EAI_HEADER>\n"+
			"<FetchAccountListReq><BankId>RAK</BankId><CIFID>"+selectedCIFNumber+"</CIFID><FetchClosedAcct>N</FetchClosedAcct><AccountIndicator>A</AccountIndicator></FetchAccountListReq>\n"+
			"</EE_EAI_MESSAGE>");
	mqInputRequest = getMQInputXML(sessionID, cabinetName,wi_name, ws_name, userName, finalXml);
	PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", mqInputRequest for Account Summary call: " + mqInputRequest);
	}
	
	//Block to make call to FlexCube system for islamic customers
	else if("flexCubeCall".equalsIgnoreCase(control))
	{
		String selectedCIFNumber = Data;
		PC.mLogger.debug("This call is for account summary details in Flex Cube");
		PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", $$selectedCIFNumber: "+selectedCIFNumber);
		StringBuilder finalXml = new StringBuilder("<EE_EAI_MESSAGE>\n"+
				"<EE_EAI_HEADER>\n"+
				"<MsgFormat>ACCOUNT_SUMMARY</MsgFormat>\n"+    //Change ACCOUNT_SUMMARY1 to ACCOUNT_SUMMARY at UAT
				"<MsgVersion>0000</MsgVersion>\n"+
				"<RequestorChannelId>BPM</RequestorChannelId>\n"+
				"<RequestorUserId>RAKUSER</RequestorUserId>\n"+
				"<RequestorLanguage>E</RequestorLanguage>\n"+
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				"<ReturnCode>911</ReturnCode>\n"+
				"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n"+
				"<MessageId>143282709427399867</MessageId>\n"+
				"<Extra1>REQ||RAK_TEMP_USER_3394.RAK_TEMP_USER_3394</Extra1>\n"+
				"<Extra2>2015-05-28T21:01:34.273+05:30</Extra2>\n"+
				"</EE_EAI_HEADER>\n"+
				"<FetchAccountListReq><BankId>RAK</BankId><CIFID>"+selectedCIFNumber+"</CIFID><FetchClosedAcct>N</FetchClosedAcct><AccountIndicator>B</AccountIndicator></FetchAccountListReq>\n"+
				"</EE_EAI_MESSAGE>");
		mqInputRequest = getMQInputXML(sessionID, cabinetName,wi_name, ws_name, userName, finalXml);
		PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", mqInputRequest for Account Summary call for FlexCube is : " + mqInputRequest);
	}
	
	else if(control.equals("btn_CIF_Search"))
	{
		 CIFNumber=  getControlValue("CIF_NUMBER_SEARCH");
		 PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", CIFNumber for the first entity detail call is --"+CIFNumber);
		 EmiratesID = getControlValue("EMIRATES_ID_SEARCH");
		 AccountNumber= getControlValue("ACCOUNT_NUMBER");
		 CardNumber= getControlValue("CARD_NUMBER");
		 LoanAgreementID = getControlValue("LOAN_AGREEMENT_ID");
		 String account_type="A";
		//getAccountType for Card
		 
			if (AccountNumber.equalsIgnoreCase("")) {
				if (!CardNumber.equalsIgnoreCase("")) {
					AccountNumber = CardNumber;
					account_type = "C";

				}
				//code change for Loan Agreement ID
				else if (!LoanAgreementID.equalsIgnoreCase("")) {
					AccountNumber = LoanAgreementID;
					account_type = "L";
				} else
					account_type = "";
			}
	StringBuilder finalXml = new StringBuilder("<EE_EAI_MESSAGE>\n"+
				"<EE_EAI_HEADER>\n"+
				"<MsgFormat>ENTITY_DETAILS</MsgFormat>\n"+
				"<MsgVersion>0001</MsgVersion>\n"+
				"<RequestorChannelId>BPM</RequestorChannelId>\n"+
				"<RequestorUserId>BPMUSER</RequestorUserId>\n"+
				"<RequestorLanguage>E</RequestorLanguage>\n"+
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				"<ReturnCode>0000</ReturnCode>\n"+
				"<ReturnDesc>saddd</ReturnDesc>\n"+
				"<MessageId>143282709427399867</MessageId>\n"+
				"<Extra1>REQ||RAK_TEMP_USER_3394.RAK_TEMP_USER_3394</Extra1>\n"+
				"<Extra2>2015-05-28T21:01:34.273+05:30</Extra2>\n"+
				"</EE_EAI_HEADER>\n"+
				"<CustomerDetails><BankId>RAK</BankId><CIFID>"+CIFNumber+"</CIFID><ACCType>"+account_type+"</ACCType><ACCNumber>"+AccountNumber+"</ACCNumber><EmiratesID>"+EmiratesID+"</EmiratesID><InquiryType>CustomerAndAccount</InquiryType><RelCIFDetFlag>Y</RelCIFDetFlag><FreeField1></FreeField1><FreeField2></FreeField2><FreeField3></FreeField3></CustomerDetails>\n"+
				"</EE_EAI_MESSAGE>");
	mqInputRequest = getMQInputXML(sessionID, cabinetName,wi_name, ws_name, userName, finalXml);
	PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", mqInputRequest for first Entity Detail call" + mqInputRequest);
	}
	
	else if(control.equals("btn_CIF_Search2"))
	{
		CIFNumber=  Data;
		 PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", CIFNumber for the second entity detail call is --"+CIFNumber);

		StringBuilder finalXml = new StringBuilder("<EE_EAI_MESSAGE>\n"+
				"<EE_EAI_HEADER>\n"+
				"<MsgFormat>ENTITY_DETAILS</MsgFormat>\n"+
				"<MsgVersion>0001</MsgVersion>\n"+
				"<RequestorChannelId>BPM</RequestorChannelId>\n"+
				"<RequestorUserId>BPMUSER</RequestorUserId>\n"+
				"<RequestorLanguage>E</RequestorLanguage>\n"+
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				"<ReturnCode>0000</ReturnCode>\n"+
				"<ReturnDesc>saddd</ReturnDesc>\n"+
				"<MessageId>143282709427399867</MessageId>\n"+
				"<Extra1>REQ||RAK_TEMP_USER_3394.RAK_TEMP_USER_3394</Extra1>\n"+
				"<Extra2>2015-05-28T21:01:34.273+05:30</Extra2>\n"+
				"</EE_EAI_HEADER>\n"+
				"<CustomerDetails><BankId>RAK</BankId><CIFID>"+CIFNumber+"</CIFID><ACCType></ACCType><ACCNumber></ACCNumber><EmiratesID></EmiratesID><InquiryType>CustomerAndAccount</InquiryType><RelCIFDetFlag>Y</RelCIFDetFlag><FreeField1></FreeField1><FreeField2></FreeField2><FreeField3></FreeField3></CustomerDetails>\n"+
				"</EE_EAI_MESSAGE>");
	mqInputRequest = getMQInputXML(sessionID, cabinetName,wi_name, ws_name, userName, finalXml);
	PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", mqInputRequest for second Entity Detail call" + mqInputRequest);
	}
	
	else if(control.equals("btn_View_Signature"))
	{
		PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside btn_View_Signature control--");
		String acc_selected = Data;
		String selectedCIFNumber = getControlValue("CIF_ID");
		PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", $$selectedCIFNumber "+selectedCIFNumber);
		StringBuilder finalXml = new StringBuilder("<EE_EAI_MESSAGE>\n"+
				"<EE_EAI_HEADER>\n"+
				"<MsgFormat>SIGNATURE_DETAILS</MsgFormat>\n"+
				"<MsgVersion>0001</MsgVersion>\n"+
				"<RequestorChannelId>BPM</RequestorChannelId>\n"+
				"<RequestorUserId>RAKUSER</RequestorUserId>\n"+
				"<RequestorLanguage>E</RequestorLanguage>\n"+
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				"<ReturnCode>911</ReturnCode>\n"+
				"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n"+
				"<MessageId>MDL053169111</MessageId>\n"+
				"<Extra1>REQ||PERCOMER.PERCOMER</Extra1>\n"+
				"<Extra2>2007-01-01T10:30:30.000Z</Extra2>\n"+
				"</EE_EAI_HEADER>\n"+
				"<SignatureDetailsReq><BankId>RAK</BankId><CustId></CustId><AcctId>"+acc_selected+"</AcctId></SignatureDetailsReq>\n"+
				"</EE_EAI_MESSAGE>");
	mqInputRequest = getMQInputXML(sessionID, cabinetName,wi_name, ws_name, userName, finalXml);
	PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", mqInputRequest for Signature Details call" + mqInputRequest);
	}
	
	try {
	
	PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", userName "+ userName);
	PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", sessionID "+ sessionID);
	
	String sMQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'PC' and CallingSource = 'Form'";
	List<List<String>> outputMQXML = iformObj.getDataFromDB(sMQuery);
	//CreditCard.mLogger.info("$$outputgGridtXML "+ "sMQuery " + sMQuery);
	if (!outputMQXML.isEmpty()) {
		//CreditCard.mLogger.info("$$outputgGridtXML "+ outputMQXML.get(0).get(0) + "," + outputMQXML.get(0).get(1));
		socketServerIP = outputMQXML.get(0).get(0);
		PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", socketServerIP " + socketServerIP);
		socketServerPort = Integer.parseInt(outputMQXML.get(0).get(1));
		PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", socketServerPort " + socketServerPort);
		if (!("".equalsIgnoreCase(socketServerIP) && socketServerIP == null && socketServerPort==0)) {
			socket = new Socket(socketServerIP, socketServerPort);
			//new Code added by Deepak to set connection timeout
			int connection_timeout=60;
				try{
					connection_timeout=70;
					//connection_timeout = Integer.parseInt(NGFUserResourceMgr_CreditCard.getGlobalVar("Integration_Connection_Timeout"));
				}
				catch(Exception e){
					connection_timeout=60;
				}
				
			socket.setSoTimeout(connection_timeout*1000);
			out = socket.getOutputStream();
			socketInputStream = socket.getInputStream();
			dout = new DataOutputStream(out);
			din = new DataInputStream(socketInputStream);
			PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", dout " + dout);
			PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", din " + din);
			mqOutputResponse = "";
			
	
			if (mqInputRequest != null && mqInputRequest.length() > 0) {
				int outPut_len = mqInputRequest.getBytes("UTF-16LE").length;
				PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Final XML output len: "+outPut_len + "");
				mqInputRequest = outPut_len + "##8##;" + mqInputRequest;
				PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", MqInputRequest"+"Input Request Bytes : "+ mqInputRequest.getBytes("UTF-16LE"));
				dout.write(mqInputRequest.getBytes("UTF-16LE"));dout.flush();
			}
			byte[] readBuffer = new byte[500];
			int num = din.read(readBuffer);
			if (num > 0) {
	
				byte[] arrayBytes = new byte[num];
				System.arraycopy(readBuffer, 0, arrayBytes, 0, num);
				mqOutputResponse = mqOutputResponse+ new String(arrayBytes, "UTF-16LE");
				PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", mqOutputResponse/message ID :  "+mqOutputResponse);
				if(!"".equalsIgnoreCase(mqOutputResponse) && control.equalsIgnoreCase("btn_CIF_Search")){
					mqOutputResponse = getOutWtthMessageID("ENTITY_DETAILS",iformObj,mqOutputResponse);
				}
				else if(!"".equalsIgnoreCase(mqOutputResponse) && control.equalsIgnoreCase("tblCIF"))
				{
					mqOutputResponse = getOutWtthMessageID("ACCOUNT_SUMMARY",iformObj,mqOutputResponse);
				}
				
				//Added for FlexCube call
				else if(!"".equalsIgnoreCase(mqOutputResponse) && control.equalsIgnoreCase("flexCubeCall"))
				{
					PC.mLogger.debug("Fetching output XML from table for FlexCube call");
					
					mqOutputResponse = getOutWtthMessageID("ACCOUNT_SUMMARY",iformObj,mqOutputResponse); // Change it to ACCOUNT_SUMMARY at UAT
				}
				
				else if(!"".equalsIgnoreCase(mqOutputResponse) && control.equalsIgnoreCase("btn_CIF_Search2"))
				{
					mqOutputResponse = getOutWtthMessageID("ENTITY_DETAILS",iformObj,mqOutputResponse);
				}
				
				else if(!"".equalsIgnoreCase(mqOutputResponse) && control.equalsIgnoreCase("btn_View_Signature"))
				{
					mqOutputResponse = getOutWtthMessageID("SIGNATURE_DETAILS",iformObj,mqOutputResponse);
				}
					
				if(mqOutputResponse.contains("&lt;")){
					mqOutputResponse=mqOutputResponse.replaceAll("&lt;", "<");
					mqOutputResponse=mqOutputResponse.replaceAll("&gt;", ">");
				}
			}
			socket.close();
			return mqOutputResponse;
			
		} else {
			PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", SocketServerIp and SocketServerPort is not maintained "+"");
			PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", SocketServerIp is not maintained "+	socketServerIP);
			PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", SocketServerPort is not maintained "+	socketServerPort);
			return "MQ details not maintained";
		}
	} else {
		PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", SOcket details are not maintained in NG_BPM_MQ_TABLE table"+"");
		return "MQ details not maintained";
	}
	
	} catch (Exception e) {
		PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Exception Occured Mq_connection_CC"+e.getStackTrace());
	return "";
	}
	finally{
	try{
		if(out != null){
			
			out.close();
			out=null;
			}
		if(socketInputStream != null){
			
			socketInputStream.close();
			socketInputStream=null;
			}
		if(dout != null){
			
			dout.close();
			dout=null;
			}
		if(din != null){
			
			din.close();
			din=null;
			}
		if(socket != null){
			if(!socket.isClosed()){
				socket.close();
			}
			socket=null;
		}
	}catch(Exception e)
	{
		//		RLOS.mLogger.info("Exception occurred while closing socket");
		PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Final Exception Occured Mq_connection_CC"+e.getStackTrace());
		//printException(e);
	}
	}
	}
	private static String getMQInputXML(String sessionID, String cabinetName,
			String wi_name, String ws_name, String userName,
			StringBuilder final_xml) {
		//FormContext.getCurrentInstance().getFormConfig();
		PC.mLogger.debug("inside getMQInputXML function");
		StringBuffer strBuff = new StringBuffer();
		strBuff.append("<APMQPUTGET_Input>");
		strBuff.append("<SessionId>" + sessionID + "</SessionId>");
		strBuff.append("<EngineName>" + cabinetName + "</EngineName>");
		strBuff.append("<XMLHISTORY_TABLENAME>NG_PC_XMLLOG_HISTORY</XMLHISTORY_TABLENAME>");
		strBuff.append("<WI_NAME>" + wi_name + "</WI_NAME>");
		strBuff.append("<WS_NAME>" + ws_name + "</WS_NAME>");
		strBuff.append("<USER_NAME>" + userName + "</USER_NAME>");
		strBuff.append("<MQ_REQUEST_XML>");
		strBuff.append(final_xml);
		strBuff.append("</MQ_REQUEST_XML>");
		strBuff.append("</APMQPUTGET_Input>");
		//PC.mLogger.debug("inside getOutputXMLValues"+ "getMQInputXML"+ strBuff.toString());
		return strBuff.toString();
	}
	
	public String getOutWtthMessageID(String callName,IFormReference iformObj,String message_ID){
		String outputxml="";
		try{
			//String wi_name = iformObj.getWFWorkitemName();
			String wi_name = getWorkitemName();
			String str_query = "select OUTPUT_XML from NG_PC_XMLLOG_HISTORY with (nolock) where CALLNAME ='"+callName+"' and MESSAGE_ID ='"+message_ID+"' and WI_NAME = '"+wi_name+"'";
			PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", inside getOutWtthMessageID str_query: "+ str_query);
			List<List<String>> result=iformObj.getDataFromDB(str_query);
			//below code added by nikhil 18/10 for Connection timeout
			//String Integration_timeOut=NGFUserResourceMgr_CreditCard.getGlobalVar("Inegration_Wait_Count");
			String Integration_timeOut="100";
			int Loop_wait_count=10;
			try
			{
				Loop_wait_count=Integer.parseInt(Integration_timeOut);
			}
			catch(Exception ex)
			{
				Loop_wait_count=10;
			}
		
			for(int Loop_count=0;Loop_count<Loop_wait_count;Loop_count++){
				if(result.size()>0){
					outputxml = result.get(0).get(0);
					break;
				}
				else{
					Thread.sleep(1000);
					result=iformObj.getDataFromDB(str_query);
				}
			}
			
			if("".equalsIgnoreCase(outputxml)){
				outputxml="Error";
			}
			String outputxmlMasked = outputxml;
			outputxmlMasked = maskXmlogBasedOnCallType(outputxmlMasked,callName);
			PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", getOutWtthMessageID" + outputxmlMasked);				
		}
		catch(Exception e){
			PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Exception occurred in getOutWtthMessageID" + e.getMessage());
			PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Exception occurred in getOutWtthMessageID" + e.getStackTrace());
			outputxml="Error";
		}
		return outputxml;
	}
	public Document getDocument(String xml) throws ParserConfigurationException, SAXException, IOException
	{
		// Step 1: create a DocumentBuilderFactory
		DocumentBuilderFactory dbf =
				DocumentBuilderFactory.newInstance();

		// Step 2: create a DocumentBuilder
		DocumentBuilder db = dbf.newDocumentBuilder();

		// Step 3: parse the input file to get a Document object
		Document doc = db.parse(new InputSource(new StringReader(xml)));
		PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", xml is-"+xml);
		return doc;
	}
	
	public String maskXmlogBasedOnCallType(String outputxmlMasked, String callType)
	{
		String Tags = "";
		if (callType.equalsIgnoreCase("ENTITY_DETAILS"))
		{
			outputxmlMasked = outputxmlMasked.replace("("," ").replace(")"," ").replace("@"," ").replace("+"," ").replace("&amp;/"," ").replace("&amp; /"," ").replace("."," ").replace(","," ");
			Tags = "<ACCNumber>~,~<AccountName>~,~<ECRNumber>~,~<DOB>~,~<MothersName>~,~<IBANNumber>~,~<DocId>~,~<DocExpDt>~,~<DocIssDate>~,~<PassportNum>~,~<MotherMaidenName>~,~<LinkedDebitCardNumber>~,~<FirstName>~,~<MiddleName>~,~<LastName>~,~<FullName>~,~<ARMCode>~,~<ARMName>~,~<PhnCountryCode>~,~<PhnLocalCode>~,~<PhoneNo>~,~<EmailID>~,~<CustomerName>~,~<CustomerMobileNumber>~,~<PrimaryEmailId>~,~<Fax>~,~<AddressType>~,~<AddrLine1>~,~<AddrLine2>~,~<AddrLine3>~,~<AddrLine4>~,~<POBox>~,~<City>~,~<Country>~,~<AddressLine1>~,~<AddressLine2>~,~<AddressLine3>~,~<AddressLine4>~,~<CityCode>~,~<State>~,~<CountryCode>~,~<Nationality>~,~<ResidentCountry>~,~<PrimaryContactName>~,~<PrimaryContactNum>~,~<SecondaryContactName>~,~<SecondaryContactNum>";
		}
		else if (callType.equalsIgnoreCase("ACCOUNT_SUMMARY"))
		{
			outputxmlMasked = outputxmlMasked.replace("("," ").replace(")"," ").replace("@"," ").replace("+"," ").replace("&amp;/"," ").replace("&amp; /"," ").replace("."," ").replace(","," ");
			Tags = "<Acid>~,~<Foracid>~,~<NicName>~,~<AccountName>~,~<AcctBal>~,~<LoanAmtAED>~,~<AcctOpnDt>~,~<MaturityAmt>~,~<EffAvailableBal>~,~<EquivalentAmt>~,~<LedgerBalanceinAED>~,~<LedgerBalance>";
		}
		else if (callType.equalsIgnoreCase("SIGNATURE_DETAILS"))
		{
			outputxmlMasked = outputxmlMasked.replace("&amp;/"," ").replace("&amp; /"," ").replace("."," ").replace(","," ");
			Tags = "<CustomerName>";
		}
		if (!Tags.equalsIgnoreCase(""))
		{
	    	String Tag[] = Tags.split("~,~");
	    	for(int i=0;i<Tag.length;i++)
	    	{
	    		outputxmlMasked = maskXmlTags(outputxmlMasked,Tag[i]);
	    	}
		}
    	return outputxmlMasked;
	}
	
}
