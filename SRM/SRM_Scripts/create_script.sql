

-------------------usr_0_srb_formlayout----------------------

CREATE TABLE usr_0_srb_formlayout
	(
	Id                    INT NOT NULL,
	CatIndex              INT,
	SubCatIndex           INT,
	Frameorder            INT,
	FieldOrder            INT,
	Ws_Name               NVARCHAR (100),
	LabelName             NVARCHAR (200),
	FieldType             NVARCHAR (200),
	FieldLength           NVARCHAR (200),
	ColumnName            NVARCHAR (200),
	IsEditable            NVARCHAR (20),
	IsMandatory           VARCHAR (1) NOT NULL,
	Pattern               NVARCHAR (20),
	IsActive              NVARCHAR (1),
	event_function        NVARCHAR (500),
	no_of_col             NVARCHAR (10),
	is_workstep_req       NVARCHAR (10),
	IsRepeatable          NVARCHAR (255),
	advanced_search_field NVARCHAR (255),
	IsAddDelReq           NVARCHAR (1),
	isVisibleInGrid       NVARCHAR (1),
	RadioGroupName        NVARCHAR (50),
	EncryptionRequired    NVARCHAR (20),
	IsToBeBuildInTab      VARCHAR (20),
	TabName               VARCHAR (100)
	)




--------------------USR_0_SRB_CATEGORY----------------------



CREATE TABLE USR_0_SRB_CATEGORY
	(
	ID            INT IDENTITY NOT NULL,
	CategoryIndex INT NOT NULL,
	CategoryName  NVARCHAR (255) NOT NULL,
	ProcessName   NVARCHAR (255),
	ProcessId     INT,
	IsActive      NVARCHAR (1) DEFAULT ('Y'),
	CONSTRAINT PK_638FSP546456_2 PRIMARY KEY (CategoryIndex)
	)
	


----------------------USR_0_SRB_CHANNELMAP-----------------


CREATE TABLE USR_0_SRB_CHANNELMAP
	(
	Channel  NVARCHAR (255) NOT NULL,
	IsActive NVARCHAR (1) DEFAULT ('Y')
	)	
	
---------------------USR_0_SRB_Checklist_Master--------------------


CREATE TABLE USR_0_SRB_Checklist_Master
	(
	id                      INT NOT NULL,
	Account_Type            NVARCHAR (100),
	Checklist_Item_Code     NVARCHAR (3) NOT NULL,
	Checklist_Item_type     NVARCHAR (100),
	Checklist_Item_Desc     NVARCHAR (1000),
	Routing_Unit_1_Branches NVARCHAR (100),
	Routing_Unit_1_WM_SME   NVARCHAR (100),
	Approving_Unit          NVARCHAR (100),
	Display_Order           NVARCHAR (3),
	IsActive                NVARCHAR (1),
	PRIMARY KEY (Checklist_Item_Code)
	)	
	
	
------------------USR_0_SRB_DECISION_MASTER--------------


CREATE TABLE USR_0_SRB_DECISION_MASTER
	(
	WORKSTEP_NAME NVARCHAR (200),
	DECISION      NVARCHAR (200),
	Sno           VARCHAR (50) NOT NULL,
	ID            INT IDENTITY NOT NULL
	)	
	
	
---------------------USR_0_SRB_DOCUMENT----------------------


CREATE TABLE USR_0_SRB_DOCUMENT
	(
	ID          INT IDENTITY NOT NULL,
	SR_ID       NVARCHAR (255) NOT NULL,
	Workstep    NVARCHAR (255),
	DocType     NVARCHAR (255),
	IsActive    NVARCHAR (1) DEFAULT ('Y'),
	IsMandatory NVARCHAR (10),
	PRIMARY KEY (ID)
	)
	

-------------------------USR_0_SRB_DUPLICATEWORKITEMS-------------------
	

	
CREATE TABLE USR_0_SRB_DUPLICATEWORKITEMS
	(
	DUPLICATEWI_NAME     NVARCHAR (200),
	IntroductionDateTime DATETIME,
	intoducedBy          NVARCHAR (100),
	SOLID                NVARCHAR (10),
	WI_NAME              NVARCHAR (200)
	)	
	
	
-------------------------USR_0_SRB_Dynamic_Variable_Master------------


CREATE TABLE USR_0_SRB_Dynamic_Variable_Master
	(
	ID          INT IDENTITY NOT NULL,
	CatIndex    INT NOT NULL,
	SubCatIndex INT NOT NULL,
	FieldName   NVARCHAR (255) NOT NULL,
	FieldValue  NVARCHAR (255) NOT NULL,
	CONSTRAINT pk_srb_dyn_var PRIMARY KEY (ID),
	CONSTRAINT fk_dynamic_varsbr_subcategoryIndex FOREIGN KEY (SubCatIndex, CatIndex) REFERENCES dbo.USR_0_SRB_SUBCATEGORY (SubCategoryIndex, ParentCategoryIndex)
	)
	
	
-------------------------USR_0_SRB_INT_RSMAP--------------



CREATE TABLE USR_0_SRB_INT_RSMAP
	(
	ID           INT NOT NULL,
	CatIndex     INT,
	SubCatIndex  INT,
	FieldName    VARCHAR (100),
	Parameter    VARCHAR (100),
	MW_RespMap   NVARCHAR (1000),
	Req_Category NVARCHAR (255),
	CONSTRAINT pk_int_rsmap_srb PRIMARY KEY (ID),
	CONSTRAINT fk_INT_RSMAP_srbIndex FOREIGN KEY (SubCatIndex, CatIndex) REFERENCES dbo.USR_0_SRB_SUBCATEGORY (SubCategoryIndex, ParentCategoryIndex)
	)	
	
	
------------------USR_0_SRB_SERVICE-------------------


CREATE TABLE USR_0_SRB_SERVICE
	(
	RequestIndex      INT IDENTITY NOT NULL,
	SR_ID             NVARCHAR (255) NOT NULL,
	CatIndex          INT NOT NULL,
	SubCatIndex       INT NOT NULL,
	Transaction_Table NVARCHAR (255) NOT NULL,
	IsActive          NVARCHAR (1) DEFAULT ('Y'),
	CONSTRAINT PK_MG65858758_2 PRIMARY KEY (CatIndex, SubCatIndex),
	CONSTRAINT fk_service_srbIndex FOREIGN KEY (SubCatIndex, CatIndex) REFERENCES dbo.USR_0_SRB_SUBCATEGORY (SubCategoryIndex, ParentCategoryIndex)
	)
	
	
----------------------USR_0_SRB_SUBCATEGORY-----------------------


CREATE TABLE USR_0_SRB_SUBCATEGORY
	(
	SubCategoryIndex                 INT NOT NULL,
	ParentCategoryIndex              INT NOT NULL,
	SubCategoryName                  NVARCHAR (255) NOT NULL,
	TAT                              INT,
	ID                               INT IDENTITY NOT NULL,
	IsActive                         NVARCHAR (1) DEFAULT ('Y'),
	Application_FormCode             NVARCHAR (100),
	DubplicateWorkItemVisible        NVARCHAR (1),
	PrintDispatchRequired            NVARCHAR (1),
	CSMApprovalRequire               NVARCHAR (1),
	CardSettlementProcessingRequired NVARCHAR (1),
	OriginalRequiredatOperations     NVARCHAR (1),
	CONSTRAINT PK_0PLQ65767_3 PRIMARY KEY (SubCategoryIndex, ParentCategoryIndex),
	CONSTRAINT fk_categoryIndexSRB FOREIGN KEY (ParentCategoryIndex) REFERENCES dbo.USR_0_SRB_CATEGORY (CategoryIndex)
	)

	
-------------------------USR_0_SRB_TR_ACT------------------------



CREATE TABLE USR_0_SRB_TR_ACT
	(
	Id            INT IDENTITY NOT NULL,
	WI_NAME       NVARCHAR (200),
	AccountNumber NVARCHAR (20),
	temp_wi_name  VARCHAR (50),
	CONSTRAINT PKK_TR2 PRIMARY KEY (Id)
	)
	
	
------------------------usr_0_srb_wihistory-----------------------


CREATE TABLE dbo.usr_0_srb_wihistory
	(
	catIndex           INT,
	subCatIndex        INT,
	winame             NVARCHAR (255),
	wsname             NVARCHAR (500),
	actual_wsname      NVARCHAR (500),
	decision           NVARCHAR (255),
	actiondatetime     DATETIME,
	remarks            NVARCHAR (500),
	username           NVARCHAR (50),
	id                 INT IDENTITY NOT NULL,
	entrydatetime      DATETIME,
	Satisfaction_Index VARCHAR (50),
	CONSTRAINT pk_srb_history PRIMARY KEY (id)
	)
	
	
------------------------USR_0_SRB_WORKSTEPS------------

CREATE TABLE USR_0_SRB_WORKSTEPS
	(
	ID            INT NOT NULL,
	SR_ID         NVARCHAR (255) NOT NULL,
	Workstep_Name NVARCHAR (255) NOT NULL,
	Logical_Name  NVARCHAR (255),
	IsActive      NVARCHAR (1) DEFAULT ('Y'),
	TAT           NVARCHAR (6) DEFAULT ('60'),
	CONSTRAINT PK_0DUTB354645644_1 PRIMARY KEY (ID)
	)
	
	
--------------------------RB_SRB_EXTTABLE----------------


CREATE TABLE RB_SRB_EXTTABLE
	(
	ITEMINDEX                        NVARCHAR (255),
	ITEMTYPE                         NVARCHAR (2),
	Category                         NVARCHAR (200),
	SubCategory                      NVARCHAR (200),
	WS_NAME                          NVARCHAR (200),
	Decision                         NVARCHAR (100),
	WI_NAME                          NVARCHAR (200),
	Process_Name                     NVARCHAR (100),
	IntoducedBy                      NVARCHAR (100),
	Next_WS                          NVARCHAR (100),
	IsSaved                          NVARCHAR (1),
	Channel                          NVARCHAR (100),
	IntroductionDateTime             DATETIME,
	mw_errorcode                     NVARCHAR (50),
	mw_errordesc                     NVARCHAR (500),
	WSErrorCode                      NVARCHAR (10),
	WSErrorDesc                      NVARCHAR (255),
	Subject                          NVARCHAR (max),
	customeridentifier               NVARCHAR (200),
	Description                      NVARCHAR (max),
	TicketNo                         INT,
	SMSID                            NVARCHAR (100),
	SMSFlag                          NVARCHAR (1),
	IsRejected                       NVARCHAR (10),
	REJ_REMARKS                      NVARCHAR (200),
	CifId                            NVARCHAR (10),
	Name                             NVARCHAR (255),
	MobileNo                         NVARCHAR (20),
	CardNo                           NVARCHAR (20),
	cardNoEncrypted                  NVARCHAR (255),
	encryptedkeyid                   NVARCHAR (200),
	Card_Number                      NVARCHAR (20),
	Current_Workstep                 NVARCHAR (50),
	TATSms                           DATETIME,
	file_created_status              NVARCHAR (10),
	Temp_WI_NAME                     NVARCHAR (255),
	IntegrationStatus                NVARCHAR (50),
	SOLID                            NVARCHAR (10),
	ARMCode                          NVARCHAR (10),
	RAKElite                         NVARCHAR (10),
	SubSegment                       NVARCHAR (10),
	EmiratesID                       NVARCHAR (10),
	AccountNo                        NVARCHAR (10),
	CSMApprovalRequire               NVARCHAR (1),
	printDispatchRequired            NVARCHAR (1),
	CardSettlementProcessingRequired NVARCHAR (1),
	OriginalRequiredatOperations     NVARCHAR (1),
	DeferralWaiverHeld               NVARCHAR (1)
	)
	
	
------------------------USR_0_SRB_TR_SRB001-----------------

CREATE TABLE USR_0_SRB_TR_SRB001
	(
	Id            INT IDENTITY NOT NULL,
	WI_NAME       NVARCHAR (200),
	AccountNumber NVARCHAR (20),
	temp_wi_name  VARCHAR (50),
	CONSTRAINT PKTK_SRB001 PRIMARY KEY (Id)
	)
	
--------------------USR_0_SRB_TR_SRB002------------------
	
	
 CREATE TABLE USR_0_SRB_TR_SRB002
	(
 	Id            INT IDENTITY NOT NULL,
	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB002 PRIMARY KEY (Id)
 	)
	
	
----------------------USR_0_SRB_TR_SRB003-------------

  CREATE TABLE USR_0_SRB_TR_SRB003
	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB003 PRIMARY KEY (Id)
 	)
	
----------------------USR_0_SRB_TR_SRB004-----------------
         
        CREATE TABLE dbo.USR_0_SRB_TR_SRB004
 	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB004 PRIMARY KEY (Id)
 	)
	
	
--------------------------USR_0_SRB_TR_SRB005------------------


 CREATE TABLE USR_0_SRB_TR_SRB005
 	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB005 PRIMARY KEY (Id)
 	)
	
	
---------------------------USR_0_SRB_TR_SRB006-----------------

 CREATE TABLE USR_0_SRB_TR_SRB006
 	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB006 PRIMARY KEY (Id)
	)
	
--------------------------USR_0_SRB_TR_SRB007--------------------


CREATE TABLE USR_0_SRB_TR_SRB007
 	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB007 PRIMARY KEY (Id)
 	)
	
	
----------------------------USR_0_SRB_TR_SRB008--------------------

 CREATE TABLE USR_0_SRB_TR_SRB008
	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB008 PRIMARY KEY (Id)
 	)
	
----------------------------USR_0_SRB_TR_SRB009------------------


           CREATE TABLE dbo.USR_0_SRB_TR_SRB009
 	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB009 PRIMARY KEY (Id)
 	)

----------------------------USR_0_SRB_TR_SRB010------------------

 CREATE TABLE USR_0_SRB_TR_SRB010
 	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB010 PRIMARY KEY (Id)
 	)

----------------------------USR_0_SRB_TR_SRB011------------------


 CREATE TABLE USR_0_SRB_TR_SRB011
 	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB011 PRIMARY KEY (Id)
 	)
	
----------------------------USR_0_SRB_TR_SRB012------------------

 CREATE TABLE USR_0_SRB_TR_SRB012
 	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
	CONSTRAINT PKTK_SRB012 PRIMARY KEY (Id)
	)


----------------------------USR_0_SRB_TR_SRB013------------------


 CREATE TABLE USR_0_SRB_TR_SRB013
 	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB013 PRIMARY KEY (Id)
	)


----------------------------USR_0_SRB_TR_SRB014------------------

 CREATE TABLE USR_0_SRB_TR_SRB014
 	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20), 	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB014 PRIMARY KEY (Id)
 	)


----------------------------USR_0_SRB_TR_SRB015------------------



 CREATE TABLE USR_0_SRB_TR_SRB015
 	(
 	Id            INT IDENTITY NOT NULL
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB015 PRIMARY KEY (Id)
 	)

----------------------------USR_0_SRB_TR_SRB016------------------



 CREATE TABLE USR_0_SRB_TR_SRB016	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB016 PRIMARY KEY (Id)
 	)

----------------------------USR_0_SRB_TR_SRB017------------------



 CREATE TABLE  USR_0_SRB_TR_SRB017
 	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
	temp_wi_name  VARCHAR (50),
	CONSTRAINT PKTK_SRB017 PRIMARY KEY (Id)
 	)


----------------------------USR_0_SRB_TR_SRB018------------------


 CREATE TABLE USR_0_SRB_TR_SRB018
   (
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB018 PRIMARY KEY (Id)
 	)

----------------------------USR_0_SRB_TR_SRB019------------------


 CREATE TABLE USR_0_SRB_TR_SRB019
 	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
	AccountNumber NVARCHAR (20),
	temp_wi_name  VARCHAR (50),
	CONSTRAINT PKTK_SRB019 PRIMARY KEY (Id)
 	)

----------------------------USR_0_SRB_TR_SRB020------------------



 CREATE TABLE USR_0_SRB_TR_SRB020
 	(	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
	CONSTRAINT PKTK_SRB020 PRIMARY KEY (Id)
	)


----------------------------USR_0_SRB_TR_SRB021------------------



 CREATE TABLE USR_0_SRB_TR_SRB021
 	(
 	Id            INT IDENTITY NOT NULL, 	
	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
    temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB021 PRIMARY KEY (Id)
 	)

----------------------------USR_0_SRB_TR_SRB022------------------


 CREATE TABLE  USR_0_SRB_TR_SRB022
 	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB022 PRIMARY KEY (Id)
 	)


----------------------------USR_0_SRB_TR_SRB046------------------


 CREATE TABLE USR_0_SRB_TR_SRB046
 	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB046 PRIMARY KEY (Id)
 	)

----------------------------USR_0_SRB_TR_SRB047------------------


 CREATE TABLE USR_0_SRB_TR_SRB047
 	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB047 PRIMARY KEY (Id)
	)


----------------------------USR_0_SRB_TR_SRB048------------------

 CREATE TABLE USR_0_SRB_TR_SRB048
 	(
	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
	CONSTRAINT PKTK_SRB048 PRIMARY KEY (Id)
	)


----------------------------USR_0_SRB_TR_SRB049------------------



 CREATE TABLE USR_0_SRB_TR_SRB049
 	(
        Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB049 PRIMARY KEY (Id)
	)

----------------------------USR_0_SRB_TR_SRB050------------------


 CREATE TABLE USR_0_SRB_TR_SRB050
 	(
 	Id            INT IDENTITY NOT NULL,
 	WI_NAME       NVARCHAR (200),
 	AccountNumber NVARCHAR (20),
 	temp_wi_name  VARCHAR (50),
 	CONSTRAINT PKTK_SRB050 PRIMARY KEY (Id)
 	)
	
	



	
	
	
	

	
	

	






