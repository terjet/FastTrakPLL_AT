SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetLongDuration20]( @StudyId INT ) AS
BEGIN
  EXEC NDV.GetLongDuration @StudyId,20                
END
GO

GRANT EXECUTE ON [NDV].[GetLongDuration20] TO [FastTrak]
GO