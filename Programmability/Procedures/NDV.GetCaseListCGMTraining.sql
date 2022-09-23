SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetCaseListCGMTraining]( @StudyId INT )
AS
BEGIN
  SELECT p.PersonId,p.DOB,p.ReverseName AS FullName,sg.GroupName,p.GenderId,p.NationalId,
    'CGM opplæring ' + CONVERT(VARCHAR,MIN(dp.DTVal),104 ) + ' (' + CONVERT(VARCHAR,COUNT(DISTINCT dp.DTVal)) + 'x)' as InfoText
  FROM dbo.ClinDatapoint dp 
  JOIN dbo.ClinEvent ce ON ce.EventId = dp.EventId
  JOIN dbo.StudCase sc ON sc.StudyId=ce.StudyId AND sc.PersonId=ce.PersonId
  JOIN dbo.StudyGroup sg ON sg.StudyId=ce.StudyId AND sg.GroupId = ISNULL(ce.GroupId,sc.GroupId)
  JOIN dbo.Person p ON p.PersonId=ce.PersonId
  JOIN dbo.UserList ul ON ul.CenterId=sg.CenterId AND ul.UserId=USER_ID() 
  WHERE dp.ItemId = 9513 AND dp.DtVal > getdate()-365 AND sg.GroupActive = 1
  GROUP BY p.PersonId,p.DOB,p.ReverseName,p.GenderId,p.NationalId,sg.GroupName
  ORDER BY p.ReverseName 
END
GO

GRANT EXECUTE ON [NDV].[GetCaseListCGMTraining] TO [FastTrak]
GO