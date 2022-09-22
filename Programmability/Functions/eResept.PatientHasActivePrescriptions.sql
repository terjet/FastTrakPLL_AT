SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [eResept].[PatientHasActivePrescriptions]( @PersonId INT ) RETURNS BIT AS
BEGIN
  DECLARE @Result BIT = 0;
  IF EXISTS (SELECT *
      FROM dbo.DrugTreatment dt
      WHERE dt.StopAt IS NULL
      AND dt.FMLibId IS NULL
      AND dt.PersonId = @PersonId)
    SET @Result = 1;
  RETURN @Result;
END
GO

GRANT EXECUTE ON [eResept].[PatientHasActivePrescriptions] TO [FastTrak]
GO