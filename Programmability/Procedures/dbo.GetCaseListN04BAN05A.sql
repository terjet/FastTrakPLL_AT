SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListN04BAN05A]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrugCombo @StudyId, 'N05A%', 'N04BA%';
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListN04BAN05A] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN04BAN05A] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN04BAN05A] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN04BAN05A] TO [Vernepleier]
GO