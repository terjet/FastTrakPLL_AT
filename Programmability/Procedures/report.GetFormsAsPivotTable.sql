SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[GetFormsAsPivotTable] ( @Forms NVARCHAR(MAX), @StudyName NVARCHAR(30), @OrderBy NVARCHAR(MAX) = '')
AS
BEGIN
  -- @Forms should only containt F's, ,'s and digits
  IF ISNUMERIC ( REPLACE(REPLACE(REPLACE(@Forms,'F',''),',',''),' ','')) = 0
  BEGIN
    RAISERROR( 'Invalid parameter-format!',16,1 )
    RETURN
  END

  -- @OrderBy should only contain 'DESC', 'ReverseName', 'GroupName', 'PersonId', and/or commas and 'F<num>'s
  DECLARE @TrimmedOrderBy NVARCHAR(MAX)
  SET @TrimmedOrderBy  = UPPER(@OrderBy)
  SET @TrimmedOrderBy  = REPLACE (@TrimmedOrderBy, 'DESC','')
  SET @TrimmedOrderBy  = REPLACE (@TrimmedOrderBy, 'REVERSENAME','')
  SET @TrimmedOrderBy  = REPLACE (@TrimmedOrderBy, 'GROUPNAME','')
  SET @TrimmedOrderBy  = REPLACE (@TrimmedOrderBy, 'PERSONID','')
  SET @TrimmedOrderBy  = REPLACE (@TrimmedOrderBy, 'F','')
  SET @TrimmedOrderBy  = REPLACE (@TrimmedOrderBy, ',','')
  IF @TrimmedOrderBy <> '' AND ISNUMERIC(@TrimmedOrderBy) = 0
  BEGIN
    RAISERROR( 'Invalid parameter-format!',16,1 )
    RETURN
  END

  DECLARE @stmt NVARCHAR(MAX)
  SET @stmt = 'SELECT PersonId, ReverseName, GroupName, ' + @Forms + ' FROM ' +
              '( SELECT c.PersonId,c.ReverseName,v.GroupName, ' + 
                        '''F''+Cast(a.FormId AS VARCHAR) AS [FormId], ' + 
                        'b.EventTime ' +
                  'FROM dbo.ClinForm a ' + 
                        'JOIN dbo.ClinEvent b ON b.EventId = a.EventId ' + 
                        'JOIN dbo.Person c ON c.PersonId = a.PersonId '+      
                        'JOIN dbo.ViewActiveCaseListStub v ON v.PersonId=a.PersonId ' + 
                        'JOIN dbo.Study s ON s.StudyId=v.StudyId AND s.StudName='''+ @StudyName +''' ' + 
                 'WHERE a.FormId IN ( ' + REPLACE(@Forms,'F','') + ') ' + 
                   'AND a.DeletedBy IS NULL) AS s ' +
              'PIVOT (MAX(EventTime) FOR [FormId] IN ( ' + @Forms + ')) AS b ' +
              CASE WHEN @OrderBy <> '' THEN 'ORDER BY ' + @OrderBy ELSE '' END;
  EXEC sys.sp_executesql  @stmt
END
GO

GRANT EXECUTE ON [report].[GetFormsAsPivotTable] TO [FastTrak]
GO