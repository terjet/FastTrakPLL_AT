SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetHyperThyroAutoimmune]( @StudyId INT ) AS 
BEGIN 
  EXEC dbo.GetActiveSingleVar @StudyId, 6313, 1; 
END
GO

GRANT EXECUTE ON [ENDO].[GetHyperThyroAutoimmune] TO [FastTrak]
GO