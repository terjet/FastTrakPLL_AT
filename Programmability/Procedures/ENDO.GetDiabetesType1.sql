SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetDiabetesType1]( @StudyId INT ) AS 
BEGIN 
  EXEC dbo.GetActiveSingleVar @StudyId, 6314, 1; 
END
GO

GRANT EXECUTE ON [ENDO].[GetDiabetesType1] TO [FastTrak]
GO