SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetFirstEnumValuesTable]( @ItemId INT ) 
RETURNS @FirstEnumVals TABLE (  
     PersonId INT NOT NULL, 
     EnumVal INT NOT NULL, 
     ShortCode VARCHAR(5), 
     OptionText VARCHAR(MAX) ) 
AS
BEGIN
    INSERT @FirstEnumVals
    SELECT a.PersonId, a.EnumVal, mia.ShortCode, mia.OptionText
    FROM   (
             SELECT ce.PersonId,cdp.EnumVal,
               RANK() OVER ( PARTITION BY ce.PersonId ORDER BY ce.EventTime ) AS OrderNo
             FROM   dbo.ClinEvent ce
             JOIN   dbo.ClinDataPoint cdp ON cdp.EventId = ce.EventId
             WHERE  cdp.ItemId = @ItemId AND cdp.EnumVal >= 0 ) a
    JOIN   dbo.MetaItemAnswer mia ON mia.ItemId=@ItemId AND mia.OrderNumber = a.EnumVal
    WHERE  a.OrderNo = 1;
	RETURN;
END
GO