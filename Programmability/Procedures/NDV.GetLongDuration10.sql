SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetLongDuration10]( @StudyId INT ) AS
BEGIN
  EXEC NDV.GetLongDuration @StudyId,10                
END
GO

GRANT EXECUTE ON [NDV].[GetLongDuration10] TO [FastTrak]
GO