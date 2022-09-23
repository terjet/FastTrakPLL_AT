SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListBPMissing]( @StudyId INT, @DaysBack FLOAT = 60 ) AS
BEGIN
  -- Get BP for active cases
  SELECT v.PersonId, MAX(ce.EventTime) AS BPDate 
  INTO #tempTable 
  FROM dbo.ViewActiveCaseListStub v
    JOIN dbo.ClinEvent ce ON ce.PersonId = v.PersonId
    JOIN dbo.ClinDataPoint cdp ON cdp.EventId = ce.EventId
    WHERE v.StudyId = @StudyId AND cdp.ItemId IN ( 3556, 3146, 3230 ) AND cdp.Quantity > 0
    GROUP BY v.PersonId;
  -- Join with active cases
  SELECT v.PersonId, v.DOB, v.FullName, v.GroupName, 
    'Siste BT: ' + ISNULL( dbo.LongTime(t.BPDate), 'Aldri') AS InfoText
    FROM dbo.ViewActiveCaseListStub v
    LEFT OUTER JOIN #tempTable t ON t.PersonId = v.PersonId AND v.StudyId = @StudyId
  WHERE ( BPDate < GETDATE() - @DaysBack ) OR ( BPDate IS NULL )
  ORDER BY BPDate;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListBPMissing] TO [FastTrak]
GO