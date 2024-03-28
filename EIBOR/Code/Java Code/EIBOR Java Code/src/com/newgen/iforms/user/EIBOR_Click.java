package com.newgen.iforms.user;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.xml.parsers.ParserConfigurationException;

import org.xml.sax.SAXException;

import com.newgen.iforms.custom.IFormReference;

public class EIBOR_Click extends EIBOR_Common {

	public String clickEvent(IFormReference iform, String controlName, String data) throws FileNotFoundException, IOException, ParserConfigurationException, SAXException 
	{
		EIBOR.mLogger.debug("EIBOR_Clicks");
		EIBOR.mLogger.debug("WINAME : " + getWorkitemName(iform) + ", WSNAME: " + getActivityName(iform) + ", controlName " + controlName + ", data " + data);
		EIBOR.mLogger.debug("controlName" + controlName);
		
		
		

		return "";
	}
}
