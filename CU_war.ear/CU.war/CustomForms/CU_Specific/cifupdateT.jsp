<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application ?Projects
//Product / Project			 : RAKBank
//File Name					 :
//Author                     : Shubham Ruhela
//Date written (DD/MM/YYYY) :  15-01-2016
//---------------------------------------------------------------------------------------------------->

<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="../CU_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>
<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<script language="javascript" src="/webdesktop/webtop/scripts/jquery-latest.js"></script>
<script language="javascript" src="/webdesktop/webtop/scripts/jquery.autocomplete.js"></script>

<HTML>
<HEAD>
	<TITLE> <%=request.getParameter("wi_name")%>: CIF Update Form</TITLE>
	<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Expires" content="0" />
	<style>
		@import url("/webdesktop/webtop/en_us/css/docstyle.css");
	</style>
	<script src="js/CUvalidate.js"></script>
	<style>
		td {
			background-color : rgba(254, 250, 239, 1);
			padding-left:5px;
			padding-right:5px;
			padding-top:2px;
			padding-bottom:2px;
		}
		th{
			padding-left:5px;
			padding-right:5px;
			padding-top:2px;
			padding-bottom:2px;
			text-align: left;
		}
		.underlineText
		{
			border-bottom: 1px solid #000;
		}
		.labelT
		{
			font-weight: bold;
		}		
		.panel-title > .small, .panel-title > .small > a, .panel-title > a, .panel-title > small, .panel-title > small > a {
			color: white;
		}
	</style>
</HEAD>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onload="window.print();">
<%			
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("passport_numN"), 1000, true) );
			String passport_numN_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("passport_numE"), 1000, true) );
			String passport_numE_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("last_nameN"), 1000, true) );
			String last_nameN_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("last_nameE"), 1000, true) );
			String last_nameE_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("middle_nameN"), 1000, true) );
			String middle_nameN_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			
			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("middle_nameE"), 1000, true) );
			String middle_nameE_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			
			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("first_nameN"), 1000, true) );
			String first_nameN_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
			
			String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("first_nameE"), 1000, true) );
			String first_nameE_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
			
			String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );
			String wi_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
			
			String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("estatementRegE"), 1000, true) );
			String estatementRegE_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
			
			String input11= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("estatementRegN"), 1000, true) );
			String estatementRegN_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input11!=null?input11:"");
			
			String input12= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("maritalstatusE"), 1000, true) );
			String maritalstatusE_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input12!=null?input12:"");
			
			String input13= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("maritalstatusN"), 1000, true) );
			String maritalstatusN_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input13!=null?input13:"");
			
			String input14= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("estatementreg_exist"), 1000, true) );
			String estatementreg_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input14!=null?input14:"");
			
			String input15= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("estatementreg_new"), 1000, true) );
			String estatementreg_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input15!=null?input15:"");
			
			String input16= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("emiratesid_exist"), 1000, true) );
			String emiratesid_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input16!=null?input16:"");
			
			String input17= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("emiratesid_new"), 1000, true) );
			String emiratesid_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input17!=null?input17:"");
			
			String input18 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("emiratesidexp_exist"), 1000, true) );
			String emiratesidexp_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input18!=null?input18:"");
			
			String input19= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("emiratesidexp_new"), 1000, true) );
			String emiratesidexp_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input19!=null?input19:"");
			
			String input20= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("passportExpDate_exist"), 1000, true) );
			String passportExpDate_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input20!=null?input20:"");
			
			String input21= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("passportExpDate_new"), 1000, true) );
			String passportExpDate_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input21!=null?input21:"");
			
			String input22 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("visa_exist"), 1000, true) );
			String visa_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input22!=null?input22:"");
			
			String input23 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("visa_new"), 1000, true) );
			String visa_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input23!=null?input23:"");
			
			String input24 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("visaExpDate_exist"), 1000, true) );
			String visaExpDate_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input24!=null?input24:"");
			
			String input25 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("visaExpDate_new"), 1000, true) );
			String visaExpDate_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input25!=null?input25:"");
			
			String input26 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("mother_maiden_name_exist"), 1000, true) );
			String mother_maiden_name_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input26!=null?input26:"");
			
			String input27 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("mother_maiden_name_new"), 1000, true) );
			String mother_maiden_name_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input27!=null?input27:"");
			
			String input28= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("usnatholder_exist"), 1000, true) );
			String usnatholder_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input28!=null?input28:"");
			
			String input29= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("usnatholder_new"), 1000, true) );
			String usnatholder_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input29!=null?input29:"");
			
			String input30= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput",
			request.getParameter("usresi_exist"), 1000, true) );
			String usresi_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input30!=null?input30:"");
			
			String input31 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("usresi_new"), 1000, true) );
			String usresi_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input31!=null?input31:"");
			
			String input32= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("usgreencardhol_exist"), 1000, true) );
			String usgreencardhol_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input32!=null?input32:"");
			
			String input33= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("usgreencardhol_new"), 1000, true) );
			String usgreencardhol_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input33!=null?input33:"");
			
			String input34= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("us_tax_payer_exist"), 1000, true) );
			String us_tax_payer_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input34!=null?input34:"");
			
			String input35= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("us_tax_payer_new"), 1000, true) );
			String us_tax_payer_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input35!=null?input35:"");
			
			String input36= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("usborn_exist"), 1000, true) );
			String usborn_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input36!=null?input36:"");
			
			String input37 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("usborn_new"), 1000, true) );
			String usborn_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input37!=null?input37:"");
			
			String input38 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("nocnofbirth_exist"), 1000, true) );
			String nocnofbirth_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input38!=null?input38:"");
			
			String input39 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("nocnofbirth_new"), 1000, true) );
			String nocnofbirth_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input39!=null?input39:"");
			
			String input40 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("abcdelig_exist"), 1000, true) );
			String abcdelig_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input40!=null?input40:"");
			
			String input41 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("abcdelig_new"), 1000, true) );
			String abcdelig_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input41!=null?input41:"");
			
			String input42 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("resiadd_exist"), 1000, true) );
			String resiadd_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input42!=null?input42:"");
			
			String input43 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("resiadd_new"), 1000, true) );
			String resiadd_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input43!=null?input43:"");
			
			String input44 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("officeadd_exist"), 1000, true) );
			String officeadd_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input44!=null?input44:"");
			
			String input45 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("officeadd_new"), 1000, true) );
			String officeadd_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input45!=null?input45:"");
			
			String input46 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("preadd_exist"), 1000, true) );
			String preadd_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input46!=null?input46:"");
			
			String input47 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("preadd_new"), 1000, true) );
			String preadd_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input47!=null?input47:"");
			
			String input48 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("priemailid_exist"), 1000, true) );
			String priemailid_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input48!=null?input48:"");
			
			String input49 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("priemailid_new"), 1000, true) );
			String priemailid_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input49!=null?input49:"");
			
			String input50 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("mob_phone_exist"), 1000, true) );
			String mob_phone_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input50!=null?input50:"");
			
			String input51 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("mob_phone_newC"), 1000, true) );
			String mob_phone_newC_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input51!=null?input51:"");
			
			String input52 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("mob_phone_newN"), 1000, true) );
			String mob_phone_newN_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input52!=null?input53:"");
			
			String input53 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("mob_phone_newE"), 1000, true) );
			String mob_phone_newE_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input54!=null?input54:"");
			
			String input54 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("sec_mob_phone_exist"), 1000, true) );
			String sec_mob_phone_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input54!=null?input54:"");
			
			String input55 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("sec_mob_phone_newC"), 1000, true) );
			String sec_mob_phone_newC_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input55!=null?input55:"");
			
			String input56 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("sec_mob_phone_newN"), 1000, true) );
			String sec_mob_phone_newN_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input56!=null?input56:"");
			
			String input57 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("sec_mob_phone_newE"), 1000, true) );
			String sec_mob_phone_newE_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input57!=null?input57:"");
			
			String input58 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("homephone_exist"), 1000, true) );
			String homephone_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input58!=null?input58:"");
			
			String input59 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("homephone_newC"), 1000, true) );
			String homephone_newC_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input59!=null?input59:"");
			
			String input60 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("homephone_newN"), 1000, true) );
			String homephone_newN_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input60!=null?input60:"");
			
			String input61 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("homephone_newE"), 1000, true) );
			String homephone_newE_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input61!=null?input61:"");
			
			String input62 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("officephone_exist"), 1000, true) );
			String officephone_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input62!=null?input62:"");
			
			String input63 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("officephone_newC"), 1000, true) );
			String officephone_newC_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input63!=null?input63:"");
			
			String input64 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("officephone_newN"), 1000, true) );
			String officephone_newN_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input64!=null?input64:"");
			
			String input65 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("officephone_newE"), 1000, true) );
			String officephone_newE_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input65!=null?input65:"");
			
			String input66 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("homecntryphone_exist"), 1000, true) );
			String homecntryphone_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input66!=null?input66:"");
			
			String input67= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("homecntryphone_newC"), 1000, true) );
			String homecntryphone_newC_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input67!=null?input67:"");
			
			String input68 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("homecntryphone_newN"), 1000, true) );
			String homecntryphone_newN_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input68!=null?input68:"");
			
			String input69 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("homecntryphone_newE"), 1000, true) );
			String homecntryphone_newE_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input69!=null?input69:"");
			
			String input70 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("fax_exist"), 1000, true) );
			String fax_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input70!=null?input70:"");
			
			String input71 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("fax_newC"), 1000, true) );
			String fax_newC_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input71!=null?input71:"");
			
			String input72 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("fax_newN"), 1000, true) );
			String fax_newN_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input72!=null?input72:"");
			
			String input73 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("fax_newE"), 1000, true) );
			String fax_newE_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input73!=null?input73:"");
			
			String input74 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("prefcontact_exist"), 1000, true) );
			String prefcontact_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input74!=null?input74:"");
			
			
			String input75 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("prefcontact_new"), 1000, true) );
			String prefcontact_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input75!=null?input75:"");
			
			String input76 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("emp_type_exist"), 1000, true) );
			String emp_type_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input76!=null?input76:"");
			
			String input77 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("emp_type_new"), 1000, true) );
			String emp_type_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input77!=null?input77:"");
			
			String input78 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("designation_exist"), 1000, true) );
			String designation_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input78!=null?input78:"");
			
			String input79 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("designation_new"), 1000, true) );
			String designation_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input79!=null?input79:"");
			
			String input80 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("comp_name_exist"), 1000, true) );
			String comp_name_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input80!=null?input80:"");
			
			String input81 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("comp_name_new"), 1000, true) );
			String comp_name_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input81!=null?input81:"");
			
			String input82 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("emp_name_exist"), 1000, true) );
			String emp_name_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input82!=null?input82:"");
			
			String input83 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("emp_name_new"), 1000, true) );
			String emp_name_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input83!=null?input83:"");
			
			String input84 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("department_exist"), 1000, true) );
			String department_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input84!=null?input84:"");
			
			String input85 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("department_new"), 1000, true) );
			String department_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input85!=null?input85:"");
			
			String input86 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("employee_num_exist"), 1000, true) );
			String employee_num_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input86!=null?input86:"");
			
			String input87 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("employee_num_new"), 1000, true) );
			String employee_num_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input87!=null?input87:"");
			
			String input88 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("occupation_exist"), 1000, true) );
			String occupation_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input88!=null?input88:"");
			
			String input89 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("occupation_new"), 1000, true) );
			String occupation_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input89!=null?input89:"");
			
			String input90 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("naturebusiness_exist"), 1000, true) );
			String naturebusiness_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input90!=null?input90:"");
			
			String input91 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("naturebusiness_new"), 1000, true) );
			String naturebusiness_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input91!=null?input91:"");
			
			String input92 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("total_year_of_emp_exist"), 1000, true) );
			String total_year_of_emp_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input92!=null?input92:"");
			
			String input93 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("total_year_of_emp_new"), 1000, true) );
			String total_year_of_emp_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input93!=null?input93:"");
			
			String input94 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("years_of_business_exist"), 1000, true) );
			String years_of_business_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input94!=null?input94:"");
			
			String input95 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("years_of_business_new"), 1000, true) );
			String years_of_business_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input95!=null?input95:"");
			
			String input96 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("employment_status_exist"), 1000, true) );
			String employment_status_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input96!=null?input96:"");
			
			String input97= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("employment_status_new"), 1000, true) );
			String employment_status_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input97!=null?input97:"");
			
			String input98 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("date_join_curr_employer_exist"), 1000, true) );
			String date_join_curr_employer_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input98!=null?input98:"");
			
			String input99 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("date_join_curr_employer_new"), 1000, true) );
			String date_join_curr_employer_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input99!=null?input99:"");
			
			String input100 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("maritalstatus_exist"), 1000, true) );
			String maritalstatus_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input100!=null?input100:"");
			
			String input101 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("maritalstatus_new"), 1000, true) );
			String maritalstatus_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input101!=null?input101:"");
			
			String input102 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("noofdep_exist"), 1000, true) );
			String noofdep_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input102!=null?input102:"");
			
			String input103 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("noofdep_new"), 1000, true) );
			String noofdep_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input103!=null?input103:"");
			
			String input104 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("countryresNat_exist"), 1000, true) );
			String countryresNat_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input104!=null?input104:"");
			
			String input105 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("countryresNat_new"), 1000, true) );
			String countryresNat_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input105!=null?input105:"");
			
			String input106 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wheninuae_exist"), 1000, true) );
			String wheninuae_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input106!=null?input106:"");
			
			String input107 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wheninuae_new"), 1000, true) );
			String wheninuae_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input107!=null?input107:"");
			
			String input108 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("preempdetails_exist"), 1000, true) );
			String preempdetails_exist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input108!=null?input108:"");
			
			String input109 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("preempdetails_new"), 1000, true) );
			String preempdetails_new_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input109!=null?input109:""); 

			
			
			 
			
	
	String cur_date=null;	
	
	
	
/* String passport_numN = request.getParameter("passport_numN");
	String passport_numE = request.getParameter("passport_numE");
	String last_nameN = request.getParameter("last_nameN");
	String last_nameE = request.getParameter("last_nameE");
	String middle_nameN = request.getParameter("middle_nameN");
	String middle_nameE = request.getParameter("middle_nameE");
	String first_nameN = request.getParameter("first_nameN");
	String first_nameE = request.getParameter("first_nameE");
	String wi_name = request.getParameter("wi_name");
	String estatementRegE = request.getParameter("estatementRegE");
	String estatementRegN = request.getParameter("estatementRegN");
	String maritalstatusE = request.getParameter("maritalstatusE");
	String maritalstatusN = request.getParameter("maritalstatusN");
	String estatementreg_exist = request.getParameter("estatementreg_exist");
	String estatementreg_new = request.getParameter("estatementreg_new");
	String emiratesid_exist = request.getParameter("emiratesid_exist");
	String emiratesid_new = request.getParameter("emiratesid_new");
	String emiratesidexp_exist = request.getParameter("emiratesidexp_exist");
	String emiratesidexp_new = request.getParameter("emiratesidexp_new");
	String passportExpDate_exist = request.getParameter("passportExpDate_exist");
	String passportExpDate_new = request.getParameter("passportExpDate_new");
	String visa_exist = request.getParameter("visa_exist");
	String visa_new = request.getParameter("visa_new");
	String visaExpDate_exist = request.getParameter("visaExpDate_exist");
	String visaExpDate_new = request.getParameter("visaExpDate_new");
	String mother_maiden_name_exist = request.getParameter("mother_maiden_name_exist");
	String mother_maiden_name_new = request.getParameter("mother_maiden_name_new");
	String usnatholder_exist = request.getParameter("usnatholder_exist");
	String usnatholder_new = request.getParameter("usnatholder_new");
	String usresi_exist = request.getParameter("usresi_exist");
	String usresi_new = request.getParameter("usresi_new");
	String usgreencardhol_exist = request.getParameter("usgreencardhol_exist");
	String usgreencardhol_new = request.getParameter("usgreencardhol_new");
	String us_tax_payer_exist = request.getParameter("us_tax_payer_exist");
	String us_tax_payer_new = request.getParameter("us_tax_payer_new");
	String usborn_exist = request.getParameter("usborn_exist");
	String usborn_new = request.getParameter("usborn_new");
	String nocnofbirth_exist = request.getParameter("nocnofbirth_exist");
	String nocnofbirth_new = request.getParameter("nocnofbirth_new");
	String abcdelig_exist = request.getParameter("abcdelig_exist");
	String abcdelig_new = request.getParameter("abcdelig_new");
	String resiadd_exist = request.getParameter("resiadd_exist");
	String resiadd_new = request.getParameter("resiadd_new");
	String officeadd_exist = request.getParameter("officeadd_exist");
	String officeadd_new = request.getParameter("officeadd_new");
	String preadd_exist = request.getParameter("preadd_exist");
	String preadd_new = request.getParameter("preadd_new");
	String priemailid_exist = request.getParameter("priemailid_exist");
	String priemailid_new = request.getParameter("priemailid_new");
	String mob_phone_exist = request.getParameter("mob_phone_exist");
	String mob_phone_newC = request.getParameter("mob_phone_newC");
	String mob_phone_newN = request.getParameter("mob_phone_newN");
	String mob_phone_newE = request.getParameter("mob_phone_newE");
	String sec_mob_phone_exist = request.getParameter("sec_mob_phone_exist");
	String sec_mob_phone_newC = request.getParameter("sec_mob_phone_newC");
	String sec_mob_phone_newN = request.getParameter("sec_mob_phone_newN");
	String sec_mob_phone_newE = request.getParameter("sec_mob_phone_newE");
	String homephone_exist = request.getParameter("homephone_exist");
	String homephone_newC = request.getParameter("homephone_newC");
	String homephone_newN = request.getParameter("homephone_newN");
	String homephone_newE = request.getParameter("homephone_newE");
	String officephone_exist = request.getParameter("officephone_exist");
	String officephone_newC = request.getParameter("officephone_newC");
	String officephone_newN = request.getParameter("officephone_newN");
	String officephone_newE = request.getParameter("officephone_newE");
	String homecntryphone_exist = request.getParameter("homecntryphone_exist");
	String homecntryphone_newC = request.getParameter("homecntryphone_newC");
	String homecntryphone_newN = request.getParameter("homecntryphone_newN");
	String homecntryphone_newE = request.getParameter("homecntryphone_newE");
	String fax_exist = request.getParameter("fax_exist");
	String fax_newC = request.getParameter("fax_newC");
	String fax_newN = request.getParameter("fax_newN");
	String fax_newE = request.getParameter("fax_newE");
	String prefcontact_exist = request.getParameter("prefcontact_exist");
	String prefcontact_new = request.getParameter("prefcontact_new");
	String emp_type_exist = request.getParameter("emp_type_exist");
	String emp_type_new = request.getParameter("emp_type_new");
	String designation_exist = request.getParameter("designation_exist");
	String designation_new = request.getParameter("designation_new");
	String comp_name_exist = request.getParameter("comp_name_exist");
	String comp_name_new = request.getParameter("comp_name_new");
	String emp_name_exist = request.getParameter("emp_name_exist");
	String emp_name_new = request.getParameter("emp_name_new");
	String department_exist = request.getParameter("department_exist");
	String department_new = request.getParameter("department_new");
	String employee_num_exist = request.getParameter("employee_num_exist");
	String employee_num_new = request.getParameter("employee_num_new");
	String occupation_exist = request.getParameter("occupation_exist");
	String occupation_new = request.getParameter("occupation_new");
	String naturebusiness_exist = request.getParameter("naturebusiness_exist");
	String naturebusiness_new = request.getParameter("naturebusiness_new");
	String total_year_of_emp_exist = request.getParameter("total_year_of_emp_exist");
	String total_year_of_emp_new = request.getParameter("total_year_of_emp_new");
	String years_of_business_exist = request.getParameter("years_of_business_exist");
	String years_of_business_new = request.getParameter("years_of_business_new");
	String employment_status_exist = request.getParameter("employment_status_exist");
	String employment_status_new = request.getParameter("employment_status_new");
	String date_join_curr_employer_exist = request.getParameter("date_join_curr_employer_exist");
	String date_join_curr_employer_new = request.getParameter("date_join_curr_employer_new");
	String maritalstatus_exist = request.getParameter("maritalstatus_exist");
	String maritalstatus_new = request.getParameter("maritalstatus_new");
	String noofdep_exist = request.getParameter("noofdep_exist");
	String noofdep_new = request.getParameter("noofdep_new");
	String countryresNat_exist = request.getParameter("countryresNat_exist");
	String countryresNat_new = request.getParameter("countryresNat_new");
	String wheninuae_exist = request.getParameter("wheninuae_exist");
	String wheninuae_new = request.getParameter("wheninuae_new");
	String preempdetails_exist = request.getParameter("preempdetails_exist");
	String preempdetails_new = request.getParameter("preempdetails_new"); */
	
	

	String passport_numN =passport_numN_Esapi;
	String passport_numE =passport_numE_Esapi;
	String last_nameN =last_nameN_Esapi;
	String last_nameE =last_nameE_Esapi;
	String middle_nameN =middle_nameN_Esapi;
	String middle_nameE =middle_nameE_Esapi;
	String first_nameN =first_nameN_Esapi;
	String first_nameE =first_nameE_Esapi;
	String wi_name =wi_name_Esapi;
	String estatementRegE =estatementRegE_Esapi;
	String estatementRegN =estatementRegN_Esapi;
	String maritalstatusE =maritalstatusE_Esapi;
	String maritalstatusN =maritalstatusN_Esapi;
	String estatementreg_exist =estatementreg_exist_Esapi;
	String estatementreg_new =estatementreg_new_Esapi;
	String emiratesid_exist =emiratesid_exist_Esapi;
	String emiratesid_new =emiratesid_new_Esapi;
	String emiratesidexp_exist =emiratesidexp_exist_Esapi;
	String emiratesidexp_new =emiratesidexp_new_Esapi;
	String passportExpDate_exist =passportExpDate_exist_Esapi;
	String passportExpDate_new =passportExpDate_new_Esapi;
	String visa_exist =visa_exist_Esapi;
	String visa_new =visa_new_Esapi;
	String visaExpDate_exist =visaExpDate_exist_Esapi;
	String visaExpDate_new =visaExpDate_new_Esapi;
	String mother_maiden_name_exist =mother_maiden_name_exist_Esapi;
	String mother_maiden_name_new =mother_maiden_name_new_Esapi;
	String usnatholder_exist =usnatholder_exist_Esapi;
	String usnatholder_new =usnatholder_new_Esapi;
	String usresi_exist =usresi_exist_Esapi;
	String usresi_new =usresi_new_Esapi;
	String usgreencardhol_exist =usgreencardhol_exist_Esapi;
	String usgreencardhol_new =usgreencardhol_new_Esapi;
	String us_tax_payer_exist =us_tax_payer_exist_Esapi;
	String us_tax_payer_new =us_tax_payer_new_Esapi;
	String usborn_exist =usborn_exist_Esapi;
	String usborn_new =usborn_new_Esapi;
	String nocnofbirth_exist =nocnofbirth_exist_Esapi;
	String nocnofbirth_new =nocnofbirth_new_Esapi;
	String abcdelig_exist =abcdelig_exist_Esapi;
	String abcdelig_new =abcdelig_new_Esapi;
	String resiadd_exist =resiadd_exist_Esapi;
	String resiadd_new =resiadd_new_Esapi;
	String officeadd_exist =officeadd_exist_Esapi;
	String officeadd_new =officeadd_new_Esapi;
	String preadd_exist =preadd_exist_Esapi;
	String preadd_new =preadd_new_Esapi;
	String priemailid_exist =priemailid_exist_Esapi;
	String priemailid_new =priemailid_new_Esapi;
	String mob_phone_exist =mob_phone_exist_Esapi;
	String mob_phone_newC =mob_phone_newC_Esapi;
	String mob_phone_newN =mob_phone_newN_Esapi;
	String mob_phone_newE =mob_phone_newE_Esapi;
	String sec_mob_phone_exist =sec_mob_phone_exist_Esapi;
	String sec_mob_phone_newC =sec_mob_phone_newC_Esapi;
	String sec_mob_phone_newN =sec_mob_phone_newN_Esapi;
	String sec_mob_phone_newE =sec_mob_phone_newE_Esapi;
	String homephone_exist =homephone_exist_Esapi;
	String homephone_newC =homephone_newC_Esapi;
	String homephone_newN =homephone_newN_Esapi;
	String homephone_newE =homephone_newE_Esapi;
	String officephone_exist =officephone_exist_Esapi;
	String officephone_newC =officephone_newC_Esapi;
	String officephone_newN =officephone_newN_Esapi;
	String officephone_newE =officephone_newE_Esapi;
	String homecntryphone_exist =homecntryphone_exist_Esapi;
	String homecntryphone_newC =homecntryphone_newC_Esapi;
	String homecntryphone_newN =homecntryphone_newN_Esapi;
	String homecntryphone_newE =homecntryphone_newE_Esapi;
	String fax_exist =fax_exist_Esapi;
	String fax_newC =fax_newC_Esapi;
	String fax_newN =fax_newN_Esapi;
	String fax_newE =fax_newE_Esapi;
	String prefcontact_exist =prefcontact_exist_Esapi;
	String prefcontact_new =prefcontact_new_Esapi;
	String emp_type_exist =emp_type_exist_Esapi;
	String emp_type_new =emp_type_new_Esapi;
	String designation_exist =designation_exist_Esapi;
	String designation_new =designation_new_Esapi;
	String comp_name_exist =comp_name_exist_Esapi;
	String comp_name_new =comp_name_new_Esapi;
	String emp_name_exist =emp_name_exist_Esapi;
	String emp_name_new =emp_name_new_Esapi;
	String department_exist =department_exist_Esapi;
	String department_new =department_new_Esapi;
	String employee_num_exist =employee_num_exist_Esapi;
	String employee_num_new =employee_num_new_Esapi;
	String occupation_exist =occupation_exist_Esapi;
	String occupation_new =occupation_new_Esapi;
	String naturebusiness_exist =naturebusiness_exist_Esapi;
	String naturebusiness_new =naturebusiness_new_Esapi;
	String total_year_of_emp_exist =total_year_of_emp_exist_Esapi;
	String total_year_of_emp_new =total_year_of_emp_new_Esapi;
	String years_of_business_exist =years_of_business_exist_Esapi;
	String years_of_business_new =years_of_business_new_Esapi;
	String employment_status_exist =employment_status_exist_Esapi;
	String employment_status_new =employment_status_new_Esapi;
	String date_join_curr_employer_exist =date_join_curr_employer_exist_Esapi;
	String date_join_curr_employer_new =date_join_curr_employer_new_Esapi;
	String maritalstatus_exist =maritalstatus_exist_Esapi;
	String maritalstatus_new =maritalstatus_new_Esapi;
	String noofdep_exist =noofdep_exist_Esapi;
	String noofdep_new =noofdep_new_Esapi;
	String countryresNat_exist =countryresNat_exist_Esapi;
	String countryresNat_new =countryresNat_new_Esapi;
	String wheninuae_exist =wheninuae_exist_Esapi;
	String wheninuae_new =wheninuae_new_Esapi;
	String preempdetails_exist =preempdetails_exist_Esapi;
	String preempdetails_new =preempdetails_new_Esapi;
	
	
	try
	{	
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
		Date date = new Date();
		cur_date = dateFormat.format(date);
		
		System.out.println("cur_date"+cur_date);
	}catch(Exception e){
		//
	}	
%>
<center>
<table >
<tr width=90%>
	<td  align="left" valign="center">
		<img height="55px" width="160px" src="\webdesktop\CustomForms\Forms_rakcabinet_first_88\images\logo_rakbank.jpg">
	</td>
	<td  nowrap='nowrap' class='EWNormalGreenGeneral1'>&nbsp;</td>
	<td  align="Right" nowrap='nowrap' class='EWNormalGreenGeneral1'>
		Work Item No : <%=wi_name%><br>
		Date : <%=cur_date%>
	</td>
	
</tr>
<tr>
	<td colspan="3" align="left" valign="center">
		<p style="font-size:12px;">We give below your key personal details recorded by the bank. Please review and either sign to confirm that the information is still correct or, alternatively, please write the current information next to entry below and sign to authorize the Bank to update its records.
		</p>
	</td>
</tr>
<tr>
	<th style="min-width: 150px;">Personal Details</th>
	<th style="min-width: 150px;">Existing</th>
	<th style="min-width: 150px;">Amendments</th>
</tr>
<tr >
	<td class="labelT EWNormalGreenGeneral1">First Name</td>
	<td class="EWNormalGreenGeneral1"><%=first_nameE%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=first_nameN%></td>
</tr>
<tr >
	<td class="labelT EWNormalGreenGeneral1">Middle Name</td>
	<td class="EWNormalGreenGeneral1"><%=middle_nameE%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=middle_nameN%></td>
</tr>
<tr >
	<td class="labelT EWNormalGreenGeneral1">Last Name</td>
	<td class="EWNormalGreenGeneral1"><%=last_nameE%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=last_nameN%></td>
</tr>


<tr>
	<td class="labelT EWNormalGreenGeneral1">Marital Status</td>
	<td class="EWNormalGreenGeneral1"><%=maritalstatusE%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=maritalstatusN%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">E-Statement Registered</td>
	<td class="EWNormalGreenGeneral1"><%=estatementreg_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=estatementreg_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Emirates ID</td>
	<td class="EWNormalGreenGeneral1"><%=emiratesid_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=emiratesid_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Emirates Id Expiry Date</td>
	<td class="EWNormalGreenGeneral1"><%=emiratesidexp_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=emiratesidexp_new%></td>
</tr>
<tr >
	<td class="labelT EWNormalGreenGeneral1">Passport No</td>
	<td class="EWNormalGreenGeneral1"><%=passport_numE%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=passport_numN%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Passport Expiry Date</td>
	<td class="EWNormalGreenGeneral1"><%=passportExpDate_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=passportExpDate_new%></td>
</tr>

<tr>
	<td class="labelT EWNormalGreenGeneral1">Visa</td>
	<td class="EWNormalGreenGeneral1"><%=visa_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=visa_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Passport Expiry Date</td>
	<td class="EWNormalGreenGeneral1"><%=visaExpDate_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=visaExpDate_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Mother's Maiden Name</td>
	<td class="EWNormalGreenGeneral1"><%=mother_maiden_name_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=mother_maiden_name_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">US Nationality Holder</td>
	<td class="EWNormalGreenGeneral1"><%=usnatholder_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=usnatholder_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">US Resident</td>
	<td class="EWNormalGreenGeneral1"><%=usresi_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=usresi_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">US Greencard Holder</td>
	<td class="EWNormalGreenGeneral1"><%=usgreencardhol_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=usgreencardhol_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">US Tax Payer?</td>
	<td class="EWNormalGreenGeneral1"><%=us_tax_payer_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=us_tax_payer_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">US Born?</td>
	<td class="EWNormalGreenGeneral1"><%=usborn_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=usborn_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">If No,Country of Birth</td>
	<td class="EWNormalGreenGeneral1"><%=nocnofbirth_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=nocnofbirth_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">AECB Eligible?</td>
	<td class="EWNormalGreenGeneral1"><%=abcdelig_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=abcdelig_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1" style="color:red;text-decoration: underline;" colspan="3">Contact Details</td>
	
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Residence Address</td>
	<td class="EWNormalGreenGeneral1"><%=resiadd_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=resiadd_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Office Address</td>
	<td class="EWNormalGreenGeneral1"><%=officeadd_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=officeadd_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Preferred Address</td>
	<td class="EWNormalGreenGeneral1"><%=preadd_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=preadd_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Primary Email ID</td>
	<td class="EWNormalGreenGeneral1"><%=priemailid_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=priemailid_new%></td>
</tr>
<tr >
	<td class="labelT EWNormalGreenGeneral1">E-Statement Registered</td>
	<td class="EWNormalGreenGeneral1"><%=estatementreg_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=estatementreg_new%></td>
</tr>
<tr>
	<td colspan="3" align="left" valign="center">
		<p style="font-size:12px;">By writing "Yes" under Amendment column against "E-statement Registered", I agree and confirm that statements/advices pertaining to all the accounts or credit cards under my name will be sent to me at the e-mail ID indicated above. By writing "No", I have requested deregistration from E-statement.
		</p>
	</td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Mobile Phone</td>
	<td class="EWNormalGreenGeneral1"><%=mob_phone_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=mob_phone_newC%><%=mob_phone_newN%><%=mob_phone_newE%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Mobile Phone 2</td>
	<td class="EWNormalGreenGeneral1"><%=sec_mob_phone_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=sec_mob_phone_newC%><%=sec_mob_phone_newN%><%=sec_mob_phone_newE%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Home Phone</td>
	<td class="EWNormalGreenGeneral1"><%=homephone_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=homephone_newC%><%=homephone_newN%><%=homephone_newE%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Office Phone</td>
	<td class="EWNormalGreenGeneral1"><%=officephone_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=officephone_newC%><%=officephone_newN%><%=officephone_newE%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Home Country Phone</td>
	<td class="EWNormalGreenGeneral1"><%=homecntryphone_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=homecntryphone_newC%><%=homecntryphone_newN%><%=homecntryphone_newE%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Fax</td>
	<td class="EWNormalGreenGeneral1"><%=fax_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=fax_newC%><%=fax_newN%><%=fax_newE%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Preferred Contact</td>
	<td class="EWNormalGreenGeneral1"><%=prefcontact_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=prefcontact_new%></td>
</tr>
<tr>
	<td style="color:red;text-decoration: underline;" class="labelT EWNormalGreenGeneral1" colspan="3">Employment Details</td>
	
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Designation</td>
	<td class="EWNormalGreenGeneral1"><%=designation_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=designation_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Company Name</td>
	<td class="EWNormalGreenGeneral1"><%=comp_name_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=comp_name_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Name of Employer</td>
	<td class="EWNormalGreenGeneral1"><%=emp_name_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=emp_name_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Department</td>
	<td class="EWNormalGreenGeneral1"><%=department_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=department_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Employee Number</td>
	<td class="EWNormalGreenGeneral1"><%=employee_num_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=employee_num_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Occupation</td>
	<td class="EWNormalGreenGeneral1"><%=occupation_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=occupation_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Nature of Business</td>
	<td class="EWNormalGreenGeneral1"><%=naturebusiness_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=naturebusiness_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Total years of Employment</td>
	<td class="EWNormalGreenGeneral1"><%=total_year_of_emp_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=total_year_of_emp_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Years since in Business</td>
	<td class="EWNormalGreenGeneral1"><%=years_of_business_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=years_of_business_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Employment Status</td>
	<td class="EWNormalGreenGeneral1"><%=employment_status_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=employment_status_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Date of Joining Current Employer</td>
	<td class="EWNormalGreenGeneral1"><%=date_join_curr_employer_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=date_join_curr_employer_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Marital Status</td>
	<td class="EWNormalGreenGeneral1"><%=maritalstatus_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=maritalstatus_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Number of Dependents</td>
	<td class="EWNormalGreenGeneral1"><%=noofdep_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=noofdep_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Country of Residence/Nationality</td>
	<td class="EWNormalGreenGeneral1"><%=countryresNat_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=countryresNat_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1">Since when in UAE</td>
	<td class="EWNormalGreenGeneral1"><%=wheninuae_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=wheninuae_new%></td>
</tr>
<tr>
	<td class="labelT EWNormalGreenGeneral1" style="color:red;text-decoration: underline;">Previous Employment Details</td>
	<td class="EWNormalGreenGeneral1"><%=preempdetails_exist%></td>
	<td class="underlineText EWNormalGreenGeneral1"><%=preempdetails_new%></td>
</tr>

<tr>
	<td style="padding-top:40px;" class="labelT EWNormalGreenGeneral1">Authorized Signature (s)</td>
	<td colspan="2">&nbsp;</td>
	
</tr>
<tr>
	<td  colspan="2" align="left" valign="center">
		<img height="55px" width="160px" src="\webdesktop\CustomForms\Forms_rakcabinet_first_88\images\logo_rakbank.jpg">
	</td>
</tr>
<tr>
	<td colspan="2">
		<p  style="font-size:15px;font-weight: bold;">Consent for disclosure of information

		</p>
	</td>
	<td >
		<p class=MsoNormal dir=LTR style="text-align:right;direction:ltr;unicode-bidi:embed;font-size:12px;font-family:'Arabic Transparent';font-weight:bold;
  color:#003300">&#1575;&#1604;&#1605;&#1608;&#1575;&#1601;&#1602;&#1577; &#1593;&#1604;&#1609; &#1575;&#1601;&#1589;&#1575;&#1581; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; 

		</p>
	</td>
</tr>
<tr>
	<td colspan="2">
		<p style="font-size:15px;">I  hereby consent and agree that the Bank:

		</p>
	</td>
	<td >
		<p class=MsoNormal dir=LTR style="text-align:right;direction:ltr;unicode-bidi:embed;font-size:12px;font-family:'Arabic Transparent';
  color:#003300">&#1571;&#1608;&#1575;&#1601;&#1602; &#1593;&#1604;&#1609; &#1571;&#1606;&#1607; &#1610;&#1580;&#1608;&#1586; &#1604;&#1604;&#1576;&#1606;&#1603;:

		</p>
	</td>
</tr>
<tr>
	<td colspan="2">
		<p  style="font-size:12px;">(a)	may disclose information regarding me , including, but not limited to, information regarding my personal and financial situation, defaults in payments and any other matter related to my account or any facilities or products made available to me  or over which I  have control either as shareholder, authorised signatory or otherwise with the Bank ("Credit Information") to any other commercial and investment banks, financial institution, credit information company or entity (including, without limitation the Al Etihad Credit Information Company PJSC), debt collection agency or any local, federal or regulatory agency or any member of the Bank’s group including any subsidiary or related company in the UAE or in any other jurisdiction irrespective of  whether the Bank operates or undertakes any form of business in that jurisdiction (each a "Relevant Entity");


		</p>
	</td>
	<td >
		<p  class=MsoNormal dir=LTR style="text-align:right;direction:ltr;unicode-bidi:embed;font-size:12px;font-family:'Arabic Transparent';
  color:#003300">&#8204;&#1571;.	&#1575;&#1604;&#1573;&#1601;&#1589;&#1575;&#1581; &#1593;&#1606; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1575;&#1604;&#1578;&#1610; &#1578;&#1582;&#1589;&#1606;&#1610; &#1548; &#1576;&#1605;&#1575; &#1601;&#1610; &#1584;&#1604;&#1603;&#1548; &#1605;&#1606; &#1583;&#1608;&#1606; &#1581;&#1589;&#1585;&#1548; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1575;&#1604;&#1582;&#1575;&#1589;&#1577; &#1576;&#1608;&#1590;&#1593;&#1610; &#1575;&#1604;&#1588;&#1582;&#1589;&#1610; &#1608;&#1575;&#1604;&#1605;&#1575;&#1604;&#1610; &#1608;&#1575;&#1604;&#1578;&#1582;&#1604;&#1601; &#1593;&#1606; &#1575;&#1604;&#1587;&#1583;&#1575;&#1583; &#1608;&#1571;&#1610; &#1605;&#1587;&#1575;&#1574;&#1604; &#1571;&#1582;&#1585;&#1609; &#1578;&#1585;&#1578;&#1576;&#1591; &#1576;&#1581;&#1587;&#1575;&#1576;&#1610; &#1571;&#1608; &#1571;&#1610; &#1578;&#1587;&#1607;&#1610;&#1604;&#1575;&#1578; &#1571;&#1608; &#1605;&#1606;&#1578;&#1580;&#1575;&#1578; &#1581;&#1589;&#1604;&#1578; &#1593;&#1604;&#1610;&#1607;&#1575; &#1605;&#1606; &#1582;&#1604;&#1575;&#1604; &#1575;&#1604;&#1576;&#1606;&#1603; (&#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1575;&#1604;&#1575;&#1574;&#1578;&#1605;&#1575;&#1606;&#1610;&#1577;) &#1571;&#1608; &#1575;&#1604;&#1578;&#1610; &#1578;&#1602;&#1593; &#1578;&#1581;&#1578; &#1585;&#1602;&#1575;&#1576;&#1578;&#1610; &#1587;&#1608;&#1575;&#1569; &#1603;&#1605;&#1587;&#1575;&#1607;&#1605;&#1610;&#1606; &#1571;&#1608; &#1605;&#1582;&#1608;&#1604;&#1610;&#1606; &#1576;&#1575;&#1604;&#1578;&#1608;&#1602;&#1610;&#1593; &#1571;&#1608; &#1582;&#1604;&#1575;&#1601; &#1584;&#1604;&#1603;&#1548; &#1608;&#1584;&#1604;&#1603; &#1604;&#1571;&#1610; &#1576;&#1606;&#1608;&#1603; &#1575;&#1587;&#1578;&#1579;&#1605;&#1575;&#1585;&#1610;&#1577; &#1571;&#1608; &#1578;&#1580;&#1575;&#1585;&#1610;&#1577; &#1571;&#1582;&#1585;&#1609; &#1571;&#1608; &#1605;&#1572;&#1587;&#1587;&#1575;&#1578; &#1605;&#1575;&#1604;&#1610;&#1577; &#1571;&#1608; &#1588;&#1585;&#1603;&#1575;&#1578; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1575;&#1574;&#1578;&#1605;&#1575;&#1606;&#1610;&#1577; (&#1576;&#1605;&#1575; &#1601;&#1610; &#1584;&#1604;&#1603;&#1548; &#1605;&#1606; &#1583;&#1608;&#1606; &#1581;&#1589;&#1585;&#1548; &#1588;&#1585;&#1603;&#1577; &#1575;&#1604;&#1575;&#1578;&#1581;&#1575;&#1583; &#1604;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1575;&#1604;&#1575;&#1574;&#1578;&#1605;&#1575;&#1606;&#1610;&#1577; &#1588;.&#1605;.&#1593;) &#1571;&#1608; &#1608;&#1603;&#1575;&#1604;&#1575;&#1578; &#1578;&#1581;&#1589;&#1610;&#1604; &#1575;&#1604;&#1583;&#1610;&#1608;&#1606; &#1571;&#1608; &#1571;&#1610; &#1580;&#1607;&#1577; &#1605;&#1581;&#1604;&#1610;&#1577; &#1571;&#1608; &#1575;&#1578;&#1581;&#1575;&#1583;&#1610;&#1577; &#1571;&#1608; &#1578;&#1588;&#1585;&#1610;&#1593;&#1610;&#1577; &#1571;&#1608; &#1571;&#1610; &#1593;&#1590;&#1608; &#1601;&#1610; &#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1576;&#1606;&#1603;&#1548; &#1576;&#1605;&#1575; &#1601;&#1610; &#1584;&#1604;&#1603; &#1571;&#1610; &#1588;&#1585;&#1603;&#1577; &#1578;&#1575;&#1576;&#1593;&#1577; &#1571;&#1608; &#1584;&#1575;&#1578; &#1589;&#1604;&#1577; &#1601;&#1610; &#1575;&#1604;&#1573;&#1605;&#1575;&#1585;&#1575;&#1578; &#1575;&#1604;&#1593;&#1585;&#1576;&#1610;&#1577; &#1575;&#1604;&#1605;&#1578;&#1581;&#1583;&#1577; &#1601;&#1610; &#1571;&#1610; &#1605;&#1606;&#1591;&#1602;&#1577; &#1571;&#1582;&#1585;&#1609; &#1576;&#1589;&#1585;&#1601; &#1575;&#1604;&#1606;&#1592;&#1585; &#1593;&#1606; &#1605;&#1605;&#1575;&#1585;&#1587;&#1577; &#1575;&#1604;&#1576;&#1606;&#1603; &#1604;&#1571;&#1610; &#1588;&#1603;&#1604; &#1570;&#1582;&#1585; &#1605;&#1606; &#1571;&#1588;&#1603;&#1575;&#1604; &#1575;&#1604;&#1593;&#1605;&#1604; &#1601;&#1610; &#1578;&#1604;&#1603; &#1575;&#1604;&#1605;&#1606;&#1591;&#1602;&#1577; (&#1610;&#1588;&#1575;&#1585; &#1573;&#1604;&#1609; &#1603;&#1604; &#1605;&#1606;&#1607;&#1575; &#1576;&#1575;&#1587;&#1605; "&#1575;&#1604;&#1580;&#1607;&#1577; &#1584;&#1575;&#1578; &#1575;&#1604;&#1589;&#1604;&#1577;



		</p>
	</td>
</tr>
<tr>
	<td colspan="2">
		<p  style="font-size:12px;">(b)	may obtain any Credit Information relating to me  or any entity over which I have control either as shareholder, authorised signatory or otherwise from any Relevant Entity and may apply or use such Credit Information in making any credit or other assessment in relation to my accounts or facilities (or proposed accounts or facilities) with the Bank;

		</p>
	</td>
	<td >
		<p class=MsoNormal dir=LTR style="text-align:right;direction:ltr;unicode-bidi:embed;font-size:12px;font-family:'Arabic Transparent';
  color:#003300">&#8204;&#1576;.	&#1582;&#1589;&#1608;&#1589;&#1575;&#1604;&#1581;&#1589;&#1608;&#1604; &#1593;&#1604;&#1609; &#1571;&#1610; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1575;&#1574;&#1578;&#1605;&#1575;&#1606;&#1610;&#1577; &#1578;&#1582;&#1589;&#1606;&#1610; &#1605;&#1606; &#1571;&#1610; &#1580;&#1607;&#1577; &#1584;&#1575;&#1578; &#1589;&#1604;&#1577; &#1576;&#1610; &#1571;&#1608; &#1571;&#1610; &#1580;&#1607;&#1577; &#1578;&#1602;&#1593; &#1578;&#1581;&#1578; &#1585;&#1602;&#1575;&#1576;&#1578;&#1610; &#1587;&#1608;&#1575;&#1569; &#1603;&#1605;&#1587;&#1575;&#1607;&#1605;&#1610;&#1606; &#1571;&#1608; &#1605;&#1582;&#1608;&#1604;&#1610;&#1606; &#1576;&#1575;&#1604;&#1578;&#1608;&#1602;&#1610;&#1593; &#1571;&#1608; &#1582;&#1604;&#1575;&#1601; &#1584;&#1604;&#1603;&#1548;  &#1608;&#1578;&#1591;&#1576;&#1610;&#1602; &#1571;&#1608; &#1575;&#1587;&#1578;&#1582;&#1583;&#1575;&#1605; &#1578;&#1604;&#1603; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1601;&#1610; &#1573;&#1580;&#1585;&#1575;&#1569; &#1571;&#1610; &#1578;&#1602;&#1610;&#1610;&#1605; &#1575;&#1574;&#1578;&#1605;&#1575;&#1606;&#1610; &#1571;&#1608; &#1578;&#1602;&#1610;&#1610;&#1605; &#1570;&#1582;&#1585; &#1610;&#1578;&#1593;&#1604;&#1602; &#1576;&#1581;&#1587;&#1575;&#1576;&#1610; &#1571;&#1608; &#1578;&#1587;&#1607;&#1610;&#1604;&#1575;&#1578;&#1610; (&#1571;&#1608; &#1575;&#1604;&#1581;&#1587;&#1575;&#1576;&#1575;&#1578; &#1571;&#1608; &#1575;&#1604;&#1578;&#1587;&#1607;&#1610;&#1604;&#1575;&#1578; &#1575;&#1604;&#1605;&#1602;&#1578;&#1585;&#1581;&#1577;) &#1604;&#1583;&#1609; &#1575;&#1604;&#1576;&#1606;&#1603;.
<br>
<br>


		</p>
	</td>
</tr>
<tr>
	<td colspan="2">
		<p  style="font-size:12px;">(c)	shall have no liability or responsibility to me including any entity over which I have control either as shareholder, authorised signatory or otherwise or any third party relying on any Credit Information provided by the Bank to any Relevant Entity (or, in the event of onward transmission of such Credit Information by that Relevant Entity) provided such Credit Information is provided in good faith and with reasonable care and without any requirement that such Credit Information be updated or checked by the Bank in the event that my personal or financial situation or that of any entity over which I  have control either as shareholder, authorised signatory or otherwise may subsequently change or further information is provided by me  to the Bank; and


		</p>
	</td>
	<td >
		<p class=MsoNormal dir=LTR style="text-align:right;direction:ltr;unicode-bidi:embed;font-size:12px;font-family:'Arabic Transparent';
  color:#003300">&#8204;&#1580;.	&#1593;&#1583;&#1605; &#1578;&#1581;&#1605;&#1604; &#1571;&#1610; &#1605;&#1587;&#1572;&#1608;&#1604;&#1610;&#1577; &#1571;&#1608; &#1575;&#1604;&#1578;&#1586;&#1575;&#1605; &#1578;&#1580;&#1575;&#1607;&#1610; &#1576;&#1605;&#1575; &#1601;&#1610; &#1584;&#1604;&#1603; &#1571;&#1610; &#1580;&#1607;&#1577; &#1578;&#1602;&#1593; &#1578;&#1581;&#1578; &#1585;&#1602;&#1575;&#1576;&#1578;&#1610; &#1587;&#1608;&#1575;&#1569; &#1603;&#1605;&#1587;&#1575;&#1607;&#1605;&#1610;&#1606; &#1571;&#1608; &#1605;&#1582;&#1608;&#1604;&#1610;&#1606; &#1576;&#1575;&#1604;&#1578;&#1608;&#1602;&#1610;&#1593; &#1571;&#1608; &#1582;&#1604;&#1575;&#1601; &#1584;&#1604;&#1603;&#1548; &#1571;&#1608; &#1578;&#1580;&#1575;&#1607; &#1571;&#1610; &#1591;&#1585;&#1601; &#1579;&#1575;&#1604;&#1579; &#1608;&#1601;&#1602;&#1575;&#1611; &#1604;&#1571;&#1610; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1575;&#1574;&#1578;&#1605;&#1575;&#1606;&#1610;&#1577; &#1605;&#1602;&#1583;&#1605;&#1577; &#1605;&#1606; &#1602;&#1576;&#1604; &#1575;&#1604;&#1576;&#1606;&#1603; &#1604;&#1571;&#1610; &#1580;&#1607;&#1577; &#1584;&#1575;&#1578; &#1589;&#1604;&#1577; (&#1571;&#1608;&#1548; &#1601;&#1610; &#1581;&#1575;&#1604; &#1578;&#1581;&#1608;&#1610;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1575;&#1604;&#1575;&#1574;&#1578;&#1605;&#1575;&#1606;&#1610;&#1577; &#1605;&#1606; &#1602;&#1576;&#1604; &#1575;&#1604;&#1580;&#1607;&#1577; &#1584;&#1575;&#1578; &#1575;&#1604;&#1589;&#1604;&#1577;) &#1576;&#1588;&#1585;&#1591; &#1571;&#1606; &#1578;&#1602;&#1583;&#1605; &#1578;&#1604;&#1603; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1576;&#1581;&#1587;&#1606; &#1606;&#1610;&#1577; &#1608;&#1605;&#1593; &#1576;&#1584;&#1604; &#1575;&#1604;&#1593;&#1606;&#1575;&#1610;&#1577; &#1575;&#1604;&#1605;&#1593;&#1602;&#1608;&#1604;&#1577; &#1608;&#1605;&#1606; &#1583;&#1608;&#1606; &#1571;&#1610; &#1575;&#1588;&#1578;&#1585;&#1575;&#1591; &#1610;&#1602;&#1590;&#1609; &#1576;&#1578;&#1581;&#1583;&#1610;&#1579; &#1571;&#1608; &#1605;&#1585;&#1575;&#1580;&#1593;&#1577; &#1578;&#1604;&#1603; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1606; &#1580;&#1575;&#1606;&#1576; &#1575;&#1604;&#1576;&#1606;&#1603; &#1601;&#1610; &#1581;&#1575;&#1604; &#1575;&#1581;&#1578;&#1605;&#1575;&#1604; &#1578;&#1594;&#1610;&#1610;&#1585; &#1608;&#1590;&#1593;&#1610; &#1575;&#1604;&#1605;&#1575;&#1604;&#1610; &#1571;&#1608; &#1575;&#1604;&#1588;&#1582;&#1589;&#1610; &#1571;&#1608; &#1571;&#1610; &#1580;&#1607;&#1577; &#1578;&#1602;&#1593; &#1578;&#1581;&#1578; &#1585;&#1602;&#1575;&#1576;&#1578;&#1610; &#1587;&#1608;&#1575;&#1569; &#1603;&#1605;&#1587;&#1575;&#1607;&#1605;&#1610;&#1606; &#1571;&#1608; &#1605;&#1582;&#1608;&#1604;&#1610;&#1606; &#1576;&#1575;&#1604;&#1578;&#1608;&#1602;&#1610;&#1593; &#1571;&#1608; &#1582;&#1604;&#1575;&#1601; &#1584;&#1604;&#1603;&#1548; &#1571;&#1608; &#1578;&#1602;&#1583;&#1610;&#1605; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1571;&#1582;&#1585;&#1609; &#1605;&#1606; &#1602;&#1576;&#1604;&#1610; &#1573;&#1604;&#1609; &#1575;&#1604;&#1576;&#1606;&#1603;&#1548; &#1608;



		</p>
	</td>
</tr>
<tr>
	<td colspan="2">
		<p  style="font-size:12px;">(d)	is providing Credit Information to each Relevant Entity for my benefit and accordingly the Bank shall be indemnified by me for any loss, cost, claim or damage incurred or sustained by the Bank as a result of providing such Credit Information in the event that any third party (including any Relevant Entity) brings any claim related to the provision of or reliance on such Credit Information provided that such information has been provided by the Bank in good faith and with reasonable care.


		</p>
	</td>
	<td >
		<p class=MsoNormal dir=LTR style="text-align:right;direction:ltr;unicode-bidi:embed;font-size:12px;font-family:'Arabic Transparent';
  color:#003300">&#8204;&#1583;.	&#1608;&#1571;&#1606; &#1578;&#1602;&#1583;&#1610;&#1605; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1575;&#1604;&#1575;&#1574;&#1578;&#1605;&#1575;&#1606;&#1610;&#1577; &#1604;&#1571;&#1610; &#1580;&#1607;&#1577; &#1584;&#1575;&#1578; &#1589;&#1604;&#1577; &#1610;&#1603;&#1608;&#1606; &#1604;&#1605;&#1589;&#1604;&#1581;&#1578;&#1610; &#1548; &#1608;&#1576;&#1606;&#1575;&#1569; &#1593;&#1604;&#1610;&#1607;&#1548; &#1610;&#1581;&#1602; &#1604;&#1604;&#1576;&#1606;&#1603; &#1575;&#1604;&#1581;&#1589;&#1608;&#1604; &#1593;&#1604;&#1609; &#1578;&#1593;&#1608;&#1610;&#1590; &#1605;&#1606;&#1610; &#1593;&#1606; &#1571;&#1610; &#1582;&#1587;&#1575;&#1585;&#1577; &#1571;&#1608; &#1578;&#1603;&#1575;&#1604;&#1610;&#1601; &#1571;&#1608; &#1605;&#1591;&#1575;&#1604;&#1576;&#1575;&#1578; &#1571;&#1608; &#1571;&#1590;&#1585;&#1575;&#1585; &#1610;&#1578;&#1605; &#1578;&#1581;&#1605;&#1604;&#1607;&#1575; &#1571;&#1608; &#1578;&#1603;&#1576;&#1583;&#1607;&#1575; &#1605;&#1606; &#1602;&#1576;&#1604; &#1575;&#1604;&#1576;&#1606;&#1603; &#1606;&#1578;&#1610;&#1580;&#1577; &#1578;&#1602;&#1583;&#1610;&#1605; &#1605;&#1579;&#1604; &#1607;&#1584;&#1607; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1573;&#1584;&#1575; &#1602;&#1575;&#1605; &#1571;&#1610; &#1591;&#1585;&#1601; &#1579;&#1575;&#1604;&#1579; (&#1576;&#1605;&#1575; &#1601;&#1610; &#1584;&#1604;&#1603; &#1571;&#1610; &#1580;&#1607;&#1577; &#1584;&#1575;&#1578; &#1589;&#1604;&#1577;) &#1576;&#1578;&#1602;&#1583;&#1610;&#1605; &#1605;&#1591;&#1575;&#1604;&#1576;&#1577; &#1578;&#1582;&#1589; &#1578;&#1602;&#1583;&#1610;&#1605; &#1578;&#1604;&#1603; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1571;&#1608; &#1578;&#1587;&#1578;&#1606;&#1583; &#1593;&#1604;&#1610;&#1607;&#1575;&#1548; &#1576;&#1588;&#1585;&#1591; &#1578;&#1602;&#1583;&#1610;&#1605; &#1575;&#1604;&#1576;&#1606;&#1603; &#1604;&#1578;&#1604;&#1603; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1576;&#1581;&#1587;&#1606; &#1606;&#1610;&#1577; &#1608;&#1605;&#1593; &#1576;&#1584;&#1604; &#1575;&#1604;&#1593;&#1606;&#1575;&#1610;&#1577; &#1575;&#1604;&#1604;&#1575;&#1586;&#1605;&#1577;.



		</p>
	</td>
</tr>

</table>
</center>
</body>
</html>
