SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListNews]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListNewForms @StudyId,1;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListNews] TO [FastTrak]
GO