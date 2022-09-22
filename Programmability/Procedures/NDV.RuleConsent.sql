SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[RuleConsent]( @StudyId INT, @PersonId INT ) AS
BEGIN
  DECLARE @AlertFacet VARCHAR(16);
  DECLARE @AlertLevel INT;
  DECLARE @NdvConsent INT; 
  SET @NdvConsent = CONVERT( INT, dbo.GetLastQuantity( @PersonId, 'NDV_CONSENT' ) );
  IF @NdvConsent IN  (1,2) 
  BEGIN
    SET @AlertFacet = 'DataFound';
    SET @AlertLevel = 0;
  END
  ELSE 
  BEGIN
    SET @AlertFacet = 'DataMissing';
    SET @AlertLevel = 2; 
  END
  EXEC AddAlertForDSSRule @StudyId,@PersonId,@AlertLevel,'NDVCONSENT',@AlertFacet;    
END
GO

GRANT EXECUTE ON [NDV].[RuleConsent] TO [FastTrak]
GO