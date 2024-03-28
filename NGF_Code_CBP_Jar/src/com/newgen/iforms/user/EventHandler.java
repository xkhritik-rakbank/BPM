package com.newgen.iforms.user;

import org.json.simple.JSONArray;
import com.newgen.iforms.*;
import com.newgen.iforms.custom.IFormReference;
import com.newgen.iforms.custom.IFormServerEventHandler;
import com.newgen.mvcbeans.model.wfobjects.WDGeneralData;


public class EventHandler extends CBPCommon  implements IFormServerEventHandler
{
	
	public static IFormReference iFormOBJECT;
	public String sessionId="";
	
	public WDGeneralData wdgeneralObj;
	
	@Override
	public void beforeFormLoad(FormDef arg0, IFormReference arg1) 
	{
	}

	@Override
	public String executeCustomService(FormDef arg0, IFormReference arg1,
			String arg2, String arg3, String arg4) 
	{
		return null;
	}

	@Override
	public JSONArray executeEvent(FormDef arg0, IFormReference arg1,String arg2, String arg3) 
	{
		return null;
	}

	public String executeServerEvent(IFormReference iformObj, String control,String event, String Stringdata) 
	{	
		CBP.mLogger.info("Inside executeServerEvent() ak 107 ---control: " + control + "\nevent: " + event);
		wdgeneralObj = iformObj.getObjGeneralData();
		sessionId = wdgeneralObj.getM_strDMSSessionId();
		iFormOBJECT = iformObj;
		
		event = event.toUpperCase();
		switch(event)
		{
		
			case "FORMLOAD": return new CBP_FormLoad().formLoadEvent(iformObj,control,Stringdata);
			case "INTRODUCEDONE" :	 return new CBP_IntroDone().onIntroduceDone(iformObj, control, Stringdata);
			default: return "";
			/*case "CLICK" : return new PC_Click().clickEvent(iformObj,control,Stringdata);
			case "INTRODUCEDONE" :	 return new PC_IntroDone().onIntroduceDone(iformObj, control, Stringdata);
			default: return "";*/
		}
	}

	@Override
	public String getCustomFilterXML(FormDef arg0, IFormReference arg1,String arg2) 
	{
		return null;
	}

	@Override
	public String setMaskedValue(String arg0, String arg1) 
	{	return arg1;
	}

	@Override
	public JSONArray validateSubmittedForm(FormDef arg0, IFormReference arg1,
			String arg2) 
	{
		return null;
	}
}

