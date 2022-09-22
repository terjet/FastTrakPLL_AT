SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[RuleTSH]( @StudyId INT, @PersonId INT ) AS
BEGIN
  DECLARE @LabName VARCHAR(40);
  DECLARE @LabVal FLOAT;     
  DECLARE @LabDate DateTime;
  DECLARE @AlertFacet VARCHAR(16);
  DECLARE @AlertLevel INT; 
  IF dbo.GetLastQuantity( @PersonId, 'NDV_TYPE' ) <> 1
  BEGIN
    SET @AlertFacet = 'Exclude';
    SET @AlertLevel = 0; 
  END
  ELSE BEGIN                                                         
    SELECT TOP 1 @LabName=lc.LabName,@LabDate=ld.LabDate,@LabVal=ld.NumResult
    FROM dbo.LabData ld JOIN LabCode lc ON lc.LabCodeId=ld.LabCodeId 
    WHERE ( ld.PersonId=@PersonId ) AND ( ld.NumResult > 0 ) AND ( lc.VarName='S_TSH' )
    ORDER BY ld.LabDate DESC;   
    IF @LabDate IS NULL
    BEGIN
      SET @AlertFacet = 'DataMissing';
      SET @AlertLevel = 2;
    END
    ELSE IF @LabDate < getdate()-730
    BEGIN
      SET @AlertFacet = 'DataOld';
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
  SET @AlertHeader = dbo.GetTextItem( 'NDV.RuleTSH', @AlertFacet +'.Header' );
  SET @AlertMessage = dbo.GetTextItem( 'NDV.RuleTSH', @AlertFacet );
  IF NOT @LabDate IS NULL                        
  BEGIN
    SET @AlertMessage = REPLACE( @AlertMessage, '@LabDate', dbo.LongTime( @LabDate ) );
    SET @AlertMessage = REPLACE( @AlertMessage, '@LabValue', CONVERT(VARCHAR,@LabVal) );
    SET @AlertMessage = REPLACE( @AlertMessage, '@LabName', @LabName );
  END
  EXEC AddAlertForPerson @StudyId,@PersonId,@AlertLevel,'NDVTSH',@AlertFacet,@AlertHeader,
      @AlertMessage;    
END
GO

GRANT EXECUTE ON [NDV].[RuleTSH] TO [FastTrak]
GO