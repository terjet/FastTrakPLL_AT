SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListDruidHigh]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDruidLevel @StudyId,4;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListDruidHigh] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListDruidHigh] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListDruidHigh] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListDruidHigh] TO [Vernepleier]
GO