SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastQuantityInThePast]( @PersonId INT, @ItemId INT, @StatusDate DateTime ) RETURNS DECIMAL(18,4) AS
BEGIN
 DECLARE @RetVal DECIMAL(18,4);
 DECLARE @EventNum INTEGER;
 SET @RetVal = ( SELECT TOP 1 cdp.Quantity FROM dbo.ClinDataPoint cdp
   JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId
   WHERE ( ce.PersonId = @PersonId ) AND (ce.EventTime <= @StatusDate ) AND ( cdp.ItemId=@ItemId ) AND ISNULL( cdp.Quantity, -1) >= 0
   ORDER BY ce.EventNum DESC );
 RETURN @RetVal;
END
GO