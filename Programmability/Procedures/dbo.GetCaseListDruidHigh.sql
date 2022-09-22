SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListDruidHigh]( @StudyId INT ) AS
BEGIN
  EXEC GetCaseListDruidLevel @StudyId,4
END
GO