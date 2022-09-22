SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastEnumValInPeriod]( @PersonId INT, @ItemId INT, @StartAt DateTime, @StopAt DateTime ) RETURNS INT AS
BEGIN
 DECLARE @RetVal INT;
 SET @RetVal = ( SELECT TOP 1 cd.EnumVal FROM dbo.ClinDataPoint cd
   JOIN dbo.ClinEvent ce ON ce.EventId=cd.EventId
   WHERE ( ce.PersonId=@PersonId ) AND ( cd.ItemId=@ItemId ) AND ISNULL(cd.EnumVal,-1) <> -1
   AND ( ce.EventTime < @StopAt ) AND ( ce.EventTime >= @StartAt )
   ORDER BY ce.EventNum DESC );
   RETURN @RetVal;
END
GO