SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListBPMissing]( @StudyId INT, @DaysBack FLOAT = 60 ) AS
BEGIN
  -- Get BP for active cases
  SELECT v.PersonId,max(ce.EventTime) AS BPDate INTO #tempTable FROM ViewActiveCaseListStub v
    JOIN ClinEvent ce ON ce.PersonId=v.PersonId AND v.StudyId=@StudyId
    JOIN ClinObservation co ON co.EventId=ce.EventId
    WHERE co.VarName IN ( 'SBP_UNSPEC','SBP') AND co.Quantity > 0
    GROUP BY v.PersonId;
  -- Join with active cases
  SELECT v.PersonId,v.DOB,v.FullName,v.GroupName, 'Siste BT: ' + ISNULL( dbo.LOngTime(t.BPDate), 'Aldri') AS InfoText
    FROM dbo.ViewActiveCaseListStub v
    LEFT OUTER JOIN #tempTable t ON t.PersonId=v.PersonId AND v.StudyId=@StudyId
  WHERE ( BPDate < getdate()-@DaysBack ) OR ( BPDate IS NULL )
  ORDER BY BPDate;
END
GO