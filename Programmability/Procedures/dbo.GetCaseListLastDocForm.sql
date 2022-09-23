SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListLastDocForm]( @StudyId INT, @IgnoreDays FLOAT = 90 ) AS
BEGIN
  DECLARE @IgnoreAfter DateTime;
  SET @IgnoreAfter = getdate() - @IgnoreDays;
  -- Find everybody with a form
  SELECT v.PersonId,max(ce.EventTime) AS LastEvent
  INTO #tempWithForm
    FROM ViewActiveCaseListStub v
    JOIN ClinEvent ce ON ce.PersonId=v.PersonId
    JOIN ClinForm cf ON cf.EventId=ce.EventId
    JOIN UserList ul ON ul.UserId=cf.CreatedBy
    JOIN MetaProfession mp ON mp.ProfId=ul.ProfId
  WHERE mp.ProfType='LE'
  GROUP BY v.PersonId;
  --  Select result, removing the forms newer than @IgnoreDays
  SELECT v.PersonId,v.DOB,v.FullName,v.GroupName,t2.LastEvent,
  'Legetilsyn: ' + ISNULL(CONVERT(VARCHAR,t2.LastEvent,104), 'Aldri') AS InfoText
  FROM ViewActiveCaseListStub v
  LEFT OUTER JOIN #tempWithForm t2 ON v.PersonId=t2.PersonId
  WHERE (t2.LastEvent < @IgnoreAfter ) OR ( t2.LastEvent IS NULL )
  ORDER BY t2.LastEvent
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListLastDocForm] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListLastDocForm] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListLastDocForm] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListLastDocForm] TO [Vernepleier]
GO