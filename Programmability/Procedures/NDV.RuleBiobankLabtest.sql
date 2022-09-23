SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[RuleBiobankLabtest]( @StudyId INT, @PersonId INT ) AS
BEGIN
  DECLARE @AlertLevel INT = 0;
  DECLARE @AlertFacet VARCHAR(16) = 'Undefined';

  IF dbo.GetLastEnumVal( @PersonId, 'NDV_CONSENT_BIOBANK' ) = 1
  BEGIN 
    IF EXISTS 
      ( 
        SELECT 1 FROM dbo.LabData ld 
        JOIN dbo.LabCode lc ON lc.LabCodeId = Ld.LabCodeId
        WHERE ld.PersonId = @PersonId AND lc.LabClassId = 1084
      )
    BEGIN
      SET @AlertLevel = 1;
      SET @AlertFacet = 'DataFound';
    END
    ELSE
    BEGIN
      SET @AlertLevel = 3;
      SET @AlertFacet = 'DataMissing';
    END
  END
  ELSE
  BEGIN
    SET @AlertFacet = 'Exclude';
  END;
  IF NOT DEFAULT_DOMAIN() IN ('DIPS-AD', 'HS' ) SET @AlertLevel = 0;
  EXEC dbo.AddAlertForDSSRule @StudyId, @PersonId, @AlertLevel, 'NDVBIOLAB', @AlertFacet;
END
GO

GRANT EXECUTE ON [NDV].[RuleBiobankLabtest] TO [FastTrak]
GO