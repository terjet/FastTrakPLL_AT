SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [eResept].[GetLastFMUpdateForPatient]( @PersonId INT ) RETURNS DATETIME AS
BEGIN
  RETURN ( SELECT p.FMLastUpdate FROM dbo.Person p  WHERE p.PersonId = @PersonId );
END
GO

GRANT EXECUTE ON [eResept].[GetLastFMUpdateForPatient] TO [FastTrak]
GO