package com.newgen.iforms.user;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import com.newgen.iforms.EControl;
import com.newgen.iforms.FormDef;
import com.newgen.iforms.custom.IFormReference;
import com.newgen.iforms.custom.IFormServerEventHandler;
import com.newgen.mvcbeans.model.wfobjects.WDGeneralData;
import com.newgen.mvcbeans.model.WorkdeskModel;
import com.newgen.mvcbeans.model.wfobjects.WDGeneralData;


public class NBTL_EventHandler extends NBTL_CommonMethods implements IFormServerEventHandler
{	
	
	private static final long serialVersionUID = 1L;
	public IFormReference iFormOBJECT;
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
		//CSR_OCC.setLogger();
		System.out.println("Inside executeServerEvent() ak 101 ---control");
		NBTL.mLogger.debug("Inside executeServerEvent() ak 101 ---control: " + control + "\nevent: " + event + "\nStringData: "
				);
		wdgeneralObj = iformObj.getObjGeneralData();
		sessionId = wdgeneralObj.getM_strDMSSessionId();
		iFormOBJECT = iformObj;
		
		event = event.toLowerCase();
		
		switch(event)
		{
			case "formload": return new NBTL_FormLoad().formLoad(iformObj, control, Stringdata);
			case "click" : return new NBTL_Click().onClick(iformObj, control, Stringdata);
			case "introducedone" : return new NBTL_IntroDone().onIntroDone(iformObj, control, Stringdata);
			case "onchange" :return new OnChange().OnChangeEvent(iformObj, control, Stringdata);	
			default: return "";
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

	@Override
	public String generateHTML(EControl arg0) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean introduceWorkItemInSpecificProcess(IFormReference arg0, String arg1) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public String introduceWorkItemInWorkFlow(IFormReference arg0, HttpServletRequest arg1, HttpServletResponse arg2) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String introduceWorkItemInWorkFlow(IFormReference arg0, HttpServletRequest arg1, HttpServletResponse arg2,
			WorkdeskModel arg3) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String onChangeEventServerSide(IFormReference arg0, String arg1) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String postHookExportToPDF(IFormReference arg0, File arg1) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void postHookOnDocumentUpload(IFormReference arg0, String arg1, String arg2, File arg3, int arg4) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateDataInWidget(IFormReference arg0, String arg1) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public String validateDocumentConfiguration(String arg0, String arg1, File arg2, Locale arg3) {
		// TODO Auto-generated method stub
		return null;
	}
}

