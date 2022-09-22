SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListNoBloodTest]( @StudyId INT, @DaysBack FLOAT = 180 ) AS
BEGIN
  -- Get BP for active cases
  SELECT v.PersonId,max(ld.LabDate) AS LabDate INTO #tempTable FROM ViewActiveCaseListStub v
    JOIN LabData ld ON ld.PersonId=v.PersonId
    WHERE ld.NumResult > 0
    GROUP BY v.PersonId;
  -- Join with active cases
  SELECT v.PersonId,v.DOB,v.FullName,v.GroupName, 'Siste blodprøver: ' + ISNULL( dbo.LongTime(t.LabDate), 'Aldri') AS InfoText
    FROM dbo.ViewActiveCaseListStub v
    LEFT OUTER JOIN #tempTable t ON t.PersonId=v.PersonId AND v.StudyId=@StudyId
  WHERE ( LabDate < getdate()-@DaysBack ) OR ( LabDate IS NULL )
  ORDER BY LabDate;
END
GO