SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[RuleEyeCheck]( @StudyId INT, @PersonId INT ) AS
BEGIN

  SET LANGUAGE Norwegian;

  DECLARE @EyeCheckDate DateTime;
  DECLARE @AlertFacet VARCHAR(16);
  DECLARE @AlertLevel INT;
  DECLARE @DiabetesType INT;
  DECLARE @DiabetesDebut FLOAT;
  DECLARE @ThisYear FLOAT;
  DECLARE @RuleIsRelevant BIT;
  
  SET @ThisYear = DATEPART( yy, GETDATE() );
  
  SELECT @DiabetesType = dbo.GetLastEnumVal( @PersonId, 'NDV_TYPE' );
  SELECT @DiabetesDebut = dbo.GetLastQuantityInThePast( @PersonId, 3486, GETDATE() );
    
  SET @RuleIsRelevant = 0;
  IF ( @DiabetesType = 1 ) AND ( @ThisYear - ISNULL(@DiabetesDebut,1900) > 5 )
    SET @RuleIsRelevant = 1;
  IF ( ISNULL(@DiabetesType,-1)  IN  (2,3,4) ) 
    SET @RuleIsRelevant = 1;
  IF @RuleIsRelevant = 0 BEGIN
    SET @AlertFacet = 'Exclude';
    SET @AlertLevel = 0;
  END
  ELSE
  BEGIN       
    SELECT @EyeCheckDate = dbo.GetLastDTVal( @PersonId, 'NDV_EYECHECK_DATE' );
    IF @EyeCheckDate IS NULL 
    BEGIN
      SET @AlertFacet = 'DataMissing';
      SET @AlertLevel = 3;
    END
    ELSE IF @EyeCheckDate < getdate()-730 
    BEGIN
      SET @AlertFacet = 'DataOld';
      SET @AlertLevel = 2;
    END
    ELSE BEGIN
      SET @AlertFacet = 'DataFound';
      SET @AlertLevel = 0;
    END 
  END
  DECLARE @AlertHeader VARCHAR(64);
  DECLARE @AlertMessage VARCHAR(512);     
  SET @AlertHeader = dbo.GetTextItem( 'NDV.RuleEyeCheck', @AlertFacet +'.Header' );
  SET @AlertMessage = dbo.GetTextItem( 'NDV.RuleEyeCheck', @AlertFacet );
  IF NOT @EyeCheckDate IS NULL
    SET @AlertMessage = REPLACE( @AlertMessage, '@EyeCheckDate', dbo.MonthYear( @EyeCheckDate ) );
  EXEC dbo.AddAlertForPerson @StudyId,@PersonId,@AlertLevel,'NDVEYE',@AlertFacet,@AlertHeader, @AlertMessage;    
END
GO

GRANT EXECUTE ON [NDV].[RuleEyeCheck] TO [FastTrak]
GO