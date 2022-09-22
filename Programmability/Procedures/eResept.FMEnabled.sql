SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[FMEnabled] AS
BEGIN
  -- Return 0/1 for overall status for FM use in this database.
  SELECT ISNULL(1,0) AS Result FROM Config.Setting s 
  WHERE s.Section = 'FM' AND s.KeyName = 'Enabled' AND s.UserId IS NULL AND s.BitValue = 1;
END
GO

GRANT EXECUTE ON [eResept].[FMEnabled] TO [FastTrak]
GO