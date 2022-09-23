SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[RuleBiobank]( @StudyId INT, @PersonId INT ) AS
BEGIN
  DECLARE @AlertFacet VARCHAR(16);
  DECLARE @AlertLevel INT;
  DECLARE @NdvConsent INT;                                           
  DECLARE @StudyName VARCHAR(32);
  DECLARE @DiabetesType INT;      
  SELECT @StudyName = StudName FROM dbo.Study WHERE StudyId=@StudyId;
  SET @DiabetesType = ISNULL(dbo.GetLastEnumVal( @PersonId, 'NDV_TYPE' ), -1 );
  IF @StudyName = 'NDV' AND @DiabetesType=-1 SET @DiabetesType=0;    
  IF @DiabetesType = -1
  BEGIN
    SET @AlertFacet = 'Exclude';
    SET @AlertLevel = 0;
  END
  ELSE
  BEGIN
    SET @NdvConsent = dbo.GetLastEnumVal( @PersonId, 'NDV_CONSENT_BIOBANK' );
    IF @NdvConsent IN  (1,2,3) 
    BEGIN
      SET @AlertFacet = 'DataFound';
      SET @AlertLevel = 0;
    END
    ELSE 
    BEGIN
      SET @AlertFacet = 'DataMissing';
      SET @AlertLevel = 3; 
    END
  END;   
  IF NOT DEFAULT_DOMAIN() IN ('DIPS-AD', 'HS' ) SET @AlertLevel = 0;
  EXEC dbo.AddAlertForDSSRule @StudyId,@PersonId,@AlertLevel,'NDVBIOBANK',@AlertFacet;    
END
GO

GRANT EXECUTE ON [NDV].[RuleBiobank] TO [FastTrak]
GO