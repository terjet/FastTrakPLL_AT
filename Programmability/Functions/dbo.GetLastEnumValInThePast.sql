﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastEnumValInThePast]( @PersonId INT, @VarName VARCHAR(64), @Cutoff DateTime ) RETURNS INT
AS
BEGIN
 DECLARE @RetVal INT;
 SET @RetVal = ( SELECT TOP 1 cd.EnumVal FROM dbo.ClinDatapoint cd
   JOIN dbo.MetaItem mi ON mi.ItemId=cd.ItemId
   JOIN dbo.ClinEvent ce ON ce.EventId=cd.EventId
   WHERE ( ce.PersonId=@PersonId ) AND ( mi.VarName=@VarName ) AND ISNULL(cd.EnumVal,-1) >= 0
   AND ( ce.EventTime < @Cutoff )
   ORDER BY ce.EventNum DESC );
   RETURN @RetVal;
END
GO

GRANT EXECUTE ON [dbo].[GetLastEnumValInThePast] TO [FastTrak]
GO