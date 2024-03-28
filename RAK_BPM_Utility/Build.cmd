@title Build RAK BPM Utility jar
@REM Copyright (c) 2004 NEWGEN All Rights Reserved.

@REM *********************JAR BUILDING***************************************************************************
@REM Modify these variables to match your environment
	cls
	set JAVA_HOME="C:\Program Files\Java\jdk1.8.0_152"
	set MYCLASSPATH=bin
	set JARPATH=..
@REM ************************************************************************************************

 	cd %MYCLASSPATH%

@REM RAK BPM Utility jar
    %JAVA_HOME%\bin\jar -cvfm %JARPATH%\rak_bpm_utility.jar ..\MANIFEST.MF com\newgen\common\*.class	    
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\PC\*.class	    
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\RAOP\CBS\*.class
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\RAOP\Document\*.class
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\RAOP\Status\*.class
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\CMP\Document\*.class
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\CMP\Status\*.class
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\CMP\CBS\*.class
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\CBP\Document\*.class
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\CBP\Status\*.class
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\CBP\CBS\*.class
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\DAC\CBS\*.class
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\DAC\Document\*.class
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\TAO\Integration\*.class
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\NBTL\CBS\*.class
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\NBTL\Document\*.class
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\NBTL\Hold\*.class
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\NBTL\StatusUpdate\*.class
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar com\newgen\main\*.class
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\common\*.java
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\PC\*.java
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\RAOP\CBS\*.java
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\RAOP\Document\*.java
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\RAOP\Status\*.java
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\CMP\CBS\*.java
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\CMP\Document\*.java
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\CMP\Status\*.java
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\CBP\CBS\*.java
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\CBP\Document\*.java
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\CBP\Status\*.java
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\DAC\CBS\*.java
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\DAC\Document\*.java
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\TAO\Integration\*.java
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\NBTL\CBS\*.java
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\NBTL\Document\*.java
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\NBTL\Hold\*.java
	%JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\NBTL\StatusUpdate\*.java
    %JAVA_HOME%\bin\jar -uvf %JARPATH%\rak_bpm_utility.jar ..\src\com\newgen\main\*.java
	pause
@REM ************************************************************************************************


