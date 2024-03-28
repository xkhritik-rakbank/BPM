/*
		Product         :       OmniFlow
		Application     :       OmniFlow Web Desktop
		Module          :       WorkList Window
		File            :       client.js
		Purpose         :       Contains the functions used for custom coding

		Change History  :

		Problem No        Correction Date	   Comments
		-----------       ----------------      ----------                
                WCL_8.0_047       18/06/2009            Function commitException() is provided in client.js for customization at exception commit and save workitem.
                WCL_8.0_081       12/08/2009            Required Custom function in client.js for validating document type or File extension while importing document.
                WCL_8.0_092       03/09/2009            Short cut keys for  toggling, between Form applet and document applet.
                WCL_8.0_093      03/09/2009             Option for saving Template Preferences.
                WCL_8.0_102      11/09/2009             Need to Disable/Enable the New  link for worklist on the basis of  ProcessName.
                WCL_8.0_103      11/09/2009             Need a pre hook for   custom validations in case of Save/Done/Introduce for Custom Form.
                WCL_8.0_106      11/09/2009             Need only 2 priorities 1)Normal 2)High.
                WCL_8.0_113      24/09/2009             Need  apply a custom validation when user clicks on ok after  selecting  document type for cropping of image applet.
                WCL_8.0_114      29/09/2009             Need to hide links form workdesk on the basis of workstep name (Add Document & Scan Document links to be hide)
                WCL_8.0_119     06/10/2009             User will select multiple workitems from webdesktop, and performs done, on clicking done, a new window to open, where some process fields will be displayed. User will enter data for these fields and perform done all the workitems together
                WCL_8.0_120      06/10/2009             When  user selects multiple workitems from webdesktop, and clicks on done, batch number to be generated  for these workitems and saved in database.
                WCL_8.0_121      06/10/2009             User should be able to open only one workitem per process.
                WCL_8.0_136     16/10/2009              Provision for LockForMe and Release in worklist.
                WCL_8.0_139     22/10/2009               selected workitem count required in  setQueueData function of client.js.
                WCL_8.0_148     16/11/2009               Provision of custom link In search screen and in worklist screen. 
                WCL_8.0_149     16/11/2009               Need provision of conditional enabling or disabling of done button in worklist window and for serach workitem list.
                WCL_8.0_161     16/12/2009               Need to disable Reassign option for users My Queue.
                WCL_8.0_163    24/12/2009                On crop document page a custom combo required and cropped document name  should be combination of selected document type and selected value of custom combo.
                WCL_8.0_176     19/01/2010               Need a Hook during import/check/add a document in OmniFlow Webdesktop.
                WCL_8.0_184     02/02/2010               Short Cut key is required to scroll the outer scroll bar.
                WCL_9.0_002     24/09/2010              Required hook in client.js on sucessful addition of conversation
                WCL_9.0_021     04/01/2011              We have to restrict some document type ext while importing document only for some particular document
                WCL_9.0_026     11/01/2011              Prehook required in client.js on click of custom link.	Requirement
                WCL_9.0_041     04/02/2011              DocAppletHeight and Formheight method missing from client.js which helps in windows size setup
                WCL_9.0_051     15/02/2011              Need a hook in client.js for initiate button
                WCL_9.0_053     23/02/2011              Need a hook in client.js for initiate and Done  Button in case of search workiitem
                WCL_9.0_056      03/03/2011             Need a hook on click of close to save the workitem
                WCL_9.0_059      12/04/2011             Overwrite feature in Generate Response
                Bug 27250        15/06/2011             Required SetDiversion option in webdesktop
                Bug 27507        15/07/2011             Needs a preehook to enable and disable Download flag for document
                                 15/07/2011             Required posthook functionality after raising and clearing the exception.
                                 20/07/2011             to display the custom message after saving the data.Save post
                Bug 27591       20/07/2011              Resolution support for the webdesktop
                Bug 27899       09/08/2011              Needs user and workitem information after click on done from
                Bug 28049       02/09/2011              Get Parent Document name in ngfuser script
                Bug 28404       28/09/2011              Need of a hook in case of reassignment so that user may restrict the user's to whom WI is reassigned 
                Bug 28603       12/10/2011              Resize Custom Form for updation, client configurable
		Bug 29397       25/11/2011              Need to open all workitem in a single window
                Bug 29755       30/12/2011              Need a method in client.js for custom done and introduce 
                Bug 30683       15/03/2012              Hook required on click of Refer button.
                Bug 30886        27/03/2012             Prehook required in client.js on click of LaunchOmnidocs option
            Replicated Bug 28345       13/09/2011             To Configure(Enable And Disable) Prev and Next Link on workitem window from client.js
            Replicated Bug 29526      09/12/2011              Need a hook on click of NO after Done
            Replicated WCL_7.1_272     29/03/2012          Needed a hook on  exception in case of being raised multiple times  without getting cleared
            Bug 30946        30/03/2012              Need a hook to raise exception via custom code rather than click on raise button
            Replicated Bug 27260       05/04/2012  Dinesh Sharma       Not required to display default document while opening workitem
            Bug 31280             20/04/2012            Short cut Key for Exception and TO DO List Window
            Replicated WCL_8.0_303     01/05/2012  Dinesh Sharma    Required to open omnidocs interface for importing document along with DataClass information.
            Bug 31564           07/05/2012               Need a hook to draw zone by custom code by calling Image View Applet's API 
            Bug 32178          24/05/2012 Ritu Raj           Differentiate the document type attached with workitem in omniflow by different color
            Bug 32179          24/05/2012            prehook required to restrict zone draw on the basis of Activity Name and Doc Type			
*       25/06/2012      Bug 32773 - Requirement for keeping the Web and DB session active forcefully through client.js
            Bug 35075          24/09/2012     Sri Prakash     Need configuration to Disable Print Screen Button
            Bug 37595      31/12/2012              No default selected Doc Type in Import Document Window and a Prehook to restrict upload documents
            Bug 37598      01/01/2013      Sri Prakash    need a hook to allow Document download and print if no modify rights on that doc type
	    Bug 38313      12/02/2013             Required password of logged in user in ngfuser and custom jsp
	    Bug 38675      12/03/2013		  Need a hook, deleteDocFromComboList() is provided, Client will pass docIndex of the deleted document, It will remove the deleted document entry in the document combo list in document window.
            Bug 38934      10/04/2013             For RGI, we require workdesk to show document on both LHS & RHS
            Bug 41792      16/08/2013            Need a hook to Save Process Variables in Workitem's Save/Done/Introduce
            Bug 42111      17/09/2013            Upload limit customization for documents in processes
            Bug 42325      08/10/2013            SAP GUI Screen default login.
	    Bug 42467      01/11/2013            If user logged in webdesktop in two different tab of IE user should be logged out from first tab
	    Bug 42617      20/11/2013            Need a hook to allow * in search text based on ProcessName/QueueName and Variable Name in case of optimized search, from both Quick search and Advance Search
	    Bug 42621      21/11/2013            Hide new version if already exist and overwrite existing document options from import document screen for a particular process.
            Bug 42649      25/11/2013            Requirement of a Generate Response Post Hook
		Bug 42678      29/11/2013        Need a hook to display custom document list in import document and scan document window 
            Bug 42759 -     20/12/2013       Dinesh Verma      To apply the Form validation on the click of reassign button (Operations button) on Form.(function mandatoryCommentsBeforeReassign(strprocessname,stractivityName); Added)
            Bug 42798 -     31/12/2013       Sandeep Tonger    Support for Array of Complex through generate response trigger.
            Bug 44068 -     27/03/2014       Need to deploy webdesktop with diffrent context name 
           Bug 44632     21/04/2014          Showing particular DOC type while cropping in omniflow
		   Bug 44696 -   24/04/2014          Required to save cropped image at shared location instead of adding it to DMS
*/
var   raiseComnt = '';
var   raiseExp = '';
var   raiseExpName = '';
function executeActionClick(actionName)
{
    return true;
}


function OpenCustomUrl(url,name)
{//todo security
    url = url.replace('\\','\\\\');    
    var src = url;
    customChildCount++;
    
    url = getActionUrlFromURL(src);
    url = appendUrlSession(url);
    
    var wFeatures = 'resizable=yes,scrollbars=auto,width='+wratio*window1W+',height='+hratio*320+',left='+window1Y/wratio+',top='+window1X/hratio;
    
    var listParam=new Array();
    listParam = getInputParamListFromURL(src);
    customChild[customChildCount] = openNewWindow(url,name,wFeatures, true,"Ext1","Ext2","Ext3","Ext4",listParam);
    
// url = appendUrlSession(url);
//  customChild[customChildCount] = window.open(url,name,'resizable=yes,scrollbars=auto,width='+window1W+',height=320,left='+window1Y+',top='+window1X);        
}


function CustomFormReload(loc)
{
//Just uncomment below line if value to be set is in the form
//	eval(loc).reload();
}

function MoreActionsClick()
{
    return true;
}


function ToolsClick()
{
    return true;
}


function PreferenceClick()
{
    return true;
}


function ReassignClick()
{
    return true;
}


function LinkedWiClick()
{
    return true;
}


function QueryClick()
{
    return true;
}


function SearchDocClick()
{
    return true;
}


function SearchFolderClick()
{
    return true;
}


function AddConversationClick()
{       
        
    return true;
}


function AddDocClick()
{
    return true;
}


function ImportDocClick()
{
    return true;
}


function ScanDocClick()
{
    return true;
}


function SaveClick()
{
    return true;
}


function IntroduceClick()
{
    return true;
}


function RejectClick()
{
    return true;
}


function AcceptClick()
{
    return true;
}


function DoneClick()
{
    return true;
}
function templateData(){

}

function ReferClick()
{
    return true;
}

function RevokeClick()
{
    return true;
}


function PrevClick()
{
    return true;
}


function NextClick()
{
    return true;
}


function ExceptionClick()
{
    return true;
}


function FormViewClick()
{
    return true;
}


function ToDoListClick()
{
    return true;
}


function DocumentClick()
{
    return true;
}


function ClientHelpClick()
{
    return true;
}


function ClientInterfaceClick(url)
{
    return true;
}


function NewClick()
{
    return true;
}


function DeleteWIClick()
{
    return true;
}


function WIPropertiesClick()
{
    return true;
}


function PriorityClick()
{
    return true;
}


function ReminderClick()
{
    return true;
}





function saveFormData()
{
    return true;
}


function NGGeneral(sEventName,sXML)
{
    switch(sEventName)
    {
        case 'ImportDoc' :
            window.parent.parent.frames["wiview_top"].importDoc('S');
            break;
    }
}


function preHook(opType)
{
    return true;
}

function CommentWiClick(){
    return true;
}

function getUploadMaxLength(strprocessname,stractivityName,docType)
{
    /*Bug 42111
         strprocessname :   Name of the Current Process
         stractivityName:   Name of the Current Activity
	 docType	:	DocumentType
    if(strprocessname == 'AttachTest' && stractivityName == 'Work Introduction1' && docType == 'attachmentfree')
    {
        return 5;
    }
    else if(strprocessname == 'AttachTest' && stractivityName == 'Work Introduction1' && docType == 'selfattach')
    {
        alert("In else if ");
        return 15;
    }
    else
    {
        alert("In else");
        return 10;
    }
*/
    return 10;
}

function WFGeneralData(){
       
}
function CustomShow(){
    return true;
}

function setFormFocus(){
 
}

function commitException(){
    return true;
}

function validateUploadDocType(docExt,DocTypeName)// WCL_8.0_081
{ 
    //check doc extension and return false from the function in case of undesired file extension
    return true;
}

function validateUploadDocTypeName(DocTypeName)// WCL_8.0_081
{
    //make custom check for the Document Type Name
    var win_workdesk = window.opener;
    var winList=win_workdesk.windowList;
    var formWindow=getWindowHandler(winList,"formGrid");
    var formFrame;
    if(formWindow){
        if(win_workdesk.wiproperty.formType=="NGFORM"){
            formFrame = formWindow;
        // Write custom code here for ngform
        }
        else if(win_workdesk.wiproperty.formType=="HTMLFORM"){
            formFrame = formWindow;
        //Write custom code here for HTMLForm
        }
        else if(win_workdesk.wiproperty.formType=="CUSTOMFORM"){
            formFrame = formWindow.frames['customform'];
        //Write custom code here for customform
        }
    }

    return true;
}
function ToggleFocus(interfaceFlag)
{       
    if(interfaceFlag == "F")
    {
        if(typeof  strInterface1!='undefined'){
            if(strInterface1=="doc" && strInterface3!=""){
                toggleIntFace("doc",strInterface3);
            }
            else if(strInterface2=="doc" && strInterface4!=""){
                toggleIntFace("doc",strInterface4);
            }
            else if(strInterface3=="doc" && strInterface1!=""){
                toggleIntFace("doc",strInterface1);
            }
            else if(strInterface4=="doc" && strInterface2!=""){
                toggleIntFace("doc",strInterface2);
            }
        }
        if(document.IVApplet)
        {
            try{
                document.IVApplet.setIVFocus();
            }catch(ex){
            }
        }
    }
    else if(interfaceFlag == "D")
    {
        if(typeof  strInterface1!='undefined'){
            if(strInterface1=="form" && strInterface3!=""){
                toggleIntFace("form",strInterface3);
            }
            else if(strInterface2=="form" && strInterface4!=""){
                toggleIntFace("form",strInterface4);
            }
            else if(strInterface3=="form" && strInterface1!=""){
                toggleIntFace("form",strInterface1);
            }
            else if(strInterface4=="form" && strInterface2!=""){
                toggleIntFace("form",strInterface2);
            }
        }
        if(document.wdgc){
            try{
                document.wdgc.NGFocus();
            }catch(ex){
            }
        }
    }else if(interfaceFlag=="W"){
        window.focus();
    }
    if(interfaceFlag == "E")
    {
        window.document.getElementById("wdesk:expList").focus();
    }
}
function getTempletPref(){ 

    var strTemplatePrefXml=''; 

    return strTemplatePrefXml; 
}
function showPriority(){
    var priorityArray =new Array();
    priorityArray[0]=1;  //Low (replace 1 by 0 for removing it from priority combo)
    priorityArray[1]=1;  //Medium
    priorityArray[2]=1;  //High
    priorityArray[3]=1; //Very High
    return priorityArray;
}
function customValidation(opt){
    //In case of Save opt="S" and for Done and Introduce opt="D"   
    return true;
}
function enableWLNew(queueName){    

    return true;
}
function validateCropDocTypeName(DocTypeName){ 
    return true;
}

function hideWdeskMenuitems(){
    var wdeskMenu="";       
    //wdeskMenu=LABEL_SAVE_WDESK+","+LABEL_INTRODUCE_WDESK;
    return wdeskMenu;
}

function hideWdeskSubMenuitems(){
    var wdeskSubMenu="";
    //wdeskSubMenu=LABEL_ADD_DOCUMENT_WDESK+","+LABEL_SCAN_DOCUMENT_WDESK;
    return wdeskSubMenu;
}

function setAttributeData()
{
    closeFrm = 'ok';
    var inputObject,i;
    var inputObjectValue;
    var inputObjectType;
    // var attributeData = '';
    var tmpObj = document.forms["dataForm"];
    // var status = htmlFormOk(window,"dataForm");
    // alert(document.forms["dataForm"].elements.length);
    for ( i=0; i < document.forms["dataForm"].elements.length ; i++)
    {
		
        if (document.forms["dataForm"].elements[i].type == "text" || document.forms["dataForm"].elements[i].type == "select-one" || document.forms["dataForm"].elements[i].type == "textarea")
        {
            inputObject = document.forms["dataForm"].elements[i].name;
            inputObjectValue = document.forms["dataForm"].elements[i].value;
            if(document.forms["dataForm"].elements[i].type == "text")
                inputObjectType = document.forms["dataForm"].elements[i].alt;
            else
                inputObjectType = "";

            //  attributeData +=inputObject.substring((inputObject.indexOf(SYMBOL_3) + 1))+SEPERATOR2+inputObjectValue+SEPERATOR2+inputObjectType+SEPERATOR1;
            attributeData +="<"+inputObject.substring((inputObject.indexOf(":")+1))+">"+inputObjectValue+"</"+inputObject.substring((inputObject.indexOf(":")+1))+">";
        }
    }

    
    window.returnValue = attributeData;
    window.close();
    return false;

}

function WIWindowName(pidWid,processName,activityName){
    // return "customWorkdesk" for opening all workitems in single workdesk
    if(typeof isSingleWorkdesk != 'undefined' && (isSingleWorkdesk == 'Y' || isSingleWorkdesk == 'M'))
        return "customWorkdesk"+dmsSessionId;
    else
        return pidWid;

}
function UnassignClick(){

    return true;
}
function LockForMe(){

    return true;
}
function setQueueData(queueId,selectedWICount)
{ 
    var dataXMl="";
    //TODO set your queue variable or external variable return the dataXML in given format--
    // <VaribaleName>variableValue</VaribaleName>
    return dataXMl;
}

function enableCustomButton(strSelQueueName,strFrom){  
    return true;
}
function CustomButtonClick(selectedWIInfo){  
    //Uncomment refresh() for refreshing workitem list.
    //refresh();
    return true;
}

function enableReassign(strSelQueueName,strFrom,strUserName){   

    /*
         strSelQueueName: selected QueueName (in case of search it is blank) 
         strFrom        : W or F or S
         strUserName    : current logged in username
         W              : Workitem list form any queue
         F              : Workitem list form Filter
         S              : Workitem list form Search
    */

    return   true;
}

function enableRefer(strSelQueueName,strFrom){  
   
    /*
         strSelQueueName: selected QueueName (in case of search it is blank)
         strFrom        : W or F or S
         W              : Workitem list form any queue
         F              : Workitem list form Filter
         S              : Workitem list form Search
    */

    return   true;
}
function enableLockForMe(strSelQueueName,strFrom){  
   
    /*
         strSelQueueName: selected QueueName (in case of search it is blank) 
         strFrom        : W or F or S
         W              : Workitem list form any queue
         F              : Workitem list form Filter
         S              : Workitem list form Search
    */

    return   true;
}
function enableRelease(strSelQueueName,strFrom){  
   
    /*
         strSelQueueName: selected QueueName (in case of search it is blank)
         strFrom        : W or F or S
         W              : Workitem list form any queue
         F              : Workitem list form Filter
         S              : Workitem list form Search
    */

    return   true;
}

function enableDelete(strSelQueueName,strFrom){  
   
    /*
         strSelQueueName: selected QueueName (in case of search it is blank)
         strFrom        : W or F or S
         W              : Workitem list form any queue
         F              : Workitem list form Filter
         S              : Workitem list form Search
    */

    return   true;
}
function customFieldForCropping(){ 
    // return the name of string type array variable for displaying combo for it on crop document page.
    return "";
}

function customDataDefName(strProcessname, strActivityname, strUsername, strDocType){
 
    /*
         strProcessname :   Name of the Current Process
         strActivityname:   Name of the Current Activity    
         strUsername    :   Current Logged in Username
         strDocType     :   Document type to be associated with Dataclass
         return         :   DataDefinition Output XML string.
    */

    return ("");
}
function OkConversationClick() {

}
function customClick(linkName){
    return true;
}
function docAndFormAppletHeight(strprocessname,stractivityName){
    var strDocAndFormHeight="";                     // 180 need to be subtracted from screen height for MenuBar.
    // strDocAndFormHeight="<DocHeight>"+strDocHeight+"</DocHeight><FormHeight>"+strFormHeight+"</FormHeight>";
    return strDocAndFormHeight;
}
function enableDone(strSelQueueName,strFrom,strProcessName,strActivityName){
    return true;
}
function enableInitiate(strSelQueueName,strFrom,strProcessName,strActivityName){
  
    return true;

}
function isSaveOnClose(strProcessName,strActivityName) {
    return true;
}
function setDiversionClick(strUserName){ 
    return true;
}

function raiseExceptionPostHook(exceptionId,exceptionName,ExceptionStatus,ExceptionCommnet,TriggerType){
}
/* this hook is replaced with isEnableDownloadPrint hook
function isEnableDownloadFlag(strprocessname,stractivityName)
{
return true;
}
*/
function savePostHook(){
    return true;
}
function undoExceptionPostHook(exceptionId,exceptionName){

}
function getDoneInformation(){
    /*   user name can be found in variable : username
                 e.g. alert(username);  */

    /* following loop will get processincstanceid activityName and processName of the selected done workitems */
    
    for(var wiNum=0; wiNum<optionStringJSON.JSONArray.length; wiNum++){
        if(document.getElementById("wiTable:"+wiNum+":chk").checked)
        {
    // var activityName = decode_utf8(document.getElementById("wiTable:"+wiNum+":activityName").value);
    // var processName = decode_utf8(document.getElementById("wiTable:"+wiNum+":processName").value);
    // var processInstanceId = decode_utf8(document.getElementById("wiTable:"+wiNum+":processInstanceId").value);
    }
               
    }
}

function getSelectedDocumentDetails()
{
    var dataXMl="";
    objCombo=document.getElementById('wdesk:docCombo');
    var strDocIndex=objCombo.value;
    var strDocName=objCombo[objCombo.selectedIndex].text;
    dataXMl += '<Document><DocumentIndex>'+strDocIndex+ '</DocumentIndex><DocumentName>'+strDocName+'</DocumentName></Document>';
    return dataXMl;

}


function customUserList(strqueueId,strUname){

    /*
         strqueueId       :   Name of the queue selected
         strUname         :   Current Logged in Username
         userPersonalName :   User's personal name (to whom workitems to be reassigned)
         userName         :   User's name (to whom workitems to be reassigned) 
         userIndex        :   User's index (to whom workitems to be reassigned)
         return           :   false

         Usage:
              window.document.getElementById('reassignto').value=userPersonalName;
              window.reassignTo=userName;
              window.reassignToUserId=userIndex;
  */   


		   
    return true;
}

function customFormFeatures()
{
    var height = window1H;
    var width = window1W;
    var wFeatures = 'resizable=no;scrollbars=auto;status=yes;dialogTop='+window1X/hratio+'px;dialogLeft='+window1Y/wratio+'px;dialogWidth='+(wratio*width)+'px;dialogHeight='+(hratio*height)+'px';
    return wFeatures;
}
function customDone(opt, ffvb)
{
    //opt=1 for  done and bring next workitem
    //opt=2 for only done
   /* if(isFormLoaded==false)
        return;
    showProcessing();
    if(!form_cutomValidation("D")){
        hideProcessing();
        return false;
    }
    if(!saveFormdata('formDataTodo','done')){
        hideProcessing();
        return false;
    }*/

    handleDoneWI(opt,ffvb);
}
function customIntroduce(opt, ffvb)
{
    //opt=1 for  done and bring next workitem
    //opt=2 for only done
   /* if(isFormLoaded==false)
        return;
    showProcessing();
    if(!form_cutomValidation("D")){
        hideProcessing();
        return false;
    }
    var batchflag=document.getElementById('wdesk:batchflag').value;
    if(!saveFormdata('formDataTodo','introduce')){
        hideProcessing();
        return false;
    }*/
    handleIntroduceWI(opt,ffvb);

}
function referBtnClick(referTo){
    //alert(referTo);
    return true;
}
function EnablePrevNextOnWdesk(){
    return true;
}
function noClickAfterDone(){
    return true;
}
function isDefaultDocument(processName,activityName){  
    return true;
}
function LaunchODClick(strUserName){
    
    return true;
}
function chkForRaisedExcp(selindx, seltxt)
{
    /*
   var retExp = getInterfaceData('E', 'F');
   for(var i=0;i< retExp.length;i++){
        var exceptionName = retExp[i].name; 
        var seqid = retExp[i].seqid;
      
   }
*/
    return true;
}
function excphook(strRaiseComnt ,strRaiseExp, strRaiseExpName ){
    raiseComnt = strRaiseComnt;
    raiseExp   = strRaiseExp;
    raiseExpName = strRaiseExpName;
    raiseExcep_open('Y');
}

function customRaiseExp(){
    return false;
}

function setCustomExpVar()
{
    document.getElementById("raise:comnt").value = window.parent.raiseComnt;
    document.getElementById("raise:Exp").value = window.parent.raiseExp;
    document.getElementById("raise:expName").value = window.parent.raiseExpName;
}
function UploadDocClick(){
    return true;
}
function customHighlightZone()
{
/*
     drawExtractZone (int zoneType, int x1, int y1, int x2, int y2, int zoneColor, int thickness, boolean isMutable)
    
Where 
	 zoneType Type of Extract Zone - Permissible values are the following defined constants:
     EXT_ZONE_SOLID_RECT = 1 (draws hollow rectangle)
     EXT_ZONE_HIGHLIGHT = 2 (draws highlighted rectangle)
     x1 x-coordinate of top-left corner of the zone
     y1 y-coordinate of top-left corner of the zone
     x2 x-coordinate of bottom-right corner of the zone
     y2 y-coordinate of bottom-right corner of the zone
     zoneColor Color of extract zone (for e.g., dvBlue = 170, dvYellow = 16776960, dvBlack = 0, dvLightGray = 8421504)
     thickness thickness of the extract zone. Permissible values are integer values between 1 and 5 pixels
     isMutable Specifying whether the extract zone is mutable i.e. it can be selected, moved or resized or not.

For example
	 
     if(document.IVApplet)
        document.IVApplet.drawExtractZone(2, 150, 150, 580, 580, 16776960 , 5,true);
		
    */
}


function setColorForDocumentList(pid,wid){
    /*if(pid=="WF-00000000000000006-gen7" && wid=="1"){
        var objCombo = document.getElementById('wdesk:docCombo');
        var arr=["red","blue"];
        for(var index2=0;index2<objCombo.length;index2++){
            
            var docType=objCombo.options[index2].text;
            if ((docType.indexOf("(") != -1))
                docType = docType.substring(0,docType.indexOf("("));
            if(docType =="doc1"){
                objCombo.options[index2].style.color=arr[0];
            }else if(docType =="doc2"){
                objCombo.options[index2].style.color=arr[1];
            }
        }
    }*/
    return true;
}

function ChangeColorOnComboSelect(docindex){
    var objCombo = document.getElementById('wdesk:docCombo');
    try{
        if(objCombo.options[docindex].style.color!=undefined)
            objCombo.style.color = objCombo.options[docindex].style.color;
    }catch(e){
          
    }
}

function isZoningRequired()
{
   
    /*
   var objCombo = document.getElementById('wdesk:docCombo');
   var strDocName=objCombo[objCombo.selectedIndex].text;

   activityName : Activity Name
   strDocName   : selected doc name (contains doc type)
   return : false for the Doc types for which no zoning is required
*/
    return true;

}

function StartSessionActiveTimer()
{
    var interval = 30;   //interval in seconds

    StartCheckIsAdminTimer(interval);
}

function StopSessionActiveTimer()
{
    StopCheckIsAdminTimer();
}
function isDisablePrintScreen(strProcessname, strActivityname)
{
    // return true to disable print screen
    return false;
}
function importDocumentPrehook(docTypeName)
{
    /* Sample custom code to retrieve Document types added in import Document Window combo list as well in workitem window's added documents and
    * Will not upload the documents if this Hook returns false
    *
   var objCombo = window.opener.document.getElementById('wdesk:docCombo');
    if(typeof objCombo != 'undefined')
      {
        for(var index2=0;index2<objCombo.length;index2++){

            var importedDocType=objCombo.options[index2].text;
            if(importedDocType.indexOf(docTypeName)== 0)
             {
                alert("Document Already Added");
                return false;
             }

        }
      }
   */
    return true;
}
function isEnableDownloadPrint(strProcessname, strActivityname, strUsername)
{
    // If returned true will allow print and download option even to thos doc types which have no modified rights
    // By default do not display toolbar by making entry in ShowDefaulToolbarFlag=N
    return false;
}
function getUserAuth(uid)
{
   var xhReq;
   var userAuth;
    myBrowser = navigator.appName;
    if (window.XMLHttpRequest){
         xhReq = new XMLHttpRequest();
    }
    else if (window.ActiveXObject){
        xhReq = new ActiveXObject("Microsoft.XMLHTTP");
    }
    var url = sContextPath+"/general/getUserAuth.jsp?WD_UID="+uid;
    xhReq.open("POST", url, false);
    xhReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhReq.send(null);
    if (xhReq.status == 200 && xhReq.readyState == 4) {
      userAuth = xhReq.responseText;
    }
    return userAuth;
}
function deleteDocFromComboList(docIndex)
{
    var objCombo = window.document.getElementById('wdesk:docCombo');
    var isFound= false;
     for(var i=0;i<objCombo.options.length;i++)
       {
        if(objCombo.options[i].value == docIndex)
         {
         objCombo.options[i]=null;
         isFound = true;
         break;
         }
       }
       if(isFound == false) alert("No Matching Document");
}

 function workitemOnload(){
      /*var pid=document.getElementById('wdesk:pid');
      var wid=document.getElementById('wdesk:wid');
      var requestString="/webdesktop/faces/workitem/view/document.jsp?wdesk:pid="+pid.value+"&wdesk:wid="+wid.value+"&WD_UID="+wd_uid+"&IsDefaultDoc=Y&IsLogo=N";
      document.getElementById("DocFrame").src=requestString;*/
}
function isAnnotationToolbar(strProcessname,strActivityname )
{
   // if(strProcessname == 'AParentForm' && strActivityname == 'Standard Workdesk1')
   //     return false;
   // else
        return true;
}
function getExtParam(processName, activityName)
{
  var retXML =  "";
   /*
     This function will return the  process variables and these values to be saved in workitem while Save / Done / Introduce operation.
   */
 // retXML =  "<Attributes><Attribute><Name>qname</Name><Value>dssD</Value></Attribute><Attribute><Name>qage</Name><Value>65</Value></Attribute></Attributes>";
  return retXML;
}
function isDefaultSAPLogin(processName,activityName){
    
    return false;
}
function isCustomValidVarValue( varName, queueName, processName, from)
{ 
/* from = quicksearch or advancesearch
   varName = name of the variable / alias
   Usage:
              if( varName == <VARIABLE-NAME> && queueName = <SELECTED QUEUE NAME>
              return true;
              Note: returning true will not check / validate for * in entered variable value
 */
return false;
}
function isNewVersionDoc(processName, activityName){ 
    
    return true;
}
function isOverWriteDoc(processName, activityName){
    
     return true;
}
function isImageDownloadStart()
{

}
function postHookGenerateResponse(docIndex, docName)
{
 /*
         docIndex: Document Index of the added Document
		 docName: Document Type of the added Document
 */

}
function getdocTypeListExt(docListObj)
{
var docTypeList = new Array();
var count = -1;

// How to Capture Existing Doc List
/*
    var tmpDocTypeList = docListObj;
    for(i=0 ; i<tmpDocTypeList.length; i++)
    {
     alert("Doc Type = "+tmpDocTypeList.options[i].value);
    }
*/

// Return custom Doc List Array as below , It must be from existing above
 /*
   docTypeList[++count] = "tabc";
   docTypeList[++count] = "txyz";

*/
return docTypeList;
}
function yesBringNextWI(strprocessname,stractivityName)
{
/* strprocessname : Process Name
 * stractivityName : Activity Name
 * return false will not open Bring Next Workitem in dialog box
 * will work only when there is entry YesBringNextWI=N in webdesktop.ini
*/
 return true;
}
function disableConfirmDone(strprocessname,stractivityName)
{
/* strprocessname : Process Name
 * stractivityName : Activity Name
 * return false will  open confirm done window
 * will work only when there is entry ConfirmDone=N in webdesktop.ini
*/
 return true;
}

function reassignPreHook(strprocessname,stractivityName)
{
/*  if(document.wdgc != undefined)
    {
    if( document.wdgc.getNGValue("formcontrolname") == "" ) {   
    alert(ENTER_YOUR_MSG_HERE);
    return false;   
    }
    else
    return true;
    }    
*/
    
/*
 *strprocessname : Process Name
 *stractivityName : Activity Name
 *formcontrolname : name of form control on which you want apply validation
 *return true:will open reassign window
 *return false :will not open reassign window
*/
    return true;
}
function postDocumentAddHook(docIndex,docName,volumeId)
{
    return true;
}

function isDebug(strprocessname,stractivityName)
{
/*    if(strprocessname=='TestGen' && stractivityName=='Work Introduction1')
        {
            return true;
        }
*/
    return false;
}

function isZoningOnSepWin(strprocessname,stractivityName){
    return false;
} 

function cropDocTypeList(strprocessname,stractivityName,strPageNo,docName)
{
    /*  strprocessname : Process Name
        stractivityName : Activity Name
     *  strPageNo       : Page No from which image is cropped
     *  docName         : Document Type & Name from which image is cropped
     *  
     *  return the doc types as Comma separated e.g.- "doc1,doc2"
     *  Doc types returned are CASE SENSITIVE. 
     */
    return  "";
}

function croppedByField(strprocessname,stractivityName){  
    // return the name of variable 
    return "";
}