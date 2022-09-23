SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetHypoParaPostop]( @StudyId INT ) AS 
BEGIN 
  EXEC dbo.GetActiveSingleVar @StudyId, 6883, 1; 
END
GO

GRANT EXECUTE ON [ENDO].[GetHypoParaPostop] TO [FastTrak]
GO