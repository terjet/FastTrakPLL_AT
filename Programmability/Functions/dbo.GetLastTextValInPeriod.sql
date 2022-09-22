SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastTextValInPeriod]( @PersonId INT, @ItemId INT, @StartAt DateTime, @StopAt DateTime ) RETURNS VARCHAR(64) AS
BEGIN
 DECLARE @RetVal VARCHAR(64);
 SET @RetVal = ( SELECT TOP 1 cd.TextVal FROM dbo.ClinDataPoint cd
   JOIN dbo.ClinEvent ce ON ce.EventId=cd.EventId
   WHERE ( ce.PersonId=@PersonId ) AND ( cd.ItemId=@ItemId ) AND ISNULL(cd.TextVal,'') <> ''
   AND ( ce.EventTime < @StopAt ) AND ( ce.EventTime >= @StartAt )
   ORDER BY ce.EventNum DESC );
   RETURN @RetVal;
END
GO

GRANT EXECUTE ON [dbo].[GetLastTextValInPeriod] TO [FastTrak]
GO