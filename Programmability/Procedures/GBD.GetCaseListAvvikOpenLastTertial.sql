SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListAvvikOpenLastTertial]( @StudyId INT ) AS
BEGIN
  DECLARE @StartAt DateTime;
  DECLARE @StopAt DateTime; 
  DECLARE @KeyDate DateTime;
  SET @KeyDate = DATEADD( MONTH, -4, GETDATE() );
  EXEC dbo.CalculateTertial @KeyDate, @StartAt OUTPUT, @StopAt OUTPUT;
  EXEC GBD.GetCaseListAvvikOpen @StudyId, @StartAt, @StopAt; 
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListAvvikOpenLastTertial] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[GetCaseListAvvikOpenLastTertial] TO [Lege]
GO