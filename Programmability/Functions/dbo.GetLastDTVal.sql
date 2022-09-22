SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastDTVal]( @PersonId INT, @VarName VARCHAR(64) ) RETURNS DateTime
AS
BEGIN
 DECLARE @RetVal DateTime;
 SET @RetVal = ( SELECT TOP 1 cd.DTVal FROM dbo.ClinDatapoint cd 
   JOIN dbo.MetaItem mi ON mi.ItemId=cd.ItemId
   JOIN dbo.ClinEvent ce ON ce.EventId=cd.EventId 
   WHERE ( ce.PersonId=@PersonId ) AND ( mi.VarName=@VarName ) AND ( NOT cd.DTVal IS NULL) 
   ORDER BY ce.EventNum DESC );
 RETURN @RetVal;
END
GO

GRANT EXECUTE ON [dbo].[GetLastDTVal] TO [FastTrak]
GO