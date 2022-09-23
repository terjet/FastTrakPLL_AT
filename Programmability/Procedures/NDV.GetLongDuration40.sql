SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetLongDuration40]( @StudyId INT ) AS
BEGIN
  EXEC NDV.GetLongDuration @StudyId,40                
END
GO

GRANT EXECUTE ON [NDV].[GetLongDuration40] TO [FastTrak]
GO