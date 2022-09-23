SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListAvvikOpenThisTertial]( @StudyId INT ) AS
BEGIN
  DECLARE @StartAt DateTime;
  DECLARE @StopAt DateTime; 
  DECLARE @KeyDate DateTime;
  SET @KeyDate = GETDATE();
  EXEC dbo.CalculateTertial @KeyDate, @StartAt OUTPUT, @StopAt OUTPUT;
  EXEC GBD.GetCaseListAvvikOpen @StudyId, @StartAt, @StopAt; 
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListAvvikOpenThisTertial] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[GetCaseListAvvikOpenThisTertial] TO [Lege]
GO