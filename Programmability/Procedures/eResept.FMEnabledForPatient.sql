SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[FMEnabledForPatient] (@PersonId INT) AS
BEGIN
  DECLARE @Result BIT = 0;
  IF EXISTS (SELECT *
      FROM dbo.Person
      WHERE PersonId = @PersonId
      AND FMEnabled = 1)
    SET @Result = 1;

  SELECT @Result AS Result
END
GO

GRANT EXECUTE ON [eResept].[FMEnabledForPatient] TO [FastTrak]
GO