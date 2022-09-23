SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListNSAID]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'M01A%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListNSAID] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListNSAID] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListNSAID] TO [Lege]
GO