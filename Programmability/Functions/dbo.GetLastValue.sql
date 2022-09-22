SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastValue]( @PersonId INT, @VarName VARCHAR(64) ) RETURNS DECIMAL(18,4)
AS
BEGIN
  DECLARE @RetVal DECIMAL(18,4);
  SET @RetVal = ( SELECT TOP 1 a.Quantity FROM   
  (  
  SELECT ce.EventTime,cd.Quantity 
    FROM dbo.ClinEvent ce 
    JOIN dbo.ClinDatapoint cd ON cd.EventId=ce.EventId
    JOIN dbo.MetaItem mi ON mi.ItemId=cd.ItemId
    WHERE ( ce.PersonId=@PersonId ) AND ( mi.VarName=@VarName ) AND ( cd.Quantity >= 0 )
  UNION
    SELECT ld.LabDate,ld.NumResult 
    FROM dbo.LabData ld
    JOIN dbo.LabCode lc ON lc.LabCodeId=ld.LabCodeId
    WHERE ( ld.PersonId=@PersonId ) AND ( lc.VarName=@VarName ) AND ( ld.NumResult >= 0 ) 
  ) a ORDER BY a.EventTime DESC ); 
  RETURN @RetVal;
END
GO

GRANT EXECUTE ON [dbo].[GetLastValue] TO [FastTrak]
GO