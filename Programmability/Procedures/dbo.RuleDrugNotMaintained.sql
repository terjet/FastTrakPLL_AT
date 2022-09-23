SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[RuleDrugNotMaintained]( @StudyId INT, @PersonId INT ) AS
BEGIN

  DECLARE @NotMaintained VARCHAR(MAX);
  DECLARE @AlertMsg VARCHAR(512);
  DECLARE @AlertFacet VARCHAR(16);
  DECLARE @AlertLevel INT;
  
  SELECT @NotMaintained = COALESCE(@NotMaintained + ', ' + DrugName, DrugName )  
    FROM dbo.DrugTreatment dt
    JOIN dbo.KBAtcIndex k ON k.AtcCode = dt.ATC
    WHERE dt.PersonId = @PersonId AND k.AtcMaintained = 0 AND ( dt.StopAt IS NULL OR  dt.StopAt > GETDATE() );
    
  IF @NotMaintained IS NULL
  BEGIN
    SET @AlertLevel = 0;
    SET @AlertFacet = 'DataFound';
    SET @AlertMsg =  'Pasientens medikamentliste inneholder ingen ATC-koder markert som ikke-vedlikeholdt i FEST med tanke på interaksjoner.';
  END
  ELSE
  BEGIN
    SET @AlertLevel = 4;
    SET @AlertFacet = 'DataMissing';
    SET @AlertMsg =  CONCAT( 'Interaksjoner på visse preparater (', @NotMaintained, ') kan mangle, disse vedlikeholdes ikke av FEST-redaksjonen i Legemiddelverket.' );
  END;
  
  EXEC dbo.AddAlertForPerson @StudyId, @PersonId, @AlertLevel, 'FESTIKKE', @AlertFacet, 'Interaksjonsdata', @AlertMsg;
  
END
GO

GRANT EXECUTE ON [dbo].[RuleDrugNotMaintained] TO [FastTrak]
GO