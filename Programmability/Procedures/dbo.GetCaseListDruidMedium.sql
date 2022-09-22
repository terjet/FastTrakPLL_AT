SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListDruidMedium]( @StudyId INT ) AS
BEGIN
  EXEC GetCaseListDruidLevel @StudyId,2
END
GO