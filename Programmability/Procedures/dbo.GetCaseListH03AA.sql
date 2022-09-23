SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListH03AA]( @StudyId INT ) AS
BEGIN 
  EXEC dbo.GetCaseListDrug @StudyId,'H03AA%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListH03AA] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListH03AA] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListH03AA] TO [Lege]
GO