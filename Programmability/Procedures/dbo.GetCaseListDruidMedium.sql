SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListDruidMedium]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDruidLevel @StudyId, 2;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListDruidMedium] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListDruidMedium] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListDruidMedium] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListDruidMedium] TO [Vernepleier]
GO