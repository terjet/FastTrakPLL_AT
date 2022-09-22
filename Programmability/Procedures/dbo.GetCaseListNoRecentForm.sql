SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListNoRecentForm]( @StudyId INT, @IgnoreDays FLOAT = 365 ) AS
BEGIN
  DECLARE @IgnoreAfter DateTime;
  SET @IgnoreAfter = getdate() - @IgnoreDays;
  -- Find everybody with a form
  SELECT v.PersonId,max(ce.EventTime) AS LastEvent
  INTO #tempWithForm
    FROM ViewActiveCaseListStub v
    JOIN ClinEvent ce ON ce.PersonId=v.PersonId
    JOIN ClinForm cf ON cf.EventId=ce.EventId AND cf.DeletedAt IS NULL
  GROUP BY v.PersonId;
  --  Select result, removing the forms newer than @IgnoreDays
  SELECT v.PersonId,v.DOB,v.FullName,v.GroupName,t2.LastEvent,
  'Siste skjema: ' + ISNULL(CONVERT(VARCHAR,t2.LastEvent,104), 'Aldri') AS InfoText
  FROM ViewActiveCaseListStub v
  LEFT OUTER JOIN #tempWithForm t2 ON v.PersonId=t2.PersonId
  WHERE (t2.LastEvent < @IgnoreAfter ) OR ( t2.LastEvent IS NULL )
  ORDER BY t2.LastEvent
END
GO