SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetHypoParaDiGeorge]( @StudyId INT ) AS 
BEGIN 
  EXEC dbo.GetActiveSingleVar @StudyId, 6664, 1; 
END
GO

GRANT EXECUTE ON [ENDO].[GetHypoParaDiGeorge] TO [FastTrak]
GO