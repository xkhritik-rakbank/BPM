package com.newgen.iforms.user;


import java.text.DateFormat;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.time.DayOfWeek;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoUnit;

import org.apache.commons.collections4.Put;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.newgen.iforms.custom.IFormReference;

public class EIBOR_FormLoad {
	 
	
	public static String formLoad(IFormReference ifr,String control,String event,String rowCount)
	{
		EIBOR.mLogger.info("inside form load method-->");
		try 
		{
			ifr.setValue("Decision","");
			String ActivityName = ifr.getActivityName();
			EIBOR.mLogger.info("Current activity name-->"+ActivityName);
			setDecisionDropDown(ifr,ActivityName);
			if(ActivityName.equalsIgnoreCase("Initiation") && ifr.getDataFromGrid("NG_EIBOR_GRID_CBUAE_RATES").size()<=0)
				dataLoadInCBUAE(ifr);
			if(ActivityName.equalsIgnoreCase("Initiation") && ifr.getDataFromGrid("NG_EIBOR_GRID_DF2_DEALS").size()<=0)
				dataLoadInDF2Deals(ifr);
			if(ActivityName.equalsIgnoreCase("Initiation") && ifr.getDataFromGrid("NG_EIBOR_GRID_MM").size()<=0)
				dataLoadInMM(ifr);			

			if(ActivityName.equalsIgnoreCase("Initiation"))
				dataLoadInPartyQuotes(ifr);
			
			if(ActivityName.equalsIgnoreCase("Initiation") && ifr.getDataFromGrid("NG_EIBOR_GRID_BB_LIBOR_FW_RATES").size()<=0)
				dataLoadInBB(ifr);
			if(ActivityName.equalsIgnoreCase("Initiation")){
				loadToBeReportedDF2(ifr);
				loadToBeReportedMM(ifr);
				
			}
			
			tbBeReportedCbuae(ifr);
			loadToBeReported(ifr);
			
			if(ActivityName.equalsIgnoreCase("Initiation") && ifr.getDataFromGrid("NG_EIBOR_GRID_DF1").size()<=0)
				dataLoadInAllCommonGrid(ifr);
			
		
			if(ActivityName.equalsIgnoreCase("Initiation")){
				clearRepeTables(ifr);
				dataLoadInHISTCUSTRepe(ifr);		
				dataLoadInHISTIBRepe(ifr);
			}	
				
			if(ActivityName.equalsIgnoreCase("Initiation")){
				dataLoadInDF1Repe(ifr);			
				dataLoadInDF2Repe(ifr);
			}	
								
			dataLoadInDF1(ifr);
			dataLoadInDF2(ifr);		
			dataLoadInHistIB(ifr);
			dataLoadInHistCust(ifr);
			
			
		}
			
		catch (Exception e)
		{
			EIBOR.mLogger.info("Exception in load decision:- "+e.toString());
		}
		return "";
	}
	
	public static void setDecisionDropDown(IFormReference ifr, String ActivityName)
	{
		EIBOR.mLogger.info("inside setDecisionDropDown method.");
		
		try 
		{
			EIBOR.mLogger.info("inside setDecisionDropDown method.");
			if(ActivityName.equalsIgnoreCase("OPS_Checker"))
			{
				EIBOR.mLogger.info("inside OPS_Checker");
				ifr.clearCombo("Decision");
				ifr.addItemInCombo("Decision","Submit","Submit");
				ifr.addItemInCombo("Decision","Send back to Maker","Send back to Maker");
				
			}
			else if(ActivityName.equalsIgnoreCase("Front_Desk_Checker"))
			{
				EIBOR.mLogger.info("inside Front_Desk_Checker");
				ifr.clearCombo("Decision");
				ifr.addItemInCombo("Decision","Submit","Submit");
				ifr.addItemInCombo("Decision","Send back to Checker","Send back to Checker");
			}
			else if(ActivityName.equalsIgnoreCase("OPS_Maker"))
			{
				EIBOR.mLogger.info("inside OPS_Maker");
				ifr.clearCombo("Decision");
				
				ifr.addItemInCombo("Decision","Send back to Checker","Send back to Checker");
			}
			else{
				EIBOR.mLogger.info("inside Initiaiton");
				ifr.clearCombo("Decision");
				ifr.addItemInCombo("Decision","Submit","Submit");
			}
		}	
		catch (Exception e)
		{
			EIBOR.mLogger.info("Exception while populating decision dropdown--:- "+e.toString());
		}
	}
	
	public static String dataLoadInCBUAE(IFormReference ifr)
	{
		EIBOR.mLogger.info("inside load data in CBUAE Grid--");
		
		try 
		{
			EIBOR.mLogger.info("inside try load data in CBUAE Grid--");
			JSONArray jsonArray=new JSONArray();
			JSONObject obj=new JSONObject();	    
			LocalDate yesterday = LocalDate.now().minusDays(1);
			String query = "select distinct Datee,O_N,One_W,One_M,Three_M,Six_M,One_Y from NG_EIBOR_GRID_CBUAE_RATES WHERE DATEE >= DATEADD(DAY,-6,GETDATE()) AND DATEE < DATEADD(DAY,-2,GETDATE())";
			if((yesterday.getDayOfWeek().getValue()==7) || (yesterday.getDayOfWeek().getValue()==1)){
				query = "select distinct Datee,O_N,One_W,One_M,Three_M,Six_M,One_Y from NG_EIBOR_GRID_CBUAE_RATES WHERE DATEE >= DATEADD(DAY,-8,GETDATE()) AND DATEE < DATEADD(DAY,-4,GETDATE())";			
			}
			@SuppressWarnings("unchecked")
			List<List<String>> dataFromDB1 = ifr.getDataFromDB(query);
			int listSize = dataFromDB1.size();
			
			if(listSize!=4){
				
				int day =-6;
				int listSize1 =listSize;
				while(listSize1!=4){
					int p =4-listSize1;
					day = day-p;
					query = "select distinct Datee,O_N,One_W,One_M,Three_M,Six_M,One_Y from NG_EIBOR_GRID_CBUAE_RATES WHERE DATEE >= DATEADD(DAY,"+day+",GETDATE()) AND DATEE < DATEADD(DAY,-2,GETDATE())";
					@SuppressWarnings("unchecked")
					List<List<String>> dataFromDB = ifr.getDataFromDB(query);
					listSize1 = dataFromDB.size();
				}
				dataFromDB1 = ifr.getDataFromDB(query);
				listSize = dataFromDB1.size();
			}
			EIBOR.mLogger.info("Query for cbuae gird --"+query);
			EIBOR.mLogger.info("Data from db CBuae --"+dataFromDB1);
			for(int i=0;i<listSize;i++){		
				EIBOR.mLogger.info("inside loop in load data in CBUAE Grid--");
				String datee = dataFromDB1.get(i).get(0).replaceAll("00:00:00", "");
				String on = dataFromDB1.get(i).get(1);
				String ow = dataFromDB1.get(i).get(2);
				String om = dataFromDB1.get(i).get(3);
				String tm = dataFromDB1.get(i).get(4);
				String sm = dataFromDB1.get(i).get(5);
				String oy = dataFromDB1.get(i).get(6);
				
				EIBOR.mLogger.info("inside loop data fetched successfully");
				
				obj.put("Date",datee);
				obj.put("O/N",on);
				obj.put("1W",ow);
				obj.put("1M",om);
				obj.put("3M",tm);
				obj.put("6M",sm);
				obj.put("1Y",oy);
				
				jsonArray.add(obj);
				ifr.addDataToGrid("NG_EIBOR_GRID_CBUAE_RATES", jsonArray);
				
				obj=new JSONObject();
				jsonArray=new JSONArray();
			}
			EIBOR.mLogger.info("exit from for loop");
			EIBOR.mLogger.info("data added to grid successfully--");
		}	
		catch (Exception e)
		{
			EIBOR.mLogger.info("Exception inside load data in CBUAE Grid--:- "+e.toString());
		}
		return "";
	}
	
	
	public static String dataLoadInDF2Deals(IFormReference ifr)
	{
		EIBOR.mLogger.info("inside load data in DF2Deals Grid--");
		
		
		try 
		{
			EIBOR.mLogger.info("inside try load data in DF2Deals Grid--");
			JSONArray jsonArray=new JSONArray();
			JSONObject obj=new JSONObject();
			String queryForExceptionCases = "select * from NG_EIBOR_MASTER_SKIP_PARTY where isActive = 'N'";
			@SuppressWarnings("unchecked")
			List<List<String>> dataFromDB1 = ifr.getDataFromDB(queryForExceptionCases);
			int listSize1 = dataFromDB1.size();
			EIBOR.mLogger.info("Size of skip paty list: "+listSize1);
			ArrayList<String> arraylist = new ArrayList<String>(20);
			for(int m =0;m<listSize1;m++){
				String counterPartyy = dataFromDB1.get(m).get(0);
				arraylist.add(counterPartyy);
			}
			
						
			EIBOR.mLogger.info("inside try load data in DF2Deals Grid with finacle report--");
			
			 
			Map<String,String> finacleRecord = new HashMap<String,String>();
			String query = "select * from NG_EIBOR_BE_FINACLE_BO_DATA where cast(inserted_date as date) = cast(GETDATE() as date) and cast(Received_On as date) = cast(GETDATE() as date)";
			@SuppressWarnings("unchecked")
			List<List<String>> finacleDataFromDB = ifr.getDataFromDB(query);
			int finacleDataListSize = finacleDataFromDB.size();
			if(finacleDataListSize > 0){
				EIBOR.mLogger.info("DF2Deals Grid,finacleDataFromDB: "+finacleDataFromDB);
				for(int i=0;i<finacleDataListSize;i++){		
					EIBOR.mLogger.info("inside loop in load data in DF2Deals Grid--");
					String counterParty = finacleDataFromDB.get(i).get(1);
					String contractRate = finacleDataFromDB.get(i).get(10);
					String startDate = finacleDataFromDB.get(i).get(4);
					String dueDate = finacleDataFromDB.get(i).get(7);
					String amount = finacleDataFromDB.get(i).get(11).replaceAll(",","");
					String account = finacleDataFromDB.get(i).get(0);
					String filename = finacleDataFromDB.get(i).get(20);
					String createdOn = finacleDataFromDB.get(i).get(17);
					String oldMaturity = finacleDataFromDB.get(i).get(15);
					
					if(!oldMaturity.isEmpty()){
						SimpleDateFormat inputFormat = new SimpleDateFormat("dd-MMM-yy");
						SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
						Date date = inputFormat.parse(oldMaturity);	
						oldMaturity = outputFormat.format(date);
					}
					
					if(arraylist.contains(counterParty)){
						continue;						
					}
					
					
					finacleRecord.put(counterParty, account);
			
					
					
					
					SimpleDateFormat formater2 = new SimpleDateFormat("yyyy-MM-dd");
					
					EIBOR.mLogger.info("Created on Date ---"+createdOn);
					EIBOR.mLogger.info("Old Maturity Date--"+oldMaturity);
					
					Date CreatedOnDate  = formater2.parse(createdOn);
					if(oldMaturity.isEmpty()){
						startDate = createdOn;
						
					}
					else{
						startDate = createdOn;
						Date oldMaturityDate = formater2.parse(oldMaturity);
						if(CreatedOnDate.equals(oldMaturityDate)){
							startDate = createdOn;
						}
						else{
							startDate = oldMaturity;
						}
					}

		
					
					EIBOR.mLogger.info("Amount--"+i+" row-----"+amount);
					EIBOR.mLogger.info("inside loop for date comparison--");
					
					SimpleDateFormat formater1 = new SimpleDateFormat("yyyy-MM-dd");
					Date duedate = formater1.parse(dueDate);
					
				
					Date valuedate = formater2.parse(startDate);
					
					LocalDate start = LocalDate.parse(startDate);
					LocalDate end = LocalDate.parse(dueDate);
					
					Date currentdate = new Date();
				
					long datediffIndays = ChronoUnit.DAYS.between(start, end);
					
					LocalDate yesterdayDate = LocalDate.now().minusDays(1);
					Date yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
					
					String dayOfWeek = yesterdayDate.getDayOfWeek().toString();
					EIBOR.mLogger.info("Day of Yesterday date--"+dayOfWeek);
					String sunday = "SUNDAY";
					if(sunday.equalsIgnoreCase(dayOfWeek)){
						yesterdayDate = LocalDate.now().minusDays(2);
						yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
					}
					EIBOR.mLogger.info("Yesterday date--"+yesterdayDatee);
					
					
					EIBOR.mLogger.info("Due Date---"+duedate);
					EIBOR.mLogger.info("Current Date---"+currentdate);
					EIBOR.mLogger.info("inside loop data fetched successfully");
					
					obj.put("Counterparty",counterParty);
					obj.put("Contract Rate",contractRate);
					obj.put("Start Date",startDate);
					obj.put("Due Date",dueDate);
					obj.put("Amount (AED MLN)",amount);
					obj.put("Account",account);
					//obj.put("Currency",currency);
					obj.put("Source File Name",filename);
					
					if(valuedate.before(currentdate) || valuedate.equals(currentdate)){
						EIBOR.mLogger.info("Inside if for load Future Deal ---OK");
						obj.put("Future Deal","OK");
						
					}
					else{
						EIBOR.mLogger.info("Inside else for load Future Deal ---Future Deal");
						obj.put("Future Deal","Future Deal");
					}
					
					obj.put("Tenor Calendar Days",datediffIndays);
					
					if(yesterdayDatee.equals(valuedate)){
						EIBOR.mLogger.info("Inside if for load To be Reported ---Yes");
						obj.put("To Be Reported ?","Yes");
					}
					else{
						EIBOR.mLogger.info("Inside else for load To be Reported ---NA");
						obj.put("To Be Reported ?","Not Applicable");
					}
					
					
					
					if(datediffIndays>=1 && datediffIndays<=3){
						obj.put("Final Tenor Bucket","O/N");				
					}
					else if(datediffIndays>=5 && datediffIndays<=10){
						obj.put("Final Tenor Bucket","1W");				
					}
					else if(datediffIndays>=25 && datediffIndays<=35){
						obj.put("Final Tenor Bucket","1M");				
					}
					else if(datediffIndays>=80 && datediffIndays<=100){
						obj.put("Final Tenor Bucket","3M");				
					}
					else if(datediffIndays>=150 && datediffIndays<=210){
						obj.put("Final Tenor Bucket","6M");				
					}
					else if(datediffIndays>=330 && datediffIndays<=390){
						obj.put("Final Tenor Bucket","1Y");				
					}
					jsonArray.add(obj);
					ifr.addDataToGrid("NG_EIBOR_GRID_DF2_DEALS", jsonArray);
					
					obj=new JSONObject();
					jsonArray=new JSONArray();
				}
				EIBOR.mLogger.info("Fincale Map Record: "+finacleRecord);
			}
			
			obj=new JSONObject();
			jsonArray=new JSONArray();
			
			query = "select * from NG_EIBOR_BE_DF2_BACKDATED_DEPOSITS where cast(inserted_date as date) = cast(GETDATE() as date) and cast(Received_On as date) = cast(GETDATE() as date)";
			@SuppressWarnings("unchecked")
			List<List<String>> dataFromDB = ifr.getDataFromDB(query);
			int listSize = dataFromDB.size();
			if(listSize>0){
				EIBOR.mLogger.info("DF2Deals Grid,dataFromDB: "+dataFromDB);
				for(int i=0;i<listSize;i++){		
				
					
					EIBOR.mLogger.info("inside loop in load data in DF2Deals Grid--");
					String counterParty = dataFromDB.get(i).get(1);
					String contractRate = dataFromDB.get(i).get(13);
					String startDate = dataFromDB.get(i).get(7);
					String maturityDate = dataFromDB.get(i).get(8);
					String amount = dataFromDB.get(i).get(10).replaceAll(",","");
					String account = dataFromDB.get(i).get(0);
					String currency = dataFromDB.get(i).get(9);
					String filename = dataFromDB.get(i).get(18);
					
					if(arraylist.contains(counterParty)){
						continue;						
					}
					EIBOR.mLogger.info("Map Value in DF2---"+finacleRecord.get(counterParty));
					if(finacleRecord.containsKey(counterParty)){
						EIBOR.mLogger.info("Map Value in DF2---"+finacleRecord.get(counterParty));
						if(finacleRecord.get(counterParty).equalsIgnoreCase(account)){
							continue;
						}
					}
					
					EIBOR.mLogger.info("inside loop for date comparison--");

					SimpleDateFormat formater1 = new SimpleDateFormat("yyyy-MM-dd");
					Date duedate = formater1.parse(maturityDate);
					
					SimpleDateFormat formater2 = new SimpleDateFormat("yyyy-MM-dd");
					Date valuedate = formater2.parse(startDate);
					
					LocalDate start = LocalDate.parse(startDate);
					LocalDate end = LocalDate.parse(maturityDate);
								
					Date currentdate = new Date();
					
					long datediffIndays = ChronoUnit.DAYS.between(start, end);
					
					LocalDate yesterdayDate = LocalDate.now().minusDays(1);
					Date yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
					
					String dayOfWeek = yesterdayDate.getDayOfWeek().toString();
					EIBOR.mLogger.info("Day of Yesterday date--"+dayOfWeek);
					String sunday = "SUNDAY";
					if(sunday.equalsIgnoreCase(dayOfWeek)){
						yesterdayDate = LocalDate.now().minusDays(2);
						yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
					}
					EIBOR.mLogger.info("Yesterday date--"+yesterdayDatee);
					
					EIBOR.mLogger.info("Due Date---"+duedate);
					EIBOR.mLogger.info("Current Date---"+currentdate);
					EIBOR.mLogger.info("inside loop data fetched successfully");
					
					obj.put("Counterparty",counterParty);
					obj.put("Contract Rate",contractRate);
					obj.put("Start Date",startDate);
					obj.put("Due Date",maturityDate);
					obj.put("Amount (AED MLN)",amount);
					obj.put("Account",account);
					obj.put("Currency",currency);
					obj.put("Source File Name",filename);
					
					
					if(valuedate.before(currentdate) || valuedate.equals(currentdate)){
						EIBOR.mLogger.info("Inside if for load Future Deal ---OK");
						obj.put("Future Deal","OK");
						
					}
					else{
						EIBOR.mLogger.info("Inside else for load Future Deal ---Future Deal");
						obj.put("Future Deal","Future Deal");
					}
					
					obj.put("Tenor Calendar Days",datediffIndays);
					
					if(yesterdayDatee.equals(valuedate)){
						EIBOR.mLogger.info("Inside if for load To be Reported ---Yes");
						obj.put("To Be Reported ?","Yes");
						
					}
					else{
						EIBOR.mLogger.info("Inside else for load To be Reported ---NA");
						obj.put("To Be Reported ?","Not Applicable");
					}
	
					if(datediffIndays>=1 && datediffIndays<=3){
						obj.put("Final Tenor Bucket","O/N");				
					}
					else if(datediffIndays>=5 && datediffIndays<=10){
						obj.put("Final Tenor Bucket","1W");				
					}
					else if(datediffIndays>=25 && datediffIndays<=35){
						obj.put("Final Tenor Bucket","1M");				
					}
					else if(datediffIndays>=80 && datediffIndays<=100){
						obj.put("Final Tenor Bucket","3M");				
					}
					else if(datediffIndays>=150 && datediffIndays<=210){
						obj.put("Final Tenor Bucket","6M");				
					}
					else if(datediffIndays>=330 && datediffIndays<=390){
						obj.put("Final Tenor Bucket","1Y");				
					}
					jsonArray.add(obj);
					ifr.addDataToGrid("NG_EIBOR_GRID_DF2_DEALS", jsonArray);
					
					obj=new JSONObject();
					jsonArray=new JSONArray();
				}
				
				EIBOR.mLogger.info("exit from for loop");
				EIBOR.mLogger.info("data added to grid DF2Deals successfully--");
			}

			EIBOR.mLogger.info("inside try load data in DF2Deals Grid with flexcube report--");
			jsonArray=new JSONArray();
			obj=new JSONObject(); 		
			query = "select * from NG_EIBOR_BE_FLEXCUBE_BO_DATA where cast(inserted_date as date) = cast(GETDATE() as date) and cast(Received_On as date) = cast(GETDATE() as date)";
			@SuppressWarnings("unchecked")
			List<List<String>> flexcubeDataFromDB = ifr.getDataFromDB(query);
			int flexcubelistSize = flexcubeDataFromDB.size();
			if(flexcubelistSize > 0){
				EIBOR.mLogger.info("DF2Deals Grid,flexcubeDataFromDB: "+flexcubeDataFromDB);
				for(int i=0;i<flexcubelistSize;i++){		
					EIBOR.mLogger.info("inside loop in load data in DF2Deals Grid--");
					String counterParty = flexcubeDataFromDB.get(i).get(1);
					String contractRate = flexcubeDataFromDB.get(i).get(12);
					String startDate = flexcubeDataFromDB.get(i).get(5);
					String dueDate = flexcubeDataFromDB.get(i).get(8);
					String amount = flexcubeDataFromDB.get(i).get(14).replaceAll(",","");
					String account = flexcubeDataFromDB.get(i).get(0);
					String currency = flexcubeDataFromDB.get(i).get(13);
					String filename = flexcubeDataFromDB.get(i).get(18);
					
					if(arraylist.contains(counterParty)){
						continue;						
					}
					
					EIBOR.mLogger.info("inside loop for date comparison--");
					
					SimpleDateFormat formater1 = new SimpleDateFormat("yyyy-MM-dd");
					Date duedate = formater1.parse(dueDate);
					
					SimpleDateFormat formater2 = new SimpleDateFormat("yyyy-MM-dd");
					Date valuedate = formater2.parse(startDate);
					
					LocalDate start = LocalDate.parse(startDate);
					LocalDate end = LocalDate.parse(dueDate);
								
					Date currentdate = new Date();
					
					long datediffIndays = ChronoUnit.DAYS.between(start, end);;	
					
					LocalDate yesterdayDate = LocalDate.now().minusDays(1);
					Date yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
					
					String dayOfWeek = yesterdayDate.getDayOfWeek().toString();
					EIBOR.mLogger.info("Day of Yesterday date--"+dayOfWeek);
					String sunday = "SUNDAY";
					if(sunday.equalsIgnoreCase(dayOfWeek)){
						yesterdayDate = LocalDate.now().minusDays(2);
						yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
					}
					EIBOR.mLogger.info("Yesterday date--"+yesterdayDatee);
					
					EIBOR.mLogger.info("Due Date---"+duedate);
					EIBOR.mLogger.info("Current Date---"+currentdate);
					EIBOR.mLogger.info("inside loop data fetched successfully");
					
					obj.put("Counterparty",counterParty);
					obj.put("Contract Rate",contractRate);
					obj.put("Start Date",startDate);
					obj.put("Due Date",dueDate);
					obj.put("Amount (AED MLN)",amount);
					obj.put("Account",account);
					obj.put("Currency",currency);
					obj.put("Source File Name",filename);
					
					if(valuedate.before(currentdate) || valuedate.equals(currentdate)){
						EIBOR.mLogger.info("Inside if for load Future Deal ---OK");
						obj.put("Future Deal","OK");
						
					}
					else{
						EIBOR.mLogger.info("Inside else for load Future Deal ---Future Deal");
						obj.put("Future Deal","Future Deal");
					}
					
					obj.put("Tenor Calendar Days",datediffIndays);
					
					if(yesterdayDatee.equals(valuedate)){
						EIBOR.mLogger.info("Inside if for load To be Reported ---Yes");
						obj.put("To Be Reported ?","Yes");
					}
					else{
						EIBOR.mLogger.info("Inside else for load To be Reported ---NA");
						obj.put("To Be Reported ?","Not Applicable");
					}
					
					
					
					if(datediffIndays>=1 && datediffIndays<=3){
						obj.put("Final Tenor Bucket","O/N");				
					}
					else if(datediffIndays>=5 && datediffIndays<=10){
						obj.put("Final Tenor Bucket","1W");				
					}
					else if(datediffIndays>=25 && datediffIndays<=35){
						obj.put("Final Tenor Bucket","1M");				
					}
					else if(datediffIndays>=80 && datediffIndays<=100){
						obj.put("Final Tenor Bucket","3M");				
					}
					else if(datediffIndays>=150 && datediffIndays<=210){
						obj.put("Final Tenor Bucket","6M");				
					}
					else if(datediffIndays>=330 && datediffIndays<=390){
						obj.put("Final Tenor Bucket","1Y");				
					}
					jsonArray.add(obj);
					ifr.addDataToGrid("NG_EIBOR_GRID_DF2_DEALS", jsonArray);
					
					obj=new JSONObject();
					jsonArray=new JSONArray();
				}	
			}	
			
			EIBOR.mLogger.info("inside try load data in DF2Deals Grid with FAS MM report--");
			jsonArray=new JSONArray();
			obj=new JSONObject(); 		
			query = "select * from NG_EIBOR_BE_FAS_MM_DEALS where cast(inserted_date as date) = cast(GETDATE() as date) and cast(Received_On as date) = cast(GETDATE() as date) and OptKey3 in ('Conv-Instl-Deposit-FI','Conv-Instl-Deposit-CBD','IIWD-Islamic Instl Wakala Deposit')";
			EIBOR.mLogger.info("Query of MM grid : "+query);
			@SuppressWarnings("unchecked")			
			List<List<String>> mmDataFromDB = ifr.getDataFromDB(query);
			EIBOR.mLogger.info("Data fetch from DB : "+mmDataFromDB);
			int mmDataFromDBListSize = mmDataFromDB.size();
			if(mmDataFromDBListSize > 0){
				EIBOR.mLogger.info("DF2Deals Grid,mmDataFromDB: "+mmDataFromDB);
				for(int i=0;i<mmDataFromDBListSize;i++){		
					EIBOR.mLogger.info("inside loop in load data in DF2Deals Grid--");
					String counterParty = mmDataFromDB.get(i).get(8);
					String contractRate = mmDataFromDB.get(i).get(5);
					String startDate = mmDataFromDB.get(i).get(6);
					String dueDate = mmDataFromDB.get(i).get(7);
					String amount = mmDataFromDB.get(i).get(4).replaceAll(",","");
					
					
					
					
					EIBOR.mLogger.info("inside loop for date comparison--");
					
					SimpleDateFormat formater1 = new SimpleDateFormat("yyyy-MM-dd");
					Date duedate = formater1.parse(dueDate);
					
					SimpleDateFormat formater2 = new SimpleDateFormat("yyyy-MM-dd");
					Date valuedate = formater2.parse(startDate);
					
					LocalDate start = LocalDate.parse(startDate);
					LocalDate end = LocalDate.parse(dueDate);
								
					Date currentdate = new Date();
					
					long datediffIndays = ChronoUnit.DAYS.between(start, end);;	
					
					LocalDate yesterdayDate = LocalDate.now().minusDays(1);
					Date yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
					
					String dayOfWeek = yesterdayDate.getDayOfWeek().toString();
					EIBOR.mLogger.info("Day of Yesterday date--"+dayOfWeek);
					String sunday = "SUNDAY";
					if(sunday.equalsIgnoreCase(dayOfWeek)){
						yesterdayDate = LocalDate.now().minusDays(2);
						yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
					}
					EIBOR.mLogger.info("Yesterday date--"+yesterdayDatee);
					
					EIBOR.mLogger.info("Due Date---"+duedate);
					EIBOR.mLogger.info("Current Date---"+currentdate);
					EIBOR.mLogger.info("inside loop data fetched successfully");
					
					obj.put("Counterparty",counterParty);
					obj.put("Contract Rate",contractRate);
					obj.put("Start Date",startDate);
					obj.put("Due Date",dueDate);
					obj.put("Amount (AED MLN)",amount);
					
					
					
					if(valuedate.before(currentdate) || valuedate.equals(currentdate)){
						EIBOR.mLogger.info("Inside if for load Future Deal ---OK");
						obj.put("Future Deal","OK");
						
					}
					else{
						EIBOR.mLogger.info("Inside else for load Future Deal ---Future Deal");
						obj.put("Future Deal","Future Deal");
					}
					
					obj.put("Tenor Calendar Days",datediffIndays);
					
					if(yesterdayDatee.equals(valuedate)){
						EIBOR.mLogger.info("Inside if for load To be Reported ---Yes");
						obj.put("To Be Reported ?","Yes");
					}
					else{
						EIBOR.mLogger.info("Inside else for load To be Reported ---NA");
						obj.put("To Be Reported ?","Not Applicable");
					}
					
					
					
					if(datediffIndays>=1 && datediffIndays<=3){
						obj.put("Final Tenor Bucket","O/N");				
					}
					else if(datediffIndays>=5 && datediffIndays<=10){
						obj.put("Final Tenor Bucket","1W");				
					}
					else if(datediffIndays>=25 && datediffIndays<=35){
						obj.put("Final Tenor Bucket","1M");				
					}
					else if(datediffIndays>=80 && datediffIndays<=100){
						obj.put("Final Tenor Bucket","3M");				
					}
					else if(datediffIndays>=150 && datediffIndays<=210){
						obj.put("Final Tenor Bucket","6M");				
					}
					else if(datediffIndays>=330 && datediffIndays<=390){
						obj.put("Final Tenor Bucket","1Y");				
					}
					jsonArray.add(obj);
					ifr.addDataToGrid("NG_EIBOR_GRID_DF2_DEALS", jsonArray);
					
					obj=new JSONObject();
					jsonArray=new JSONArray();
				}	
			}	
			
		}
		catch (Exception e)
		{
			EIBOR.mLogger.info("Exception inside load data in DF2Deals Grid--:- "+e.toString());
		}
		return "";
	}
	
	
	public static String dataLoadInMM(IFormReference ifr)
	{
		EIBOR.mLogger.info("inside load data in MM Grid--");
		
		try 
		{
			EIBOR.mLogger.info("inside try load data in MM Grid--");
			JSONArray jsonArray=new JSONArray();
			JSONObject obj=new JSONObject();			
			String query = "select * from NG_EIBOR_BE_FAS_MM_DEALS where cast(inserted_date as date) = cast(GETDATE() as date) and cast(Received_On as date) = cast(GETDATE() as date) and OptKey3 not in ('Conv-Instl-Deposit-FI','Conv-Instl-Deposit-CBD','IIWD-Islamic Instl Wakala Deposit')";
			@SuppressWarnings("unchecked")
			List<List<String>> dataFromDB = ifr.getDataFromDB(query);
			int listSize = dataFromDB.size();
			String queryForExceptionCases = "select * from NG_EIBOR_MASTER_SKIP_PARTY where isActive = 'N'";
			@SuppressWarnings("unchecked")
			List<List<String>> dataFromDB1 = ifr.getDataFromDB(queryForExceptionCases);
			int listSize1 = dataFromDB1.size();
			EIBOR.mLogger.info("Size of skip paty list: "+listSize1);
			ArrayList<String> arraylist = new ArrayList<String>(20);
			
			for(int m =0;m<listSize1;m++){
				String counterParty = dataFromDB1.get(m).get(0);
				arraylist.add(counterParty);
			}
			EIBOR.mLogger.info("ArrayList contains: "+arraylist);
			
			if(listSize > 0){
				EIBOR.mLogger.info("MM Grid,dataFromDB: "+dataFromDB);
				
				for(int j=0;j<listSize;j++){		
					EIBOR.mLogger.info("inside loop in load data in MM Grid--");
					String fulldepoNo = dataFromDB.get(j).get(0);
					String depoNo = fulldepoNo.substring(15);
					String depoDate = dataFromDB.get(j).get(1);
					String depoType = dataFromDB.get(j).get(2);
					String principal = dataFromDB.get(j).get(4).replaceAll(",","");
					String rate = dataFromDB.get(j).get(5);
					String valueDate = dataFromDB.get(j).get(6);
					String dueDate = dataFromDB.get(j).get(7);
					String cptyCode = dataFromDB.get(j).get(8);
					
				
					
					if(arraylist.contains(cptyCode)){
						continue;
						
					}
					
					
					EIBOR.mLogger.info("Amount--"+j+" row-----"+principal);
					EIBOR.mLogger.info("inside loop for date comparison MM Grid--");
					
					SimpleDateFormat formater1 = new SimpleDateFormat("yyyy-MM-dd");
					Date duedate = formater1.parse(dueDate);
					
					
					SimpleDateFormat formater2 = new SimpleDateFormat("yyyy-MM-dd");
					Date valuedate = formater2.parse(valueDate);
					
					SimpleDateFormat formater3  = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");				
					Date dateTime = formater3.parse(depoDate);
					
					
					EIBOR.mLogger.info("Depo date with Time "+dateTime);
					
					LocalDate startd = LocalDate.parse(valueDate);
					LocalDate endd = LocalDate.parse(dueDate);
								
					Date currentdate = new Date();
					
				
					long tenorCalenderDays = ChronoUnit.DAYS.between(startd, endd);
					EIBOR.mLogger.info("Teno Calendar days "+tenorCalenderDays);
					
					LocalDate yesterdayDate = LocalDate.now().minusDays(1);
					Date yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
					
					LocalDate current = LocalDate.now();
					Date currentd = java.sql.Date.valueOf(current);
					Date currentDate = formater2.parse(current.toString());
					Date currentWithTime = dateToDateTime(ifr,currentDate);
					EIBOR.mLogger.info("Current Date with 11am time "+currentWithTime);
					
					Date yesterday = formater2.parse(yesterdayDate.toString());
					Date yesterdayWithTime = dateToDateTime(ifr,yesterday);
					EIBOR.mLogger.info("Yesterday date--"+yesterdayDatee);					
					EIBOR.mLogger.info("Yesterday date with 11 am time--"+yesterdayWithTime);
					long workingDays = workingDays(startd, endd, ifr);
					EIBOR.mLogger.info("Working Days exclude Sunday and Holidays---"+workingDays);
								
					long businessDays = workingDays;
					EIBOR.mLogger.info("Business Days---"+businessDays);
					
					EIBOR.mLogger.info("Due Date MM Grid---"+duedate);
					EIBOR.mLogger.info("Current Date MM Grid---"+currentdate);
					EIBOR.mLogger.info("inside loop data fetched successfully");
					
					obj.put("Depo_no",depoNo);
					obj.put("Depo_date",depoDate);
					obj.put("Depo_type",depoType);
					obj.put("Principal",principal);
					obj.put("Int_rate",rate);
					obj.put("Value_date",valueDate);
					obj.put("Due_date",dueDate);
					obj.put("Cpty_code",cptyCode);
									
					if(valuedate.before(currentdate) || valuedate.equals(currentdate)){
						EIBOR.mLogger.info("Inside if for load Future Deal in MM---OK");
						obj.put("Future Deal","OK");
						
					}
					else{
						EIBOR.mLogger.info("Inside else for load Future Deal in MM ---Future Deal");
						obj.put("Future Deal","Future Deal");
					}
					
					obj.put("Tenor Calendar Days",tenorCalenderDays);
					
					
					if(tenorCalenderDays<3 && tenorCalenderDays>0){
						obj.put("Tenor Business Days",tenorCalenderDays);	
					}
					else{
						obj.put("Tenor Business Days",businessDays);
					}
					
					if((yesterdayDatee.equals(valuedate)) || (yesterdayWithTime.before(dateTime) && currentWithTime.after(dateTime))){
						EIBOR.mLogger.info("Inside if for load To be Reported in MM ---Yes");
						obj.put("To Be Reported ?","Yes");
					}
					
					else{
						EIBOR.mLogger.info("Inside else for load To be Reported in MM---NA");
						obj.put("To Be Reported ?","Not Applicable");
					}
							
					if(businessDays>=1 && businessDays<=3){
						obj.put("Final Tenor Bucket","O/N");
						
					}
					else if(businessDays>=5 && businessDays<=10){
						obj.put("Final Tenor Bucket","1W");	
						
					}
					else if(tenorCalenderDays>=25 && tenorCalenderDays<=35){
						obj.put("Final Tenor Bucket","1M");	
						
					}
					else if(tenorCalenderDays>=80 && tenorCalenderDays<=100){
						obj.put("Final Tenor Bucket","3M");	
						
					}
					else if(tenorCalenderDays>=150 && tenorCalenderDays<=210){
						obj.put("Final Tenor Bucket","6M");	
						
					}
					else if(tenorCalenderDays>=330 && tenorCalenderDays<=390){
						obj.put("Final Tenor Bucket","1Y");	
						
					}
					

					jsonArray.add(obj);
					ifr.addDataToGrid("NG_EIBOR_GRID_MM", jsonArray);
					
					obj=new JSONObject();
					jsonArray=new JSONArray();
				}
			

				EIBOR.mLogger.info("exit from for loop");
				EIBOR.mLogger.info("data added to grid MM successfully--");
				
			}
			
		}
		catch (Exception e)
		{
			EIBOR.mLogger.info("Exception inside load data in MM Grid-:- "+e.toString());
		}
		return "";
	}
	

	
	public static String dataLoadInPartyQuotes(IFormReference ifr)
	{
		
		EIBOR.mLogger.info("inside load data in Party Quotes Grid--");
		
		try 
		{
			EIBOR.mLogger.info("inside try load data in Party Quotes Grid--");
			ifr.clearTable("NG_EIBOR_GRID_THIRD_PARTY_QUOTES");
			JSONArray jsonArray=new JSONArray();
			JSONObject obj=new JSONObject();
			String query = "select * from NG_EIBOR_BE_BCG_BROKER_RATES where cast(inserted_date as date) = cast(GETDATE() as date) and cast(Received_On as date) = cast(GETDATE() as date)";
			@SuppressWarnings("unchecked")
			List<List<String>> dataFromDB = ifr.getDataFromDB(query);
			EIBOR.mLogger.info("dataFromDB--"+dataFromDB);
			int listSizeBgc = dataFromDB.size();
			EIBOR.mLogger.info("listSize--"+listSizeBgc);
			String queryIcap = "select * from NG_EIBOR_BE_ICAP_BROKER_RATES where cast(inserted_date as date) = cast(GETDATE() as date) and cast(Received_On as date) = cast(GETDATE() as date)";
			@SuppressWarnings("unchecked")
			List<List<String>> dataFromDB1 = ifr.getDataFromDB(queryIcap);
			EIBOR.mLogger.info("ICAP dataFromDB--"+dataFromDB1);	
			int listSizeIcap = dataFromDB1.size();
			String newquery  = "select TOP 8 AED_Deposits from NG_EIBOR_BE_ICAP_BROKER_RATES";
			@SuppressWarnings("unchecked")
			List<List<String>> dataFromDBForTenor = ifr.getDataFromDB(newquery);
			
			for(int i =0;i<8;i++){
				double newBcgBid =0;
				double newBcgOffer =0;
				double midBcg =0;
				double newIcapBid =0;
				double newIcapOffer =0;
				double midIcap =0;
				double avg = 0;
				String finalMidBcg = null;
				String finalMidIcap = null;
				String finalAvg=null;
				if(i==2 || i==4){
					continue;
				}
				String tenor = "";
				String IcapBid = "";
				String IcapOffer = "";
				String bcgBid = "";
				String bcgOffer = "";
				
				if(listSizeIcap==0 && listSizeBgc!=0){
					tenor = dataFromDB.get(i).get(0);
					IcapBid = "0";
					IcapOffer = "0";
					bcgBid = dataFromDB.get(i).get(1);	
					bcgOffer = dataFromDB.get(i).get(2);
				}else if(listSizeBgc==0 && listSizeIcap!=0){
					tenor = dataFromDB1.get(i).get(0);
					bcgBid = "0";
					bcgOffer = "0";
					IcapBid = dataFromDB1.get(i).get(1);
					IcapOffer = dataFromDB1.get(i).get(2);
				}else if(listSizeBgc!=0 && listSizeIcap!=0){
					tenor = dataFromDB.get(i).get(0);
					bcgBid = dataFromDB.get(i).get(1);	
					bcgOffer = dataFromDB.get(i).get(2);
					IcapBid = dataFromDB1.get(i).get(1);
					IcapOffer = dataFromDB1.get(i).get(2);
				}else{
					
					tenor = dataFromDBForTenor.get(i).get(0);
					bcgBid = "0";	
					bcgOffer = "0";
					IcapBid = "0";
					IcapOffer = "0";
				}
				
				
				EIBOR.mLogger.info("Tenor--"+tenor);
											
				newBcgBid = Double.parseDouble(bcgBid);
			    EIBOR.mLogger.info("Bid BCG--"+newBcgBid);
			    newBcgOffer = Double.parseDouble(bcgOffer);
			    EIBOR.mLogger.info("Offer BCG--"+newBcgOffer);
			    newIcapBid = Double.parseDouble(IcapBid);
			    EIBOR.mLogger.info("Bid ICAP--"+newIcapBid);
			    newIcapOffer = Double.parseDouble(IcapOffer);
			    EIBOR.mLogger.info("Offer ICAP--"+newIcapOffer);
			    
			    DecimalFormat df = new DecimalFormat("0.00000");
			    midBcg = (newBcgBid + newBcgOffer)/2;
			    EIBOR.mLogger.info("mid BCG--"+midBcg);
			    finalMidBcg = df.format(midBcg);
			   			  
			    midIcap = (newIcapBid + newIcapOffer)/2;
			    EIBOR.mLogger.info("mid ICAP--"+midIcap);
			    finalMidIcap = df.format(midIcap);
				
				if(listSizeIcap==0 && listSizeBgc!=0){
					avg = midBcg;					
				}else if(listSizeBgc==0 && listSizeIcap!=0){
					avg = midIcap;
									
				}else if(listSizeBgc!=0 && listSizeIcap!=0){
					avg = (midBcg+midIcap)/2;
										
				}else{
					avg = 0;
				}
				EIBOR.mLogger.info("Average of BCG & ICAP--"+avg);
				finalAvg = df.format(avg);
			    			    
			    obj.put("Tenor",tenor);
				obj.put("BCG",finalMidBcg);
				obj.put("ICAP",finalMidIcap);
				obj.put("Average", finalAvg);
				
				jsonArray.add(obj);
				ifr.addDataToGrid("NG_EIBOR_GRID_THIRD_PARTY_QUOTES", jsonArray);
				
				obj=new JSONObject();
				jsonArray=new JSONArray();					
			}
			
									
			
			EIBOR.mLogger.info("exit from for loop");
			EIBOR.mLogger.info("data added to grid THIRD PARTY from ICAP successfully--");
			
		
		}
		catch (Exception e)
		{
			EIBOR.mLogger.info("Exception inside load data in THIRD PARTY-:- "+e.toString());
		}
		return "";
	}
	
	
	public static String dataLoadInBB(IFormReference ifr)
	{
	
		try 
		{
			EIBOR.mLogger.info("inside try load data in BB Grid--");
				
			JSONArray jsonArray=new JSONArray();
			JSONObject obj=new JSONObject();
			String query = "select Tenor from NG_EIBOR_MAST_TENOR_BUCKETING";
			@SuppressWarnings("unchecked")
			List<List<String>> dataFromDB = ifr.getDataFromDB(query);
			EIBOR.mLogger.info("dataFromDB--"+dataFromDB);
			int listSize = dataFromDB.size();
			EIBOR.mLogger.info("listSize--"+listSize);
			if(listSize>0){
				for(int i =0;i<listSize;i++){
					
					String tenor = dataFromDB.get(i).get(0);		    
				    obj.put("Tenor",tenor);										
					jsonArray.add(obj);
					ifr.addDataToGrid("NG_EIBOR_GRID_BB_LIBOR_FW_RATES", jsonArray);
					ifr.addDataToGrid("NG_EIBOR_GRID_DF3", jsonArray);
					ifr.addDataToGrid("NG_EIBOR_GRID_FINAL_SUMMARY", jsonArray);

					obj=new JSONObject();
					jsonArray=new JSONArray();					
				}					
			}		
		}
		catch (Exception e)
		{
			EIBOR.mLogger.info("Exception inside load data in THIRD PARTY-:- "+e.toString());
		}
		return "";
	}	
	
	
	public static String dataLoadInAllCommonGrid(IFormReference ifr)
	{
		
		EIBOR.mLogger.info("inside load data in HIST IB Grid--");
		
		try 
		{
			EIBOR.mLogger.info("inside try load data in HIST IB Grid--");
			JSONArray jsonArray=new JSONArray();
			JSONObject obj=new JSONObject();
			String query1 = "select * from NG_EIBOR_DF1_MAST";
			@SuppressWarnings("unchecked")
			List<List<String>> dataFromDB1 = ifr.getDataFromDB(query1);
			int listSize1 = dataFromDB1.size();
			for(int i =0;i<listSize1;i++){
				String ten = dataFromDB1.get(i).get(0);
				String eib = dataFromDB1.get(i).get(1);
					
				obj.put("Tenor",ten);
				obj.put("EIBOR rate for Today",eib);
				
				jsonArray.add(obj);
				ifr.addDataToGrid("NG_EIBOR_GRID_History_IB_DATA", jsonArray);
				ifr.addDataToGrid("NG_EIBOR_GRID_History_CUST_DATA", jsonArray);
				ifr.addDataToGrid("NG_EIBOR_GRID_DF1", jsonArray);
				ifr.addDataToGrid("NG_EIBOR_GRID_DF2", jsonArray);
				
				
				obj=new JSONObject();
				jsonArray=new JSONArray();
				
			}

			EIBOR.mLogger.info("exit from for loop");
			EIBOR.mLogger.info("data added to grid HIST IB successfully--");
		
		}
		catch (Exception e)
		{
			EIBOR.mLogger.info("Exception inside load data in HIST IB Grid-:- "+e.toString());
		}
		return "";
	}
	
	
	public static String dataLoadInDF1Repe(IFormReference ifr)
	{
	
		try 
		{
			EIBOR.mLogger.info("inside try load data in DF1 Repetetive Grid--");
			JSONArray jsonArray=new JSONArray();
			JSONArray jsonArray1 = new JSONArray();
			JSONObject obj=new JSONObject();

			jsonArray = ifr.getDataFromGrid("NG_EIBOR_GRID_MM"); 
			String arr[][] = new String[1000][13]  ;
			int length = jsonArray.size();
			LocalDate yesterdayDate = LocalDate.now().minusDays(1);
			Date yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
			DateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
			LocalDate current = LocalDate.now();
			
			Date currentDate = formater.parse(current.toString());
			Date currentWithTime = dateToDateTime(ifr,currentDate);
			EIBOR.mLogger.info("Current date with 11am--"+currentWithTime);
			
			
			Date yesterday = formater.parse(yesterdayDate.toString());
			Date yesterdayWithTime = dateToDateTime(ifr,yesterday);
			EIBOR.mLogger.info("Yesterday date with 11 am--"+yesterdayWithTime);
			EIBOR.mLogger.info("json Array Size--"+length);
			for(int i=0;i<length;i++){				
				for(int j=0;j<13;j++){
					EIBOR.mLogger.info("inside loop for fetching column"+i+"<<:i and j>>:"+j);
					arr[i][j] = ifr.getTableCellValue("NG_EIBOR_GRID_MM",i,j);
					EIBOR.mLogger.info("Array of data for each row--"+arr[i][j]);					 
				}
				String valueDate = arr[i][5];
				String datetime = arr[i][1];
				
				Date newValueDate = (Date)formater.parse(valueDate);
				SimpleDateFormat formater3  = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");				
				Date dateTime = formater3.parse(datetime);	
				EIBOR.mLogger.info("Depo date time--"+dateTime);
				
				
				
				if(arr[i][11].equalsIgnoreCase("Yes")){
					if(yesterdayWithTime.before(dateTime) && currentWithTime.after(dateTime)){
						String counterParty = arr[i][7];
						EIBOR.mLogger.info("Counter Party--"+i+":"+counterParty);
						String amount = arr[i][3];
						EIBOR.mLogger.info("amount--"+i+":"+amount);
						String contractRate = arr[i][4];
						EIBOR.mLogger.info("Contarct rate--"+i+":"+contractRate);
						String startdate = arr[i][5];
						EIBOR.mLogger.info("start date--"+i+":"+startdate);
						String dueDate = arr[i][6];
						EIBOR.mLogger.info("due date--"+i+":"+dueDate);
						String tenor = arr[i][10];
						EIBOR.mLogger.info("Tenor--"+i+":"+tenor);
						
						String newStartDate = startdate.replace("-","/");
						EIBOR.mLogger.info("inside loop Startdate after replace-->"+newStartDate);
						String newDueDate = dueDate.replace("-","/");
						EIBOR.mLogger.info("inside loop Duedate after replace-->"+newDueDate);
						String[] startDateSplit = newStartDate.split("/");
						String finalStartDate = startDateSplit[2]+"/"+startDateSplit[1]+"/"+startDateSplit[0];
						EIBOR.mLogger.info("Final Start Date DF1 Repe Grid-->"+finalStartDate);
						String[] dueDateSplit = newDueDate.split("/");
						String finaldueDate = dueDateSplit[2]+"/"+dueDateSplit[1]+"/"+dueDateSplit[0];
						EIBOR.mLogger.info("Final Due Date DF1 Repe Grid -->"+finaldueDate);
						
						obj.put("Counter Party", counterParty);
						obj.put("Contract Rate", contractRate);
						obj.put("Start Date", finalStartDate);
						obj.put("Due Date", finaldueDate);
						obj.put("Amount", amount);
						
						jsonArray1.add(obj);
						
						if(tenor.equalsIgnoreCase("O/N")){
							ifr.setStyle("NG_EIBOR_GRID_DF1_REPETETIVE","visible","true");
							ifr.addDataToGrid("NG_EIBOR_GRID_DF1_REPETETIVE", jsonArray1);
						}
						if(tenor.equalsIgnoreCase("1W")){
							ifr.setStyle("NG_EIBOR_GRID_DF1_REPETETIVE_OW","visible","true");
							ifr.addDataToGrid("NG_EIBOR_GRID_DF1_REPETETIVE_OW", jsonArray1);
						}
						if(tenor.equalsIgnoreCase("1M")){
							ifr.setStyle("NG_EIBOR_GRID_DF1_REPETETIVE_OM","visible","true");
							ifr.addDataToGrid("NG_EIBOR_GRID_DF1_REPETETIVE_OM", jsonArray1);
						}
						if(tenor.equalsIgnoreCase("3M")){
							ifr.setStyle("NG_EIBOR_GRID_DF1_REPETETIVE_TM","visible","true");
							ifr.addDataToGrid("NG_EIBOR_GRID_DF1_REPETETIVE_TM", jsonArray1);
						}
						if(tenor.equalsIgnoreCase("6M")){
							ifr.setStyle("NG_EIBOR_GRID_DF1_REPETETIVE_SM","visible","true");
							ifr.addDataToGrid("NG_EIBOR_GRID_DF1_REPETETIVE_SM", jsonArray1);
						}
						if(tenor.equalsIgnoreCase("1Y")){
							ifr.setStyle("NG_EIBOR_GRID_DF1_REPETETIVE_OY","visible","true");
							ifr.addDataToGrid("NG_EIBOR_GRID_DF1_REPETETIVE_OY", jsonArray1);
						}
						
						EIBOR.mLogger.info("Data Added successfully to DF1 Repetetive Grid for"+tenor);
						
						obj=new JSONObject();
						jsonArray1=new JSONArray();
					}
				}
				 
				
			}
			EIBOR.mLogger.info("Exit from for loop");
	
			
		}
		catch (Exception e)
		{
			EIBOR.mLogger.info("DF1 Repetitve Grid-:- "+e.toString());
		}
		return "";
	}
	
	
	
	public static String dataLoadInDF2Repe(IFormReference ifr)
	{
	
		try 
		{
			EIBOR.mLogger.info("inside try load data in DF2 Repetetive Grid--");
			JSONArray jsonArray=new JSONArray();
			JSONArray jsonArray1 = new JSONArray();
			JSONObject obj=new JSONObject();

			jsonArray = ifr.getDataFromGrid("NG_EIBOR_GRID_DF2_DEALS");
			String arr[][] = new String[1000][12]  ;
			int length = jsonArray.size();
			LocalDate yesterdayDate = LocalDate.now().minusDays(1);
			Date yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
			
			String dayOfWeek = yesterdayDate.getDayOfWeek().toString();
			EIBOR.mLogger.info("Day of Yesterday date--"+dayOfWeek);
			String sunday = "SUNDAY";
			if(sunday.equalsIgnoreCase(dayOfWeek)){
				yesterdayDate = LocalDate.now().minusDays(2);
				yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
			}
			
			EIBOR.mLogger.info("json Array Size--"+length);
			for(int i=0;i<length;i++){				
				for(int j=0;j<12;j++){
					EIBOR.mLogger.info("inside loop for fetching column"+i+"<<:i and j>>:"+j);
					arr[i][j] = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS",i,j);
					EIBOR.mLogger.info("Array of data for each row--"+arr[i][j]);					 
				}
				String valueDate = arr[i][2];
				DateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
				Date newValueDate = (Date)formater.parse(valueDate);
				if(arr[i][10].equalsIgnoreCase("Yes") && newValueDate.equals(yesterdayDatee)){
					String counterParty = arr[i][0];
					EIBOR.mLogger.info("Counter Party--"+i+":"+counterParty);
					String amount = arr[i][4];
					EIBOR.mLogger.info("amount--"+i+":"+amount);
					String contractRate = arr[i][1];
					EIBOR.mLogger.info("Contarct rate--"+i+":"+contractRate);
					String startdate = arr[i][2];
					EIBOR.mLogger.info("start date--"+i+":"+startdate);
					String dueDate = arr[i][3];
					EIBOR.mLogger.info("due date--"+i+":"+dueDate);
					String tenor = arr[i][9];
					EIBOR.mLogger.info("Tenor--"+i+":"+tenor);
					
					String newStartDate = startdate.replace("-","/");
					EIBOR.mLogger.info("inside loop Startdate after replace-->"+newStartDate);
					String newDueDate = dueDate.replace("-","/");
					EIBOR.mLogger.info("inside loop Duedate after replace-->"+newDueDate);
					String[] startDateSplit = newStartDate.split("/");
					String finalStartDate = startDateSplit[2]+"/"+startDateSplit[1]+"/"+startDateSplit[0];
					EIBOR.mLogger.info("Final Start Date DF1 Repe Grid-->"+finalStartDate);
					String[] dueDateSplit = newDueDate.split("/");
					String finaldueDate = dueDateSplit[2]+"/"+dueDateSplit[1]+"/"+dueDateSplit[0];
					EIBOR.mLogger.info("Final Due Date DF1 Repe Grid -->"+finaldueDate);
					
					obj.put("Counter Party", counterParty);
					obj.put("Contract Rate", contractRate);
					obj.put("Start Date", finalStartDate);
					obj.put("Due Date", finaldueDate);
					obj.put("Amount", amount);
					
					jsonArray1.add(obj);
					
				
					if(tenor.equalsIgnoreCase("O/N")){
						ifr.setStyle("NG_EIBOR_GRID_DF2_REPETETIVE","visible","true");
						ifr.addDataToGrid("NG_EIBOR_GRID_DF2_REPETETIVE", jsonArray1);
					}
					if(tenor.equalsIgnoreCase("1W")){
						ifr.setStyle("NG_EIBOR_GRID_DF2_REPETETIVE_OW","visible","true");
						ifr.addDataToGrid("NG_EIBOR_GRID_DF2_REPETETIVE_OW", jsonArray1);
					}
					if(tenor.equalsIgnoreCase("1M")){
						ifr.setStyle("NG_EIBOR_GRID_DF2_REPETETIVE_OM","visible","true");
						ifr.addDataToGrid("NG_EIBOR_GRID_DF2_REPETETIVE_OM", jsonArray1);
					}
					if(tenor.equalsIgnoreCase("3M")){
						ifr.setStyle("NG_EIBOR_GRID_DF2_REPETETIVE_TM","visible","true");
						ifr.addDataToGrid("NG_EIBOR_GRID_DF2_REPETETIVE_TM", jsonArray1);
					}
					if(tenor.equalsIgnoreCase("6M")){
						ifr.setStyle("NG_EIBOR_GRID_DF2_REPETETIVE_SM","visible","true");
						ifr.addDataToGrid("NG_EIBOR_GRID_DF2_REPETETIVE_SM", jsonArray1);
					}
					if(tenor.equalsIgnoreCase("1Y")){
						ifr.setStyle("NG_EIBOR_GRID_DF2_REPETETIVE_OY","visible","true");
						ifr.addDataToGrid("NG_EIBOR_GRID_DF2_REPETETIVE_OY", jsonArray1);
					}
					
					EIBOR.mLogger.info("Data Added successfully to DF2 Repetetive Grid for"+tenor);
					
					obj=new JSONObject();
					jsonArray1=new JSONArray();
				}
				 
				
			}
			EIBOR.mLogger.info("Exit from for loop");
	
			
		}
		catch (Exception e)
		{
			EIBOR.mLogger.info("DF2 Repetitve Grid-:- "+e.toString());
		}
		return "";
	}
	
	
	public static String dataLoadInDF1(IFormReference ifr)
	{
	
		try 
		{
			EIBOR.mLogger.info("inside try load data in DF1 Grid--");
			JSONArray jsonArray = new JSONArray();
			JSONArray jsonArray1 = new JSONArray();
			JSONObject obj=new JSONObject();
			String[] tenor = {"NG_EIBOR_GRID_DF1_REPETETIVE","NG_EIBOR_GRID_DF1_REPETETIVE_OW","NG_EIBOR_GRID_DF1_REPETETIVE_OM","NG_EIBOR_GRID_DF1_REPETETIVE_TM","NG_EIBOR_GRID_DF1_REPETETIVE_SM","NG_EIBOR_GRID_DF1_REPETETIVE_OY"};

			for(int m =0;m<6;m++){
				jsonArray = ifr.getDataFromGrid(tenor[m]);
				String arr[][] = new String[1000][11]  ;
				int length = jsonArray.size();			
				EIBOR.mLogger.info("json Array Size--"+length);
				if(length>0){
					
					String eiborRateToday = null;
					double eiborRate = 0;
					double totalAmount = 0;
					
					double totalMultiply = 0;
					
					for(int i=0;i<length;i++){				
						for(int j=0;j<5;j++){
							EIBOR.mLogger.info("inside loop for fetching column"+i+"<<:i and j>>:"+j);
							arr[i][j] = ifr.getTableCellValue(tenor[m],i,j);
							EIBOR.mLogger.info("Array of data for each row--"+arr[i][j]);					 
						}
					
						double multiply = 0;
						String principal1 = arr[i][4];
						EIBOR.mLogger.info("amount--"+i+":"+principal1);			
						String rate1 = arr[i][1];
						EIBOR.mLogger.info("Contarct rate--"+i+":"+rate1);
					
						double principal = Double.parseDouble(principal1);
						double rate = Double.parseDouble(rate1);
						
						multiply = principal*rate;
						EIBOR.mLogger.info("Multiply: "+multiply);
						totalMultiply = multiply + totalMultiply;	
						EIBOR.mLogger.info("Total Multiply for each row: "+totalMultiply);
						totalAmount = totalAmount+principal;
						EIBOR.mLogger.info("Total Amount for each row: "+totalAmount);
					}
					DecimalFormat formater = new DecimalFormat("0.00000");		
					EIBOR.mLogger.info("Total Multiply: "+totalMultiply);
					EIBOR.mLogger.info("Total Amount: "+totalAmount);
					eiborRate = totalMultiply/totalAmount; 
					
					EIBOR.mLogger.info("Eibor Rate for Today: "+eiborRate);
					eiborRateToday = formater.format(eiborRate);	
					ifr.setTableCellValue("NG_EIBOR_GRID_DF1",m,1,eiborRateToday);
			
				}

			}

		}
		catch (Exception e)
		{
			EIBOR.mLogger.info("DF1  Grid-:- "+e.toString());
		}
		return "";
	}
	
	public static String dataLoadInDF2(IFormReference ifr)
	{
	
		try 
		{
			EIBOR.mLogger.info("inside try load data in DF2 Grid--");
			JSONArray jsonArray = new JSONArray();
			JSONArray jsonArray1 = new JSONArray();
			JSONObject obj=new JSONObject();
			String[] tenor = {"NG_EIBOR_GRID_DF2_REPETETIVE","NG_EIBOR_GRID_DF2_REPETETIVE_OW","NG_EIBOR_GRID_DF2_REPETETIVE_OM","NG_EIBOR_GRID_DF2_REPETETIVE_TM","NG_EIBOR_GRID_DF2_REPETETIVE_SM","NG_EIBOR_GRID_DF2_REPETETIVE_OY"};

			for(int m =0;m<6;m++){
				jsonArray = ifr.getDataFromGrid(tenor[m]);
				String arr[][] = new String[1000][11]  ;
				int length = jsonArray.size();			
				EIBOR.mLogger.info("json Array Size--"+length);
				if(length>0){
					
					String eiborRateToday = null;
					double eiborRate = 0;
					double totalAmount = 0;
					
					double totalMultiply = 0;
					
					for(int i=0;i<length;i++){				
						for(int j=0;j<5;j++){
							EIBOR.mLogger.info("inside loop for fetching column"+i+"<<:i and j>>:"+j);
							arr[i][j] = ifr.getTableCellValue(tenor[m],i,j);
							EIBOR.mLogger.info("Array of data for each row--"+arr[i][j]);					 
						}
					
						double multiply = 0;
						String principal1 = arr[i][4];
						EIBOR.mLogger.info("amount--"+i+":"+principal1);			
						String rate1 = arr[i][1];
						EIBOR.mLogger.info("Contarct rate--"+i+":"+rate1);
					
						double principal = Double.parseDouble(principal1);
						double rate = Double.parseDouble(rate1);
						
						multiply = principal*rate;
						EIBOR.mLogger.info("Multiply: "+multiply);
						totalMultiply = multiply + totalMultiply;	
						EIBOR.mLogger.info("Total Multiply for each row: "+totalMultiply);
						totalAmount = totalAmount+principal;
						EIBOR.mLogger.info("Total Amount for each row: "+totalAmount);
					}
					DecimalFormat formater = new DecimalFormat("0.00000");	
					EIBOR.mLogger.info("Total Multiply: "+totalMultiply);
					EIBOR.mLogger.info("Total Amount: "+totalAmount);
					eiborRate = totalMultiply/totalAmount; 
					EIBOR.mLogger.info("Eibor Rate for Today: "+eiborRate);
					eiborRateToday = formater.format(eiborRate);
					ifr.setTableCellValue("NG_EIBOR_GRID_DF2",m,1,eiborRateToday);
			
				}

			}

		}
		catch (Exception e)
		{
			EIBOR.mLogger.info("DF2  Grid-:- "+e.toString());
		}
		return "";
	}
	
	public static String dataLoadInHistIB(IFormReference ifr)
	{
	
		try 
		{
			EIBOR.mLogger.info("inside try load data in DF1 Grid--");
			JSONArray jsonArray = new JSONArray();
			JSONArray jsonArray1 = new JSONArray();
			JSONObject obj=new JSONObject();
			String[] tenor = {"Q_NG_EIBOR_GRID_HIST_IB_ON","Q_NG_EIBOR_GRID_HIST_IB_OW","Q_NG_EIBOR_GRID_HIST_IB_OM","Q_NG_EIBOR_GRID_HIST_IB_TM","Q_NG_EIBOR_GRID_HIST_IB_SM","Q_NG_EIBOR_GRID_HIST_IB_OY"};

			for(int m =0;m<6;m++){
				jsonArray = ifr.getDataFromGrid(tenor[m]);
				String arr[][] = new String[1000][11]  ;
				int length = jsonArray.size();			
				EIBOR.mLogger.info("json Array Size--"+length);
				if(length>0){
					
					String eiborRateToday = null;
					double eiborRate = 0;
					double totalAmount = 0;
					
					double totalMultiply = 0;
					
					for(int i=0;i<length;i++){				
						for(int j=0;j<5;j++){
							EIBOR.mLogger.info("inside loop for fetching column"+i+"<<:i and j>>:"+j);
							arr[i][j] = ifr.getTableCellValue(tenor[m],i,j);
							EIBOR.mLogger.info("Array of data for each row--"+arr[i][j]);					 
						}
					
						double multiply = 0;
						String principal1 = arr[i][4];
						EIBOR.mLogger.info("amount--"+i+":"+principal1);			
						String rate1 = arr[i][1];
						EIBOR.mLogger.info("Contarct rate--"+i+":"+rate1);
					
						double principal = Double.parseDouble(principal1);
						double rate = Double.parseDouble(rate1);
						
						multiply = principal*rate;
						EIBOR.mLogger.info("Multiply: "+multiply);
						totalMultiply = multiply + totalMultiply;	
						EIBOR.mLogger.info("Total Multiply for each row: "+totalMultiply);
						totalAmount = totalAmount+principal;
						EIBOR.mLogger.info("Total Amount for each row: "+totalAmount);
					}
					DecimalFormat formater = new DecimalFormat("0.00000");		
					EIBOR.mLogger.info("Total Multiply: "+totalMultiply);
					EIBOR.mLogger.info("Total Amount: "+totalAmount);
					eiborRate = totalMultiply/totalAmount; 
					EIBOR.mLogger.info("Eibor Rate for Today: "+eiborRate);
					eiborRateToday = formater.format(eiborRate);	
					ifr.setTableCellValue("NG_EIBOR_GRID_History_IB_DATA",m,1,eiborRateToday);
			
				}

			}

		}
		catch (Exception e)
		{
			EIBOR.mLogger.info("DF2  Grid-:- "+e.toString());
		}
		return "";
	}
	
	
	public static String dataLoadInHistCust(IFormReference ifr)
	{	
		try 
		{
			EIBOR.mLogger.info("inside try load data in DF1 Grid--");
			JSONArray jsonArray = new JSONArray();
			JSONArray jsonArray1 = new JSONArray();
			JSONObject obj=new JSONObject();
			String[] tenor = {"Q_NG_EIBOR_GRID_HIST_CUST_ON","Q_NG_EIBOR_GRID_HIST_CUST_OW","Q_NG_EIBOR_GRID_HIST_CUST_OM","Q_NG_EIBOR_GRID_HIST_CUST_TM","Q_NG_EIBOR_GRID_HIST_CUST_SM","Q_NG_EIBOR_GRID_HIST_CUST_OY"};

			for(int m =0;m<6;m++){
				jsonArray = ifr.getDataFromGrid(tenor[m]);
				String arr[][] = new String[1000][11]  ;
				int length = jsonArray.size();			
				EIBOR.mLogger.info("json Array Size--"+length);
				if(length>0){
					
					String eiborRateToday = null;
					double eiborRate = 0;
					double totalAmount = 0;
					
					double totalMultiply = 0;
					
					for(int i=0;i<length;i++){				
						for(int j=0;j<5;j++){
							EIBOR.mLogger.info("inside loop for fetching column"+i+"<<:i and j>>:"+j);
							arr[i][j] = ifr.getTableCellValue(tenor[m],i,j);
							EIBOR.mLogger.info("Array of data for each row--"+arr[i][j]);					 
						}
					
						double multiply = 0;
						String principal1 = arr[i][4];
						EIBOR.mLogger.info("amount--"+i+":"+principal1);			
						String rate1 = arr[i][1];
						EIBOR.mLogger.info("Contarct rate--"+i+":"+rate1);
					
						double principal = Double.parseDouble(principal1);
						double rate = Double.parseDouble(rate1);
						
						multiply = principal*rate;
						EIBOR.mLogger.info("Multiply: "+multiply);
						totalMultiply = multiply + totalMultiply;	
						EIBOR.mLogger.info("Total Multiply for each row: "+totalMultiply);
						totalAmount = totalAmount+principal;
						EIBOR.mLogger.info("Total Amount for each row: "+totalAmount);
					}
					DecimalFormat formater = new DecimalFormat("0.00000");		
					EIBOR.mLogger.info("Total Multiply: "+totalMultiply);
					EIBOR.mLogger.info("Total Amount: "+totalAmount);
					eiborRate = totalMultiply/totalAmount; 
					EIBOR.mLogger.info("Eibor Rate for Today: "+eiborRate);
					eiborRateToday = formater.format(eiborRate);
					ifr.setTableCellValue("NG_EIBOR_GRID_History_CUST_DATA",m,1,eiborRateToday);
			
				}

			}

		}
		catch (Exception e)
		{
			EIBOR.mLogger.info("DF2  Grid-:- "+e.toString());
		}
		return "";
	}
	
	public static String dataLoadInHISTIBRepe(IFormReference ifr)
	{
	
		try 
		{
			EIBOR.mLogger.info("inside try load data in hist IB Repetetive Grid--");
			JSONArray jsonArray=new JSONArray();
			JSONArray jsonArray1 = new JSONArray();
			JSONObject obj=new JSONObject();

			jsonArray = ifr.getDataFromGrid("NG_EIBOR_GRID_MM");
			String arr[][] = new String[1000][13]  ;
			int length = jsonArray.size();
			
			EIBOR.mLogger.info("json Array Size--"+length);
			for(int i=0;i<length;i++){				
				for(int j=0;j<13;j++){
					EIBOR.mLogger.info("inside loop for fetching column"+i+"<<:i and j>>:"+j);
					arr[i][j] = ifr.getTableCellValue("NG_EIBOR_GRID_MM",i,j);
					EIBOR.mLogger.info("Array of data for each row--"+arr[i][j]);					 
				}
				String strtdate = arr[i][5];
				String datetime = arr[i][1];
				
				SimpleDateFormat formater3  = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");				
				Date dateTime = formater3.parse(datetime);
				EIBOR.mLogger.info("Depo Date time-"+dateTime);
				DateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
				Date newValueDate = (Date)formater.parse(strtdate);
				LocalDate yesterdayDate = LocalDate.now().minusDays(1);
				Date yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
				
				Date yesterday = formater.parse(yesterdayDate.toString());
				Date yesterdayWithTime = dateToDateTime(ifr,yesterday);
				EIBOR.mLogger.info("Yesterday date with 11 am--"+yesterdayWithTime);
				EIBOR.mLogger.info("Yesterday date--"+yesterdayDatee);
				EIBOR.mLogger.info("Value Date--"+newValueDate);
				EIBOR.mLogger.info("To be Reported"+arr[i][11]);
				EIBOR.mLogger.info("Comparing dates---"+(yesterdayDatee.compareTo(newValueDate)!=0));
				
				
				if(arr[i][11].equalsIgnoreCase("Yes")){
					if((yesterdayWithTime.after(dateTime))){
						EIBOR.mLogger.info("Inside If :");
						String counterParty = arr[i][7];
						EIBOR.mLogger.info("Counter Party--"+i+":"+counterParty);
						String amount = arr[i][3];
						EIBOR.mLogger.info("amount--"+i+":"+amount);
						String contractRate = arr[i][4];
						EIBOR.mLogger.info("Contarct rate--"+i+":"+contractRate);
						String startdate = arr[i][5];
						EIBOR.mLogger.info("start date--"+i+":"+startdate);
						String dueDate = arr[i][6];
						EIBOR.mLogger.info("due date--"+i+":"+dueDate);
						String tenor = arr[i][10];
						EIBOR.mLogger.info("Tenor--"+i+":"+tenor);
						
						String newStartDate = startdate.replace("-","/");
						EIBOR.mLogger.info("inside loop Startdate after replace-->"+newStartDate);
						String newDueDate = dueDate.replace("-","/");
						EIBOR.mLogger.info("inside loop Duedate after replace-->"+newDueDate);
						String[] startDateSplit = newStartDate.split("/");
						String finalStartDate = startDateSplit[2]+"/"+startDateSplit[1]+"/"+startDateSplit[0];
						EIBOR.mLogger.info("Final Start Date HIST IB Repe Grid-->"+finalStartDate);
						String[] dueDateSplit = newDueDate.split("/");
						String finaldueDate = dueDateSplit[2]+"/"+dueDateSplit[1]+"/"+dueDateSplit[0];
						EIBOR.mLogger.info("Final Due Date HIST IB Repe Grid -->"+finaldueDate);
						
						obj.put("Counter Party", counterParty);
						obj.put("Contract Rate", contractRate);
						obj.put("Start Date", finalStartDate);
						obj.put("Due Date", finaldueDate);
						obj.put("Amount", amount);
						
						jsonArray1.add(obj);
						
						if(tenor.equalsIgnoreCase("O/N")){
							ifr.setStyle("Q_NG_EIBOR_GRID_HIST_IB_ON","visible","true");
							ifr.addDataToGrid("Q_NG_EIBOR_GRID_HIST_IB_ON", jsonArray1);
						}
						if(tenor.equalsIgnoreCase("1W")){
							ifr.setStyle("Q_NG_EIBOR_GRID_HIST_IB_OW","visible","true");
							ifr.addDataToGrid("Q_NG_EIBOR_GRID_HIST_IB_OW", jsonArray1);
						}
						if(tenor.equalsIgnoreCase("1M")){
							ifr.setStyle("Q_NG_EIBOR_GRID_HIST_IB_OM","visible","true");
							ifr.addDataToGrid("Q_NG_EIBOR_GRID_HIST_IB_OM", jsonArray1);
						}
						if(tenor.equalsIgnoreCase("3M")){
							ifr.setStyle("Q_NG_EIBOR_GRID_HIST_IB_TM","visible","true");
							ifr.addDataToGrid("Q_NG_EIBOR_GRID_HIST_IB_TM", jsonArray1);
						}
						if(tenor.equalsIgnoreCase("6M")){
							ifr.setStyle("Q_NG_EIBOR_GRID_HIST_IB_SM","visible","true");
							ifr.addDataToGrid("Q_NG_EIBOR_GRID_HIST_IB_SM", jsonArray1);
						}
						if(tenor.equalsIgnoreCase("1Y")){
							ifr.setStyle("Q_NG_EIBOR_GRID_HIST_IB_OY","visible","true");
							ifr.addDataToGrid("Q_NG_EIBOR_GRID_HIST_IB_OY", jsonArray1);
						}
						
						EIBOR.mLogger.info("Data Added successfully to HIST IB Repetetive Grid for"+tenor);
						
						obj=new JSONObject();
						jsonArray1=new JSONArray();
					}
						
				}
				 
				
			}
			EIBOR.mLogger.info("Exit from for loop");
	
			
		}
		catch (Exception e)
		{
			EIBOR.mLogger.info("HIST IB Repetitve Grid-:- "+e.toString());
		}
		return "";
	}
		
	public static String dataLoadInHISTCUSTRepe(IFormReference ifr)
	{
	
		try 
		{
			EIBOR.mLogger.info("inside try load data in hist CUST Repetetive Grid--");
			JSONArray jsonArray=new JSONArray();
			JSONArray jsonArray1 = new JSONArray();
			JSONObject obj=new JSONObject();

			jsonArray = ifr.getDataFromGrid("NG_EIBOR_GRID_DF2_DEALS");
			String arr[][] = new String[1000][12]  ;
			int length = jsonArray.size();
			
			EIBOR.mLogger.info("json Array Size--"+length);
			for(int i=0;i<length;i++){				
				for(int j=0;j<12;j++){
					EIBOR.mLogger.info("inside loop for fetching column"+i+"<<:i and j>>:"+j);
					arr[i][j] = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS",i,j);
					EIBOR.mLogger.info("Array of data for each row--"+arr[i][j]);					 
				}
				String strtdate = arr[i][2];
				DateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
				Date newValueDate = (Date)formater.parse(strtdate);
				LocalDate yesterdayDate = LocalDate.now().minusDays(1);
				Date yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
				String dayOfWeek = yesterdayDate.getDayOfWeek().toString();
				String sunday = "SUNDAY";
				if(sunday.equalsIgnoreCase(dayOfWeek)){
					yesterdayDate = LocalDate.now().minusDays(2);
					yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
				}
				
				if(arr[i][10].equalsIgnoreCase("Yes")&& (yesterdayDatee.compareTo(newValueDate)!=0)){
					String counterParty = arr[i][0];
					EIBOR.mLogger.info("Counter Party--"+i+":"+counterParty);
					String amount = arr[i][4];
					EIBOR.mLogger.info("amount--"+i+":"+amount);
					String contractRate = arr[i][1];
					EIBOR.mLogger.info("Contarct rate--"+i+":"+contractRate);
					String startdate = arr[i][2];
					EIBOR.mLogger.info("start date--"+i+":"+startdate);
					String dueDate = arr[i][3];
					EIBOR.mLogger.info("due date--"+i+":"+dueDate);
					String tenor = arr[i][9];
					EIBOR.mLogger.info("Tenor--"+i+":"+tenor);
					
					String newStartDate = startdate.replace("-","/");
					EIBOR.mLogger.info("inside loop Startdate after replace-->"+newStartDate);
					String newDueDate = dueDate.replace("-","/");
					EIBOR.mLogger.info("inside loop Duedate after replace-->"+newDueDate);
					String[] startDateSplit = newStartDate.split("/");
					String finalStartDate = startDateSplit[2]+"/"+startDateSplit[1]+"/"+startDateSplit[0];
					EIBOR.mLogger.info("Final Start Date DF1 Repe Grid-->"+finalStartDate);
					String[] dueDateSplit = newDueDate.split("/");
					String finaldueDate = dueDateSplit[2]+"/"+dueDateSplit[1]+"/"+dueDateSplit[0];
					EIBOR.mLogger.info("Final Due Date DF1 Repe Grid -->"+finaldueDate);
					
					obj.put("Counter Party", counterParty);
					obj.put("Contract Rate", contractRate);
					obj.put("Start Date", finalStartDate);
					obj.put("Due Date", finaldueDate);
					obj.put("Amount", amount);
					
					jsonArray1.add(obj);
					
				
					if(tenor.equalsIgnoreCase("O/N")){
						ifr.setStyle("Q_NG_EIBOR_GRID_HIST_CUST_ON","visible","true");
						ifr.addDataToGrid("Q_NG_EIBOR_GRID_HIST_CUST_ON", jsonArray1);
					}
					if(tenor.equalsIgnoreCase("1W")){
						ifr.setStyle("Q_NG_EIBOR_GRID_HIST_CUST_OW","visible","true");
						ifr.addDataToGrid("Q_NG_EIBOR_GRID_HIST_CUST_OW", jsonArray1);
					}
					if(tenor.equalsIgnoreCase("1M")){
						ifr.setStyle("Q_NG_EIBOR_GRID_HIST_CUST_OM","visible","true");
						ifr.addDataToGrid("Q_NG_EIBOR_GRID_HIST_CUST_OM", jsonArray1);
					}
					if(tenor.equalsIgnoreCase("3M")){
						ifr.setStyle("Q_NG_EIBOR_GRID_HIST_CUST_TM","visible","true");
						ifr.addDataToGrid("Q_NG_EIBOR_GRID_HIST_CUST_TM", jsonArray1);
					}
					if(tenor.equalsIgnoreCase("6M")){
						ifr.setStyle("Q_NG_EIBOR_GRID_HIST_CUST_SM","visible","true");
						ifr.addDataToGrid("Q_NG_EIBOR_GRID_HIST_CUST_SM", jsonArray1);
					}
					if(tenor.equalsIgnoreCase("1Y")){
						ifr.setStyle("Q_NG_EIBOR_GRID_HIST_CUST_OY","visible","true");
						ifr.addDataToGrid("Q_NG_EIBOR_GRID_HIST_CUST_OY", jsonArray1);
					}
					
					EIBOR.mLogger.info("Data Added successfully to HIST CUST Repetetive Grid for"+tenor);
					
					obj=new JSONObject();
					jsonArray1=new JSONArray();
				}
				 
				
			}
			EIBOR.mLogger.info("Exit from for loop");
	
			
		}
		catch (Exception e)
		{
			EIBOR.mLogger.info("HIST CUST Repetitve Grid-:- "+e.toString());
		}
		return "";
	}
	
	public static String loadToBeReportedMM(IFormReference ifr)
	{
	
		try 
		{
			EIBOR.mLogger.info("inside try load data to be reported in MM Grid--");
			JSONArray jsonArray=new JSONArray();
			

			jsonArray = ifr.getDataFromGrid("NG_EIBOR_GRID_MM");
			String arr[][] = new String[1000][13]  ;
			int length = jsonArray.size();
			LocalDate yesterdayDate = LocalDate.now().minusDays(1);
			Date yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
			
			
			SimpleDateFormat sdf  = new SimpleDateFormat("yyyy-MM-dd");
			Date yesterday = sdf.parse(yesterdayDate.toString());
			Date yesterdayWithTime = dateToDateTime(ifr,yesterday);
			EIBOR.mLogger.info("Yesterday date with 11am--"+yesterdayWithTime);
			EIBOR.mLogger.info("Yesterday date--"+yesterdayDatee);
			LocalDate threeDaysBack = yesterdayDate.minusDays(2);
			Date threeDaysBackk = java.sql.Date.valueOf(threeDaysBack);
			LocalDate fiveDaysBack = yesterdayDate.minusDays(4);
			Date fiveDaysBackk = java.sql.Date.valueOf(fiveDaysBack);
			LocalDate tenDaysBack = yesterdayDate.minusDays(9);
			Date tenDaysBackk = java.sql.Date.valueOf(tenDaysBack);	
			
			EIBOR.mLogger.info("json Array Size--"+length);
			for(int i=0;i<length;i++){				
				for(int j=0;j<13;j++){
					
					arr[i][j] = ifr.getTableCellValue("NG_EIBOR_GRID_MM",i,j);
									 
				}
				String valueDate = arr[i][5];
				String datetime = arr[i][1];
				
				SimpleDateFormat formater3  = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");				
				Date dateTime = formater3.parse(datetime);				
				
				
				DateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
				Date newValueDate = (Date)formater.parse(valueDate);
				EIBOR.mLogger.info("Value date--"+newValueDate);
				EIBOR.mLogger.info("Depo date Time--"+dateTime);
				String tenor = arr[i][10];							
				if(tenor.equalsIgnoreCase("O/N") || tenor.equalsIgnoreCase("1W")){						
					long totalWorkingDays = workingDays(threeDaysBack, yesterdayDate, ifr);
					while(totalWorkingDays!=3){
						long totalHolidays = 3-totalWorkingDays;
						threeDaysBack = threeDaysBack.minusDays(totalHolidays);
						threeDaysBackk = java.sql.Date.valueOf(threeDaysBack);
						totalWorkingDays = workingDays(threeDaysBack, yesterdayDate, ifr);
					}
					
					Date threeDays = sdf.parse(threeDaysBack.toString());
					Date threeDaysWithTime = dateToDateTime(ifr,threeDays);
					EIBOR.mLogger.info("Three days back date with 11 am--"+threeDaysWithTime);
					EIBOR.mLogger.info("Start Date for Historical Data--"+threeDaysBackk);
					if(newValueDate.before(yesterdayDatee) && newValueDate.after(threeDaysBackk)){
						ifr.setTableCellValue("NG_EIBOR_GRID_MM",i,11,"Yes");
					}
					if(newValueDate.equals(threeDaysBackk)){
						ifr.setTableCellValue("NG_EIBOR_GRID_MM",i,11,"Yes");
					}
					if(yesterdayWithTime.after(dateTime) && threeDaysWithTime.before(dateTime)){
						ifr.setTableCellValue("NG_EIBOR_GRID_MM",i,11,"Yes");
					}
				}
				else if(tenor.equalsIgnoreCase("1M") || tenor.equalsIgnoreCase("3M")){
					long totalWorkingDays = workingDays(fiveDaysBack, yesterdayDate, ifr);
					while(totalWorkingDays!=5){
						long totalHolidays = 5-totalWorkingDays;
						fiveDaysBack = fiveDaysBack.minusDays(totalHolidays);
						fiveDaysBackk = java.sql.Date.valueOf(fiveDaysBack);
						totalWorkingDays = workingDays(fiveDaysBack, yesterdayDate, ifr);
					}
					Date fiveDays = sdf.parse(fiveDaysBack.toString());
					Date fiveDaysWithTime = dateToDateTime(ifr,fiveDays);
					EIBOR.mLogger.info("Five days back date with 11 am--"+fiveDaysWithTime);
					EIBOR.mLogger.info("Start Date for Historical Data--"+fiveDaysBackk);
					if(newValueDate.before(yesterdayDatee) && newValueDate.after(fiveDaysBackk)){
						ifr.setTableCellValue("NG_EIBOR_GRID_MM",i,11,"Yes");
					}
					if(newValueDate.equals(fiveDaysBackk)){
						ifr.setTableCellValue("NG_EIBOR_GRID_MM",i,11,"Yes");
					}
					if(yesterdayWithTime.after(dateTime) && fiveDaysWithTime.before(dateTime)){
						ifr.setTableCellValue("NG_EIBOR_GRID_MM",i,11,"Yes");
					}
				}
				else if(tenor.equalsIgnoreCase("6M") || tenor.equalsIgnoreCase("1Y")){
					long totalWorkingDays = workingDays(threeDaysBack, yesterdayDate, ifr);
					while(totalWorkingDays!=10){
						long totalHolidays = 10-totalWorkingDays;
						tenDaysBack = tenDaysBack.minusDays(totalHolidays);
						tenDaysBackk = java.sql.Date.valueOf(tenDaysBack);
						totalWorkingDays = workingDays(tenDaysBack, yesterdayDate, ifr);
					}
					Date tenDays = sdf.parse(tenDaysBack.toString());
					Date tenDaysWithTime = dateToDateTime(ifr,tenDays);
					EIBOR.mLogger.info("Ten days back date with 11 am--"+tenDaysWithTime);
					EIBOR.mLogger.info("Start Date for Historical Data--"+tenDaysBackk);
					if(newValueDate.before(yesterdayDatee) && newValueDate.after(tenDaysBackk)){
						ifr.setTableCellValue("NG_EIBOR_GRID_MM",i,11,"Yes");
					}
					if(newValueDate.equals(tenDaysBackk)){
						ifr.setTableCellValue("NG_EIBOR_GRID_MM",i,11,"Yes");
					}
					if(yesterdayWithTime.after(dateTime) && tenDaysWithTime.before(dateTime)){
						ifr.setTableCellValue("NG_EIBOR_GRID_MM",i,11,"Yes");
					}
				}		 
				
			}
			EIBOR.mLogger.info("Exit from for loop");
	
			
		}
		catch (Exception e)
		{
			EIBOR.mLogger.info("Load to be reported in MM-:- "+e.toString());
		}
		return "";
	}
	
	
	public static String loadToBeReportedDF2(IFormReference ifr)
	{
	
		try 
		{
			EIBOR.mLogger.info("inside try load data to be reported in DF2 DEALS Grid--");
			JSONArray jsonArray=new JSONArray();
			

			jsonArray = ifr.getDataFromGrid("NG_EIBOR_GRID_DF2_DEALS");
			String arr[][] = new String[1000][12];
			int length = jsonArray.size();
			LocalDate yesterdayDate = LocalDate.now().minusDays(1);
			Date yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
			
			String dayOfWeek = yesterdayDate.getDayOfWeek().toString();
			EIBOR.mLogger.info("Day of Yesterday date--"+dayOfWeek);
			String sunday = "SUNDAY";
			if(sunday.equalsIgnoreCase(dayOfWeek)){
				yesterdayDate = LocalDate.now().minusDays(2);
				yesterdayDatee = java.sql.Date.valueOf(yesterdayDate);
			}
			EIBOR.mLogger.info("Yesterday date--"+yesterdayDatee);
			LocalDate threeDaysBack = yesterdayDate.minusDays(2);
			Date threeDaysBackk = java.sql.Date.valueOf(threeDaysBack);
			LocalDate fiveDaysBack = yesterdayDate.minusDays(4);
			Date fiveDaysBackk = java.sql.Date.valueOf(fiveDaysBack);
			LocalDate tenDaysBack = yesterdayDate.minusDays(9);
			Date tenDaysBackk = java.sql.Date.valueOf(tenDaysBack);	
			
			EIBOR.mLogger.info("json Array Size--"+length);
			for(int i=0;i<length;i++){				
				for(int j=0;j<12;j++){
					
					arr[i][j] = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS",i,j);
										 
				}
				String valueDate = arr[i][2];
				DateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
				Date newValueDate = (Date)formater.parse(valueDate);
				String tenor = arr[i][9];							
				if(tenor.equalsIgnoreCase("O/N") || tenor .equalsIgnoreCase("1W")){						
					long totalWorkingDays = workingDays(threeDaysBack, yesterdayDate, ifr);
					while(totalWorkingDays!=3){
						long totalHolidays = 3-totalWorkingDays;
						threeDaysBack = threeDaysBack.minusDays(totalHolidays);
						threeDaysBackk = java.sql.Date.valueOf(threeDaysBack);
						totalWorkingDays = workingDays(threeDaysBack, yesterdayDate, ifr);
					}
					EIBOR.mLogger.info("Start Date for Historical CUST Data--"+threeDaysBackk);
					if(newValueDate.before(yesterdayDatee) && newValueDate.after(threeDaysBackk)){
						ifr.setTableCellValue("NG_EIBOR_GRID_DF2_DEALS",i,10,"Yes");
					}
					if(newValueDate.equals(threeDaysBackk)){
						ifr.setTableCellValue("NG_EIBOR_GRID_DF2_DEALS",i,10,"Yes");
					}			
					
				}
				else if(tenor.equalsIgnoreCase("1M") || tenor.equalsIgnoreCase("3M")){
					long totalWorkingDays = workingDays(fiveDaysBack, yesterdayDate, ifr);
					while(totalWorkingDays!=5){
						long totalHolidays = 5-totalWorkingDays;
						fiveDaysBack = fiveDaysBack.minusDays(totalHolidays);
						fiveDaysBackk = java.sql.Date.valueOf(fiveDaysBack);
						totalWorkingDays = workingDays(fiveDaysBack, yesterdayDate, ifr);
					}
					EIBOR.mLogger.info("Start Date for Historical CUST Data--"+fiveDaysBackk);
					if(newValueDate.before(yesterdayDatee) && newValueDate.after(fiveDaysBackk)){
						ifr.setTableCellValue("NG_EIBOR_GRID_DF2_DEALS",i,10,"Yes");
					}
					if(newValueDate.equals(fiveDaysBackk)){
						ifr.setTableCellValue("NG_EIBOR_GRID_DF2_DEALS",i,10,"Yes");
					}
				}
				else if(tenor.equalsIgnoreCase("6M") || tenor.equalsIgnoreCase("1Y")){
					long totalWorkingDays = workingDays(tenDaysBack, yesterdayDate, ifr);
					while(totalWorkingDays!=10){
						long totalHolidays = 10-totalWorkingDays;
						tenDaysBack = tenDaysBack.minusDays(totalHolidays);
						tenDaysBackk = java.sql.Date.valueOf(tenDaysBack);
						totalWorkingDays = workingDays(tenDaysBack, yesterdayDate, ifr);
					}
					EIBOR.mLogger.info("Start Date for Historical CUST Data--"+tenDaysBackk);
					if(newValueDate.before(yesterdayDatee) && newValueDate.after(tenDaysBackk)){
						ifr.setTableCellValue("NG_EIBOR_GRID_DF2_DEALS",i,10,"Yes");
					}
					if(newValueDate.equals(tenDaysBackk)){
						ifr.setTableCellValue("NG_EIBOR_GRID_DF2_DEALS",i,10,"Yes");
					}
				}		 
				
			}
			EIBOR.mLogger.info("Exit from for loop");
	
			
		}
		catch (Exception e)
		{
			EIBOR.mLogger.info("Load to be reported in DF2-:- "+e.toString());
		}
		return "";
	}
	public static String tbBeReportedCbuae(IFormReference ifr)
	{
		EIBOR.mLogger.info("inside load data in MM Grid--");
		
		try 
		{	
			JSONArray jsonArray=new JSONArray();
			JSONArray jsonArray1 = new JSONArray();
			JSONObject obj=new JSONObject();
			String arr[][] = new String[1000][13] ;
			jsonArray = ifr.getDataFromGrid("NG_EIBOR_GRID_MM");
			int lengthMM = jsonArray.size();
			jsonArray1 = ifr.getDataFromGrid("NG_EIBOR_GRID_DF2_DEALS");
			int lengthDf2 = jsonArray1.size();
			
			String query = "select bps_value from NG_EIBOR_MAST_BPS_VALUE where bps_index = '1'";
			@SuppressWarnings("unchecked")
			List<List<String>> BpsValueDataFromDB = ifr.getDataFromDB(query);
			EIBOR.mLogger.info("BPS value fetch from DB :- "+BpsValueDataFromDB);
			
			String bps = BpsValueDataFromDB.get(0).get(0);
			Double bpsValue = Double.parseDouble(bps);
			EIBOR.mLogger.info("BPS value :- "+bpsValue);	
											
			Double tmCbuae = Double.parseDouble(ifr.getTableCellValue("NG_EIBOR_GRID_CBUAE_RATES",3,4));	
			Double lowertmCbuae = tmCbuae-bpsValue;
			EIBOR.mLogger.info("Lower Value of 3 month:- "+lowertmCbuae);
			Double uppertmCbuae = tmCbuae+bpsValue;
			EIBOR.mLogger.info("Upper Value of 3 month :- "+uppertmCbuae);
			Double smCbuae = Double.parseDouble(ifr.getTableCellValue("NG_EIBOR_GRID_CBUAE_RATES",3,5));
			Double lowersmCbuae = smCbuae-bpsValue;
			EIBOR.mLogger.info("Lower value of 6 month :- "+lowersmCbuae);
			Double uppersmCbuae = smCbuae+bpsValue;
			EIBOR.mLogger.info("Upper value of 6 month :- "+uppersmCbuae);
			Double oyCbuae = Double.parseDouble(ifr.getTableCellValue("NG_EIBOR_GRID_CBUAE_RATES",3,6));
			Double loweroyCbuae = oyCbuae-bpsValue;
			EIBOR.mLogger.info("Lower value of 1 year :- "+loweroyCbuae);
			Double upperoyCbuae= oyCbuae+bpsValue;
			EIBOR.mLogger.info("Upper value of 1 year :- "+upperoyCbuae);
			for(int i=0;i<lengthMM;i++){							
				String tenor = ifr.getTableCellValue("NG_EIBOR_GRID_MM",i,10);		
				String toBeReported = ifr.getTableCellValue("NG_EIBOR_GRID_MM",i,11);
				String contractrate =  ifr.getTableCellValue("NG_EIBOR_GRID_MM",i,4);
				if(contractrate.isEmpty()){
					contractrate = "0";
				}
				Double contractRate = Double.parseDouble(contractrate);
				EIBOR.mLogger.info("Contract Rate----"+i+contractRate);
				
				if(toBeReported.equalsIgnoreCase("Yes")){
					if(tenor.equalsIgnoreCase("3M")){
						if(contractRate<lowertmCbuae || contractRate>uppertmCbuae){
							ifr.setTableCellValue("NG_EIBOR_GRID_MM",i,11,"Not Applicable");
						}
					}
					if(tenor.equalsIgnoreCase("6M")){
						if(contractRate<lowersmCbuae || contractRate>uppersmCbuae){
							ifr.setTableCellValue("NG_EIBOR_GRID_MM",i,11,"Not Applicable");
						}
					}
					if(tenor.equalsIgnoreCase("1Y")){
						if(contractRate<loweroyCbuae || contractRate>upperoyCbuae){
							ifr.setTableCellValue("NG_EIBOR_GRID_MM",i,11,"Not Applicable");
						}
					}

				}
				
			
			}
			for(int j=0;j<lengthDf2;j++){							
				String tenor = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS",j,9);		
				String toBeReported = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS",j,10);
				String contractrate =  ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS",j,1);
				if(contractrate.isEmpty()){
					contractrate = "0";
				}
				Double contractRate = Double.parseDouble(contractrate);
				EIBOR.mLogger.info("Contract Rate----"+j+contractRate);
				
				if(toBeReported.equalsIgnoreCase("Yes")){
					if(tenor.equalsIgnoreCase("3M")){
						if(contractRate<lowertmCbuae || contractRate>uppertmCbuae){
							ifr.setTableCellValue("NG_EIBOR_GRID_DF2_DEALS",j,10,"Not Applicable");
						}
					}
					if(tenor.equalsIgnoreCase("6M")){
						if(contractRate<lowersmCbuae || contractRate>uppersmCbuae){
							ifr.setTableCellValue("NG_EIBOR_GRID_DF2_DEALS",j,10,"Not Applicable");
						}
					}
					if(tenor.equalsIgnoreCase("1Y")){
						if(contractRate<loweroyCbuae || contractRate>upperoyCbuae){
							ifr.setTableCellValue("NG_EIBOR_GRID_DF2_DEALS",j,10,"Not Applicable");
						}
					}

				}
				
			
			}
			
			
		}
		catch (Exception e)
		{
			EIBOR.mLogger.info("Exception inside load to be reported for CBUAE GRID logic-:- "+e.toString());
		}
		return "";
	}
	
	public static String loadToBeReported(IFormReference ifr)
	{
	
		try 
		{
			
			JSONArray jsonArray=new JSONArray();
			JSONArray jsonArray1=new JSONArray();

			jsonArray = ifr.getDataFromGrid("NG_EIBOR_GRID_MM");
			jsonArray1 = ifr.getDataFromGrid("NG_EIBOR_GRID_DF2_DEALS");
			int length = jsonArray.size();
			int length1 = jsonArray1.size();
			
			
			EIBOR.mLogger.info("json Array Size--"+length);
			for(int i=0;i<length;i++){						
				String rateMM = ifr.getTableCellValue("NG_EIBOR_GRID_MM",i,4);
				String tenorMM = ifr.getTableCellValue("NG_EIBOR_GRID_MM",i,10);	
												
				if(rateMM.isEmpty() || tenorMM.isEmpty()){
					ifr.setTableCellValue("NG_EIBOR_GRID_MM",i,11,"Not Applicable");
					ifr.setTableCellValue("NG_EIBOR_GRID_MM",i,12,"OK");
				}
								
			}
			for(int j=0;j<length1;j++){						
				String rateDF2 = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS",j,1);
				String tenorDF2 = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS",j,9);	
												
				if(rateDF2.isEmpty() || tenorDF2.isEmpty()){
					ifr.setTableCellValue("NG_EIBOR_GRID_DF2_DEALS",j,10,"Not Applicable");
					ifr.setTableCellValue("NG_EIBOR_GRID_DF2_DEALS",j,11,"OK");
				}
				
			}

			EIBOR.mLogger.info("Exit from for loop");
	
			
		}
		catch (Exception e)
		{
			EIBOR.mLogger.info("Loading to be reported Not applicable if tenor or rate is empty -:- "+e.toString());
		}
		return "";
	}
	
	
	public static long workingDays(LocalDate strdate,LocalDate enddate,IFormReference ifr ) throws ParseException
	{	
		
		long totalDays = ChronoUnit.DAYS.between(strdate, enddate);
		long weekend =0;
		for(LocalDate date = strdate; !date.isAfter(enddate); date=date.plusDays(1)){
			if(date.getDayOfWeek()==DayOfWeek.SUNDAY){
				weekend++;
			}
		}
		
		String holidayQuery = "select * from NG_EIBOR_MAST_PUBLIC_HLD WHERE DATE >= '"+strdate+"' AND DATE <= '"+enddate+"'";
		@SuppressWarnings("unchecked")
		List<List<String>> holidayDataFromDB = ifr.getDataFromDB(holidayQuery);
		long noOfHolidays = holidayDataFromDB.size();
		EIBOR.mLogger.info("No. of Weekends:"+ weekend);
		EIBOR.mLogger.info("No. of Holidays:"+ noOfHolidays);
		
		
		
		long count = 0;
		if(noOfHolidays>0){
			for(int j=0;j<noOfHolidays;j++){
				String datee = holidayDataFromDB.get(j).get(0);
				EIBOR.mLogger.info("Date from holiday Master:"+ datee);
				
				LocalDate dateFromDB= LocalDate.parse(datee);
				int day = dateFromDB.getDayOfWeek().getValue();
				EIBOR.mLogger.info("Day is--- "+ day);				
				if(day==7){
					count++;
				}

			}
			EIBOR.mLogger.info("Number of holidays on sunday----" + count);
		}
		/*EIBOR.mLogger.info("aaaaaatotalDays----" + totalDays);
		EIBOR.mLogger.info("aaaaaaweekend----" + weekend);
		EIBOR.mLogger.info("aaaaaaanoOfHolidays----" + noOfHolidays);
		EIBOR.mLogger.info("aaaaaacount----" + count);*/
			
		long workingDays = (((totalDays-weekend)-noOfHolidays)+count);
		
		return workingDays;
	}
	
	public static String clearRepeTables(IFormReference ifr){
		String[] allTableID = {"NG_EIBOR_GRID_DF1_REPETETIVE","NG_EIBOR_GRID_DF1_REPETETIVE_OW","NG_EIBOR_GRID_DF1_REPETETIVE_OM","NG_EIBOR_GRID_DF1_REPETETIVE_TM","NG_EIBOR_GRID_DF1_REPETETIVE_SM","NG_EIBOR_GRID_DF1_REPETETIVE_OY","Q_NG_EIBOR_GRID_HIST_IB_ON","Q_NG_EIBOR_GRID_HIST_IB_OW","Q_NG_EIBOR_GRID_HIST_IB_OM","Q_NG_EIBOR_GRID_HIST_IB_TM","Q_NG_EIBOR_GRID_HIST_IB_SM","Q_NG_EIBOR_GRID_HIST_IB_OY"};
		String[] allTableIdDf2 ={"NG_EIBOR_GRID_DF2_REPETETIVE","NG_EIBOR_GRID_DF2_REPETETIVE_OW","NG_EIBOR_GRID_DF2_REPETETIVE_OM","NG_EIBOR_GRID_DF2_REPETETIVE_TM","NG_EIBOR_GRID_DF2_REPETETIVE_SM","NG_EIBOR_GRID_DF2_REPETETIVE_OY","Q_NG_EIBOR_GRID_HIST_CUST_ON","Q_NG_EIBOR_GRID_HIST_CUST_OW","Q_NG_EIBOR_GRID_HIST_CUST_OM","Q_NG_EIBOR_GRID_HIST_CUST_TM","Q_NG_EIBOR_GRID_HIST_CUST_SM","Q_NG_EIBOR_GRID_HIST_CUST_OY"};
		for(int i=0;i<12;i++){
			ifr.clearTable(allTableID[i]);
			ifr.clearTable(allTableIdDf2[i]);
		}

		return "";
	}
	
	
	public static Date dateToDateTime(IFormReference ifr,Date date) throws ParseException{
		
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.set(Calendar.HOUR_OF_DAY,11);
		cal.set(Calendar.MINUTE,0);
		cal.set(Calendar.SECOND,0);
		
		return cal.getTime();
	}
	
	
	/*public static String duplicateRemove(IFormReference ifr,String rowCount) throws ParseException{
	
	int row = Integer.parseInt(rowCount);
	List<Integer> list = new ArrayList<Integer>();
	for(int i=0;i<row;i++){		
		String counterParty = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS", i, 0);
		String accountNo = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS", i, 5);
		String sourceName = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS", i, 10);
		for(int j=1;j<row;j++){
			String cptyCode = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS", j, 0);
			String acc = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS", j, 5);
			String source = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS", j, 10);
			
			if(counterParty.equalsIgnoreCase(cptyCode) && accountNo.equalsIgnoreCase(acc)){
				if(sourceName.contains("DF2") && source.contains("Finacle")){
					list.add(i);
				}
				else if(sourceName.contains("Finacle")&&source.contains("DF2")){
					list.add(j);
				}
			}
		}
	}
	
	return "" ;
	}*/
	
}

