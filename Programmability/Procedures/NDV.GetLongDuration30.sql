SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetLongDuration30]( @StudyId INT ) AS
BEGIN
  EXEC NDV.GetLongDuration @StudyId,30                
END
GO

GRANT EXECUTE ON [NDV].[GetLongDuration30] TO [FastTrak]
GO