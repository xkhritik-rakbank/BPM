
 
-------------------------------SRB_TXN_AUDIT_LOG_GEN------------------------
 
 
ALTER PROCEDURE [dbo].[SRB_TXN_AUDIT_LOG_GEN]
(
                @cabinetName varchar(50),
                @winame varchar(50),
                @tempwiname varchar(50),
                @activityname varchar(50),
                @username varchar(50),
                @category varchar(50),
                @subcategory varchar(100),
                @fieldnames varchar(MAX),
                @fieldvalues varchar(MAX)
)
AS
SET NOCOUNT ON 
Begin

                declare @processname nvarchar(20)
                declare @processdefid nvarchar(5)
                declare @activityId nvarchar(5)
                declare @userid nvarchar(5)
                declare @message nvarchar(max)
                declare @query nvarchar(max)
               
                declare @fieldname nvarchar(100)
                declare @fieldValue nvarchar(max)
                declare @txntable nvarchar(100)
                declare @catindex nvarchar(50)
                declare @subcatindex nvarchar(50)
                declare @mod_fields nvarchar(max)
                declare @insertrecord int
                declare @insertrecord2 int
                declare @temp varchar(100)
                CREATE TABLE #TMP(Row_Count int)
                
				SET NUMERIC_ROUNDABORT OFF 
				SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON

             
              --SET @fieldnames=RIGHT(@fieldnames, LEN(@fieldnames)-1)
             
				SET @fieldnames='AccountNumber~WI_NAME'
                set @processname='SRB'
                PRINT @processname
                select @processdefid=processdefid from processdeftable where processname=@processname
                PRINT @processdefid
                select @userid=userindex from pdbuser where username=@username
                PRINT @userid
                select @activityId=activityId from activitytable where processdefid=@processdefid and activityname=@activityname
                
                --Fetch Category  ID
                select @catindex=categoryindex from usr_0_srb_category where CategoryName=@category

                --Fetch SubCategory ID
                select @subcatindex=subcategoryindex from usr_0_srb_subcategory where ParentCategoryIndex=@catindex and subcategoryname=@subcategory
                
                --Fetch Txn Table
                select @txntable=transaction_table from USR_0_SRB_SERVICE where catindex=@catindex and subcatindex=@subcatindex
                
                set @query='insert into #TMP select count(*) from '+@txntable +' where wi_name='''+@winame+''''    
                print(@query)
                exec(@query)

                select @insertrecord=Row_Count  from #TMP
                
                -- *********
                --set @query='insert into #TMP select count(*) from '+@txntable +' where temp_wi_name='''+@tempwiname+''''                
                --print(@query)
                --exec(@query)

                select @insertrecord2=Row_Count  from #TMP
                
                PRINT(@insertrecord)
                PRINT(@insertrecord2)
                if @insertrecord=0 and @insertrecord2=0
                BEGIN
                PRINT 'inside if'
                                set @query='insert into '+@txntable+'('+@fieldnames +') values ('+@fieldvalues+')'
								
                                set @query=REPLACE(@query,'~',',')
                                print(@query)
                                exec(@query)
                                select 'Inserted Successfully'
                                declare @getfieldvalue cursor
                                set @getfieldvalue = cursor for select * from fnSplitString_fldVals(@fieldnames,@fieldvalues,'~')   
                                open @getfieldvalue
                                fetch next from @getfieldvalue into @fieldname,            @fieldValue                                                       
                                while @@FETCH_STATUS=0
 begin
                                
                                                set @message='<Name>'+@fieldname+'</Name><Value>'''+@fieldValue+'''</Value>' 
                                                set @query='insert into currentroutelogtable(ProcessDefId,ActivityId,Processinstanceid,WorkitemId,Userid,actionid,actiondatetime,associatedFieldId,ActivityName,UserName,AssociatedFieldName)' 
                                                set @query=@query+' values('+@processdefid+','+@activityId+','''+@winame+''',1,'+@userid+',16,getdate(),0,'''+@activityname+''','''+@username+''','''+@message+''')'
                                                --print (@query)
                                                exec (@query)
                                                fetch next from @getfieldvalue into       @fieldname,@fieldValue 
                                
                                end
                                
                                close @getfieldvalue
                                deallocate @getfieldvalue 
                                
                end
                else
                begin
				
				   set @query='delete from '+@txntable+' where  WI_NAME='''+@winame+''''
				    exec(@query)
					
                     set @query='insert into '+@txntable+'('+@fieldnames +') values ('+@fieldvalues+')'
								
                                set @query=REPLACE(@query,'~',',')
                                print(@query)
                                exec(@query)
                                select 'updated Successfully'         
end
end
--exec [SRM_TXN_AUDIT_LOG_GEN] 'rakcabinet_first','SRM2-0000001358-Process','PBO','aishwarya','Cards','Cash Back Redemption',
--'Account_Category~Disputed_Transaction~CCI_CT','''Primary''~''N''~''Debit'''
GO


--------------------------SRB_WI_HISTORY_GEN---------------------------



ALTER PROCEDURE [dbo].[SRB_WI_HISTORY_GEN]
(
	@winame varchar(50),
	@fieldnames varchar(MAX),
	@fieldvalues varchar(MAX)
)
AS
SET NOCOUNT ON 
Begin
	
	declare @insertrecord int
	declare @query nvarchar(max)

	select @insertrecord=count(*) from usr_0_srB_wihistory where winame=@winame
	print (@insertrecord)
	if @insertrecord=0
	begin
		set @query='insert into usr_0_srB_wihistory( '+@fieldnames+') values ('+@fieldvalues+')'
		set @query=REPLACE(@query,'~',',')
		--print(@query)
		exec (@query)
		select 'Inserted Successfully'
	end
	else
	begin
		declare @fieldname varchar(100)
		declare @fieldValue varchar(MAX)
		declare @whereclause varchar(max) 
		set @query='update usr_0_srB_wihistory set '
		set @whereclause=''
		
		declare @getfieldvalue cursor
		
		set @getfieldvalue = cursor for select * from fnSplitString_fldVals(@fieldnames,@fieldvalues,'~')   
		
		open @getfieldvalue
		fetch next from @getfieldvalue into @fieldname,	@fieldValue 	
		
		while @@FETCH_STATUS=0
		begin
			if @fieldname='catindex' or @fieldname='subcatindex' or @fieldname='winame'  or @fieldname='wsname' 
			begin
				if @whereclause =''
				begin
					set @whereclause=@whereclause+' '+@fieldname+'='+@fieldValue
				end
				else
				begin
					set @whereclause=@whereclause+' and '+@fieldname+'='+@fieldValue
				end	
			end
			else
			begin
				if @query ='update usr_0_srB_wihistory set '
				begin
					set @query=@query+' '+@fieldname+'='+@fieldValue
				end
				else
				begin
					set @query=@query+', '+@fieldname+'='+@fieldValue
				end					
			end
			fetch next from @getfieldvalue into	@fieldname,@fieldValue 
		
		end
		
		close @getfieldvalue
		deallocate @getfieldvalue 
		
		if @query !='update usr_0_srB_wihistory set ' and @whereclause !=''
		begin
			set @query=@query+' where '+@whereclause
			--print(@query)
			exec(@query)
			select 'Updated Successfully'
		end
	end
	
end
GO

IF @userName <> 'All'
SET @Query = @Query + ' a.introducedby=''' + @userName + ''' and '

IF @userName = 'All'
SET @Query = @Query + ' a.introducedby in (select RTRIM(a.UserName) from pdbuser a, pdbgroupmember b with (nolock) where b.GroupIndex in (select GroupIndex from pdbgroup with(nolock) where GroupName = ''CardAgents'') and a.UserIndex=b.UserIndex) and '

If @BranchID <> ''
SET @Query = @Query + ' b.USER_BRANCH = '''+@BranchID+''' and '

SET @Query = @Query + ' a.processinstanceid=b.WI_NAME and '

SET @Query = @Query + ' a.introductiondatetime between ''' + @FROMDATE + ''' and ''' + @TODATE + ''' and'

SET @Query = @Query + ' a.processname = '''+@Reqtype1+''' '

SET @Query = @Query + ' group by a.processname, a.introducedby '

print @Query
EXEC (@Query)
End

if @RequestType = 'All' OR @RequestType = 'CSR_MR'
Begin
Set @Reqtype1='CSR_MR'

SET @Query = 'insert INTO #TMP(ProcessName,Count_p,userName) select distinct a.processname, count(*) as count, a.introducedby from queueview a, RB_CSR_MISC_EXTTABLE b where '

IF @userName <> 'All'
SET @Query = @Query + ' a.introducedby=''' + @userName + ''' and '

IF @userName = 'All'
SET @Query = @Query + ' a.introducedby in (select RTRIM(a.UserName) from pdbuser a, pdbgroupmember b with (nolock) where b.GroupIndex in (select GroupIndex from pdbgroup with(nolock) where GroupName = ''CardAgents'') and a.UserIndex=b.UserIndex) and '

If @BranchID <> ''
SET @Query = @Query + ' b.USER_BRANCH = '''+@BranchID+''' and '

SET @Query = @Query + ' a.processinstanceid=b.WI_NAME and '

SET @Query = @Query + ' a.introductiondatetime between ''' + @FROMDATE + ''' and ''' + @TODATE + ''' and'

SET @Query = @Query + ' a.processname = '''+@Reqtype1+''' '

SET @Query = @Query + ' group by a.processname, a.introducedby '

print @Query
EXEC (@Query)
End

if @RequestType = 'All' OR @RequestType = 'CSR_RR'
Begin
Set @Reqtype1='CSR_RR'

SET @Query = 'insert INTO #TMP(ProcessName,Count_p,userName) select distinct a.processname, count(*) as count, a.introducedby from queueview a, RB_CSR_RR_EXTTABLE b where '

IF @userName <> 'All'
SET @Query = @Query + ' a.introducedby=''' + @userName + ''' and '

IF @userName = 'All'
SET @Query = @Query + ' a.introducedby in (select RTRIM(a.UserName) from pdbuser a, pdbgroupmember b with (nolock) where b.GroupIndex in (select GroupIndex from pdbgroup with(nolock) where GroupName = ''CardAgents'') and a.UserIndex=b.UserIndex) and '

If @BranchID <> ''
SET @Query = @Query + ' b.USER_BRANCH = '''+@BranchID+''' and '

SET @Query = @Query + ' a.processinstanceid=b.WI_NAME and '

SET @Query = @Query + ' a.introductiondatetime between ''' + @FROMDATE + ''' and ''' + @TODATE + ''' and'

SET @Query = @Query + ' a.processname = '''+@Reqtype1+''' '

SET @Query = @Query + ' group by a.processname, a.introducedby '

print @Query
EXEC (@Query)
End

if @RequestType = 'All' OR @RequestType = 'CSR_OCC'
Begin
Set @Reqtype1='CSR_OCC'

SET @Query = 'insert INTO #TMP(ProcessName,Count_p,userName) select distinct a.processname, count(*) as count, a.introducedby from queueview a, RB_CSR_OCC_EXTTABLE b where '

IF @userName <> 'All'
SET @Query = @Query + ' a.introducedby=''' + @userName + ''' and '

IF @userName = 'All'
SET @Query = @Query + ' a.introducedby in (select RTRIM(a.UserName) from pdbuser a, pdbgroupmember b with (nolock) where b.GroupIndex in (select GroupIndex from pdbgroup with(nolock) where GroupName = ''CardAgents'') and a.UserIndex=b.UserIndex) and '

If @BranchID <> ''
SET @Query = @Query + ' b.USER_BRANCH = '''+@BranchID+''' and '

SET @Query = @Query + ' a.processinstanceid=b.WI_NAME and '

SET @Query = @Query + ' a.introductiondatetime between ''' + @FROMDATE + ''' and ''' + @TODATE + ''' and'

SET @Query = @Query + ' a.processname = '''+@Reqtype1+''' '

SET @Query = @Query + ' group by a.processname, a.introducedby '

print @Query
EXEC (@Query)
End

select * from #TMP order by userName

--exec SRM_AGENT_REPORT 'All','2007 -10-29','2008 -12-26','All',''

--exec SRM_AGENT_REPORT 'All','2008-09-02','2008-12-26','All',''
GO
