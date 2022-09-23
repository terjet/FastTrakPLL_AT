SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListAvvikMineLastTertial]( @StudyId INT ) AS
BEGIN
  DECLARE @StartAt DateTime;
  DECLARE @StopAt DateTime; 
  DECLARE @KeyDate DateTime;
  SET @KeyDate = DATEADD( MONTH, -4, GETDATE() );
  EXEC dbo.CalculateTertial @KeyDate, @StartAt OUTPUT, @StopAt OUTPUT;
  EXEC GBD.GetCaseListAvvikMine @StudyId, @StartAt, @StopAt; 
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListAvvikMineLastTertial] TO [FastTrak]
GO