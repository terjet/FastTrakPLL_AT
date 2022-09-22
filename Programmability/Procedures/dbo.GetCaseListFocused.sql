SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListFocused]( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId,v.DOB,v.FullName,v.GroupName,p.CAVE as InfoText
  FROM ViewActiveCaseListStub v
    JOIN dbo.StudCase sc ON sc.PersonId=v.PersonId AND sc.StudyId=v.StudyId
    JOIN dbo.Person p ON  p.PersonId=v.PersonId
  WHERE v.StudyId=@StudyId AND sc.FinState = 2;
END
GO