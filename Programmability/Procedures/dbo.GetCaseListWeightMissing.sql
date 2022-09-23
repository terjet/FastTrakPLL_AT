SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListWeightMissing]( @StudyId INT ) AS
BEGIN
  -- TODO: Make into single call.
  -- Get list of patients with last weight date
  SELECT vcl.PersonId, MAX(ce.EventTime) AS LastWeightDate
  INTO #weightDate FROM dbo.ViewActiveCaseListStub vcl
    LEFT OUTER JOIN dbo.ClinEvent ce ON ce.PersonId = vcl.PersonId
    LEFT OUTER JOIN dbo.ClinDataPoint cdp ON cdp.EventId = ce.EventId AND cdp.ItemId = 3224
  WHERE vcl.StudyId = @StudyId AND ISNULL(cdp.Quantity,0) > 0
  GROUP BY vcl.PersonId;
  -- Select the list
  SELECT vcl.PersonId, vcl.DOB, vcl.FullName, vcl.GroupName, ISNULL(dbo.LongTime(wd.LastWeightDate), 'Vekt mangler.' ) AS InfoText
    FROM dbo.ViewActiveCaseListStub vcl
    LEFT JOIN #weightDate wd ON wd.PersonId = vcl.PersonId
  WHERE ( vcl.StudyId = @StudyId ) AND ( GETDATE() - wd.LastWeightDate > 30 OR wd.LastWeightDate IS NULL )
  ORDER BY wd.LastWeightDate;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListWeightMissing] TO [FastTrak]
GO