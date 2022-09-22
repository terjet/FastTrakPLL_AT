SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListLastForm]( @StudyId INT, @FormName VARCHAR(32), @IgnoreDays FLOAT = 0 ) AS
BEGIN
  DECLARE @IgnoreAfter DateTime;
  SET @IgnoreAfter = getdate()-@IgnoreDays;
  -- First get all active patients for this study
  SELECT PersonId,DOB, FullName, GroupName INTO #tempAll FROM dbo.ViewActiveCaseListStub WHERE StudyId=@StudyId;
  -- Find everybody with a form
  SELECT v.PersonId,max(ce.EventTime) as LastFormDate
  INTO #tempWithForm
  FROM #tempAll v
  JOIN ClinEvent ce ON ce.PersonId=v.PersonId AND ce.StudyId=@StudyId
  JOIN ClinForm cf ON cf.EventId=ce.EventId
  JOIN MetaForm mf ON mf.FormId=cf.FormId AND mf.FormName=@FormName
  GROUP BY v.PersonId;
  --Select result, removing the forms newer than @IgnoreDays
  SELECT t1.PersonId,t1.DOB,t1.FullName,t1.GroupName,t2.LastFormDate,
    'Utfylt: ' + ISNULL(CONVERT(VARCHAR,t2.LastFormDate,104), 'Aldri') AS InfoText
    FROM #tempAll t1
    LEFT OUTER JOIN #tempWithForm t2 ON t1.PersonId=t2.PersonId
  WHERE ( t2.LastFormDate <=@IgnoreAfter ) OR ( t2.LastFormDate IS NULL )
  ORDER BY t2.LastFormDate
END
GO