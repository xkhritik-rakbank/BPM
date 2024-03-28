var EIDAWebComponentName = "EIDAWebComponent";
var EIDAWebComponent = null;

function ReadPublicDataEx(sRefresh, sReadPhotography, sReadNonModifiableData, sReadModifiableData, sSignatureValidation,
		sReadV2Fields, sReadSignatureImage, sReadAddress)
{
	if(EIDAWebComponent == null)
	{
		alert("The Webcomponent is not initialized.");
		return;
	}
	var Ret = EIDAWebComponent.ReadPublicDataEx(sRefresh, sReadPhotography, sReadNonModifiableData, sReadModifiableData, sSignatureValidation,
			sReadV2Fields, sReadSignatureImage, sReadAddress);
	return Ret;
}
function Initialize() 
{
	try
	{		
		EIDAWebComponent = document.getElementById(EIDAWebComponentName);
		var Ret = EIDAWebComponent.Initialize();
		return Ret;
	}
	catch(e)
	{
		return "Webcomponent Initialization Failed, Details: "+e;
	}
}
function fetchEID()
{

	if(EIDAWebComponent == null)
	{
		alert("The Webcomponent is not initialized.");
		return;
	}
	return EIDAWebComponent.GetIDNumber();
}
function DisplayPublicDataEx()
{
	
	if(EIDAWebComponent == null)
	{
		alert("The Webcomponent is not initialized.");
		return;
	}
	
	var Ret = ReadPublicDataEx("true", "false", "true", "true", "false", "true", "true", "true");

}
