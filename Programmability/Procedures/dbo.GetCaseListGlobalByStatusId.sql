SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListGlobalByStatusId]( @StudyId INT, @StatusId INT ) AS
BEGIN
  SELECT 
    p.PersonId, p.DOB, 
    CASE p.GenderId WHEN 1 THEN 'Mann, Avidentifisert' WHEN 2 THEN 'Kvinne, Avidentifisert' END AS FullName,
    ss.StatusText AS GroupName, p.GenderId, c.CenterName AS InfoText
  FROM dbo.StudCase sc 
  JOIN dbo.StudyStatus ss ON ss.StudyId=sc.StudyId and ss.StatusId = sc.StatusId
  JOIN dbo.StudyGroup sg ON sg.StudyId = sc.StudyId and sg.GroupId = sc.GroupId
  JOIN dbo.Person p ON p.PersonId = sc.PersonId
  JOIN dbo.StudyCenter c ON c.CenterId = sg.CenterId
  WHERE sc.StudyId=@StudyId AND ss.StatusId = @StatusId;
END;
GO

GRANT EXECUTE ON [dbo].[GetCaseListGlobalByStatusId] TO [FastTrak]
GO