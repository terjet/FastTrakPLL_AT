SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetHypoParaAutosomal]( @StudyId INT ) AS 
BEGIN 
  EXEC dbo.GetActiveSingleVar @StudyId, 6884, 1; 
END
GO

GRANT EXECUTE ON [ENDO].[GetHypoParaAutosomal] TO [FastTrak]
GO