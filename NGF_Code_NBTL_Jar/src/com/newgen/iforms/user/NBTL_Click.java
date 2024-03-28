package com.newgen.iforms.user;

import com.newgen.iforms.custom.IFormReference;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import java.io.*;
import java.util.*;

public class NBTL_Click {
	private String WI_Name = null;
	private String activityName = null;
	
	public String onClick(IFormReference iformObj, String control, String data)	{
		try{
		WI_Name = iformObj.getObjGeneralData().getM_strProcessInstanceId();
		activityName = iformObj.getActivityName();
		NBTL.mLogger.debug("ActivityName-->"+activityName+" WI_Name-->"+WI_Name +" control-->"+control+"Inside onClick...debug");
		String res = "";
			if(control.equalsIgnoreCase("GetOldTL"))
			{
				res = NBTL_CommonMethods.getOldTL(iformObj);
			}
			if(!(res.equalsIgnoreCase("false")))
				return res;
			else	
				return "false";
		}		
		catch(Exception e)
		{
			NBTL.mLogger.debug("ActivityName-->"+activityName+" WI_Name-->"+WI_Name +" control-->"+control+ e);
			return "false";
		}
		
	}
}


