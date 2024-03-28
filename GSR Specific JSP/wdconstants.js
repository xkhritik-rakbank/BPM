/*
		Product         :       OmniFlow
		Application     :       OmniFlow Web Desktop
		Module          :
		File            :       wdconstants.js
		Purpose         :       Contains the general constants used in the project.

		Change History  :

		Problem No        Correction Date		Comments
		Bug 29752       30/12/2011          If you are login in webdesktop and app server is stopped then proper message should be displayed
		 Bug 31306       23/04/2012      Jaseem Ansari   Print functionality needed in webdesktop
		 Bug 37113    12/12/2012     In case of optimized search with * allowing only at end of search strings
         Bug 37595      31/12/2012     No default selected Doc Type in Import Document Window and a Prehook to restrict upload documents
		 Bug 41692 		01/08/2013  Requirement for Date and time picker in "Advance search" and "Set filter" screens of webdesktop. Currently date is entered manually by the user.
                 Bug 42544              12/11/2013  Exception should be committed before introduce or done operation on workitem.
		 Bug 42724   	11/12/2013 	 Need INI based configuration to not show Workitem List by default
		 Bug 45041       31/04/2014        API Calls Optimization to improve performance over the network
		 Bug 47588 		22/07/2014		 To Provide support for displaying total number of workItems and pages while click on Queue or Seaching from 

Advance search functionality
                -----------       ----------------      ----------

*/
var SEPERATOR1= '\u00b6';
var SEPERATOR2= '\u00fc';
var SEPERATOR3=';';
var SEPERATOR4='\u00b5';  //mu character
var SEPERATOR5='=';
var SEPARATOR6='\u00df';
var SEPARATOR7='@';
var SEPERATOR8='#';
var SEPERATOR9='$';
var SEPERATOR10='-';
var PATH='en_us/';
var LEFT='Left';
var RIGHT='Right';
var dir="ltr";
var ABSBOTTOM="absbottom";
var ALERT_INVALID_LOGIN_INFO="Invalid Login Information";
var OPEN_SQ_BRACKETS="[";
var CLOSE_SQ_BRACKETS="]";
var SYMBOL_3=":";

var COMBO_ALL_PROCESS='--All Processes--';
var COMBO_PREV_BATCH='--Previous Batch--';
var COMBO_NEXT_BATCH='--Next Batch--';
var COMBO_ALL_ACT='--All Worksteps--';
var COMBO_ALL_QUEUES='--My Queue--';
var COMBO_CONVERSATION = 'Conversation';
var COMBO_MY_SEARCH_QUEUE = '-- My Search Queue --';
var COMBO_SELECT_EXCEPTION='--Select an Exception--';
var COMBO_SHOW_ALL='--Show All--';
var COMBO_NO_EXCEPTION='--No Exception Raised--';

var ALERT_SET_REMINDER='Please add some reminder to set.';
var ALERT_SELECT_DOCUMENT_TO_ADD='Select a document to Add.';
var ALERT_DOCNAME_ALREADY_ADDED = '<docname> has already been added.';
var ALERT_FILE_NOT_EXIST = 'File "<filename>" does not exist.';
var ALERT_FILE_NOT_FOUND = 'File not Found.';
var ALERT_LENGTH_EXCEEDED_MAX = 'Length of File exceeded 10 MB.';
var ALERT_EXCEP_TRIG_NOT_FOUND = 'Error: While executing exception trigger, Exception Definition not found!';
var ALERT_SCAN_ACTION_NOT_FOUND = 'Error while executing scanactions: Scan Actions definition not found!';
var ALERT_SAVING_DATA= 'Error while saving Data!';
// Start for WCL_I_5.0.1_345
var INVALID_CHAR_IN_BATCH_SIZE_FIELD = "Only Digits are allowed in batch size field.";
var INVALID_BATCH_SIZE = "Batch size should lie between 1 to  250.";
var ALERT_ENTER_BATCHSIZE= 'Please specify the batch size value.';
var SPECIFY_OTHER_VALUE_FOR_BATCH_SIZE='Specify a value for batch size other than the existing value.';
// End for WCL_I_5.0.1_345

var ALERT_ENTER_REMINDERINTERVAL= 'Please specify some reminder interval.';
var SELECT_DOC_TO_UPLOAD = 'Please select a document to upload.';
var SPECIFY_EXT_FOR_DOC = 'Please specify an extension for the document.';
var ALERT_SELECT_USER='Please select a user.';
var ALERT_PLUGIN_FOR_95_NT='This plug-in only runs on Windows NT/95.';
var ALERT_ENABLE_SMARTUPDATE="Enable SmartUpdate before running this script.";
var ALERT_ENABLE_JAVA="Enable Java before running this script.";
var ALERT_NO_TO_ADDR="Variable associated with to address is not modifyable.";
var ALERT_NO_CC_ADDR="Variable associated with CC address is not modifyable.";
var ALERT_NO_FROM_ADDR="Variable associated with From address is not modifyable.";
var ALERT_SELECT_PROCESS="Please select a process.";
var ALERT_CONFIRM_DELETE_QUERY="Are you sure you want to delete this query?";
var ALERT_DELETE_FILTER="Are you sure you want to delete this filter?";
var ALERT_QRY_NOT_DEL ="The Query could not be deleted due to the following error at the server end :";
var CONFIRM_DELETE_WI = 'Are you sure you wish to delete the workitem(s)?';
var ALERT_SELECT_PROCESS_INSTANCE="Please select some Process Instance.";
//Begin PR:PCL_3.0.1.0091
var ALERT_CLOSE_SAVE_CONFIRM = "Do you want to save the workitem?";
var ALERT_REASSIGN_SAVE_CONFIRM = "Do you want to save workitem before reassignment?";
var ALERT_REFER_SAVE_CONFIRM = "Do you want to save workitem before referring it?";
//End PR:PCL_3.0.1.0091
var ALERT_RETRY_SEL_SCANNER='Please select a scanner.';
var ALERT_SCAN_ERROR = 'An error occured while scanning the document.';
var ALERT_SAME_USER = 'Workitem cannot be assigned to same user.';
var ALERT_SAME_REFER_USER = 'Workitem cannot be referred to the same user.';
var ALERT_SELECT_EXCEPTION = 'Please select an exception.';
var ALERT_SELECT_PRIORITY = 'Please select a priority.';
var ALERT_SELECT_QUERY = 'Please select a query.';
var ALERT_CLEAR_COMMENT = 'Please enter some clearing comments.';
var ALERT_RAISE_COMMENT = 'Please enter some raising comments.';
var ALERT_MODIFY_COMMENT = 'Please enter some modifying comments.';
var ALERT_SET_REMINDERS = 'Please enter some comments.';
var ALERT_SOME_CONVERSATION = 'Please enter some Conversation text.';
var ALERT_QUERY_ALREADY_EXISTS = 'A query with the specified name already exists. Please change it and try again.';
var ALERT_QUERY_ALREADY_EXISTS1 = 'A query with the specified name already exists. do you want to select another name for the query?';
var ALERT_NO_QUERY_NAME = 'Please specify some name for the query.';
var ALERT_QUERY_BLANK="Query Name cannot be blank.";
var ALERT_MAX_QRY_LEN="Query Name cannot be more than 255 characters.";
var ALERT_MAX_QUERY_NAME="Query Name cannot be more than 25 characters.";
var ALERT_MOVE_MULTI='You cannot move multiple items together.';
var ALERT_NO_DISP_FLD='Please select atleast one display field.';
var ALERT_REMINDERINTERVAL_0='Please enter a reminder interval greater than zero.';
var ALERT_SEL_FOLDER='Please select a folder from the folder list to view its document list.';
var ALERT_NO_QRY_DEL='Currently there are no queries to delete.';
var ALERT_VALID_DATE_31="Please enter valid day.\nDay should be greater than 0 and less than or equal to 31.";
var ALERT_VALID_DATE_30="Please enter valid day.\nDay should be greater than 0 and less than or equal to 30.";
var ALERT_VALID_DATE_29="Please enter valid day.\nDay should be greater than 0 and less than or equal to 29.";
var ALERT_VALID_DATE_28="Please enter valid day.\nDay should be greater than 0 and less than or equal to 28.";
var ALERT_WRONG_YEAR="The year for the reminder is prior to the current year.\n Please re-enter the year and then click Add.";
var ALERT_WRONG_MONTH="The month for the reminder is prior to the current month.\n Please re-enter the month and then click Add.";
var ALERT_WRONG_TIME="The time for the reminder is prior to the current time.\n Please re-enter the time and then click Add.";
var ALERT_WRONG_DATE="The date for the reminder is prior to the current date.\n Please re-enter the date and then click Add.";
var ALERT_NO_REMINDER="No reminder is set to delete.";
var ALERT_NO_REMINDER_2_DELETE="No reminder is set to delete.";
var SELECT_REMINDER_2_DELETE="Please select some reminder to delete.";
var ALERT_SELECT_GROUP="Please select some group.";
var ALERT_EXCEEDING_COMMENT_LENGHT="Comment length cannot exceed 150 characters.";
var ALERT_EXCEEDING_REMINDER_COMMENT_LENGTH="Comment length cannot exceed 255 characters.";
var ALERT_EXCEEDING_COMMENT_LENGTH="Comment length cannot exceed";
var CHARS = "characters."
var ALERT_SELECT_A_PROCESS_TO_FETCH_DATA="Please select a process to fetch its data.";
//PCL_3.1.5.015 Start
var ALERT_SELECT_REMINDER="Please select a reminder to dismiss.";
//PCL_3.1.5.015 End
var ALERT_GET_JRE="This version of Java is not supported.Please download and install version 1.4.1_02 or above.";

var JAN="Jan";
var FEB="Feb";
var MAR="Mar";
var APR="Apr";
var MAY="May";
var JUN="Jun";
var JUL="Jul";
var AUG="Aug";
var SEP="Sep";
var OCT="Oct";
var NOV="Nov";
var DEC="Dec";

var JAN1="JAN";
var FEB1="FEB";
var MAR1="MAR";
var APR1="APR";
var MAY1="MAY";
var JUN1="JUN";
var JUL1="JUL";
var AUG1="AUG";
var SEP1="SEP";
var OCT1="OCT";
var NOV1="NOV";
var DEC1="DEC";

var AT="At";
var CREATED_ON="Created On";
var BY="BY";
var ON="ON";
var LABEL_ON="on";

var DOB_CANNOT_BE_A_VERSION="DOB file cannot be added as a version of the document.";
var ONLY_ALPHANUMERIC_CHARS_IN_DOCUMENT_NAME='Only alpah-numberic characters allowed.';
var INAVLID_CHARS_IN_DOCUMENT_NAME="Characters   |  , #  :   <   >   \"   /  * ?  \\ are not allowed in Document Name.";
var ONLY_ALPHANUMERIC_CHARS_IN_DOCUMENT_NAME="Only alpha-numeric characters are allowed in Document Name.";
var LENGTH_EXCEEDED_IN_VERSION_COMMENT="Maximum length for Version Comment is 255 characters.";
var INVALID_CHARS_IN_VERSION_COMMENT="Characters   &   =   #   <   >   \"   '   `   \\   are not allowed in Version Comment.";
var SELECT_DOC_VERSION_TO_DELETE="Please select a document version to delete.";
var SELECT_DOC_VERSION_TO_CHANGE_COMMENTS="Please select a document version for changing comments.";
var CONFIRM_DOC_VERSION_DELETION="Are you sure you want to delete the selected version?\nOnce deleted there is no way to retrieve this version.";
var SELECT_DOC_VERSION_FOR_LATEST="Please select a document version for making it as latest version.";
var DOC_ALREADY_CHECKED_OUT="This document is already checked out";
var DOC_ALREADY_CHECKED_IN="This document is already checked in";
var DOC_CHECKED_OUT_BY_SOME_OTHER_USER="This document is checked out by some other user .";
var CONFIRM_CHECKOUT_DOC="Are you sure you want to checkout this document?";
var FIELD_NAME="Field Name";
var LOGICAL_OPERATOR="Logical Operator";
var OPERATOR ="Operator";
var VALUE="Value";
var ALT_LOCKED="Locked";
var ALT_IN_EXCEPTION = "In Exception";
var ADVANCED_SEARCH= "Advanced Search";
var FORM_FIELD = "in some of the form field(s).";
var INVALID_NUMBER = "Invalid number specified";
var INVALID_NUMBER_RANGE = "Numeric value out of range";
var INVALID_STRING_LENGTH = "Value exceeds max noumber of permitted characters";
var INVALID_STRING_CHAR= "Invalid character";
var INVALID_FLOAT_NUMBER = "Invalid Float Number";
var INVALID_DATE="Invalid date specified.";
var INVALID_DATE_2="Invalid date specified.";
var INVALID_DATE_YEAR = "Invalid date year specified.";
var INVALID_DATE_MONTH= "Invalid date month specified.";
var INVALID_DATE_RANGE = "Invalid date range specified";
var INVALID_LONG = "Invalid long number specified";
var INVALID_LONG_RANGE = "Long value out of range";
var INVALID_FLOAT_RANGE = "Float value out of range.";

var SUCCESS="succ";
var FAILURE="fail";

var TRIG_SUCCESS = 'Success';
var TRIG_FAILIURE = 'Failed';

var TO_DO_LIST_MANDATORY = "No value specified for Mandatory To Do Item.";
var CONFIRM_SAVE="Do you want to save the workitem?";
var DATEFORMAT="(mm/dd/yyyy)";
var DATESEPARATOR="/";
var ALERT_DELETE_VIEW = "Some workitems are open. Please close them before deleting.";

var CONFIRM_LOGIN="The specified user is already logged in on some other machine. Do you want to disconnect and login again?";  //WCL_6.0.1_086

var WL_VALID_TILL="Valid Till";
var WL_LOCKED_BY="Locked By";
var WL_CHECKLIST_STATUS="Checklist Complete";
var WL_INTRODUCED_BY="Introduced By";
var WL_INTRODUCED_ON="Introduced On";
var WL_REGISTRATION_NO="Registration No";
var WL_WORKITEM_NAME="Workitem Name";
var WL_LOCKED_DATE="Locked Time";
var WL_WORKSTEP_NAME="Workstep Name";
var WL_STATUS="Status";
var WL_STATE="Workitem State";
var WL_ENTRY_DATE="Entry Date Time";
var WL_PRIORITY="Priority";
var WL_EXCP_STATUS="Exception Status";
var WL_LOCKSTATUS="Lock Status";
var WL_WI_AGE="Total Age";
var WL_WI_AGE_IN_WORKSTEP="Age In Workstep";
var QUEUE_VARIABLES="Queue Variable(s)";

var F_NAME="Folder Name";
var F_MODIFIED_TIME="Modified Time";
var F_OWNER="Owner";
var F_LOCKED_DATE="Locked Date";
var F_ACCESSED_DATE="Accessed Date";
var F_CREATION_DATE="Creation Date";
var F_REVISED_DATE="Revised Date";
var F_DATACLASS="Data Class";

var D_NAME="Document Name";
var D_DATACLASS="Data Class";
var D_SIZE="Size";
var D_TYPE="Type";
var D_CHECKEDOUT_BY="Checked Out By";
var D_CREATED_ON="Created On";
var D_ACCESSED_DATE="Accessed Date";
var D_CREATION_DATE="Creation Date";
var D_REVISED_DATE="Revised Date";
var D_PAGES="Pages";
var D_OWNER="Owner";
var D_VERSION_NO="Version";
var D_USEFUL_INFO="Useful Info";
var D_ANNOTATED="Annotated";
var D_LINKED="Linked";
var D_CHECKED_OUT="Checked Out";
var D_ORDER_NO='Order No';

var WD_PREV="Previous Workitem";
var WD_NEXT="Next Workitem";
var WD_SAVE="Save";
var WD_TOOLS="Tools";
var WD_DONE_INTRO="Done/Introduce";
var WD_HELP="Help";
var WD_ACCEPT_REJECT="Accept/Reject";
var WD_INTRODUCE="Introduce";

var OP_WI_ADDCONVERSATION="Add Conversation";
var OP_WI_ADDDOCUMENT="Add Document";
var OP_WI_IMPORTDOCUMENT="Import Document";
var OP_WI_SCANDOCUMENT="Scan";
var OP_WI_PREFERENCE="Set Preference";
var OP_WI_REASSIGNWI="Reassign Workitem";
var OP_WI_LINKEDWI="Linked Workitems";
var OP_WI_SEARCH="Search Workitem";
var OP_SEARCH_DOCUMENT="Search Document";
var OP_SEARCH_FOLDER="Search Folder";
var OP_WI_REFER_REVOKE="Refer/Revoke";
var OP_WI_EXT_INTERFACES="External Interfaces";
var OP_WI_PROPERTIES="Workitem Properties";

var INVALID_CHARS_FOLDERNAME="Characters  |   &   =   #   ,   <   >   \"   '   `   \\   are not allowed in Folder Name.";
var INVALID_CHARS_SRCH_QUERY="Invalid char : { |  , #  :   <   >   \"   /   \\ } symbols are not allowed in Search query.";   // Added For WCL_I_5.0.1_462
var INVALID_CHARS_SRCH_QUERYNAME="Invalid char | , # : < > \" / & \\ = ' ` ( ) + % *  symbols are not allowed in Query Name.";
var INVALID_CHARS_IN_KEYWORD="Characters   \\ / : * \" < > | ?  ;  are not allowed in Keywords.";
var INVALID_CHARS_KEYWORDS= "Characters   \\ / : * \" < > | ?  ;  are not allowed in Keywords.";
var CHARS_NOT_ALLOWED_IN_KEYWORDS="Characters   \\ / : * \" < > | ?  ;  are not allowed in Keywords.";
var MAX_LENGTH_KEYWORDS="A keyword may not exceeded a maximum of 32 characters";
var MAX_LENGTH_DOCNAME="Name can not exceed 255 characters.";
var MAX_LENGTH_DOCTYPE="DocType can not exceed 4 characters.";
var MAX_LENGTH_USERNAME="User name cannot exceed 50 characters";
var INVALID_DATE_RANGE="The date range does not seem to be valid. Please correct and try again.";
var INVALID_NUMERIC_VALUE="The value for numeric field does not seem to be valid. Please correct and try again.";
var MANDATORY_FIELD="Please Enter Value In Mandatory Field";
var INVALID_DATE="The date does not seem to be valid.\nPlease provide a date in DD-MM-YYYY format and try again.";
var INVALID_DATE_1= "The date does not seem to be valid.\nPlease provide a date  after 1-1-1900 and try again.";
var INVALLD_BOOL="The value for boolean field does not seem to be valid. Please correct and try again.";
var INVALID_STRING="Invalid string value in search criteria";
var INVALID_STR1="Invalid string value # not allowed in search criteria.";
var INVALID_STR2="Invalid string value \u00FF and \u00FC not allowed in search criteria.";
var INVALID_START_NUMERIC_VALUE="Please enter valid start (numeric) value.";
var INVALID_END_NUMERIC_VALUE="Please enter valid end (numeric) value.";
var INVALID_FTS_QUERY="Invalid FTS Query. Click Help button for Full Text Search Query syntax.";
var ENTER_BOTH_VALUES="Please enter both values.";
var INDEX_VALUE_OUT_OF_RANGE="Index Value entered is out of range.";
var SEL_FIELD_TO_DELETE="Please select a field to remove.";
var SELECT_GLOBAL_INDEX="Please select a global index";
var CANNOT_REMOVE_MANDATORY_COLUMNS="Cannot remove mandatory columns from the display list.";
var LABEL_ANY_USER = 'Any User';
var CANNOT_REMOVE_ALL_COLUMNS="Cannot remove all columns from the display list.";
var CANNOT_REMOVE_ALL_COLUMNS_1="At least one column should be there other than Queue variables.";
var INVALID_EMAIL_ID_From="Invalid Email Id for From user.";
var INVALID_EMAIL_ID_To="Invalid Email Id for To user.";
var INVALID_EMAIL_ID_CC="Invalid Email Id for CC user.";
var SPECIFY_FROM_EMAILID="Please specify the From address.";
var BLANK_EMAILID_TO_CC="Both to and cc user are blank so mail cannot be sent";
var NO_RESULTS_SAVED="No Results to save";
var SEARCH_ON_VALUES_PROCESS_ATTRIBUTES="Search on Values of Process Attributes"
var CONFIRM_QUERY_DUPLI_NAME="This query name already exist. Do you want to modify this query?";
var CONFIRM_ANOTHER_QUERY_NAME="Do you want to save it with another name?";
var INVALID_CHARACTERS="Invalid char : {  |  ,  #  :  <  >  \"  (  /  ?  \\  &  +  %  )  *  } symbols are not allowed in Query Name.";
var INVALID_CHARACTERS_SEARCH="Invalid char : {\\  /  :  \"  <   >  |  ellipses(...) } symbols are not allowed in Search query.";

var TEXT_CHECKIN= "Check In";
var TEXT_CHECKOUT="Check Out";
var CAB_ALREADY_REGISTERED="Cabinet with the same name already registered.";
var INI_DO_NOT_DELETE="Omniflow Ini --- System File: Do not alter or delete.";
var REMOVE="Remove";
var INVALID_FORMAT="Date should be in proper format as ";
var INVALID_FORMAT1="Invalid Date Format";
var INVALID_SHORT_DATE="Invalid Short Date Format";
var INVALID_TIME_FORMAT = "Invalid Time Format"
var NON_NUMERIC_DAY="Day should be numeric.";
var NON_NUMERIC_MONTH="Month should be numeric.";
var NON_NUMERIC_YEAR="Year should be numeric.";
var ALERT_YEAR_LENGTH_FORMAT="Year should be greater than 1900 and in YYYY format.";
var INVALID_MONTH_STRING="Incorrect month specified. ";
var INVALID_CHARS_PASSWORD="Characters  < , > , # and , are not allowed in Password.";
var CONSTRAINT_SPACES_PASSWORD="No spaces are allowed in the beginning or end of Password";
var MIN_LENGTH_PASSWORD="Your password must be alphanumeric and 8 characters long.";
var MISMATCH_PASSWORD="New password and Confirm password not matching.";
var SPECIFY_OLD_PASSWORD="Specify old password !";
var SPECIFY_NEW_PASSWORD="Specify new password !";
var PASSWORD_SAME_OLDPASSWORD="Password cannot be same as old password !";
var PLZ_SPECIFY_USERNAME ="Please specify a username";
var PLZ_SPECIFY_PASSWORD="Please specify a password";
var NON_NUMERIC_SEC="Seconds should be numeric and less than 60.";
var NON_NUMERIC_HOUR="Hours should be numeric and less than 24.";
var NON_NUMERIC_MIN="Minutes should be numeric and less than 60.";
var INVALID_TIME="Time should be correct format.";
var TEXT_EQUALS="Equals";
var TEXT_CONTAINS="Contains";
var TEXT_LESS="Less Than";
var TEXT_GREATER="Greater Than";
var TEXT_BETWEEN="Between";

var LABEL_MYQUEUE="My Queue";
var LABEL_SET_FILTER="Set Filter";
var LABEL_SET_FILTER_MSG="Filter on";
var LABEL_DELETE_FILTER="Delete";
var LABEL_SELECT_QUERY="Select Query";
var LABEL_NO_SAVED_QUERY="No Saved Query";
var LABEL_AUTHORISED="Authorised Queues";

var INSERT_STR_VAL="Please Insert STRING Values";
var INSERT_BOOL_VAL="Please Insert BOOLEAN Values";
var INSERT_DATE_VAL="Please Insert DATE Values in Date Format ";
var INSERT_INT_VAL="Please Insert INTEGER Values";
var INSERT_DEC_VAL="Please Insert DECIMAL Values";
var INSERT_RAW_VAL="RAW DATA";
var GEN_YES="Yes";
var GEN_NO="No";
var GEN_ALL="All";
var ALT_NEXT_BATCH='Next Batch';
var ALT_PREV_BATCH='Previous Batch';	
var INCOMPATIBLE_FORM_DATA='Value entered in some of the form field(s) is not compatible with its type.';
var DOCUMENT_COULD_NOT_UPLOADED='Document could not be uploaded properly.';


var LIKE="Like";
var STATUS="Status";
var CENTER="center";
var BUTTON_CLOSE="close";
var COMMENTS="Comments.";
var REG_NO="Registeration No.";
var LABEL_STATUS='Please wait while OmniViewer Plugin installation proceeds ...';
var LABEL_REMIND='Remind';
var COLON=':';

var TITLE_WIHISTORY='Workitem History';
var TITLE_WIPROPERTY='Workitem Properties';
var TEXT_EXCEPTIONS_RAISED="exceptions raised";
var LABEL_NO_EXCEPTION_ASSOCIATED="No exception associated";
var LABEL_ALLTODO_FILLED="All To-do items filled";
var LABEL_NOTODOITEM="No To-do items in the list";
var LABEL_TODO_NOTFILLED="To-do items not filled";
var LABEL_TODOLIST_NOT_ASSOCIATED="No Todo Items Exist in the ToDoList";
var TH_STATUS='Status';
var TEXT_ATTRIBUTES='Attributes';
var TEXT_VALUE='Value';
var TOOL_EXCEPTION="Exception";
var TOOL_TODOLIST='ToDoList';
var TOOL_DOCUMENT='Document';
var TOOL_DATA_ENTRY='Data Entry';
var LABEL_STATUS_WEB_CONTROL="Please wait while OmniFlow Web Control installation proceeds ...";

var TEXT_SHOWINGMESSEGE='Showing workitems of';
var LABEL_MYSEARCHQUEUE='My Search Queue';
var TEXT_FORPROCESS='for Process';
var TEXT_ATWORKSTEP='at Work-step';
var LABEL_QUERY='Query';
var LABEL_CHECKIN='Check In';

var OPTIONS_NEW="New";
var OPTIONS_INITIATE="Initiate";
var OPTIONS_DELETE="Delete";
var OPTIONS_REASSIGN="Reassign";
var OPTIONS_PROPERTIES="Properties";
var OPTIONS_DONE="Done";
var OPTIONS_REFER="Refer";
var OPTIONS_REVOKE="Revoke";
var OPTIONS_PRIORITY="Priority";
var OPTIONS_REMINDER="Reminder";
var OPTIONS_SAVE="Save";
var NO_DOC_TYPE_ADDABLE="No Document type is addable at the current workstep.";
var SPECIFIED_DOC_TYPE_NOT_ADDABLE="The specified document type is not addable at the current workstep :";
var SPECIFY_WFS_IP="Specify WFS IP.";
var SPECIFY_WFS_PORT="Specify WFS Port.";  // Added for WCL_I_5.0.1_316
var INVALID_PORT_NUMBER="Invalid Port number specified.";

var CHECKOUT_DOC_STATUS_1="The document '";
var CHECKOUT_DOC_STATUS_2="' has been checkedout by user '";
var CHECKOUT_DOC_STATUS_3="'.Do you want to continue?.";
var INSUFFICIENT_PRIVELEGES =  "The user does not have sufficient privileges to perform this action"
var DATE_VALIDATION_MSG_1="From Date cannot be greater than current Date.";
var DATE_VALIDATION_MSG_2="To Date cannot be greater than current Date.";
var DATE_VALIDATION_MSG_3="From Date cannot be greater than To Date.";
var SEL_QUEUE_PROCESS_DATA="Please select a queue or process to fetch its data.";
var SEL_QUEUE_PROCESS="Please select a queue or process to continue.";
var SEL_QUERY_TO_DELETE="Please select a Query to delete.";
var SEL_FILTER_TO_DELETE="Please select a Filter to delete.";
var CONFIRM_QUERY_DELETE="Do you want to delete the selected Query ?";
var CONFIRM_FILTER_DELETE="Do you want to delete the selected Filter ?";
var BATCHSIZE_MAX_VALUE="Batch size cannot be greater than";
var INCOMPATIBLE_VALUE_ASSIGNMENT="Incompatible value assignment so operation cannot be executed."
var INCOMPATIBLE_VALUE_ASSIGNMENT_SCAN_ACTION="Incompatible value assignment so scan action cannot be executed."
var INCOMPATIBLE_VALUE_ASSIGNMENT_SET_TRIGGER="Incompatible value assignment so Set Trigger cannot be executed."
var CONFIRM_WEB_CONTROL_INSTALLATION="Omniflow web control is not installed on your machine. without it, some of the functionalities won't work properly. Do you want to installed it now?";
var EXCEPTION_RAISED_BY_ACTION="Exception raised by action '";
var EXCEPTION_CLEARED_BY_ACTION="Exception cleared by action '";
var LABEL_EXCEPTION_BY="By ";
var LABEL_EXCEPTION_AT="At ";
var LABEL_EXCEPTION_ON="On ";
var LABEL_EXCEPTION_NAME="Name ";
var LABEL_EXCEPTION_ACTION="Action ";
var LABEL_EXCEPTION_COMMENTS="Comments";
var RAISED="Raised";
var CLEARED="Cleared";
var REMINDERS="Reminder(s)";
var PRINT="Print";
var HELP="Help";
var ADD_DOCUMENT_AS="Add Document As:";
 
/*WCL_6.1.2_027 Start*/
var Doc_Order_Id=new Array();
var Doc_Order_Name=new Array();
Doc_Order_Id[0]=9;
Doc_Order_Name[0]="CreatedByAppName";
Doc_Order_Id[1]=11;
Doc_Order_Name[1]="DocumentSize";
Doc_Order_Id[2]=2;
Doc_Order_Name[2]="DocumentName";
Doc_Order_Id[3]=10;
Doc_Order_Name[3]="NoOfPages";
Doc_Order_Id[4]=18;
Doc_Order_Name[4]="OrderNo";
Doc_Order_Id[5]=3;
Doc_Order_Name[5]="Owner";
Doc_Order_Id[6]=5;
Doc_Order_Name[6]="RevisedDateTime";
var Sort_Order_Id=new Array();
var Sort_Order_Name=new Array();
Sort_Order_Id[0]="A";
Sort_Order_Name[0]="AscendingOrder";
Sort_Order_Id[1]="D";
Sort_Order_Name[1]="DescendingOrder";
var ERROR_DATA="Error fetching data!";
var ERROR_SERVER="Application Server or Network is Down. Kindly login again";
var INVALID_REQUEST_ERROR="An invalid request is made.";
var DYNAMIC_CONST_COND_FAILED="Some Condition Failed as Value in Dynamic Constant is not type compatible";
var ALERT_LINK='Please select any workitem(s).';
var DATA_SAVED='Data Saved';
var Label_Data='Data';
var Label_Add='Add';  
var LABEL_HIDE='Hide Details';
var LABEL_SHOW='Show Details';
var LABLE_NO_DATA_FOUND='No data found for this queue';
var OP_WI_PREVWI = 'prev';
var OP_WI_NEXTWI = 'next';
var HIDE_TOOLBAR='Hide Toolbar';
var SHOW_TOOLBAR='Show Toolbar';
var CONFIRM_DOC_STATUS='Some document is checked out .Do you want to continue ?';
var COMMIT_EXCEPTION='Please commit the exception(s) before fetching exception data.'
var CONFIRM_MAX_UPLOAD_LIMIT = 'File exceeded maximum upload limit of ';
var CONFIRM_CONTINUE_UPLOAD = '\nDo you still want to continue ?';
var CONFIRM_CURRENT_FILESIZE = '\nCurrent file size is : ';
var ALERT_MAX_UPLOAD_LIMIT = 'Maximum limit of document upload (MB) is : ';
var OP_WI_CUSTOM_INTERFACES='Custom Interfaces';
var VALIDATION_FAILED = 'Workitem save operaton could not be completed as some validation(s) failed.';
var NGFORM_VALIDATE_CONTROL_FAILED = 'NGForm Mandatory Validation  Failed';
var LABEL_EMBEDDED = 'Embedded';
var LABEL_CLASSIC = 'Classic';
var COMMENT_DELETE_DOCUMENT='Are you sure you want to delete the document?';
var CRITERIA_SEARCH='Search criteria: ';
var LABEL_FALSE='False';
var LABEL_TRUE='True';
var INVALID_BOOLEAN_VALUE='The value specified for the boolean variable is invalid';
var YOUR_PASSWORD_WILL_EXPIRE='Your password will expire in ';
var DAYS_DO_YOU_WANT_TO_CHANGE=' days, Do you want to change it now?'
var ALT_ACTION_CONDITION_FAILED='ConditionFailed';
var ALT_COMPLEX_VARIABLE_NOT_COMPATIBLE='Some of the complex variables are not compatible';
var HOUR_FORAMAT_IS_HH='Hour Format is HH';
var MINUTE_FORAMAT_IS_MM='Minute Format is mm';
var SECOND_FORAMAT_IS_SS='Second Format is ss';
var INVALID_DURATION_FORMAT = "Invalid Duration Format";
var INVALID_YEAR_LENGTH="Year should be numeric and >= 0";
var INVALID_MONTH_LENGTH="Month should be numeric and >= 0 and <= 12";
var INVALID_DAY_LENGTH="Day should be numeric and >= 0 and <= 31";
var INVALID_HOUR_LENGTH="Hour should be numeric and >= 0 and <= 24";
var INVALID_MINUTE_LENGTH="Minute should be numeric and >= 0 and <= 60";
var INVALID_SECOND_LENGTH="Second should be numeric and >= 0 and <= 60";
var DURATION_FORMAT="year:mon:day:hr:min:sec";
var TITLE_RAISE_EXCEPTION = "Raise Exception";
var TITLE_CLEAR_EXCEPTION = "Clear Exception";
var TITLE_MODIFY_EXCEPTION = "Modify Exception";
var TITLE_EXCEPTION_DETAILS = "Exception Details";
var LABEL_DETAILS = "Details";
var ALERT_DOCUMENT_CHECKEDOUT='The operation cannot be performed as one or more document(s) is checked out';
var LABEL_QUEUE_NAME='Queue Name';
var LABEL_SAVE_XLS='xls';
var LABEL_SAVE_PDF='pdf';
var TITLE_RESPONSE_EXCEPTION="Response Exception";
var TITLE_REJECT_EXCEPTION="Reject Exception";
var RESPONDED = "Responded";
var LAST_SUCCESS_LOGIN = 'Time of last successful login : ';
var LAST_FAILED_LOGIN = 'Time of last failed login attempt : ';
var FAILED_LOGIN_COUNT = 'Failed login attempt count : ';
var LABEL_RAISED_EXP_TEMPORARILY='[Temporarily]';
var LABEL_SAVE_WDESK="Save";
var LABEL_OPERATIONS_WDESK="Operations";
var LABEL_INTRODUCE_WDESK="Introduce";
var LABEL_SEARCH_WDESK="Search";
var LABEL_DOCUMENT_WDESK="Document";
var LABEL_DONE_WDESK="Done";
var LABEL_WIPROPERTIES_WDESK="WI Properties";
var LABEL_USERPREFERENCES_WDESK="User Preferences";
var LABEL_LINKEDWI_WDESK="Linked WI";
var LABEL_REASSIGN_WDESK="Reassign";
var LABEL_REFER_WDESK="Refer";
var LABEL_CONVERSATION_WDESK="Conversation";
var LABEL_SEARCH_WORKITEM_WDESK="Workitem";
var LABEL_SEARCH_DOCUMENT_WDESK="Document";
var LABEL_SEARCH_FOLDER_WDESK="Folder";
var LABEL_ADD_DOCUMENT_WDESK="Add Document";
var LABEL_IMPORT_DOCUMENT_WDESK="Import Document";
var LABEL_SCAN_DOCUMENT_WDESK="Scan Document";
var WL_TURNAROUND_DATETIME="Turn Around Date Time";
var OPTIONS_RELEASE="Release";
var OPTIONS_LOCKFORME="LockForMe";
var LABEL_SAVE_TXT='txt'; 
var LABEL_SAVE_CSV='csv'; 
var LABEL_ALERT_CROP_READ_ONLY="This operation can not be performed on read only workitem";
var LABEL_ALERT_MOZILA_FORM_HIDE_DONE="Before Save or Done or Introduce click Data tab and wait until form loads completely";
var LABEL_ALERT_MOZILA_FORM_HIDE_PREV_NEXT="Before going to next or previous  workitem click Data tab and wait until form loads completely";
var INVALID_FILE_TYPE = "The file type you are attempting to upload is not allowed.";
var TITLE_CLASSIC="Click to  view workitem in classic mode";
var TITLE_EMBEDDED="Click to view workitem in embedded mode";
var TITLE_SET_FILTER="Click to Set Filter";
var TITLE_REASSIGN="Click to Reassign workitem";
var TITLE_REFER="Click to refer workitem";
var TITLE_SAVE_XLS="Click to save workitem list as a XLS file";
var TITLE_SAVE_PDF="Click to save workitem list as a PDF file";
var TITLE_SAVE_TXT="Click to save workitem list as a TEXT file";
var TITLE_SAVE_CSV="Click to save workitem list as a CSV file"; 
var TITLE_LOCK_FOR_ME="Click to lock the workitem";
var TITLE_RELEASE="Click to Release the reassigned wokitem";
var TITLE_REVOKE="Click to Revoke  Referred wokitem";
var TITLE_PROPERTIES="Click to view workitem Properties and history";
var TITLE_REMINDER="Click to set Reminder";
var TITLE_PRIORITY="Click to set priority";
var TITLE_DELETE="Click to delete workitem";
var CLICK_TO_VIEW_NO_OF_WRKITEM="Click to view no of workitem in selected queue";
var ALERT_DOCUMENT_ADDED_SUCCESSFULLY="Document added successfully";
var ALERT_DOCUMENT_IMPORTED_SUCCESSFULLY="Document imported successfully";
var LABEL_ALL_ALIAS="All Alias";
var SAVE_TRANSFORMATION_MESSGAE="Transformation Saved";
var NO_AUTHORIZATION_TO_CROP="No authorization to crop this document";
var ALERT_UNSAVED_ANNOTATION="There is unsaved annotation do you want to save it?";
var ALERT_NOT_ALLOWED_FIRST_POSTION='* is not allowed at first position';
var ENTER_NUMERIC_VALUE_ONLY="Please enter numeric value only";
var ENTER_FROM_PAGE_VALUE="Please enter From Page value";
var ENTER_VALID_PAGES_RANGE="Please enter valid Page Range : Start Page should not be greater than Total pages";
var START_PAGE_GREATER_THAN_ZERO="Start Page should be greater than Zero.";
var TO_PAGE_LESS_THAN_TOTAL_PAGES="Please enter valid Page Range : To Page should not be greater than Total pages";
var TO_PAGE_GREATER_THAN_FROM_PAGE="Please enter valid Page Range : To Page should be greater than From Page";
var LABEL_OUT_OF="out of";
var LABEL_DOCUMENTS_PRINTED='document gets printed';
var ALERT_ALLOWED_ONLY_AT_LAST_POSTION = "* is  allowed only at last position";
var SELECT_DOC_TYPE="--Select a Doc Type--";
var CONFIRM_SEARCH_HISTORY ="Search might take several minutes.  Do you want to continue ?";
var MONTH="Month";
var YEAR="Year";
var LABEL_OK='Ok';
var LABEL_CANCEL='Cancel';
var PLEASE_ENTER_A_VALID_YEAR='Please enter a valid year';
var CHOOSE_A_DATE_COLON="Choose a date:";
var WEEKDAYS_SHORT_SUNDAY="Su";
var WEEKDAYS_SHORT_MONDAY="Mo";
var WEEKDAYS_SHORT_TUESDAY="Tu";
var WEEKDAYS_SHORT_WEDNESDAY="We";
var WEEKDAYS_SHORT_THIRSDAY="Th";
var WEEKDAYS_SHORT_FRIDAY="Fr";
var WEEKDAYS_SHORT_SATURDAY="Sa";
var JAN="Jan";
var FEB="Feb";
var MAR="Mar";
var APR="Apr";
var MAY="May";
var JUN="Jun";
var JUL="Jul";
var AUG="Aug";
var SEP="Sep";
var OCT="Oct";
var NOV="Nov";
var DEC="Dec";
var JANUARY="January";
var FEBRUARY="February";
var MARCH="March";
var APRIL="April";
var MAY="May";
var JUNE="June";
var JULY="July";
var AUGUST="August";
var SEPTEMBER="September";
var OCTOBER="October";
var NOVEMBER="November";
var DECEMBER="December";
var LABEL_YEAR_SUFFIX=" ";
var LABEL_MONTH_SUFFIX=" ";
var SEARCH_CRITERIA_CAN_NOT_BLANK="Search Criteria can not be blank.";
var MESSAGE_SESSION_TIMEOUT="Session will be expired in "; 
var LABEL_MINUTE="minute";
var LABEL_SECOND="second";
var ALERT_WAIT_CUSTOM_WORKDESK_LOADED="Please wait custom workdesk window is getting loaded";
var INVALID_FILE_WORD="Invalid Word(s) in file"
var WL_VALID_TILL_FIL="Valid Till";
var WL_INTRODUCED_ON_FIL="Introduced On";
var WL_ENTRY_DATE_FIL="Entry Date Time";
var AND="AND";
var OR="OR";
var ALERT_COMMIT_EXCEPTION_BEFORE_SUBMIT="There is uncommited exception(s) so commit it before submit the workitem";
var CLICK_QUEUE_TO_FETCH_WI="Click any queue to fetch the workitem list";
var DO_YOU_WANT_TO_CLOSE_WORKITEM="Do you want to close the workitem.";
var REMOVE_INVALID_CHARACTERS="Kindly remove invalid characters such as (•)."
var ALERT_PLEASE_ENTER_THE_VALUE="Please enter the value of ";
var LABEL_ALL_PROCESS="All Processes";
var LABEL_SELECT_PROCESS="Select Process";
var TEXT_SHOWING="Showing";
var TEXT_OF="of";