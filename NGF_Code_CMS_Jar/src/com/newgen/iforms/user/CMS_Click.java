package com.newgen.iforms.user;

import com.newgen.iforms.custom.IFormReference;

public class CMS_Click {

	public String clickEvent(IFormReference iform, String controlName, String data)
	{
		CMS.mLogger.debug("inside cms_click");
		 if(controlName.equals("btn_Populate"))
             return new CMSIntegration().onclickevent(iform, "btn_Populate",data);
         else if(controlName.equals("btn_View_Signature"))
             return new CMSIntegration().onclickevent(iform, "btn_View_Signature",data);
         else
        	 return "";		
	}
}
