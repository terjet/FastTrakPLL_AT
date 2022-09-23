SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListGroupId]( @StudyId INT, @GroupId INT ) AS
BEGIN
  SELECT *, StatusText AS InfoText 
  FROM dbo.ViewCaseListStub WHERE StudyId = @StudyId AND GroupId = @GroupId;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListGroupId] TO [FastTrak]
GO