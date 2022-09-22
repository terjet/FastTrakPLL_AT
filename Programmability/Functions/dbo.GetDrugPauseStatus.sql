SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetDrugPauseStatus]( @TreatId INT, @PauseDate DateTime ) RETURNS INT
AS
BEGIN
  DECLARE @PauseStatus INT;
  SELECT @PauseStatus = COUNT(PauseId) FROM DrugPause 
  WHERE ( TreatId=@TreatId )
  AND ( PausedAt <= @PauseDate ) AND ( ISNULL(RestartAt,@PauseDate ) >= @PauseDate );
  IF @PauseStatus > 1 SET @PauseStatus = 1;
  RETURN @PauseStatus;
END
GO

GRANT EXECUTE ON [dbo].[GetDrugPauseStatus] TO [FastTrak]
GO