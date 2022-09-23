SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetHypoParaAutoImmune]( @StudyId INT ) AS 
BEGIN 
  EXEC dbo.GetActiveSingleVar @StudyId, 6663, 0; 
END
GO

GRANT EXECUTE ON [ENDO].[GetHypoParaAutoImmune] TO [FastTrak]
GO