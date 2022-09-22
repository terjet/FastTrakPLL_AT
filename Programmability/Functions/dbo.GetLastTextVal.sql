SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastTextVal]( @PersonId INT, @VarName VARCHAR(64) ) RETURNS VARCHAR(MAX)
AS
BEGIN
 DECLARE @RetVal VARCHAR(MAX);
 SET @RetVal = ( SELECT TOP 1 cd.TextVal FROM dbo.ClinDatapoint cd 
   JOIN dbo.MetaItem mi ON mi.ItemId=cd.ItemId
   JOIN dbo.ClinEvent ce ON ce.EventId=cd.EventId 
   WHERE ( ce.PersonId=@PersonId ) AND ( mi.VarName=@VarName ) AND DATALENGTH(cd.TextVal) > 0 
   ORDER BY ce.EventNum DESC );
 RETURN @RetVal;
END
GO