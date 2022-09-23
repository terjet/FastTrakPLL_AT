SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetGravideType5]( @StudyId INT ) AS
BEGIN         
  EXEC NDV.GetPregnantByType @StudyId, 5;
END
GO

GRANT EXECUTE ON [NDV].[GetGravideType5] TO [FastTrak]
GO