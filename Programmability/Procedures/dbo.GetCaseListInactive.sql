SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListInactive]( @StudyId INT ) AS
BEGIN
  SELECT vcl.PersonId, vcl.DOB, vcl.FullName, sg.GroupName, ss.StatusText AS InfoText
  FROM dbo.ViewCaseListStub vcl
    JOIN dbo.StudCase sc ON sc.PersonId = vcl.PersonId AND sc.StudyId = @StudyId
    JOIN dbo.StudyStatus ss on ss.StatusId = sc.FinState AND ss.StudyId = sc.StudyId
    LEFT OUTER JOIN dbo.StudyGroup sg ON sg.GroupId = sc.GroupId AND sg.StudyId = sc.StudyId
  WHERE ( ss.StatusActive = 0 ) OR ( ss.StatusActive IS NULL );
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListInactive] TO [FastTrak]
GO