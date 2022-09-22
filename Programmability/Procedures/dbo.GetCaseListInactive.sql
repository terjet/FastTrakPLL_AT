SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListInactive]( @StudyId INT ) AS
BEGIN
  SELECT DISTINCT vcl.PersonId,vcl.DOB,vcl.FullName,sg.GroupName,ss.StatusText as InfoText
  FROM ViewCaseListStub vcl
    JOIN StudCase sc ON sc.PersonId=vcl.PersonId and sc.StudyId=@StudyId
    LEFT OUTER JOIN dbo.StudyGroup sg on sg.GroupId=sc.GroupId and sg.StudyId=sc.StudyId
    LEFT OUTER JOIN dbo.StudyStatus ss on ss.StatusId=sc.FinState and ss.StudyId=sc.StudyId
  WHERE (ss.StatusActive=0 ) or (ss.StatusActive IS NULL);
END
GO