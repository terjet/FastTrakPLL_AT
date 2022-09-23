SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetHypoThyroAutoimmune]( @StudyId INT ) AS 
BEGIN 
  EXEC dbo.GetActiveSingleVar @StudyId, 6312, 1; 
END
GO

GRANT EXECUTE ON [ENDO].[GetHypoThyroAutoimmune] TO [FastTrak]
GO