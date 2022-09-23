SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListB01AA03]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'B01AA03'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListB01AA03] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListB01AA03] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListB01AA03] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListB01AA03] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListB01AA03] TO [Vernepleier]
GO