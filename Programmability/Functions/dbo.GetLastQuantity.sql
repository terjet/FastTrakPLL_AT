SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastQuantity]( @PersonId INT, @VarName VARCHAR(64) ) RETURNS DECIMAL(18,4)
AS
BEGIN
 DECLARE @RetVal DECIMAL(18,4);
 SET @RetVal = ( SELECT TOP 1 cd.Quantity FROM dbo.ClinDatapoint cd 
   JOIN dbo.MetaItem mi ON mi.ItemId=cd.ItemId
   JOIN dbo.ClinEvent ce ON ce.EventId=cd.EventId 
   WHERE ( ce.PersonId=@PersonId ) AND ( mi.VarName=@VarName ) AND ISNULL(cd.Quantity,-1)>=0 
   ORDER BY ce.EventNum DESC );
 RETURN @RetVal;
END
GO