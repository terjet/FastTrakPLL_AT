SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[GetAllActiveCases]( @StudyId INT ) AS
BEGIN
  SELECT 
    p.PersonId, p.DOB, p.FullName, sg.GroupName, ss.StatusText AS InfoText, 
    p.GenderId, p.NationalId 
  FROM dbo.Person p
  JOIN dbo.StudCase sc ON sc.PersonId = p.PersonId
  JOIN dbo.StudyGroup sg ON sg.StudyId = sc.StudyId AND sg.GroupId = sc.GroupId AND sg.GroupActive = 1
  JOIN dbo.StudyStatus ss ON ss.StudyId = sc.StudyId AND ss.StatusId = sc.FinState AND ss.StatusActive = 1
  JOIN dbo.Study s ON s.StudyId = sc.StudyId 
  WHERE s.StudyId = @StudyId;
END
GO

GRANT EXECUTE ON [report].[GetAllActiveCases] TO [QuickStat]
GO