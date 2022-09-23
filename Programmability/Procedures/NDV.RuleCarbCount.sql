SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[RuleCarbCount]( @StudyId INT, @PersonId INT ) AS
BEGIN
  DECLARE @TrainDate DateTime;
  DECLARE @AlertFacet VARCHAR(16);
  DECLARE @AlertLevel INT;                      
         
  -- Make sure we have a Type-1 diabetes patient
  
  IF ISNULL(dbo.GetLastEnumVal( @PersonId, 'NDV_TYPE' ),-1) <> 1
  BEGIN
    -- Not relevant for patients without Type-1 diabetes                                                
    SET @AlertFacet = 'Exclude';
    SET @AlertLevel = 0; 
  END
  ELSE 
  BEGIN
    -- Find date where Carbohydrate counting was taught                                               
    SELECT TOP 1 @TrainDate = DTVal 
    FROM dbo.ClinDataPoint cdp
    JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId 
    WHERE ( ce.PersonId = @PersonId ) AND ( cdp.ItemId = 5713 )
    ORDER BY DTVal DESC;   
    IF @TrainDate IS NULL
    BEGIN
      SET @AlertFacet = 'DataMissing';
      SET @AlertLevel = 1;
    END
    ELSE
    BEGIN
      SET @AlertFacet = 'DataFound';
      SET @AlertLevel = 0;
    END
  END; 
  DECLARE @AlertHeader VARCHAR(64);
  DECLARE @AlertMessage VARCHAR(512);     
  SET @AlertHeader = dbo.GetTextItem( 'NDV.RuleCarbCount', @AlertFacet +'.Header' );
  SET @AlertMessage = dbo.GetTextItem( 'NDV.RuleCarbCount', @AlertFacet );
  IF NOT @TrainDate IS NULL                        
    SET @AlertMessage = REPLACE( @AlertMessage, '@TrainDate', dbo.LongTime( @TrainDate ) );
  EXEC dbo.AddAlertForPerson @StudyId, @PersonId, @AlertLevel,'CARBCOUNT', @AlertFacet, @AlertHeader, @AlertMessage;    
END
GO

GRANT EXECUTE ON [NDV].[RuleCarbCount] TO [FastTrak]
GO