SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[RuleCarbCount]( @StudyId INT, @PersonId INT ) AS
BEGIN
  DECLARE @TrainDate DateTime;
  DECLARE @AlertFacet VARCHAR(16);
  DECLARE @AlertLevel INT; 
  IF dbo.GetLastQuantity( @PersonId, 'NDV_TYPE' ) <> 1
  BEGIN
    SET @AlertFacet = 'Exclude';
    SET @AlertLevel = 0; 
  END
  ELSE BEGIN                                                         
    SELECT TOP 1 @TrainDate=DTVal FROM ClinObservation co
    JOIN ClinEvent ce ON co.EventId=ce.EventId 
    WHERE ( ce.StudyId=@StudyId ) AND ( ce.PersonId=@PersonId ) AND ( co.VarName='DIAPOL_TRAIN_CARBCOUNT' )
    ORDER BY DTVal DESC;   
    IF @TrainDate IS NULL
    BEGIN
      SET @AlertFacet = 'DataMissing';
      SET @AlertLevel = 2;
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
  BEGIN
    SET @AlertMessage = REPLACE( @AlertMessage, '@TrainDate', dbo.LongTime( @TrainDate ) );
  END
  EXEC AddAlertForPerson @StudyId,@PersonId,@AlertLevel,'CARBCOUNT',@AlertFacet,@AlertHeader,
      @AlertMessage;    
END
GO