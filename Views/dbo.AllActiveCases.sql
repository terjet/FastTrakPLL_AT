SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[AllActiveCases]  
AS
SELECT p.PersonId,sc.StudyId,c.CenterId FROM dbo.Person p
  JOIN dbo.StudCase sc ON sc.PersonId=p.PersonId
  JOIN dbo.StudyGroup sg ON sg.GroupId=sc.GroupId AND sg.StudyId=sc.StudyId and sg.GroupActive=1
  JOIN dbo.StudyStatus ss ON ss.StatusId=sc.FinState AND ss.StudyId=sc.StudyId AND ss.StatusActive=1
  JOIN dbo.StudyCenter c ON c.CenterId=sg.CenterId
GO