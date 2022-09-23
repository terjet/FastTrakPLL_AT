SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListOldLab]( @StudyId INT ) AS
BEGIN
  /* Get list of last lab dates */
  SELECT PersonId,Max(LabDate) AS LabDate
  INTO #tempLab FROM LabData GROUP BY PersonId;
  /* Select the list */
  SELECT p.PersonId,p.DOB,p.FullName,p.GroupName,dbo.LongTime(tl.LabDate) AS InfoText
  FROM ViewActiveCaseListStub p
    JOIN #tempLab tl ON tl.PersonId=p.PersonId
  WHERE p.StudyId=@StudyId
  ORDER BY tl.LabDate
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListOldLab] TO [Lege]
GO