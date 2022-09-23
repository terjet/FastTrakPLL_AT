SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RuleNutritionAction]( @StudyId INT, @PersonId INT ) AS
BEGIN
  DECLARE @LastTiltakDate DateTime;
  DECLARE @LastInnkomstDate DateTime;
  DECLARE @KostLege INT;  
  DECLARE @AlertFacet varchar(16);
  DECLARE @AlertHdr VARCHAR(64);
  DECLARE @AlertMsg VARCHAR(512);
  DECLARE @AlertLevel INT;
  DECLARE @LastInnkomstDateStr VARCHAR(24);
  DECLARE @LastTiltakDateStr VARCHAR(24);     
  
  -- Finn eksisterende signert kostsamtale-skjema
  SET @LastInnkomstDate = dbo.GetLastSignedForm( @StudyId,@PersonId,'SAMTALE_KOST' );
  SET @LastInnkomstDateStr = CONVERT(VARCHAR,@LastInnkomstDate,104);
  SET @KostLege = ISNULL( dbo.GetLastEnumVal( @PersonId, 'KOST_Lege' ), 1 );
  IF ( @LastInnkomstDate IS NULL ) OR ( @KostLege = -1 )
  BEGIN          
    -- Finnes ikke noen signert eller skikkelig utfylt kostsamtale, varsling gult nivå, ekskluder for tiltak. 
    EXEC dbo.AddAlertForDSSRule @StudyId, @PersonId, 2, 'KostSamtale', 'DataMissing';
    EXEC dbo.AddAlertForDSSRule @StudyId, @PersonId, 0, 'KostTiltak', 'Exclude';
  END
  ELSE 
  BEGIN                      
    -- Kostsamtale er funnet, legg til i Alert på debug nivå 
    EXEC dbo.GetAlertText 'KostSamtale', 'DataFound', @AlertHdr OUT, @AlertMsg OUT; 
    SET @AlertMsg = REPLACE( @AlertMsg,'@LastInnkomstDate', @LastInnkomstDateStr );
    EXEC dbo.AddAlertForPerson @StudyId, @PersonId, 0, 'KostSamtale', 'DataFound', @AlertHdr,@AlertMsg;
    -- Nødvendig med tilsyn av lege?
    IF @KostLege = 1
    BEGIN
      -- Det skal være et signert skjema med ernæringstiltak her!
      SELECT @LastTiltakDate = dbo.GetLastSignedForm( @StudyId,@PersonId,'GbdErnaeringTiltak' );
      SET @LastTiltakDateStr = CONVERT(VARCHAR,@LastTiltakDate,104);
      IF ( @LastTiltakDate IS NULL )  
      BEGIN       
        -- Det finnes ikke noe tiltaksskjema i det hele tatt
        SET @LastTiltakDateStr = '';
        SET @AlertLevel = 3;
        SET @AlertFacet = 'DataMissing';
      END                            
      ELSE IF ( @LastTiltakDate < @LastInnkomstDate - 2 )
      BEGIN        
        -- Tiltaksskjema er mye eldre enn innkomstskjema
        SET @AlertLevel = 2;
        SET @AlertFacet = 'DataOld';
      END
      ELSE
      BEGIN
        -- Tiltaksskjema er oppdatert, alt vel.
        SET @AlertLevel = 0;
        SET @AlertFacet = 'DataFound';
      END  
    END
    ELSE
    BEGIN          
      -- Ikke nødvendig med tiltak
      SET @AlertLevel = 0;
      SET @AlertFacet = 'Exclude';
    END;
    EXEC dbo.GetAlertText 'KostTiltak', @AlertFacet, @AlertHdr OUT, @AlertMsg OUT;
    IF NOT @LastTiltakDateStr IS NULL SET @AlertMsg = REPLACE( @AlertMsg,'@LastTiltakDate', @LastTiltakDateStr );
    IF NOT @LastInnkomstDateStr IS NULL SET @AlertMsg = REPLACE( @AlertMsg,'@LastInnkomstDate', @LastInnkomstDateStr );
    EXEC dbo.AddAlertForPerson @StudyId,@PersonId,@AlertLevel,'KostTiltak',@AlertFacet,@AlertHdr,@AlertMsg;
  END;
END;
GO

GRANT EXECUTE ON [GBD].[RuleNutritionAction] TO [FastTrak]
GO