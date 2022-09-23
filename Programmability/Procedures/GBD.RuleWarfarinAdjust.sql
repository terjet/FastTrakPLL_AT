SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RuleWarfarinAdjust]( @StudyId INT, @PersonId INT )
AS
BEGIN
  DECLARE @AlertFacet varchar(16);
  DECLARE @AlertLevel INT;
  DECLARE @NewDosingDate DateTime;
  
  /* Check for Warfarin treatment */
  
  IF NOT EXISTS ( SELECT TreatId FROM dbo.OngoingTreatment WHERE PersonId=@PersonId AND ATC='B01AA03' ) BEGIN
    SET @AlertFacet='Exclude';
    SET @AlertLevel=0;
  END
  ELSE BEGIN      
  
    /* Find next Warfarin dosing date from form data */
    
    SELECT @NewDosingDate = dbo.GetLastDTVal( @PersonId,'WARFARIN_NEXT' );
    IF @NewDosingDate IS NULL BEGIN
      SET @AlertFacet = 'Exclude';
      SET @AlertLevel = 0;
    END
    ELSE IF @NewDosingDate<GetDate() BEGIN
      SET @AlertFacet = 'DataOld';
      SET @AlertLevel = 3;
    END
    ELSE BEGIN
      SET @AlertFacet = 'DataFound';
      SET @AlertLevel = 0;
    END
  END
  EXEC dbo.AddAlertForDSSRule @StudyId,@PersonId,@AlertLevel,'WARFADJ',@AlertFacet
END;
GO

GRANT EXECUTE ON [GBD].[RuleWarfarinAdjust] TO [FastTrak]
GO