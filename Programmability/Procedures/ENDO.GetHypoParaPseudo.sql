SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetHypoParaPseudo]( @StudyId INT ) AS 
BEGIN 
  EXEC dbo.GetActiveSingleVar @StudyId, 6663, 1; 
END
GO

GRANT EXECUTE ON [ENDO].[GetHypoParaPseudo] TO [FastTrak]
GO