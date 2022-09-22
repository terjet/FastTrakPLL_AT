SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListTest] ( @StudyId INT ) AS
BEGIN
  SELECT PersonId,DOB,FullName,GroupName from ViewCaseListStub where StudyId=@StudyId and GroupName like 'Test%'
  ORDER BY FullName
END
GO