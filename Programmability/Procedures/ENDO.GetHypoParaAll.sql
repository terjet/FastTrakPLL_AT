﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetHypoParaAll]( @StudyId INT ) AS 
BEGIN 
  EXEC dbo.GetActiveSingleVar @StudyId, 6321, 1; 
END
GO

GRANT EXECUTE ON [ENDO].[GetHypoParaAll] TO [FastTrak]
GO