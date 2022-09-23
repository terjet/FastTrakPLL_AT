SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListNewsMonth]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListNewForms @StudyId,30;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListNewsMonth] TO [Administrator]
GO