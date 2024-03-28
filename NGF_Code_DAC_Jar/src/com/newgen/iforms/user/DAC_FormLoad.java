package com.newgen.iforms.user;

import java.util.Calendar;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.json.simple.JSONArray;
import java.util.List;
import org.json.simple.JSONObject;
import com.newgen.iforms.custom.IFormReference;

public class DAC_FormLoad extends DACCommon {
	public String formLoadEvent(IFormReference iform, String controlName, String event, String data) {
		String strReturn = "";

		DAC.mLogger.debug("This is DAC_FormLoad_Event");

		// CMS.mLogger.debug("SELECT DECISION FROM USR_0_DAC_DECISION_MASTER WHERE
		// WORKSTEP_NAME= '"+iform.getActivityName()"' and ISACTIVE='Y'");

		if (controlName.equalsIgnoreCase("DecisionDropDown") && event.equalsIgnoreCase("FormLoad")) {

			String actname = iform.getActivityName();
			// CMS.mLogger.debug(actname);
			List lstDecisions = iform
					.getDataFromDB("SELECT DECISION FROM USR_0_DAC_DECISION_MASTER WHERE WORKSTEP_NAME= '"
							+ iform.getActivityName() + "' and ISACTIVE='Y' order by DISPLAY_ORDER");

			String value = "";

			DAC.mLogger.debug(lstDecisions);

			iform.clearCombo("DECISION");
			for (int i = 0; i < lstDecisions.size(); i++) {
				List<String> arr1 = (List) lstDecisions.get(i);
				value = arr1.get(0);
				iform.addItemInCombo("DECISION", value, value);
			}
		}

		else if ("SolId".equals(controlName) && event.equalsIgnoreCase("FormLoad")) {
			try {

				List<List<String>> lstDecision = iform
						.getDataFromDB("SELECT comment FROM PDBUser with (nolock) WHERE UserName='" + data + "'");
				for (List<String> row : lstDecision) {

					strReturn = row.get(0);

				}
				DAC.mLogger.debug("return for Sol Id on Load " + strReturn);

			} catch (Exception e) {
				DAC.mLogger.debug("Exception in SolId on load " + e.getMessage());
			}
		}

		return strReturn;
	}

}
