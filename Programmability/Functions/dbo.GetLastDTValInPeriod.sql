SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastDTValInPeriod]( @PersonId INT, @ItemId INT, @StartAt DateTime, @StopAt DateTime ) RETURNS DateTime AS
BEGIN
 DECLARE @RetVal DateTime;
 SET @RetVal = ( SELECT TOP 1 cd.DTVal FROM dbo.ClinDataPoint cd
   JOIN dbo.ClinEvent ce ON ce.EventId=cd.EventId
   WHERE ( ce.PersonId=@PersonId ) AND ( cd.ItemId=@ItemId ) AND ( NOT DTVal IS NULL )
   AND ( ce.EventTime < @StopAt ) AND ( ce.EventTime >= @StartAt )
   ORDER BY ce.EventNum DESC );
   RETURN @RetVal;
END
GO

GRANT EXECUTE ON [dbo].[GetLastDTValInPeriod] TO [FastTrak]
GO