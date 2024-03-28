@REM Copyright (c) 2004 NEWGEN All Rights Reserved.

@REM ************************************************************************************************
@REM Modify these variables to match your environment
	cls
	set JAVA_HOME="C:\Program Files\Java\jdk1.7.0_40"
	set JTS_LIBPATH=lib
	set MYCLASSPATH=bin
	set LIBCLASSPATH=%JTS_LIBPATH%\iforms.jar;%JTS_LIBPATH%\json-simple-1.1.1.jar;%JTS_LIBPATH%\log4j-1.2.14.jar;%JTS_LIBPATH%\sun.misc.base64decoder.jar;%JTS_LIBPATH%\wfdesktop.jar;%JTS_LIBPATH%\itextpdf-5.3.2.jar;%JTS_LIBPATH%\ISPack.jar;%JTS_LIBPATH%\ngejbcallbroker.jar;%JTS_LIBPATH%\jdts.jar;%JTS_LIBPATH%\NIPLJ.jar;%JTS_LIBPATH%\nsms.jar
@REM ************************************************************************************************

@REM ************************************************************************************************
@REM Compile SockectClient
	
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath %LIBCLASSPATH%;%MYCLASSPATH% src\com\newgen\iforms\user\*.java
	pause
@REM ************************************************************************************************


@REM Copyright (c) 2004 NEWGEN All Rights Reserved.

@REM *********************JAR BUILDING***************************************************************************
@REM Modify these variables to match your environment
	cls
	set JAVA_HOME="C:\Program Files\Java\jdk1.7.0_40"
	set MYCLASSPATH=bin
	set JARPATH=..
@REM ************************************************************************************************

 	cd %MYCLASSPATH%

@REM mqsocketserver jar
    %JAVA_HOME%\bin\jar -cvf %JARPATH%\CMP.jar com\newgen\iforms\user\*.class    
	pause
@REM ************************************************************************************************

