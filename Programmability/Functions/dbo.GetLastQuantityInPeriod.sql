SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastQuantityInPeriod]( @PersonId INT, @ItemId INT, @StartAt DateTime, @StopAt DateTime ) RETURNS DECIMAL(18,4) AS
BEGIN
 DECLARE @RetVal DECIMAL(18,4);
 SET @RetVal = ( SELECT TOP 1 cd.Quantity FROM dbo.ClinDataPoint cd
   JOIN dbo.ClinEvent ce ON ce.EventId=cd.EventId
   WHERE ( ce.PersonId=@PersonId ) AND ( cd.ItemId=@ItemId ) AND ( NOT cd.Quantity IS NULL )
   AND ( ce.EventTime < @StopAt ) AND ( ce.EventTime >= @StartAt )
   ORDER BY ce.EventNum DESC );
   RETURN @RetVal;
END
GO

GRANT EXECUTE ON [dbo].[GetLastQuantityInPeriod] TO [FastTrak]
GO