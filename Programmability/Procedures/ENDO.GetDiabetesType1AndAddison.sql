SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetDiabetesType1AndAddison]( @StudyId INT ) AS 
BEGIN 
  EXEC dbo.GetActiveDoubleVar @StudyId, 6314, 1, 6299, 1; 
END
GO

GRANT EXECUTE ON [ENDO].[GetDiabetesType1AndAddison] TO [FastTrak]
GO