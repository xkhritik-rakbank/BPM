<%-- 
    Document   : timerdiv
    Created on : Jul 2, 2021, 3:59:08 AM
    Author     : Minakshi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    </head>
    <body>        
        <div id="TimerDiv" class="iframeShadow" style="z-index: 50001; display: none; position: absolute;"><table cellpadding="0" cellspacing="0" width="100%">
                <tbody>
                    <tr>
                        <td style="width: 100%;"><table cellpadding="0" cellspacing="0" width="100%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <div class="bluepanelcontent containerShadow" style="width: 382px;height: 158px;">
                                                <div class="containerHeaderRadius themeBackGroundStyle sectionStyle" style="width: 100%;"><table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                        <tbody>
                                                            <tr>
                                                                <td style="width:100%;vertical-align: top;"><table id="bpanel:bp:bluepanel" border="0" cellpadding="0" cellspacing="0" style="padding: 0px; margin: 0px;" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td class="lImgColumn">
                                                                                    <div class="lBlueBg"></div></td>
                                                                                <td class="headerColumn"><label style="white-space: nowrap;">
                                                                                        Session Expiry Alert</label></td>
                                                                                <td class="menuButtonColumn"></td>
                                                                                <td class="rImgColumn">
                                                                                    <div class="rBlueBg"></div></td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>

                                                </div><table border="0" cellpadding="0" cellspacing="2" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td><span style="visibility: hidden;">.</span></td>
                                                        </tr>
                                                        <tr>
                                                            <td><table class="informationmsgdiv" border="0" cellpadding="0" cellspacing="2">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td><table id="bpanel:bp:timerinfodiv" border="0" cellpadding="0" cellspacing="2">
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td><span class="glyphicon glyphicon-info-sign"></span></td>
                                                                                            <td><span class="informatinostyleblue">You will be logged out in</span></td>
                                                                                            <td><span style="visibility: hidden;">.</span></td>
                                                                                            <td>
                                                                                                <span id="crminutes" class="informatinostyleblue"></span></td>
                                                                                            <td><span class="informatinostyleblue">:</span></td>
                                                                                            <td>
                                                                                                <span id="crseconds" class="informatinostyleblue"></span></td>
                                                                                            <td><span style="visibility: hidden;">.</span></td>
                                                                                            <td><span class="informatinostyleblue">(mm:ss)</span></td>
                                                                                        </tr>
                                                                                    </tbody>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td><table id="bpanel:bp:expiryinfodiv" border="0" cellpadding="0" cellspacing="2" style="display: none;">
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td><span class="glyphicon glyphicon-info-sign"></span></td>
                                                                                            <td><span class="informatinostyleblue">Session Expired</span></td>
                                                                                        </tr>
                                                                                    </tbody>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><span style="visibility: hidden;">.</span></td>
                                                        </tr>
                                                        <tr>
                                                            <td><table border="0" cellpadding="0" cellspacing="2" width="100%">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td style="width:100%;text-align: center;">                                        
                                                                                <a href="#" class="control-label labelStyle" onclick="extendWebSession();return false;" style="margin-bottom:0px;cursor:pointer;text-decoration: underline !important;color:#0000ff !important;">Click Here to stay logged in</a></td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>

                                            </div></td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </tbody>
            </table>

        </div>
    </body>
</html>
