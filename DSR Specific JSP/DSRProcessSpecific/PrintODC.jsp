<!----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group			         : Application –Projects
//Product / Project	     : RAKBank 
//Module                 : Update Request
//Author                     : Lalit Kumar
// Date written (DD/MM/YYYY) : 6-Mar-2008
//Description                : for print functionality.
//------------------------------------------------------------------------------------------------------------------------------------>

<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<head>
<head>

	<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>

<%@ page import="java.io.*,java.util.*,java.text.SimpleDateFormat"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>


<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<style type="text/css">
td {font-size: 80%;}
</style>
<%
    Calendar c = Calendar.getInstance();
	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MMM/yyyy hh:mm:ss"); 
	String CurrDate=dateFormat.format(c.getTime());
	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("wi_name", request.getParameter("wi_name"), 1000, true) );
	String wi_name = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: wi_name: "+wi_name);
	WriteLog("Integration jsp: wi_name 1: "+request.getParameter("wi_name"));
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("IntroductionDateTime", request.getParameter("IntroductionDateTime"), 1000, true) );
	String IntroductionDateTime = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: IntroductionDateTime: "+IntroductionDateTime);
	
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("BU_UserName", request.getParameter("BU_UserName"), 1000, true) );
	String BU_UserName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	WriteLog("Integration jsp: BU_UserName: "+BU_UserName);
	
	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DCI_DebitCN", request.getParameter("DCI_DebitCN"), 1000, true) );
	String DCI_DebitCN = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	WriteLog("Integration jsp: DCI_DebitCN: "+DCI_DebitCN);
	
	String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DCI_ExpD", request.getParameter("DCI_ExpD"), 1000, true) );
	String DCI_ExpD = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
	WriteLog("Integration jsp: DCI_ExpD: "+DCI_ExpD);
	
	String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DCI_CName", request.getParameter("DCI_CName"), 1000, true) );
	String DCI_CName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
	WriteLog("Integration jsp: DCI_CName: "+DCI_CName);
	
	String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DCI_CT", request.getParameter("DCI_CT"), 1000, true) );
	String DCI_CT = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
	WriteLog("Integration jsp: DCI_CT: "+DCI_CT);
	
	String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DCI_MONO", request.getParameter("DCI_MONO"), 1000, true) );
	String DCI_MONO = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
	WriteLog("Integration jsp: DCI_MONO: "+DCI_MONO);
	
	String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DCI_CAPS_GENSTAT", request.getParameter("DCI_CAPS_GENSTAT"), 1000, true) );
	String DCI_CAPS_GENSTAT = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
	WriteLog("Integration jsp: DCI_CAPS_GENSTAT: "+DCI_CAPS_GENSTAT);
	
	String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DCI_ELITECUSTNO", request.getParameter("DCI_ELITECUSTNO"), 1000, true) );
	String DCI_ELITECUSTNO = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
	WriteLog("Integration jsp: DCI_ELITECUSTNO: "+DCI_ELITECUSTNO);
	
	String input11 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DCI_ExtNo", request.getParameter("DCI_ExtNo"), 1000, true) );
	String DCI_ExtNo = ESAPI.encoder().encodeForSQL(new OracleCodec(), input11!=null?input11:"");
	WriteLog("Integration jsp: DCI_ExtNo: "+DCI_ExtNo);
	
	String input12 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_TINCheck", request.getParameter("VD_TINCheck"), 1000, true) );
	String VD_TINCheck = ESAPI.encoder().encodeForSQL(new OracleCodec(), input12!=null?input12:"");
	WriteLog("Integration jsp: VD_TINCheck: "+VD_TINCheck);
	
	String input13 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_MoMaidN", request.getParameter("VD_MoMaidN"), 1000, true) );
	String VD_MoMaidN = ESAPI.encoder().encodeForSQL(new OracleCodec(), input13!=null?input13:"");
	WriteLog("Integration jsp: VD_MoMaidN: "+VD_MoMaidN);
	
	String input14 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_POBox", request.getParameter("VD_POBox"), 1000, true) );
	String VD_POBox = ESAPI.encoder().encodeForSQL(new OracleCodec(), input14!=null?input14:"");
	WriteLog("Integration jsp: VD_POBox: "+VD_POBox);
	
	String input15 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_Oth", request.getParameter("VD_Oth"), 1000, true) );
	String VD_Oth = ESAPI.encoder().encodeForSQL(new OracleCodec(), input15!=null?input15:"");
	WriteLog("Integration jsp: VD_Oth: "+VD_Oth);
	
	String input16 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_MRT", request.getParameter("VD_MRT"), 1000, true) );
	String VD_MRT = ESAPI.encoder().encodeForSQL(new OracleCodec(), input16!=null?input16:"");
	WriteLog("Integration jsp: VD_MRT: "+VD_MRT);
	
	String input17 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_StaffId", request.getParameter("VD_StaffId"), 1000, true) );
	String VD_StaffId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input17!=null?input17:"");
	WriteLog("Integration jsp: VD_StaffId: "+VD_StaffId);
	
	String input18 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_EDC", request.getParameter("VD_EDC"), 1000, true) );
	String VD_EDC = ESAPI.encoder().encodeForSQL(new OracleCodec(), input18!=null?input18:"");
	WriteLog("Integration jsp: VD_EDC: "+VD_EDC);
	
	String input19 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_TELNO", request.getParameter("VD_TELNO"), 1000, true) );
	String VD_TELNO = ESAPI.encoder().encodeForSQL(new OracleCodec(), input19!=null?input19:"");
	WriteLog("Integration jsp: VD_TELNO: "+VD_TELNO);
	
	String input20 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_DOB", request.getParameter("VD_DOB"), 1000, true) );
	String VD_DOB = ESAPI.encoder().encodeForSQL(new OracleCodec(), input20!=null?input20:"");
	WriteLog("Integration jsp: VD_DOB: "+VD_DOB);
	
	String input21 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Card_Upgrade", request.getParameter("Card_Upgrade"), 1000, true) );
	String Card_Upgrade = ESAPI.encoder().encodeForSQL(new OracleCodec(), input21!=null?input21:"");
	WriteLog("Integration jsp: Card_Upgrade: "+Card_Upgrade);
	
	String input22 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_cu_RR", request.getParameter("oth_cu_RR"), 1000, true) );
	String oth_cu_RR = ESAPI.encoder().encodeForSQL(new OracleCodec(), input22!=null?input22:"");
	WriteLog("Integration jsp: oth_cu_RR: "+oth_cu_RR);
	
	String input23 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Card_Delivery_Request", request.getParameter("Card_Delivery_Request"), 1000, true) );
	String Card_Delivery_Request = ESAPI.encoder().encodeForSQL(new OracleCodec(), input23!=null?input23:"");
	WriteLog("Integration jsp: Card_Delivery_Request: "+Card_Delivery_Request);
	
	String input24 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_cdr_CDT", request.getParameter("oth_cdr_CDT"), 1000, true) );
	String oth_cdr_CDT = ESAPI.encoder().encodeForSQL(new OracleCodec(), input24!=null?input24:"");
	WriteLog("Integration jsp: oth_cdr_CDT: "+oth_cdr_CDT);
	
	String input25 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_cdr_BN", request.getParameter("oth_cdr_BN"), 1000, true) );
	String oth_cdr_BN = ESAPI.encoder().encodeForSQL(new OracleCodec(), input25!=null?input25:"");
	WriteLog("Integration jsp: oth_cdr_BN: "+oth_cdr_BN);
	
	String input26 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Transaction_Dispute", request.getParameter("Transaction_Dispute"), 1000, true) );
	String Transaction_Dispute = ESAPI.encoder().encodeForSQL(new OracleCodec(), input26!=null?input26:"");
	WriteLog("Integration jsp: Transaction_Dispute: "+Transaction_Dispute);
	
	String input27 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_td_RNO", request.getParameter("oth_td_RNO"), 1000, true) );
	String oth_td_RNO = ESAPI.encoder().encodeForSQL(new OracleCodec(), input27!=null?input27:"");
	WriteLog("Integration jsp: oth_td_RNO: "+oth_td_RNO);
	
	String input28 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_td_Amount", request.getParameter("oth_td_Amount"), 1000, true) );
	String oth_td_Amount = ESAPI.encoder().encodeForSQL(new OracleCodec(), input28!=null?input28:"");
	WriteLog("Integration jsp: oth_td_Amount: "+oth_td_Amount);
	
	String input29 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_cdr_RR", request.getParameter("oth_cdr_RR"), 1000, true) );
	String oth_cdr_RR = ESAPI.encoder().encodeForSQL(new OracleCodec(), input29!=null?input29:"");
	WriteLog("Integration jsp: oth_cdr_RR: "+oth_cdr_RR);
	
	String input30 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_td_RR", request.getParameter("oth_td_RR"), 1000, true) );
	String oth_td_RR = ESAPI.encoder().encodeForSQL(new OracleCodec(), input30!=null?input30:"");
	WriteLog("Integration jsp: oth_td_RR: "+oth_td_RR);
	
	String input31 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Early_Card_Renewal", request.getParameter("Early_Card_Renewal"), 1000, true) );
	String Early_Card_Renewal = ESAPI.encoder().encodeForSQL(new OracleCodec(), input31!=null?input31:"");
	WriteLog("Integration jsp: Early_Card_Renewal: "+Early_Card_Renewal);
	
	String input32 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_ecr_RB", request.getParameter("oth_ecr_RB"), 1000, true) );
	String oth_ecr_RB = ESAPI.encoder().encodeForSQL(new OracleCodec(), input32!=null?input32:"");
	WriteLog("Integration jsp: oth_ecr_RB: "+oth_ecr_RB);
	
	String input33 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_ecr_dt", request.getParameter("oth_ecr_dt"), 1000, true) );
	String oth_ecr_dt = ESAPI.encoder().encodeForSQL(new OracleCodec(), input33!=null?input33:"");
	WriteLog("Integration jsp: oth_ecr_dt: "+oth_ecr_dt);
	
	String input34 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_ecr_bn", request.getParameter("oth_ecr_bn"), 1000, true) );
	String oth_ecr_bn = ESAPI.encoder().encodeForSQL(new OracleCodec(), input34!=null?input34:"");
	WriteLog("Integration jsp: oth_ecr_bn: "+oth_ecr_bn);
	
	String input35 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_ecr_RR", request.getParameter("oth_ecr_RR"), 1000, true) );
	String oth_ecr_RR = ESAPI.encoder().encodeForSQL(new OracleCodec(), input35!=null?input35:"");
	WriteLog("Integration jsp: oth_ecr_RR: "+oth_ecr_RR);
	
	String input36 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Credit_Shield", request.getParameter("Credit_Shield"), 1000, true) );
	String Credit_Shield = ESAPI.encoder().encodeForSQL(new OracleCodec(), input36!=null?input36:"");
	WriteLog("Integration jsp: Credit_Shield: "+Credit_Shield);
	
	String input37 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_cs_CS", request.getParameter("oth_cs_CS"), 1000, true) );
	String oth_cs_CS = ESAPI.encoder().encodeForSQL(new OracleCodec(), input37!=null?input37:"");
	WriteLog("Integration jsp: oth_cs_CS: "+oth_cs_CS);
	
	String input38 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_cs_DSR", request.getParameter("oth_cs_DSR"), 1000, true) );
	String oth_cs_DSR = ESAPI.encoder().encodeForSQL(new OracleCodec(), input38!=null?input38:"");
	WriteLog("Integration jsp: oth_cs_DSR: "+oth_cs_DSR);
	
	String input39 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_cs_Amount", request.getParameter("oth_cs_Amount"), 1000, true) );
	String oth_cs_Amount = ESAPI.encoder().encodeForSQL(new OracleCodec(), input39!=null?input39:"");
	WriteLog("Integration jsp: oth_cs_Amount: "+oth_cs_Amount);
	
	String input40 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_cs_RR", request.getParameter("oth_cs_RR"), 1000, true) );
	String oth_cs_RR = ESAPI.encoder().encodeForSQL(new OracleCodec(), input40!=null?input40:"");
	WriteLog("Integration jsp: oth_cs_RR: "+oth_cs_RR);
	
	String input41 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Card_Replacement", request.getParameter("Card_Replacement"), 1000, true) );
	String Card_Replacement = ESAPI.encoder().encodeForSQL(new OracleCodec(), input41!=null?input41:"");
	WriteLog("Integration jsp: Card_Replacement: "+Card_Replacement);
	
	String input42 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_cr_reason", request.getParameter("oth_cr_reason"), 1000, true) );
	String oth_cr_reason = ESAPI.encoder().encodeForSQL(new OracleCodec(), input42!=null?input42:"");
	WriteLog("Integration jsp: oth_cr_reason: "+oth_cr_reason);
	
	String input43 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_cr_OPS", request.getParameter("oth_cr_OPS"), 1000, true) );
	String oth_cr_OPS = ESAPI.encoder().encodeForSQL(new OracleCodec(), input43!=null?input43:"");
	WriteLog("Integration jsp: oth_cr_OPS: "+oth_cr_OPS);
	
	String input44 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_cr_DC", request.getParameter("oth_cr_DC"), 1000, true) );
	String oth_cr_DC = ESAPI.encoder().encodeForSQL(new OracleCodec(), input44!=null?input44:"");
	WriteLog("Integration jsp: oth_cr_DC: "+oth_cr_DC);
	
	String input45 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_cr_BN", request.getParameter("oth_cr_BN"), 1000, true) );
	String oth_cr_BN = ESAPI.encoder().encodeForSQL(new OracleCodec(), input45!=null?input45:"");
	WriteLog("Integration jsp: oth_cr_BN: "+oth_cr_BN);
	
	String input46 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_cr_RR", request.getParameter("oth_cr_RR"), 1000, true) );
	String oth_cr_RR = ESAPI.encoder().encodeForSQL(new OracleCodec(), input46!=null?input46:"");
	WriteLog("Integration jsp: oth_cr_RR: "+oth_cr_RR);
	
	String input47 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Credit_Limit_Increase", request.getParameter("Credit_Limit_Increase"), 1000, true) );
	String Credit_Limit_Increase = ESAPI.encoder().encodeForSQL(new OracleCodec(), input47!=null?input47:"");
	WriteLog("Integration jsp: Credit_Limit_Increase: "+Credit_Limit_Increase);
	
	String input48 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_cli_type", request.getParameter("oth_cli_type"), 1000, true) );
	String oth_cli_type = ESAPI.encoder().encodeForSQL(new OracleCodec(), input48!=null?input48:"");
	WriteLog("Integration jsp: oth_cli_type: "+oth_cli_type);
	
	String input49 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_cli_months", request.getParameter("oth_cli_months"), 1000, true) );
	String oth_cli_months = ESAPI.encoder().encodeForSQL(new OracleCodec(), input49!=null?input49:"");
	WriteLog("Integration jsp: oth_cli_months: "+oth_cli_months);
	
	String input50 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_cli_RR", request.getParameter("oth_cli_RR"), 1000, true) );
	String oth_cli_RR = ESAPI.encoder().encodeForSQL(new OracleCodec(), input50!=null?input50:"");
	WriteLog("Integration jsp: oth_cli_RR: "+oth_cli_RR);
	
	String input51 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Change_in_Standing_Instructions", request.getParameter("Change_in_Standing_Instructions"), 1000, true) );
	String Change_in_Standing_Instructions = ESAPI.encoder().encodeForSQL(new OracleCodec(), input51!=null?input51:"");
	WriteLog("Integration jsp: Change_in_Standing_Instructions: "+Change_in_Standing_Instructions);
	
	String input52 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_csi_PH", request.getParameter("oth_csi_PH"), 1000, true) );
	String oth_csi_PH = ESAPI.encoder().encodeForSQL(new OracleCodec(), input52!=null?input52:"");
	WriteLog("Integration jsp: oth_csi_PH: "+oth_csi_PH);
	
	String input53 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_csi_TOH", request.getParameter("oth_csi_TOH"), 1000, true) );
	String oth_csi_TOH = ESAPI.encoder().encodeForSQL(new OracleCodec(), input53!=null?input53:"");
	WriteLog("Integration jsp: oth_csi_TOH: "+oth_csi_TOH);
	
	String input54 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_csi_NOM", request.getParameter("oth_csi_NOM"), 1000, true) );
	String oth_csi_NOM = ESAPI.encoder().encodeForSQL(new OracleCodec(), input54!=null?input54:"");
	WriteLog("Integration jsp: oth_csi_NOM: "+oth_csi_NOM);
	
	String input55 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_csi_CSIP", request.getParameter("oth_csi_CSIP"), 1000, true) );
	String oth_csi_CSIP = ESAPI.encoder().encodeForSQL(new OracleCodec(), input55!=null?input55:"");
	WriteLog("Integration jsp: oth_csi_CSIP: "+oth_csi_CSIP);
	
	String input56 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_csi_POSTMTB", request.getParameter("oth_csi_POSTMTB"), 1000, true) );
	String oth_csi_POSTMTB = ESAPI.encoder().encodeForSQL(new OracleCodec(), input56!=null?input56:"");
	WriteLog("Integration jsp: oth_csi_POSTMTB: "+oth_csi_POSTMTB);
	
	String input57 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_csi_CSID", request.getParameter("oth_csi_CSID"), 1000, true) );
	String oth_csi_CSID = ESAPI.encoder().encodeForSQL(new OracleCodec(), input57!=null?input57:"");
	WriteLog("Integration jsp: oth_csi_CSID: "+oth_csi_CSID);
	
	String input58 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_csi_ND", request.getParameter("oth_csi_ND"), 1000, true) );
	String oth_csi_ND = ESAPI.encoder().encodeForSQL(new OracleCodec(), input58!=null?input58:"");
	WriteLog("Integration jsp: oth_csi_ND: "+oth_csi_ND);
	
	String input59 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_csi_CDACNo", request.getParameter("oth_csi_CDACNo"), 1000, true) );
	String oth_csi_CDACNo = ESAPI.encoder().encodeForSQL(new OracleCodec(), input59!=null?input59:"");
	WriteLog("Integration jsp: oth_csi_CDACNo: "+oth_csi_CDACNo);
	
	String input60 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_csi_AccNo", request.getParameter("oth_csi_AccNo"), 1000, true) );
	String oth_csi_AccNo = ESAPI.encoder().encodeForSQL(new OracleCodec(), input60!=null?input60:"");
	WriteLog("Integration jsp: oth_csi_AccNo: "+oth_csi_AccNo);
	
	String input61 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_csi_RR", request.getParameter("oth_csi_RR"), 1000, true) );
	String oth_csi_RR = ESAPI.encoder().encodeForSQL(new OracleCodec(), input61!=null?input61:"");
	WriteLog("Integration jsp: oth_csi_RR: "+oth_csi_RR);
	
	String input62 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Setup_Suppl_Card_Limit", request.getParameter("Setup_Suppl_Card_Limit"), 1000, true) );
	String Setup_Suppl_Card_Limit = ESAPI.encoder().encodeForSQL(new OracleCodec(), input62!=null?input62:"");
	WriteLog("Integration jsp: Setup_Suppl_Card_Limit: "+Setup_Suppl_Card_Limit);
	
	String input63 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_ssc_Amount", request.getParameter("oth_ssc_Amount"), 1000, true) );
	String oth_ssc_Amount = ESAPI.encoder().encodeForSQL(new OracleCodec(), input63!=null?input63:"");
	WriteLog("Integration jsp: oth_ssc_Amount: "+oth_ssc_Amount);
	
	String input64 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_ssc_SCNo", request.getParameter("oth_ssc_SCNo"), 1000, true) );
	String oth_ssc_SCNo = ESAPI.encoder().encodeForSQL(new OracleCodec(), input64!=null?input64:"");
	WriteLog("Integration jsp: oth_ssc_SCNo: "+oth_ssc_SCNo);
	
	String input65 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_ssc_RR", request.getParameter("oth_ssc_RR"), 1000, true) );
	String oth_ssc_RR = ESAPI.encoder().encodeForSQL(new OracleCodec(), input65!=null?input65:"");
	WriteLog("Integration jsp: oth_ssc_RR: "+oth_ssc_RR);
	
	String input66 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Re_Issue_of_PIN", request.getParameter("Re_Issue_of_PIN"), 1000, true) );
	String Re_Issue_of_PIN = ESAPI.encoder().encodeForSQL(new OracleCodec(), input66!=null?input66:"");
	WriteLog("Integration jsp: Re_Issue_of_PIN: "+Re_Issue_of_PIN);
	
	String input67 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_rip_reason", request.getParameter("oth_rip_reason"), 1000, true) );
	String oth_rip_reason = ESAPI.encoder().encodeForSQL(new OracleCodec(), input67!=null?input67:"");
	WriteLog("Integration jsp: oth_rip_reason: "+oth_rip_reason);
	
	String input68 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_rip_DC", request.getParameter("oth_rip_DC"), 1000, true) );
	String oth_rip_DC = ESAPI.encoder().encodeForSQL(new OracleCodec(), input68!=null?input68:"");
	WriteLog("Integration jsp: oth_rip_DC: "+oth_rip_DC);
	
	String input69 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_rip_BN", request.getParameter("oth_rip_BN"), 1000, true) );
	String oth_rip_BN = ESAPI.encoder().encodeForSQL(new OracleCodec(), input69!=null?input69:"");
	WriteLog("Integration jsp: oth_rip_BN: "+oth_rip_BN);
	
	String input70 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("oth_rip_RR", request.getParameter("oth_rip_RR"), 1000, true) );
	String oth_rip_RR = ESAPI.encoder().encodeForSQL(new OracleCodec(), input70!=null?input70:"");
	WriteLog("Integration jsp: oth_rip_RR: "+oth_rip_RR);
	
	String input71 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("BR_Remarks", request.getParameter("BR_Remarks"), 1000, true) );
	String BR_Remarks = ESAPI.encoder().encodeForSQL(new OracleCodec(), input71!=null?input71:"");
	WriteLog("Integration jsp: BR_Remarks: "+BR_Remarks);
	
	String input72 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Cards_Remarks", request.getParameter("Cards_Remarks"), 1000, true) );
	String Cards_Remarks = ESAPI.encoder().encodeForSQL(new OracleCodec(), input72!=null?input72:"");
	WriteLog("Integration jsp: Cards_Remarks: "+Cards_Remarks);
	
	String input73 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Cards_Decision", request.getParameter("Cards_Decision"), 1000, true) );
	String Cards_Decision = ESAPI.encoder().encodeForSQL(new OracleCodec(), input73!=null?input73:"");
	WriteLog("Integration jsp: Cards_Decision: "+Cards_Decision);
	
	%>


<script>

function load()
{
	
}

</script>
</head>
<body lang=EN-US onload="window.print();">

<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' onload="load()" >
<table id=tbl width="100%"   cellpadding=0 cellspacing=0>
	<tr width="100%">
		<td colspan=5 align=right width="90%" >
			&nbsp;
		</td>
		<td colspan=1 align=left width="10%" >
			<img src='\webdesktop\webtop\images\rak-logo.gif'>
		</td>
	</tr>
</table>
<form name="dataform">

<script language="javascript" src="/webdesktop/webtop/en_us/scripts/DSR_RBCommon.js"></script>
<br>
<table border="0" cellspacing="1" cellpadding="1" width=100% >
		<TR>
			<td nowrap width="200" height="16" class="RBPrint" colspan=1 id="IntroductionDateTime">Introduction Date & Time :</td>
			<td nowrap  width="800" colspan=1><%=IntroductionDateTime==null?"":IntroductionDateTime%></td>
		</tr>
		<TR>
			<td nowrap width="200" height="16" class="RBPrint" colspan=1 id="BU_UserName">Introduced By :</td>
			<td nowrap  width="800" colspan=1><%=BU_UserName==null?"":BU_UserName%></td>
		</tr>
</table>

<table border="0" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
			<td  colspan=4 align=center ><b>Request Type:Other Debit Card Requests  </b></td>
		</tr>
		</table>
	<table border="1" cellspacing="1" cellpadding="1" width=100% >
		<tr  border="1" width=100% >
			<td colspan=4 align=center class="RBPrint"><b>Debit Card Information &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Registration No: <%=wi_name%></b></td>
		</tr>
		</table>
		<table>
		<TR>
			<td nowrap width="100" height="16" class="RBPrint" colspan=1 id="DCI_DebitCN">Debit Card No:</td>
			<td nowrap  width="200" colspan=1><%=DCI_DebitCN==null?"":DCI_DebitCN%></td>
			<td nowrap  height="16" class="RBPrint" id="DCI_CName">Customer Name:</td>
			<td nowrap  width="150"><%=DCI_CName==null?"":DCI_CName%></td>
		</tr> 
		<TR>
			<td nowrap width="190" height="16" class="RBPrint" id="DCI_ExpD">Expiry Date:</td>
			<td nowrap width="190"><%=DCI_ExpD==null?"":DCI_ExpD%></td>
			<td nowrap width="100" height="16" class="RBPrint" id="DCI_CT">Card Type:</td>
			<td nowrap width="180"><%=DCI_CT==null?"":DCI_CT%></td> 
		</tr>
		<TR>
	    <td nowrap width="170" height="16" class="RBPrint" id="DCI_MONO">Mobile No:</td>
        <td nowrap width="190"><%=DCI_MONO==null?"":DCI_MONO%></td>
		<td nowrap width="100" height="16" class="RBPrint" id="DCI_CAPS_GENSTAT">General Status:</td>
        <td nowrap width="180"><%=DCI_CAPS_GENSTAT==null?"":DCI_CAPS_GENSTAT%></td> 
		</tr>
		<TR>
	     <td nowrap width="170" height="16" class="RBPrint" id="DCI_ELITECUSTNO">Master No:</td>
        <td nowrap width="190"><%=DCI_ELITECUSTNO==null?"":DCI_ELITECUSTNO%></td>
		<td nowrap width="155" height="16" class="RBPrint" id="DCI_ExtNo">Ext No.:</td> 
        <td nowrap  width="190"><%=DCI_ExtNo==null?"":DCI_ExtNo%></td>
		</tr>	
	</table>


<table border="1" cellspacing="1" cellpadding="1" width=100% >
		
	<tr  border="1" width=100% >
			<td colspan=4 align=center class="RBPrint"><b>Verification Details</b></td>
	</tr>
	</table>
	<table>
	<TR>
	
	<%if(VD_TINCheck.equalsIgnoreCase("true")){ %>
        <td nowrap  height="16" class="RBPrint" id="C_VD_TINCheck" colspan=4>&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;TIN Check</td>
		<% } else {%>
		<td nowrap  height="16" class="RBPrint" id="C_VD_TINCheck" colspan=4><input type="checkbox" name="VD_TINCheck" style='width:25px;' disabled>&nbsp;TIN Check</td>
		<%}%>
	</tr>
	<TR>
	<%if(VD_MoMaidN.equalsIgnoreCase("true")){ %>
        <td nowrap  height="16" class="RBPrint" colspan=3 width=29% id="C_VD_MoMaidN">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;Any 4 of the following RANDOM Questions</td>
		<% } else {%>
		 <td nowrap  height="16" class="RBPrint" colspan=3 width=29% id="C_VD_MoMaidN"><input type="checkbox" name="VD_MoMaidN"  style='width:25px;'  disabled>&nbsp;Any 4 of the following RANDOM Questions</td>
	<%}%>
	</TR>
	<TR>
		<tr>
		<%if(VD_POBox.equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=50% id="C_VD_POBox">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;P.O Box</td>
		<% } else {%>
		<td class="RBPrint" nowrap width=50% id="C_VD_POBox"><input type="checkbox" name="VD_POBox" disabled style='width:25px;'   disabled >&nbsp;&nbsp;P.O Box</td>
			<%}%>
		<%if(VD_Oth.equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=50% id="C_VD_Oth">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mother's Maiden name</td>
			<% } else {%>
			<td class="RBPrint" nowrap width=50% id="C_VD_Oth"><input type="checkbox" name="VD_Oth" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Mother's Maiden name</td>
				<%}%>
		</tr>
		<tr>
		<%if(VD_MRT.equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=50% id="C_VD_MRT">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Most Resent Transaction (Date,Amount in Transaction Currency)</td>
			<% } else {%>
			<td class="RBPrint" nowrap width=50% id="C_VD_MRT"><input type="checkbox" name="VD_MRT" disabled style='width:25px;'  disabled >&nbsp;&nbsp;Most Resent Transaction (Date,Amount in Transaction Currency)</td>
				<%}%>
		<%if(VD_StaffId.equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=50% id="C_VD_StaffId">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Staff ID No./Military ID No.</td>
          <% } else {%>
		  <td class="RBPrint" nowrap width=50% id="C_VD_StaffId"><input type="checkbox" name="VD_StaffId" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Staff ID No./Military ID No.</td>
		  <%}%>

		</tr>
		<tr>
		<%if(VD_EDC.equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=50% id="C_VD_EDC">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Expiry date Of Your Card</td>
			 <% } else {%>
			 <td class="RBPrint" nowrap width=50% id="C_VD_EDC"><input type="checkbox" name="VD_EDC" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Expiry date Of Your Card</td>
					  <%}%>
		<%if(VD_TELNO.equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=50% id="C_VD_TELNO">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Residence,Mobile,Work Tel No.registered with us&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			 <% } else {%>
			 <td class="RBPrint" nowrap width=50% id="C_VD_TELNO"><input type="checkbox" name="VD_TELNO" disabled style='width:25px;'
	  disabled>&nbsp;&nbsp;Residence,Mobile,Work Tel No.registered with us&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			 <%}%>
		</tr>
		<tr>
			<%if(VD_DOB.equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=100% id="C_VD_DOB">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date Of Birth</td>
		 <% } else {%>
		 <td class="RBPrint" nowrap width=100% id="C_VD_DOB"><input type="checkbox" name="VD_DOB" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Date Of Birth</td>
		 	 <%}%>



        </tr>
		</TR>

</table>
<%if(Card_Upgrade.equalsIgnoreCase("Card Upgrade")){ %>

		<table border="1" cellspacing="1" cellpadding="1" width=100% >

				 <tr  border="1" width=100% >
				<td colspan=4 align=center class="RBPrint"><b>Debit card Upgrade Details</b></td>
			</tr>	
			</table>
			<table>
			<TR>	    
				<td nowrap valign="top" width="155" height="16" id="oth_cu_RR" class="RBPrint">Remarks/Reasons</td>
				<td nowrap  width="150" colspan=3><%=oth_cu_RR==null?"":oth_cu_RR.replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
			</tr>	
		</table>

<% } else if(Card_Delivery_Request.equalsIgnoreCase("Card Delivery Request")) {%>

<table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=4 align=center class="RBPrint"><b>Card Delivery Request</b></td>
	</tr>
	</table>
	<table>
	<TR>
        <td nowrap width="155" height="16" id="oth_cdr_CDT" class="RBPrint">Card Delivery To</td>
        <td nowrap  width="150"><%=oth_cdr_CDT==null?"":oth_cdr_CDT%>
		</td>
		 <td nowrap width="100" height="16" id="C_oth_cdr_BN" class="RBPrint">Branch Name</td>
        <td nowrap width="180"><%=oth_cdr_BN==null?"":oth_cdr_BN%>
		</td>   
	</tr>	
	</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap valign="top" width="155" height="16" id="oth_cdr_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=3><%=oth_cdr_RR==null?"":oth_cdr_RR.replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>

<% } else if(Transaction_Dispute.equalsIgnoreCase("Transaction Dispute")) {%>
<table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=4 align=center class="RBPrint"><b>Transaction Dispute</b></td>
	</tr>
	</table>
	<table>
	<TR>
        <td nowrap width="155" id="oth_td_RNO" height="16" class="RBPrint">Reference No.</td>
        <td nowrap  width="150"><%=oth_td_RNO==null?"":oth_td_RNO%>
		</td>
		  <td nowrap width="190" id="oth_td_Amount" height="16" class="RBPrint">Amount</td>
        <td nowrap width="190"><%=oth_td_Amount==null?"":oth_td_Amount%>
		</td>
	</tr>	
	</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap valign="top" width="155" height="16" id="oth_td_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=3><%=oth_td_RR==null?"":oth_td_RR.replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>

<% } else if(Early_Card_Renewal.equalsIgnoreCase("Early Card Renewal")) {%>
<table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=4 align=center class="RBPrint"><b>Early Card Renewal (max. 3 months before the expiry date)</b></td>
	</tr>
	</table>
	<table>
	<TR>
        <td nowrap width="155" height="16" id='oth_ecr_RB' class="RBPrint">Required by date </td>
        <td nowrap  width="150"><%=oth_ecr_RB==null?"":oth_ecr_RB%>
		</td>
		<td nowrap width="190" height="16" class="RBPrint" colspan=2></td>
        
	</tr>

	<TR>
        <td nowrap width="155" height="16" id='oth_ecr_DeliverTo' class="RBPrint">Deliver to </td>
        <td nowrap  width="150"><%=oth_ecr_dt==null?"":oth_ecr_dt%>
		</td>
		<td nowrap width="190" height="16" class="RBPrint" colspan=2></td>
        
	</tr>


<%
	String Branch_Name = oth_ecr_bn;

	if (Branch_Name.equals(""))
	{}
	else
	{
	out.print("<TR><td nowrap width=\"155\" height=\"16\" class=\"RBPrint\">Branch name </td>");
	out.print("<td nowrap  width=\"150\">"+Branch_Name);
	out.print("</td><td nowrap width=\"190\" height=\"16\" class=\"RBPrint\" colspan=2></td>");
	}	
%>
	<TR>	    
        <td nowrap valign="top" width="155" height="16" id="oth_ecr_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=3><%=oth_ecr_RR==null?"":oth_ecr_RR.replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>
<% } else if(Credit_Shield.equalsIgnoreCase("Credit Shield")) {%>
<table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=5 align=center class="RBPrint"><b>Credit Shield</b></td>
	</tr>
	</table>
	<table>
	<TR>
        <td nowrap width="150" height="16" id="oth_cs_CS" class="RBPrint">Credit Shield</td>
        <td nowrap  width="270"><%=oth_cs_CS==null?"":oth_cs_CS%>
		</td>
		<%if(oth_cs_DSR.equalsIgnoreCase("true")){ %>
		  <td nowrap width="180" height="16" id="oth_cs_DSR" class="RBPrint">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp; Credit Shield Reversal</td>
		  <% } else {%>
			<td nowrap width="180" height="16" id="oth_cs_DSR" class="RBPrint"><input type="checkbox" name="oth_cs_DSR" style='width:25px;' disabled > Credit Shield Reversal</td>
			<%}%>
			</tr>
			<tr>
  		  <td nowrap width="90" height="16" id="oth_cs_Amount" class="RBPrint">Amount</td> 
        <td nowrap width="190"><%=oth_cs_Amount==null?"":oth_cs_Amount%>
		</td>
	</tr>
	</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap valign="top" width="155" height="16" id="oth_cs_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=4><%=oth_cs_RR==null?"":oth_cs_RR.replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>
<% } else if(Card_Replacement.equalsIgnoreCase("Card Replacement")) {%>
<table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=4 align=center class="RBPrint"><b>Card Replacement</b></td>
	</tr>
	</table>
	<table>
	<TR>
        <td nowrap valign="top" width="155" height="16" id='oth_cr_reason' class="RBPrint">Reason</td>
        <td nowrap  width="250"><%=oth_cr_reason==null?"":oth_cr_reason%>
		</td>
		  <td nowrap width="190" height="16" id="oth_cr_OPS" class="RBPrint">Others Pls Specify</td>
        <td nowrap width="190"><%=oth_cr_OPS==null?"":oth_cr_OPS%>
		</td>
	</tr>


	<TR>
        <td nowrap width="155" height="16" id="oth_cr_DC" class="RBPrint">Delivery Channel</td>
        <td nowrap  width="150"><%=oth_cr_DC==null?"":oth_cr_DC%>
		</td>
		  <td nowrap width="100" id="oth_cr_BN" height="16" class="RBPrint">Branch Name</td>
        <td nowrap width="180"><%=oth_cr_BN==null?"":oth_cr_BN%>
		</td>        
	</tr>
	</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap  valign="top" width="155" height="16" id="oth_cr_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=3><%=oth_cr_RR==null?"":oth_cr_RR.replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%>
		</td>
	</tr>	
</table>
<% } else if(Credit_Limit_Increase.equalsIgnoreCase("Credit Limit Increase")) {%>
 <table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=4 align=center class="RBPrint"><b>Credit Limit Increase</b></td>
	</tr>
	</table>
	<table>
	<TR>
        <td nowrap width="155" height="16" id="oth_cli_type" class="RBPrint">Type</td>
        <td nowrap  width="150"><%=oth_cli_type==null?"":oth_cli_type%>
		</td>
		  <td nowrap width="190" height="16" id="oth_cli_months" class="RBPrint">Months</td>
     	<td><%=oth_cli_months==null?"":oth_cli_months%></td>
	</tr>
	</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap  valign="top" width="155" height="16" id="oth_cli_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=3><%=oth_cli_RR==null?"":oth_cli_RR.replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>
<% } else if(Change_in_Standing_Instructions.equalsIgnoreCase("Change in Standing Instructions")) {%>
<table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=5 align=center class="RBPrint"><b>Change in Standing Instructions</b></td>
	</tr>
	</table>
	<table>
	<TR>
		<%if(oth_csi_PH.equalsIgnoreCase("true")){ %>
        <td nowrap width="215" height="16" id="oth_csi_PH" class="RBPrint">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;Place Hold </td>
		 <% } else {%>
			<td nowrap width="215" height="16" id="oth_csi_PH" class="RBPrint"><input type="checkbox" name="oth_csi_PH" style='width:25px;' disabled >Place Hold </td>
			<%}%>

        <td nowrap  width="150" id="oth_csi_TOH" class="RBPrint">Type of Hold</td>
		  <td><%=oth_csi_TOH==null?"":oth_csi_TOH%>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>
		<td nowrap width="150" class="RBPrint" id="oth_csi_NOM">No. of Months </td>
		<td><%=oth_csi_NOM==null?"":oth_csi_NOM%>
		</td>
	</tr>
	<TR>
		<%if(oth_csi_CSIP.equalsIgnoreCase("true")){ %>
	    <td nowrap width="100" height="16" id="oth_csi_CSIP" class="RBPrint">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;Change SI %</td>
			<% } else {%>
			<td nowrap width="180" height="16" id="oth_csi_CSIP" class="RBPrint"><input type="checkbox" name="oth_csi_CSIP" style='width:25px;' disabled >Change SI %</td>
			<%}%>
        <td nowrap width="180" class="RBPrint" id="oth_csi_POSTMTB">% Of STMT Balance</td><td><%=oth_csi_POSTMTB==null?"":oth_csi_POSTMTB%></td>
		</tr>
	<TR>
		<%if(oth_csi_CSID.equalsIgnoreCase("true")){ %>
	    <td nowrap width="180" height="16" id="oth_csi_CSID" class="RBPrint">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;Change in SI Date</td>
		<% } else {%>
			<td nowrap width="100" height="16" id="oth_csi_CSID" class="RBPrint"><input type="checkbox" name="oth_csi_CSID" style='width:25px;' disabled >Change in SI Date</td>
			<%}%>

        <td nowrap width="180" id="oth_csi_ND" class="RBPrint">New date(DD)</td>
		<td colspan=3><%=oth_csi_ND==null?"":oth_csi_ND%></td>		
	</tr>
	<TR>
	    <%if(oth_csi_CDACNo.equalsIgnoreCase("true")){ %>
	    <td nowrap width="200" height="16" id="oth_csi_CDACNo" class="RBPrint">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;Change Debit A/C No.</td>
			<% } else {%>
			   <td nowrap width="200" height="16" id="oth_csi_CDACNo" class="RBPrint"><input type="checkbox" name="oth_csi_CDACNo" style='width:25px;' disabled >Change Debit A/C No.</td>
			   <%}%>

        <td nowrap width="180" id="oth_csi_AccNo" class="RBPrint">Account No.</td> 
		<td colspan=3> <%=oth_csi_AccNo==null?"":oth_csi_AccNo%></td>		
	</tr>
	</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap valign="top" width="155" height="16" id="oth_csi_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=4><%=oth_csi_RR==null?"":oth_csi_RR.replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>
<% } else if(Setup_Suppl_Card_Limit.equalsIgnoreCase("Setup Suppl. Card Limit")) {%>
<table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=4 align=center class="RBPrint"><b>Setup Suppl. Card Limit</b></td>
	</tr>
	</table>
	<table>
	<TR>
        <td nowrap width="155" height="16" id="oth_ssc_Amount" class="RBPrint">Amount Field</td>
        <td nowrap  width="150"><%=oth_ssc_Amount==null?"":oth_ssc_Amount%></td>
		  <td nowrap width="190" id="C_oth_ssc_SCNo" height="16" class="RBPrint">Suplementary Card No.</td>
        <td nowrap width="190"><%=oth_ssc_SCNo==null?"":oth_ssc_SCNo%>
		</td>
	</tr>	
	</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap  valign="top" width="155" height="16" id="oth_ssc_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=3><%=oth_ssc_RR==null?"":oth_ssc_RR.replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>
<% } else if(Re_Issue_of_PIN.equalsIgnoreCase("Re-Issue of PIN")) {%>
<table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=4 align=center class="RBPrint"><b>Reissue of PIN Details</b></td>
	</tr>
	</table>
	<table>
	<TR>
        <td nowrap width="155" height="16" id="oth_rip_reason" class="RBPrint">Reason</td>
        <td nowrap  width="150"><%=oth_rip_reason==null?"":oth_rip_reason%>
		</td>
		  <td nowrap width="190" height="16" id="oth_rip_DC" class="RBPrint">Delivery Channel</td>
        <td nowrap width="190"><%=oth_rip_DC==null?"":oth_rip_DC%>
		</td>
	</tr>
	<TR>
	    <td nowrap width="100" height="16" id="oth_rip_BN" class="RBPrint">Branch Name</td>
        <td nowrap width="180"><%=oth_rip_BN==null?"":oth_rip_BN%>
		</td>        
		  <td nowrap width="170" height="16" class="RBPrint" colspan=2>&nbsp;&nbsp;</td>
	</tr>
	</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap valign="top" width="155" height="16" id="oth_rip_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=3><%=oth_rip_RR==null?"":oth_rip_RR.replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>

 <%}%>
  <br>
 <table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap valign="top" width="155" height="16" id="BR_Remarks" class="RBPrint">Branch Return Remarks/Reasons</td>
        <td nowrap  width="150" colspan=3><%=BR_Remarks==null?"":BR_Remarks.replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>
<%

String Cards_Rem = Cards_Remarks;
Cards_Rem=Cards_Rem.replace("ampersand","&");
Cards_Rem=Cards_Rem.replace("equalsopt","=");
Cards_Rem=Cards_Rem.replace("percentageopt","%");

String cardDecision = Cards_Decision;
if ((Cards_Rem.equals("")) && (cardDecision.equals("")))
{}
else
{
out.print("<table border=\"1\" cellspacing=\"1\" cellpadding=\"1\" width=100% >");
out.print("<tr  border=\"1\" width=100% >");
out.print("<td colspan=4 align=center class=\"RBPrint\"><b>CARDS Details</b></td>");
out.print("</tr>");
out.print("</table>");
String cardDecTemp = new String();
if(cardDecision.equals("CARDS_E"))
{cardDecTemp="Complete";}
else if(cardDecision.equals("CARDS_BR"))
{cardDecTemp="Re-Submit to Branch";}
else if(cardDecision.equals("CARDS_UP"))
{cardDecTemp="Under Process";}

out.print("<table>");
out.print("<TR>");
out.print("<td nowrap width=\"140\" height=\"16\" class=\"RBPrint\"  id=\"CardsDecision\">Decision:</td>");
out.print("<td nowrap width=\"180\" >");
out.print(cardDecTemp);
out.print("</td>");
out.print("</tr>");
out.print("<tr>");
out.print("<td valign=\"top\" nowrap width=\"140\" height=\"16\" class=\"RBPrint\" id=\"Cards_Remarks\">Remarks/ Reason:</td>");
out.print("<td wrap width=\"800\" align=\"left\" class=\"RBPrint\">");
out.print(Cards_Rem);
out.print("</td>");
out.print("</TR>");
out.print("</table>");
}	
%>

&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp <br><font size="-1">"This is a Computer Generated Document, therefore needs no signature."</font>
<br>
<br>
<br>
<br>
<table border="0" cellspacing="1" cellpadding="1" width=100% >
	  <tr class="" width=100% class="">
			<td  colspan=4 align="right" class="">------------------------</td>
	  </tr>
	  	 <tr class="" width=100% class="">
			<td  colspan=4 align="right" class=""><%=wfsession.getUserName()%></td>

	 </tr>
	 <tr class="" width=100% class="">
			<td  colspan=4 align="right" class=""><%=CurrDate %></td>

	 </tr>
 </table>

<body topmargin=0 leftmargin=15 class='EWGeneralRB'>
</form>
</body>
<br>
<br>
</form>


</form>
</body>