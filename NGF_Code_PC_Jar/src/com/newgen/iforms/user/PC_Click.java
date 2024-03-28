package com.newgen.iforms.user;

import com.newgen.iforms.custom.IFormReference;

public class PC_Click {

	public String clickEvent(IFormReference iform, String controlName, String data)
	{
		 if(controlName.equals("btn_CIF_Search"))
             return new PCIntegration().onclickevent(iform, "btn_CIF_Search",data);
         else if(controlName.equals("tblCIF"))
             return new PCIntegration().onclickevent(iform, "tblCIF",data);
         else if(controlName.equals("btn_CIF_Clear"))
         	return new PCIntegration().onclickevent(iform, "btn_CIF_Clear","");
         else if(controlName.equals("btn_View_Signature"))
             return new PCIntegration().onclickevent(iform, "btn_View_Signature",data);
         else
        	 return "";		
	}
}
