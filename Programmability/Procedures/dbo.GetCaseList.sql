SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseList]( @StudyId INT ) AS
BEGIN
  SET NOCOUNT ON;
  SELECT vcl.PersonId,vcl.DOB,vcl.FullName,vcl.GroupName,ss.StatusText AS InfoText
  FROM StudCase sc
    JOIN ViewActiveCaseListStub vcl ON sc.PersonId=vcl.PersonId AND vcl.StudyId=sc.StudyId
    LEFT OUTER JOIN dbo.StudyStatus ss ON ss.StatusId=sc.FinState AND ss.StudyId=sc.StudyId
  WHERE sc.StudyId=@StudyId
  ORDER BY vcl.FullName
END
GO