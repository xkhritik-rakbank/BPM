package com.newgen.iforms.user;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.newgen.iforms.custom.IFormReference;

public class EIBOR_Change extends EIBOR_Common {

	public String changeEvent(IFormReference ifr, String controlName, String event, String data) {
		
		EIBOR.mLogger.debug("Data coming from js--"+data);
		
		
		String[] allTableID = {"NG_EIBOR_GRID_DF1","NG_EIBOR_GRID_History_IB_DATA","NG_EIBOR_GRID_DF1_REPETETIVE","NG_EIBOR_GRID_DF1_REPETETIVE_OW","NG_EIBOR_GRID_DF1_REPETETIVE_OM","NG_EIBOR_GRID_DF1_REPETETIVE_TM","NG_EIBOR_GRID_DF1_REPETETIVE_SM","NG_EIBOR_GRID_DF1_REPETETIVE_OY","Q_NG_EIBOR_GRID_HIST_IB_ON","Q_NG_EIBOR_GRID_HIST_IB_OW","Q_NG_EIBOR_GRID_HIST_IB_OM","Q_NG_EIBOR_GRID_HIST_IB_TM","Q_NG_EIBOR_GRID_HIST_IB_SM","Q_NG_EIBOR_GRID_HIST_IB_OY"};
		String[] allTableIdDf2 ={"NG_EIBOR_GRID_DF2","NG_EIBOR_GRID_History_CUST_DATA","NG_EIBOR_GRID_DF2_REPETETIVE","NG_EIBOR_GRID_DF2_REPETETIVE_OW","NG_EIBOR_GRID_DF2_REPETETIVE_OM","NG_EIBOR_GRID_DF2_REPETETIVE_TM","NG_EIBOR_GRID_DF2_REPETETIVE_SM","NG_EIBOR_GRID_DF2_REPETETIVE_OY","Q_NG_EIBOR_GRID_HIST_CUST_ON","Q_NG_EIBOR_GRID_HIST_CUST_OW","Q_NG_EIBOR_GRID_HIST_CUST_OM","Q_NG_EIBOR_GRID_HIST_CUST_TM","Q_NG_EIBOR_GRID_HIST_CUST_SM","Q_NG_EIBOR_GRID_HIST_CUST_OY"};
		for(int i=0;i<14;i++){
			ifr.clearTable(allTableID[i]);
			ifr.clearTable(allTableIdDf2[i]);
		}
		EIBOR.mLogger.debug("All tables are cleared");
		
		EIBOR_FormLoad.dataLoadInDF1Repe(ifr);
		EIBOR.mLogger.debug("dataLoadIn_DF1_Repe success");
		
		EIBOR_FormLoad.dataLoadInHISTIBRepe(ifr);
		EIBOR.mLogger.debug("dataLoadIn_HIST_IB_Repe success");
		
		EIBOR_FormLoad.dataLoadInDF2Repe(ifr);
		EIBOR.mLogger.debug("dataLoadIn_DF2_Repe success");
		
		EIBOR_FormLoad.dataLoadInHISTCUSTRepe(ifr);
		EIBOR.mLogger.debug("dataLoadIn_HIST_CUST_Repe success");
		
		EIBOR_FormLoad.dataLoadInAllCommonGrid(ifr);
		
		EIBOR_FormLoad.dataLoadInDF1(ifr);
		EIBOR.mLogger.debug("dataLoadIn_DF1 success");
		
		EIBOR_FormLoad.dataLoadInHistIB(ifr);
		EIBOR.mLogger.debug("dataLoadIn_Hist_IB success");
		
		EIBOR_FormLoad.dataLoadInDF2(ifr);
		EIBOR.mLogger.debug("dataLoadIn_DF2 success");
		
		EIBOR_FormLoad.dataLoadInHistCust(ifr);
		EIBOR.mLogger.debug("dataLoadIn_Hist_cust success");
		
		for(int j =2; j<14;j++){
			String cp = ifr.getTableCellValue(allTableID[j], 0, 0);
			String cptycode = ifr.getTableCellValue(allTableIdDf2[j], 0, 0);
			if(cp.equalsIgnoreCase("")){
				ifr.setStyle(allTableID[j],"visible","false");
			}
			if(cptycode.equalsIgnoreCase("")){
				ifr.setStyle(allTableIdDf2[j],"visible","false");
			}
			
		}
		
		return "";
	}

}