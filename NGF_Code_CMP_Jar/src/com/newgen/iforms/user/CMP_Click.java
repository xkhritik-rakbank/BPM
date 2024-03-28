package com.newgen.iforms.user;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.newgen.iforms.custom.IFormReference;

public class CMP_Click extends CMPCommon
{
	public String clickEvent(IFormReference iform,String controlName,String event, String data)
	{
		CMP.mLogger.debug("controlName "+controlName);
		// TODO Auto-generated method stub
		if(controlName.equals("BtnRetryDuplicate") || controlName.equals("DedupeSubFormLoad"))
            return new CMPIntegration().onclickevent(iform, "BtnRetryDuplicate",data);
        else if(controlName.equals("BtnAttachDuplicate"))
            return new CMPIntegration().onclickevent(iform, "BtnAttachDuplicate",data);
        else if(controlName.equals("BtnRetryRiskScore") || controlName.equals("RiskScoreFormLoad"))
        	return new CMPIntegration().onclickevent(iform, "BtnRetryRiskScore",data);
        else if(controlName.equals("BtnPopulateDuplicate"))
            return new CMPIntegration().onclickevent(iform, "BtnPopulateDuplicate",data);
        else if(controlName.equals("BtnRetryBlacklist") || controlName.equals("BlacklistFormLoad"))
            return new CMPIntegration().onclickevent(iform, "BtnRetryBlacklist",data);
        else if(controlName.equals("BtnAttachBlacklist"))
            return new CMPIntegration().onclickevent(iform, "BtnAttachBlacklist",data);
        else
       	 return "";	
	}
}
