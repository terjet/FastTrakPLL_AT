SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListInactiveGroup]( @StudyId INT ) AS
BEGIN
  SELECT vcl.PersonId, vcl.DOB, vcl.FullName, sg.GroupName, ss.StatusText AS InfoText, vcl.StudyId
  FROM dbo.ViewCaseListStub vcl
  JOIN dbo.StudCase sc ON sc.PersonId = vcl.PersonId AND sc.StudyId = vcl.StudyId
  JOIN dbo.StudyGroup sg ON sg.GroupId = sc.GroupId AND sg.StudyId = vcl.StudyId
  JOIN dbo.StudyStatus ss on ss.StatusId = sc.FinState AND ss.StudyId = vcl.StudyId
  WHERE ( vcl.StudyId = @StudyId ) AND ( sg.GroupActive = 0 ); 
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListInactiveGroup] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListInactiveGroup] TO [superuser]
GO